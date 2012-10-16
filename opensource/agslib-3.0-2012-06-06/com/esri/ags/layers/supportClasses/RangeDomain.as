package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class RangeDomain extends EventDispatcher implements IDomain
    {
        private var _maxValue:Number;
        private var _minValue:Number;
        private var _name:String;

        public function RangeDomain()
        {
            return;
        }// end function

        public function get maxValue() : Number
        {
            return this._maxValue;
        }// end function

        public function set maxValue(value:Number) : void
        {
            if (this._maxValue !== value)
            {
                this._maxValue = value;
                dispatchEvent(new Event("maxValueChanged"));
            }
            return;
        }// end function

        public function get minValue() : Number
        {
            return this._minValue;
        }// end function

        public function set minValue(value:Number) : void
        {
            if (this._minValue !== value)
            {
                this._minValue = value;
                dispatchEvent(new Event("minValueChanged"));
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function set name(value:String) : void
        {
            if (this._name !== value)
            {
                this._name = value;
                dispatchEvent(new Event("nameChanged"));
            }
            return;
        }// end function

        static function toRangeDomain(obj:Object) : RangeDomain
        {
            var _loc_2:RangeDomain = null;
            var _loc_3:Array = null;
            if (obj)
            {
                _loc_2 = new RangeDomain;
                _loc_2.name = obj.name;
                _loc_3 = obj.range as Array;
                if (_loc_3)
                {
                }
                if (_loc_3.length >= 2)
                {
                    _loc_2.minValue = _loc_3[0];
                    _loc_2.maxValue = _loc_3[1];
                }
            }
            return _loc_2;
        }// end function

    }
}
