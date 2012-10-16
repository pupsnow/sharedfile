package com.esri.ags.utils
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;

    public class CandidateTileInfo extends Object
    {
        public var tile:Tile;
        public var lod:LOD;
        public var extent:Extent;

        public function CandidateTileInfo(tile:Tile, lod:LOD, extent:Extent)
        {
            this.tile = tile;
            this.lod = lod;
            this.extent = extent;
            return;
        }// end function

    }
}
