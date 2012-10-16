package com.esri.ags.events
{
    import flash.events.*;

    public class VEGeocoderEvent extends Event
    {
        public var results:Array;
        public static const ADDRESS_TO_LOCATIONS_COMPLETE:String = "addressToLocationsComplete";

        public function VEGeocoderEvent(type:String, results:Array)
        {
            super(type);
            this.results = results;
            return;
        }// end function

        override public function clone() : Event
        {
            return new VEGeocoderEvent(type, this.results);
        }// end function

        override public function toString() : String
        {
            return formatToString("VEGeocoderEvent", "type", "results");
        }// end function

    }
}
