package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class IdentifyResult extends EventDispatcher
    {
        private var _41955764layerId:Number;
        private var _1664633988layerName:String;
        private var _1424604157displayFieldName:String;
        private var _979207434feature:Graphic;
        private var _111972721value:String;

        public function IdentifyResult()
        {
            return;
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

        public function get layerName() : String
        {
            return this._1664633988layerName;
        }// end function

        public function set layerName(value:String) : void
        {
            arguments = this._1664633988layerName;
            if (arguments !== value)
            {
                this._1664633988layerName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layerName", arguments, value));
                }
            }
            return;
        }// end function

        public function get displayFieldName() : String
        {
            return this._1424604157displayFieldName;
        }// end function

        public function set displayFieldName(value:String) : void
        {
            arguments = this._1424604157displayFieldName;
            if (arguments !== value)
            {
                this._1424604157displayFieldName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "displayFieldName", arguments, value));
                }
            }
            return;
        }// end function

        public function get feature() : Graphic
        {
            return this._979207434feature;
        }// end function

        public function set feature(value:Graphic) : void
        {
            arguments = this._979207434feature;
            if (arguments !== value)
            {
                this._979207434feature = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "feature", arguments, value));
                }
            }
            return;
        }// end function

        public function get value() : String
        {
            return this._111972721value;
        }// end function

        public function set value(value:String) : void
        {
            arguments = this._111972721value;
            if (arguments !== value)
            {
                this._111972721value = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", arguments, value));
                }
            }
            return;
        }// end function

        static function toIdentifyResult(obj:Object) : IdentifyResult
        {
            var _loc_2:IdentifyResult = null;
            if (obj)
            {
                _loc_2 = new IdentifyResult;
                _loc_2.layerId = obj.layerId;
                _loc_2.layerName = obj.layerName;
                _loc_2.value = obj.value;
                _loc_2.displayFieldName = obj.displayFieldName;
                _loc_2.feature = new Graphic();
                _loc_2.feature.attributes = obj.attributes;
                if (obj.geometry)
                {
                    _loc_2.feature.geometry = Geometry.fromJSON2(obj.geometry, null, obj.geometryType);
                }
            }
            return _loc_2;
        }// end function

    }
}
