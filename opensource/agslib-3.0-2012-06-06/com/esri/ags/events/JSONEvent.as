package com.esri.ags.events
{
    import flash.events.*;

    public class JSONEvent extends Event
    {
        public var json:Object;
        public static const EXECUTE_COMPLETE:String = "executeComplete";

        public function JSONEvent(type:String, json:Object)
        {
            super(type);
            this.json = json;
            return;
        }// end function

        override public function clone() : Event
        {
            return new JSONEvent(type, this.json);
        }// end function

        override public function toString() : String
        {
            return formatToString("JSONEvent", "type", "json");
        }// end function

    }
}
