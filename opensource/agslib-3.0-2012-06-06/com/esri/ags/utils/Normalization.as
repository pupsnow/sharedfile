package com.esri.ags.utils
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;

    class Normalization extends Object
    {

        function Normalization()
        {
            return;
        }// end function

        public static function normalize(g:Geometry) : Geometry
        {
            if (!g)
            {
                return null;
            }
            if (!g.spatialReference)
            {
                return g;
            }
            var _loc_2:* = g.spatialReference.info;
            if (!_loc_2)
            {
                return g;
            }
            var _loc_3:* = _loc_2.valid[1];
            if (g is Polygon)
            {
                return normalizePolygon(g as Polygon, _loc_3);
            }
            if (g is Polyline)
            {
                return normalizePolyline(g as Polyline, _loc_3);
            }
            return g;
        }// end function

        private static function normalizePolyline(splitPoly:Polyline, dateline:Number) : Polyline
        {
            var _loc_3:Polyline = null;
            var _loc_4:Polyline = null;
            var _loc_5:int = 0;
            var _loc_6:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:Number = NaN;
            var _loc_13:MapPoint = null;
            var _loc_7:* = new Polyline([], splitPoly.spatialReference);
            var _loc_8:* = splitPoly.extent.xmin;
            var _loc_9:* = Math.ceil((_loc_8 - dateline) / (dateline * 2)) * (dateline * 2) + dateline;
            if (_loc_9 > splitPoly.extent.xmax)
            {
                _loc_7 = splitPoly;
            }
            else
            {
                _loc_10 = splitPoly.extent.xmax;
                while (_loc_9 < _loc_10)
                {
                    
                    _loc_11 = splitPolyline(splitPoly, _loc_9);
                    _loc_3 = _loc_11[0];
                    _loc_4 = _loc_11[1];
                    if (_loc_3)
                    {
                        for each (_loc_6 in _loc_3.paths)
                        {
                            
                            _loc_7.paths.push(_loc_6);
                        }
                    }
                    if (_loc_4 == null)
                    {
                        break;
                    }
                    else
                    {
                        splitPoly = _loc_4;
                    }
                    _loc_9 = _loc_9 + dateline * 2;
                }
                if (_loc_4)
                {
                    for each (_loc_6 in _loc_4.paths)
                    {
                        
                        _loc_7.paths.push(_loc_6);
                    }
                }
            }
            for each (_loc_6 in _loc_7.paths)
            {
                
                _loc_12 = getFrame(getExtent(_loc_6).centerX, dateline);
                for each (_loc_13 in _loc_6)
                {
                    
                    _loc_13.x = _loc_13.x - _loc_12 * 2 * dateline;
                }
            }
            return _loc_7;
        }// end function

        private static function normalizePolygon(splitPoly:Polygon, dateline:Number) : Polygon
        {
            var _loc_3:Polygon = null;
            var _loc_4:Polygon = null;
            var _loc_5:int = 0;
            var _loc_6:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:Number = NaN;
            var _loc_13:MapPoint = null;
            var _loc_7:* = new Polygon([], splitPoly.spatialReference);
            var _loc_8:* = splitPoly.extent.xmin;
            var _loc_9:* = Math.ceil((_loc_8 - dateline) / (dateline * 2)) * (dateline * 2) + dateline;
            if (_loc_9 > splitPoly.extent.xmax)
            {
                _loc_7 = splitPoly;
            }
            else
            {
                _loc_10 = splitPoly.extent.xmax;
                while (_loc_9 < _loc_10)
                {
                    
                    _loc_11 = splitPolygon(splitPoly, _loc_9);
                    _loc_3 = _loc_11[0];
                    _loc_4 = _loc_11[1];
                    if (_loc_3)
                    {
                        for each (_loc_6 in _loc_3.rings)
                        {
                            
                            _loc_7.rings.push(_loc_6);
                        }
                    }
                    if (_loc_4 == null)
                    {
                        break;
                    }
                    else
                    {
                        splitPoly = _loc_4;
                    }
                    _loc_9 = _loc_9 + dateline * 2;
                }
                if (_loc_4)
                {
                    for each (_loc_6 in _loc_4.rings)
                    {
                        
                        _loc_7.rings.push(_loc_6);
                    }
                }
            }
            for each (_loc_6 in _loc_7.rings)
            {
                
                _loc_12 = getFrame(getExtent(_loc_6).centerX, dateline);
                for each (_loc_13 in _loc_6)
                {
                    
                    _loc_13.x = _loc_13.x - _loc_12 * 2 * dateline;
                }
            }
            return _loc_7;
        }// end function

        private static function splitPolyline(input:Polyline, edge:Number) : Array
        {
            var _loc_3:Polyline = null;
            var _loc_4:Polyline = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Extent = null;
            var _loc_10:MapPoint = null;
            var _loc_11:Boolean = false;
            var _loc_12:Array = null;
            var _loc_13:int = 0;
            var _loc_14:MapPoint = null;
            var _loc_15:Boolean = false;
            var _loc_16:MapPoint = null;
            var _loc_5:* = input.extent;
            if (_loc_5.xmax <= edge)
            {
                _loc_3 = input;
            }
            else if (_loc_5.xmin >= edge)
            {
                _loc_4 = input;
            }
            else
            {
                _loc_3 = new Polyline([]);
                _loc_4 = new Polyline([]);
                _loc_6 = _loc_3.paths;
                _loc_7 = _loc_4.paths;
                for each (_loc_8 in input.paths)
                {
                    
                    _loc_9 = getExtent(_loc_8);
                    if (_loc_9.xmax <= edge)
                    {
                        _loc_6.push(_loc_8);
                        continue;
                    }
                    if (_loc_9.xmin >= edge)
                    {
                        _loc_7.push(_loc_8);
                        continue;
                    }
                    _loc_10 = _loc_8[0];
                    _loc_11 = isOnLeft(_loc_10, edge);
                    _loc_12 = [];
                    _loc_12.push(_loc_10);
                    _loc_13 = 1;
                    while (_loc_13 < _loc_8.length)
                    {
                        
                        _loc_14 = _loc_8[_loc_13];
                        _loc_15 = isOnLeft(_loc_14, edge);
                        if (_loc_15 == _loc_11)
                        {
                            _loc_12.push(_loc_14);
                        }
                        else
                        {
                            _loc_16 = edgeIntersection(_loc_10, _loc_14, edge);
                            _loc_12.push(_loc_16);
                            if (_loc_11)
                            {
                                _loc_6.push(_loc_12);
                            }
                            else
                            {
                                _loc_7.push(_loc_12);
                            }
                            _loc_12 = [];
                            _loc_12.push(new MapPoint(_loc_16.x, _loc_16.y));
                            _loc_12.push(_loc_14);
                            _loc_11 = _loc_15;
                        }
                        _loc_10 = _loc_14;
                        _loc_13 = _loc_13 + 1;
                    }
                    if (_loc_11)
                    {
                        _loc_6.push(_loc_12);
                        continue;
                    }
                    _loc_7.push(_loc_12);
                }
            }
            return [_loc_3, _loc_4];
        }// end function

        private static function splitPolygon(input:Polygon, edge:Number) : Array
        {
            var _loc_3:Polygon = null;
            var _loc_4:Polygon = null;
            var _loc_5:int = 0;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
            var _loc_10:Array = null;
            var _loc_11:Extent = null;
            var _loc_12:MapPoint = null;
            var _loc_13:Boolean = false;
            var _loc_14:Array = null;
            var _loc_15:MapPoint = null;
            var _loc_16:Boolean = false;
            var _loc_17:MapPoint = null;
            var _loc_18:Array = null;
            var _loc_6:* = input.extent;
            if (_loc_6.xmax <= edge)
            {
                _loc_3 = input;
            }
            else if (_loc_6.xmin >= edge)
            {
                _loc_4 = input;
            }
            else
            {
                _loc_7 = [];
                _loc_8 = [];
                _loc_9 = [];
                for each (_loc_10 in input.rings)
                {
                    
                    _loc_11 = getExtent(_loc_10);
                    if (_loc_11.xmax <= edge)
                    {
                        _loc_7.push(_loc_10);
                        continue;
                    }
                    if (_loc_11.xmin >= edge)
                    {
                        _loc_8.push(_loc_10);
                        continue;
                    }
                    _loc_12 = _loc_10[(_loc_10.length - 1)];
                    _loc_13 = isOnLeft(_loc_12, edge);
                    _loc_14 = [];
                    _loc_5 = 0;
                    while (_loc_5 < _loc_10.length)
                    {
                        
                        _loc_15 = _loc_10[_loc_5];
                        _loc_16 = isOnLeft(_loc_15, edge);
                        if (_loc_16 == _loc_13)
                        {
                            _loc_14.push(_loc_15);
                        }
                        else
                        {
                            _loc_17 = edgeIntersection(_loc_12, _loc_15, edge);
                            _loc_14.push(_loc_17);
                            if (_loc_13)
                            {
                                _loc_7.push(_loc_14);
                            }
                            else
                            {
                                _loc_8.push(_loc_14);
                            }
                            _loc_9.push(_loc_17.y);
                            _loc_14 = [];
                            _loc_14.push(new MapPoint(_loc_17.x, _loc_17.y));
                            _loc_14.push(_loc_15);
                            _loc_13 = _loc_16;
                        }
                        _loc_12 = _loc_15;
                        _loc_5 = _loc_5 + 1;
                    }
                    if (_loc_13)
                    {
                        _loc_7.push(_loc_14);
                        continue;
                    }
                    _loc_8.push(_loc_14);
                }
                _loc_9.sort(Array.NUMERIC);
                _loc_5 = 0;
                while (_loc_5 < (_loc_9.length - 1))
                {
                    
                    _loc_18 = [];
                    _loc_18.push(new MapPoint(edge, _loc_9[_loc_5]));
                    _loc_18.push(new MapPoint(edge, _loc_9[(_loc_5 + 1)]));
                    if (_loc_7.length > 0)
                    {
                        _loc_7.push(_loc_18);
                    }
                    if (_loc_8.length > 0)
                    {
                        _loc_8.push(_loc_18);
                    }
                    _loc_5 = _loc_5 + 2;
                }
                if (_loc_7.length > 0)
                {
                    _loc_3 = mergeSegments(_loc_7);
                }
                if (_loc_8.length > 0)
                {
                    _loc_4 = mergeSegments(_loc_8);
                }
            }
            return [_loc_3, _loc_4];
        }// end function

        private static function mergeSegments(segments:Array) : Polygon
        {
            var _loc_2:int = 0;
            var _loc_4:Array = null;
            var _loc_5:Boolean = false;
            var _loc_6:MapPoint = null;
            var _loc_7:MapPoint = null;
            var _loc_8:int = 0;
            var _loc_9:Array = null;
            var _loc_10:MapPoint = null;
            var _loc_11:MapPoint = null;
            var _loc_3:* = new Polygon([]);
            while (segments.length > 0)
            {
                
                _loc_4 = segments[0];
                _loc_5 = false;
                _loc_6 = _loc_4[0];
                _loc_7 = _loc_4[(_loc_4.length - 1)];
                if (_loc_6.x == _loc_7.x)
                {
                }
                if (_loc_6.y != _loc_7.y)
                {
                    _loc_8 = 1;
                    while (_loc_8 < segments.length)
                    {
                        
                        _loc_9 = segments[_loc_8];
                        _loc_10 = _loc_9[0];
                        _loc_11 = _loc_9[(_loc_9.length - 1)];
                        if (_loc_7.y == _loc_10.y)
                        {
                        }
                        if (_loc_7.x == _loc_10.x)
                        {
                            _loc_2 = 1;
                            while (_loc_2 < _loc_9.length)
                            {
                                
                                _loc_4.push(new MapPoint(_loc_9[_loc_2].x, _loc_9[_loc_2].y));
                                _loc_2 = _loc_2 + 1;
                            }
                            _loc_5 = true;
                        }
                        else
                        {
                            if (_loc_7.y == _loc_11.y)
                            {
                            }
                            if (_loc_7.x == _loc_11.x)
                            {
                                _loc_2 = _loc_9.length - 2;
                                while (_loc_2 >= 0)
                                {
                                    
                                    _loc_4.push(new MapPoint(_loc_9[_loc_2].x, _loc_9[_loc_2].y));
                                    _loc_2 = _loc_2 - 1;
                                }
                                _loc_5 = true;
                            }
                            else
                            {
                                if (_loc_6.y == _loc_11.y)
                                {
                                }
                                if (_loc_6.x == _loc_11.x)
                                {
                                    _loc_2 = 0;
                                    while (_loc_2 < (_loc_9.length - 1))
                                    {
                                        
                                        _loc_4.splice(_loc_2, 0, new MapPoint(_loc_9[_loc_2].x, _loc_9[_loc_2].y));
                                        _loc_2 = _loc_2 + 1;
                                    }
                                    _loc_5 = true;
                                }
                                else
                                {
                                    if (_loc_6.y == _loc_10.y)
                                    {
                                    }
                                    if (_loc_6.x == _loc_10.x)
                                    {
                                        _loc_2 = 1;
                                        while (_loc_2 < _loc_9.length)
                                        {
                                            
                                            _loc_4.unshift(new MapPoint(_loc_9[_loc_2].x, _loc_9[_loc_2].y));
                                            _loc_2 = _loc_2 + 1;
                                        }
                                        _loc_5 = true;
                                    }
                                }
                            }
                        }
                        if (_loc_5)
                        {
                            segments.splice(_loc_8, 1);
                            if (MapPoint(_loc_4[0]).equalsMapPoint(MapPoint(_loc_4[(_loc_4.length - 1)])))
                            {
                                segments.shift();
                                if (getExtent(_loc_4).width > 0)
                                {
                                    _loc_3.rings.push(_loc_4);
                                }
                            }
                            break;
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                }
                if (!_loc_5)
                {
                    segments.shift();
                    if (_loc_4.length < 3)
                    {
                    }
                    _loc_3.rings.push(_loc_4);
                }
            }
            return _loc_3;
        }// end function

        private static function isOnLeft(p0:MapPoint, edge:Number) : Boolean
        {
            return p0.x < edge;
        }// end function

        private static function edgeIntersection(p0:MapPoint, p1:MapPoint, edge:Number) : MapPoint
        {
            return new MapPoint(edge, p0.y + (p1.y - p0.y) / (p1.x - p0.x) * (edge - p0.x));
        }// end function

        private static function getExtent(points:Array) : Extent
        {
            var _loc_2:* = new Multipoint(points);
            return _loc_2.extent;
        }// end function

        private static function getFrame(x:Number, dateline:Number) : Number
        {
            var _loc_3:* = (x + dateline) / (dateline * 2);
            if (_loc_3 % 2 == 1)
            {
                _loc_3 = _loc_3 - 1;
            }
            return Math.floor(_loc_3);
        }// end function

    }
}
