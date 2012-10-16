package com.esri.ags.events
{
    import flash.events.*;

    public class GraphicsLayerEvent extends Event
    {
        public static const GRAPHICS_CLEAR:String = "graphicsClear";

        public function GraphicsLayerEvent(type:String)
        {
            super(type);
            return;
        }// end function

        override public function clone() : Event
        {
            return new GraphicsLayerEvent(type);
        }// end function

        override public function toString() : String
        {
            return formatToString("GraphicsLayerEvent", "type");
        }// end function

    }
}
