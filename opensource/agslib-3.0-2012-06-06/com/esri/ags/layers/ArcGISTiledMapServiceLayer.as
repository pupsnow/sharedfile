package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;

    public class ArcGISTiledMapServiceLayer extends TiledMapServiceLayer implements ILegendSupport
    {
        private var _log:ILogger;
        private var _mapServiceInfo:MapServiceInfo;
        private var _legendUrl:String = "http://utility.arcgis.com/sharing/tools/legend";
        private var _maxScaleSet:Boolean;
        private var _minScaleSet:Boolean;
        var credential:Credential;
        private var _layerInfoWindowRenderers:Array;
        private var _proxyURLObj:URL;
        private var _requestTimeout:int = -1;
        private var _tileServers:Array;
        private var _tileServersSet:Boolean;
        private var _token:String;
        private var _urlChanged:Boolean;
        const urlObj:URL;

        public function ArcGISTiledMapServiceLayer(url:String = null, proxyURL:String = null, token:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._proxyURLObj = new URL();
            this.urlObj = new URL();
            this.url = url;
            this.proxyURL = proxyURL;
            this.token = token;
            if (FlexGlobals.topLevelApplication)
            {
                FlexGlobals.topLevelApplication.callLater(this.loadMapServiceInfoEarly);
            }
            return;
        }// end function

        override public function get fullExtent() : Extent
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.fullExtent) : (null);
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.initialExtent) : (null);
        }// end function

        override public function set maxScale(value:Number) : void
        {
            super.maxScale = value;
            this._maxScaleSet = true;
            return;
        }// end function

        override public function set minScale(value:Number) : void
        {
            super.minScale = value;
            this._minScaleSet = true;
            return;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.spatialReference) : (null);
        }// end function

        override public function get tileInfo() : TileInfo
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.tileInfo) : (null);
        }// end function

        public function get units() : String
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.units) : (Units.UNKNOWN_UNITS);
        }// end function

        public function get capabilities() : Array
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.capabilities) : (null);
        }// end function

        public function get copyright() : String
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.copyrightText) : (null);
        }// end function

        public function get description() : String
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.description) : (null);
        }// end function

        public function get layerInfos() : Array
        {
            return this._mapServiceInfo ? (ObjectUtil.copy(this._mapServiceInfo.layers) as Array) : (null);
        }// end function

        public function get layerInfoWindowRenderers() : Array
        {
            return this._layerInfoWindowRenderers;
        }// end function

        public function set layerInfoWindowRenderers(value:Array) : void
        {
            this._layerInfoWindowRenderers = value;
            dispatchEvent(new Event("layerInfoWindowRenderersChanged"));
            return;
        }// end function

        public function get maxRecordCount() : Number
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.maxRecordCount) : (NaN);
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURLObj.sourceURL;
        }// end function

        private function set _985186271proxyURL(value:String) : void
        {
            this._proxyURLObj.update(value);
            return;
        }// end function

        public function get requestTimeout() : int
        {
            return this._requestTimeout;
        }// end function

        public function set requestTimeout(value:int) : void
        {
            if (this._requestTimeout !== value)
            {
                this._requestTimeout = value;
                dispatchEvent(new Event("requestTimeoutChanged"));
            }
            return;
        }// end function

        public function get serviceDescription() : String
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.serviceDescription) : (null);
        }// end function

        public function get tableInfos() : Array
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.tables) : (null);
        }// end function

        public function get tileServers() : Array
        {
            return this._tileServers;
        }// end function

        public function set tileServers(value:Array) : void
        {
            this._tileServers = value;
            this._tileServersSet = true;
            dispatchEvent(new Event("tileServersChanged"));
            return;
        }// end function

        public function get timeInfo() : TimeInfo
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.timeInfo) : (null);
        }// end function

        public function get token() : String
        {
            return this._token;
        }// end function

        public function set token(value:String) : void
        {
            if (this._token !== value)
            {
                this._token = value;
                dispatchEvent(new Event("tokenChanged"));
            }
            return;
        }// end function

        public function get url() : String
        {
            return this.urlObj.sourceURL;
        }// end function

        public function set url(value:String) : void
        {
            if (this.url != value)
            {
            }
            if (value)
            {
                this.urlObj.update(value);
                this._urlChanged = true;
                invalidateProperties();
                this._mapServiceInfo = null;
                this.credential = null;
                setLoaded(false);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        public function get version() : Number
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.mapServiceVersion) : (NaN);
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this._urlChanged)
            {
                this._urlChanged = false;
                removeAllChildren();
                this.loadMapServiceInfo();
            }
            return;
        }// end function

        override protected function getTileURL(level:Number, row:Number, col:Number) : URLRequest
        {
            var _loc_4:* = "/tile/" + level + "/" + row + "/" + col;
            if (this._tileServers)
            {
            }
            var _loc_5:* = this._tileServers.length > 0 ? (this._tileServers[row % this._tileServers.length]) : (this.urlObj.path);
            var _loc_6:* = this.credential ? (this.credential.token) : (null);
            return AGSUtil.getURLRequest(this.urlObj, _loc_4, null, this.token, this._proxyURLObj, _loc_5, _loc_6);
        }// end function

        public function getAllDetails(responder:IResponder = null) : AsyncToken
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new DetailsEvent(DetailsEvent.GET_ALL_DETAILS_COMPLETE);
                _loc_2.allDetails = result as AllDetails;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            var task:* = new DetailsTask(this.url);
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            var asyncToken:* = task.getAllDetails(responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function getDetails(layerOrTableId:Number, responder:IResponder = null) : AsyncToken
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var layerOrTableId:* = layerOrTableId;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new DetailsEvent(DetailsEvent.GET_DETAILS_COMPLETE);
                _loc_2.layerDetails = result as LayerDetails;
                _loc_2.tableDetails = result as TableDetails;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            var task:* = new DetailsTask(this.url);
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            var asyncToken:* = task.getDetails(layerOrTableId, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function getLegendInfos(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:String = null;
            var _loc_3:Boolean = false;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            if (this.version >= 10.01)
            {
                _loc_2 = this.url;
            }
            else
            {
                _loc_3 = true;
                _loc_6 = this.url.toLowerCase().indexOf("/rest/");
                _loc_7 = this.url.substring(0, _loc_6) + this.url.substring(_loc_6 + 5, this.url.length);
                _loc_2 = this._legendUrl + "?soapUrl=" + _loc_7;
            }
            var _loc_4:* = new LegendTask(_loc_2);
            _loc_4.proxyURL = this.proxyURL;
            _loc_4.requestTimeout = this.requestTimeout;
            _loc_4.token = this.token;
            var _loc_5:* = _loc_4.getLegend(this, _loc_3, responder);
            return _loc_5;
        }// end function

        private function loadMapServiceInfo() : void
        {
            var thisLayer:ArcGISTiledMapServiceLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (result:Object, token:Object = null) : void
            {
                var _loc_3:Array = null;
                var _loc_4:String = null;
                var _loc_5:Boolean = false;
                var _loc_6:Boolean = false;
                var _loc_7:RegExp = null;
                var _loc_8:String = null;
                var _loc_9:ESRIError = null;
                if (token == url)
                {
                    _mapServiceInfo = result as MapServiceInfo;
                    if (_mapServiceInfo)
                    {
                        if (tileInfo)
                        {
                            credential = IdentityManager.instance.findCredential(urlObj.path);
                            if (!_maxScaleSet)
                            {
                                thisLayer.maxScale = _mapServiceInfo.maxScale;
                                _maxScaleSet = false;
                            }
                            if (!_minScaleSet)
                            {
                                thisLayer.minScale = _mapServiceInfo.minScale;
                                _minScaleSet = false;
                            }
                            if (!_tileServersSet)
                            {
                                if (_mapServiceInfo.rawObj.tileServers is Array)
                                {
                                    _loc_3 = _mapServiceInfo.rawObj.tileServers as Array;
                                    if (_loc_3)
                                    {
                                    }
                                    if (_loc_3.length > 0)
                                    {
                                        thisLayer.tileServers = _loc_3;
                                        _tileServersSet = false;
                                    }
                                }
                                else
                                {
                                    _loc_4 = urlObj.path;
                                    _loc_5 = _loc_4.search(/^https?:\/\/server\.arcgisonline\.com/i) !== -1;
                                    if (!_loc_5)
                                    {
                                    }
                                    _loc_6 = _loc_4.search(/^https?:\/\/services\.arcgisonline\.com/i) !== -1;
                                    if (!_loc_5)
                                    {
                                    }
                                    if (_loc_6)
                                    {
                                        _loc_7 = _loc_5 ? (/server\.arcgisonline/i) : (/services\.arcgisonline/i);
                                        _loc_8 = _loc_5 ? ("services.arcgisonline") : ("server.arcgisonline");
                                        thisLayer.tileServers = [_loc_4, _loc_4.replace(_loc_7, _loc_8)];
                                        _tileServersSet = false;
                                    }
                                }
                            }
                            setLoaded(true);
                            invalidateLayer();
                        }
                        else
                        {
                            _loc_9 = new ESRIError(ESRIMessageCodes.INVALID_TILE_SERVICE, url);
                            dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, new Fault(null, _loc_9.message)));
                            throw _loc_9;
                        }
                    }
                }
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object, token:Object = null) : void
            {
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, String(error));
                }
                dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, error as Fault));
                return;
            }// end function
            ;
            thisLayer;
            var task:* = new MapServiceInfoTask(this.url);
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            task.execute(new AsyncResponder(myResultFunction, myFaultFunction, this.url));
            return;
        }// end function

        private function loadMapServiceInfoEarly() : void
        {
            if (!parent)
            {
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                this.loadMapServiceInfo();
            }
            return;
        }// end function

        public function set proxyURL(value:String) : void
        {
            arguments = this.proxyURL;
            if (arguments !== value)
            {
                this._985186271proxyURL = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "proxyURL", arguments, value));
                }
            }
            return;
        }// end function

    }
}
