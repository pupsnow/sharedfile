package com.esri.ags.symbols.supportClasses
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.graphics.*;

    public class PointCircleStyle extends PointSymbolStyle implements ISymbolStyle
    {
        private static const PI_OVER_180:Number = 0.0174533;

        public function PointCircleStyle()
        {
            return;
        }// end function

        public function drawGeometry(canvas:Object, geometry:Geometry, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:* = canvas as Sprite;
            _loc_5.graphics.beginFill(color, alpha);
            var _loc_6:* = drawStyle(_loc_5, geometry as MapPoint, screenX, screenY);
            _loc_5.graphics.endFill();
            return _loc_6;
        }// end function

        override protected function drawStyleWithNoOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            if (angle)
            {
                this.traceRotationCircle(sprite, half, false, null, point, screenX, screenY);
            }
            else
            {
                sprite.graphics.drawCircle(screenX, screenY, half);
            }
            return new Rectangle(screenX - half, screenY - half, size, size);
        }// end function

        override protected function drawStyleWithSolidOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            if (angle)
            {
                this.traceRotationCircle(sprite, half, false, m_stroke, point, screenX, screenY);
            }
            else
            {
                if (m_stroke.weight != 0)
                {
                    m_stroke.apply(sprite.graphics, null, null);
                }
                sprite.graphics.drawCircle(screenX, screenY, half);
            }
            return new Rectangle(screenX - half, screenY - half, size, size);
        }// end function

        override protected function drawStyleWithStyledOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Array = null;
            if (angle)
            {
                this.traceRotationCircle(sprite, half, true, null, point, screenX, screenY);
            }
            else
            {
                _loc_5 = this.traceStyledCircle(sprite.graphics, screenX, screenY, half);
                SymbolUtil.drawStyledLine(sprite, _loc_5, m_stroke, pattern);
                sprite.graphics.endFill();
            }
            return new Rectangle(screenX - half, screenY - half, size, size);
        }// end function

        private function traceRotationCircle(sprite:Sprite, half:Number, isStyled:Boolean, stroke:SolidColorStroke, point:MapPoint, screenX:Number, screenY:Number) : void
        {
            var _loc_8:Array = null;
            sprite.graphics.beginFill(color, alpha);
            if (outline)
            {
            }
            if (outline.style == SimpleLineSymbol.STYLE_SOLID)
            {
                if (stroke.weight != 0)
                {
                    stroke.apply(sprite.graphics, null, null);
                }
            }
            sprite.graphics.drawCircle(screenX, screenY, half);
            sprite.graphics.endFill();
            if (isStyled)
            {
                _loc_8 = this.traceStyledCircle(sprite.graphics, screenX, screenY, half);
                SymbolUtil.drawStyledLine(sprite, _loc_8, m_stroke, pattern);
            }
            return;
        }// end function

        private function traceStyledCircle(graphics:Graphics, sx:Number, sy:Number, radius:Number) : Array
        {
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_5:Array = [];
            var _loc_6:int = 0;
            while (_loc_6 <= 360)
            {
                
                _loc_7 = sx + radius * Math.sin(_loc_6 * PI_OVER_180);
                _loc_8 = sy + radius * Math.cos(_loc_6 * PI_OVER_180);
                _loc_6 = _loc_6 + 3;
                _loc_5.push(_loc_7, _loc_8);
            }
            return _loc_5;
        }// end function

    }
}
