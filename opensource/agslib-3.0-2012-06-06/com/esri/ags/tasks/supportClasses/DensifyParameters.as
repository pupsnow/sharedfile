package com.esri.ags.tasks.supportClasses
{

    public class DensifyParameters extends Object
    {
        public var geometries:Array;
        public var geodesic:Boolean = false;
        public var maxSegmentLength:Number;
        public var lengthUnit:Number;

        public function DensifyParameters()
        {
            return;
        }// end function

    }
}
