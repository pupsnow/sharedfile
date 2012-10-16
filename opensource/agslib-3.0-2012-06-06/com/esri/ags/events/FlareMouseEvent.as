package com.esri.ags.events
{
    import com.esri.ags.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import flash.events.*;

    public class FlareMouseEvent extends MouseEvent
    {
        private var m_mouseEvent:MouseEvent;
        public var graphic:Graphic;
        public var cluster:Cluster;
        public static const FLARE_CLICK:String = "flareClick";
        public static const FLARE_OUT:String = "flareOut";
        public static const FLARE_OVER:String = "flareOver";

        public function FlareMouseEvent(type:String, cluster:Cluster, graphic:Graphic)
        {
            super(type, true);
            this.cluster = cluster;
            this.graphic = graphic;
            return;
        }// end function

        override public function get stageX() : Number
        {
            return this.m_mouseEvent.stageX;
        }// end function

        override public function get stageY() : Number
        {
            return this.m_mouseEvent.stageY;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new FlareMouseEvent(type, this.cluster, this.graphic);
            _loc_1.copyProperties(this.m_mouseEvent);
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("FlareMouseEvent", "type", "cluster", "graphic", "localX", "localY", "stageX", "stageY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "delta");
        }// end function

        function copyProperties(event:MouseEvent) : void
        {
            localX = event.localX;
            localY = event.localY;
            relatedObject = event.relatedObject;
            ctrlKey = event.ctrlKey;
            altKey = event.altKey;
            shiftKey = event.shiftKey;
            buttonDown = event.buttonDown;
            delta = event.delta;
            this.m_mouseEvent = event;
            return;
        }// end function

    }
}
