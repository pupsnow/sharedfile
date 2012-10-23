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
	import flash.display.DisplayObjectContainer;
	
	import mx.automation.Automation;
	import mx.automation.AutomationManager;
	import mx.automation.IAutomationManager2;
	import mx.automation.IAutomationObject;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.containers.ApplicationControlBar;
	import mx.core.Application;
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  Application class. 
	 * 
	 *  @see mx.core.Application
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class ApplicationAutomationImpl extends ContainerAutomationImpl
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
			Automation.registerDelegateClass(Application, ApplicationAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj Application object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ApplicationAutomationImpl(obj:Object)
		{
			super(obj);
			recordClick = true;
			var am:IAutomationManager2 = Automation.automationManager2;
			am.registerNewApplication(obj);
		}
		
		/**
		 *  @private
		 */
		protected function get application():Object
		{
			return uiComponent as Object;      
		}
		
		/**
		 *  @private
		 */
		override public function get automationName():String
		{
			var am:IAutomationManager2 = Automation.automationManager2;
			return am.getUniqueApplicationID();
		}
		/**
		 *  @private
		 */
		override protected function componentInitialized():void
		{
			super.componentInitialized();
			// Override for situations where an app is loaded into another
			// application. Find the Flex loader that contains us.
			var owner:Object = application.owner as Object;
			
			if ((!owner)  && application.systemManager.isTopLevel() == false)
			{
				try
				{
					var findAP:Object = application.parent;
					
					owner = findAP as Object;
					while (findAP && !(owner))
					{
						findAP = findAP.parent;
						owner = findAP as Object;
					}
					
					application.owner = owner as Object;
				}
				catch (e:Error)
				{
				}
			}
		}
		
		
		/**
		 *  @private
		 */
		private function getDockedControlBar(index:int):Object
		{
			var dockedApplicationControlBarsFound:int = 0;
			
			// number of docked application control bars
			// get its row children and see how many docked application control 
			// bars are present
			var n:int = application.rawChildren.numChildren;
			for ( var childPos:int=0 ;childPos < n; childPos++)
			{
				var currentObject:Object = 
					application.rawChildren.getChildAt(childPos) as Object;
				if(currentObject && currentObject.hasOwnProperty("dock"))
				{
					if(currentObject.dock == true)
					{
						if(dockedApplicationControlBarsFound == index)
						{
							return currentObject as Object;
						}
						else
						{
							dockedApplicationControlBarsFound++;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 *  @private
		 */
		private function getDockedControlBarChildren():Array
		{
			var childrenList:Array = new Array();
			
			// number of docked application control bars
			// get its row children and see how many docked application control 
			// bars are present
			var n:int = application.rawChildren.numChildren;
			for (var i:int=0 ;i < n; i++)
			{
				var currentObject:ApplicationControlBar = 
					application.rawChildren.getChildAt(i) as ApplicationControlBar;
				if (currentObject)
				{
					if(currentObject.dock == true)
						childrenList.push(currentObject as IAutomationObject);
				}
			}
			return childrenList;
		}
		
		/**
		 *  @private
		 */
		//----------------------------------
		//  getDockedApplicationControlBarCount
		//----------------------------------
		/* this method is written to get the docked application control bars separately
		as they are not part of the numChildren and get childAt.
		but we need these objcts as part of them to get the event from these
		properly recorded
		*/
		private function getDockedApplicationControlBarCount():int
		{
			var dockedApplicationControlBars:int = 0;
			
			// number of docked application control bars
			// get its row children and see how many docked application control 
			// bars are present
			var n:int = application.rawChildren.numChildren;
			for (var i:int=0; i < n; i++)
			{
				var currentObject:Object = 
					application.rawChildren.getChildAt(i) as Object;
				if( currentObject)
				{
					if(currentObject.hasOwnProperty("dock"))
						if(currentObject.dock == true)
							dockedApplicationControlBars++;
				}
			}
			
			return dockedApplicationControlBars;
		}
		
		override public function get numAutomationChildren():int
		{
			
			var am:IAutomationManager2 = Automation.automationManager2;
			
			return application.numChildren + application.numRepeaters + 
				getDockedApplicationControlBarCount() +am.getPopUpChildrenCount();
		}
		
		override public function getAutomationChildren():Array
		{
			var am:IAutomationManager2 = Automation.automationManager2;
			
			// we need to add popup children
			var childList:Array = new Array();
			var tempChildren1:Array  = am.getPopUpChildren();
			var n:int = 0;
			var i:int = 0;	
			
			if(tempChildren1)
			{
				n = tempChildren1.length;
				for (i = 0; i < n ; i++)
					childList.push(tempChildren1[i]);
			}
			
			
			// get the 	 DockedApplicationBarControl details
			var tempChildren:Array  = getDockedControlBarChildren();
			if(tempChildren)
			{
				n = tempChildren.length;
				for ( i = 0; i < n ; i++)
				{
					childList.push(tempChildren[i]);
				}
			}
			
			
			n = application.numChildren;
			for (i = 0; i < n ; i++)
			{
				childList.push(application.getChildAt(i));
			}
			
			tempChildren  =   application.childRepeaters;
			if (tempChildren)
			{
				n = tempChildren.length;
				for (i = 0; i < n ; i++)
				{
					childList.push(tempChildren[i]);
				}
			}
			
			return childList;
		}
		
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			var am:IAutomationManager2 = Automation.automationManager2;
			// handle popup objects
			var popUpCount:int = am.getPopUpChildrenCount();
			if (index < popUpCount)
				return am.getPopUpChildObject(index) ;
			else
				index = index - popUpCount;
			
			// get the 	 DockedApplicationControl details
			var dockedApplicationBarNumbers:int = getDockedApplicationControlBarCount();
			if (index < dockedApplicationBarNumbers)
				return (getDockedControlBar(index) as IAutomationObject);
			else
				index = index - dockedApplicationBarNumbers ;
			
			
			if (index < application.numChildren)
			{
				var d:Object = application.getChildAt(index);
				return d as IAutomationObject;
			}   
			
			var r:Object = application.childRepeaters[index - application.numChildren];
			return r as IAutomationObject;
		}
		
		override public function numGenieAutomationChildren():int
		{
			
			var am:IAutomationManager2 = Automation.automationManager2;
			
			var count:int = 0;
			count = application.numChildren;
			if(application.hasOwnProperty("numRepeaters"))
			{
				count += application.numRepeaters;
			}
			
			count += getDockedApplicationControlBarCount();
			count += am.getPopUpChildrenCount();
			return count;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			var am:IAutomationManager2 = Automation.automationManager2;
			// handle popup objects
			var popUpCount:int = am.getPopUpChildrenCount();
			if (index < popUpCount)
				return am.getPopUpChildObject(index) ;
			else
				index = index - popUpCount;
			
			// get the 	 DockedApplicationControl details
			var dockedApplicationBarNumbers:int = getDockedApplicationControlBarCount();
			if (index < dockedApplicationBarNumbers)
				return (getDockedControlBar(index) as Object);
			else
				index = index - dockedApplicationBarNumbers ;
			
			
			if (index < application.numChildren)
			{
				var d:Object = application.getChildAt(index);
				return d as Object;
			}   
			
			var r:Object = application.childRepeaters[index - application.numChildren];
			return r as Object;
		}
	}
	
}