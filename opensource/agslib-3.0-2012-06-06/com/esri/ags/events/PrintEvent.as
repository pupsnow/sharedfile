package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class PrintEvent extends Event
    {
        public var executeResult:ExecuteResult;
        public var jobInfo:JobInfo;
        public var parameterValue:ParameterValue;
        public var serviceInfo:PrintServiceInfo;
        public static const EXECUTE_COMPLETE:String = "executeComplete";
        public static const GET_RESULT_DATA_COMPLETE:String = "getResultDataComplete";
        public static const GET_SERVICE_INFO_COMPLETE:String = "getServiceInfoComplete";
        public static const JOB_COMPLETE:String = "jobComplete";
        public static const STATUS_UPDATE:String = "statusUpdate";

        public function PrintEvent(type:String)
        {
            super(type);
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new PrintEvent(type);
            _loc_1.executeResult = this.executeResult;
            _loc_1.jobInfo = this.jobInfo;
            _loc_1.parameterValue = this.parameterValue;
            _loc_1.serviceInfo = this.serviceInfo;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("PrintEvent", "type", "executeResult", "jobInfo", "parameterValue", "serviceInfo");
        }// end function

    }
}
