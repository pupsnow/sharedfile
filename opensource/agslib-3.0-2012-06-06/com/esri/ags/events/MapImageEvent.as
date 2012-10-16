package com.esri.ags.events
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class MapImageEvent extends Event
    {
        public var mapImage:MapImage;
        public static const EXPORT:String = "mapImageExport";

        public function MapImageEvent(type:String, mapImage:MapImage = null)
        {
            super(type);
            this.mapImage = mapImage;
            return;
        }// end function

        override public function clone() : Event
        {
            return new MapImageEvent(type, this.mapImage);
        }// end function

        override public function toString() : String
        {
            return formatToString("MapImageEvent", "type", "mapImage");
        }// end function

    }
}
