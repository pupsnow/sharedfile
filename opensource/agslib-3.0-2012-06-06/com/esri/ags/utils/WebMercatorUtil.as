package com.esri.ags.utils
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;

    public class WebMercatorUtil extends Object
    {
        static const DEGREES_PER_RADIANS:Number = 57.2958;
        static const RADIANS_PER_DEGREES:Number = 0.0174533;
        static const RADIUS:Number = 6.37814e+006;
        static const GEO_WKID:Number = 4326;
        static const MER_WKID:Number = 102100;

        public function WebMercatorUtil()
        {
            return;
        }// end function

        public static function geographicToWebMercator(geometry:Geometry) : Geometry
        {
            return projectGeometry(geometry, longitudeToX, latitudeToY, MER_WKID);
        }// end function

        public static function webMercatorToGeographic(geometry:Geometry) : Geometry
        {
            return projectGeometry(geometry, xToLongitude, yToLatitude, GEO_WKID);
        }// end function

        private static function projectGeometry(geometry:Geometry, xConvFunc:Function, yConvFunc:Function, wkid:Number) : Geometry
        {
            if (geometry is MapPoint)
            {
                geometry = projectMapPoint(MapPoint(geometry), xConvFunc, yConvFunc, wkid);
            }
            else if (geometry is Extent)
            {
                geometry = projectExtent(Extent(geometry), xConvFunc, yConvFunc, wkid);
            }
            else if (geometry is Polyline)
            {
                geometry = projectPolyline(Polyline(geometry), xConvFunc, yConvFunc, wkid);
            }
            else if (geometry is Polygon)
            {
                geometry = projectPolygon(Polygon(geometry), xConvFunc, yConvFunc, wkid);
            }
            else if (geometry is Multipoint)
            {
                geometry = projectMultipoint(Multipoint(geometry), xConvFunc, yConvFunc, wkid);
            }
            return geometry;
        }// end function

        private static function projectExtent(extent:Extent, xConvFunc:Function, yConvFunc:Function, wkid:Number) : Extent
        {
            var _loc_5:* = WebMercatorUtil.xConvFunc(extent.xmin);
            var _loc_6:* = WebMercatorUtil.yConvFunc(extent.ymin);
            var _loc_7:* = WebMercatorUtil.xConvFunc(extent.xmax);
            var _loc_8:* = WebMercatorUtil.yConvFunc(extent.ymax);
            extent = new Extent(_loc_5, _loc_6, _loc_7, _loc_8, createSR(wkid));
            return extent;
        }// end function

        private static function projectMapPoint(mapPoint:MapPoint, xConvFunc:Function, yConvFunc:Function, wkid:Number) : MapPoint
        {
            var _loc_5:* = WebMercatorUtil.xConvFunc(mapPoint.x);
            var _loc_6:* = WebMercatorUtil.yConvFunc(mapPoint.y);
            var _loc_7:* = new MapPoint(_loc_5, _loc_6, createSR(wkid));
            _loc_7.m = mapPoint.m;
            _loc_7.z = mapPoint.z;
            return _loc_7;
        }// end function

        private static function projectMultipoint(multipoint:Multipoint, xConvFunc:Function, yConvFunc:Function, wkid:Number) : Multipoint
        {
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_5:* = multipoint.points;
            var _loc_6:* = _loc_5 != null ? (new Array(_loc_5.length)) : (null);
            var _loc_7:* = new Multipoint(_loc_6, createSR(wkid));
            _loc_7.hasM = multipoint.hasM;
            _loc_7.hasZ = multipoint.hasZ;
            if (_loc_5)
            {
                _loc_8 = 0;
                _loc_9 = _loc_5.length;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_6[_loc_8] = projectMapPoint(_loc_5[_loc_8], xConvFunc, yConvFunc, NaN);
                    _loc_8 = _loc_8 + 1;
                }
            }
            return _loc_7;
        }// end function

        private static function projectPolygon(polygon:Polygon, xConvFunc:Function, yConvFunc:Function, wkid:Number) : Polygon
        {
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:Array = null;
            var _loc_11:Array = null;
            var _loc_12:uint = 0;
            var _loc_13:uint = 0;
            var _loc_5:* = polygon.rings;
            var _loc_6:* = _loc_5 != null ? (new Array(_loc_5.length)) : (null);
            var _loc_7:* = new Polygon(_loc_6, createSR(wkid));
            _loc_7.hasM = polygon.hasM;
            _loc_7.hasZ = polygon.hasZ;
            if (_loc_5)
            {
                _loc_8 = 0;
                _loc_9 = _loc_5.length;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_10 = _loc_5[_loc_8];
                    _loc_11 = _loc_10 != null ? (new Array(_loc_10.length)) : (null);
                    _loc_6[_loc_8] = _loc_11;
                    if (_loc_10)
                    {
                        _loc_12 = 0;
                        _loc_13 = _loc_10.length;
                        while (_loc_12 < _loc_13)
                        {
                            
                            _loc_11[_loc_12] = projectMapPoint(_loc_10[_loc_12], xConvFunc, yConvFunc, NaN);
                            _loc_12 = _loc_12 + 1;
                        }
                    }
                    _loc_8 = _loc_8 + 1;
                }
            }
            return _loc_7;
        }// end function

        private static function projectPolyline(polyline:Polyline, xConvFunc:Function, yConvFunc:Function, wkid:Number) : Polyline
        {
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:Array = null;
            var _loc_11:Array = null;
            var _loc_12:uint = 0;
            var _loc_13:uint = 0;
            var _loc_5:* = polyline.paths;
            var _loc_6:* = _loc_5 != null ? (new Array(_loc_5.length)) : (null);
            var _loc_7:* = new Polyline(_loc_6, createSR(wkid));
            _loc_7.hasM = polyline.hasM;
            _loc_7.hasZ = polyline.hasZ;
            if (_loc_5)
            {
                _loc_8 = 0;
                _loc_9 = _loc_5.length;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_10 = _loc_5[_loc_8];
                    _loc_11 = _loc_10 != null ? (new Array(_loc_10.length)) : (null);
                    _loc_6[_loc_8] = _loc_11;
                    if (_loc_10)
                    {
                        _loc_12 = 0;
                        _loc_13 = _loc_10.length;
                        while (_loc_12 < _loc_13)
                        {
                            
                            _loc_11[_loc_12] = projectMapPoint(_loc_10[_loc_12], xConvFunc, yConvFunc, NaN);
                            _loc_12 = _loc_12 + 1;
                        }
                    }
                    _loc_8 = _loc_8 + 1;
                }
            }
            return _loc_7;
        }// end function

        static function latitudeToY(latitude:Number) : Number
        {
            var _loc_2:Number = NaN;
            _loc_2 = latitude * RADIANS_PER_DEGREES;
            var _loc_3:* = Math.sin(_loc_2);
            return RADIUS * 0.5 * Math.log((1 + _loc_3) / (1 - _loc_3));
        }// end function

        static function longitudeToX(longitude:Number) : Number
        {
            return longitude * RADIANS_PER_DEGREES * RADIUS;
        }// end function

        static function xToLongitude(x:Number, linear:Boolean = false) : Number
        {
            var _loc_3:Number = NaN;
            _loc_3 = x / RADIUS;
            var _loc_4:* = _loc_3 * DEGREES_PER_RADIANS;
            if (linear)
            {
                return _loc_4;
            }
            var _loc_5:* = Math.floor((_loc_4 + 180) / 360);
            return _loc_4 - _loc_5 * 360;
        }// end function

        static function yToLatitude(y:Number) : Number
        {
            var _loc_2:* = ProjUtils.PI_OVER_2 - 2 * Math.atan(Math.exp(-1 * y / RADIUS));
            return _loc_2 * DEGREES_PER_RADIANS;
        }// end function

        private static function createSR(wkid:Number) : SpatialReference
        {
            var _loc_2:SpatialReference = null;
            if (!isNaN(wkid))
            {
                _loc_2 = new SpatialReference(wkid);
            }
            return _loc_2;
        }// end function

    }
}
