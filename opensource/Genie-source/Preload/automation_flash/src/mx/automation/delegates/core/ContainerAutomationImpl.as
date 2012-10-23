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
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.events.AutomationReplayEvent;
	import mx.containers.Tile;
	import mx.controls.VScrollBar;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.EventPriority;
	import mx.core.mx_internal;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;
	import mx.events.ScrollEventDirection;

	use namespace mx_internal;
	
	
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  Container class. 
	 * 
	 *  @see mx.core.Container
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class ContainerAutomationImpl extends UIComponentAutomationImpl
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
			Automation.registerDelegateClass(Container, ContainerAutomationImpl);
			Automation.registerDelegateClass(Tile, ContainerAutomationImpl);
		}   
		
		/**
		 *  Constructor.
		 * @param obj Container object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ContainerAutomationImpl(obj:Object)
		{
			super(obj);
			
			obj.addEventListener(ScrollEvent.SCROLL, scroll_eventHandler, false, 0, true);
			addMouseEvent(obj, MouseEvent.MOUSE_WHEEL, mouseWheelHandler,false, EventPriority.DEFAULT+1, true );
			
		}
		
		/**
		 *  @private
		 */
		private function get container():Object
		{
			return uiComponent as Object;
		}
		
		/**
		 *  @private
		 *  Holds the previous scroll event object. This is used to prevent recording
		 *  multiple scroll events.
		 */
		private var previousEvent:Object;
		
		/**
		 *  @private
		 *  Flag used to control recording of scroll events.
		 *  MouseWheel events are recorded as they are handled specially by the containers.
		 *  The scrollEvent generated doesnot contain proper information for playback. Hence
		 *  we record and playback mouseWheel events.
		 */
		private var skipScrollEvent:Boolean = false;
		
		//----------------------------------
		//  automationName
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationName():String
		{
			return container.label || super.automationName;
		}
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationValue():Array
		{
			if (container.label && container.label.length != 0)
				return [ container.label ];
			
			var result:Array = [];
			
			var childList:Array = getAutomationChildren();
			if(childList)
			{
				var n:int = childList.length;
				for (var i:int = 0; i < n; i++)
				{
					var child:IAutomationObject = childList[i];
					var x:Array = child.automationValue;
					if (x && x.length != 0)
						result.push(x);
				}
			}
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
		override public function replayAutomatableEvent(ev:Event):Boolean
		{
			var event:Event = (ev as AutomationReplayEvent).replayableEvent;
			var delegate:Object;
			
			if (event is ScrollEvent)
			{
				var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
				
				var se:ScrollEvent = ScrollEvent(event);
				
				var vReplayer:Object = (container.verticalScrollBar as Object);
				var hReplayer:Object = (container.horizontalScrollBar as Object);
				
				if (se.direction == ScrollEventDirection.VERTICAL && vReplayer)
				{
					delegate = Automation.getDelegate(vReplayer);
					delegate.replayAutomatableEvent(se);
					//vReplayer.replayAutomatableEvent(se);
				}	
				else if (se.direction == ScrollEventDirection.HORIZONTAL && hReplayer)
				{
					delegate = Automation.getDelegate(hReplayer);
					delegate.replayAutomatableEvent(se);
					//hReplayer.replayAutomatableEvent(se);
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
		
		/**
		 *  @private
		 */
		override public function createAutomationIDPart(child:IAutomationObject):Object
		{
			/*var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			return help.helpCreateIDPart(uiAutomationObject, child);*/
			return null;
		}
		
		/**
		 *  @private
		 */
		override public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object
		{
			/*var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			return help.helpCreateIDPartWithRequiredProperties(uiAutomationObject, child,properties);*/
			return null;
		}
		
		
		/**
		 *  @private
		 */
		override public function resolveAutomationIDPart(part:Object):Array
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			return help.helpResolveIDPart(uiAutomationObject, part);
		}
		
		
		
		
		/**
		 *  @private
		 */
		
		override public function get numAutomationChildren():int
		{
			return container.numChildren + container.numRepeaters ;
		}
		
		
		
		/**
		 *  @private
		 */
		
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			if (index < container.numChildren)
			{
				var d:Object = container.getChildAt(index);
				return d as IAutomationObject;
			}   
			
			var r:Object = container.childRepeaters[index - container.numChildren];
			return r as IAutomationObject;
		}
		
		/**
		 * @private
		 */
		override public function getAutomationChildren():Array
		{
			var childList:Array = new Array();
			var tempArray1:Array = container.getChildren();
			var n:int = 0;
			var i:int = 0;
			if (tempArray1)
			{
				n = tempArray1.length;
				for(i = 0; i < n ; i++)
				{
					childList.push(tempArray1[i]);
				}
			}
			
			
			
			// get repeaters
			var tempArray:Array = container.childRepeaters;
			if(tempArray)
			{
				n = tempArray.length;
				for(i = 0; i < n ; i++)
				{
					childList.push(tempArray[i] as Object);
					
				}
			}
			
			
			return childList;
		}
		
		//----------------------------------
		//  automationTabularData
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get automationTabularData():Object
		{
			//return new ContainerTabularData(uiAutomationObject);
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		public function scroll_eventHandler(ev:Event):void
		{
			// we skip recording a scroll event if a mouse wheel
			// event has been recorded
			var event:Object = ev;
			
			if (skipScrollEvent)
			{
				skipScrollEvent = false;
				return;
			}   
			if (event.detail == ScrollEventDetail.THUMB_TRACK)
				return;
			// the checks have been added to prevent multiple recording
			// of the same scroll event

			if (!previousEvent || (event.delta && previousEvent.delta != event.delta)  ||
				previousEvent.detail != event.detail ||
				previousEvent.direction != event.direction ||
				previousEvent.position != event.position ||
				previousEvent.type != event.type)
			{
				if(previousEvent != null)
				{
					if((previousEvent.detail == ScrollEventDetail.PAGE_DOWN || previousEvent.detail == ScrollEventDetail.PAGE_UP) && event.detail == ScrollEventDetail.THUMB_POSITION)
					{
						previousEvent = event;
						return;
					}
				}
				recordAutomatableEvent(ev);
				previousEvent = event.clone();
				
			}
			
			/*if (!previousEvent || (event.delta && previousEvent.delta != event.delta) ||
				previousEvent.detail != event.detail ||
				previousEvent.direction != event.direction ||
				previousEvent.position != event.position ||
				previousEvent.type != event.type)
			{
				recordAutomatableEvent(event);
				previousEvent = event.clone() as ScrollEvent;
			}*/
		}
		
		/**
		 *  @private
		 */
		private function mouseWheelHandler(event:MouseEvent):void
		{
			skipScrollEvent = true;
			//event.currentTarget == uiComponent is added because event.target always remains scrollthumb
			//wherever it should have been the uiComponent which is availabe from event.currenttarget.
			if (event.target == uiComponent)
			{   
				recordAutomatableEvent(event, true);
			}
		}
		//Get all the children of this component
		override public function numGenieAutomationChildren():int
		{
			return container.numChildren + container.numRepeaters ;
		}
		
		override public function getGenieAutomationChildAt(index:int):Object
		{
			if (index < container.numChildren)
			{
				var d:Object = container.getChildAt(index);
				return d;
			}   
			
			var r:Object = container.childRepeaters[index - container.numChildren];
			return r;
		}
		
		override public function isGenieAutomationChild(child:Object):Boolean
		{
			var retValue:Boolean = false;
			try{
				if(container.getChildIndex(child) > -1)
				{
					//Added check so that skin etc controls are not displayed.
					//if(Automation.getDelegate(child)!=null)
						retValue = true;
				}
				else
					retValue =  false;
			}catch(e:Error)
			{
				if(getQualifiedClassName(child) == "mx.controls::TabBar")
				{
					if(container.owns(child))
						retValue =  true;
					else
						retValue =  false;
				}
			}
			return retValue;
		}
		
		
	}
	
}