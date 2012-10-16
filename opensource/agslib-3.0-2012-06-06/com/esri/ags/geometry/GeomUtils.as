package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import flash.geom.*;

    public class GeomUtils extends Object
    {

        public function GeomUtils()
        {
            return;
        }// end function

        static function extentToRect(extent:Extent) : Rectangle
        {
            return new Rectangle(extent.xmin, extent.ymax, extent.width, extent.height);
        }// end function

        static function rectToExtent(rect:Rectangle) : Extent
        {
            return new Extent(rect.x, rect.y - rect.height, rect.x + rect.width, rect.y);
        }// end function

        public static function calcArea(arrOfMapPoints:Array) : Number
        {
            var _loc_6:MapPoint = null;
            var _loc_7:MapPoint = null;
            var _loc_2:Number = 0;
            var _loc_3:* = arrOfMapPoints.length;
            var _loc_4:* = _loc_3 - 1;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_6 = arrOfMapPoints[_loc_4];
                _loc_7 = arrOfMapPoints[_loc_5];
                _loc_2 = _loc_2 + (_loc_6.x * _loc_7.y - _loc_7.x * _loc_6.y);
                _loc_4 = _loc_5;
                _loc_5 = _loc_5 + 1;
            }
            return _loc_2 * 0.5;
        }// end function

        public static function calcCentroidAndArea(points:Array) : Object
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_8:MapPoint = null;
            var _loc_9:MapPoint = null;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_4:* = points.length;
            var _loc_5:Number = 0;
            var _loc_6:Number = 0;
            var _loc_7:Number = 0;
            _loc_2 = _loc_4 - 1;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_8 = points[_loc_2] as MapPoint;
                _loc_9 = points[_loc_3] as MapPoint;
                _loc_10 = _loc_8.x;
                _loc_11 = _loc_8.y;
                _loc_12 = _loc_9.x;
                _loc_13 = _loc_9.y;
                _loc_14 = _loc_10 * _loc_13 - _loc_12 * _loc_11;
                _loc_5 = _loc_5 + _loc_14;
                _loc_6 = _loc_6 + (_loc_10 + _loc_12) * _loc_14;
                _loc_7 = _loc_7 + (_loc_11 + _loc_13) * _loc_14;
                _loc_2 = _loc_3;
                _loc_3 = _loc_3 + 1;
            }
            _loc_5 = _loc_5 / 2;
            _loc_6 = _loc_6 / (6 * _loc_5);
            _loc_7 = _loc_7 / (6 * _loc_5);
            return {x:_loc_6, y:_loc_7, area:_loc_5};
        }// end function

        public static function isClockwise(arrOfMapPoints:Array) : Boolean
        {
            return calcArea(arrOfMapPoints) <= 0;
        }// end function

        public static function contains(arrOfMapPoints:Array, px:Number, py:Number) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_9:Number = NaN;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            _loc_9 = arrOfMapPoints[0].y - arrOfMapPoints[(arrOfMapPoints.length - 1)].y;
            if (_loc_9 < 0)
            {
                _loc_8 = 1;
            }
            else if (_loc_9 > 0)
            {
                _loc_8 = 0;
            }
            else
            {
                _loc_10 = arrOfMapPoints.length - 2;
                _loc_11 = _loc_10 + 1;
                while (arrOfMapPoints[_loc_10].y == arrOfMapPoints[_loc_11].y)
                {
                    
                    _loc_10 = _loc_10 - 1;
                    _loc_11 = _loc_11 - 1;
                    if (_loc_10 == 0)
                    {
                        return true;
                    }
                }
                _loc_9 = arrOfMapPoints[_loc_11].y - arrOfMapPoints[_loc_10].y;
                if (_loc_9 < 0)
                {
                    _loc_8 = 1;
                }
                else if (_loc_9 > 0)
                {
                    _loc_8 = 0;
                }
            }
            _loc_5 = 0;
            _loc_6 = 1;
            while (_loc_5 < (arrOfMapPoints.length - 1))
            {
                
                _loc_12 = arrOfMapPoints[_loc_5].x;
                _loc_13 = arrOfMapPoints[_loc_5].y;
                _loc_14 = arrOfMapPoints[_loc_6].x;
                _loc_15 = arrOfMapPoints[_loc_6].y;
                if (py > _loc_13)
                {
                    if (py < _loc_15)
                    {
                        _loc_4 = (py - _loc_13) * (_loc_14 - _loc_12) / (_loc_15 - _loc_13) + _loc_12;
                        if (px < _loc_4)
                        {
                            _loc_7 = _loc_7 + 1;
                        }
                        else if (px == _loc_4)
                        {
                            return true;
                        }
                    }
                    else if (py == _loc_15)
                    {
                        _loc_8 = 0;
                    }
                }
                else if (py < _loc_13)
                {
                    if (py > _loc_15)
                    {
                        _loc_4 = (py - _loc_13) * (_loc_14 - _loc_12) / (_loc_15 - _loc_13) + _loc_12;
                        if (px < _loc_4)
                        {
                            _loc_7 = _loc_7 + 1;
                        }
                        else if (px == _loc_4)
                        {
                            return true;
                        }
                    }
                    else if (py == _loc_15)
                    {
                        _loc_8 = 1;
                    }
                }
                else
                {
                    if (px == _loc_12)
                    {
                        return true;
                    }
                    if (py < _loc_15)
                    {
                        if (_loc_8 != 1)
                        {
                            if (px < _loc_12)
                            {
                                _loc_7 = _loc_7 + 1;
                            }
                        }
                    }
                    else if (py > _loc_15)
                    {
                        if (_loc_8 > 0)
                        {
                            if (px < _loc_12)
                            {
                                _loc_7 = _loc_7 + 1;
                            }
                        }
                    }
                    else
                    {
                        if (px > _loc_12)
                        {
                        }
                        if (px <= _loc_14)
                        {
                            return true;
                        }
                        if (px < _loc_12)
                        {
                        }
                        if (px >= _loc_14)
                        {
                            return true;
                        }
                    }
                }
                _loc_5 = _loc_5 + 1;
                _loc_6 = _loc_6 + 1;
            }
            if (_loc_7 % 2 != 0)
            {
                return true;
            }
            return false;
        }// end function

        public static function isClosed(arrOfMapPoints:Array) : Boolean
        {
            var _loc_2:* = arrOfMapPoints.length - 1;
            if (arrOfMapPoints[0].y == arrOfMapPoints[_loc_2].y)
            {
            }
            return arrOfMapPoints[0].x == arrOfMapPoints[_loc_2].x;
        }// end function

        public static function clipLineExtent(startPt:MapPoint, endPt:MapPoint, extent:Extent) : Array
        {
            var _loc_4:* = new MapPoint(extent.xmin, extent.ymax);
            var _loc_5:* = new MapPoint(extent.xmax, extent.ymin);
            var _loc_6:* = new MapPoint(extent.xmax, extent.ymax);
            var _loc_7:* = new MapPoint(extent.xmin, extent.ymin);
            var _loc_8:Array = [];
            _loc_8.push(intersectLineLine(_loc_4, _loc_6, startPt, endPt));
            _loc_8.push(intersectLineLine(_loc_6, _loc_5, startPt, endPt));
            _loc_8.push(intersectLineLine(_loc_5, _loc_7, startPt, endPt));
            _loc_8.push(intersectLineLine(_loc_7, _loc_4, startPt, endPt));
            var _loc_9:Array = [];
            var _loc_10:int = 0;
            while (_loc_10 < _loc_8.length)
            {
                
                if (_loc_8[_loc_10] is MapPoint)
                {
                    _loc_9.push(_loc_8[_loc_10]);
                }
                _loc_10 = _loc_10 + 1;
            }
            return _loc_9;
        }// end function

        public static function intersectLineLine(a1:MapPoint, a2:MapPoint, b1:MapPoint, b2:MapPoint) : Object
        {
            var _loc_5:Object = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_6:* = (b2.x - b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x);
            var _loc_7:* = (a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x);
            var _loc_8:* = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y);
            if (_loc_8 != 0)
            {
                _loc_9 = _loc_6 / _loc_8;
                _loc_10 = _loc_7 / _loc_8;
                if (_loc_9 >= 0)
                {
                }
                if (_loc_9 <= 1)
                {
                }
                if (_loc_10 >= 0)
                {
                }
                if (_loc_10 <= 1)
                {
                    _loc_5 = new MapPoint(a1.x + _loc_9 * (a2.x - a1.x), a1.y + _loc_9 * (a2.y - a1.y));
                }
                else
                {
                    _loc_5 = "No Intersection";
                }
            }
            else
            {
                if (_loc_6 != 0)
                {
                }
                if (_loc_7 == 0)
                {
                    _loc_5 = "Coincident";
                }
                else
                {
                    _loc_5 = "Parallel";
                }
            }
            return _loc_5;
        }// end function

        public static function getLineIntersection2(line1:Array, line2:Array) : Array
        {
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_3:* = line1[0];
            var _loc_4:* = line1[1];
            var _loc_5:* = line2[0];
            var _loc_6:* = line2[1];
            var _loc_7:* = _loc_3[0];
            var _loc_8:* = _loc_3[1];
            var _loc_9:* = _loc_4[0];
            var _loc_10:* = _loc_4[1];
            var _loc_11:* = _loc_5[0];
            var _loc_12:* = _loc_5[1];
            var _loc_13:* = _loc_6[0];
            var _loc_14:* = _loc_6[1];
            var _loc_15:* = _loc_13 - _loc_11;
            var _loc_16:* = _loc_7 - _loc_11;
            var _loc_17:* = _loc_9 - _loc_7;
            var _loc_18:* = _loc_14 - _loc_12;
            var _loc_19:* = _loc_8 - _loc_12;
            var _loc_20:* = _loc_10 - _loc_8;
            var _loc_21:* = _loc_18 * _loc_17 - _loc_15 * _loc_20;
            if (_loc_21 === 0)
            {
                return null;
            }
            _loc_22 = (_loc_15 * _loc_19 - _loc_18 * _loc_16) / _loc_21;
            _loc_23 = (_loc_17 * _loc_19 - _loc_20 * _loc_16) / _loc_21;
            if (_loc_22 >= 0)
            {
            }
            if (_loc_22 <= 1)
            {
            }
            if (_loc_23 >= 0)
            {
            }
            if (_loc_23 <= 1)
            {
                _loc_24 = _loc_7 + _loc_22 * (_loc_9 - _loc_7);
                _loc_25 = _loc_8 + _loc_22 * (_loc_10 - _loc_8);
                return [_loc_24, _loc_25];
            }
            return null;
        }// end function

        public static function intersects(map:Map, geometry:Geometry, geomExtent:Extent) : Array
        {
            var _loc_4:Array = null;
            var _loc_8:Array = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:Object = null;
            var _loc_16:Object = null;
            var _loc_5:Array = [];
            var _loc_6:* = map.spatialReference.info;
            var _loc_7:* = getFrameWidth(map);
            var _loc_9:* = map.extentExpanded.getParts(_loc_6);
            var _loc_17:Array = [];
            var _loc_18:* = getPartwise(geometry);
            if (_loc_18.length > 0)
            {
                _loc_8 = [];
                _loc_10 = 0;
                while (_loc_10 < _loc_18.length)
                {
                    
                    _loc_8 = _loc_8.concat(Extent(_loc_18[_loc_10]).getParts(_loc_6));
                    _loc_10 = _loc_10 + 1;
                }
            }
            else
            {
                _loc_8 = geomExtent.getParts(_loc_6);
            }
            _loc_10 = 0;
            while (_loc_10 < _loc_8.length)
            {
                
                _loc_15 = _loc_8[_loc_10];
                _loc_11 = 0;
                while (_loc_11 < _loc_9.length)
                {
                    
                    _loc_16 = _loc_9[_loc_11];
                    if (_loc_16.extent.intersectsExtent(_loc_15.extent))
                    {
                        _loc_14 = 0;
                        while (_loc_14 < _loc_16.frameIds.length)
                        {
                            
                            _loc_13 = 0;
                            while (_loc_13 < _loc_15.frameIds.length)
                            {
                                
                                _loc_5.push((_loc_16.frameIds[_loc_14] - _loc_15.frameIds[_loc_13]) * _loc_7);
                                _loc_13 = _loc_13 + 1;
                            }
                            _loc_14 = _loc_14 + 1;
                        }
                    }
                    _loc_11 = _loc_11 + 1;
                }
                _loc_10 = _loc_10 + 1;
            }
            _loc_10 = 0;
            while (_loc_10 < _loc_5.length)
            {
                
                _loc_12 = _loc_5[_loc_10];
                if (_loc_5.indexOf(_loc_12) === _loc_10)
                {
                    _loc_17.push(_loc_12);
                }
                _loc_10 = _loc_10 + 1;
            }
            _loc_4 = _loc_17.length > 0 ? (_loc_17) : (null);
            return _loc_4;
        }// end function

        public static function getFrameWidth(map:Map) : Number
        {
            var _loc_4:Array = null;
            var _loc_2:Number = -1;
            var _loc_3:* = map.spatialReference.info;
            if (map.currentLOD)
            {
                _loc_4 = map.currentLOD.frameInfo;
                if (_loc_4)
                {
                    _loc_2 = _loc_4[3];
                }
            }
            else if (_loc_3)
            {
                _loc_2 = Math.round(2 * _loc_3.valid[1] / (Math.abs(map.extent.xmax - map.extent.xmin) / map.width));
            }
            return _loc_2;
        }// end function

        private static function getPartwise(geometry:Geometry) : Array
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:MapPoint = null;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_2:Array = [];
            switch(geometry.type)
            {
                case Geometry.EXTENT:
                {
                    _loc_2 = [(geometry as Extent).duplicate()];
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_2 = (geometry as Polygon).parts;
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_2 = (geometry as Polyline).parts;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        public static function denormalizePoint(map:Map, mapPoint:MapPoint, stagePoint:Point = null) : MapPoint
        {
            var _loc_4:MapPoint = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Array = null;
            var _loc_16:int = 0;
            var _loc_17:Array = null;
            var _loc_18:int = 0;
            var _loc_5:* = intersects(map, mapPoint, new Extent(mapPoint.x, mapPoint.y, mapPoint.x, mapPoint.y));
            if (_loc_5)
            {
            }
            if (_loc_5.length > 0)
            {
                if (_loc_5.length == 1)
                {
                    _loc_4 = map.toMap(new Point(map.toScreenX(mapPoint.x) + _loc_5[0], map.toScreenY(mapPoint.y)));
                }
                else if (stagePoint)
                {
                    _loc_6 = Extent.normalizeX(map.toMapX(stagePoint.x), map.spatialReference.info).frameId;
                    _loc_7 = Extent.normalizeX(mapPoint.x, map.spatialReference.info).frameId;
                    _loc_8 = (_loc_6 - _loc_7) * map.spatialReference.info.world;
                    _loc_4 = new MapPoint(mapPoint.x + _loc_8, mapPoint.y);
                }
                else
                {
                    _loc_9 = [];
                    _loc_10 = map.toScreenX(mapPoint.x);
                    _loc_11 = map.toScreenY(mapPoint.y);
                    for each (_loc_12 in _loc_5)
                    {
                        
                        _loc_9.push(new Point(_loc_10 + _loc_12, _loc_11));
                    }
                    _loc_13 = map.toScreenX(map.extent.centerX);
                    _loc_14 = map.toScreenY(map.extent.centerY);
                    _loc_15 = [];
                    _loc_16 = 0;
                    while (_loc_16 < _loc_9.length)
                    {
                        
                        _loc_15.push(Math.pow(_loc_9[_loc_16].x - _loc_13, 2) + Math.pow(_loc_9[_loc_16].y - _loc_14, 2));
                        _loc_16 = _loc_16 + 1;
                    }
                    _loc_17 = _loc_15.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
                    _loc_18 = _loc_17[0];
                    _loc_4 = map.toMap(new Point(_loc_9[_loc_18].x, _loc_9[_loc_18].y));
                }
            }
            return _loc_4;
        }// end function

    }
}
