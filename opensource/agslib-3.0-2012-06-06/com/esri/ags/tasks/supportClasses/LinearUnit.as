package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class LinearUnit extends EventDispatcher
    {
        private var _288459765distance:Number;
        private var _111433583units:String;

        public function LinearUnit(distance:Number = 0, units:String = null)
        {
            this.distance = distance;
            this.units = units;
            return;
        }// end function

        public function get distance() : Number
        {
            return this._288459765distance;
        }// end function

        public function set distance(value:Number) : void
        {
            arguments = this._288459765distance;
            if (arguments !== value)
            {
                this._288459765distance = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "distance", arguments, value));
                }
            }
            return;
        }// end function

        public function get units() : String
        {
            return this._111433583units;
        }// end function

        public function set units(value:String) : void
        {
            arguments = this._111433583units;
            if (arguments !== value)
            {
                this._111433583units = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "units", arguments, value));
                }
            }
            return;
        }// end function

        static function toLinearUnit(decodedObject:Object) : LinearUnit
        {
            var _loc_2:* = new LinearUnit;
            _loc_2.distance = decodedObject.distance;
            _loc_2.units = decodedObject.units;
            return _loc_2;
        }// end function

    }
}
