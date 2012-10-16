package com.esri.ags.symbols.supportClasses
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.graphics.*;

    public class PointSymbolStyle extends SymbolStyle
    {
        protected var color:uint;
        protected var alpha:Number;
        protected var angle:Number;
        protected var size:Number;
        protected var half:Number;
        protected var outline:SimpleLineSymbol;
        protected var pattern:Array;
        protected var m_stroke:SolidColorStroke;
        private var m_traceFunction:Function;

        public function PointSymbolStyle()
        {
            this.m_stroke = new SolidColorStroke();
            return;
        }// end function

        protected function drawStyle(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:* = this.m_traceFunction.call(this, sprite, point, screenX, screenY);
            if (this.outline)
            {
            }
            if (this.outline.width > 0)
            {
                _loc_5.x = _loc_5.x - this.outline.width * 0.5;
                _loc_5.y = _loc_5.y - this.outline.width * 0.5;
                _loc_5.width = _loc_5.width + this.outline.width;
                _loc_5.height = _loc_5.height + this.outline.width;
            }
            return _loc_5;
        }// end function

        protected function drawStyleWithNoOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            return null;
        }// end function

        protected function drawStyleWithSolidOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            return null;
        }// end function

        protected function drawStyleWithStyledOutline(sprite:Sprite, point:MapPoint, screenX:Number, screenY:Number) : Rectangle
        {
            return null;
        }// end function

        override protected function updateStyle() : void
        {
            var _loc_1:* = m_symbol as SimpleMarkerSymbol;
            this.outline = _loc_1.outline;
            if (this.outline)
            {
            }
            if (this.outline.style == SimpleLineSymbol.STYLE_NULL)
            {
                this.m_traceFunction = this.drawStyleWithNoOutline;
            }
            else if (this.outline.style == SimpleLineSymbol.STYLE_SOLID)
            {
                this.m_traceFunction = this.drawStyleWithSolidOutline;
            }
            else
            {
                this.m_traceFunction = this.drawStyleWithStyledOutline;
            }
            if (this.outline)
            {
                this.m_stroke.color = _loc_1.outline.color;
                this.m_stroke.weight = _loc_1.outline.width;
                this.m_stroke.alpha = _loc_1.outline.alpha;
                switch(this.outline.style)
                {
                    case SimpleLineSymbol.STYLE_DASH:
                    {
                        this.pattern = [6, 6];
                        break;
                    }
                    case SimpleLineSymbol.STYLE_DOT:
                    {
                        this.pattern = [1, 6];
                        break;
                    }
                    case SimpleLineSymbol.STYLE_DASHDOT:
                    {
                        this.pattern = [6, 4, 1, 4];
                        break;
                    }
                    case SimpleLineSymbol.STYLE_DASHDOTDOT:
                    {
                        this.pattern = [6, 4, 1, 4, 1, 4];
                        break;
                    }
                    default:
                    {
                        this.pattern = [1, 0];
                        break;
                    }
                }
            }
            this.color = _loc_1.color;
            this.alpha = _loc_1.alpha;
            this.angle = _loc_1.angle;
            this.size = _loc_1.size;
            this.half = this.size * 0.5;
            return;
        }// end function

        private function handleSymbolChange(event:Event) : void
        {
            this.updateStyle();
            return;
        }// end function

    }
}
