package com.esri.ags.symbols
{
    import __AS3__.vec.*;
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;

    public class SimpleFillSymbol extends FillSymbol implements IJSONSupport
    {
        private var m_stroke:SolidColorStroke;
        private var m_arrClippedBySidePoints:Vector.<MapPoint>;
        private var m_style:String;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_pattern:Array;
        public static const STYLE_SOLID:String = "solid";
        public static const STYLE_VERTICAL:String = "vertical";
        public static const STYLE_HORIZONTAL:String = "horizontal";
        public static const STYLE_CROSS:String = "cross";
        public static const STYLE_DIAGONAL_CROSS:String = "diagonalcross";
        public static const STYLE_FORWARD_DIAGONAL:String = "forwarddiagonal";
        public static const STYLE_BACKWARD_DIAGONAL:String = "backwarddiagonal";
        public static const STYLE_NULL:String = "null";
        private static const REST_STYLES:Object = {};
        private static var m_defaultSymbol:SimpleFillSymbol;

        public function SimpleFillSymbol(style:String = "solid", color:Number = 0, alpha:Number = 0.5, outline:SimpleLineSymbol = null)
        {
            this.m_stroke = new SolidColorStroke();
            this.m_style = style;
            this.m_color = color;
            this.m_alpha = alpha;
            m_outline = outline;
            return;
        }// end function

        public function get style() : String
        {
            return this.m_style;
        }// end function

        private function set _109780401style(value:String) : void
        {
            if (value != this.m_style)
            {
                this.m_style = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this.m_color;
        }// end function

        private function set _94842723color(value:uint) : void
        {
            if (value != this.m_color)
            {
                this.m_color = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get alpha() : Number
        {
            return this.m_alpha;
        }// end function

        private function set _92909918alpha(value:Number) : void
        {
            if (value != this.m_alpha)
            {
                this.m_alpha = value;
                dispatchEventChange();
            }
            return;
        }// end function

        override public function set outline(value:SimpleLineSymbol) : void
        {
            super.outline = value;
            this.m_pattern = null;
            return;
        }// end function

        function get pattern() : Array
        {
            return m_outline.pattern;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var _loc_6:Polygon = null;
            var _loc_7:Array = null;
            var _loc_8:Polygon = null;
            var _loc_9:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:MapPoint = null;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_5:* = map.extentExpanded;
            if (!(geometry is Polygon))
            {
            }
            if (geometry is Extent)
            {
                if (!map.wrapAround180)
                {
                    if (_loc_5.intersects(geometry))
                    {
                        this.drawFillSymbol(sprite, map, geometry, map.extent.expand(3));
                    }
                }
                else
                {
                    _loc_6 = geometry is Polygon ? (Polygon(geometry)) : (Extent(geometry).toPolygon());
                    _loc_7 = GeomUtils.intersects(map, _loc_6, _loc_6.extent);
                    if (_loc_7)
                    {
                    }
                    if (_loc_7.length > 0)
                    {
                        _loc_8 = new Polygon();
                        for each (_loc_9 in _loc_6.rings)
                        {
                            
                            for each (_loc_10 in _loc_7)
                            {
                                
                                _loc_11 = [];
                                for each (_loc_12 in _loc_9)
                                {
                                    
                                    _loc_13 = map.toScreenX(_loc_12.x);
                                    _loc_14 = map.toScreenY(_loc_12.y);
                                    _loc_11.push(map.toMap(new Point(_loc_13 + _loc_10, _loc_14)));
                                }
                                _loc_8.addRing(_loc_11);
                            }
                        }
                        this.drawFillSymbol(sprite, map, _loc_8, map.extent.expand(3));
                    }
                }
            }
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            sprite.graphics.clear();
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            sprite.graphics.clear();
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Array = null;
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            this.drawFillSymbol(_loc_4, null, null, null);
            if (shape)
            {
            }
            if (shape != FeatureTemplate.TOOL_POLYGON)
            {
            }
            if (shape != FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON)
            {
            }
            if (shape != FeatureTemplate.TOOL_RECTANGLE)
            {
                if (m_outline)
                {
                    _loc_5 = Math.min(m_outline.width, height);
                    _loc_6 = _loc_5 / 2;
                    this.m_stroke.weight = _loc_5 == 0 ? (-1) : (_loc_5);
                    this.m_stroke.color = m_outline.color;
                    this.m_stroke.alpha = m_outline.alpha;
                    if (m_outline.style != SimpleLineSymbol.STYLE_SOLID)
                    {
                    }
                    if (m_outline.style != SimpleLineSymbol.STYLE_NULL)
                    {
                        if (this.m_stroke.weight != 0)
                        {
                            this.m_stroke.apply(_loc_4.graphics, null, null);
                        }
                    }
                }
                switch(shape)
                {
                    case FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON:
                    case FeatureTemplate.TOOL_FREEHAND:
                    {
                        _loc_4.graphics.moveTo((width - _loc_6) * 0.25, (height - _loc_6) * 0.5);
                        _loc_4.graphics.curveTo(_loc_6, (height - _loc_6) * 0.25, (width - _loc_6) * 0.25, _loc_6);
                        _loc_4.graphics.curveTo((width - _loc_6) * 0.5, _loc_6 - 5, (width - _loc_6) * 0.75, _loc_6);
                        _loc_4.graphics.curveTo(width - _loc_6, (height - _loc_6) * 0.25, (width - _loc_6) * 0.75, (height - _loc_6) * 0.5);
                        _loc_4.graphics.curveTo(width - _loc_6, (height - _loc_6) * 0.75, (width - _loc_6) * 0.75, height - _loc_6);
                        _loc_4.graphics.curveTo((width - _loc_6) * 0.5, height - _loc_6 + 5, (width - _loc_6) * 0.25, height - _loc_6);
                        _loc_4.graphics.curveTo(_loc_6, (height - _loc_6) * 0.75, (width - _loc_6) * 0.25, (height - _loc_6) * 0.5);
                        break;
                    }
                    case FeatureTemplate.TOOL_CIRCLE:
                    {
                        _loc_7 = Math.min(width, height);
                        _loc_4.graphics.drawCircle(width * 0.5, height * 0.5, _loc_7 * 0.5);
                        break;
                    }
                    case FeatureTemplate.TOOL_ELLIPSE:
                    {
                        _loc_4.graphics.drawEllipse(0, 0, width, height);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else if (m_outline)
            {
                _loc_8 = Math.min(m_outline.width, height);
                _loc_9 = _loc_8 / 2;
                this.m_stroke.weight = _loc_8 == 0 ? (-1) : (_loc_8);
                this.m_stroke.color = m_outline.color;
                this.m_stroke.alpha = m_outline.alpha;
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (this.m_stroke.weight != 0)
                    {
                        this.m_stroke.apply(_loc_4.graphics, null, null);
                    }
                    _loc_4.graphics.drawRoundRect(_loc_9, _loc_9, width - _loc_8, height - _loc_8, (width + height) / 8);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    _loc_4.graphics.drawRoundRect(0, 0, width, height, (width + height) / 8);
                }
                else
                {
                    _loc_10 = [_loc_9, _loc_9, _loc_9, height - _loc_9, width - _loc_9, height - _loc_9, width - _loc_9, _loc_9, _loc_9, _loc_9];
                    _loc_4.graphics.drawRect(_loc_9, _loc_9, width - _loc_8, height - _loc_8);
                    _loc_4.graphics.endFill();
                    SymbolUtil.drawStyledLine(_loc_4, _loc_10, this.m_stroke, this.pattern);
                }
            }
            else
            {
                _loc_4.graphics.drawRoundRect(0, 0, width, height, (width + height) / 8);
            }
            _loc_4.graphics.endFill();
            return _loc_4;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"esriSFS"};
            _loc_2.style = REST_STYLES[this.style];
            if (this.style != STYLE_NULL)
            {
                _loc_2.color = SymbolFactory.colorAndAlphaToRGBA(this.color, this.alpha);
            }
            if (outline)
            {
                _loc_2.outline = outline.toJSON();
            }
            return _loc_2;
        }// end function

        private function drawFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            switch(this.m_style)
            {
                case STYLE_SOLID:
                {
                    this.drawSolidFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_VERTICAL:
                {
                    this.drawVerticalFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_HORIZONTAL:
                {
                    this.drawHorizontalFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_CROSS:
                {
                    this.drawCrossFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_DIAGONAL_CROSS:
                {
                    this.drawDiagonalCrossFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_FORWARD_DIAGONAL:
                {
                    this.drawForwardDiagonalFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_BACKWARD_DIAGONAL:
                {
                    this.drawBackwardDiagonalFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                case STYLE_NULL:
                {
                    this.drawNullFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
                default:
                {
                    this.drawSolidFillSymbol(sprite, map, geometry, mapExtent);
                    break;
                }
            }
            return;
        }// end function

        private function drawSolidFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            sprite.graphics.beginFill(this.m_color, this.m_alpha);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawVerticalFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_vertical;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawHorizontalFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_horizontal;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawCrossFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_cross;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawDiagonalCrossFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_diagonalcross;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawForwardDiagonalFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_forwarddiagonal;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawBackwardDiagonalFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            var _loc_5:* = SimpleFillSymbol_m_embed_backwarddiagonal;
            var _loc_6:* = new _loc_5 as Bitmap;
            this.stylingBitmap(_loc_6);
            sprite.graphics.beginBitmapFill(_loc_6.bitmapData);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawNullFillSymbol(sprite:Sprite, map:Map, geometry:Geometry, mapExtent:Extent) : void
        {
            sprite.graphics.beginFill(16777215, 0);
            if (map)
            {
            }
            if (geometry)
            {
            }
            if (mapExtent)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, sprite, geometry as Polygon, mapExtent);
                }
                else
                {
                    this.drawExtent(map, sprite, geometry as Extent, mapExtent);
                }
            }
            return;
        }// end function

        private function drawPolygon(map:Map, sprite:Sprite, polygon:Polygon, mapExtent:Extent) : void
        {
            var _loc_6:Boolean = false;
            var _loc_11:GraphicsPath = null;
            var _loc_18:uint = 0;
            var _loc_19:uint = 0;
            var _loc_20:uint = 0;
            var _loc_21:uint = 0;
            var _loc_22:uint = 0;
            var _loc_23:MapPoint = null;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_27:Vector.<MapPoint> = null;
            var _loc_28:Array = null;
            var _loc_29:uint = 0;
            var _loc_5:* = polygon.extent;
            var _loc_7:* = toScreenX(map, _loc_5.xmin);
            var _loc_8:* = toScreenX(map, _loc_5.xmax);
            var _loc_9:* = toScreenY(map, _loc_5.ymin);
            var _loc_10:* = toScreenY(map, _loc_5.ymax);
            sprite.x = _loc_7;
            sprite.y = _loc_10;
            sprite.width = _loc_8 - _loc_7;
            sprite.height = _loc_9 - _loc_10;
            if (m_outline)
            {
                _loc_6 = true;
                this.m_stroke.color = m_outline.color;
                this.m_stroke.weight = m_outline.width;
                this.m_stroke.alpha = m_outline.alpha;
            }
            var _loc_12:* = toScreenX(map, 0);
            var _loc_13:* = toScreenY(map, 0);
            var _loc_14:* = toScreenX(map, 1) - _loc_12;
            var _loc_15:* = toScreenY(map, 1) - _loc_13;
            _loc_12 = _loc_12 - sprite.x;
            _loc_13 = _loc_13 - sprite.y;
            var _loc_16:* = new Vector.<Number>;
            var _loc_17:* = new Vector.<int>;
            var _loc_26:* = new Vector.<Vector.<MapPoint>>;
            for each (_loc_28 in polygon.rings)
            {
                
                if (_loc_28.length > 0)
                {
                    _loc_27 = new Vector.<MapPoint>;
                    _loc_18 = _loc_16.length;
                    _loc_23 = _loc_28[0] as MapPoint;
                    _loc_24 = _loc_23.x * _loc_14 + _loc_12;
                    _loc_25 = _loc_23.y * _loc_15 + _loc_13;
                    _loc_21 = Math.round(_loc_24);
                    _loc_22 = Math.round(_loc_25);
                    _loc_16.push(_loc_21, _loc_22);
                    _loc_17.push(GraphicsPathCommand.MOVE_TO);
                    _loc_27.push(_loc_23);
                    _loc_29 = 1;
                    while (_loc_29 < _loc_28.length)
                    {
                        
                        _loc_23 = _loc_28[_loc_29] as MapPoint;
                        _loc_24 = _loc_23.x * _loc_14 + _loc_12;
                        _loc_25 = _loc_23.y * _loc_15 + _loc_13;
                        _loc_19 = Math.round(_loc_24);
                        _loc_20 = Math.round(_loc_25);
                        if (_loc_19 == _loc_21)
                        {
                        }
                        if (_loc_20 != _loc_22)
                        {
                            _loc_16.push(_loc_19, _loc_20);
                            _loc_17.push(GraphicsPathCommand.LINE_TO);
                            _loc_21 = _loc_19;
                            _loc_22 = _loc_20;
                            _loc_27.push(_loc_23);
                        }
                        _loc_29 = _loc_29 + 1;
                    }
                    if (_loc_16.length > 4)
                    {
                        if (_loc_16[_loc_18] == _loc_16[_loc_16.length - 2])
                        {
                        }
                        if (_loc_16[(_loc_18 + 1)] != _loc_16[(_loc_16.length - 1)])
                        {
                            _loc_16.push(_loc_16[_loc_18], _loc_16[(_loc_18 + 1)]);
                            _loc_17.push(GraphicsPathCommand.LINE_TO);
                            _loc_27.push(_loc_28[0]);
                        }
                    }
                    if (_loc_27.length > 1)
                    {
                        _loc_26.push(_loc_27);
                    }
                }
            }
            if (_loc_17.length > 0)
            {
                _loc_11 = new GraphicsPath(_loc_17, _loc_16);
                this.tracePolygon(map, sprite, _loc_11, this.m_stroke, _loc_6);
            }
            sprite.graphics.endFill();
            if (_loc_17.length > 0)
            {
            }
            if (m_outline)
            {
            }
            if (m_outline.style != SimpleLineSymbol.STYLE_SOLID)
            {
            }
            if (m_outline.style != SimpleLineSymbol.STYLE_NULL)
            {
                for each (_loc_27 in _loc_26)
                {
                    
                    this.traceSegmentStyledLine(map, mapExtent, sprite, this.m_stroke, _loc_27);
                }
            }
            return;
        }// end function

        private function tracePolygon(map:Map, sprite:Sprite, graphicPath:GraphicsPath, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (stroke.weight != 0)
                    {
                        stroke.apply(sprite.graphics, null, null);
                    }
                    this.graphicsFilling(map, sprite, graphicPath);
                }
                else
                {
                    this.graphicsFilling(map, sprite, graphicPath);
                }
            }
            else
            {
                this.graphicsFilling(map, sprite, graphicPath);
            }
            return;
        }// end function

        private function graphicsFilling(map:Map, sprite:Sprite, path:GraphicsPath) : void
        {
            sprite.graphics.drawPath(path.commands, path.data);
            return;
        }// end function

        private function traceSegmentStyledLine(map:Map, mapExtent:Extent, sprite:Sprite, stroke:SolidColorStroke, arrOfStyledPoints:Vector.<MapPoint>) : void
        {
            var _loc_9:MapPoint = null;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            this.closePolygon(arrOfStyledPoints);
            var _loc_6:* = arrOfStyledPoints[0];
            var _loc_7:Array = [];
            var _loc_8:int = 1;
            while (_loc_8 < arrOfStyledPoints.length)
            {
                
                _loc_9 = arrOfStyledPoints[_loc_8];
                if (_loc_9.x == _loc_6.x)
                {
                }
                if (_loc_9.y != _loc_6.y)
                {
                    _loc_10 = toScreenX(map, _loc_6.x);
                    _loc_11 = toScreenY(map, _loc_6.y);
                    _loc_12 = toScreenX(map, _loc_9.x);
                    _loc_13 = toScreenY(map, _loc_9.y);
                    _loc_7.push(_loc_10 - sprite.x);
                    _loc_7.push(_loc_11 - sprite.y);
                    _loc_7.push(_loc_12 - sprite.x);
                    _loc_7.push(_loc_13 - sprite.y);
                }
                _loc_6 = _loc_9;
                _loc_8 = _loc_8 + 1;
            }
            SymbolUtil.drawStyledLine(sprite, _loc_7, stroke, this.pattern);
            return;
        }// end function

        private function closePolygon(arrPoints:Vector.<MapPoint>) : void
        {
            if (arrPoints[(arrPoints.length - 1)].x == arrPoints[0].x)
            {
            }
            if (arrPoints[(arrPoints.length - 1)].y != arrPoints[0].y)
            {
                arrPoints.push(arrPoints[0]);
            }
            return;
        }// end function

        private function drawExtent(map:Map, sprite:Sprite, extent:Extent, mapExtent:Extent) : void
        {
            var _loc_14:Boolean = false;
            var _loc_15:Boolean = false;
            var _loc_16:MapPoint = null;
            var _loc_17:GraphicsPath = null;
            var _loc_18:Vector.<Number> = null;
            var _loc_19:Vector.<int> = null;
            var _loc_20:Array = null;
            var _loc_5:* = toScreenX(map, extent.xmin);
            var _loc_6:* = toScreenY(map, extent.ymin);
            var _loc_7:* = toScreenX(map, extent.xmax);
            var _loc_8:* = toScreenY(map, extent.ymax);
            sprite.x = _loc_5;
            sprite.y = _loc_8;
            sprite.width = _loc_7 - _loc_5;
            sprite.height = _loc_6 - _loc_8;
            var _loc_9:Number = 0;
            var _loc_10:Number = 0;
            var _loc_11:* = _loc_7 - _loc_5;
            var _loc_12:* = _loc_6 - _loc_8;
            var _loc_13:* = new Vector.<MapPoint>;
            _loc_13.push(new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmax, extent.ymax), new MapPoint(extent.xmax, extent.ymin));
            if (m_outline)
            {
                _loc_14 = true;
                this.m_stroke.color = m_outline.color;
                this.m_stroke.weight = m_outline.width == 0 ? (-1) : (m_outline.width);
                this.m_stroke.alpha = m_outline.alpha;
            }
            if (mapExtent.contains(extent))
            {
                this.traceExtent(map, mapExtent, sprite, _loc_9, _loc_10, _loc_11, _loc_12, _loc_13, this.m_stroke, _loc_14);
            }
            else if (mapExtent.disjointExtent(extent))
            {
            }
            else if (extent.contains(mapExtent))
            {
                _loc_15 = true;
                for each (_loc_16 in _loc_13)
                {
                    
                    if (mapExtent.contains(_loc_16))
                    {
                        _loc_15 = false;
                        break;
                    }
                }
                if (_loc_15)
                {
                    _loc_18 = new Vector.<Number>;
                    _loc_19 = new Vector.<int>;
                    _loc_20 = [];
                    _loc_19.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
                    _loc_18.push(toScreenX(map, mapExtent.xmin) - sprite.x, toScreenY(map, mapExtent.ymax) - sprite.y, toScreenX(map, mapExtent.xmin) - sprite.x, toScreenY(map, mapExtent.ymin) - sprite.y, toScreenX(map, mapExtent.xmax) - sprite.x, toScreenY(map, mapExtent.ymin) - sprite.y, toScreenX(map, mapExtent.xmax) - sprite.x, toScreenY(map, mapExtent.ymax) - sprite.y, toScreenX(map, mapExtent.xmin) - sprite.x, toScreenY(map, mapExtent.ymax) - sprite.y);
                    _loc_17 = new GraphicsPath(_loc_19, _loc_18);
                    this.graphicsFilling(map, sprite, _loc_17);
                }
                else
                {
                    this.traceClippedExtent(map, mapExtent, sprite, _loc_13, this.m_stroke, _loc_14);
                }
            }
            else
            {
                this.traceClippedExtent(map, mapExtent, sprite, _loc_13, this.m_stroke, _loc_14);
            }
            sprite.graphics.endFill();
            return;
        }// end function

        private function traceExtent(map:Map, mapExtent:Extent, sprite:Sprite, px0:Number, py0:Number, px1:Number, py1:Number, arrOfMapPoints:Vector.<MapPoint>, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            var _loc_11:Array = null;
            var _loc_12:Array = null;
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (stroke.weight != 0)
                    {
                        stroke.apply(sprite.graphics, null, null);
                    }
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                }
                else
                {
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                    sprite.graphics.endFill();
                    _loc_11 = [px0, py0, px1, py0, px1, py1, px0, py1, px0, py0];
                    if (px1 != px0)
                    {
                    }
                    if (py1 == py0)
                    {
                        _loc_12 = [_loc_11[0], _loc_11[1], _loc_11[4], _loc_11[5]];
                        SymbolUtil.drawStyledLine(sprite, _loc_12, stroke, m_outline.pattern);
                    }
                    else
                    {
                        SymbolUtil.drawStyledLine(sprite, _loc_11, stroke, m_outline.pattern);
                    }
                }
            }
            else
            {
                sprite.graphics.drawRect(px0, py0, px1, py1);
            }
            return;
        }// end function

        private function traceClippedExtent(map:Map, mapExtent:Extent, sprite:Sprite, arrOfMapPoints:Vector.<MapPoint>, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:MapPoint = null;
            var _loc_7:* = arrOfMapPoints.slice();
            this.m_arrClippedBySidePoints = new Vector.<MapPoint>;
            this.runBySideClipping(_loc_7, mapExtent, "left");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = new Vector.<MapPoint>;
            this.runBySideClipping(_loc_7, mapExtent, "right");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = new Vector.<MapPoint>;
            this.runBySideClipping(_loc_7, mapExtent, "top");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = new Vector.<MapPoint>;
            this.runBySideClipping(_loc_7, mapExtent, "bottom");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.closePolygon(_loc_7);
            var _loc_8:* = new GraphicsPath();
            var _loc_9:Array = [];
            for each (_loc_12 in _loc_7)
            {
                
                _loc_10 = toScreenX(map, _loc_12.x) - sprite.x;
                _loc_11 = toScreenY(map, _loc_12.y) - sprite.y;
                _loc_9.push(_loc_10, _loc_11);
                _loc_8.lineTo(_loc_10, _loc_11);
            }
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (this.m_stroke.weight != 0)
                    {
                        this.m_stroke.apply(sprite.graphics, null, null);
                    }
                    this.graphicsFilling(map, sprite, _loc_8);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    this.graphicsFilling(map, sprite, _loc_8);
                }
                else
                {
                    this.graphicsFilling(map, sprite, _loc_8);
                    sprite.graphics.endFill();
                    SymbolUtil.drawStyledLine(sprite, _loc_9, this.m_stroke, this.pattern);
                }
            }
            else
            {
                this.graphicsFilling(map, sprite, _loc_8);
            }
            return;
        }// end function

        private function stylingBitmap(fillBitmap:Bitmap) : void
        {
            var _loc_2:* = new Rectangle(0, 0, fillBitmap.width, fillBitmap.height);
            var _loc_3:* = new ColorTransform();
            _loc_3.alphaMultiplier = this.m_alpha;
            _loc_3.color = this.m_color;
            fillBitmap.bitmapData.colorTransform(_loc_2, _loc_3);
            return;
        }// end function

        private function runBySideClipping(arrClippedPoints:Vector.<MapPoint>, extent:Extent, side:String) : void
        {
            var _loc_8:int = 0;
            var _loc_4:* = new MapPoint(extent.xmin, extent.ymin);
            var _loc_5:* = new MapPoint(extent.xmax, extent.ymax);
            var _loc_6:* = new MapPoint(extent.xmax, extent.ymin);
            var _loc_7:* = new MapPoint(extent.xmin, extent.ymax);
            switch(side)
            {
                case "left":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_7, _loc_4, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_7, _loc_4, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "right":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_6, _loc_5, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_6, _loc_5, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "top":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_4, _loc_6, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_4, _loc_6, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "bottom":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_5, _loc_7, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_5, _loc_7, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function getOutput(vertex1:int, vertex2:int, point1:MapPoint, point2:MapPoint, extent:Extent, arrClippedPoints:Vector.<MapPoint>, side:String) : void
        {
            switch(side)
            {
                case "left":
                {
                    if (arrClippedPoints[vertex1].x >= extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x >= extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].x >= extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x < extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x < extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x < extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x < extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x >= extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "right":
                {
                    if (arrClippedPoints[vertex1].x <= extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x <= extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].x <= extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x > extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x > extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x > extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x > extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x <= extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "top":
                {
                    if (arrClippedPoints[vertex1].y >= extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y >= extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].y >= extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y < extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y < extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y < extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y < extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y >= extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "bottom":
                {
                    if (arrClippedPoints[vertex1].y <= extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y <= extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].y <= extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y > extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y > extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y > extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y > extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y <= extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function clipping(v1:MapPoint, v2:MapPoint, vc1:MapPoint, vc2:MapPoint, clippingOption:String) : void
        {
            var _loc_6:MapPoint = null;
            switch(clippingOption)
            {
                case "InsideInside":
                {
                    this.m_arrClippedBySidePoints.push(new MapPoint(v2.x, v2.y));
                    break;
                }
                case "InsideOutside":
                {
                    _loc_6 = this.intersect(v1, v2, vc1, vc2);
                    this.m_arrClippedBySidePoints.push(_loc_6);
                    break;
                }
                case "OutsideOutside":
                {
                    break;
                }
                case "OutsideInside":
                {
                    _loc_6 = this.intersect(v1, v2, vc1, vc2);
                    this.m_arrClippedBySidePoints.push(_loc_6);
                    this.m_arrClippedBySidePoints.push(new MapPoint(v2.x, v2.y));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function intersect(v1:MapPoint, v2:MapPoint, vc1:MapPoint, vc2:MapPoint) : MapPoint
        {
            var _loc_5:* = this.det(this.det(v1.x, v1.y, v2.x, v2.y), v1.x - v2.x, this.det(vc1.x, vc1.y, vc2.x, vc2.y), vc1.x - vc2.x) / this.det(v1.x - v2.x, v1.y - v2.y, vc1.x - vc2.x, vc1.y - vc2.y);
            var _loc_6:* = this.det(this.det(v1.x, v1.y, v2.x, v2.y), v1.y - v2.y, this.det(vc1.x, vc1.y, vc2.x, vc2.y), vc1.y - vc2.y) / this.det(v1.x - v2.x, v1.y - v2.y, vc1.x - vc2.x, vc1.y - vc2.y);
            return new MapPoint(_loc_5, _loc_6);
        }// end function

        private function det(a:Number, b:Number, c:Number, d:Number) : Number
        {
            return a * d - b * c;
        }// end function

        public function set style(value:String) : void
        {
            arguments = this.style;
            if (arguments !== value)
            {
                this._109780401style = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "style", arguments, value));
                }
            }
            return;
        }// end function

        public function set color(value:uint) : void
        {
            arguments = this.color;
            if (arguments !== value)
            {
                this._94842723color = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "color", arguments, value));
                }
            }
            return;
        }// end function

        public function set alpha(value:Number) : void
        {
            arguments = this.alpha;
            if (arguments !== value)
            {
                this._92909918alpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "alpha", arguments, value));
                }
            }
            return;
        }// end function

        static function get defaultSymbol() : Symbol
        {
            if (m_defaultSymbol == null)
            {
                m_defaultSymbol = new SimpleFillSymbol;
            }
            return m_defaultSymbol;
        }// end function

        public static function fromJSON(obj:Object) : SimpleFillSymbol
        {
            return SymbolFactory.toSFS(obj);
        }// end function

        REST_STYLES[STYLE_SOLID] = "esriSFSSolid";
        REST_STYLES[STYLE_VERTICAL] = "esriSFSVertical";
        REST_STYLES[STYLE_HORIZONTAL] = "esriSFSHorizontal";
        REST_STYLES[STYLE_CROSS] = "esriSFSCross";
        REST_STYLES[STYLE_DIAGONAL_CROSS] = "esriSFSDiagonalCross";
        REST_STYLES[STYLE_FORWARD_DIAGONAL] = "esriSFSForwardDiagonal";
        REST_STYLES[STYLE_BACKWARD_DIAGONAL] = "esriSFSBackwardDiagonal";
        REST_STYLES[STYLE_NULL] = "esriSFSNull";
    }
}
