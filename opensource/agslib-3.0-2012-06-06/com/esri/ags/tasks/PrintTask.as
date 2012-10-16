package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;
    import flash.net.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class PrintTask extends BaseTask
    {
        private var _gp:Geoprocessor;
        private var _getServiceInfoLastResult:PrintServiceInfo;

        public function PrintTask(url:String = null)
        {
            super(url);
            this._gp = new Geoprocessor(url);
            this._gp.useAMF = false;
            this._gp.addEventListener(FaultEvent.FAULT, this.gpFaultHandler);
            this._gp.addEventListener(GeoprocessorEvent.EXECUTE_COMPLETE, this.gpExecuteCompleteHandler);
            this._gp.addEventListener(GeoprocessorEvent.GET_RESULT_DATA_COMPLETE, this.gpGetResultDataCompleteHandler);
            this._gp.addEventListener(GeoprocessorEvent.JOB_COMPLETE, this.gpJobCompleteHandler);
            this._gp.addEventListener(GeoprocessorEvent.STATUS_UPDATE, this.gpStatusUpdateHandler);
            return;
        }// end function

        public function get executeLastResult() : ExecuteResult
        {
            return this._gp.executeLastResult;
        }// end function

        public function get getResultDataLastResult() : ParameterValue
        {
            return this._gp.getResultDataLastResult;
        }// end function

        public function get getServiceInfoLastResult() : PrintServiceInfo
        {
            return this._getServiceInfoLastResult;
        }// end function

        public function get submitJobLastResult() : JobInfo
        {
            return this._gp.submitJobLastResult;
        }// end function

        public function get updateDelay() : Number
        {
            return this._gp.updateDelay;
        }// end function

        public function set updateDelay(value:Number) : void
        {
            if (this._gp.updateDelay !== value)
            {
                this._gp.updateDelay = value;
                dispatchEvent(new Event("updateDelayChanged"));
            }
            return;
        }// end function

        public function cancelJobStatusUpdates(jobId:String) : void
        {
            this._gp.cancelJobStatusUpdates(jobId);
            return;
        }// end function

        public function checkJobStatus(jobId:String, responder:IResponder = null) : AsyncToken
        {
            return this._gp.checkJobStatus(jobId, responder);
        }// end function

        public function execute(printParameters:PrintParameters, responder:IResponder = null) : AsyncToken
        {
            this.updateGP();
            return this._gp.execute(printParameters.toJSON(), responder);
        }// end function

        public function getResultData(jobId:String, responder:IResponder = null) : AsyncToken
        {
            this.updateGP();
            return this._gp.getResultData(jobId, "Output_File", responder);
        }// end function

        public function getServiceInfo(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            return sendURLVariables(null, _loc_2, responder, this.handleGetServiceInfo);
        }// end function

        private function handleGetServiceInfo(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:PrintEvent = null;
            this._getServiceInfoLastResult = PrintServiceInfo.fromJSON(decodedObject);
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this._getServiceInfoLastResult);
            }
            _loc_4 = new PrintEvent(PrintEvent.GET_SERVICE_INFO_COMPLETE);
            _loc_4.serviceInfo = this._getServiceInfoLastResult;
            dispatchEvent(_loc_4);
            return;
        }// end function

        public function submitJob(printParameters:PrintParameters, responder:IResponder = null, statusResponder:IResponder = null) : AsyncToken
        {
            this.updateGP();
            return this._gp.submitJob(printParameters.toJSON(), responder, statusResponder);
        }// end function

        private function updateGP() : void
        {
            this._gp.concurrency = concurrency;
            this._gp.disableClientCaching = disableClientCaching;
            this._gp.method = method;
            this._gp.proxyURL = proxyURL;
            this._gp.requestTimeout = requestTimeout;
            this._gp.showBusyCursor = showBusyCursor;
            this._gp.token = token;
            this._gp.url = url;
            return;
        }// end function

        private function gpFaultHandler(event:FaultEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function gpExecuteCompleteHandler(event:GeoprocessorEvent) : void
        {
            var _loc_2:* = new PrintEvent(PrintEvent.EXECUTE_COMPLETE);
            _loc_2.executeResult = event.executeResult;
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function gpGetResultDataCompleteHandler(event:GeoprocessorEvent) : void
        {
            var _loc_2:* = new PrintEvent(PrintEvent.GET_RESULT_DATA_COMPLETE);
            _loc_2.parameterValue = event.parameterValue;
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function gpJobCompleteHandler(event:GeoprocessorEvent) : void
        {
            var _loc_2:* = new PrintEvent(PrintEvent.JOB_COMPLETE);
            _loc_2.jobInfo = event.jobInfo;
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function gpStatusUpdateHandler(event:GeoprocessorEvent) : void
        {
            var _loc_2:* = new PrintEvent(PrintEvent.STATUS_UPDATE);
            _loc_2.jobInfo = event.jobInfo;
            dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
