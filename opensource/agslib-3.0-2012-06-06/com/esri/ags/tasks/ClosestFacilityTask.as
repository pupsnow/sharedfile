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
    import mx.rpc.events.*;

    public class ClosestFacilityTask extends BaseTask
    {
        private var _503775218solveLastResult:ClosestFacilitySolveResult;

        public function ClosestFacilityTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function solve(closestFacilityParameters:ClosestFacilityParameters, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var arrToBeNormalizedObject:Array;
            var i:int;
            var facilityObject:Object;
            var incidentObject:Object;
            var pointBarrierObject:Object;
            var polylineBarrierObject:Object;
            var polygonBarrierObject:Object;
            var countFacilities:Number;
            var facilityFeatureSet:FeatureSet;
            var facilityFeatures:Array;
            var facilityLayer:DataLayer;
            var facilityLayerObj:Object;
            var countIncidents:Number;
            var incidentFeatureSet:FeatureSet;
            var incidentFeatures:Array;
            var incidentLayer:DataLayer;
            var incidentLayerObj:Object;
            var pointBarrierFeatures:Array;
            var pointBarrierDataLayer:Object;
            var polylineBarrierFeatures:Array;
            var polylineBarrierDataLayer:Object;
            var polygonBarrierFeatures:Array;
            var polygonBarrierDataLayer:Object;
            var closestFacilityParameters:* = closestFacilityParameters;
            var responder:* = responder;
            var generateUrlVariables:* = function () : void
            {
                var _loc_1:* = new URLVariables();
                _loc_1.f = "json";
                _loc_1.defaultCutoff = closestFacilityParameters.defaultCutoff;
                _loc_1.defaultTargetFacilityCount = closestFacilityParameters.defaultTargetFacilityCount;
                _loc_1.returnBarriers = closestFacilityParameters.returnPointBarriers;
                _loc_1.returnPolylineBarriers = closestFacilityParameters.returnPolylineBarriers;
                _loc_1.returnPolygonBarriers = closestFacilityParameters.returnPolygonBarriers;
                _loc_1.returnDirections = closestFacilityParameters.returnDirections;
                _loc_1.returnCFRoutes = closestFacilityParameters.returnRoutes;
                _loc_1.returnFacilities = closestFacilityParameters.returnFacilities;
                _loc_1.returnIncidents = closestFacilityParameters.returnIncidents;
                if (facilityObject)
                {
                    _loc_1.facilities = JSONUtil.encode(facilityObject);
                }
                if (incidentObject)
                {
                    _loc_1.incidents = JSONUtil.encode(incidentObject);
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
                if (closestFacilityParameters.accumulateAttributes)
                {
                    _loc_1.accumulateAttributeNames = closestFacilityParameters.accumulateAttributes.join();
                }
                if (closestFacilityParameters.attributeParameterValues)
                {
                    _loc_1.attributeParameterValues = JSONUtil.encode(closestFacilityParameters.attributeParameterValues);
                }
                if (closestFacilityParameters.directionsLanguage)
                {
                    _loc_1.directionsLanguage = closestFacilityParameters.directionsLanguage;
                }
                if (closestFacilityParameters.directionsLengthUnits)
                {
                    _loc_1.directionsLengthUnits = NAUtil.toDirectionLengthUnits(closestFacilityParameters.directionsLengthUnits);
                }
                if (closestFacilityParameters.directionsTimeAttribute)
                {
                    _loc_1.directionsTimeAttributeName = closestFacilityParameters.directionsTimeAttribute;
                }
                if (closestFacilityParameters.impedanceAttribute)
                {
                    _loc_1.impedanceAttributeName = closestFacilityParameters.impedanceAttribute;
                }
                if (closestFacilityParameters.outputLines)
                {
                    _loc_1.outputLines = closestFacilityParameters.outputLines;
                }
                if (isNaN(closestFacilityParameters.outputGeometryPrecision) == false)
                {
                    _loc_1.outputGeometryPrecision = closestFacilityParameters.outputGeometryPrecision;
                }
                if (closestFacilityParameters.outputGeometryPrecisionUnits)
                {
                    _loc_1.outputGeometryPrecisionUnits = closestFacilityParameters.outputGeometryPrecisionUnits;
                }
                if (closestFacilityParameters.outSpatialReference)
                {
                    _loc_1.outSR = closestFacilityParameters.outSpatialReference.toSR();
                }
                if (closestFacilityParameters.restrictionAttributes)
                {
                    _loc_1.restrictionAttributeNames = closestFacilityParameters.restrictionAttributes.join();
                }
                if (closestFacilityParameters.restrictUTurns)
                {
                    _loc_1.restrictUTurns = closestFacilityParameters.restrictUTurns;
                }
                if (closestFacilityParameters.travelDirection)
                {
                    _loc_1.travelDirection = closestFacilityParameters.travelDirection;
                }
                if (closestFacilityParameters.timeOfDay)
                {
                    _loc_1.timeOfDay = closestFacilityParameters.timeOfDay;
                }
                if (closestFacilityParameters.timeOfDayUsage)
                {
                    _loc_1.timeOfDayUsage = closestFacilityParameters.timeOfDayUsage;
                }
                if (closestFacilityParameters.m_useHierarchy)
                {
                    _loc_1.useHierarchy = closestFacilityParameters.useHierarchy;
                }
                if (closestFacilityParameters.returnZ)
                {
                    _loc_1.returnZ = closestFacilityParameters.returnZ;
                }
                asyncToken = sendURLVariables2("/solveClosestFacility", _loc_1, handleDecodedObject, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::solve:{1}", id, closestFacilityParameters);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            arrToBeNormalizedObject;
            var arrToBeNormalizedGeometry:Array;
            facilityObject = new Object();
            if (closestFacilityParameters.facilities is FeatureSet)
            {
                asyncToken = new AsyncToken(null);
                countFacilities;
                facilityFeatureSet = FeatureSet(closestFacilityParameters.facilities);
                facilityFeatures = facilityFeatureSet.features ? (facilityFeatureSet.features) : ([]);
                if (autoNormalize)
                {
                    i;
                    while (i < facilityFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"facilities", type:"features", featureObject:facilityFeatures[i]});
                        arrToBeNormalizedGeometry.push(facilityFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    facilityObject;
                }
            }
            else if (closestFacilityParameters.facilities is DataLayer)
            {
                facilityLayer = DataLayer(closestFacilityParameters.facilities);
                facilityLayerObj;
                if (facilityLayer.geometry)
                {
                    facilityLayerObj.geometryType = facilityLayer.geometry.type;
                    facilityLayerObj.spatialRel = facilityLayer.spatialRelationship;
                    if (autoNormalize)
                    {
                        arrToBeNormalizedObject.push({objectType:"facilities", type:"layer", featureObject:facilityLayerObj});
                        arrToBeNormalizedGeometry.push(facilityLayer.geometry);
                    }
                    else
                    {
                        facilityLayerObj.geometry = facilityLayer.geometry;
                        facilityObject = facilityLayerObj;
                    }
                }
            }
            else if (closestFacilityParameters.facilities is String)
            {
                facilityObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:facilityObject});
                }
            }
            incidentObject = new Object();
            if (closestFacilityParameters.incidents is FeatureSet)
            {
                asyncToken = new AsyncToken(null);
                countIncidents;
                incidentFeatureSet = FeatureSet(closestFacilityParameters.incidents);
                incidentFeatures = incidentFeatureSet.features ? (incidentFeatureSet.features) : ([]);
                if (autoNormalize)
                {
                    i;
                    while (i < incidentFeatures.length)
                    {
                        
                        arrToBeNormalizedObject.push({objectType:"incidents", type:"features", featureObject:incidentFeatures[i]});
                        arrToBeNormalizedGeometry.push(incidentFeatures[i].geometry);
                        i = (i + 1);
                    }
                }
                else
                {
                    incidentObject;
                }
            }
            else if (closestFacilityParameters.incidents is DataLayer)
            {
                incidentLayer = DataLayer(closestFacilityParameters.incidents);
                incidentLayerObj;
                if (incidentLayer.geometry)
                {
                    incidentLayerObj.geometryType = incidentLayer.geometry.type;
                    incidentLayerObj.spatialRel = incidentLayer.spatialRelationship;
                    if (autoNormalize)
                    {
                        arrToBeNormalizedObject.push({objectType:"incidents", type:"layer", featureObject:incidentLayerObj});
                        arrToBeNormalizedGeometry.push(facilityLayer.geometry);
                    }
                    else
                    {
                        incidentLayerObj.geometry = incidentLayer.geometry;
                        incidentObject = incidentLayerObj;
                    }
                }
            }
            else if (closestFacilityParameters.incidents is String)
            {
                incidentObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:incidentObject});
                }
            }
            pointBarrierObject = new Object();
            if (closestFacilityParameters.pointBarriers is FeatureSet)
            {
                pointBarrierFeatures = NAUtil.getBarrierFeatures(closestFacilityParameters.pointBarriers);
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
            else if (closestFacilityParameters.pointBarriers is DataLayer)
            {
                pointBarrierDataLayer = NAUtil.getBarrierLayer(closestFacilityParameters.pointBarriers);
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
            else if (closestFacilityParameters.pointBarriers is String)
            {
                pointBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:pointBarrierObject});
                }
            }
            polylineBarrierObject = new Object();
            if (closestFacilityParameters.polylineBarriers is FeatureSet)
            {
                polylineBarrierFeatures = NAUtil.getBarrierFeatures(closestFacilityParameters.polylineBarriers);
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
            else if (closestFacilityParameters.polylineBarriers is DataLayer)
            {
                polylineBarrierDataLayer = NAUtil.getBarrierLayer(closestFacilityParameters.polylineBarriers);
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
            else if (closestFacilityParameters.polylineBarriers is String)
            {
                polylineBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:polylineBarrierObject});
                }
            }
            polygonBarrierObject = new Object();
            if (closestFacilityParameters.polygonBarriers is FeatureSet)
            {
                polygonBarrierFeatures = NAUtil.getBarrierFeatures(closestFacilityParameters.polygonBarriers);
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
            else if (closestFacilityParameters.polygonBarriers is DataLayer)
            {
                polygonBarrierDataLayer = NAUtil.getBarrierLayer(closestFacilityParameters.polygonBarriers);
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
            else if (closestFacilityParameters.polygonBarriers is String)
            {
                polygonBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:polygonBarrierObject});
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
                var _loc_12:Boolean = false;
                var _loc_3:* = item as Array;
                var _loc_5:Array = [];
                var _loc_7:Array = [];
                var _loc_9:Array = [];
                var _loc_11:Array = [];
                var _loc_13:Array = [];
                var _loc_14:int = 0;
                while (_loc_14 < arrToBeNormalizedObject.length)
                {
                    
                    if (arrToBeNormalizedObject[_loc_14].objectType == "facilities")
                    {
                        if (arrToBeNormalizedObject[_loc_14].type == "features")
                        {
                            _loc_4 = true;
                            _loc_5.push(new Graphic(_loc_3[_loc_14], arrToBeNormalizedObject[_loc_14].featureObject.symbol, arrToBeNormalizedObject[_loc_14].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_14].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_14].featureObject.geometry = _loc_3[_loc_14];
                            _loc_5.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                        else
                        {
                            _loc_5.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_14].objectType == "incidents")
                    {
                        if (arrToBeNormalizedObject[_loc_14].type == "features")
                        {
                            _loc_6 = true;
                            _loc_7.push(new Graphic(_loc_3[_loc_14], arrToBeNormalizedObject[_loc_14].featureObject.symbol, arrToBeNormalizedObject[_loc_14].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_14].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_14].featureObject.geometry = _loc_3[_loc_14];
                            _loc_7.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                        else
                        {
                            _loc_7.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_14].objectType == "pointBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_14].type == "features")
                        {
                            _loc_8 = true;
                            _loc_9.push(new Graphic(_loc_3[_loc_14], arrToBeNormalizedObject[_loc_14].featureObject.symbol, arrToBeNormalizedObject[_loc_14].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_14].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_14].featureObject.geometry = _loc_3[_loc_14];
                            _loc_9.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                        else
                        {
                            _loc_9.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_14].objectType == "polylineBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_14].type == "features")
                        {
                            _loc_10 = true;
                            _loc_11.push(new Graphic(_loc_3[_loc_14], arrToBeNormalizedObject[_loc_14].featureObject.symbol, arrToBeNormalizedObject[_loc_14].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_14].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_14].featureObject.geometry = _loc_3[_loc_14];
                            _loc_11.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                        else
                        {
                            _loc_11.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_14].objectType == "polygonBarrier")
                    {
                        if (arrToBeNormalizedObject[_loc_14].type == "features")
                        {
                            _loc_12 = true;
                            _loc_13.push(new Graphic(_loc_3[_loc_14], arrToBeNormalizedObject[_loc_14].featureObject.symbol, arrToBeNormalizedObject[_loc_14].featureObject.attributes));
                        }
                        else if (arrToBeNormalizedObject[_loc_14].type == "layer")
                        {
                            arrToBeNormalizedObject[_loc_14].featureObject.geometry = _loc_3[_loc_14];
                            _loc_13.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                        else
                        {
                            _loc_13.push(arrToBeNormalizedObject[_loc_14].featureObject);
                        }
                    }
                    _loc_14 = _loc_14 + 1;
                }
                if (_loc_4)
                {
                    facilityObject = {type:"features", features:_loc_5, doNotLocateOnRestrictedElements:closestFacilityParameters.doNotLocateOnRestrictedElements};
                }
                else
                {
                    if (_loc_5)
                    {
                    }
                    facilityObject = _loc_5.length > 0 ? (_loc_5[0]) : (null);
                }
                if (_loc_6)
                {
                    incidentObject = {type:"features", features:_loc_7};
                }
                else
                {
                    if (_loc_7)
                    {
                    }
                    incidentObject = _loc_7.length > 0 ? (_loc_7[0]) : (null);
                }
                if (_loc_8)
                {
                    pointBarrierObject = {type:"features", features:_loc_9};
                }
                else
                {
                    if (_loc_9)
                    {
                    }
                    pointBarrierObject = _loc_9.length > 0 ? (_loc_9[0]) : (null);
                }
                if (_loc_10)
                {
                    polylineBarrierObject = {type:"features", features:_loc_11};
                }
                else
                {
                    if (_loc_11)
                    {
                    }
                    polylineBarrierObject = _loc_11.length > 0 ? (_loc_11[0]) : (null);
                }
                if (_loc_12)
                {
                    polygonBarrierObject = {type:"features", features:_loc_13};
                }
                else
                {
                    if (_loc_13)
                    {
                    }
                    polygonBarrierObject = _loc_13.length > 0 ? (_loc_13[0]) : (null);
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

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_5:Object = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:Object = null;
            var _loc_9:Array = null;
            var _loc_10:Array = null;
            var _loc_11:Object = null;
            var _loc_12:Array = null;
            var _loc_13:Array = null;
            var _loc_14:Object = null;
            var _loc_15:Array = null;
            var _loc_16:Array = null;
            var _loc_17:Object = null;
            var _loc_18:Array = null;
            var _loc_19:Array = null;
            var _loc_20:Object = null;
            var _loc_21:Array = null;
            var _loc_22:Array = null;
            var _loc_23:Object = null;
            var _loc_24:Array = null;
            var _loc_25:Object = null;
            var _loc_26:ClosestFacilitySolveResult = null;
            var _loc_27:IResponder = null;
            var _loc_28:MapPoint = null;
            var _loc_29:MapPoint = null;
            var _loc_30:MapPoint = null;
            var _loc_31:Polyline = null;
            var _loc_32:Polygon = null;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, decodedObject);
            }
            var _loc_3:Array = [];
            var _loc_4:* = decodedObject.directions ? (decodedObject.directions) : (null);
            for each (_loc_5 in _loc_4)
            {
                
                _loc_3.push(NAUtil.toDirectionsFeatureSet(_loc_5));
            }
            _loc_6 = [];
            _loc_7 = decodedObject.incidents ? (decodedObject.incidents.features) : (null);
            for each (_loc_8 in _loc_7)
            {
                
                _loc_28 = MapPoint.fromJSON(_loc_8.geometry);
                _loc_6.push(new Graphic(_loc_28, null, _loc_8.attributes));
            }
            _loc_9 = [];
            _loc_10 = decodedObject.facilities ? (decodedObject.facilities.features) : (null);
            for each (_loc_11 in _loc_10)
            {
                
                _loc_29 = MapPoint.fromJSON(_loc_11.geometry);
                _loc_9.push(new Graphic(_loc_29, null, _loc_11.attributes));
            }
            _loc_12 = [];
            _loc_13 = decodedObject.routes ? (decodedObject.routes.features) : (null);
            for each (_loc_14 in _loc_13)
            {
                
                _loc_12.push(NAUtil.toRoute(_loc_14));
            }
            _loc_15 = [];
            _loc_16 = decodedObject.barriers ? (decodedObject.barriers.features) : (null);
            for each (_loc_17 in _loc_16)
            {
                
                _loc_30 = MapPoint.fromJSON(_loc_17.geometry);
                _loc_15.push(new Graphic(_loc_30, null, _loc_17.attributes));
            }
            _loc_18 = [];
            _loc_19 = decodedObject.polylineBarriers ? (decodedObject.polylineBarriers.features) : (null);
            for each (_loc_20 in _loc_19)
            {
                
                _loc_31 = Polyline.fromJSON(_loc_20.geometry);
                _loc_18.push(new Graphic(_loc_31, null, _loc_20.attributes));
            }
            _loc_21 = [];
            _loc_22 = decodedObject.polygonBarriers ? (decodedObject.polygonBarriers.features) : (null);
            for each (_loc_23 in _loc_22)
            {
                
                _loc_32 = Polygon.fromJSON(_loc_23.geometry);
                _loc_21.push(new Graphic(_loc_32, null, _loc_23.attributes));
            }
            _loc_24 = [];
            for each (_loc_25 in decodedObject.messages)
            {
                
                _loc_24.push(NAMessage.toNAMessage(_loc_25));
            }
            _loc_26 = new ClosestFacilitySolveResult();
            _loc_26.directions = _loc_3;
            _loc_26.facilities = _loc_9;
            _loc_26.incidents = _loc_6;
            _loc_26.routes = _loc_12;
            _loc_26.pointBarriers = _loc_15;
            _loc_26.polylineBarriers = _loc_18;
            _loc_26.polygonBarriers = _loc_21;
            _loc_26.messages = _loc_24;
            this.solveLastResult = _loc_26;
            for each (_loc_27 in asyncToken.responders)
            {
                
                _loc_27.result(this.solveLastResult);
            }
            dispatchEvent(new ClosestFacilityEvent(ClosestFacilityEvent.SOLVE_COMPLETE, this.solveLastResult));
            return;
        }// end function

        public function get solveLastResult() : ClosestFacilitySolveResult
        {
            return this._503775218solveLastResult;
        }// end function

        public function set solveLastResult(value:ClosestFacilitySolveResult) : void
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
