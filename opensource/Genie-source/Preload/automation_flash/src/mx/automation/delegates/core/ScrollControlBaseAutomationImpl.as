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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.events.AutomationReplayEvent;
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.EventPriority;
	import mx.core.ScrollControlBase;
	import mx.core.mx_internal;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;
	import mx.events.ScrollEventDirection;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  ScrollControlBase class. 
	 * 
	 *  @see mx.core.ScrollControlBase
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class ScrollControlBaseAutomationImpl extends UIComponentAutomationImpl 
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
			Automation.registerDelegateClass(ScrollControlBase, ScrollControlBaseAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor.
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj ScrollControlBase object to be automated.         
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ScrollControlBaseAutomationImpl(obj:Object)
		{
			super(obj);
			
			obj.addEventListener(Event.ADDED, childAddedHandler, false, 0, true);
			obj.addEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler, false, EventPriority.DEFAULT+1, true);
						
			addScrollRecordHandlers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function get sBase():Object
		{
			return uiComponent as Object;
		}
		
		//--------------------------------------------------------------------------
		//  Overridden Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Replays ScrollEvents. ScrollEvents are replayed
		 * by calling ScrollBar.scrollIt on the appropriate (horizontal or vertical)
		 * scrollBar.
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
		override public function replayAutomatableEvent(ev:Event):Boolean
		{
			var event:Event = null;
			if(ev is AutomationReplayEvent)
			{
				event = (AutomationReplayEvent)(ev).replayableEvent;
			}
			else
				event = ev;
			
			if (event is ScrollEvent)
			{
				var se:ScrollEvent = ScrollEvent(event);
				
				var position:Number = se.position;
				var direction:String = se.direction;
				var delegate:Object;
				
				
				switch (direction)
				{
					case ScrollEventDirection.VERTICAL:
					{
						if (!(sBase.scroll_verticalScrollBar && sBase.scroll_verticalScrollBar.enabled))
							return false;
						delegate = Automation.getDelegate(sBase.scroll_verticalScrollBar);
						delegate.replayAutomatableEvent(event);
						break;
					}
						
					case ScrollEventDirection.HORIZONTAL:
					{
						if (!(sBase.scroll_horizontalScrollBar && sBase.scroll_horizontalScrollBar.enabled))
							return false;
						//                  sBase.horizontalScrollPosition = position;
						Automation.getDelegate(sBase.scroll_horizontalScrollBar);
						delegate.replayAutomatableEvent(event);
						break;
					}
						
					default:
					{
						return false;
					}
				}
				return true;
			}
			else if (event is MouseEvent && event.type == MouseEvent.MOUSE_WHEEL)
			{
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				help.replayMouseEvent(uiComponent, event as MouseEvent);
				return true;
			}
			
			return super.replayAutomatableEvent(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function childAddedHandler(ev:Event):void
		{
			if(getQualifiedClassName(ev.target).indexOf("ScrollBar") > -1)
			{
				ev.target.addEventListener(AutomationRecordEvent.RECORD,
					scrollBar_recordHandler, false, 0, true);
			}
		}
		
		protected function addScrollRecordHandlers():void
		{
			try
			{
				//mx.controls.VScrollBar
				var objScroll:Object = new Object();
				//var scrollBar:Object = sBase.vScrollBar;
				var scrollBar:Object = sBase.scroll_verticalScrollBar;
				if(scrollBar)
				{
					//Register scrollbar
					Automation.getDelegate(scrollBar);
					scrollBar.addEventListener(AutomationRecordEvent.RECORD,
						scrollBar_recordHandler, false, 0, true);
				}
				scrollBar = sBase.scroll_horizontalScrollBar ;
				if(scrollBar)
				{
					Automation.getDelegate(scrollBar);
					scrollBar.addEventListener(AutomationRecordEvent.RECORD,
						scrollBar_recordHandler, false, 0, true);
				}
			}
			catch(e:Error)
			{
			}
		}
		
		/**
		 * @private
		 */
		private function mouseScrollHandler(event:MouseEvent):void
		{
			recordAutomatableEvent(event);
		}
		
		/**
		 *  @private
		 */
		private function scrollBar_recordHandler(event:AutomationRecordEvent):void
		{
			if (event.automationObject == sBase.scroll_verticalScrollBar ||
				event.automationObject == sBase.scroll_horizontalScrollBar)
			{
				//if (event.replayableEvent is ScrollEvent &&
					if (Object(event.replayableEvent).detail != ScrollEventDetail.THUMB_TRACK)
					recordAutomatableEvent(event.replayableEvent);
			}
		}
		
		override public function numGenieAutomationChildren():int
		{
			return 0;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			return null;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			return false;
		}
		
	}
}