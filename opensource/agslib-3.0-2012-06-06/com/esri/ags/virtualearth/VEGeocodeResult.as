package com.esri.ags.virtualearth
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;

    public class VEGeocodeResult extends EventDispatcher
    {
        private var _address:VEAddress;
        private var _bestView:Extent;
        private var _confidence:String;
        private var _displayName:String;
        private var _entityType:String;
        private var _location:MapPoint;

        public function VEGeocodeResult()
        {
            return;
        }// end function

        public function get address() : VEAddress
        {
            return this._address;
        }// end function

        public function set address(value:VEAddress) : void
        {
            this._address = value;
            dispatchEvent(new Event("addressChanged"));
            return;
        }// end function

        public function get bestView() : Extent
        {
            return this._bestView;
        }// end function

        public function set bestView(value:Extent) : void
        {
            this._bestView = value;
            dispatchEvent(new Event("bestViewChanged"));
            return;
        }// end function

        public function get confidence() : String
        {
            return this._confidence;
        }// end function

        public function set confidence(value:String) : void
        {
            if (this._confidence !== value)
            {
                this._confidence = value;
                dispatchEvent(new Event("confidenceChanged"));
            }
            return;
        }// end function

        public function get displayName() : String
        {
            return this._displayName;
        }// end function

        public function set displayName(value:String) : void
        {
            if (this._displayName !== value)
            {
                this._displayName = value;
                dispatchEvent(new Event("displayNameChanged"));
            }
            return;
        }// end function

        public function get entityType() : String
        {
            return this._entityType;
        }// end function

        public function set entityType(value:String) : void
        {
            if (this._entityType !== value)
            {
                this._entityType = value;
                dispatchEvent(new Event("entityTypeChanged"));
            }
            return;
        }// end function

        public function get location() : MapPoint
        {
            return this._location;
        }// end function

        public function set location(value:MapPoint) : void
        {
            this._location = value;
            dispatchEvent(new Event("locationChanged"));
            return;
        }// end function

        static function toVEGeocodeResult(obj:Object) : VEGeocodeResult
        {
            var _loc_2:VEGeocodeResult = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            if (obj)
            {
                _loc_2 = new VEGeocodeResult;
                _loc_2.address = VEAddress.toVEAddress(obj.address);
                if (obj.bbox is Array)
                {
                    _loc_3 = obj.bbox as Array;
                    if (_loc_3.length == 4)
                    {
                        _loc_2.bestView = new Extent();
                        _loc_2.bestView.xmin = _loc_3[1];
                        _loc_2.bestView.ymin = _loc_3[0];
                        _loc_2.bestView.xmax = _loc_3[3];
                        _loc_2.bestView.ymax = _loc_3[2];
                        _loc_2.bestView.spatialReference = new SpatialReference(4326);
                    }
                }
                _loc_2.confidence = obj.confidence;
                _loc_2.displayName = obj.name;
                _loc_2.entityType = obj.entityType;
                if (obj.point)
                {
                }
                if (obj.point.coordinates is Array)
                {
                    _loc_4 = obj.point.coordinates as Array;
                    if (_loc_4.length == 2)
                    {
                        _loc_2.location = new MapPoint();
                        _loc_2.location.x = _loc_4[1];
                        _loc_2.location.y = _loc_4[0];
                        _loc_2.location.spatialReference = new SpatialReference(4326);
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
