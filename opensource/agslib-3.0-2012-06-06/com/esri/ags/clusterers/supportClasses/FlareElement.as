package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    final class FlareElement extends Sprite
    {
        private var m_graphic:Graphic;
        private var m_symbol:Symbol;
        private var m_radius:Number;
        private var m_scaleX:Number;
        private var m_scaleY:Number;
        private var m_scale:Number = 1;
        private var m_cos:Number;
        private var m_sin:Number;
        private var m_distance:Number;
        private var m_easingDistance:Number = 0;
        private var m_drawFunction:Function;
        private static const RAD_PER_DEG:Number = 0.0174533;
        private static const MATRIX:Matrix = new Matrix();

        function FlareElement(graphic:Graphic, angle:Number, distance:Number, radius:Number)
        {
            this.m_drawFunction = this.drawDefault;
            this.m_graphic = graphic;
            this.m_radius = radius;
            this.m_distance = distance;
            var _loc_5:* = angle * RAD_PER_DEG;
            this.m_cos = Math.cos(_loc_5);
            this.m_sin = Math.sin(_loc_5);
            this.addEventListener(Event.ADDED, this.addedHandler, false, 0, true);
            this.addEventListener(Event.REMOVED, this.removedHandler, false, 0, true);
            this.x = 0;
            this.y = 0;
            return;
        }// end function

        private function get flareContainer() : FlareContainer
        {
            return parent as FlareContainer;
        }// end function

        public function initialize() : void
        {
            this.m_symbol = this.m_graphic.getActiveSymbol(this.flareContainer.parentGraphic.graphicsLayer);
            var _loc_1:* = this.m_symbol as SimpleMarkerSymbol;
            if (_loc_1 === null)
            {
                if (this.m_symbol is PictureMarkerSymbol)
                {
                    this.initializePictureMarkerSymbol();
                }
                else
                {
                    this.m_drawFunction = this.drawDefault;
                }
            }
            else
            {
                if (_loc_1.outline !== null)
                {
                }
                if (_loc_1.outline.style === SimpleLineSymbol.STYLE_NULL)
                {
                    this.setDrawShapeWithoutOutline(_loc_1);
                }
                else
                {
                    this.drawShapeWithOutline(_loc_1);
                }
            }
            return;
        }// end function

        private function initializePictureMarkerSymbol() : void
        {
            var _loc_1:PictureMarkerSymbol = null;
            var _loc_3:Loader = null;
            var _loc_4:Class = null;
            var _loc_5:* = undefined;
            var _loc_6:DisplayObject = null;
            var _loc_7:ByteArray = null;
            var _loc_8:Loader = null;
            this.m_drawFunction = this.drawBitmap;
            _loc_1 = this.m_symbol as PictureMarkerSymbol;
            var _loc_2:* = _loc_1.source as String;
            if (_loc_2)
            {
                this.m_drawFunction = this.drawDefault;
                _loc_3 = new Loader();
                _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.contentLoaderInfo_completeHandler);
                _loc_3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.contentLoaderInfo_ioErrorHandler);
                _loc_3.load(new URLRequest(_loc_2));
            }
            else
            {
                _loc_4 = _loc_1.source as Class;
                if (_loc_4)
                {
                    _loc_5 = new _loc_4;
                    _loc_6 = _loc_5 as DisplayObject;
                    if (_loc_6)
                    {
                        if (_loc_1.width > 0)
                        {
                            _loc_6.width = _loc_1.width;
                        }
                        if (_loc_1.height > 0)
                        {
                            _loc_6.height = _loc_1.height;
                        }
                        this.m_scaleX = _loc_6.scaleX;
                        this.m_scaleY = _loc_6.scaleY;
                        _loc_6.x = _loc_6.width * -0.5;
                        _loc_6.y = _loc_6.height * -0.5;
                        addChild(_loc_5);
                        this.m_drawFunction = this.drawDisplayObject;
                    }
                }
                else
                {
                    _loc_7 = _loc_1.source as ByteArray;
                    if (_loc_7)
                    {
                        this.m_drawFunction = this.drawDefault;
                        _loc_8 = new Loader();
                        _loc_8.contentLoaderInfo.addEventListener(Event.COMPLETE, this.contentLoaderInfo_completeHandler);
                        _loc_8.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.contentLoaderInfo_ioErrorHandler);
                        _loc_8.loadBytes(_loc_7);
                    }
                }
            }
            return;
        }// end function

        private function contentLoaderInfo_ioErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function contentLoaderInfo_completeHandler(event:Event) : void
        {
            var _loc_2:* = LoaderInfo(event.target).loader;
            var _loc_3:* = this.m_symbol as PictureMarkerSymbol;
            if (_loc_3.width > 0)
            {
                _loc_2.width = _loc_3.width;
            }
            if (_loc_3.height > 0)
            {
                _loc_2.height = _loc_3.height;
            }
            this.m_scaleX = _loc_2.scaleX;
            this.m_scaleY = _loc_2.scaleY;
            addChild(_loc_2);
            this.m_drawFunction = this.drawDisplayObject;
            this.updateDisplayList();
            return;
        }// end function

        private function drawShapeWithOutline(simpleMarkerSymbol:SimpleMarkerSymbol) : void
        {
            if (simpleMarkerSymbol.size > 0)
            {
                this.m_radius = simpleMarkerSymbol.size * 0.5;
            }
            switch(simpleMarkerSymbol.style)
            {
                case SimpleMarkerSymbol.STYLE_CIRCLE:
                {
                    this.m_drawFunction = this.drawCircleWithOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_SQUARE:
                {
                    this.m_drawFunction = this.drawSquareWithOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_CROSS:
                {
                    this.m_drawFunction = this.drawCrossWithOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_DIAMOND:
                {
                    this.m_drawFunction = this.drawDiamondWithOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_TRIANGLE:
                {
                    this.m_drawFunction = this.drawTriangleWithOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_X:
                {
                    this.m_drawFunction = this.drawXWithOutline;
                    break;
                }
                default:
                {
                    this.m_drawFunction = this.drawDefault;
                    break;
                }
            }
            return;
        }// end function

        private function setDrawShapeWithoutOutline(simpleMarkerSymbol:SimpleMarkerSymbol) : void
        {
            if (simpleMarkerSymbol.size > 0)
            {
                this.m_radius = simpleMarkerSymbol.size * 0.5;
            }
            switch(simpleMarkerSymbol.style)
            {
                case SimpleMarkerSymbol.STYLE_CIRCLE:
                {
                    this.m_drawFunction = this.drawCircleWithoutOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_SQUARE:
                {
                    this.m_drawFunction = this.drawSquareWithoutOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_CROSS:
                {
                    this.m_drawFunction = this.drawCrossWithoutOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_DIAMOND:
                {
                    this.m_drawFunction = this.drawDiamondWithoutOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_TRIANGLE:
                {
                    this.m_drawFunction = this.drawTriangleWithoutOutline;
                    break;
                }
                case SimpleMarkerSymbol.STYLE_X:
                {
                    this.m_drawFunction = this.drawXWithoutOutline;
                    break;
                }
                default:
                {
                    this.m_drawFunction = this.drawDefault;
                    break;
                }
            }
            return;
        }// end function

        private function addedHandler(event:Event) : void
        {
            if (event.eventPhase === EventPhase.AT_TARGET)
            {
                removeEventListener(event.type, this.addedHandler);
                addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
                addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            }
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            var _loc_2:Point = null;
            var _loc_3:Number = NaN;
            if (this.m_symbol is SimpleMarkerSymbol)
            {
                _loc_2 = globalToLocal(new Point(event.stageX, event.stageY));
                _loc_3 = Math.sqrt(_loc_2.x * _loc_2.x + _loc_2.y * _loc_2.y) + this.m_radius;
                if (_loc_3 < this.m_distance)
                {
                    return;
                }
            }
            if (event.eventPhase !== EventPhase.AT_TARGET)
            {
            }
            if (event.target is Loader)
            {
                addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
                addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            return;
        }// end function

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            event.stopPropagation();
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.dispatchFlareMouseEvent(FlareMouseEvent.FLARE_CLICK, event, this.flareContainer);
            return;
        }// end function

        private function dispatchFlareMouseEvent(type:String, event:MouseEvent, flareContainer:FlareContainer) : void
        {
            var _loc_4:* = new FlareMouseEvent(type, flareContainer.cluster, this.m_graphic);
            _loc_4.copyProperties(event);
            dispatchEvent(_loc_4);
            return;
        }// end function

        private function rollOverHandler(event:MouseEvent) : void
        {
            var _loc_3:Point = null;
            var _loc_4:Number = NaN;
            if (hasEventListener(MouseEvent.ROLL_OUT))
            {
                removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            }
            if (this.m_symbol is SimpleMarkerSymbol)
            {
                _loc_3 = globalToLocal(new Point(event.stageX, event.stageY));
                _loc_4 = Math.sqrt(_loc_3.x * _loc_3.x + _loc_3.y * _loc_3.y) + this.m_radius;
                if (_loc_4 < this.m_distance)
                {
                    return;
                }
            }
            var _loc_2:* = this.flareContainer.flareSymbol;
            this.m_radius = this.m_radius + _loc_2.flareSizeIncOnRollOver;
            this.m_scale = 1.2;
            this.updateDisplayList();
            event.updateAfterEvent();
            addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            this.dispatchFlareMouseEvent(FlareMouseEvent.FLARE_OVER, event, this.flareContainer);
            return;
        }// end function

        private function rollOutHandler(event:MouseEvent) : void
        {
            removeEventListener(MouseEvent.ROLL_OUT, this.rollOverHandler);
            var _loc_2:* = this.flareContainer.flareSymbol;
            this.m_radius = this.m_radius - _loc_2.flareSizeIncOnRollOver;
            this.m_scale = 1;
            this.updateDisplayList();
            event.updateAfterEvent();
            this.dispatchFlareMouseEvent(FlareMouseEvent.FLARE_OUT, event, this.flareContainer);
            return;
        }// end function

        private function removedHandler(event:Event) : void
        {
            removeEventListener(event.type, this.removedHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            return;
        }// end function

        public function updateFactor(factor:Number) : void
        {
            this.m_easingDistance = FlareEasing.easing(factor, 0, this.m_distance, 1);
            return;
        }// end function

        public function updateDisplayList() : void
        {
            var _loc_1:FlareSymbol = null;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (parent)
            {
                _loc_1 = this.flareContainer.flareSymbol;
                _loc_2 = this.m_easingDistance * this.m_cos;
                _loc_3 = this.m_easingDistance * this.m_sin;
                graphics.clear();
                graphics.lineStyle(_loc_1.borderThickness, _loc_1.borderColor, _loc_1.borderAlpha);
                graphics.moveTo(0, 0);
                graphics.lineTo(_loc_2, _loc_3);
                this.m_drawFunction(this.flareContainer, _loc_2, _loc_3);
            }
            return;
        }// end function

        private function drawDefault(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            graphics.beginFill(flareContainer.backgroundColor, flareContainer.backgroundAlpha);
            graphics.drawCircle(px, py, this.m_radius);
            graphics.endFill();
            return;
        }// end function

        private function drawCircleWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle();
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            graphics.drawCircle(px, py, this.m_radius);
            graphics.endFill();
            return;
        }// end function

        private function drawCircleWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            graphics.drawCircle(px, py, this.m_radius);
            graphics.endFill();
            return;
        }// end function

        private function drawCrossWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            graphics.lineStyle(flareContainer.flareSymbol.borderThickness, flareContainer.flareSymbol.borderColor, flareContainer.flareSymbol.borderAlpha);
            this.drawCross(px, py);
            return;
        }// end function

        private function drawCrossWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            this.drawCross(px, py);
            return;
        }// end function

        private function drawCross(px:Number, py:Number) : void
        {
            graphics.moveTo(px - this.m_radius, py);
            graphics.lineTo(px + this.m_radius, py);
            graphics.moveTo(px, py + this.m_radius);
            graphics.lineTo(px, py - this.m_radius);
            return;
        }// end function

        private function drawXWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            graphics.lineStyle(flareContainer.flareSymbol.borderThickness, flareContainer.flareSymbol.borderColor, flareContainer.flareSymbol.borderAlpha);
            this.drawX(px, py);
            return;
        }// end function

        private function drawXWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            this.drawX(px, py);
            return;
        }// end function

        private function drawX(px:Number, py:Number) : void
        {
            graphics.moveTo(px - this.m_radius, py - this.m_radius);
            graphics.lineTo(px + this.m_radius, py + this.m_radius);
            graphics.moveTo(px + this.m_radius, py - this.m_radius);
            graphics.lineTo(px - this.m_radius, py + this.m_radius);
            return;
        }// end function

        private function drawSquareWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            var _loc_5:* = this.m_radius + this.m_radius;
            graphics.lineStyle();
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            graphics.drawRect(px - this.m_radius, py - this.m_radius, _loc_5, _loc_5);
            graphics.endFill();
            return;
        }// end function

        private function drawSquareWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            var _loc_5:* = this.m_radius + this.m_radius;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            graphics.drawRect(px - this.m_radius, py - this.m_radius, _loc_5, _loc_5);
            graphics.endFill();
            return;
        }// end function

        private function drawTriangleWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle();
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            this.drawTriangle(px, py);
            graphics.endFill();
            return;
        }// end function

        private function drawTriangleWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            this.drawTriangle(px, py);
            graphics.endFill();
            return;
        }// end function

        private function drawTriangle(px:Number, py:Number) : void
        {
            graphics.moveTo(px, py - this.m_radius);
            graphics.lineTo(px - this.m_radius, py + this.m_radius);
            graphics.lineTo(px + this.m_radius, py + this.m_radius);
            graphics.lineTo(px, py - this.m_radius);
            return;
        }// end function

        private function drawDiamondWithoutOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle();
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            this.drawDiamond(px, py);
            graphics.endFill();
            return;
        }// end function

        private function drawDiamondWithOutline(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = this.m_symbol as SimpleMarkerSymbol;
            graphics.lineStyle(_loc_4.outline.width, _loc_4.outline.color, _loc_4.outline.alpha);
            graphics.beginFill(_loc_4.color, _loc_4.alpha);
            this.drawDiamond(px, py);
            graphics.endFill();
            return;
        }// end function

        private function drawDiamond(px:Number, py:Number) : void
        {
            graphics.moveTo(px, py - this.m_radius);
            graphics.lineTo(px - this.m_radius, py);
            graphics.lineTo(px, py + this.m_radius);
            graphics.lineTo(px + this.m_radius, py);
            graphics.moveTo(px, py - this.m_radius);
            return;
        }// end function

        private function drawBitmap(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var flareContainer:* = flareContainer;
            var px:* = px;
            var py:* = py;
            var drawLater:* = function (customPictureMarkerObject:CustomPictureMarkerObject) : void
            {
                var _loc_2:* = customPictureMarkerObject.bitmap;
                if (_loc_2)
                {
                    MATRIX.identity();
                    MATRIX.scale(m_scale, m_scale);
                    MATRIX.tx = px - _loc_2.width * m_scale * 0.5;
                    MATRIX.ty = py - _loc_2.height * m_scale * 0.5;
                    graphics.lineStyle();
                    graphics.beginBitmapFill(_loc_2.bitmapData, MATRIX, false, true);
                    graphics.drawRect(MATRIX.tx, MATRIX.ty, _loc_2.width * m_scale, _loc_2.height * m_scale);
                    graphics.endFill();
                }
                else
                {
                    graphics.beginFill(flareContainer.backgroundColor, flareContainer.backgroundAlpha);
                    graphics.drawCircle(px, py, m_radius);
                    graphics.endFill();
                }
                return;
            }// end function
            ;
            var pictureMarkerSymbol:* = this.m_symbol as PictureMarkerSymbol;
            MATRIX.identity();
            MATRIX.tx = pictureMarkerSymbol.xoffset;
            MATRIX.ty = pictureMarkerSymbol.yoffset;
            PictureMarkerSymbolCache.instance.getCachedObject(pictureMarkerSymbol.source, drawLater, MATRIX);
            return;
        }// end function

        private function drawDisplayObject(flareContainer:FlareContainer, px:Number, py:Number) : void
        {
            var _loc_4:* = getChildAt(0);
            _loc_4.x = px - _loc_4.width * this.m_scale * 0.5;
            _loc_4.y = py - _loc_4.height * this.m_scale * 0.5;
            _loc_4.scaleX = this.m_scaleX * this.m_scale;
            _loc_4.scaleY = this.m_scaleY * this.m_scale;
            return;
        }// end function

    }
}
