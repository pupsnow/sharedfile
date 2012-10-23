//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.delegates.core 
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import mx.automation.Automation; 
	import mx.automation.IAutomationObject;
	import mx.core.UITextField;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  UITextField class. 
	 * 
	 *  @see mx.core.UITextField
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class UITextFieldAutomationImpl implements IAutomationObject
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
			Automation.registerDelegateClass(UITextField, UITextFieldAutomationImpl);
		}   
		
		/**
		 * Constructor.
		 * @param obj UITextField object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public function UITextFieldAutomationImpl(obj:Object)
		{
			super();
			uiTextField = obj;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */ 
		protected var uiTextField:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------
		//  automationEnabled
		//---------------------------------
		public function get automationEnabled():Boolean
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if(uiTextField)
				return uiTextField.enabled;
			
			return false;
		}
		
		//---------------------------------
		//  automationOwner
		//---------------------------------
		public function get automationOwner():DisplayObjectContainer
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			
			if(uiTextField)
				return uiTextField.owner;
			
			return null;
		}
		
		//---------------------------------
		//  automationParent
		//---------------------------------
		public function get automationParent():DisplayObjectContainer
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			
			if(uiTextField)
				return uiTextField.parent;
			
			return null;
		}
		
		//---------------------------------
		//  automationVisible
		//---------------------------------
		public function get automationVisible():Boolean
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if(uiTextField)
				return uiTextField.visible;
			
			return false;
		}
		
		//----------------------------------
		//  automationName
		//----------------------------------
		
		/**
		 * @private
		 */
		public function get automationName():String
		{
			return uiTextField.text;
		}
		
		/**
		 * @private
		 */
		public function set automationName(value:String):void
		{
			
			if( uiTextField is IAutomationObject)
			{
				var tempObj:IAutomationObject = IAutomationObject(uiTextField);
				if(tempObj != null)
				{
					tempObj.automationName = value;
				}
			}
		}
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get automationValue():Array
		{
			return [ uiTextField.text ];
		}
		
		/**
		 *  @private
		 */
		public function createAutomationIDPart(child:IAutomationObject):Object
		{
			return null;
		}
		
		/**
		 *  @private
		 */
		public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object
		{
			return null;
		}
		
		/**
		 *  @private
		 */
		public function resolveAutomationIDPart(criteria:Object):Array
		{
			return [];
		}
		
		/**
		 *  @private
		 */
		public function get numAutomationChildren():int
		{
			return 0;
		}
		
		/**
		 *  @private
		 */
		public function getAutomationChildAt(index:int):IAutomationObject
		{
			return null;
		}  
		/**
		 *  @private
		 */
		public function getAutomationChildren():Array
		{
			return null;
		}
		
		/**
		 *  @private
		 */
		public function get automationTabularData():Object
		{
			return null;    
		}
		
		/**
		 *  @private
		 */
		public function get showInAutomationHierarchy():Boolean
		{
			return true;
		}
		
		/**
		 *  @private
		 */
		public function set showInAutomationHierarchy(value:Boolean):void
		{
		}
		
		/**
		 *  @private
		 */
		public function get owner():DisplayObjectContainer
		{
			return null;
		}
		
		/**
		 *  @private
		 */
		public function replayAutomatableEvent(event:Event):Boolean
		{
			return false;
		}
		
		/**
		 *  @private
		 */
		public function set automationDelegate(val:Object):void
		{
			trace("Invalid setter function call. Should have been called on the component");
		}
		
		/**
		 *  @private
		 */
		public function get automationDelegate():Object
		{
			trace("Invalid setter function call. Should have been called on the component");
			return this;
		}
		
		public function numGenieAutomationChildren():int
		{
			return 0;
		}
		
		public function getGenieAutomationChildAt(index:int):Object
		{
			//if((container as Object).flexContextMenu != null)
			//return (container as UIComponent).flexContextMenu as Object;
			return null;
		}
		
		public function isGenieAutomationChild(child:Object):Boolean
		{
			return false;
		}
	}
	
}