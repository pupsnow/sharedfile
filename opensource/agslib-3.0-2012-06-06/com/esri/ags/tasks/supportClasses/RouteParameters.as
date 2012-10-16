package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class RouteParameters extends Object
    {
        public var accumulateAttributes:Array;
        public var attributeParameterValues:Array;
        public var pointBarriers:Object;
        public var polylineBarriers:Object;
        public var polygonBarriers:Object;
        public var directionsLanguage:String;
        public var directionsLengthUnits:String;
        public var directionsTimeAttribute:String;
        var m_findBestSequence:String;
        var m_ignoreInvalidLocations:String;
        public var impedanceAttribute:String;
        public var outputLines:String;
        public var outSpatialReference:SpatialReference;
        public var outputGeometryPrecision:Number;
        public var outputGeometryPrecisionUnits:String;
        var m_preserveFirstStop:String;
        var m_preserveLastStop:String;
        public var restrictionAttributes:Array;
        public var restrictUTurns:String;
        public var returnPointBarriers:Boolean = false;
        public var returnPolylineBarriers:Boolean = false;
        public var returnPolygonBarriers:Boolean = false;
        public var returnDirections:Boolean = false;
        public var returnRoutes:Boolean = true;
        public var returnStops:Boolean = false;
        public var returnZ:Boolean = false;
        public var startTime:Date;
        public var stops:Object;
        var m_useHierarchy:String;
        var m_useTimeWindows:String;
        public var doNotLocateOnRestrictedElements:Boolean = false;
        private static const _TRUE:String = true.toString();
        private static const _FALSE:String = false.toString();

        public function RouteParameters()
        {
            return;
        }// end function

        public function get findBestSequence() : Boolean
        {
            return this.m_findBestSequence === _TRUE;
        }// end function

        public function set findBestSequence(value:Boolean) : void
        {
            this.m_findBestSequence = value.toString();
            return;
        }// end function

        public function get ignoreInvalidLocations() : Boolean
        {
            return this.m_ignoreInvalidLocations === _TRUE;
        }// end function

        public function set ignoreInvalidLocations(value:Boolean) : void
        {
            this.m_ignoreInvalidLocations = value.toString();
            return;
        }// end function

        public function get preserveFirstStop() : Boolean
        {
            return this.m_preserveFirstStop === _TRUE;
        }// end function

        public function set preserveFirstStop(value:Boolean) : void
        {
            this.m_preserveFirstStop = value.toString();
            return;
        }// end function

        public function get preserveLastStop() : Boolean
        {
            return this.m_preserveLastStop === _TRUE;
        }// end function

        public function set preserveLastStop(value:Boolean) : void
        {
            this.m_preserveLastStop = value.toString();
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

        public function get useTimeWindows() : Boolean
        {
            return this.m_useTimeWindows === _TRUE;
        }// end function

        public function set useTimeWindows(value:Boolean) : void
        {
            this.m_useTimeWindows = value.toString();
            return;
        }// end function

    }
}
