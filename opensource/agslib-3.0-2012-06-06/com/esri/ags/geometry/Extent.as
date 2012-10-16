package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class Extent extends Geometry implements IEventDispatcher
    {
        private var m_xmin:Number;
        private var m_xmax:Number;
        private var m_ymin:Number;
        private var m_ymax:Number;
        private var m_shifted:Extent;
        private var m_parts:Array;
        private var _eventDispatcher:EventDispatcher;
        public static const OUT_LEFT:int = 1;
        public static const OUT_TOP:int = 2;
        public static const OUT_RIGHT:int = 4;
        public static const OUT_BOTTOM:int = 8;

        public function Extent(xmin:Number = 0, ymin:Number = 0, xmax:Number = 0, ymax:Number = 0, spatialReference:SpatialReference = null)
        {
            this._eventDispatcher = new EventDispatcher(IEventDispatcher(this));
            this.m_xmin = xmin;
            this.m_ymin = ymin;
            this.m_xmax = xmax;
            this.m_ymax = ymax;
            if (spatialReference)
            {
                this.spatialReference = spatialReference;
            }
            return;
        }// end function

        override public function get type() : String
        {
            return EXTENT;
        }// end function

        override function get defaultSymbol() : Symbol
        {
            return SimpleFillSymbol.defaultSymbol;
        }// end function

        public function get xmin() : Number
        {
            return this.m_xmin;
        }// end function

        private function set _3683034xmin(value:Number) : void
        {
            this.m_xmin = value;
            this.m_parts = null;
            this.m_shifted = null;
            return;
        }// end function

        public function get xmax() : Number
        {
            return this.m_xmax;
        }// end function

        private function set _3682796xmax(value:Number) : void
        {
            this.m_xmax = value;
            this.m_parts = null;
            this.m_shifted = null;
            return;
        }// end function

        public function get ymin() : Number
        {
            return this.m_ymin;
        }// end function

        private function set _3712825ymin(value:Number) : void
        {
            this.m_ymin = value;
            this.m_parts = null;
            this.m_shifted = null;
            return;
        }// end function

        public function get ymax() : Number
        {
            return this.m_ymax;
        }// end function

        private function set _3712587ymax(value:Number) : void
        {
            this.m_ymax = value;
            this.m_parts = null;
            this.m_shifted = null;
            return;
        }// end function

        public function get center() : MapPoint
        {
            return new MapPoint(this.centerX, this.centerY, this.spatialReference);
        }// end function

        function get centerX() : Number
        {
            return (this.m_xmin + this.m_xmax) / 2;
        }// end function

        function get centerY() : Number
        {
            return (this.m_ymin + this.m_ymax) / 2;
        }// end function

        public function get width() : Number
        {
            return this.xmax - this.xmin;
        }// end function

        public function get height() : Number
        {
            return this.ymax - this.ymin;
        }// end function

        override public function get extent() : Extent
        {
            return this;
        }// end function

        public function offset(dx:Number, dy:Number) : Extent
        {
            return new Extent(this.xmin + dx, this.ymin + dy, this.xmax + dx, this.ymax + dy, this.spatialReference);
        }// end function

        public function centerAt(point:MapPoint) : Extent
        {
            return this.centerAtXY(point.x, point.y);
        }// end function

        function centerAtXY(mapX:Number, mapY:Number) : Extent
        {
            var _loc_3:* = this.center;
            var _loc_4:* = mapX - _loc_3.x;
            var _loc_5:* = mapY - _loc_3.y;
            return new Extent(this.xmin + _loc_4, this.ymin + _loc_5, this.xmax + _loc_4, this.ymax + _loc_5, this.spatialReference);
        }// end function

        public function expand(factor:Number) : Extent
        {
            var _loc_2:* = (1 - factor) / 2;
            var _loc_3:* = this.width * _loc_2;
            var _loc_4:* = this.height * _loc_2;
            return new Extent(this.xmin + _loc_3, this.ymin + _loc_4, this.xmax - _loc_3, this.ymax - _loc_4, this.spatialReference);
        }// end function

        public function intersects(geometry:Geometry) : Boolean
        {
            var _loc_2:Boolean = false;
            if (!geometry)
            {
                return false;
            }
            switch(geometry.type)
            {
                case Geometry.MAPPOINT:
                {
                    _loc_2 = this.containsPoint(geometry as MapPoint);
                    break;
                }
                case Geometry.EXTENT:
                {
                    _loc_2 = this.intersectsExtent(geometry as Extent);
                    break;
                }
                case Geometry.MULTIPOINT:
                {
                    _loc_2 = this.intersectsMultipoint(geometry as Multipoint);
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_2 = this.intersectsPolyline(geometry as Polyline);
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_2 = this.intersectsPolygon(geometry as Polygon);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        function intersectsMultipoint(multipoint:Multipoint) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:int = 0;
            while (_loc_3 < multipoint.points.length)
            {
                
                if (this.containsPoint(multipoint.points[_loc_3]))
                {
                    _loc_2 = true;
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        function intersectsExtent(extent:Extent) : Boolean
        {
            if (extent.xmax < this.xmin)
            {
                return false;
            }
            if (extent.xmin > this.xmax)
            {
                return false;
            }
            if (extent.ymin > this.ymax)
            {
                return false;
            }
            if (extent.ymax < this.ymin)
            {
                return false;
            }
            return true;
        }// end function

        function intersectsPolyline(polyline:Polyline) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:Array = null;
            var _loc_4:MapPoint = null;
            var _loc_5:int = 0;
            var _loc_6:MapPoint = null;
            for each (_loc_3 in polyline.paths)
            {
                
                _loc_4 = _loc_3[0];
                _loc_5 = 1;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_6 = _loc_3[_loc_5];
                    if (_loc_6.x == _loc_4.x)
                    {
                    }
                    if (_loc_6.y != _loc_4.y)
                    {
                        if (this.containsPoint(_loc_4))
                        {
                            this.containsPoint(_loc_4);
                        }
                        if (this.containsPoint(_loc_6))
                        {
                            _loc_2 = true;
                        }
                        else
                        {
                            _loc_2 = this.checkForEachLineSegment(_loc_4, _loc_6);
                        }
                        if (_loc_2)
                        {
                            break;
                        }
                    }
                    _loc_4 = _loc_6;
                    _loc_5 = _loc_5 + 1;
                }
                if (_loc_2)
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        function intersectsPolygon(polygon:Polygon) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_4:MapPoint = null;
            var _loc_5:Array = null;
            var _loc_6:MapPoint = null;
            var _loc_7:int = 0;
            var _loc_8:MapPoint = null;
            var _loc_3:Array = [];
            _loc_3.push(new MapPoint(this.xmin, this.ymin));
            _loc_3.push(new MapPoint(this.xmax, this.ymin));
            _loc_3.push(new MapPoint(this.xmax, this.ymax));
            _loc_3.push(new MapPoint(this.xmin, this.ymax));
            for each (_loc_4 in _loc_3)
            {
                
                if (polygon.contains(_loc_4))
                {
                    _loc_2 = true;
                    break;
                }
            }
            if (!_loc_2)
            {
                for each (_loc_5 in polygon.rings)
                {
                    
                    _loc_6 = _loc_5[0];
                    _loc_7 = 1;
                    while (_loc_7 < _loc_5.length)
                    {
                        
                        _loc_8 = _loc_5[_loc_7];
                        if (_loc_8.x == _loc_6.x)
                        {
                        }
                        if (_loc_8.y != _loc_6.y)
                        {
                            if (this.containsPoint(_loc_6))
                            {
                                this.containsPoint(_loc_6);
                            }
                            if (this.containsPoint(_loc_8))
                            {
                                _loc_2 = true;
                            }
                            else
                            {
                                _loc_2 = this.checkForEachLineSegment(_loc_6, _loc_8);
                            }
                            if (_loc_2)
                            {
                                break;
                            }
                        }
                        _loc_6 = _loc_8;
                        _loc_7 = _loc_7 + 1;
                    }
                    if (_loc_2)
                    {
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        private function checkForEachLineSegment(startPt:MapPoint, endPt:MapPoint) : Boolean
        {
            var _loc_3:Array = [];
            _loc_3 = GeomUtils.clipLineExtent(startPt, endPt, this);
            if (_loc_3.length == 0)
            {
                return false;
            }
            if (_loc_3.length == 1)
            {
                return true;
            }
            return true;
        }// end function

        function intersectsAndDoesNotTouch(extent:Extent) : Boolean
        {
            if (extent.xmax <= this.xmin)
            {
                return false;
            }
            if (extent.xmin >= this.xmax)
            {
                return false;
            }
            if (extent.ymin >= this.ymax)
            {
                return false;
            }
            if (extent.ymax <= this.ymin)
            {
                return false;
            }
            return true;
        }// end function

        public function intersection(extent:Extent) : Extent
        {
            if (this.intersectsAndDoesNotTouch(extent) === false)
            {
                return null;
            }
            var _loc_2:* = Math.max(this.xmin, extent.xmin);
            var _loc_3:* = Math.min(this.xmax, extent.xmax);
            var _loc_4:* = Math.max(this.ymin, extent.ymin);
            var _loc_5:* = Math.min(this.ymax, extent.ymax);
            return new Extent(_loc_2, _loc_4, _loc_3, _loc_5, spatialReference);
        }// end function

        public function contains(geometry:Geometry) : Boolean
        {
            var _loc_2:Boolean = false;
            if (!geometry)
            {
                return false;
            }
            switch(geometry.type)
            {
                case Geometry.MAPPOINT:
                {
                    _loc_2 = this.containsPoint(geometry as MapPoint);
                    break;
                }
                case Geometry.EXTENT:
                {
                    _loc_2 = this.containsExtent(geometry as Extent);
                    break;
                }
                case Geometry.MULTIPOINT:
                {
                    _loc_2 = this.containsPoints(Multipoint(geometry).points);
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_2 = this.containsPolyline(geometry as Polyline);
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_2 = this.containsPolygon(geometry as Polygon);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function containsExtent(env:Extent) : Boolean
        {
            if (env != null)
            {
            }
            if (this.m_xmin <= env.xmin)
            {
            }
            if (this.m_ymin <= env.ymin)
            {
            }
            if (this.m_xmax >= env.xmax)
            {
            }
            return this.m_ymax >= env.ymax;
        }// end function

        private function containsPoint(point:MapPoint) : Boolean
        {
            if (point != null)
            {
            }
            if (point.x >= this.m_xmin)
            {
            }
            if (point.x <= this.m_xmax)
            {
            }
            if (point.y >= this.m_ymin)
            {
            }
            return point.y <= this.m_ymax;
        }// end function

        private function containsPoints(points:Array) : Boolean
        {
            var _loc_3:uint = 0;
            if (!points)
            {
                return false;
            }
            var _loc_2:* = points.length;
            while (_loc_3 < _loc_2)
            {
                
                if (!this.containsPoint(points[_loc_3]))
                {
                    return false;
                }
                _loc_3 = _loc_3 + 1;
            }
            return true;
        }// end function

        private function containsPolyline(polyline:Polyline) : Boolean
        {
            var _loc_3:uint = 0;
            if (polyline)
            {
            }
            if (!polyline.paths)
            {
                return false;
            }
            var _loc_2:* = polyline.paths.length;
            while (_loc_3 < _loc_2)
            {
                
                if (!this.containsPoints(polyline.paths[_loc_3]))
                {
                    return false;
                }
                _loc_3 = _loc_3 + 1;
            }
            return true;
        }// end function

        private function containsPolygon(polygon:Polygon) : Boolean
        {
            var _loc_3:uint = 0;
            if (polygon)
            {
            }
            if (!polygon.rings)
            {
                return false;
            }
            var _loc_2:* = polygon.rings.length;
            while (_loc_3 < _loc_2)
            {
                
                if (!this.containsPoints(polygon.rings[_loc_3]))
                {
                    return false;
                }
                _loc_3 = _loc_3 + 1;
            }
            return true;
        }// end function

        public function containsXY(x:Number, y:Number) : Boolean
        {
            if (x >= this.xmin)
            {
            }
            if (x <= this.xmax)
            {
            }
            if (y >= this.ymin)
            {
            }
            return y <= this.ymax;
        }// end function

        public function union(extent:Extent) : Extent
        {
            return new Extent(Math.min(this.xmin, extent.xmin), Math.min(this.ymin, extent.ymin), Math.max(this.xmax, extent.xmax), Math.max(this.ymax, extent.ymax), this.spatialReference);
        }// end function

        public function update(xmin:Number, ymin:Number, xmax:Number, ymax:Number, spatialReference:SpatialReference = null) : void
        {
            this.xmin = xmin;
            this.ymin = ymin;
            this.xmax = xmax;
            this.ymax = ymax;
            if (spatialReference)
            {
                this.spatialReference = spatialReference;
            }
            return;
        }// end function

        function duplicate() : Extent
        {
            return new Extent(this.xmin, this.ymin, this.xmax, this.ymax, spatialReference);
        }// end function

        function unionExtent(extent:Extent) : void
        {
            if (extent.ymin < this.ymin)
            {
                this.ymin = extent.ymin;
            }
            if (extent.xmin < this.xmin)
            {
                this.xmin = extent.xmin;
            }
            if (extent.ymax > this.ymax)
            {
                this.ymax = extent.ymax;
            }
            if (extent.xmax > this.xmax)
            {
                this.xmax = extent.xmax;
            }
            return;
        }// end function

        function unionPoint(point:MapPoint) : void
        {
            this.unionXY(point.x, point.y);
            return;
        }// end function

        function unionXY(x:Number, y:Number) : void
        {
            this.xmin = Math.min(this.xmin, x);
            this.ymin = Math.min(this.ymin, y);
            this.xmax = Math.max(this.xmax, x);
            this.ymax = Math.max(this.ymax, y);
            return;
        }// end function

        function get area() : Number
        {
            return this.height * this.width;
        }// end function

        function disjointExtent(extent:Extent) : Boolean
        {
            if (this.xmax >= extent.xmin)
            {
            }
            if (this.ymax >= extent.ymin)
            {
            }
            if (this.xmin <= extent.xmax)
            {
            }
            return this.ymin > extent.ymax;
        }// end function

        public function equalsExtent(extent:Extent) : Boolean
        {
            if (this.xmax == extent.xmax)
            {
            }
            if (this.ymax == extent.ymax)
            {
            }
            if (this.xmin == extent.xmin)
            {
            }
            return this.ymin == extent.ymin;
        }// end function

        function equalsExtentOr(extent:Extent) : Boolean
        {
            if (this.xmax != extent.xmax)
            {
            }
            if (this.ymax != extent.ymax)
            {
            }
            if (this.xmin != extent.xmin)
            {
            }
            return this.ymin == extent.ymin;
        }// end function

        function reset(extent:Extent) : void
        {
            this.xmax = extent.xmax;
            this.ymax = extent.ymax;
            this.xmin = extent.xmin;
            this.ymin = extent.ymin;
            spatialReference = extent.spatialReference;
            return;
        }// end function

        function unionExtents(a:Extent, b:Extent) : void
        {
            if (a.xmin < b.xmin)
            {
                this.xmin = a.xmin;
            }
            else
            {
                this.xmin = b.xmin;
            }
            if (a.ymin < b.ymin)
            {
                this.ymin = a.ymin;
            }
            else
            {
                this.ymin = b.ymin;
            }
            if (a.xmax > b.xmax)
            {
                this.xmax = a.xmax;
            }
            else
            {
                this.xmax = b.xmax;
            }
            if (a.ymax > b.ymax)
            {
                this.ymax = a.ymax;
            }
            else
            {
                this.ymax = b.ymax;
            }
            return;
        }// end function

        function isEmpty() : Boolean
        {
            if (this.xmin <= this.xmax)
            {
            }
            return this.ymin > this.ymax;
        }// end function

        private function shiftCM(info:SRInfo) : Extent
        {
            var _loc_2:Extent = null;
            var _loc_3:SpatialReference = null;
            var _loc_4:MapPoint = null;
            var _loc_5:MapPoint = null;
            var _loc_6:String = null;
            if (!this.m_shifted)
            {
                _loc_2 = this.duplicate();
                _loc_3 = _loc_2.spatialReference;
                _loc_3 = new SpatialReference(_loc_3.wkid, _loc_3.wkt);
                _loc_2.spatialReference = _loc_3;
                if (!info)
                {
                }
                info = _loc_3.info;
                if (info)
                {
                    _loc_4 = this.getCM(info);
                    if (_loc_4)
                    {
                        _loc_5 = _loc_3.isWebMercator() ? (WebMercatorUtil.webMercatorToGeographic(_loc_4) as MapPoint) : (_loc_4);
                        _loc_2.xmin = _loc_2.xmin - _loc_4.x;
                        _loc_2.xmax = _loc_2.xmax - _loc_4.x;
                        if (!_loc_3.isWebMercator())
                        {
                            _loc_5.x = normalizeX(_loc_5.x, info).x;
                        }
                        _loc_6 = _loc_3.wkid === 4326 ? (info.altTemplate) : (info.wkTemplate);
                        _loc_2.spatialReference.wkt = StringUtil.substitute(_loc_6, _loc_5.x);
                        _loc_2.spatialReference.wkid = NaN;
                    }
                }
                this.m_shifted = _loc_2;
            }
            return this.m_shifted;
        }// end function

        private function getCM(info:SRInfo) : MapPoint
        {
            var _loc_2:MapPoint = null;
            var _loc_3:* = info.valid[0];
            var _loc_4:* = info.valid[1];
            var _loc_5:* = this.xmin;
            var _loc_6:* = this.xmax;
            if (_loc_5 >= _loc_3)
            {
            }
            var _loc_7:* = _loc_5 <= _loc_4;
            if (_loc_6 >= _loc_3)
            {
            }
            var _loc_8:* = _loc_6 <= _loc_4;
            if (_loc_7)
            {
            }
            if (!_loc_8)
            {
                _loc_2 = this.center;
            }
            return _loc_2;
        }// end function

        function normalize(shift:Boolean = false, sameType:Boolean = false, info:SRInfo = null) : Object
        {
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Object = null;
            var _loc_9:Polygon = null;
            var _loc_10:Extent = null;
            var _loc_4:* = this.duplicate();
            var _loc_5:* = _loc_4.spatialReference;
            if (_loc_5)
            {
                if (!info)
                {
                }
                info = _loc_5.info;
                if (info)
                {
                    _loc_6 = [];
                    _loc_7 = this.getParts(info);
                    for each (_loc_8 in _loc_7)
                    {
                        
                        _loc_6.push(_loc_8.extent);
                    }
                    if (_loc_6.length > 2)
                    {
                        if (shift)
                        {
                            return this.shiftCM(info);
                        }
                        _loc_4.xmin = info.valid[0];
                        _loc_4.xmax = info.valid[1];
                        return _loc_4;
                    }
                    else if (_loc_6.length === 2)
                    {
                        if (shift)
                        {
                            return this.shiftCM(info);
                        }
                        if (sameType)
                        {
                            return _loc_6;
                        }
                        _loc_9 = new Polygon(null, _loc_5);
                        for each (_loc_10 in _loc_6)
                        {
                            
                            _loc_9.addRing([new MapPoint(_loc_10.xmin, _loc_10.ymin), new MapPoint(_loc_10.xmin, _loc_10.ymax), new MapPoint(_loc_10.xmax, _loc_10.ymax), new MapPoint(_loc_10.xmax, _loc_10.ymin), new MapPoint(_loc_10.xmin, _loc_10.ymin)]);
                        }
                        return _loc_9;
                    }
                    else
                    {
                        return _loc_6.length === 1 ? (_loc_6[0]) : (_loc_4);
                    }
                }
            }
            return _loc_4;
        }// end function

        function getParts(info:SRInfo) : Array
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:SpatialReference = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Object = null;
            var _loc_13:Array = null;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Boolean = false;
            var _loc_17:Extent = null;
            var _loc_18:Extent = null;
            var _loc_19:Extent = null;
            var _loc_20:Extent = null;
            var _loc_21:Array = null;
            var _loc_22:Array = null;
            var _loc_23:int = 0;
            if (!this.m_parts)
            {
                _loc_2 = this.xmin;
                _loc_3 = this.xmax;
                _loc_4 = this.ymin;
                _loc_5 = this.ymax;
                _loc_6 = this.spatialReference;
                _loc_7 = this.width;
                _loc_8 = _loc_2;
                _loc_9 = _loc_3;
                _loc_10 = 0;
                _loc_11 = 0;
                _loc_13 = [];
                if (!info)
                {
                }
                info = _loc_6.info;
                _loc_14 = info.valid[0];
                _loc_15 = info.valid[1];
                _loc_12 = normalizeX(_loc_2, info);
                _loc_2 = _loc_12.x;
                _loc_10 = _loc_12.frameId;
                _loc_12 = normalizeX(_loc_3, info);
                _loc_3 = _loc_12.x;
                _loc_11 = _loc_12.frameId;
                if (_loc_2 === _loc_3)
                {
                }
                _loc_16 = _loc_7 > 0;
                if (_loc_7 > info.world)
                {
                    _loc_17 = new Extent(_loc_8 < _loc_9 ? (_loc_2) : (_loc_3), _loc_4, _loc_15, _loc_5, _loc_6);
                    _loc_18 = new Extent(_loc_14, _loc_4, _loc_8 < _loc_9 ? (_loc_3) : (_loc_2), _loc_5, _loc_6);
                    _loc_19 = new Extent(0, _loc_4, _loc_15, _loc_5, _loc_6);
                    _loc_20 = new Extent(_loc_14, _loc_4, 0, _loc_5, _loc_6);
                    _loc_21 = [];
                    _loc_22 = [];
                    if (_loc_17.containsExtent(_loc_19))
                    {
                        _loc_21.push(_loc_10);
                    }
                    if (_loc_17.containsExtent(_loc_20))
                    {
                        _loc_22.push(_loc_10);
                    }
                    if (_loc_18.containsExtent(_loc_19))
                    {
                        _loc_21.push(_loc_11);
                    }
                    if (_loc_18.containsExtent(_loc_20))
                    {
                        _loc_22.push(_loc_11);
                    }
                    _loc_23 = _loc_10 + 1;
                    while (_loc_23 < _loc_11)
                    {
                        
                        _loc_21.push(_loc_23);
                        _loc_22.push(_loc_23);
                        _loc_23 = _loc_23 + 1;
                    }
                    _loc_13.push({extent:_loc_17, frameIds:[_loc_10]}, {extent:_loc_18, frameIds:[_loc_11]}, {extent:_loc_19, frameIds:_loc_21}, {extent:_loc_20, frameIds:_loc_22});
                }
                else
                {
                    if (_loc_2 <= _loc_3)
                    {
                    }
                    if (_loc_16)
                    {
                        _loc_13.push({extent:new Extent(_loc_2, _loc_4, _loc_15, _loc_5, _loc_6), frameIds:[_loc_10]}, {extent:new Extent(_loc_14, _loc_4, _loc_3, _loc_5, _loc_6), frameIds:[_loc_11]});
                    }
                    else
                    {
                        _loc_13.push({extent:new Extent(_loc_2, _loc_4, _loc_3, _loc_5, _loc_6), frameIds:[_loc_10]});
                    }
                }
                this.m_parts = _loc_13;
            }
            return this.m_parts;
        }// end function

        override public function toString() : String
        {
            var _loc_1:* = spatialReference ? ("," + spatialReference.toString()) : ("");
            return "Extent[xmin=" + this.m_xmin + ",ymin=" + this.m_ymin + ",xmax=" + this.m_xmax + ",ymax=" + this.m_ymax + _loc_1 + "]";
        }// end function

        override public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {xmin:this.m_xmin, ymin:this.m_ymin, xmax:this.m_xmax, ymax:this.m_ymax};
            if (spatialReference)
            {
                _loc_2.spatialReference = spatialReference.toJSON();
            }
            return _loc_2;
        }// end function

        public function toPolygon() : Polygon
        {
            var _loc_1:Array = [new MapPoint(this.xmin, this.ymin), new MapPoint(this.xmin, this.ymax), new MapPoint(this.xmax, this.ymax), new MapPoint(this.xmax, this.ymin), new MapPoint(this.xmin, this.ymin)];
            return new Polygon([_loc_1], this.spatialReference);
        }// end function

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false) : void
        {
            this._eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._eventDispatcher.dispatchEvent(event);
        }// end function

        public function hasEventListener(type:String) : Boolean
        {
            return this._eventDispatcher.hasEventListener(type);
        }// end function

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
        {
            this._eventDispatcher.removeEventListener(type, listener, useCapture);
            return;
        }// end function

        public function willTrigger(type:String) : Boolean
        {
            return this._eventDispatcher.willTrigger(type);
        }// end function

        public function set ymin(value:Number) : void
        {
            arguments = this.ymin;
            if (arguments !== value)
            {
                this._3712825ymin = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ymin", arguments, value));
                }
            }
            return;
        }// end function

        public function set ymax(value:Number) : void
        {
            arguments = this.ymax;
            if (arguments !== value)
            {
                this._3712587ymax = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ymax", arguments, value));
                }
            }
            return;
        }// end function

        public function set xmin(value:Number) : void
        {
            arguments = this.xmin;
            if (arguments !== value)
            {
                this._3683034xmin = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xmin", arguments, value));
                }
            }
            return;
        }// end function

        public function set xmax(value:Number) : void
        {
            arguments = this.xmax;
            if (arguments !== value)
            {
                this._3682796xmax = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xmax", arguments, value));
                }
            }
            return;
        }// end function

        static function createEmptyExtent(spatialReference:SpatialReference = null) : Extent
        {
            return new Extent(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, spatialReference);
        }// end function

        static function normalizeX(x:Number, info:SRInfo) : Object
        {
            var _loc_7:Number = NaN;
            var _loc_3:Number = 0;
            var _loc_4:* = info.valid[0];
            var _loc_5:* = info.valid[1];
            var _loc_6:* = info.world;
            if (x > _loc_5)
            {
                _loc_7 = Math.ceil(Math.abs(x - _loc_5) / _loc_6);
                x = x - _loc_7 * _loc_6;
                _loc_3 = _loc_7;
            }
            else if (x < _loc_4)
            {
                _loc_7 = Math.ceil(Math.abs(x - _loc_4) / _loc_6);
                x = x + _loc_7 * _loc_6;
                _loc_3 = -_loc_7;
            }
            return {x:x, frameId:_loc_3};
        }// end function

        public static function fromJSON(obj:Object) : Extent
        {
            var _loc_2:Extent = null;
            if (obj)
            {
                _loc_2 = new Extent;
                _loc_2.xmin = obj.xmin;
                _loc_2.ymin = obj.ymin;
                _loc_2.xmax = obj.xmax;
                _loc_2.ymax = obj.ymax;
                _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
            }
            return _loc_2;
        }// end function

    }
}
