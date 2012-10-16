package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.rpc.http.*;

    public class WMTSLayer extends TiledMapServiceLayer
    {
        private var _log:ILogger;
        private var _fullImageFormat:String;
        private var _service:HTTPService;
        private var _tileUrl:String;
        private var _tileInfo:TileInfo;
        private var _idToIdentifierString:Dictionary;
        private var _fullExtent:Extent;
        private var _fullExtentSet:Boolean;
        private var _initialExtent:Extent;
        private var _initialExtentSet:Boolean;
        private var _spatialReference:SpatialReference;
        private var _abstract:String;
        private var _abstractSet:Boolean;
        private var _copyright:String;
        private var _copyrightSet:Boolean;
        private var _imageFormat:String;
        private var _imageFormatChanged:Boolean;
        private var _layerId:String;
        private var _proxyURLObj:URL;
        private var _serviceMode:String = "RESTful";
        private var _style:String;
        private var _styleSet:Boolean;
        private var _tileMatrixSetId:String;
        private var _title:String;
        private var _titleSet:Boolean;
        private var _urlObj:URL;
        private var _urlChanged:Boolean = false;
        private var _version:String = "1.0.0";
        private static const SUPPORTED_SERVICE_MODES:Array = ["KVP", "RESTful"];

        public function WMTSLayer(url:String = null, proxyURL:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._idToIdentifierString = new Dictionary();
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

        override public function get fullExtent() : Extent
        {
            return this._fullExtent ? (this._fullExtent) : (super.fullExtent);
        }// end function

        public function set fullExtent(value:Extent) : void
        {
            this._fullExtent = value;
            this._fullExtentSet = true;
            dispatchEvent(new Event("initialExtentChanged"));
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

        override public function get tileInfo() : TileInfo
        {
            return this._tileInfo;
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

        public function get copyright() : String
        {
            return this._copyright;
        }// end function

        private function set _1522889671copyright(value:String) : void
        {
            this._copyright = value;
            this._copyrightSet = true;
            return;
        }// end function

        public function get imageFormat() : String
        {
            return this._imageFormat;
        }// end function

        public function set imageFormat(value:String) : void
        {
            this._imageFormat = value;
            this._imageFormatChanged = true;
            invalidateProperties();
            invalidateLayer();
            dispatchEvent(new Event("imageFormatChanged"));
            return;
        }// end function

        public function get layerId() : String
        {
            return this._layerId;
        }// end function

        public function set layerId(value:String) : void
        {
            this._layerId = value;
            invalidateLayer();
            dispatchEvent(new Event("layerIdChanged"));
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

        public function get serviceMode() : String
        {
            return this._serviceMode;
        }// end function

        public function set serviceMode(value:String) : void
        {
            if (this._serviceMode !== value)
            {
            }
            if (SUPPORTED_SERVICE_MODES.indexOf(value) != -1)
            {
                this._serviceMode = value;
                dispatchEvent(new Event("serviceModeChanged"));
            }
            return;
        }// end function

        public function get style() : String
        {
            return this._style;
        }// end function

        private function set _109780401style(value:String) : void
        {
            this._style = value;
            this._styleSet = true;
            return;
        }// end function

        public function get tileMatrixSetId() : String
        {
            return this._tileMatrixSetId;
        }// end function

        public function set tileMatrixSetId(value:String) : void
        {
            this._tileMatrixSetId = value;
            invalidateLayer();
            dispatchEvent(new Event("tileMatrixSetIdChanged"));
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
                setLoaded(false);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        public function get version() : String
        {
            return this._version;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:String = null;
            super.commitProperties();
            if (this._imageFormatChanged)
            {
                this._imageFormatChanged = false;
                _loc_1 = this.imageFormat ? (this.imageFormat.toLowerCase()) : ("");
                this._fullImageFormat = "image/" + _loc_1;
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                removeAllChildren();
                this.loadCapabilities();
            }
            return;
        }// end function

        override protected function getTileURL(level:Number, row:Number, col:Number) : URLRequest
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:Object = null;
            if (!this._tileUrl)
            {
                this._tileUrl = this._urlObj.path;
            }
            if (this._proxyURLObj.path)
            {
                this._tileUrl = this._proxyURLObj.path + "?" + this._tileUrl;
            }
            var _loc_4:* = this._idToIdentifierString[level] ? (this._idToIdentifierString[level]) : (level);
            if (this.serviceMode == "KVP")
            {
                _loc_5 = this._tileUrl + "SERVICE=WMTS&VERSION=" + this.version + "&REQUEST=GetTile" + "&LAYER=" + this._layerId + "&STYLE=" + this._style + "&FORMAT=" + this._fullImageFormat + "&TILEMATRIXSET=" + this._tileMatrixSetId + "&TILEMATRIX=" + _loc_4 + "&TILEROW=" + row + "&TILECOL=" + col;
            }
            else if (this.serviceMode == "RESTful")
            {
                _loc_7 = {image/png:".png", image/png8:".png", image/png24:".png", image/png32:".png", image/jpg:".jpg", image/jpeg:".jpg", image/gif:".gif", image/bmp:".bmp", image/tiff:".tif"};
                if (_loc_7[this._fullImageFormat])
                {
                    _loc_6 = _loc_7[this._fullImageFormat];
                }
                _loc_5 = this._tileUrl + this._layerId + "/" + this._style + "/" + this._tileMatrixSetId + "/" + _loc_4 + "/" + row + "/" + col + _loc_6;
            }
            return new URLRequest(_loc_5);
        }// end function

        private function loadCapabilitiesEarly() : void
        {
            if (!parent)
            {
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                this.loadCapabilities();
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
            var thisLayer:WMTSLayer;
            var token:AsyncToken;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (event:ResultEvent, token:Object = null) : void
            {
                var _loc_5:Fault = null;
                var _loc_6:Namespace = null;
                var _loc_7:XMLList = null;
                var _loc_8:XML = null;
                var _loc_9:XMLList = null;
                var _loc_10:XML = null;
                var _loc_11:XML = null;
                var _loc_12:Array = null;
                var _loc_13:XML = null;
                var _loc_14:XMLList = null;
                var _loc_15:XML = null;
                var _loc_16:XML = null;
                var _loc_17:String = null;
                var _loc_18:Namespace = null;
                var _loc_19:XMLList = null;
                var _loc_20:XML = null;
                var _loc_21:XMLList = null;
                var _loc_22:XML = null;
                var _loc_23:String = null;
                var _loc_24:XMLList = null;
                var _loc_25:Boolean = false;
                var _loc_26:XML = null;
                var _loc_27:XMLList = null;
                var _loc_28:XMLList = null;
                var _loc_29:XML = null;
                var _loc_30:XML = null;
                var _loc_31:Number = NaN;
                var _loc_32:XML = null;
                var _loc_33:int = 0;
                var _loc_34:int = 0;
                var _loc_35:Array = null;
                var _loc_36:String = null;
                var _loc_37:String = null;
                var _loc_38:MapPoint = null;
                var _loc_39:Number = NaN;
                var _loc_40:Number = NaN;
                var _loc_41:Array = null;
                var _loc_42:XMLList = null;
                var _loc_43:Number = NaN;
                var _loc_44:Number = NaN;
                var _loc_45:Number = NaN;
                var _loc_46:Number = NaN;
                var _loc_47:Number = NaN;
                var _loc_48:Number = NaN;
                var _loc_49:Extent = null;
                var _loc_50:Array = null;
                var _loc_51:Array = null;
                var _loc_52:XML = null;
                var _loc_53:XML = null;
                var _loc_54:int = 0;
                var _loc_3:* = event.result as XML;
                var _loc_4:* = new Namespace("http://www.opengis.net/wmts/1.0");
                if (_loc_4::ServiceException[0])
                {
                    _loc_5 = new Fault(_loc_4::ServiceException[0].@code[0], _loc_4::ServiceException[0]);
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, _loc_5));
                }
                else
                {
                    _loc_6 = new Namespace("http://www.opengis.net/ows/1.1");
                    _loc_7 = _loc_3.._loc_6::Operation;
                    for each (_loc_8 in _loc_7)
                    {
                        
                        _loc_17 = _loc_8.@name[0];
                        if (_loc_17)
                        {
                        }
                        if (_loc_17.indexOf("GetTile") != -1)
                        {
                            _loc_18 = new Namespace("http://www.w3.org/1999/xlink");
                            _loc_19 = _loc_8.._loc_6::Get;
                            for each (_loc_20 in _loc_19)
                            {
                                
                                if (_loc_20.._loc_6::Value[0])
                                {
                                }
                                if (_loc_20.._loc_6::Value[0] == serviceMode)
                                {
                                    _tileUrl = _loc_18::@href[0];
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    if (_tileUrl.indexOf("/1.0.0/") == -1)
                    {
                    }
                    if (serviceMode == "RESTful")
                    {
                        _tileUrl = _tileUrl + "/1.0.0/";
                    }
                    if (!_copyrightSet)
                    {
                        thisLayer.copyright = _loc_6::AccessConstraints[0];
                        _copyrightSet = false;
                    }
                    if (!_layerId)
                    {
                        _layerId = _loc_6::Identifier[0][0];
                    }
                    _loc_9 = _loc_3.._loc_4::Layer;
                    for each (_loc_11 in _loc_9)
                    {
                        
                        if (_loc_6::Identifier[0] == _layerId)
                        {
                            _loc_10 = _loc_11;
                            break;
                        }
                    }
                    if (!_abstractSet)
                    {
                        thisLayer.abstract = _loc_4::Abstract[0];
                        _abstractSet = false;
                    }
                    if (!_titleSet)
                    {
                        thisLayer.title = _loc_4::Title[0];
                        _titleSet = false;
                    }
                    if (!_styleSet)
                    {
                        _loc_21 = _loc_4::Style;
                        for each (_loc_22 in _loc_21)
                        {
                            
                            if (_loc_22.@isDefault[0])
                            {
                                thisLayer.style = _loc_6::Identifier[0];
                                _styleSet = false;
                                break;
                            }
                        }
                    }
                    _loc_12 = [];
                    for each (_loc_13 in _loc_4::Format)
                    {
                        
                        _loc_12.push(String(_loc_13[0]));
                    }
                    if (_fullImageFormat)
                    {
                        if (_loc_12.indexOf(_fullImageFormat) == -1)
                        {
                            _fullImageFormat = _loc_12[0];
                        }
                    }
                    else
                    {
                        _fullImageFormat = _loc_12[0];
                    }
                    _imageFormat = _fullImageFormat.substring((_fullImageFormat.indexOf("/") + 1), _fullImageFormat.length);
                    if (!_tileMatrixSetId)
                    {
                        _loc_24 = _loc_10.._loc_4::TileMatrixSet;
                        for each (_loc_26 in _loc_24)
                        {
                            
                            if (String(_loc_26[0]).indexOf("GoogleMapsCompatible") != -1)
                            {
                                _loc_23 = "GoogleMapsCompatible";
                                _loc_25 = true;
                                break;
                            }
                        }
                        if (!_loc_25)
                        {
                            _loc_23 = _loc_24[0][0];
                        }
                        _tileMatrixSetId = _loc_23;
                    }
                    _loc_14 = _loc_4::TileMatrixSetLink;
                    for each (_loc_16 in _loc_14)
                    {
                        
                        if (_loc_4::TileMatrixSet[0] == _tileMatrixSetId)
                        {
                            _loc_15 = _loc_16;
                            break;
                        }
                    }
                    if (_loc_15)
                    {
                        _loc_27 = _loc_4::TileMatrix;
                        _loc_28 = _loc_4::TileMatrixSet;
                        for each (_loc_30 in _loc_28)
                        {
                            
                            if (_loc_6::Identifier[0] == _tileMatrixSetId)
                            {
                                _loc_29 = _loc_30;
                                break;
                            }
                        }
                        _loc_31 = String(_loc_6::SupportedCRS[0]).split(":").pop();
                        if (_loc_31 == 900913)
                        {
                            _loc_31 = 3857;
                        }
                        _spatialReference = new SpatialReference(_loc_31);
                        _loc_32 = _loc_4::TileMatrix[0];
                        _loc_33 = parseInt(_loc_4::TileWidth[0], 10);
                        _loc_34 = parseInt(_loc_4::TileHeight[0], 10);
                        _loc_35 = _loc_4::TopLeftCorner[0].split(" ");
                        _loc_36 = _loc_35[0];
                        _loc_37 = _loc_35[1];
                        if (_loc_36.split("E").length > 1)
                        {
                            _loc_50 = _loc_36.split("E");
                            _loc_36 = String(_loc_50[0] * Math.pow(10, _loc_50[1]));
                        }
                        if (_loc_37.split("E").length > 1)
                        {
                            _loc_51 = _loc_37.split("E");
                            _loc_37 = String(_loc_51[0] * Math.pow(10, _loc_51[1]));
                        }
                        _loc_38 = new MapPoint(parseInt(_loc_36, 10), parseInt(_loc_37, 10));
                        if (_loc_31 != 3857)
                        {
                        }
                        if (_loc_31 != 102113)
                        {
                        }
                        if (_loc_31 == 102100)
                        {
                            _loc_38.x = -2.00375e+007;
                            _loc_38.y = 2.00375e+007;
                        }
                        else if (_loc_31 == 4326)
                        {
                            _loc_38.x = -180;
                            _loc_38.y = 90;
                        }
                        _loc_39 = _loc_4::MatrixWidth[0];
                        _loc_40 = _loc_4::MatrixHeight[0];
                        _loc_41 = [];
                        _loc_42 = _loc_4::TileMatrix;
                        if (_loc_27.length() == 0)
                        {
                            for each (_loc_52 in _loc_42)
                            {
                                
                                _loc_41.push(getLodFromTileMatrix(_loc_52, _loc_31));
                            }
                        }
                        else
                        {
                            for each (_loc_53 in _loc_27)
                            {
                                
                                _loc_54 = 0;
                                while (_loc_54 < _loc_42.length())
                                {
                                    
                                    if (_loc_6::Identifier[0] == _loc_53[0])
                                    {
                                        _loc_41.push(getLodFromTileMatrix(_loc_52[_loc_54], _loc_31));
                                        break;
                                        continue;
                                    }
                                    _loc_54 = _loc_54 + 1;
                                }
                            }
                        }
                        _loc_43 = _loc_38.x;
                        _loc_44 = _loc_38.y;
                        _loc_45 = _loc_39 > _loc_40 ? (_loc_39) : (_loc_40);
                        _loc_46 = _loc_39 > _loc_40 ? (_loc_40) : (_loc_39);
                        _loc_47 = _loc_43 + _loc_45 * _loc_34 * _loc_41[0].resolution;
                        _loc_48 = _loc_44 - _loc_46 * _loc_33 * _loc_41[0].resolution;
                        _loc_49 = new Extent(_loc_43, _loc_48, _loc_47, _loc_44, _spatialReference);
                        if (!_initialExtentSet)
                        {
                            thisLayer.initialExtent = _loc_49;
                            _initialExtentSet = false;
                        }
                        if (!_fullExtentSet)
                        {
                            thisLayer.fullExtent = _loc_49;
                            _fullExtentSet = false;
                        }
                        _tileInfo = new TileInfo();
                        _tileInfo.dpi = 90.7143;
                        _tileInfo.spatialReference = _spatialReference;
                        _tileInfo.format = _imageFormat;
                        _tileInfo.height = _loc_33;
                        _tileInfo.width = _loc_34;
                        _tileInfo.origin = _loc_38;
                        _tileInfo.lods = _loc_41;
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
            if (this.serviceMode == "KVP")
            {
                urlVariables.SERVICE = "WMTS";
                urlVariables.REQUEST = "GetCapabilities";
                urlVariables.VERSION = this.version;
                this._service.url = this.getServiceURL(urlVariables);
            }
            else if (this.serviceMode == "RESTful")
            {
                this._service.url = this.getServiceURL() + "/" + this.version + "/WMTSCapabilities.xml";
            }
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

        private function getLodFromTileMatrix(tileMatrix:XML, wkid:int) : LOD
        {
            var _loc_5:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:String = null;
            var _loc_13:Array = null;
            var _loc_3:* = new Namespace("http://www.opengis.net/ows/1.1");
            var _loc_4:* = new Namespace("http://www.opengis.net/wmts/1.0");
            var _loc_6:* = _loc_3::Identifier[0];
            if (_loc_6.indexOf(":") != -1)
            {
                _loc_11 = [];
                for each (_loc_12 in _loc_6.split(":"))
                {
                    
                    _loc_11.push(_loc_12);
                }
                _loc_5 = _loc_11[(_loc_11.length - 1)];
                this._idToIdentifierString[_loc_5] = _loc_6;
            }
            else
            {
                _loc_5 = Number(_loc_6);
            }
            var _loc_7:* = _loc_4::ScaleDenominator[0];
            if (_loc_7.split("E").length > 1)
            {
                _loc_13 = _loc_7.split("E");
                _loc_8 = _loc_13[0] * Math.pow(10, _loc_13[1]);
            }
            else
            {
                _loc_8 = parseFloat(_loc_7);
            }
            if (wkid in WKIDUnitConversion.WKIDS)
            {
                _loc_9 = WKIDUnitConversion.VALUES[WKIDUnitConversion.WKIDS[wkid]];
            }
            else
            {
                _loc_9 = 111195;
            }
            var _loc_10:* = _loc_8 * 7 / 25000 / _loc_9;
            return new LOD(_loc_5, _loc_10, _loc_8);
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

        public function set style(value:String) : void
        {
            arguments = this.style;
            if (arguments !== value)
            {
                this._109780401style = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "style", arguments, value));
                }
            }
            return;
        }// end function

        public function set copyright(value:String) : void
        {
            arguments = this.copyright;
            if (arguments !== value)
            {
                this._1522889671copyright = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "copyright", arguments, value));
                }
            }
            return;
        }// end function

    }
}
