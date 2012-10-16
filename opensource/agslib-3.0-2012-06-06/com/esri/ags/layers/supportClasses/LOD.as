package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LOD extends EventDispatcher
    {
        private var _102865796level:Number;
        private var _1600030548resolution:Number;
        private var _109250890scale:Number;
        var startTileRow:Number;
        var startTileCol:Number;
        var endTileRow:Number;
        var endTileCol:Number;
        var frameInfo:Array;

        public function LOD(level:Number = NaN, resolution:Number = NaN, scale:Number = NaN)
        {
            this.level = level;
            this.resolution = resolution;
            this.scale = scale;
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get level() : Number
        {
            return this._102865796level;
        }// end function

        public function set level(value:Number) : void
        {
            arguments = this._102865796level;
            if (arguments !== value)
            {
                this._102865796level = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "level", arguments, value));
                }
            }
            return;
        }// end function

        public function get resolution() : Number
        {
            return this._1600030548resolution;
        }// end function

        public function set resolution(value:Number) : void
        {
            arguments = this._1600030548resolution;
            if (arguments !== value)
            {
                this._1600030548resolution = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "resolution", arguments, value));
                }
            }
            return;
        }// end function

        public function get scale() : Number
        {
            return this._109250890scale;
        }// end function

        public function set scale(value:Number) : void
        {
            arguments = this._109250890scale;
            if (arguments !== value)
            {
                this._109250890scale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scale", arguments, value));
                }
            }
            return;
        }// end function

        static function toLOD(obj:Object) : LOD
        {
            var _loc_2:LOD = null;
            if (obj)
            {
                _loc_2 = new LOD;
                _loc_2.level = obj.level;
                _loc_2.resolution = obj.resolution;
                _loc_2.scale = obj.scale;
            }
            return _loc_2;
        }// end function

    }
}
