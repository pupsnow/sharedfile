package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LayerTimeOptions extends EventDispatcher implements IJSONSupport
    {
        private var _41955764layerId:Number;
        private var _996557718timeDataCumulative:Boolean = false;
        private var _665490880timeOffset:Number;
        private var _1590793841timeOffsetUnits:String;
        private var _148016908useTime:Boolean = false;

        public function LayerTimeOptions()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            _loc_2.useTime = this.useTime;
            _loc_2.timeDataCumulative = this.timeDataCumulative;
            if (isFinite(this.timeOffset))
            {
                isFinite(this.timeOffset);
            }
            if (this.timeOffsetUnits)
            {
                _loc_2.timeOffset = this.timeOffset;
                _loc_2.timeOffsetUnits = this.timeOffsetUnits;
            }
            return _loc_2;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get layerId() : Number
        {
            return this._41955764layerId;
        }// end function

        public function set layerId(value:Number) : void
        {
            arguments = this._41955764layerId;
            if (arguments !== value)
            {
                this._41955764layerId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layerId", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeDataCumulative() : Boolean
        {
            return this._996557718timeDataCumulative;
        }// end function

        public function set timeDataCumulative(value:Boolean) : void
        {
            arguments = this._996557718timeDataCumulative;
            if (arguments !== value)
            {
                this._996557718timeDataCumulative = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeDataCumulative", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeOffset() : Number
        {
            return this._665490880timeOffset;
        }// end function

        public function set timeOffset(value:Number) : void
        {
            arguments = this._665490880timeOffset;
            if (arguments !== value)
            {
                this._665490880timeOffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeOffset", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeOffsetUnits() : String
        {
            return this._1590793841timeOffsetUnits;
        }// end function

        public function set timeOffsetUnits(value:String) : void
        {
            arguments = this._1590793841timeOffsetUnits;
            if (arguments !== value)
            {
                this._1590793841timeOffsetUnits = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeOffsetUnits", arguments, value));
                }
            }
            return;
        }// end function

        public function get useTime() : Boolean
        {
            return this._148016908useTime;
        }// end function

        public function set useTime(value:Boolean) : void
        {
            arguments = this._148016908useTime;
            if (arguments !== value)
            {
                this._148016908useTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "useTime", arguments, value));
                }
            }
            return;
        }// end function

        static function toLayerTimeOptions(obj:Object) : LayerTimeOptions
        {
            var _loc_2:LayerTimeOptions = null;
            if (obj)
            {
                _loc_2 = new LayerTimeOptions;
                _loc_2.timeDataCumulative = obj.timeDataCumulative;
                _loc_2.timeOffset = obj.timeOffset;
                _loc_2.timeOffsetUnits = obj.timeOffsetUnits;
                _loc_2.useTime = obj.useTime;
            }
            return _loc_2;
        }// end function

    }
}
