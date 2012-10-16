package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class CodedValue extends EventDispatcher
    {
        private var _3059181code:String;
        private var _3373707name:String;

        public function CodedValue()
        {
            return;
        }// end function

        public function get code() : String
        {
            return this._3059181code;
        }// end function

        public function set code(value:String) : void
        {
            arguments = this._3059181code;
            if (arguments !== value)
            {
                this._3059181code = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "code", arguments, value));
                }
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._3373707name;
        }// end function

        public function set name(value:String) : void
        {
            arguments = this._3373707name;
            if (arguments !== value)
            {
                this._3373707name = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", arguments, value));
                }
            }
            return;
        }// end function

        static function toCodedValue(obj:Object) : CodedValue
        {
            var _loc_2:CodedValue = null;
            if (obj)
            {
                _loc_2 = new CodedValue;
                _loc_2.code = obj.code;
                _loc_2.name = obj.name;
            }
            return _loc_2;
        }// end function

    }
}
