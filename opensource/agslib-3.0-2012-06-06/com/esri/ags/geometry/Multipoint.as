package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;

    public class Multipoint extends Geometry
    {
        private var m_points:Array;
        private var m_extent:Extent;
        public var hasM:Boolean;
        public var hasZ:Boolean;

        public function Multipoint(points:Array = null, spatialReference:SpatialReference = null)
        {
            this.points = points;
            this.spatialReference = spatialReference;
            return;
        }// end function

        override public function get type() : String
        {
            return MULTIPOINT;
        }// end function

        public function get points() : Array
        {
            return this.m_points;
        }// end function

        public function set points(value:Array) : void
        {
            this.m_points = value;
            this.m_extent = null;
            return;
        }// end function

        public function addPoint(point:MapPoint) : void
        {
            if (this.m_points == null)
            {
                this.m_points = [];
            }
            this.m_points.push(point);
            this.m_extent = null;
            return;
        }// end function

        public function getPoint(index:int) : MapPoint
        {
            if (!this.points)
            {
                return null;
            }
            var _loc_2:* = this.points[index];
            if (_loc_2)
            {
                _loc_2.spatialReference = this.spatialReference;
            }
            return _loc_2;
        }// end function

        public function removePoint(index:int) : MapPoint
        {
            this.m_extent = null;
            var _loc_2:* = this.m_points ? (this.m_points.splice(index, 1)) : (null);
            return _loc_2 ? (new MapPoint(_loc_2[0].x, _loc_2[0].y, this.spatialReference)) : (null);
        }// end function

        public function setPoint(index:int, point:MapPoint) : void
        {
            if (this.points)
            {
                this.m_extent = null;
                this.points[index] = point;
            }
            return;
        }// end function

        override public function get extent() : Extent
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:MapPoint = null;
            if (this.m_points.length > 1)
            {
                if (this.m_extent == null)
                {
                    _loc_1 = Number.POSITIVE_INFINITY;
                    _loc_2 = Number.POSITIVE_INFINITY;
                    _loc_3 = Number.NEGATIVE_INFINITY;
                    _loc_4 = Number.NEGATIVE_INFINITY;
                    for each (_loc_5 in this.m_points)
                    {
                        
                        _loc_1 = Math.min(_loc_1, _loc_5.x);
                        _loc_2 = Math.min(_loc_2, _loc_5.y);
                        _loc_3 = Math.max(_loc_3, _loc_5.x);
                        _loc_4 = Math.max(_loc_4, _loc_5.y);
                    }
                    this.m_extent = new Extent();
                    this.m_extent.xmin = _loc_1;
                    this.m_extent.ymin = _loc_2;
                    this.m_extent.xmax = _loc_3;
                    this.m_extent.ymax = _loc_4;
                    this.m_extent.spatialReference = this.spatialReference;
                }
            }
            else
            {
                this.m_extent = null;
            }
            return this.m_extent;
        }// end function

        override function get defaultSymbol() : Symbol
        {
            return SimpleMarkerSymbol.defaultSymbol;
        }// end function

        override public function toJSON(key:String = null) : Object
        {
            var _loc_4:MapPoint = null;
            var _loc_5:Array = null;
            var _loc_2:Object = {};
            var _loc_3:Array = [];
            for each (_loc_4 in this.m_points)
            {
                
                _loc_5 = [_loc_4.x, _loc_4.y];
                if (this.hasZ)
                {
                    _loc_5.push(_loc_4.z);
                }
                if (this.hasM)
                {
                }
                if (!isNaN(_loc_4.m))
                {
                    _loc_5.push(_loc_4.m);
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
            _loc_2.points = _loc_3;
            if (spatialReference)
            {
                _loc_2.spatialReference = spatialReference.toJSON();
            }
            return _loc_2;
        }// end function

        public static function fromJSON(obj:Object) : Multipoint
        {
            var _loc_2:Multipoint = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:MapPoint = null;
            _loc_2 = new Multipoint;
            _loc_2.hasM = obj.hasM;
            _loc_2.hasZ = obj.hasZ;
            var _loc_3:Array = [];
            for each (_loc_4 in obj.points)
            {
                
                _loc_5 = _loc_4.length;
                _loc_6 = new MapPoint();
                _loc_6.x = _loc_4[0];
                _loc_6.y = _loc_4[1];
                if (_loc_2.hasZ)
                {
                }
                if (_loc_2.hasM)
                {
                    if (_loc_5 > 2)
                    {
                        _loc_6.z = _loc_4[2];
                    }
                    if (_loc_5 > 3)
                    {
                        _loc_6.m = _loc_4[3];
                    }
                }
                else
                {
                    if (_loc_2.hasM)
                    {
                    }
                    if (_loc_5 > 2)
                    {
                        _loc_6.m = _loc_4[2];
                    }
                    else
                    {
                        if (_loc_2.hasZ)
                        {
                        }
                        if (_loc_5 > 2)
                        {
                            _loc_6.z = _loc_4[2];
                        }
                    }
                }
                _loc_3.push(_loc_6);
            }
            _loc_2.points = _loc_3;
            _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
            return _loc_2;
        }// end function

    }
}
