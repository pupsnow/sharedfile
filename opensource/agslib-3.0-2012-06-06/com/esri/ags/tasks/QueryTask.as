package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class QueryTask extends BaseTask
    {
        private var _2143403096executeLastResult:FeatureSet;
        private var _1101044466executeForCountLastResult:Number;
        private var _866316681executeForIdsLastResult:Array;
        private var _1844702418executeRelationshipQueryLastResult:Object;
        private var _gdbVersion:String;
        private var _source:ILayerSource;
        private var _useAMF:Boolean = true;

        public function QueryTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function get gdbVersion() : String
        {
            return this._gdbVersion;
        }// end function

        public function set gdbVersion(value:String) : void
        {
            if (this._gdbVersion !== value)
            {
                this._gdbVersion = value;
                dispatchEvent(new Event("gdbVersionChanged"));
            }
            return;
        }// end function

        public function get source() : ILayerSource
        {
            return this._source;
        }// end function

        public function set source(value:ILayerSource) : void
        {
            this._source = value;
            dispatchEvent(new Event("sourceChanged"));
            return;
        }// end function

        public function get useAMF() : Boolean
        {
            return this._useAMF;
        }// end function

        public function set useAMF(value:Boolean) : void
        {
            if (this._useAMF !== value)
            {
                this._useAMF = value;
                dispatchEvent(new Event("useAMFChanged"));
            }
            return;
        }// end function

        public function execute(query:Query, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var query:* = query;
            var responder:* = responder;
            var generateUrlVariables:* = function (geometry:Geometry = null) : void
            {
                var _loc_3:Object = null;
                var _loc_2:* = new URLVariables();
                _loc_2.f = useAMF ? ("amf") : ("json");
                _loc_2.returnGeometry = query.returnGeometry;
                if (source)
                {
                    _loc_2.layer = JSONUtil.encode({source:source});
                }
                if (gdbVersion)
                {
                    _loc_2.gdbVersion = gdbVersion;
                }
                if (geometry)
                {
                    _loc_3 = geometry.toJSON();
                    if (geometry.spatialReference)
                    {
                        _loc_2.inSR = geometry.spatialReference.toSR();
                    }
                    _loc_2.geometry = JSONUtil.encode(_loc_3);
                    _loc_2.geometryType = geometry.type;
                }
                if (query.spatialRelationship)
                {
                    _loc_2.spatialRel = query.spatialRelationship;
                }
                if (query.text)
                {
                    _loc_2.text = query.text;
                }
                if (query.where)
                {
                    _loc_2.where = query.where;
                }
                if (query.outSpatialReference)
                {
                    _loc_2.outSR = query.outSpatialReference.toSR();
                }
                if (query.outFields)
                {
                    _loc_2.outFields = query.outFields.join();
                }
                if (query.objectIds)
                {
                    _loc_2.objectIds = query.objectIds.join();
                }
                if (query.relationParam)
                {
                }
                if (query.spatialRelationship == Query.SPATIAL_REL_RELATION)
                {
                    _loc_2.relationParam = query.relationParam;
                }
                if (query.timeExtent)
                {
                    _loc_2.time = query.timeExtent.toTimeParam();
                }
                if (!isNaN(query.maxAllowableOffset))
                {
                    _loc_2.maxAllowableOffset = query.maxAllowableOffset;
                }
                if (query.orderByFields)
                {
                    _loc_2.orderByFields = query.orderByFields.join();
                }
                if (query.outStatistics)
                {
                    _loc_2.outStatistics = JSONUtil.encode(query.outStatistics);
                    if (query.groupByFieldsForStatistics)
                    {
                        _loc_2.groupByFieldsForStatistics = query.groupByFieldsForStatistics.join();
                    }
                }
                if (query.returnGeometry)
                {
                    if (query.returnM)
                    {
                        _loc_2.returnM = true;
                    }
                    if (query.returnZ)
                    {
                        _loc_2.returnZ = true;
                    }
                }
                asyncToken = sendURLVariables2("/query", _loc_2, handleExecute, asyncToken);
                return;
            }// end function
            ;
            if (query == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::execute::a query was not defined", id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, query);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (query.geometry)
            {
                if (autoNormalize)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                generateUrlVariables((item as Array)[0] as Geometry);
                return;
            }// end function
            ;
                    var faultHandler:* = function (fault:Fault, asyncToken:AsyncToken) : void
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
                    GeometryUtil.normalizeCentralMeridian([query.geometry], GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultHandler, asyncToken));
                }
                else
                {
                    this.generateUrlVariables(query.geometry);
                }
            }
            else
            {
                this.generateUrlVariables();
            }
            return asyncToken;
        }// end function

        private function handleExecute(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            if (decodedObject is FeatureSet)
            {
                this.executeLastResult = FeatureSet(decodedObject);
            }
            else
            {
                this.executeLastResult = FeatureSet.fromJSON(decodedObject);
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, this.executeLastResult);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.executeLastResult);
            }
            dispatchEvent(new QueryEvent(QueryEvent.EXECUTE_COMPLETE, NaN, this.executeLastResult));
            return;
        }// end function

        public function executeForCount(query:Query, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var query:* = query;
            var responder:* = responder;
            var generateUrlVariables:* = function (geometry:Geometry) : void
            {
                var _loc_3:Object = null;
                var _loc_2:* = new URLVariables();
                _loc_2.f = "json";
                _loc_2.returnCountOnly = true;
                _loc_2.returnIdsOnly = true;
                _loc_2.returnGeometry = false;
                if (source)
                {
                    _loc_2.layer = JSONUtil.encode({source:source});
                }
                if (gdbVersion)
                {
                    _loc_2.gdbVersion = gdbVersion;
                }
                if (geometry)
                {
                    _loc_3 = geometry.toJSON();
                    if (geometry.spatialReference)
                    {
                        _loc_2.inSR = geometry.spatialReference.toSR();
                    }
                    _loc_2.geometry = JSONUtil.encode(_loc_3);
                    _loc_2.geometryType = geometry.type;
                }
                if (query.spatialRelationship)
                {
                    _loc_2.spatialRel = query.spatialRelationship;
                }
                if (query.text)
                {
                    _loc_2.text = query.text;
                }
                if (query.where)
                {
                    _loc_2.where = query.where;
                }
                if (query.objectIds)
                {
                    _loc_2.objectIds = query.objectIds.join();
                }
                if (query.relationParam)
                {
                }
                if (query.spatialRelationship == Query.SPATIAL_REL_RELATION)
                {
                    _loc_2.relationParam = query.relationParam;
                }
                if (query.timeExtent)
                {
                    _loc_2.time = query.timeExtent.toTimeParam();
                }
                asyncToken = sendURLVariables2("/query", _loc_2, handleExecuteForCount, asyncToken);
                return;
            }// end function
            ;
            if (query == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::executeForCount::a query was not defined", id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::executeForCount:{1}", id, query);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (query.geometry)
            {
                if (autoNormalize)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                generateUrlVariables((item as Array)[0] as Geometry);
                return;
            }// end function
            ;
                    var faultHandler:* = function (fault:Fault, asyncToken:AsyncToken) : void
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
                    GeometryUtil.normalizeCentralMeridian([query.geometry], GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultHandler, asyncToken));
                }
                else
                {
                    this.generateUrlVariables(query.geometry);
                }
            }
            else
            {
                this.generateUrlVariables(null);
            }
            return asyncToken;
        }// end function

        private function handleExecuteForCount(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            if (decodedObject.count is Number)
            {
                this.executeForCountLastResult = decodedObject.count;
            }
            else if (decodedObject.objectIds is Array)
            {
                this.executeForCountLastResult = (decodedObject.objectIds as Array).length;
            }
            else
            {
                this.executeForCountLastResult = NaN;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleExecuteForCount:{1}", id, this.executeForCountLastResult);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.executeForCountLastResult);
            }
            dispatchEvent(new QueryEvent(QueryEvent.EXECUTE_FOR_COUNT_COMPLETE, this.executeForCountLastResult));
            return;
        }// end function

        public function executeForIds(query:Query, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var query:* = query;
            var responder:* = responder;
            var generateUrlVariables:* = function (geometry:Geometry) : void
            {
                var _loc_3:Object = null;
                var _loc_2:* = new URLVariables();
                _loc_2.f = "json";
                _loc_2.returnIdsOnly = true;
                _loc_2.returnGeometry = false;
                if (source)
                {
                    _loc_2.layer = JSONUtil.encode({source:source});
                }
                if (gdbVersion)
                {
                    _loc_2.gdbVersion = gdbVersion;
                }
                if (geometry)
                {
                    _loc_3 = geometry.toJSON();
                    if (geometry.spatialReference)
                    {
                        _loc_2.inSR = geometry.spatialReference.toSR();
                    }
                    _loc_2.geometry = JSONUtil.encode(_loc_3);
                    _loc_2.geometryType = geometry.type;
                }
                if (query.spatialRelationship)
                {
                    _loc_2.spatialRel = query.spatialRelationship;
                }
                if (query.text)
                {
                    _loc_2.text = query.text;
                }
                if (query.where)
                {
                    _loc_2.where = query.where;
                }
                if (query.objectIds)
                {
                    _loc_2.objectIds = query.objectIds.join();
                }
                if (query.relationParam)
                {
                }
                if (query.spatialRelationship == Query.SPATIAL_REL_RELATION)
                {
                    _loc_2.relationParam = query.relationParam;
                }
                if (query.timeExtent)
                {
                    _loc_2.time = query.timeExtent.toTimeParam();
                }
                if (query.orderByFields)
                {
                    _loc_2.orderByFields = query.orderByFields.join();
                }
                asyncToken = sendURLVariables2("/query", _loc_2, handleExecuteForIds, asyncToken);
                return;
            }// end function
            ;
            if (query == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::executeForIds::a query was not defined", id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::executeForIds:{1}", id, query);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (query.geometry)
            {
                if (autoNormalize)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                generateUrlVariables((item as Array)[0] as Geometry);
                return;
            }// end function
            ;
                    var faultHandler:* = function (fault:Fault, asyncToken:AsyncToken) : void
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
                    GeometryUtil.normalizeCentralMeridian([query.geometry], GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultHandler, asyncToken));
                }
                else
                {
                    this.generateUrlVariables(query.geometry);
                }
            }
            else
            {
                this.generateUrlVariables(null);
            }
            return asyncToken;
        }// end function

        private function handleExecuteForIds(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            if (decodedObject.objectIds)
            {
                this.executeForIdsLastResult = decodedObject.objectIds;
            }
            else
            {
                this.executeForIdsLastResult = [];
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleExecuteForIds:{1}", id, this.executeForIdsLastResult);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.executeForIdsLastResult);
            }
            dispatchEvent(new QueryEvent(QueryEvent.EXECUTE_FOR_IDS_COMPLETE, NaN, null, this.executeForIdsLastResult));
            return;
        }// end function

        public function executeRelationshipQuery(relationshipQuery:RelationshipQuery, responder:IResponder = null) : AsyncToken
        {
            if (relationshipQuery == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::executeRelationshipQuery::a relationship query was not defined", id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::executeRelationshipQuery:{1}", id, relationshipQuery);
            }
            var _loc_3:* = new AsyncToken(null);
            if (responder)
            {
                _loc_3.addResponder(responder);
            }
            var _loc_4:* = new URLVariables();
            _loc_4.f = this.useAMF ? ("amf") : ("json");
            _loc_4.returnGeometry = relationshipQuery.returnGeometry;
            _loc_4.relationshipId = relationshipQuery.relationshipId;
            if (this.gdbVersion)
            {
                _loc_4.gdbVersion = this.gdbVersion;
            }
            if (relationshipQuery.outSpatialReference)
            {
                _loc_4.outSR = relationshipQuery.outSpatialReference.toSR();
            }
            if (relationshipQuery.definitionExpression)
            {
                _loc_4.definitionExpression = relationshipQuery.definitionExpression;
            }
            if (relationshipQuery.outFields)
            {
                _loc_4.outFields = relationshipQuery.outFields.join();
            }
            if (relationshipQuery.objectIds)
            {
                _loc_4.objectIds = relationshipQuery.objectIds.join();
            }
            if (!isNaN(relationshipQuery.maxAllowableOffset))
            {
                _loc_4.maxAllowableOffset = relationshipQuery.maxAllowableOffset;
            }
            if (relationshipQuery.returnGeometry)
            {
                if (relationshipQuery.returnM)
                {
                    _loc_4.returnM = true;
                }
                if (relationshipQuery.returnZ)
                {
                    _loc_4.returnZ = true;
                }
            }
            return sendURLVariables2("/queryRelatedRecords", _loc_4, this.handleRelationshipQuery, _loc_3);
        }// end function

        private function handleRelationshipQuery(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_5:RelatedRecordSet = null;
            var _loc_6:RelatedRecordGroup = null;
            var _loc_7:FeatureSet = null;
            var _loc_8:Object = null;
            var _loc_3:* = new Object();
            if (decodedObject is RelatedRecordSet)
            {
                _loc_5 = RelatedRecordSet(decodedObject);
                for each (_loc_6 in _loc_5.relatedRecordGroups)
                {
                    
                    _loc_7 = new FeatureSet(_loc_6.relatedRecords);
                    _loc_7.fields = _loc_5.fields;
                    _loc_7.geometryType = _loc_5.geometryType;
                    _loc_7.spatialReference = _loc_5.spatialReference;
                    _loc_3[_loc_6.objectId] = _loc_7;
                }
            }
            else
            {
                for each (_loc_8 in decodedObject.relatedRecordGroups)
                {
                    
                    _loc_8.features = _loc_8.relatedRecords;
                    _loc_8.fields = decodedObject.fields;
                    _loc_8.geometryType = decodedObject.geometryType;
                    _loc_8.spatialReference = decodedObject.spatialReference;
                    _loc_3[_loc_8.objectId] = FeatureSet.fromJSON(_loc_8);
                }
            }
            this.executeRelationshipQueryLastResult = _loc_3;
            if (Log.isDebug())
            {
                logger.debug("{0}::handleRelationshipQuery:{1}", id, this.executeRelationshipQueryLastResult);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.executeRelationshipQueryLastResult);
            }
            dispatchEvent(new QueryEvent(QueryEvent.EXECUTE_RELATIONSHIP_QUERY_COMPLETE, NaN, null, null, this.executeRelationshipQueryLastResult));
            return;
        }// end function

        public function get executeLastResult() : FeatureSet
        {
            return this._2143403096executeLastResult;
        }// end function

        public function set executeLastResult(value:FeatureSet) : void
        {
            arguments = this._2143403096executeLastResult;
            if (arguments !== value)
            {
                this._2143403096executeLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get executeForCountLastResult() : Number
        {
            return this._1101044466executeForCountLastResult;
        }// end function

        public function set executeForCountLastResult(value:Number) : void
        {
            arguments = this._1101044466executeForCountLastResult;
            if (arguments !== value)
            {
                this._1101044466executeForCountLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeForCountLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get executeForIdsLastResult() : Array
        {
            return this._866316681executeForIdsLastResult;
        }// end function

        public function set executeForIdsLastResult(value:Array) : void
        {
            arguments = this._866316681executeForIdsLastResult;
            if (arguments !== value)
            {
                this._866316681executeForIdsLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeForIdsLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get executeRelationshipQueryLastResult() : Object
        {
            return this._1844702418executeRelationshipQueryLastResult;
        }// end function

        public function set executeRelationshipQueryLastResult(value:Object) : void
        {
            arguments = this._1844702418executeRelationshipQueryLastResult;
            if (arguments !== value)
            {
                this._1844702418executeRelationshipQueryLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeRelationshipQueryLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
