package com.esri.ags.events
{
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import flash.geom.*;

    public class PanEvent extends Event
    {
        public var extent:Extent;
        public var point:Point;
        public static const PAN_START:String = "panStart";
        public static const PAN_UPDATE:String = "panUpdate";
        public static const PAN_END:String = "panEnd";

        public function PanEvent(type:String, extent:Extent = null, point:Point = null)
        {
            super(type);
            this.extent = extent;
            this.point = point;
            return;
        }// end function

        override public function clone() : Event
        {
            return new PanEvent(type, this.extent, this.point);
        }// end function

        override public function toString() : String
        {
            return formatToString("PanEvent", "type", "extent", "point");
        }// end function

    }
}
