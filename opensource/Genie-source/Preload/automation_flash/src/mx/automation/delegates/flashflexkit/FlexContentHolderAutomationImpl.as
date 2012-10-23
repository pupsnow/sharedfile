//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package mx.automation.delegates.flashflexkit
{ 
	import flash.display.DisplayObject;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.IAutomationObject;
	import mx.core.mx_internal;
	import mx.flash.FlexContentHolder;
	use namespace mx_internal;
	
	[Mixin]
	/**
	 *  
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  FlexContentHolder control.
	 * 
	 *  @see  mx.flash.FlexContentHolder
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	
	
	public class  FlexContentHolderAutomationImpl  extends UIMovieClipAutomationImpl 
	{  
		include "../../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Registers the delegate class for a component class with automation manager.
		 *  @param root DisplayObject object representing the application root. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function init(root:Object):void
		{
			Automation.registerDelegateClass(FlexContentHolder, FlexContentHolderAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj Panel object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function FlexContentHolderAutomationImpl(obj:Object)
		{
			super(obj);
			recordClick = true;
		}
		
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get flexContentHolder():Object
		{
			return movieClip as Object;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
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
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			return [ automationName ];
		}
		
		//----------------------------------
		//  numAutomationChildren
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get numAutomationChildren():int
		{
			//always the Flash container can have only one child
			// which inturn can be a Flex container to hold multiple objects
			
			return (1);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			// only one flex component is allowed as the child
			
			if (index == 0)
				return flexContentHolder.content as IAutomationObject;
			
			return null;
		}
		
		override public function getAutomationChildren():Array
		{
			// only one flex component is allowed as the child
			return [flexContentHolder.content as IAutomationObject];
		}
		
		/**
		 *  @private
		 */
		override public function resolveAutomationIDPart(part:Object):Array
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			return help.helpResolveIDPart(uiAutomationObject, part);
		}
		
		override public function numGenieAutomationChildren():int
		{
			return 1;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			if (index == 0)
				return flexContentHolder.content as Object;
			
			return null;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			if(child == getGenieAutomationChildAt(0))
				return true;
			else
				return false;
		}
	}
}


