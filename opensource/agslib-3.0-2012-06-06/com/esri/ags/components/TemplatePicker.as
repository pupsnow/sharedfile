package com.esri.ags.components
{
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.rpc.*;
    import spark.components.supportClasses.*;

    public class TemplatePicker extends SkinnableComponent
    {
        private var _loading:Boolean;
        private var _featureLayers:Array;
        private var _selectedTemplate:Template;
        private var _featureLayerLoadedCount:Number;
        private var _successfullyLoadedLayers:Array;
        private var _featureLayerToDynamicMapServiceLayer:Dictionary;
        private var _dynamicMapServiceLayerToLegendInfo:Dictionary;
        var onlyShowEditableAndCreateAllowedLayers:Boolean;
        private var _templateCollection:Array;

        public function TemplatePicker(featureLayers:Array = null)
        {
            this._featureLayerToDynamicMapServiceLayer = new Dictionary();
            this._dynamicMapServiceLayerToLegendInfo = new Dictionary();
            this.featureLayers = featureLayers;
            return;
        }// end function

        override public function set enabled(value:Boolean) : void
        {
            if (enabled != value)
            {
                invalidateSkinState();
            }
            super.enabled = value;
            return;
        }// end function

        public function get featureLayers() : Array
        {
            return this._featureLayers;
        }// end function

        public function set featureLayers(value:Array) : void
        {
            var _loc_2:FeatureLayer = null;
            var _loc_3:FeatureLayer = null;
            var _loc_4:FeatureLayer = null;
            for each (_loc_2 in this._featureLayers)
            {
                
                _loc_2.removeEventListener(LayerEvent.LOAD, this.featureLayer_loadCompleteHandler);
                _loc_2.removeEventListener(LayerEvent.LOAD_ERROR, this.featureLayer_loadCompleteHandler);
            }
            this._featureLayers = value;
            this._featureLayerLoadedCount = 0;
            if (this._featureLayers)
            {
                this._loading = true;
                for each (_loc_3 in this._featureLayers)
                {
                    
                    if (!_loc_3.loaded)
                    {
                    }
                    if (!_loc_3.loadFault)
                    {
                        _loc_3.addEventListener(LayerEvent.LOAD, this.featureLayer_loadCompleteHandler, false, -1);
                        _loc_3.addEventListener(LayerEvent.LOAD_ERROR, this.featureLayer_loadCompleteHandler, false, -1);
                        continue;
                    }
                    var _loc_7:String = this;
                    var _loc_8:* = this._featureLayerLoadedCount + 1;
                    _loc_7._featureLayerLoadedCount = _loc_8;
                }
                if (this._featureLayerLoadedCount == this._featureLayers.length)
                {
                    this._loading = false;
                    this._successfullyLoadedLayers = [];
                    for each (_loc_4 in this._featureLayers)
                    {
                        
                        if (this.onlyShowEditableAndCreateAllowedLayers)
                        {
                        }
                        if (_loc_4.isEditable)
                        {
                            if (this.onlyShowEditableAndCreateAllowedLayers)
                            {
                            }
                            if (_loc_4.isEditable)
                            {
                            }
                        }
                        if (this.checkIfCreateIsAllowed(_loc_4))
                        {
                        }
                        if (_loc_4.loadFault)
                        {
                            continue;
                        }
                        this._successfullyLoadedLayers.push(_loc_4);
                    }
                    this.populateTemplateCollection(this._successfullyLoadedLayers);
                }
                invalidateSkinState();
            }
            return;
        }// end function

        public function get selectedTemplate() : Template
        {
            return this._selectedTemplate;
        }// end function

        public function set selectedTemplate(value:Template) : void
        {
            if (this._selectedTemplate)
            {
            }
            if (value)
            {
                if (this._selectedTemplate.featureLayer == value.featureLayer)
                {
                }
                if (this._selectedTemplate.featureType == value.featureType)
                {
                }
                if (this._selectedTemplate.featureTemplate != value.featureTemplate)
                {
                    this._selectedTemplate = value;
                    dispatchEvent(new TemplatePickerEvent(TemplatePickerEvent.SELECTED_TEMPLATE_CHANGE, this._selectedTemplate));
                }
            }
            else if (this._selectedTemplate != value)
            {
                this._selectedTemplate = value;
                dispatchEvent(new TemplatePickerEvent(TemplatePickerEvent.SELECTED_TEMPLATE_CHANGE, this._selectedTemplate));
            }
            return;
        }// end function

        public function get templateCollection() : Array
        {
            return this._templateCollection;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (!enabled)
            {
                return "disabled";
            }
            if (this._loading)
            {
                return "loading";
            }
            return "normal";
        }// end function

        private function featureLayer_loadCompleteHandler(event:LayerEvent) : void
        {
            var _loc_2:FeatureLayer = null;
            var _loc_3:String = this;
            var _loc_4:* = this._featureLayerLoadedCount + 1;
            _loc_3._featureLayerLoadedCount = _loc_4;
            if (this._featureLayerLoadedCount == this._featureLayers.length)
            {
                this._loading = false;
                this._successfullyLoadedLayers = [];
                for each (_loc_2 in this._featureLayers)
                {
                    
                    if (_loc_2.loaded)
                    {
                    }
                    if (!_loc_2.loadFault)
                    {
                        if (this.onlyShowEditableAndCreateAllowedLayers)
                        {
                        }
                        if (_loc_2.isEditable)
                        {
                            if (this.onlyShowEditableAndCreateAllowedLayers)
                            {
                            }
                            if (_loc_2.isEditable)
                            {
                            }
                        }
                        if (!this.checkIfCreateIsAllowed(_loc_2))
                        {
                            continue;
                        }
                        this._successfullyLoadedLayers.push(_loc_2);
                    }
                }
                this.populateTemplateCollection(this._successfullyLoadedLayers);
                invalidateSkinState();
            }
            return;
        }// end function

        public function clearSelection() : void
        {
            this.selectedTemplate = null;
            return;
        }// end function

        override public function styleChanged(styleProp:String) : void
        {
            super.styleChanged(styleProp);
            if (styleProp == "skinClass")
            {
                callLater(this.populateTemplateCollection, [this._successfullyLoadedLayers]);
            }
            return;
        }// end function

        private function populateTemplateCollection(loadedFeatureLayers:Array) : void
        {
            this._templateCollection = [];
            var _loc_2:int = 0;
            this.getTemplatesForFeatureLayer(_loc_2, loadedFeatureLayers);
            return;
        }// end function

        private function getTemplatesForFeatureLayer(index:int, loadedFeatureLayers:Array) : void
        {
            var featureLayer:FeatureLayer;
            var templateArray:Array;
            var template:Template;
            var template0:FeatureTemplate;
            var type:FeatureType;
            var template1:FeatureTemplate;
            var template2:FeatureTemplate;
            var dynamicMapServiceLayer:ArcGISDynamicMapServiceLayer;
            var index:* = index;
            var loadedFeatureLayers:* = loadedFeatureLayers;
            if (index < loadedFeatureLayers.length)
            {
                featureLayer = loadedFeatureLayers[index];
                templateArray;
                if (featureLayer.layerDetails)
                {
                    if (featureLayer.layerDetails.types)
                    {
                    }
                    if (featureLayer.layerDetails.types.length == 0)
                    {
                        if (FeatureLayerDetails(featureLayer.layerDetails).templates)
                        {
                        }
                        if (FeatureLayerDetails(featureLayer.layerDetails).templates.length > 0)
                        {
                            var _loc_4:int = 0;
                            var _loc_5:* = FeatureLayerDetails(featureLayer.layerDetails).templates;
                            while (_loc_5 in _loc_4)
                            {
                                
                                template0 = _loc_5[_loc_4];
                                template = new Template();
                                template.featureLayer = featureLayer;
                                template.featureTemplate = template0;
                                templateArray.push(template);
                            }
                        }
                        else
                        {
                            template = new Template();
                            template.featureLayer = featureLayer;
                            templateArray.push(template);
                        }
                    }
                    else
                    {
                        if (featureLayer.layerDetails.types)
                        {
                        }
                        if (featureLayer.layerDetails.types.length > 0)
                        {
                            var _loc_4:int = 0;
                            var _loc_5:* = featureLayer.layerDetails.types;
                            while (_loc_5 in _loc_4)
                            {
                                
                                type = _loc_5[_loc_4];
                                if (type.templates)
                                {
                                    var _loc_6:int = 0;
                                    var _loc_7:* = type.templates;
                                    while (_loc_7 in _loc_6)
                                    {
                                        
                                        template1 = _loc_7[_loc_6];
                                        template = new Template();
                                        template.featureLayer = featureLayer;
                                        template.featureType = type;
                                        template.featureTemplate = template1;
                                        templateArray.push(template);
                                    }
                                    continue;
                                }
                                if (FeatureLayerDetails(featureLayer.layerDetails).templates)
                                {
                                    var _loc_6:int = 0;
                                    var _loc_7:* = FeatureLayerDetails(featureLayer.layerDetails).templates;
                                    while (_loc_7 in _loc_6)
                                    {
                                        
                                        template2 = _loc_7[_loc_6];
                                        template = new Template();
                                        template.featureLayer = featureLayer;
                                        template.featureType = type;
                                        template.featureTemplate = template2;
                                        templateArray.push(template);
                                    }
                                    continue;
                                }
                                template = new Template();
                                template.featureLayer = featureLayer;
                                template.featureType = type;
                                templateArray.push(template);
                            }
                        }
                    }
                    if (featureLayer.mode == FeatureLayer.MODE_SELECTION)
                    {
                    }
                    if (featureLayer.layerDetails.version >= 10.1)
                    {
                        var getLegendResult:* = function (layerLegendInfos:Array, token:Object = null) : void
            {
                _dynamicMapServiceLayerToLegendInfo[token as ArcGISDynamicMapServiceLayer] = layerLegendInfos;
                parseLayerLegendInfos(layerLegendInfos);
                return;
            }// end function
            ;
                        var getLegendFault:* = function (fault:Fault, token:Object = null) : void
            {
                parseTemplates(index, templateArray, featureLayer, loadedFeatureLayers);
                return;
            }// end function
            ;
                        var parseLayerLegendInfos:* = function (layerLegendInfos:Array) : void
            {
                var _loc_2:Array = null;
                var _loc_4:Template = null;
                var _loc_5:LegendItemInfo = null;
                var _loc_6:Template = null;
                var _loc_7:Template = null;
                var _loc_3:int = 0;
                while (_loc_3 < layerLegendInfos.length)
                {
                    
                    if (LayerLegendInfo(layerLegendInfos[_loc_3]).layerId == String(featureLayer.layerDetails.id))
                    {
                        _loc_2 = LayerLegendInfo(layerLegendInfos[_loc_3]).legendItemInfos;
                        break;
                        continue;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                if (_loc_2)
                {
                }
                if (_loc_2.length)
                {
                    for each (_loc_4 in templateArray)
                    {
                        
                        for each (_loc_5 in _loc_2)
                        {
                            
                            if (_loc_5.values)
                            {
                            }
                            if (_loc_5.values.length)
                            {
                                if (_loc_4.featureTemplate.prototype.attributes[featureLayer.layerDetails.typeIdField] == _loc_5.values[0])
                                {
                                    _loc_4.symbol = _loc_5.symbol;
                                }
                                continue;
                            }
                            for each (_loc_6 in templateArray)
                            {
                                
                                _loc_6.symbol = getTemplateSymbol(_loc_6, featureLayer);
                            }
                        }
                    }
                }
                else
                {
                    for each (_loc_7 in templateArray)
                    {
                        
                        _loc_7.symbol = getTemplateSymbol(_loc_7, featureLayer);
                    }
                }
                var _loc_9:* = index + 1;
                index = _loc_9;
                _templateCollection.push({featureLayer:featureLayer, selectedTemplates:templateArray, templates:templateArray});
                getTemplatesForFeatureLayer(index, loadedFeatureLayers);
                return;
            }// end function
            ;
                        dynamicMapServiceLayer = this.getDynamicMapServiceLayer(featureLayer);
                        if (dynamicMapServiceLayer)
                        {
                            if (!this._dynamicMapServiceLayerToLegendInfo[dynamicMapServiceLayer])
                            {
                                dynamicMapServiceLayer.getLegendInfos(new AsyncResponder(getLegendResult, getLegendFault, dynamicMapServiceLayer));
                            }
                            else
                            {
                                this.parseLayerLegendInfos(this._dynamicMapServiceLayerToLegendInfo[dynamicMapServiceLayer]);
                            }
                        }
                        else
                        {
                            this.parseTemplates(index, templateArray, featureLayer, loadedFeatureLayers);
                        }
                    }
                    else
                    {
                        this.parseTemplates(index, templateArray, featureLayer, loadedFeatureLayers);
                    }
                }
            }
            else
            {
                this._loading = false;
                invalidateSkinState();
                dispatchEvent(new Event("templateCollectionReady"));
            }
            return;
        }// end function

        private function parseTemplates(index:int, templateArray:Array, featureLayer:FeatureLayer, loadedFeatureLayers:Array) : void
        {
            var _loc_5:Template = null;
            for each (_loc_5 in templateArray)
            {
                
                _loc_5.symbol = this.getTemplateSymbol(_loc_5, featureLayer);
            }
            index = index + 1;
            this._templateCollection.push({featureLayer:featureLayer, selectedTemplates:templateArray, templates:templateArray});
            this.getTemplatesForFeatureLayer(index, loadedFeatureLayers);
            return;
        }// end function

        private function getDynamicMapServiceLayer(featureLayer:FeatureLayer) : ArcGISDynamicMapServiceLayer
        {
            var _loc_2:ArcGISDynamicMapServiceLayer = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:Layer = null;
            if (this._featureLayerToDynamicMapServiceLayer[featureLayer])
            {
                _loc_2 = this._featureLayerToDynamicMapServiceLayer[featureLayer];
            }
            else
            {
                _loc_3 = featureLayer.url.substring(0, featureLayer.url.lastIndexOf("/"));
                _loc_4 = _loc_3.replace("FeatureServer", "MapServer");
                for each (_loc_5 in featureLayer.map.layers)
                {
                    
                    if (_loc_5 is ArcGISDynamicMapServiceLayer)
                    {
                    }
                    if (ArcGISDynamicMapServiceLayer(_loc_5).url == _loc_4)
                    {
                        if (featureLayer.gdbVersion)
                        {
                            if (ArcGISDynamicMapServiceLayer(_loc_5).gdbVersion)
                            {
                            }
                            if (ArcGISDynamicMapServiceLayer(_loc_5).gdbVersion == featureLayer.gdbVersion)
                            {
                                _loc_2 = ArcGISDynamicMapServiceLayer(_loc_5);
                                this._featureLayerToDynamicMapServiceLayer[featureLayer] = _loc_2;
                                break;
                            }
                            continue;
                        }
                        _loc_2 = ArcGISDynamicMapServiceLayer(_loc_5);
                        this._featureLayerToDynamicMapServiceLayer[featureLayer] = _loc_2;
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        private function getTemplateSymbol(template:Template, featureLayer:FeatureLayer) : Symbol
        {
            var _loc_3:Symbol = null;
            if (featureLayer.renderer)
            {
                if (template.featureTemplate)
                {
                    _loc_3 = featureLayer.renderer.getSymbol(template.featureTemplate.prototype);
                    if (_loc_3 is CompositeSymbol)
                    {
                        _loc_3 = this.getDefaultSymbolBasedOnGeometry(featureLayer);
                    }
                }
            }
            else if (featureLayer.symbol)
            {
                _loc_3 = featureLayer.symbol;
                if (_loc_3 is CompositeSymbol)
                {
                    _loc_3 = this.getDefaultSymbolBasedOnGeometry(featureLayer);
                }
            }
            else
            {
                _loc_3 = this.getDefaultSymbolBasedOnGeometry(featureLayer);
            }
            return _loc_3;
        }// end function

        private function getDefaultSymbolBasedOnGeometry(fLayer:FeatureLayer) : Symbol
        {
            var _loc_2:Symbol = null;
            switch(fLayer.layerDetails.geometryType)
            {
                case Geometry.MAPPOINT:
                {
                    _loc_2 = new SimpleMarkerSymbol();
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_2 = new SimpleLineSymbol();
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_2 = new SimpleFillSymbol();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function checkIfCreateIsAllowed(featureLayer:FeatureLayer) : Boolean
        {
            var _loc_2:Boolean = false;
            if (featureLayer.layerDetails is FeatureLayerDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureLayerDetails).isCreateAllowed;
            }
            else if (featureLayer.tableDetails is FeatureTableDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureTableDetails).isCreateAllowed;
            }
            return _loc_2;
        }// end function

    }
}
