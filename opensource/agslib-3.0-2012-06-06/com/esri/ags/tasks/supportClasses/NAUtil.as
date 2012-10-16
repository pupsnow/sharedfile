package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;

    public class NAUtil extends Object
    {
        private static const NONAME:String = "_NONAME_";

        public function NAUtil()
        {
            return;
        }// end function

        public static function getBarrierFeatures(barriers:Object) : Array
        {
            var _loc_2:FeatureSet = null;
            _loc_2 = FeatureSet(barriers);
            var _loc_3:* = _loc_2.features ? (_loc_2.features) : ([]);
            return _loc_3;
        }// end function

        public static function getBarrierLayer(barriers:Object) : Object
        {
            var _loc_2:DataLayer = null;
            _loc_2 = DataLayer(barriers);
            var _loc_3:Object = {type:"layer", layerName:_loc_2.name};
            if (_loc_2.geometry)
            {
                _loc_3.geometry = _loc_2.geometry;
                _loc_3.geometryType = _loc_2.geometry.type;
                _loc_3.spatialRel = _loc_2.spatialRelationship;
            }
            _loc_3.where = _loc_2.where;
            return _loc_3;
        }// end function

        public static function toRoute(route:Object) : Graphic
        {
            var _loc_2:* = Polyline.fromJSON(route.geometry);
            return new Graphic(_loc_2, null, route.attributes);
        }// end function

        public static function toDirectionLengthUnits(directionLengthUnit:String) : String
        {
            switch(directionLengthUnit)
            {
                case Units.FEET:
                {
                    return "esriNAUFeet";
                }
                case Units.METERS:
                {
                    return "esriNAUMeters";
                }
                case Units.KILOMETERS:
                {
                    return "esriNAUKilometers";
                }
                case Units.MILES:
                {
                    return "esriNAUMiles";
                }
                case Units.NAUTICAL_MILES:
                {
                    return "esriNAUNauticalMiles";
                }
                case Units.YARDS:
                {
                    return "esriNAUYards";
                }
                default:
                {
                    break;
                }
            }
            return "esriNAUUnknownUnits";
        }// end function

        public static function toDirectionsFeatureSet(direction:Object) : DirectionsFeatureSet
        {
            var _loc_3:DirectionsFeatureSet = null;
            var _loc_5:Object = null;
            var _loc_6:Graphic = null;
            var _loc_7:Polyline = null;
            var _loc_2:Array = [];
            _loc_3 = new DirectionsFeatureSet();
            _loc_3.extent = Extent.fromJSON(direction.summary.envelope);
            _loc_3.routeId = direction.routeId;
            _loc_3.routeName = direction.routeName;
            _loc_3.totalTime = direction.summary.totalTime;
            _loc_3.totalLength = direction.summary.totalLength;
            _loc_3.totalDriveTime = direction.summary.totalDriveTime;
            _loc_3.features = [];
            var _loc_4:* = _loc_3.extent.spatialReference;
            for each (_loc_5 in direction.features)
            {
                
                _loc_6 = new Graphic();
                _loc_7 = decompressGeometry(_loc_5.compressedGeometry, _loc_2, _loc_4);
                _loc_6.geometry = _loc_7;
                _loc_6.symbol = null;
                _loc_6.attributes = _loc_5.attributes;
                _loc_3.features.push(_loc_6);
            }
            _loc_3.mergedGeometry = new Polyline([_loc_2], _loc_4);
            return _loc_3;
        }// end function

        public static function decompressGeometry(compressedGeometry:String, points:Array, sr:SpatialReference) : Polyline
        {
            var _loc_13:int = 0;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:int = 0;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:MapPoint = null;
            var _loc_26:int = 0;
            var _loc_27:Number = NaN;
            var _loc_28:Number = NaN;
            var _loc_29:int = 0;
            var _loc_30:Number = NaN;
            var _loc_31:Number = NaN;
            var _loc_4:Array = [];
            var _loc_5:int = 0;
            var _loc_6:Object = {nIndexXYInt:0};
            var _loc_7:Object = {nIndexZInt:0};
            var _loc_8:Object = {nIndexMInt:0};
            var _loc_9:Number = 0;
            var _loc_10:Number = 0;
            var _loc_11:Number = 0;
            var _loc_12:* = extractInt(compressedGeometry, _loc_6);
            if (_loc_12 == 0)
            {
                _loc_18 = extractInt(compressedGeometry, _loc_6);
                _loc_5 = extractInt(compressedGeometry, _loc_6);
                _loc_9 = Number(extractInt(compressedGeometry, _loc_6));
            }
            else
            {
                _loc_9 = Number(_loc_12);
            }
            if (_loc_5 == 0)
            {
                _loc_13 = compressedGeometry.length;
            }
            else
            {
                _loc_13 = compressedGeometry.indexOf("|");
                if ((_loc_5 & 1) == 1)
                {
                    _loc_7.nIndexZInt = _loc_13 + 1;
                    _loc_10 = Number(extractInt(compressedGeometry, _loc_7));
                }
                if ((_loc_5 & 2) == 2)
                {
                    _loc_8.nIndexMInt = compressedGeometry.indexOf("|", _loc_7.nIndexZInt) + 1;
                    _loc_11 = Number(extractInt(compressedGeometry, _loc_8));
                }
            }
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:int = 0;
            var _loc_17:int = 0;
            while (_loc_6.nIndexXYInt != _loc_13)
            {
                
                _loc_19 = extractInt(compressedGeometry, _loc_6);
                _loc_20 = _loc_19 + _loc_14;
                _loc_14 = _loc_20;
                _loc_21 = _loc_20 / _loc_9;
                _loc_22 = extractInt(compressedGeometry, _loc_6);
                _loc_23 = _loc_22 + _loc_15;
                _loc_15 = _loc_23;
                _loc_24 = _loc_23 / _loc_9;
                _loc_25 = new MapPoint();
                _loc_25.x = _loc_21;
                _loc_25.y = _loc_24;
                if ((_loc_5 & 1) == 1)
                {
                    _loc_26 = extractInt(compressedGeometry, _loc_7);
                    _loc_27 = _loc_26 + _loc_16;
                    _loc_16 = _loc_27;
                    _loc_28 = _loc_27 / _loc_10;
                    _loc_25.z = _loc_28;
                }
                if ((_loc_5 & 2) == 2)
                {
                    _loc_29 = extractInt(compressedGeometry, _loc_8);
                    _loc_30 = _loc_29 + _loc_17;
                    _loc_17 = _loc_30;
                    _loc_31 = _loc_30 / _loc_11;
                    _loc_25.m = _loc_31;
                }
                points.push(_loc_25);
                _loc_4.push(_loc_25);
            }
            return new Polyline([_loc_4], sr);
        }// end function

        private static function extractInt(src:String, nStartPos:Object) : int
        {
            var _loc_7:String = null;
            var _loc_3:Boolean = false;
            var _loc_4:String = "";
            var _loc_5:* = nStartPos.nIndexXYInt;
            while (!_loc_3)
            {
                
                _loc_7 = src.charAt(_loc_5);
                if (_loc_7 != "+")
                {
                }
                if (_loc_7 != "-")
                {
                }
                if (_loc_7 == "|")
                {
                    if (_loc_5 != nStartPos.nIndexXYInt)
                    {
                        _loc_3 = true;
                        continue;
                    }
                }
                _loc_4 = _loc_4 + _loc_7;
                _loc_5 = _loc_5 + 1;
                if (_loc_5 == src.length)
                {
                    _loc_3 = true;
                }
            }
            var _loc_6:* = int.MIN_VALUE;
            if (_loc_4.length != 0)
            {
                _loc_6 = parseInt(_loc_4, 32);
                nStartPos.nIndexXYInt = _loc_5;
            }
            return _loc_6;
        }// end function

    }
}
