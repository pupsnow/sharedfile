package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class GeometryService extends BaseTask
    {
        private var _1406379444projectLastResult:Array;
        private var _879103036simplifyLastResult:Array;
        private var _1333289293bufferLastResult:Array;
        private var _2132230016lengthsLastResult:Array;
        private var _1712781809areasAndLengthsLastResult:AreasAndLengthsResult;
        private var _1080791722labelPointsLastResult:Array;
        private var _166131345relationLastResult:Array;
        private var _1681442776distanceLastResult:Number;
        private var _40916039convexHullLastResult:Geometry;
        private var _663053126offsetLastResult:Array;
        private var _1078768975trimExtendLastResult:Array;
        private var _1925444897generalizeLastResult:Array;
        private var _698172539autoCompleteLastResult:Array;
        private var _1068047831densifyLastResult:Array;
        private var _543519285cutLastResult:CutResult;
        private var _2033358992differenceLastResult:Array;
        private var _1247487186intersectLastResult:Array;
        private var _713407106unionLastResult:Geometry;
        private var _1834793537reshapeLastResult:Geometry;
        public static const UNIT_METER:Number = 9001;
        public static const UNIT_FOOT:Number = 9002;
        public static const UNIT_KILOMETER:Number = 9036;
        public static const UNIT_STATUTE_MILE:Number = 9093;
        public static const UNIT_NAUTICAL_MILE:Number = 9030;
        public static const UNIT_US_NAUTICAL_MILE:Number = 109012;
        public static const UNIT_SQUARE_INCHES:String = "esriSquareInches";
        public static const UNIT_SQUARE_FEET:String = "esriSquareFeet";
        public static const UNIT_SQUARE_YARDS:String = "esriSquareYards";
        public static const UNIT_ACRES:String = "esriAcres";
        public static const UNIT_SQUARE_MILES:String = "esriSquareMiles";
        public static const UNIT_SQUARE_MILLIMETERS:String = "esriSquareMillimeters";
        public static const UNIT_SQUARE_CENTIMETERS:String = "esriSquareCentimeters";
        public static const UNIT_SQUARE_DECIMETERS:String = "esriSquareDecimeters";
        public static const UNIT_SQUARE_METERS:String = "esriSquareMeters";
        public static const UNIT_ARES:String = "esriAres";
        public static const UNIT_HECTARES:String = "esriHectares";
        public static const UNIT_SQUARE_KILOMETERS:String = "esriSquareKilometers";

        public function GeometryService(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function project(projectParameters:ProjectParameters, responder:IResponder = null) : AsyncToken
        {
            var geometryType:String;
            var handleProject:Function;
            var projectParameters:* = projectParameters;
            var responder:* = responder;
            handleProject = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], projectParameters.outSpatialReference, geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                projectLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(projectLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.PROJECT_COMPLETE, projectLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::project:{1}", id, projectParameters.geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            var geometries:* = projectParameters.geometries;
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometryType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.inSR = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (projectParameters.outSpatialReference)
            {
                urlVariables.outSR = projectParameters.outSpatialReference.toSR();
            }
            if (projectParameters.datumTransform)
            {
                urlVariables.transformation = projectParameters.datumTransform.toDatumTransform();
                urlVariables.transformForward = projectParameters.transformForward;
            }
            return sendURLVariables("/project", urlVariables, responder, handleProject);
        }// end function

        public function simplify(geometries:Array, responder:IResponder = null) : AsyncToken
        {
            var geometryType:String;
            var handleSimplify:Function;
            var geometries:* = geometries;
            var responder:* = responder;
            handleSimplify = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], geometries[0].spatialReference, geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                simplifyLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(_loc_3);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.SIMPLIFY_COMPLETE, _loc_3));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::simplify:{1}", id, geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometryType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            return sendURLVariables("/simplify", urlVariables, responder, handleSimplify);
        }// end function

        public function buffer(bufferParameters:BufferParameters, responder:IResponder = null) : AsyncToken
        {
            var geometries:Array;
            var geometryType:String;
            var handleBuffer:Function;
            var bufferParameters:* = bufferParameters;
            var responder:* = responder;
            handleBuffer = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:SpatialReference = null;
                var _loc_5:Object = null;
                var _loc_6:IResponder = null;
                var _loc_7:Polygon = null;
                var _loc_3:Array = [];
                if (bufferParameters.outSpatialReference)
                {
                    _loc_4 = bufferParameters.outSpatialReference;
                }
                else
                {
                    _loc_4 = geometries[0].spatialReference;
                }
                for each (_loc_5 in decodedObject.geometries)
                {
                    
                    _loc_7 = Polygon.fromJSON(_loc_5);
                    _loc_7.spatialReference = _loc_4;
                    _loc_3.push(_loc_7);
                }
                bufferLastResult = _loc_3;
                for each (_loc_6 in asyncToken.responders)
                {
                    
                    _loc_6.result(_loc_3);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.BUFFER_COMPLETE, _loc_3));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::buffer:{1}", id, ObjectUtil.toString(bufferParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            geometries = bufferParameters.geometries.slice();
            var i:int;
            while (i < geometries.length)
            {
                
                if (geometries[i].type == Geometry.EXTENT)
                {
                    geometries[i] = (geometries[i] as Extent).toPolygon();
                }
                i = (i + 1);
            }
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometryType = geometries[0].type == Geometry.EXTENT ? (Geometry.POLYGON) : (geometries[0].type);
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.inSR = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (bufferParameters.outSpatialReference)
            {
                urlVariables.outSR = bufferParameters.outSpatialReference.toSR();
            }
            if (bufferParameters.bufferSpatialReference)
            {
                urlVariables.bufferSR = bufferParameters.bufferSpatialReference.toSR();
            }
            urlVariables.unionResults = bufferParameters.unionResults;
            if (!isNaN(bufferParameters.unit))
            {
                urlVariables.unit = bufferParameters.unit;
            }
            if (bufferParameters.distances)
            {
                urlVariables.distances = bufferParameters.distances.join();
            }
            if (bufferParameters.geodesic)
            {
                urlVariables.geodesic = bufferParameters.geodesic;
            }
            return sendURLVariables("/buffer", urlVariables, responder, handleBuffer);
        }// end function

        public function lengths(lengthsParameters:LengthsParameters, responder:IResponder = null) : AsyncToken
        {
            var handleLengths:Function;
            var lengthsParameters:* = lengthsParameters;
            var responder:* = responder;
            handleLengths = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:Number = NaN;
                var _loc_5:IResponder = null;
                var _loc_3:Array = [];
                for each (_loc_4 in decodedObject.lengths)
                {
                    
                    _loc_3.push(_loc_4);
                }
                lengthsLastResult = _loc_3;
                for each (_loc_5 in asyncToken.responders)
                {
                    
                    _loc_5.result(lengthsLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.LENGTHS_COMPLETE, lengthsLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::lengths:{1}", id, ObjectUtil.toString(lengthsParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (lengthsParameters.polylines)
            {
            }
            if (lengthsParameters.polylines.length >= 1)
            {
                urlVariables.polylines = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(lengthsParameters.polylines));
                if (lengthsParameters.polylines[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = lengthsParameters.polylines[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.polylines = "";
            }
            if (!isNaN(lengthsParameters.lengthUnit))
            {
                urlVariables.lengthUnit = lengthsParameters.lengthUnit;
            }
            if (lengthsParameters.calculationType)
            {
                urlVariables.calculationType = lengthsParameters.calculationType;
            }
            else if (lengthsParameters.geodesic)
            {
                urlVariables.geodesic = lengthsParameters.geodesic;
            }
            return sendURLVariables("/lengths", urlVariables, responder, handleLengths);
        }// end function

        public function areasAndLengths(areasAndLengthsParameters:AreasAndLengthsParameters, responder:IResponder = null) : AsyncToken
        {
            var handleAreaLengths:Function;
            var areaUnitNum:Number;
            var areasAndLengthsParameters:* = areasAndLengthsParameters;
            var responder:* = responder;
            handleAreaLengths = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_3:* = new AreasAndLengthsResult();
                _loc_3.areas = decodedObject.areas ? (decodedObject.areas) : (null);
                _loc_3.lengths = decodedObject.lengths ? (decodedObject.lengths) : (null);
                areasAndLengthsLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(areasAndLengthsLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.AREAS_AND_LENGTHS_COMPLETE, areasAndLengthsLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::areasAndLengths:{1}", id, ObjectUtil.toString(areasAndLengthsParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (areasAndLengthsParameters.polygons)
            {
            }
            if (areasAndLengthsParameters.polygons.length >= 1)
            {
                urlVariables.polygons = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(areasAndLengthsParameters.polygons));
                if (areasAndLengthsParameters.polygons[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = areasAndLengthsParameters.polygons[0].spatialReference.toSR();
                }
            }
            if (areasAndLengthsParameters.areaUnit)
            {
                areaUnitNum = Number(areasAndLengthsParameters.areaUnit);
                if (isNaN(areaUnitNum))
                {
                    urlVariables.areaUnit = JSONUtil.encode({areaUnit:areasAndLengthsParameters.areaUnit});
                }
                else
                {
                    urlVariables.areaUnit = areaUnitNum;
                }
            }
            if (!isNaN(areasAndLengthsParameters.lengthUnit))
            {
                urlVariables.lengthUnit = areasAndLengthsParameters.lengthUnit;
            }
            if (areasAndLengthsParameters.calculationType)
            {
                urlVariables.calculationType = areasAndLengthsParameters.calculationType;
            }
            return sendURLVariables("/areasAndLengths", urlVariables, responder, handleAreaLengths);
        }// end function

        public function labelPoints(polygons:Array, responder:IResponder = null) : AsyncToken
        {
            var handleLabelPoints:Function;
            var polygons:* = polygons;
            var responder:* = responder;
            handleLabelPoints = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_6:MapPoint = null;
                var _loc_3:Array = [];
                if (decodedObject.labelPoints)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.labelPoints.length)
                    {
                        
                        _loc_6 = MapPoint.fromJSON(decodedObject.labelPoints[_loc_5]);
                        _loc_6.spatialReference = polygons[0].spatialReference;
                        _loc_3.push(_loc_6);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                labelPointsLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(labelPointsLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.LABEL_POINTS_COMPLETE, labelPointsLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::labelPoints:{1}", id, polygons);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (polygons)
            {
            }
            if (polygons.length >= 1)
            {
                urlVariables.polygons = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(polygons));
                if (polygons[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = polygons[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.polygons = "";
            }
            return sendURLVariables("/labelPoints", urlVariables, responder, handleLabelPoints);
        }// end function

        public function relation(relationParameters:RelationParameters, responder:IResponder = null) : AsyncToken
        {
            var handleRelation:Function;
            var geometryType1:String;
            var geometryType2:String;
            var relationParameters:* = relationParameters;
            var responder:* = responder;
            handleRelation = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:Object = null;
                var _loc_5:IResponder = null;
                var _loc_3:Array = [];
                for each (_loc_4 in decodedObject.relations)
                {
                    
                    _loc_4.geometry1 = relationParameters.geometries1[_loc_4.geometry1Index];
                    _loc_4.geometry2 = relationParameters.geometries2[_loc_4.geometry2Index];
                    _loc_3.push(_loc_4);
                }
                relationLastResult = _loc_3;
                for each (_loc_5 in asyncToken.responders)
                {
                    
                    _loc_5.result(relationLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.RELATION_COMPLETE, relationLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::relation:{1}", id, ObjectUtil.toString(relationParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (relationParameters.geometries1)
            {
            }
            if (relationParameters.geometries1.length >= 1)
            {
                geometryType1 = relationParameters.geometries1[0].type;
                urlVariables.geometries1 = JSONUtil.encode({geometryType:geometryType1, geometries:JSONUtil.toJSONArrayNoSR(relationParameters.geometries1)});
                if (relationParameters.geometries1[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = relationParameters.geometries1[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries1 = "";
            }
            if (relationParameters.geometries2)
            {
                geometryType2 = relationParameters.geometries2[0].type;
                urlVariables.geometries2 = JSONUtil.encode({geometryType:geometryType2, geometries:JSONUtil.toJSONArrayNoSR(relationParameters.geometries2)});
            }
            else
            {
                urlVariables.geometries2 = "";
            }
            if (relationParameters.spatialRelationship)
            {
                urlVariables.relation = relationParameters.spatialRelationship;
            }
            if (relationParameters.comparisonString)
            {
                urlVariables.relationParam = relationParameters.comparisonString;
            }
            return sendURLVariables("/relation", urlVariables, responder, handleRelation);
        }// end function

        public function distance(distanceParameters:DistanceParameters, responder:IResponder = null) : AsyncToken
        {
            var handleDistance:Function;
            var geometryType1:String;
            var jsonGeometry1:Object;
            var geometryType2:String;
            var jsonGeometry2:Object;
            var distanceParameters:* = distanceParameters;
            var responder:* = responder;
            handleDistance = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                distanceLastResult = decodedObject.distance;
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.result(distanceLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.DISTANCE_COMPLETE, distanceLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::distance:{1}", id, ObjectUtil.toString(distanceParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (distanceParameters.geometry1)
            {
                geometryType1 = distanceParameters.geometry1.type;
                jsonGeometry1 = distanceParameters.geometry1.toJSON();
                delete jsonGeometry1.spatialReference;
                urlVariables.geometry1 = JSONUtil.encode({geometryType:geometryType1, geometry:jsonGeometry1});
                if (distanceParameters.geometry1.spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = distanceParameters.geometry1.spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometry1 = "";
            }
            if (distanceParameters.geometry2)
            {
                geometryType2 = distanceParameters.geometry2.type;
                jsonGeometry2 = distanceParameters.geometry2.toJSON();
                delete jsonGeometry2.spatialReference;
                urlVariables.geometry2 = JSONUtil.encode({geometryType:geometryType2, geometry:jsonGeometry2});
            }
            else
            {
                urlVariables.geometry2 = "";
            }
            if (!isNaN(distanceParameters.distanceUnit))
            {
                urlVariables.distanceUnit = distanceParameters.distanceUnit;
            }
            if (distanceParameters.geodesic)
            {
                urlVariables.geodesic = distanceParameters.geodesic;
            }
            return sendURLVariables("/distance", urlVariables, responder, handleDistance);
        }// end function

        public function convexHull(geometries:Array, outSR:SpatialReference, responder:IResponder = null) : AsyncToken
        {
            var handleConvexHull:Function;
            var geometryType:String;
            var geometries:* = geometries;
            var outSR:* = outSR;
            var responder:* = responder;
            handleConvexHull = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_3:* = new Geometry();
                if (decodedObject.geometry)
                {
                    _loc_3 = Geometry.fromJSON2(decodedObject.geometry, outSR, decodedObject.geometryType);
                }
                convexHullLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(_loc_3);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.CONVEX_HULL_COMPLETE, _loc_3));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::convexHull:{1}", id, geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometryType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (outSR)
            {
                urlVariables.sr = outSR.toSR();
            }
            return sendURLVariables("/convexHull", urlVariables, responder, handleConvexHull);
        }// end function

        public function offset(offsetParameters:OffsetParameters, responder:IResponder = null) : AsyncToken
        {
            var handleOffset:Function;
            var offsetParameters:* = offsetParameters;
            var responder:* = responder;
            handleOffset = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], offsetParameters.geometries[0].spatialReference, decodedObject.geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                offsetLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(offsetLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.OFFSET_COMPLETE, offsetLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::offset:{1}", id, ObjectUtil.toString(offsetParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (offsetParameters.geometries)
            {
            }
            if (offsetParameters.geometries.length >= 1)
            {
                urlVariables.geometries = JSONUtil.encode({geometryType:offsetParameters.geometries[0].type, geometries:JSONUtil.toJSONArrayNoSR(offsetParameters.geometries)});
                if (offsetParameters.geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = offsetParameters.geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (!isNaN(offsetParameters.offsetDistance))
            {
                urlVariables.offsetDistance = offsetParameters.offsetDistance;
            }
            if (offsetParameters.offsetHow)
            {
                urlVariables.offsetHow = offsetParameters.offsetHow;
            }
            if (!isNaN(offsetParameters.bevelRatio))
            {
                urlVariables.bevelRatio = offsetParameters.bevelRatio;
            }
            if (!isNaN(offsetParameters.offsetUnit))
            {
                urlVariables.offsetUnit = offsetParameters.offsetUnit;
            }
            return sendURLVariables("/offset", urlVariables, responder, handleOffset);
        }// end function

        public function trimExtend(trimExtendParameters:TrimExtendParameters, responder:IResponder = null) : AsyncToken
        {
            var handleTrimExtend:Function;
            var jsonTrimExtendPolyline:Object;
            var trimExtendParameters:* = trimExtendParameters;
            var responder:* = responder;
            handleTrimExtend = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_6:Polyline = null;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_6 = Polyline.fromJSON(decodedObject.geometries[_loc_5]);
                        _loc_6.spatialReference = trimExtendParameters.polylines[0].spatialReference;
                        _loc_3.push(_loc_6);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                trimExtendLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(trimExtendLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.TRIM_EXTEND_COMPLETE, trimExtendLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::trimExtend:{1}", id, ObjectUtil.toString(trimExtendParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (trimExtendParameters.polylines)
            {
            }
            if (trimExtendParameters.polylines.length >= 1)
            {
                urlVariables.polylines = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(trimExtendParameters.polylines));
                if (trimExtendParameters.polylines[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = trimExtendParameters.polylines[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.polylines = "";
            }
            if (trimExtendParameters.trimExtendPolyline)
            {
                jsonTrimExtendPolyline = trimExtendParameters.trimExtendPolyline.toJSON();
                delete jsonTrimExtendPolyline.spatialReference;
                urlVariables.trimExtendTo = JSONUtil.encode(jsonTrimExtendPolyline);
            }
            else
            {
                urlVariables.trimExtendTo = "";
            }
            if (!isNaN(trimExtendParameters.extendHow))
            {
                urlVariables.extendHow = trimExtendParameters.extendHow;
            }
            return sendURLVariables("/trimExtend", urlVariables, responder, handleTrimExtend);
        }// end function

        public function generalize(generalizeParameters:GeneralizeParameters, responder:IResponder = null) : AsyncToken
        {
            var handleGeneralize:Function;
            var geometryType:String;
            var generalizeParameters:* = generalizeParameters;
            var responder:* = responder;
            handleGeneralize = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], generalizeParameters.geometries[0].spatialReference, decodedObject.geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                generalizeLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(generalizeLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.GENERALIZE_COMPLETE, generalizeLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::generalize:{1}", id, ObjectUtil.toString(generalizeParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (generalizeParameters.geometries)
            {
            }
            if (generalizeParameters.geometries.length >= 1)
            {
                geometryType = generalizeParameters.geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(generalizeParameters.geometries)});
                if (generalizeParameters.geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = generalizeParameters.geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (!isNaN(generalizeParameters.maxDeviation))
            {
                urlVariables.maxDeviation = generalizeParameters.maxDeviation;
            }
            if (!isNaN(generalizeParameters.deviationUnit))
            {
                urlVariables.deviationUnit = generalizeParameters.deviationUnit;
            }
            return sendURLVariables("/generalize", urlVariables, responder, handleGeneralize);
        }// end function

        public function autoComplete(polygons:Array, polylines:Array, responder:IResponder = null) : AsyncToken
        {
            var handleAutoComplete:Function;
            var polygons:* = polygons;
            var polylines:* = polylines;
            var responder:* = responder;
            handleAutoComplete = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_6:Polygon = null;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_6 = Polygon.fromJSON(decodedObject.geometries[_loc_5]);
                        _loc_6.spatialReference = polygons[0].spatialReference;
                        _loc_3.push(_loc_6);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                autoCompleteLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(autoCompleteLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.AUTO_COMPLETE_COMPLETE, autoCompleteLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::autoComplete:{1}", id, polygons, polylines);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (polygons)
            {
            }
            if (polygons.length >= 1)
            {
                urlVariables.polygons = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(polygons));
                if (polygons[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = polygons[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.polygons = "";
            }
            if (polylines)
            {
            }
            if (polylines.length >= 1)
            {
                urlVariables.polylines = JSONUtil.encode(JSONUtil.toJSONArrayNoSR(polylines));
            }
            else
            {
                urlVariables.polylines = "";
            }
            return sendURLVariables("/autoComplete", urlVariables, responder, handleAutoComplete);
        }// end function

        public function densify(densifyParameters:DensifyParameters, responder:IResponder = null) : AsyncToken
        {
            var handleDensify:Function;
            var densifyParameters:* = densifyParameters;
            var responder:* = responder;
            handleDensify = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], densifyParameters.geometries[0].spatialReference, decodedObject.geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                densifyLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(densifyLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.DENSIFY_COMPLETE, densifyLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::densify:{1}", id, ObjectUtil.toString(densifyParameters));
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (densifyParameters.geometries)
            {
            }
            if (densifyParameters.geometries.length >= 1)
            {
                urlVariables.geometries = JSONUtil.encode({geometryType:densifyParameters.geometries[0].type, geometries:JSONUtil.toJSONArrayNoSR(densifyParameters.geometries)});
                if (densifyParameters.geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = densifyParameters.geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (!isNaN(densifyParameters.maxSegmentLength))
            {
                urlVariables.maxSegmentLength = densifyParameters.maxSegmentLength;
            }
            urlVariables.geodesic = densifyParameters.geodesic;
            if (!isNaN(densifyParameters.lengthUnit))
            {
                urlVariables.lengthUnit = densifyParameters.lengthUnit;
            }
            return sendURLVariables("/densify", urlVariables, responder, handleDensify);
        }// end function

        public function cut(targetGeometries:Array, cutterPolyline:Polyline, responder:IResponder = null) : AsyncToken
        {
            var handleCut:Function;
            var targetGeometryType:String;
            var jsonCutterPolyline:Object;
            var targetGeometries:* = targetGeometries;
            var cutterPolyline:* = cutterPolyline;
            var responder:* = responder;
            handleCut = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_5:IResponder = null;
                var _loc_6:int = 0;
                var _loc_3:* = new CutResult();
                var _loc_4:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_6 = 0;
                    while (_loc_6 < decodedObject.geometries.length)
                    {
                        
                        _loc_4.push(Geometry.fromJSON2(decodedObject.geometries[_loc_6], targetGeometries[0].spatialReference, decodedObject.geometryType));
                        _loc_6 = _loc_6 + 1;
                    }
                }
                _loc_3.geometries = _loc_4;
                _loc_3.cutIndexes = decodedObject.cutIndexes;
                cutLastResult = _loc_3;
                for each (_loc_5 in asyncToken.responders)
                {
                    
                    _loc_5.result(cutLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.CUT_COMPLETE, cutLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::cut:{1}", id, targetGeometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (targetGeometries)
            {
            }
            if (targetGeometries.length >= 1)
            {
                targetGeometryType = targetGeometries[0].type;
                urlVariables.target = JSONUtil.encode({geometryType:targetGeometryType, geometries:JSONUtil.toJSONArrayNoSR(targetGeometries)});
                if (targetGeometries[0].spatialReference != null)
                {
                }
                if (cutterPolyline.spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = targetGeometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.target = "";
            }
            if (cutterPolyline)
            {
                jsonCutterPolyline = cutterPolyline.toJSON();
                delete jsonCutterPolyline.spatialReference;
                urlVariables.cutter = JSONUtil.encode(jsonCutterPolyline);
            }
            else
            {
                urlVariables.cutter = "";
            }
            return sendURLVariables("/cut", urlVariables, responder, handleCut);
        }// end function

        public function difference(geometries:Array, geometry:Geometry, responder:IResponder = null) : AsyncToken
        {
            var handleDifference:Function;
            var geometriesType:String;
            var geometryType:String;
            var jsonGeometry:Object;
            var geometries:* = geometries;
            var geometry:* = geometry;
            var responder:* = responder;
            handleDifference = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], geometries[0].spatialReference, decodedObject.geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                differenceLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(differenceLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.DIFFERENCE_COMPLETE, differenceLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::difference:{1}", id, geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometriesType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometriesType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (geometry)
            {
                geometryType = geometry.type;
                jsonGeometry = geometry.toJSON();
                delete jsonGeometry.spatialReference;
                urlVariables.geometry = JSONUtil.encode({geometryType:geometryType, geometry:jsonGeometry});
            }
            else
            {
                urlVariables.geometry = "";
            }
            return sendURLVariables("/difference", urlVariables, responder, handleDifference);
        }// end function

        public function intersect(geometries:Array, geometry:Geometry, responder:IResponder = null) : AsyncToken
        {
            var handleIntersect:Function;
            var geometriesType:String;
            var geometryType:String;
            var jsonGeometry:Object;
            var geometries:* = geometries;
            var geometry:* = geometry;
            var responder:* = responder;
            handleIntersect = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_5:int = 0;
                var _loc_3:Array = [];
                if (decodedObject.geometries)
                {
                    _loc_5 = 0;
                    while (_loc_5 < decodedObject.geometries.length)
                    {
                        
                        _loc_3.push(Geometry.fromJSON2(decodedObject.geometries[_loc_5], geometries[0].spatialReference, decodedObject.geometryType));
                        _loc_5 = _loc_5 + 1;
                    }
                }
                intersectLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(intersectLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.INTERSECT_COMPLETE, intersectLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::intersect:{1}", id, geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometriesType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometriesType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            if (geometry)
            {
                geometryType = geometry.type;
                jsonGeometry = geometry.toJSON();
                delete jsonGeometry.spatialReference;
                urlVariables.geometry = JSONUtil.encode({geometryType:geometryType, geometry:jsonGeometry});
            }
            else
            {
                urlVariables.geometry = "";
            }
            return sendURLVariables("/intersect", urlVariables, responder, handleIntersect);
        }// end function

        public function union(geometries:Array, responder:IResponder = null) : AsyncToken
        {
            var handleUnion:Function;
            var geometryType:String;
            var geometries:* = geometries;
            var responder:* = responder;
            handleUnion = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_3:Geometry = null;
                var _loc_4:IResponder = null;
                if (decodedObject.geometry)
                {
                    _loc_3 = Geometry.fromJSON2(decodedObject.geometry, geometries[0].spatialReference, decodedObject.geometryType);
                }
                unionLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(unionLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.UNION_COMPLETE, unionLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::union:{1}", id, geometries);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (geometries)
            {
            }
            if (geometries.length >= 1)
            {
                geometryType = geometries[0].type;
                urlVariables.geometries = JSONUtil.encode({geometryType:geometryType, geometries:JSONUtil.toJSONArrayNoSR(geometries)});
                if (geometries[0].spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = geometries[0].spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.geometries = "";
            }
            return sendURLVariables("/union", urlVariables, responder, handleUnion);
        }// end function

        public function reshape(targetGeometry:Geometry, reshaperPolyline:Polyline, responder:IResponder = null) : AsyncToken
        {
            var handleReshape:Function;
            var targetGeometryType:String;
            var jsonTargetGeometry:Object;
            var jsonReshaperPolyline:Object;
            var targetGeometry:* = targetGeometry;
            var reshaperPolyline:* = reshaperPolyline;
            var responder:* = responder;
            handleReshape = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_4:IResponder = null;
                var _loc_3:* = new Geometry();
                if (decodedObject.geometry)
                {
                    _loc_3 = Geometry.fromJSON2(decodedObject.geometry, targetGeometry.spatialReference, decodedObject.geometryType);
                }
                reshapeLastResult = _loc_3;
                for each (_loc_4 in asyncToken.responders)
                {
                    
                    _loc_4.result(reshapeLastResult);
                }
                dispatchEvent(new GeometryServiceEvent(GeometryServiceEvent.RESHAPE_COMPLETE, reshapeLastResult));
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::reshape:{1}", id, targetGeometry);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (targetGeometry)
            {
                targetGeometryType = targetGeometry.type;
                jsonTargetGeometry = targetGeometry.toJSON();
                delete jsonTargetGeometry.spatialReference;
                urlVariables.target = JSONUtil.encode({geometryType:targetGeometryType, geometry:jsonTargetGeometry});
                if (targetGeometry.spatialReference == null)
                {
                    if (Log.isError())
                    {
                        logger.error("SpatialReference value required with the input geometries");
                    }
                }
                else
                {
                    urlVariables.sr = targetGeometry.spatialReference.toSR();
                }
            }
            else
            {
                urlVariables.target = "";
            }
            if (reshaperPolyline)
            {
                jsonReshaperPolyline = reshaperPolyline.toJSON();
                delete jsonReshaperPolyline.spatialReference;
                urlVariables.reshaper = JSONUtil.encode(jsonReshaperPolyline);
            }
            else
            {
                urlVariables.reshaper = "";
            }
            return sendURLVariables("/reshape", urlVariables, responder, handleReshape);
        }// end function

        public function get projectLastResult() : Array
        {
            return this._1406379444projectLastResult;
        }// end function

        public function set projectLastResult(value:Array) : void
        {
            arguments = this._1406379444projectLastResult;
            if (arguments !== value)
            {
                this._1406379444projectLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "projectLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get simplifyLastResult() : Array
        {
            return this._879103036simplifyLastResult;
        }// end function

        public function set simplifyLastResult(value:Array) : void
        {
            arguments = this._879103036simplifyLastResult;
            if (arguments !== value)
            {
                this._879103036simplifyLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "simplifyLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get bufferLastResult() : Array
        {
            return this._1333289293bufferLastResult;
        }// end function

        public function set bufferLastResult(value:Array) : void
        {
            arguments = this._1333289293bufferLastResult;
            if (arguments !== value)
            {
                this._1333289293bufferLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "bufferLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get lengthsLastResult() : Array
        {
            return this._2132230016lengthsLastResult;
        }// end function

        public function set lengthsLastResult(value:Array) : void
        {
            arguments = this._2132230016lengthsLastResult;
            if (arguments !== value)
            {
                this._2132230016lengthsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lengthsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get areasAndLengthsLastResult() : AreasAndLengthsResult
        {
            return this._1712781809areasAndLengthsLastResult;
        }// end function

        public function set areasAndLengthsLastResult(value:AreasAndLengthsResult) : void
        {
            arguments = this._1712781809areasAndLengthsLastResult;
            if (arguments !== value)
            {
                this._1712781809areasAndLengthsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "areasAndLengthsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get labelPointsLastResult() : Array
        {
            return this._1080791722labelPointsLastResult;
        }// end function

        public function set labelPointsLastResult(value:Array) : void
        {
            arguments = this._1080791722labelPointsLastResult;
            if (arguments !== value)
            {
                this._1080791722labelPointsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelPointsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get relationLastResult() : Array
        {
            return this._166131345relationLastResult;
        }// end function

        public function set relationLastResult(value:Array) : void
        {
            arguments = this._166131345relationLastResult;
            if (arguments !== value)
            {
                this._166131345relationLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "relationLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get distanceLastResult() : Number
        {
            return this._1681442776distanceLastResult;
        }// end function

        public function set distanceLastResult(value:Number) : void
        {
            arguments = this._1681442776distanceLastResult;
            if (arguments !== value)
            {
                this._1681442776distanceLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "distanceLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get convexHullLastResult() : Geometry
        {
            return this._40916039convexHullLastResult;
        }// end function

        public function set convexHullLastResult(value:Geometry) : void
        {
            arguments = this._40916039convexHullLastResult;
            if (arguments !== value)
            {
                this._40916039convexHullLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "convexHullLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get offsetLastResult() : Array
        {
            return this._663053126offsetLastResult;
        }// end function

        public function set offsetLastResult(value:Array) : void
        {
            arguments = this._663053126offsetLastResult;
            if (arguments !== value)
            {
                this._663053126offsetLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offsetLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get trimExtendLastResult() : Array
        {
            return this._1078768975trimExtendLastResult;
        }// end function

        public function set trimExtendLastResult(value:Array) : void
        {
            arguments = this._1078768975trimExtendLastResult;
            if (arguments !== value)
            {
                this._1078768975trimExtendLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "trimExtendLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get generalizeLastResult() : Array
        {
            return this._1925444897generalizeLastResult;
        }// end function

        public function set generalizeLastResult(value:Array) : void
        {
            arguments = this._1925444897generalizeLastResult;
            if (arguments !== value)
            {
                this._1925444897generalizeLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "generalizeLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get autoCompleteLastResult() : Array
        {
            return this._698172539autoCompleteLastResult;
        }// end function

        public function set autoCompleteLastResult(value:Array) : void
        {
            arguments = this._698172539autoCompleteLastResult;
            if (arguments !== value)
            {
                this._698172539autoCompleteLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "autoCompleteLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get densifyLastResult() : Array
        {
            return this._1068047831densifyLastResult;
        }// end function

        public function set densifyLastResult(value:Array) : void
        {
            arguments = this._1068047831densifyLastResult;
            if (arguments !== value)
            {
                this._1068047831densifyLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "densifyLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get cutLastResult() : CutResult
        {
            return this._543519285cutLastResult;
        }// end function

        public function set cutLastResult(value:CutResult) : void
        {
            arguments = this._543519285cutLastResult;
            if (arguments !== value)
            {
                this._543519285cutLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cutLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get differenceLastResult() : Array
        {
            return this._2033358992differenceLastResult;
        }// end function

        public function set differenceLastResult(value:Array) : void
        {
            arguments = this._2033358992differenceLastResult;
            if (arguments !== value)
            {
                this._2033358992differenceLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "differenceLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get intersectLastResult() : Array
        {
            return this._1247487186intersectLastResult;
        }// end function

        public function set intersectLastResult(value:Array) : void
        {
            arguments = this._1247487186intersectLastResult;
            if (arguments !== value)
            {
                this._1247487186intersectLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "intersectLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get unionLastResult() : Geometry
        {
            return this._713407106unionLastResult;
        }// end function

        public function set unionLastResult(value:Geometry) : void
        {
            arguments = this._713407106unionLastResult;
            if (arguments !== value)
            {
                this._713407106unionLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "unionLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get reshapeLastResult() : Geometry
        {
            return this._1834793537reshapeLastResult;
        }// end function

        public function set reshapeLastResult(value:Geometry) : void
        {
            arguments = this._1834793537reshapeLastResult;
            if (arguments !== value)
            {
                this._1834793537reshapeLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "reshapeLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
