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
	import flash.events.MouseEvent;
	
	import mx.automation.Automation;
	import mx.automation.AutomationClass;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.automation.events.AutomationReplayEvent;
	import mx.containers.DividedBox;
	import mx.core.mx_internal;
	import mx.events.DividerEvent;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  DividedBox class. 
	 * 
	 *  @see mx.containers.DividedBox
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class DividedBoxAutomationImpl extends ContainerAutomationImpl 
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
			Automation.registerDelegateClass(DividedBox, DividedBoxAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj DividedBox object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function DividedBoxAutomationImpl(obj:Object)
		{
			super(obj);
			
			obj.addEventListener(DividerEvent.DIVIDER_RELEASE,recordAutomatableEvent, false, 0, true);
					
			
			
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get dBox():Object
		{
			return uiComponent as Object;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Replay methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Replays <code>DIVIDER_RELEASE</code> events by dispatching 
		 *  a <code>DIVIDER_PRESS</code> event, moving the divider in question,
		 *  and dispatching a <code>DIVIDER_RELEASE</code> event.
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
			if(interaction is AutomationReplayEvent)
			{
				uiComponent = (interaction as Object).automationObject;
				interaction = (interaction as Object).replayableEvent;
			}
						
			if (interaction is DividerEvent)
			{
				//var dividerEventClass:Object = Automation.AppSystemManager().loaderInfo.applicationDomain.getDefinition("mx.events::DividerEvent");
				var dividerEventClass:Object = uiComponent.loaderInfo.applicationDomain.getDefinition("mx.events::DividerEvent");
				if(dividerEventClass == null)
					dividerEventClass = Automation.AppSystemManager().loaderInfo.applicationDomain.getDefinition("mx.events::DividerEvent");
				if(dividerEventClass == null)
					dividerEventClass = mx.events.DividerEvent;
				
				
				var dividerInteraction:DividerEvent = DividerEvent(interaction);
				// dispatch a pressed event (in case anyone was listening)
							
				var pressedEvent:Object = 
					new dividerEventClass(DividerEvent.DIVIDER_PRESS);
				pressedEvent.dividerIndex = dividerInteraction.dividerIndex;
				dBox.dispatchEvent(pressedEvent);
				
				
				
				// dispatch a dragged event (in case anyone was listening)
				var draggedEvent:Object = 
					new dividerEventClass(DividerEvent.DIVIDER_DRAG);
				draggedEvent.dividerIndex = dividerInteraction.dividerIndex;
				draggedEvent.delta = dividerInteraction.delta;
				dBox.dispatchEvent(draggedEvent);
				
								
				// move the divider
				dBox.moveDivider(dividerInteraction.dividerIndex,
					dividerInteraction.delta);
			
				
				dBox.validateNow();
				// dispatch a released event (the same one that was recorded)
				var releaseEvent:Object = 
					new dividerEventClass(DividerEvent.DIVIDER_RELEASE);
				
				releaseEvent.dividerIndex = dividerInteraction.dividerIndex;			
				releaseEvent.delta = dividerInteraction.delta;
				
				dBox.dispatchEvent(releaseEvent);
				
				return true;
			}
			return super.replayAutomatableEvent(interaction);
		}
		
	}
	
}
