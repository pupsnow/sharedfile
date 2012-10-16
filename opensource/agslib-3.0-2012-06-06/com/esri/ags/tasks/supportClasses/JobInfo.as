package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class JobInfo extends EventDispatcher
    {
        private var _101296568jobId:String;
        private var _1129174543jobStatus:String;
        private var _462094004messages:Array;
        public static const STATUS_SUCCEEDED:String = "esriJobSucceeded";
        public static const STATUS_FAILED:String = "esriJobFailed";
        public static const STATUS_DELETED:String = "esriJobDeleted";
        public static const STATUS_CANCELLED:String = "esriJobCancelled";
        public static const STATUS_TIMED_OUT:String = "esriJobTimedOut";
        public static const STATUS_CANCELLING:String = "esriJobCancelling";
        public static const STATUS_DELETING:String = "esriJobDeleting";
        public static const STATUS_EXECUTING:String = "esriJobExecuting";
        public static const STATUS_NEW:String = "esriJobNew";
        public static const STATUS_SUBMITTED:String = "esriJobSubmitted";
        public static const STATUS_WAITING:String = "esriJobWaiting";

        public function JobInfo()
        {
            return;
        }// end function

        public function get jobId() : String
        {
            return this._101296568jobId;
        }// end function

        public function set jobId(value:String) : void
        {
            arguments = this._101296568jobId;
            if (arguments !== value)
            {
                this._101296568jobId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "jobId", arguments, value));
                }
            }
            return;
        }// end function

        public function get jobStatus() : String
        {
            return this._1129174543jobStatus;
        }// end function

        public function set jobStatus(value:String) : void
        {
            arguments = this._1129174543jobStatus;
            if (arguments !== value)
            {
                this._1129174543jobStatus = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "jobStatus", arguments, value));
                }
            }
            return;
        }// end function

        public function get messages() : Array
        {
            return this._462094004messages;
        }// end function

        public function set messages(value:Array) : void
        {
            arguments = this._462094004messages;
            if (arguments !== value)
            {
                this._462094004messages = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "messages", arguments, value));
                }
            }
            return;
        }// end function

        static function toJobInfo(decodedObject:Object) : JobInfo
        {
            var _loc_3:Object = null;
            var _loc_2:* = new JobInfo;
            _loc_2.jobId = decodedObject.jobId;
            _loc_2.jobStatus = decodedObject.jobStatus;
            _loc_2.messages = [];
            for each (_loc_3 in decodedObject.messages)
            {
                
                _loc_2.messages.push(GPMessage.toGPMessage(_loc_3));
            }
            return _loc_2;
        }// end function

    }
}
