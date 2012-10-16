package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import flash.events.*;
    import mx.collections.*;
    import mx.events.*;
    import mx.rpc.*;
    import spark.components.supportClasses.*;

    public class Legend extends SkinnableComponent
    {
        private var _layers:Array;
        private var _map:Map;
        private var _respectCurrentMapScale:Boolean = true;
        private var _layersChanged:Boolean;
        private var _mapChanged:Boolean;
        private var _respectCurrentMapScaleChanged:Boolean;
        private var _legendLayers:Array;
        private var _loadedLegendLayers:Array;
        private var _legendLayerCountLoad:Number;
        private var _successfullyLoadedLayers:Array;
        private var _loading:Boolean = true;
        private var _legendCollection:Array;

        public function Legend(layers:Array = null, map:Map = null, respectCurrentMapScale:Boolean = true)
        {
            this.layers = layers;
            this.map = map;
            this.respectCurrentMapScale = respectCurrentMapScale;
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

        public function get layers() : Array
        {
            return this._layers;
        }// end function

        private function set _1109732030layers(value:Array) : void
        {
            if (this._layers !== value)
            {
            }
            if (value)
            {
                this._layers = value;
                this._loading = true;
                invalidateSkinState();
                this._layersChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get map() : Map
        {
            return this._map;
        }// end function

        private function set _107868map(value:Map) : void
        {
            if (this._map !== value)
            {
            }
            if (value)
            {
                this._map = value;
                this._loading = true;
                invalidateSkinState();
                this._mapChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get respectCurrentMapScale() : Boolean
        {
            return this._respectCurrentMapScale;
        }// end function

        private function set _844848961respectCurrentMapScale(value:Boolean) : void
        {
            if (this._respectCurrentMapScale !== value)
            {
                this._respectCurrentMapScale = value;
                this._respectCurrentMapScaleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get legendCollection() : Array
        {
            return this._legendCollection;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (enabled === false)
            {
                return "disabled";
            }
            if (this._map === null)
            {
                return "disabled";
            }
            if (this._loading)
            {
                return "loading";
            }
            return "normal";
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Layer = null;
            var _loc_2:String = null;
            var _loc_3:Layer = null;
            super.commitProperties();
            if (!this._layersChanged)
            {
            }
            if (!this._mapChanged)
            {
            }
            if (this._respectCurrentMapScaleChanged)
            {
                this._respectCurrentMapScaleChanged = false;
                if (!this._layersChanged)
                {
                }
                if (this._mapChanged)
                {
                    this._layersChanged = false;
                    this._mapChanged = false;
                    this._legendLayers = [];
                    if (this._layers)
                    {
                        for each (_loc_1 in this._layers)
                        {
                            
                            if (this.isSupportedLayerType(_loc_1))
                            {
                                this._legendLayers.push(_loc_1);
                            }
                        }
                    }
                    else if (this._map)
                    {
                        this._map.removeEventListener(MapEvent.LAYER_ADD, this.onLayerAdd);
                        this._map.removeEventListener(MapEvent.LAYER_REMOVE, this.onLayerRemove);
                        this._map.addEventListener(MapEvent.LAYER_ADD, this.onLayerAdd);
                        this._map.addEventListener(MapEvent.LAYER_REMOVE, this.onLayerRemove);
                        for each (_loc_2 in this._map.layerIds.reverse())
                        {
                            
                            _loc_3 = this._map.getLayer(_loc_2);
                            if (this.isSupportedLayerType(_loc_3))
                            {
                                this._legendLayers.push(_loc_3);
                            }
                        }
                    }
                    if (this._map)
                    {
                        this._map.removeEventListener(MapEvent.LAYER_REORDER, this.onLayerReorder);
                        this._map.removeEventListener(MapEvent.LAYER_REMOVE_ALL, this.onLayerRemoveAll);
                        this._map.addEventListener(MapEvent.LAYER_REORDER, this.onLayerReorder);
                        this._map.addEventListener(MapEvent.LAYER_REMOVE_ALL, this.onLayerRemoveAll);
                    }
                }
                if (this._legendLayers)
                {
                    if (this._map.loaded)
                    {
                        this.createLegend();
                    }
                    else
                    {
                        this._map.addEventListener(MapEvent.LOAD, this.mapLoadHandler);
                    }
                }
            }
            return;
        }// end function

        private function mapLoadHandler(event:MapEvent) : void
        {
            this.createLegend();
            return;
        }// end function

        private function isSupportedLayerType(layer:Layer) : Boolean
        {
            if (layer is ILegendSupport)
            {
                return true;
            }
            return false;
        }// end function

        private function createLegend() : void
        {
            var _loc_1:Layer = null;
            var _loc_2:Layer = null;
            this._loadedLegendLayers = [];
            this._legendLayerCountLoad = 0;
            for each (_loc_1 in this._legendLayers)
            {
                
                if (!_loc_1.loaded)
                {
                }
                if (!_loc_1.loadFault)
                {
                    if (_loc_1 is KMLLayer)
                    {
                        this._loadedLegendLayers.push(_loc_1);
                    }
                    _loc_1.addEventListener(LayerEvent.LOAD, this.layer_loadCompleteHandler);
                    _loc_1.addEventListener(LayerEvent.LOAD_ERROR, this.layer_loadCompleteHandler);
                    continue;
                }
                this._loadedLegendLayers.push(_loc_1);
            }
            this._successfullyLoadedLayers = [];
            if (this._loadedLegendLayers.length == this._legendLayers.length)
            {
                for each (_loc_2 in this._legendLayers)
                {
                    
                    if (_loc_2.loaded)
                    {
                    }
                    if (_loc_2.loadFault)
                    {
                    }
                    if (_loc_2 is KMLLayer)
                    {
                        this._successfullyLoadedLayers.push(_loc_2);
                    }
                }
            }
            this.populateLegendCollection(this._successfullyLoadedLayers);
            return;
        }// end function

        private function layer_loadCompleteHandler(event:LayerEvent) : void
        {
            var _loc_3:Layer = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            invalidateSkinState();
            var _loc_6:String = this;
            var _loc_7:* = this._legendLayerCountLoad + 1;
            _loc_6._legendLayerCountLoad = _loc_7;
            var _loc_2:int = 0;
            while (_loc_2 < this._loadedLegendLayers.length)
            {
                
                if (event.target is KMLLayer)
                {
                }
                if (this._loadedLegendLayers[_loc_2] == event.target)
                {
                    this._loadedLegendLayers.splice(_loc_2, 1);
                }
                _loc_2 = _loc_2 + 1;
            }
            if (this._loadedLegendLayers.length + this._legendLayerCountLoad == this._legendLayers.length)
            {
                this._successfullyLoadedLayers = [];
                for each (_loc_3 in this._legendLayers)
                {
                    
                    if (_loc_3.loaded)
                    {
                    }
                    if (!_loc_3.loadFault)
                    {
                        this._successfullyLoadedLayers.push(_loc_3);
                    }
                }
                if (this._legendCollection)
                {
                }
                if (this._legendCollection.length > 0)
                {
                    _loc_4 = [];
                    _loc_2 = 0;
                    while (_loc_2 < this._legendCollection.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < this._successfullyLoadedLayers.length)
                        {
                            
                            if (this._legendCollection[_loc_2].layer === this._successfullyLoadedLayers[_loc_5])
                            {
                                _loc_4.push(this._successfullyLoadedLayers[_loc_5]);
                                break;
                                continue;
                            }
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    this._successfullyLoadedLayers = _loc_4;
                }
                this.populateLegendCollection(this._successfullyLoadedLayers);
            }
            return;
        }// end function

        private function populateLegendCollection(successfullyLoadedLayers:Array) : void
        {
            var layer:Layer;
            var successfullyLoadedLayers:* = successfullyLoadedLayers;
            this._legendCollection = new Array();
            if (successfullyLoadedLayers.length > 0)
            {
                var getLegendResult:* = function (layerLegendInfos:Array, token:Object = null) : void
            {
                _legendCollection.push({layer:token.layer, title:token.title, layerLegendInfos:layerLegendInfos});
                checkLegendCollection();
                return;
            }// end function
            ;
                var getLegendFault:* = function (fault:Fault, token:Object = null) : void
            {
                _legendCollection.push({layer:token.layer, title:token.title, layerLegendInfos:null});
                checkLegendCollection();
                return;
            }// end function
            ;
                var checkLegendCollection:* = function () : void
            {
                var _loc_1:Array = null;
                var _loc_2:int = 0;
                var _loc_3:int = 0;
                if (_legendCollection.length == successfullyLoadedLayers.length)
                {
                    _loc_1 = [];
                    _loc_2 = 0;
                    while (_loc_2 < successfullyLoadedLayers.length)
                    {
                        
                        _loc_3 = 0;
                        while (_loc_3 < _legendCollection.length)
                        {
                            
                            if (successfullyLoadedLayers[_loc_2] === _legendCollection[_loc_3].layer)
                            {
                                _loc_1.push(_legendCollection[_loc_3]);
                                break;
                                continue;
                            }
                            _loc_3 = _loc_3 + 1;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _loading = false;
                    invalidateSkinState();
                    _legendCollection = _loc_1;
                    dispatchEvent(new Event("legendCollectionReady"));
                }
                return;
            }// end function
            ;
                var _loc_3:int = 0;
                var _loc_4:* = successfullyLoadedLayers;
                while (_loc_4 in _loc_3)
                {
                    
                    layer = _loc_4[_loc_3];
                    if (layer is ILegendSupport)
                    {
                        if (layer is KMLLayer)
                        {
                        }
                        if (!layer.loaded)
                        {
                            this._legendCollection.push({layer:layer, title:layer.name ? (layer.name) : (layer.id), layerLegendInfos:null});
                            continue;
                        }
                        ILegendSupport(layer).getLegendInfos(new AsyncResponder(getLegendResult, getLegendFault, {title:layer.name ? (layer.name) : (layer.id), layer:layer}));
                    }
                }
            }
            else
            {
                callLater(this.changeLoadingState);
            }
            return;
        }// end function

        private function changeLoadingState() : void
        {
            this._loading = false;
            invalidateSkinState();
            dispatchEvent(new Event("legendCollectionReady"));
            return;
        }// end function

        private function onLayerAdd(event:MapEvent) : void
        {
            if (this.isSupportedLayerType(event.layer))
            {
                this._legendLayers.push(event.layer);
                this.createLegend();
            }
            return;
        }// end function

        private function onLayerReorder(event:MapEvent) : void
        {
            var layer:Layer;
            var index:int;
            var i:int;
            var currentLegendIndex:int;
            var currentItem:Object;
            var legendCol:ArrayCollection;
            var newLegendIndex:Number;
            var event:* = event;
            var getCurrentLegendIndex:* = function () : int
            {
                var _loc_1:int = 0;
                i = 0;
                while (i < legendCol.length)
                {
                    
                    if (legendCol.getItemAt(i).layer === layer)
                    {
                        _loc_1 = i;
                        break;
                    }
                    var _loc_3:* = i + 1;
                    i = _loc_3;
                }
                return _loc_1;
            }// end function
            ;
            if (this.isSupportedLayerType(event.layer))
            {
                layer = event.layer;
                index = event.index;
                legendCol = new ArrayCollection(this._legendCollection);
                if (index <= this._map.layerIds.length - legendCol.length)
                {
                    currentLegendIndex = this.getCurrentLegendIndex();
                    currentItem = legendCol.getItemAt(currentLegendIndex);
                    i = currentLegendIndex;
                    while (i < legendCol.length)
                    {
                        
                        if (i == (legendCol.length - 1))
                        {
                            legendCol.setItemAt(currentItem, (legendCol.length - 1));
                        }
                        else
                        {
                            legendCol.setItemAt(legendCol.getItemAt((i + 1)), i);
                        }
                        i = (i + 1);
                    }
                }
                else if (this._map.layerIds.length - legendCol.length < index < (this.map.layerIds.length - 1))
                {
                    currentLegendIndex = this.getCurrentLegendIndex();
                    currentItem = legendCol.getItemAt(currentLegendIndex);
                    newLegendIndex = this._map.layerIds.length - index - 1;
                    if (newLegendIndex < currentLegendIndex)
                    {
                        i = currentLegendIndex;
                        while (newLegendIndex <= i)
                        {
                            
                            if (i == newLegendIndex)
                            {
                                legendCol.setItemAt(currentItem, newLegendIndex);
                            }
                            else
                            {
                                legendCol.setItemAt(legendCol.getItemAt((i - 1)), i);
                            }
                            i = (i - 1);
                        }
                    }
                    else
                    {
                        i = currentLegendIndex;
                        while (i <= newLegendIndex)
                        {
                            
                            if (i == newLegendIndex)
                            {
                                legendCol.setItemAt(currentItem, newLegendIndex);
                            }
                            else
                            {
                                legendCol.setItemAt(legendCol.getItemAt((i + 1)), i);
                            }
                            i = (i + 1);
                        }
                    }
                }
                this._legendCollection = legendCol.source;
                dispatchEvent(new Event("legendCollectionReady"));
            }
            return;
        }// end function

        private function onLayerRemove(event:MapEvent) : void
        {
            var _loc_2:Number = NaN;
            if (this.isSupportedLayerType(event.layer))
            {
                _loc_2 = 0;
                while (_loc_2 < this._legendCollection.length)
                {
                    
                    if (this._legendCollection[_loc_2].layer === event.layer)
                    {
                        this._legendCollection.splice(_loc_2, 1);
                        break;
                        continue;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                dispatchEvent(new Event("legendCollectionReady"));
            }
            return;
        }// end function

        private function onLayerRemoveAll(event:MapEvent) : void
        {
            this._legendCollection = null;
            dispatchEvent(new Event("legendCollectionReady"));
            return;
        }// end function

        public function set layers(value:Array) : void
        {
            arguments = this.layers;
            if (arguments !== value)
            {
                this._1109732030layers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layers", arguments, value));
                }
            }
            return;
        }// end function

        public function set map(value:Map) : void
        {
            arguments = this.map;
            if (arguments !== value)
            {
                this._107868map = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "map", arguments, value));
                }
            }
            return;
        }// end function

        public function set respectCurrentMapScale(value:Boolean) : void
        {
            arguments = this.respectCurrentMapScale;
            if (arguments !== value)
            {
                this._844848961respectCurrentMapScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "respectCurrentMapScale", arguments, value));
                }
            }
            return;
        }// end function

    }
}
