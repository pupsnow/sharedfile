package com.esri.ags.events
{
    import flash.events.*;

    final public class FormFieldEvent extends Event
    {
        public static const RENDERER_CHANGE:String = "rendererChange";
        public static const DATA_CHANGE:String = "dataChange";

        public function FormFieldEvent(type:String)
        {
            super(type, false, false);
            return;
        }// end function

        override public function clone() : Event
        {
            return new FormFieldEvent(type);
        }// end function

    }
}
