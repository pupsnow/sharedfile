package com.esri.ags.layers
{
    import WMSLayer.as$465.*;
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.rpc.http.*;
    import mx.utils.*;

    public class WMSLayer extends DynamicMapServiceLayer
    {
        private var _log:ILogger;
        private var _service:HTTPService;
        private var _capabilities:Capabilities;
        private var _fullImageFormat:String = "image/png";
        private var _addTimestamp:Boolean;
        private var _authHeader:URLRequestHeader;
        private var _hiddenVisibleLayers:Array;
        private var _blankImageClass:Class;
        private var _blankImage:ByteArray;
        private var _initialExtent:Extent;
        private var _initialExtentSet:Boolean;
        private var _spatialReference:SpatialReference;
        private var _spatialReferenceSet:Boolean;
        private var _abstract:String;
        private var _abstractSet:Boolean;
        private var _disableClientCaching:Boolean;
        private var _imageFormat:String = "png";
        private var _imageFormatChanged:Boolean;
        private var _layerInfos:Array;
        private var _layerInfosSet:Boolean;
        private var _maxImageHeight:int;
        private var _maxImageHeightSet:Boolean;
        private var _maxImageWidth:int;
        private var _maxImageWidthSet:Boolean;
        private var _password:String;
        private var _proxyURLObj:URL;
        private var _skipGetCapabilities:Boolean;
        private var _title:String;
        private var _titleSet:Boolean;
        private var _urlObj:URL;
        private var _urlChanged:Boolean = false;
        private var _username:String;
        private var _version:String = "1.3.0";
        private var _visibleLayers:IList;
        private static const SUPPORTED_VERSIONS:Array = ["1.1.0", "1.1.1", "1.3.0"];

        public function WMSLayer(url:String = null, proxyURL:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._blankImageClass = WMSLayer__blankImageClass;
            this._blankImage = new this._blankImageClass();
            this._proxyURLObj = new URL();
            this._urlObj = new URL();
            this._service = new HTTPService();
            this._service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
            this._service.requestTimeout = -1;
            this._service.concurrency = "last";
            this.url = url;
            this.proxyURL = proxyURL;
            if (FlexGlobals.topLevelApplication)
            {
                FlexGlobals.topLevelApplication.callLater(this.loadCapabilitiesEarly);
            }
            return;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._initialExtent ? (this._initialExtent) : (super.initialExtent);
        }// end function

        public function set initialExtent(value:Extent) : void
        {
            this._initialExtent = value;
            this._initialExtentSet = true;
            dispatchEvent(new Event("initialExtentChanged"));
            return;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._spatialReference ? (this._spatialReference) : (super.spatialReference);
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            this._spatialReference = value;
            this._spatialReferenceSet = true;
            dispatchEvent(new Event("spatialReferenceChanged"));
            return;
        }// end function

        public function get abstract() : String
        {
            return this._abstract;
        }// end function

        private function set _1732898850abstract(value:String) : void
        {
            this._abstract = value;
            this._abstractSet = true;
            return;
        }// end function

        public function get disableClientCaching() : Boolean
        {
            return this._disableClientCaching;
        }// end function

        private function set _2076627820disableClientCaching(value:Boolean) : void
        {
            this._disableClientCaching = value;
            return;
        }// end function

        public function get imageFormat() : String
        {
            return this._imageFormat;
        }// end function

        public function set imageFormat(value:String) : void
        {
            if (this._imageFormat !== value)
            {
                this._imageFormat = value;
                this._imageFormatChanged = true;
                invalidateProperties();
                invalidateLayer();
                dispatchEvent(new Event("imageFormatChanged"));
            }
            return;
        }// end function

        public function get layerInfos() : Array
        {
            return this._layerInfos;
        }// end function

        public function set layerInfos(value:Array) : void
        {
            this._layerInfos = value;
            this._layerInfosSet = true;
            dispatchEvent(new Event("layerInfosChanged"));
            return;
        }// end function

        public function get maxImageHeight() : int
        {
            return this._maxImageHeight;
        }// end function

        private function set _137366946maxImageHeight(value:int) : void
        {
            this._maxImageHeight = value;
            this._maxImageHeightSet = true;
            return;
        }// end function

        public function get maxImageWidth() : int
        {
            return this._maxImageWidth;
        }// end function

        private function set _1672104367maxImageWidth(value:int) : void
        {
            this._maxImageWidth = value;
            this._maxImageWidthSet = true;
            return;
        }// end function

        public function get password() : String
        {
            return this._password;
        }// end function

        public function set password(value:String) : void
        {
            this._password = value;
            this.setCredentials();
            return;
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
            return this._service.requestTimeout;
        }// end function

        private function set _1124910034requestTimeout(value:int) : void
        {
            this._service.requestTimeout = value;
            return;
        }// end function

        public function get skipGetCapabilities() : Boolean
        {
            return this._skipGetCapabilities;
        }// end function

        private function set _517662381skipGetCapabilities(value:Boolean) : void
        {
            this._skipGetCapabilities = value;
            return;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        private function set _110371416title(value:String) : void
        {
            this._title = value;
            this._titleSet = true;
            return;
        }// end function

        public function get url() : String
        {
            return this._urlObj.sourceURL;
        }// end function

        public function set url(value:String) : void
        {
            if (this.url !== value)
            {
            }
            if (value)
            {
                this._urlObj.update(value);
                this._urlChanged = true;
                invalidateProperties();
                this._capabilities = null;
                setLoaded(false);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        public function get username() : String
        {
            return this._username;
        }// end function

        public function set username(value:String) : void
        {
            this._username = value;
            this.setCredentials();
            return;
        }// end function

        public function get version() : String
        {
            return this._version;
        }// end function

        public function set version(value:String) : void
        {
            if (this._version !== value)
            {
            }
            if (SUPPORTED_VERSIONS.indexOf(value) != -1)
            {
                this._version = value;
                dispatchEvent(new Event("versionChanged"));
            }
            return;
        }// end function

        public function get visibleLayers() : IList
        {
            return this._visibleLayers;
        }// end function

        public function set visibleLayers(value:IList) : void
        {
            if (this._visibleLayers)
            {
                this._visibleLayers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayers_collectionChangeHandler);
            }
            this._visibleLayers = value;
            if (this._visibleLayers)
            {
                this._visibleLayers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayers_collectionChangeHandler);
            }
            invalidateLayer();
            dispatchEvent(new Event("layersChanged"));
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:String = null;
            super.commitProperties();
            if (this._imageFormatChanged)
            {
                this._imageFormatChanged = false;
                _loc_1 = this.imageFormat ? (this.imageFormat.toLowerCase()) : ("");
                switch(_loc_1)
                {
                    case "jpg":
                    {
                        this._fullImageFormat = "image/jpeg";
                        break;
                    }
                    case "gif":
                    {
                        this._fullImageFormat = "image/gif";
                        break;
                    }
                    default:
                    {
                        this._fullImageFormat = "image/png";
                        break;
                        break;
                    }
                }
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                removeAllChildren();
                if (this.skipGetCapabilities)
                {
                    setLoaded(true);
                    invalidateLayer();
                }
                else
                {
                    this.loadCapabilities();
                }
            }
            return;
        }// end function

        override protected function loadMapImage(loader:Loader) : void
        {
            var _loc_5:Number = NaN;
            if (this.visibleLayers)
            {
            }
            if (this.visibleLayers.length == 0)
            {
                loader.loadBytes(this._blankImage);
                return;
            }
            var _loc_2:* = this.buildStartRect();
            var _loc_3:* = map.extent;
            if (_loc_2.x == 0)
            {
            }
            if (_loc_2.y != 0)
            {
                _loc_3 = this.buildExtent(_loc_2);
                loader.x = _loc_2.x;
                loader.y = _loc_2.y;
            }
            var _loc_4:* = this.getExtraVariables();
            _loc_4.SERVICE = "WMS";
            _loc_4.REQUEST = "GetMap";
            _loc_4.FORMAT = this._fullImageFormat;
            _loc_4.TRANSPARENT = "TRUE";
            if (!_loc_4.STYLES)
            {
                _loc_4.STYLES = "";
            }
            _loc_4.WIDTH = _loc_2.width;
            _loc_4.HEIGHT = _loc_2.height;
            _loc_4.VERSION = this.version;
            _loc_4.LAYERS = this.visibleLayers.toArray().join();
            if (this._spatialReferenceSet)
            {
                _loc_5 = this.spatialReference.wkid;
            }
            else if (map.spatialReference)
            {
                _loc_5 = map.spatialReference.wkid;
            }
            if (!isNaN(_loc_5))
            {
                if (this.version == Capabilities.VERSION_1_3_0)
                {
                    _loc_4.CRS = "EPSG:" + _loc_5;
                }
                else
                {
                    _loc_4.SRS = "EPSG:" + _loc_5;
                }
            }
            if (this.version == Capabilities.VERSION_1_3_0)
            {
            }
            if (Capabilities.useLatLong(_loc_5))
            {
                _loc_4.BBOX = _loc_3.ymin + "," + _loc_3.xmin + "," + _loc_3.ymax + "," + _loc_3.xmax;
            }
            else
            {
                _loc_4.BBOX = _loc_3.xmin + "," + _loc_3.ymin + "," + _loc_3.xmax + "," + _loc_3.ymax;
            }
            var _loc_6:* = new URLRequest();
            if (this._capabilities)
            {
            }
            if (this._capabilities.getMapURL)
            {
                _loc_6.url = this._capabilities.getMapURL.path;
            }
            else
            {
                _loc_6.url = this._urlObj.path;
            }
            _loc_6.url = _loc_6.url + ("?" + _loc_4.toString());
            if (this._proxyURLObj.path)
            {
                _loc_6.url = this._proxyURLObj.path + "?" + _loc_6.url;
            }
            if (this._authHeader)
            {
                _loc_6.requestHeaders.push(this._authHeader);
                _loc_6.method = URLRequestMethod.POST;
                _loc_6.data = _loc_4;
            }
            loader.load(_loc_6);
            return;
        }// end function

        override public function refresh() : void
        {
            super.refresh();
            this._addTimestamp = true;
            return;
        }// end function

        private function setCredentials() : void
        {
            var _loc_1:Base64Encoder = null;
            var _loc_2:String = null;
            if (this.username)
            {
            }
            if (this.password)
            {
                _loc_1 = new Base64Encoder();
                _loc_1.insertNewLines = false;
                _loc_1.encode(this.username + ":" + this.password);
                _loc_2 = _loc_1.toString();
                this._authHeader = new URLRequestHeader();
                this._authHeader.name = "Authorization";
                this._authHeader.value = "Basic " + _loc_2;
                this._service.headers[this._authHeader.name] = this._authHeader.value;
                this._service.method = URLRequestMethod.POST;
                invalidateLayer();
            }
            else if (this._authHeader)
            {
                delete this._service.headers[this._authHeader.name];
                this._authHeader = null;
                this._service.method = URLRequestMethod.GET;
            }
            return;
        }// end function

        private function getExtraVariables() : URLVariables
        {
            var _loc_2:Object = null;
            var _loc_1:* = new URLVariables();
            for (_loc_2 in this._proxyURLObj.query)
            {
                
                _loc_1[_loc_2] = this._proxyURLObj.query[_loc_2];
            }
            for (_loc_2 in this._urlObj.query)
            {
                
                _loc_1[_loc_2] = this._urlObj.query[_loc_2];
            }
            if (this._capabilities)
            {
            }
            if (this._capabilities.getMapURL)
            {
                for (_loc_2 in this._capabilities.getMapURL.query)
                {
                    
                    _loc_1[_loc_2] = this._capabilities.getMapURL.query[_loc_2];
                }
            }
            if (!this.disableClientCaching)
            {
            }
            if (this._addTimestamp)
            {
                _loc_1._ts = new Date().time;
                this._addTimestamp = false;
            }
            return _loc_1;
        }// end function

        private function getServiceURL(urlVariables:URLVariables = null) : String
        {
            var _loc_2:* = this._urlObj.path;
            if (this._proxyURLObj.path)
            {
                _loc_2 = this._proxyURLObj.path + "?" + _loc_2;
            }
            if (urlVariables)
            {
                _loc_2 = _loc_2 + ("?" + urlVariables.toString());
            }
            return _loc_2;
        }// end function

        private function loadCapabilities() : void
        {
            var thisLayer:WMSLayer;
            var token:AsyncToken;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (event:ResultEvent, token:Object = null) : void
            {
                var _loc_5:Fault = null;
                var _loc_3:* = event.result as XML;
                var _loc_4:* = _loc_3.namespace();
                if (_loc_4::ServiceException[0])
                {
                    _loc_5 = new Fault(_loc_4::ServiceException[0].@code[0], _loc_4::ServiceException[0]);
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, _loc_5));
                }
                else
                {
                    _capabilities = Capabilities.toCapabilities(_loc_3);
                    if (_capabilities)
                    {
                        thisLayer.version = _capabilities.version;
                        if (!_abstractSet)
                        {
                            thisLayer.abstract = _capabilities.abstract;
                            _abstractSet = false;
                        }
                        if (!_initialExtentSet)
                        {
                            thisLayer.initialExtent = _capabilities.fullExtent;
                            _initialExtentSet = false;
                        }
                        if (!_layerInfosSet)
                        {
                            thisLayer.layerInfos = _capabilities.layerInfos;
                            _layerInfosSet = false;
                        }
                        if (!_maxImageHeightSet)
                        {
                            thisLayer.maxImageHeight = _capabilities.maxHeight;
                            _maxImageHeightSet = false;
                        }
                        if (!_maxImageWidthSet)
                        {
                            thisLayer.maxImageWidth = _capabilities.maxWidth;
                            _maxImageWidthSet = false;
                        }
                        if (!_spatialReferenceSet)
                        {
                        }
                        if (_capabilities.fullExtent)
                        {
                            thisLayer.spatialReference = _capabilities.fullExtent.spatialReference;
                            _spatialReferenceSet = false;
                        }
                        if (!_titleSet)
                        {
                            thisLayer.title = _capabilities.title;
                            _titleSet = false;
                        }
                        setLoaded(true);
                        invalidateLayer();
                    }
                }
                return;
            }// end function
            ;
            myFaultFunction = function (event:FaultEvent, token:Object = null) : void
            {
                var _loc_3:SecurityErrorEvent = null;
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, String(event.fault));
                }
                dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, event.fault));
                if (event.fault)
                {
                }
                if (event.fault.rootCause)
                {
                    _loc_3 = event.fault.rootCause as SecurityErrorEvent;
                    if (_loc_3)
                    {
                        throw new SecurityError(_loc_3.text);
                    }
                }
                return;
            }// end function
            ;
            thisLayer;
            var urlVariables:* = this.getExtraVariables();
            urlVariables.SERVICE = "WMS";
            urlVariables.REQUEST = "GetCapabilities";
            urlVariables.VERSION = this.version;
            this._service.url = this.getServiceURL(urlVariables);
            if (this._service.method == URLRequestMethod.GET)
            {
                token = this._service.send();
            }
            else
            {
                token = this._service.send(urlVariables);
            }
            token.addResponder(new AsyncResponder(myResultFunction, myFaultFunction));
            return;
        }// end function

        private function loadCapabilitiesEarly() : void
        {
            if (!parent)
            {
            }
            if (this._urlChanged)
            {
            }
            if (!this.skipGetCapabilities)
            {
                this._urlChanged = false;
                this.loadCapabilities();
            }
            return;
        }// end function

        private function buildStartRect() : Rectangle
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_1:* = new Rectangle(0, 0, map.width, map.height);
            if (this.maxImageWidth > 0)
            {
            }
            if (this.maxImageHeight > 0)
            {
                _loc_2 = this.maxImageWidth;
                _loc_3 = this.maxImageHeight;
                if (_loc_2 >= _loc_1.width)
                {
                }
                if (_loc_3 < _loc_1.height)
                {
                    _loc_4 = _loc_2 < _loc_1.width ? (Math.floor((_loc_2 - _loc_1.width) * 0.5)) : (0);
                    _loc_5 = _loc_3 < _loc_1.height ? (Math.floor((_loc_3 - _loc_1.height) * 0.5)) : (0);
                    _loc_1.inflate(_loc_4, _loc_5);
                }
            }
            return _loc_1;
        }// end function

        private function buildExtent(startRect:Rectangle) : Extent
        {
            var _loc_2:* = map.toMap(new Point(startRect.left, startRect.top));
            var _loc_3:* = map.toMap(new Point(startRect.right, startRect.bottom));
            return new Extent(_loc_2.x, _loc_3.y, _loc_3.x, _loc_2.y);
        }// end function

        override protected function hideHandler(event:FlexEvent) : void
        {
            super.hideHandler(event);
            if (this.visibleLayers)
            {
                this._hiddenVisibleLayers = this.visibleLayers.toArray();
            }
            else
            {
                this._hiddenVisibleLayers = null;
            }
            return;
        }// end function

        override protected function showHandler(event:FlexEvent) : void
        {
            super.showHandler(event);
            if (numChildren > 0)
            {
                if (this.visibleLayers)
                {
                }
            }
            if (ObjectUtil.compare(this._hiddenVisibleLayers, this.visibleLayers.toArray()) != 0)
            {
                removeAllChildren();
            }
            return;
        }// end function

        private function visibleLayers_collectionChangeHandler(event:CollectionEvent) : void
        {
            invalidateLayer();
            return;
        }// end function

        public function set abstract(value:String) : void
        {
            arguments = this.abstract;
            if (arguments !== value)
            {
                this._1732898850abstract = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "abstract", arguments, value));
                }
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

        public function set title(value:String) : void
        {
            arguments = this.title;
            if (arguments !== value)
            {
                this._110371416title = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "title", arguments, value));
                }
            }
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

        public function set maxImageHeight(value:int) : void
        {
            arguments = this.maxImageHeight;
            if (arguments !== value)
            {
                this._137366946maxImageHeight = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxImageHeight", arguments, value));
                }
            }
            return;
        }// end function

        public function set skipGetCapabilities(value:Boolean) : void
        {
            arguments = this.skipGetCapabilities;
            if (arguments !== value)
            {
                this._517662381skipGetCapabilities = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "skipGetCapabilities", arguments, value));
                }
            }
            return;
        }// end function

        public function set disableClientCaching(value:Boolean) : void
        {
            arguments = this.disableClientCaching;
            if (arguments !== value)
            {
                this._2076627820disableClientCaching = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "disableClientCaching", arguments, value));
                }
            }
            return;
        }// end function

        public function set maxImageWidth(value:int) : void
        {
            arguments = this.maxImageWidth;
            if (arguments !== value)
            {
                this._1672104367maxImageWidth = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxImageWidth", arguments, value));
                }
            }
            return;
        }// end function

    }
}
