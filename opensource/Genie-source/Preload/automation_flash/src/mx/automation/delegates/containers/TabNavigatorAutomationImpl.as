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
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationTabularData;
	import mx.automation.events.AutomationRecordEvent;
	import mx.containers.TabNavigator;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  TabNavigator class. 
	 * 
	 *  @see mx.containers.TabNavigator
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class TabNavigatorAutomationImpl extends ViewStackAutomationImpl 
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
			Automation.registerDelegateClass(TabNavigator, TabNavigatorAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj TabNavigator object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function TabNavigatorAutomationImpl(obj:Object)
		{
			super(obj);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get tabNavigator():Object
		{
			return uiComponent as Object;         
		}
		
		/**
		 *  @private
		 */
		override public function get automationTabularData():Object
		{
			var delegate:Object = tabNavigator.getTabBar() as Object;
			
			return delegate.automationTabularData;
		}
		
		
		/**
		 *  Replays ItemClickEvents by dispatching a MouseEvent to the item that was
		 *  clicked.
		 *  
		 *  @param interaction The event to replay.
		 *  
		 *  @return <code>true</code> if the replay was successful. Otherwise, returns <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function replayAutomatableEvent(interaction:Event):Boolean
		{
			var replayer:Object = tabNavigator.getTabBar() as Object ;
			
			var compClass:Class;
			var delegateClass:Class;
			var c:Class;
			var delegate:Object;
			
			try
			{
				delegate = Automation.getDelegate(replayer);
				return delegate.replayAutomatableEvent(interaction);
			}
			catch(e:Error)
			{
				return false;
			}							
			
			return true;
			//return replayer.replayAutomatableEvent(interaction);
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
			tabNavigator.getTabBar().addEventListener(AutomationRecordEvent.RECORD,
				tabBar_recordHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 */
		private function tabBar_recordHandler(event:AutomationRecordEvent):void
		{
			recordAutomatableEvent(event.replayableEvent);
		}
		
	}
}