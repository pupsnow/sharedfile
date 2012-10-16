package com.esri.ags.handlers
{
    import InfoWindowRendererHandler.as$485.*;
    import com.esri.ags.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.components.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import mx.collections.*;
    import mx.rpc.*;
    import spark.events.*;

    public class InfoWindowRendererHandler extends Object
    {
        private var _map:Map;
        private var _infoWindowStagePoint:Point;
        private var _counter:uint;
        private const _contentNavigator:ContentNavigator;
        private const _highlightGraphic:Graphic;
        private const _highlightFilters:Array;
        private const _highlightFillSymbol:SimpleFillSymbol;
        private const _featureLyrsCache:Object;
        private var _pendingFeatureLyrs:Array;
        private static const LAYER_KEY:String = "layerKey";
        private static const COUNTER_KEY:String = "counterKey";

        public function InfoWindowRendererHandler(map:Map)
        {
            this._contentNavigator = new ContentNavigator();
            this._highlightGraphic = new Graphic(null, null, null);
            this._highlightFilters = [];
            this._highlightFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_NULL, 0, 1, new CartographicLineSymbol(SimpleLineSymbol.STYLE_SOLID, 65535, 1, 3, CartographicLineSymbol.CAP_ROUND, CartographicLineSymbol.JOIN_ROUND));
            this._featureLyrsCache = {};
            this._pendingFeatureLyrs = [];
            this._map = map;
            var _loc_2:* = new GlowFilter();
            _loc_2.alpha = 0.6;
            _loc_2.blurX = 16;
            _loc_2.blurY = 16;
            _loc_2.color = 65535;
            _loc_2.inner = false;
            _loc_2.knockout = false;
            _loc_2.strength = 8;
            this._highlightFilters.push(_loc_2);
            this._map.addEventListener(MapEvent.LOAD, this.map_loadHander);
            this._map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickHandler);
            this._contentNavigator.addEventListener(IndexChangeEvent.CHANGE, this.contentNavigator_changeHandler);
            return;
        }// end function

        private function processClientGraphics(stagePoint:Point, mapPoint:MapPoint, mouseTarget:Object) : void
        {
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:DisplayObject = null;
            var _loc_10:Graphic = null;
            var _loc_11:ClusterGraphic = null;
            var _loc_12:Cluster = null;
            var _loc_4:Array = [];
            var _loc_5:Array = [];
            if (this._map.stage.areInaccessibleObjectsUnderPoint(stagePoint))
            {
                this._map.stage.areInaccessibleObjectsUnderPoint(stagePoint);
            }
            if (mouseTarget is DisplayObject)
            {
                _loc_6 = [mouseTarget];
            }
            else
            {
                _loc_6 = this._map.stage.getObjectsUnderPoint(stagePoint);
            }
            if (_loc_6)
            {
                _loc_7 = 0;
                _loc_8 = _loc_6.length;
                while (_loc_7 < _loc_8)
                {
                    
                    _loc_9 = _loc_6[_loc_7];
                    _loc_10 = this.getTargetAsGraphic(_loc_9);
                    if (_loc_10)
                    {
                    }
                    if (_loc_10.graphicsLayer)
                    {
                    }
                    if (_loc_10.graphicsLayer.map === this._map)
                    {
                        if (!_loc_10.mouseChildren)
                        {
                        }
                    }
                    if (_loc_10.mouseEnabled)
                    {
                        if (!_loc_10.graphicsLayer.infoWindowRenderer)
                        {
                        }
                    }
                    if (_loc_10.infoWindowRenderer)
                    {
                    }
                    if (_loc_4.indexOf(_loc_10) === -1)
                    {
                    }
                    if (_loc_5.indexOf(_loc_10) === -1)
                    {
                        if (_loc_10 is ClusterGraphic)
                        {
                            _loc_11 = _loc_10 as ClusterGraphic;
                            _loc_12 = _loc_11.cluster;
                            if (_loc_12)
                            {
                                _loc_4 = _loc_4.concat(_loc_12.graphics);
                                _loc_5.push(_loc_11);
                            }
                        }
                        else
                        {
                            _loc_4.push(_loc_10);
                        }
                    }
                    _loc_7 = _loc_7 + 1;
                }
            }
            if (_loc_4.length > 0)
            {
                this.showInfoWindow(_loc_4.reverse(), stagePoint, mapPoint);
            }
            return;
        }// end function

        private function showInfoWindow(graphics:Array, stagePoint:Point, mapPoint:MapPoint) : void
        {
            this._infoWindowStagePoint = stagePoint;
            this._map.infoWindow.removeEventListener("contentChange", this.mapInfoWindow_closeOrChangeHandler);
            this._contentNavigator.dataProvider = new ArrayList(graphics);
            this._map.infoWindow.content = this._contentNavigator;
            this._map.infoWindow.contentOwner = this._map;
            this._map.infoWindow.show(mapPoint, stagePoint);
            this._map.infoWindow.addEventListener("contentChange", this.mapInfoWindow_closeOrChangeHandler);
            return;
        }// end function

        private function getTargetAsGraphic(target:DisplayObject) : Graphic
        {
            var _loc_2:* = target as Graphic;
            if (_loc_2)
            {
                return _loc_2;
            }
            if (target === this._map.layerContainer)
            {
                return null;
            }
            if (target.parent)
            {
                return this.getTargetAsGraphic(target.parent);
            }
            return null;
        }// end function

        private function processLayerInfoWindowRenderers(stagePoint:Point, mapPoint:MapPoint) : void
        {
            var _loc_7:Layer = null;
            var _loc_8:Array = null;
            var _loc_9:Boolean = false;
            var _loc_10:String = null;
            var _loc_11:Array = null;
            var _loc_12:Array = null;
            var _loc_13:Array = null;
            var _loc_14:String = null;
            var _loc_15:int = 0;
            var _loc_16:String = null;
            var _loc_17:String = null;
            var _loc_18:Boolean = false;
            var _loc_19:Array = null;
            var _loc_20:ArcGISDynamicMapServiceLayer = null;
            var _loc_21:ArcGISTiledMapServiceLayer = null;
            var _loc_22:Array = null;
            var _loc_23:LayerInfo = null;
            var _loc_24:Number = NaN;
            var _loc_25:LayerInfoWindowRenderer = null;
            var _loc_26:String = null;
            var _loc_27:MyFeatureLayer = null;
            var _loc_28:DynamicLayerInfo = null;
            var _loc_29:LayerDrawingOptions = null;
            var _loc_3:Array = [];
            var _loc_4:* = this._map.layers as ArrayCollection;
            var _loc_5:* = Math.floor(this._map.extent.width / this._map.width);
            var _loc_6:* = _loc_4.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_7 = _loc_4.getItemAt(_loc_6) as Layer;
                if (_loc_7)
                {
                }
                if (_loc_7.visible)
                {
                }
                if (_loc_7.loaded)
                {
                }
                if (_loc_7.isInScaleRange)
                {
                    _loc_8 = null;
                    _loc_9 = false;
                    _loc_11 = null;
                    _loc_12 = null;
                    _loc_13 = null;
                    _loc_14 = null;
                    _loc_15 = -1;
                    _loc_16 = null;
                    _loc_17 = null;
                    _loc_18 = true;
                    _loc_19 = null;
                    if (_loc_7 is ArcGISDynamicMapServiceLayer)
                    {
                        _loc_20 = _loc_7 as ArcGISDynamicMapServiceLayer;
                        _loc_8 = _loc_20.layerInfoWindowRenderers;
                        _loc_9 = _loc_20.disableClientCaching;
                        _loc_10 = _loc_20.gdbVersion;
                        _loc_11 = _loc_20.layerDefinitions;
                        _loc_12 = _loc_20.layerDrawingOptions;
                        if (!_loc_20.dynamicLayerInfos)
                        {
                        }
                        _loc_13 = _loc_20.layerInfos;
                        _loc_14 = _loc_20.proxyURL;
                        _loc_15 = _loc_20.requestTimeout;
                        _loc_16 = _loc_20.token;
                        _loc_17 = _loc_20.url;
                        _loc_18 = _loc_20.useMapTime;
                        if (_loc_20.visibleLayers)
                        {
                            _loc_19 = _loc_20.visibleLayers.toArray();
                        }
                    }
                    else if (_loc_7 is ArcGISTiledMapServiceLayer)
                    {
                        _loc_21 = _loc_7 as ArcGISTiledMapServiceLayer;
                        _loc_8 = _loc_21.layerInfoWindowRenderers;
                        _loc_13 = _loc_21.layerInfos;
                        _loc_14 = _loc_21.proxyURL;
                        _loc_15 = _loc_21.requestTimeout;
                        _loc_16 = _loc_21.token;
                        _loc_17 = _loc_21.url;
                    }
                    if (_loc_8)
                    {
                    }
                    if (_loc_8.length > 0)
                    {
                        _loc_19 = AGSUtil.getVisibleLayers(_loc_19, _loc_13);
                        _loc_22 = AGSUtil.getLayersForScale(this._map.scale, _loc_13);
                        for each (_loc_23 in _loc_13)
                        {
                            
                            _loc_24 = _loc_23.layerId;
                            if (!_loc_23.subLayerIds)
                            {
                            }
                            if (_loc_19.indexOf(_loc_24) != -1)
                            {
                            }
                            if (_loc_22.indexOf(_loc_24) != -1)
                            {
                                _loc_25 = this.getLayerInfoWindowRenderer(_loc_24, _loc_8);
                                if (_loc_25)
                                {
                                }
                                if (_loc_25.infoWindowRenderer)
                                {
                                    _loc_26 = this.getLayerUrl(_loc_17, _loc_24);
                                    if (_loc_26)
                                    {
                                        _loc_27 = this._featureLyrsCache[_loc_26];
                                        if (_loc_27)
                                        {
                                        }
                                        if (_loc_27.loadFault)
                                        {
                                            _loc_27.setMap(null);
                                            _loc_27 = null;
                                        }
                                        if (!_loc_27)
                                        {
                                            _loc_27 = new MyFeatureLayer();
                                            _loc_27.mode = FeatureLayer.MODE_SELECTION;
                                            _loc_27.outFields = ["*"];
                                            _loc_28 = this.getDynamicLayerInfo(_loc_24, _loc_13);
                                            if (_loc_28)
                                            {
                                                _loc_27.url = this.getDynamicLayerUrl(_loc_17);
                                                _loc_27.source = _loc_28.source;
                                            }
                                            else
                                            {
                                                _loc_27.url = _loc_26;
                                            }
                                            _loc_29 = this.getLayerDrawingOptions(_loc_24, _loc_12);
                                            if (_loc_29)
                                            {
                                            }
                                            if (_loc_29.renderer)
                                            {
                                                _loc_27.renderer = _loc_29.renderer;
                                            }
                                            _loc_27.visible = false;
                                            _loc_27.setMap(this._map);
                                            this._featureLyrsCache[_loc_26] = _loc_27;
                                        }
                                        _loc_27.clickedMapPoint = mapPoint;
                                        _loc_27.clickedStagePoint = stagePoint;
                                        _loc_27.disableClientCaching = _loc_9;
                                        _loc_27.definitionExpression = AGSUtil.getDefinitionExpression(_loc_24, _loc_11);
                                        _loc_27.gdbVersion = _loc_10;
                                        _loc_27.infoWindowRenderer = _loc_25.infoWindowRenderer;
                                        _loc_27.maxAllowableOffset = _loc_5;
                                        _loc_27.proxyURL = _loc_14;
                                        _loc_27.requestTimeout = _loc_15;
                                        _loc_27.token = _loc_16;
                                        _loc_3.push(_loc_27);
                                    }
                                }
                            }
                        }
                    }
                }
                _loc_6 = _loc_6 - 1;
            }
            if (_loc_3.length > 0)
            {
                this.processFeatureLayers(_loc_3, stagePoint, mapPoint);
            }
            return;
        }// end function

        private function processFeatureLayers(featureLayers:Array, stagePoint:Point, mapPoint:MapPoint) : void
        {
            var loadedFeatureLayers:Array;
            var originalFeatureLayers:Array;
            var arrayIndex:int;
            var layer:Layer;
            var featureLayers:* = featureLayers;
            var stagePoint:* = stagePoint;
            var mapPoint:* = mapPoint;
            loadedFeatureLayers;
            originalFeatureLayers = featureLayers.concat();
            var i:int;
            while (i < featureLayers.length)
            {
                
                layer = featureLayers[i] as Layer;
                if (layer.loaded)
                {
                    if (layer.isInScaleRange)
                    {
                        arrayIndex = originalFeatureLayers.indexOf(layer);
                        loadedFeatureLayers[arrayIndex] = layer;
                    }
                    i = (i - 1);
                    featureLayers.splice(i, 1);
                }
                else
                {
                    var layerLoadHandler:* = function (event:LayerEvent) : void
            {
                var _loc_2:* = event.layer;
                if (_loc_2.loaded)
                {
                }
                if (_loc_2.isInScaleRange)
                {
                    arrayIndex = originalFeatureLayers.indexOf(_loc_2);
                    loadedFeatureLayers[arrayIndex] = _loc_2;
                }
                featureLayers.pop();
                if (featureLayers.length == 0)
                {
                    queryFeatureLayers(loadedFeatureLayers, stagePoint, mapPoint);
                }
                return;
            }// end function
            ;
                    layer.addEventListener(LayerEvent.LOAD, layerLoadHandler, false, 0, true);
                    layer.addEventListener(LayerEvent.LOAD_ERROR, layerLoadHandler, false, 0, true);
                }
                i = (i + 1);
            }
            if (featureLayers.length == 0)
            {
                this.queryFeatureLayers(loadedFeatureLayers, stagePoint, mapPoint);
            }
            return;
        }// end function

        private function queryFeatureLayers(featureLayers:Array, stagePoint:Point, mapPoint:MapPoint) : void
        {
            var _loc_5:FeatureLayer = null;
            var _loc_6:Geometry = null;
            var _loc_7:String = null;
            var _loc_8:AsyncToken = null;
            var _loc_9:Number = NaN;
            var _loc_10:Extent = null;
            var _loc_11:Point = null;
            featureLayers = this.removeNulls(featureLayers);
            if (featureLayers.length == 0)
            {
                return;
            }
            this._map.cursorManager.setBusyCursor();
            var _loc_4:* = new Query();
            for each (_loc_5 in featureLayers)
            {
                
                _loc_7 = _loc_5.layerDetails ? (_loc_5.layerDetails.geometryType) : (null);
                if (_loc_7 === Geometry.POLYGON)
                {
                    _loc_6 = mapPoint;
                }
                else
                {
                    if (_loc_7 === Geometry.POLYLINE)
                    {
                        _loc_9 = this.calculateClickTolerance(2, _loc_5.renderer);
                    }
                    else
                    {
                        _loc_9 = this.calculateClickTolerance(10, _loc_5.renderer);
                    }
                    _loc_10 = new Extent();
                    _loc_11 = this._map.globalToLocal(stagePoint);
                    _loc_10.xmin = this._map.toMapX(_loc_11.x - _loc_9);
                    _loc_10.ymin = this._map.toMapY(_loc_11.y + _loc_9);
                    _loc_10.xmax = this._map.toMapX(_loc_11.x + _loc_9);
                    _loc_10.ymax = this._map.toMapY(_loc_11.y - _loc_9);
                    _loc_10.spatialReference = this._map.spatialReference;
                    _loc_6 = _loc_10;
                }
                _loc_4.geometry = _loc_6;
                _loc_4.timeExtent = _loc_5.useMapTime ? (this._map.timeExtent) : (null);
                _loc_8 = _loc_5.selectFeatures(_loc_4);
                _loc_8[LAYER_KEY] = _loc_5;
                _loc_8[COUNTER_KEY] = this._counter;
                _loc_8.addResponder(new AsyncResponder(this.featureLayer_selectionCompleteHandler, this.featureLayer_faultHandler, _loc_8));
                this._pendingFeatureLyrs.push(_loc_5);
            }
            return;
        }// end function

        private function featureLayer_selectionCompleteHandler(selectedFeatures:Array, asyncToken:AsyncToken) : void
        {
            var _loc_7:Graphic = null;
            if (this._counter !== asyncToken[COUNTER_KEY])
            {
                return;
            }
            var _loc_3:* = asyncToken[LAYER_KEY];
            var _loc_4:* = _loc_3.clickedStagePoint;
            var _loc_5:* = _loc_3.clickedMapPoint;
            if (selectedFeatures)
            {
            }
            if (selectedFeatures.length > 0)
            {
                if (this._infoWindowStagePoint === _loc_4)
                {
                    for each (_loc_7 in selectedFeatures)
                    {
                        
                        this._contentNavigator.dataProvider.addItem(_loc_7);
                    }
                }
                else
                {
                    this.showInfoWindow(selectedFeatures, _loc_4, _loc_5);
                }
            }
            var _loc_6:* = this._pendingFeatureLyrs.indexOf(_loc_3);
            if (_loc_6 != -1)
            {
                this._pendingFeatureLyrs.splice(_loc_6, 1);
            }
            if (this._pendingFeatureLyrs.length == 0)
            {
                this._map.cursorManager.removeBusyCursor();
            }
            return;
        }// end function

        private function featureLayer_faultHandler(fault:Fault, asyncToken:AsyncToken) : void
        {
            if (this._counter !== asyncToken[COUNTER_KEY])
            {
                return;
            }
            var _loc_3:* = asyncToken[LAYER_KEY];
            var _loc_4:* = this._pendingFeatureLyrs.indexOf(_loc_3);
            if (_loc_4 != -1)
            {
                this._pendingFeatureLyrs.splice(_loc_4, 1);
            }
            if (this._pendingFeatureLyrs.length == 0)
            {
                this._map.cursorManager.removeBusyCursor();
            }
            return;
        }// end function

        private function getLayerInfoWindowRenderer(layerId:Number, layerInfoWindowRenderers:Array) : LayerInfoWindowRenderer
        {
            var _loc_3:LayerInfoWindowRenderer = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:LayerInfoWindowRenderer = null;
            if (layerInfoWindowRenderers)
            {
                _loc_4 = 0;
                _loc_5 = layerInfoWindowRenderers.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_6 = layerInfoWindowRenderers[_loc_4] as LayerInfoWindowRenderer;
                    if (_loc_6)
                    {
                    }
                    if (_loc_6.layerId === layerId)
                    {
                        _loc_3 = _loc_6;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_3;
        }// end function

        private function getLayerDrawingOptions(layerId:Number, layerDrawingOptions:Array) : LayerDrawingOptions
        {
            var _loc_3:LayerDrawingOptions = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:LayerDrawingOptions = null;
            if (layerDrawingOptions)
            {
                _loc_4 = 0;
                _loc_5 = layerDrawingOptions.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_6 = layerDrawingOptions[_loc_4] as LayerDrawingOptions;
                    if (_loc_6)
                    {
                    }
                    if (_loc_6.layerId === layerId)
                    {
                        _loc_3 = _loc_6;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_3;
        }// end function

        private function getDynamicLayerInfo(layerId:Number, layerInfos:Array) : DynamicLayerInfo
        {
            var _loc_3:DynamicLayerInfo = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:DynamicLayerInfo = null;
            if (layerInfos)
            {
                _loc_4 = 0;
                _loc_5 = layerInfos.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_6 = layerInfos[_loc_4] as DynamicLayerInfo;
                    if (_loc_6)
                    {
                    }
                    if (_loc_6.layerId === layerId)
                    {
                        _loc_3 = _loc_6;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_3;
        }// end function

        private function getLayerUrl(serviceUrl:String, layerId:Number) : String
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            if (serviceUrl)
            {
            }
            if (isFinite(layerId))
            {
                _loc_4 = serviceUrl.indexOf("?");
                if (_loc_4 == -1)
                {
                    _loc_3 = serviceUrl + "/" + layerId;
                }
                else
                {
                    _loc_3 = serviceUrl.substring(0, _loc_4) + "/" + layerId + serviceUrl.substring(_loc_4);
                }
            }
            return _loc_3;
        }// end function

        private function getDynamicLayerUrl(serviceUrl:String) : String
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            if (serviceUrl)
            {
                _loc_3 = serviceUrl.indexOf("?");
                if (_loc_3 == -1)
                {
                    _loc_2 = serviceUrl + "/dynamicLayer";
                }
                else
                {
                    _loc_2 = serviceUrl.substring(0, _loc_3) + "/dynamicLayer" + serviceUrl.substring(_loc_3);
                }
            }
            return _loc_2;
        }// end function

        private function removeNulls(values:Array) : Array
        {
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Object = null;
            if (values)
            {
                _loc_2 = [];
                _loc_3 = 0;
                _loc_4 = values.length;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = values[_loc_3];
                    if (_loc_5 != null)
                    {
                        _loc_2.push(_loc_5);
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function calculateClickTolerance(minTolerance:Number, renderer:IRenderer) : Number
        {
            var _loc_4:Array = null;
            var _loc_5:Symbol = null;
            var _loc_6:UniqueValueRenderer = null;
            var _loc_7:UniqueValueInfo = null;
            var _loc_8:ClassBreaksRenderer = null;
            var _loc_9:ClassBreakInfo = null;
            var _loc_10:MarkerSymbol = null;
            var _loc_3:* = minTolerance;
            if (renderer)
            {
                _loc_4 = [];
                if (renderer is SimpleRenderer)
                {
                    _loc_4.push((renderer as SimpleRenderer).symbol);
                }
                else if (renderer is UniqueValueRenderer)
                {
                    _loc_6 = renderer as UniqueValueRenderer;
                    _loc_4.push(_loc_6.defaultSymbol);
                    for each (_loc_7 in _loc_6.infos)
                    {
                        
                        _loc_4.push(_loc_7.symbol);
                    }
                }
                else if (renderer is ClassBreaksRenderer)
                {
                    _loc_8 = renderer as ClassBreaksRenderer;
                    _loc_4.push(_loc_8.defaultSymbol);
                    for each (_loc_9 in _loc_8.infos)
                    {
                        
                        _loc_4.push(_loc_9.symbol);
                    }
                }
                for each (_loc_5 in _loc_4)
                {
                    
                    if (_loc_5 is MarkerSymbol)
                    {
                        _loc_10 = _loc_5 as MarkerSymbol;
                        if (_loc_10.xoffset)
                        {
                            _loc_3 = Math.max(_loc_3, Math.abs(_loc_10.xoffset));
                        }
                        if (_loc_10.yoffset)
                        {
                            _loc_3 = Math.max(_loc_3, Math.abs(_loc_10.yoffset));
                        }
                        continue;
                    }
                    if (_loc_5 is LineSymbol)
                    {
                        _loc_3 = Math.max(_loc_3, (_loc_5 as LineSymbol).width);
                    }
                }
            }
            return _loc_3;
        }// end function

        private function clearPendingFeatureLyrs() : void
        {
            if (this._pendingFeatureLyrs.length > 0)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._counter + 1;
                _loc_1._counter = _loc_2;
                this._pendingFeatureLyrs = [];
                this._map.cursorManager.removeBusyCursor();
            }
            return;
        }// end function

        private function contentNavigator_changeHandler(event:IndexChangeEvent) : void
        {
            var _loc_2:* = event.newIndex >= 0 ? (this._contentNavigator.selectedItem as Graphic) : (null);
            if (_loc_2)
            {
                if (_loc_2.clusterGraphic)
                {
                    this._highlightGraphic.visible = false;
                }
                else
                {
                    this._highlightGraphic.attributes = _loc_2.attributes;
                    this._highlightGraphic.geometry = _loc_2.geometry;
                    if (!(_loc_2.geometry is Polygon))
                    {
                    }
                    if (_loc_2.geometry is Extent)
                    {
                        this._highlightGraphic.symbol = this._highlightFillSymbol;
                        this._highlightGraphic.filters = null;
                    }
                    else
                    {
                        this._highlightGraphic.symbol = _loc_2.getActiveSymbol(_loc_2.graphicsLayer);
                        this._highlightGraphic.filters = this._highlightFilters;
                    }
                    this._highlightGraphic.visible = true;
                }
            }
            return;
        }// end function

        private function mapInfoWindow_closeOrChangeHandler(event:Event) : void
        {
            this.clearPendingFeatureLyrs();
            this._highlightGraphic.visible = false;
            return;
        }// end function

        private function map_clickHandler(event:MapMouseEvent) : void
        {
            var _loc_2:Point = null;
            this.clearPendingFeatureLyrs();
            if (event.mapPoint)
            {
            }
            if (this._map.infoWindowRenderersEnabled)
            {
                _loc_2 = new Point(event.stageX, event.stageY);
                this.processClientGraphics(_loc_2, event.mapPoint, event.originalTarget);
                this.processLayerInfoWindowRenderers(_loc_2, event.mapPoint);
            }
            return;
        }// end function

        private function map_loadHander(event:Event) : void
        {
            this._highlightGraphic.mouseChildren = false;
            this._highlightGraphic.mouseEnabled = false;
            this._highlightGraphic.visible = false;
            this._map.defaultGraphicsLayer.add(this._highlightGraphic);
            this._map.infoWindow.addEventListener(Event.CLOSE, this.mapInfoWindow_closeOrChangeHandler);
            return;
        }// end function

    }
}
