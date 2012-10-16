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
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class ArcGISImageServiceLayer extends DynamicMapServiceLayer
    {
        private var _log:ILogger;
        private var _mapServiceInfo:MapServiceInfo;
        private var _addTimestamp:Boolean;
        private var _bandIds:Array;
        private var _compressionQuality:Number;
        var credential:Credential;
        private var _disableClientCaching:Boolean;
        private var _imageFormat:String;
        private var _interpolation:String;
        private var _maxImageHeight:int;
        private var _maxImageHeightSet:Boolean;
        private var _maxImageWidth:int;
        private var _maxImageWidthSet:Boolean;
        private var _mosaicRule:MosaicRule;
        private var _noData:Number;
        private var _proxyURLObj:URL;
        private var _renderingRule:RasterFunction;
        private var _requestTimeout:int = -1;
        private var _timeOffset:Number;
        private var _timeOffsetUnits:String;
        private var _token:String;
        private var _urlChanged:Boolean;
        const urlObj:URL;
        private var _useMapTime:Boolean = true;

        public function ArcGISImageServiceLayer(url:String = null, proxyURL:String = null, token:String = null)
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

        override public function get initialExtent() : Extent
        {
            var _loc_1:Extent = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = Extent.fromJSON(this._mapServiceInfo.rawObj.extent);
            }
            return _loc_1;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this.initialExtent ? (this.initialExtent.spatialReference) : (null);
        }// end function

        public function get bandCount() : Number
        {
            var _loc_1:Number = NaN;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.bandCount;
            }
            return _loc_1;
        }// end function

        public function get bandIds() : Array
        {
            return this._bandIds;
        }// end function

        public function set bandIds(value:Array) : void
        {
            this._bandIds = value;
            invalidateLayer();
            dispatchEvent(new Event("bandIdsChanged"));
            return;
        }// end function

        public function get compressionQuality() : Number
        {
            return this._compressionQuality;
        }// end function

        private function set _130072761compressionQuality(value:Number) : void
        {
            this._compressionQuality = value;
            invalidateLayer();
            return;
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

        public function get fields() : Array
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.fields) : (null);
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

        public function get interpolation() : String
        {
            return this._interpolation;
        }// end function

        private function set _559331748interpolation(value:String) : void
        {
            this._interpolation = value;
            invalidateLayer();
            return;
        }// end function

        public function get maxBandValues() : Array
        {
            var _loc_1:Array = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.maxValues;
            }
            return _loc_1;
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

        public function get maxPixelSize() : Number
        {
            var _loc_1:Number = NaN;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.maxPixelSize;
            }
            return _loc_1;
        }// end function

        public function get maxRecordCount() : Number
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.maxRecordCount) : (NaN);
        }// end function

        public function get meanBandValues() : Array
        {
            var _loc_1:Array = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.meanValues;
            }
            return _loc_1;
        }// end function

        public function get minBandValues() : Array
        {
            var _loc_1:Array = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.minValues;
            }
            return _loc_1;
        }// end function

        public function get minPixelSize() : Number
        {
            var _loc_1:Number = NaN;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.minPixelSize;
            }
            return _loc_1;
        }// end function

        public function get mosaicRule() : MosaicRule
        {
            return this._mosaicRule;
        }// end function

        public function set mosaicRule(value:MosaicRule) : void
        {
            this._mosaicRule = value;
            invalidateLayer();
            dispatchEvent(new Event("mosaicRuleChanged"));
            return;
        }// end function

        public function get noData() : Number
        {
            return this._noData;
        }// end function

        private function set _1041127157noData(value:Number) : void
        {
            this._noData = value;
            invalidateLayer();
            return;
        }// end function

        public function get objectIdField() : String
        {
            var _loc_1:String = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.objectIdField;
            }
            return _loc_1;
        }// end function

        public function get pixelSizeX() : Number
        {
            var _loc_1:Number = NaN;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.pixelSizeX;
            }
            return _loc_1;
        }// end function

        public function get pixelSizeY() : Number
        {
            var _loc_1:Number = NaN;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.pixelSizeY;
            }
            return _loc_1;
        }// end function

        public function get pixelType() : String
        {
            var _loc_1:String = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.pixelType;
            }
            return _loc_1;
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

        public function get renderingRule() : RasterFunction
        {
            return this._renderingRule;
        }// end function

        public function set renderingRule(value:RasterFunction) : void
        {
            this._renderingRule = value;
            invalidateLayer();
            dispatchEvent(new Event("renderingRuleChanged"));
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

        public function get serviceDataType() : String
        {
            var _loc_1:String = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.serviceDataType;
            }
            return _loc_1;
        }// end function

        public function get serviceDescription() : String
        {
            return this._mapServiceInfo ? (this._mapServiceInfo.serviceDescription) : (null);
        }// end function

        public function get stdvBandValues() : Array
        {
            var _loc_1:Array = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.rawObj)
            {
                _loc_1 = this._mapServiceInfo.rawObj.stdvValues;
            }
            return _loc_1;
        }// end function

        public function get timeInfo() : TimeInfo
        {
            var _loc_1:TimeInfo = null;
            if (this._mapServiceInfo)
            {
            }
            if (this._mapServiceInfo.timeInfo)
            {
            }
            if (this._mapServiceInfo.timeInfo.timeExtent)
            {
                _loc_1 = this._mapServiceInfo.timeInfo;
            }
            return _loc_1;
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
            return this._mapServiceInfo ? (this._mapServiceInfo.imageServiceVersion) : (NaN);
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
            var _loc_11:SRInfo = null;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_2:* = this.buildStartRect();
            var _loc_3:* = map.extent;
            var _loc_4:* = _loc_3.spatialReference;
            if (_loc_2.x == 0)
            {
            }
            if (_loc_2.y != 0)
            {
                _loc_3 = this.buildExtent(_loc_2, _loc_4);
                loader.x = _loc_2.x;
                loader.y = _loc_2.y;
            }
            var _loc_5:* = _loc_2.width;
            var _loc_6:* = _loc_2.height;
            var _loc_7:* = _loc_3.width;
            if (this.version >= 10)
            {
            }
            if (map.wrapAround180)
            {
            }
            if (_loc_4)
            {
                _loc_11 = _loc_4.info;
                if (_loc_7 > _loc_11.world)
                {
                    _loc_3 = _loc_3.duplicate();
                    _loc_3.xmin = _loc_11.valid[0];
                    _loc_3.xmax = _loc_11.valid[1];
                    _loc_12 = map.toScreenX(_loc_3.xmin);
                    _loc_13 = map.toScreenX(_loc_3.xmax);
                    _loc_5 = Math.round(_loc_13 - _loc_12);
                    loader.x = _loc_12;
                    loader.addEventListener(Event.COMPLETE, this.loader_completeHandler, false, -1, true);
                }
                else
                {
                    _loc_3 = _loc_3.normalize(true) as Extent;
                }
            }
            var _loc_8:* = this.getURLVariables(_loc_3, _loc_5, _loc_6);
            _loc_8.f = "image";
            var _loc_9:* = this.credential ? (this.credential.token) : (null);
            var _loc_10:* = AGSUtil.getURLRequest(this.urlObj, "/exportImage", _loc_8, this.token, this._proxyURLObj, null, _loc_9);
            loader.load(_loc_10);
            return;
        }// end function

        override public function refresh() : void
        {
            super.refresh();
            this._addTimestamp = true;
            return;
        }// end function

        private function loadMapServiceInfo() : void
        {
            var thisLayer:ArcGISImageServiceLayer;
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

        protected function getURLVariables(extent:Extent, width:Number, height:Number) : URLVariables
        {
            var _loc_4:* = new ImageServiceParameters();
            _loc_4.bandIds = this.bandIds;
            _loc_4.compressionQuality = this.compressionQuality;
            _loc_4.extent = extent;
            _loc_4.format = this.imageFormat;
            _loc_4.width = width;
            _loc_4.height = height;
            _loc_4.interpolation = this.interpolation;
            _loc_4.mosaicRule = this.mosaicRule;
            _loc_4.noData = this.noData;
            _loc_4.renderingRule = this.renderingRule;
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

        public function exportMapImage(imageServiceParameters:ImageServiceParameters = null, responder:IResponder = null) : AsyncToken
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var extent:Extent;
            var startRect:Rectangle;
            var imageServiceParameters:* = imageServiceParameters;
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
            var params:* = imageServiceParameters;
            if (!params)
            {
                params = new ImageServiceParameters();
            }
            if (this.version >= 10)
            {
                params.normalize = map ? (map.wrapAround180) : (true);
            }
            if (!params.bandIds)
            {
                params.bandIds = this.bandIds;
            }
            if (isNaN(params.compressionQuality))
            {
                params.compressionQuality = this.compressionQuality;
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
            if (isNaN(params.height))
            {
                isNaN(params.height);
            }
            if (map)
            {
                params.height = map.height;
            }
            if (!params.interpolation)
            {
                params.interpolation = this.interpolation;
            }
            if (!params.mosaicRule)
            {
                params.mosaicRule = this.mosaicRule;
            }
            if (isNaN(params.noData))
            {
                params.noData = this.noData;
            }
            if (!params.renderingRule)
            {
                params.renderingRule = this.renderingRule;
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
            var asyncToken:* = task.exportImage(params, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
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
                    _loc_5 = parent.scrollRect;
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

        public function set noData(value:Number) : void
        {
            arguments = this.noData;
            if (arguments !== value)
            {
                this._1041127157noData = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "noData", arguments, value));
                }
            }
            return;
        }// end function

        public function set interpolation(value:String) : void
        {
            arguments = this.interpolation;
            if (arguments !== value)
            {
                this._559331748interpolation = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "interpolation", arguments, value));
                }
            }
            return;
        }// end function

        public function set compressionQuality(value:Number) : void
        {
            arguments = this.compressionQuality;
            if (arguments !== value)
            {
                this._130072761compressionQuality = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "compressionQuality", arguments, value));
                }
            }
            return;
        }// end function

    }
}
