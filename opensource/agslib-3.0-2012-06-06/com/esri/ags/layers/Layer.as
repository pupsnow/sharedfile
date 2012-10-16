package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import mx.rpc.*;

    public class Layer extends UIComponent
    {
        private var _invalidateLayerFlag:Boolean;
        private var _updatePendingFlag:Boolean;
        private var _lastIsInScaleRange:Boolean = true;
        private var _bitmapSize:Rectangle;
        private var _bitmapData:BitmapData;
        private var _drawBitmap:Boolean;
        private var _zoomFactor:Number;
        private var _visible:Boolean = true;
        private var _extent:Extent;
        var isBaseLayer:Boolean;
        private var _loaded:Boolean;
        private var _loadFault:Fault;
        private var _map:Map;
        private var _maxScale:Number = 0;
        private var _maxScaleChanged:Boolean;
        private var _minScale:Number = 0;
        private var _minScaleChanged:Boolean;
        private var _spatialReference:SpatialReference;

        public function Layer()
        {
            this._extent = new Extent(-180, -90, 180, 90, new SpatialReference(4326));
            this._spatialReference = new SpatialReference(4326);
            addEventListener(LayerEvent.LOAD_ERROR, this.loadErrorHandler);
            addEventListener(LayerEvent.UPDATE_END, this.updateEndHandler);
            addEventListener(Event.ADDED, this.addedHandler);
            addEventListener(Event.REMOVED, this.removedHandler);
            addEventListener(FlexEvent.SHOW, this.showHandler);
            addEventListener(FlexEvent.HIDE, this.hideHandler);
            return;
        }// end function

        override public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        override public function set visible(value:Boolean) : void
        {
            if (this._visible != value)
            {
                this._visible = value;
                if (super.visible != value)
                {
                    super.visible = value;
                }
                else
                {
                    dispatchEvent(new FlexEvent(value ? (FlexEvent.SHOW) : (FlexEvent.HIDE)));
                }
                dispatchEvent(new Event("visibleChanged"));
            }
            return;
        }// end function

        override public function set x(value:Number) : void
        {
            return;
        }// end function

        override public function set y(value:Number) : void
        {
            return;
        }// end function

        public function get initialExtent() : Extent
        {
            return this._extent;
        }// end function

        public function get isInScaleRange() : Boolean
        {
            var _loc_2:Number = NaN;
            var _loc_1:Boolean = true;
            if (this.map)
            {
                if (this.maxScale <= 0)
                {
                }
            }
            if (this.minScale > 0)
            {
                _loc_2 = this.map.scale;
                if (this.maxScale > 0)
                {
                }
                if (this.minScale > 0)
                {
                    if (this.maxScale <= _loc_2)
                    {
                    }
                    _loc_1 = _loc_2 <= this.minScale;
                }
                else if (this.maxScale > 0)
                {
                    _loc_1 = this.maxScale <= _loc_2;
                }
                else if (this.minScale > 0)
                {
                    _loc_1 = _loc_2 <= this.minScale;
                }
            }
            return _loc_1;
        }// end function

        public function get loaded() : Boolean
        {
            return this._loaded;
        }// end function

        public function get loadFault() : Fault
        {
            return this._loadFault;
        }// end function

        public function get map() : Map
        {
            return this._map;
        }// end function

        public function get maxScale() : Number
        {
            return this._maxScale;
        }// end function

        public function set maxScale(value:Number) : void
        {
            if (this._maxScale != value)
            {
                this._maxScale = value;
                this._maxScaleChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("maxScaleChanged"));
            }
            return;
        }// end function

        public function get minScale() : Number
        {
            return this._minScale;
        }// end function

        public function set minScale(value:Number) : void
        {
            if (this._minScale != value)
            {
                this._minScale = value;
                this._minScaleChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("minScaleChanged"));
            }
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this._spatialReference;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (!this._maxScaleChanged)
            {
            }
            if (this._minScaleChanged)
            {
                this._maxScaleChanged = false;
                this._minScaleChanged = false;
                this.checkIsInScaleRange();
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            this.updateLayerIfInvalid();
            if (this._drawBitmap)
            {
                this.drawBitmap();
            }
            return;
        }// end function

        private function checkIsInScaleRange() : void
        {
            var _loc_2:LayerEvent = null;
            var _loc_1:* = this.isInScaleRange;
            if (this._lastIsInScaleRange != _loc_1)
            {
                this._lastIsInScaleRange = _loc_1;
                _loc_2 = new LayerEvent(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this);
                _loc_2.isInScaleRange = _loc_1;
                dispatchEvent(_loc_2);
            }
            if (!_loc_1)
            {
                if (super.visible)
                {
                    super.setVisible(false, true);
                }
            }
            else
            {
                if (this.visible)
                {
                }
                if (!super.visible)
                {
                    super.setVisible(true, true);
                }
            }
            return;
        }// end function

        private function updateLayerIfInvalid() : void
        {
            if (this._invalidateLayerFlag)
            {
                this._invalidateLayerFlag = false;
                this.checkIsInScaleRange();
                if (super.visible)
                {
                }
                if (this.loaded)
                {
                }
                if (this.map)
                {
                }
                if (this.map.loaded)
                {
                }
                if (this.map.visible)
                {
                }
                if (this.map.width > 0)
                {
                }
                if (this.map.height > 0)
                {
                    this.width = this.map.width;
                    this.height = this.map.height;
                    if (!this._updatePendingFlag)
                    {
                        this._updatePendingFlag = true;
                        dispatchEvent(new LayerEvent(LayerEvent.UPDATE_START, this));
                    }
                    this.updateLayer();
                }
            }
            return;
        }// end function

        protected function updateLayer() : void
        {
            return;
        }// end function

        private function drawBitmap() : void
        {
            var _loc_1:Matrix = null;
            graphics.clear();
            if (this._bitmapData)
            {
                _loc_1 = new Matrix();
                _loc_1.scale(this._zoomFactor, this._zoomFactor);
                _loc_1.translate(this._bitmapSize.x, this._bitmapSize.y);
                graphics.beginBitmapFill(this._bitmapData, _loc_1, false, false);
                graphics.drawRect(this._bitmapSize.x, this._bitmapSize.y, this._bitmapSize.width, this._bitmapSize.height);
                graphics.endFill();
            }
            return;
        }// end function

        function setMap(map:Map) : void
        {
            this.removeMapListeners();
            this._map = map;
            if (this.visible)
            {
                this.addMapListeners();
                this.invalidateLayer();
            }
            return;
        }// end function

        protected function addMapListeners() : void
        {
            if (this.map)
            {
                this.map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
                this.map.addEventListener(ZoomEvent.ZOOM_START, this.zoomStartHandler);
                this.map.addEventListener(ZoomEvent.ZOOM_UPDATE, this.zoomUpdateHandler);
                this.map.addEventListener(ZoomEvent.ZOOM_END, this.zoomEndHandler);
            }
            return;
        }// end function

        protected function removeMapListeners() : void
        {
            if (this.map)
            {
                this.map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
                this.map.removeEventListener(ZoomEvent.ZOOM_START, this.zoomStartHandler);
                this.map.removeEventListener(ZoomEvent.ZOOM_UPDATE, this.zoomUpdateHandler);
                this.map.removeEventListener(ZoomEvent.ZOOM_END, this.zoomEndHandler);
            }
            return;
        }// end function

        protected function setLoaded(value:Boolean) : void
        {
            if (this._loaded != value)
            {
                this._loaded = value;
                if (this._loaded)
                {
                    if (this._loadFault)
                    {
                        this._loadFault = null;
                        dispatchEvent(new Event("loadFaultChanged"));
                    }
                    this.invalidateLayer();
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD, this));
                }
            }
            return;
        }// end function

        protected function removeAllChildren() : void
        {
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            return;
        }// end function

        public function refresh() : void
        {
            this.invalidateLayer();
            return;
        }// end function

        protected function invalidateLayer() : void
        {
            this._invalidateLayerFlag = true;
            invalidateDisplayList();
            return;
        }// end function

        private function updateBitmapSize(event:ZoomEvent) : void
        {
            if (this._bitmapSize)
            {
                this._zoomFactor = event.zoomFactor;
                this._bitmapSize.width = event.width;
                this._bitmapSize.height = event.height;
                this._bitmapSize.x = this.map.layerContainer.scrollRect.x + event.x;
                this._bitmapSize.y = this.map.layerContainer.scrollRect.y + event.y;
            }
            return;
        }// end function

        protected function toScreenX(mapX:Number) : Number
        {
            return this.map.mapToContainerX(mapX);
        }// end function

        protected function toScreenY(mapY:Number) : Number
        {
            return this.map.mapToContainerY(mapY);
        }// end function

        private function loadErrorHandler(event:LayerEvent) : void
        {
            this._loadFault = event.fault;
            dispatchEvent(new Event("loadFaultChanged"));
            return;
        }// end function

        private function updateEndHandler(event:LayerEvent) : void
        {
            this._updatePendingFlag = false;
            return;
        }// end function

        protected function addedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                if (this._drawBitmap)
                {
                    graphics.clear();
                    this._drawBitmap = false;
                    this._bitmapSize = null;
                    this._bitmapData = null;
                }
                this.addMapListeners();
            }
            return;
        }// end function

        protected function removedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                this.removeMapListeners();
            }
            return;
        }// end function

        protected function showHandler(event:FlexEvent) : void
        {
            if (this._drawBitmap)
            {
                graphics.clear();
                this._drawBitmap = false;
                this._bitmapSize = null;
                this._bitmapData = null;
            }
            this.addMapListeners();
            this.invalidateLayer();
            return;
        }// end function

        protected function hideHandler(event:FlexEvent) : void
        {
            this.removeMapListeners();
            return;
        }// end function

        protected function extentChangeHandler(event:ExtentEvent) : void
        {
            this.invalidateLayer();
            return;
        }// end function

        protected function zoomStartHandler(event:ZoomEvent) : void
        {
            var matrix:Matrix;
            var event:* = event;
            if (this.map)
            {
            }
            if (this.map.layerContainer)
            {
                matrix = new Matrix();
                matrix.translate(-this.map.layerContainer.scrollRect.x, -this.map.layerContainer.scrollRect.y);
                try
                {
                    this._bitmapData = new BitmapData(width, height, true, 0);
                    this._bitmapData.draw(this, matrix);
                }
                catch (error:SecurityError)
                {
                    _bitmapData = null;
                    throw error;
                    ;
                }
                catch (error:Error)
                {
                    _bitmapData = null;
                }
                this._zoomFactor = event.zoomFactor;
                this._bitmapSize = new Rectangle(this.map.layerContainer.scrollRect.x, this.map.layerContainer.scrollRect.y, width, height);
                this._drawBitmap = true;
                invalidateDisplayList();
            }
            return;
        }// end function

        protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            this.updateBitmapSize(event);
            invalidateDisplayList();
            return;
        }// end function

        protected function zoomEndHandler(event:ZoomEvent) : void
        {
            this.updateBitmapSize(event);
            this.drawBitmap();
            this._drawBitmap = false;
            this._bitmapSize = null;
            this._bitmapData = null;
            return;
        }// end function

    }
}
