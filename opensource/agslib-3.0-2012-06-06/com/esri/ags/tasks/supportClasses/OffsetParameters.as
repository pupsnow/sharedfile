package com.esri.ags.tasks.supportClasses
{

    public class OffsetParameters extends Object
    {
        public var geometries:Array;
        public var offsetDistance:Number;
        public var offsetUnit:Number;
        public var bevelRatio:Number;
        public var offsetHow:String = "esriGeometryOffsetMitered";
        public static const OFFSET_MITERED:String = "esriGeometryOffsetMitered";
        public static const OFFSET_BEVELLED:String = "esriGeometryOffsetBevelled";
        public static const OFFSET_ROUNDED:String = "esriGeometryOffsetRounded";

        public function OffsetParameters()
        {
            return;
        }// end function

    }
}
