package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class ProjectParameters extends Object
    {
        public var geometries:Array;
        public var outSpatialReference:SpatialReference;
        public var datumTransform:DatumTransform;
        public var transformForward:Boolean = false;

        public function ProjectParameters()
        {
            return;
        }// end function

    }
}
