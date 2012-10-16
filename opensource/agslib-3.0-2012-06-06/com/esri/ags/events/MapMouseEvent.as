package com.esri.ags.events
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;

    public class MapMouseEvent extends MouseEvent
    {
        private var _originalMouseEvent:MouseEvent;
        public var map:Map;
        public var mapPoint:MapPoint;
        public static const MAP_CLICK:String = "mapClick";
        public static const MAP_MOUSE_DOWN:String = "mapMouseDown";

        public function MapMouseEvent(type:String, map:Map, mapPoint:MapPoint)
        {
            super(type, true);
            this.map = map;
            this.mapPoint = mapPoint;
            return;
        }// end function

        override public function get stageX() : Number
        {
            return this._originalMouseEvent.stageX;
        }// end function

        override public function get stageY() : Number
        {
            return this._originalMouseEvent.stageY;
        }// end function

        function get originalTarget() : Object
        {
            return this._originalMouseEvent.target;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new MapMouseEvent(type, this.map, this.mapPoint);
            _loc_1.setMouseEventProperties(this._originalMouseEvent);
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("MapMouseEvent", "type", "map", "mapPoint", "localX", "localY", "stageX", "stageY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "delta");
        }// end function

        function setMouseEventProperties(event:MouseEvent) : void
        {
            localX = event.localX;
            localY = event.localY;
            relatedObject = event.relatedObject;
            ctrlKey = event.ctrlKey;
            altKey = event.altKey;
            shiftKey = event.shiftKey;
            buttonDown = event.buttonDown;
            delta = event.delta;
            this._originalMouseEvent = event;
            return;
        }// end function

    }
}
