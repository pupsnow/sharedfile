package com.esri.ags.utils
{
    import com.esri.ags.geometry.*;

    public class Tile extends Object
    {
        public var point:MapPoint;
        public var coords:Coords;
        public var offsets:MapPoint;

        public function Tile(point:MapPoint, coords:Coords, offsets:MapPoint)
        {
            this.point = point;
            this.coords = coords;
            this.offsets = offsets;
            return;
        }// end function

    }
}
