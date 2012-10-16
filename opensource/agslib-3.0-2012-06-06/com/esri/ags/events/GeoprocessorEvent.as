package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class GeoprocessorEvent extends Event
    {
        public var executeResult:ExecuteResult;
        public var parameterValue:ParameterValue;
        public var jobInfo:JobInfo;
        public static const EXECUTE_COMPLETE:String = "executeComplete";
        public static const GET_INPUT_COMPLETE:String = "getInputComplete";
        public static const GET_RESULT_DATA_COMPLETE:String = "getResultDataComplete";
        public static const GET_RESULT_IMAGE_COMPLETE:String = "getResultImageComplete";
        public static const JOB_COMPLETE:String = "jobComplete";
        public static const JOB_CANCELLED:String = "jobCancelled";
        public static const STATUS_UPDATE:String = "statusUpdate";

        public function GeoprocessorEvent(type:String, executeResult:ExecuteResult = null, parameterValue:ParameterValue = null, jobInfo:JobInfo = null)
        {
            super(type);
            this.executeResult = executeResult;
            this.parameterValue = parameterValue;
            this.jobInfo = jobInfo;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GeoprocessorEvent(type, this.executeResult, this.parameterValue, this.jobInfo);
        }// end function

        override public function toString() : String
        {
            return formatToString("GeoprocessorEvent", "type", "executeResult", "parameterValue", "jobInfo");
        }// end function

    }
}
