package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;

    public class MapPoint extends Geometry
    {
        public var x:Number = 0;
        public var y:Number = 0;
        public var z:Number;
        public var m:Number;

        public function MapPoint(x:Number = 0, y:Number = 0, spatialReference:SpatialReference = null)
        {
            this.x = x;
            this.y = y;
            this.spatialReference = spatialReference;
            return;
        }// end function

        public function offset(dx:Number, dy:Number) : MapPoint
        {
            var _loc_3:* = new MapPoint(this.x + dx, this.y + dy, this.spatialReference);
            _loc_3.m = this.m;
            _loc_3.z = this.z;
            return _loc_3;
        }// end function

        public function update(x:Number, y:Number, spatialReference:SpatialReference = null) : void
        {
            this.x = x;
            this.y = y;
            if (spatialReference)
            {
                this.spatialReference = spatialReference;
            }
            return;
        }// end function

        public function normalize() : MapPoint
        {
            var _loc_4:SRInfo = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_1:* = this.x;
            var _loc_2:* = this.spatialReference;
            if (_loc_2)
            {
                _loc_4 = _loc_2.info;
                if (_loc_4)
                {
                    _loc_5 = _loc_4.valid[0];
                    _loc_6 = _loc_4.valid[1];
                    _loc_7 = _loc_4.world;
                    if (_loc_1 > _loc_6)
                    {
                        _loc_8 = Math.ceil(Math.abs(_loc_1 - _loc_6) / _loc_7);
                        _loc_1 = _loc_1 - _loc_8 * _loc_7;
                    }
                    else if (_loc_1 < _loc_5)
                    {
                        _loc_8 = Math.ceil(Math.abs(_loc_1 - _loc_5) / _loc_7);
                        _loc_1 = _loc_1 + _loc_8 * _loc_7;
                    }
                }
            }
            var _loc_3:* = new MapPoint(_loc_1, this.y, _loc_2);
            _loc_3.m = this.m;
            _loc_3.z = this.z;
            return _loc_3;
        }// end function

        override public function get type() : String
        {
            return MAPPOINT;
        }// end function

        override public function get extent() : Extent
        {
            return null;
        }// end function

        function equalsMapPoint(point:MapPoint) : Boolean
        {
            if (this.x == point.x)
            {
            }
            return this.y == point.y;
        }// end function

        override public function toString() : String
        {
            var _loc_1:* = "MapPoint[x=" + this.x + ",y=" + this.y;
            if (!isNaN(this.z))
            {
                _loc_1 = _loc_1 + (",z=" + this.z);
            }
            if (!isNaN(this.m))
            {
                _loc_1 = _loc_1 + (",m=" + this.m);
            }
            if (spatialReference)
            {
                _loc_1 = _loc_1 + ("," + spatialReference.toString());
            }
            _loc_1 = _loc_1 + "]";
            return _loc_1;
        }// end function

        override function get defaultSymbol() : Symbol
        {
            return SimpleMarkerSymbol.defaultSymbol;
        }// end function

        override public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {x:this.x, y:this.y};
            if (!isNaN(this.z))
            {
                _loc_2.z = this.z;
            }
            if (!isNaN(this.m))
            {
                _loc_2.m = this.m;
            }
            if (spatialReference)
            {
                _loc_2.spatialReference = spatialReference.toJSON();
            }
            return _loc_2;
        }// end function

        public static function fromJSON(obj:Object) : MapPoint
        {
            var _loc_2:MapPoint = null;
            if (obj)
            {
                _loc_2 = new MapPoint;
                _loc_2.x = obj.x;
                _loc_2.y = obj.y;
                _loc_2.z = obj.z;
                _loc_2.m = obj.m;
                _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
            }
            return _loc_2;
        }// end function

    }
}
