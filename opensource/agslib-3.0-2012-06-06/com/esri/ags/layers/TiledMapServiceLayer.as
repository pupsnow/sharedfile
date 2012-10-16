package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.events.*;
    import mx.logging.*;

    public class TiledMapServiceLayer extends Layer
    {
        private var _log:ILogger;
        private var m_tileIds:Array;
        private var m_tiles:Dictionary;
        private var m_tileBounds:Dictionary;
        private var m_ct:CandidateTileInfo = null;
        private var m_removeStack:Array;
        private var m_loadingStack:Array;
        private var m_lods:Array;
        private var m_tileOrigin:MapPoint;
        private var m_tileW:Number;
        private var m_tileH:Number;
        private var m_scales:Array;
        private var m_levelChange:Boolean;
        private var m_extentChangeExtent:Extent;
        private var m_useDefaultZoomHandlers:Boolean = true;
        private var m_coords_dx:Number;
        private var m_coords_dy:Number;
        private var _hiddenExtent:Extent;
        private var _fireAllComplete:Boolean;
        private var _wrap:Boolean;
        private var _displayLevels:Array;
        private var _fadeInFrameCount:uint = 4;

        public function TiledMapServiceLayer()
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this.m_tileIds = [];
            this.m_tiles = new Dictionary(true);
            this.m_tileBounds = new Dictionary(true);
            this.m_removeStack = [];
            this.m_loadingStack = [];
            mouseChildren = false;
            mouseEnabled = false;
            addEventListener(LayerEvent.LOAD, this.layerLoadHandler);
            return;
        }// end function

        public function get displayLevels() : Array
        {
            return this._displayLevels;
        }// end function

        private function set _2023571247displayLevels(value:Array) : void
        {
            this._displayLevels = value;
            invalidateLayer();
            return;
        }// end function

        public function get fadeInFrameCount() : uint
        {
            return this._fadeInFrameCount;
        }// end function

        public function set fadeInFrameCount(value:uint) : void
        {
            if (value != this._fadeInFrameCount)
            {
                this._fadeInFrameCount = value;
                dispatchEvent(new Event("fadeInFrameCountChanged"));
            }
            return;
        }// end function

        public function get fullExtent() : Extent
        {
            return null;
        }// end function

        public function get tileInfo() : TileInfo
        {
            return null;
        }// end function

        override protected function updateLayer() : void
        {
            if (!this.m_extentChangeExtent)
            {
            }
            this.loadTiles(map.extent, this.m_levelChange);
            this.m_extentChangeExtent = null;
            this.m_levelChange = false;
            return;
        }// end function

        override public function refresh() : void
        {
            super.refresh();
            this.removeAllChildren();
            return;
        }// end function

        override protected function removeAllChildren() : void
        {
            super.removeAllChildren();
            graphics.clear();
            this.m_tileIds = [];
            this.m_tiles = new Dictionary(true);
            this.m_tileBounds = new Dictionary(true);
            this.m_ct = null;
            this.m_loadingStack = [];
            return;
        }// end function

        override protected function addMapListeners() : void
        {
            super.addMapListeners();
            this.addMapPanListeners();
            this.addFrameInfoToTileInfo();
            return;
        }// end function

        override protected function removeMapListeners() : void
        {
            super.removeMapListeners();
            this.removeMapPanListeners();
            return;
        }// end function

        private function layerLoadHandler(event:LayerEvent) : void
        {
            var _loc_5:Coords = null;
            var _loc_6:LOD = null;
            this.m_ct = null;
            var _loc_2:* = this.tileInfo;
            this.m_lods = _loc_2.lods;
            this.m_tileOrigin = new MapPoint(_loc_2.origin.x, _loc_2.origin.y, spatialReference);
            this.m_tileW = _loc_2.width;
            this.m_tileH = _loc_2.height;
            this.m_scales = [];
            var _loc_3:* = new MapPoint(this.fullExtent.xmin, this.fullExtent.ymax);
            var _loc_4:* = new MapPoint(this.fullExtent.xmax, this.fullExtent.ymin);
            var _loc_7:int = 0;
            var _loc_8:* = this.m_lods.length;
            while (_loc_7 < _loc_8)
            {
                
                _loc_6 = this.m_lods[_loc_7];
                this.m_scales[_loc_7] = _loc_6.scale;
                _loc_5 = TileUtils.getContainingTileCoords(_loc_2, _loc_3, _loc_6);
                _loc_6.startTileRow = _loc_5.row < 0 ? (0) : (_loc_5.row);
                _loc_6.startTileCol = _loc_5.col < 0 ? (0) : (_loc_5.col);
                _loc_5 = TileUtils.getContainingTileCoords(_loc_2, _loc_4, _loc_6);
                _loc_6.endTileRow = _loc_5.row;
                _loc_6.endTileCol = _loc_5.col;
                _loc_7 = _loc_7 + 1;
            }
            this.addFrameInfoToTileInfo();
            return;
        }// end function

        private function addFrameInfoToTileInfo() : void
        {
            var _loc_1:TileInfo = null;
            var _loc_2:SpatialReference = null;
            if (map)
            {
                _loc_1 = this.tileInfo;
                if (_loc_1)
                {
                }
                if (_loc_1.spatialReference)
                {
                    _loc_2 = _loc_1.spatialReference;
                    if (map.wrapAround180)
                    {
                    }
                    this._wrap = _loc_2.isWrappable();
                    if (this._wrap)
                    {
                        TileUtils.addFrameInfo(_loc_1, _loc_2.info);
                    }
                }
            }
            return;
        }// end function

        private function addMapPanListeners() : void
        {
            if (map)
            {
                map.addEventListener(PanEvent.PAN_UPDATE, this.onPanHandler, false, 0, true);
            }
            return;
        }// end function

        private function removeMapPanListeners() : void
        {
            if (map)
            {
                map.removeEventListener(PanEvent.PAN_UPDATE, this.onPanHandler);
            }
            return;
        }// end function

        private function loadTiles(extent:Extent, levelChange:Boolean = false, lod:LOD = null) : void
        {
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            var _loc_6:Number = NaN;
            var _loc_7:CandidateTileInfo = null;
            var _loc_8:Rectangle = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:String = null;
            var _loc_12:ImageLoader = null;
            var _loc_13:int = 0;
            var _loc_14:Number = NaN;
            var _loc_15:LOD = null;
            var _loc_16:String = null;
            var _loc_17:ImageLoader = null;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:Rectangle = null;
            if (visible)
            {
            }
            if (loaded)
            {
            }
            if (this.tileInfo)
            {
            }
            if (map)
            {
            }
            if (map.width > 0)
            {
            }
            if (map.height > 0)
            {
                _loc_4 = true;
                if (!visible)
                {
                    _loc_4 = false;
                }
                if (lod)
                {
                    _loc_6 = lod.scale;
                }
                else
                {
                    _loc_14 = map.level;
                    _loc_6 = map.lods ? (map.lods[_loc_14].scale) : (-1);
                }
                _loc_5 = this.m_scales.indexOf(_loc_6) == -1;
                if (!_loc_5)
                {
                }
                if (this.displayLevels)
                {
                    for each (_loc_15 in this.m_lods)
                    {
                        
                        if (_loc_15.scale == _loc_6)
                        {
                            _loc_5 = this.displayLevels.indexOf(_loc_15.level) == -1;
                            break;
                        }
                    }
                }
                if (_loc_4)
                {
                    if (_loc_5)
                    {
                        _loc_4 = false;
                        this.removeAllChildren();
                        this.removeMapPanListeners();
                    }
                    else
                    {
                        this.removeMapPanListeners();
                        this.addMapPanListeners();
                    }
                }
                _loc_7 = TileUtils.getCandidateTileInfo(map, this.tileInfo, extent);
                _loc_8 = parent.scrollRect;
                if (this.m_ct)
                {
                }
                if (_loc_7.lod.level == this.m_ct.lod.level)
                {
                }
                if (levelChange)
                {
                    this.m_ct = _loc_7;
                    this.cleanUpRemovedImages();
                    _loc_18 = 0;
                    _loc_19 = this.m_tileIds.length;
                    while (_loc_18 < _loc_19)
                    {
                        
                        _loc_16 = this.m_tileIds[_loc_18];
                        _loc_17 = this.m_tiles[_loc_16];
                        var _loc_21:String = null;
                        this.m_tileIds[_loc_18] = null;
                        this.m_tileBounds[_loc_16] = _loc_21;
                        this.m_removeStack.push(_loc_17);
                        _loc_18 = _loc_18 + 1;
                    }
                    if (levelChange)
                    {
                        this.m_tileIds = [];
                        this.m_tiles = new Dictionary(true);
                        this.m_tileBounds = new Dictionary(true);
                    }
                }
                _loc_9 = -_loc_8.x;
                _loc_10 = -_loc_8.y;
                if (_loc_4)
                {
                }
                if (!_loc_5)
                {
                    this.m_coords_dx = _loc_9;
                    this.m_coords_dy = _loc_10;
                    this.updateImages(new Rectangle(0, 0, _loc_8.width, _loc_8.height));
                    if (this.m_loadingStack.length === 0)
                    {
                        dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
                    }
                    else
                    {
                        this._fireAllComplete = true;
                    }
                }
                else
                {
                    this.cleanUpRemovedImages();
                }
                _loc_8 = new Rectangle(_loc_8.x, _loc_8.y, _loc_8.width, _loc_8.height);
                _loc_13 = this.m_tileIds.length - 1;
                while (_loc_13 >= 0)
                {
                    
                    _loc_11 = this.m_tileIds[_loc_13];
                    if (_loc_11)
                    {
                        _loc_12 = this.m_tiles[_loc_11];
                        _loc_20 = new Rectangle(_loc_12.x, _loc_12.y, this.m_tileW, this.m_tileH);
                        if (_loc_8.intersects(_loc_20))
                        {
                            this.m_tileBounds[_loc_11] = _loc_20;
                        }
                        else
                        {
                            if (this.m_loadingStack.indexOf(_loc_11) != -1)
                            {
                                this.tilePopPop(_loc_12);
                            }
                            if (_loc_12)
                            {
                            }
                            if (contains(_loc_12))
                            {
                                removeChild(_loc_12);
                                _loc_12.cancel = true;
                            }
                            this.m_tileIds.splice(_loc_13, 1);
                            delete this.m_tileBounds[_loc_11];
                            delete this.m_tiles[_loc_11];
                        }
                    }
                    else
                    {
                        this.m_tileIds.splice(_loc_13, 1);
                        delete this.m_tileBounds[_loc_11];
                        delete this.m_tiles[_loc_11];
                    }
                    _loc_13 = _loc_13 - 1;
                }
            }
            return;
        }// end function

        private function onPanHandler(event:PanEvent) : void
        {
            if (loaded)
            {
            }
            if (!this.m_ct)
            {
                return;
            }
            var _loc_2:* = parent.scrollRect;
            var _loc_3:* = -_loc_2.x;
            var _loc_4:* = -_loc_2.y;
            this.m_coords_dx = _loc_3;
            this.m_coords_dy = _loc_4;
            this.updateImages(new Rectangle(0, 0, _loc_2.width, _loc_2.height));
            return;
        }// end function

        private function updateImages(rect:Rectangle) : void
        {
            var _loc_2:String = null;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_32:Array = null;
            var _loc_33:Number = NaN;
            var _loc_34:Number = NaN;
            var _loc_35:Number = NaN;
            var _loc_37:Number = NaN;
            var _loc_3:* = this.m_ct.lod;
            var _loc_4:* = this.m_ct.tile;
            var _loc_5:* = _loc_4.offsets;
            var _loc_6:* = _loc_4.coords;
            var _loc_7:* = _loc_6.row;
            var _loc_8:* = _loc_6.col;
            var _loc_9:* = _loc_3.level;
            var _loc_10:* = map.id;
            var _loc_11:* = this.id;
            var _loc_12:* = rect.x;
            var _loc_13:* = rect.y;
            var _loc_14:* = _loc_3.startTileRow;
            var _loc_15:* = _loc_3.endTileRow;
            var _loc_16:* = _loc_3.startTileCol;
            var _loc_17:* = _loc_3.endTileCol;
            var _loc_20:* = -rect.x;
            var _loc_21:* = -rect.y;
            var _loc_22:* = _loc_5.x - this.m_coords_dx;
            var _loc_23:* = _loc_5.y - this.m_coords_dy;
            var _loc_24:* = this.m_tileW - _loc_22 + _loc_20;
            var _loc_25:* = this.m_tileH - _loc_23 + _loc_21;
            var _loc_26:* = _loc_24 > 0 ? (_loc_24 % this.m_tileW) : (this.m_tileW - Math.abs(_loc_24) % this.m_tileW);
            var _loc_27:* = _loc_25 > 0 ? (_loc_25 % this.m_tileH) : (this.m_tileH - Math.abs(_loc_25) % this.m_tileH);
            var _loc_28:* = _loc_12 > 0 ? (Math.floor((_loc_12 + _loc_22) / this.m_tileW)) : (Math.ceil((_loc_12 - (this.m_tileW - _loc_22)) / this.m_tileW));
            var _loc_29:* = _loc_13 > 0 ? (Math.floor((_loc_13 + _loc_23) / this.m_tileH)) : (Math.ceil((_loc_13 - (this.m_tileH - _loc_23)) / this.m_tileH));
            var _loc_30:* = _loc_28 + Math.ceil((rect.width - _loc_26) / this.m_tileW);
            var _loc_31:* = _loc_29 + Math.ceil((rect.height - _loc_27) / this.m_tileH);
            if (this._wrap)
            {
                _loc_32 = _loc_3.frameInfo;
                _loc_33 = _loc_32[0];
                _loc_34 = _loc_32[1];
                _loc_35 = _loc_32[2];
            }
            var _loc_36:* = _loc_28;
            while (_loc_36 <= _loc_30)
            {
                
                _loc_37 = _loc_29;
                while (_loc_37 <= _loc_31)
                {
                    
                    _loc_18 = _loc_7 + _loc_37;
                    _loc_19 = _loc_8 + _loc_36;
                    if (this._wrap)
                    {
                        if (_loc_19 < _loc_34)
                        {
                            _loc_19 = _loc_19 % _loc_33;
                            _loc_19 = _loc_19 < _loc_34 ? (_loc_19 + _loc_33) : (_loc_19);
                        }
                        else if (_loc_19 > _loc_35)
                        {
                            _loc_19 = _loc_19 % _loc_33;
                        }
                    }
                    if (_loc_18 >= _loc_14)
                    {
                    }
                    if (_loc_18 <= _loc_15)
                    {
                    }
                    if (_loc_19 >= _loc_16)
                    {
                    }
                    if (_loc_19 <= _loc_17)
                    {
                        _loc_2 = _loc_10 + "_" + _loc_11 + "_tile_" + _loc_9 + "_" + _loc_37 + "_" + _loc_36;
                        if (this.m_tileIds.indexOf(_loc_2) === -1)
                        {
                            this.m_loadingStack.push(_loc_2);
                            this.m_tileIds.push(_loc_2);
                            this.addImage(_loc_9, _loc_37, _loc_18, _loc_36, _loc_19, _loc_2, this.m_tileW, this.m_tileH, _loc_5);
                        }
                    }
                    _loc_37 = _loc_37 + 1;
                }
                _loc_36 = _loc_36 + 1;
            }
            return;
        }// end function

        private function cleanUpRemovedImages() : void
        {
            var _loc_1:ImageLoader = null;
            while (this.m_removeStack.length > 0)
            {
                
                _loc_1 = this.m_removeStack.pop();
                if (_loc_1)
                {
                }
                if (contains(_loc_1))
                {
                    removeChild(_loc_1);
                    _loc_1.cancel = true;
                }
            }
            return;
        }// end function

        private function addImage(level:Number, row:Number, r:Number, col:Number, c:Number, id:String, tileW:Number, tileH:Number, offsets:MapPoint) : void
        {
            var _loc_10:* = new ImageLoader();
            this.m_tiles[id] = _loc_10;
            _loc_10.id = id;
            _loc_10.x = tileW * col - offsets.x;
            _loc_10.y = tileH * row - offsets.y;
            _loc_10.fadeInFrameCount = this.fadeInFrameCount;
            _loc_10.addEventListener(Event.COMPLETE, this.onImageComplete, false, 0, true);
            _loc_10.addEventListener(IOErrorEvent.IO_ERROR, this.onImageIOError, false, 0, true);
            var _loc_11:* = this.getTileURL(level, r, c);
            if (_loc_11.url.indexOf("data://") === 0)
            {
                _loc_10.loadBytes(_loc_11.data as ByteArray);
            }
            else
            {
                _loc_10.load(_loc_11);
            }
            addChild(_loc_10);
            return;
        }// end function

        protected function getTileURL(level:Number, row:Number, col:Number) : URLRequest
        {
            return null;
        }// end function

        private function onImageComplete(event:Event) : void
        {
            var _loc_2:* = ImageLoader(event.target);
            this.tilePopPop(_loc_2);
            if (hasEventListener(event.type))
            {
                dispatchEvent(event);
            }
            return;
        }// end function

        private function onImageIOError(event:IOErrorEvent) : void
        {
            var _loc_2:* = ImageLoader(event.target);
            this.tilePopPop(_loc_2);
            if (Log.isError())
            {
                this._log.error("{0}::{1}", id, event.text);
            }
            if (hasEventListener(event.type))
            {
                dispatchEvent(event);
            }
            return;
        }// end function

        private function tilePopPop(img:ImageLoader) : void
        {
            var _loc_2:* = this.m_loadingStack.indexOf(img.id);
            if (_loc_2 != -1)
            {
                this.m_loadingStack.splice(_loc_2, 1);
            }
            img.removeEventListener(Event.COMPLETE, this.onImageComplete);
            img.removeEventListener(IOErrorEvent.IO_ERROR, this.onImageIOError);
            if (this.m_loadingStack.length === 0)
            {
                graphics.clear();
                this.cleanUpRemovedImages();
                if (this._fireAllComplete)
                {
                    this._fireAllComplete = false;
                    dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
                }
            }
            return;
        }// end function

        override protected function removedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                this.removeMapListeners();
                this.removeAllChildren();
            }
            return;
        }// end function

        override protected function extentChangeHandler(event:ExtentEvent) : void
        {
            super.extentChangeHandler(event);
            if (visible)
            {
            }
            if (parent)
            {
            }
            if (isInScaleRange)
            {
                this.m_extentChangeExtent = event.extent;
                this.m_levelChange = event.levelChange;
            }
            return;
        }// end function

        override protected function hideHandler(event:FlexEvent) : void
        {
            super.hideHandler(event);
            if (map)
            {
                this._hiddenExtent = map.extent.duplicate();
            }
            else
            {
                this._hiddenExtent = null;
            }
            return;
        }// end function

        override protected function showHandler(event:FlexEvent) : void
        {
            super.showHandler(event);
            if (map)
            {
            }
            if (map.extent)
            {
            }
            if (this._hiddenExtent)
            {
            }
            if (!map.extent.equalsExtent(this._hiddenExtent))
            {
                this.removeAllChildren();
            }
            return;
        }// end function

        override protected function zoomStartHandler(event:ZoomEvent) : void
        {
            var event:* = event;
            if (this.m_useDefaultZoomHandlers)
            {
                try
                {
                    super.zoomStartHandler(event);
                    this.removeAllChildren();
                }
                catch (error:SecurityError)
                {
                    m_useDefaultZoomHandlers = false;
                }
            }
            return;
        }// end function

        override protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            var _loc_2:String = null;
            var _loc_3:Rectangle = null;
            var _loc_4:ImageLoader = null;
            var _loc_5:Rectangle = null;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            if (this.m_useDefaultZoomHandlers)
            {
                super.zoomUpdateHandler(event);
            }
            else
            {
                _loc_5 = map.layerContainer.scrollRect;
                _loc_6 = Math.ceil(this.m_tileW * event.zoomFactor);
                _loc_7 = Math.ceil(this.m_tileH * event.zoomFactor);
                _loc_8 = event.width / map.width;
                _loc_9 = event.height / map.height;
                _loc_11 = this.m_tileIds.length;
                while (_loc_10 < _loc_11)
                {
                    
                    _loc_2 = this.m_tileIds[_loc_10];
                    _loc_3 = this.m_tileBounds[_loc_2];
                    _loc_4 = this.m_tiles[_loc_2];
                    _loc_4.x = event.x + (_loc_3.x - _loc_5.x) * _loc_8 + _loc_5.x;
                    _loc_4.y = event.y + (_loc_3.y - _loc_5.y) * _loc_9 + _loc_5.y;
                    _loc_4.width = _loc_6;
                    _loc_4.height = _loc_7;
                    _loc_10 = _loc_10 + 1;
                }
            }
            return;
        }// end function

        override protected function zoomEndHandler(event:ZoomEvent) : void
        {
            super.zoomEndHandler(event);
            this.m_useDefaultZoomHandlers = true;
            return;
        }// end function

        public function set displayLevels(value:Array) : void
        {
            arguments = this.displayLevels;
            if (arguments !== value)
            {
                this._2023571247displayLevels = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "displayLevels", arguments, value));
                }
            }
            return;
        }// end function

    }
}
