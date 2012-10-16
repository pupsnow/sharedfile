package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.clusterers.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class GraphicsLayer extends Layer implements ILegendSupport
    {
        private var m_initialExtent:Extent;
        private var m_spatialReference:SpatialReference;
        private var m_graphicProvider:ArrayCollection;
        private var m_symbolChanged:Boolean;
        private var m_clusterer:IClusterer;
        private var m_symbol:Symbol;
        private var m_renderer:IRenderer;
        private var _autoMoveGraphicsToTop:Boolean;
        private var m_infoWindowRenderer:IFactory;

        public function GraphicsLayer()
        {
            addEventListener(FlareMouseEvent.FLARE_CLICK, this.flare_clickHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            return;
        }// end function

        final protected function get $graphicProvider() : ArrayCollection
        {
            if (this.m_graphicProvider === null)
            {
                this.m_graphicProvider = new ArrayCollection();
                this.m_graphicProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            return this.m_graphicProvider;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this.m_initialExtent ? (this.m_initialExtent) : (new Extent(-180, -90, 180, 90, new SpatialReference(4326)));
        }// end function

        public function set initialExtent(value:Extent) : void
        {
            this.m_initialExtent = value;
            return;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this.m_spatialReference ? (this.m_spatialReference) : (new SpatialReference(4326));
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            this.m_spatialReference = value;
            return;
        }// end function

        public function get numGraphics() : int
        {
            return this.m_graphicProvider ? (this.m_graphicProvider.length) : (0);
        }// end function

        public function get graphicProvider() : Object
        {
            return this.$graphicProvider;
        }// end function

        public function set graphicProvider(value:Object) : void
        {
            var _loc_3:Graphic = null;
            var _loc_4:Array = null;
            if (this.m_graphicProvider)
            {
                if (this.m_clusterer)
                {
                    for each (_loc_3 in this.m_graphicProvider)
                    {
                        
                        _loc_3.setGraphicsLayer(null);
                    }
                }
                this.m_graphicProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            if (value is Array)
            {
                this.m_graphicProvider = new ArrayCollection(value as Array);
            }
            else if (value is ArrayCollection)
            {
                this.m_graphicProvider = value as ArrayCollection;
            }
            else
            {
                _loc_4 = [];
                if (value != null)
                {
                    _loc_4.push(value);
                }
                this.m_graphicProvider = new ArrayCollection(_loc_4);
            }
            this.m_graphicProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            var _loc_2:* = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc_2.kind = CollectionEventKind.RESET;
            this.collectionChangeHandler(_loc_2);
            dispatchEvent(new Event("graphicProviderChanged"));
            return;
        }// end function

        public function get symbol() : Symbol
        {
            return this.m_symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            if (this.m_symbol !== value)
            {
                if (this.m_symbol)
                {
                    this.m_symbol.removeEventListener(Event.CHANGE, this.symbol_changeHandler);
                }
                this.m_symbol = value;
                this.m_symbolChanged = true;
                if (this.m_symbol)
                {
                    this.m_symbol.addEventListener(Event.CHANGE, this.symbol_changeHandler, false, 0, true);
                }
                invalidateProperties();
                dispatchEvent(new Event("symbolChanged"));
            }
            return;
        }// end function

        public function get renderer() : IRenderer
        {
            return this.m_renderer;
        }// end function

        public function set renderer(value:IRenderer) : void
        {
            this.m_renderer = value;
            this.m_symbolChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("rendererChanged"));
            return;
        }// end function

        public function get autoMoveGraphicsToTop() : Boolean
        {
            return this._autoMoveGraphicsToTop;
        }// end function

        public function set autoMoveGraphicsToTop(value:Boolean) : void
        {
            this._autoMoveGraphicsToTop = value;
            if (this._autoMoveGraphicsToTop)
            {
                addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            }
            else
            {
                removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            }
            return;
        }// end function

        public function get clusterer() : IClusterer
        {
            return this.m_clusterer;
        }// end function

        private function set _561940519clusterer(value:IClusterer) : void
        {
            if (this.m_clusterer)
            {
                this.m_clusterer.removeEventListener(Event.CHANGE, this.clusterer_changeHandler);
                this.m_clusterer.destroy(this);
            }
            this.m_clusterer = value;
            if (this.m_clusterer)
            {
                this.m_clusterer.addEventListener(Event.CHANGE, this.clusterer_changeHandler);
                this.m_clusterer.initialize(this);
            }
            if (this.m_graphicProvider)
            {
                this.m_graphicProvider.refresh();
            }
            return;
        }// end function

        public function get infoWindowRenderer() : IFactory
        {
            return this.m_infoWindowRenderer;
        }// end function

        public function set infoWindowRenderer(value:IFactory) : void
        {
            this.m_infoWindowRenderer = value;
            return;
        }// end function

        public function add(graphic:Graphic) : String
        {
            if (graphic.id === null)
            {
                graphic.id = NameUtil.createUniqueName(graphic);
            }
            this.$graphicProvider.addItem(graphic);
            if (hasEventListener(GraphicEvent.GRAPHIC_ADD))
            {
                dispatchEvent(new GraphicEvent(GraphicEvent.GRAPHIC_ADD, graphic));
            }
            return graphic.id;
        }// end function

        public function moveToTop(graphic:Graphic) : void
        {
            setChildIndex(graphic, (numChildren - 1));
            return;
        }// end function

        public function remove(graphic:Graphic) : void
        {
            var _loc_2:* = this.$graphicProvider.getItemIndex(graphic);
            if (_loc_2 > -1)
            {
                this.$graphicProvider.removeItemAt(_loc_2);
                if (hasEventListener(GraphicEvent.GRAPHIC_REMOVE))
                {
                    dispatchEvent(new GraphicEvent(GraphicEvent.GRAPHIC_REMOVE, graphic));
                }
            }
            return;
        }// end function

        public function clear() : void
        {
            this.$graphicProvider.removeAll();
            dispatchEvent(new GraphicsLayerEvent(GraphicsLayerEvent.GRAPHICS_CLEAR));
            return;
        }// end function

        public function getLegendInfos(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new AsyncToken();
            if (responder)
            {
                _loc_2.addResponder(responder);
            }
            var _loc_3:* = new Array();
            var _loc_4:* = this.getFeatureResult();
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

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this.m_symbolChanged)
            {
                this.m_symbolChanged = false;
                this.drawGraphicsWithNoSymbol();
            }
            return;
        }// end function

        override protected function updateLayer() : void
        {
            var _loc_1:Array = null;
            var _loc_2:Graphic = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            callLater(this.resetTransformMatrix);
            if (this.m_clusterer)
            {
                this.m_clusterer.removeGraphics(this);
                if (this.m_graphicProvider)
                {
                    _loc_1 = this.m_clusterer.clusterGraphics(this, this.m_graphicProvider);
                    for each (_loc_2 in _loc_1)
                    {
                        
                        addChild(_loc_2);
                    }
                }
            }
            else
            {
                _loc_3 = numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    (getChildAt(_loc_4) as Graphic).invalidateGraphic();
                    _loc_4 = _loc_4 + 1;
                }
            }
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }// end function

        private function renderInfoWindow(event:FlareMouseEvent, infoWindowFactory:IFactory) : void
        {
            var _loc_4:Point = null;
            var _loc_3:* = infoWindowFactory.newInstance();
            if (_loc_3 is IDataRenderer)
            {
                IDataRenderer(_loc_3).data = event.graphic.attributes;
            }
            if ("dataProvider" in _loc_3)
            {
                _loc_3["dataProvider"] = event.graphic.attributes;
            }
            if (_loc_3 is IGraphicRenderer)
            {
                IGraphicRenderer(_loc_3).graphic = event.graphic;
            }
            if (_loc_3 is UIComponent)
            {
                map.infoWindow.data = event.graphic.attributes;
                map.infoWindow.content = UIComponent(_loc_3);
                map.infoWindow.contentOwner = this;
                _loc_4 = new Point(event.stageX, event.stageY);
                map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
                map.infoWindow.show(map.toMapFromStage(event.stageX, event.stageY), _loc_4);
                map.infoWindow.addEventListener(Event.CLOSE, this.infoWindow_closeHandler);
                map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
            }
            return;
        }// end function

        private function drawGraphicsWithNoSymbol() : void
        {
            var _loc_1:Graphic = null;
            if (map)
            {
            }
            if (map.loaded)
            {
            }
            if (!map.isTweening)
            {
            }
            if (!map.isResizing)
            {
                for each (_loc_1 in this.m_graphicProvider)
                {
                    
                    if (_loc_1.symbol === null)
                    {
                    }
                    if (_loc_1.visible)
                    {
                        _loc_1.drawWithSymbol(_loc_1.getActiveSymbol(this), map);
                    }
                }
            }
            return;
        }// end function

        private function resetTransformMatrix() : void
        {
            var _loc_1:* = this.transform.matrix;
            if (_loc_1)
            {
                _loc_1.identity();
            }
            else
            {
                _loc_1 = new Matrix();
            }
            this.transform.matrix = _loc_1;
            return;
        }// end function

        private function getTargetAsGraphic(target:Object) : Graphic
        {
            var _loc_2:* = target as Graphic;
            if (_loc_2)
            {
                return _loc_2;
            }
            if (target.parent)
            {
                return this.getTargetAsGraphic(target.parent);
            }
            return null;
        }// end function

        private function getFeatureResult() : LayerLegendInfo
        {
            var _loc_2:UniqueValueRenderer = null;
            var _loc_3:LegendItemInfo = null;
            var _loc_4:int = 0;
            var _loc_5:LegendItemInfo = null;
            var _loc_6:ClassBreaksRenderer = null;
            var _loc_7:LegendItemInfo = null;
            var _loc_8:int = 0;
            var _loc_9:LegendItemInfo = null;
            var _loc_1:* = new LayerLegendInfo();
            _loc_1.layerId = this.id;
            _loc_1.layerName = this.name ? (this.name) : (this.id);
            _loc_1.minScale = this.minScale;
            _loc_1.maxScale = this.maxScale;
            _loc_1.visible = this.visible;
            _loc_1.legendItemInfos = new Array();
            if (this.renderer)
            {
                if (this.renderer is UniqueValueRenderer)
                {
                    _loc_2 = this.renderer as UniqueValueRenderer;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_2.infos.length)
                    {
                        
                        _loc_3 = new LegendItemInfo();
                        _loc_3.symbol = UniqueValueInfo(_loc_2.infos[_loc_4]).symbol;
                        _loc_3.label = UniqueValueInfo(_loc_2.infos[_loc_4]).label;
                        _loc_1.legendItemInfos.push(_loc_3);
                        _loc_4 = _loc_4 + 1;
                    }
                    if (_loc_2.defaultSymbol)
                    {
                        _loc_3 = new LegendItemInfo();
                        _loc_3.symbol = _loc_2.defaultSymbol;
                        _loc_3.label = _loc_2.defaultLabel;
                        _loc_1.legendItemInfos.push(_loc_3);
                    }
                }
                if (this.renderer is SimpleRenderer)
                {
                    _loc_5 = new LegendItemInfo();
                    _loc_5.label = SimpleRenderer(this.renderer).label;
                    _loc_5.symbol = SimpleRenderer(this.renderer).symbol;
                    _loc_1.legendItemInfos.push(_loc_5);
                }
                if (this.renderer is ClassBreaksRenderer)
                {
                    _loc_6 = this.renderer as ClassBreaksRenderer;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_6.infos.length)
                    {
                        
                        _loc_7 = new LegendItemInfo();
                        _loc_7.symbol = ClassBreakInfo(_loc_6.infos[_loc_8]).symbol;
                        _loc_7.label = ClassBreakInfo(_loc_6.infos[_loc_8]).label;
                        _loc_1.legendItemInfos.push(_loc_7);
                        _loc_8 = _loc_8 + 1;
                    }
                    if (_loc_6.defaultSymbol)
                    {
                        _loc_7 = new LegendItemInfo();
                        _loc_7.symbol = _loc_6.defaultSymbol;
                        _loc_7.label = _loc_6.defaultLabel;
                        _loc_1.legendItemInfos.push(_loc_7);
                    }
                }
            }
            else if (this.symbol)
            {
                _loc_9 = new LegendItemInfo();
                _loc_9.symbol = this.symbol;
                _loc_1.legendItemInfos.push(_loc_9);
            }
            return _loc_1;
        }// end function

        protected function creationCompleteHandler(event:FlexEvent) : void
        {
            removeEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            setLoaded(true);
            return;
        }// end function

        private function flare_clickHandler(event:FlareMouseEvent) : void
        {
            if (event.graphic.infoWindowRenderer)
            {
                this.renderInfoWindow(event, event.graphic.infoWindowRenderer);
            }
            else if (this.infoWindowRenderer)
            {
                this.renderInfoWindow(event, this.infoWindowRenderer);
            }
            return;
        }// end function

        private function clusterer_changeHandler(event:Event) : void
        {
            invalidateLayer();
            return;
        }// end function

        private function infoWindow_closeHandler(event:Event) : void
        {
            map.infoWindow.removeEventListener(Event.CLOSE, this.infoWindow_closeHandler);
            FlareContainer.lastFlareContainer.flareIn();
            return;
        }// end function

        private function map_extentChangeHandler(event:ExtentEvent) : void
        {
            map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
            if (map.infoWindow.contentOwner === this)
            {
                map.infoWindow.hide();
            }
            return;
        }// end function

        protected function collectionChangeHandler(event:CollectionEvent) : void
        {
            var _loc_2:Graphic = null;
            var _loc_3:PropertyChangeEvent = null;
            var _loc_4:Graphic = null;
            var _loc_5:Graphic = null;
            dispatchEvent(event);
            if (this.m_clusterer)
            {
                switch(event.kind)
                {
                    case CollectionEventKind.ADD:
                    {
                        for each (_loc_2 in event.items)
                        {
                            
                            _loc_2.setGraphicsLayer(this);
                        }
                        break;
                    }
                    case CollectionEventKind.REMOVE:
                    {
                        for each (_loc_2 in event.items)
                        {
                            
                            _loc_2.setGraphicsLayer(null);
                        }
                        break;
                    }
                    case CollectionEventKind.REPLACE:
                    {
                        _loc_3 = PropertyChangeEvent(event.items[0]);
                        _loc_4 = _loc_3.newValue as Graphic;
                        _loc_4.setGraphicsLayer(this);
                        _loc_5 = _loc_3.oldValue as Graphic;
                        if (_loc_5)
                        {
                            _loc_5.setGraphicsLayer(null);
                        }
                        break;
                    }
                    case CollectionEventKind.RESET:
                    {
                        for each (_loc_2 in this.m_graphicProvider)
                        {
                            
                            _loc_2.setGraphicsLayer(this);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                invalidateLayer();
            }
            else
            {
                switch(event.kind)
                {
                    case CollectionEventKind.ADD:
                    {
                        this.collectionAddHandler(event);
                        break;
                    }
                    case CollectionEventKind.REMOVE:
                    {
                        this.collectionRemoveHandler(event);
                        break;
                    }
                    case CollectionEventKind.MOVE:
                    {
                        this.collectionMoveHandler(event);
                        break;
                    }
                    case CollectionEventKind.REPLACE:
                    {
                        this.collectionReplaceHandler(event);
                        break;
                    }
                    case CollectionEventKind.REFRESH:
                    case CollectionEventKind.RESET:
                    {
                        this.collectionRefreshOrResetHandler();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function collectionAddHandler(event:CollectionEvent) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in event.items)
            {
                
                addChildAt(_loc_2, event.location);
            }
            return;
        }// end function

        private function collectionMoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in event.items)
            {
                
                setChildIndex(_loc_2, event.location);
            }
            return;
        }// end function

        private function collectionRefreshOrResetHandler() : void
        {
            var _loc_1:Graphic = null;
            removeAllChildren();
            for each (_loc_1 in this.m_graphicProvider)
            {
                
                addChild(_loc_1);
            }
            return;
        }// end function

        private function collectionRemoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in event.items)
            {
                
                removeChild(_loc_2);
            }
            return;
        }// end function

        private function collectionReplaceHandler(event:CollectionEvent) : void
        {
            var _loc_2:PropertyChangeEvent = null;
            _loc_2 = PropertyChangeEvent(event.items[0]);
            var _loc_3:* = _loc_2.newValue as Graphic;
            addChildAt(_loc_3, event.location);
            var _loc_4:* = _loc_2.oldValue as Graphic;
            if (_loc_4)
            {
                removeChild(_loc_4);
            }
            return;
        }// end function

        private function symbol_changeHandler(event:Event) : void
        {
            this.m_symbolChanged = true;
            invalidateProperties();
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            var _loc_2:* = this.getTargetAsGraphic(event.target);
            if (_loc_2)
            {
                this.moveToTop(_loc_2);
            }
            return;
        }// end function

        override protected function zoomStartHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            var _loc_2:* = map.layerContainer ? (map.layerContainer.scrollRect) : (null);
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = event.x + _loc_2.x - _loc_2.x * event.zoomFactor;
            var _loc_4:* = event.y + _loc_2.y - _loc_2.y * event.zoomFactor;
            var _loc_5:* = this.transform.matrix;
            if (_loc_5)
            {
                _loc_5.identity();
            }
            else
            {
                _loc_5 = new Matrix();
            }
            _loc_5.scale(event.zoomFactor, event.zoomFactor);
            _loc_5.translate(_loc_3, _loc_4);
            this.transform.matrix = _loc_5;
            return;
        }// end function

        override protected function zoomEndHandler(event:ZoomEvent) : void
        {
            this.zoomUpdateHandler(event);
            return;
        }// end function

        protected function enterFrameHandler(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
            return;
        }// end function

        public function set clusterer(value:IClusterer) : void
        {
            arguments = this.clusterer;
            if (arguments !== value)
            {
                this._561940519clusterer = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "clusterer", arguments, value));
                }
            }
            return;
        }// end function

    }
}
