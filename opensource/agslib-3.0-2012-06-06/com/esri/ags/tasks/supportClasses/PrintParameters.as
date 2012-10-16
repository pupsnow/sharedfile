package com.esri.ags.tasks.supportClasses
{
    import __AS3__.vec.*;
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import com.esri.ags.virtualearth.*;
    import mx.collections.*;

    public class PrintParameters extends Object implements IJSONSupport
    {
        private var _allLegendLayers:Array;
        public var customParameters:Object;
        public var exportOptions:ExportOptions;
        public var format:String;
        public var layoutOptions:LayoutOptions;
        public var layoutTemplate:String;
        public var map:Map;
        public var outSpatialReference:SpatialReference;
        public var preserveScale:Boolean = true;

        public function PrintParameters()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:String = null;
            var _loc_2:Object = {};
            if (this.layoutOptions)
            {
            }
            if (this.layoutOptions.legendOptions)
            {
            }
            if (!this.layoutOptions.legendOptions.legendLayers)
            {
                this._allLegendLayers = [];
            }
            else
            {
                this._allLegendLayers = null;
            }
            for (_loc_3 in this.customParameters)
            {
                
                _loc_2[_loc_3] = this.customParameters[_loc_3];
            }
            if (this.format)
            {
                _loc_2.Format = this.format;
            }
            if (this.layoutTemplate)
            {
                _loc_2.Layout_Template = this.layoutTemplate;
            }
            var _loc_4:Object = {};
            _loc_4.mapOptions = this.getMapOptions();
            _loc_4.exportOptions = this.getExportOptions();
            _loc_4.operationalLayers = this.getOperationalLayers();
            if (this.layoutOptions)
            {
                _loc_4.layoutOptions = this.layoutOptions.toJSON();
            }
            if (this._allLegendLayers)
            {
                if (!this.layoutOptions)
                {
                    _loc_4.layoutOptions = {};
                }
                _loc_4.layoutOptions.legendOptions = {operationalLayers:this._allLegendLayers};
            }
            _loc_2.Web_Map_as_JSON = _loc_4;
            return _loc_2;
        }// end function

        private function getMapOptions() : Object
        {
            var _loc_1:Object = null;
            var _loc_2:Extent = null;
            var _loc_3:SpatialReference = null;
            var _loc_4:Extent = null;
            var _loc_5:Extent = null;
            if (this.map)
            {
                _loc_1 = {};
                if (this.map.extent)
                {
                    _loc_2 = this.map.extent;
                    if (this.map.spatialReference)
                    {
                        _loc_2.spatialReference = this.map.spatialReference;
                    }
                    _loc_3 = _loc_2.spatialReference;
                    if (this.map.wrapAround180)
                    {
                    }
                    if (_loc_3)
                    {
                        _loc_4 = _loc_2.normalize(true) as Extent;
                        _loc_1.extent = _loc_4.toJSON();
                    }
                    else
                    {
                        _loc_1.extent = _loc_2.toJSON();
                    }
                }
                if (this.outSpatialReference)
                {
                    if (_loc_2)
                    {
                    }
                    if (this.map.wrapAround180)
                    {
                    }
                    if (_loc_3)
                    {
                    }
                    if (this.outSpatialReference.isWrappable())
                    {
                        if (this.outSpatialReference.wkid == 4326)
                        {
                        }
                        if (_loc_3.isWebMercator())
                        {
                            _loc_5 = WebMercatorUtil.webMercatorToGeographic(_loc_2) as Extent;
                            _loc_5.xmax = WebMercatorUtil.xToLongitude(_loc_2.xmax, true);
                            _loc_5.xmin = WebMercatorUtil.xToLongitude(_loc_2.xmin, true);
                            _loc_5 = _loc_5.normalize(true) as Extent;
                            _loc_1.spatialReference = _loc_5.spatialReference.toJSON();
                        }
                        else
                        {
                            if (this.outSpatialReference.isWebMercator())
                            {
                                this.outSpatialReference.isWebMercator();
                            }
                            if (_loc_3.wkid == 4326)
                            {
                                _loc_5 = WebMercatorUtil.geographicToWebMercator(_loc_2) as Extent;
                                _loc_5 = _loc_5.normalize(true) as Extent;
                                _loc_1.spatialReference = _loc_5.spatialReference.toJSON();
                            }
                        }
                    }
                    else
                    {
                        _loc_1.spatialReference = this.outSpatialReference.toJSON();
                    }
                }
                if (this.preserveScale)
                {
                }
                if (this.map.scale > 0)
                {
                    _loc_1.scale = this.map.scale;
                }
                if (this.map.timeExtent)
                {
                    _loc_1.time = this.map.timeExtent.toJSON();
                }
            }
            return _loc_1;
        }// end function

        private function getExportOptions() : Object
        {
            var _loc_1:Object = null;
            if (this.exportOptions)
            {
                _loc_1 = {};
                if (this.exportOptions.dpi > 0)
                {
                    _loc_1.dpi = this.exportOptions.dpi;
                }
                if (this.layoutTemplate)
                {
                }
                if (this.layoutTemplate == "MAP_ONLY")
                {
                    if (this.exportOptions.width > 0)
                    {
                    }
                    if (this.exportOptions.height > 0)
                    {
                        _loc_1.outputSize = [this.exportOptions.width, this.exportOptions.height];
                    }
                    else if (this.map)
                    {
                        _loc_1.outputSize = [this.map.width, this.map.height];
                    }
                }
            }
            else
            {
                if (this.map)
                {
                    if (this.layoutTemplate)
                    {
                    }
                }
                if (this.layoutTemplate == "MAP_ONLY")
                {
                    _loc_1 = {outputSize:[this.map.width, this.map.height]};
                }
            }
            return _loc_1;
        }// end function

        private function getOperationalLayers() : Array
        {
            var _loc_1:Array = null;
            var _loc_2:Array = null;
            var _loc_3:Layer = null;
            var _loc_4:Object = null;
            if (this.map)
            {
            }
            if (this.map.loaded)
            {
                _loc_1 = [];
                _loc_2 = (this.map.layers as IList).toArray();
                _loc_2.push(this.map.defaultGraphicsLayer);
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = null;
                    if (_loc_3.visible)
                    {
                    }
                    if (_loc_3.loaded)
                    {
                    }
                    if (_loc_3.isInScaleRange)
                    {
                        if (_loc_3 is ArcGISDynamicMapServiceLayer)
                        {
                            _loc_4 = this.getArcGISDynamicMapServiceLayerJSON(_loc_3 as ArcGISDynamicMapServiceLayer);
                        }
                        else if (_loc_3 is ArcGISImageServiceLayer)
                        {
                            _loc_4 = this.getArcGISImageServiceLayerJSON(_loc_3 as ArcGISImageServiceLayer);
                        }
                        else if (_loc_3 is ArcGISTiledMapServiceLayer)
                        {
                            _loc_4 = this.getArcGISTiledMapServiceLayerJSON(_loc_3 as ArcGISTiledMapServiceLayer);
                        }
                        else if (_loc_3 is FeatureLayer)
                        {
                            _loc_4 = this.getFeatureLayerJSON(_loc_3 as FeatureLayer);
                        }
                        else if (_loc_3 is GPResultImageLayer)
                        {
                            _loc_4 = this.getGPResultImageLayerJSON(_loc_3 as GPResultImageLayer);
                        }
                        else if (_loc_3 is GraphicsLayer)
                        {
                            _loc_4 = this.getGraphicsLayerJSON(_loc_3 as GraphicsLayer);
                        }
                        else if (_loc_3 is KMLLayer)
                        {
                            _loc_4 = this.getKMLLayerJSON(_loc_3 as KMLLayer);
                        }
                        else if (_loc_3 is MapImageLayer)
                        {
                            _loc_4 = this.getMapImageLayers(_loc_3 as MapImageLayer);
                        }
                        else if (_loc_3 is OpenStreetMapLayer)
                        {
                            _loc_4 = this.getOpenStreetMapLayerJSON(_loc_3 as OpenStreetMapLayer);
                        }
                        else if (_loc_3 is VETiledLayer)
                        {
                            _loc_4 = this.getVETiledLayerJSON(_loc_3 as VETiledLayer);
                        }
                        else if (_loc_3 is WMSLayer)
                        {
                            _loc_4 = this.getWMSLayerJSON(_loc_3 as WMSLayer);
                        }
                        else if (_loc_3 is WMTSLayer)
                        {
                            _loc_4 = this.getWMTSLayerJSON(_loc_3 as WMTSLayer);
                        }
                    }
                    if (_loc_4)
                    {
                        if (_loc_4 is Array)
                        {
                            _loc_1 = _loc_1.concat(_loc_4);
                            continue;
                        }
                        _loc_4.id = _loc_3.id;
                        if (this._allLegendLayers)
                        {
                        }
                        if (_loc_3 !== this.map.defaultGraphicsLayer)
                        {
                            this._allLegendLayers.push({id:_loc_3.id});
                        }
                        if (_loc_3.name)
                        {
                            _loc_4.title = _loc_3.name;
                        }
                        if (_loc_3.alpha < 1)
                        {
                            _loc_4.opacity = _loc_3.alpha;
                        }
                        _loc_1.push(_loc_4);
                    }
                }
            }
            return _loc_1;
        }// end function

        function getArcGISDynamicMapServiceLayerJSON(layer:ArcGISDynamicMapServiceLayer) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_6:Object = null;
            var _loc_7:Number = NaN;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
            var _loc_10:LayerInfo = null;
            var _loc_11:Object = null;
            var _loc_12:String = null;
            var _loc_13:LayerDrawingOptions = null;
            var _loc_14:LayerTimeOptions = null;
            var _loc_15:LayerTimeOptions = null;
            var _loc_16:Object = null;
            var _loc_17:Object = null;
            var _loc_18:Boolean = false;
            var _loc_2:Object = {};
            _loc_2.url = this.getURLWithToken(layer.urlObj, layer.credential, layer.token);
            if (layer.gdbVersion)
            {
                _loc_2.gdbVersion = layer.gdbVersion;
            }
            if (layer.layerDefinitions)
            {
            }
            if (layer.layerDefinitions.length > 0)
            {
                _loc_3 = layer.layerDefinitions;
            }
            if (layer.visibleLayers)
            {
                _loc_4 = layer.visibleLayers.toArray();
            }
            var _loc_5:Array = [];
            if (layer.supportsDynamicLayers)
            {
                _loc_8 = layer.dynamicLayerInfos;
                if (!_loc_8)
                {
                }
                if (!_loc_4)
                {
                }
                if (!_loc_3)
                {
                }
                if (!layer.layerDrawingOptions)
                {
                }
                if (layer.layerTimeOptions)
                {
                    if (!_loc_8)
                    {
                        _loc_8 = layer.layerInfos;
                    }
                    _loc_4 = AGSUtil.getVisibleLayers(_loc_4, _loc_8);
                    _loc_9 = AGSUtil.getLayersForScale(this.map.scale, _loc_8);
                    for each (_loc_10 in _loc_8)
                    {
                        
                        if (!_loc_10.subLayerIds)
                        {
                            _loc_7 = _loc_10.layerId;
                            if (_loc_4.indexOf(_loc_7) != -1)
                            {
                            }
                            if (_loc_9.indexOf(_loc_7) != -1)
                            {
                                _loc_11 = {};
                                if (_loc_10 is DynamicLayerInfo)
                                {
                                    _loc_11.source = (_loc_10 as DynamicLayerInfo).source;
                                }
                                else
                                {
                                    _loc_11.source = {type:"mapLayer", mapLayerId:_loc_7};
                                }
                                _loc_12 = AGSUtil.getDefinitionExpression(_loc_7, _loc_3);
                                if (_loc_12)
                                {
                                    _loc_11.definitionExpression = _loc_12;
                                }
                                _loc_13 = AGSUtil.getLayerDrawingOptions(_loc_7, layer.layerDrawingOptions);
                                if (_loc_13)
                                {
                                    _loc_11.drawingInfo = _loc_13;
                                }
                                _loc_14 = AGSUtil.getLayerTimeOptions(_loc_7, layer.layerTimeOptions);
                                if (_loc_14)
                                {
                                    _loc_11.layerTimeOptions = _loc_14;
                                }
                                _loc_6 = {id:_loc_7, layerDefinition:_loc_11};
                                _loc_5.push(_loc_6);
                            }
                        }
                    }
                }
            }
            else
            {
                if (_loc_3)
                {
                    _loc_16 = LayerDefinition.getLayerDefsAsJSON(_loc_3);
                    for (_loc_17 in _loc_16)
                    {
                        
                        _loc_6 = {id:_loc_17, layerDefinition:{}};
                        _loc_6.layerDefinition.definitionExpression = _loc_16[_loc_17];
                        _loc_5.push(_loc_6);
                    }
                }
                for each (_loc_15 in layer.layerTimeOptions)
                {
                    
                    _loc_7 = _loc_15.layerId;
                    _loc_18 = false;
                    for each (_loc_6 in _loc_5)
                    {
                        
                        if (_loc_7 == _loc_6.id)
                        {
                            _loc_18 = true;
                            _loc_6.layerDefinition.layerTimeOptions = _loc_15;
                            break;
                        }
                    }
                    if (!_loc_18)
                    {
                        _loc_6 = {id:_loc_7, layerDefinition:{}};
                        _loc_6.layerDefinition.layerTimeOptions = _loc_15;
                        _loc_5.push(_loc_6);
                    }
                }
                if (_loc_4)
                {
                    _loc_2.visibleLayers = _loc_4;
                }
            }
            if (_loc_5.length > 0)
            {
                _loc_2.layers = _loc_5;
            }
            return _loc_2;
        }// end function

        private function getArcGISImageServiceLayerJSON(layer:ArcGISImageServiceLayer) : Object
        {
            var _loc_2:Object = {};
            _loc_2.url = this.getURLWithToken(layer.urlObj, layer.credential, layer.token);
            if (!isNaN(layer.noData))
            {
                _loc_2.noData = layer.noData;
            }
            if (layer.imageFormat)
            {
                _loc_2.format = layer.imageFormat;
            }
            if (layer.interpolation)
            {
                _loc_2.interpolation = layer.interpolation;
            }
            if (!isNaN(layer.compressionQuality))
            {
                _loc_2.compressionQuality = layer.compressionQuality;
            }
            if (layer.bandIds)
            {
                _loc_2.bandIds = layer.bandIds.concat();
            }
            if (layer.mosaicRule)
            {
                _loc_2.mosaicRule = layer.mosaicRule.toJSON();
            }
            if (layer.renderingRule)
            {
                _loc_2.renderingRule = layer.renderingRule.toJSON();
            }
            return _loc_2;
        }// end function

        private function getArcGISTiledMapServiceLayerJSON(layer:ArcGISTiledMapServiceLayer) : Object
        {
            var _loc_2:Object = {};
            _loc_2.url = this.getURLWithToken(layer.urlObj, layer.credential, layer.token);
            return _loc_2;
        }// end function

        private function getFeatureLayerJSON(layer:FeatureLayer) : Object
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            var _loc_4:Array = null;
            var _loc_5:TemporalRenderer = null;
            var _loc_6:Object = null;
            var _loc_7:Vector.<Number> = null;
            if (layer.isCollection)
            {
                _loc_2 = this.getGraphicsLayerJSON(layer);
            }
            else
            {
                if (!layer.layerDetails)
                {
                    return null;
                }
                _loc_2 = {};
                _loc_2.url = this.getURLWithToken(layer.urlObj, layer.credential, layer.token);
                _loc_3 = {};
                if (layer.definitionExpression)
                {
                    _loc_3.definitionExpression = layer.definitionExpression;
                }
                if (layer.renderer)
                {
                    if (!layer.isDefaultRenderer)
                    {
                        if (layer.renderer is IJSONSupport)
                        {
                            _loc_3.drawingInfo = {renderer:IJSONSupport(layer.renderer).toJSON()};
                        }
                        else if (layer.renderer is TemporalRenderer)
                        {
                            _loc_5 = layer.renderer as TemporalRenderer;
                            _loc_6 = {};
                            if (_loc_5.observationRenderer is IJSONSupport)
                            {
                                _loc_6.renderer = IJSONSupport(_loc_5.observationRenderer).toJSON();
                            }
                            if (_loc_5.latestObservationRenderer is IJSONSupport)
                            {
                                _loc_6.latestObservationRenderer = IJSONSupport(_loc_5.latestObservationRenderer).toJSON();
                            }
                            if (_loc_5.trackRenderer is IJSONSupport)
                            {
                                _loc_6.trackLinesRenderer = IJSONSupport(_loc_5.trackRenderer).toJSON();
                            }
                            if (_loc_5.observationAger is IJSONSupport)
                            {
                            }
                            if (this.map.timeExtent)
                            {
                                _loc_6.observationAger = IJSONSupport(_loc_5.observationAger).toJSON();
                            }
                            _loc_3.drawingInfo = _loc_6;
                        }
                    }
                }
                else if (layer.symbol is IJSONSupport)
                {
                    _loc_3.drawingInfo = {renderer:new SimpleRenderer(layer.symbol).toJSON()};
                }
                if (layer.gdbVersion)
                {
                    _loc_3.gdbVersion = layer.gdbVersion;
                }
                if (layer.source is IJSONSupport)
                {
                    _loc_3.source = IJSONSupport(layer.source).toJSON();
                }
                _loc_4 = layer.selectedIds;
                if (layer.isSelOnly)
                {
                    if (_loc_4.length == 0)
                    {
                        return null;
                    }
                    _loc_3.objectIds = _loc_4;
                }
                else
                {
                    if (layer.isSnapshot)
                    {
                    }
                    if (layer.timeDefinition)
                    {
                        _loc_7 = layer.featureIds;
                        if (_loc_7.length == 0)
                        {
                            return null;
                        }
                        _loc_3.objectIds = _loc_7;
                    }
                }
                if (_loc_4.length > 0)
                {
                    _loc_2.selectionObjectIds = _loc_4;
                    _loc_2.selectionSymbol = this.getSelectionSymbol(layer.selectionColor, layer.layerDetails.geometryType);
                }
                if (layer.trackIdField)
                {
                    _loc_3.timeInfo = {trackIdField:layer.trackIdField};
                }
                if (!_loc_3.definitionExpression)
                {
                }
                if (!_loc_3.drawingInfo)
                {
                }
                if (!_loc_3.gdbVersion)
                {
                }
                if (!_loc_3.objectIds)
                {
                }
                if (!_loc_3.source)
                {
                }
                if (_loc_3.timeInfo)
                {
                    _loc_2.layerDefinition = _loc_3;
                }
            }
            return _loc_2;
        }// end function

        private function getGPResultImageLayerJSON(layer:GPResultImageLayer) : Object
        {
            var _loc_2:Object = {};
            var _loc_3:* = new URL(layer.url);
            _loc_3.path = _loc_3.path + layer.getPathSuffix();
            _loc_2.url = this.getURLWithToken(_loc_3, layer.credential, layer.token);
            return _loc_2;
        }// end function

        private function getGraphicsLayerJSON(layer:GraphicsLayer) : Object
        {
            var _loc_2:Object = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Object = null;
            var _loc_10:Graphic = null;
            var _loc_11:Object = null;
            var _loc_12:Geometry = null;
            var _loc_13:TextSymbol = null;
            var _loc_14:Object = null;
            var _loc_15:Object = null;
            var _loc_16:Array = null;
            var _loc_17:Object = null;
            var _loc_3:* = layer.graphicProvider as IList;
            if (_loc_3)
            {
            }
            if (_loc_3.length > 0)
            {
                _loc_4 = [];
                _loc_5 = [];
                _loc_6 = [];
                _loc_7 = [];
                _loc_8 = [];
                _loc_9 = this.map.spatialReference ? (this.map.spatialReference.toJSON()) : (null);
                for each (_loc_10 in _loc_3)
                {
                    
                    _loc_11 = null;
                    _loc_12 = _loc_10.geometry;
                    if (_loc_10.visible)
                    {
                    }
                    if (_loc_12)
                    {
                        _loc_11 = _loc_10.toJSON();
                        if (!_loc_12.spatialReference)
                        {
                        }
                        if (_loc_11.geometry)
                        {
                        }
                        if (_loc_9)
                        {
                            _loc_11.geometry.spatialReference = _loc_9;
                        }
                        if (_loc_10.symbol is IJSONSupport)
                        {
                            _loc_11.symbol = (_loc_10.symbol as IJSONSupport).toJSON();
                        }
                        if (_loc_12 is MapPoint)
                        {
                            _loc_13 = _loc_10.getActiveSymbol(layer) as TextSymbol;
                            if (_loc_13)
                            {
                                _loc_14 = _loc_13.toServerJSON(_loc_12 as MapPoint, _loc_10.attributes);
                                if (_loc_14)
                                {
                                }
                                if (_loc_14.text)
                                {
                                    delete _loc_11.attributes;
                                    _loc_11.symbol = _loc_14;
                                    _loc_8.push(_loc_11);
                                }
                            }
                            else
                            {
                                _loc_4.push(_loc_11);
                            }
                            continue;
                        }
                        if (_loc_12 is Polygon)
                        {
                            _loc_5.push(_loc_11);
                            continue;
                        }
                        if (_loc_12 is Polyline)
                        {
                            _loc_6.push(_loc_11);
                            continue;
                        }
                        if (_loc_12 is Multipoint)
                        {
                            _loc_7.push(_loc_11);
                            continue;
                        }
                        if (_loc_12 is Extent)
                        {
                            _loc_11.geometry = (_loc_12 as Extent).toPolygon().toJSON();
                            _loc_5.push(_loc_11);
                        }
                    }
                }
                if (_loc_4.length <= 0)
                {
                }
                if (_loc_5.length <= 0)
                {
                }
                if (_loc_6.length <= 0)
                {
                }
                if (_loc_7.length <= 0)
                {
                }
                if (_loc_8.length > 0)
                {
                    _loc_2 = {};
                    _loc_15 = {};
                    _loc_2.featureCollection = _loc_15;
                    _loc_16 = [];
                    _loc_15.layers = _loc_16;
                    if (_loc_5.length > 0)
                    {
                        _loc_16.push(this.getFCLayerJSON(_loc_5, Geometry.POLYGON, layer));
                    }
                    if (_loc_6.length > 0)
                    {
                        _loc_16.push(this.getFCLayerJSON(_loc_6, Geometry.POLYLINE, layer));
                    }
                    if (_loc_7.length > 0)
                    {
                        _loc_16.push(this.getFCLayerJSON(_loc_7, Geometry.MULTIPOINT, layer));
                    }
                    if (_loc_4.length > 0)
                    {
                        _loc_16.push(this.getFCLayerJSON(_loc_4, Geometry.MAPPOINT, layer));
                    }
                    if (_loc_8.length > 0)
                    {
                        _loc_17 = {layerDefinition:{geometryType:Geometry.MAPPOINT}};
                        _loc_17.featureSet = {features:_loc_8, geometryType:Geometry.MAPPOINT};
                        _loc_16.push(_loc_17);
                    }
                }
            }
            return _loc_2;
        }// end function

        private function getFCLayerJSON(jsonGraphics:Array, geometryType:String, layer:GraphicsLayer) : Object
        {
            var _loc_8:ClassBreaksRenderer = null;
            var _loc_9:UniqueValueRenderer = null;
            var _loc_10:Array = null;
            var _loc_11:String = null;
            var _loc_4:Object = {};
            var _loc_5:Object = {geometryType:geometryType};
            var _loc_6:Array = [];
            var _loc_7:* = layer.renderer;
            if (!_loc_7)
            {
            }
            if (layer.symbol is IJSONSupport)
            {
                _loc_7 = new SimpleRenderer(layer.symbol);
            }
            if (_loc_7)
            {
                if (_loc_7 is IJSONSupport)
                {
                    _loc_5.drawingInfo = {renderer:(_loc_7 as IJSONSupport).toJSON()};
                }
                if (_loc_7 is ClassBreaksRenderer)
                {
                    _loc_8 = _loc_7 as ClassBreaksRenderer;
                    if (_loc_8.field)
                    {
                        _loc_6.push({name:_loc_8.field, type:Field.TYPE_DOUBLE});
                    }
                    if (_loc_8.normalizationField)
                    {
                        _loc_6.push({name:_loc_8.normalizationField, type:Field.TYPE_DOUBLE});
                    }
                }
                else if (_loc_7 is UniqueValueRenderer)
                {
                    _loc_9 = _loc_7 as UniqueValueRenderer;
                    _loc_10 = [_loc_9.field, _loc_9.field2, _loc_9.field3];
                    for each (_loc_11 in _loc_10)
                    {
                        
                        if (_loc_11)
                        {
                            _loc_6.push({name:_loc_11, type:Field.TYPE_STRING});
                        }
                    }
                }
            }
            _loc_5.fields = _loc_6;
            _loc_4.layerDefinition = _loc_5;
            _loc_4.featureSet = {features:jsonGraphics, geometryType:geometryType};
            return _loc_4;
        }// end function

        private function getKMLLayerJSON(layer:KMLLayer) : Object
        {
            var _loc_2:Object = {type:"KML"};
            _loc_2.url = layer.url;
            return _loc_2;
        }// end function

        private function getMapImageLayers(layer:MapImageLayer) : Array
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:MapImage = null;
            var _loc_7:Object = null;
            var _loc_2:Array = [];
            var _loc_3:* = layer.mapImageProvider as IList;
            if (_loc_3)
            {
                _loc_4 = 0;
                _loc_5 = _loc_3.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_6 = _loc_3.getItemAt(_loc_4) as MapImage;
                    if (_loc_6)
                    {
                    }
                    if (_loc_6.extent)
                    {
                        _loc_7 = {type:"image"};
                        _loc_7.extent = _loc_6.extent.toJSON();
                        _loc_7.url = _loc_6.source as String;
                        if (layer.alpha < 1)
                        {
                            _loc_7.opacity = layer.alpha;
                        }
                        _loc_2.push(_loc_7);
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function getOpenStreetMapLayerJSON(layer:OpenStreetMapLayer) : Object
        {
            var _loc_3:String = null;
            var _loc_2:Object = {type:"OpenStreetMap"};
            if (layer.tileServers)
            {
            }
            if (layer.tileServers.length > 0)
            {
                _loc_3 = layer.tileServers[0];
                if (_loc_3 != "http://a.tile.openstreetmap.org/")
                {
                    _loc_2.url = layer.tileServers[0];
                }
            }
            else
            {
                return null;
            }
            return _loc_2;
        }// end function

        private function getVETiledLayerJSON(layer:VETiledLayer) : Object
        {
            var _loc_2:Object = {};
            _loc_2.culture = layer.culture;
            _loc_2.key = layer.key;
            if (layer.mapStyle == VETiledLayer.MAP_STYLE_AERIAL)
            {
                _loc_2.type = "BingMapsAerial";
            }
            else if (layer.mapStyle == VETiledLayer.MAP_STYLE_AERIAL_WITH_LABELS)
            {
                _loc_2.type = "BingMapsHybrid";
            }
            else if (layer.mapStyle == VETiledLayer.MAP_STYLE_ROAD)
            {
                _loc_2.type = "BingMapsRoad";
            }
            return _loc_2;
        }// end function

        private function getWMSLayerJSON(layer:WMSLayer) : Object
        {
            var _loc_2:Object = {type:"wms", transparentBackground:true};
            _loc_2.url = layer.url;
            if (layer.visibleLayers)
            {
                _loc_2.visibleLayers = layer.visibleLayers.toArray();
            }
            if (layer.imageFormat == "jpg")
            {
                _loc_2.format = "jpg";
                _loc_2.transparentBackground = false;
            }
            _loc_2.version = layer.version;
            return _loc_2;
        }// end function

        private function getWMTSLayerJSON(layer:WMTSLayer) : Object
        {
            var _loc_2:Object = {type:"wmts"};
            _loc_2.url = layer.url;
            _loc_2.layer = layer.layerId;
            if (layer.tileMatrixSetId)
            {
                _loc_2.tileMatrixSet = layer.tileMatrixSetId;
            }
            return _loc_2;
        }// end function

        private function getSelectionSymbol(color:uint, geometryType:String) : Symbol
        {
            var _loc_3:Symbol = null;
            var _loc_4:SimpleFillSymbol = null;
            switch(geometryType)
            {
                case Geometry.MAPPOINT:
                case Geometry.MULTIPOINT:
                {
                    _loc_3 = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, 11, color);
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_4 = new SimpleFillSymbol(SimpleFillSymbol.STYLE_NULL);
                    _loc_4.outline = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, color, 1, 3);
                    _loc_3 = _loc_4;
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_3 = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, color, 1, 3);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_3;
        }// end function

        private function getURLWithToken(urlObj:URL, credential:Credential, tokenProp:String) : String
        {
            var _loc_4:* = urlObj.path;
            if (credential)
            {
            }
            if (!credential.token)
            {
            }
            if (!tokenProp)
            {
                if (urlObj.query)
                {
                }
            }
            var _loc_5:* = urlObj.query.token;
            if (_loc_5)
            {
                _loc_4 = _loc_4 + ("?token=" + _loc_5);
            }
            return _loc_4;
        }// end function

    }
}
