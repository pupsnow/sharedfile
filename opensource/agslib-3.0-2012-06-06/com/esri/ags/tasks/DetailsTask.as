package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class DetailsTask extends BaseTask
    {
        private var _1191199990getAllDetailsLastResult:AllDetails;
        private var _1370427430getLayerDetailsLastResult:LayerDetails;
        private var _1221283075getTableDetailsLastResult:TableDetails;

        public function DetailsTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        private function get isFeatureServer() : Boolean
        {
            var _loc_2:URL = null;
            var _loc_3:String = null;
            var _loc_1:Boolean = false;
            if (this.url)
            {
                _loc_2 = new URL(this.url);
                _loc_3 = _loc_2.path;
                if (_loc_3.indexOf("/FeatureServer/") != -1)
                {
                    _loc_1 = true;
                }
                else if (_loc_3.lastIndexOf("/FeatureServer") == _loc_3.length - 14)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1;
        }// end function

        public function getAllDetails(responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getAllDetails:{1}", id, url);
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            var _loc_3:* = sendURLVariables("/layers", _loc_2, responder, this.handleAllDetails);
            _loc_3["baseUrl"] = this.getProxiedURL();
            this.setUrlParams(_loc_3);
            return _loc_3;
        }// end function

        private function handleAllDetails(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:LayerDetails = null;
            this.getAllDetailsLastResult = AllDetails.toAllDetails(decodedObject);
            if (this.getAllDetailsLastResult)
            {
                _loc_4 = asyncToken["baseUrl"];
                _loc_5 = asyncToken["urlParams"];
                for each (_loc_6 in this.getAllDetailsLastResult.layersDetails)
                {
                    
                    if (_loc_6)
                    {
                        this.fixPictureSymbols(_loc_6, _loc_4 + "/" + _loc_6.id, _loc_5);
                    }
                }
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleAllDetails:{1}", id, this.getAllDetailsLastResult);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.getAllDetailsLastResult);
            }
            dispatchEvent(new DetailsEvent(DetailsEvent.GET_ALL_DETAILS_COMPLETE, this.getAllDetailsLastResult));
            return;
        }// end function

        public function getDetails(layerOrTableId:Number, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getDetails:{1}", id, url);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            var _loc_4:* = "/" + layerOrTableId;
            var _loc_5:* = sendURLVariables(_loc_4, _loc_3, responder, this.handleDetails);
            _loc_5["baseUrl"] = this.getProxiedURL() + _loc_4;
            this.setUrlParams(_loc_5);
            return _loc_5;
        }// end function

        function getLayerOrTableDetails(responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getLayerOrTableDetails:{1}", id, url);
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            var _loc_3:* = sendURLVariables(null, _loc_2, responder, this.handleDetails);
            _loc_3["baseUrl"] = this.getProxiedURL();
            this.setUrlParams(_loc_3);
            return _loc_3;
        }// end function

        public function getDynamicDetails(source:ILayerSource, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getDynamicDetails:{1}", id, url);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            _loc_3.layer = JSONUtil.encode({source:source});
            return sendURLVariables("/dynamicLayer", _loc_3, responder, this.handleDetails);
        }// end function

        function getSourceDetails(source:ILayerSource, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::getSourceDetails:{1}", id, url);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            _loc_3.layer = JSONUtil.encode({source:source});
            return sendURLVariables(null, _loc_3, responder, this.handleDetails);
        }// end function

        private function handleDetails(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:IResponder = null;
            var _loc_5:String = null;
            if (decodedObject)
            {
                if (decodedObject.type == "Table")
                {
                    if (this.isFeatureServer)
                    {
                        this.getTableDetailsLastResult = FeatureTableDetails.toFeatureTableDetails(decodedObject);
                    }
                    else
                    {
                        this.getTableDetailsLastResult = TableDetails.toTableDetails(decodedObject);
                    }
                    if (Log.isDebug())
                    {
                        logger.debug("{0}::handleDetails:{1}", id, this.getTableDetailsLastResult);
                    }
                    for each (_loc_3 in asyncToken.responders)
                    {
                        
                        _loc_3.result(this.getTableDetailsLastResult);
                    }
                    dispatchEvent(new DetailsEvent(DetailsEvent.GET_DETAILS_COMPLETE, null, null, this.getTableDetailsLastResult));
                }
                else
                {
                    if (this.isFeatureServer)
                    {
                        this.getLayerDetailsLastResult = FeatureLayerDetails.toFeatureLayerDetails(decodedObject);
                    }
                    else
                    {
                        this.getLayerDetailsLastResult = LayerDetails.toLayerDetails(decodedObject);
                    }
                    if (this.getLayerDetailsLastResult)
                    {
                        _loc_5 = asyncToken["baseUrl"];
                        if (_loc_5)
                        {
                            this.fixPictureSymbols(this.getLayerDetailsLastResult, _loc_5, asyncToken["urlParams"]);
                        }
                    }
                    if (Log.isDebug())
                    {
                        logger.debug("{0}::handleDetails:{1}", id, this.getLayerDetailsLastResult);
                    }
                    for each (_loc_4 in asyncToken.responders)
                    {
                        
                        _loc_4.result(this.getLayerDetailsLastResult);
                    }
                    dispatchEvent(new DetailsEvent(DetailsEvent.GET_DETAILS_COMPLETE, null, this.getLayerDetailsLastResult));
                }
            }
            return;
        }// end function

        private function getProxiedURL() : String
        {
            var _loc_1:String = null;
            var _loc_3:URL = null;
            var _loc_2:* = new URL(this.url);
            _loc_1 = _loc_2.path ? (_loc_2.path) : ("");
            if (this.proxyURL)
            {
                _loc_3 = new URL(this.proxyURL);
                _loc_1 = _loc_3.path + "?" + _loc_1;
            }
            return _loc_1;
        }// end function

        private function setUrlParams(asyncToken:AsyncToken) : void
        {
            var _loc_2:* = this.getURLandProxyParams();
            if (this.token)
            {
                _loc_2.token = this.token;
            }
            asyncToken["urlParams"] = _loc_2.toString();
            return;
        }// end function

        private function getURLandProxyParams() : URLVariables
        {
            var _loc_2:String = null;
            var _loc_4:URL = null;
            var _loc_1:* = new URLVariables();
            var _loc_3:* = new URL(this.url);
            for (_loc_2 in _loc_3.query)
            {
                
                _loc_1[_loc_2] = _loc_3.query[_loc_2];
            }
            if (this.proxyURL)
            {
                _loc_4 = new URL(this.proxyURL);
                if (_loc_4.query)
                {
                    for (_loc_2 in _loc_4.query)
                    {
                        
                        if (!_loc_1[_loc_2])
                        {
                            _loc_1[_loc_2] = _loc_4.query[_loc_2];
                        }
                    }
                }
            }
            return _loc_1;
        }// end function

        private function fixPictureSymbols(layerDetails:LayerDetails, baseURL:String, urlParams:String) : void
        {
            var _loc_5:Symbol = null;
            var _loc_6:IRenderer = null;
            var _loc_7:ClassBreaksRenderer = null;
            var _loc_8:ClassBreakInfo = null;
            var _loc_9:UniqueValueRenderer = null;
            var _loc_10:UniqueValueInfo = null;
            var _loc_11:PictureMarkerSymbol = null;
            var _loc_12:PictureFillSymbol = null;
            var _loc_4:Array = [];
            if (layerDetails.drawingInfo)
            {
            }
            if (layerDetails.drawingInfo.renderer)
            {
                _loc_6 = layerDetails.drawingInfo.renderer;
                if (_loc_6 is SimpleRenderer)
                {
                    _loc_4.push(SimpleRenderer(_loc_6).symbol);
                }
                else if (_loc_6 is ClassBreaksRenderer)
                {
                    _loc_7 = ClassBreaksRenderer(_loc_6);
                    _loc_4.push(_loc_7.defaultSymbol);
                    for each (_loc_8 in _loc_7.infos)
                    {
                        
                        _loc_4.push(_loc_8.symbol);
                    }
                }
                else if (_loc_6 is UniqueValueRenderer)
                {
                    _loc_9 = UniqueValueRenderer(_loc_6);
                    _loc_4.push(_loc_9.defaultSymbol);
                    for each (_loc_10 in _loc_9.infos)
                    {
                        
                        _loc_4.push(_loc_10.symbol);
                    }
                }
            }
            for each (_loc_5 in _loc_4)
            {
                
                if (_loc_5 is PictureMarkerSymbol)
                {
                    _loc_11 = PictureMarkerSymbol(_loc_5);
                    if (_loc_11.source is String)
                    {
                        _loc_11.source = this.fixPictureSymbolSource(_loc_11.source as String, baseURL, urlParams);
                    }
                    continue;
                }
                if (_loc_5 is PictureFillSymbol)
                {
                    _loc_12 = PictureFillSymbol(_loc_5);
                    if (_loc_12.source is String)
                    {
                        _loc_12.source = this.fixPictureSymbolSource(_loc_12.source as String, baseURL, urlParams);
                    }
                }
            }
            return;
        }// end function

        private function fixPictureSymbolSource(source:String, baseURL:String, urlParams:String) : String
        {
            var _loc_4:String = null;
            if (source.indexOf("http:") != 0)
            {
            }
            if (source.indexOf("https:") != 0)
            {
                _loc_4 = baseURL + "/images/" + source;
            }
            else
            {
                _loc_4 = source;
            }
            if (urlParams)
            {
                _loc_4 = _loc_4 + ("?" + urlParams);
            }
            return _loc_4;
        }// end function

        public function get getAllDetailsLastResult() : AllDetails
        {
            return this._1191199990getAllDetailsLastResult;
        }// end function

        public function set getAllDetailsLastResult(value:AllDetails) : void
        {
            arguments = this._1191199990getAllDetailsLastResult;
            if (arguments !== value)
            {
                this._1191199990getAllDetailsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getAllDetailsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get getLayerDetailsLastResult() : LayerDetails
        {
            return this._1370427430getLayerDetailsLastResult;
        }// end function

        public function set getLayerDetailsLastResult(value:LayerDetails) : void
        {
            arguments = this._1370427430getLayerDetailsLastResult;
            if (arguments !== value)
            {
                this._1370427430getLayerDetailsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getLayerDetailsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get getTableDetailsLastResult() : TableDetails
        {
            return this._1221283075getTableDetailsLastResult;
        }// end function

        public function set getTableDetailsLastResult(value:TableDetails) : void
        {
            arguments = this._1221283075getTableDetailsLastResult;
            if (arguments !== value)
            {
                this._1221283075getTableDetailsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getTableDetailsLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
