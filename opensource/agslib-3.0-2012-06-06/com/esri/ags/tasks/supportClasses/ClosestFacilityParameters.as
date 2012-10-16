package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class ClosestFacilityParameters extends Object
    {
        public var accumulateAttributes:Array;
        public var attributeParameterValues:Array;
        public var defaultCutoff:Number;
        public var defaultTargetFacilityCount:int;
        public var directionsLanguage:String;
        public var directionsLengthUnits:String;
        public var directionsTimeAttribute:String;
        public var doNotLocateOnRestrictedElements:Boolean = false;
        public var facilities:Object;
        public var impedanceAttribute:String;
        public var incidents:Object;
        public var outputLines:String;
        public var outSpatialReference:SpatialReference;
        public var outputGeometryPrecision:Number;
        public var outputGeometryPrecisionUnits:String;
        public var pointBarriers:Object;
        public var polylineBarriers:Object;
        public var polygonBarriers:Object;
        public var restrictionAttributes:Array;
        public var restrictUTurns:String;
        public var returnDirections:Boolean = false;
        public var returnFacilities:Boolean = false;
        public var returnIncidents:Boolean = false;
        public var returnPointBarriers:Boolean = false;
        public var returnPolylineBarriers:Boolean = false;
        public var returnPolygonBarriers:Boolean = false;
        public var returnRoutes:Boolean = true;
        public var returnZ:Boolean = false;
        public var travelDirection:String;
        public var timeOfDay:Number;
        public var timeOfDayUsage:String;
        var m_useHierarchy:String;
        private static const _TRUE:String = true.toString();
        private static const _FALSE:String = false.toString();

        public function ClosestFacilityParameters()
        {
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
