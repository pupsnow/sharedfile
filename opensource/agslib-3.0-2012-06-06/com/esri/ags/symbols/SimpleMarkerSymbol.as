package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.supportClasses.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;

    public class SimpleMarkerSymbol extends MarkerSymbol implements IJSONSupport
    {
        private var m_styleImpl:ISymbolStyle;
        var m_editModeOn:Boolean;
        private var m_style:String;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_size:Number;
        private var m_half:Number;
        private var m_outline:SimpleLineSymbol;
        public static const STYLE_CIRCLE:String = "circle";
        public static const STYLE_SQUARE:String = "square";
        public static const STYLE_DIAMOND:String = "diamond";
        public static const STYLE_CROSS:String = "cross";
        public static const STYLE_X:String = "x";
        public static const STYLE_TRIANGLE:String = "triangle";
        private static const REST_STYLES:Object = {};
        private static var m_defaultSymbol:Symbol;

        public function SimpleMarkerSymbol(style:String = "circle", size:Number = 15, color:Number = 0, alpha:Number = 1, xoffset:Number = 0, yoffset:Number = 0, angle:Number = 0, outline:SimpleLineSymbol = null)
        {
            this.m_style = style;
            this.m_size = size;
            this.m_half = size * 0.5;
            this.m_color = color;
            this.m_alpha = alpha;
            m_xoffset = xoffset;
            m_yoffset = yoffset;
            m_angle = angle;
            this.m_outline = outline;
            this.updateStyleImpl();
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
                this.updateStyleImpl();
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

        public function get size() : Number
        {
            return this.m_size;
        }// end function

        private function set _3530753size(value:Number) : void
        {
            if (value != this.m_size)
            {
                this.m_size = value;
                this.m_half = value * 0.5;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get outline() : SimpleLineSymbol
        {
            return this.m_outline;
        }// end function

        private function set _1106245566outline(value:SimpleLineSymbol) : void
        {
            if (this.m_outline)
            {
                this.m_outline.removeEventListener(Event.CHANGE, this.onOutlineChange);
            }
            this.m_outline = value;
            if (this.m_outline)
            {
                this.m_outline.addEventListener(Event.CHANGE, this.onOutlineChange);
            }
            dispatchEventChange();
            return;
        }// end function

        function onOutlineChange(event:Event) : void
        {
            dispatchEventChange();
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var _loc_6:Array = null;
            var _loc_7:Multipoint = null;
            var _loc_8:Multipoint = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Multipoint = null;
            var _loc_13:Extent = null;
            var _loc_14:Array = null;
            var _loc_15:MapPoint = null;
            var _loc_16:Multipoint = null;
            var _loc_17:Multipoint = null;
            var _loc_18:MapPoint = null;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:Array = null;
            var _loc_23:Polyline = null;
            var _loc_24:Polyline = null;
            var _loc_25:Array = null;
            var _loc_26:Number = NaN;
            var _loc_27:Array = null;
            var _loc_28:Array = null;
            var _loc_29:MapPoint = null;
            var _loc_30:Number = NaN;
            var _loc_31:Number = NaN;
            var _loc_32:Array = null;
            var _loc_33:Polygon = null;
            var _loc_34:Polygon = null;
            var _loc_35:Array = null;
            var _loc_36:Number = NaN;
            var _loc_37:Array = null;
            var _loc_38:Array = null;
            var _loc_39:MapPoint = null;
            var _loc_40:Number = NaN;
            var _loc_41:Number = NaN;
            var _loc_42:Polygon = null;
            var _loc_43:Array = null;
            var _loc_44:Polygon = null;
            var _loc_45:Polygon = null;
            var _loc_46:Array = null;
            var _loc_47:Number = NaN;
            var _loc_48:Array = null;
            var _loc_49:Array = null;
            var _loc_50:MapPoint = null;
            var _loc_51:Number = NaN;
            var _loc_52:Number = NaN;
            removeAllChildren(sprite);
            if (!geometry)
            {
                return;
            }
            var _loc_5:* = map.extentExpanded;
            if (!map.wrapAround180)
            {
                if (_loc_5.intersects(geometry))
                {
                    if (geometry is MapPoint)
                    {
                        this.drawPoint(sprite, this.m_size, this.m_half, map, geometry as MapPoint);
                    }
                    else
                    {
                        this.drawMultipoint(map, sprite, geometry, geometry);
                    }
                    showAllChildren(sprite);
                }
                else
                {
                    hideAllChildren(sprite);
                }
            }
            else
            {
                switch(geometry.type)
                {
                    case Geometry.MAPPOINT:
                    {
                        _loc_6 = GeomUtils.intersects(map, geometry, new Extent(MapPoint(geometry).x, MapPoint(geometry).y, MapPoint(geometry).x, MapPoint(geometry).y, geometry.spatialReference));
                        if (_loc_6)
                        {
                        }
                        if (_loc_6.length > 0)
                        {
                            _loc_7 = new Multipoint();
                            _loc_8 = new Multipoint();
                            _loc_9 = map.toScreenX(MapPoint(geometry).x);
                            _loc_10 = map.toScreenY(MapPoint(geometry).y);
                            for each (_loc_11 in _loc_6)
                            {
                                
                                _loc_7.addPoint(map.toMap(new Point(_loc_9 + _loc_11, _loc_10)));
                                _loc_8.addPoint(MapPoint(geometry));
                            }
                            this.drawMultipoint(map, sprite, _loc_7, _loc_8);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        _loc_12 = geometry as Multipoint;
                        if (!_loc_12.points)
                        {
                            return;
                        }
                        if (_loc_12.points.length == 1)
                        {
                            _loc_15 = _loc_12.points[0] as MapPoint;
                            _loc_13 = new Extent(_loc_15.x, _loc_15.y, _loc_15.x, _loc_15.y, geometry.spatialReference);
                        }
                        else if (_loc_12.points.length > 1)
                        {
                            _loc_13 = geometry.extent;
                        }
                        _loc_14 = GeomUtils.intersects(map, geometry, _loc_13);
                        if (_loc_14)
                        {
                        }
                        if (_loc_14.length > 0)
                        {
                            _loc_16 = new Multipoint();
                            _loc_17 = new Multipoint();
                            for each (_loc_18 in Multipoint(geometry).points)
                            {
                                
                                _loc_19 = map.toScreenX(_loc_18.x);
                                _loc_20 = map.toScreenY(_loc_18.y);
                                for each (_loc_21 in _loc_14)
                                {
                                    
                                    _loc_16.addPoint(map.toMap(new Point(_loc_19 + _loc_21, _loc_20)));
                                    _loc_17.addPoint(_loc_18);
                                }
                            }
                            this.drawMultipoint(map, sprite, _loc_16, _loc_17);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        _loc_22 = GeomUtils.intersects(map, geometry, geometry.extent);
                        if (_loc_22)
                        {
                        }
                        if (_loc_22.length > 0)
                        {
                            _loc_23 = new Polyline();
                            _loc_24 = new Polyline();
                            for each (_loc_25 in Polyline(geometry).paths)
                            {
                                
                                for each (_loc_26 in _loc_22)
                                {
                                    
                                    _loc_27 = [];
                                    _loc_28 = [];
                                    for each (_loc_29 in _loc_25)
                                    {
                                        
                                        _loc_30 = map.toScreenX(_loc_29.x);
                                        _loc_31 = map.toScreenY(_loc_29.y);
                                        _loc_27.push(map.toMap(new Point(_loc_30 + _loc_26, _loc_31)));
                                        _loc_28.push(_loc_29);
                                    }
                                    _loc_23.addPath(_loc_27);
                                    _loc_24.addPath(_loc_28);
                                }
                            }
                            this.drawMultipoint(map, sprite, _loc_23, _loc_24);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        _loc_32 = GeomUtils.intersects(map, geometry, geometry.extent);
                        if (_loc_32)
                        {
                        }
                        if (_loc_32.length > 0)
                        {
                            _loc_33 = new Polygon();
                            _loc_34 = new Polygon();
                            for each (_loc_35 in Polygon(geometry).rings)
                            {
                                
                                for each (_loc_36 in _loc_32)
                                {
                                    
                                    _loc_37 = [];
                                    _loc_38 = [];
                                    for each (_loc_39 in _loc_35)
                                    {
                                        
                                        _loc_40 = map.toScreenX(_loc_39.x);
                                        _loc_41 = map.toScreenY(_loc_39.y);
                                        _loc_37.push(map.toMap(new Point(_loc_40 + _loc_36, _loc_41)));
                                        _loc_38.push(_loc_39);
                                    }
                                    _loc_33.addRing(_loc_37);
                                    _loc_34.addRing(_loc_38);
                                }
                            }
                            this.drawMultipoint(map, sprite, _loc_33, _loc_34);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        _loc_42 = Extent(geometry).toPolygon();
                        _loc_43 = GeomUtils.intersects(map, _loc_42, _loc_42.extent);
                        if (_loc_43)
                        {
                        }
                        if (_loc_43.length > 0)
                        {
                            _loc_44 = new Polygon();
                            _loc_45 = new Polygon();
                            for each (_loc_46 in _loc_42.rings)
                            {
                                
                                for each (_loc_47 in _loc_43)
                                {
                                    
                                    _loc_48 = [];
                                    _loc_49 = [];
                                    for each (_loc_50 in _loc_46)
                                    {
                                        
                                        _loc_51 = map.toScreenX(_loc_50.x);
                                        _loc_52 = map.toScreenY(_loc_50.y);
                                        _loc_48.push(map.toMap(new Point(_loc_51 + _loc_47, _loc_52)));
                                        _loc_49.push(_loc_50);
                                    }
                                    _loc_44.addRing(_loc_48);
                                    _loc_45.addRing(_loc_49);
                                }
                            }
                            this.drawMultipoint(map, sprite, _loc_44, _loc_45);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                        break;
                    }
                    default:
                    {
                        break;
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
            removeAllChildren(sprite);
            sprite.graphics.clear();
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            var _loc_5:* = new UIComponent();
            _loc_4.addChild(_loc_5);
            var _loc_6:* = width * 0.5;
            var _loc_7:* = height * 0.5;
            var _loc_8:* = Math.min(this.m_size, width, height);
            this.drawPoint(_loc_5, _loc_8, _loc_8 * 0.5, null, null, _loc_6, _loc_7);
            return _loc_4;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"esriSMS"};
            _loc_2.style = REST_STYLES[this.style];
            _loc_2.color = SymbolFactory.colorAndAlphaToRGBA(this.color, this.alpha);
            _loc_2.size = SymbolFactory.pxToPt(this.size);
            if (isFinite(angle))
            {
                isFinite(angle);
            }
            if (angle != 0)
            {
                _loc_2.angle = -angle;
            }
            if (isFinite(xoffset))
            {
                isFinite(xoffset);
            }
            if (xoffset != 0)
            {
                _loc_2.xoffset = SymbolFactory.pxToPt(xoffset);
            }
            if (isFinite(yoffset))
            {
                isFinite(yoffset);
            }
            if (yoffset != 0)
            {
                _loc_2.yoffset = SymbolFactory.pxToPt(yoffset);
            }
            if (this.outline)
            {
                if (this.style != STYLE_CROSS)
                {
                }
                if (this.style == STYLE_X)
                {
                    _loc_2.outline = {color:_loc_2.color, width:SymbolFactory.pxToPt(this.outline.width / 2)};
                }
                else
                {
                    _loc_2.outline = {color:SymbolFactory.colorAndAlphaToRGBA(this.outline.color, this.outline.alpha), width:SymbolFactory.pxToPt(this.outline.width)};
                }
            }
            return _loc_2;
        }// end function

        private function drawPoint(sprite:Sprite, size:Number, half:Number, map:Map, point:MapPoint, centerX:Number = 0, centerY:Number = 0) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_8:* = sprite as UIComponent;
            if (map)
            {
            }
            if (point)
            {
                _loc_9 = isFinite(xoffset) ? (xoffset) : (0);
                _loc_10 = isFinite(yoffset) ? (yoffset) : (0);
                _loc_8.move(toScreenX(map, point.x) - half + _loc_9, toScreenY(map, point.y) - half - _loc_10);
                _loc_8.setActualSize(size, size);
            }
            else
            {
                _loc_8.move(centerX - half, centerY - half);
                _loc_8.setActualSize(size, size);
            }
            this.m_styleImpl.drawGeometry(_loc_8, point, half, half);
            return;
        }// end function

        private function drawMultipoint(map:Map, sprite:Sprite, geometry:Geometry, originalGeometry:Geometry) : void
        {
            var _loc_6:Multipoint = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Polyline = null;
            var _loc_10:Array = null;
            var _loc_11:Array = null;
            var _loc_12:Polygon = null;
            var _loc_13:Array = null;
            var _loc_14:Array = null;
            var _loc_15:Extent = null;
            var _loc_16:Array = null;
            var _loc_17:Array = null;
            var _loc_5:* = geometry.extent;
            if (geometry is Multipoint)
            {
                _loc_6 = geometry as Multipoint;
                if (_loc_6.points.length == 0)
                {
                    return;
                }
                if (_loc_6.points.length == 1)
                {
                    this.drawPoint(sprite, this.m_size, this.m_half, map, _loc_6.points[0] as MapPoint, 0, 0);
                }
                else
                {
                    _loc_7 = _loc_6.points.slice();
                    _loc_8 = (originalGeometry as Multipoint).points.slice();
                    this.traceMultipointGeometry(map, sprite, _loc_7, _loc_8, _loc_5);
                }
            }
            else
            {
                if (sprite is CompositeSymbolComponent)
                {
                }
                if (geometry is Polyline)
                {
                    _loc_9 = geometry as Polyline;
                    _loc_10 = this.getPolylinePoints(_loc_9);
                    _loc_11 = this.getPolylinePoints(Polyline(originalGeometry));
                    this.traceMultipointGeometry(map, sprite, _loc_10, _loc_11, _loc_5);
                }
                else
                {
                    if (sprite is CompositeSymbolComponent)
                    {
                    }
                    if (geometry is Polygon)
                    {
                        _loc_12 = geometry as Polygon;
                        _loc_13 = this.getPolygonPoints(_loc_12);
                        _loc_14 = this.getPolygonPoints(Polygon(originalGeometry));
                        this.traceMultipointGeometry(map, sprite, _loc_13, _loc_14, _loc_5);
                    }
                    else
                    {
                        if (sprite is CompositeSymbolComponent)
                        {
                        }
                        if (geometry is Extent)
                        {
                            _loc_15 = geometry as Extent;
                            _loc_16 = this.getExtentPoints(_loc_15);
                            _loc_17 = this.getExtentPoints(Extent(originalGeometry));
                            this.traceMultipointGeometry(map, sprite, _loc_16, _loc_17, _loc_5);
                        }
                    }
                }
            }
            return;
        }// end function

        private function getPolylinePoints(polyline:Polyline) : Array
        {
            var _loc_4:Array = null;
            var _loc_5:Number = NaN;
            var _loc_2:Array = [];
            var _loc_3:Array = [];
            for each (_loc_4 in polyline.paths.slice())
            {
                
                if (_loc_4.length > 1)
                {
                    if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                    {
                    }
                    _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                }
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_2.push(_loc_3[_loc_5] as MapPoint);
                    _loc_5 = _loc_5 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function getPolygonPoints(polygon:Polygon) : Array
        {
            var _loc_4:Array = null;
            var _loc_5:Number = NaN;
            var _loc_2:Array = [];
            var _loc_3:Array = [];
            for each (_loc_4 in polygon.rings.slice())
            {
                
                if (_loc_4.length > 1)
                {
                    if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                    {
                    }
                    _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                }
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_2.push(_loc_3[_loc_5] as MapPoint);
                    _loc_5 = _loc_5 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function getExtentPoints(extent:Extent) : Array
        {
            var _loc_2:Array = [];
            _loc_2.push(new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmax, extent.ymin), new MapPoint(extent.xmax, extent.ymax));
            return _loc_2;
        }// end function

        private function traceMultipointGeometry(map:Map, sprite:Sprite, arrOfPoints:Array, arrOfOriginalPoints:Array, multipointExtent:Extent) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:MapPoint = null;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Sprite = null;
            if (multipointExtent != null)
            {
                _loc_9 = toScreenX(map, multipointExtent.xmin);
                _loc_10 = toScreenY(map, multipointExtent.ymin);
                _loc_11 = toScreenX(map, multipointExtent.xmax);
                _loc_12 = toScreenY(map, multipointExtent.ymax);
                sprite.x = _loc_9 - this.m_half;
                sprite.y = _loc_12 - this.m_half;
                sprite.width = _loc_11 + this.m_size - _loc_9;
                sprite.height = _loc_10 + this.m_size - _loc_12;
            }
            var _loc_6:* = isFinite(xoffset) ? (xoffset) : (0);
            var _loc_7:* = isFinite(yoffset) ? (yoffset) : (0);
            var _loc_8:int = 0;
            while (_loc_8 < arrOfPoints.length)
            {
                
                _loc_13 = arrOfPoints[_loc_8];
                _loc_14 = toScreenX(map, _loc_13.x) - sprite.x + _loc_6;
                _loc_15 = toScreenY(map, _loc_13.y) - sprite.y - _loc_7;
                _loc_16 = sprite;
                if (this.m_editModeOn)
                {
                    _loc_13 = arrOfOriginalPoints[_loc_8];
                    _loc_16 = new CustomSprite(_loc_13);
                    _loc_16.x = _loc_14;
                    _loc_16.y = _loc_15;
                    _loc_14 = 0;
                    _loc_15 = 0;
                    sprite.addChild(_loc_16);
                }
                this.m_styleImpl.drawGeometry(_loc_16, _loc_13, _loc_14, _loc_15);
                _loc_8 = _loc_8 + 1;
            }
            return;
        }// end function

        private function updateStyleImpl() : void
        {
            if (this.m_styleImpl)
            {
                this.m_styleImpl.symbol = null;
            }
            switch(this.m_style)
            {
                case STYLE_CIRCLE:
                {
                    this.m_styleImpl = new PointCircleStyle();
                    break;
                }
                case STYLE_SQUARE:
                {
                    this.m_styleImpl = new PointSquareStyle();
                    break;
                }
                case STYLE_DIAMOND:
                {
                    this.m_styleImpl = new PointDiamondStyle();
                    break;
                }
                case STYLE_CROSS:
                {
                    this.m_styleImpl = new PointCrossStyle();
                    break;
                }
                case STYLE_X:
                {
                    this.m_styleImpl = new PointXStyle();
                    break;
                }
                case STYLE_TRIANGLE:
                {
                    this.m_styleImpl = new PointTriangleStyle();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.m_styleImpl.symbol = this;
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

        public function set outline(value:SimpleLineSymbol) : void
        {
            arguments = this.outline;
            if (arguments !== value)
            {
                this._1106245566outline = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outline", arguments, value));
                }
            }
            return;
        }// end function

        public function set size(value:Number) : void
        {
            arguments = this.size;
            if (arguments !== value)
            {
                this._3530753size = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "size", arguments, value));
                }
            }
            return;
        }// end function

        static function get defaultSymbol() : Symbol
        {
            if (m_defaultSymbol == null)
            {
                m_defaultSymbol = new SimpleMarkerSymbol;
            }
            return m_defaultSymbol;
        }// end function

        public static function fromJSON(obj:Object) : SimpleMarkerSymbol
        {
            return SymbolFactory.toSMS(obj);
        }// end function

        REST_STYLES[STYLE_CIRCLE] = "esriSMSCircle";
        REST_STYLES[STYLE_SQUARE] = "esriSMSSquare";
        REST_STYLES[STYLE_DIAMOND] = "esriSMSDiamond";
        REST_STYLES[STYLE_CROSS] = "esriSMSCross";
        REST_STYLES[STYLE_X] = "esriSMSX";
        REST_STYLES[STYLE_TRIANGLE] = "esriSMSTriangle";
    }
}
