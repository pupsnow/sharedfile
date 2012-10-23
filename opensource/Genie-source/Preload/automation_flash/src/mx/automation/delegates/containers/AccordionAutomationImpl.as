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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.automation.events.AutomationReplayEvent;
	import mx.containers.Accordion;
	import mx.controls.Button;
	import mx.core.EventPriority;
	import mx.core.mx_internal;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.IndexChangedEvent;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  Accordion class. 
	 * 
	 *  @see mx.containers.Accordion
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class AccordionAutomationImpl extends ContainerAutomationImpl 
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
			Automation.registerDelegateClass(Accordion, AccordionAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj Accordion object to be automated.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function AccordionAutomationImpl(obj:Object)
		{
			super(obj);
			
			obj.addEventListener(KeyboardEvent.KEY_DOWN, accordionKeyDownHandler, false, EventPriority.DEFAULT+1, true);
			
			obj.addEventListener(IndexChangedEvent.CHANGE, indexChangeHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get accr():Object
		{
			return uiComponent as Object;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Replays an <code>IndexChangedEvent</code> event by dispatching
		 * a <code>MouseEvent</code> to the header that was clicked.
		 *  
		 *  @param event The event to replay.
		 *  
		 *  @return <code>true</code> if the replay was successful. Otherwise, returns <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function replayAutomatableEvent(event:Event):Boolean
		{   
			
			if(event is AutomationReplayEvent)
			{
				uiComponent = (event as Object).automationObject;
				event = (event as Object).replayableEvent;
			}
			
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			var completeTime:Number = getTimer() + accr.getStyle("openDuration");
			
			if (event is IndexChangedEvent)
			{
				help.addSynchronization(function():Boolean
				{
					return getTimer() >= completeTime;
				});
				var ice:IndexChangedEvent = IndexChangedEvent(event);
				if(ice.relatedObject == null)
				{
					ice.relatedObject = accr.getChildAt(ice.newIndex);
				}
				var child:Object = ice.relatedObject;
				var header:Object = accr.getHeaderAt(accr.getChildIndex(child));
				var ao:Object = header as Object;
				var delegate:Object;
				delegate = Automation.getDelegate(header);
				
				return delegate.replayAutomatableEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else if (event is KeyboardEvent)
			{
				var keyEvent:KeyboardEvent = KeyboardEvent(event);
				
				if (keyEvent.keyCode == Keyboard.PAGE_UP ||
					keyEvent.keyCode == Keyboard.PAGE_DOWN ||
					keyEvent.keyCode == Keyboard.HOME ||
					keyEvent.keyCode == Keyboard.END ||
					keyEvent.keyCode == Keyboard.SPACE ||
					keyEvent.keyCode == Keyboard.ENTER)
				{               
					help.addSynchronization(function():Boolean
					{
						return getTimer() >= completeTime;
					});
				}
				return help.replayKeyboardEvent(uiComponent, keyEvent);
			}    
			else
			{
				return super.replayAutomatableEvent(event);
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function accordionKeyDownHandler(event:KeyboardEvent):void 
		{
			// Only listen for events that have come from the accordion itself.
			if (event.target != accr)
				return;
			
			switch (event.keyCode)
			{
				case Keyboard.DOWN:
				case Keyboard.RIGHT:
				case Keyboard.UP:
				case Keyboard.LEFT:
					recordAutomatableEvent(event);
					break;
			}
		}
		
		/**
		 *  @private
		 */
		private function indexChangeHandler(ev:Event):void
		{
			var event:Object = ev;
			if (event.triggerEvent is MouseEvent)
				recordAutomatableEvent(ev, false);
			else
				recordAutomatableEvent(event.triggerEvent, false);
		}
		
		
		/**
		 *  @private
		 *  Prevent duplicate ENTER key recordings. 
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			;
		}
		
	}
}