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
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.shared.SharedFunctions;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationEventDescriptor;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.automation.events.AutomationReplayEvent;
	import mx.controls.List;
	import mx.core.EventPriority;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	
	use namespace mx_internal;
	public class GenericAutomationImpl extends UIComponentAutomationImpl 
	{
		private var bClicked:Boolean = false;
		private var bDoubleClicked:Boolean = false;
		private var objArg:Object = null;
		private var UIEvent:Object = null;
		private var strLastUIEvent:String;
		private var am:IAutomationManager;
		private var delay:uint = 10;
		private var repeat:uint = 2000;
		private var key_timerObj:Timer = new Timer(delay, repeat);
		private var lastKeyDownEvent:Event = null;
		private var nKeyPressedForDuration:int = 1;
		private var nStart:int = 0;
		private var nEnd:int = 0;
		private var nTime:int = 0
		private var lastMouseDown:Event = null;
		
		private static var nOldEventPhase:uint;
		private static var nCurrentEventPhase:uint;
		private static var bRecorded:Boolean = false;
		private static var nStartCounter:int;
		private static var nEndCounter:int;
		private static var isKeyDown:Boolean = false;
		private static var isKeyUp:Boolean = true;
		private static var bMouseClickCaptured:Boolean = false;
		private static var bMouseDownCaptured:Boolean = false;
		private static var nClickedStageX:Number = 0;
		private static var nClickedStageY:Number = 0;
		
		public static function init(root:Object):void
		{
			Automation.registerDelegateClass(Sprite, GenericAutomationImpl);
			Automation.registerDelegateClass(Shape, GenericAutomationImpl);
			Automation.registerDelegateClass(MovieClip, GenericAutomationImpl);
		} 
		
		public static function registerObject(obj:Object):void
		{
			Automation.registerDelegateObject(obj, GenericAutomationImpl);
		}

		public function GenericAutomationImpl(obj:Object)
		{
			
			try
			{
				//Below event listeners are commented because of the performance hit on farmville while recording
				
				Automation.isGenericObject = true;
				super(obj);

				obj.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler,false,EventPriority.DEFAULT+1, true);
				
				obj.addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler,false,EventPriority.DEFAULT+1, true);
				obj.addEventListener(MouseEvent.CLICK, mouseClickHandler,false,EventPriority.DEFAULT+1, true);
				//obj.addEventListener(MouseEvent.CLICK, mouseClickHandler,true,EventPriority.DEFAULT+1, true);
				
				//Add key handlers
				obj.addEventListener(KeyboardEvent.KEY_DOWN, genericKeyHandler, false, EventPriority.DEFAULT+1, true);
				obj.addEventListener(KeyboardEvent.KEY_UP, genericKeyUpHandler, false, EventPriority.DEFAULT+1, true);
				
				//There are scenarios where stage/system manager or root listens to the key events and not the component
				//For that add key handlers to parent and root if they exists.
				//KeyBoardSupport
				if(obj.hasOwnProperty("parent") && obj.parent != null)
				{
					obj.parent.addEventListener(KeyboardEvent.KEY_DOWN, genericKeyHandler, false, EventPriority.DEFAULT+1, true);
					obj.parent.addEventListener(KeyboardEvent.KEY_UP, genericKeyUpHandler, false, EventPriority.DEFAULT+1, true);
				}
				
				if(obj.hasOwnProperty("root") && obj.root != null)
				{
					obj.root.addEventListener(KeyboardEvent.KEY_DOWN, genericKeyHandler, false, EventPriority.DEFAULT+1, true);
					obj.root.addEventListener(KeyboardEvent.KEY_UP, genericKeyUpHandler, false, EventPriority.DEFAULT+1, true);
				}				
			}
			catch(e:Error)
			{
				GenieMix.genieLog.traceLog(GenieLogConst.ERROR, e.message);
			}
		}
		
		//Listen to the keyDown event# KeyBoardSupport
		override public function genericKeyHandler(event:KeyboardEvent):void
		{
			am = Automation.automationManager;
			
			if (am && am.recording)
			{
				//There are multiple phases for the event but we need to capture only event phase 2 and that too when keyUp flag is true
				//i.e. no key is pressed right now.
				if(event.eventPhase == 2 && isKeyUp)
				{
					if(!isKeyDown)
					{
						nStart = getTimer();
						
						lastKeyDownEvent = event;
						isKeyDown = true;
						isKeyUp = false;
						//nKeyPressedForDuration = 1;
		
						nTime = 0;
						GenieMix.genieLog.traceLog(GenieLogConst.INFO, "KeyDown has come");
						delay = 10;
						repeat = 2000;
						key_timerObj = new Timer(delay, repeat);
						key_timerObj.start();
					}
				}
			}
		}
		
		//Just a place holder function
