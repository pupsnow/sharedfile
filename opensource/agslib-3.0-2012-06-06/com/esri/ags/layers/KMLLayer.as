package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.logging.*;
    import mx.rpc.*;
    import spark.components.*;

    public class KMLLayer extends Layer implements ILegendSupport
    {
        private var _log:ILogger;
        private var _kmlInfo:KMLInfo;
        private var _content:Array;
        private var _screenOverlays:Array;
        private var _screenOverlayImages:Array;
        private var _screenOverlayImageToVisibility:Dictionary;
        private var _networkLinkToVisibility:Dictionary;
        private var _kmlLayerToMapImageLayer:Dictionary;
        private var _arrMapImageOrFeatureLayer:Array;
        private var _outSpatialReference:SpatialReference;
        private var _outSpatialReferenceSent:SpatialReference;
        private var _doClientSideConversion:Boolean;
        private var _networkLinkTurnedOffByFolder:Boolean;
        private var _timeoutHandle:uint;
        private var _description:String;
        private var _disableClientCaching:Boolean;
        private var _initialExtent:Extent;
        private var _requestTimeout:int = -1;
        private var _respectFeatureVisibility:Boolean = false;
        private var _snippet:String;
        private var _serviceURL:String = "http://utility.arcgis.com/sharing/kml";
        private var _serviceURLChanged:Boolean;
        private var _urlObj:URL;
        private var _urlChanged:Boolean = false;
        var visibleFolders:Array;
        var httpQuery:String;
        var viewFormat:String;
        var viewBoundScale:Number;
        var refreshMode:String;
        var refreshInterval:Number;
        var viewRefreshMode:String;
        var viewRefreshTime:Number;
        private static const WEB_MERCATOR_IDS:Array = [102100, 3857, 102113];

        public function KMLLayer(url:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._screenOverlays = [];
            this._screenOverlayImages = [];
            this._screenOverlayImageToVisibility = new Dictionary();
            this._networkLinkToVisibility = new Dictionary();
            this._kmlLayerToMapImageLayer = new Dictionary();
            this._outSpatialReference = new SpatialReference(4326);
            this._outSpatialReferenceSent = new SpatialReference();
            this._urlObj = new URL();
            this.url = url;
            return;
        }// end function

        public function get description() : String
        {
            return this._description;
        }// end function

        private function set _1724546052description(value:String) : void
        {
            this._description = value;
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

        public function get featureInfos() : Array
        {
            return this._kmlInfo ? (this._kmlInfo.featureInfos) : (null);
        }// end function

        public function get folders() : Array
        {
            return this._kmlInfo ? (this._kmlInfo.folders) : (null);
        }// end function

        public function get groundOverlays() : Array
        {
            return this._kmlInfo ? (this._kmlInfo.groundOverlays) : (null);
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._initialExtent;
        }// end function

        public function get layers() : Array
        {
            return this._arrMapImageOrFeatureLayer;
        }// end function

        public function get networkLinks() : Array
        {
            return this._kmlInfo ? (this._kmlInfo.networkLinks) : (null);
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

        public function get respectFeatureVisibility() : Boolean
        {
            return this._respectFeatureVisibility;
        }// end function

        private function set _159684222respectFeatureVisibility(value:Boolean) : void
        {
            this._respectFeatureVisibility = value;
            return;
        }// end function

        public function get snippet() : String
        {
            return this._snippet;
        }// end function

        private function set _2061635299snippet(value:String) : void
        {
            this._snippet = value;
            return;
        }// end function

        public function get screenOverlays() : Array
        {
            return this._kmlInfo ? (this._kmlInfo.screenOverlays) : (null);
        }// end function

        public function get serviceURL() : String
        {
            return this._serviceURL;
        }// end function

        public function set serviceURL(value:String) : void
        {
            if (this.serviceURL != value)
            {
                this._serviceURL = value;
                this._serviceURLChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get url() : String
        {
            return this._urlObj.sourceURL;
        }// end function

        public function set url(value:String) : void
        {
            if (this.url != value)
            {
            }
            if (value)
            {
                this._urlObj.update(value);
                this._urlChanged = true;
                invalidateProperties();
                this._kmlInfo = null;
                setLoaded(false);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        override public function set minScale(value:Number) : void
        {
            var _loc_2:Layer = null;
            super.minScale = value;
            for each (_loc_2 in this._content)
            {
                
                _loc_2.minScale = value;
            }
            return;
        }// end function

        override public function set maxScale(value:Number) : void
        {
            var _loc_2:Layer = null;
            super.maxScale = value;
            for each (_loc_2 in this._content)
            {
                
                _loc_2.maxScale = value;
            }
            return;
        }// end function

        override function setMap(map:Map) : void
        {
            var _loc_2:Layer = null;
            super.setMap(map);
            if (map)
            {
                for each (_loc_2 in this._content)
                {
                    
                    if (_loc_2.loaded)
                    {
                        _loc_2.setMap(map);
                        continue;
                    }
                    _loc_2.addEventListener(LayerEvent.LOAD, this.layerLoadHandler);
                }
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (!this._urlChanged)
            {
            }
            if (this._serviceURLChanged)
            {
            }
            if (visible)
            {
                this._urlChanged = false;
                this._serviceURLChanged = false;
                this.loadKMLInfo();
            }
            return;
        }// end function

        override protected function updateLayer() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            super.updateLayer();
            if (numChildren == 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this._content.length)
                {
                    
                    if (this._content[_loc_1] is MapImageLayer)
                    {
                    }
                    if (parent is KMLLayer)
                    {
                        _loc_3 = 0;
                        _loc_2 = 0;
                        while (_loc_2 < KMLLayer(parent).numChildren)
                        {
                            
                            if (KMLLayer(parent).getChildAt(_loc_2) is MapImageLayer)
                            {
                            }
                            if (this._content[_loc_1] !== KMLLayer(parent).getChildAt(_loc_2))
                            {
                                _loc_3 = _loc_3 + 1;
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                        KMLLayer(parent).addChildAt(this._content[_loc_1], _loc_3);
                    }
                    else
                    {
                        if (this._content[_loc_1] is FeatureLayer)
                        {
                        }
                        if (this._doClientSideConversion)
                        {
                            this.convertLayerFromGeographicToWebMercator(FeatureLayer(this._content[_loc_1]));
                        }
                        addChild(this._content[_loc_1]);
                    }
                    _loc_1 = _loc_1 + 1;
                }
                this.updateInitialExtent();
            }
            if (this._screenOverlayImages.length == 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this._screenOverlays.length)
                {
                    
                    this.addScreenOverlayImageToStaticLayer(this._screenOverlays[_loc_1].image, this._screenOverlays[_loc_1].overlay);
                    _loc_1 = _loc_1 + 1;
                }
            }
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }// end function

        override protected function showHandler(event:FlexEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:KMLLayer = null;
            super.showHandler(event);
            invalidateProperties();
            if (parent is KMLLayer)
            {
                _loc_3 = KMLLayer(parent);
                _loc_2 = 0;
                while (_loc_2 < _loc_3.networkLinks.length)
                {
                    
                    if (_loc_3.networkLinks[_loc_2] == this)
                    {
                        _loc_3._networkLinkToVisibility[_loc_3.networkLinks[_loc_2]] = true;
                        break;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                if (this.layers)
                {
                }
                if (this.layers.length > 0)
                {
                }
                if (this.layers[0] is MapImageLayer)
                {
                    this.layers[0].visible = true;
                }
                if (loaded)
                {
                    this.checkAutoRefresh();
                }
            }
            if (this._screenOverlayImages.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this._screenOverlayImages.length)
                {
                    
                    this._screenOverlayImages[_loc_2].image.visible = this._screenOverlayImageToVisibility[this._screenOverlayImages[_loc_2].image];
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        override protected function hideHandler(event:FlexEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:KMLLayer = null;
            super.hideHandler(event);
            if (parent is KMLLayer)
            {
                _loc_3 = KMLLayer(parent);
                if (!_loc_3._networkLinkTurnedOffByFolder)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_3.networkLinks.length)
                    {
                        
                        if (_loc_3.networkLinks[_loc_2] == this)
                        {
                            _loc_3._networkLinkToVisibility[_loc_3.networkLinks[_loc_2]] = false;
                            break;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                }
                _loc_3._networkLinkTurnedOffByFolder = false;
                if (this.layers)
                {
                }
                if (this.layers.length > 0)
                {
                }
                if (this.layers[0] is MapImageLayer)
                {
                    this.layers[0].visible = false;
                }
                this.checkAutoRefresh();
            }
            _loc_2 = 0;
            while (_loc_2 < this._screenOverlayImages.length)
            {
                
                this._screenOverlayImageToVisibility[this._screenOverlayImages[_loc_2].image] = this._screenOverlayImages[_loc_2].image.visible;
                this._screenOverlayImages[_loc_2].image.visible = false;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        override protected function zoomStartHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function zoomEndHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function removedHandler(event:Event) : void
        {
            super.removedHandler(event);
            if (event.target == this)
            {
                this.removeScreenOverlayImages();
            }
            return;
        }// end function

        override public function refresh() : void
        {
            if (this.loaded)
            {
            }
            if (!this.map)
            {
                return;
            }
            this.loadKMLInfo();
            return;
        }// end function

        public function getLegendInfos(responder:IResponder = null) : AsyncToken
        {
            var _loc_9:Layer = null;
            var _loc_2:* = new AsyncToken();
            if (responder)
            {
                _loc_2.addResponder(responder);
            }
            var _loc_3:* = new Array();
            var _loc_4:* = new LayerLegendInfo();
            _loc_4.layerId = this.id;
            _loc_4.layerName = this.name ? (this.name) : (this.id);
            _loc_4.minScale = this.minScale;
            _loc_4.maxScale = this.maxScale;
            _loc_4.visible = this.visible;
            _loc_4.legendItemInfos = [];
            var _loc_5:Array = [];
            var _loc_6:Array = [];
            var _loc_7:int = 0;
            var _loc_8:* = this._arrMapImageOrFeatureLayer[0] is MapImageLayer ? ((this._arrMapImageOrFeatureLayer.length - 1)) : (this._arrMapImageOrFeatureLayer.length);
            for each (_loc_9 in this.layers)
            {
                
                if (_loc_9 is FeatureLayer)
                {
                    FeatureLayer(_loc_9).getLegendInfos(new AsyncResponder(this.getLegendResult, this.getLegendFault, _loc_4));
                }
            }
            _loc_3.push(_loc_4);
            if (FlexGlobals.topLevelApplication is UIComponent)
            {
                UIComponent(FlexGlobals.topLevelApplication).callLater(this.layerLegendInfosHandler, [_loc_3, _loc_2]);
            }
            else
            {
                this.layerLegendInfosHandler(_loc_3, _loc_2);
            }
            return _loc_2;
        }// end function

        private function layerLegendInfosHandler(result:Array, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(result);
            }
            return;
        }// end function

        private function getLegendResult(layerLegendInfos:Array, token:Object = null) : void
        {
            var _loc_3:LegendItemInfo = null;
            for each (_loc_3 in LayerLegendInfo(layerLegendInfos[0]).legendItemInfos)
            {
                
                LayerLegendInfo(token).legendItemInfos.push(_loc_3);
            }
            return;
        }// end function

        private function getLegendFault(fault:Fault, token:Object = null) : void
        {
            return;
        }// end function

        public function getFeature(featureInfo:KMLFeatureInfo) : Object
        {
            var _loc_2:Object = null;
            var _loc_5:Boolean = false;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            switch(featureInfo.type)
            {
                case KMLFeatureInfo.FOLDER:
                {
                    _loc_3 = 0;
                    while (_loc_3 < this.folders.length)
                    {
                        
                        if (this.folders[_loc_3].id == featureInfo.id)
                        {
                            _loc_2 = this.folders[_loc_3];
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.POLYGON:
                {
                    _loc_5 = false;
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.polygonFeatureLayers.length)
                    {
                        
                        _loc_6 = FeatureLayer(this._kmlInfo.polygonFeatureLayers[_loc_3]).featureCollection.featureSet.features;
                        _loc_4 = 0;
                        while (_loc_4 < _loc_6.length)
                        {
                            
                            if (featureInfo.id == Graphic(_loc_6[_loc_4]).attributes["id"])
                            {
                                _loc_2 = Graphic(_loc_6[_loc_4]);
                                _loc_5 = true;
                                break;
                                continue;
                            }
                            _loc_4 = _loc_4 + 1;
                        }
                        if (_loc_5)
                        {
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.LINE:
                {
                    _loc_5 = false;
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.polylineFeatureLayers.length)
                    {
                        
                        _loc_7 = FeatureLayer(this._kmlInfo.polylineFeatureLayers[_loc_3]).featureCollection.featureSet.features;
                        _loc_4 = 0;
                        while (_loc_4 < _loc_7.length)
                        {
                            
                            if (featureInfo.id == Graphic(_loc_7[_loc_4]).attributes["id"])
                            {
                                _loc_2 = Graphic(_loc_7[_loc_4]);
                                _loc_5 = true;
                                break;
                                continue;
                            }
                            _loc_4 = _loc_4 + 1;
                        }
                        if (_loc_5)
                        {
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.POINT:
                {
                    _loc_5 = false;
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.pointFeatureLayers.length)
                    {
                        
                        _loc_8 = FeatureLayer(this._kmlInfo.pointFeatureLayers[_loc_3]).featureCollection.featureSet.features;
                        _loc_4 = 0;
                        while (_loc_4 < _loc_8.length)
                        {
                            
                            if (featureInfo.id == Graphic(_loc_8[_loc_4]).attributes["id"])
                            {
                                _loc_2 = Graphic(_loc_8[_loc_4]);
                                _loc_5 = true;
                                break;
                                continue;
                            }
                            _loc_4 = _loc_4 + 1;
                        }
                        if (_loc_5)
                        {
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.GROUND_OVERLAY:
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.groundOverlays.length)
                    {
                        
                        if (this._kmlInfo.groundOverlays[_loc_3].id == featureInfo.id)
                        {
                            _loc_2 = this._kmlInfo.groundOverlays[_loc_3] as KMLGroundOverlay;
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.SCREEN_OVERLAY:
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.screenOverlays.length)
                    {
                        
                        if (this._kmlInfo.screenOverlays[_loc_3].id == featureInfo.id)
                        {
                            _loc_2 = this._kmlInfo.screenOverlays[_loc_3] as KMLScreenOverlay;
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                case KMLFeatureInfo.NETWORK_LINK:
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._kmlInfo.networkLinks.length)
                    {
                        
                        if (this._kmlInfo.networkLinks[_loc_3].id == String(featureInfo.id))
                        {
                            _loc_2 = this._kmlInfo.networkLinks[_loc_3] as KMLLayer;
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function setFolderVisibility(folder:KMLFolder, isVisible:Boolean) : void
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            if (!folder)
            {
                return;
            }
            folder.visible = isVisible;
            if (isVisible)
            {
                _loc_3 = this.getParentFolders(folder);
                if (_loc_3.length > 0)
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.length)
                    {
                        
                        if (!KMLFolder(_loc_3[_loc_4]).visible)
                        {
                            isVisible = false;
                            break;
                            continue;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                }
            }
            this.setState(folder, isVisible);
            return;
        }// end function

        private function loadKMLInfo() : void
        {
            var _loc_1:Map = null;
            var _loc_2:Extent = null;
            if (parent is LayerContainer)
            {
                _loc_1 = LayerContainer(parent).map;
            }
            else if (parent is KMLLayer)
            {
                _loc_1 = KMLLayer(parent).map;
                this.requestTimeout = KMLLayer(parent).requestTimeout;
                this.disableClientCaching = KMLLayer(parent).disableClientCaching;
            }
            if (_loc_1)
            {
                if (isBaseLayer)
                {
                    _loc_2 = _loc_1.extent;
                    if (_loc_2)
                    {
                    }
                    if (_loc_2.spatialReference)
                    {
                        this._outSpatialReference = _loc_2.spatialReference;
                    }
                    this.loadKMLInfo2(_loc_1);
                }
                else if (_loc_1.loaded)
                {
                    this._outSpatialReference = _loc_1.spatialReference;
                    this.loadKMLInfo2(_loc_1);
                }
                else
                {
                    _loc_1.addEventListener(MapEvent.LOAD, this.mapLoadHandler);
                }
            }
            return;
        }// end function

        private function mapLoadHandler(event:MapEvent) : void
        {
            this._outSpatialReference = event.map.spatialReference;
            this.loadKMLInfo2(event.map);
            return;
        }// end function

        private function loadKMLInfo2(map:Map) : void
        {
            var layer:Layer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var map:* = map;
            myResultFunction = function (result:Object, token:Object = null) : void
            {
                if (token == _serviceURL)
                {
                    _kmlInfo = result as KMLInfo;
                    if (_kmlInfo)
                    {
                        if (parent is KMLLayer)
                        {
                            removeMapImageLayerFromParent(KMLLayer(parent));
                        }
                        getKMLContent();
                        setLoaded(true);
                        checkAutoRefresh();
                        removeAllChildren();
                        removeScreenOverlayImages();
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
                dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, layer, error as Fault));
                return;
            }// end function
            ;
            layer;
            var task:* = new KMLTask(this._serviceURL);
            task.requestTimeout = this.requestTimeout;
            task.disableClientCaching = this.disableClientCaching;
            if (WEB_MERCATOR_IDS.indexOf(this._outSpatialReference.wkid) != -1)
            {
                this._doClientSideConversion = true;
                this._outSpatialReferenceSent.wkid = 4326;
            }
            else
            {
                this._outSpatialReferenceSent.wkid = this._outSpatialReference.wkid;
            }
            var model:String;
            var kmlURL:* = parent is KMLLayer ? (this.url + "?" + this.getNetworkLinkQueryParameters(map)) : (this.url);
            task.getKML(kmlURL, model, this._outSpatialReferenceSent, new AsyncResponder(myResultFunction, myFaultFunction, this._serviceURL));
            return;
        }// end function

        private function getKMLContent() : void
        {
            var _loc_1:KMLFolder = null;
            var _loc_2:MapImageLayer = null;
            var _loc_3:Array = null;
            var _loc_4:KMLGroundOverlay = null;
            var _loc_5:Extent = null;
            var _loc_6:int = 0;
            var _loc_7:FeatureLayer = null;
            var _loc_8:FeatureLayer = null;
            var _loc_9:FeatureLayer = null;
            var _loc_10:KMLScreenOverlay = null;
            var _loc_11:Image = null;
            var _loc_12:KMLLayer = null;
            var _loc_13:KMLFolder = null;
            this._arrMapImageOrFeatureLayer = [];
            this._content = [];
            if (this._kmlInfo.groundOverlays)
            {
            }
            if (this._kmlInfo.groundOverlays.length > 0)
            {
                _loc_2 = new MapImageLayer();
                this.setMapIfAlreadyPresent(_loc_2);
                _loc_3 = [];
                for each (_loc_4 in this._kmlInfo.groundOverlays)
                {
                    
                    if (_loc_4.source)
                    {
                        _loc_3.push(_loc_4);
                        _loc_2.add(_loc_4);
                    }
                }
                _loc_5 = _loc_3[0].extent;
                _loc_6 = 1;
                while (_loc_6 < _loc_3.length)
                {
                    
                    _loc_5 = _loc_5.union(_loc_3[_loc_6].extent);
                    _loc_6 = _loc_6 + 1;
                }
                this._kmlLayerToMapImageLayer[this] = _loc_2;
                _loc_2.initialExtent = _loc_5;
                this._arrMapImageOrFeatureLayer.push(_loc_2);
                this._content.push(_loc_2);
            }
            if (this._kmlInfo.polygonFeatureLayers)
            {
            }
            if (this._kmlInfo.polygonFeatureLayers.length > 0)
            {
                for each (_loc_7 in this._kmlInfo.polygonFeatureLayers)
                {
                    
                    this.setMapIfAlreadyPresent(_loc_7);
                    this._arrMapImageOrFeatureLayer.push(_loc_7);
                    this._content.push(_loc_7);
                }
            }
            if (this._kmlInfo.polylineFeatureLayers)
            {
            }
            if (this._kmlInfo.polylineFeatureLayers.length > 0)
            {
                for each (_loc_8 in this._kmlInfo.polylineFeatureLayers)
                {
                    
                    this.setMapIfAlreadyPresent(_loc_8);
                    this._arrMapImageOrFeatureLayer.push(_loc_8);
                    this._content.push(_loc_8);
                }
            }
            if (this._kmlInfo.pointFeatureLayers)
            {
            }
            if (this._kmlInfo.pointFeatureLayers.length > 0)
            {
                for each (_loc_9 in this._kmlInfo.pointFeatureLayers)
                {
                    
                    this.setMapIfAlreadyPresent(_loc_9);
                    this._arrMapImageOrFeatureLayer.push(_loc_9);
                    this._content.push(_loc_9);
                }
            }
            if (this._kmlInfo.screenOverlays)
            {
            }
            if (this._kmlInfo.screenOverlays.length > 0)
            {
                for each (_loc_10 in this._kmlInfo.screenOverlays)
                {
                    
                    _loc_11 = new Image();
                    this._screenOverlays.push({image:_loc_11, overlay:_loc_10});
                }
            }
            if (this._kmlInfo.networkLinks)
            {
            }
            if (this._kmlInfo.networkLinks.length > 0)
            {
                for each (_loc_12 in this._kmlInfo.networkLinks)
                {
                    
                    this.setMapIfAlreadyPresent(_loc_12);
                    this._networkLinkToVisibility[_loc_12] = _loc_12.visible;
                    this._content.push(_loc_12);
                }
            }
            this._initialExtent = this.getInitialExtentFromMapImageAndFeatureLayers(this);
            if (this.visibleFolders)
            {
            }
            if (this.visibleFolders.length > 0)
            {
                for each (_loc_13 in this._kmlInfo.folders)
                {
                    
                    _loc_13.visible = this.visibleFolders.indexOf(_loc_13.id) != -1 ? (true) : (false);
                }
            }
            for each (_loc_1 in this._kmlInfo.folders)
            {
                
                if (_loc_1.parentFolderId == -1)
                {
                    this.setState(_loc_1, _loc_1.visible);
                }
            }
            return;
        }// end function

        private function setMapIfAlreadyPresent(layer:Layer) : void
        {
            if (map)
            {
                layer.setMap(map);
            }
            return;
        }// end function

        private function getInitialExtentFromMapImageAndFeatureLayers(layer:KMLLayer) : Extent
        {
            var _loc_2:Extent = null;
            var _loc_3:int = 0;
            if (layer.layers.length > 0)
            {
                _loc_2 = layer.layers[0].initialExtent;
                _loc_3 = 1;
                while (_loc_3 < layer.layers.length)
                {
                    
                    _loc_2 = _loc_2.union(this._content[_loc_3].initialExtent);
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function updateInitialExtent() : void
        {
            var _loc_1:KMLLayer = null;
            if (this.networkLinks)
            {
            }
            if (this.networkLinks.length > 0)
            {
                for each (_loc_1 in this.networkLinks)
                {
                    
                    if (_loc_1.loaded)
                    {
                        this.updateInitialExtent2(_loc_1);
                        continue;
                    }
                    _loc_1.addEventListener(LayerEvent.LOAD, this.networkLink_loadHandler);
                }
            }
            return;
        }// end function

        private function networkLink_loadHandler(event:LayerEvent) : void
        {
            this.updateInitialExtent2(event.layer as KMLLayer);
            return;
        }// end function

        private function updateInitialExtent2(layer:KMLLayer) : void
        {
            var _loc_2:* = layer.parent as KMLLayer;
            if (!_loc_2._initialExtent)
            {
                _loc_2._initialExtent = layer.initialExtent;
            }
            else
            {
                _loc_2._initialExtent = _loc_2._initialExtent.union(layer.initialExtent);
            }
            return;
        }// end function

        private function setState(folder:KMLFolder, isVisible:Boolean) : void
        {
            var _loc_3:Object = null;
            var _loc_5:KMLFeatureInfo = null;
            var _loc_6:MapImageLayer = null;
            var _loc_7:Object = null;
            var _loc_8:Object = null;
            var _loc_4:int = 0;
            while (_loc_4 < folder.featureInfos.length)
            {
                
                _loc_5 = KMLFeatureInfo(folder.featureInfos[_loc_4]);
                _loc_3 = this.getFeature(_loc_5);
                if (_loc_3)
                {
                    switch(_loc_5.type)
                    {
                        case KMLFeatureInfo.FOLDER:
                        {
                            if (isVisible)
                            {
                            }
                            this.setState(_loc_3 as KMLFolder, KMLFolder(_loc_3).visible);
                            break;
                        }
                        case KMLFeatureInfo.NETWORK_LINK:
                        {
                            if (!isVisible)
                            {
                                this._networkLinkTurnedOffByFolder = true;
                                KMLLayer(_loc_3).visible = false;
                            }
                            else if (!this._networkLinkToVisibility[_loc_3])
                            {
                                KMLLayer(_loc_3).visible = false;
                            }
                            else
                            {
                                KMLLayer(_loc_3).visible = true;
                            }
                            break;
                        }
                        case KMLFeatureInfo.GROUND_OVERLAY:
                        {
                            _loc_6 = this._arrMapImageOrFeatureLayer[0];
                            if (_loc_6)
                            {
                                if (!isVisible)
                                {
                                    _loc_6.setImageVisibility(KMLGroundOverlay(_loc_3), false);
                                }
                                else if (!this.respectFeatureVisibility)
                                {
                                    _loc_6.setImageVisibility(KMLGroundOverlay(_loc_3), true);
                                }
                                else if (!KMLGroundOverlay(_loc_3).visible)
                                {
                                    _loc_6.setImageVisibility(KMLGroundOverlay(_loc_3), false);
                                }
                                else
                                {
                                    _loc_6.setImageVisibility(KMLGroundOverlay(_loc_3), true);
                                }
                            }
                            break;
                        }
                        case KMLFeatureInfo.SCREEN_OVERLAY:
                        {
                            if (this._screenOverlayImages.length > 0)
                            {
                                for each (_loc_7 in this._screenOverlayImages)
                                {
                                    
                                    this.setScreenOverlayImageVisibility(_loc_7.image, _loc_7.overlay, isVisible);
                                }
                            }
                            else
                            {
                                for each (_loc_8 in this._screenOverlays)
                                {
                                    
                                    this.setScreenOverlayImageVisibility(_loc_8.image, _loc_8.overlay, isVisible);
                                }
                            }
                            break;
                        }
                        case KMLFeatureInfo.POINT:
                        case KMLFeatureInfo.LINE:
                        case KMLFeatureInfo.POLYGON:
                        {
                            if (!isVisible)
                            {
                                Graphic(_loc_3).visible = false;
                            }
                            else if (!this.respectFeatureVisibility)
                            {
                                Graphic(_loc_3).visible = true;
                            }
                            else if (Graphic(_loc_3).attributes.visibility == 0)
                            {
                                Graphic(_loc_3).visible = false;
                            }
                            else
                            {
                                Graphic(_loc_3).visible = true;
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function setScreenOverlayImageVisibility(img:Image, overlay:KMLScreenOverlay, isVisible:Boolean) : void
        {
            if (!isVisible)
            {
                img.visible = false;
            }
            else if (!this.respectFeatureVisibility)
            {
                img.visible = true;
            }
            else if (!overlay.visible)
            {
                img.visible = false;
            }
            else
            {
                img.visible = true;
            }
            return;
        }// end function

        private function getParentFolders(folder:KMLFolder, arr:Array = null) : Array
        {
            var _loc_4:KMLFeatureInfo = null;
            var _loc_5:KMLFolder = null;
            if (!arr)
            {
                arr = [];
            }
            var _loc_3:* = folder.parentFolderId;
            if (_loc_3 != -1)
            {
                _loc_4 = new KMLFeatureInfo();
                _loc_4.type = KMLFeatureInfo.FOLDER;
                _loc_4.id = _loc_3;
                _loc_5 = this.getFeature(_loc_4) as KMLFolder;
                arr.push(_loc_5);
                return this.getParentFolders(_loc_5, arr);
            }
            return arr;
        }// end function

        private function addScreenOverlayImageToStaticLayer(screenOverlayImage:Image, screenOverlay:KMLScreenOverlay) : void
        {
            screenOverlayImage.scaleMode = BitmapScaleMode.STRETCH;
            screenOverlayImage.source = screenOverlay.href;
            if (screenOverlay.screenXUnits === "fraction")
            {
                if (screenOverlay.screenX < 0.5)
                {
                    screenOverlayImage.setStyle("left", map.width * screenOverlay.screenX);
                }
                else if (screenOverlay.screenX > 0.5)
                {
                    screenOverlayImage.setStyle("right", map.width - map.width * screenOverlay.screenX);
                }
                else
                {
                    screenOverlayImage.setStyle("horizontalCenter", 0);
                }
            }
            else
            {
                screenOverlayImage.setStyle("left", screenOverlay.screenX);
            }
            if (screenOverlay.screenYUnits === "fraction")
            {
                if (screenOverlay.screenY < 0.5)
                {
                    screenOverlayImage.setStyle("bottom", map.height * screenOverlay.screenY);
                }
                else if (screenOverlay.screenY > 0.5)
                {
                    screenOverlayImage.setStyle("top", map.height - map.height * screenOverlay.screenY);
                }
                else
                {
                    screenOverlayImage.setStyle("verticalCenter", 0);
                }
            }
            else
            {
                screenOverlayImage.setStyle("top", screenOverlay.screenY);
            }
            if (screenOverlay.sizeX == 0)
            {
            }
            if (screenOverlay.sizeY == 0)
            {
                screenOverlayImage.scaleMode = BitmapScaleMode.LETTERBOX;
            }
            else
            {
                if (screenOverlay.sizeXUnits === "fraction")
                {
                }
                if (screenOverlay.sizeX > 0)
                {
                }
                if (screenOverlay.sizeX <= 1)
                {
                    screenOverlayImage.width = map.width * screenOverlay.sizeX;
                }
                else
                {
                    if (screenOverlay.sizeXUnits === "pixel")
                    {
                    }
                    if (screenOverlay.sizeX > 0)
                    {
                        screenOverlayImage.width = screenOverlay.sizeX;
                    }
                }
                if (screenOverlay.sizeYUnits === "fraction")
                {
                }
                if (screenOverlay.sizeY > 0)
                {
                }
                if (screenOverlay.sizeY <= 1)
                {
                    screenOverlayImage.height = map.height * screenOverlay.sizeY;
                }
                else
                {
                    if (screenOverlay.sizeYUnits === "pixel")
                    {
                    }
                    if (screenOverlay.sizeY > 0)
                    {
                        screenOverlayImage.height = screenOverlay.sizeY;
                    }
                }
            }
            this._screenOverlayImages.push({image:screenOverlayImage, overlay:screenOverlay});
            map.staticLayer.addElementAt(screenOverlayImage, 0);
            return;
        }// end function

        private function removeScreenOverlayImages() : void
        {
            var _loc_1:Image = null;
            while (this._screenOverlayImages.length)
            {
                
                _loc_1 = Image(this._screenOverlayImages.pop().image);
                map.staticLayer.removeElement(_loc_1);
                delete this._screenOverlayImageToVisibility[_loc_1];
            }
            return;
        }// end function

        private function convertLayerFromGeographicToWebMercator(layer:FeatureLayer) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in layer.featureCollection.featureSet.features)
            {
                
                _loc_2.geometry = WebMercatorUtil.geographicToWebMercator(_loc_2.geometry);
            }
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
            return;
        }// end function

        private function layerLoadHandler(event:LayerEvent) : void
        {
            event.layer.setMap(map);
            return;
        }// end function

        private function getNetworkLinkQueryParameters(map:Map) : String
        {
            var _loc_2:String = null;
            var _loc_4:Extent = null;
            var _loc_5:Extent = null;
            var _loc_6:SpatialReference = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Number = NaN;
            var _loc_3:* = map.extent;
            if (_loc_3)
            {
            }
            if (this.viewFormat)
            {
                _loc_4 = _loc_3;
                _loc_5 = _loc_3;
                _loc_6 = _loc_3.spatialReference;
                if (_loc_6)
                {
                    if (WEB_MERCATOR_IDS.indexOf(_loc_6.wkid) != -1)
                    {
                        _loc_4 = WebMercatorUtil.webMercatorToGeographic(_loc_3) as Extent;
                    }
                    else if (_loc_6.wkid == 4326)
                    {
                        _loc_5 = WebMercatorUtil.geographicToWebMercator(_loc_3) as Extent;
                    }
                }
                _loc_7 = _loc_4.center;
                _loc_8 = Math.max(_loc_5.width, _loc_5.height);
                if (this.viewBoundScale)
                {
                    _loc_4 = _loc_4.expand(this.viewBoundScale);
                }
                _loc_2 = this.viewFormat.replace(/\[bboxWest\]/ig, _loc_4.xmin).replace(/\[bboxEast\]/ig, _loc_4.xmax).replace(/\[bboxSouth\]/ig, _loc_4.ymin).replace(/\[bboxNorth\]/ig, _loc_4.ymax).replace(/\[lookatLon\]/ig, _loc_7.x).replace(/\[lookatLat\]/ig, _loc_7.y).replace(/\[lookatRange\]/ig, _loc_8).replace(/\[lookatTilt\]/ig, 0).replace(/\[lookatHeading\]/ig, 0).replace(/\[lookatTerrainLon\]/ig, _loc_7.x).replace(/\[lookatTerrainLat\]/ig, _loc_7.y).replace(/\[lookatTerrainAlt\]/ig, 0).replace(/\[cameraLon\]/ig, _loc_7.x).replace(/\[cameraLat\]/ig, _loc_7.y).replace(/\[cameraAlt\]/ig, _loc_8).replace(/\[horizFov\]/ig, 60).replace(/\[vertFov\]/ig, 60).replace(/\[horizPixels\]/ig, map.width).replace(/\[vertPixels\]/ig, map.height).replace(/\[terrainEnabled\]/ig, 0);
            }
            if (this.httpQuery)
            {
                _loc_2 = _loc_2 + this.httpQuery.replace(/\[clientVersion\]/ig, 3).replace(/\[kmlVersion\]/ig, 2.2).replace(/\[clientName\]/ig, "ArcGIS API for Flex").replace(/\[language\]/ig, Capabilities.language);
            }
            return _loc_2;
        }// end function

        private function checkAutoRefresh() : void
        {
            if (parent is KMLLayer)
            {
                if (this.visible)
                {
                    if (this.refreshMode)
                    {
                    }
                    if (this.refreshMode.toLowerCase().indexOf("oninterval") != -1)
                    {
                    }
                    if (this.refreshInterval > 0)
                    {
                        this.stopAutoRefresh();
                        this._timeoutHandle = setTimeout(this.refresh, this.refreshInterval * 1000);
                    }
                    if (this.viewRefreshMode)
                    {
                    }
                    if (this.viewRefreshMode.toLowerCase().indexOf("onstop") != -1)
                    {
                    }
                    if (this.viewRefreshTime > 0)
                    {
                        this.map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.mapExtentChangeHandler);
                    }
                }
                else
                {
                    this.stopAutoRefresh();
                    this.map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.mapExtentChangeHandler);
                }
            }
            return;
        }// end function

        private function stopAutoRefresh() : void
        {
            clearTimeout(this._timeoutHandle);
            return;
        }// end function

        private function mapExtentChangeHandler(event:ExtentEvent) : void
        {
            this.stopAutoRefresh();
            this._timeoutHandle = setTimeout(this.refresh, this.viewRefreshTime * 1000);
            return;
        }// end function

        private function removeMapImageLayerFromParent(parent:KMLLayer) : void
        {
            var _loc_2:MapImageLayer = null;
            var _loc_3:int = 0;
            if (this._kmlLayerToMapImageLayer[this])
            {
                _loc_2 = this._kmlLayerToMapImageLayer[this] as MapImageLayer;
                _loc_3 = 0;
                while (_loc_3 < parent.numChildren)
                {
                    
                    if (parent.getChildAt(_loc_3) is MapImageLayer)
                    {
                    }
                    if (_loc_2 === parent.getChildAt(_loc_3))
                    {
                        parent.removeChildAt(_loc_3);
                        delete this._kmlLayerToMapImageLayer[this];
                        break;
                        continue;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return;
        }// end function

        public function set respectFeatureVisibility(value:Boolean) : void
        {
            arguments = this.respectFeatureVisibility;
            if (arguments !== value)
            {
                this._159684222respectFeatureVisibility = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "respectFeatureVisibility", arguments, value));
                }
            }
            return;
        }// end function

        public function set description(value:String) : void
        {
            arguments = this.description;
            if (arguments !== value)
            {
                this._1724546052description = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", arguments, value));
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

        public function set snippet(value:String) : void
        {
            arguments = this.snippet;
            if (arguments !== value)
            {
                this._2061635299snippet = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snippet", arguments, value));
                }
            }
            return;
        }// end function

    }
}
