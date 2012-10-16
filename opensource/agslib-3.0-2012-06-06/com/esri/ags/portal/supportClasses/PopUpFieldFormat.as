package com.esri.ags.portal.supportClasses
{

    public class PopUpFieldFormat extends Object
    {
        public var dateFormat:String = "shortDateShortTime";
        public var precision:int = -1;
        public var useThousandsSeparator:Boolean = true;
        public var useUTC:Boolean = false;
        public static const SHORT_DATE:String = "shortDate";
        public static const LONG_MONTH_DAY_YEAR:String = "longMonthDayYear";
        public static const DAY_SHORT_MONTH_YEAR:String = "dayShortMonthYear";
        public static const LONG_DATE:String = "longDate";
        public static const SHORT_DATE_SHORT_TIME:String = "shortDateShortTime";
        public static const SHORT_DATE_SHORT_TIME24:String = "shortDateShortTime24";
        public static const LONG_MONTH_YEAR:String = "longMonthYear";
        public static const SHORT_MONTH_YEAR:String = "shortMonthYear";
        public static const YEAR:String = "year";

        public function PopUpFieldFormat()
        {
            return;
        }// end function

        static function toPopUpFieldFormat(obj:Object) : PopUpFieldFormat
        {
            var _loc_2:PopUpFieldFormat = null;
            if (obj)
            {
                _loc_2 = new PopUpFieldFormat;
                _loc_2.dateFormat = obj.dateFormat;
                _loc_2.precision = obj.places;
                _loc_2.useThousandsSeparator = obj.digitSeparator;
            }
            return _loc_2;
        }// end function

    }
}
