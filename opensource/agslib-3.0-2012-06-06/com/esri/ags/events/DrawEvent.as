package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;

    public class DrawEvent extends Event
    {
        public var graphic:Graphic;
        public static const DRAW_END:String = "drawEnd";
        public static const DRAW_START:String = "drawStart";

        public function DrawEvent(type:String, graphic:Graphic = null)
        {
            super(type);
            this.graphic = graphic;
            return;
        }// end function

        override public function clone() : Event
        {
            return new DrawEvent(type, this.graphic);
        }// end function

        override public function toString() : String
        {
            return formatToString("DrawEvent", "type", "graphic");
        }// end function

    }
}
