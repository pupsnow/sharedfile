package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class KMLScreenOverlay extends EventDispatcher
    {
        private var _id:Number;
        private var _name:String;
        private var _description:String;
        private var _snippet:String;
        private var _visible:Boolean;
        private var _href:String;
        private var _rotation:Number;
        var sizeX:Number;
        var sizeY:Number;
        var sizeXUnits:String;
        var sizeYUnits:String;
        var screenX:Number;
        var screenY:Number;
        var screenXUnits:String;
        var screenYUnits:String;
        var overlayX:Number;
        var overlayY:Number;
        var overlayXUnits:String;
        var overlayYUnits:String;
        var rotationX:Number;
        var rotationY:Number;
        var rotationXUnits:String;
        var rotationYUnits:String;

        public function KMLScreenOverlay()
        {
            return;
        }// end function

        public function get id() : Number
        {
            return this._id;
        }// end function

        public function set id(value:Number) : void
        {
            if (this._id !== value)
            {
                this._id = value;
                dispatchEvent(new Event("idChanged"));
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

        public function get description() : String
        {
            return this._description;
        }// end function

        public function set description(value:String) : void
        {
            if (this._description !== value)
            {
                this._description = value;
                dispatchEvent(new Event("descriptionChanged"));
            }
            return;
        }// end function

        public function get snippet() : String
        {
            return this._snippet;
        }// end function

        public function set snippet(value:String) : void
        {
            if (this._snippet !== value)
            {
                this._snippet = value;
                dispatchEvent(new Event("snippetChanged"));
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        public function set visible(value:Boolean) : void
        {
            if (this._visible !== value)
            {
                this._visible = value;
                dispatchEvent(new Event("visibleChanged"));
            }
            return;
        }// end function

        public function get href() : String
        {
            return this._href;
        }// end function

        public function set href(value:String) : void
        {
            if (this._href !== value)
            {
                this._href = value;
                dispatchEvent(new Event("hrefChanged"));
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

        static function toKMLScreenOverlay(obj:Object) : KMLScreenOverlay
        {
            var _loc_2:KMLScreenOverlay = null;
            if (obj)
            {
                _loc_2 = new KMLScreenOverlay;
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
                _loc_2.description = obj.description;
                _loc_2.snippet = obj.snippet;
                _loc_2.visible = obj.visibility;
                _loc_2.rotation = obj.rotation;
                _loc_2.href = obj.href;
                if (obj.rotationXY)
                {
                    _loc_2.rotationX = obj.rotationXY.x;
                    _loc_2.rotationY = obj.rotationXY.y;
                    _loc_2.rotationXUnits = obj.rotationXY.xunits;
                    _loc_2.rotationYUnits = obj.rotationXY.yunits;
                }
                if (obj.overlayXY)
                {
                    _loc_2.overlayX = obj.overlayXY.x;
                    _loc_2.overlayY = obj.overlayXY.y;
                    _loc_2.overlayXUnits = obj.overlayXY.xunits;
                    _loc_2.overlayYUnits = obj.overlayXY.yunits;
                }
                if (obj.size)
                {
                    _loc_2.sizeX = obj.size.x;
                    _loc_2.sizeY = obj.size.y;
                    _loc_2.sizeXUnits = obj.size.xunits;
                    _loc_2.sizeYUnits = obj.size.yunits;
                }
                if (obj.screenXY)
                {
                    _loc_2.screenX = obj.screenXY.x;
                    _loc_2.screenY = obj.screenXY.y;
                    _loc_2.screenXUnits = obj.screenXY.xunits;
                    _loc_2.screenYUnits = obj.screenXY.yunits;
                }
            }
            return _loc_2;
        }// end function

    }
}
