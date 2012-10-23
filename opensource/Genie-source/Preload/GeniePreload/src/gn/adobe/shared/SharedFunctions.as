//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.shared
{
	import flash.net.XMLSocket;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLDocument;
	
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	
	import mx.utils.XMLUtil;
	

	public class SharedFunctions
	{
		private static var objLogs:GenieLog = new GenieLog();
		private static var arrPropertyNames:Array = ["id","name","label","enabled","toolTip","numChildren","width","visible"
													,"parent","currentState","ClassName","height","mouseX","mouseY","text"];
		public function SharedFunctions()
		{

		}
		
		public static function getObjectName(child:Object):String
		{
			var strChildName:String = "";
			try
			{
				strChildName = child.id;	
			}
			catch(ex:Error)
			{
				strChildName = child.name;
			}
			if(strChildName == null)
			{
				strChildName = child.name;
			}

			return strChildName;
		}
		
		public static function getObjectProperty(object:Object, objXML:XML):XML
		{
			//var classInfo:XML = describeType(object);

			for(var i:int=0; i< arrPropertyNames.length; i++)
			{
				try
				{
					if(object.hasOwnProperty(arrPropertyNames[i]))
					{
						if( (arrPropertyNames[i] == "name") && (getQualifiedClassName(object).indexOf("flash.display::Stage") > -1))
						{
							objXML.@[arrPropertyNames[i]] = "Stage";
						}
						else
						{
							objXML.@[arrPropertyNames[i]] = object[arrPropertyNames[i]];
						}
					}
				}
				catch(e:Error)
				{
					objLogs.detailedTrace(GenieLogConst.ERROR, e.message);
				}
			}
			return objXML;
		}
		
		public static function getObjectFromClassName(clName:String, obj:Object):Object
		{
			var classInfo:XML = describeType(obj);
			var objToReturn:Object = null;
			for each (var a:XML in classInfo..variable) 
			{
					if(a.@type == clName)
					{
						objToReturn = obj[a.@name];
						break;
					}
			}
			return objToReturn;
		}
		
		public static function getStageDimensions(obj:Object):Array
		{
			var stageWidth:int = 0;
			var stageHeight:int = 0;
			var arrDimensions:Array = new Array();
			
			try
			{
				if(obj.hasOwnProperty("stageWidth") && 	obj.stageWidth > 0)
					stageWidth = obj.stageWidth;
				
				if(obj.hasOwnProperty("stageHeight") && obj.stageHeight > 0)
					stageHeight = obj.stageHeight;
				
				if(stageWidth > 0 && stageHeight > 0)
				{
					arrDimensions.push(stageWidth);
					arrDimensions.push(stageHeight);
				}
				else
				{
					if(obj.hasOwnProperty("stage") && obj.stage.hasOwnProperty("stageWidth") && obj.stage.stageWidth > 0)
						stageWidth = obj.stage.stageWidth;
					
					if(obj.hasOwnProperty("stage") && obj.stage.hasOwnProperty("stageHeight") && obj.stage.stageHeight > 0)
						stageHeight = obj.stage.stageHeight;
					
					arrDimensions.push(stageWidth);
					arrDimensions.push(stageHeight);
				}
			}
			catch(e:Error)
			{
				arrDimensions = new Array();
				
				//This is done because in some cases where movie clip loads the child, there stage is null
				//Also we do not require stage hwight and widht in that scenario.
				if(obj.hasOwnProperty("stage") && obj.stage)
				{
					if(obj.stage.hasOwnProperty("stageWidth") && obj.stage.stageWidth > 0)
						stageWidth = obj.stage.stageWidth;
					else
						stageWidth = 0;
					
					if(obj.stage.hasOwnProperty("stageHeight") && obj.stage.stageHeight > 0)
						stageHeight = obj.stage.stageHeight;
					else
						stageWidth = 0;
				}
				
				arrDimensions.push(stageWidth);
				arrDimensions.push(stageHeight);
			}
			
			return arrDimensions;
		}
		
		public static function getObjectClassName(obj:Object):String
		{
			var strObjClassName:String = "";
			if(getQualifiedClassName(obj) == "flash.display::Sprite")
				strObjClassName = "flash.display::Sprite";
			else if(getQualifiedClassName(obj) == "flash.display::Shape")
				strObjClassName = "flash.display::Shape";
			else if(getQualifiedClassName(obj) == "flash.display::MovieClip")
				strObjClassName = "flash.display::MovieClip";
			else
				strObjClassName = "com.adobe.genie::DisplayObject";
			
			return strObjClassName;
		}
		
		public static function validateXMLTag(strTagName:String):String
		{
			strTagName = strTagName.replace(/\./g, '_');
			strTagName = strTagName.replace(/:/g, '_');
			strTagName = strTagName.replace(/ /g, '_');
			strTagName = strTagName.replace(/\[/g, '_');
			strTagName = strTagName.replace(/]/g, '_');
			
			return strTagName
		}
		
		public static function getPropertyArray():Array
		{
			return arrPropertyNames;
		}
		
		/**
		 * returns integer number from version string e.g. 2.1.3 => 213
		 */
		private static function getVersionNumberFromString(v:String):int
		{
			var res:Array = v.split(".");
			
			var l:int = res.length;
			var pw:int = l-1;
			var s1:int = 0;
			try
			{
				for(var i:int=0; i < l; i++)
				{
					s1 += parseInt(res[i]) * Math.pow(100, pw);
					pw --;
				}
			}
			catch(e:Error)
			{}
			return s1;
		}
		
		/**
		 * checks whether version returned by Server is compatible or not
		 */
		public static function isServerVersionSupported(sVer:String, pVer:String):Boolean
		{
			var l1:int = sVer.split(".").length;
			var l2:int = pVer.split(".").length;
			
			while (l1 < l2)
			{
				sVer += ".0";
				l1 ++;
			}
			while (l2 < l1)
			{
				pVer += ".0";
				l2 ++;
			}
			
			var v1:int = getVersionNumberFromString(sVer);
			var v2:int = getVersionNumberFromString(pVer);
			
			if (v2 <= v1)
				return true;
			
			return false;
		}
		
		/**
		 * Disable Genie icons, and close the socket
		 */
		public static function disablePreloadActions(socket:XMLSocket, errorMsg:String):void
		{
			objLogs.traceLog(GenieLogConst.INFO, "Connection aborted! " + errorMsg);
			
			var genieDisplay:DisplayManager = GenieMix.getDisplay;
			genieDisplay.disableGenie();
			
			socket.close();
		}
		
		public static function KeyValidate(strArg:String):Boolean
		{
			var xmlArg:XMLDocument = XMLUtil.createXMLDocument(<Object>{strArg}</Object>);
			for(var i:int = 0; i < xmlArg.childNodes.length; i++)
			{
				if(xmlArg.childNodes[i].localName == "Arguments")
				{
					if(xmlArg.childNodes[i].childNodes.length == 1)
					{
						switch (xmlArg.childNodes[i].childNodes[0].childNodes[0].nodeValue.toString())
						{
							case "CONTROL":
							case "SHIFT":
							case "DOWN":
							//case "END":
							//case "HOME":
							case "LEFT":
							case "PAGE_DOWN":
							case "PAGE_UP":
							case "RIGHT":
							case "UP":
							case "INSERT":
							case "BACKSPACE":
							case "DELETE":
							//case "ENTER":
							//case "ESCAPE":
								return true;
							default:
								return false;
						}
					}
				}
			}
			return false;
		}
	}
}