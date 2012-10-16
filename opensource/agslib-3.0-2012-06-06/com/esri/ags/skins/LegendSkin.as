package com.esri.ags.skins
{
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.skins.supportClasses.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.binding.utils.*;
    import mx.collections.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.layouts.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class LegendSkin extends SparkSkin implements IBindingClient, IStateClient2
    {
        public var _LegendSkin_HGroup1:HGroup;
        public var _LegendSkin_Label1:Label;
        public var _LegendSkin_SWFLoader1:SWFLoader;
        private var _897015999_LegendSkin_Scroller1:Scroller;
        private var _1636506674_LegendSkin_VGroup1:VGroup;
        private var _1952144589noLegendImage:BitmapImage;
        private var _3587215vGrp:VGroup;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _legendCollectionChanged:Boolean;
        private var _changeWatcher:ChangeWatcher;
        private var _visibleLayersChangeWatcher:ChangeWatcher;
        private var _itemRenderer:LegendGroupItemRenderer;
        private var _1097519085loader:Class;
        private var _embed_mxml_____________assets_skins_nolayers_png_2087816685:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:Legend;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function LegendSkin()
        {
            var bindings:Array;
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._itemRenderer = new LegendGroupItemRenderer();
            this._1097519085loader = LegendSkin_loader;
            this._embed_mxml_____________assets_skins_nolayers_png_2087816685 = LegendSkin__embed_mxml_____________assets_skins_nolayers_png_2087816685;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            bindings = this._LegendSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_LegendSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return [propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.layout = this._LegendSkin_VerticalLayout1_c();
            this.mxmlContent = [this._LegendSkin_Scroller1_i()];
            this.currentState = "normal";
            this.addEventListener("initialize", this.___LegendSkin_SparkSkin1_initialize);
            var _LegendSkin_HGroup1_factory:* = new DeferredInstanceFromFunction(this._LegendSkin_HGroup1_i);
            var _LegendSkin_VGroup2_factory:* = new DeferredInstanceFromFunction(this._LegendSkin_VGroup2_i);
            states = [new State({name:"normal", overrides:[new AddItems().initializeFromObject({itemsFactory:_LegendSkin_VGroup2_factory, destination:"_LegendSkin_VGroup1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_LegendSkin_Scroller1", name:"enabled", value:true})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_LegendSkin_VGroup2_factory, destination:"_LegendSkin_VGroup1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_LegendSkin_Scroller1", name:"enabled", value:true})]}), new State({name:"loading", overrides:[new AddItems().initializeFromObject({itemsFactory:_LegendSkin_HGroup1_factory, destination:"_LegendSkin_VGroup1", propertyName:"mxmlContent", position:"first"})]})];
            var i:uint;
            while (i < bindings.length)
            {
                
                Binding(bindings[i]).execute();
                i = (i + 1);
            }
            return;
        }// end function

        override public function set moduleFactory(factory:IFlexModuleFactory) : void
        {
            super.moduleFactory = factory;
            if (this.__moduleFactoryInitialized)
            {
                return;
            }
            this.__moduleFactoryInitialized = true;
            return;
        }// end function

        override public function initialize() : void
        {
            super.initialize();
            return;
        }// end function

        private function sparkskin1_initializeHandler(event:FlexEvent) : void
        {
            this._changeWatcher = ChangeWatcher.watch(this.hostComponent, "legendCollection", this.legendCollectionChangeHandler);
            return;
        }// end function

        private function legendCollectionChangeHandler(event:Event = null) : void
        {
            invalidateProperties();
            this._legendCollectionChanged = true;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var element:int;
            var i:Number;
            var serviceGroup:VGroup;
            var serviceLabel:Label;
            var j:Number;
            var dynamicMapServiceLayer:ArcGISDynamicMapServiceLayer;
            var addLegendGroup:* = function (serviceGroup:VGroup, serviceLabel:Label, layer:Layer, currentLayerLegendInfo:LayerLegendInfo) : void
            {
                var _loc_5:LayerLegendInfo = null;
                var _loc_6:VerticalLayout = null;
                var _loc_7:DataGroup = null;
                var _loc_8:ArrayCollection = null;
                var _loc_9:Number = NaN;
                var _loc_10:Label = null;
                if (currentLayerLegendInfo)
                {
                    if (currentLayerLegendInfo.layerLegendInfos)
                    {
                    }
                    if (currentLayerLegendInfo.layerLegendInfos.length > 0)
                    {
                        for each (_loc_5 in currentLayerLegendInfo.layerLegendInfos)
                        {
                            
                            addLegendGroup(serviceGroup, serviceLabel, layer, _loc_5);
                        }
                    }
                    else
                    {
                        if (!(layer is GraphicsLayer))
                        {
                        }
                        if (layer is KMLLayer)
                        {
                            serviceLabel.text = currentLayerLegendInfo.layerName;
                        }
                        else
                        {
                            _loc_10 = new Label();
                            _loc_10.name = String(currentLayerLegendInfo.layerId);
                            _loc_10.text = currentLayerLegendInfo.layerName;
                            if (layer is ArcGISDynamicMapServiceLayer)
                            {
                                if (layer.visible)
                                {
                                    if (currentLayerLegendInfo.visible)
                                    {
                                        if (!subLayerInScaleRange(currentLayerLegendInfo))
                                        {
                                            if (hostComponent.respectCurrentMapScale)
                                            {
                                                var _loc_11:Boolean = false;
                                                _loc_10.includeInLayout = false;
                                                _loc_10.visible = _loc_11;
                                            }
                                            else
                                            {
                                                _loc_10.alpha = 0.5;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        var _loc_11:Boolean = false;
                                        _loc_10.includeInLayout = false;
                                        _loc_10.visible = _loc_11;
                                    }
                                }
                            }
                            serviceGroup.addElement(_loc_10);
                        }
                        _loc_6 = new VerticalLayout();
                        _loc_6.gap = 0;
                        _loc_6.horizontalAlign = "left";
                        _loc_6.useVirtualLayout = true;
                        _loc_7 = new DataGroup();
                        _loc_7.name = String(currentLayerLegendInfo.layerId);
                        _loc_7.layout = _loc_6;
                        _loc_8 = new ArrayCollection();
                        _loc_9 = 0;
                        while (_loc_9 < currentLayerLegendInfo.legendItemInfos.length)
                        {
                            
                            _loc_8.addItem(currentLayerLegendInfo.legendItemInfos[_loc_9]);
                            _loc_9 = _loc_9 + 1;
                        }
                        _loc_7.dataProvider = _loc_8;
                        _loc_7.itemRenderer = new ClassFactory(LegendGroupItemRenderer);
                        if (layer is ArcGISDynamicMapServiceLayer)
                        {
                            if (layer.visible)
                            {
                                if (currentLayerLegendInfo.visible)
                                {
                                    if (!subLayerInScaleRange(currentLayerLegendInfo))
                                    {
                                        if (hostComponent.respectCurrentMapScale)
                                        {
                                            var _loc_11:Boolean = false;
                                            _loc_7.includeInLayout = false;
                                            _loc_7.visible = _loc_11;
                                        }
                                        else
                                        {
                                            _loc_7.alpha = 0.5;
                                        }
                                    }
                                }
                                else
                                {
                                    var _loc_11:Boolean = false;
                                    _loc_7.includeInLayout = false;
                                    _loc_7.visible = _loc_11;
                                }
                            }
                        }
                        serviceGroup.addElement(_loc_7);
                    }
                }
                return;
            }// end function
            ;
            super.commitProperties();
            if (this._legendCollectionChanged)
            {
                this._legendCollectionChanged = false;
                element;
                while (element < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(element))
                    {
                        this.vGrp.getElementAt(element);
                        if (!(this.vGrp.getElementAt(element) is VGroup))
                        {
                        }
                    }
                    if (this.vGrp.getElementAt(element) is Spacer)
                    {
                        this.vGrp.removeElement(this.vGrp.getElementAt(element));
                        element = (element - 1);
                        continue;
                    }
                    element = (element + 1);
                }
                if (this.hostComponent.legendCollection)
                {
                    var _loc_2:Boolean = false;
                    this.noLegendImage.includeInLayout = false;
                    this.noLegendImage.visible = _loc_2;
                    this.hostComponent.map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
                    this.hostComponent.map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
                    i;
                    while (i < this.hostComponent.legendCollection.length)
                    {
                        
                        if (this.hostComponent.legendCollection[i].layerLegendInfos)
                        {
                        }
                        if (this.hostComponent.legendCollection[i].layerLegendInfos.length > 0)
                        {
                            serviceGroup = new VGroup();
                            serviceGroup.name = this.hostComponent.legendCollection[i].layer.id;
                            serviceLabel = new Label();
                            serviceLabel.text = this.hostComponent.legendCollection[i].title;
                            serviceLabel.setStyle("fontWeight", "bold");
                            serviceGroup.addElement(serviceLabel);
                            serviceGroup.addElement(new Spacer());
                            this.vGrp.addElement(serviceGroup);
                            if (Layer(this.hostComponent.legendCollection[i].layer).visible)
                            {
                                if (!Layer(this.hostComponent.legendCollection[i].layer).isInScaleRange)
                                {
                                    if (this.hostComponent.respectCurrentMapScale)
                                    {
                                        var _loc_2:Boolean = false;
                                        serviceGroup.includeInLayout = false;
                                        serviceGroup.visible = _loc_2;
                                    }
                                    else
                                    {
                                        serviceGroup.alpha = 0.5;
                                    }
                                }
                            }
                            else
                            {
                                var _loc_2:Boolean = false;
                                serviceGroup.includeInLayout = false;
                                serviceGroup.visible = _loc_2;
                            }
                            j;
                            while (j < this.hostComponent.legendCollection[i].layerLegendInfos.length)
                            {
                                
                                this.addLegendGroup(serviceGroup, serviceLabel, this.hostComponent.legendCollection[i].layer, LayerLegendInfo(this.hostComponent.legendCollection[i].layerLegendInfos[j]));
                                j = (j + 1);
                            }
                            Layer(this.hostComponent.legendCollection[i].layer).removeEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.layer_isInScaleRangeChangeHandler);
                            Layer(this.hostComponent.legendCollection[i].layer).removeEventListener(FlexEvent.HIDE, this.layer_hideShowHandler);
                            Layer(this.hostComponent.legendCollection[i].layer).removeEventListener(FlexEvent.SHOW, this.layer_hideShowHandler);
                            Layer(this.hostComponent.legendCollection[i].layer).addEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.layer_isInScaleRangeChangeHandler);
                            Layer(this.hostComponent.legendCollection[i].layer).addEventListener(FlexEvent.HIDE, this.layer_hideShowHandler);
                            Layer(this.hostComponent.legendCollection[i].layer).addEventListener(FlexEvent.SHOW, this.layer_hideShowHandler);
                            if (this.hostComponent.legendCollection[i].layer is ArcGISDynamicMapServiceLayer)
                            {
                                this.checkServiceGroupVisibility(serviceGroup);
                                dynamicMapServiceLayer = ArcGISDynamicMapServiceLayer(this.hostComponent.legendCollection[i].layer);
                                if (dynamicMapServiceLayer.visibleLayers)
                                {
                                    dynamicMapServiceLayer.visibleLayers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayersChangeHandler);
                                    dynamicMapServiceLayer.visibleLayers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayersChangeHandler);
                                }
                                this._visibleLayersChangeWatcher = ChangeWatcher.watch(dynamicMapServiceLayer, "visibleLayers", this.visibleLayersChange);
                            }
                        }
                        i = (i + 1);
                    }
                    invalidateDisplayList();
                    this.isLegendShown();
                }
                else
                {
                    var _loc_2:Boolean = true;
                    this.noLegendImage.includeInLayout = true;
                    this.noLegendImage.visible = _loc_2;
                }
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            var _loc_3:Number = NaN;
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (this.vGrp)
            {
                _loc_3 = 0;
                while (_loc_3 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_3) is VGroup)
                    {
                        VGroup(this.vGrp.getElementAt(_loc_3)).percentWidth = 100;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                this.vGrp.invalidateSize();
            }
            return;
        }// end function

        private function checkServiceGroupVisibility(serviceGroup:VGroup) : void
        {
            var _loc_3:Boolean = false;
            serviceGroup.includeInLayout = false;
            serviceGroup.visible = _loc_3;
            var _loc_2:int = 0;
            while (_loc_2 < serviceGroup.numElements)
            {
                
                if (serviceGroup.getElementAt(_loc_2) is DataGroup)
                {
                }
                if (serviceGroup.getElementAt(_loc_2).visible)
                {
                    var _loc_3:Boolean = true;
                    serviceGroup.includeInLayout = true;
                    serviceGroup.visible = _loc_3;
                    break;
                    continue;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function isSubLayerVisible(layerLegendInfo:LayerLegendInfo, dynamicMapServiceLayer:ArcGISDynamicMapServiceLayer, checkDefaultVisibility:Boolean = false) : Boolean
        {
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:int = 0;
            var _loc_7:LayerInfo = null;
            if (!checkDefaultVisibility)
            {
                _loc_4 = this.getActualVisibleLayers(dynamicMapServiceLayer.visibleLayers.toArray(), dynamicMapServiceLayer.dynamicLayerInfos ? (dynamicMapServiceLayer.dynamicLayerInfos.slice()) : (dynamicMapServiceLayer.layerInfos.slice()));
                layerLegendInfo.visible = _loc_4.indexOf(Number(layerLegendInfo.layerId)) != -1 ? (true) : (false);
            }
            else
            {
                _loc_5 = dynamicMapServiceLayer.dynamicLayerInfos ? (dynamicMapServiceLayer.dynamicLayerInfos) : (dynamicMapServiceLayer.layerInfos);
                _loc_6 = 0;
                while (_loc_6 < _loc_5.length)
                {
                    
                    if (_loc_5[_loc_6].layerId == layerLegendInfo.layerId)
                    {
                        if (_loc_5[_loc_6].parentLayerId != -1)
                        {
                            _loc_7 = this.findLayerById(_loc_5[0].parentLayerId, _loc_5);
                            _loc_5[_loc_6].defaultVisibility = _loc_7.defaultVisibility;
                        }
                        layerLegendInfo.visible = _loc_5[_loc_6].defaultVisibility;
                        break;
                        continue;
                    }
                    _loc_6 = _loc_6 + 1;
                }
            }
            return layerLegendInfo.visible;
        }// end function

        private function findLayerById(id:Number, layerInfos:Array) : LayerInfo
        {
            var _loc_3:LayerInfo = null;
            for each (_loc_3 in layerInfos)
            {
                
                if (id == _loc_3.layerId)
                {
                    return _loc_3;
                }
            }
            return null;
        }// end function

        private function getActualVisibleLayers(layerIds:Array, layerInfos:Array) : Array
        {
            var _loc_4:LayerInfo = null;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_3:Array = [];
            layerIds = layerIds ? (layerIds.concat()) : (null);
            if (layerIds)
            {
                for each (_loc_4 in layerInfos)
                {
                    
                    _loc_5 = layerIds.indexOf(_loc_4.layerId);
                    if (_loc_4.subLayerIds)
                    {
                    }
                    if (_loc_5 != -1)
                    {
                        layerIds.splice(_loc_5, 1);
                        for each (_loc_6 in _loc_4.subLayerIds)
                        {
                            
                            layerIds.push(_loc_6);
                        }
                    }
                }
                for each (_loc_4 in layerInfos.reverse())
                {
                    
                    if (layerIds.indexOf(_loc_4.layerId) != -1)
                    {
                    }
                    if (layerIds.indexOf(_loc_4.parentLayerId) == -1)
                    {
                    }
                    if (_loc_4.parentLayerId != -1)
                    {
                        layerIds.push(_loc_4.parentLayerId);
                    }
                }
                _loc_3 = layerIds;
            }
            return _loc_3;
        }// end function

        private function subLayerInScaleRange(layerLegendInfo:LayerLegendInfo) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_2:Boolean = true;
            var _loc_3:* = this.hostComponent.map;
            if (_loc_3)
            {
                if (layerLegendInfo.maxScale <= 0)
                {
                }
            }
            if (layerLegendInfo.minScale > 0)
            {
                _loc_4 = _loc_3.scale;
                if (layerLegendInfo.maxScale > 0)
                {
                }
                if (layerLegendInfo.minScale > 0)
                {
                    if (layerLegendInfo.maxScale <= Math.ceil(_loc_4))
                    {
                    }
                    _loc_2 = Math.floor(_loc_4) <= layerLegendInfo.minScale;
                }
                else if (layerLegendInfo.maxScale > 0)
                {
                    _loc_2 = layerLegendInfo.maxScale <= Math.ceil(_loc_4);
                }
                else if (layerLegendInfo.minScale > 0)
                {
                    _loc_2 = Math.floor(_loc_4) <= layerLegendInfo.minScale;
                }
            }
            return _loc_2;
        }// end function

        private function layer_isInScaleRangeChangeHandler(event:LayerEvent) : void
        {
            this.serviceGroupShowHide(event.layer);
            return;
        }// end function

        private function layer_hideShowHandler(event:FlexEvent) : void
        {
            this.serviceGroupShowHide(Layer(event.target));
            return;
        }// end function

        private function extentChangeHandler(event:ExtentEvent) : void
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this.hostComponent.legendCollection.length)
            {
                
                if (this.hostComponent.legendCollection[_loc_2].layer is ArcGISDynamicMapServiceLayer)
                {
                }
                if (ArcGISDynamicMapServiceLayer(this.hostComponent.legendCollection[_loc_2].layer).isInScaleRange)
                {
                }
                if (ArcGISDynamicMapServiceLayer(this.hostComponent.legendCollection[_loc_2].layer).visible)
                {
                    this.checkServiceGroupForDynamicMapServiceLayer(this.hostComponent.legendCollection[_loc_2]);
                    break;
                    continue;
                }
                _loc_2 = _loc_2 + 1;
            }
            this.isLegendShown();
            return;
        }// end function

        private function checkServiceGroupForDynamicMapServiceLayer(legendCollectionObject:Object) : void
        {
            var count:int;
            var leafLayerLegendInfo:LayerLegendInfo;
            var j:Number;
            var legendCollectionObject:* = legendCollectionObject;
            var showHideLayersBasedOnScale:* = function (isInScaleRange:Boolean, serviceGroup:VGroup, layer:Layer, leafLayerLegendInfo:LayerLegendInfo, numLeaf:Number) : void
            {
                var _loc_6:int = 0;
                var _loc_7:int = 0;
                if (!isInScaleRange)
                {
                    var _loc_9:* = count + 1;
                    count = _loc_9;
                }
                if (count == numLeaf)
                {
                    if (hostComponent.respectCurrentMapScale)
                    {
                        var _loc_8:Boolean = false;
                        serviceGroup.visible = false;
                        serviceGroup.includeInLayout = _loc_8;
                    }
                    else
                    {
                        serviceGroup.alpha = isInScaleRange ? (1) : (0.5);
                    }
                }
                else
                {
                    if (hostComponent.respectCurrentMapScale)
                    {
                        var _loc_8:Boolean = true;
                        serviceGroup.includeInLayout = true;
                        serviceGroup.visible = _loc_8;
                    }
                    else
                    {
                        serviceGroup.alpha = 1;
                    }
                    _loc_7 = 0;
                    while (_loc_7 < serviceGroup.numElements)
                    {
                        
                        if (serviceGroup.getElementAt(_loc_7) is Label)
                        {
                        }
                        if (Label(serviceGroup.getElementAt(_loc_7)).name == String(leafLayerLegendInfo.layerId))
                        {
                            if (leafLayerLegendInfo.visible)
                            {
                                var _loc_8:Boolean = true;
                                Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = true;
                                Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                if (hostComponent.respectCurrentMapScale)
                                {
                                    var _loc_8:* = isInScaleRange;
                                    Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = isInScaleRange;
                                    Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                }
                                else
                                {
                                    Label(serviceGroup.getElementAt(_loc_7)).alpha = isInScaleRange ? (1) : (0.5);
                                }
                            }
                            else
                            {
                                var _loc_8:Boolean = false;
                                Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                            }
                        }
                        if (serviceGroup.getElementAt(_loc_7) is DataGroup)
                        {
                        }
                        if (DataGroup(serviceGroup.getElementAt(_loc_7)).name == String(leafLayerLegendInfo.layerId))
                        {
                            if (leafLayerLegendInfo.visible)
                            {
                                var _loc_8:Boolean = true;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = true;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                if (hostComponent.respectCurrentMapScale)
                                {
                                    var _loc_8:* = isInScaleRange;
                                    DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = isInScaleRange;
                                    DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                }
                                else
                                {
                                    DataGroup(serviceGroup.getElementAt(_loc_7)).alpha = isInScaleRange ? (1) : (0.5);
                                }
                            }
                            else
                            {
                                var _loc_8:Boolean = false;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                            }
                        }
                        _loc_7 = _loc_7 + 1;
                    }
                }
                return;
            }// end function
            ;
            var serviceGroup:* = this.getServiceGroup(legendCollectionObject.layer);
            count;
            var arrLeafLayerLegendInfo:Array;
            if (legendCollectionObject.layerLegendInfos)
            {
            }
            if (legendCollectionObject.layerLegendInfos.length > 0)
            {
                j;
                while (j < legendCollectionObject.layerLegendInfos.length)
                {
                    
                    this.findLeafLayerLegendInfo(LayerLegendInfo(legendCollectionObject.layerLegendInfos[j]), arrLeafLayerLegendInfo);
                    j = (j + 1);
                }
            }
            var _loc_3:int = 0;
            var _loc_4:* = arrLeafLayerLegendInfo;
            while (_loc_4 in _loc_3)
            {
                
                leafLayerLegendInfo = _loc_4[_loc_3];
                this.showHideLayersBasedOnScale(this.subLayerInScaleRange(leafLayerLegendInfo), serviceGroup, legendCollectionObject.layer, leafLayerLegendInfo, arrLeafLayerLegendInfo.length);
            }
            return;
        }// end function

        private function visibleLayersChange(event:Event = null) : void
        {
            var _loc_2:* = ArcGISDynamicMapServiceLayer(event.target);
            if (_loc_2.visibleLayers)
            {
                _loc_2.visibleLayers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayersChangeHandler);
                _loc_2.visibleLayers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.visibleLayersChangeHandler);
            }
            if (_loc_2.visible)
            {
                this.visibleLayersChanged(_loc_2, _loc_2.visibleLayers ? (false) : (true));
            }
            return;
        }// end function

        private function visibleLayersChangeHandler(event:CollectionEvent) : void
        {
            var _loc_2:* = ArrayCollection(this.hostComponent.map.layers);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if (_loc_2.getItemAt(_loc_3) is ArcGISDynamicMapServiceLayer)
                {
                }
                if (ArcGISDynamicMapServiceLayer(_loc_2.getItemAt(_loc_3)).visible)
                {
                }
                if (ArcGISDynamicMapServiceLayer(_loc_2.getItemAt(_loc_3)).visibleLayers === event.target)
                {
                    this.visibleLayersChanged(ArcGISDynamicMapServiceLayer(_loc_2.getItemAt(_loc_3)));
                    break;
                    continue;
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function visibleLayersChanged(layer:ArcGISDynamicMapServiceLayer, goBackToDeafultVisibility:Boolean = false) : void
        {
            var dynamicMapServiceLayer:ArcGISDynamicMapServiceLayer;
            var serviceGroup:VGroup;
            var count:int;
            var arrLeafLayerLegendInfo:Array;
            var j:Number;
            var leafLayerLegendInfo:LayerLegendInfo;
            var layer:* = layer;
            var goBackToDeafultVisibility:* = goBackToDeafultVisibility;
            var showHideLayersBasedOnVisibility:* = function (isSubLayerVisible:Boolean, serviceGroup:VGroup, layer:Layer, leafLayerLegendInfo:LayerLegendInfo, numLeaf:Number) : void
            {
                var _loc_6:int = 0;
                var _loc_7:int = 0;
                if (!isSubLayerVisible)
                {
                    var _loc_9:* = count + 1;
                    count = _loc_9;
                }
                if (count == numLeaf)
                {
                    var _loc_8:Boolean = false;
                    serviceGroup.visible = false;
                    serviceGroup.includeInLayout = _loc_8;
                }
                else
                {
                    var _loc_8:Boolean = true;
                    serviceGroup.includeInLayout = true;
                    serviceGroup.visible = _loc_8;
                    _loc_7 = 0;
                    while (_loc_7 < serviceGroup.numElements)
                    {
                        
                        if (serviceGroup.getElementAt(_loc_7) is Label)
                        {
                        }
                        if (Label(serviceGroup.getElementAt(_loc_7)).name == String(leafLayerLegendInfo.layerId))
                        {
                            if (isSubLayerVisible)
                            {
                                var _loc_8:Boolean = true;
                                Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = true;
                                Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                if (!subLayerInScaleRange(leafLayerLegendInfo))
                                {
                                    if (hostComponent.respectCurrentMapScale)
                                    {
                                        var _loc_8:Boolean = false;
                                        Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                        Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                    }
                                    else
                                    {
                                        Label(serviceGroup.getElementAt(_loc_7)).alpha = 0.5;
                                    }
                                }
                            }
                            else
                            {
                                var _loc_8:Boolean = false;
                                Label(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                Label(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                            }
                        }
                        if (serviceGroup.getElementAt(_loc_7) is DataGroup)
                        {
                        }
                        if (DataGroup(serviceGroup.getElementAt(_loc_7)).name == String(leafLayerLegendInfo.layerId))
                        {
                            if (isSubLayerVisible)
                            {
                                var _loc_8:Boolean = true;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = true;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                if (!subLayerInScaleRange(leafLayerLegendInfo))
                                {
                                    if (hostComponent.respectCurrentMapScale)
                                    {
                                        var _loc_8:Boolean = false;
                                        DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                        DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                                    }
                                    else
                                    {
                                        DataGroup(serviceGroup.getElementAt(_loc_7)).alpha = 0.5;
                                    }
                                }
                            }
                            else
                            {
                                var _loc_8:Boolean = false;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).includeInLayout = false;
                                DataGroup(serviceGroup.getElementAt(_loc_7)).visible = _loc_8;
                            }
                        }
                        _loc_7 = _loc_7 + 1;
                    }
                }
                return;
            }// end function
            ;
            var l:Number;
            while (l < this.hostComponent.legendCollection.length)
            {
                
                if (this.hostComponent.legendCollection[l].layer is ArcGISDynamicMapServiceLayer)
                {
                }
                if (ArcGISDynamicMapServiceLayer(this.hostComponent.legendCollection[l].layer).visibleLayers === layer.visibleLayers)
                {
                    dynamicMapServiceLayer = this.hostComponent.legendCollection[l].layer;
                    serviceGroup = this.getServiceGroup(this.hostComponent.legendCollection[l].layer);
                    count;
                    arrLeafLayerLegendInfo;
                    j;
                    while (j < this.hostComponent.legendCollection[l].layerLegendInfos.length)
                    {
                        
                        this.findLeafLayerLegendInfo(LayerLegendInfo(this.hostComponent.legendCollection[l].layerLegendInfos[j]), arrLeafLayerLegendInfo);
                        j = (j + 1);
                    }
                    var _loc_4:int = 0;
                    var _loc_5:* = arrLeafLayerLegendInfo;
                    while (_loc_5 in _loc_4)
                    {
                        
                        leafLayerLegendInfo = _loc_5[_loc_4];
                        this.showHideLayersBasedOnVisibility(this.isSubLayerVisible(leafLayerLegendInfo, dynamicMapServiceLayer, goBackToDeafultVisibility), serviceGroup, this.hostComponent.legendCollection[l].layer, leafLayerLegendInfo, arrLeafLayerLegendInfo.length);
                    }
                    break;
                    continue;
                }
                l = (l + 1);
            }
            this.isLegendShown();
            return;
        }// end function

        private function serviceGroupShowHide(layer:Layer) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = this.getServiceGroup(layer);
            if (layer.visible)
            {
                var _loc_4:Boolean = true;
                _loc_2.includeInLayout = true;
                _loc_2.visible = _loc_4;
                _loc_2.alpha = 1;
                if (!layer.isInScaleRange)
                {
                    if (this.hostComponent.respectCurrentMapScale)
                    {
                        var _loc_4:Boolean = false;
                        _loc_2.includeInLayout = false;
                        _loc_2.visible = _loc_4;
                    }
                    else
                    {
                        _loc_2.alpha = 0.5;
                    }
                }
                else if (layer is ArcGISDynamicMapServiceLayer)
                {
                    this.checkServiceGroupForDynamicMapServiceLayer(this.getLegendCollectionForLayer(layer));
                }
            }
            else
            {
                var _loc_4:Boolean = false;
                _loc_2.includeInLayout = false;
                _loc_2.visible = _loc_4;
            }
            this.isLegendShown();
            return;
        }// end function

        private function getServiceGroup(layer:Layer) : VGroup
        {
            var _loc_2:VGroup = null;
            var _loc_3:int = 0;
            while (_loc_3 < this.vGrp.numElements)
            {
                
                if (this.vGrp.getElementAt(_loc_3) is VGroup)
                {
                }
                if (VGroup(this.vGrp.getElementAt(_loc_3)).name == layer.id)
                {
                    _loc_2 = VGroup(this.vGrp.getElementAt(_loc_3));
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        private function getLegendCollectionForLayer(layer:Layer) : Object
        {
            var _loc_2:Object = null;
            var _loc_3:Number = 0;
            while (_loc_3 < this.hostComponent.legendCollection.length)
            {
                
                if (this.hostComponent.legendCollection[_loc_3].layer === layer)
                {
                    _loc_2 = this.hostComponent.legendCollection[_loc_3];
                    break;
                    continue;
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        private function findLeafLayerLegendInfo(currentLayerLegendInfo:LayerLegendInfo, arrLeafLayerLegendInfo:Array) : void
        {
            var _loc_3:LayerLegendInfo = null;
            if (currentLayerLegendInfo)
            {
                if (currentLayerLegendInfo.layerLegendInfos)
                {
                }
                if (currentLayerLegendInfo.layerLegendInfos.length > 0)
                {
                    for each (_loc_3 in currentLayerLegendInfo.layerLegendInfos)
                    {
                        
                        this.findLeafLayerLegendInfo(_loc_3, arrLeafLayerLegendInfo);
                    }
                }
                else
                {
                    arrLeafLayerLegendInfo.push(currentLayerLegendInfo);
                }
            }
            return;
        }// end function

        private function isLegendShown() : void
        {
            var _loc_3:Boolean = false;
            this.noLegendImage.includeInLayout = false;
            this.noLegendImage.visible = _loc_3;
            var _loc_1:Boolean = true;
            var _loc_2:int = 0;
            while (_loc_2 < this.vGrp.numElements)
            {
                
                if (this.vGrp.getElementAt(_loc_2) is VGroup)
                {
                }
                if (VGroup(this.vGrp.getElementAt(_loc_2)).visible)
                {
                    _loc_1 = false;
                    break;
                    continue;
                }
                _loc_2 = _loc_2 + 1;
            }
            if (_loc_1)
            {
                var _loc_3:Boolean = true;
                this.noLegendImage.includeInLayout = true;
                this.noLegendImage.visible = _loc_3;
            }
            return;
        }// end function

        private function _LegendSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            _loc_1.horizontalAlign = "center";
            return _loc_1;
        }// end function

        private function _LegendSkin_Scroller1_i() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.focusEnabled = false;
            _loc_1.hasFocusableChildren = true;
            _loc_1.viewport = this._LegendSkin_VGroup1_i();
            _loc_1.setStyle("horizontalScrollPolicy", "auto");
            _loc_1.setStyle("verticalScrollPolicy", "auto");
            _loc_1.id = "_LegendSkin_Scroller1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._LegendSkin_Scroller1 = _loc_1;
            BindingManager.executeBindings(this, "_LegendSkin_Scroller1", this._LegendSkin_Scroller1);
            return _loc_1;
        }// end function

        private function _LegendSkin_VGroup1_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.mxmlContent = [];
            _loc_1.id = "_LegendSkin_VGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._LegendSkin_VGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_LegendSkin_VGroup1", this._LegendSkin_VGroup1);
            return _loc_1;
        }// end function

        private function _LegendSkin_HGroup1_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.percentWidth = 100;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._LegendSkin_SWFLoader1_i(), this._LegendSkin_Label1_i()];
            _loc_1.id = "_LegendSkin_HGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._LegendSkin_HGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_LegendSkin_HGroup1", this._LegendSkin_HGroup1);
            return _loc_1;
        }// end function

        private function _LegendSkin_SWFLoader1_i() : SWFLoader
        {
            var _loc_1:* = new SWFLoader();
            _loc_1.id = "_LegendSkin_SWFLoader1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._LegendSkin_SWFLoader1 = _loc_1;
            BindingManager.executeBindings(this, "_LegendSkin_SWFLoader1", this._LegendSkin_SWFLoader1);
            return _loc_1;
        }// end function

        private function _LegendSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.id = "_LegendSkin_Label1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._LegendSkin_Label1 = _loc_1;
            BindingManager.executeBindings(this, "_LegendSkin_Label1", this._LegendSkin_Label1);
            return _loc_1;
        }// end function

        private function _LegendSkin_VGroup2_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.paddingLeft = 5;
            _loc_1.mxmlContent = [this._LegendSkin_BitmapImage1_i()];
            _loc_1.id = "vGrp";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.vGrp = _loc_1;
            BindingManager.executeBindings(this, "vGrp", this.vGrp);
            return _loc_1;
        }// end function

        private function _LegendSkin_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.includeInLayout = false;
            _loc_1.source = this._embed_mxml_____________assets_skins_nolayers_png_2087816685;
            _loc_1.visible = false;
            _loc_1.initialized(this, "noLegendImage");
            this.noLegendImage = _loc_1;
            BindingManager.executeBindings(this, "noLegendImage", this.noLegendImage);
            return _loc_1;
        }// end function

        public function ___LegendSkin_SparkSkin1_initialize(event:FlexEvent) : void
        {
            this.sparkskin1_initializeHandler(event);
            return;
        }// end function

        private function _LegendSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Object
            {
                return loader;
            }// end function
            , null, "_LegendSkin_SWFLoader1.source");
            result[1] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "loadingLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_LegendSkin_Label1.text");
            return result;
        }// end function

        public function get _LegendSkin_Scroller1() : Scroller
        {
            return this._897015999_LegendSkin_Scroller1;
        }// end function

        public function set _LegendSkin_Scroller1(value:Scroller) : void
        {
            var _loc_2:* = this._897015999_LegendSkin_Scroller1;
            if (_loc_2 !== value)
            {
                this._897015999_LegendSkin_Scroller1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_LegendSkin_Scroller1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _LegendSkin_VGroup1() : VGroup
        {
            return this._1636506674_LegendSkin_VGroup1;
        }// end function

        public function set _LegendSkin_VGroup1(value:VGroup) : void
        {
            var _loc_2:* = this._1636506674_LegendSkin_VGroup1;
            if (_loc_2 !== value)
            {
                this._1636506674_LegendSkin_VGroup1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_LegendSkin_VGroup1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get noLegendImage() : BitmapImage
        {
            return this._1952144589noLegendImage;
        }// end function

        public function set noLegendImage(value:BitmapImage) : void
        {
            var _loc_2:* = this._1952144589noLegendImage;
            if (_loc_2 !== value)
            {
                this._1952144589noLegendImage = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "noLegendImage", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get vGrp() : VGroup
        {
            return this._3587215vGrp;
        }// end function

        public function set vGrp(value:VGroup) : void
        {
            var _loc_2:* = this._3587215vGrp;
            if (_loc_2 !== value)
            {
                this._3587215vGrp = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "vGrp", _loc_2, value));
                }
            }
            return;
        }// end function

        private function get loader() : Class
        {
            return this._1097519085loader;
        }// end function

        private function set loader(value:Class) : void
        {
            var _loc_2:* = this._1097519085loader;
            if (_loc_2 !== value)
            {
                this._1097519085loader = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "loader", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : Legend
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:Legend) : void
        {
            var _loc_2:* = this._213507019hostComponent;
            if (_loc_2 !== value)
            {
                this._213507019hostComponent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hostComponent", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            _watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
