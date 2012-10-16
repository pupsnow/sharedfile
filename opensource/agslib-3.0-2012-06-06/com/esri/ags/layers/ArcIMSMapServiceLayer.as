package com.esri.ags.layers
{
    import ArcIMSMapServiceLayer.as$466.*;
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
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

    public class ArcIMSMapServiceLayer extends DynamicMapServiceLayer
    {
        private var _log:ILogger;
        private var _service:HTTPService;
        private var _urlChanged:Boolean;
        private var _serviceInfo:ServiceInfo;
        private var _startRect:Rectangle;
        private var _hiddenVisibleLayers:Array;
        private var _backgroundColor:String = "255,255,255";
        private var _backgroundTranscolor:String = "255,255,255";
        private var _coordSysID:Number;
        private var _imageFormat:String = "png8";
        private var _password:String;
        private var _proxyURL:String;
        private var _serviceHost:String;
        private var _serviceName:String;
        private var _username:String;
        private var _visibleLayers:IList;

        public function ArcIMSMapServiceLayer(serviceHost:String = null, serviceName:String = null, proxyURL:String = null, username:String = null, password:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._service = new HTTPService();
            this._service.contentType = HTTPService.CONTENT_TYPE_XML;
            this._service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
            this._service.requestTimeout = -1;
            this._service.concurrency = "last";
            this.serviceHost = serviceHost;
            this.serviceName = serviceName;
            this.proxyURL = proxyURL;
            this.username = username;
            this.password = password;
            if (FlexGlobals.topLevelApplication)
            {
                FlexGlobals.topLevelApplication.callLater(this.loadServiceInfoEarly);
            }
            return;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._serviceInfo ? (this._serviceInfo.initialExtent) : (null);
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._serviceInfo ? (this._serviceInfo.spatialReference) : (null);
        }// end function

        public function get units() : String
        {
            return this._serviceInfo ? (this._serviceInfo.units) : (Units.UNKNOWN_UNITS);
        }// end function

        public function get backgroundColor() : String
        {
            return this._backgroundColor;
        }// end function

        private function set _1287124693backgroundColor(value:String) : void
        {
            if (this.backgroundColor != value)
            {
                this._backgroundColor = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get backgroundTranscolor() : String
        {
            return this._backgroundTranscolor;
        }// end function

        private function set _1832864375backgroundTranscolor(value:String) : void
        {
            if (this.backgroundTranscolor != value)
            {
                this._backgroundTranscolor = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get coordSysID() : Number
        {
            return this._coordSysID;
        }// end function

        private function set _178958003coordSysID(value:Number) : void
        {
            this._coordSysID = value;
            return;
        }// end function

        public function get imageFormat() : String
        {
            return this._imageFormat;
        }// end function

        private function set _1798561074imageFormat(value:String) : void
        {
            if (this.imageFormat != value)
            {
                this._imageFormat = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get layerInfos() : Array
        {
            return this._serviceInfo ? (this._serviceInfo.layerInfos) : (null);
        }// end function

        public function get password() : String
        {
            return this._password;
        }// end function

        private function set _1216985755password(value:String) : void
        {
            this._password = value;
            this.setCredentials();
            return;
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURL;
        }// end function

        private function set _985186271proxyURL(value:String) : void
        {
            this._proxyURL = value;
            this.buildURL();
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

        public function get serviceHost() : String
        {
            return this._serviceHost;
        }// end function

        private function set _1928737283serviceHost(serviceHost:String) : void
        {
            this._serviceHost = serviceHost;
            this.buildURL();
            return;
        }// end function

        public function get serviceName() : String
        {
            return this._serviceName;
        }// end function

        private function set _1928572192serviceName(serviceName:String) : void
        {
            this._serviceName = serviceName;
            this.buildURL();
            return;
        }// end function

        public function get username() : String
        {
            return this._username;
        }// end function

        private function set _265713450username(value:String) : void
        {
            this._username = value;
            this.setCredentials();
            return;
        }// end function

        public function get visibleLayers() : IList
        {
            return this._visibleLayers;
        }// end function

        private function set _677647444visibleLayers(value:IList) : void
        {
            this.removeVisibleLayersListener();
            this._visibleLayers = value;
            this.addVisibleLayersListener();
            invalidateLayer();
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this._urlChanged)
            {
                this._urlChanged = false;
                removeAllChildren();
                this.loadServiceInfo();
            }
            return;
        }// end function

        override protected function loadMapImage(loader:Loader) : void
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var loader:* = loader;
            myResultFunction = function (event:ResultEvent, token:Object = null) : void
            {
                var _loc_4:String = null;
                var _loc_3:* = event.result as XML;
                if (_loc_3)
                {
                    if (_loc_3..ERROR[0])
                    {
                        if (Log.isError())
                        {
                            _log.error("{0}::{1}", id, _loc_3..ERROR);
                        }
                    }
                    else
                    {
                        _loc_4 = _loc_3..OUTPUT.@url;
                        if (_loc_4)
                        {
                            if (proxyURL)
                            {
                                _loc_4 = proxyURL + "?" + _loc_4;
                            }
                            loader.x = _startRect.x;
                            loader.y = _startRect.y;
                            loader.load(new URLRequest(_loc_4));
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
                    _log.error("{0}::{1}", id, ObjectUtil.toString(error));
                }
                return;
            }// end function
            ;
            this.buildStartRect();
            var extent:* = map.extent;
            if (this._startRect.x != 0)
            {
                extent = this.buildExtent();
            }
            var axl:* = new XML("<ARCXML version=\"1.1\">\r\n                " + ("<REQUEST>\r\n                    " + ("<GET_IMAGE>\r\n                        " + ("<PROPERTIES>\r\n                            " + ("<BACKGROUND color=\"" + this.backgroundColor + "\" transcolor=\"" + this.backgroundTranscolor + "\"/>") + "\r\n                            " + ("<ENVELOPE minx=\"" + extent.xmin + "\" miny=\"" + extent.ymin + "\" maxx=\"" + extent.xmax + "\" maxy=\"" + extent.ymax + "\"/>") + "\r\n                            " + ("<IMAGESIZE width=\"" + this._startRect.width + "\" height=\"" + this._startRect.height + "\"/>") + "\r\n                            " + ("<OUTPUT type=\"" + this.imageFormat + "\"/>") + "\r\n                        </PROPERTIES>") + "\r\n                    </GET_IMAGE>") + "\r\n                </REQUEST>") + "\r\n            </ARCXML>");
            this.addFeatureAndFilterCoordSys(axl);
            this.addLayerList(axl);
            var token:* = this._service.send(axl);
            token.addResponder(new AsyncResponder(myResultFunction, myFaultFunction));
            return;
        }// end function

        private function buildURL() : void
        {
            if (this.serviceHost)
            {
            }
            if (this.serviceName)
            {
                if (this.serviceHost.indexOf("com.esri.esrimap.Esrimap") == -1)
                {
                    this._service.url = this.serviceHost + "/servlet/com.esri.esrimap.Esrimap?ServiceName=" + this.serviceName;
                }
                else
                {
                    this._service.url = this.serviceHost + "?ServiceName=" + this.serviceName;
                }
                if (this.proxyURL)
                {
                    this._service.url = this.proxyURL + "?" + this._service.url;
                }
                this._urlChanged = true;
                invalidateProperties();
                this._serviceInfo = null;
                setLoaded(false);
            }
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
                this._service.headers.Authorization = "Basic " + _loc_2;
                invalidateLayer();
            }
            return;
        }// end function

        private function addVisibleLayersListener() : void
        {
            if (this.visibleLayers)
            {
                this.visibleLayers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayers_collectionChangeHandler);
            }
            return;
        }// end function

        private function removeVisibleLayersListener() : void
        {
            if (this.visibleLayers)
            {
                this.visibleLayers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayers_collectionChangeHandler);
            }
            return;
        }// end function

        private function loadServiceInfo() : void
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (event:ResultEvent, token:Object = null) : void
            {
                var _loc_4:Fault = null;
                var _loc_3:* = event.result as XML;
                if (_loc_3.RESPONSE.ERROR[0])
                {
                    _loc_4 = new Fault(null, _loc_3.RESPONSE.ERROR);
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, token as Layer, _loc_4));
                }
                else
                {
                    _serviceInfo = toServiceInfo(token as , _loc_3);
                    if (_serviceInfo)
                    {
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
                dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, token as Layer, event.fault));
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
            var axl:* = <ARCXML version="1.1">
                <REQUEST>
                    <GET_SERVICE_INFO extensions="false" fields="false" renderer="false"/>
                </REQUEST>
            </ARCXML>;
            var token:* = this._service.send(axl);
            token.addResponder(new AsyncResponder(myResultFunction, myFaultFunction, this));
            return;
        }// end function

        private function loadServiceInfoEarly() : void
        {
            if (!parent)
            {
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                this.loadServiceInfo();
            }
            return;
        }// end function

        private function addFeatureAndFilterCoordSys(axl:XML) : void
        {
            var _loc_2:XML = null;
            var _loc_3:XML = null;
            if (map.spatialReference)
            {
                if (!isNaN(map.spatialReference.wkid))
                {
                    _loc_2 = new XML("<FEATURECOORDSYS id=\"" + map.spatialReference.wkid + "\"/>");
                    _loc_3 = new XML("<FILTERCOORDSYS id=\"" + map.spatialReference.wkid + "\"/>");
                }
                else if (map.spatialReference.wkt)
                {
                    _loc_2 = new XML("<FEATURECOORDSYS string=\"" + map.spatialReference.wkt + "\"/>");
                    _loc_3 = new XML("<FILTERCOORDSYS string=\"" + map.spatialReference.wkt + "\"/>");
                }
            }
            if (_loc_2)
            {
            }
            if (_loc_3)
            {
                axl..PROPERTIES.insertChildBefore(axl..IMAGESIZE, _loc_2);
                axl..PROPERTIES.insertChildBefore(axl..IMAGESIZE, _loc_3);
            }
            return;
        }// end function

        private function addLayerList(axl:XML) : void
        {
            var _loc_2:XML = null;
            var _loc_3:AIMSLayer = null;
            var _loc_4:Boolean = false;
            var _loc_5:XML = null;
            if (this.visibleLayers)
            {
                _loc_2 = <LAYERLIST/>;
                for each (_loc_3 in this._serviceInfo.aimsLayers)
                {
                    
                    _loc_4 = false;
                    if (this.visibleLayers.getItemIndex(_loc_3.name) != -1)
                    {
                        _loc_4 = true;
                    }
                    _loc_5 = new XML("<LAYERDEF id=\"" + _loc_3.id + "\" visible=\"" + _loc_4 + "\"/>");
                    _loc_2.appendChild(_loc_5);
                }
                axl..PROPERTIES.insertChildAfter(axl..IMAGESIZE, _loc_2);
            }
            return;
        }// end function

        private function buildStartRect() : void
        {
            this._startRect = new Rectangle(0, 0, map.width, map.height);
            while (this._startRect.width * this._startRect.height > this._serviceInfo.maxPixelCount)
            {
                
                this._startRect.inflate(-1, -1);
            }
            return;
        }// end function

        private function buildExtent() : Extent
        {
            var _loc_1:* = map.toMap(new Point(this._startRect.left, this._startRect.top));
            var _loc_2:* = map.toMap(new Point(this._startRect.right, this._startRect.bottom));
            return new Extent(_loc_1.x, _loc_2.y, _loc_2.x, _loc_1.y, map.extent.spatialReference);
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

        public function set serviceHost(value:String) : void
        {
            arguments = this.serviceHost;
            if (arguments !== value)
            {
                this._1928737283serviceHost = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "serviceHost", arguments, value));
                }
            }
            return;
        }// end function

        public function set backgroundColor(value:String) : void
        {
            arguments = this.backgroundColor;
            if (arguments !== value)
            {
                this._1287124693backgroundColor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundColor", arguments, value));
                }
            }
            return;
        }// end function

        public function set backgroundTranscolor(value:String) : void
        {
            arguments = this.backgroundTranscolor;
            if (arguments !== value)
            {
                this._1832864375backgroundTranscolor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundTranscolor", arguments, value));
                }
            }
            return;
        }// end function

        public function set imageFormat(value:String) : void
        {
            arguments = this.imageFormat;
            if (arguments !== value)
            {
                this._1798561074imageFormat = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageFormat", arguments, value));
                }
            }
            return;
        }// end function

        public function set password(value:String) : void
        {
            arguments = this.password;
            if (arguments !== value)
            {
                this._1216985755password = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "password", arguments, value));
                }
            }
            return;
        }// end function

        public function set serviceName(value:String) : void
        {
            arguments = this.serviceName;
            if (arguments !== value)
            {
                this._1928572192serviceName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "serviceName", arguments, value));
                }
            }
            return;
        }// end function

        public function set coordSysID(value:Number) : void
        {
            arguments = this.coordSysID;
            if (arguments !== value)
            {
                this._178958003coordSysID = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "coordSysID", arguments, value));
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

        public function set username(value:String) : void
        {
            arguments = this.username;
            if (arguments !== value)
            {
                this._265713450username = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "username", arguments, value));
                }
            }
            return;
        }// end function

        public function set visibleLayers(value:IList) : void
        {
            arguments = this.visibleLayers;
            if (arguments !== value)
            {
                this._677647444visibleLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visibleLayers", arguments, value));
                }
            }
            return;
        }// end function

    }
}