//		private function timerHandler(e:TimerEvent):void{
//			//repeat--;
//			nKeyPressedForDuration += 1;
//		}
		
		//Listen to the keyDown event# KeyBoardSupport
		public function genericKeyUpHandler(event:KeyboardEvent):void
		{	
			//Only enter this when recording is enabled
			if (am && am.recording && !isKeyUp)
			{
				GenieMix.genieLog.traceLog(GenieLogConst.INFO, "event Phase: " + event.eventPhase.toString());
				var strObjClassName:String = "";
				var objArg:Object = event.currentTarget;
				
				if(getQualifiedClassName(objArg) == "flash.display::Sprite")
					strObjClassName = "flash.display::Sprite";
				else if(getQualifiedClassName(objArg) == "flash.display::Shape")
					strObjClassName = "flash.display::Shape";
				else if(getQualifiedClassName(objArg) == "flash.display::MovieClip")
					strObjClassName = "flash.display::MovieClip";
				else
					strObjClassName = "com.adobe.genie::DisplayObject";
				
				if(key_timerObj.running)
				{
					key_timerObj.stop();
					//key_timerObj.removeEventListener(TimerEvent.TIMER, timerHandler);
					
					var automationClass:IAutomationClass; 
					
					automationClass = IAutomationEnvironment(Automation.automationManager.automationEnvironment).getAutomationClassByInstance(objArg);
					if (automationClass == null)
					{
						automationClass = IAutomationEnvironment(Automation.automationManager.automationEnvironment).getAutomationClassByName("com.adobe.genie::DisplayObject");
					}
					
					var eventDescriptor:IAutomationEventDescriptor =  automationClass.getDescriptorForEvent(event);
					
					if (eventDescriptor == null)
					{
						return;
					} 
					
	 				var arrArgs:Array = eventDescriptor.record(objArg, event);
					
					//There are multiple phases for the event but we need to capture only event phase 2 and that too when keyDown flag is true
					//i.e. One key is pressed right now for which time is not calculated
					if(isKeyDown && event.eventPhase == 2 && nTime == 0)
					{					
						nEnd = getTimer();
						nTime = nEnd - nStart;
						
						var delegate:Object = Automation.getDelegate(objArg);
						if(delegate == null || Automation.getDelegate(objArg).toString().indexOf("GenericAutomationImpl") > -1)
							GenieMix.command.performKeyboardAutoSwitching(objArg, "performKeyAction", strObjClassName, arrArgs, nTime);
						isKeyDown = false;
						isKeyUp = true;
						//lastKeyDownEvent = null;
					}
				}
			}
		}
		
		private function callKeyAutoSwitching(objArg:Object, strObjClassName:String, arrArgs:Array, nTime:int, e:Event):void
		{
			GenieMix.command.performKeyboardAutoSwitching(objArg, "performKeyAction", strObjClassName, arrArgs, nTime);
		}
		
		private function mouseDownHandler(event:MouseEvent):void 
		{
			am = Automation.automationManager;
			if(am && am.recording)
			{
				if(lastMouseDown == null || lastMouseDown != event)
				{
					GenieMix.genieLog.traceLog(GenieLogConst.INFO, "mouse down done");
					bMouseDownCaptured = false;
					
					CommandsMain.strLastUIStep = "";
					
					GenieMix.command.bStepRecorded = false;
					
					bMouseClickCaptured = false;
					lastMouseDown = event;
					nClickedStageX = 0;
					nClickedStageY = 0;
					var timer:Timer = new Timer(175 * 1, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
						function(e:Event):void
						{
							sendRecordAutomatableEvent(event, e);
						}	
					);
					timer.start();
				}
			}
		}
		
		private function sendRecordAutomatableEvent(event:MouseEvent, e:Event):void
		{
			if(!bMouseClickCaptured)
			{
				var strObjClassName:String = SharedFunctions.getObjectClassName(event.target);
				var arrStage:Array = SharedFunctions.getStageDimensions(event.target);

				if(event.stageX == nClickedStageX || nClickedStageX == 0)
					nClickedStageX = event.stageX;
				
				if(event.stageY == nClickedStageY || nClickedStageY == 0)
					nClickedStageY = event.stageY;
				
				GenieMix.genieLog.traceLog(GenieLogConst.INFO, "sending from mouse down");
				bMouseDownCaptured = true;
				
				GenieMix.command.performAutoSwitching(event.target, "Click", strObjClassName, event.localX, event.localY, nClickedStageX, nClickedStageY, arrStage[0], arrStage[1], event.eventPhase);
			}
		}
		
		private function mouseDoubleClickHandler(event:MouseEvent):void
		{
			am = Automation.automationManager;
			var automationClass:IAutomationClass;
			if (am && am.recording)
			{
				objArg = event.target;
				UIEvent = event;
				bDoubleClicked = true;
				bClicked = false;
				automationClass	= IAutomationEnvironment(GenieMix.automationManager.automationEnvironment).getAutomationClassByInstance(objArg);
				if(automationClass)
				{	
					callAutoSwitching(event);				
				}
			}
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			GenieMix.genieLog.traceLog(GenieLogConst.INFO, "Mouse Clicked");
			var am:IAutomationManager = Automation.automationManager;
			var automationClass:IAutomationClass;
			var compClass:Class;
			var delegateClass:Class;
			var bDelegatePresent:Boolean = false;
			var delegate:Object = null;
			trace(event.eventPhase.toString());
			if (am && am.recording)
			{
			
				var obj:Object = new Object();
				objArg = event.target;
				
				try
				{
					delegate = Automation.getDelegate(objArg);
					
					if(delegate != null && delegate.toString().indexOf("GenericAutomationImpl") == -1)
						bDelegatePresent = false;		
				}
				catch(e:Error)
				{
					bDelegatePresent = false;
				}
				
				if(!bDelegatePresent)
				{
					UIEvent = event;
					bClicked = true;
					bDoubleClicked = false;
										
					nCurrentEventPhase = event.eventPhase;
					nStartCounter = nStartCounter + 1;
					
					GenieMix.genieLog.traceLog(GenieLogConst.INFO, "nStartCounter: "+nStartCounter.toString());
					
					if(nStartCounter == 1)
					{
						nClickedStageX = event.stageX;
						nClickedStageY = event.stageY;	
					}
					
					if(nOldEventPhase == 0)
						nOldEventPhase = event.eventPhase;
					
					var timer:Timer = new Timer(10,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, callAutoSwitching);
					timer.start();
					
					if(bRecorded)
						bRecorded = false;
				}
			}
		}
		
		private function callAutoSwitching(e:Event):void
		{
			//Check whether the object is an automatable component or not for mx and spark.
			//For flash lets record with UIEvents
			var bAutomtabale:Boolean = true;
			var strClassName:String = getQualifiedClassName(objArg);
			
			if(strClassName.toLowerCase().indexOf("mx.") > -1 || strClassName.toLowerCase().indexOf("spark.") > -1)
			{
				if(objArg.hasOwnProperty("showInAutomationHierarchy"))
				{
					if(objArg.showInAutomationHierarchy)
						bAutomtabale = true;
					else
						bAutomtabale = false;
				}
				else
					bAutomtabale = false;
			}
			else
			{
				var automationClass:IAutomationClass;
				automationClass = IAutomationEnvironment(GenieMix.automationManager.automationEnvironment).getAutomationClassByInstance(objArg);
				
				if(automationClass)
				{
					if(automationClass.objExtendedClassName.toLowerCase().indexOf("mx.") > -1 || automationClass.objExtendedClassName.toLowerCase().indexOf("spark.") > -1)
					{
						if(objArg.hasOwnProperty("showInAutomationHierarchy"))
						{
							if(objArg.showInAutomationHierarchy)
								bAutomtabale = true;
							else
								bAutomtabale = false;
						}
						else
							bAutomtabale = false;
					}
				}
			}
			
			if(bAutomtabale)
			{
				nEndCounter = nEndCounter + 1;
				GenieMix.genieLog.traceLog(GenieLogConst.INFO, "nEndCounter: "+nEndCounter.toString());
				var strObjClassName:String = SharedFunctions.getObjectClassName(objArg);
				
				var arrStage:Array = SharedFunctions.getStageDimensions(UIEvent.target);			
				
				if(bClicked == true && bRecorded == false && !bMouseDownCaptured)
				{
					var nLocalX:int = UIEvent.localX;
					var nLocalY:int = UIEvent.localY;
					
					if(nLocalX < 0)
						nLocalX = UIEvent.stageX;
					
					if(nLocalY < 0)
						nLocalY = UIEvent.stageY;
					
					if(nOldEventPhase == nCurrentEventPhase)
					{
						GenieMix.genieLog.traceLog(GenieLogConst.INFO, "Equal Phase");
						GenieMix.genieLog.traceLog(GenieLogConst.INFO, "sending from mouse click");
						nClickedStageX = UIEvent.stageX;
						nClickedStageY = UIEvent.stageY;
						GenieMix.command.performAutoSwitching(objArg, "Click", strObjClassName, nLocalX, nLocalY, UIEvent.stageX, UIEvent.stageY, arrStage[0], arrStage[1], nCurrentEventPhase);
						nOldEventPhase = 0;
						nCurrentEventPhase = 0;
						nStartCounter = 0;
						nEndCounter = 0;
						bRecorded = true;
						bMouseClickCaptured = true;
					}
					else
					{
						if(nStartCounter == nEndCounter && !bMouseDownCaptured)
						{
							GenieMix.genieLog.traceLog(GenieLogConst.INFO, "Equal Counter");
							nClickedStageX = UIEvent.stageX;
							nClickedStageY = UIEvent.stageY;
							GenieMix.genieLog.traceLog(GenieLogConst.INFO, "sending from mouse click");
							GenieMix.command.performAutoSwitching(objArg, "Click", strObjClassName, nLocalX, nLocalY, UIEvent.stageX, UIEvent.stageY, arrStage[0], arrStage[1], nCurrentEventPhase);
							nOldEventPhase = 0;
							nCurrentEventPhase = 0;
							nStartCounter = 0;
							nEndCounter = 0;
							bRecorded = true;
							bMouseClickCaptured = true;
						}
					}
				}
				else if(bDoubleClicked == true)
				{
					GenieMix.command.performAutoSwitching(objArg, "DoubleClick", strObjClassName, UIEvent.localX, UIEvent.localY, UIEvent.stageX, UIEvent.stageY, arrStage[0], arrStage[1]);
					bMouseClickCaptured = true;
				}
			}
		}
		
		private function getInteractiveObject(obj:Object):Object
		{
			var objToReturn:Object = new Object();
			
			try
			{
				objToReturn = obj as InteractiveObject;
				if(objToReturn)
					return objToReturn;
				else
					objToReturn = getInteractiveObject(obj.parent);
			}
			catch(e:Error)
			{}
			return objToReturn;
		}
		
		override public function replayAutomatableEvent(event:Event):Boolean
		{
			var bPlayedBack:Boolean = false;
			var me:MouseEvent;
			var ev:MouseEvent;
			var objToDispatch:Object = new Object();

			objToDispatch = getInteractiveObject((event as AutomationReplayEvent).automationObject);
			
			if (event is AutomationReplayEvent)
				event = (event as AutomationReplayEvent).replayableEvent;
			if (event is MouseEvent && event.type == "ClickAtLocation")
			{
				ev = event as MouseEvent;
				
				//This is done to bring consistency for playback irrespective whether the recording is done in 2 or 3 event phase
				//if(ev.delta == 3)
				//{
				//Fix for the issue of mouse down happening plowing up the field if mouse is on the field
				//and plow button is enabled even if market is clicked
				var strObjDisplatchClassName:String = getQualifiedClassName(objToDispatch);
				if(strObjDisplatchClassName == "flash.display::Sprite" || strObjDisplatchClassName == "flash.display::MovieClip")
				{
					me = new MouseEvent(MouseEvent.MOUSE_DOWN);
					me.localX = ev.localX;
					me.localY = ev.localY;
					me.buttonDown = true;
					bPlayedBack = objToDispatch.dispatchEvent(me);
					
					me = new MouseEvent(MouseEvent.MOUSE_UP);
					me.localX = ev.localX;
					me.localY = ev.localY;
					me.buttonDown = true;
					bPlayedBack = objToDispatch.dispatchEvent(me);
				}
				//}
				
				me = new MouseEvent(MouseEvent.CLICK);
				me.localX = ev.localX;
				me.localY = ev.localX;
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);

//				else if(ev.delta == 2)
//				{
//					objToDispatch.addEventListener(MouseEvent.MOUSE_DOWN, stopDownHandler, false, EventPriority.DEFAULT+1, true);
//					objToDispatch.addEventListener(MouseEvent.MOUSE_UP, stopUpHandler, false, EventPriority.DEFAULT+1, true);
//					//objToDispatch.addEventListener(MouseEvent.CLICK, stopClickHandler, false, EventPriority.DEFAULT+1, true);
//										
//					me = new MouseEvent(MouseEvent.MOUSE_DOWN);
//					me.localX = ev.localX;
//					me.localY = ev.localY;
//					bPlayedBack = objToDispatch.dispatchEvent(me);
//					
//					me = new MouseEvent(MouseEvent.MOUSE_UP);
//					me.localX = ev.localX;
//					me.localY = ev.localY;
//					bPlayedBack = objToDispatch.dispatchEvent(me);
//					
//					me = new MouseEvent(MouseEvent.CLICK);
//					me.localX = ev.localX;
//					me.localY = ev.localX;
//					bPlayedBack = objToDispatch.dispatchEvent(me);
//				}
//				else
//				{
//					me = new MouseEvent(MouseEvent.CLICK);
//					me.localX = ev.localX;
//					me.localY = ev.localX;
//					bPlayedBack = objToDispatch.dispatchEvent(me);
//				}
			}
			else if (event is MouseEvent && event.type == "DoubleClickAtLocation")
			{
				ev = event as MouseEvent;
				
				me = new MouseEvent(MouseEvent.MOUSE_DOWN);
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
				
				me = new MouseEvent(MouseEvent.MOUSE_MOVE);
				me.localX = ev.localX;
				me.localY = ev.localY;
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
				
				me = new MouseEvent(MouseEvent.MOUSE_UP);
				me.localX = ev.localX;
				me.localY = ev.localY;
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
				
				me = new MouseEvent(MouseEvent.MOUSE_DOWN);
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
				
				me = new MouseEvent(MouseEvent.MOUSE_MOVE);
				me.localX = ev.localX;
				me.localY = ev.localY;
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
				
				me = new MouseEvent(MouseEvent.MOUSE_UP);
				me.localX = ev.localX;
				me.localY = ev.localY;
				me.buttonDown = true;
				bPlayedBack = objToDispatch.dispatchEvent(me);
			}
			else if (event is KeyboardEvent && event.type == "keyDown")
			{
				//KeyBoardSupport
				//If action is keyboard event perform keyDown event first
				//Wait for the duration for which key should get pressed
				//Enable the timer
				//When timer gets completed, keyUP is fired.
				var kb:KeyboardEvent;
				kb = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true);
				kb.keyCode = KeyboardEvent(event).keyCode;
				kb.ctrlKey = KeyboardEvent(event).ctrlKey;
				kb.shiftKey = KeyboardEvent(event).shiftKey;
				kb.altKey = KeyboardEvent(event).altKey;
				
				GenieMix.genieLog.traceLog(GenieLogConst.INFO, "Automation.keyDownForDuration: " + Automation.keyDownForDuration.toString());
				
				var timer:Timer = new Timer(Automation.keyDownForDuration, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
					function(e:Event):void
					{
						playKeyUpEvent(objToDispatch, event, e)
					}	
				);
				bPlayedBack = objToDispatch.dispatchEvent(kb);
				timer.start();
			}
			else
				bPlayedBack = super.replayAutomatableEvent(event);
			
			return bPlayedBack;
		}
		
		private function playKeyUpEvent(obj:Object, event:Event, e:Event):void
		{
			var kb:KeyboardEvent;
			kb = new KeyboardEvent(KeyboardEvent.KEY_UP, true);
			kb.keyCode = KeyboardEvent(event).keyCode;
			kb.ctrlKey = KeyboardEvent(event).ctrlKey;
			kb.shiftKey = KeyboardEvent(event).shiftKey;
			kb.altKey = KeyboardEvent(event).altKey;
			obj.dispatchEvent(kb);
		}
		
		private function stopClickHandler(ev:Event):void
		{
			trace("inside stopClickHandler");
			trace(ev.eventPhase);
			ev.stopImmediatePropagation();
			//ev.stopPropagation();
			ev.target.removeEventListener(MouseEvent.CLICK, stopClickHandler);
		}
		
		private function stopDownHandler(ev:Event):void
		{
			trace("inside stopDownHandler");
			trace(ev.eventPhase);
			ev.stopImmediatePropagation();
			//ev.stopPropagation();
			ev.target.removeEventListener(MouseEvent.MOUSE_DOWN, stopDownHandler);
		}
		
		private function stopUpHandler(ev:Event):void
		{
			trace("inside stopUpHandler");
			trace(ev.eventPhase);
			ev.stopImmediatePropagation();
			//ev.stopPropagation();
			ev.target.removeEventListener(MouseEvent.MOUSE_UP, stopUpHandler);
		}
		protected function get generic():Object
		{
			return uiComponent as Object;
		}
		
		override public function get automationName():String
		{
			var strAutomationName:String = "";
			
			try
			{
				strAutomationName = generic.id;
			}
			catch(e:Error)
			{
				
			}
			
			try
			{
				strAutomationName = strAutomationName || generic.label;
			}
			catch(e:Error)
			{
				
			}
			
			try
			{
				strAutomationName = strAutomationName || generic.text;
			}
			catch(e:Error)
			{
				
			}
			
			try
			{
				strAutomationName = strAutomationName || generic.toolTip;
			}
			catch(e:Error)
			{
				
			}
			
			try
			{
				strAutomationName = strAutomationName || super.automationName;
			}
			catch(e:Error)
			{
				
			}
			
			return strAutomationName;
		}
		
		override public function get automationValue():Array
		{
			return [ generic.label || generic.toolTip ];
		}
		
		override public function getAutomationChildren():Array
		{
			var arrFinalArray:Array = new Array();
			var i:int = 0;
			try
			{
				try
				{
					if(uiComponent.hasOwnProperty("rawChildren"))
					{
						for(i = 0; i < uiComponent.rawChildren.numChildren; i++)
						{
							arrFinalArray.push(uiComponent.rawChildren.getChildAt(i));
						}
					}
				}
				catch(e:Error)
				{}
				
				try
				{
					if(uiComponent.hasOwnProperty("numChildren"))
					{
						for(i = 0; i < uiComponent.numChildren; i++)
						{
							var obj:* = uiComponent.getChildAt(i);
							if(arrFinalArray.indexOf(obj) == -1)
							{
								arrFinalArray.push(obj);
							}
						}
					}
				}
				catch(e:Error)
				{}
			}
			catch(e:Error)
			{
				arrFinalArray = new Array();
			}
			return arrFinalArray;
		}
		
		
		override public function numGenieAutomationChildren():int
		{
			var totalChildren:int = 0;
			try
			{
				var arrChild:Array = getAutomationChildren();
				totalChildren = arrChild.length;
				
			}catch(e:Error)
			{
				totalChildren = uiComponent.numChildren;
			}
			
			return totalChildren;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			var d:Object = null;
			var arrChild:Array = getAutomationChildren();
			
			if(index < arrChild.length)
			{
				d = arrChild[index];
				return d;
			}
			
			return null;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			var retValue:Boolean = false;
			var arrChild:Array = getAutomationChildren();
			try
			{
				if(arrChild.indexOf(child) > -1)
					return true;
				else
					return false;
			}
			catch(e:Error)
			{
				if(uiComponent.owns(child))
					return true;
				else
					return false;
			}
			return retValue;
		}
		
	}
}