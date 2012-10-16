package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class AddressCandidate extends EventDispatcher
    {
        private var _1147692044address:Object;
        private var _405645655attributes:Object;
        private var _1901043637location:MapPoint;
        private var _109264530score:Number;

        public function AddressCandidate()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get address() : Object
        {
            return this._1147692044address;
        }// end function

        public function set address(value:Object) : void
        {
            arguments = this._1147692044address;
            if (arguments !== value)
            {
                this._1147692044address = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "address", arguments, value));
                }
            }
            return;
        }// end function

        public function get attributes() : Object
        {
            return this._405645655attributes;
        }// end function

        public function set attributes(value:Object) : void
        {
            arguments = this._405645655attributes;
            if (arguments !== value)
            {
                this._405645655attributes = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attributes", arguments, value));
                }
            }
            return;
        }// end function

        public function get location() : MapPoint
        {
            return this._1901043637location;
        }// end function

        public function set location(value:MapPoint) : void
        {
            arguments = this._1901043637location;
            if (arguments !== value)
            {
                this._1901043637location = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "location", arguments, value));
                }
            }
            return;
        }// end function

        public function get score() : Number
        {
            return this._109264530score;
        }// end function

        public function set score(value:Number) : void
        {
            arguments = this._109264530score;
            if (arguments !== value)
            {
                this._109264530score = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "score", arguments, value));
                }
            }
            return;
        }// end function

        static function toAddressCandidte(decodedObject:Object, outSpatialReference:SpatialReference = null) : AddressCandidate
        {
            var _loc_3:* = new AddressCandidate;
            _loc_3.address = decodedObject.address;
            _loc_3.location = MapPoint.fromJSON(decodedObject.location);
            if (_loc_3.location)
            {
            }
            if (!_loc_3.location.spatialReference)
            {
                _loc_3.location.spatialReference = outSpatialReference;
            }
            _loc_3.score = decodedObject.score;
            _loc_3.attributes = decodedObject.attributes;
            return _loc_3;
        }// end function

    }
}
