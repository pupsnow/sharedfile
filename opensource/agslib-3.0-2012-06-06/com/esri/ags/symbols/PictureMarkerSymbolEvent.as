package com.esri.ags.symbols
{
    import flash.events.*;

    class PictureMarkerSymbolEvent extends Event
    {
        public static const COMPLETE:String = "Complete";

        function PictureMarkerSymbolEvent(type:String)
        {
            super(type);
            return;
        }// end function

        override public function clone() : Event
        {
            return new PictureMarkerSymbolEvent(type);
        }// end function

    }
}
