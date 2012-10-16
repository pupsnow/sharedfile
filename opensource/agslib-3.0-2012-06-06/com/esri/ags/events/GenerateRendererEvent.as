package com.esri.ags.events
{
    import com.esri.ags.renderers.*;
    import flash.events.*;

    public class GenerateRendererEvent extends Event
    {
        public var renderer:IRenderer;
        public static const EXECUTE_COMPLETE:String = "executeComplete";

        public function GenerateRendererEvent(type:String, renderer:IRenderer = null)
        {
            super(type);
            this.renderer = renderer;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GenerateRendererEvent(type, this.renderer);
        }// end function

        override public function toString() : String
        {
            return formatToString("GenerateRendererEvent", "type", "renderer");
        }// end function

    }
}
