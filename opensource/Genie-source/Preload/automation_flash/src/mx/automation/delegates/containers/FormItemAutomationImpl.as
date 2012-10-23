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
	
	import mx.automation.Automation;
	import mx.automation.AutomationIDPart;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.containers.FormItem;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  FormItem class. 
	 * 
	 *  @see mx.containers.FormItem
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class FormItemAutomationImpl extends ContainerAutomationImpl 
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
			Automation.registerDelegateClass(FormItem, FormItemAutomationImpl);
		}   
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get formItem():Object
		{
			return uiComponent as Object;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @param obj The FormItem object to be automated.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function FormItemAutomationImpl(obj:Object)
		{
			super(obj);
			
		}
		
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			var label:IAutomationObject = formItem.itemLabel as IAutomationObject;
			var result:Array = [ label ? label.automationName : null ];
			
			var childArray:Array = getAutomationChildren();
			if (childArray)
			{
				var n:int = childArray.length;
				for (var i:int = 0; i < n; i++)
				{
					var child:IAutomationObject = childArray[i] as IAutomationObject;
					if (child == label)
						continue;
					var x:Array = child.automationValue;
					if (x && x.length != 0)
						result.push(x);
				}
			}
			return result;
		}
		
		//----------------------------------
		//  numAutomationChildren
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get numAutomationChildren():int
		{
			return formItem.numChildren + (formItem.itemLabel != null ? 1 : 0);
		}
		
		/**
		 *  @private
		 */
		override public function createAutomationIDPart(child:IAutomationObject):Object
		{ 
			//var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			//return help.helpCreateIDPart(uiAutomationObject, child, getItemAutomationName);
			return null;
		}
		
		override public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object
		{
			//var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			//return help.helpCreateIDPartWithRequiredProperties(uiAutomationObject, child,properties, getItemAutomationName);
			return null;
		}
		
		/**
		 *  @private
		 */
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			var labelObj:IAutomationObject = formItem.itemLabel as IAutomationObject;
			return (index == formItem.numChildren && labelObj != null 
				? (labelObj)
				: super.getAutomationChildAt(index));
		}
		
		/**
		 * @private
		 */
		override public function getAutomationChildren():Array
		{
			var childList:Array = new Array();
			var labelObj:Object = formItem.itemLabel as Object;
			// we need to add the label object and the children of the form also
			
			var tempArray1:Array = super.getAutomationChildren();
			if(tempArray1)
			{
				var n:int = tempArray1.length;
				for (var i:int = 0; i < n ; i++)
				{
					childList.push(tempArray1[i]);
				}
			}
			
			if(labelObj)
				childList.push(labelObj);
			
			return childList;
		}
		/**
		 * @private
		 */
		private function getItemAutomationName(child:IAutomationObject):String
		{
			var labelObj:IAutomationObject = formItem.itemLabel as IAutomationObject;
			var label:String = labelObj ? labelObj.automationName : "";
			var result:String = null;
			if (child.automationName && child.automationName.length != 0)
				result = (((label)&&(label.length != 0))
					? label + ":" + child.automationName 
					: child.automationName);
			else
			{
				var childArray:Array = getAutomationChildren();
				if (childArray)
				{
					var n:int = childArray.length;
					for (var i:uint = 0; !result && i < n; i++)
					{
						if (childArray[i] == child)
						{
							result = (i == 0 && 
								n == (labelObj ? 2 : 1)
								? label
								: label + ":" + i);
						}
					}
				}
			}
			return result;
		}
		
		public override function numGenieAutomationChildren():int
		{
			return formItem.numChildren + (formItem.itemLabel != null ? 1 : 0);
		}
		
		public override function getGenieAutomationChildAt(index:int):Object
		{
			var labelObj:Object = formItem.itemLabel as Object;
			if(index == formItem.numChildren && labelObj != null)
			{
				return (labelObj);
			}
			else
			{
				return super.getGenieAutomationChildAt(index);
			}
			
		}
		
		public override function isGenieAutomationChild(child:Object):Boolean
		{
			var childArray:Array = getAutomationChildren();
			if(childArray.indexOf(child) > -1)
				return true;
			else
				return false;
				
		}
		
		
		
		
	}
}
