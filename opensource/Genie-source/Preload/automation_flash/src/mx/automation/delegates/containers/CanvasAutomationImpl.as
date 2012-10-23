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
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.containers.Canvas;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  Canvas class. 
	 * 
	 *  @see mx.containers.Canvas
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class CanvasAutomationImpl extends ContainerAutomationImpl 
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
			Automation.registerDelegateClass(Canvas, CanvasAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj Canvas object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function CanvasAutomationImpl(obj:Object)
		{
			super(obj);
			
			recordClick = true;
		}
		
		private var isRawChildrenUsed:Boolean = false; 
		//Get all the children of this component
		
		override public function getAutomationChildren():Array
		{
			var arrRawChild:Array = new Array();
			var arrNumChild:Array = new Array();
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
							arrRawChild.push(uiComponent.rawChildren.getChildAt(i))
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
							arrNumChild.push(uiComponent.getChildAt(i))
						}
					}
				}
				catch(e:Error)
				{}
				
				if(arrNumChild.length > 0)
					for(i = 0; i < arrNumChild.length; i++)
					{
						var obj:* = arrNumChild[i];
						arrFinalArray.push(obj);
					}
				
				if(arrRawChild.length > 0)
					for(i = 0; i < arrRawChild.length; i++)
					{
						obj = arrRawChild[i];
						if(arrFinalArray.indexOf(obj) == -1)
							arrFinalArray.push(obj);
					}
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
				if(uiComponent.hasOwnProperty("numRepeaters"))
					totalChildren = arrChild.length + uiComponent.numRepeaters ;
					//totalChildren = uiComponent.rawChildren.numChildren + uiComponent.numRepeaters ;
				else
					totalChildren = arrChild.length 
					//totalChildren = uiComponent.rawChildren.numChildren ;
						
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
			try
			{
				if(index < arrChild.length)
				{
					d = arrChild[index];
					return d;
				}
				else
				{
					var r:Object = uiComponent.childRepeaters[index - uiComponent.numChildren];
					return r;
				}
			}
			catch(e:Error)
			{
				d = uiComponent.rawChildren.getChildAt(index);
				isRawChildrenUsed = true;
				return d;
			}
			return d;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			var retValue:Boolean = false;
			try{
				if(isRawChildrenUsed)
				{
					if(uiComponent.rawChildren.getChildIndex(child) > -1)
					{
						//Added check so that skin etc controls are not displayed.
						if(Automation.getDelegate(child)!=null)
							retValue = true;
					}
					else
						retValue =  false;
				}else
				{
					if(uiComponent.getChildIndex(child) > -1)
					{
						//Added check so that skin etc controls are not displayed.
						if(Automation.getDelegate(child)!=null)
							retValue = true;
					}
					else
					{
						if(uiComponent.owns(child))
							retValue = true;
						else
							retValue =  false;
					}
				}
			}catch(e:Error)
			{
				if(getQualifiedClassName(child) == "mx.controls::TabBar")
				{
					if(uiComponent.owns(child))
						retValue =  true;
					else
						retValue =  false;
				}
				else
				{
					if(uiComponent.owns(child) && isRawChildrenUsed)
						retValue = true;
					else
						retValue =  false;
				}
			}
			return retValue;
		}	
	}
	
}