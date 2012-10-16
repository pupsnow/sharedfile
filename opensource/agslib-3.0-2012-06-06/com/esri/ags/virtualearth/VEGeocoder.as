package com.esri.ags.virtualearth
{
    import com.esri.ags.events.*;
    import flash.events.*;
    import mx.events.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class VEGeocoder extends EventDispatcher implements IMXMLObject
    {
        private var _geoTask:VEGeocoderTask;

        public function VEGeocoder()
        {
            this._geoTask = new VEGeocoderTask();
            this._geoTask.addEventListener(FaultEvent.FAULT, this.geoTask_eventHandler, false, 0, true);
            this._geoTask.addEventListener(VEGeocoderEvent.ADDRESS_TO_LOCATIONS_COMPLETE, this.geoTask_eventHandler, false, 0, true);
            this._geoTask.addEventListener("addressToLocationsLastResultChanged", this.geoTask_eventHandler, false, 0, true);
            return;
        }// end function

        public function get addressToLocationsLastResult() : Array
        {
            return this._geoTask.addressToLocationsLastResult;
        }// end function

        public function set addressToLocationsLastResult(value:Array) : void
        {
            this._geoTask.addressToLocationsLastResult = value;
            return;
        }// end function

        public function get concurrency() : String
        {
            return this._geoTask.concurrency;
        }// end function

        private function set _1476186003concurrency(value:String) : void
        {
            this._geoTask.concurrency = value;
            return;
        }// end function

        public function get culture() : String
        {
            return this._geoTask.culture;
        }// end function

        private function set _1121473966culture(value:String) : void
        {
            this._geoTask.culture = value;
            return;
        }// end function

        public function get key() : String
        {
            return this._geoTask.key;
        }// end function

        private function set _106079key(value:String) : void
        {
            this._geoTask.key = value;
            return;
        }// end function

        public function get requestTimeout() : int
        {
            return this._geoTask.requestTimeout;
        }// end function

        private function set _1124910034requestTimeout(value:int) : void
        {
            this._geoTask.requestTimeout = value;
            return;
        }// end function

        public function get showBusyCursor() : Boolean
        {
            return this._geoTask.showBusyCursor;
        }// end function

        private function set _899935860showBusyCursor(value:Boolean) : void
        {
            this._geoTask.showBusyCursor = value;
            return;
        }// end function

        function get url() : String
        {
            return this._geoTask.url;
        }// end function

        function set url(value:String) : void
        {
            this._geoTask.url = value;
            return;
        }// end function

        public function addressToLocations(query:String, responder:IResponder = null) : AsyncToken
        {
            return this._geoTask.addressToLocations(query, responder);
        }// end function

        public function initialized(document:Object, id:String) : void
        {
            this._geoTask.initialized(document, id);
            return;
        }// end function

        private function geoTask_eventHandler(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function set requestTimeout(value:int) : void
        {
            arguments = this.requestTimeout;
            if (arguments !== value)
            {
                this._1124910034requestTimeout = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "requestTimeout", arguments, value));
                }
            }
            return;
        }// end function

        public function set showBusyCursor(value:Boolean) : void
        {
            arguments = this.showBusyCursor;
            if (arguments !== value)
            {
                this._899935860showBusyCursor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showBusyCursor", arguments, value));
                }
            }
            return;
        }// end function

        public function set concurrency(value:String) : void
        {
            arguments = this.concurrency;
            if (arguments !== value)
            {
                this._1476186003concurrency = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "concurrency", arguments, value));
                }
            }
            return;
        }// end function

        public function set key(value:String) : void
        {
            arguments = this.key;
            if (arguments !== value)
            {
                this._106079key = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "key", arguments, value));
                }
            }
            return;
        }// end function

        public function set culture(value:String) : void
        {
            arguments = this.culture;
            if (arguments !== value)
            {
                this._1121473966culture = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "culture", arguments, value));
                }
            }
            return;
        }// end function

    }
}
