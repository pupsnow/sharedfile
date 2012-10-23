//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package fl.automation.delegates.controls 
{
	import fl.automation.delegates.core.FlashUIComponentAutomationImpl;
	import fl.controls.BaseButton;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.events.AutomationReplayEvent;
	import mx.core.EventPriority;
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  Button control.
	 * 
	 *  @see mx.controls.Button 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class FlashBaseButtonAutomationImpl extends FlashUIComponentAutomationImpl 
	{
		include "../../../core/Version.as";
		
		private static var bMouseClickCaptured:Boolean = false;
		private static var bSendForRecord:Boolean = false;
		private static var lastMouseDown:Event = null;
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Registers the delegate class for a component class with automation manager.
		 *  
		 *  @param root The SystemManger of the application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function init(root:Object):void
		{
			Automation.registerDelegateClass(fl.controls.BaseButton, FlashBaseButtonAutomationImpl);
			Automation.registerDelegateClass(flash.display.SimpleButton, FlashBaseButtonAutomationImpl);
		}   
		
		/**
		 *  Constructor.
		 * @param obj Button object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function FlashBaseButtonAutomationImpl(obj:Object)
		{
			super(obj);
			if(getQualifiedClassName(obj.parent) != "fl.controls::ComboBox")
			{
				obj.addEventListener(KeyboardEvent.KEY_UP, btnKeyUpHandler, false, EventPriority.DEFAULT+1, true);          
				obj.addEventListener(MouseEvent.CLICK, clickHandler, false, EventPriority.DEFAULT+1, true);
			}
			
			obj.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, EventPriority.DEFAULT+1, true);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get btn():Object
		{
			return uiComponent as Object;
		}
		
		/**
		 *  @private
		 */
		private var ignoreReplayableClick:Boolean;
		
		//----------------------------------
		//  automationName
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationName():String
		{
			return super.automationName;
		}
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			return [];
		}
		
		
		protected function buttonDownHandler(event:Event):void 
		{
			if (!ignoreReplayableClick)
				recordAutomatableEvent(event);
			ignoreReplayableClick = false;
		}
		/**
		 *  @private
		 */
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			if((lastMouseDown == null || lastMouseDown != event))
			{
				trace("mouse down done");
				lastMouseDown = event;
				bMouseClickCaptured = false;
				
				var timer:Timer = new Timer(50 * 1, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
					function(e:Event):void
					{
						sendRecordAutomatableEvent(event, e);
					}	
				);
				timer.start();
			}
		}
		
		protected function clickHandler(event:MouseEvent):void 
		{
			if (!ignoreReplayableClick)
			{
				bMouseClickCaptured = true;
				if(!bSendForRecord)
				{
					recordAutomatableEvent(event);
				}
			}
			ignoreReplayableClick = false;
		}
		
		private function sendRecordAutomatableEvent(event:MouseEvent, e:Event):void
		{
			if(!bMouseClickCaptured)
			{
				var ev:MouseEvent = new MouseEvent(MouseEvent.CLICK);
				ev.buttonDown = event.buttonDown;
				ev.altKey = event.altKey;
				ev.ctrlKey = event.ctrlKey;
				ev.shiftKey = event.shiftKey;
				recordAutomatableEvent(ev);
				bSendForRecord = true;
			}
		}
		/**
		 *  @private
		 */
		private function btnKeyUpHandler(event:KeyboardEvent):void 
		{
			if (!btn.enabled)
				return;
			
			if (event.keyCode == Keyboard.SPACE)
			{
				// we need to ignore recording a click being dispatched here
				ignoreReplayableClick = true;
				recordAutomatableEvent(event);
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Replays click interactions on the button.
		 *  If the interaction was from the mouse,
		 *  dispatches MOUSE_DOWN, MOUSE_UP, and CLICK.
		 *  If interaction was from the keyboard,
		 *  dispatches KEY_DOWN, KEY_UP.
		 *  Button's KEY_UP handler then dispatches CLICK.
		 *
		 *  @param event ReplayableClickEvent to replay.
		 */
		override public function replayAutomatableEvent(event:Event):Boolean
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			var ev:Event;
			try
			{
				ev = (event as AutomationReplayEvent).replayableEvent;	
			}
			catch(e:Error)
			{
				ev = event;
			}
			
			if (ev is MouseEvent && ev.type == MouseEvent.CLICK)
				return help.replayClick(uiComponent, MouseEvent(ev));
			else if (ev is KeyboardEvent)
				return help.replayKeyboardEvent(uiComponent, KeyboardEvent(ev));
			else
				return super.replayAutomatableEvent(ev);
		}
		
	}
	
}