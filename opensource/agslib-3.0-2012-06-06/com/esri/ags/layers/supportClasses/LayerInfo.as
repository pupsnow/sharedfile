package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LayerInfo extends EventDispatcher
    {
        private var _2040924109defaultVisibility:Boolean;
        private var _41955764layerId:Number;
        private var _396505670maxScale:Number;
        private var _1379690984minScale:Number;
        private var _3373707name:String;
        private var _446442050parentLayerId:Number;
        private var _13884935subLayerIds:Array;

        public function LayerInfo()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get defaultVisibility() : Boolean
        {
            return this._2040924109defaultVisibility;
        }// end function

        public function set defaultVisibility(value:Boolean) : void
        {
            arguments = this._2040924109defaultVisibility;
            if (arguments !== value)
            {
                this._2040924109defaultVisibility = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultVisibility", arguments, value));
                }
            }
            return;
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

        public function get maxScale() : Number
        {
            return this._396505670maxScale;
        }// end function

        public function set maxScale(value:Number) : void
        {
            arguments = this._396505670maxScale;
            if (arguments !== value)
            {
                this._396505670maxScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxScale", arguments, value));
                }
            }
            return;
        }// end function

        public function get minScale() : Number
        {
            return this._1379690984minScale;
        }// end function

        public function set minScale(value:Number) : void
        {
            arguments = this._1379690984minScale;
            if (arguments !== value)
            {
                this._1379690984minScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minScale", arguments, value));
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

        public function get parentLayerId() : Number
        {
            return this._446442050parentLayerId;
        }// end function

        public function set parentLayerId(value:Number) : void
        {
            arguments = this._446442050parentLayerId;
            if (arguments !== value)
            {
                this._446442050parentLayerId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "parentLayerId", arguments, value));
                }
            }
            return;
        }// end function

        public function get subLayerIds() : Array
        {
            return this._13884935subLayerIds;
        }// end function

        public function set subLayerIds(value:Array) : void
        {
            arguments = this._13884935subLayerIds;
            if (arguments !== value)
            {
                this._13884935subLayerIds = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subLayerIds", arguments, value));
                }
            }
            return;
        }// end function

        static function toLayerInfo(obj:Object) : LayerInfo
        {
            var _loc_2:LayerInfo = null;
            if (obj)
            {
                _loc_2 = new LayerInfo;
                _loc_2.defaultVisibility = obj.defaultVisibility;
                _loc_2.layerId = obj.id;
                _loc_2.maxScale = obj.maxScale;
                _loc_2.minScale = obj.minScale;
                _loc_2.name = obj.name;
                _loc_2.parentLayerId = obj.parentLayerId;
                _loc_2.subLayerIds = obj.subLayerIds;
            }
            return _loc_2;
        }// end function

    }
}
