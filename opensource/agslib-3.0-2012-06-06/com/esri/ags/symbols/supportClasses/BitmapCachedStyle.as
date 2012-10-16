package com.esri.ags.symbols.supportClasses
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import spark.components.*;

    public class BitmapCachedStyle extends Object implements ISymbolStyle
    {
        private var m_fillTranslation:Matrix;
        private var m_bitmapBounds:Rectangle;
        private var m_innerStyle:ISymbolStyle;
        private var m_cachedBitmapData:BitmapData;
        private var destinationPoint:Point;

        public function BitmapCachedStyle(innerStyle:ISymbolStyle = null)
        {
            this.m_fillTranslation = new Matrix();
            this.destinationPoint = new Point();
            this.m_innerStyle = innerStyle;
            return;
        }// end function

        public function get innerStyle() : ISymbolStyle
        {
            return this.m_innerStyle;
        }// end function

        public function set innerStyle(value:ISymbolStyle) : void
        {
            if (this.m_innerStyle)
            {
            }
            if (this.m_innerStyle.symbol)
            {
                this.m_innerStyle.symbol.removeEventListener(Event.CHANGE, this.handleSymbolChange);
                this.m_innerStyle.symbol = null;
            }
            this.m_innerStyle = value;
            if (this.m_innerStyle)
            {
            }
            if (this.m_innerStyle.symbol)
            {
                this.disposeCachedBitmapData();
                this.m_innerStyle.symbol.addEventListener(Event.CHANGE, this.handleSymbolChange);
            }
            return;
        }// end function

        public function get symbol() : Symbol
        {
            return this.m_innerStyle.symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            if (this.m_innerStyle)
            {
                if (this.m_innerStyle.symbol)
                {
                    this.m_innerStyle.symbol.removeEventListener(Event.CHANGE, this.handleSymbolChange);
                }
                this.m_innerStyle.symbol = value;
                if (this.m_innerStyle.symbol)
                {
                    this.disposeCachedBitmapData();
                    this.m_innerStyle.symbol.addEventListener(Event.CHANGE, this.handleSymbolChange);
                }
            }
            return;
        }// end function

        public function get cachedBitmapData() : BitmapData
        {
            return this.m_cachedBitmapData;
        }// end function

        public function drawGeometry(canvas:Object, geometry:Geometry, screenX:Number, screenY:Number) : Rectangle
        {
            var _loc_5:* = canvas as Sprite;
            var _loc_6:* = canvas as BitmapData;
            if (!_loc_5)
            {
            }
            if (_loc_6)
            {
                if (!this.m_cachedBitmapData)
                {
                    _loc_5 = new Sprite();
                    (FlexGlobals.topLevelApplication as Application).stage.addChild(_loc_5);
                    this.drawGeometry(_loc_5, geometry, 0, 0);
                    (FlexGlobals.topLevelApplication as Application).stage.removeChild(_loc_5);
                    _loc_5.graphics.clear();
                    this.m_bitmapBounds.width = this.m_bitmapBounds.width * 2;
                    this.m_bitmapBounds.height = this.m_bitmapBounds.height * 2;
                }
                this.destinationPoint.x = screenX + this.m_bitmapBounds.x;
                this.destinationPoint.y = screenY + this.m_bitmapBounds.y;
                _loc_6.copyPixels(this.m_cachedBitmapData, this.m_bitmapBounds, this.destinationPoint, null, null, true);
            }
            else if (this.m_cachedBitmapData)
            {
                this.drawCachedBitmapData(_loc_5.graphics, screenX, screenY);
            }
            else
            {
                this.m_bitmapBounds = this.m_innerStyle.drawGeometry(canvas, geometry, screenX, screenY);
                this.cacheBitmapData(_loc_5, this.m_bitmapBounds);
            }
            return this.m_bitmapBounds;
        }// end function

        private function cacheBitmapData(sprite:Sprite, bounds:Rectangle) : BitmapData
        {
            if (!this.m_cachedBitmapData)
            {
                this.m_cachedBitmapData = new BitmapData(Math.ceil(bounds.width), Math.ceil(bounds.height), true, 0);
                this.m_fillTranslation.tx = -bounds.x;
                this.m_fillTranslation.ty = -bounds.y;
                this.m_cachedBitmapData.draw(sprite, this.m_fillTranslation);
            }
            return this.m_cachedBitmapData;
        }// end function

        private function drawCachedBitmapData(graphics:Graphics, screenX:Number, screenY:Number) : void
        {
            if (this.m_cachedBitmapData)
            {
                this.m_fillTranslation.tx = screenX - this.m_bitmapBounds.width * 0.5;
                this.m_fillTranslation.ty = screenY - this.m_bitmapBounds.height * 0.5;
                graphics.beginBitmapFill(this.m_cachedBitmapData, this.m_fillTranslation, false);
                graphics.drawRect(this.m_fillTranslation.tx, this.m_fillTranslation.ty, this.m_bitmapBounds.width, this.m_bitmapBounds.height);
                graphics.endFill();
            }
            return;
        }// end function

        private function disposeCachedBitmapData() : void
        {
            if (this.m_cachedBitmapData)
            {
                this.m_cachedBitmapData.dispose();
                this.m_cachedBitmapData = null;
                this.m_bitmapBounds = null;
            }
            return;
        }// end function

        private function handleSymbolChange(event:Event) : void
        {
            this.disposeCachedBitmapData();
            return;
        }// end function

    }
}
