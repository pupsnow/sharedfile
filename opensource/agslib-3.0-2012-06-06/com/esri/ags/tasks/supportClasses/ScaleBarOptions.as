package com.esri.ags.tasks.supportClasses
{

    public class ScaleBarOptions extends Object
    {
        public var metricLabel:String;
        public var metricUnit:String;
        public var nonMetricLabel:String;
        public var nonMetricUnit:String;
        public static const FEET:String = "esriFeet";
        public static const KILOMETERS:String = "esriKilometers";
        public static const METERS:String = "esriMeters";
        public static const MILES:String = "esriMiles";
        public static const NAUTICAL_MILES:String = "esriNauticalMiles";
        public static const YARDS:String = "esriYards";

        public function ScaleBarOptions()
        {
            return;
        }// end function

    }
}
