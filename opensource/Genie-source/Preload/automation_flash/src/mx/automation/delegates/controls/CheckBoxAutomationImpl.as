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
	import flash.display.DisplayObjectContainer;
	
	import mx.automation.Automation;
	import mx.controls.CheckBox;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  CheckBox control.
	 * 
	 *  @see mx.controls.CheckBox 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class CheckBoxAutomationImpl extends ButtonAutomationImpl 
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
			Automation.registerDelegateClass(CheckBox, CheckBoxAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj CheckBox object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function CheckBoxAutomationImpl(obj:Object)
		{
			var bShouldRegister:Boolean = false;
			
			try
			{
				if(obj.owner.hasOwnProperty("showInAutomationHierarchy") && !(obj.owner is DisplayObjectContainer))
					bShouldRegister = obj.owner.showInAutomationHierarchy;
				
				if(obj.parent.hasOwnProperty("showInAutomationHierarchy") && !(obj.owner is DisplayObjectContainer))
					bShouldRegister = obj.parent.showInAutomationHierarchy;
			}
			catch(ex:Error)
			{
				bShouldRegister = false;
			}
			
			if(!bShouldRegister)
				super(obj);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get chk():Object
		{
			return uiComponent as Object;
		}
		
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
			var result:String = chk.selected ? "[X]" : "[ ]";
			if (chk.label || chk.toolTip)
				result += " " + (chk.label || chk.toolTip);
			return [ result ];
		}
		
	}
}