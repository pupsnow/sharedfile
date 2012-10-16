package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import mx.core.*;

    public class Symbol extends EventDispatcher
    {

        public function Symbol()
        {
            super(null);
            return;
        }// end function

        public function initialize(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            return;
        }// end function

        public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            return;
        }// end function

        public function clear(sprite:Sprite) : void
        {
            return;
        }// end function

        public function destroy(sprite:Sprite) : void
        {
            return;
        }// end function

        public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            return null;
        }// end function

        protected function toScreenX(map:Map, mapX:Number) : Number
        {
            return map.mapToContainerX(mapX);
        }// end function

        protected function toScreenY(map:Map, mapY:Number) : Number
        {
            return map.mapToContainerY(mapY);
        }// end function

        protected function removeAllChildren(sprite:Sprite) : void
        {
            while (sprite.numChildren)
            {
                
                sprite.removeChildAt(0);
            }
            return;
        }// end function

        function hideAllChildren(sprite:Sprite) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < sprite.numChildren)
            {
                
                sprite.getChildAt(_loc_2).visible = false;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function showAllChildren(sprite:Sprite) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < sprite.numChildren)
            {
                
                sprite.getChildAt(_loc_2).visible = true;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        protected function dispatchEventChange() : void
        {
            if (hasEventListener(Event.CHANGE))
            {
                dispatchEvent(new Event(Event.CHANGE));
            }
            return;
        }// end function

    }
}
