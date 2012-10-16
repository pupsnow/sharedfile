package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class LocatorEvent extends Event
    {
        public var addressCandidates:Array;
        public var addressCandidate:AddressCandidate;
        public static const ADDRESS_TO_LOCATIONS_COMPLETE:String = "addressToLocationsComplete";
        public static const ADDRESSES_TO_LOCATIONS_COMPLETE:String = "addressesToLocationsComplete";
        public static const LOCATION_TO_ADDRESS_COMPLETE:String = "locationToAddressComplete";

        public function LocatorEvent(type:String, addressCandidates:Array = null, addressCandidate:AddressCandidate = null)
        {
            super(type);
            this.addressCandidates = addressCandidates;
            this.addressCandidate = addressCandidate;
            return;
        }// end function

        override public function clone() : Event
        {
            return new LocatorEvent(type, this.addressCandidates, this.addressCandidate);
        }// end function

        override public function toString() : String
        {
            return formatToString("LocatorEvent", "type", "addressCandidates", "addressCandidate");
        }// end function

    }
}
