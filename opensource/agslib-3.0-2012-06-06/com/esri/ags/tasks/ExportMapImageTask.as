package com.esri.ags.tasks
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class ExportMapImageTask extends BaseTask
    {
        private var _1896791419exportMapLastResult:MapImage;
        private var _855600198exportImageLastResult:MapImage;

        public function ExportMapImageTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function exportMap(imageParameters:ImageParameters, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, imageParameters);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            imageParameters.appendToURLVariables(_loc_3);
            return sendURLVariables("/export", _loc_3, responder, this.handleExportMap);
        }// end function

        private function handleExportMap(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_3:* = MapImage.toMapImage(decodedObject);
            this.appendToken(_loc_3);
            this.exportMapLastResult = _loc_3;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleExportMap:{1}", id, this.exportMapLastResult);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.exportMapLastResult);
            }
            return;
        }// end function

        public function exportImage(imageServiceParameters:ImageServiceParameters, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, imageServiceParameters);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            imageServiceParameters.appendToURLVariables(_loc_3);
            return sendURLVariables("/exportImage", _loc_3, responder, this.handleExportImage);
        }// end function

        private function handleExportImage(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_3:* = MapImage.toMapImage(decodedObject);
            this.appendToken(_loc_3);
            this.exportImageLastResult = _loc_3;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleExportImage:{1}", id, this.exportImageLastResult);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.exportImageLastResult);
            }
            return;
        }// end function

        private function appendToken(mapImage:MapImage) : void
        {
            if (mapImage)
            {
            }
            if (!mapImage.source)
            {
                return;
            }
            var _loc_2:* = IdentityManager.instance.findCredential(urlObj.path);
            if (_loc_2)
            {
            }
            if (!_loc_2.token)
            {
            }
            if (!this.token)
            {
                if (urlObj.query)
                {
                }
            }
            var _loc_3:* = urlObj.query.token;
            if (_loc_3)
            {
                if (mapImage.source is String)
                {
                    mapImage.source = mapImage.source + (mapImage.source.indexOf("?") === -1 ? ("?") : ("&"));
                    mapImage.source = mapImage.source + ("token=" + encodeURIComponent(_loc_3));
                }
            }
            return;
        }// end function

        public function get exportMapLastResult() : MapImage
        {
            return this._1896791419exportMapLastResult;
        }// end function

        public function set exportMapLastResult(value:MapImage) : void
        {
            arguments = this._1896791419exportMapLastResult;
            if (arguments !== value)
            {
                this._1896791419exportMapLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "exportMapLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get exportImageLastResult() : MapImage
        {
            return this._855600198exportImageLastResult;
        }// end function

        public function set exportImageLastResult(value:MapImage) : void
        {
            arguments = this._855600198exportImageLastResult;
            if (arguments !== value)
            {
                this._855600198exportImageLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "exportImageLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
