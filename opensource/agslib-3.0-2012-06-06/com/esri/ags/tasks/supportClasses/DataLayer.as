package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.geometry.*;

    public class DataLayer extends Object
    {
        public var geometry:Geometry;
        public var spatialRelationship:String = "esriSpatialRelIntersects";
        public var where:String;
        public var name:String;
        public static const SPATIAL_REL_CONTAINS:String = "esriSpatialRelContains";
        public static const SPATIAL_REL_CROSSES:String = "esriSpatialRelCrosses";
        public static const SPATIAL_REL_ENVELOPEINTERSECTS:String = "esriSpatialRelEnvelopeIntersects";
        public static const SPATIAL_REL_INDEXINTERSECTS:String = "esriSpatialRelIndexIntersects";
        public static const SPATIAL_REL_INTERSECTS:String = "esriSpatialRelIntersects";
        public static const SPATIAL_REL_OVERLAPS:String = "esriSpatialRelOverlaps";
        public static const SPATIAL_REL_TOUCHES:String = "esriSpatialRelTouches";
        public static const SPATIAL_REL_WITHIN:String = "esriSpatialRelWithin";

        public function DataLayer()
        {
            return;
        }// end function

    }
}
