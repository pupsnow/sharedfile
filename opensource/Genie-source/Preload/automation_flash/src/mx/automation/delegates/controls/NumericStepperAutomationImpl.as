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
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.events.AutomationReplayEvent;
	import mx.automation.events.TextSelectionEvent;
	import mx.controls.NumericStepper;
	import mx.controls.TextInput;
	import mx.core.EventPriority;
	import mx.core.mx_internal;
	import mx.events.NumericStepperEvent;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  NumericStepper control.
	 * 
	 *  @see mx.controls.NumericStepper 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class NumericStepperAutomationImpl extends UIComponentAutomationImpl 
	{
		
		include "../../../core/Version.as";
		
		private var keyPressed:Boolean = false;
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
			Automation.registerDelegateClass(NumericStepper, NumericStepperAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj NumericStepper object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function NumericStepperAutomationImpl(obj:Object)
		{
			super(obj);
			
			obj.addEventListener(NumericStepperEvent.CHANGE, nsChangeHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get ns():Object
		{
			return uiComponent as Object;   
		}
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			return [ ns.value.toString() ];
		}
		
		/**
		 *  @private
		 */
		override public function replayAutomatableEvent(ev:Event):Boolean
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			var event:Event = AutomationReplayEvent(ev).replayableEvent;
			if (event is NumericStepperEvent)
			{
				var nsEvent:NumericStepperEvent = NumericStepperEvent(event);
				
				//This is done because properties for flash numeric stepper are protected and hence getting the object from numChildren is the only way
				var btnNextObject:Object = new Object();
				var btnPrevObject:Object = new Object();
				
				if(ns.hasOwnProperty("nextButton"))
					btnNextObject = ns.nextButton;
				else 
				{
					if(ns.hasOwnProperty("numChildren"))
					{
						if(ns.numChildren)
						{
							for(var i:int = 0; i < ns.numChildren; i++)
							{
								var objChild:* = ns.getChildAt(i);
								if(getQualifiedClassName(objChild).toLowerCase().indexOf("basebutton") > -1 && objChild.hasOwnProperty("numChildren"))
								{
									if(getQualifiedClassName(objChild.getChildAt(0)).toLowerCase().indexOf("uparrow") > -1)
									{
										btnNextObject = objChild;
										break;
									}
								}
							}
						}
					}
				}
				
				if(ns.hasOwnProperty("prevButton"))
					btnPrevObject = ns.prevButton;
				else 
				{
					if(ns.hasOwnProperty("numChildren"))
					{
						if(ns.numChildren)
						{
							for(i = 0; i < ns.numChildren; i++)
							{
								objChild = ns.getChildAt(i);
								if(getQualifiedClassName(objChild).toLowerCase().indexOf("basebutton") > -1 && objChild.hasOwnProperty("numChildren"))
								{
									if(getQualifiedClassName(objChild.getChildAt(0)).toLowerCase().indexOf("downarrow") > -1)
									{
										btnPrevObject = objChild;
										break;
									}
								}
							}
						}
					}
				}
				
				if(nsEvent.value > ns.value)
				{
					if(getQualifiedClassName(btnNextObject).toLowerCase().indexOf("button")== -1)
						btnNextObject = ns.nextButton;
					while(nsEvent.value > ns.value)
						help.replayClick(btnNextObject);
					
					return true;
				}
				else if(nsEvent.value < ns.value)
				{
					if(getQualifiedClassName(btnPrevObject).toLowerCase().indexOf("button")== -1)
						btnPrevObject = ns.prevButton;
					while(nsEvent.value < ns.value)
						help.replayClick(btnPrevObject);
					
					return true;
				}
				else
				{
					if(Number(ns.inputField.text) != nsEvent.value)
						ns.inputField.text = String(nsEvent.value);
					return true; // we dont need any button click here.
				}
			}
			else if (event is KeyboardEvent)
			{
				return help.replayKeyboardEvent(ns.inputField,
					KeyboardEvent(event));
			}
			else if (event is TextEvent || event is TextSelectionEvent)
			{
				var delegate:Object = Automation.getDelegate(ns.inputField);
				return (delegate).replayAutomatableEvent(ev);
			}
			else
			{
				return super.replayAutomatableEvent(event);
			}
		}
		
		/**
		 *  Method which gets called after the component has been initialized. 
		 *  This can be used to access any sub-components and act on the component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function componentInitialized():void
		{
			super.componentInitialized();
			
			ns.inputField.addEventListener(AutomationRecordEvent.RECORD,
				inputField_recordHandler);
			ns.inputField.addEventListener(KeyboardEvent.KEY_DOWN, 
				inputField_keyDownHandler, false, EventPriority.DEFAULT+1);
		}
		
		private function inputField_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.HOME ||
				event.keyCode == Keyboard.END ||
				event.keyCode == Keyboard.UP ||
				event.keyCode == Keyboard.DOWN)
			{
				keyPressed = true;
				recordAutomatableEvent(event);
			}
		}
		
		/**
		 *  @private
		 */
		protected function nsChangeHandler(event:Event):void
		{
			if (!keyPressed)
			{
				recordAutomatableEvent(event);
			}
			else
			{
				keyPressed = false;
			}
		}
		
		/**
		 *  @private
		 */
		private function inputField_recordHandler(event:AutomationRecordEvent):void
		{
			if(event.automationObject == ns.inputField)
			{
				// enter key is recorded by the base class.
				// prevent its recording
				var re:Object = event.replayableEvent;
				if (re is KeyboardEvent && re.keyCode == Keyboard.ENTER)
					return;
				recordAutomatableEvent(event.replayableEvent);
			}
		}
		
		override public function numGenieAutomationChildren():int
		{
			return 0;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			return null;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			return false;
		}
		
	}
}