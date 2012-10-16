package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import mx.core.*;

    public class InfoSymbol extends Symbol
    {
        private var m_infoPlacement:String;
        private var m_infoRenderer:IFactory;
        public var containerStyleName:String;
        private static const EXTENT:Extent = new Extent();

        public function InfoSymbol()
        {
            this.m_infoRenderer = new ClassFactory(InfoDataList);
            return;
        }// end function

        public function get infoPlacement() : String
        {
            return this.m_infoPlacement;
        }// end function

        public function set infoPlacement(value:String) : void
        {
            if (value !== this.m_infoPlacement)
            {
                this.m_infoPlacement = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get infoRenderer() : IFactory
        {
            return this.m_infoRenderer;
        }// end function

        public function set infoRenderer(value:IFactory) : void
        {
            if (value == null)
            {
                this.m_infoRenderer = new ClassFactory(InfoDataList);
            }
            else
            {
                this.m_infoRenderer = value;
            }
            dispatchEventChange();
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var _loc_5:* = geometry as MapPoint;
            if (_loc_5)
            {
                if (map.wrapAround180)
                {
                    this.drawMultipleMapPoints(sprite, _loc_5, attributes, map);
                }
                else
                {
                    this.drawSingleMapPoint(sprite, _loc_5, attributes, map);
                }
            }
            return;
        }// end function

        private function drawMultipleMapPoints(sprite:Sprite, mapPoint:MapPoint, attributes:Object, map:Map) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_5:* = map.toScreenX(mapPoint.x);
            var _loc_6:* = map.toScreenY(mapPoint.y);
            var _loc_12:* = mapPoint.x;
            EXTENT.xmax = mapPoint.x;
            EXTENT.xmin = _loc_12;
            var _loc_12:* = mapPoint.y;
            EXTENT.ymax = mapPoint.y;
            EXTENT.ymin = _loc_12;
            EXTENT.spatialReference = mapPoint.spatialReference;
            var _loc_7:* = GeomUtils.intersects(map, mapPoint, EXTENT);
            var _loc_8:Array = [];
            for each (_loc_9 in _loc_7)
            {
                
                _loc_10 = map.toMapX(_loc_5 + _loc_9);
                _loc_11 = map.toMapY(_loc_6);
                if (map.extent.containsXY(_loc_10, _loc_11))
                {
                    _loc_8.push(new MapPoint(_loc_10, _loc_11));
                }
            }
            if (_loc_8.length === 0)
            {
                removeAllChildren(sprite);
            }
            else if (sprite.numChildren === _loc_8.length)
            {
                this.doSameNumberOfChildren(sprite, _loc_8, attributes, map);
            }
            else if (sprite.numChildren < _loc_8.length)
            {
                this.doLessNumberOfChildren(sprite, _loc_8, attributes, map);
            }
            else if (sprite.numChildren > _loc_8.length)
            {
                this.doMoreNumberOfChildren(sprite, _loc_8, attributes, map);
            }
            return;
        }// end function

        private function doMoreNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map) : void
        {
            var _loc_5:* = sprite.numChildren - mapPoints.length;
            while (_loc_5--)
            {
                
                sprite.removeChildAt(0);
            }
            this.doSameNumberOfChildren(sprite, mapPoints, attributes, map);
            return;
        }// end function

        private function doLessNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map) : void
        {
            var _loc_6:MapPoint = null;
            var _loc_7:InfoSymbolWindow = null;
            var _loc_8:MapPoint = null;
            var _loc_9:InfoSymbolWindow = null;
            var _loc_5:int = 0;
            while (_loc_5 < sprite.numChildren)
            {
                
                _loc_6 = mapPoints[_loc_5];
                _loc_7 = sprite.getChildAt(_loc_5) as InfoSymbolWindow;
                if (this.m_infoPlacement)
                {
                    _loc_7.setStyle(InfoComponent.INFO_PLACEMENT, this.m_infoPlacement);
                }
                _loc_7.data = attributes;
                _loc_7.anchorX = toScreenX(map, _loc_6.x);
                _loc_7.anchorY = toScreenY(map, _loc_6.y);
                _loc_5 = _loc_5 + 1;
            }
            while (_loc_5 < mapPoints.length)
            {
                
                _loc_8 = mapPoints[_loc_5];
                _loc_9 = new InfoSymbolWindow(map, this.containerStyleName);
                if (this.m_infoPlacement)
                {
                    _loc_9.setStyle(InfoComponent.INFO_PLACEMENT, this.m_infoPlacement);
                }
                _loc_9.content = this.infoRenderer.newInstance() as IVisualElement;
                _loc_9.data = attributes;
                _loc_9.anchorX = toScreenX(map, _loc_8.x);
                _loc_9.anchorY = toScreenY(map, _loc_8.y);
                sprite.addChild(_loc_9);
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        private function doSameNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map) : void
        {
            var _loc_6:MapPoint = null;
            var _loc_7:InfoSymbolWindow = null;
            var _loc_5:int = 0;
            while (_loc_5 < sprite.numChildren)
            {
                
                _loc_6 = mapPoints[_loc_5];
                _loc_7 = sprite.getChildAt(_loc_5) as InfoSymbolWindow;
                _loc_7.data = attributes;
                _loc_7.anchorX = toScreenX(map, _loc_6.x);
                _loc_7.anchorY = toScreenY(map, _loc_6.y);
                if (this.m_infoPlacement)
                {
                    _loc_7.setStyle(InfoComponent.INFO_PLACEMENT, this.m_infoPlacement);
                }
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        private function drawSingleMapPoint(sprite:Sprite, mapPoint:MapPoint, attributes:Object, map:Map) : void
        {
            var _loc_5:* = sprite.getChildByName("infoSymbolWindow") as InfoSymbolWindow;
            if (_loc_5 === null)
            {
                _loc_5 = new InfoSymbolWindow(map, this.containerStyleName);
                _loc_5.name = "infoSymbolWindow";
                _loc_5.content = this.infoRenderer.newInstance() as IVisualElement;
                sprite.addChild(_loc_5);
            }
            if (this.m_infoPlacement)
            {
                _loc_5.setStyle(InfoComponent.INFO_PLACEMENT, this.m_infoPlacement);
            }
            _loc_5.data = attributes;
            this.drawMapPoint(map, sprite, mapPoint, _loc_5);
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            sprite.graphics.clear();
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            removeAllChildren(sprite);
            sprite.graphics.clear();
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        private function drawMapPoint(map:Map, sprite:Sprite, mapPoint:MapPoint, infoSymbolWindow:InfoSymbolWindow) : void
        {
            if (map.extent.containsXY(mapPoint.x, mapPoint.y))
            {
                infoSymbolWindow.anchorX = toScreenX(map, mapPoint.x);
                infoSymbolWindow.anchorY = toScreenY(map, mapPoint.y);
                infoSymbolWindow.visible = true;
                infoSymbolWindow.includeInLayout = true;
            }
            else
            {
                infoSymbolWindow.visible = false;
                infoSymbolWindow.includeInLayout = false;
            }
            return;
        }// end function

    }
}
