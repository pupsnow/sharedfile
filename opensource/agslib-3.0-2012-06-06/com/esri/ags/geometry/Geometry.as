package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import mx.utils.*;

    public class Geometry extends Object implements IJSONSupport
    {
        public var spatialReference:SpatialReference;
        public static const MAPPOINT:String = "esriGeometryPoint";
        public static const MULTIPOINT:String = "esriGeometryMultipoint";
        public static const POLYLINE:String = "esriGeometryPolyline";
        public static const POLYGON:String = "esriGeometryPolygon";
        public static const EXTENT:String = "esriGeometryEnvelope";

        public function Geometry()
        {
            return;
        }// end function

        public function get type() : String
        {
            throw new ESRIError(ESRIMessageCodes.USE_SUBCLASS, "Geometry::get type");
        }// end function

        public function get extent() : Extent
        {
            throw new ESRIError(ESRIMessageCodes.USE_SUBCLASS, "Geometry::get extent");
        }// end function

        function get defaultSymbol() : Symbol
        {
            throw new ESRIError(ESRIMessageCodes.USE_SUBCLASS, "Geometry::get defaultSymbol");
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function toJSON(key:String = null) : Object
        {
            throw new ESRIError(ESRIMessageCodes.USE_SUBCLASS, "Geometry::toJSON");
        }// end function

        public static function fromJSON(obj:Object) : Geometry
        {
            var _loc_2:Geometry = null;
            if (obj.x !== undefined)
            {
            }
            if (obj.y !== undefined)
            {
                _loc_2 = MapPoint.fromJSON(obj);
            }
            else if (obj.paths !== undefined)
            {
                _loc_2 = Polyline.fromJSON(obj);
            }
            else if (obj.rings !== undefined)
            {
                _loc_2 = Polygon.fromJSON(obj);
            }
            else if (obj.points !== undefined)
            {
                _loc_2 = Multipoint.fromJSON(obj);
            }
            else
            {
                if (obj.xmin !== undefined)
                {
                }
                if (obj.ymin !== undefined)
                {
                }
                if (obj.xmax !== undefined)
                {
                }
                if (obj.ymax !== undefined)
                {
                    _loc_2 = Extent.fromJSON(obj);
                }
            }
            return _loc_2;
        }// end function

        static function fromJSON2(obj:Object, spatialReference:SpatialReference, geometryType:String) : Geometry
        {
            var _loc_4:Geometry = null;
            if (!geometryType)
            {
                geometryType = obj.geometryType;
            }
            switch(geometryType)
            {
                case MAPPOINT:
                {
                    _loc_4 = MapPoint.fromJSON(obj);
                    break;
                }
                case POLYLINE:
                {
                    _loc_4 = Polyline.fromJSON(obj);
                    break;
                }
                case POLYGON:
                {
                    _loc_4 = Polygon.fromJSON(obj);
                    break;
                }
                case MULTIPOINT:
                {
                    _loc_4 = Multipoint.fromJSON(obj);
                    break;
                }
                case EXTENT:
                {
                    _loc_4 = Extent.fromJSON(obj);
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_4)
            {
            }
            if (!_loc_4.spatialReference)
            {
                _loc_4.spatialReference = spatialReference;
            }
            return _loc_4;
        }// end function

    }
}
