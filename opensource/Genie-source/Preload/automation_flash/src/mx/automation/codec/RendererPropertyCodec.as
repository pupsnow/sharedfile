//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.codec
{ 
	
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.AutomationClass;
	import mx.automation.AutomationIDPart;
	import mx.automation.Genie.IGeniePropertyDescriptor;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	
	[ResourceBundle("automation_agent")]
	
	/**
	 *  Translates between internal Flex component and automation-friendly version
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class RendererPropertyCodec extends AutomationObjectPropertyCodec
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RendererPropertyCodec()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override public function encode(automationManager:IAutomationManager,
										obj:Object, 
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):Object
		{
			var val:Object = getMemberFromObject(automationManager, obj, pd);
			
			var delegate:IAutomationObject = val as IAutomationObject;
			/*if (delegate)
			{
				var part:AutomationIDPart = automationManager.createIDPart(delegate);
				val = part.automationName;
				var automationClass:IAutomationClass;
				if (relativeParent)
					automationClass = automationManager.automationEnvironment.getAutomationClassByInstance(relativeParent);
				if (automationClass)
				{
					var propertyNameMap:Object = automationClass.propertyNameMap;
					if (propertyNameMap["enableIndexBasedSelection"])
						val = part.automationIndex;
				}
			}*/
			
			if (!val && !(val is int))
				val = "";
			
			return val;
		}
		
		private function getLabelShowIndex(aoc:Object, text:String):String
		{
			var strToReturn:String = "";
			try
			{
				var arrMenus:Array = aoc.menuBarItems;
				for(var i:int = 0; i < arrMenus.length; i++)
				{
					if(text == arrMenus[i].menuBarItemIndex.toString())
					{
						for(var iChild:int = 0; iChild < arrMenus[i].numChildren; iChild++)
						{
							var argChild:* = arrMenus[i].getChildAt(iChild);
							if(getQualifiedClassName(argChild) == "mx.controls::Label")
							{
								strToReturn = argChild.text.toString();
								break;
							}
							else if(getQualifiedClassName(argChild).indexOf("UITextField") > -1)
							{
								strToReturn = argChild.text.toString();
								break;
							}
						}
					}
				}
			}
			catch(e:Error)
			{
				strToReturn = "";
			}
			return strToReturn;
		}
		
		private function getLabelItemIndex(aoc:Object, text:String):String
		{
			var strToReturn:String = "";
			var argChild:*;
			try
			{
				for(var i:int = 0; i < aoc.numChildren; i++)
				{
					argChild = aoc.getChildAt(i);
					if(getQualifiedClassName(argChild).indexOf("ListBaseContentHolder") > -1)
					{
						var arrItems:Object = argChild.listItems;
						for(var x:int = 0; x < arrItems.length; x++)
						{
							if(text == x.toString())
							{
								var objItem:Object = arrItems[x];
								try
								{
									strToReturn = objItem[0].listData.label.toString();
									break;
								}
								catch(e:Error)
								{
									for(var iChild:int = 0; iChild < objItem[0].numChildren; iChild++)
									{
										argChild = objItem[0].getChildAt(iChild);
										if(getQualifiedClassName(argChild) == "mx.controls::Label")
										{
											strToReturn = argChild.text.toString();
											break;
										}
										else if(getQualifiedClassName(argChild) == "mx.core::UITextField")
										{
											strToReturn = argChild.text.toString();
											break;
										}
									}
								}
							}
						}
						break;
					}
				}
			}
			catch(e:Error)
			{
				strToReturn = "";
			}
			return strToReturn;
		}
		
		private function getLabelFromIndex(obj:Object, text:String):String
		{
			var strToReturn:String = "";
			var argChild:*;
			try
			{
				for(var i:int = 0; i < obj.numChildren; i++)
				{
					argChild = obj.getChildAt(i);
					if(getQualifiedClassName(argChild).toLowerCase().indexOf("buttonbar") > -1)
					{
						if(text == i.toString())
						{
							if(argChild.label != null && argChild.label != "")
							{
								strToReturn = argChild.label.toString();
							}
							else
							{
								var objToggle:Object = argChild.owner;
								var delegate:Object = Automation.getDelegate(objToggle);
								var numAutoChildren:int = delegate.numGenieAutomationChildren()
								for(var x:int = 0; x < numAutoChildren; x++)
								{
									if(argChild == delegate.getGenieAutomationChildAt(x))
									{
										strToReturn = "index:"+x.toString();
										break;
									}
								}
							}
						}
					}
				}
			}
			catch(e:Error)
			{
				strToReturn = obj.label.toString();
			}
			return strToReturn;
		}
		
		/**
		 * @private
		 */
		override public function decode(automationManager:IAutomationManager,
										obj:Object, 
										value:Object,
										pd:IGeniePropertyDescriptor,
										relativeParent:Object):void
		{
			if ((!value) || value.length == 0)
			{
				obj[pd.name] = null;
			}
			else
			{
				var aoc:Object = (relativeParent != null ? relativeParent : obj as Object);
				
				var part:AutomationIDPart = new AutomationIDPart();
				// If we have any descriptive programming element
				// in the value string use that property.
				// If it is a normal string assume it to be automationName
				var text:String = String(value);
				var separatorPos:int = text.indexOf(":=");
				var items:Array = [];
				if(separatorPos != -1)
					items = text.split(":=");
				
				if(items.length == 2)
					part[items[0]] = items[1]; 
				else
					part.automationName = text;
				
				
				if(obj.type == "menuShowIndex")
				{
					part.automationName = getLabelShowIndex(aoc, text);
				}
				else if(obj.type == "itemClickIndex")
				{
					var automationClass:IAutomationClass;
					automationClass = IAutomationEnvironment(automationManager.automationEnvironment).getAutomationClassByInstance(aoc);
					if(automationClass.name.toLowerCase().indexOf("buttonbar") > -1 || automationClass.objExtendedClassName.toLowerCase().indexOf("buttonbar") > -1)
						part.automationName = getLabelFromIndex(aoc, text);
					else
						part.automationName = getLabelItemIndex(aoc, text);
				}
				var ao:Array = automationManager.resolveIDPart(aoc, part);
				var n:int = ao.length;
				var delegate:Object = (ao[0] as Object);
				if (delegate)
				{
					try
					{					
						obj[pd.name] = delegate;	
					}
					catch(e:Error)
					{
						obj[pd.name] = ao[0];
					}
				}
				else
					obj[pd.name] = ao[0];
				
				/*if (n > 1)
				{
					var message:String = resourceManager.getString(
						"automation_agent", "matchesMsg",[ ao.length,
							part.toString().replace(/\n/, ' ')]) + ":\n";
					
					for (var i:int = 0; i < n; i++)
					{
						message += AutomationClass.getClassName(ao[i]) + 
							"(" + ao[i].automationName + ")\n";
					}
					
					trace(message);
				}*/
				
				// we couldnot find the itemRenderer in the visible area
				// set itemString property if it is available so that the
				// delegate can handle this.
				if (n == 0)
				{
					if (obj.hasOwnProperty("itemAutomationValue"))
						obj["itemAutomationValue"] = text;
				}
			}
		}
	}
	
}
