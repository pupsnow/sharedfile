//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.delegates.controls 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.automation.Automation;
	import mx.automation.AutomationIDPart;
	import mx.automation.IAutomationObjectHelper;
	import mx.controls.RadioButton;
	import mx.core.EventPriority;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  RadioButton control.
	 * 
	 *  @see mx.controls.RadioButton 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class RadioButtonAutomationImpl extends ButtonAutomationImpl 
	{
		include "../../../core/Version.as";
		
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
			Automation.registerDelegateClass(RadioButton, RadioButtonAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj RadioButton object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function RadioButtonAutomationImpl(obj:Object)
		{
			super(obj);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get radioButton():Object
		{
			return uiComponent as Object;
		}
		
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
			
			if (event is KeyboardEvent)
				return help.replayKeyboardEvent(uiComponent, KeyboardEvent(event));
			else
				return super.replayAutomatableEvent(event);
		}
		
		/**
		 *  @private
		 *  Support the use of keyboard within the group.
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.DOWN:
				case Keyboard.UP:
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					//for form defaults:
				case Keyboard.ENTER:
					recordAutomatableEvent(event);
					break;
			}
		}
		
	}
}