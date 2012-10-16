package com.esri.ags.tasks
{
    import Geoprocessor.as$386.*;
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;

    public class Geoprocessor extends BaseTask
    {
        private var m_jobId:String;
        private var m_updateTimers:Array;
        private var _2143403096executeLastResult:ExecuteResult;
        private var _929111956executeLastResultFirstFeatureSet:FeatureSet;
        private var _163172231getInputLastResult:ParameterValue;
        private var _836016016getResultDataLastResult:ParameterValue;
        private var _1809658491getResultImageLastResult:ParameterValue;
        private var m_outSpatialReference:SpatialReference;
        private var m_processSpatialReference:SpatialReference;
        private var _returnM:Boolean;
        private var _returnZ:Boolean;
        private var _720501354cancelJobLastResult:JobInfo;
        private var _1993210696submitJobLastResult:JobInfo;
        private var m_updateDelay:Number = 4000;
        public var useAMF:Boolean = true;

        public function Geoprocessor(url:String = null)
        {
            this.m_updateTimers = [];
            super(url);
            return;
        }// end function

        public function get outSpatialReference() : SpatialReference
        {
            return this.m_outSpatialReference;
        }// end function

        private function set _1929069035outSpatialReference(value:SpatialReference) : void
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::outSpatialReference::{1}", id, value);
            }
            this.m_outSpatialReference = value;
            return;
        }// end function

        public function get processSpatialReference() : SpatialReference
        {
            return this.m_processSpatialReference;
        }// end function

        private function set _297257782processSpatialReference(value:SpatialReference) : void
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::processSpatialReference::{1}", id, value);
            }
            this.m_processSpatialReference = value;
            return;
        }// end function

        public function get returnM() : Boolean
        {
            return this._returnM;
        }// end function

        public function set returnM(value:Boolean) : void
        {
            if (this._returnM !== value)
            {
                this._returnM = value;
                dispatchEvent(new Event("returnMChanged"));
            }
            return;
        }// end function

        public function get returnZ() : Boolean
        {
            return this._returnZ;
        }// end function

        public function set returnZ(value:Boolean) : void
        {
            if (this._returnZ !== value)
            {
                this._returnZ = value;
                dispatchEvent(new Event("returnZChanged"));
            }
            return;
        }// end function

        public function get updateDelay() : Number
        {
            return this.m_updateDelay;
        }// end function

        private function set _598825414updateDelay(value:Number) : void
        {
            if (value < 0)
            {
                if (Log)
                {
                }
                if (Log.isError())
                {
                    logger.error("{0}::Invalid update value:{1}", id, value);
                }
                throw new ESRIError(ESRIMessageCodes.INVALID_UPDATE_DELAY, value);
            }
            if (value != this.m_updateDelay)
            {
                if (Log)
                {
                }
                if (Log.isDebug())
                {
                    logger.debug("{0}::updateDelay:old={1},new={2}", id, this.m_updateDelay, value);
                }
                this.m_updateDelay = value;
            }
            return;
        }// end function

        public function cancelJobStatusUpdates(jobId:String) : void
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::cancelJobStatusUpdates", id);
            }
            clearTimeout(this.m_updateTimers[jobId]);
            this.m_updateTimers[jobId] = null;
            return;
        }// end function

        private function getJobStatus(jobId:String, responder:GPResponder) : void
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getJobStatus:jobId={1}", id, jobId);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            _loc_3._ts = new Date().time;
            sendURLVariables("/jobs/" + jobId, _loc_3, responder, this.jobUpdateHandler);
            return;
        }// end function

        public function checkJobStatus(jobId:String, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::checkJobStatus:jobId={1}", id, jobId);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            _loc_3._ts = new Date().time;
            var _loc_4:* = new AsyncToken(null);
            if (responder)
            {
                _loc_4.addResponder(responder);
            }
            var _loc_5:* = new GPResponder(_loc_4);
            sendURLVariables("/jobs/" + jobId, _loc_3, _loc_5, this.jobUpdateHandler);
            return _loc_4;
        }// end function

        public function cancelJob(jobId:String, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::cancelJob:jobId={1}", id, jobId);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            _loc_3._ts = new Date().time;
            var _loc_4:* = new AsyncToken(null);
            if (responder)
            {
                _loc_4.addResponder(responder);
            }
            var _loc_5:* = new GPResponder(_loc_4);
            sendURLVariables("/jobs/" + jobId + "/cancel", _loc_3, _loc_5, this.jobCancelHandler);
            return _loc_4;
        }// end function

        private function jobCancelHandler(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:JobInfo = null;
            var _loc_5:GeoprocessorEvent = null;
            var _loc_6:IResponder = null;
            var _loc_7:GeoprocessorEvent = null;
            var _loc_3:* = asyncToken.responders[0];
            if (decodedObject.jobId)
            {
                _loc_4 = JobInfo.toJobInfo(decodedObject);
                if (Log)
                {
                }
                if (Log.isDebug())
                {
                    logger.debug("{0}::handleCancelJobResult:jobId={1},jobStatus={2}", id, _loc_4.jobId, _loc_4.jobStatus);
                }
                this.cancelJobLastResult = _loc_4;
                if (_loc_3.statusResponder)
                {
                    _loc_3.statusResponder.result(_loc_4);
                }
                _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.STATUS_UPDATE);
                _loc_5.jobInfo = _loc_4;
                dispatchEvent(_loc_5);
                this.m_jobId = _loc_4.jobId;
                switch(decodedObject.jobStatus)
                {
                    case JobInfo.STATUS_CANCELLING:
                    {
                        this.m_updateTimers[this.m_jobId] = setTimeout(this.getJobStatus, this.m_updateDelay, this.m_jobId, _loc_3);
                        break;
                    }
                    case JobInfo.STATUS_CANCELLED:
                    {
                        for each (_loc_6 in _loc_3.asyncToken.responders)
                        {
                            
                            _loc_6.result(_loc_4);
                        }
                        _loc_7 = new GeoprocessorEvent(GeoprocessorEvent.JOB_CANCELLED);
                        _loc_7.jobInfo = _loc_4;
                        dispatchEvent(_loc_7);
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                if (Log)
                {
                }
                if (Log.isWarn())
                {
                    logger.warn("{0}::Unhandled cancelJob result:{1}", id, ObjectUtil.toString(decodedObject));
                }
            }
            return;
        }// end function

        public function execute(inputParameters:Object, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, ObjectUtil.toString(inputParameters));
            }
            var _loc_3:* = new AsyncToken(null);
            if (responder)
            {
                _loc_3.addResponder(responder);
            }
            var _loc_4:* = this.toURLVariables(inputParameters, _loc_3);
            if (this.useAMF)
            {
                _loc_4.f = "amf";
            }
            return sendURLVariables2("/execute", _loc_4, this.handleExecuteResult, _loc_3);
        }// end function

        private function handleExecuteResult(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:ExecuteResult = null;
            var _loc_4:IResponder = null;
            var _loc_5:GeoprocessorEvent = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:ParameterValue = null;
            if (decodedObject is ExecuteResult)
            {
                _loc_3 = ExecuteResult(decodedObject);
                this.convertExecuteResultToPublicClasses(_loc_3);
            }
            else
            {
                _loc_6 = this.toParameterValues(decodedObject);
                _loc_7 = this.toMessages(decodedObject);
                _loc_3 = new ExecuteResult();
                _loc_3.results = _loc_6;
                _loc_3.messages = _loc_7;
            }
            this.executeLastResult = _loc_3;
            if (_loc_3.results)
            {
            }
            if (_loc_3.results.length > 0)
            {
                _loc_8 = _loc_3.results[0];
                this.executeLastResultFirstFeatureSet = _loc_8.value as FeatureSet;
            }
            else
            {
                this.executeLastResultFirstFeatureSet = null;
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.executeLastResult);
            }
            _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.EXECUTE_COMPLETE);
            _loc_5.executeResult = this.executeLastResult;
            dispatchEvent(_loc_5);
            return;
        }// end function

        private function convertExecuteResultToPublicClasses(executeResult:ExecuteResult) : void
        {
            var _loc_2:ParameterValue = null;
            for each (_loc_2 in executeResult.results)
            {
                
                this.convertParameterValueToPublicClasses(_loc_2);
            }
            return;
        }// end function

        private function convertParameterValueToPublicClasses(parameterValue:ParameterValue) : void
        {
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            if (!parameterValue)
            {
                return;
            }
            var _loc_2:* = parameterValue.dataType;
            var _loc_3:* = parameterValue.value;
            if (_loc_3 is Array)
            {
            }
            if (_loc_2)
            {
            }
            if (_loc_2.indexOf("GPMultiValue:") === 0)
            {
                _loc_4 = [];
                _loc_5 = _loc_2.substring("GPMultiValue:".length);
                for each (_loc_6 in _loc_3)
                {
                    
                    _loc_4.push(this.convertAMFClassToPublicClass(_loc_5, _loc_6));
                }
                parameterValue.value = _loc_4;
            }
            else
            {
                parameterValue.value = this.convertAMFClassToPublicClass(_loc_2, _loc_3);
            }
            return;
        }// end function

        private function convertAMFClassToPublicClass(dataType:String, value:Object) : Object
        {
            var _loc_4:FeatureSet = null;
            var _loc_6:GPFeatureRecordSetLayer = null;
            var _loc_7:GPRasterDataLayer = null;
            var _loc_8:GPRecordSet = null;
            var _loc_9:DataFile = null;
            var _loc_10:MapImage = null;
            var _loc_11:RasterData = null;
            var _loc_3:* = value;
            if (value is GPFeatureRecordSetLayer)
            {
                _loc_6 = GPFeatureRecordSetLayer(value);
                _loc_4 = new FeatureSet();
                _loc_4.features = _loc_6.features;
                _loc_4.geometryType = _loc_6.geometryType;
                _loc_4.spatialReference = _loc_6.spatialReference;
                _loc_4.fields = _loc_6.fields;
                _loc_4.hasM = _loc_6.hasM;
                _loc_4.hasZ = _loc_6.hasZ;
                _loc_4.exceededTransferLimit = _loc_6.exceededTransferLimit;
                _loc_3 = _loc_4;
            }
            else if (value is GPRasterDataLayer)
            {
                _loc_7 = GPRasterDataLayer(value);
                _loc_3 = new RasterData(_loc_7.url, _loc_7.format);
            }
            else if (value is GPRecordSet)
            {
                _loc_8 = GPRecordSet(value);
                _loc_4 = new FeatureSet(_loc_8.features);
                _loc_4.exceededTransferLimit = _loc_8.exceededTransferLimit;
                _loc_3 = _loc_4;
            }
            else
            {
                if (dataType == "GPDate")
                {
                }
                if (value is Number)
                {
                    _loc_3 = new Date(value);
                }
            }
            var _loc_5:* = this.getCurrentToken();
            if (_loc_3 is DataFile)
            {
                _loc_9 = _loc_3 as DataFile;
                _loc_9.url = ParameterValue.appendToken(_loc_9.url, _loc_5);
            }
            else if (_loc_3 is MapImage)
            {
                _loc_10 = _loc_3 as MapImage;
                if (_loc_10.source is String)
                {
                    _loc_10.source = ParameterValue.appendToken(String(_loc_10.source), _loc_5);
                }
            }
            else if (_loc_3 is RasterData)
            {
                _loc_11 = _loc_3 as RasterData;
                _loc_11.url = ParameterValue.appendToken(_loc_11.url, _loc_5);
            }
            return _loc_3;
        }// end function

        private function toParameterValues(decodedObject:Object) : Array
        {
            var _loc_3:Object = null;
            var _loc_2:Array = [];
            for each (_loc_3 in decodedObject.results)
            {
                
                _loc_2.push(ParameterValue.toParameterValue(_loc_3, this.getCurrentToken()));
            }
            return _loc_2;
        }// end function

        private function toMessages(decodedObject:Object) : Array
        {
            var _loc_3:Object = null;
            var _loc_2:Array = [];
            for each (_loc_3 in decodedObject.messages)
            {
                
                _loc_2.push(GPMessage.toGPMessage(_loc_3));
            }
            return _loc_2;
        }// end function

        public function submitJob(inputParameters:Object, responder:IResponder = null, statusResponder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::submitJob:{1}", id, ObjectUtil.toString(inputParameters));
            }
            var _loc_4:* = this.toURLVariables(inputParameters);
            var _loc_5:* = new AsyncToken(null);
            if (responder)
            {
                _loc_5.addResponder(responder);
            }
            var _loc_6:* = new GPResponder(_loc_5, statusResponder);
            sendURLVariables("/submitJob", _loc_4, _loc_6, this.jobUpdateHandler);
            return _loc_5;
        }// end function

        private function jobUpdateHandler(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:JobInfo = null;
            var _loc_5:GeoprocessorEvent = null;
            var _loc_6:IResponder = null;
            var _loc_7:GeoprocessorEvent = null;
            var _loc_3:* = asyncToken.responders[0];
            if (decodedObject.jobId)
            {
                _loc_4 = JobInfo.toJobInfo(decodedObject);
                if (Log)
                {
                }
                if (Log.isDebug())
                {
                    logger.debug("{0}::handleSubmitJobResult:jobId={1},jobStatus={2}", id, _loc_4.jobId, _loc_4.jobStatus);
                }
                this.submitJobLastResult = _loc_4;
                if (_loc_3.statusResponder)
                {
                    _loc_3.statusResponder.result(_loc_4);
                }
                _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.STATUS_UPDATE);
                _loc_5.jobInfo = _loc_4;
                dispatchEvent(_loc_5);
                this.m_jobId = _loc_4.jobId;
                switch(decodedObject.jobStatus)
                {
                    case JobInfo.STATUS_SUBMITTED:
                    case JobInfo.STATUS_EXECUTING:
                    case JobInfo.STATUS_WAITING:
                    case JobInfo.STATUS_NEW:
                    {
                        this.m_updateTimers[this.m_jobId] = setTimeout(this.getJobStatus, this.m_updateDelay, this.m_jobId, _loc_3);
                        break;
                    }
                    default:
                    {
                        for each (_loc_6 in _loc_3.asyncToken.responders)
                        {
                            
                            _loc_6.result(_loc_4);
                        }
                        _loc_7 = new GeoprocessorEvent(GeoprocessorEvent.JOB_COMPLETE);
                        _loc_7.jobInfo = _loc_4;
                        dispatchEvent(_loc_7);
                        break;
                    }
                }
            }
            else
            {
                if (Log)
                {
                }
                if (Log.isWarn())
                {
                    logger.warn("{0}::Unhandled submitJob result:{1}", id, ObjectUtil.toString(decodedObject));
                }
            }
            return;
        }// end function

        private function toURLVariables(obj:Object, asyncToken:AsyncToken = null) : URLVariables
        {
            var urlVariables:URLVariables;
            var key:String;
            var val:Object;
            var arrToBeNormalizedGeometry:Array;
            var featureSet:FeatureSet;
            var features:Array;
            var feature:Object;
            var k:String;
            var obj:* = obj;
            var asyncToken:* = asyncToken;
            urlVariables = new URLVariables();
            urlVariables.f = "json";
            if (this.m_processSpatialReference)
            {
                urlVariables["env:processSR"] = this.m_processSpatialReference.toSR();
            }
            if (this.m_outSpatialReference)
            {
                urlVariables["env:outSR"] = this.m_outSpatialReference.toSR();
            }
            if (this.returnM)
            {
                urlVariables.returnM = true;
            }
            if (this.returnZ)
            {
                urlVariables.returnZ = true;
            }
            var _loc_4:int = 0;
            var _loc_5:* = obj;
            while (_loc_5 in _loc_4)
            {
                
                key = _loc_5[_loc_4];
                val = obj[key];
                if (val is String)
                {
                    urlVariables[key] = val as String;
                    continue;
                }
                if (val is Number)
                {
                    urlVariables[key] = val as Number;
                    continue;
                }
                if (val is Boolean)
                {
                    urlVariables[key] = val as Boolean;
                    continue;
                }
                if (val is Date)
                {
                    urlVariables[key] = (val as Date).time;
                    continue;
                }
                if (val is Object)
                {
                }
                if (val != null)
                {
                    if (val is FeatureSet)
                    {
                    }
                    if (autoNormalize)
                    {
                        var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                var _loc_3:* = item as Array;
                var _loc_4:Array = [];
                var _loc_5:int = 0;
                while (_loc_5 < features.length)
                {
                    
                    if (features[_loc_5] is Graphic)
                    {
                        _loc_4.push(new Graphic(_loc_3[_loc_5], features[_loc_5].symbol, features[_loc_5].attributes));
                    }
                    else
                    {
                        _loc_4.push({geometry:_loc_3[_loc_5]});
                    }
                    _loc_5 = _loc_5 + 1;
                }
                var _loc_6:* = featureSet.toJSON();
                _loc_6.features = _loc_4;
                urlVariables[key] = JSONUtil.encode(_loc_6);
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
                        arrToBeNormalizedGeometry;
                        featureSet = val as FeatureSet;
                        features = featureSet.features ? (featureSet.features) : ([]);
                        var _loc_6:int = 0;
                        var _loc_7:* = features;
                        while (_loc_7 in _loc_6)
                        {
                            
                            feature = _loc_7[_loc_6];
                            arrToBeNormalizedGeometry.push(feature.geometry);
                        }
                        GeometryUtil.normalizeCentralMeridian(arrToBeNormalizedGeometry, GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultFunction, asyncToken));
                        continue;
                    }
                    urlVariables[key] = JSONUtil.encode(val);
                }
            }
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                var _loc_4:int = 0;
                var _loc_5:* = urlVariables;
                while (_loc_5 in _loc_4)
                {
                    
                    k = _loc_5[_loc_4];
                    logger.debug("{0}={1}", k, urlVariables[k]);
                }
            }
            return urlVariables;
        }// end function

        public function getInput(jobId:String, parameterName:String, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getInput:jobId={1},parameterName={2}", id, jobId, parameterName);
            }
            var _loc_4:* = new URLVariables();
            _loc_4.f = "json";
            return sendURLVariables("/jobs/" + jobId + "/inputs/" + parameterName, _loc_4, responder, this.handeGetInputResult);
        }// end function

        private function handeGetInputResult(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_5:GeoprocessorEvent = null;
            var _loc_3:* = ParameterValue.toParameterValue(decodedObject);
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handeGetInputResult:parameterValue={1}", id, _loc_3);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            this.getInputLastResult = _loc_3;
            _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.GET_INPUT_COMPLETE);
            _loc_5.parameterValue = _loc_3;
            dispatchEvent(_loc_5);
            return;
        }// end function

        public function getResultData(jobId:String, parameterName:String, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getResultData:jobId={1},parameterName={2}", id, jobId, parameterName);
            }
            var _loc_4:* = new URLVariables();
            _loc_4.f = this.useAMF ? ("amf") : ("json");
            _loc_4.returnType = "data";
            return sendURLVariables("/jobs/" + jobId + "/results/" + parameterName, _loc_4, responder, this.handleGetResultData);
        }// end function

        private function handleGetResultData(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:ParameterValue = null;
            var _loc_4:IResponder = null;
            var _loc_5:GeoprocessorEvent = null;
            if (decodedObject is ParameterValue)
            {
                _loc_3 = ParameterValue(decodedObject);
                this.convertParameterValueToPublicClasses(_loc_3);
            }
            else
            {
                _loc_3 = ParameterValue.toParameterValue(decodedObject, this.getCurrentToken());
            }
            this.getResultDataLastResult = _loc_3;
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleGetResultData:parameterValue={1}", id, this.getResultDataLastResult);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(this.getResultDataLastResult);
            }
            _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.GET_RESULT_DATA_COMPLETE);
            _loc_5.parameterValue = this.getResultDataLastResult;
            dispatchEvent(_loc_5);
            return;
        }// end function

        public function getResultImage(jobId:String, parameterName:String, imageParameters:ImageParameters, responder:IResponder = null) : AsyncToken
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getResultImage:jobId={1},parameterName={2}", id, jobId, parameterName);
            }
            var _loc_5:* = new URLVariables();
            _loc_5.f = "json";
            imageParameters.appendToURLVariables(_loc_5);
            return sendURLVariables("/jobs/" + jobId + "/results/" + parameterName, _loc_5, responder, this.handleGetResultImage);
        }// end function

        private function handleGetResultImage(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_5:GeoprocessorEvent = null;
            var _loc_3:* = ParameterValue.toParameterValue(decodedObject, this.getCurrentToken());
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleGetResultImage:parameterValue={1}", id, _loc_3);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            this.getResultImageLastResult = _loc_3;
            _loc_5 = new GeoprocessorEvent(GeoprocessorEvent.GET_RESULT_IMAGE_COMPLETE);
            _loc_5.parameterValue = _loc_3;
            dispatchEvent(_loc_5);
            return;
        }// end function

        public function getResultImageLayer(jobId:String, parameterName:String, imageParameters:ImageParameters = null) : GPResultImageLayer
        {
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getResultImageLayer:jobId={1},parameterName={2}", id, jobId, parameterName);
            }
            var _loc_4:* = new GPResultImageLayer(url);
            _loc_4.proxyURL = proxyURL;
            _loc_4.token = token;
            _loc_4.jobId = jobId;
            _loc_4.parameterName = parameterName;
            if (imageParameters)
            {
                if (!isNaN(imageParameters.dpi))
                {
                    _loc_4.dpi = imageParameters.dpi;
                }
                if (imageParameters.format)
                {
                    _loc_4.imageFormat = imageParameters.format;
                }
                _loc_4.imageTransparency = imageParameters.transparent;
            }
            return _loc_4;
        }// end function

        public function getResultMapServiceLayer(jobId:String) : ArcGISDynamicMapServiceLayer
        {
            var _loc_2:ArcGISDynamicMapServiceLayer = null;
            var _loc_5:String = null;
            if (Log)
            {
            }
            if (Log.isDebug())
            {
                logger.info("{0}::getResultMapServiceLayer:jobId={1}", id, jobId);
            }
            var _loc_3:* = new URL(this.url);
            var _loc_4:* = _loc_3.path ? (_loc_3.path.indexOf("/GPServer/")) : (-1);
            if (_loc_4 > 0)
            {
                _loc_5 = _loc_3.path.substring(0, _loc_4) + "/MapServer/jobs/" + jobId;
                if (_loc_3.query)
                {
                    _loc_5 = _loc_5 + ("?" + _loc_3.query.toString());
                }
                _loc_2 = new ArcGISDynamicMapServiceLayer(_loc_5, proxyURL, token);
            }
            return _loc_2;
        }// end function

        private function getCurrentToken() : String
        {
            var _loc_1:* = IdentityManager.instance.findCredential(urlObj.path);
            if (_loc_1)
            {
            }
            if (!_loc_1.token)
            {
            }
            if (!this.token)
            {
                if (urlObj.query)
                {
                }
            }
            var _loc_2:* = urlObj.query.token;
            return _loc_2;
        }// end function

        public function get executeLastResult() : ExecuteResult
        {
            return this._2143403096executeLastResult;
        }// end function

        public function set executeLastResult(value:ExecuteResult) : void
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

        public function get executeLastResultFirstFeatureSet() : FeatureSet
        {
            return this._929111956executeLastResultFirstFeatureSet;
        }// end function

        public function set executeLastResultFirstFeatureSet(value:FeatureSet) : void
        {
            arguments = this._929111956executeLastResultFirstFeatureSet;
            if (arguments !== value)
            {
                this._929111956executeLastResultFirstFeatureSet = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeLastResultFirstFeatureSet", arguments, value));
                }
            }
            return;
        }// end function

        public function get getInputLastResult() : ParameterValue
        {
            return this._163172231getInputLastResult;
        }// end function

        public function set getInputLastResult(value:ParameterValue) : void
        {
            arguments = this._163172231getInputLastResult;
            if (arguments !== value)
            {
                this._163172231getInputLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getInputLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get getResultDataLastResult() : ParameterValue
        {
            return this._836016016getResultDataLastResult;
        }// end function

        public function set getResultDataLastResult(value:ParameterValue) : void
        {
            arguments = this._836016016getResultDataLastResult;
            if (arguments !== value)
            {
                this._836016016getResultDataLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getResultDataLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get getResultImageLastResult() : ParameterValue
        {
            return this._1809658491getResultImageLastResult;
        }// end function

        public function set getResultImageLastResult(value:ParameterValue) : void
        {
            arguments = this._1809658491getResultImageLastResult;
            if (arguments !== value)
            {
                this._1809658491getResultImageLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "getResultImageLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function set outSpatialReference(value:SpatialReference) : void
        {
            arguments = this.outSpatialReference;
            if (arguments !== value)
            {
                this._1929069035outSpatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outSpatialReference", arguments, value));
                }
            }
            return;
        }// end function

        public function set processSpatialReference(value:SpatialReference) : void
        {
            arguments = this.processSpatialReference;
            if (arguments !== value)
            {
                this._297257782processSpatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "processSpatialReference", arguments, value));
                }
            }
            return;
        }// end function

        public function get cancelJobLastResult() : JobInfo
        {
            return this._720501354cancelJobLastResult;
        }// end function

        public function set cancelJobLastResult(value:JobInfo) : void
        {
            arguments = this._720501354cancelJobLastResult;
            if (arguments !== value)
            {
                this._720501354cancelJobLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cancelJobLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function get submitJobLastResult() : JobInfo
        {
            return this._1993210696submitJobLastResult;
        }// end function

        public function set submitJobLastResult(value:JobInfo) : void
        {
            arguments = this._1993210696submitJobLastResult;
            if (arguments !== value)
            {
                this._1993210696submitJobLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "submitJobLastResult", arguments, value));
                }
            }
            return;
        }// end function

        public function set updateDelay(value:Number) : void
        {
            arguments = this.updateDelay;
            if (arguments !== value)
            {
                this._598825414updateDelay = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "updateDelay", arguments, value));
                }
            }
            return;
        }// end function

    }
}
