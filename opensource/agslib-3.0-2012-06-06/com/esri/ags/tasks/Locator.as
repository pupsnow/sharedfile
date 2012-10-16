package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class Locator extends BaseTask
    {
        private var _862780862addressToLocationsLastResult:Array;
        private var _1702910804addressesToLocationsLastResult:Array;
        private var _1228634569locationToAddressLastResult:AddressCandidate;
        private var _outSpatialReference:SpatialReference;

        public function Locator(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function get outSpatialReference() : SpatialReference
        {
            return this._outSpatialReference;
        }// end function

        public function set outSpatialReference(value:SpatialReference) : void
        {
            this._outSpatialReference = value;
            dispatchEvent(new Event("outSpatialReferenceChanged"));
            return;
        }// end function

        public function addressToLocations(parameters:AddressToLocationsParameters, responder:IResponder = null) : AsyncToken
        {
            var _loc_4:String = null;
            var _loc_5:Extent = null;
            if (Log.isDebug())
            {
                logger.debug("{0}::addressToLocations:{1}", id, ObjectUtil.toString(parameters));
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            for (_loc_4 in parameters.address)
            {
                
                _loc_3[_loc_4] = parameters.address[_loc_4];
            }
            _loc_3.outFields = parameters.outFields ? (parameters.outFields.join()) : ("");
            if (parameters.searchExtent)
            {
                _loc_5 = parameters.searchExtent;
                if (_loc_5.spatialReference)
                {
                }
                if (_loc_5.spatialReference.isWrappable())
                {
                    _loc_5 = _loc_5.normalize(true) as Extent;
                }
                _loc_3.searchExtent = JSONUtil.encode(_loc_5);
            }
            if (this.outSpatialReference)
            {
                _loc_3.outSR = this.outSpatialReference.toSR();
            }
            return sendURLVariables("/findAddressCandidates", _loc_3, responder, this.handleAddressCandidates);
        }// end function

        private function handleAddressCandidates(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_5:Object = null;
            var _loc_6:IResponder = null;
            var _loc_3:Array = [];
            var _loc_4:* = SpatialReference.fromJSON(decodedObject.spatialReference);
            for each (_loc_5 in decodedObject.candidates)
            {
                
                _loc_3.push(AddressCandidate.toAddressCandidte(_loc_5, _loc_4));
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleAddressCandidates:{1}", id, _loc_3);
            }
            this.addressToLocationsLastResult = _loc_3;
            for each (_loc_6 in asyncToken.responders)
            {
                
                _loc_6.result(_loc_3);
            }
            dispatchEvent(new LocatorEvent(LocatorEvent.ADDRESS_TO_LOCATIONS_COMPLETE, _loc_3));
            return;
        }// end function

        public function addressesToLocations(parameters:AddressToLocationsParameters, responder:IResponder = null) : AsyncToken
        {
            var _loc_5:Object = null;
            if (Log.isDebug())
            {
                logger.debug("{0}::addressesToLocations:{1}", id, ObjectUtil.toString(parameters));
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            var _loc_4:Array = [];
            for each (_loc_5 in parameters.addresses)
            {
                
                _loc_4.push({attributes:_loc_5});
            }
            _loc_3.addresses = JSONUtil.encode({records:_loc_4});
            if (this.outSpatialReference)
            {
                _loc_3.outSR = this.outSpatialReference.toSR();
            }
            return sendURLVariables("/geocodeAddresses", _loc_3, responder, this.handleAddressesCandidates);
        }// end function

        private function handleAddressesCandidates(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_5:Object = null;
            var _loc_6:IResponder = null;
            var _loc_3:Array = [];
            var _loc_4:* = SpatialReference.fromJSON(decodedObject.spatialReference);
            for each (_loc_5 in decodedObject.locations)
            {
                
                _loc_3.push(AddressCandidate.toAddressCandidte(_loc_5, _loc_4));
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleAddressesCandidates:{1}", id, _loc_3);
            }
            this.addressesToLocationsLastResult = _loc_3;
            for each (_loc_6 in asyncToken.responders)
            {
                
                _loc_6.result(_loc_3);
            }
            dispatchEvent(new LocatorEvent(LocatorEvent.ADDRESSES_TO_LOCATIONS_COMPLETE, _loc_3));
            return;
        }// end function

        public function locationToAddress(location:MapPoint, distance:Number = 0, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::locationToAddress:{1}:{2}", id, location, distance);
            }
            var _loc_4:* = new URLVariables();
            _loc_4.f = "json";
            _loc_4.location = autoNormalize ? (JSONUtil.encode(location.normalize())) : (JSONUtil.encode(location));
            if (!isNaN(distance))
            {
                _loc_4.distance = distance;
            }
            if (this.outSpatialReference)
            {
                _loc_4.outSR = this.outSpatialReference.toSR();
            }
            return sendURLVariables("/reverseGeocode", _loc_4, responder, this.handleAddressCandidate);
        }// end function

        private function handleAddressCandidate(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_3:* = AddressCandidate.toAddressCandidte(decodedObject);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleAddressCandidate:{1}", id, _loc_3);
            }
            this.locationToAddressLastResult = _loc_3;
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            dispatchEvent(new LocatorEvent(LocatorEvent.LOCATION_TO_ADDRESS_COMPLETE, null, _loc_3));
            return;
        }// end function

        public function get addressToLocationsLastResult() : Array
        {
            return this._862780862addressToLocationsLastResult;
        }// end function

        public function set addressToLocationsLastResult(value:Array) : void
        {
            arguments = this._862780862addressToLocationsLastResult;
            if (arguments !== value)
            {
                this._862780862addressToLocationsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addressToLocationsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get addressesToLocationsLastResult() : Array
        {
            return this._1702910804addressesToLocationsLastResult;
        }// end function

        public function set addressesToLocationsLastResult(value:Array) : void
        {
            arguments = this._1702910804addressesToLocationsLastResult;
            if (arguments !== value)
            {
                this._1702910804addressesToLocationsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addressesToLocationsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get locationToAddressLastResult() : AddressCandidate
        {
            return this._1228634569locationToAddressLastResult;
        }// end function

        public function set locationToAddressLastResult(value:AddressCandidate) : void
        {
            arguments = this._1228634569locationToAddressLastResult;
            if (arguments !== value)
            {
                this._1228634569locationToAddressLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "locationToAddressLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
