package com.esri.ags.symbols.supportClasses
{
    import __AS3__.vec.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.graphics.*;

    public class PointCrossStyle extends PointSymbolStyle implements ISymbolStyle
    {

        public function PointCrossStyle()
        {
            return;
        }// end function

        public function drawGeometry(canvas:Object, geometry:Geometry, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:* = canvas as Sprite;
            return drawStyle(_loc_5, geometry as MapPoint, screenX, screenY);
        }// end function

        override protected function drawStyleWithNoOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            m_stroke.apply(sprite.graphics, null, null);
            if (angle)
            {
                _loc_5 = this.traceRotationCross(sprite, screenX, screenY, half, false, null);
            }
            else
            {
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceCross(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithSolidOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            if (m_stroke.weight != 0)
            {
                m_stroke.apply(sprite.graphics, null, null);
            }
            if (angle)
            {
                _loc_5 = this.traceRotationCross(sprite, screenX, screenY, half, false, m_stroke);
            }
            else
            {
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
                this.traceCross(sprite.graphics, screenX, screenY, half);
            }
            return _loc_5;
        }// end function

        override protected function drawStyleWithStyledOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:Rectangle = null;
            var _loc_6:Array = null;
            if (angle)
            {
                _loc_5 = this.traceRotationCross(sprite, screenX, screenY, half, true, m_stroke);
            }
            else
            {
                _loc_6 = [[screenX - half, screenY, screenX + half, screenY], [screenX, screenY - half, screenX, screenY + half]];
                SymbolUtil.drawStyledLine(sprite, _loc_6[0], m_stroke, pattern);
                SymbolUtil.drawStyledLine(sprite, _loc_6[1], m_stroke, pattern);
                _loc_5 = new Rectangle(screenX - half, screenY - half, size, size);
            }
            return _loc_5;
        }// end function

        override protected function updateStyle() : void
        {
            super.updateStyle();
            m_stroke.color = color;
            m_stroke.alpha = alpha;
            return;
        }// end function

        private function traceCross(graphics:Graphics, screenX:Number, screenY:Number, half:Number) : void
        {
            graphics.moveTo(screenX - half, screenY);
            graphics.lineTo(screenX + half, screenY);
            graphics.moveTo(screenX, screenY + half);
            graphics.lineTo(screenX, screenY - half);
            return;
        }// end function

        private function traceRotationCross(sprite:Sprite, screenX:Number, screenY:Number, half:Number, isStyled:Boolean, stroke:SolidColorStroke) : Rectangle
        {
            var _loc_8:uint = 0;
            var _loc_11:Vector.<int> = null;
            var _loc_7:* = new Point(screenX, screenY);
            new Vector.<Number>(8)[0] = screenX - half;
            new Vector.<Number>(8)[1] = screenY;
            new Vector.<Number>(8)[2] = screenX + half;
            new Vector.<Number>(8)[3] = screenY;
            new Vector.<Number>(8)[4] = screenX;
            new Vector.<Number>(8)[5] = screenY - half;
            new Vector.<Number>(8)[6] = screenX;
            new Vector.<Number>(8)[7] = screenY + half;
            var _loc_9:* = new Vector.<Number>(8);
            var _loc_10:* = rotatePoints(_loc_9, _loc_7, angle);
            if (isStyled)
            {
                SymbolUtil.drawStyledLine(sprite, [_loc_9[0], _loc_9[1], _loc_9[2], _loc_9[3]], stroke, pattern);
                SymbolUtil.drawStyledLine(sprite, [_loc_9[4], _loc_9[5], _loc_9[6], _loc_9[7]], stroke, pattern);
            }
            else
            {
                new Vector.<int>(4)[0] = 1;
                new Vector.<int>(4)[1] = 2;
                new Vector.<int>(4)[2] = 1;
                new Vector.<int>(4)[3] = 2;
                _loc_11 = new Vector.<int>(4);
                sprite.graphics.drawPath(_loc_11, _loc_9);
            }
            return _loc_10;
        }// end function

    }
}
