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
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import gn.adobe.logging.GenieLogConst;
	
	import mx.automation.Automation;
	
	public class LoadCustomContent extends Sprite
	{		
		private var ByteLoader:URLLoader;
		private var ByteConverter:Loader;
		private var ByteConverter2:Loader;
		private var FileRequest:URLRequest;
		
		public function LoadCustomContent()
		{
		}
		
		public function LoadCustomSwf(strPathToLoad:String):void
		{
			try
			{
				ByteLoader = new URLLoader();
				ByteLoader.dataFormat = URLLoaderDataFormat.BINARY;
				ByteLoader.addEventListener (Event.COMPLETE, onBytesLoaded);
				ByteLoader.addEventListener (IOErrorEvent.IO_ERROR, onBytesLoaded);
				FileRequest = new URLRequest (strPathToLoad);
				ByteLoader.load (FileRequest);
			}
			catch(e:Error)
			{
				GenieMix.genieLog.traceLog(GenieLogConst.ERROR, e.message.toString());
			}
		}
		
		public function onBytesLoaded (evt:Event):void 
		{
			if(evt.type == "ioError")
			{
				//Do Nothing
			}
			else
			{
				var MyByteArray:ByteArray = evt.target.data;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onload, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onload, false, 0, true);
				loader.loadBytes(MyByteArray);
				addChild(loader);
			}
			
		}
		
		
		private static function onload(e:Event):void
		{
			if(e is IOErrorEvent)
			{
				var obj:Object = e;
				GenieMix.genieLog.traceLog(GenieLogConst.ERROR, obj.text.toString());
			}
			else
			{
				try
				{
					var target:Object = e.currentTarget.loader.content as Object;
					var strClassName:String = target.returnClass();
					var tempClass:Class = target.returnRegisterClass();

					var arrClass:Array = new Array();
					
					try
					{
						//Fix for making Custom Component easy
						arrClass = target.registerClassesWithGenericImpl();
					}
					catch(e:Error)
					{}
					
					for (var k:int = 0; k<arrClass.length; k++)
					{
						if (Automation.arrCustomClasses.indexOf(arrClass[k]) == -1)
							Automation.arrCustomClasses.push(arrClass[k]);
					}
					
					target.fillAutomationManager(Automation.automationManager);
					Automation.registerDelegateString(strClassName, tempClass);
					Automation.extendedComponentDelegateList[strClassName] = tempClass;
					Automation.delegateDictionary[strClassName] = tempClass;
					GenieMix.genieLog.traceLog(GenieLogConst.INFO, "Custom Component loaded successfully");
				}
				catch(e:Error)
				{
					GenieMix.genieLog.traceLog(GenieLogConst.ERROR, e.message.toString());
				}
			}
		}
	}
}