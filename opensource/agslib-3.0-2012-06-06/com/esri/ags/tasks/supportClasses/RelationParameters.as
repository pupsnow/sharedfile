package com.esri.ags.tasks.supportClasses
{

    public class RelationParameters extends Object
    {
        public var geometries1:Array;
        public var geometries2:Array;
        public var spatialRelationship:String;
        public var comparisonString:String;
        public static const SPATIAL_REL_COINCIDENCE:String = "esriGeometryRelationLineCoincidence";
        public static const SPATIAL_REL_CROSS:String = "esriGeometryRelationCross";
        public static const SPATIAL_REL_DISJOINT:String = "esriGeometryRelationDisjoint";
        public static const SPATIAL_REL_IN:String = "esriGeometryRelationIn";
        public static const SPATIAL_REL_INTERIORINTERSECTION:String = "esriGeometryRelationInteriorIntersection";
        public static const SPATIAL_REL_INTERSECTION:String = "esriGeometryRelationIntersection";
        public static const SPATIAL_REL_LINETOUCH:String = "esriGeometryRelationLineTouch";
        public static const SPATIAL_REL_OVERLAP:String = "esriGeometryRelationOverlap";
        public static const SPATIAL_REL_POINTTOUCH:String = "esriGeometryRelationPointTouch";
        public static const SPATIAL_REL_RELATION:String = "esriGeometryRelationRelation";
        public static const SPATIAL_REL_TOUCH:String = "esriGeometryRelationTouch";
        public static const SPATIAL_REL_WITHIN:String = "esriGeometryRelationWithin";

        public function RelationParameters()
        {
            return;
        }// end function

    }
}
