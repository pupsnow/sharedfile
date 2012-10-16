package com.esri.ags.events
{
    import flash.events.*;

    public class FindEvent extends Event
    {
        public var findResults:Array;
        public static const EXECUTE_COMPLETE:String = "executeComplete";

        public function FindEvent(type:String, findResults:Array = null)
        {
            super(type);
            this.findResults = findResults;
            return;
        }// end function

        override public function clone() : Event
        {
            return new FindEvent(type, this.findResults);
        }// end function

        override public function toString() : String
        {
            return formatToString("FindEvent", "type", "findResults");
        }// end function

    }
}
