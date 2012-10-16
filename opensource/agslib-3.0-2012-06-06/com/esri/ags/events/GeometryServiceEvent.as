package com.esri.ags.events
{
    import flash.events.*;

    public class GeometryServiceEvent extends Event
    {
        public var result:Object;
        public static const PROJECT_COMPLETE:String = "projectComplete";
        public static const SIMPLIFY_COMPLETE:String = "simplifyComplete";
        public static const BUFFER_COMPLETE:String = "bufferComplete";
        public static const LENGTHS_COMPLETE:String = "lengthsComplete";
        public static const AREAS_AND_LENGTHS_COMPLETE:String = "areasAndLengthsComplete";
        public static const LABEL_POINTS_COMPLETE:String = "labelPointsComplete";
        public static const RELATION_COMPLETE:String = "relationComplete";
        public static const DISTANCE_COMPLETE:String = "distanceComplete";
        public static const CONVEX_HULL_COMPLETE:String = "convexHullComplete";
        public static const OFFSET_COMPLETE:String = "offsetComplete";
        public static const GENERALIZE_COMPLETE:String = "generalizeComplete";
        public static const AUTO_COMPLETE_COMPLETE:String = "autoCompleteComplete";
        public static const TRIM_EXTEND_COMPLETE:String = "trimExtendComplete";
        public static const CUT_COMPLETE:String = "cutComplete";
        public static const DENSIFY_COMPLETE:String = "densifyComplete";
        public static const DIFFERENCE_COMPLETE:String = "differenceComplete";
        public static const INTERSECT_COMPLETE:String = "intersectComplete";
        public static const UNION_COMPLETE:String = "unionComplete";
        public static const RESHAPE_COMPLETE:String = "reshapeComplete";

        public function GeometryServiceEvent(type:String, result:Object = null)
        {
            super(type);
            this.result = result;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GeometryServiceEvent(type, this.result);
        }// end function

        override public function toString() : String
        {
            return formatToString("GeometryServiceEvent", "type", "result");
        }// end function

    }
}
