package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class CodedValueDomain extends EventDispatcher implements IDomain
    {
        private var _codedValues:Array;
        private var _name:String;

        public function CodedValueDomain()
        {
            return;
        }// end function

        public function get codedValues() : Array
        {
            return this._codedValues;
        }// end function

        public function set codedValues(value:Array) : void
        {
            this._codedValues = value;
            dispatchEvent(new Event("codedValuesChanged"));
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

        static function toCodedValueDomain(obj:Object) : CodedValueDomain
        {
            var _loc_2:CodedValueDomain = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new CodedValueDomain;
                _loc_2.name = obj.name;
                if (obj.codedValues)
                {
                    _loc_2.codedValues = [];
                    for each (_loc_3 in obj.codedValues)
                    {
                        
                        _loc_2.codedValues.push(CodedValue.toCodedValue(_loc_3));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
