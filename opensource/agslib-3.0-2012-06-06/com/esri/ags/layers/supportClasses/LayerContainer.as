package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;

    public class LayerContainer extends UIComponent
    {
        private var m_map:Map;
        private var m_defaultGraphicsLayer:GraphicsLayer;

        public function LayerContainer(map:Map)
        {
            this.m_map = map;
            this.m_defaultGraphicsLayer = new GraphicsLayer();
            this.m_defaultGraphicsLayer.id = "defaultGraphicsLayer";
            this.m_defaultGraphicsLayer.setMap(map);
            addChild(this.m_defaultGraphicsLayer);
            this.m_map.addEventListener(FlexEvent.CREATION_COMPLETE, this.onCreationComplete, false, 1);
            return;
        }// end function

        private function onCreationComplete(event:FlexEvent) : void
        {
            this.m_map.removeEventListener(FlexEvent.CREATION_COMPLETE, this.onCreationComplete);
            this.m_map.addEventListener(ResizeEvent.RESIZE, this.onMapResize);
            scrollRect = new Rectangle(0, 0, this.m_map.width, this.m_map.height);
            width = scrollRect.width;
            height = scrollRect.height;
            return;
        }// end function

        private function onMapResize(event:ResizeEvent) : void
        {
            var _loc_2:* = scrollRect;
            _loc_2.width = this.m_map.width;
            _loc_2.height = this.m_map.height;
            scrollRect = _loc_2;
            width = _loc_2.width;
            height = _loc_2.height;
            return;
        }// end function

        function updateScrollRect(x:Number, y:Number) : void
        {
            var _loc_3:* = scrollRect;
            _loc_3.x = x;
            _loc_3.y = y;
            scrollRect = _loc_3;
            invalidateDisplayList();
            return;
        }// end function

        function updateScrollRectDelta(dx:Number, dy:Number) : void
        {
            var _loc_3:* = scrollRect;
            _loc_3.x = _loc_3.x + dx;
            _loc_3.y = _loc_3.y + dy;
            scrollRect = _loc_3;
            invalidateDisplayList();
            return;
        }// end function

        function get layerIds() : Array
        {
            var _loc_4:Layer = null;
            var _loc_1:Array = [];
            var _loc_2:int = 0;
            var _loc_3:* = numChildren;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = getChildAt(_loc_2) as Layer;
                if (_loc_4)
                {
                }
                if (_loc_4 != this.m_defaultGraphicsLayer)
                {
                    _loc_1.push(_loc_4.id);
                }
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }// end function

        function get layers() : Array
        {
            var _loc_4:Layer = null;
            var _loc_1:Array = [];
            var _loc_2:int = 0;
            var _loc_3:* = numChildren;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = getChildAt(_loc_2) as Layer;
                if (_loc_4)
                {
                }
                if (_loc_4 != this.m_defaultGraphicsLayer)
                {
                    _loc_1.push(_loc_4);
                }
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }// end function

        function get defaultGraphicsLayer() : GraphicsLayer
        {
            return this.m_defaultGraphicsLayer;
        }// end function

        function get map() : Map
        {
            return this.m_map;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (scrollRect)
            {
                graphics.clear();
                graphics.beginFill(16711680, 0);
                graphics.drawRect(scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
                graphics.endFill();
            }
            return;
        }// end function

        function removeLayer(layer:Layer) : void
        {
            if (contains(layer))
            {
                contains(layer);
            }
            if (layer != this.m_defaultGraphicsLayer)
            {
                removeChild(layer);
                this.m_map.dispatchEvent(new MapEvent(MapEvent.LAYER_REMOVE, this.m_map, layer));
            }
            return;
        }// end function

        function removeAllLayers() : void
        {
            var _loc_4:Layer = null;
            var _loc_1:* = this.layers;
            var _loc_2:int = 0;
            var _loc_3:* = _loc_1.length;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = removeChild(_loc_1[_loc_2]) as Layer;
                this.m_map.dispatchEvent(new MapEvent(MapEvent.LAYER_REMOVE, this.m_map, _loc_4));
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

    }
}
