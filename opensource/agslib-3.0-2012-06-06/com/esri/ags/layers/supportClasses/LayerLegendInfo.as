package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LayerLegendInfo extends EventDispatcher
    {
        private var _layerId:String;
        private var _layerName:String;
        private var _layerType:String;
        private var _maxScale:Number;
        private var _minScale:Number;
        private var _layerLegendInfos:Array;
        private var _legendItemInfos:Array;
        private var _visible:Boolean;

        public function LayerLegendInfo()
        {
            return;
        }// end function

        public function get layerId() : String
        {
            return this._layerId;
        }// end function

        public function set layerId(value:String) : void
        {
            if (this._layerId !== value)
            {
                this._layerId = value;
                dispatchEvent(new Event("layerIdChanged"));
            }
            return;
        }// end function

        public function get layerName() : String
        {
            return this._layerName;
        }// end function

        public function set layerName(value:String) : void
        {
            if (this._layerName !== value)
            {
                this._layerName = value;
                dispatchEvent(new Event("layerNameChanged"));
            }
            return;
        }// end function

        public function get layerType() : String
        {
            return this._layerType;
        }// end function

        public function set layerType(value:String) : void
        {
            if (this._layerType !== value)
            {
                this._layerType = value;
                dispatchEvent(new Event("layerTypeChanged"));
            }
            return;
        }// end function

        public function get maxScale() : Number
        {
            return this._maxScale;
        }// end function

        public function set maxScale(value:Number) : void
        {
            if (this._maxScale !== value)
            {
                this._maxScale = value;
                dispatchEvent(new Event("maxScaleChanged"));
            }
            return;
        }// end function

        public function get minScale() : Number
        {
            return this._minScale;
        }// end function

        public function set minScale(value:Number) : void
        {
            if (this._minScale !== value)
            {
                this._minScale = value;
                dispatchEvent(new Event("minScaleChanged"));
            }
            return;
        }// end function

        public function get layerLegendInfos() : Array
        {
            return this._layerLegendInfos;
        }// end function

        public function set layerLegendInfos(value:Array) : void
        {
            this._layerLegendInfos = value;
            dispatchEvent(new Event("layerLegendInfosChanged"));
            return;
        }// end function

        public function get legendItemInfos() : Array
        {
            return this._legendItemInfos;
        }// end function

        public function set legendItemInfos(value:Array) : void
        {
            this._legendItemInfos = value;
            dispatchEvent(new Event("legendItemInfosChanged"));
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        private function set _466743410visible(value:Boolean) : void
        {
            this._visible = value;
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function set visible(value:Boolean) : void
        {
            arguments = this.visible;
            if (arguments !== value)
            {
                this._466743410visible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", arguments, value));
                }
            }
            return;
        }// end function

        static function toLayerLegendInfo(obj:Object) : LayerLegendInfo
        {
            var _loc_2:LayerLegendInfo = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new LayerLegendInfo;
                _loc_2.layerId = String(obj.layerId);
                _loc_2.layerName = obj.layerName;
                _loc_2.layerType = obj.layerType;
                _loc_2.maxScale = obj.maxScale;
                _loc_2.minScale = obj.minScale;
                if (obj.legend)
                {
                    _loc_2.legendItemInfos = [];
                    for each (_loc_3 in obj.legend)
                    {
                        
                        _loc_2.legendItemInfos.push(LegendItemInfo.toLegendItemInfo(_loc_3));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
