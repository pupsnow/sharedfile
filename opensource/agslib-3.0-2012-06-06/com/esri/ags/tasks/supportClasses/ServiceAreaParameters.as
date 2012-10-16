package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class ServiceAreaParameters extends Object
    {
        public var accumulateAttributes:Array;
        public var attributeParameterValues:Array;
        public var defaultBreaks:Array;
        public var doNotLocateOnRestrictedElements:Boolean = false;
        public var excludeSourcesFromPolygons:Array;
        public var facilities:Object;
        public var impedanceAttribute:String;
        var m_mergeSimilarPolygonRanges:String;
        public var outputLines:String;
        public var outputPolygons:String;
        public var outSpatialReference:SpatialReference;
        public var outputGeometryPrecision:Number;
        public var outputGeometryPrecisionUnits:String;
        var m_overlapLines:String;
        var m_overlapPolygons:String;
        public var pointBarriers:Object;
        public var polylineBarriers:Object;
        public var polygonBarriers:Object;
        public var restrictionAttributes:Array;
        public var restrictUTurns:String;
        public var returnFacilities:Boolean = false;
        public var returnPointBarriers:Boolean = false;
        public var returnPolylineBarriers:Boolean = false;
        public var returnPolygonBarriers:Boolean = false;
        public var returnZ:Boolean = false;
        var m_splitLinesAtBreaks:String;
        var m_splitPolygonsAtBreaks:String;
        public var timeOfDay:Number;
        public var travelDirection:String;
        var m_trimOuterPolygon:String;
        public var trimPolygonDistance:Number;
        public var trimPolygonDistanceUnits:String;
        var m_useHierarchy:String;
        private static const _TRUE:String = true.toString();
        private static const _FALSE:String = false.toString();

        public function ServiceAreaParameters()
        {
            return;
        }// end function

        public function get mergeSimilarPolygonRanges() : Boolean
        {
            return this.m_mergeSimilarPolygonRanges === _TRUE;
        }// end function

        public function set mergeSimilarPolygonRanges(value:Boolean) : void
        {
            this.m_mergeSimilarPolygonRanges = value.toString();
            return;
        }// end function

        public function get overlapLines() : Boolean
        {
            return this.m_overlapLines === _TRUE;
        }// end function

        public function set overlapLines(value:Boolean) : void
        {
            this.m_overlapLines = value.toString();
            return;
        }// end function

        public function get overlapPolygons() : Boolean
        {
            return this.m_overlapPolygons === _TRUE;
        }// end function

        public function set overlapPolygons(value:Boolean) : void
        {
            this.m_overlapPolygons = value.toString();
            return;
        }// end function

        public function get splitLinesAtBreaks() : Boolean
        {
            return this.m_splitLinesAtBreaks === _TRUE;
        }// end function

        public function set splitLinesAtBreaks(value:Boolean) : void
        {
            this.m_splitLinesAtBreaks = value.toString();
            return;
        }// end function

        public function get splitPolygonsAtBreaks() : Boolean
        {
            return this.m_splitPolygonsAtBreaks === _TRUE;
        }// end function

        public function set splitPolygonsAtBreaks(value:Boolean) : void
        {
            this.m_splitPolygonsAtBreaks = value.toString();
            return;
        }// end function

        public function get trimOuterPolygon() : Boolean
        {
            return this.m_trimOuterPolygon === _TRUE;
        }// end function

        public function set trimOuterPolygon(value:Boolean) : void
        {
            this.m_trimOuterPolygon = value.toString();
            return;
        }// end function

        public function get useHierarchy() : Boolean
        {
            return this.m_useHierarchy === _TRUE;
        }// end function

        public function set useHierarchy(value:Boolean) : void
        {
            this.m_useHierarchy = value.toString();
            return;
        }// end function

    }
}
