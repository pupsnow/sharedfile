package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class TileInfo extends EventDispatcher
    {
        private var _99677dpi:Number;
        private var _1268779017format:String;
        private var _1221029593height:Number;
        private var _3327314lods:Array;
        private var _1008619738origin:MapPoint;
        private var _784017063spatialReference:SpatialReference;
        private var _113126854width:Number;

        public function TileInfo()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get dpi() : Number
        {
            return this._99677dpi;
        }// end function

        public function set dpi(value:Number) : void
        {
            arguments = this._99677dpi;
            if (arguments !== value)
            {
                this._99677dpi = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dpi", arguments, value));
                }
            }
            return;
        }// end function

        public function get format() : String
        {
            return this._1268779017format;
        }// end function

        public function set format(value:String) : void
        {
            arguments = this._1268779017format;
            if (arguments !== value)
            {
                this._1268779017format = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "format", arguments, value));
                }
            }
            return;
        }// end function

        public function get height() : Number
        {
            return this._1221029593height;
        }// end function

        public function set height(value:Number) : void
        {
            arguments = this._1221029593height;
            if (arguments !== value)
            {
                this._1221029593height = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "height", arguments, value));
                }
            }
            return;
        }// end function

        public function get lods() : Array
        {
            return this._3327314lods;
        }// end function

        public function set lods(value:Array) : void
        {
            arguments = this._3327314lods;
            if (arguments !== value)
            {
                this._3327314lods = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lods", arguments, value));
                }
            }
            return;
        }// end function

        public function get origin() : MapPoint
        {
            return this._1008619738origin;
        }// end function

        public function set origin(value:MapPoint) : void
        {
            arguments = this._1008619738origin;
            if (arguments !== value)
            {
                this._1008619738origin = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "origin", arguments, value));
                }
            }
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this._784017063spatialReference;
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            arguments = this._784017063spatialReference;
            if (arguments !== value)
            {
                this._784017063spatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "spatialReference", arguments, value));
                }
            }
            return;
        }// end function

        public function get width() : Number
        {
            return this._113126854width;
        }// end function

        public function set width(value:Number) : void
        {
            arguments = this._113126854width;
            if (arguments !== value)
            {
                this._113126854width = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "width", arguments, value));
                }
            }
            return;
        }// end function

        static function toTileInfo(obj:Object) : TileInfo
        {
            var _loc_2:TileInfo = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new TileInfo;
                _loc_2.dpi = obj.dpi;
                _loc_2.format = obj.format;
                _loc_2.height = obj.rows;
                if (obj.lods)
                {
                    _loc_2.lods = [];
                    for each (_loc_3 in obj.lods)
                    {
                        
                        _loc_2.lods.push(LOD.toLOD(_loc_3));
                    }
                }
                _loc_2.origin = MapPoint.fromJSON(obj.origin);
                _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
                _loc_2.width = obj.cols;
            }
            return _loc_2;
        }// end function

    }
}
