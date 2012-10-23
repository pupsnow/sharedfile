//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================
package
{
	[Frame(factoryClass="mx.managers.SystemManager")];
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.*;
	
	import gn.adobe.genie.CommandsMain;
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.logging.IGenieLog;
	import mx.automation.Automation;
	
	public class GeniePreload extends Sprite
	{
		public static var MySprite:Sprite = null;
		[ArrayElementType("Sprite")]
		public var arraySprite:Array = new Array();
		[ArrayElementType("XML")]
		private var arrayAppXML:Array = new Array();
		
		private var arrayApp:Array = new Array();
		public static var geniePreloadName:String ="";
		public static var MainStage:Stage = null;
		public static var MainSprite:Sprite = null;

		public var myLoader:Loader = new Loader();
		public var firstTime:Boolean = true;
		private static var needReloading:Boolean = false;	//Only for class merging
		private static var reloaded:Boolean = false;	//Only for class merging
		private var strAppName:String; 
		private var objLog:IGenieLog;
		
		public static var connectionStatusForLogging:Boolean=false;
		
		public function GeniePreload()
		{
			objLog = GenieLog.getInstance(); 
			objLog.traceLog(GenieLogConst.INFO, "Genie Preload Constuctor invoked");
			
			var timerDelayLoading:Timer;
			timerDelayLoading = new Timer(2000,1);
			timerDelayLoading.start();	
			
			MySprite = this;
			root.addEventListener("allComplete",allCompleteHandler);
			//Code to get name of the swf-start			
			var preloadUrl:String=this.loaderInfo.url;			
			var splitPreloadUrl:Array=preloadUrl.split("/");

			geniePreloadName=splitPreloadUrl[splitPreloadUrl.length-1];
			geniePreloadName=geniePreloadName.toLowerCase();
			geniePreloadName="GenieLibrary";	

		}
		
		private function allCompleteHandler(event:Event) : void
		{
			
			var loaderInfo:LoaderInfo;
			var theName:String;
			var t:Timer;
			var t1:Timer;
			var stats:GenieDisplay;
			var theValue:String;
							
			try
			{
				if(firstTime)
				{
					
					firstTime = false;
					loaderInfo = LoaderInfo(event.target);
					//if stage is null then reset firstTime flag
					if(loaderInfo.content.root.stage == null)
						firstTime = true;
					if (loaderInfo.content.root.stage != null) 
					{
						var loadedObject:Sprite = loaderInfo.content.root as Sprite;
						
						MainStage = loaderInfo.content.root.stage;
						if(getQualifiedClassName(loadedObject).toLowerCase().indexOf("systemmanager") == -1)
						{
							if(loadedObject == MainStage.getChildAt(0))
								loadedObject = loaderInfo.content.root as Sprite;
							else
								loadedObject = MainStage.getChildAt(0) as Sprite;
						}
						
						
						if(MainStage == null || loadedObject == null)
						{
							firstTime = true;
							objLog.traceLog(GenieLogConst.INFO,"MainStage is null: Returning from allCompleteHandler()");
							return;
						}
						else 
						{
							if(loadedObject)
							{
								trace("Loaded Object is " + loadedObject);
								
								if(loadedObject.hasOwnProperty("cp"))
									if(Object(loadedObject).cp)
									{
										firstTime = true;
										objLog.traceLog(GenieLogConst.INFO,"Proxy Object: Returning from allCompleteHandler()");
										return;
									}
							}
							else
							{
								firstTime = true;
								return;
							}
							
						}
						
						MainSprite = loadedObject;
						
						if(MainSprite == null)
						{
							firstTime = true;
							objLog.traceLog(GenieLogConst.INFO , "MainSprite null: Returning from allCompleteHandler()");
							return;
						}
						
						MainStage.addChild(this);
												
						//Show some stats
						var displayManager:DisplayManager = DisplayManager.getInstance();
						GenieMix.gnDisplay = displayManager;
						GenieMix.strASVersion = loaderInfo.actionScriptVersion.toString();
						
						t1 = new Timer(500 * 1, 1);
						t1.addEventListener(TimerEvent.TIMER_COMPLETE, initialize);
						t1.start();	
						
						t = new Timer(1000 * 20, 1);
						t.addEventListener(TimerEvent.TIMER_COMPLETE, removeListener);
						t.start();	
					}
					else
						firstTime = true;
				}
			}
			catch (e:Error)
			{
				objLog.traceLog(GenieLogConst.ERROR ,"function allCompleteHandler: "+e.message);
			}
		}
		
		private function removeListener(e:Event):void
		{
			MainStage.removeEventListener(Event.ADDED,added);
		}
		private function added(e:Event):void
		{
			MainStage.setChildIndex(this,MainStage.numChildren -1 );
		}
		private function initialize(e:Event):void
		{
			try
			{
				MainStage.addEventListener(Event.ADDED,added);
				
				GenieMix.setcurrentMainSprite = MainSprite;
				strAppName = GenieMix.getUniqueApplicationName(MainSprite);
				GenieMix.init(MainSprite,strAppName);
				var gnDisplay:GenieDisplay = new GenieDisplay();
				addChild(gnDisplay);
				DisplayManager.getInstance().addToList(gnDisplay);
				GenieMix.subsequentInitialization(MainSprite);
			}
			catch(e1:Error)
			{
				objLog.traceLog(GenieLogConst.ERROR ,"Error in initialize(): " + e1.message.toString());
			}
		}
	}
}
