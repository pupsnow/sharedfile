package com.esri.ags.virtualearth
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.rpc.http.*;
    import mx.utils.*;

    public class VETiledLayer extends TiledMapServiceLayer implements IVETiledLayer
    {
        private var _service:HTTPService;
        private var _imageryInfo:Object;
        private var _tileServers:Array;
        private var _zoomRangeFrom:Number;
        private var _log:ILogger;
        private var _fullExtent:Extent;
        private var _initialExtent:Extent;
        private var _spatialReference:SpatialReference;
        private var _tileInfo:TileInfo;
        private var _culture:String = "en-US";
        private var _cultureChanged:Boolean;
        private var _key:String;
        private var _keyChanged:Boolean;
        private var _mapStyle:String = "road";
        private var _mapStyleChanged:Boolean;
        private var _url:String = "http://dev.virtualearth.net/REST/v1";
        public static const MAP_STYLE_AERIAL:String = "aerial";
        public static const MAP_STYLE_AERIAL_WITH_LABELS:String = "aerialWithLabels";
        public static const MAP_STYLE_ROAD:String = "road";
        private static const VE_URL:String = "http://dev.virtualearth.net/REST/v1";

        public function VETiledLayer(culture:String = "en-US", mapStyle:String = "road")
        {
            var traceHandler:Function;
            var culture:* = culture;
            var mapStyle:* = mapStyle;
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._fullExtent = new Extent(-2.00375e+007, -2.00375e+007, 2.00375e+007, 2.00375e+007, new SpatialReference(102100));
            this._initialExtent = new Extent(-2.00375e+007, -2.00375e+007, 2.00375e+007, 2.00375e+007, new SpatialReference(102100));
            this._spatialReference = new SpatialReference(102100);
            this._tileInfo = new TileInfo();
            traceHandler = function (event:Event) : void
            {
                return;
            }// end function
            ;
            this.buildTileInfo();
            this._service = new HTTPService();
            this._service.contentType = HTTPService.CONTENT_TYPE_FORM;
            this._service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            this._service.concurrency = "last";
            this._service.addEventListener(ResultEvent.RESULT, traceHandler);
            this._service.addEventListener(FaultEvent.FAULT, traceHandler);
            this.culture = culture;
            this.mapStyle = mapStyle;
            return;
        }// end function

        override public function get fullExtent() : Extent
        {
            return this._fullExtent;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._initialExtent;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._spatialReference;
        }// end function

        override public function get tileInfo() : TileInfo
        {
            return this._tileInfo;
        }// end function

        public function get units() : String
        {
            return Units.METERS;
        }// end function

        public function get culture() : String
        {
            return this._culture;
        }// end function

        public function set culture(value:String) : void
        {
            if (this._culture !== value)
            {
                this._culture = value;
                this._cultureChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("cultureChanged"));
            }
            return;
        }// end function

        public function get key() : String
        {
            return this._key;
        }// end function

        public function set key(value:String) : void
        {
            if (this._key !== value)
            {
                this._key = value;
                this._keyChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("keyChanged"));
            }
            return;
        }// end function

        public function get mapStyle() : String
        {
            return this._mapStyle;
        }// end function

        public function set mapStyle(value:String) : void
        {
            if (this._mapStyle !== value)
            {
            }
            if (value)
            {
                this._mapStyle = value;
                this._mapStyleChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("mapStyleChanged"));
            }
            return;
        }// end function

        function get url() : String
        {
            return this._url;
        }// end function

        function set url(value:String) : void
        {
            this._url = value;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (!this._cultureChanged)
            {
            }
            if (this._mapStyleChanged)
            {
                removeAllChildren();
            }
            if (!this._keyChanged)
            {
            }
            if (!this._cultureChanged)
            {
            }
            if (this._mapStyleChanged)
            {
                this._keyChanged = false;
                this._cultureChanged = false;
                this._mapStyleChanged = false;
                setLoaded(false);
                this._imageryInfo = null;
                this.loadImageryInfo();
            }
            return;
        }// end function

        override protected function getTileURL(level:Number, row:Number, col:Number) : URLRequest
        {
            var _loc_4:* = this._tileServers[row % this._tileServers.length];
            var _loc_5:* = this.tileToQuadKey(level + this._zoomRangeFrom, row, col);
            _loc_4 = _loc_4.replace("{quadkey}", _loc_5);
            return new URLRequest(_loc_4);
        }// end function

        private function loadImageryInfo() : void
        {
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (event:ResultEvent, token:Object = null) : void
            {
                var _loc_4:String = null;
                var _loc_5:String = null;
                var _loc_6:Array = null;
                var _loc_7:String = null;
                var _loc_8:Fault = null;
                var _loc_3:* = JSONUtil.decode(event.result as String);
                if (_loc_3.statusCode == 200)
                {
                    processImageryInfo(_loc_3);
                    setLoaded(true);
                    invalidateLayer();
                }
                else
                {
                    _loc_4 = _loc_3.statusCode;
                    _loc_5 = _loc_3.statusDescription;
                    _loc_6 = _loc_3.errorDetails as Array;
                    _loc_7 = _loc_6 ? (_loc_6.join("\n")) : ("");
                    _loc_8 = new Fault(_loc_4, _loc_5, _loc_7);
                    if (Log.isError())
                    {
                        _log.error("{0}::{1}", id, _loc_8);
                    }
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, token as Layer, _loc_8));
                }
                return;
            }// end function
            ;
            myFaultFunction = function (event:FaultEvent, token:Object = null) : void
            {
                var _loc_3:SecurityErrorEvent = null;
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, ObjectUtil.toString(event.fault));
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
            if (!this.mapStyle)
            {
                return;
            }
            this._service.url = this.url + "/Imagery/Metadata/" + this.mapStyle;
            var params:* = new URLVariables();
            if (this.culture)
            {
                params.c = this.culture;
            }
            params.ss = true;
            params.key = this.key;
            var asyncToken:* = this._service.send(params);
            asyncToken.addResponder(new AsyncResponder(myResultFunction, myFaultFunction, this));
            return;
        }// end function

        private function processImageryInfo(info:Object) : void
        {
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:TileInfo = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            this._imageryInfo = info;
            info = info.resourceSets[0].resources[0];
            var _loc_2:* = info.imageUrl;
            _loc_2 = _loc_2.replace("{culture}", this.culture);
            this._tileServers = [];
            var _loc_3:* = info.imageUrlSubdomains as Array;
            for each (_loc_4 in _loc_3)
            {
                
                this._tileServers.push(_loc_2.replace("{subdomain}", _loc_4));
            }
            this._zoomRangeFrom = info.zoomMin;
            _loc_5 = info.zoomMax;
            if (!isNaN(this._zoomRangeFrom))
            {
            }
            if (!isNaN(_loc_5))
            {
                if (_loc_5 === 19)
                {
                    _loc_5 = 21;
                }
                this.buildTileInfo();
                _loc_6 = this.tileInfo;
                _loc_6.lods = _loc_6.lods.slice(this._zoomRangeFrom, (_loc_5 + 1));
                _loc_7 = 0;
                _loc_8 = _loc_6.lods.length;
                while (_loc_7 < _loc_8)
                {
                    
                    LOD(_loc_6.lods[_loc_7]).level = _loc_7;
                    _loc_7 = _loc_7 + 1;
                }
            }
            return;
        }// end function

        private function buildTileInfo() : void
        {
            this._tileInfo.dpi = 96;
            this._tileInfo.height = 256;
            this._tileInfo.width = 256;
            this._tileInfo.origin = new MapPoint(-2.00375e+007, 2.00375e+007);
            this._tileInfo.spatialReference = new SpatialReference(102100);
            this._tileInfo.lods = [new LOD(0, 156543, 5.91658e+008), new LOD(1, 78271.5, 2.95829e+008), new LOD(2, 39135.8, 1.47914e+008), new LOD(3, 19567.9, 7.39572e+007), new LOD(4, 9783.94, 3.69786e+007), new LOD(5, 4891.97, 1.84893e+007), new LOD(6, 2445.98, 9.24465e+006), new LOD(7, 1222.99, 4.62232e+006), new LOD(8, 611.496, 2.31116e+006), new LOD(9, 305.748, 1.15558e+006), new LOD(10, 152.874, 577791), new LOD(11, 76.437, 288895), new LOD(12, 38.2185, 144448), new LOD(13, 19.1093, 72223.8), new LOD(14, 9.55463, 36111.9), new LOD(15, 4.77731, 18056), new LOD(16, 2.38866, 9027.98), new LOD(17, 1.19433, 4513.99), new LOD(18, 0.597164, 2256.99), new LOD(19, 0.298582, 1128.5), new LOD(20, 0.149291, 564.249), new LOD(21, 0.0746455, 282.124), new LOD(22, 0.0373228, 141.062), new LOD(23, 0.0186614, 70.5311)];
            return;
        }// end function

        private function tileToQuadKey(level:Number, ty:Number, tx:Number) : String
        {
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_4:String = "";
            var _loc_5:* = level;
            while (_loc_5 > 0)
            {
                
                _loc_6 = 0;
                _loc_7 = 1 << (_loc_5 - 1);
                if ((tx & _loc_7) != 0)
                {
                    _loc_6 = _loc_6 + 1;
                }
                if ((ty & _loc_7) != 0)
                {
                    _loc_6 = _loc_6 + 2;
                }
                _loc_4 = _loc_4 + _loc_6;
                _loc_5 = _loc_5 - 1;
            }
            return _loc_4;
        }// end function

    }
}
