package com.esri.ags.utils
{
    import GeometryUtil.as$41.*;
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.tasks.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class GeometryUtil extends Object
    {
        private static const RADIANS_PER_DEGREES:Number = 0.0174533;
        private static const FLATTENING:Number = 0.00335281;
        private static const ECCENTRICITY_SQUARED:Number = 0.00669438;
        private static const ECCENTRICITY:Number = Math.sqrt(ECCENTRICITY_SQUARED);
        private static const LENGTH_UNITS:Object = {};
        private static const AREA_UNITS:Object = {};

        public function GeometryUtil()
        {
            return;
        }// end function

        public static function normalizeCentralMeridian(geometries:Array, geometryService:GeometryService, responder:IResponder) : void
        {
            normalizeCentralMeridian2(geometries, responder, true, geometryService);
            return;
        }// end function

        static function normalizeCentralMeridian2(geometries:Array, responder:IResponder, simplify:Boolean = false, geometryService:GeometryService = null) : void
        {
            var i:int;
            var il:int;
            var geometry:Geometry;
            var normalizedGeometries:Array;
            var geometriesToBeCut:Array;
            var count:Number;
            var geomExtent:Extent;
            var multiPt:Multipoint;
            var points:Array;
            var point:MapPoint;
            var magnitude:Number;
            var offset:Number;
            var geometriesToBeSimplified:Array;
            var newGeometry:Geometry;
            var newGeometryAsPolygon:Polygon;
            var oldGeometryAsPolygon:Polygon;
            var geometries:* = geometries;
            var responder:* = responder;
            var simplify:* = simplify;
            var geometryService:* = geometryService;
            var getNormalizedCutGeometries:* = function () : void
            {
                i = 0;
                il = normalizedGeometries.length;
                while (i < il)
                {
                    
                    if (normalizedGeometries[i] === "cut")
                    {
                        normalizedGeometries[i] = geometriesToBeCut.shift();
                    }
                    var _loc_2:* = i + 1;
                    i = _loc_2;
                }
                return;
            }// end function
            ;
            if (!responder)
            {
                return;
            }
            if (geometries)
            {
            }
            if (geometries.length == 0)
            {
                responder.result(geometries);
                return;
            }
            normalizedGeometries;
            geometriesToBeCut;
            var normalizedSR:* = geometries[0].spatialReference;
            if (!normalizedSR)
            {
                responder.result(geometries);
                return;
            }
            var info:* = normalizedSR.info;
            if (!info)
            {
                responder.result(geometries);
                return;
            }
            var maxX:Number;
            var minX:Number;
            var webMercatorFlag:Boolean;
            if (normalizedSR.isWebMercator())
            {
                maxX = info.valid[1];
                minX = info.valid[0];
                webMercatorFlag;
            }
            var plus180Line:* = new Polyline([[new MapPoint(maxX, minX), new MapPoint(maxX, maxX)]]);
            var minus180Line:* = new Polyline([[new MapPoint(minX, minX), new MapPoint(minX, maxX)]]);
            var geometryMaxX:Number;
            geometries = ObjectUtil.copy(geometries) as Array;
            var _loc_6:int = 0;
            var _loc_7:* = geometries;
            while (_loc_7 in _loc_6)
            {
                
                geometry = _loc_7[_loc_6];
                geomExtent = geometry.extent;
                if (geometry is MapPoint)
                {
                    normalizedGeometries.push(pointNormalization(geometry as MapPoint, maxX, minX));
                    continue;
                }
                if (geometry is Multipoint)
                {
                    multiPt = geometry as Multipoint;
                    points = multiPt.points;
                    multiPt.points = null;
                    var _loc_8:int = 0;
                    var _loc_9:* = points;
                    while (_loc_9 in _loc_8)
                    {
                        
                        point = _loc_9[_loc_8];
                        multiPt.addPoint(pointNormalization(point, maxX, minX));
                    }
                    normalizedGeometries.push(multiPt);
                    continue;
                }
                if (geometry is Extent)
                {
                    normalizedGeometries.push(geomExtent.normalize(false, false, info));
                    continue;
                }
                magnitude = offsetMagnitude(geomExtent.xmin, minX);
                offset = magnitude * (2 * maxX);
                geometry = offset === 0 ? (geometry) : (updatePolyGeometry(geometry, offset));
                geomExtent = geomExtent.offset(offset, 0);
                if (geomExtent.intersects(plus180Line))
                {
                    geomExtent.intersects(plus180Line);
                }
                if (geomExtent.xmax !== maxX)
                {
                    geometryMaxX = geomExtent.xmax > geometryMaxX ? (geomExtent.xmax) : (geometryMaxX);
                    geometriesToBeCut.push(geometry);
                    normalizedGeometries.push("cut");
                    continue;
                }
                if (geomExtent.intersects(minus180Line))
                {
                    geomExtent.intersects(minus180Line);
                }
                if (geomExtent.xmin !== minX)
                {
                    geometryMaxX = geomExtent.xmax * (2 * maxX) > geometryMaxX ? (geomExtent.xmax * (2 * maxX)) : (geometryMaxX);
                    geometry = updatePolyGeometry(geometry, 2 * maxX);
                    geometriesToBeCut.push(geometry);
                    normalizedGeometries.push("cut");
                    continue;
                }
                normalizedGeometries.push(geometry);
            }
            count = offsetMagnitude(geometryMaxX, maxX);
            if (geometriesToBeCut.length > 0)
            {
            }
            if (count > 0)
            {
                i;
                il = geometriesToBeCut.length;
                while (i < il)
                {
                    
                    geometriesToBeCut[i] = Normalization.normalize(geometriesToBeCut[i]);
                    i = (i + 1);
                }
                geometriesToBeSimplified;
                if (simplify)
                {
                    i;
                    il = normalizedGeometries.length;
                    while (i < il)
                    {
                        
                        if (normalizedGeometries[i] === "cut")
                        {
                            newGeometry = geometriesToBeCut.shift();
                            newGeometryAsPolygon = newGeometry as Polygon;
                            oldGeometryAsPolygon = geometries[i] as Polygon;
                            if (oldGeometryAsPolygon)
                            {
                            }
                            if (oldGeometryAsPolygon.rings)
                            {
                            }
                            if (oldGeometryAsPolygon.rings.length > 1)
                            {
                            }
                            if (newGeometryAsPolygon.rings.length >= oldGeometryAsPolygon.rings.length)
                            {
                                normalizedGeometries[i] = "simplify";
                                geometriesToBeSimplified.push(newGeometry);
                            }
                            else
                            {
                                normalizedGeometries[i] = newGeometry;
                            }
                        }
                        i = (i + 1);
                    }
                }
                if (geometriesToBeSimplified.length > 0)
                {
                    if (!geometryService)
                    {
                        responder.fault(new Fault(null, "GeometryUtil.normalizeCentralMeridian: \'geometryService\' argument is missing."));
                    }
                    else if (!geometryService.url)
                    {
                        responder.fault(new Fault(null, "GeometryUtil.normalizeCentralMeridian: \'geometryService\' url is missing."));
                    }
                    else
                    {
                        geometryService.simplify(geometriesToBeSimplified, new AsyncResponder(simplifyHandler, responder.fault, [normalizedGeometries, responder]));
                    }
                }
                else
                {
                    GeometryUtil.getNormalizedCutGeometries();
                    responder.result(normalizedGeometries);
                }
            }
            else
            {
                GeometryUtil.getNormalizedCutGeometries();
                responder.result(normalizedGeometries);
            }
            return;
        }// end function

        public static function geodesicDensify(geometry:Geometry, maxSegmentLength:Number = 10000) : Geometry
        {
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:int = 0;
            var _loc_14:InverseGeodeticResult = null;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:MapPoint = null;
            var _loc_19:int = 0;
            var _loc_20:Number = NaN;
            var _loc_21:MapPoint = null;
            var _loc_22:Number = NaN;
            var _loc_23:MapPoint = null;
            var _loc_3:Number = 6.37101e+006;
            if (maxSegmentLength < _loc_3 / 10000)
            {
                maxSegmentLength = _loc_3 / 10000;
            }
            if (!(geometry is Polyline))
            {
            }
            if (!(geometry is Polygon))
            {
                throw new Error("GeometryUtil.geodesicDensify: the input geometry is neither polyline nor polygon");
            }
            var _loc_4:* = geometry is Polyline;
            var _loc_5:* = _loc_4 ? (Polyline(geometry).paths) : (Polygon(geometry).rings);
            var _loc_6:Array = [];
            for each (_loc_8 in _loc_5)
            {
                
                _loc_8 = convertPointsToArrays(_loc_8);
                var _loc_26:* = [];
                _loc_7 = [];
                _loc_6.push(_loc_26);
                _loc_7.push(new MapPoint(_loc_8[0][0], _loc_8[0][1]));
                _loc_9 = _loc_8[0][0] * RADIANS_PER_DEGREES;
                _loc_10 = _loc_8[0][1] * RADIANS_PER_DEGREES;
                _loc_13 = 0;
                while (_loc_13 < (_loc_8.length - 1))
                {
                    
                    _loc_11 = _loc_8[(_loc_13 + 1)][0] * RADIANS_PER_DEGREES;
                    _loc_12 = _loc_8[(_loc_13 + 1)][1] * RADIANS_PER_DEGREES;
                    _loc_14 = inverseGeodeticSolver(_loc_10, _loc_9, _loc_12, _loc_11);
                    _loc_15 = _loc_14.azimuth;
                    _loc_16 = _loc_14.geodesicDistance;
                    _loc_17 = _loc_16 / maxSegmentLength;
                    if (_loc_17 > 1)
                    {
                        _loc_19 = 1;
                        while (_loc_19 <= (_loc_17 - 1))
                        {
                            
                            _loc_22 = _loc_19 * maxSegmentLength;
                            _loc_23 = directGeodeticSolver(_loc_10, _loc_9, _loc_15, _loc_22);
                            _loc_7.push(_loc_23);
                            _loc_19 = _loc_19 + 1;
                        }
                        _loc_20 = (_loc_16 + Math.floor((_loc_17 - 1)) * maxSegmentLength) / 2;
                        _loc_21 = directGeodeticSolver(_loc_10, _loc_9, _loc_15, _loc_20);
                        _loc_7.push(_loc_21);
                    }
                    _loc_18 = directGeodeticSolver(_loc_10, _loc_9, _loc_15, _loc_16);
                    _loc_7.push(_loc_18);
                    _loc_9 = _loc_18.x * RADIANS_PER_DEGREES;
                    _loc_10 = _loc_18.y * RADIANS_PER_DEGREES;
                    _loc_13 = _loc_13 + 1;
                }
            }
            if (_loc_4)
            {
                return new Polyline(_loc_6, geometry.spatialReference);
            }
            return new Polygon(_loc_6, geometry.spatialReference);
        }// end function

        public static function geodesicLengths(polylines:Array, lengthUnit:String) : Array
        {
            var _loc_4:Polyline = null;
            var _loc_5:Number = NaN;
            var _loc_6:Array = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:InverseGeodeticResult = null;
            var _loc_13:int = 0;
            var _loc_3:Array = [];
            if (lengthUnit in LENGTH_UNITS)
            {
                for each (_loc_4 in polylines)
                {
                    
                    _loc_5 = 0;
                    for each (_loc_6 in _loc_4.paths)
                    {
                        
                        _loc_7 = 0;
                        _loc_6 = convertPointsToArrays(_loc_6);
                        _loc_13 = 1;
                        while (_loc_13 < _loc_6.length)
                        {
                            
                            _loc_8 = _loc_6[(_loc_13 - 1)][0] * RADIANS_PER_DEGREES;
                            _loc_9 = _loc_6[_loc_13][0] * RADIANS_PER_DEGREES;
                            _loc_10 = _loc_6[(_loc_13 - 1)][1] * RADIANS_PER_DEGREES;
                            _loc_11 = _loc_6[_loc_13][1] * RADIANS_PER_DEGREES;
                            _loc_12 = inverseGeodeticSolver(_loc_10, _loc_8, _loc_11, _loc_9);
                            _loc_7 = _loc_7 + _loc_12.geodesicDistance / 1609.34;
                            _loc_13 = _loc_13 + 1;
                        }
                        _loc_5 = _loc_5 + _loc_7;
                    }
                    _loc_5 = _loc_5 * LENGTH_UNITS[lengthUnit];
                    _loc_3.push(_loc_5);
                }
            }
            else
            {
                throw new Error("GeometryUtil.geodesicLengths: \'lengthUnit\' argument (\'" + lengthUnit + "\') is invalid.");
            }
            return _loc_3;
        }// end function

        public static function geodesicAreas(polygons:Array, areaUnit:String) : Array
        {
            var _loc_4:Polygon = null;
            var _loc_5:Array = null;
            var _loc_6:MapPoint = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Geometry = null;
            var _loc_9:Number = NaN;
            var _loc_10:Array = null;
            var _loc_11:Number = NaN;
            var _loc_12:int = 0;
            var _loc_3:Array = [];
            if (areaUnit in AREA_UNITS)
            {
                _loc_5 = [];
                for each (_loc_4 in polygons)
                {
                    
                    _loc_8 = geodesicDensify(_loc_4, 10000);
                    _loc_5.push(_loc_8);
                }
                for each (_loc_4 in _loc_5)
                {
                    
                    _loc_9 = 0;
                    for each (_loc_10 in _loc_4.rings)
                    {
                        
                        _loc_10 = convertPointsToArrays(_loc_10);
                        _loc_6 = toEqualAreaPoint(new MapPoint(_loc_10[0][0], _loc_10[0][1]));
                        _loc_7 = toEqualAreaPoint(new MapPoint(_loc_10[(_loc_10.length - 1)][0], _loc_10[(_loc_10.length - 1)][1]));
                        _loc_11 = _loc_7.x * _loc_6.y - _loc_6.x * _loc_7.y;
                        _loc_12 = 0;
                        while (_loc_12 < (_loc_10.length - 1))
                        {
                            
                            _loc_6 = toEqualAreaPoint(new MapPoint(_loc_10[(_loc_12 + 1)][0], _loc_10[(_loc_12 + 1)][1]));
                            _loc_7 = toEqualAreaPoint(new MapPoint(_loc_10[_loc_12][0], _loc_10[_loc_12][1]));
                            _loc_11 = _loc_11 + (_loc_7.x * _loc_6.y - _loc_6.x * _loc_7.y);
                            _loc_12 = _loc_12 + 1;
                        }
                        _loc_11 = _loc_11 / 4046.87;
                        _loc_9 = _loc_9 + _loc_11;
                    }
                    _loc_9 = _loc_9 * AREA_UNITS[areaUnit];
                    _loc_3.push(_loc_9 / -2);
                }
            }
            else
            {
                throw new Error("GeometryUtil.geodesicAreas: \'areaUnit\' argument (\'" + areaUnit + "\') is invalid.");
            }
            return _loc_3;
        }// end function

        public static function polygonSelfIntersecting(polygon:Polygon) : Boolean
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:MapPoint = null;
            var _loc_5:MapPoint = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_11:Array = null;
            var _loc_12:int = 0;
            var _loc_13:Array = null;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            if (polygon)
            {
            }
            var _loc_9:* = polygon.rings ? (polygon.rings.length) : (0);
            var _loc_10:int = 0;
            while (_loc_10 < _loc_9)
            {
                
                _loc_11 = polygon.rings[_loc_10];
                _loc_2 = 0;
                while (_loc_2 < (_loc_11.length - 1))
                {
                    
                    _loc_4 = _loc_11[_loc_2];
                    _loc_5 = _loc_11[(_loc_2 + 1)];
                    _loc_6 = [[_loc_4.x, _loc_4.y], [_loc_5.x, _loc_5.y]];
                    _loc_3 = _loc_10 + 1;
                    while (_loc_3 < _loc_9)
                    {
                        
                        _loc_13 = polygon.rings[_loc_3];
                        _loc_14 = 0;
                        while (_loc_14 < (_loc_13.length - 1))
                        {
                            
                            _loc_4 = _loc_13[_loc_14];
                            _loc_5 = _loc_13[(_loc_14 + 1)];
                            _loc_7 = [[_loc_4.x, _loc_4.y], [_loc_5.x, _loc_5.y]];
                            _loc_8 = GeomUtils.getLineIntersection2(_loc_6, _loc_7);
                            if (_loc_8)
                            {
                                if (_loc_8[0] === _loc_6[0][0])
                                {
                                }
                                if (_loc_8[1] !== _loc_6[0][1])
                                {
                                    if (_loc_8[0] === _loc_7[0][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_7[0][1])
                                {
                                    if (_loc_8[0] === _loc_6[1][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_6[1][1])
                                {
                                    if (_loc_8[0] === _loc_7[1][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_7[1][1])
                                {
                                    return true;
                                }
                            }
                            _loc_14 = _loc_14 + 1;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                _loc_12 = _loc_11.length;
                if (_loc_12 <= 4)
                {
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_12 - 3)
                    {
                        
                        _loc_15 = _loc_12 - 1;
                        if (_loc_2 === 0)
                        {
                            _loc_15 = _loc_12 - 2;
                        }
                        _loc_4 = _loc_11[_loc_2];
                        _loc_5 = _loc_11[(_loc_2 + 1)];
                        _loc_6 = [[_loc_4.x, _loc_4.y], [_loc_5.x, _loc_5.y]];
                        _loc_3 = _loc_2 + 2;
                        while (_loc_3 < _loc_15)
                        {
                            
                            _loc_4 = _loc_11[_loc_3];
                            _loc_5 = _loc_11[(_loc_3 + 1)];
                            _loc_7 = [[_loc_4.x, _loc_4.y], [_loc_5.x, _loc_5.y]];
                            _loc_8 = GeomUtils.getLineIntersection2(_loc_6, _loc_7);
                            if (_loc_8)
                            {
                                if (_loc_8[0] === _loc_6[0][0])
                                {
                                }
                                if (_loc_8[1] !== _loc_6[0][1])
                                {
                                    if (_loc_8[0] === _loc_7[0][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_7[0][1])
                                {
                                    if (_loc_8[0] === _loc_6[1][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_6[1][1])
                                {
                                    if (_loc_8[0] === _loc_7[1][0])
                                    {
                                    }
                                }
                                if (_loc_8[1] !== _loc_7[1][1])
                                {
                                    return true;
                                }
                            }
                            _loc_3 = _loc_3 + 1;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                }
                _loc_10 = _loc_10 + 1;
            }
            return false;
        }// end function

        private static function simplifyHandler(simplifiedGeometries:Array, token:Array) : void
        {
            var _loc_3:* = token[0];
            var _loc_4:* = token[1];
            var _loc_5:int = 0;
            var _loc_6:* = _loc_3.length;
            while (_loc_5 < _loc_6)
            {
                
                if (_loc_3[_loc_5] === "simplify")
                {
                    _loc_3[_loc_5] = simplifiedGeometries.shift();
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_4.result(_loc_3);
            return;
        }// end function

        private static function offsetMagnitude(xCoord:Number, offsetFromX:Number) : Number
        {
            return Math.ceil((xCoord - offsetFromX) / (offsetFromX * 2));
        }// end function

        private static function pointNormalization(point:MapPoint, maxX:Number, minX:Number) : MapPoint
        {
            var _loc_5:Number = NaN;
            var _loc_4:* = point.x;
            if (_loc_4 > maxX)
            {
                _loc_5 = offsetMagnitude(_loc_4, maxX);
                point = point.offset(_loc_5 * (-2 * maxX), 0);
            }
            else if (_loc_4 < minX)
            {
                _loc_5 = offsetMagnitude(_loc_4, minX);
                point = point.offset(_loc_5 * (-2 * minX), 0);
            }
            return point;
        }// end function

        private static function updatePolyGeometry(geometry:Geometry, offsetX:Number) : Geometry
        {
            var _loc_3:Array = null;
            var _loc_4:Polygon = null;
            var _loc_5:Polyline = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:MapPoint = null;
            if (geometry is Polygon)
            {
                _loc_4 = geometry as Polygon;
                _loc_3 = _loc_4.rings;
                _loc_4.rings = _loc_3;
            }
            else if (geometry is Polyline)
            {
                _loc_5 = geometry as Polyline;
                _loc_3 = _loc_5.paths;
                _loc_5.paths = _loc_3;
            }
            if (_loc_3)
            {
                _loc_6 = 0;
                _loc_7 = _loc_3.length;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_8 = _loc_3[_loc_6];
                    _loc_9 = 0;
                    _loc_10 = _loc_8.length;
                    while (_loc_9 < _loc_10)
                    {
                        
                        _loc_11 = _loc_8[_loc_9];
                        _loc_8[_loc_9] = _loc_11.offset(offsetX, 0);
                        _loc_9 = _loc_9 + 1;
                    }
                    _loc_6 = _loc_6 + 1;
                }
            }
            return geometry;
        }// end function

        private static function toEqualAreaPoint(pt:MapPoint) : MapPoint
        {
            var _loc_2:Number = 6378137;
            var _loc_3:* = ECCENTRICITY_SQUARED;
            var _loc_4:* = ECCENTRICITY;
            var _loc_5:* = Math.sin(pt.y * RADIANS_PER_DEGREES);
            var _loc_6:* = (1 - _loc_3) * (_loc_5 / (1 - _loc_3 * (_loc_5 * _loc_5)) - 1 / (2 * _loc_4) * Math.log((1 - _loc_4 * _loc_5) / (1 + _loc_4 * _loc_5)));
            var _loc_7:* = _loc_2 * pt.x * RADIANS_PER_DEGREES;
            var _loc_8:* = _loc_2 * _loc_6 * 0.5;
            var _loc_9:* = new MapPoint(_loc_7, _loc_8);
            return _loc_9;
        }// end function

        private static function directGeodeticSolver(lat1:Number, lon1:Number, alpha1:Number, s:Number) : MapPoint
        {
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_32:Number = NaN;
            var _loc_5:Number = 6378137;
            var _loc_6:Number = 6.35675e+006;
            var _loc_7:* = 1 / 298.257;
            var _loc_8:* = Math.sin(alpha1);
            var _loc_9:* = Math.cos(alpha1);
            var _loc_10:* = (1 - _loc_7) * Math.tan(lat1);
            var _loc_11:* = 1 / Math.sqrt(1 + _loc_10 * _loc_10);
            var _loc_12:* = _loc_10 * _loc_11;
            var _loc_13:* = Math.atan2(_loc_10, _loc_9);
            var _loc_14:* = _loc_11 * _loc_8;
            var _loc_15:* = 1 - _loc_14 * _loc_14;
            var _loc_16:* = _loc_15 * (_loc_5 * _loc_5 - _loc_6 * _loc_6) / (_loc_6 * _loc_6);
            var _loc_17:* = 1 + _loc_16 / 16384 * (4096 + _loc_16 * (-768 + _loc_16 * (320 - 175 * _loc_16)));
            var _loc_18:* = _loc_16 / 1024 * (256 + _loc_16 * (-128 + _loc_16 * (74 - 47 * _loc_16)));
            var _loc_19:* = s / (_loc_6 * _loc_17);
            var _loc_20:* = 2 * Math.PI;
            while (Math.abs(_loc_19 - _loc_20) > 1e-012)
            {
                
                _loc_23 = Math.cos(2 * _loc_13 + _loc_19);
                _loc_21 = Math.sin(_loc_19);
                _loc_22 = Math.cos(_loc_19);
                _loc_32 = _loc_18 * _loc_21 * (_loc_23 + _loc_18 / 4 * (_loc_22 * (-1 + 2 * _loc_23 * _loc_23) - _loc_18 / 6 * _loc_23 * (-3 + 4 * _loc_21 * _loc_21) * (-3 + 4 * _loc_23 * _loc_23)));
                _loc_20 = _loc_19;
                _loc_19 = s / (_loc_6 * _loc_17) + _loc_32;
            }
            var _loc_24:* = _loc_12 * _loc_21 - _loc_11 * _loc_22 * _loc_9;
            var _loc_25:* = Math.atan2(_loc_12 * _loc_22 + _loc_11 * _loc_21 * _loc_9, (1 - _loc_7) * Math.sqrt(_loc_14 * _loc_14 + _loc_24 * _loc_24));
            var _loc_26:* = Math.atan2(_loc_21 * _loc_8, _loc_11 * _loc_22 - _loc_12 * _loc_21 * _loc_9);
            var _loc_27:* = _loc_7 / 16 * _loc_15 * (4 + _loc_7 * (4 - 3 * _loc_15));
            var _loc_28:* = _loc_26 - (1 - _loc_27) * _loc_7 * _loc_14 * (_loc_19 + _loc_27 * _loc_21 * (_loc_23 + _loc_27 * _loc_22 * (-1 + 2 * _loc_23 * _loc_23)));
            var _loc_29:* = _loc_25 / (Math.PI / 180);
            var _loc_30:* = (lon1 + _loc_28) / (Math.PI / 180);
            var _loc_31:* = new MapPoint(_loc_30, _loc_29);
            return _loc_31;
        }// end function

        private static function inverseGeodeticSolver(lat1:Number, lon1:Number, lat2:Number, lon2:Number) : InverseGeodeticResult
        {
            var _loc_17:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_31:Number = NaN;
            var _loc_32:Number = NaN;
            var _loc_33:Number = NaN;
            var _loc_34:Number = NaN;
            var _loc_35:Number = NaN;
            var _loc_36:Number = NaN;
            var _loc_37:Number = NaN;
            var _loc_38:Number = NaN;
            var _loc_39:Number = NaN;
            var _loc_40:Number = NaN;
            var _loc_5:* = new InverseGeodeticResult();
            var _loc_6:Number = 6378137;
            var _loc_7:Number = 6.35675e+006;
            var _loc_8:* = 1 / 298.257;
            var _loc_9:* = lon2 - lon1;
            var _loc_10:* = Math.atan((1 - _loc_8) * Math.tan(lat1));
            var _loc_11:* = Math.atan((1 - _loc_8) * Math.tan(lat2));
            var _loc_12:* = Math.sin(_loc_10);
            var _loc_13:* = Math.cos(_loc_10);
            var _loc_14:* = Math.sin(_loc_11);
            var _loc_15:* = Math.cos(_loc_11);
            var _loc_16:* = _loc_9;
            var _loc_18:Number = 1000;
            do
            {
                
                _loc_31 = Math.sin(_loc_16);
                _loc_32 = Math.cos(_loc_16);
                _loc_20 = Math.sqrt(_loc_15 * _loc_31 * (_loc_15 * _loc_31) + (_loc_13 * _loc_14 - _loc_12 * _loc_15 * _loc_32) * (_loc_13 * _loc_14 - _loc_12 * _loc_15 * _loc_32));
                if (_loc_20 === 0)
                {
                    _loc_5.azimuth = 0;
                    _loc_5.geodesicDistance = 0;
                    _loc_5.reverseAzimuth = 0;
                    return _loc_5;
                }
                _loc_22 = _loc_12 * _loc_14 + _loc_13 * _loc_15 * _loc_32;
                _loc_23 = Math.atan2(_loc_20, _loc_22);
                _loc_33 = _loc_13 * _loc_15 * _loc_31 / _loc_20;
                _loc_19 = 1 - _loc_33 * _loc_33;
                _loc_21 = _loc_22 - 2 * _loc_12 * _loc_14 / _loc_19;
                if (isNaN(_loc_21))
                {
                    _loc_21 = 0;
                }
                _loc_34 = _loc_8 / 16 * _loc_19 * (4 + _loc_8 * (4 - 3 * _loc_19));
                _loc_17 = _loc_16;
                _loc_16 = _loc_9 + (1 - _loc_34) * _loc_8 * _loc_33 * (_loc_23 + _loc_34 * _loc_20 * (_loc_21 + _loc_34 * _loc_22 * (-1 + 2 * _loc_21 * _loc_21)));
                if (Math.abs(_loc_16 - _loc_17) > 1e-012)
                {
                }
            }while (--_loc_18 > 0)
            if (--_loc_18 === 0)
            {
                _loc_35 = 6371009;
                _loc_36 = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1)) * _loc_35;
                _loc_37 = lon2 - lon1;
                _loc_38 = Math.sin(_loc_37) * Math.cos(lat2);
                _loc_39 = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(_loc_37);
                _loc_40 = Math.atan2(_loc_38, _loc_39);
                _loc_5.azimuth = _loc_40;
                _loc_5.geodesicDistance = _loc_36;
                return _loc_5;
            }
            var _loc_24:* = _loc_19 * (_loc_6 * _loc_6 - _loc_7 * _loc_7) / (_loc_7 * _loc_7);
            var _loc_25:* = 1 + _loc_24 / 16384 * (4096 + _loc_24 * (-768 + _loc_24 * (320 - 175 * _loc_24)));
            var _loc_26:* = _loc_24 / 1024 * (256 + _loc_24 * (-128 + _loc_24 * (74 - 47 * _loc_24)));
            var _loc_27:* = _loc_26 * _loc_20 * (_loc_21 + _loc_26 / 4 * (_loc_22 * (-1 + 2 * _loc_21 * _loc_21) - _loc_26 / 6 * _loc_21 * (-3 + 4 * _loc_20 * _loc_20) * (-3 + 4 * _loc_21 * _loc_21)));
            var _loc_28:* = _loc_7 * _loc_25 * (_loc_23 - _loc_27);
            var _loc_29:* = Math.atan2(_loc_15 * Math.sin(_loc_16), _loc_13 * _loc_14 - _loc_12 * _loc_15 * Math.cos(_loc_16));
            var _loc_30:* = Math.atan2(_loc_13 * Math.sin(_loc_16), _loc_13 * _loc_14 * Math.cos(_loc_16) - _loc_12 * _loc_15);
            _loc_5.azimuth = _loc_29;
            _loc_5.geodesicDistance = _loc_28;
            _loc_5.reverseAzimuth = _loc_30;
            return _loc_5;
        }// end function

        private static function convertPointsToArrays(points:Array) : Array
        {
            var _loc_3:MapPoint = null;
            var _loc_2:Array = [];
            for each (_loc_3 in points)
            {
                
                _loc_2.push([_loc_3.x, _loc_3.y]);
            }
            return _loc_2;
        }// end function

        LENGTH_UNITS[Units.MILES] = 1;
        LENGTH_UNITS[Units.KILOMETERS] = 1.60934;
        LENGTH_UNITS[Units.FEET] = 5280;
        LENGTH_UNITS[Units.METERS] = 1609.34;
        LENGTH_UNITS[Units.YARDS] = 1760;
        LENGTH_UNITS[Units.NAUTICAL_MILES] = 0.869;
        LENGTH_UNITS[Units.CENTIMETERS] = 160934;
        LENGTH_UNITS[Units.DECIMETERS] = 16093.4;
        LENGTH_UNITS[Units.INCHES] = 63360;
        LENGTH_UNITS[Units.MILLIMETERS] = 1609340;
        AREA_UNITS[Units.ACRES] = 1;
        AREA_UNITS[Units.ARES] = 40.4686;
        AREA_UNITS[Units.SQUARE_KILOMETERS] = 0.00404686;
        AREA_UNITS[Units.SQUARE_MILES] = 0.0015625;
        AREA_UNITS[Units.SQUARE_FEET] = 43560;
        AREA_UNITS[Units.SQUARE_METERS] = 4046.86;
        AREA_UNITS[Units.HECTARES] = 0.404686;
        AREA_UNITS[Units.SQUARE_YARDS] = 4840;
        AREA_UNITS[Units.SQUARE_INCHES] = 6272640;
        AREA_UNITS[Units.SQUARE_MILLIMETERS] = 4046856420;
        AREA_UNITS[Units.SQUARE_CENTIMETERS] = 4.04686e+007;
        AREA_UNITS[Units.SQUARE_DECIMETERS] = 404686;
    }
}
