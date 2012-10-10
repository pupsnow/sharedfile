package com.lhyx.event
{
	import flash.events.Event;
	
	public class EventBase extends Event
	{
		private var _eventMessage:String;
		
		public function EventBase(type:String, eventMessage:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._eventMessage = eventMessage;
		}

		public function get eventMessage():String
		{
			return _eventMessage;
		}

		public function set eventMessage(value:String):void
		{
			_eventMessage = value;
		}
	}
}