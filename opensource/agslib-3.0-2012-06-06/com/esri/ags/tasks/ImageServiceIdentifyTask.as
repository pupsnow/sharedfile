package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class ImageServiceIdentifyTask extends BaseTask
    {
        private var _2143403096executeLastResult:ImageServiceIdentifyResult;

        public function ImageServiceIdentifyTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function execute(imageServiceIdentifyParameters:ImageServiceIdentifyParameters, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var imageServiceIdentifyParameters:* = imageServiceIdentifyParameters;
            var responder:* = responder;
            var generateUrlVariables:* = function (geometry:Geometry = null) : void
            {
                var _loc_2:* = new URLVariables();
                _loc_2.f = "json";
                if (geometry)
                {
                    _loc_2.geometryType = geometry.type;
                    _loc_2.geometry = JSONUtil.encode(geometry);
                }
                if (imageServiceIdentifyParameters.mosaicRule)
                {
                    _loc_2.mosaicRule = JSONUtil.encode(imageServiceIdentifyParameters.mosaicRule);
                }
                if (!isNaN(imageServiceIdentifyParameters.pixelSizeX))
                {
                }
                if (!isNaN(imageServiceIdentifyParameters.pixelSizeY))
                {
                    _loc_2.pixelSize = imageServiceIdentifyParameters.pixelSizeX + "," + imageServiceIdentifyParameters.pixelSizeY;
                }
                asyncToken = sendURLVariables2("/identify", _loc_2, handleDecodedObject, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, imageServiceIdentifyParameters);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (imageServiceIdentifyParameters.geometry)
            {
                if (autoNormalize)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                generateUrlVariables((item as Array)[0] as Geometry);
                return;
            }// end function
            ;
                    var faultHandler:* = function (fault:Fault, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.fault(fault);
                }
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
                return;
            }// end function
            ;
                    GeometryUtil.normalizeCentralMeridian([imageServiceIdentifyParameters.geometry], GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultHandler, asyncToken));
                }
                else
                {
                    this.generateUrlVariables(imageServiceIdentifyParameters.geometry);
                }
            }
            else
            {
                this.generateUrlVariables();
            }
            return asyncToken;
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_3:* = ImageServiceIdentifyResult.toImageServiceIdentifyResult(decodedObject);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, _loc_3);
            }
            this.executeLastResult = _loc_3;
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.executeLastResult);
            }
            dispatchEvent(new ImageServiceIdentifyEvent(ImageServiceIdentifyEvent.EXECUTE_COMPLETE, this.executeLastResult));
            return;
        }// end function

        public function get executeLastResult() : ImageServiceIdentifyResult
        {
            return this._2143403096executeLastResult;
        }// end function

        public function set executeLastResult(value:ImageServiceIdentifyResult) : void
        {
            arguments = this._2143403096executeLastResult;
            if (arguments !== value)
            {
                this._2143403096executeLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
