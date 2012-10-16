package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class TableInfo extends EventDispatcher
    {
        private var _3355id:Number;
        private var _3373707name:String;

        public function TableInfo()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get id() : Number
        {
            return this._3355id;
        }// end function

        public function set id(value:Number) : void
        {
            arguments = this._3355id;
            if (arguments !== value)
            {
                this._3355id = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", arguments, value));
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

        static function toTableInfo(obj:Object) : TableInfo
        {
            var _loc_2:TableInfo = null;
            if (obj)
            {
                _loc_2 = new TableInfo;
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
            }
            return _loc_2;
        }// end function

    }
}
