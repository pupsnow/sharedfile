package com.esri.ags.events
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class DetailsEvent extends Event
    {
        public var allDetails:AllDetails;
        public var layerDetails:LayerDetails;
        public var tableDetails:TableDetails;
        public static const GET_ALL_DETAILS_COMPLETE:String = "getAllDetailsComplete";
        public static const GET_DETAILS_COMPLETE:String = "getDetailsComplete";

        public function DetailsEvent(type:String, allDetails:AllDetails = null, layerDetails:LayerDetails = null, tableDetails:TableDetails = null)
        {
            super(type);
            this.allDetails = allDetails;
            this.layerDetails = layerDetails;
            this.tableDetails = tableDetails;
            return;
        }// end function

        override public function clone() : Event
        {
            return new DetailsEvent(type, this.allDetails, this.layerDetails, this.tableDetails);
        }// end function

        override public function toString() : String
        {
            return formatToString("DetailsEvent", "type", "allDetails", "layerDetails", "tableDetails");
        }// end function

    }
}
