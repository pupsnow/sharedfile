package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;

    public class GraphicEvent extends Event
    {
        public var graphic:Graphic;
        public static const GRAPHIC_ADD:String = "graphicAdd";
        public static const GRAPHIC_REMOVE:String = "graphicRemove";

        public function GraphicEvent(type:String, graphic:Graphic = null)
        {
            super(type);
            this.graphic = graphic;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GraphicEvent(type, this.graphic);
        }// end function

        override public function toString() : String
        {
            return formatToString("GraphicEvent", "type", "graphic");
        }// end function

    }
}
