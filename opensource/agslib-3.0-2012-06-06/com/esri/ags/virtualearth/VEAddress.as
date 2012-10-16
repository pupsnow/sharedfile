package com.esri.ags.virtualearth
{
    import flash.events.*;

    public class VEAddress extends EventDispatcher
    {
        private var _addressLine:String;
        private var _adminDistrict:String;
        private var _countryRegion:String;
        private var _district:String;
        private var _formattedAddress:String;
        private var _locality:String;
        private var _postalCode:String;

        public function VEAddress()
        {
            return;
        }// end function

        public function get addressLine() : String
        {
            return this._addressLine;
        }// end function

        public function set addressLine(value:String) : void
        {
            if (this._addressLine !== value)
            {
                this._addressLine = value;
                dispatchEvent(new Event("addressLineChanged"));
            }
            return;
        }// end function

        public function get adminDistrict() : String
        {
            return this._adminDistrict;
        }// end function

        public function set adminDistrict(value:String) : void
        {
            if (this._adminDistrict !== value)
            {
                this._adminDistrict = value;
                dispatchEvent(new Event("adminDistrictChanged"));
            }
            return;
        }// end function

        public function get countryRegion() : String
        {
            return this._countryRegion;
        }// end function

        public function set countryRegion(value:String) : void
        {
            if (this._countryRegion !== value)
            {
                this._countryRegion = value;
                dispatchEvent(new Event("countryRegionChanged"));
            }
            return;
        }// end function

        public function get district() : String
        {
            return this._district;
        }// end function

        public function set district(value:String) : void
        {
            if (this._district !== value)
            {
                this._district = value;
                dispatchEvent(new Event("districtChanged"));
            }
            return;
        }// end function

        public function get formattedAddress() : String
        {
            return this._formattedAddress;
        }// end function

        public function set formattedAddress(value:String) : void
        {
            if (this._formattedAddress !== value)
            {
                this._formattedAddress = value;
                dispatchEvent(new Event("formattedAddressChanged"));
            }
            return;
        }// end function

        public function get locality() : String
        {
            return this._locality;
        }// end function

        public function set locality(value:String) : void
        {
            if (this._locality !== value)
            {
                this._locality = value;
                dispatchEvent(new Event("localityChanged"));
            }
            return;
        }// end function

        public function get postalCode() : String
        {
            return this._postalCode;
        }// end function

        public function set postalCode(value:String) : void
        {
            if (this._postalCode !== value)
            {
                this._postalCode = value;
                dispatchEvent(new Event("postalCodeChanged"));
            }
            return;
        }// end function

        static function toVEAddress(obj:Object) : VEAddress
        {
            var _loc_2:VEAddress = null;
            if (obj)
            {
                _loc_2 = new VEAddress;
                _loc_2.addressLine = obj.addressLine;
                _loc_2.adminDistrict = obj.adminDistrict;
                _loc_2.countryRegion = obj.countryRegion;
                _loc_2.district = obj.adminDistrict2;
                _loc_2.formattedAddress = obj.formattedAddress;
                _loc_2.locality = obj.locality;
                _loc_2.postalCode = obj.postalCode;
            }
            return _loc_2;
        }// end function

    }
}
