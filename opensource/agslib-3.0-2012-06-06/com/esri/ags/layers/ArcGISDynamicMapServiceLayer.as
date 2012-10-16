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
    import mx.utils.*;

    public class ArcGISDynamicMapServiceLayer extends DynamicMapServiceLayer implements ILegendSupport
    {
        private var _log:ILogger;
        private var _mapServiceInfo:MapServiceInfo;
        private var _addTimestamp:Boolean;
        private var _defaultVisibleLayers:Array;
        private var _hiddenVisibleLayers:Array;
        private var _blankImageClass:Class;
        private var _blankImage:ByteArray;
        private var _legendUrl:String = "http://utility.arcgis.com/sharing/tools/legend";
        var credential:Credential;
        private var _disableClientCaching:Boolean;
        private var _dynamicLayerInfos:Array;
        private var _dpi:Number = 96;
        private var _gdbVersion:String;
        private var _imageFormat:String = "png8";
        private var _imageTransparency:Boolean = true;
        private var _layerDefinitions:Array;
        private var _layerDrawingOptions:Array;
        private var _layerInfoWindowRenderers:Array;
        private var _layerTimeOptions:Array;
        private var _maxImageHeight:int;
        private var _maxImageHeightSet:Boolean;
        private var _maxImageWidth:int;
        private var _maxImageWidthSet:Boolean;
        private var _proxyURLObj:URL;
        private var _requestTimeout:int = -1;
        private var _timeOffset:Number;
        private var _timeOffsetUnits:String;
        private var _token:String;
        private var _urlChanged:Boolean;
        const urlObj:URL;
        private var _useMapTime:Boolean = true;
        private var _visibleLayers:IList;

        public function ArcGISDynamicMapServiceLayer(url:String = null, proxyURL:String = null, token:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._blankImageClass = ArcGISDynamicMapServiceLayer__blankImageClass;
            this._blankImage = new this._blankImageClass();
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

        override public function get initialExtent() : Extent
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.initialExtent) : (null);
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.spatialReference) : (null);
        }// end function

        public function get supportsDynamicLayers() : Boolean
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.supportsDynamicLayers) : (false);
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

        public function get disableClientCaching() : Boolean
        {
            return this._disableClientCaching;
        }// end function

        private function set _2076627820disableClientCaching(value:Boolean) : void
        {
            this._disableClientCaching = value;
            return;
        }// end function

        public function get dynamicLayerInfos() : Array
        {
            return this._dynamicLayerInfos ? (ObjectUtil.copy(this._dynamicLayerInfos) as Array) : (null);
        }// end function

        public function set dynamicLayerInfos(value:Array) : void
        {
            this._dynamicLayerInfos = value;
            invalidateLayer();
            dispatchEvent(new Event("dynamicLayerInfosChanged"));
            return;
        }// end function

        public function get dpi() : Number
        {
            return this._dpi;
        }// end function

        public function set dpi(value:Number) : void
        {
            if (this._dpi !== value)
            {
                this._dpi = value;
                invalidateLayer();
                dispatchEvent(new Event("dpiChanged"));
            }
            return;
        }// end function

        public function get fullExtent() : Extent
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.fullExtent) : (null);
        }// end function

        public function get gdbVersion() : String
        {
            return this._gdbVersion;
        }// end function

        public function set gdbVersion(value:String) : void
        {
            if (this._gdbVersion !== value)
            {
                this._gdbVersion = value;
                invalidateLayer();
                dispatchEvent(new Event("gdbVersionChanged"));
            }
            return;
        }// end function

        public function get hasVersionedData() : Boolean
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.hasVersionedData) : (false);
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
                invalidateLayer();
                dispatchEvent(new Event("imageFormatChanged"));
            }
            return;
        }// end function

        public function get imageTransparency() : Boolean
        {
            return this._imageTransparency;
        }// end function

        public function set imageTransparency(value:Boolean) : void
        {
            if (this._imageTransparency !== value)
            {
                this._imageTransparency = value;
                invalidateLayer();
                dispatchEvent(new Event("imageTransparencyChanged"));
            }
            return;
        }// end function

        public function get layerDefinitions() : Array
        {
            return this._layerDefinitions;
        }// end function

        public function set layerDefinitions(value:Array) : void
        {
            this._layerDefinitions = value;
            invalidateLayer();
            dispatchEvent(new Event("layerDefinitionsChanged"));
            return;
        }// end function

        public function get layerDrawingOptions() : Array
        {
            return this._layerDrawingOptions;
        }// end function

        public function set layerDrawingOptions(value:Array) : void
        {
            this._layerDrawingOptions = value;
            invalidateLayer();
            dispatchEvent(new Event("layerDrawingOptionsChanged"));
            return;
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

        public function get layerTimeOptions() : Array
        {
            return this._layerTimeOptions;
        }// end function

        public function set layerTimeOptions(value:Array) : void
        {
            this._layerTimeOptions = value;
            invalidateLayer();
            dispatchEvent(new Event("layerTimeOptionsChanged"));
            return;
        }// end function

        public function get maxImageHeight() : int
        {
            return this._maxImageHeight;
        }// end function

        public function set maxImageHeight(value:int) : void
        {
            if (this._maxImageHeight !== value)
            {
                this._maxImageHeight = value;
                this._maxImageHeightSet = true;
                dispatchEvent(new Event("maxImageHeightChanged"));
            }
            return;
        }// end function

        public function get maxImageWidth() : int
        {
            return this._maxImageWidth;
        }// end function

        public function set maxImageWidth(value:int) : void
        {
            if (this._maxImageWidth !== value)
            {
                this._maxImageWidth = value;
                this._maxImageWidthSet = true;
                dispatchEvent(new Event("maxImageWidthChanged"));
            }
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

        public function get timeInfo() : TimeInfo
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.timeInfo) : (null);
        }// end function

        public function get timeOffset() : Number
        {
            return this._timeOffset;
        }// end function

        public function set timeOffset(value:Number) : void
        {
            if (this._timeOffset !== value)
            {
                this._timeOffset = value;
                invalidateLayer();
                dispatchEvent(new Event("timeOffsetChanged"));
            }
            return;
        }// end function

        public function get timeOffsetUnits() : String
        {
            return this._timeOffsetUnits;
        }// end function

        public function set timeOffsetUnits(value:String) : void
        {
            if (this._timeOffsetUnits !== value)
            {
                this._timeOffsetUnits = value;
                invalidateLayer();
                dispatchEvent(new Event("timeOffsetUnitsChanged"));
            }
            return;
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

        public function get useMapTime() : Boolean
        {
            return this._useMapTime;
        }// end function

        private function set _784516414useMapTime(value:Boolean) : void
        {
            this._useMapTime = value;
            invalidateLayer();
            return;
        }// end function

        public function get version() : Number
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.mapServiceVersion) : (NaN);
        }// end function

        public function get visibleLayers() : IList
        {
            return this._visibleLayers;
        }// end function

        public function set visibleLayers(value:IList) : void
        {
            this.removeVisibleLayersListener();
            this._visibleLayers = value;
            this.addVisibleLayersListener();
            invalidateLayer();
            dispatchEvent(new Event("visibleLayersChanged"));
            return;
        }// end function

        override protected function addMapListeners() : void
        {
            super.addMapListeners();
            if (map)
            {
                map.addEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.map_timeExtentChangeHandler);
            }
            return;
        }// end function

        override protected function removeMapListeners() : void
        {
            super.removeMapListeners();
            if (map)
            {
                map.removeEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.map_timeExtentChangeHandler);
            }
            return;
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

        override protected function loadMapImage(loader:Loader) : void
        {
            var _loc_12:SRInfo = null;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_2:* = this.imageFormat ? (this.imageFormat.toLowerCase()) : ("");
            if (this.visibleLayers)
            {
            }
            if (this.visibleLayers.length == 0)
            {
            }
            if (this.imageTransparency)
            {
                if (_loc_2.indexOf("png") != 0)
                {
                }
            }
            if (_loc_2 == "gif")
            {
                loader.loadBytes(this._blankImage);
                return;
            }
            var _loc_3:* = this.buildStartRect();
            var _loc_4:* = map.extent;
            var _loc_5:* = _loc_4.spatialReference;
            if (_loc_3.x == 0)
            {
            }
            if (_loc_3.y != 0)
            {
                _loc_4 = this.buildExtent(_loc_3, _loc_5);
                loader.x = _loc_3.x;
                loader.y = _loc_3.y;
            }
            var _loc_6:* = _loc_3.width;
            var _loc_7:* = _loc_3.height;
            var _loc_8:* = _loc_4.width;
            if (this.version >= 10)
            {
            }
            if (map.wrapAround180)
            {
            }
            if (_loc_5)
            {
                _loc_12 = _loc_5.info;
                if (_loc_8 > _loc_12.world)
                {
                    _loc_4 = _loc_4.duplicate();
                    _loc_4.xmin = _loc_12.valid[0];
                    _loc_4.xmax = _loc_12.valid[1];
                    _loc_13 = map.toScreenX(_loc_4.xmin);
                    _loc_14 = map.toScreenX(_loc_4.xmax);
                    _loc_6 = Math.round(_loc_14 - _loc_13);
                    loader.x = _loc_13;
                    loader.addEventListener(Event.COMPLETE, this.loader_completeHandler, false, -1, true);
                }
                else
                {
                    _loc_4 = _loc_4.normalize(true) as Extent;
                }
            }
            var _loc_9:* = this.getURLVariables(_loc_4, _loc_6, _loc_7);
            _loc_9.f = "image";
            var _loc_10:* = this.credential ? (this.credential.token) : (null);
            var _loc_11:* = AGSUtil.getURLRequest(this.urlObj, "/export", _loc_9, this.token, this._proxyURLObj, null, _loc_10);
            loader.load(_loc_11);
            return;
        }// end function

        override public function refresh() : void
        {
            super.refresh();
            this._addTimestamp = true;
            return;
        }// end function

        public function createDynamicLayerInfosFromLayerInfos() : Array
        {
            var _loc_1:Array = null;
            var _loc_3:LayerInfo = null;
            var _loc_2:* = this.layerInfos;
            if (_loc_2)
            {
                _loc_1 = [];
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(DynamicLayerInfo.fromLayerInfo(_loc_3));
                }
            }
            return _loc_1;
        }// end function

        public function exportMapImage(imageParameters:ImageParameters = null, responder:IResponder = null) : AsyncToken
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var extent:Extent;
            var startRect:Rectangle;
            var imageParameters:* = imageParameters;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                dispatchEvent(new MapImageEvent(MapImageEvent.EXPORT, result as MapImage));
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            var params:* = imageParameters;
            if (!params)
            {
                params = new ImageParameters();
            }
            if (this.version >= 10)
            {
                params.normalize = map ? (map.wrapAround180) : (true);
            }
            params.layerInfos = this.layerInfos;
            params.mapScale = map ? (map.scale) : (0);
            if (isNaN(params.dpi))
            {
                params.dpi = this.dpi;
            }
            if (!params.dynamicLayerInfos)
            {
                params.dynamicLayerInfos = this.dynamicLayerInfos;
            }
            if (!params.extent)
            {
            }
            if (map)
            {
                extent = map.extent;
                startRect = this.buildStartRect();
                if (startRect.x == 0)
                {
                }
                if (startRect.y != 0)
                {
                    extent = this.buildExtent(startRect, extent.spatialReference);
                }
                params.extent = extent;
            }
            if (!params.format)
            {
                params.format = this.imageFormat;
            }
            if (!params.gdbVersion)
            {
                params.gdbVersion = this.gdbVersion;
            }
            if (isNaN(params.height))
            {
                isNaN(params.height);
            }
            if (map)
            {
                params.height = map.height;
            }
            if (!params.layerDefinitions)
            {
                params.layerDefinitions = this.layerDefinitions;
            }
            if (!params.layerIds)
            {
            }
            if (!params.layerOption)
            {
                if (this.visibleLayers)
                {
                    params.layerIds = this.visibleLayers.toArray();
                    params.layerOption = ImageParameters.LAYER_OPTION_SHOW;
                }
            }
            if (!params.layerTimeOptions)
            {
                params.layerTimeOptions = this.layerTimeOptions;
            }
            if (!params.layerDrawingOptions)
            {
                params.layerDrawingOptions = this.layerDrawingOptions;
            }
            if (!params.timeExtent)
            {
            }
            if (this.useMapTime)
            {
            }
            if (map)
            {
            }
            if (map.timeExtent)
            {
            }
            if (this.timeInfo)
            {
                if (!isNaN(this.timeOffset))
                {
                }
                if (this.timeOffsetUnits)
                {
                    params.timeExtent = map.timeExtent.offset(-this.timeOffset, this.timeOffsetUnits);
                }
                else
                {
                    params.timeExtent = map.timeExtent;
                }
            }
            if (isNaN(params.width))
            {
                isNaN(params.width);
            }
            if (map)
            {
                params.width = map.width;
            }
            if (this.maxImageHeight > 0)
            {
                params.height = Math.min(params.height, this.maxImageHeight);
            }
            if (this.maxImageWidth > 0)
            {
                params.width = Math.min(params.width, this.maxImageWidth);
            }
            var task:* = new ExportMapImageTask(this.url);
            task.disableClientCaching = this.disableClientCaching;
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            var asyncToken:* = task.exportMap(params, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
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
            task.disableClientCaching = this.disableClientCaching;
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
            task.disableClientCaching = this.disableClientCaching;
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            var asyncToken:* = task.getDetails(layerOrTableId, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        private function getURLVariables(extent:Extent, width:Number, height:Number) : URLVariables
        {
            var _loc_4:* = new ImageParameters();
            _loc_4.extent = extent;
            _loc_4.dpi = this.dpi;
            _loc_4.dynamicLayerInfos = this._dynamicLayerInfos;
            _loc_4.format = this.imageFormat;
            _loc_4.gdbVersion = this.gdbVersion;
            _loc_4.height = height;
            _loc_4.width = width;
            _loc_4.layerDefinitions = this.layerDefinitions;
            _loc_4.layerDrawingOptions = this.layerDrawingOptions;
            _loc_4.layerInfos = this.layerInfos;
            _loc_4.layerTimeOptions = this.layerTimeOptions;
            if (this.visibleLayers)
            {
                _loc_4.layerIds = this.visibleLayers.toArray();
                _loc_4.layerOption = ImageParameters.LAYER_OPTION_SHOW;
            }
            _loc_4.mapScale = map.scale;
            if (this.useMapTime)
            {
            }
            if (map.timeExtent)
            {
            }
            if (this.timeInfo)
            {
                if (!isNaN(this.timeOffset))
                {
                }
                if (this.timeOffsetUnits)
                {
                    _loc_4.timeExtent = map.timeExtent.offset(-this.timeOffset, this.timeOffsetUnits);
                }
                else
                {
                    _loc_4.timeExtent = map.timeExtent;
                }
            }
            _loc_4.transparent = this.imageTransparency;
            var _loc_5:* = new URLVariables();
            _loc_4.appendToURLVariables(_loc_5);
            if (!this.disableClientCaching)
            {
            }
            if (this._addTimestamp)
            {
                this._addTimestamp = false;
                _loc_5._ts = new Date().time;
            }
            return _loc_5;
        }// end function

        private function loadMapServiceInfo() : void
        {
            var thisLayer:ArcGISDynamicMapServiceLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (result:Object, token:Object = null) : void
            {
                if (token == url)
                {
                    _mapServiceInfo = result as MapServiceInfo;
                    if (_mapServiceInfo)
                    {
                        credential = IdentityManager.instance.findCredential(urlObj.path);
                        if (!_maxImageHeightSet)
                        {
                            thisLayer.maxImageHeight = _mapServiceInfo.maxImageHeight;
                            _maxImageHeightSet = false;
                        }
                        if (!_maxImageWidthSet)
                        {
                            thisLayer.maxImageWidth = _mapServiceInfo.maxImageWidth;
                            _maxImageWidthSet = false;
                        }
                        setLoaded(true);
                        invalidateLayer();
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
            task.disableClientCaching = this.disableClientCaching;
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
            _loc_4.disableClientCaching = this.disableClientCaching;
            _loc_4.proxyURL = this.proxyURL;
            _loc_4.requestTimeout = this.requestTimeout;
            _loc_4.token = this.token;
            var _loc_5:* = _loc_4.getLegend(this, _loc_3, responder);
            return _loc_5;
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

        private function buildExtent(startRect:Rectangle, spatialReference:SpatialReference) : Extent
        {
            var _loc_3:* = map.toMap(new Point(startRect.left, startRect.top));
            var _loc_4:* = map.toMap(new Point(startRect.right, startRect.bottom));
            return new Extent(_loc_3.x, _loc_4.y, _loc_4.x, _loc_3.y, spatialReference);
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

        private function loader_completeHandler(event:Event) : void
        {
            var _loc_3:Bitmap = null;
            var _loc_4:Matrix = null;
            var _loc_5:Rectangle = null;
            var _loc_2:* = Loader(event.target);
            if (_loc_2.parent)
            {
                try
                {
                    _loc_3 = _loc_2.content as Bitmap;
                }
                catch (err:SecurityError)
                {
                }
                if (_loc_3)
                {
                    _loc_2.visible = false;
                    _loc_4 = new Matrix();
                    _loc_4.translate(_loc_2.x, _loc_2.y);
                    _loc_5 = map.layerContainer.scrollRect;
                    graphics.clear();
                    graphics.beginBitmapFill(_loc_3.bitmapData, _loc_4);
                    graphics.drawRect(_loc_5.x - map.width, _loc_2.y, map.width * 3, _loc_2.height);
                    graphics.endFill();
                }
            }
            return;
        }// end function

        private function map_timeExtentChangeHandler(event:TimeExtentEvent) : void
        {
            if (this.useMapTime)
            {
            }
            if (this.timeInfo)
            {
                invalidateLayer();
            }
            return;
        }// end function

        private function visibleLayers_collectionChangeHandler(event:CollectionEvent) : void
        {
            invalidateLayer();
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

        public function set useMapTime(value:Boolean) : void
        {
            arguments = this.useMapTime;
            if (arguments !== value)
            {
                this._784516414useMapTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "useMapTime", arguments, value));
                }
            }
            return;
        }// end function

    }
}
