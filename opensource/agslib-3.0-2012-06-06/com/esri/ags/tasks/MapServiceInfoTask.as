package com.esri.ags.tasks
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class MapServiceInfoTask extends BaseTask
    {
        private var _1897299539lastResult:MapServiceInfo;

        public function MapServiceInfoTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function execute(responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, url);
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            return sendURLVariables("", _loc_2, responder, this.handleDecodedObject);
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            this.lastResult = MapServiceInfo.toMapServiceInfo(decodedObject);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, this.lastResult);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.lastResult);
            }
            return;
        }// end function

        public function get lastResult() : MapServiceInfo
        {
            return this._1897299539lastResult;
        }// end function

        public function set lastResult(value:MapServiceInfo) : void
        {
            arguments = this._1897299539lastResult;
            if (arguments !== value)
            {
                this._1897299539lastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
