package com.esri.ags.symbols.supportClasses
{
    import __AS3__.vec.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.graphics.*;

    public class PointTriangleStyle extends PointSymbolStyle implements ISymbolStyle
    {

        public function PointTriangleStyle()
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
            var _loc_5:Rectangle = null;
            if (angle)
            {
                _loc_5 = this.traceRotationTriangle(sprite, screenX, screenY, size, half, false, null, point);
            }
            else
            {
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceTriangle(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithSolidOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            if (angle)
            {
                _loc_5 = this.traceRotationTriangle(sprite, screenX, screenY, size, half, false, m_stroke, point);
            }
            else
            {
                if (m_stroke.weight != 0)
                {
                    m_stroke.apply(sprite.graphics, null, null);
                }
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceTriangle(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithStyledOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Array = null;
            if (angle)
            {
                _loc_5 = this.traceRotationTriangle(sprite, screenX, screenY, size, half, true, m_stroke, point);
            }
            else
            {
                this.traceTriangle(sprite.graphics, screenX, screenY, half);
                sprite.graphics.endFill();
                _loc_6 = Math.pow(half, 2);
                _loc_7 = Math.pow(half * 0.5, 2);
                _loc_8 = [screenX - Math.sqrt(_loc_6 - _loc_7), screenY + half * 0.5, screenX, screenY - half, screenX + Math.sqrt(_loc_6 - _loc_7), screenY + half * 0.5, screenX - Math.sqrt(_loc_6 - _loc_7), screenY + half * 0.5];
                SymbolUtil.drawStyledLine(sprite, _loc_8, m_stroke, pattern);
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
            }
            return _loc_5;
        }// end function

        private function traceTriangle(graphics:Graphics, screenX:Number, screenY:Number, half:Number) : void
        {
            var _loc_5:* = Math.pow(half, 2);
            var _loc_6:* = Math.pow(half * 0.5, 2);
            graphics.moveTo(screenX - Math.sqrt(_loc_5 - _loc_6), screenY + half * 0.5);
            graphics.lineTo(screenX, screenY - half);
            graphics.lineTo(screenX + Math.sqrt(_loc_5 - _loc_6), screenY + half * 0.5);
            return;
        }// end function

        private function traceRotationTriangle(sprite:Sprite, screenX:Number, screenY:Number, size:Number, half:Number, isStyled:Boolean, stroke:SolidColorStroke, point:MapPoint) : Rectangle
        {
            var _loc_15:Array = null;
            var _loc_16:uint = 0;
            new Vector.<int>(4)[0] = 1;
            new Vector.<int>(4)[1] = 2;
            new Vector.<int>(4)[2] = 2;
            new Vector.<int>(4)[3] = 2;
            var _loc_9:* = new Vector.<int>(4);
            var _loc_10:* = Math.pow(half, 2);
            var _loc_11:* = Math.pow(half * 0.5, 2);
            new Vector.<Number>(8)[0] = screenX - Math.sqrt(_loc_10 - _loc_11);
            new Vector.<Number>(8)[1] = screenY + half * 0.5;
            new Vector.<Number>(8)[2] = screenX;
            new Vector.<Number>(8)[3] = screenY - half;
            new Vector.<Number>(8)[4] = screenX + Math.sqrt(_loc_10 - _loc_11);
            new Vector.<Number>(8)[5] = screenY + half * 0.5;
            new Vector.<Number>(8)[6] = screenX - Math.sqrt(_loc_10 - _loc_11);
            new Vector.<Number>(8)[7] = screenY + half * 0.5;
            var _loc_12:* = new Vector.<Number>(8);
            var _loc_13:* = new Point(screenX, screenY);
            rotatePoints(_loc_12, _loc_13, angle);
            var _loc_14:* = new Rectangle(screenX - half, screenY - half, size, size);
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
            sprite.graphics.beginFill(color, alpha);
            sprite.graphics.drawPath(_loc_9, _loc_12);
            sprite.graphics.endFill();
            if (isStyled)
            {
                _loc_15 = [];
                _loc_16 = 0;
                while (_loc_16 < _loc_12.length)
                {
                    
                    _loc_15[_loc_15.length] = _loc_12[_loc_16];
                    _loc_16 = _loc_16 + 1;
                }
                SymbolUtil.drawStyledLine(sprite, _loc_15, stroke, pattern);
            }
            return _loc_14;
        }// end function

    }
}
