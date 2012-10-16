package com.esri.ags.utils
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;

    public class TileUtils extends Object
    {

        public function TileUtils()
        {
            return;
        }// end function

        public static function addFrameInfo(tileInfo:TileInfo, srInfo:SRInfo) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:LOD = null;
            if (tileInfo)
            {
            }
            if (!srInfo)
            {
                return;
            }
            var _loc_5:* = 2 * srInfo.origin[1];
            var _loc_6:* = srInfo.origin[0];
            var _loc_7:* = tileInfo.origin.x;
            var _loc_8:* = tileInfo.width;
            for each (_loc_10 in tileInfo.lods)
            {
                
                _loc_3 = Math.round(_loc_5 / _loc_10.resolution);
                _loc_4 = Math.ceil(_loc_3 / _loc_8);
                _loc_9 = Math.floor((_loc_6 - _loc_7) / (_loc_8 * _loc_10.resolution));
                if (!_loc_10.frameInfo)
                {
                    _loc_10.frameInfo = [_loc_4, _loc_9, _loc_9 + _loc_4 - 1, _loc_3];
                }
            }
            return;
        }// end function

        public static function getContainingTileCoords(ti:TileInfo, point:MapPoint, lod:LOD) : Coords
        {
            if (ti)
            {
            }
            if (point)
            {
            }
            if (!lod)
            {
                return null;
            }
            var _loc_4:* = ti.origin;
            var _loc_5:* = lod.resolution;
            var _loc_6:* = ti.width * _loc_5;
            var _loc_7:* = ti.height * _loc_5;
            var _loc_8:* = Math.floor((point.x - _loc_4.x) / _loc_6);
            var _loc_9:* = Math.floor((_loc_4.y - point.y) / _loc_7);
            return new Coords(_loc_9, _loc_8);
        }// end function

        public static function getCandidateTileInfo(map:Map, ti:TileInfo, extent:Extent) : CandidateTileInfo
        {
            if (map)
            {
            }
            if (ti)
            {
            }
            if (!extent)
            {
                return null;
            }
            var _loc_4:* = getClosestLodInfo(map, ti, extent);
            var _loc_5:* = getAdjustedExtent(map, extent, _loc_4);
            var _loc_6:* = getContainingTile(map, ti, new MapPoint(_loc_5.xmin, _loc_5.ymax, extent.spatialReference), _loc_4);
            return new CandidateTileInfo(_loc_6, _loc_4, _loc_5);
        }// end function

        private static function getClosestLodInfo(map:Map, ti:TileInfo, extent:Extent) : LOD
        {
            var _loc_13:LOD = null;
            var _loc_14:LOD = null;
            var _loc_15:Number = NaN;
            var _loc_4:* = ti.width;
            var _loc_5:* = ti.height;
            var _loc_6:* = map.width / _loc_4;
            var _loc_7:* = map.height / _loc_5;
            var _loc_8:* = extent.xmax - extent.xmin;
            var _loc_9:* = extent.ymax - extent.ymin;
            var _loc_10:Number = -1;
            var _loc_11:* = ti.lods;
            var _loc_12:* = Math.abs;
            var _loc_16:uint = 0;
            var _loc_17:* = _loc_11.length;
            while (_loc_16 < _loc_17)
            {
                
                _loc_14 = _loc_11[_loc_16];
                _loc_15 = _loc_8 > _loc_9 ? (TileUtils._loc_12(_loc_9 - _loc_7 * _loc_5 * _loc_14.resolution)) : (TileUtils._loc_12(_loc_8 - _loc_6 * _loc_4 * _loc_14.resolution));
                if (_loc_10 >= 0)
                {
                }
                if (_loc_15 <= _loc_10)
                {
                    _loc_13 = _loc_14;
                    _loc_10 = _loc_15;
                }
                else
                {
                    break;
                }
                _loc_16 = _loc_16 + 1;
            }
            return _loc_13;
        }// end function

        private static function getAdjustedExtent(map:Map, extent:Extent, lod:LOD) : Extent
        {
            var _loc_4:* = lod.resolution;
            var _loc_5:* = (extent.xmin + extent.xmax) / 2;
            var _loc_6:* = (extent.ymin + extent.ymax) / 2;
            var _loc_7:* = map.width / 2;
            var _loc_8:* = map.height / 2;
            return new Extent(_loc_5 - _loc_7 * _loc_4, _loc_6 - _loc_8 * _loc_4, _loc_5 + _loc_7 * _loc_4, _loc_6 + _loc_8 * _loc_4, extent.spatialReference);
        }// end function

        private static function getContainingTile(map:Map, ti:TileInfo, point:MapPoint, lod:LOD) : Tile
        {
            var _loc_5:* = lod.resolution;
            var _loc_6:* = ti.width;
            var _loc_7:* = ti.height;
            var _loc_8:* = ti.origin;
            var _loc_9:* = map.scrollRectX;
            var _loc_10:* = map.scrollRectY;
            var _loc_11:* = Math.floor;
            var _loc_12:* = _loc_6 * _loc_5;
            var _loc_13:* = _loc_7 * _loc_5;
            var _loc_14:* = TileUtils._loc_11((_loc_8.y - point.y) / _loc_13);
            var _loc_15:* = TileUtils._loc_11((point.x - _loc_8.x) / _loc_12);
            var _loc_16:* = _loc_8.x + _loc_15 * _loc_12;
            var _loc_17:* = _loc_8.y - _loc_14 * _loc_13;
            var _loc_18:* = TileUtils._loc_11(Math.abs((point.x - _loc_16) * _loc_6 / _loc_12)) - _loc_9;
            var _loc_19:* = TileUtils._loc_11(Math.abs((point.y - _loc_17) * _loc_7 / _loc_13)) - _loc_10;
            return new Tile(point, new Coords(_loc_14, _loc_15), new MapPoint(_loc_18, _loc_19));
        }// end function

    }
}
