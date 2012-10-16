package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class KMLFeatureInfo extends EventDispatcher
    {
        private var _3355id:Number;
        private var _3575610type:Number;
        public static const FOLDER:Number = 0;
        public static const GROUND_OVERLAY:Number = 1;
        public static const LINE:Number = 2;
        public static const NETWORK_LINK:Number = 3;
        public static const POINT:Number = 4;
        public static const POLYGON:Number = 5;
        public static const SCREEN_OVERLAY:Number = 6;

        public function KMLFeatureInfo()
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

        public function get type() : Number
        {
            return this._3575610type;
        }// end function

        public function set type(value:Number) : void
        {
            arguments = this._3575610type;
            if (arguments !== value)
            {
                this._3575610type = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", arguments, value));
                }
            }
            return;
        }// end function

        static function toKMLFeatureInfo(obj:Object) : KMLFeatureInfo
        {
            var _loc_2:KMLFeatureInfo = null;
            if (obj)
            {
                _loc_2 = new KMLFeatureInfo;
                _loc_2.id = obj.id;
                switch(obj.type)
                {
                    case "Folder":
                    {
                        _loc_2.type = KMLFeatureInfo.FOLDER;
                        break;
                    }
                    case "GroundOverlay":
                    {
                        _loc_2.type = KMLFeatureInfo.GROUND_OVERLAY;
                        break;
                    }
                    case "ScreenOverlay":
                    {
                        _loc_2.type = KMLFeatureInfo.SCREEN_OVERLAY;
                        break;
                    }
                    case "NetworkLink":
                    {
                        _loc_2.type = KMLFeatureInfo.NETWORK_LINK;
                        break;
                    }
                    case "esriGeometryPoint":
                    {
                        _loc_2.type = KMLFeatureInfo.POINT;
                        break;
                    }
                    case "esriGeometryPolyline":
                    {
                        _loc_2.type = KMLFeatureInfo.LINE;
                        break;
                    }
                    case "esriGeometryPolygon":
                    {
                        _loc_2.type = KMLFeatureInfo.POLYGON;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
