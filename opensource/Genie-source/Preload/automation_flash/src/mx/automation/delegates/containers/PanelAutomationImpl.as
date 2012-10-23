//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================


package mx.automation.delegates.containers 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.containers.Panel;
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  Panel class. 
	 * 
	 *  @see mx.containers.Panel
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class PanelAutomationImpl extends ContainerAutomationImpl 
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
			Automation.registerDelegateClass(Panel, PanelAutomationImpl);
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
		public function PanelAutomationImpl(obj:Object)
		{
			super(obj);
		}
		
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get panel():Object
		{
			return uiComponent as Object;
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
			return panel.title || super.automationName;
		}
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			return [ panel.title ];
		}
		
		//----------------------------------
		//  numAutomationChildren
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get numAutomationChildren():int
		{
			var result:int = super.numAutomationChildren;
			
			var controlBar:Object = panel.getControlBar();
			
			if (controlBar && (controlBar is IAutomationObject))
				++result;
			
			if (panel._showCloseButton)
				++result;
			
			return result;
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
			var result:int = super.numAutomationChildren;
			var controlBar:Object = panel.getControlBar();
			if (index < result)
			{
				return super.getAutomationChildAt(index);
			}
			
			if (controlBar)
			{
				if(index == result)
					return (controlBar as IAutomationObject);
				++result;
			}
			
			if (panel._showCloseButton && index == result)
				return (panel.closeButton as IAutomationObject);
			
			return null;
		}
		
		/**
		 *  @private
		 */
		override public function getAutomationChildren():Array
		{
			// get the basic children
			var childList:Array = new Array();
			var tempArray1:Array = super.getAutomationChildren();
			if (tempArray1)
			{
				var n:int = tempArray1.length;
				for (var i:int = 0; i< n ; i++)
				{
					childList.push(tempArray1[i]);
				}
			}
			
			
			// add the control bar
			var controlBar:Object = panel.getControlBar();
			if (controlBar)
				childList.push(controlBar as Object);
			
			// add close button
			if (panel._showCloseButton)
				childList.push(panel.closeButton as Object);
			
			return childList;
		}
		
		//Get all the children of this component
		override public function numGenieAutomationChildren():int
		{
			var result:int = super.numGenieAutomationChildren();
			
			var controlBar:Object = panel.getControlBar();
			
			if (controlBar)
				++result;
			
			if (panel._showCloseButton)
				++result;
			
			return result;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			var result:int = super.numGenieAutomationChildren();
			var controlBar:Object = panel.getControlBar();
			if (index < result)
			{
				return super.getGenieAutomationChildAt(index);
			}
			
			if (controlBar)
			{
				if(index == result)
					return (controlBar);
				++result;
			}
			
			if (panel._showCloseButton && index == result)
				return (panel.closeButton as Object);
			
			return null;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			var childArray:Array = getAutomationChildren();
			if(childArray.indexOf(child) > -1)
				return true;
			else
				return false;
			
		}
	}
	
}
