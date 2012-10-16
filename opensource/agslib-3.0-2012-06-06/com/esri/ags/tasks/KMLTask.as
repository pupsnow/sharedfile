package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class KMLTask extends BaseTask
    {
        private var _1897299539lastResult:KMLInfo;

        public function KMLTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function getKML(kmlUrl:String, model:String, outSpatialReference:SpatialReference, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getKML:{1}", id, url);
            }
            var _loc_5:* = new URLVariables();
            _loc_5.url = kmlUrl;
            _loc_5.model = model;
            if (outSpatialReference)
            {
                _loc_5.outSR = outSpatialReference.toSR();
            }
            return sendURLVariables("", _loc_5, responder, this.handleDecodedObject);
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            this.lastResult = KMLInfo.toKMLInfo(decodedObject);
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

        public function get lastResult() : KMLInfo
        {
            return this._1897299539lastResult;
        }// end function

        public function set lastResult(value:KMLInfo) : void
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
