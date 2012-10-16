package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;

    public class TimeExtentEvent extends Event
    {
        public var timeExtent:TimeExtent;
        public static const TIME_EXTENT_CHANGE:String = "timeExtentChange";

        public function TimeExtentEvent(timeExtent:TimeExtent)
        {
            super(TIME_EXTENT_CHANGE);
            this.timeExtent = timeExtent;
            return;
        }// end function

        override public function clone() : Event
        {
            return new TimeExtentEvent(this.timeExtent);
        }// end function

        override public function toString() : String
        {
            return formatToString("TimeExtentEvent", "type", "timeExtent");
        }// end function

    }
}
