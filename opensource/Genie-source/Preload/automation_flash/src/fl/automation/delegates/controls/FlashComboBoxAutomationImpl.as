//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package fl.automation.delegates.controls 
{
	import fl.automation.delegates.core.FlashUIComponentAutomationImpl;
	import fl.controls.ComboBox;
	import fl.controls.List;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.system.ApplicationDomain;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import mx.automation.Automation;
	import mx.automation.AutomationIDPart;
	import mx.automation.AutomationManager;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.events.AutomationReplayEvent;
	import mx.automation.events.ListItemSelectEvent;
	import mx.automation.events.TextSelectionEvent;
	import mx.core.EventPriority;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ScrollEvent;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  ComboBox control.
	 * 
	 *  @see mx.controls.ComboBox 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class FlashComboBoxAutomationImpl extends FlashUIComponentAutomationImpl
	{
		include "../../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private  
		 * Registers the delegate class for a component class with automation manager.
		 *  
		 *  @param root The SystemManger of the application.
		 */
		public static function init(root:Object):void
		{
			Automation.registerDelegateClass(ComboBox, FlashComboBoxAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @param obj The ComboBox to be automated.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function FlashComboBoxAutomationImpl(obj:Object)
		{
			super(obj);
			obj.addEventListener(Event.OPEN, openCloseHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get comboBox():Object
		{
			return uiComponent as Object;
		}
		
		/**
		 *  @private
		 *  Replays the event specified by the parameter if possible.
		 *
		 *  @param interaction The event to replay.
		 * 
		 *  @return Whether or not a replay was successful.
		 */
		override public function replayAutomatableEvent(event:Event):Boolean
		{
			var completeTime:Number;
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			var textReplayer:Object = comboBox.textField as Object;
			var aoDropDown:Object = comboBox.dropdown as Object;
			event = AutomationReplayEvent(event).replayableEvent;
			
			var delegate:Object;
			
			delegate = Automation.getDelegate(aoDropDown);
			if (event is ListItemSelectEvent)
			{
				var result:Boolean = delegate.replayAutomatableEvent(event);
				
				// selection closes the comboBox. 
				// We need to wait for the dropDown to close.
				if (result)
				{
					completeTime = getTimer() + comboBox.getStyle("closeDuration");
					
					help.addSynchronization(function():Boolean
					{
						return getTimer() >= completeTime;
					});
				}
				
				return result;
			}
			else if (event is KeyboardEvent)
			{
				var keyEvent:KeyboardEvent = event as KeyboardEvent;
				if (comboBox.getTextInput() && comboBox.editable)
				{
					if (keyEvent.keyCode == Keyboard.UP ||
						keyEvent.keyCode == Keyboard.DOWN ||
						keyEvent.keyCode == Keyboard.PAGE_UP ||
						keyEvent.keyCode == Keyboard.PAGE_DOWN)
						return help.replayKeyboardEvent(uiComponent, KeyboardEvent(event));
					else
						return textReplayer.replayAutomatableEvent(event);
				}
				else
				{
					// if comboBox is closing due to either selection or escape we need to wait
					// and sync up
					if (keyEvent.keyCode == Keyboard.ENTER || keyEvent.keyCode == Keyboard.ESCAPE)
					{
						completeTime = getTimer() + comboBox.getStyle("closeDuration");
						
						help.addSynchronization(function():Boolean
						{
							return getTimer() >= completeTime;
						});
					}
					return help.replayKeyboardEvent(uiComponent, KeyboardEvent(event));
				}
			}else if ((comboBox.textField != null) && (event is TextEvent || event is TextSelectionEvent) )
			{
				return textReplayer.replayAutomatableEvent(event);
			}
			else if (event is ScrollEvent)
			{
				return delegate.replayAutomatableEvent(event);
			}
			else 
			{
				var cbdEvent:Event = Event(event);
				if ((cbdEvent.type == Event.OPEN) ||(cbdEvent.type == Event.CLOSE))
				{
					var kbEvent:KeyboardEvent =
						new KeyboardEvent(KeyboardEvent.KEY_DOWN);
					kbEvent.keyCode =
						(cbdEvent.type == Event.OPEN
							? Keyboard.DOWN
							: Keyboard.UP);
					kbEvent.ctrlKey = true;
					help.replayKeyboardEvent(uiComponent, kbEvent);	
				}
				
				completeTime = getTimer() +
					comboBox.getStyle(cbdEvent.type == Event.OPEN ?
						"openDuration" :
						"closeDuration");
				
				help.addSynchronization(function():Boolean
				{
					return getTimer() >= completeTime;
				});
				
				return true;
			}
			
			
			return super.replayAutomatableEvent(event);
		}
		
		/**
		 *  @private
		 *  Provide a set of properties that identify the child within 
		 *  this container.  These values should not change during the
		 *  lifespan of the application.
		 *  
		 *  @param child the child for which to provide the id.
		 *  @return a set of properties describing the child which can
		 *          later be used to resolve the component.
		 */
		override public function createAutomationIDPart(child:IAutomationObject):Object
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			return  delegate.createAutomationIDPart(child);
		}
		
		/**
		 *  @private
		 */
		override public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			if(delegate)
				return delegate.createAutomationIDPartWithRequiredProperties(child,properties);
		
			return null;
		}
		
		/**;
		 *  @private
		 *
		 *  Resolve a child using the id provided.  The id is a set 
		 *  of properties as provided by createAutomationID.
		 *
		 *  @param criteria a set of properties describing the child.
		 *         The criteria can contain regular expression values
		 *         resulting in multiple children being matched.
		 *  @return the an array of children that matched the criteria
		 *          or <tt>null</tt> if no children could not be resolved.
		 */
		override public function resolveAutomationIDPart(criteria:Object):Array
		{
			try
			{
				var delegate:Object;
				
				delegate = Automation.getDelegate(comboBox.dropdown);
				return delegate.resolveAutomationIDPart(criteria);
			}
			catch(e:Error)
			{
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				return help ? help.helpResolveIDPart(comboBox.dropdown, criteria) : null;	
			}
			return null;
		}
		
		/** 
		 *  @private
		 *  Provides the automation object at the specified index.  This list
		 *  should not include any children that are composites.
		 *
		 *  @param index the index of the child to return
		 *  @return the child at the specified index.
		 */
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			return  delegate.getAutomationChildAt(index);
		}
		
		
		
		/**
		 * @private
		 */
		override public function getAutomationChildren():Array
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			
			return delegate.getAutomationChildren();
		}
		/**
		 *  @private
		 *  Provides the number of automation children this container has.
		 *  This sum should not include any composite children, though
		 *  it does include those children not signficant within the
		 *  automation hierarchy.
		 *
		 *  @return the number of automation children this container has.
		 */
		override public function get numAutomationChildren():int
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			return delegate.numAutomationChildren;
		}
		
		/**
		 *  @private
		 *  A matrix containing the automation values of all parts of the components.
		 *  Should be row-major (return value is an array of rows, each of which is
		 *  an array of "items").
		 *
		 *  @return A matrix containing the automation values of all parts of the components.
		 */
		override public function get automationTabularData():Object
		{
			var delegate:IAutomationObject = comboBox.dropdown as IAutomationObject;
			return  delegate.automationTabularData;
		}
		
		/**
		 * @private
		 */
		protected function setupEditHandler():void
		{
			var text:Object = comboBox.textField as Object;
			if (!text)
				return;
			
			// If comboBox is editable we setup a listener for the textInput control.
			if(comboBox.editable)
				text.addEventListener(KeyboardEvent.KEY_DOWN, 
					textKeyDownHandler, false, EventPriority.DEFAULT+1);
			else
				text.removeEventListener(KeyboardEvent.KEY_DOWN, 
					textKeyDownHandler, false);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function openCloseHandler(ev:Object):void
		{
			var textInput:Object = comboBox.textField as Object;
			var event:Event = Event(ev);
			//if (ev.triggerEvent)
			recordAutomatableEvent(event);
			if (ev.type == Event.OPEN)
			{
				comboBox.dropdown.addEventListener(AutomationRecordEvent.RECORD, 
					dropdown_recordHandler, false, 0, true);
			}
		}
		
		/**
		 *  @private
		 */
		private function dropdown_recordHandler(event:AutomationRecordEvent):void
		{
			var re:Event = event.replayableEvent;
			if ((re is ListItemSelectEvent || re is ScrollEvent)
				&& event.target is List )
				recordAutomatableEvent(event.replayableEvent, event.cacheable);
		}
		
		/**
		 * @private
		 * Keyboard events like up/down/page_up/page_down/enter are
		 * recorded here. They are not recorded by textInput control but
		 * we require them to be recorded.
		 */    
		private function textKeyDownHandler(event:KeyboardEvent):void
		{
			// we do not record key events with modifiers
			// open/close events with ctrl key are recorded seperately.
			if (event.ctrlKey)
				return;
			// record keys which are of used for navigation in the dropdown list
			if (event.keyCode == Keyboard.UP ||
				event.keyCode == Keyboard.DOWN ||
				event.keyCode == Keyboard.PAGE_UP ||
				event.keyCode == Keyboard.PAGE_DOWN ||
				event.keyCode == Keyboard.ESCAPE ||
				event.keyCode == Keyboard.ENTER)
				
				recordAutomatableEvent(event);
		}
		
		/**
		 * @private
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			// if editable we have a different keydown handler
			if (comboBox.editable)
				return;
			
			// we do not record key events with modifiers
			if (event.ctrlKey)
				return;
			
			if(event.target == comboBox && 
				event.keyCode != Keyboard.ENTER &&
				event.keyCode != Keyboard.SPACE)
				recordAutomatableEvent(event);
			
			super.keyDownHandler(event);
		}
		
		/**
		 * @private
		 */
		public function getItemsCount():int
		{
			if (comboBox.dataProvider)
				return comboBox.dataProvider.length;
			
			return 0;
		}
		
	}
}


