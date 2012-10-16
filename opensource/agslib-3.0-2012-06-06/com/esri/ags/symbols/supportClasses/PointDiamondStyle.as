package com.esri.ags.symbols.supportClasses
{
    import __AS3__.vec.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.graphics.*;

    public class PointDiamondStyle extends PointSymbolStyle implements ISymbolStyle
    {

        public function PointDiamondStyle()
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
                _loc_5 = this.traceRotationDiamond(sprite, screenX, screenY, size, half, false, null, point);
            }
            else
            {
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceDiamond(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithSolidOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            if (angle)
            {
                _loc_5 = this.traceRotationDiamond(sprite, screenX, screenY, size, half, false, m_stroke, point);
            }
            else
            {
                if (m_stroke.weight != 0)
                {
                    m_stroke.apply(sprite.graphics, null, null);
                }
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceDiamond(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithStyledOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            var _loc_6:Array = null;
            if (angle)
            {
                _loc_5 = this.traceRotationDiamond(sprite, screenX, screenY, size, half, true, m_stroke, point);
            }
            else
            {
                this.traceDiamond(sprite.graphics, screenX, screenY, half);
                sprite.graphics.endFill();
                _loc_6 = [screenX - half, screenY, screenX, screenY - half, screenX + half, screenY, screenX, screenY + half, screenX - half, screenY];
                SymbolUtil.drawStyledLine(sprite, _loc_6, m_stroke, pattern);
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
            }
            return _loc_5;
        }// end function

        private function traceDiamond(graphics:Graphics, screenX:Number, screenY:Number, half:Number) : void
        {
            graphics.moveTo(screenX - half, screenY);
            graphics.lineTo(screenX, screenY - half);
            graphics.lineTo(screenX + half, screenY);
            graphics.lineTo(screenX, screenY + half);
            return;
        }// end function

        private function traceRotationDiamond(sprite:Sprite, screenX:Number, screenY:Number, size:Number, half:Number, isStyled:Boolean, stroke:SolidColorStroke, point:MapPoint) : Rectangle
        {
            var _loc_13:Array = null;
            var _loc_14:uint = 0;
            var _loc_9:* = new Point(screenX, screenY);
            new Vector.<int>(5)[0] = 1;
            new Vector.<int>(5)[1] = 2;
            new Vector.<int>(5)[2] = 2;
            new Vector.<int>(5)[3] = 2;
            new Vector.<int>(5)[4] = 2;
            var _loc_10:* = new Vector.<int>(5);
            new Vector.<Number>(10)[0] = screenX - half;
            new Vector.<Number>(10)[1] = screenY;
            new Vector.<Number>(10)[2] = screenX;
            new Vector.<Number>(10)[3] = screenY - half;
            new Vector.<Number>(10)[4] = screenX + half;
            new Vector.<Number>(10)[5] = screenY;
            new Vector.<Number>(10)[6] = screenX;
            new Vector.<Number>(10)[7] = screenY + half;
            new Vector.<Number>(10)[8] = screenX - half;
            new Vector.<Number>(10)[9] = screenY;
            var _loc_11:* = new Vector.<Number>(10);
            var _loc_12:* = rotatePoints(_loc_11, _loc_9, angle);
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
            sprite.graphics.drawPath(_loc_10, _loc_11);
            sprite.graphics.endFill();
            if (isStyled)
            {
                _loc_13 = [];
                _loc_14 = 0;
                while (_loc_14 < _loc_11.length)
                {
                    
                    _loc_13[_loc_13.length] = _loc_11[_loc_14];
                    _loc_14 = _loc_14 + 1;
                }
                SymbolUtil.drawStyledLine(sprite, _loc_13, stroke, pattern);
            }
            return _loc_12;
        }// end function

    }
}
