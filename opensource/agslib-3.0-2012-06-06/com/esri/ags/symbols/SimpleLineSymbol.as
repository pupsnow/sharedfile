package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;

    public class SimpleLineSymbol extends LineSymbol implements IJSONSupport
    {
        private var m_stroke:SolidColorStroke;
        private var m_style:String;
        private var m_pattern:Array;
        public static const STYLE_SOLID:String = "solid";
        public static const STYLE_DASH:String = "dash";
        public static const STYLE_DOT:String = "dot";
        public static const STYLE_DASHDOT:String = "dashdot";
        public static const STYLE_DASHDOTDOT:String = "dashdotdot";
        public static const STYLE_NULL:String = "none";
        private static const REST_STYLES:Object = {};
        private static var m_defaultSymbol:Symbol;

        public function SimpleLineSymbol(style:String = "solid", color:Number = 0, alpha:Number = 1, width:Number = 1)
        {
            this.m_stroke = new SolidColorStroke();
            this.m_style = style;
            m_color = color;
            m_alpha = alpha;
            m_width = width;
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
                this.m_pattern = null;
                dispatchEvent(new Event(Event.CHANGE));
            }
            return;
        }// end function

        function get pattern() : Array
        {
            if (!this.m_pattern)
            {
                switch(this.m_style)
                {
                    case STYLE_DASH:
                    {
                        this.m_pattern = [6, 6];
                        break;
                    }
                    case STYLE_DOT:
                    {
                        this.m_pattern = [1, 6];
                        break;
                    }
                    case STYLE_DASHDOT:
                    {
                        this.m_pattern = [6, 4, 1, 4];
                        break;
                    }
                    case STYLE_DASHDOTDOT:
                    {
                        this.m_pattern = [6, 4, 1, 4, 1, 4];
                        break;
                    }
                    default:
                    {
                        this.m_pattern = [1, 0];
                        break;
                    }
                }
            }
            return this.m_pattern;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var _loc_6:Polyline = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:MapPoint = null;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_5:* = map.extentExpanded;
            if (geometry is Polyline)
            {
                if (!map.wrapAround180)
                {
                    _loc_6 = geometry as Polyline;
                    if (_loc_5.intersects(_loc_6))
                    {
                        this.drawPolyline(sprite, _loc_6, map);
                    }
                }
                else
                {
                    _loc_6 = new Polyline();
                    _loc_7 = GeomUtils.intersects(map, geometry, geometry.extent);
                    _loc_8 = (geometry as Polyline).paths;
                    for each (_loc_9 in _loc_8)
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
                            _loc_6.addPath(_loc_11);
                        }
                    }
                    this.drawPolyline(sprite, _loc_6, map);
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
            var _loc_6:Array = null;
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            var _loc_5:* = Math.min(m_width, height);
            _loc_5 = Math.min(2, _loc_5);
            if (_loc_5 < 1)
            {
                _loc_5 = 1;
            }
            switch(this.m_style)
            {
                case STYLE_SOLID:
                {
                    if (_loc_5 > 0)
                    {
                        this.setLineStyle(_loc_4.graphics);
                        if (shape)
                        {
                            if (shape != FeatureTemplate.TOOL_FREEHAND)
                            {
                            }
                            if (shape != FeatureTemplate.TOOL_CIRCLE)
                            {
                            }
                            if (shape != FeatureTemplate.TOOL_ELLIPSE)
                            {
                            }
                        }
                        if (shape == FeatureTemplate.TOOL_RECTANGLE)
                        {
                            _loc_4.graphics.moveTo(_loc_5, height * 0.5);
                            _loc_4.graphics.curveTo((width - _loc_5) * 0.25, height * 0.25, (width - _loc_5) * 0.5, height * 0.5);
                            _loc_4.graphics.curveTo((width - _loc_5) * 0.75, height * 0.75, width - _loc_5, height * 0.5);
                        }
                        else
                        {
                            _loc_4.graphics.moveTo(_loc_5, height * 0.5);
                            _loc_4.graphics.lineTo(width - _loc_5, height * 0.5);
                        }
                    }
                    break;
                }
                case STYLE_NULL:
                {
                    break;
                }
                default:
                {
                    if (shape)
                    {
                        if (shape != FeatureTemplate.TOOL_FREEHAND)
                        {
                        }
                        if (shape != FeatureTemplate.TOOL_CIRCLE)
                        {
                        }
                        if (shape != FeatureTemplate.TOOL_ELLIPSE)
                        {
                        }
                    }
                    if (shape == FeatureTemplate.TOOL_RECTANGLE)
                    {
                        this.setLineStyle(_loc_4.graphics);
                        _loc_4.graphics.moveTo(_loc_5, height * 0.5);
                        _loc_4.graphics.curveTo((width - _loc_5) * 0.25, height * 0.25, (width - _loc_5) * 0.5, height * 0.5);
                        _loc_4.graphics.curveTo((width - _loc_5) * 0.75, height * 0.75, width - _loc_5, height * 0.5);
                    }
                    else
                    {
                        _loc_6 = [_loc_5, height * 0.5, width - _loc_5, height * 0.5];
                        SymbolUtil.drawStyledLine(_loc_4, _loc_6, this.m_stroke, this.pattern);
                    }
                    break;
                }
            }
            return _loc_4;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"esriSLS"};
            _loc_2.style = REST_STYLES[this.style];
            if (this.style != STYLE_NULL)
            {
                _loc_2.color = SymbolFactory.colorAndAlphaToRGBA(color, alpha);
            }
            _loc_2.width = SymbolFactory.pxToPt(width);
            return _loc_2;
        }// end function

        protected function setLineStyle(graphics:Graphics) : void
        {
            graphics.lineStyle(width, color, alpha, false, "normal", CapsStyle.NONE);
            return;
        }// end function

        private function drawPolyline(sprite:Sprite, polyline:Polyline, map:Map) : void
        {
            var _loc_4:* = polyline.extent;
            var _loc_5:* = toScreenX(map, _loc_4.xmin);
            var _loc_6:* = toScreenX(map, _loc_4.xmax);
            var _loc_7:* = toScreenY(map, _loc_4.ymin);
            var _loc_8:* = toScreenY(map, _loc_4.ymax);
            sprite.x = _loc_5;
            sprite.y = _loc_8;
            sprite.width = _loc_6 - _loc_5;
            sprite.height = _loc_7 - _loc_8;
            switch(this.m_style)
            {
                case STYLE_SOLID:
                {
                    this.drawSolidPolyline(map, map.extent.expand(3), sprite, polyline);
                    break;
                }
                case STYLE_NULL:
                {
                    this.drawNullPolyline(map, map.extent.expand(3), sprite, polyline);
                    break;
                }
                default:
                {
                    this.drawStyledPolylines(map, map.extent.expand(3), sprite, polyline);
                    break;
                }
            }
            return;
        }// end function

        private function drawSolidPolyline(map:Map, mapExtent:Extent, sprite:Sprite, polyline:Polyline) : void
        {
            var _loc_5:Array = null;
            var _loc_6:MapPoint = null;
            var _loc_7:int = 0;
            var _loc_8:MapPoint = null;
            if (width > 0)
            {
                this.setLineStyle(sprite.graphics);
                for each (_loc_5 in polyline.paths)
                {
                    
                    if (_loc_5.length > 1)
                    {
                        _loc_6 = _loc_5[0];
                        sprite.graphics.moveTo(toScreenX(map, _loc_6.x) - sprite.x, toScreenY(map, _loc_6.y) - sprite.y);
                        _loc_7 = 1;
                        while (_loc_7 < _loc_5.length)
                        {
                            
                            _loc_8 = _loc_5[_loc_7];
                            if (_loc_8.x == _loc_6.x)
                            {
                            }
                            if (_loc_8.y != _loc_6.y)
                            {
                                this.drawSegmentPolyline(map, mapExtent, sprite, _loc_6, _loc_8);
                            }
                            _loc_6 = _loc_8;
                            _loc_7 = _loc_7 + 1;
                        }
                    }
                }
            }
            return;
        }// end function

        private function drawNullPolyline(map:Map, mapExtent:Extent, sprite:Sprite, polyline:Polyline) : void
        {
            return;
        }// end function

        private function drawStyledPolylines(map:Map, mapExtent:Extent, sprite:Sprite, polyline:Polyline) : void
        {
            var _loc_5:MapPoint = null;
            var _loc_6:MapPoint = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:int = 0;
            this.m_stroke.color = color;
            this.m_stroke.weight = width;
            this.m_stroke.alpha = alpha;
            for each (_loc_7 in polyline.paths)
            {
                
                if (_loc_7.length > 1)
                {
                    _loc_8 = [];
                    _loc_5 = _loc_7[0];
                    _loc_9 = 1;
                    while (_loc_9 < _loc_7.length)
                    {
                        
                        _loc_6 = _loc_7[_loc_9];
                        if (_loc_6.x == _loc_5.x)
                        {
                        }
                        if (_loc_6.y != _loc_5.y)
                        {
                            this.drawSegmentStyledPolyline(map, mapExtent, sprite, _loc_5, _loc_6, _loc_8);
                        }
                        _loc_5 = _loc_6;
                        _loc_9 = _loc_9 + 1;
                    }
                    if (_loc_8.length > 0)
                    {
                        SymbolUtil.drawStyledLine(sprite, _loc_8, this.m_stroke, this.pattern);
                    }
                }
            }
            return;
        }// end function

        private function drawSegmentPolyline(map:Map, mapExtent:Extent, sprite:Sprite, startPt:MapPoint, endPt:MapPoint) : void
        {
            var _loc_11:Array = null;
            var _loc_12:MapPoint = null;
            var _loc_13:MapPoint = null;
            var _loc_14:MapPoint = null;
            var _loc_6:* = toScreenX(map, startPt.x);
            var _loc_7:* = toScreenY(map, startPt.y);
            var _loc_8:* = toScreenX(map, endPt.x);
            var _loc_9:* = toScreenY(map, endPt.y);
            var _loc_10:* = Math.sqrt(Math.pow(_loc_8 - _loc_6, 2) + Math.pow(_loc_9 - _loc_7, 2));
            if (_loc_10 >= 32000)
            {
                _loc_11 = [];
                if (mapExtent.contains(startPt))
                {
                }
                if (!mapExtent.contains(endPt))
                {
                    _loc_11 = GeomUtils.clipLineExtent(startPt, endPt, mapExtent);
                    if (_loc_11.length == 0)
                    {
                    }
                    else if (_loc_11.length == 1)
                    {
                        _loc_12 = _loc_11[0];
                        if (!mapExtent.contains(startPt))
                        {
                        }
                        if (mapExtent.contains(endPt))
                        {
                            sprite.graphics.moveTo(toScreenX(map, _loc_12.x) - sprite.x, toScreenY(map, _loc_12.y) - sprite.y);
                            sprite.graphics.lineTo(_loc_8 - sprite.x, _loc_9 - sprite.y);
                        }
                        else
                        {
                            if (mapExtent.contains(startPt))
                            {
                                mapExtent.contains(startPt);
                            }
                            if (!mapExtent.contains(endPt))
                            {
                                sprite.graphics.lineTo(toScreenX(map, _loc_12.x) - sprite.x, toScreenY(map, _loc_12.y) - sprite.y);
                            }
                        }
                    }
                    else
                    {
                        _loc_13 = _loc_11[0];
                        _loc_14 = _loc_11[1];
                        sprite.graphics.moveTo(toScreenX(map, _loc_13.x) - sprite.x, toScreenY(map, _loc_13.y) - sprite.y);
                        sprite.graphics.lineTo(toScreenX(map, _loc_14.x) - sprite.x, toScreenY(map, _loc_14.y) - sprite.y);
                    }
                }
                else
                {
                    sprite.graphics.lineTo(_loc_8 - sprite.x, _loc_9 - sprite.y);
                }
            }
            else
            {
                sprite.graphics.lineTo(_loc_8 - sprite.x, _loc_9 - sprite.y);
            }
            return;
        }// end function

        private function drawSegmentStyledPolyline(map:Map, mapExtent:Extent, sprite:Sprite, startPt:MapPoint, endPt:MapPoint, arrOfPoints:Array) : void
        {
            var _loc_12:MapPoint = null;
            var _loc_13:MapPoint = null;
            var _loc_14:MapPoint = null;
            var _loc_7:* = toScreenX(map, startPt.x);
            var _loc_8:* = toScreenY(map, startPt.y);
            var _loc_9:* = toScreenX(map, endPt.x);
            var _loc_10:* = toScreenY(map, endPt.y);
            var _loc_11:Array = [];
            if (mapExtent.contains(startPt))
            {
            }
            if (!mapExtent.contains(endPt))
            {
                _loc_11 = GeomUtils.clipLineExtent(startPt, endPt, mapExtent);
                if (_loc_11.length == 0)
                {
                }
                else if (_loc_11.length == 1)
                {
                    _loc_12 = _loc_11[0];
                    if (!mapExtent.contains(startPt))
                    {
                    }
                    if (mapExtent.contains(endPt))
                    {
                        arrOfPoints.push(toScreenX(map, _loc_12.x) - sprite.x);
                        arrOfPoints.push(toScreenY(map, _loc_12.y) - sprite.y);
                        arrOfPoints.push(_loc_9 - sprite.x);
                        arrOfPoints.push(_loc_10 - sprite.y);
                    }
                    else
                    {
                        if (mapExtent.contains(startPt))
                        {
                            mapExtent.contains(startPt);
                        }
                        if (!mapExtent.contains(endPt))
                        {
                            arrOfPoints.push(_loc_7 - sprite.x);
                            arrOfPoints.push(_loc_8 - sprite.y);
                            arrOfPoints.push(toScreenX(map, _loc_12.x) - sprite.x);
                            arrOfPoints.push(toScreenY(map, _loc_12.y) - sprite.y);
                        }
                    }
                }
                else
                {
                    _loc_13 = _loc_11[0];
                    _loc_14 = _loc_11[1];
                    arrOfPoints.push(toScreenX(map, _loc_13.x) - sprite.x);
                    arrOfPoints.push(toScreenY(map, _loc_13.y) - sprite.y);
                    arrOfPoints.push(toScreenX(map, _loc_14.x) - sprite.x);
                    arrOfPoints.push(toScreenY(map, _loc_14.y) - sprite.y);
                }
            }
            else
            {
                arrOfPoints.push(_loc_7 - sprite.x);
                arrOfPoints.push(_loc_8 - sprite.y);
                arrOfPoints.push(_loc_9 - sprite.x);
                arrOfPoints.push(_loc_10 - sprite.y);
            }
            return;
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

        static function get defaultSymbol() : Symbol
        {
            if (m_defaultSymbol == null)
            {
                m_defaultSymbol = new SimpleLineSymbol;
            }
            return m_defaultSymbol;
        }// end function

        public static function fromJSON(obj:Object) : SimpleLineSymbol
        {
            return SymbolFactory.toSLS(obj);
        }// end function

        REST_STYLES[STYLE_SOLID] = "esriSLSSolid";
        REST_STYLES[STYLE_DASH] = "esriSLSDash";
        REST_STYLES[STYLE_DOT] = "esriSLSDot";
        REST_STYLES[STYLE_DASHDOT] = "esriSLSDashDot";
        REST_STYLES[STYLE_DASHDOTDOT] = "esriSLSDashDotDot";
        REST_STYLES[STYLE_NULL] = "esriSLSNull";
    }
}
