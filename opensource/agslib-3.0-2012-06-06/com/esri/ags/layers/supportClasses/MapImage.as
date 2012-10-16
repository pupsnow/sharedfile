package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.utils.*;

    public class MapImage extends EventDispatcher
    {
        private var _extent:Extent;
        private var _height:Number;
        private var _rotation:Number;
        private var _scale:Number;
        private var _source:Object;
        private var _width:Number;

        public function MapImage()
        {
            return;
        }// end function

        public function get extent() : Extent
        {
            return this._extent;
        }// end function

        public function set extent(value:Extent) : void
        {
            this._extent = value;
            dispatchEvent(new Event("extentChanged"));
            return;
        }// end function

        public function get height() : Number
        {
            return this._height;
        }// end function

        public function set height(value:Number) : void
        {
            if (this._height !== value)
            {
                this._height = value;
                dispatchEvent(new Event("heightChanged"));
            }
            return;
        }// end function

        public function get rotation() : Number
        {
            return this._rotation;
        }// end function

        public function set rotation(value:Number) : void
        {
            if (this._rotation !== value)
            {
                this._rotation = value;
                dispatchEvent(new Event("rotationChanged"));
            }
            return;
        }// end function

        public function get scale() : Number
        {
            return this._scale;
        }// end function

        public function set scale(value:Number) : void
        {
            if (this._scale !== value)
            {
                this._scale = value;
                dispatchEvent(new Event("scaleChanged"));
            }
            return;
        }// end function

        public function get source() : Object
        {
            return this._source;
        }// end function

        public function set source(value:Object) : void
        {
            if (this._source !== value)
            {
                this._source = value;
                dispatchEvent(new Event("sourceChanged"));
            }
            return;
        }// end function

        public function get width() : Number
        {
            return this._width;
        }// end function

        public function set width(value:Number) : void
        {
            if (this._width !== value)
            {
                this._width = value;
                dispatchEvent(new Event("widthChanged"));
            }
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        static function toMapImage(obj:Object) : MapImage
        {
            var _loc_2:MapImage = null;
            if (obj)
            {
                _loc_2 = new MapImage;
                _loc_2.source = obj.href;
                _loc_2.width = obj.width;
                _loc_2.height = obj.height;
                _loc_2.scale = obj.scale;
                _loc_2.extent = Extent.fromJSON(obj.extent);
            }
            return _loc_2;
        }// end function

    }
}
