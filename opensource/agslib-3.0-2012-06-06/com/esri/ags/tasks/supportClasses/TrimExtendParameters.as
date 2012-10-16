package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.geometry.*;

    public class TrimExtendParameters extends Object
    {
        public var polylines:Array;
        public var trimExtendPolyline:Polyline;
        public var extendHow:Number = 0;
        public static const DEFAULT_CURVE_EXTENSION:Number = 0;
        public static const RELOCATE_ENDS:Number = 1;
        public static const KEEP_END_ATTRIBUTES:Number = 2;
        public static const NO_END_ATTRIBUTES:Number = 4;
        public static const NO_EXTEND_AT_FROM:Number = 8;
        public static const NO_EXTEND_AT_TO:Number = 16;

        public function TrimExtendParameters()
        {
            return;
        }// end function

    }
}
