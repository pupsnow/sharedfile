//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.genie
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	
	import mx.automation.Automation;
	import mx.automation.AutomationClass;
	import mx.automation.Genie.GeniePropertyDescriptor;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationClass2;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationEventDescriptor;
	import mx.automation.IAutomationMethodDescriptor;
	import mx.core.Application;
	
	public class GenieEnvironment implements IAutomationEnvironment
	{
		public function GenieEnvironment(source:XML)
		{
			super();
			
			// Parse the XML, and populate the objects
			//var parser:EnvXMLParser = new EnvXMLParser();
			//var outputXML:XML = parser.parse(source);
			
			defineEnums(source);
			
			fillObjects(source);
			
			//Set the raw_environemnt
			raw_environment = source;
		}
		
		public function addCustom(source:XML):void
		{
			fillObjects(source);
			raw_environment =combine(raw_environment, source);
		}
		
		private function defineEnums(source:XML):void {
			for(var i:Object in source.ListOfValues) {
				var enumList:XML = source.ListOfValues[i];
				var enumArr:Array = new Array();
				for(var j:int=0; j<enumList.EnumValue.length(); j++) {
					var value:XML = enumList.EnumValue[j];
					enumArr.push({label:value.@Label.toString(), name:value.@Name.toString(), value:Number(value.@RealValue)});
				}
				environmentEnums[enumList.@Name.toString()] = enumArr;
			}
		}
		
		private function fillObjects(source:XML):void {
			for (var i:Object in source.ClassInfo)
			{
				// populate the class/automationClass map
				var classInfoXML:XML = source.ClassInfo[i];
				var automationClassName:String = classInfoXML.@Name.toString();
				var superClassName:String = 
					classInfoXML.@Extends && classInfoXML.@Extends.length != 0 ?
					classInfoXML.@Extends.toString() :
					null;
				var automationClass:AutomationClass =	new AutomationClass(automationClassName, superClassName);
				automationClassName2automationClass[automationClassName] =	automationClass;
				
				for (var j:Object in classInfoXML.Implementation)
				{
					var implementationXML:XML = classInfoXML.Implementation[j];
					var realClassName:String =
						implementationXML.@Class.toString().replace("::", ".");
					
					var versionObj:Object = implementationXML.@Version;
					var versionNum:String = versionObj.toString();
					if(versionNum!= "")
					{
						realClassName = realClassName+"_"+versionNum;
						automationClass.implementationVersion = int(versionNum);
					}
					else
					{
						automationClass.implementationVersion = 0;
					}
					automationClass.objExtendedClassName = implementationXML.@Class.toString();
					className2automationClass[realClassName] = automationClass;
					automationClass.addImplementationClassName(realClassName);
					
					var compatibleClassNames:String = (implementationXML.@PreviousVersionClassNames).toString();
					if(compatibleClassNames!= ""){
						var classNames:Array /*of String*/ = compatibleClassNames.split(",");
						automationClass.previousVersionClassNames = classNames;
					}
				}
				
				// for each Method
				for (var k:Object in classInfoXML.TypeInfo.Operation)
				{
					var operationXML:XML = classInfoXML.TypeInfo.Operation[k];
					
					var automationMethodName:String = operationXML.@Name.toString();
					var eventClassName:String =
						operationXML.Implementation.@Class.toString();
					eventClassName = eventClassName.replace("::", ".");
					var eventType:String =
						operationXML.Implementation.@Type.toString();
					
					if (eventType)
					{
						var args:Array = [];
						for (var m:Object in operationXML.Argument)
						{
							var argXML:XML = operationXML.Argument[m];
							var argName:String = argXML.@Name.toString();
							var argType:String =
								argXML.Type.@VariantType.toString().toLowerCase();
							var argCodec:String = argXML.Type.@Codec.toString();
							var defaultValue:String = 
								argXML.@DefaultValue.length() > 0 ?
								argXML.@DefaultValue.toString() :
								null;
							var enums:Array = (argType.toLowerCase()=="enumeration")?environmentEnums[argXML.Type.@ListOfValuesName.toString()]:null;
							var argDesc:String = argXML.Description.toString();
							var pd:GeniePropertyDescriptor = new GeniePropertyDescriptor(
									argName, true, true, argType,
									(argCodec == null || argCodec.length == 0 ?
										"object" :
										argCodec), defaultValue, enums, argDesc);
							args.push(pd);
						}
						
						var returnType:GeniePropertyDescriptor = new GeniePropertyDescriptor("return",false,false,
							operationXML.ReturnValueType.Type.@VariantType.toString(),
							"",null,null,operationXML.ReturnValueType.Description.toString());
						
						var codecName:String =
							operationXML.ReturnValueType.Type.@Codec.toString();
						
						var eventUsed:Boolean = false;
							
						if(eventClassName)
						{
							var ed:IAutomationEventDescriptor = new GenieEventDescriptor(
								automationMethodName, eventClassName,
								eventType, args);
							automationClass.addEvent(ed);
							eventUsed = true;
						}
						else
						{
							var md:IAutomationMethodDescriptor = new GenieMethodDescriptor(
								automationMethodName, eventType, returnType,
								codecName, args);
							automationClass.addMethod(md);
						}
						
						if(automationClassName2automationEvents[automationClassName]==null)
							automationClassName2automationEvents[automationClassName] = new Array();
						if(eventUsed) {
							if(!checkExists(ed, automationClassName2automationEvents[automationClassName]))
								automationClassName2automationEvents[automationClassName].push(ed);
						} else {
							if(!checkExists(md, automationClassName2automationEvents[automationClassName]))
								automationClassName2automationEvents[automationClassName].push(md);
						}
					}
				}
				
				// for each Property
				for (var p:Object in classInfoXML.Properties.Property)
				{
					var propertyXML:XML = classInfoXML.Properties.Property[p];
					var propName:String = propertyXML.@Name.toString();
					var propType:String =
						propertyXML.Type.@VariantType.toString().toLowerCase();
					var propCodec:String = propertyXML.Type.@Codec.toString();
					var propDesc:String = propertyXML.Description.toString();
					var pd1:GeniePropertyDescriptor = 
						new GeniePropertyDescriptor(
							propName,
							propertyXML.@ForDescription.toString() == "true",
							propertyXML.@ForVerification.toString() == "true",
							propType,
							(propCodec == null || propCodec.length == 0 ?
								"object" :
								propCodec), propDesc);
					automationClass.addPropertyDescriptor(pd1);
				}
			}
		}
		
		private function combine(part1:XML, part2:XML):XML {
			var children:XMLList = part2.children();
			for(var i:int=0; i<children.length(); i++) {
				part1.appendChild(children[i]);
			}
			return part1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var raw_environment:XML;
		
		
		/**
		 *  @private
		 */
		private var className2automationClass:Object = {};
		
		/**
		 *  @private
		 */
		private var automationClassName2automationClass:Object = {};
		
		/**
		 *  @private
		 */
		private var automationClassName2automationEvents:Object = {};
		
		/**
		 * @private
		 */
		private var environmentEnums:Object = {};
		
		/**
		 *  @private
		 *  Used for accessing localized Error messages.
		 */
		//private var resourceManager:IResourceManager =	ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function checkExists(obj:Object, arr:Array):Boolean {
			for(var i:int=0; i<arr.length; i++) {
				if(arr[i].name==obj.name)
					return true;
			}
			return false;
		}
		
		/**
		 *  @private
		 */
		public function getAutomationClassByInstance(
			obj:Object):IAutomationClass
		{
			var result:IAutomationClass = findClosestAncestor(obj);
			if (! result)
			{
				//GenieLog.getInstance().traceLog(GenieLogConst.ERROR, "AutomationClass not found. In function getAutomationClassByInstance");
			}
			return result; 
		}
		
		/**
		 *  @private
		 */
		public function getAutomationClassByName(
			automationClass:String):IAutomationClass
		{
			var acToReturn:IAutomationClass;
			acToReturn = AutomationClass(automationClassName2automationClass[automationClass]);
			if(acToReturn)
				return acToReturn;
			else
			{
				for each(acToReturn in automationClassName2automationClass)
				{
					//trace(acToReturn.objExtendedClassName);
					if(acToReturn.objExtendedClassName == automationClass || acToReturn.name == "FlashDisplayObject")
						return acToReturn;
				}
			}
			return null;
			//return AutomationClass(automationClassName2automationClass[automationClass]);
		}
		
		public function getAutomationEventsByInstance(automationObj:Object):Array {
			return automationClassName2automationEvents[getAutomationClassByInstance(automationObj).name] as Array;
		}
		
		/**
		 *  Finds the closest ancestor to this object about which information was 
		 *  passed in the environment XML.
		 *  @private
		 */
		private function findClosestAncestor(obj:Object):IAutomationClass
		{   	
			//TODO: Commented out Parsec so this all would compile.
			//if(obj is CABID){
			//	obj = CABID(obj).cabObject;
			//}
			var className:String = AutomationClass.getClassName(obj);
			var version:int = int(className.substr(className.length-1));
			//if(!isNaN(int(className.charAt(className.length-1))*1))
			//	className = className.substring(0, className.length - 2);
			for(var i:int = version; i > 0; i--){
				var classNameWithVersion:String = className.concat('_').concat(i);
				if (classNameWithVersion in className2automationClass)
					return className2automationClass[classNameWithVersion];
			}
			
			if (className in className2automationClass)
				return className2automationClass[className];
			
			var ancestors:Array = findAllAncestors(obj);
			if (ancestors.length != 0)
			{
				className2automationClass[className] = getClosestVersionAncestor(ancestors);;
				return className2automationClass[className];
			}
			else
			{
				return null;
			}
		}
		
		/**
		 *  @private
		 */
		private function getClosestVersionAncestor(ancestors:Array):IAutomationClass
		{
			//There can be many ancestors of same class but with different versions
			//We need to find the ancestor which is closer in version to current version 
			
			var closeAncestors:Array = [];
			
			if(ancestors.length > 0)
			{
				closeAncestors.push(ancestors[0]);
				var n:int = ancestors.length;
				var isAncestor:Boolean = false;
				
				for( var i:int = 1; i < n; i++ )
				{
					var firstSuperClass:String = ancestors[0].superClassName;
					var secondAncestor:IAutomationClass = ancestors[i];
					
					while( firstSuperClass )
					{
						if( firstSuperClass == secondAncestor.name )
						{
							isAncestor = true;
							break;
						}
						else
						{
							var ItempClass:IAutomationClass = getAutomationClassByName(firstSuperClass);
							if(ItempClass)
								firstSuperClass = ItempClass.superClassName;
							else
								break;
						}
					}
					if( !isAncestor )
					{
						var temp:Array = [];
						temp.push(ancestors[i]);
						closeAncestors = temp.concat(closeAncestors);
					}
					else
					{
						break;
					}
				}
				
				var currentVersion:int = int(AutomationClass.getMajorVersion());
				var closestAncestor:IAutomationClass = closeAncestors[0];
				
				if(closeAncestors[0] is IAutomationClass2)
				{
					var currentAncestorVersion:int = IAutomationClass2(closeAncestors[0]).implementationVersion;
					n = closeAncestors.length;
					for (i = 1; i < n; i++)
					{
						var nextAncestorVersion:int = IAutomationClass2(closeAncestors[i]).implementationVersion;
						if(currentAncestorVersion > currentVersion)
							currentAncestorVersion = nextAncestorVersion; 
						if( nextAncestorVersion <= currentVersion && nextAncestorVersion >= currentAncestorVersion)
						{
							closestAncestor = closeAncestors[i];
							currentAncestorVersion = nextAncestorVersion;
						}
					}
				}
			}
			
			return closestAncestor;
		}
		
		/**
		 *  @private
		 */

		private function findAllAncestors(obj:Object):Array
		{
			var result:Array = [];
			var t1:Date = new Date();
			var strQualifiedName:String = getQualifiedClassName(obj);

			result = [];
			var appDomain:ApplicationDomain = null;
			appDomain = ApplicationDomain.currentDomain;
			if(strQualifiedName.indexOf("mx_managers_SystemManager") > -1)
				return result;
			
			var flexComponent:Class = null;
			try
			{
				flexComponent = obj.loaderInfo.applicationDomain.getDefinition("mx.core::UIComponent") as Class;
			}
			catch(e:Error)
			{
				flexComponent = null;
			}
			
			if(!flexComponent || !(obj is flexComponent))
			{
				var spriteClass:Class = appDomain.getDefinition("flash.display::Sprite") as Class;
				var movieClass:Class = appDomain.getDefinition("flash.display::MovieClip") as Class;
				
				if(obj is movieClass )
				{
					//do nothing
				}
				else 
					if(obj is spriteClass)
					{
						return result;
					}	
			}		
			var classInfo:XML = describeType(obj);
			var strBase:String = "";
			var strType:String = "";
			var bFlashClass:Boolean = false;
			var bVariable:Boolean = false;
			
			if(strQualifiedName == "flash.display::Stage")
			{
				try
				{
					if(obj.loaderInfo.content.hasOwnProperty("movie"))
						if(obj.loaderInfo.content.movie)
							Automation.bIsFlashApp = true;
				}
				catch(e:Error)
				{}
			}
			
			if(Automation.bIsFlashApp)
			{
				var attr:XMLList = classInfo.attributes();
				if(attr.length() > 1)
				{
					for(var c:int = 0; c < attr.length(); c++)
					{
						if(attr[c].name().localName.toString().toLowerCase() == "base")
						{
							strBase = attr[c].toString();
							break;
						}
					}
				}
				
				for each (var a:XML in classInfo..extendsClass) 
				{
					try
					{
						if(a.@type)
						{
							if(a.@type.toString().indexOf("fl.") > -1)
							{
								strType = a.@type.toString();
								if(strType == strBase)
								{
									bVariable = true;
									bFlashClass = true;
									break;
								}
								else
								{
									bFlashClass = false;
									break;
								}
							}
						}
					}
					catch(e:Error)
					{}
				}
				
				if(!bFlashClass)
				{
					for each (a in classInfo..variable) 
					{
						try
						{
							if(a.@type)
							{
								if(a.@type.toString().indexOf("::") > -1)
								{
									bVariable = true;
									strType = a.@type.toString();
									if(strType.indexOf("flash.") > -1)
									{
										if(strType == strBase)
										{
											bFlashClass = false;
											break;
										}
										else
										{
											bFlashClass = true;
											break;
										}
									}
								}
							}
						}
						catch(e:Error)
						{}
					}
				}
//				
				if(!bVariable)
				{
					if(attr.length() > 1)
					{
						for(c = 0; c < attr.length(); c++)
						{
							if(attr[c].name().localName.toString().toLowerCase() == "name")
							{
								bFlashClass = true;
								strType = attr[c].toString();
								break;
							}
						}
					}
				}
				
			}
			
			
			if(!bFlashClass)
			{
				var bRegisteredBeforeSprite:Boolean = true;
				for each (a in classInfo..extendsClass) 
				{
					var goAhead:Boolean = true;
					//if( (a.@type.indexOf("Sprite") > -1) || (a.@type.indexOf("flash") > -1) )
					
					
					//if(a.@type.indexOf("flash") > -1 && strQualifiedName != "flash.display::Sprite")
					if( (a.@type.indexOf("Sprite") > -1) || (a.@type.indexOf("flash") > -1) )
					{
						if((a.@type.indexOf("flash.display::MovieClip") > -1) 
							|| (a.@type.indexOf("mx.flash::FlexContentHolder") > -1)
							|| (a.@type.indexOf("mx.flash::ContainerMovieClip") > -1)
							|| (a.@type.indexOf("mx.flash::UIMovieClip") > -1)
							|| (a.@type.indexOf("flash.display::Sprite") > -1)
						)
						{
							goAhead = true;
						}
						else
							goAhead = false;
					}	
					
					if(goAhead)
					{	
						var clName:String = a.@type;
						var realClass:Class = AutomationClass.getDefinitionFromObjectDomain(obj, clName) as Class;
						var tmpAutomationClass:IAutomationClass = className2automationClass[clName.replace("::",".")];
						if(tmpAutomationClass)
						{
							if(!bRegisteredBeforeSprite || (bRegisteredBeforeSprite && clName != "flash.display::Sprite"))
							{
								if(clName.indexOf("mx.") > -1 || clName.indexOf("spark.") > -1 || clName.indexOf("flash.") > -1)
								{
									tmpAutomationClass.objExtendedClassName = clName;
									result.push(tmpAutomationClass);
									//break;
								}
							}
						}
					}
				}
			}
			else
			{
				clName = strType;
				realClass = AutomationClass.getDefinitionFromObjectDomain(obj, clName) as Class;
				tmpAutomationClass = className2automationClass[clName.replace("::",".")];
				if(tmpAutomationClass)
				{
					tmpAutomationClass.objExtendedClassName = clName;
					result.push(tmpAutomationClass);
				}
			}
			
			result.sort(sortAncestors);
			
			return result;
		}
		
		/**
		 *  @private
		 */
		private function sortAncestors(a:Object, b:Object):int
		{
			var superClass:IAutomationClass;
			var x:String = a.superClassName;
			while (x)
			{
				if (x == b.name)
					return -1;
				superClass = getAutomationClassByName(x);
				if(superClass)
					x = superClass.superClassName;
				else
					break;
			}
			
			x = b.superClassName;
			while (x)
			{
				if (x == a.name)
					return 1;
				superClass = getAutomationClassByName(x);
				if(superClass)
					x = superClass.superClassName;
				else
					break;
			}
			
			return 0;
		}
		
		public function toString():String {
			return raw_environment.toXMLString();
		}
	}
}