package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.geometry.*;

    public class Cluster extends Object
    {
        public var center:MapPoint;
        public var weight:Number;
        public var graphics:Array;

        public function Cluster(center:MapPoint = null, weight:Number = 0, graphics:Array = null)
        {
            this.center = center;
            this.weight = weight;
            this.graphics = graphics;
            return;
        }// end function

    }
}
