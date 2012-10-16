package com.esri.ags.virtualearth
{
    import com.esri.ags.events.*;
    import com.esri.ags.tasks.*;
    import flash.events.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.utils.*;

    class VEGeocoderTask extends BaseTask
    {
        private var _addressToLocationsLastResult:Array;
        public var culture:String = "en";
        public var key:String;
        private static const VE_URL:String = "http://dev.virtualearth.net/REST/v1";

        function VEGeocoderTask()
        {
            super(VE_URL);
            return;
        }// end function

        public function get addressToLocationsLastResult() : Array
        {
            return this._addressToLocationsLastResult;
        }// end function

        public function set addressToLocationsLastResult(value:Array) : void
        {
            this._addressToLocationsLastResult = value;
            dispatchEvent(new Event("addressToLocationsLastResultChanged"));
            return;
        }// end function

        public function addressToLocations(query:String, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::addressToLocations:{1}", id, query);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.q = query;
            if (this.culture)
            {
                _loc_3.c = this.culture;
            }
            _loc_3.ss = true;
            _loc_3.key = this.key;
            return sendURLVariables("/Locations", _loc_3, responder, this.handleAddressToLocations);
        }// end function

        private function handleAddressToLocations(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:Array = null;
            var _loc_4:IResponder = null;
            var _loc_5:Array = null;
            var _loc_6:Object = null;
            var _loc_7:Array = null;
            var _loc_8:Object = null;
            var _loc_9:String = null;
            var _loc_10:String = null;
            var _loc_11:Array = null;
            var _loc_12:String = null;
            var _loc_13:Fault = null;
            if (decodedObject.statusCode == 200)
            {
                _loc_3 = [];
                if (decodedObject.resourceSets is Array)
                {
                    _loc_5 = decodedObject.resourceSets as Array;
                    if (_loc_5.length > 0)
                    {
                        _loc_6 = _loc_5[0];
                        if (_loc_6.resources is Array)
                        {
                            _loc_7 = _loc_6.resources as Array;
                            for each (_loc_8 in _loc_7)
                            {
                                
                                _loc_3.push(VEGeocodeResult.toVEGeocodeResult(_loc_8));
                            }
                        }
                    }
                }
                if (Log.isDebug())
                {
                    logger.debug("{0}::handleAddressToLocations:{1}", id, ObjectUtil.toString(_loc_3));
                }
                this.addressToLocationsLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(_loc_3);
                }
                dispatchEvent(new VEGeocoderEvent(VEGeocoderEvent.ADDRESS_TO_LOCATIONS_COMPLETE, _loc_3));
            }
            else
            {
                _loc_9 = decodedObject.statusCode;
                _loc_10 = decodedObject.statusDescription;
                _loc_11 = decodedObject.errorDetails as Array;
                _loc_12 = _loc_11 ? (_loc_11.join("\n")) : ("");
                _loc_13 = new Fault(_loc_9, _loc_10, _loc_12);
                handleFault(_loc_13, asyncToken);
            }
            return;
        }// end function

    }
}
