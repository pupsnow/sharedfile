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

    public class ServiceAreaTask extends BaseTask
    {
        private var _503775218solveLastResult:ServiceAreaSolveResult;

        public function ServiceAreaTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function solve(serviceAreaParameters:ServiceAreaParameters, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var arrToBeNormalizedObject:Array;
            var i:int;
            var facilityObject:Object;
            var pointBarrierObject:Object;
            var polylineBarrierObject:Object;
            var polygonBarrierObject:Object;
            var countFacilities:Number;
            var facilityFeatureSet:FeatureSet;
            var facilityFeatures:Array;
            var facility:Graphic;
            var fFacility:Fault;
            var facilityLayer:DataLayer;
            var facilityLayerObj:Object;
            var pointBarrierFeatures:Array;
            var pointBarrierDataLayer:Object;
            var polylineBarrierFeatures:Array;
            var polylineBarrierDataLayer:Object;
            var polygonBarrierFeatures:Array;
            var polygonBarrierDataLayer:Object;
            var serviceAreaParameters:* = serviceAreaParameters;
            var responder:* = responder;
            var generateUrlVariables:* = function () : void
            {
                var _loc_1:* = new URLVariables();
                _loc_1.f = "json";
                _loc_1.returnBarriers = serviceAreaParameters.returnPointBarriers;
                _loc_1.returnPolylineBarriers = serviceAreaParameters.returnPolylineBarriers;
                _loc_1.returnPolygonBarriers = serviceAreaParameters.returnPolygonBarriers;
                _loc_1.returnFacilities = serviceAreaParameters.returnFacilities;
                if (facilityObject)
                {
                    _loc_1.facilities = JSONUtil.encode(facilityObject);
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
                if (serviceAreaParameters.accumulateAttributes)
                {
                    _loc_1.accumulateAttributeNames = serviceAreaParameters.accumulateAttributes.join();
                }
                if (serviceAreaParameters.attributeParameterValues)
                {
                    _loc_1.attributeParameterValues = JSONUtil.encode(serviceAreaParameters.attributeParameterValues);
                }
                if (serviceAreaParameters.defaultBreaks)
                {
                    _loc_1.defaultBreaks = serviceAreaParameters.defaultBreaks.join();
                }
                if (serviceAreaParameters.excludeSourcesFromPolygons)
                {
                    _loc_1.excludeSourcesFromPolygons = serviceAreaParameters.excludeSourcesFromPolygons.join();
                }
                if (serviceAreaParameters.impedanceAttribute)
                {
                    _loc_1.impedanceAttributeName = serviceAreaParameters.impedanceAttribute;
                }
                if (serviceAreaParameters.m_mergeSimilarPolygonRanges)
                {
                    _loc_1.mergeSimilarPolygonRanges = serviceAreaParameters.mergeSimilarPolygonRanges;
                }
                if (serviceAreaParameters.outputLines)
                {
                    _loc_1.outputLines = serviceAreaParameters.outputLines;
                }
                if (serviceAreaParameters.outputPolygons)
                {
                    _loc_1.outputPolygons = serviceAreaParameters.outputPolygons;
                }
                if (serviceAreaParameters.m_overlapLines)
                {
                    _loc_1.overlapLines = serviceAreaParameters.overlapLines;
                }
                if (serviceAreaParameters.m_overlapPolygons)
                {
                    _loc_1.overlapPolygons = serviceAreaParameters.overlapPolygons;
                }
                if (isNaN(serviceAreaParameters.outputGeometryPrecision) == false)
                {
                    _loc_1.outputGeometryPrecision = serviceAreaParameters.outputGeometryPrecision;
                }
                if (serviceAreaParameters.outputGeometryPrecisionUnits)
                {
                    _loc_1.outputGeometryPrecisionUnits = serviceAreaParameters.outputGeometryPrecisionUnits;
                }
                if (serviceAreaParameters.outSpatialReference)
                {
                    _loc_1.outSR = serviceAreaParameters.outSpatialReference.toSR();
                }
                if (serviceAreaParameters.restrictionAttributes)
                {
                    _loc_1.restrictionAttributeNames = serviceAreaParameters.restrictionAttributes.join();
                }
                if (serviceAreaParameters.restrictUTurns)
                {
                    _loc_1.restrictUTurns = serviceAreaParameters.restrictUTurns;
                }
                if (serviceAreaParameters.m_splitLinesAtBreaks)
                {
                    _loc_1.splitLinesAtBreaks = serviceAreaParameters.splitLinesAtBreaks;
                }
                if (serviceAreaParameters.m_splitPolygonsAtBreaks)
                {
                    _loc_1.splitPolygonsAtBreaks = serviceAreaParameters.splitPolygonsAtBreaks;
                }
                if (serviceAreaParameters.travelDirection)
                {
                    _loc_1.travelDirection = serviceAreaParameters.travelDirection;
                }
                if (serviceAreaParameters.m_trimOuterPolygon)
                {
                    _loc_1.trimOuterPolygon = serviceAreaParameters.trimOuterPolygon;
                }
                if (serviceAreaParameters.trimPolygonDistance)
                {
                    _loc_1.trimPolygonDistance = serviceAreaParameters.trimPolygonDistance;
                }
                if (serviceAreaParameters.trimPolygonDistanceUnits)
                {
                    _loc_1.trimPolygonDistanceUnits = serviceAreaParameters.trimPolygonDistanceUnits;
                }
                if (serviceAreaParameters.m_useHierarchy)
                {
                }
                if (!serviceAreaParameters.outputLines)
                {
                    _loc_1.useHierarchy = serviceAreaParameters.useHierarchy;
                }
                if (serviceAreaParameters.returnZ)
                {
                    _loc_1.returnZ = serviceAreaParameters.returnZ;
                }
                asyncToken = sendURLVariables2("/solveServiceArea", _loc_1, handleDecodedObject, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::solve:{1}", id, serviceAreaParameters);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            arrToBeNormalizedObject;
            var arrToBeNormalizedGeometry:Array;
            facilityObject = new Object();
            if (serviceAreaParameters.facilities is FeatureSet)
            {
                asyncToken = new AsyncToken(null);
                countFacilities;
                facilityFeatureSet = FeatureSet(serviceAreaParameters.facilities);
                facilityFeatures = facilityFeatureSet.features ? (facilityFeatureSet.features) : ([]);
                var _loc_4:int = 0;
                var _loc_5:* = facilityFeatures;
                while (_loc_5 in _loc_4)
                {
                    
                    facility = _loc_5[_loc_4];
                    if (facility.attributes != null)
                    {
                    }
                    if (facility.attributes.RouteName != null)
                    {
                        countFacilities = (countFacilities + 1);
                    }
                }
                if (countFacilities != facilityFeatures.length)
                {
                }
                if (countFacilities != 0)
                {
                    if (responder)
                    {
                        asyncToken.addResponder(responder);
                        fFacility = new Fault(null, "The facilities do not have consistent route names");
                        responder.fault(fFacility);
                        if (hasEventListener(FaultEvent.FAULT))
                        {
                            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, fFacility));
                        }
                    }
                    return asyncToken;
                }
                else if (autoNormalize)
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
            else if (serviceAreaParameters.facilities is DataLayer)
            {
                facilityLayer = DataLayer(serviceAreaParameters.facilities);
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
            else if (serviceAreaParameters.facilities is String)
            {
                facilityObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:facilityObject});
                }
            }
            pointBarrierObject = new Object();
            if (serviceAreaParameters.pointBarriers is FeatureSet)
            {
                pointBarrierFeatures = NAUtil.getBarrierFeatures(serviceAreaParameters.pointBarriers);
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
            else if (serviceAreaParameters.pointBarriers is DataLayer)
            {
                pointBarrierDataLayer = NAUtil.getBarrierLayer(serviceAreaParameters.pointBarriers);
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
            else if (serviceAreaParameters.pointBarriers is String)
            {
                pointBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:pointBarrierObject});
                }
            }
            polylineBarrierObject = new Object();
            if (serviceAreaParameters.polylineBarriers is FeatureSet)
            {
                polylineBarrierFeatures = NAUtil.getBarrierFeatures(serviceAreaParameters.polylineBarriers);
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
            else if (serviceAreaParameters.polylineBarriers is DataLayer)
            {
                polylineBarrierDataLayer = NAUtil.getBarrierLayer(serviceAreaParameters.polylineBarriers);
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
            else if (serviceAreaParameters.polylineBarriers is String)
            {
                polylineBarrierObject;
                if (autoNormalize)
                {
                    arrToBeNormalizedObject.push({objectType:"facilities", type:"url", featureObject:polylineBarrierObject});
                }
            }
            polygonBarrierObject = new Object();
            if (serviceAreaParameters.polygonBarriers is FeatureSet)
            {
                polygonBarrierFeatures = NAUtil.getBarrierFeatures(serviceAreaParameters.polygonBarriers);
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
            else if (serviceAreaParameters.polygonBarriers is DataLayer)
            {
                polygonBarrierDataLayer = NAUtil.getBarrierLayer(serviceAreaParameters.polygonBarriers);
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
            else if (serviceAreaParameters.polygonBarriers is String)
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
                var _loc_3:* = item as Array;
                var _loc_5:Array = [];
                var _loc_7:Array = [];
                var _loc_9:Array = [];
                var _loc_11:Array = [];
                var _loc_12:int = 0;
                while (_loc_12 < arrToBeNormalizedObject.length)
                {
                    
                    if (arrToBeNormalizedObject[_loc_12].objectType == "facilities")
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
                    facilityObject = {type:"features", features:_loc_5, doNotLocateOnRestrictedElements:serviceAreaParameters.doNotLocateOnRestrictedElements};
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
            var _loc_22:Object = null;
            var _loc_23:ServiceAreaSolveResult = null;
            var _loc_24:IResponder = null;
            var _loc_25:MapPoint = null;
            var _loc_26:Polygon = null;
            var _loc_27:Polyline = null;
            var _loc_28:MapPoint = null;
            var _loc_29:Polyline = null;
            var _loc_30:Polygon = null;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, decodedObject);
            }
            var _loc_3:Array = [];
            var _loc_4:* = decodedObject.facilities ? (decodedObject.facilities.features) : (null);
            for each (_loc_5 in _loc_4)
            {
                
                _loc_25 = MapPoint.fromJSON(_loc_5.geometry);
                _loc_3.push(new Graphic(_loc_25, null, _loc_5.attributes));
            }
            _loc_6 = [];
            _loc_7 = decodedObject.saPolygons ? (decodedObject.saPolygons.features) : (null);
            for each (_loc_8 in _loc_7)
            {
                
                _loc_26 = Polygon.fromJSON(_loc_8.geometry);
                _loc_6.push(new Graphic(_loc_26, null, _loc_8.attributes));
            }
            _loc_9 = [];
            _loc_10 = decodedObject.saPolylines ? (decodedObject.saPolylines.features) : (null);
            for each (_loc_11 in _loc_10)
            {
                
                _loc_27 = Polyline.fromJSON(_loc_11.geometry);
                _loc_9.push(new Graphic(_loc_27, null, _loc_11.attributes));
            }
            _loc_12 = [];
            _loc_13 = decodedObject.barriers ? (decodedObject.barriers.features) : (null);
            for each (_loc_14 in _loc_13)
            {
                
                _loc_28 = MapPoint.fromJSON(_loc_14.geometry);
                _loc_12.push(new Graphic(_loc_28, null, _loc_14.attributes));
            }
            _loc_15 = [];
            _loc_16 = decodedObject.polylineBarriers ? (decodedObject.polylineBarriers.features) : (null);
            for each (_loc_17 in _loc_16)
            {
                
                _loc_29 = Polyline.fromJSON(_loc_17.geometry);
                _loc_15.push(new Graphic(_loc_29, null, _loc_17.attributes));
            }
            _loc_18 = [];
            _loc_19 = decodedObject.polygonBarriers ? (decodedObject.polygonBarriers.features) : (null);
            for each (_loc_20 in _loc_19)
            {
                
                _loc_30 = Polygon.fromJSON(_loc_20.geometry);
                _loc_18.push(new Graphic(_loc_30, null, _loc_20.attributes));
            }
            _loc_21 = [];
            for each (_loc_22 in decodedObject.messages)
            {
                
                _loc_21.push(GPMessage.toGPMessage(_loc_22));
            }
            _loc_23 = new ServiceAreaSolveResult();
            _loc_23.serviceAreaPolygons = _loc_6;
            _loc_23.serviceAreaPolylines = _loc_9;
            _loc_23.facilities = _loc_3;
            _loc_23.pointBarriers = _loc_12;
            _loc_23.polylineBarriers = _loc_15;
            _loc_23.polygonBarriers = _loc_18;
            _loc_23.messages = _loc_21;
            this.solveLastResult = _loc_23;
            for each (_loc_24 in asyncToken.responders)
            {
                
                _loc_24.result(this.solveLastResult);
            }
            dispatchEvent(new ServiceAreaEvent(ServiceAreaEvent.SOLVE_COMPLETE, this.solveLastResult));
            return;
        }// end function

        public function get solveLastResult() : ServiceAreaSolveResult
        {
            return this._503775218solveLastResult;
        }// end function

        public function set solveLastResult(value:ServiceAreaSolveResult) : void
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
