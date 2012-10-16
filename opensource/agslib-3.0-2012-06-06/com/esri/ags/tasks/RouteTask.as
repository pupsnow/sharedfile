package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class RouteTask extends BaseTask
    {
        private var _503775218solveLastResult:RouteSolveResult;
        private var _firstRouteResult:RouteResult;
        private static const NONAME:String = "_NONAME_";

        public function RouteTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function get firstRouteResult() : RouteResult
        {
            return this._firstRouteResult;
        }// end function

        public function solve(routeParameters:RouteParameters, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var arrToBeNormalizedObject:Array;
            var i:int;
            var stopObject:Object;
            var pointBarrierObject:Object;
            var polylineBarrierObject:Object;
            var polygonBarrierObject:Object;
            var count:Number;
            var stopFeatureSet:FeatureSet;
            var stopFeatures:Array;
            var stop:Graphic;
            var fRoute:Fault;
            var stopLayer:DataLayer;
            var stopLayerObj:Object;
            var pointBarrierFeatures:Array;
            var pointBarrierDataLayer:Object;
            var polylineBarrierFeatures:Array;
            var polylineBarrierDataLayer:Object;
            var polygonBarrierFeatures:Array;
            var polygonBarrierDataLayer:Object;
            var routeParameters:* = routeParameters;
            var responder:* = responder;
            var generateUrlVariables:* = function () : void
            {
                var _loc_1:* = new URLVariables();
                _loc_1.f = "json";
                _loc_1.returnBarriers = routeParameters.returnPointBarriers;
                _loc_1.returnPolylineBarriers = routeParameters.returnPolylineBarriers;
                _loc_1.returnPolygonBarriers = routeParameters.returnPolygonBarriers;
                _loc_1.returnDirections = routeParameters.returnDirections;
                _loc_1.returnRoutes = routeParameters.returnRoutes;
                _loc_1.returnStops = routeParameters.returnStops;
                if (stopObject)
                {
                    _loc_1.stops = JSONUtil.encode(stopObject);
                }
                if (pointBarrierObject)
                {
                    _loc_1.barriers = JSONUtil.encode(pointBarrierObject);
                }
                if (polylineBarrierObject)
                {
                    _loc_1.polylineBarriers = JSONUtil.encode(polylineBarrierObject);
                }
                if (polygonBarrierObject)
                {
                    _loc_1.polygonBarriers = JSONUtil.encode(polygonBarrierObject);
                }
                if (routeParameters.m_ignoreInvalidLocations)
                {
                    _loc_1.ignoreInvalidLocations = routeParameters.ignoreInvalidLocations;
                }
                if (routeParameters.m_findBestSequence)
                {
                    _loc_1.findBestSequence = routeParameters.findBestSequence;
                }
                if (routeParameters.m_preserveFirstStop)
                {
                    _loc_1.preserveFirstStop = routeParameters.preserveFirstStop;
                }
                if (routeParameters.m_preserveLastStop)
                {
                    _loc_1.preserveLastStop = routeParameters.preserveLastStop;
                }
                if (routeParameters.m_useHierarchy)
                {
                    _loc_1.useHierarchy = routeParameters.useHierarchy;
                }
                if (routeParameters.m_useTimeWindows)
                {
                    _loc_1.useTimeWindows = routeParameters.useTimeWindows;
                }
                if (routeParameters.accumulateAttributes)
                {
                    _loc_1.accumulateAttributeNames = routeParameters.accumulateAttributes.join();
                }
                if (routeParameters.attributeParameterValues)
                {
                    _loc_1.attributeParameterValues = JSONUtil.encode(routeParameters.attributeParameterValues);
                }
                if (routeParameters.directionsLanguage)
                {
                    _loc_1.directionsLanguage = routeParameters.directionsLanguage;
                }
                if (routeParameters.directionsLengthUnits)
                {
                    _loc_1.directionsLengthUnits = NAUtil.toDirectionLengthUnits(routeParameters.directionsLengthUnits);
                }
                if (routeParameters.directionsTimeAttribute)
                {
                    _loc_1.directionsTimeAttributeName = routeParameters.directionsTimeAttribute;
                }
                if (routeParameters.impedanceAttribute)
                {
                    _loc_1.impedanceAttributeName = routeParameters.impedanceAttribute;
                }
                if (routeParameters.outputLines)
                {
                    _loc_1.outputLines = routeParameters.outputLines;
                }
                if (isNaN(routeParameters.outputGeometryPrecision) == false)
                {
                    _loc_1.outputGeometryPrecision = routeParameters.outputGeometryPrecision;
                }
                if (routeParameters.outputGeometryPrecisionUnits)
                {
                    _loc_1.outputGeometryPrecisionUnits = routeParameters.outputGeometryPrecisionUnits;
                }
                if (routeParameters.outSpatialReference)
                {
                    _loc_1.outSR = routeParameters.outSpatialReference.toSR();
                }
                if (routeParameters.restrictionAttributes)
                {
                    _loc_1.restrictionAttributeNames = routeParameters.restrictionAttributes.join();
                }
                if (routeParameters.restrictUTurns)
                {
                    _loc_1.restrictUTurns = routeParameters.restrictUTurns;
                }
                if (routeParameters.startTime)
                {
                    _loc_1.startTime = routeParameters.startTime.getTime();
                }
                if (routeParameters.returnZ)
                {
                    _loc_1.returnZ = routeParameters.returnZ;
                }
                asyncToken = sendURLVariables2("/solve", _loc_1, handleDecodedObject, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, routeParameters);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            arrToBeNormalizedObject;
            var arrToBeNormalizedGeometry:Array;
            stopObject = new Object();
            if (routeParameters.stops is FeatureSet)
            {
                count;
                stopFeatureSet = FeatureSet(routeParameters.stops);
                stopFeatures = stopFeatureSet.features ? (stopFeatureSet.features) : ([]);
                var _loc_4:int = 0;
                var _loc_5:* = stopFeatures;
                while (_loc_5 in _loc_4)
                {
                    
                    stop = _loc_5[_loc_4];
                    if (stop.attributes != null)
                    {
                    }
                    if (stop.attributes.RouteName != null)
                    {
                        count = (count + 1);
                    }
                }
                if (count != stopFeatures.length)
                {
                }
                if (count != 0)
                {
                    if (responder)
                    {
                        asyncToken.addResponder(responder);
                        fRoute = new Fault(null, "The stops do not have consistent route names");
                        responder.fault(fRoute);
                        if (hasEventListener(FaultEvent.FAULT))
                        {
                            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, fRoute));
                        }
                    }
                    return asyncToken;
                }
                else if (autoNormalize)
                {
                    i;
                    while (i < stopFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"stops", type:"features", featureObject:stopFeatures[i]});
                        arrToBeNormalizedGeometry.push(stopFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    stopObject;
                }
            }
            else if (routeParameters.stops is DataLayer)
            {
                stopLayer = DataLayer(routeParameters.stops);
                stopLayerObj;
                if (stopLayer.geometry)
                {
                    stopLayerObj.geometryType = stopLayer.geometry.type;
                    stopLayerObj.spatialRel = stopLayer.spatialRelationship;
                    if (autoNormalize)
                    {
                        arrToBeNormalizedObject.push({objectType:"stops", type:"layer", featureObject:stopLayerObj});
                        arrToBeNormalizedGeometry.push(stopLayer.geometry);
                    }
                    else
                    {
                        stopLayerObj.geometry = stopLayer.geometry;
                        stopObject = stopLayerObj;
                    }
                }
            }
            else if (routeParameters.stops is String)
            {
                stopObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"stops", type:"url", featureObject:stopObject});
                }
            }
            pointBarrierObject = new Object();
            if (routeParameters.pointBarriers is FeatureSet)
            {
                pointBarrierFeatures = this.getRouteBarrierFeatures(routeParameters.pointBarriers);
                if (autoNormalize)
                {
                    i;
                    while (i < pointBarrierFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"pointBarrier", type:"features", featureObject:pointBarrierFeatures[i]});
                        arrToBeNormalizedGeometry.push(pointBarrierFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    pointBarrierObject;
                }
            }
            else if (routeParameters.pointBarriers is DataLayer)
            {
                pointBarrierDataLayer = this.getRouteBarrierLayer(routeParameters.pointBarriers);
                if (autoNormalize)
                {
                }
                if (pointBarrierDataLayer.geometry)
                {
                    arrToBeNormalizedObject.push({objectType:"pointBarrier", type:"layer", featureObject:pointBarrierDataLayer});
                    arrToBeNormalizedGeometry.push(pointBarrierDataLayer.geometry);
                }
                else
                {
                    pointBarrierObject = pointBarrierDataLayer;
                }
            }
            else if (routeParameters.pointBarriers is String)
            {
                pointBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"stops", type:"url", featureObject:pointBarrierObject});
                }
            }
            polylineBarrierObject = new Object();
            if (routeParameters.polylineBarriers is FeatureSet)
            {
                polylineBarrierFeatures = this.getRouteBarrierFeatures(routeParameters.polylineBarriers);
                if (autoNormalize)
                {
                    i;
                    while (i < polylineBarrierFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"polylineBarrier", type:"features", featureObject:polylineBarrierFeatures[i]});
                        arrToBeNormalizedGeometry.push(polylineBarrierFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    polylineBarrierObject;
                }
            }
            else if (routeParameters.polylineBarriers is DataLayer)
            {
                polylineBarrierDataLayer = this.getRouteBarrierLayer(routeParameters.polylineBarriers);
                if (autoNormalize)
                {
                }
                if (polylineBarrierDataLayer.geometry)
                {
                    arrToBeNormalizedObject.push({objectType:"polylineBarrier", type:"layer", featureObject:polylineBarrierDataLayer});
                    arrToBeNormalizedGeometry.push(polylineBarrierDataLayer.geometry);
                }
                else
                {
                    polylineBarrierObject = polylineBarrierDataLayer;
                }
            }
            else if (routeParameters.polylineBarriers is String)
            {
                polylineBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"stops", type:"url", featureObject:polylineBarrierObject});
                }
            }
            polygonBarrierObject = new Object();
            if (routeParameters.polygonBarriers is FeatureSet)
            {
                polygonBarrierFeatures = this.getRouteBarrierFeatures(routeParameters.polygonBarriers);
                if (autoNormalize)
                {
                    i;
                    while (i < polygonBarrierFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"polygonBarrier", type:"features", featureObject:polygonBarrierFeatures[i]});
                        arrToBeNormalizedGeometry.push(polygonBarrierFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    polygonBarrierObject;
                }
            }
            else if (routeParameters.polygonBarriers is DataLayer)
            {
                polygonBarrierDataLayer = this.getRouteBarrierLayer(routeParameters.polygonBarriers);
                if (autoNormalize)
                {
                }
                if (polygonBarrierDataLayer.geometry)
                {
                    arrToBeNormalizedObject.push({objectType:"polygonBarrier", type:"layer", featureObject:polygonBarrierDataLayer});
                    arrToBeNormalizedGeometry.push(polygonBarrierDataLayer.geometry);
                }
                else
                {
                    polygonBarrierObject = polygonBarrierDataLayer;
                }
            }
            else if (routeParameters.polygonBarriers is String)
            {
                polygonBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"stops", type:"url", featureObject:polygonBarrierObject});
                }
            }
            if (autoNormalize)
            {
            }
            if (arrToBeNormalizedGeometry.length)
            {
                var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                var _loc_4:Boolean = false;
                var _loc_6:Boolean = false;
                var _loc_8:Boolean = false;
                var _loc_10:Boolean = false;
                var _loc_3:* = item as Array;
                var _loc_5:Array = [];
                var _loc_7:Array = [];
                var _loc_9:Array = [];
                var _loc_11:Array = [];
                var _loc_12:int = 0;
                while (_loc_12 < arrToBeNormalizedObject.length)
                {
                    
                    if (arrToBeNormalizedObject[_loc_12].objectType == "stops")
                    {
                        if (arrToBeNormalizedObject[_loc_12].type == "features")
                        {
                            _loc_4 = true;
                            _loc_5.push(new Graphic(_loc_3[_loc_12], arrToBeNormalizedObject[_loc_12].featureObject.symbol, arrToBeNormalizedObject[_loc_12].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_12].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_12].featureObject.geometry = _loc_3[_loc_12];
                            _loc_5.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                        else
                        {
                            _loc_5.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_12].objectType == "pointBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_12].type == "features")
                        {
                            _loc_6 = true;
                            _loc_7.push(new Graphic(_loc_3[_loc_12], arrToBeNormalizedObject[_loc_12].featureObject.symbol, arrToBeNormalizedObject[_loc_12].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_12].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_12].featureObject.geometry = _loc_3[_loc_12];
                            _loc_7.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                        else
                        {
                            _loc_7.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_12].objectType == "polylineBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_12].type == "features")
                        {
                            _loc_8 = true;
                            _loc_9.push(new Graphic(_loc_3[_loc_12], arrToBeNormalizedObject[_loc_12].featureObject.symbol, arrToBeNormalizedObject[_loc_12].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_12].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_12].featureObject.geometry = _loc_3[_loc_12];
                            _loc_9.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                        else
                        {
                            _loc_9.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_12].objectType == "polygonBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_12].type == "features")
                        {
                            _loc_10 = true;
                            _loc_11.push(new Graphic(_loc_3[_loc_12], arrToBeNormalizedObject[_loc_12].featureObject.symbol, arrToBeNormalizedObject[_loc_12].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_12].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_12].featureObject.geometry = _loc_3[_loc_12];
                            _loc_11.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                        else
                        {
                            _loc_11.push(arrToBeNormalizedObject[_loc_12].featureObject);
                        }
                    }
                    _loc_12 = _loc_12 + 1;
                }
                if (_loc_4)
                {
                    stopObject = {type:"features", features:_loc_5, doNotLocateOnRestrictedElements:routeParameters.doNotLocateOnRestrictedElements};
                }
                else
                {
                    if (_loc_5)
                    {
                    }
                    stopObject = _loc_5.length > 0 ? (_loc_5[0]) : (null);
                }
                if (_loc_6)
                {
                    pointBarrierObject = {type:"features", features:_loc_7};
                }
                else
                {
                    if (_loc_7)
                    {
                    }
                    pointBarrierObject = _loc_7.length > 0 ? (_loc_7[0]) : (null);
                }
                if (_loc_8)
                {
                    polylineBarrierObject = {type:"features", features:_loc_9};
                }
                else
                {
                    if (_loc_9)
                    {
                    }
                    polylineBarrierObject = _loc_9.length > 0 ? (_loc_9[0]) : (null);
                }
                if (_loc_10)
                {
                    polygonBarrierObject = {type:"features", features:_loc_11};
                }
                else
                {
                    if (_loc_11)
                    {
                    }
                    polygonBarrierObject = _loc_11.length > 0 ? (_loc_11[0]) : (null);
                }
                generateUrlVariables();
                return;
            }// end function
            ;
                var faultFunction:* = function (fault:Fault, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.fault(fault);
                }
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
                return;
            }// end function
            ;
                GeometryUtil.normalizeCentralMeridian(arrToBeNormalizedGeometry, GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultFunction, asyncToken));
            }
            else
            {
                this.generateUrlVariables();
            }
            return asyncToken;
        }// end function

        private function getRouteBarrierFeatures(routeBarriers:Object) : Array
        {
            var _loc_2:FeatureSet = null;
            _loc_2 = FeatureSet(routeBarriers);
            var _loc_3:* = _loc_2.features ? (_loc_2.features) : ([]);
            return _loc_3;
        }// end function

        private function getRouteBarrierLayer(routeBarriers:Object) : Object
        {
            var _loc_2:DataLayer = null;
            _loc_2 = DataLayer(routeBarriers);
            var _loc_3:Object = {type:"layer", layerName:_loc_2.name};
            if (_loc_2.geometry)
            {
                _loc_3.geometry = _loc_2.geometry;
                _loc_3.geometryType = _loc_2.geometry.type;
                _loc_3.spatialRel = _loc_2.spatialRelationship;
            }
            _loc_3.where = _loc_2.where;
            return _loc_3;
        }// end function

        private function decodeDirections(decodedObject:Object, results:Object, count:int) : int
        {
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_4:* = decodedObject.directions;
            for each (_loc_5 in _loc_4)
            {
                
                if (!_loc_5.routeName)
                {
                }
                _loc_6 = NONAME;
                results[_loc_6] = {direction:_loc_5};
                count = count + 1;
            }
            return count;
        }// end function

        private function decodeRoutes(decodedObject:Object, results:Object, count:int) : int
        {
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:Object = null;
            var _loc_4:* = decodedObject.routes ? (decodedObject.routes.features) : (null);
            for each (_loc_5 in _loc_4)
            {
                
                if (!_loc_5.attributes.Name)
                {
                }
                _loc_6 = NONAME;
                _loc_7 = results[_loc_6];
                if (_loc_7)
                {
                    _loc_7.route = _loc_5;
                    continue;
                }
                results[_loc_6] = {route:_loc_5};
                count = count + 1;
            }
            return count;
        }// end function

        private function decodeStops(decodedObject:Object, results:Object) : void
        {
            var _loc_4:Object = null;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            var _loc_7:Array = null;
            var _loc_3:* = decodedObject.stops ? (decodedObject.stops.features) : (null);
            for each (_loc_4 in _loc_3)
            {
                
                if (!_loc_4.attributes.RouteName)
                {
                }
                _loc_5 = NONAME;
                _loc_6 = results[_loc_5];
                if (_loc_6)
                {
                    _loc_7 = _loc_6.stops;
                    if (_loc_7)
                    {
                        _loc_7.push(_loc_4);
                    }
                    else
                    {
                        _loc_6.stops = [_loc_4];
                    }
                    continue;
                }
                results[_loc_5] = {stops:[_loc_4]};
            }
            return;
        }// end function

        private function decodeStopsInOneRoute(decodedObject:Object, results:Object) : void
        {
            var _loc_3:Array = null;
            var _loc_4:Object = null;
            if (decodedObject.stops)
            {
                _loc_3 = decodedObject.stops.features;
                for each (_loc_4 in results)
                {
                    
                    _loc_4.stops = _loc_3;
                    break;
                }
            }
            return;
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_6:String = null;
            var _loc_7:Array = null;
            var _loc_8:Array = null;
            var _loc_9:Object = null;
            var _loc_10:Array = null;
            var _loc_11:Array = null;
            var _loc_12:Object = null;
            var _loc_13:Array = null;
            var _loc_14:Array = null;
            var _loc_15:Object = null;
            var _loc_16:Array = null;
            var _loc_17:Object = null;
            var _loc_19:IResponder = null;
            var _loc_20:Object = null;
            var _loc_21:RouteResult = null;
            var _loc_22:MapPoint = null;
            var _loc_23:Polyline = null;
            var _loc_24:Polygon = null;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, decodedObject);
            }
            var _loc_3:Object = {};
            var _loc_4:* = this.decodeDirections(decodedObject, _loc_3, 0);
            _loc_4 = this.decodeRoutes(decodedObject, _loc_3, _loc_4);
            if (_loc_4 === 1)
            {
                this.decodeStopsInOneRoute(decodedObject, _loc_3);
            }
            else
            {
                this.decodeStops(decodedObject, _loc_3);
            }
            var _loc_5:Array = [];
            for (_loc_6 in _loc_3)
            {
                
                _loc_20 = _loc_3[_loc_6];
                _loc_21 = new RouteResult();
                _loc_21.routeName = _loc_6 === NONAME ? (null) : (_loc_6);
                if (_loc_20.route)
                {
                    if (_loc_20.route.geometry)
                    {
                        _loc_21.route = this.toRoute(_loc_20.route);
                    }
                    else
                    {
                        _loc_21.route = new Graphic(null, null, _loc_20.route.attributes);
                    }
                }
                if (_loc_20.direction)
                {
                    _loc_21.directions = NAUtil.toDirectionsFeatureSet(_loc_20.direction);
                }
                if (_loc_20.stops)
                {
                    _loc_21.stops = this.toStops(_loc_20.stops);
                }
                _loc_5.push(_loc_21);
            }
            _loc_7 = [];
            _loc_8 = decodedObject.barriers ? (decodedObject.barriers.features) : (null);
            for each (_loc_9 in _loc_8)
            {
                
                _loc_22 = MapPoint.fromJSON(_loc_9.geometry);
                _loc_7.push(new Graphic(_loc_22, null, _loc_9.attributes));
            }
            _loc_10 = [];
            _loc_11 = decodedObject.polylineBarriers ? (decodedObject.polylineBarriers.features) : (null);
            for each (_loc_12 in _loc_11)
            {
                
                _loc_23 = Polyline.fromJSON(_loc_12.geometry);
                _loc_10.push(new Graphic(_loc_23, null, _loc_12.attributes));
            }
            _loc_13 = [];
            _loc_14 = decodedObject.polygonBarriers ? (decodedObject.polygonBarriers.features) : (null);
            for each (_loc_15 in _loc_14)
            {
                
                _loc_24 = Polygon.fromJSON(_loc_15.geometry);
                _loc_13.push(new Graphic(_loc_24, null, _loc_15.attributes));
            }
            _loc_16 = [];
            for each (_loc_17 in decodedObject.messages)
            {
                
                _loc_16.push(NAMessage.toNAMessage(_loc_17));
            }
            if (_loc_5.length > 0)
            {
                this._firstRouteResult = _loc_5[0];
                dispatchEvent(new Event("firstRouteResultChanged"));
            }
            var _loc_18:* = new RouteSolveResult();
            _loc_18.routeResults = _loc_5;
            _loc_18.pointBarriers = _loc_7;
            _loc_18.polylineBarriers = _loc_10;
            _loc_18.polygonBarriers = _loc_13;
            _loc_18.messages = _loc_16;
            this.solveLastResult = _loc_18;
            for each (_loc_19 in asyncToken.responders)
            {
                
                _loc_19.result(_loc_18);
            }
            dispatchEvent(new RouteEvent(RouteEvent.SOLVE_COMPLETE, _loc_18));
            return;
        }// end function

        private function toStops(stops:Object) : Array
        {
            var _loc_3:Object = null;
            var _loc_4:MapPoint = null;
            var _loc_2:Array = [];
            for each (_loc_3 in stops)
            {
                
                _loc_4 = MapPoint.fromJSON(_loc_3.geometry);
                _loc_2.push(new Graphic(_loc_4, null, _loc_3.attributes));
            }
            return _loc_2;
        }// end function

        private function toRoute(route:Object) : Graphic
        {
            var _loc_2:* = Polyline.fromJSON(route.geometry);
            return new Graphic(_loc_2, null, route.attributes);
        }// end function

        public function get solveLastResult() : RouteSolveResult
        {
            return this._503775218solveLastResult;
        }// end function

        public function set solveLastResult(value:RouteSolveResult) : void
        {
            arguments = this._503775218solveLastResult;
            if (arguments !== value)
            {
                this._503775218solveLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "solveLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
