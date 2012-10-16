package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.geometry.*;

    public class DistanceParameters extends Object
    {
        public var geometry1:Geometry;
        public var geometry2:Geometry;
        public var distanceUnit:Number;
        public var geodesic:Boolean = false;

        public function DistanceParameters()
        {
            return;
        }// end function

    }
}
