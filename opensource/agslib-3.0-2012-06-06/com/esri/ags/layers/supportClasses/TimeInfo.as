package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class TimeInfo extends EventDispatcher
    {
        private var _780029843defaultTimeInterval:Number;
        private var _19604580defaultTimeIntervalUnits:String;
        private var _1210229310defaultTimeWindow:Number;
        private var _397970542endTimeField:String;
        private var _165791670exportOptions:LayerTimeOptions;
        private var _3310736hasLiveData:Boolean;
        private var _341098517startTimeField:String;
        private var _913014450timeInterval:Number;
        private var _1270040541timeIntervalUnits:String;
        private var _396226647timeExtent:TimeExtent;
        private var _1105388286timeReference:TimeReference;
        private var _211840023timeRelation:String;
        private var _535410476trackIdField:String;
        public static const UNIT_CENTURIES:String = "esriTimeUnitsCenturies";
        public static const UNIT_DAYS:String = "esriTimeUnitsDays";
        public static const UNIT_DECADES:String = "esriTimeUnitsDecades";
        public static const UNIT_HOURS:String = "esriTimeUnitsHours";
        public static const UNIT_MILLISECONDS:String = "esriTimeUnitsMilliseconds";
        public static const UNIT_MINUTES:String = "esriTimeUnitsMinutes";
        public static const UNIT_MONTHS:String = "esriTimeUnitsMonths";
        public static const UNIT_SECONDS:String = "esriTimeUnitsSeconds";
        public static const UNIT_WEEKS:String = "esriTimeUnitsWeeks";
        public static const UNIT_YEARS:String = "esriTimeUnitsYears";
        public static const UNIT_UNKNOWN:String = "esriTimeUnitsUnknown";
        static const UNIT_MILLISECONDS_MS:Number = 1;
        static const UNIT_SECONDS_MS:Number = 1000;
        static const UNIT_MINUTES_MS:Number = 60000;
        static const UNIT_HOURS_MS:Number = 3.6e+006;
        static const UNIT_DAYS_MS:Number = 8.64e+007;
        static const UNIT_WEEKS_MS:Number = 6.048e+008;
        static const UNIT_MONTHS_MS:Number = 2.62975e+009;
        static const UNIT_YEARS_MS:Number = 3.15576e+010;
        static const UNIT_DECADES_MS:Number = 3.15576e+011;
        static const UNIT_CENTURIES_MS:Number = 3.15576e+012;
        static const UNIT_TIMES_MS:Object = {};

        public function TimeInfo()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get defaultTimeInterval() : Number
        {
            return this._780029843defaultTimeInterval;
        }// end function

        public function set defaultTimeInterval(value:Number) : void
        {
            arguments = this._780029843defaultTimeInterval;
            if (arguments !== value)
            {
                this._780029843defaultTimeInterval = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultTimeInterval", arguments, value));
                }
            }
            return;
        }// end function

        public function get defaultTimeIntervalUnits() : String
        {
            return this._19604580defaultTimeIntervalUnits;
        }// end function

        public function set defaultTimeIntervalUnits(value:String) : void
        {
            arguments = this._19604580defaultTimeIntervalUnits;
            if (arguments !== value)
            {
                this._19604580defaultTimeIntervalUnits = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultTimeIntervalUnits", arguments, value));
                }
            }
            return;
        }// end function

        public function get defaultTimeWindow() : Number
        {
            return this._1210229310defaultTimeWindow;
        }// end function

        public function set defaultTimeWindow(value:Number) : void
        {
            arguments = this._1210229310defaultTimeWindow;
            if (arguments !== value)
            {
                this._1210229310defaultTimeWindow = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultTimeWindow", arguments, value));
                }
            }
            return;
        }// end function

        public function get endTimeField() : String
        {
            return this._397970542endTimeField;
        }// end function

        public function set endTimeField(value:String) : void
        {
            arguments = this._397970542endTimeField;
            if (arguments !== value)
            {
                this._397970542endTimeField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "endTimeField", arguments, value));
                }
            }
            return;
        }// end function

        public function get exportOptions() : LayerTimeOptions
        {
            return this._165791670exportOptions;
        }// end function

        public function set exportOptions(value:LayerTimeOptions) : void
        {
            arguments = this._165791670exportOptions;
            if (arguments !== value)
            {
                this._165791670exportOptions = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "exportOptions", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasLiveData() : Boolean
        {
            return this._3310736hasLiveData;
        }// end function

        public function set hasLiveData(value:Boolean) : void
        {
            arguments = this._3310736hasLiveData;
            if (arguments !== value)
            {
                this._3310736hasLiveData = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasLiveData", arguments, value));
                }
            }
            return;
        }// end function

        public function get startTimeField() : String
        {
            return this._341098517startTimeField;
        }// end function

        public function set startTimeField(value:String) : void
        {
            arguments = this._341098517startTimeField;
            if (arguments !== value)
            {
                this._341098517startTimeField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "startTimeField", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeInterval() : Number
        {
            return this._913014450timeInterval;
        }// end function

        public function set timeInterval(value:Number) : void
        {
            arguments = this._913014450timeInterval;
            if (arguments !== value)
            {
                this._913014450timeInterval = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeInterval", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeIntervalUnits() : String
        {
            return this._1270040541timeIntervalUnits;
        }// end function

        public function set timeIntervalUnits(value:String) : void
        {
            arguments = this._1270040541timeIntervalUnits;
            if (arguments !== value)
            {
                this._1270040541timeIntervalUnits = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeIntervalUnits", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeExtent() : TimeExtent
        {
            return this._396226647timeExtent;
        }// end function

        public function set timeExtent(value:TimeExtent) : void
        {
            arguments = this._396226647timeExtent;
            if (arguments !== value)
            {
                this._396226647timeExtent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeExtent", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeReference() : TimeReference
        {
            return this._1105388286timeReference;
        }// end function

        public function set timeReference(value:TimeReference) : void
        {
            arguments = this._1105388286timeReference;
            if (arguments !== value)
            {
                this._1105388286timeReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeReference", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeRelation() : String
        {
            return this._211840023timeRelation;
        }// end function

        public function set timeRelation(value:String) : void
        {
            arguments = this._211840023timeRelation;
            if (arguments !== value)
            {
                this._211840023timeRelation = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeRelation", arguments, value));
                }
            }
            return;
        }// end function

        public function get trackIdField() : String
        {
            return this._535410476trackIdField;
        }// end function

        public function set trackIdField(value:String) : void
        {
            arguments = this._535410476trackIdField;
            if (arguments !== value)
            {
                this._535410476trackIdField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "trackIdField", arguments, value));
                }
            }
            return;
        }// end function

        static function toTimeInfo(obj:Object) : TimeInfo
        {
            var _loc_2:TimeInfo = null;
            if (obj)
            {
                _loc_2 = new TimeInfo;
                _loc_2.defaultTimeInterval = obj.defaultTimeInterval;
                _loc_2.defaultTimeIntervalUnits = obj.defaultTimeIntervalUnits;
                _loc_2.defaultTimeWindow = obj.defaultTimeWindow;
                _loc_2.endTimeField = obj.endTimeField;
                _loc_2.exportOptions = LayerTimeOptions.toLayerTimeOptions(obj.exportOptions);
                _loc_2.hasLiveData = obj.hasLiveData;
                _loc_2.startTimeField = obj.startTimeField;
                _loc_2.timeExtent = TimeExtent.fromJSON(obj.timeExtent);
                _loc_2.timeInterval = obj.timeInterval;
                _loc_2.timeIntervalUnits = obj.timeIntervalUnits;
                _loc_2.timeReference = TimeReference.toTimeReference(obj.timeReference);
                _loc_2.timeRelation = obj.timeRelation;
                _loc_2.trackIdField = obj.trackIdField;
            }
            return _loc_2;
        }// end function

        UNIT_TIMES_MS[UNIT_MILLISECONDS] = UNIT_MILLISECONDS_MS;
        UNIT_TIMES_MS[UNIT_SECONDS] = UNIT_SECONDS_MS;
        UNIT_TIMES_MS[UNIT_MINUTES] = UNIT_MINUTES_MS;
        UNIT_TIMES_MS[UNIT_HOURS] = UNIT_HOURS_MS;
        UNIT_TIMES_MS[UNIT_DAYS] = UNIT_DAYS_MS;
        UNIT_TIMES_MS[UNIT_WEEKS] = UNIT_WEEKS_MS;
        UNIT_TIMES_MS[UNIT_MONTHS] = UNIT_MONTHS_MS;
        UNIT_TIMES_MS[UNIT_YEARS] = UNIT_YEARS_MS;
        UNIT_TIMES_MS[UNIT_DECADES] = UNIT_DECADES_MS;
        UNIT_TIMES_MS[UNIT_CENTURIES] = UNIT_CENTURIES_MS;
    }
}
