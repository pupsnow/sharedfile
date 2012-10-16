package com.esri.ags.tasks.supportClasses
{

    public class StatisticDefinition extends Object
    {
        public var onStatisticField:String;
        public var outStatisticFieldName:String;
        public var statisticType:String;
        public static const TYPE_AVERAGE:String = "avg";
        public static const TYPE_COUNT:String = "count";
        public static const TYPE_MINIMUM:String = "min";
        public static const TYPE_MAXIMUM:String = "max";
        public static const TYPE_STANDARD_DEVIATION:String = "stddev";
        public static const TYPE_SUMMATION:String = "sum";
        public static const TYPE_VARIANCE:String = "var";

        public function StatisticDefinition()
        {
            return;
        }// end function

    }
}
