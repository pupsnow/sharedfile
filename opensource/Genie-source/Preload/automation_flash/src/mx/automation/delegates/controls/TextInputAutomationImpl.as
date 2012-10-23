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
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.TextFieldAutomationHelper;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.controls.TextInput;
	import mx.core.IUITextField;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  TextInput control.
	 * 
	 *  @see mx.controls.TextInput 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class TextInputAutomationImpl extends UIComponentAutomationImpl 
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
			Automation.registerDelegateClass(TextInput, TextInputAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj TextInput object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function TextInputAutomationImpl(obj:Object)
		{
			super(obj);
			if(!obj.initialized)
				componentInitialized();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get  textInput():Object
		{
			return uiComponent as Object;
		}
		
		/**
		 *  @private
		 *  Generic record/replay logic for textfields.
		 */
		private var automationHelper:TextFieldAutomationHelper;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			return [ textInput.text ];
		}
		
		public function checkFocus():Boolean
		{
			return automationHelper.checkFocus();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function replayAutomatableEvent(interaction:Event):Boolean
		{
			var returnValue:Boolean = false;
			try
			{
				returnValue = ((automationHelper &&
					automationHelper.replayAutomatableEvent(interaction)) ||
					super.replayAutomatableEvent(interaction));	
			}
			catch(e:Error)
			{
				if(e.errorID == 1019)
				{
					returnValue = ((automationHelper &&
						automationHelper.replayAutomatableEvent(interaction)) ||
						super.replayAutomatableEvent(interaction));	
				}
				else
					throw e;
			}
			return returnValue;
		}
			 
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
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
			var textField:Object = textInput.getTextField();
			if(!Automation.delegateInstanceDictionary[uiComponent])
				automationHelper = new TextFieldAutomationHelper(uiComponent, uiAutomationObject, textField)
		}
		
		/**
		 *  @private
		 *  Prevent duplicate ENTER key recordings. 
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			;
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