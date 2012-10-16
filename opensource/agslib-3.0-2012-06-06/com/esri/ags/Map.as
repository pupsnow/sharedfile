package com.esri.ags
{
    import Map.as$423.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.handlers.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.ui.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.utils.*;
    import spark.components.*;

    public class Map extends UIComponent
    {
        protected var m_drawLayer:FlexShape;
        protected var m_keyboardHandler:KeyboardHandler;
        protected var m_layerHolder:UIComponent;
        protected var m_infoWindowRendererHandler:InfoWindowRendererHandler;
        protected var m_mouseHandler:MouseHandler;
        protected var m_resizeHandler:ResizeHandler;
        var extentExpanded:Extent;
        var mapMouseClickTolerance:uint = 3;
        var animateExtent:Boolean = false;
        var baseLayer:Layer;
        var isPanning:Boolean = false;
        var isResizing:Boolean = false;
        var isTweening:Boolean = false;
        var m_endExtent:Extent;
        var m_oldExtent:Extent;
        var layerContainer:LayerContainer;
        private var m_baseLayerLoaded:Boolean = false;
        private var m_clickRecenterEnabled:Boolean = true;
        private var m_commitExtentCalled:Boolean;
        private var m_widthAndHeightNotZero:Boolean = false;
        private var m_creationComplete:Boolean = false;
        private var m_crosshairVisible:Boolean = false;
        private var m_doubleClickZoomEnabled:Boolean = true;
        private var m_extent:Extent;
        private var m_extentChanged:Boolean = false;
        private var m_infoWindow:InfoWindow;
        private var m_initialExtent:Extent;
        private var m_keyboardNavigationEnabled:Boolean = true;
        private var m_layers:ArrayCollection;
        private var m_levelChange:Boolean;
        private var m_levelChangeCommitted:Boolean;
        private var m_levelChanged:Boolean;
        private var m_loaded:Boolean = false;
        private var m_lod:LOD;
        private var m_logger:ILogger;
        private var m_mapLoadEventWasDispatched:Boolean = false;
        private var m_menuItem:ContextMenuItem;
        private var m_moveResize:MoveResize;
        private var m_navigation:UIComponent;
        private var m_navigationClass:Class;
        private var m_navigationClassChanged:Boolean = true;
        private var m_stageX:Number;
        private var m_stageY:Number;
        private var m_panEnabled:Boolean = true;
        private var m_ratioH:Number = 1;
        private var m_ratioW:Number = 1;
        private var m_rubberbandZoomEnabled:Boolean = true;
        private var m_scale:Number = 0;
        private var m_scaleBar:UIComponent;
        private var m_scaleBarClass:Class;
        private var m_scaleBarClassChanged:Boolean = true;
        private var m_scaleBarVisible:Boolean = true;
        private var m_scaleBarVisibleChanged:Boolean = true;
        private var m_scaleChangeCommitted:Boolean;
        private var m_scaleChanged:Boolean;
        private var m_staticLayer:StaticLayer;
        private var m_tileInfo:TileInfo;
        private var m_zoomSliderVisible:Boolean = true;
        private var m_zoomSliderVisibleChanged:Boolean = false;
        private var _infoWindowRenderersEnabled:Boolean = true;
        private var m_level:Number = -1;
        private var m_openHandCursorVisible:Boolean;
        private var _panDuration:Number = 300;
        private var m_panEasingFactor:Number = 0.2;
        private var m_spatialReference:SpatialReference;
        private var _timeExtent:TimeExtent;
        private var _timeSlider:ITimeSlider;
        private var _wrapAround180:Boolean = false;
        private var _zoomDuration:Number = 300;
        private static const EXTENT_EXPAND_FACTOR:Number = 1.25;
        private static const FIXED_PAN_FACTOR:Number = 0.25;
        private static const LEVEL_CHANGE_FACTOR:Number = 1000000;
        private static const SCREEN_DPI:Number = 96;
        private static const SPATIAL_REFERENCE_CHANGE:String = "spatialReferenceChange";

        public function Map()
        {
            this.m_scaleBarClass = ScaleBar;
            this.initMap();
            return;
        }// end function

        private function initMap() : void
        {
            var mapContextMenu:String;
            var mapAboutText:String;
            percentWidth = 100;
            percentHeight = 100;
            this.m_mouseHandler = new MouseHandler(this);
            this.m_keyboardHandler = new KeyboardHandler(this);
            this.m_resizeHandler = new ResizeHandler(this);
            this.m_infoWindowRendererHandler = new InfoWindowRendererHandler(this);
            mapContextMenu = resourceManager.getString("ESRIMessages", "mapContextMenu");
            mapAboutText = resourceManager.getString("ESRIMessages", "mapAboutText");
            this.m_menuItem = new ContextMenuItem(mapContextMenu);
            this.m_menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (event:ContextMenuEvent) : void
            {
                var event:* = event;
                var buttonWidth:* = Alert.buttonWidth;
                var yesLabel:* = Alert.yesLabel;
                var noLabel:* = Alert.noLabel;
                Alert.buttonWidth = 100;
                Alert.yesLabel = resourceManager.getString("ESRIMessages", "mapAboutLearnMoreBtn");
                Alert.noLabel = resourceManager.getString("ESRIMessages", "mapAboutCloseBtn");
                Alert.show(mapAboutText, mapContextMenu, Alert.YES | Alert.NO, null, function (event:CloseEvent) : void
                {
                    if (event.detail == Alert.YES)
                    {
                        navigateToURL(new URLRequest("http://links.esri.com/flex-api/"));
                    }
                    return;
                }// end function
                , StaticLayer.m_esriLogo, Alert.NO);
                Alert.buttonWidth = buttonWidth;
                Alert.yesLabel = yesLabel;
                Alert.noLabel = noLabel;
                return;
            }// end function
            );
            contextMenu = new ContextMenu();
            if (contextMenu)
            {
                contextMenu.hideBuiltInItems();
                if (contextMenu.customItems)
                {
                    contextMenu.customItems.push(this.m_menuItem);
                }
            }
            this.m_layerHolder = new UIComponent();
            this.layerContainer = new LayerContainer(this);
            this.m_drawLayer = new FlexShape();
            this.m_staticLayer = new StaticLayer(this);
            addEventListener(ResizeEvent.RESIZE, this.resizeHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            addEventListener(FlexEvent.SHOW, this.showHandler);
            this.m_layerHolder.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            return;
        }// end function

        public function addLayer(layer:Layer, index:int = -1) : String
        {
            if (layer.id == null)
            {
                layer.id = NameUtil.createUniqueName(layer);
            }
            if (index < 0)
            {
                index = this.layerContainer.numChildren - 1;
            }
            else
            {
                index = Math.min(index, (this.layerContainer.numChildren - 1));
            }
            var _loc_3:* = this.layers as ArrayCollection;
            var _loc_4:* = _loc_3.getItemIndex(layer);
            if (_loc_4 != -1)
            {
                _loc_3.removeItemAt(_loc_4);
                if (index > _loc_3.length)
                {
                    index = index - 1;
                }
            }
            _loc_3.addItemAt(layer, index);
            return layer.id;
        }// end function

        public function centerAt(mapPoint:MapPoint) : void
        {
            this.extent = this.m_extent.centerAt(mapPoint);
            return;
        }// end function

        public function get clickRecenterEnabled() : Boolean
        {
            return this.m_clickRecenterEnabled;
        }// end function

        private function set _194628401clickRecenterEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("clickRecenterEnabled:{0}", value);
            }
            this.m_clickRecenterEnabled = value;
            return;
        }// end function

        public function get crosshairVisible() : Boolean
        {
            return this.m_crosshairVisible;
        }// end function

        private function set _1712342512crosshairVisible(value:Boolean) : void
        {
            if (value != this.m_crosshairVisible)
            {
                this.m_crosshairVisible = value;
                this.m_staticLayer.invalidateDisplayList();
            }
            return;
        }// end function

        public function get defaultGraphicsLayer() : GraphicsLayer
        {
            return this.loaded ? (this.layerContainer.defaultGraphicsLayer) : (null);
        }// end function

        public function get doubleClickZoomEnabled() : Boolean
        {
            return this.m_doubleClickZoomEnabled;
        }// end function

        private function set _822359863doubleClickZoomEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("doubleClickZoomEnabled:{0}", value);
            }
            this.m_doubleClickZoomEnabled = value;
            return;
        }// end function

        public function get infoWindowRenderersEnabled() : Boolean
        {
            return this._infoWindowRenderersEnabled;
        }// end function

        private function set _166161553infoWindowRenderersEnabled(value:Boolean) : void
        {
            this._infoWindowRenderersEnabled = value;
            return;
        }// end function

        public function get initialExtent() : Extent
        {
            return this.m_initialExtent;
        }// end function

        private function set _549748850initialExtent(value:Extent) : void
        {
            this.m_initialExtent = value;
            return;
        }// end function

        public function get extent() : Extent
        {
            return this.m_extent;
        }// end function

        public function set extent(value:Extent) : void
        {
            if (this.isPanning)
            {
                this.m_mouseHandler.stopPanning();
            }
            else if (this.isTweening)
            {
                return;
            }
            if (value != null)
            {
                if (this.m_extent)
                {
                }
                if (value)
                {
                }
                if (value.width == 0)
                {
                }
                if (value.height == 0)
                {
                    this.m_extent = this.m_extent.centerAt(new MapPoint(value.xmin, value.ymin, value.spatialReference));
                }
                else
                {
                    this.m_extent = value.duplicate();
                }
                this.m_extentChanged = true;
                invalidateProperties();
                if (this.m_spatialReference)
                {
                    this.m_extent.spatialReference = this.m_spatialReference;
                }
                if (this.loaded)
                {
                    this.m_extent = this.reaspect(this.m_extent);
                }
                this.extentExpanded = this.m_extent.expand(EXTENT_EXPAND_FACTOR);
            }
            return;
        }// end function

        public function getLayer(layerId:String) : Layer
        {
            var _loc_2:Layer = null;
            var _loc_4:Layer = null;
            var _loc_3:* = this.layerContainer.layers;
            for each (_loc_4 in _loc_3)
            {
                
                if (layerId == _loc_4.id)
                {
                    _loc_2 = _loc_4;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function get infoWindow() : InfoWindow
        {
            if (this.m_infoWindow === null)
            {
                this.m_infoWindow = new InfoWindow(this);
                this.m_staticLayer.addElement(this.m_infoWindow);
            }
            return this.m_infoWindow;
        }// end function

        public function get infoWindowContent() : UIComponent
        {
            return this.infoWindow.content;
        }// end function

        private function set _1953433509infoWindowContent(value:UIComponent) : void
        {
            this.infoWindow.content = value;
            this.infoWindow.contentOwner = this;
            return;
        }// end function

        public function get keyboardNavigationEnabled() : Boolean
        {
            return this.m_keyboardNavigationEnabled;
        }// end function

        private function set _1821348198keyboardNavigationEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("keyboardNavigationEnabled:{0}", value);
            }
            this.m_keyboardNavigationEnabled = value;
            if (this.m_keyboardNavigationEnabled)
            {
                this.m_keyboardHandler.enable();
            }
            else
            {
                this.m_keyboardHandler.disable();
            }
            return;
        }// end function

        public function get layerIds() : Array
        {
            return this.layerContainer.layerIds;
        }// end function

        public function get layers() : Object
        {
            if (this.m_layers == null)
            {
                this.m_layers = new ArrayCollection();
                this.m_layers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            return this.m_layers;
        }// end function

        public function set layers(value:Object) : void
        {
            var _loc_3:Array = null;
            if (this.m_layers)
            {
                this.m_layers.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            if (value is Array)
            {
                this.m_layers = new ArrayCollection(value as Array);
            }
            else if (value is ArrayCollection)
            {
                this.m_layers = value as ArrayCollection;
            }
            else
            {
                _loc_3 = [];
                if (value != null)
                {
                    _loc_3.push(value);
                }
                this.m_layers = new ArrayCollection(_loc_3);
            }
            this.m_layers.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            var _loc_2:* = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc_2.kind = CollectionEventKind.RESET;
            this.collectionChangeHandler(_loc_2);
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function get level() : Number
        {
            if (!this.loaded)
            {
                return this.m_level;
            }
            return this.m_lod ? (this.m_lod.level) : (-1);
        }// end function

        public function set level(value:Number) : void
        {
            this.m_level = value;
            this.m_levelChanged = true;
            invalidateProperties();
            if (this.loaded)
            {
                this.commitLevel();
            }
            else
            {
                this.m_levelChangeCommitted = false;
            }
            return;
        }// end function

        public function get loaded() : Boolean
        {
            return this.m_loaded;
        }// end function

        public function get lods() : Array
        {
            return this.m_tileInfo ? (this.m_tileInfo.lods) : (null);
        }// end function

        public function set lods(value:Array) : void
        {
            var newLods:Array;
            var l:LOD;
            var uLods:Array;
            var i:int;
            var lod:LOD;
            var newExtent:Extent;
            var value:* = value;
            var lastLods:* = this.lods;
            if (value)
            {
            }
            if (value.length > 0)
            {
                newLods;
                var _loc_3:int = 0;
                var _loc_4:* = value;
                while (_loc_4 in _loc_3)
                {
                    
                    l = _loc_4[_loc_3];
                    newLods.push(new LOD(l.level, l.resolution, l.scale));
                }
                newLods.sortOn("scale", Array.NUMERIC | Array.DESCENDING);
                uLods;
                i;
                while (i < newLods.length)
                {
                    
                    lod = newLods[i];
                    if (LOD(uLods[(uLods.length - 1)]).scale != lod.scale)
                    {
                        uLods.push(lod);
                    }
                    i = (i + 1);
                }
                newLods = uLods;
                with ({})
                {
                    {}.callback = function (item:LOD, index:int, array:Array) : void
            {
                item.level = index;
                return;
            }// end function
            ;
                }
                newLods.forEach(function (item:LOD, index:int, array:Array) : void
            {
                item.level = index;
                return;
            }// end function
            );
                this.m_tileInfo = new TileInfo();
                this.m_tileInfo.dpi = 96;
                this.m_tileInfo.format = "JPEG";
                this.m_tileInfo.height = 512;
                this.m_tileInfo.width = 512;
                this.m_tileInfo.origin = new MapPoint(-180, 90);
                this.m_tileInfo.spatialReference = new SpatialReference(4326);
                this.m_tileInfo.lods = newLods;
                if (this.spatialReference)
                {
                    TileUtils.addFrameInfo(this.m_tileInfo, this.spatialReference.info);
                }
                if (this.loaded)
                {
                    if (!lastLods)
                    {
                        this.scale = this.scale;
                    }
                    else
                    {
                        newExtent = this.getAdjustedExtent(this.extent).extent;
                        if (!newExtent.equalsExtent(this.extent))
                        {
                            this.extent = newExtent;
                        }
                    }
                }
            }
            else
            {
                this.m_tileInfo = null;
                this.m_lod = null;
            }
            dispatchEvent(new Event("lodsChange"));
            return;
        }// end function

        function get currentLOD() : LOD
        {
            return this.m_lod;
        }// end function

        public function get logoVisible() : Boolean
        {
            return this.m_staticLayer.logoVisible;
        }// end function

        private function set _309781433logoVisible(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("logoVisible::{0}", value);
            }
            this.m_staticLayer.logoVisible = value;
            return;
        }// end function

        public function get mapNavigationEnabled() : Boolean
        {
            if (this.doubleClickZoomEnabled)
            {
            }
            if (this.clickRecenterEnabled)
            {
            }
            if (this.panEnabled)
            {
            }
            if (this.rubberbandZoomEnabled)
            {
            }
            if (this.keyboardNavigationEnabled)
            {
            }
            if (this.scrollWheelZoomEnabled)
            {
            }
            return this.multiTouchEnabled;
        }// end function

        private function set _585685137mapNavigationEnabled(value:Boolean) : void
        {
            if (value != this.mapNavigationEnabled)
            {
                if (Log.isDebug())
                {
                    this.logger.debug("mapNavigationEnabled:{0}", value);
                }
                this.doubleClickZoomEnabled = value;
                this.clickRecenterEnabled = value;
                this.panEnabled = value;
                this.rubberbandZoomEnabled = value;
                this.keyboardNavigationEnabled = value;
                this.scrollWheelZoomEnabled = value;
                this.multiTouchEnabled = value;
            }
            return;
        }// end function

        public function get multiTouchEnabled() : Boolean
        {
            return this.m_mouseHandler.multiTouchEnabled;
        }// end function

        private function set _855012645multiTouchEnabled(value:Boolean) : void
        {
            this.m_mouseHandler.multiTouchEnabled = value;
            return;
        }// end function

        public function get navigationClass() : Class
        {
            if (!this.m_navigationClass)
            {
                this.m_navigationClass = Navigation;
            }
            return this.m_navigationClass;
        }// end function

        private function set _993254340navigationClass(value:Class) : void
        {
            if (this.m_navigationClass !== value)
            {
                this.m_navigationClass = value;
                this.m_navigationClassChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get openHandCursorVisible() : Boolean
        {
            return this.m_openHandCursorVisible;
        }// end function

        private function set _1833646819openHandCursorVisible(value:Boolean) : void
        {
            this.m_openHandCursorVisible = value;
            return;
        }// end function

        public function get panArrowsVisible() : Boolean
        {
            return this.m_staticLayer.panArrowsVisible;
        }// end function

        private function set _340931051panArrowsVisible(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("panArrowsVisible:{0}", value);
            }
            this.m_staticLayer.panArrowsVisible = value;
            return;
        }// end function

        public function panDown() : void
        {
            this.fixedPan(0, height * FIXED_PAN_FACTOR);
            return;
        }// end function

        public function get panDuration() : Number
        {
            return this._panDuration;
        }// end function

        private function set _160926383panDuration(value:Number) : void
        {
            if (this._panDuration != value)
            {
                this._panDuration = isNaN(value) ? (1) : (Math.max(1, value));
            }
            return;
        }// end function

        public function get panEasingFactor() : Number
        {
            return this.m_panEasingFactor;
        }// end function

        public function set panEasingFactor(value:Number) : void
        {
            value = Math.min(1, value);
            if (value <= 0)
            {
                value = 0.2;
            }
            if (this.m_panEasingFactor != value)
            {
                this.m_panEasingFactor = value;
                dispatchEvent(new Event("panEasingFactorChanged"));
            }
            return;
        }// end function

        public function get panEnabled() : Boolean
        {
            return this.m_panEnabled;
        }// end function

        private function set _1273432092panEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("panEnabled::{0}", value);
            }
            this.m_panEnabled = value;
            return;
        }// end function

        public function panLeft() : void
        {
            this.fixedPan(width * (-FIXED_PAN_FACTOR), 0);
            return;
        }// end function

        public function panLowerLeft() : void
        {
            this.fixedPan(width * (-FIXED_PAN_FACTOR), height * FIXED_PAN_FACTOR);
            return;
        }// end function

        public function panLowerRight() : void
        {
            this.fixedPan(width * FIXED_PAN_FACTOR, height * FIXED_PAN_FACTOR);
            return;
        }// end function

        public function panRight() : void
        {
            this.fixedPan(width * FIXED_PAN_FACTOR, 0);
            return;
        }// end function

        public function panUp() : void
        {
            this.fixedPan(0, height * (-FIXED_PAN_FACTOR));
            return;
        }// end function

        public function panUpperLeft() : void
        {
            this.fixedPan(width * (-FIXED_PAN_FACTOR), height * (-FIXED_PAN_FACTOR));
            return;
        }// end function

        public function panUpperRight() : void
        {
            this.fixedPan(width * FIXED_PAN_FACTOR, height * (-FIXED_PAN_FACTOR));
            return;
        }// end function

        public function removeAllLayers() : void
        {
            ArrayCollection(this.layers).removeAll();
            return;
        }// end function

        public function removeLayer(layer:Layer) : void
        {
            var _loc_2:* = this.layers as ArrayCollection;
            var _loc_3:* = _loc_2.getItemIndex(layer);
            if (_loc_3 != -1)
            {
                _loc_2.removeItemAt(_loc_3);
            }
            return;
        }// end function

        public function reorderLayer(layerId:String, index:int) : void
        {
            var _loc_4:ArrayCollection = null;
            var _loc_5:int = 0;
            if (index < 0)
            {
                index = 0;
            }
            else if (index > (this.layerContainer.numChildren - 1))
            {
                index = this.layerContainer.numChildren - 1;
            }
            var _loc_3:* = this.getLayer(layerId);
            if (_loc_3)
            {
                _loc_4 = this.layers as ArrayCollection;
                _loc_5 = _loc_4.getItemIndex(_loc_3);
                if (_loc_5 != -1)
                {
                    _loc_4.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
                    _loc_4.removeItemAt(_loc_5);
                    if (index > _loc_4.length)
                    {
                        index = index - 1;
                    }
                    _loc_4.addItemAt(_loc_3, index);
                    this.layerContainer.setChildIndex(_loc_3, index);
                    _loc_4.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
                }
                dispatchEvent(new MapEvent(MapEvent.LAYER_REORDER, this, _loc_3, index));
            }
            return;
        }// end function

        public function get rubberbandZoomEnabled() : Boolean
        {
            return this.m_rubberbandZoomEnabled;
        }// end function

        private function set _18061623rubberbandZoomEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("rubberbandZoomEnabled:{0}", value);
            }
            this.m_rubberbandZoomEnabled = value;
            return;
        }// end function

        public function get scale() : Number
        {
            if (!this.loaded)
            {
                return this.m_scale;
            }
            return this.getScale();
        }// end function

        public function set scale(value:Number) : void
        {
            var _loc_2:LOD = null;
            for each (_loc_2 in this.lods)
            {
                
                if (_loc_2.scale === value)
                {
                    this.level = _loc_2.level;
                    return;
                }
            }
            this.m_scale = value;
            this.m_scaleChanged = true;
            invalidateProperties();
            if (this.loaded)
            {
                this.commitScale();
            }
            else
            {
                this.m_scaleChangeCommitted = false;
            }
            return;
        }// end function

        public function get scaleBarClass() : Class
        {
            return this.m_scaleBarClass;
        }// end function

        private function set _1327016817scaleBarClass(value:Class) : void
        {
            if (this.m_scaleBarClass !== value)
            {
                this.m_scaleBarClass = value;
                this.m_scaleBarClassChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get scaleBarVisible() : Boolean
        {
            return this.m_scaleBarVisible;
        }// end function

        private function set _44748343scaleBarVisible(value:Boolean) : void
        {
            if (this.m_scaleBarVisible !== value)
            {
                this.m_scaleBarVisible = value;
                this.m_scaleBarVisibleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get scrollWheelZoomEnabled() : Boolean
        {
            return this.m_mouseHandler.scrollWheelZoomEnabled;
        }// end function

        private function set _5071488scrollWheelZoomEnabled(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("scrollWheelZoomEnabled::{0}", value);
            }
            this.m_mouseHandler.scrollWheelZoomEnabled = value;
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this.m_spatialReference;
        }// end function

        public function get staticLayer() : Group
        {
            return this.m_staticLayer;
        }// end function

        override public function styleChanged(styleProp:String) : void
        {
            super.styleChanged(styleProp);
            var _loc_2:* = styleProp == "styleName";
            if (!_loc_2)
            {
            }
            if (styleProp != "crosshairLength")
            {
            }
            if (styleProp != "crosshairWidth")
            {
            }
            if (styleProp != "crosshairAlpha")
            {
            }
            if (styleProp == "crosshairColor")
            {
                this.m_staticLayer.invalidateProperties();
                this.m_staticLayer.invalidateDisplayList();
            }
            if (this.panArrowsVisible)
            {
            }
            if (styleProp)
            {
                if (!_loc_2)
                {
                }
                if (styleProp != "panSkinOffset")
                {
                }
            }
            if (styleProp.search(/^pan\S+Skin$/) == 0)
            {
                this.m_staticLayer.hidePanArrows();
                this.m_staticLayer.showPanArrows();
            }
            if (styleProp === "scaleBarStyleName")
            {
            }
            if (this.m_scaleBar)
            {
            }
            if (this.m_scaleBar.visible)
            {
                this.m_scaleBar.styleName = getStyle(styleProp);
            }
            if (styleProp === "navigationStyleName")
            {
            }
            if (this.m_navigation)
            {
            }
            if (this.m_navigation.visible)
            {
                this.m_navigation.styleName = getStyle(styleProp);
            }
            return;
        }// end function

        public function get timeExtent() : TimeExtent
        {
            return this._timeExtent;
        }// end function

        public function set timeExtent(value:TimeExtent) : void
        {
            if (ObjectUtil.compare(this._timeExtent, value) != 0)
            {
                this._timeExtent = value;
                dispatchEvent(new TimeExtentEvent(value));
            }
            else
            {
                this._timeExtent = value;
            }
            return;
        }// end function

        public function get timeSlider() : ITimeSlider
        {
            return this._timeSlider;
        }// end function

        private function set _785623566timeSlider(value:ITimeSlider) : void
        {
            if (this._timeSlider)
            {
                this._timeSlider.removeEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.timerSlider_timeExtentChangeHandler);
            }
            this._timeSlider = value;
            if (this._timeSlider)
            {
                this.timeExtent = this._timeSlider.timeExtent;
                this._timeSlider.addEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.timerSlider_timeExtentChangeHandler);
            }
            return;
        }// end function

        public function toMap(screenPoint:Point) : MapPoint
        {
            var _loc_2:MapPoint = null;
            if (this.loaded)
            {
                _loc_2 = new MapPoint();
                _loc_2.x = this.toMapX(screenPoint.x);
                _loc_2.y = this.toMapY(screenPoint.y);
                _loc_2.spatialReference = this.spatialReference;
            }
            return _loc_2;
        }// end function

        public function toMapFromStage(stageX:Number, stageY:Number) : MapPoint
        {
            var _loc_3:MapPoint = null;
            var _loc_4:Point = null;
            if (this.loaded)
            {
                _loc_3 = new MapPoint();
                _loc_4 = globalToLocal(new Point(stageX, stageY));
                _loc_3.x = this.toMapX(_loc_4.x);
                _loc_3.y = this.toMapY(_loc_4.y);
                _loc_3.spatialReference = this.spatialReference;
            }
            return _loc_3;
        }// end function

        public function toScreen(mapPoint:MapPoint) : Point
        {
            var _loc_2:* = new Point();
            _loc_2.x = this.toScreenX(mapPoint.x);
            _loc_2.y = this.toScreenY(mapPoint.y);
            return _loc_2;
        }// end function

        public function get wrapAround180() : Boolean
        {
            return this._wrapAround180;
        }// end function

        private function set _1009388754wrapAround180(value:Boolean) : void
        {
            if (!this.loaded)
            {
                this._wrapAround180 = value;
            }
            return;
        }// end function

        public function get zoomDuration() : Number
        {
            return this._zoomDuration;
        }// end function

        private function set _739487097zoomDuration(value:Number) : void
        {
            if (this._zoomDuration != value)
            {
                this._zoomDuration = isNaN(value) ? (1) : (Math.max(1, value));
            }
            return;
        }// end function

        public function zoom(factor:Number, focusPoint:MapPoint = null) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_3:* = this.extent;
            if (_loc_3)
            {
            }
            if (isFinite(factor))
            {
                if (this.wrapAround180)
                {
                }
                if (focusPoint)
                {
                    focusPoint = GeomUtils.denormalizePoint(this, focusPoint);
                }
                this.extent = _loc_3.expand(factor);
                if (focusPoint)
                {
                    _loc_3 = this.extent;
                    _loc_4 = this.toScreenX2(focusPoint.x);
                    _loc_5 = this.toScreenY2(focusPoint.y);
                    _loc_6 = this.toScreenX2(_loc_3.xmin);
                    _loc_7 = this.toScreenY2(_loc_3.ymin);
                    _loc_8 = this.toScreenX2(_loc_3.xmax);
                    _loc_9 = this.toScreenY2(_loc_3.ymax);
                    factor = _loc_3.width / this.m_oldExtent.width;
                    _loc_10 = _loc_6 + _loc_4 * factor;
                    _loc_11 = _loc_9 + _loc_5 * factor;
                    _loc_12 = _loc_10 - _loc_4;
                    _loc_13 = _loc_11 - _loc_5;
                    _loc_14 = this.toMapX2(_loc_6 - _loc_12);
                    _loc_15 = this.toMapX2(_loc_8 - _loc_12);
                    _loc_16 = this.toMapY2(_loc_7 - _loc_13);
                    _loc_17 = this.toMapY2(_loc_9 - _loc_13);
                    this.extent = new Extent(_loc_14, _loc_16, _loc_15, _loc_17, this.spatialReference);
                }
            }
            return;
        }// end function

        public function zoomIn() : void
        {
            if (this.level == -1)
            {
                this.extent = this.extent.expand(0.5);
            }
            else
            {
                (this.level + 1);
            }
            return;
        }// end function

        public function zoomOut() : void
        {
            if (this.level >= 1)
            {
                (this.level - 1);
            }
            else if (this.level == -1)
            {
                this.extent = this.extent.expand(2);
            }
            return;
        }// end function

        public function get zoomSliderVisible() : Boolean
        {
            return this.m_zoomSliderVisible;
        }// end function

        private function set _1291871426zoomSliderVisible(value:Boolean) : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("zoomSliderVisible:{0}", value);
            }
            if (this.m_zoomSliderVisible !== value)
            {
                this.m_zoomSliderVisible = value;
                this.m_zoomSliderVisibleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        protected function collectionChangeHandler(event:CollectionEvent) : void
        {
            switch(event.kind)
            {
                case CollectionEventKind.ADD:
                {
                    this.collectionAddHandler(event);
                    break;
                }
                case CollectionEventKind.MOVE:
                {
                    this.collectionMoveHandler(event);
                    break;
                }
                case CollectionEventKind.REFRESH:
                case CollectionEventKind.RESET:
                {
                    this.collectionRefreshAndResetHandler();
                    break;
                }
                case CollectionEventKind.REMOVE:
                {
                    this.collectionRemoveHandler(event);
                    break;
                }
                case CollectionEventKind.REPLACE:
                {
                    this.collectionReplaceHandler(event);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            this.commitScaleBarProperties();
            this.commitNavigationProperties();
            if (this.loaded)
            {
                if (this.m_scaleChanged)
                {
                    this.m_scaleChanged = false;
                    if (!this.m_scaleChangeCommitted)
                    {
                        this.commitScale();
                    }
                }
                if (this.m_levelChanged)
                {
                    this.m_levelChanged = false;
                    if (!this.m_levelChangeCommitted)
                    {
                        this.commitLevel();
                    }
                }
                if (this.m_extentChanged)
                {
                    this.m_extentChanged = false;
                    this.commitExtent();
                }
            }
            return;
        }// end function

        private function commitNavigationProperties() : void
        {
            var _loc_1:String = null;
            if (this.m_navigationClassChanged)
            {
                if (this.m_zoomSliderVisible)
                {
                    this.m_navigationClassChanged = false;
                }
                if (this.m_navigation)
                {
                    this.m_staticLayer.removeElement(this.m_navigation);
                    this.m_navigation = null;
                }
                if (this.m_zoomSliderVisible)
                {
                }
                if (this.navigationClass)
                {
                    this.m_navigation = new this.m_navigationClass();
                    _loc_1 = getStyle("navigationStyleName");
                    if (_loc_1)
                    {
                        this.m_navigation.styleName = _loc_1;
                    }
                    if (this.m_navigation.hasOwnProperty("map"))
                    {
                        this.m_navigation["map"] = this;
                    }
                    this.m_staticLayer.addElement(this.m_navigation);
                }
            }
            if (this.m_zoomSliderVisibleChanged)
            {
                this.m_zoomSliderVisibleChanged = false;
                if (this.m_navigation)
                {
                    var _loc_2:* = this.m_zoomSliderVisible;
                    this.m_navigation.visible = this.m_zoomSliderVisible;
                    this.m_navigation.includeInLayout = _loc_2;
                }
            }
            return;
        }// end function

        private function commitScaleBarProperties() : void
        {
            var _loc_1:String = null;
            if (this.m_scaleBarClassChanged)
            {
                if (this.m_scaleBarVisible)
                {
                    this.m_scaleBarClassChanged = false;
                }
                if (this.m_scaleBar)
                {
                    this.m_staticLayer.removeElement(this.m_scaleBar);
                    this.m_scaleBar = null;
                }
                if (this.m_scaleBarVisible)
                {
                }
                if (this.m_scaleBarClass)
                {
                    this.m_scaleBar = new this.m_scaleBarClass();
                    _loc_1 = getStyle("scaleBarStyleName");
                    if (_loc_1)
                    {
                        this.m_scaleBar.styleName = _loc_1;
                    }
                    if (this.m_scaleBar.hasOwnProperty("map"))
                    {
                        this.m_scaleBar["map"] = this;
                    }
                    this.m_staticLayer.addElement(this.m_scaleBar);
                }
            }
            if (this.m_scaleBarVisibleChanged)
            {
                this.m_scaleBarVisibleChanged = false;
                if (this.m_scaleBar)
                {
                    this.m_scaleBar.visible = this.m_scaleBarVisible;
                }
            }
            return;
        }// end function

        override protected function createChildren() : void
        {
            super.createChildren();
            if (!UIComponentGlobals.designMode)
            {
                this.m_layerHolder.addChild(this.layerContainer);
                addChild(this.m_layerHolder);
                addChild(this.m_drawLayer);
            }
            addChild(this.m_staticLayer);
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            this.m_staticLayer.setActualSize(unscaledWidth, unscaledHeight);
            return;
        }// end function

        function containerToMapX(screenX:Number) : Number
        {
            return this.m_extent.xmin + (screenX - this.layerContainer.scrollRect.x) * this.m_extent.width / width;
        }// end function

        function containerToMapY(screenY:Number) : Number
        {
            return this.m_extent.ymax - (screenY - this.layerContainer.scrollRect.y) * this.m_extent.height / height;
        }// end function

        function dispatchPanEnd(x:Number, y:Number, dispatchExtentChange:Boolean = true) : void
        {
            this.isTweening = false;
            this.isPanning = false;
            this.m_extent = this.m_endExtent;
            this.extentExpanded = this.m_extent.expand(EXTENT_EXPAND_FACTOR);
            this.m_oldExtent = this.m_endExtent;
            dispatchEvent(new PanEvent(PanEvent.PAN_END, this.m_extent, new Point(x, y)));
            if (dispatchExtentChange)
            {
                dispatchEvent(new ExtentEvent(ExtentEvent.EXTENT_CHANGE, this.m_extent, false, this.m_lod));
            }
            return;
        }// end function

        function dispatchPanStart(x:Number, y:Number) : void
        {
            this.isTweening = true;
            this.isPanning = true;
            dispatchEvent(new PanEvent(PanEvent.PAN_START, this.m_oldExtent, new Point(x, y)));
            return;
        }// end function

        function dispatchPanUpdate(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number) : void
        {
            var _loc_5:* = new Point(xTo - xFrom, yTo - yFrom);
            this.m_extent = new Extent(this.m_oldExtent.xmin - _loc_5.x / this.m_ratioW, this.m_oldExtent.ymin + _loc_5.y / this.m_ratioH, this.m_oldExtent.xmin + this.m_oldExtent.width - _loc_5.x / this.m_ratioW, this.m_oldExtent.ymin + this.m_oldExtent.height + _loc_5.y / this.m_ratioH, this.spatialReference);
            dispatchEvent(new Event("extentUpdate"));
            dispatchEvent(new PanEvent(PanEvent.PAN_UPDATE, this.m_extent, _loc_5));
            return;
        }// end function

        function get drawLayer() : FlexShape
        {
            return this.m_drawLayer;
        }// end function

        function get extentChanged() : Boolean
        {
            return this.m_extentChanged;
        }// end function

        function get layerHolder() : UIComponent
        {
            return this.m_layerHolder;
        }// end function

        function get logger() : ILogger
        {
            if (this.m_logger == null)
            {
                this.m_logger = Log.getLogger(getQualifiedClassName(Map).replace(/::/, "."));
            }
            return this.m_logger;
        }// end function

        function mapToContainerX(mapX:Number) : Number
        {
            return (mapX - this.m_oldExtent.xmin) * width / this.m_oldExtent.width + this.layerContainer.scrollRect.x;
        }// end function

        function mapToContainerY(mapY:Number) : Number
        {
            return (this.m_oldExtent.ymax - mapY) * height / this.m_oldExtent.height + this.layerContainer.scrollRect.y;
        }// end function

        function panToXY(pixelX:Number, pixelY:Number) : void
        {
            var _loc_3:* = this.toMapX(pixelX);
            var _loc_4:* = this.toMapY(pixelY);
            this.extent = this.m_extent.centerAtXY(_loc_3, _loc_4);
            return;
        }// end function

        function get scrollRectX() : Number
        {
            return this.layerContainer.scrollRect.x;
        }// end function

        function get scrollRectY() : Number
        {
            return this.layerContainer.scrollRect.y;
        }// end function

        function toMapX(screenX:Number) : Number
        {
            return this.m_extent.xmin + screenX * this.m_extent.width / width;
        }// end function

        function toMapX2(screenX:Number) : Number
        {
            return this.m_oldExtent.xmin + screenX * this.m_oldExtent.width / width;
        }// end function

        function toMapY(screenY:Number) : Number
        {
            return this.m_extent.ymax - screenY * this.m_extent.height / height;
        }// end function

        function toMapY2(screenY:Number) : Number
        {
            return this.m_oldExtent.ymax - screenY * this.m_oldExtent.height / height;
        }// end function

        public function toScreenX(mapX:Number) : Number
        {
            return (mapX - this.m_extent.xmin) * width / this.m_extent.width;
        }// end function

        function toScreenX2(mapX:Number) : Number
        {
            return (mapX - this.m_oldExtent.xmin) * width / this.m_oldExtent.width;
        }// end function

        public function toScreenY(mapY:Number) : Number
        {
            return (this.m_extent.ymax - mapY) * height / this.m_extent.height;
        }// end function

        function toScreenY2(mapY:Number) : Number
        {
            return (this.m_oldExtent.ymax - mapY) * height / this.m_oldExtent.height;
        }// end function

        public function zoomToInitialExtent() : void
        {
            this.extent = this.m_initialExtent;
            return;
        }// end function

        private function addLayer2(layer:Layer, index:int) : void
        {
            if (layer.id == null)
            {
                layer.id = NameUtil.createUniqueName(layer);
            }
            index = Math.min(index, (this.layerContainer.numChildren - 1));
            if (this.layerContainer.contains(layer))
            {
                this.layerContainer.contains(layer);
            }
            if (index == (this.layerContainer.numChildren - 1))
            {
                index = index - 1;
            }
            layer.setMap(this);
            this.layerContainer.addChildAt(layer, index);
            if (this.baseLayer == null)
            {
                this.baseLayer = layer;
                layer.isBaseLayer = true;
                if (this.baseLayer.loaded)
                {
                    this.baseLayerLoadHandler(new LayerEvent(LayerEvent.LOAD, this.baseLayer));
                }
                else
                {
                    layer.addEventListener(LayerEvent.LOAD, this.baseLayerLoadHandler, false, 999);
                }
            }
            dispatchEvent(new MapEvent(MapEvent.LAYER_ADD, this, layer, index));
            return;
        }// end function

        private function baseLayerLoadHandler(event:LayerEvent) : void
        {
            event.layer.removeEventListener(LayerEvent.LOAD, this.baseLayerLoadHandler);
            if (this.extent)
            {
            }
            if (this.extent.spatialReference)
            {
                this.m_spatialReference = this.extent.spatialReference;
            }
            else
            {
                this.m_spatialReference = event.layer.spatialReference;
            }
            dispatchEvent(new Event(SPATIAL_REFERENCE_CHANGE));
            if (this.extent == null)
            {
                this.extent = event.layer.initialExtent;
            }
            if (this.lods)
            {
                if (this.spatialReference)
                {
                    TileUtils.addFrameInfo(this.m_tileInfo, this.spatialReference.info);
                }
            }
            else if (event.layer is TiledMapServiceLayer)
            {
                this.lods = TiledMapServiceLayer(event.layer).tileInfo.lods;
            }
            this.m_baseLayerLoaded = true;
            this.checkIfCompleteAndHasWidthAndHeightAndBaseLayerLoaded();
            return;
        }// end function

        private function calcExtentFromComponent() : Extent
        {
            var _loc_1:* = this.m_oldExtent.width / this.m_moveResize.width;
            var _loc_2:* = this.m_oldExtent.xmin + -this.m_moveResize.x * _loc_1;
            var _loc_3:* = this.m_oldExtent.xmin + (width - this.m_moveResize.x) * _loc_1;
            var _loc_4:* = this.m_oldExtent.height / this.m_moveResize.height;
            var _loc_5:* = this.m_oldExtent.ymin + (this.m_moveResize.height - (height - this.m_moveResize.y)) * _loc_4;
            var _loc_6:* = this.m_oldExtent.ymin + (this.m_moveResize.height - -this.m_moveResize.y) * _loc_4;
            return new Extent(_loc_2, _loc_5, _loc_3, _loc_6, this.spatialReference);
        }// end function

        private function checkIfCompleteAndHasWidthAndHeightAndBaseLayerLoaded() : void
        {
            var _loc_1:SpatialReference = null;
            if (this.m_creationComplete)
            {
            }
            if (this.m_widthAndHeightNotZero)
            {
            }
            if (this.m_baseLayerLoaded)
            {
                this.m_mouseHandler.enable();
                if (this.m_keyboardNavigationEnabled)
                {
                    this.m_keyboardHandler.enable();
                }
                var _loc_2:* = this.reaspect(this.m_extent);
                this.m_oldExtent = this.reaspect(this.m_extent);
                this.extent = _loc_2;
                _loc_1 = this.m_spatialReference;
                if (this.wrapAround180)
                {
                }
                if (_loc_1)
                {
                }
                this.wrapAround180 = _loc_1.isWrappable() ? (true) : (false);
                this.m_loaded = true;
                if (!this.m_mapLoadEventWasDispatched)
                {
                    this.m_mapLoadEventWasDispatched = true;
                    dispatchEvent(new MapEvent(MapEvent.LOAD, this));
                }
            }
            return;
        }// end function

        private function collectionAddHandler(event:CollectionEvent) : void
        {
            var _loc_2:Layer = null;
            for each (_loc_2 in event.items)
            {
                
                this.addLayer2(_loc_2, event.location);
            }
            return;
        }// end function

        private function collectionMoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:Layer = null;
            for each (_loc_2 in event.items)
            {
                
                this.reorderLayer2(_loc_2, event.location);
            }
            return;
        }// end function

        private function collectionRefreshAndResetHandler() : void
        {
            var _loc_1:Layer = null;
            this.removeAllLayers2();
            for each (_loc_1 in this.m_layers)
            {
                
                this.addLayer2(_loc_1, this.layerContainer.numChildren);
            }
            return;
        }// end function

        private function collectionRemoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:Layer = null;
            for each (_loc_2 in event.items)
            {
                
                this.removeLayer2(_loc_2);
            }
            return;
        }// end function

        private function collectionReplaceHandler(event:CollectionEvent) : void
        {
            var _loc_2:* = Layer(PropertyChangeEvent(event.items[0]).newValue);
            this.addLayer2(_loc_2, event.location);
            var _loc_3:* = Layer(PropertyChangeEvent(event.items[0]).oldValue);
            if (_loc_3)
            {
                this.removeLayer2(_loc_3);
            }
            return;
        }// end function

        private function commitExtent() : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            this.m_ratioW = width / this.m_extent.width;
            this.m_ratioH = height / this.m_extent.height;
            this.m_endExtent = this.m_extent.duplicate();
            if (this.m_commitExtentCalled === false)
            {
                this.m_commitExtentCalled = true;
                this.m_oldExtent = this.m_endExtent;
                if (this.m_initialExtent === null)
                {
                    this.m_initialExtent = this.m_extent.duplicate();
                }
            }
            var _loc_1:* = Math.round(this.m_oldExtent.width * LEVEL_CHANGE_FACTOR);
            var _loc_2:* = Math.round(this.m_extent.width * LEVEL_CHANGE_FACTOR);
            var _loc_3:* = Math.round(this.m_oldExtent.height * LEVEL_CHANGE_FACTOR);
            var _loc_4:* = Math.round(this.m_extent.height * LEVEL_CHANGE_FACTOR);
            if (_loc_1 == _loc_2)
            {
            }
            this.m_levelChange = _loc_3 != _loc_4;
            if (this.m_levelChange)
            {
                if (this.animateExtent)
                {
                    this.isTweening = true;
                    this.moveAndResize();
                }
                else
                {
                    this.m_oldExtent = this.m_endExtent;
                    dispatchEvent(new ExtentEvent(ExtentEvent.EXTENT_CHANGE, this.m_extent, this.m_levelChange, this.m_lod));
                }
            }
            else
            {
                if (this.animateExtent)
                {
                    if (!this.m_oldExtent.intersects(this.m_extent))
                    {
                        this.animateExtent = false;
                    }
                }
                if (this.animateExtent)
                {
                    this.isTweening = true;
                    this.panTheMap();
                }
                else
                {
                    _loc_5 = this.toScreenX2(this.m_extent.xmin);
                    _loc_6 = this.toScreenY2(this.m_extent.ymax);
                    this.layerContainer.updateScrollRectDelta(_loc_5, _loc_6);
                    this.m_oldExtent = this.m_endExtent;
                    dispatchEvent(new ExtentEvent(ExtentEvent.EXTENT_CHANGE, this.m_extent, this.m_levelChange, this.m_lod));
                }
            }
            this.animateExtent = true;
            return;
        }// end function

        private function commitLevel() : void
        {
            var _loc_1:MapPoint = null;
            var _loc_2:LOD = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            this.m_levelChangeCommitted = true;
            if (this.lods)
            {
                if (this.m_level >= 0)
                {
                }
                if (this.m_level >= this.lods.length)
                {
                    return;
                }
                _loc_1 = this.extent.center;
                _loc_2 = this.lods[this.m_level];
                _loc_3 = this.width * _loc_2.resolution / 2;
                _loc_4 = this.height * _loc_2.resolution / 2;
                this.extent = new Extent(_loc_1.x - _loc_3, _loc_1.y - _loc_4, _loc_1.x + _loc_3, _loc_1.y + _loc_4, _loc_1.spatialReference);
            }
            return;
        }// end function

        private function commitScale() : void
        {
            this.m_scaleChangeCommitted = true;
            var _loc_1:* = ProjUtils.getExtentWidthForScale(this.m_scale, this.m_extent, width, SCREEN_DPI);
            if (!isNaN(_loc_1))
            {
                this.extent = this.extent.expand(_loc_1 / this.extent.width);
            }
            return;
        }// end function

        private function fixedPan(dx:Number, dy:Number) : void
        {
            this.panToXY(width / 2 + dx, height / 2 + dy);
            return;
        }// end function

        private function getAdjustedExtent(extent:Extent) : CandidateTileInfo
        {
            if (this.m_tileInfo)
            {
                return TileUtils.getCandidateTileInfo(this, this.m_tileInfo, extent);
            }
            return new CandidateTileInfo(null, null, extent);
        }// end function

        private function getScale() : Number
        {
            if (this.m_lod)
            {
                return this.m_lod.scale;
            }
            return ProjUtils.convertExtentToScale(this.extent, width, SCREEN_DPI);
        }// end function

        private function isEventFromInfoContainer(child:DisplayObject) : Boolean
        {
            while (child)
            {
                
                if (child is InfoComponent)
                {
                    return true;
                }
                if (child is Map)
                {
                    return false;
                }
                child = child.parent;
            }
            return false;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this.isEventFromInfoContainer(event.target as DisplayObject))
            {
                return;
            }
            if (hasEventListener(MapMouseEvent.MAP_MOUSE_DOWN))
            {
                this.dispatchMapMouseEvent(MapMouseEvent.MAP_MOUSE_DOWN, event);
            }
            if (event.shiftKey)
            {
                return;
            }
            if (hasEventListener(MapMouseEvent.MAP_CLICK))
            {
                this.m_stageX = event.stageX;
                this.m_stageY = event.stageY;
                addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
                addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            return;
        }// end function

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:* = Math.abs(event.stageX - this.m_stageX);
            var _loc_3:* = Math.abs(event.stageY - this.m_stageY);
            if (_loc_2 < this.mapMouseClickTolerance)
            {
            }
            if (_loc_3 >= this.mapMouseClickTolerance)
            {
                removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
                removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.dispatchMapMouseEvent(MapMouseEvent.MAP_CLICK, event);
            return;
        }// end function

        private function dispatchMapMouseEvent(type:String, event:MouseEvent) : void
        {
            var _loc_3:MapPoint = null;
            _loc_3 = this.toMapFromStage(event.stageX, event.stageY);
            var _loc_4:* = new MapMouseEvent(type, this, _loc_3);
            _loc_4.setMouseEventProperties(event);
            dispatchEvent(_loc_4);
            return;
        }// end function

        private function moveAndResize() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (!this.m_moveResize)
            {
                this.m_moveResize = new MoveResize(this);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_START, this.tweenStartHandler);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_UPDATE, this.tweenUpdateHandler);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_END, this.tweenEndHandler);
            }
            this.m_moveResize.x = 0;
            this.m_moveResize.y = 0;
            this.m_moveResize.width = this.width;
            this.m_moveResize.height = this.height;
            _loc_1 = this.toScreenX2(this.m_endExtent.xmin);
            _loc_2 = this.toScreenX2(this.m_endExtent.xmax);
            _loc_3 = this.toScreenY2(this.m_endExtent.ymin);
            _loc_4 = this.toScreenY2(this.m_endExtent.ymax);
            _loc_5 = (_loc_2 + _loc_1) * 0.5;
            _loc_6 = (_loc_3 + _loc_4) * 0.5;
            this.m_moveResize.widthFrom = this.width;
            this.m_moveResize.heightFrom = this.height;
            this.m_moveResize.widthTo = this.width * this.width / (_loc_2 - _loc_1);
            this.m_moveResize.heightTo = this.height * this.height / (_loc_3 - _loc_4);
            _loc_7 = this.m_moveResize.widthTo / this.m_moveResize.widthFrom;
            var _loc_8:* = (_loc_5 - this.width * 0.5) * _loc_7;
            var _loc_9:* = (_loc_6 - this.height * 0.5) * _loc_7;
            this.m_moveResize.xFrom = 0;
            this.m_moveResize.yFrom = 0;
            this.m_moveResize.xTo = (this.m_moveResize.widthFrom - this.m_moveResize.widthTo) * 0.5 - _loc_8;
            this.m_moveResize.yTo = (this.m_moveResize.heightFrom - this.m_moveResize.heightTo) * 0.5 - _loc_9;
            this.m_moveResize.duration = this.zoomDuration;
            this.m_moveResize.play();
            return;
        }// end function

        private function resizeHandler(event:ResizeEvent) : void
        {
            if (width > 0)
            {
            }
            if (height > 0)
            {
                removeEventListener(ResizeEvent.RESIZE, this.resizeHandler);
                this.m_widthAndHeightNotZero = true;
                this.checkIfCompleteAndHasWidthAndHeightAndBaseLayerLoaded();
            }
            return;
        }// end function

        private function creationCompleteHandler(event:FlexEvent) : void
        {
            this.m_creationComplete = true;
            this.checkIfCompleteAndHasWidthAndHeightAndBaseLayerLoaded();
            return;
        }// end function

        private function panTheMap() : void
        {
            var rect:Rectangle;
            var center:MapPoint;
            var xPixel:Number;
            var yPixel:Number;
            var xFrom:Number;
            var yFrom:Number;
            var xBy:Number;
            var yBy:Number;
            var xTo:Number;
            var yTo:Number;
            var time:int;
            var enterFrameHandler:Function;
            enterFrameHandler = function (event:Event) : void
            {
                var _loc_3:Number = NaN;
                var _loc_4:Number = NaN;
                var _loc_5:Number = NaN;
                var _loc_2:* = getTimer() - time;
                if (_loc_2 >= panDuration)
                {
                    removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                    layerContainer.updateScrollRect(xTo, yTo);
                    dispatchPanEnd(-xBy, -yBy);
                }
                else
                {
                    _loc_3 = _loc_2 / panDuration;
                    _loc_4 = xFrom + xBy * _loc_3;
                    _loc_5 = yFrom + yBy * _loc_3;
                    layerContainer.updateScrollRect(_loc_4, _loc_5);
                    dispatchPanUpdate(_loc_4, _loc_5, xFrom, yFrom);
                }
                return;
            }// end function
            ;
            rect = this.layerContainer.scrollRect;
            center = this.m_extent.center;
            xPixel = this.toScreenX2(center.x);
            yPixel = this.toScreenY2(center.y);
            xFrom = rect.x;
            yFrom = rect.y;
            xBy = xPixel - width * 0.5;
            yBy = yPixel - height * 0.5;
            xTo = xFrom + xBy;
            yTo = yFrom + yBy;
            time = getTimer();
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            this.dispatchPanStart(0, 0);
            this.isPanning = false;
            return;
        }// end function

        private function reaspect(ext:Extent) : Extent
        {
            var _loc_2:* = ext.width;
            var _loc_3:* = ext.height;
            var _loc_4:* = _loc_2 / _loc_3;
            var _loc_5:* = width / height;
            var _loc_6:Number = 0;
            var _loc_7:Number = 0;
            if (width > height)
            {
                if (_loc_2 > _loc_3)
                {
                    if (_loc_5 > _loc_4)
                    {
                        _loc_6 = _loc_3 * _loc_5 - _loc_2;
                    }
                    else
                    {
                        _loc_7 = _loc_2 / _loc_5 - _loc_3;
                    }
                }
                else if (_loc_2 < _loc_3)
                {
                    _loc_6 = _loc_3 * _loc_5 - _loc_2;
                }
                else
                {
                    _loc_6 = _loc_3 * _loc_5 - _loc_2;
                }
            }
            else if (width < height)
            {
                if (_loc_2 > _loc_3)
                {
                    _loc_7 = _loc_2 / _loc_5 - _loc_3;
                }
                else if (_loc_2 < _loc_3)
                {
                    if (_loc_5 > _loc_4)
                    {
                        _loc_6 = _loc_3 * _loc_5 - _loc_2;
                    }
                    else
                    {
                        _loc_7 = _loc_2 / _loc_5 - _loc_3;
                    }
                }
                else
                {
                    _loc_7 = _loc_2 / _loc_5 - _loc_3;
                }
            }
            else if (_loc_2 < _loc_3)
            {
                _loc_6 = _loc_3 - _loc_2;
            }
            else if (_loc_2 > _loc_3)
            {
                _loc_7 = _loc_2 / _loc_5 - _loc_3;
            }
            if (_loc_6)
            {
                ext.xmin = ext.xmin - _loc_6 / 2;
                ext.xmax = ext.xmax + _loc_6 / 2;
            }
            if (_loc_7)
            {
                ext.ymin = ext.ymin - _loc_7 / 2;
                ext.ymax = ext.ymax + _loc_7 / 2;
            }
            var _loc_8:* = this.getAdjustedExtent(ext);
            this.m_lod = _loc_8.lod;
            ext = _loc_8.extent;
            return ext;
        }// end function

        private function refresh() : void
        {
            var _loc_2:Layer = null;
            var _loc_1:* = this.layerContainer.layers;
            for each (_loc_2 in _loc_1)
            {
                
                _loc_2.refresh();
            }
            this.layerContainer.defaultGraphicsLayer.refresh();
            return;
        }// end function

        private function removeAllLayers2() : void
        {
            this.layerContainer.removeAllLayers();
            dispatchEvent(new MapEvent(MapEvent.LAYER_REMOVE_ALL, this));
            return;
        }// end function

        private function removeLayer2(layer:Layer) : void
        {
            this.layerContainer.removeLayer(layer);
            return;
        }// end function

        private function reorderLayer2(layer:Layer, index:int) : void
        {
            if (index >= (this.layerContainer.numChildren - 1))
            {
                index = this.layerContainer.numChildren - 2;
            }
            this.layerContainer.setChildIndex(layer, index);
            dispatchEvent(new MapEvent(MapEvent.LAYER_REORDER, this, layer, index));
            return;
        }// end function

        private function showHandler(event:FlexEvent) : void
        {
            this.refresh();
            return;
        }// end function

        private function timerSlider_timeExtentChangeHandler(event:TimeExtentEvent) : void
        {
            this.timeExtent = event.timeExtent;
            return;
        }// end function

        function pinchEndHandler() : void
        {
            var _loc_1:* = this.m_oldExtent;
            this.m_endExtent = this.reaspect(this.m_extent);
            this.tweenEndHandler(null, false);
            this.m_oldExtent = _loc_1;
            this.animateExtent = false;
            this.extent = this.m_endExtent;
            return;
        }// end function

        function pinchStartHandler() : void
        {
            if (this.isPanning)
            {
                this.m_mouseHandler.stopPanning();
            }
            this.isTweening = true;
            if (!this.m_moveResize)
            {
                this.m_moveResize = new MoveResize(this);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_START, this.tweenStartHandler);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_UPDATE, this.tweenUpdateHandler);
                this.m_moveResize.addEventListener(TweenEvent.TWEEN_END, this.tweenEndHandler);
            }
            this.m_moveResize.x = 0;
            this.m_moveResize.y = 0;
            this.m_moveResize.width = this.width;
            this.m_moveResize.height = this.height;
            this.tweenStartHandler(null);
            return;
        }// end function

        function pinchUpdateHandler(scale:Number, px:Number, py:Number) : void
        {
            var _loc_4:* = (px - this.m_moveResize.x) / this.m_moveResize.width;
            var _loc_5:* = (py - this.m_moveResize.y) / this.m_moveResize.height;
            this.m_moveResize.width = this.m_moveResize.width * scale;
            this.m_moveResize.height = this.m_moveResize.height * scale;
            this.m_moveResize.x = px - this.m_moveResize.width * _loc_4;
            this.m_moveResize.y = py - this.m_moveResize.height * _loc_5;
            this.tweenUpdateHandler(null);
            return;
        }// end function

        private function tweenEndHandler(event:TweenEvent, dispatchExtentChange:Boolean = true) : void
        {
            this.isTweening = false;
            this.m_extent = this.m_endExtent;
            this.extentExpanded = this.m_extent.expand(EXTENT_EXPAND_FACTOR);
            this.m_oldExtent = this.m_endExtent;
            var _loc_3:* = new ZoomEvent(ZoomEvent.ZOOM_END);
            _loc_3.x = this.m_moveResize.x;
            _loc_3.y = this.m_moveResize.y;
            _loc_3.width = this.m_moveResize.width;
            _loc_3.height = this.m_moveResize.height;
            _loc_3.extent = this.m_extent;
            _loc_3.zoomFactor = this.m_moveResize.width / this.width;
            _loc_3.level = this.m_lod ? (this.m_lod.level) : (-1);
            dispatchEvent(_loc_3);
            if (dispatchExtentChange)
            {
                dispatchEvent(new ExtentEvent(ExtentEvent.EXTENT_CHANGE, this.m_extent, this.m_levelChange, this.m_lod));
            }
            return;
        }// end function

        private function tweenStartHandler(event:TweenEvent) : void
        {
            var _loc_2:* = new ZoomEvent(ZoomEvent.ZOOM_START);
            _loc_2.x = this.m_moveResize.x;
            _loc_2.y = this.m_moveResize.y;
            _loc_2.width = this.m_moveResize.width;
            _loc_2.height = this.m_moveResize.height;
            _loc_2.extent = this.m_oldExtent;
            _loc_2.zoomFactor = 1;
            _loc_2.level = this.level;
            this.m_extent = this.m_oldExtent;
            dispatchEvent(new Event("extentUpdate"));
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function tweenUpdateHandler(event:TweenEvent) : void
        {
            var _loc_2:* = new ZoomEvent(ZoomEvent.ZOOM_UPDATE);
            _loc_2.x = this.m_moveResize.x;
            _loc_2.y = this.m_moveResize.y;
            _loc_2.width = this.m_moveResize.width;
            _loc_2.height = this.m_moveResize.height;
            _loc_2.extent = this.calcExtentFromComponent();
            _loc_2.zoomFactor = this.m_moveResize.width / this.width;
            this.m_extent = _loc_2.extent;
            dispatchEvent(new Event("extentUpdate"));
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function set panDuration(value:Number) : void
        {
            arguments = this.panDuration;
            if (arguments !== value)
            {
                this._160926383panDuration = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "panDuration", arguments, value));
                }
            }
            return;
        }// end function

        public function set panEnabled(value:Boolean) : void
        {
            arguments = this.panEnabled;
            if (arguments !== value)
            {
                this._1273432092panEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "panEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set scaleBarClass(value:Class) : void
        {
            arguments = this.scaleBarClass;
            if (arguments !== value)
            {
                this._1327016817scaleBarClass = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scaleBarClass", arguments, value));
                }
            }
            return;
        }// end function

        public function set timeSlider(value:ITimeSlider) : void
        {
            arguments = this.timeSlider;
            if (arguments !== value)
            {
                this._785623566timeSlider = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeSlider", arguments, value));
                }
            }
            return;
        }// end function

        public function set rubberbandZoomEnabled(value:Boolean) : void
        {
            arguments = this.rubberbandZoomEnabled;
            if (arguments !== value)
            {
                this._18061623rubberbandZoomEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rubberbandZoomEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set clickRecenterEnabled(value:Boolean) : void
        {
            arguments = this.clickRecenterEnabled;
            if (arguments !== value)
            {
                this._194628401clickRecenterEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "clickRecenterEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set initialExtent(value:Extent) : void
        {
            arguments = this.initialExtent;
            if (arguments !== value)
            {
                this._549748850initialExtent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "initialExtent", arguments, value));
                }
            }
            return;
        }// end function

        public function set multiTouchEnabled(value:Boolean) : void
        {
            arguments = this.multiTouchEnabled;
            if (arguments !== value)
            {
                this._855012645multiTouchEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "multiTouchEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set mapNavigationEnabled(value:Boolean) : void
        {
            arguments = this.mapNavigationEnabled;
            if (arguments !== value)
            {
                this._585685137mapNavigationEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mapNavigationEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set keyboardNavigationEnabled(value:Boolean) : void
        {
            arguments = this.keyboardNavigationEnabled;
            if (arguments !== value)
            {
                this._1821348198keyboardNavigationEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "keyboardNavigationEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set openHandCursorVisible(value:Boolean) : void
        {
            arguments = this.openHandCursorVisible;
            if (arguments !== value)
            {
                this._1833646819openHandCursorVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "openHandCursorVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set infoWindowContent(value:UIComponent) : void
        {
            arguments = this.infoWindowContent;
            if (arguments !== value)
            {
                this._1953433509infoWindowContent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "infoWindowContent", arguments, value));
                }
            }
            return;
        }// end function

        public function set infoWindowRenderersEnabled(value:Boolean) : void
        {
            arguments = this.infoWindowRenderersEnabled;
            if (arguments !== value)
            {
                this._166161553infoWindowRenderersEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "infoWindowRenderersEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set navigationClass(value:Class) : void
        {
            arguments = this.navigationClass;
            if (arguments !== value)
            {
                this._993254340navigationClass = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "navigationClass", arguments, value));
                }
            }
            return;
        }// end function

        public function set zoomSliderVisible(value:Boolean) : void
        {
            arguments = this.zoomSliderVisible;
            if (arguments !== value)
            {
                this._1291871426zoomSliderVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoomSliderVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set zoomDuration(value:Number) : void
        {
            arguments = this.zoomDuration;
            if (arguments !== value)
            {
                this._739487097zoomDuration = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoomDuration", arguments, value));
                }
            }
            return;
        }// end function

        public function set doubleClickZoomEnabled(value:Boolean) : void
        {
            arguments = this.doubleClickZoomEnabled;
            if (arguments !== value)
            {
                this._822359863doubleClickZoomEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "doubleClickZoomEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set scaleBarVisible(value:Boolean) : void
        {
            arguments = this.scaleBarVisible;
            if (arguments !== value)
            {
                this._44748343scaleBarVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scaleBarVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set wrapAround180(value:Boolean) : void
        {
            arguments = this.wrapAround180;
            if (arguments !== value)
            {
                this._1009388754wrapAround180 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "wrapAround180", arguments, value));
                }
            }
            return;
        }// end function

        public function set crosshairVisible(value:Boolean) : void
        {
            arguments = this.crosshairVisible;
            if (arguments !== value)
            {
                this._1712342512crosshairVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "crosshairVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set logoVisible(value:Boolean) : void
        {
            arguments = this.logoVisible;
            if (arguments !== value)
            {
                this._309781433logoVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "logoVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set scrollWheelZoomEnabled(value:Boolean) : void
        {
            arguments = this.scrollWheelZoomEnabled;
            if (arguments !== value)
            {
                this._5071488scrollWheelZoomEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scrollWheelZoomEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set panArrowsVisible(value:Boolean) : void
        {
            arguments = this.panArrowsVisible;
            if (arguments !== value)
            {
                this._340931051panArrowsVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "panArrowsVisible", arguments, value));
                }
            }
            return;
        }// end function

    }
}
