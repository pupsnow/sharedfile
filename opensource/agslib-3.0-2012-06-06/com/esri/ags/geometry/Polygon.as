package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;

    public class Polygon extends Geometry
    {
        private var _rings:Array;
        private var _extent:Extent;
        private var _parts:Array;
        public var hasM:Boolean;
        public var hasZ:Boolean;

        public function Polygon(rings:Array = null, spatialReference:SpatialReference = null)
        {
            this.rings = rings;
            this.spatialReference = spatialReference;
            return;
        }// end function

        override function get defaultSymbol() : Symbol
        {
            return SimpleFillSymbol.defaultSymbol;
        }// end function

        override public function get type() : String
        {
            return POLYGON;
        }// end function

        override public function get extent() : Extent
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Array = null;
            var _loc_6:MapPoint = null;
            if (this._extent == null)
            {
                _loc_1 = Number.POSITIVE_INFINITY;
                _loc_2 = Number.POSITIVE_INFINITY;
                _loc_3 = Number.NEGATIVE_INFINITY;
                _loc_4 = Number.NEGATIVE_INFINITY;
                for each (_loc_5 in this._rings)
                {
                    
                    for each (_loc_6 in _loc_5)
                    {
                        
                        _loc_1 = Math.min(_loc_1, _loc_6.x);
                        _loc_2 = Math.min(_loc_2, _loc_6.y);
                        _loc_3 = Math.max(_loc_3, _loc_6.x);
                        _loc_4 = Math.max(_loc_4, _loc_6.y);
                    }
                }
                this._extent = new Extent();
                this._extent.xmin = _loc_1;
                this._extent.ymin = _loc_2;
                this._extent.xmax = _loc_3;
                this._extent.ymax = _loc_4;
                this._extent.spatialReference = this.spatialReference;
            }
            return this._extent;
        }// end function

        public function get rings() : Array
        {
            return this._rings;
        }// end function

        public function set rings(value:Array) : void
        {
            this._rings = value;
            this._extent = null;
            this._parts = null;
            return;
        }// end function

        override public function toJSON(key:String = null) : Object
        {
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:MapPoint = null;
            var _loc_7:Array = null;
            var _loc_2:Object = {};
            var _loc_3:Array = [];
            for each (_loc_4 in this._rings)
            {
                
                _loc_5 = [];
                for each (_loc_6 in _loc_4)
                {
                    
                    _loc_7 = [_loc_6.x, _loc_6.y];
                    if (this.hasZ)
                    {
                        _loc_7.push(_loc_6.z);
                    }
                    if (this.hasM)
                    {
                    }
                    if (!isNaN(_loc_6.m))
                    {
                        _loc_7.push(_loc_6.m);
                    }
                    _loc_5.push(_loc_7);
                }
                _loc_3.push(_loc_5);
            }
            if (this.hasM)
            {
                _loc_2.hasM = true;
            }
            if (this.hasZ)
            {
                _loc_2.hasZ = true;
            }
            _loc_2.rings = _loc_3;
            if (spatialReference)
            {
                _loc_2.spatialReference = spatialReference.toJSON();
            }
            return _loc_2;
        }// end function

        public function addRing(points:Array) : void
        {
            if (!this._rings)
            {
                this._rings = [];
            }
            this._rings.push(points);
            this._extent = null;
            this._parts = null;
            return;
        }// end function

        public function contains(point:MapPoint) : Boolean
        {
            var _loc_2:Number = NaN;
            var _loc_3:MapPoint = null;
            var _loc_4:MapPoint = null;
            var _loc_6:Array = null;
            var _loc_7:Number = NaN;
            var _loc_5:Boolean = false;
            for each (_loc_6 in this.rings)
            {
                
                _loc_2 = 0;
                _loc_7 = 0;
                while (_loc_7 < _loc_6.length)
                {
                    
                    _loc_2 = _loc_2 + 1;
                    if (_loc_2 == _loc_6.length)
                    {
                        _loc_2 = 0;
                    }
                    _loc_3 = _loc_6[_loc_7];
                    _loc_4 = _loc_6[_loc_2];
                    if (_loc_3.y < point.y)
                    {
                    }
                    if (_loc_4.y < point.y)
                    {
                        if (_loc_4.y < point.y)
                        {
                        }
                    }
                    if (_loc_3.y >= point.y)
                    {
                    }
                    if (_loc_3.x + (point.y - _loc_3.y) / (_loc_4.y - _loc_3.y) * (_loc_4.x - _loc_3.x) < point.x)
                    {
                        _loc_5 = !_loc_5;
                    }
                    _loc_7 = _loc_7 + 1;
                }
            }
            return _loc_5;
        }// end function

        public function getPoint(ringIndex:int, pointIndex:int) : MapPoint
        {
            var _loc_3:MapPoint = null;
            if (!this.rings)
            {
                return null;
            }
            var _loc_4:* = this.rings[ringIndex];
            if (_loc_4)
            {
                _loc_3 = _loc_4[pointIndex];
                if (_loc_3)
                {
                    _loc_3.spatialReference = this.spatialReference;
                }
            }
            return _loc_3;
        }// end function

        public function insertPoint(ringIndex:int, pointIndex:int, point:MapPoint) : void
        {
            var _loc_4:Array = null;
            if (this.rings)
            {
                _loc_4 = this.rings[ringIndex];
                if (_loc_4)
                {
                    this._extent = null;
                    this._parts = null;
                    _loc_4.splice(pointIndex, 0, point);
                }
            }
            return;
        }// end function

        public function removePoint(ringIndex:int, pointIndex:int) : MapPoint
        {
            if (!this.rings)
            {
                return null;
            }
            var _loc_3:* = this.rings[ringIndex];
            this._extent = null;
            this._parts = null;
            var _loc_4:* = _loc_3 ? (_loc_3.splice(pointIndex, 1)) : (null);
            return _loc_4 ? (new MapPoint(_loc_4[0].x, _loc_4[0].y, this.spatialReference)) : (null);
        }// end function

        public function removeRing(index:int) : Array
        {
            this._extent = null;
            this._parts = null;
            return this._rings.splice(index, 1);
        }// end function

        public function setPoint(ringIndex:int, pointIndex:int, point:MapPoint) : void
        {
            var _loc_4:Array = null;
            if (this.rings)
            {
                _loc_4 = this.rings[ringIndex];
                if (_loc_4)
                {
                    this._extent = null;
                    this._parts = null;
                    _loc_4[pointIndex] = point;
                }
            }
            return;
        }// end function

        function get parts() : Array
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:MapPoint = null;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:Array = null;
            if (!this._parts)
            {
                this._parts = [];
                for each (_loc_8 in this.rings)
                {
                    
                    if (_loc_8.length > 2)
                    {
                        _loc_5 = _loc_8[0] as MapPoint;
                        var _loc_11:* = _loc_5.x;
                        _loc_2 = _loc_5.x;
                        _loc_1 = _loc_11;
                        var _loc_11:* = _loc_5.y;
                        _loc_4 = _loc_5.y;
                        _loc_3 = _loc_11;
                        _loc_6 = 1;
                        while (_loc_6 < _loc_8.length)
                        {
                            
                            _loc_5 = _loc_8[_loc_6] as MapPoint;
                            _loc_1 = Math.min(_loc_1, _loc_5.x);
                            _loc_3 = Math.min(_loc_3, _loc_5.y);
                            _loc_2 = Math.max(_loc_2, _loc_5.x);
                            _loc_4 = Math.max(_loc_4, _loc_5.y);
                            _loc_6 = _loc_6 + 1;
                        }
                        this._parts.push(new Extent(_loc_1, _loc_3, _loc_2, _loc_4, spatialReference));
                    }
                }
            }
            return this._parts;
        }// end function

        public static function fromJSON(obj:Object) : Polygon
        {
            var _loc_2:Polygon = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:MapPoint = null;
            _loc_2 = new Polygon;
            _loc_2.hasM = obj.hasM;
            _loc_2.hasZ = obj.hasZ;
            var _loc_3:Array = [];
            for each (_loc_4 in obj.rings)
            {
                
                _loc_5 = [];
                for each (_loc_6 in _loc_4)
                {
                    
                    _loc_7 = _loc_6.length;
                    _loc_8 = new MapPoint();
                    _loc_8.x = _loc_6[0];
                    _loc_8.y = _loc_6[1];
                    if (_loc_2.hasZ)
                    {
                    }
                    if (_loc_2.hasM)
                    {
                        if (_loc_7 > 2)
                        {
                            _loc_8.z = _loc_6[2];
                        }
                        if (_loc_7 > 3)
                        {
                            _loc_8.m = _loc_6[3];
                        }
                    }
                    else
                    {
                        if (_loc_2.hasM)
                        {
                        }
                        if (_loc_7 > 2)
                        {
                            _loc_8.m = _loc_6[2];
                        }
                        else
                        {
                            if (_loc_2.hasZ)
                            {
                            }
                            if (_loc_7 > 2)
                            {
                                _loc_8.z = _loc_6[2];
                            }
                        }
                    }
                    _loc_5.push(_loc_8);
                }
                _loc_3.push(_loc_5);
            }
            _loc_2.rings = _loc_3;
            _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
            return _loc_2;
        }// end function

    }
}
