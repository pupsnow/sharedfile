package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class BufferParameters extends Object
    {
        public var geometries:Array;
        public var unionResults:Boolean = false;
        public var distances:Array;
        public var bufferSpatialReference:SpatialReference;
        public var outSpatialReference:SpatialReference;
        public var unit:Number;
        public var geodesic:Boolean = false;

        public function BufferParameters()
        {
            return;
        }// end function

    }
}
