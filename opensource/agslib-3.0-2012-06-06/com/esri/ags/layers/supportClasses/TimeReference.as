package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class TimeReference extends EventDispatcher
    {
        private var _1514965151respectsDaylightSaving:Boolean;
        private var _2077180903timeZone:String;

        public function TimeReference()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get respectsDaylightSaving() : Boolean
        {
            return this._1514965151respectsDaylightSaving;
        }// end function

        public function set respectsDaylightSaving(value:Boolean) : void
        {
            arguments = this._1514965151respectsDaylightSaving;
            if (arguments !== value)
            {
                this._1514965151respectsDaylightSaving = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "respectsDaylightSaving", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeZone() : String
        {
            return this._2077180903timeZone;
        }// end function

        public function set timeZone(value:String) : void
        {
            arguments = this._2077180903timeZone;
            if (arguments !== value)
            {
                this._2077180903timeZone = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeZone", arguments, value));
                }
            }
            return;
        }// end function

        static function toTimeReference(obj:Object) : TimeReference
        {
            var _loc_2:TimeReference = null;
            if (obj)
            {
                _loc_2 = new TimeReference;
                _loc_2.respectsDaylightSaving = obj.respectsDaylightSaving;
                _loc_2.timeZone = obj.timeZone;
            }
            return _loc_2;
        }// end function

    }
}
