package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import mx.utils.*;

    public class OpenStreetMapLayer extends TiledMapServiceLayer
    {
        private var _fullExtent:Extent;
        private var _initialExtent:Extent;
        private var _spatialReference:SpatialReference;
        private var _tileInfo:TileInfo;
        private var _tileServers:Array;
        private var _tileServersChanged:Boolean;

        public function OpenStreetMapLayer()
        {
            this._fullExtent = new Extent(-2.00375e+007, -2.00375e+007, 2.00375e+007, 2.00375e+007, new SpatialReference(102100));
            this._initialExtent = new Extent(-2.00375e+007, -2.00375e+007, 2.00375e+007, 2.00375e+007, new SpatialReference(102100));
            this._spatialReference = new SpatialReference(102100);
            this._tileInfo = new TileInfo();
            this.buildTileInfo();
            this.tileServers = ["http://a.tile.openstreetmap.org/", "http://b.tile.openstreetmap.org/", "http://c.tile.openstreetmap.org/"];
            return;
        }// end function

        override public function get fullExtent() : Extent
        {
            return this._fullExtent;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._initialExtent;
        }// end function

        override public function get spatialReference() : SpatialReference
        {
            return this._spatialReference;
        }// end function

        override public function get tileInfo() : TileInfo
        {
            return this._tileInfo;
        }// end function

        public function get units() : String
        {
            return Units.METERS;
        }// end function

        public function get tileServers() : Array
        {
            return this._tileServers;
        }// end function

        public function set tileServers(value:Array) : void
        {
            if (ObjectUtil.compare(this._tileServers, value) != 0)
            {
                this._tileServers = value;
                this._tileServersChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this._tileServersChanged)
            {
                this._tileServersChanged = false;
                removeAllChildren();
                if (this.tileServers)
                {
                }
                if (this.tileServers.length > 0)
                {
                    setLoaded(true);
                    invalidateLayer();
                }
                else
                {
                    setLoaded(false);
                }
            }
            return;
        }// end function

        override protected function getTileURL(level:Number, row:Number, col:Number) : URLRequest
        {
            var _loc_4:* = this._tileServers[row % this._tileServers.length];
            _loc_4 = _loc_4 + (level + "/" + col + "/" + row + ".png");
            return new URLRequest(_loc_4);
        }// end function

        private function buildTileInfo() : void
        {
            this._tileInfo.dpi = 96;
            this._tileInfo.height = 256;
            this._tileInfo.width = 256;
            this._tileInfo.origin = new MapPoint(-2.00375e+007, 2.00375e+007);
            this._tileInfo.spatialReference = new SpatialReference(102100);
            this._tileInfo.lods = [new LOD(0, 156543, 5.91658e+008), new LOD(1, 78271.5, 2.95829e+008), new LOD(2, 39135.8, 1.47914e+008), new LOD(3, 19567.9, 7.39572e+007), new LOD(4, 9783.94, 3.69786e+007), new LOD(5, 4891.97, 1.84893e+007), new LOD(6, 2445.98, 9.24465e+006), new LOD(7, 1222.99, 4.62232e+006), new LOD(8, 611.496, 2.31116e+006), new LOD(9, 305.748, 1.15558e+006), new LOD(10, 152.874, 577791), new LOD(11, 76.437, 288895), new LOD(12, 38.2185, 144448), new LOD(13, 19.1093, 72223.8), new LOD(14, 9.55463, 36111.9), new LOD(15, 4.77731, 18056), new LOD(16, 2.38866, 9027.98), new LOD(17, 1.19433, 4513.99), new LOD(18, 0.597164, 2256.99)];
            return;
        }// end function

    }
}
