package com.esri.ags.events
{
    import com.esri.ags.geometry.*;
    import flash.events.*;

    public class ZoomEvent extends Event
    {
        public var extent:Extent;
        public var zoomFactor:Number;
        public var level:Number = -1;
        var x:Number;
        var y:Number;
        var width:Number;
        var height:Number;
        public static const ZOOM_START:String = "zoomStart";
        public static const ZOOM_UPDATE:String = "zoomUpdate";
        public static const ZOOM_END:String = "zoomEnd";

        public function ZoomEvent(type:String, extent:Extent = null, zoomFactor:Number = 1, level:Number = -1)
        {
            super(type);
            this.extent = extent;
            this.zoomFactor = zoomFactor;
            this.level = level;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new ZoomEvent(type, this.extent, this.zoomFactor, this.level);
            _loc_1.x = this.x;
            _loc_1.y = this.y;
            _loc_1.width = this.width;
            _loc_1.height = this.height;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("ZoomEvent", "type", "extent", "zoomFactor", "level");
        }// end function

    }
}
