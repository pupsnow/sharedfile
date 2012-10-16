package com.esri.ags.events
{
    import flash.events.*;

    public class InfoPlacementEvent extends Event
    {
        public var infoPlacement:String = "upperRight";
        public static const INFO_PLACEMENT:String = "infoPlacement";

        public function InfoPlacementEvent(infoPlacement:String = "upperRight")
        {
            super(INFO_PLACEMENT, true);
            this.infoPlacement = infoPlacement;
            return;
        }// end function

        override public function clone() : Event
        {
            return new InfoPlacementEvent(this.infoPlacement);
        }// end function

    }
}
