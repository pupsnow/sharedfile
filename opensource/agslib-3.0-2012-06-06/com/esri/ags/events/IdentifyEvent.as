package com.esri.ags.events
{
    import flash.events.*;

    public class IdentifyEvent extends Event
    {
        public var identifyResults:Array;
        public static const EXECUTE_COMPLETE:String = "executeComplete";

        public function IdentifyEvent(type:String, identifyResults:Array = null)
        {
            super(type);
            this.identifyResults = identifyResults;
            return;
        }// end function

        override public function clone() : Event
        {
            return new IdentifyEvent(type, this.identifyResults);
        }// end function

        override public function toString() : String
        {
            return formatToString("IdentifyEvent", "type", "identifyResults");
        }// end function

    }
}
