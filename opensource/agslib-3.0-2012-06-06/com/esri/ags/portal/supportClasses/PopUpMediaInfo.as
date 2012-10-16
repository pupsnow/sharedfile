package com.esri.ags.portal.supportClasses
{

    public class PopUpMediaInfo extends Object
    {
        public var caption:String;
        public var chartFields:Array;
        public var chartNormalizationField:String;
        public var chartSeriesStyleName:String;
        public var imageSourceURL:String;
        public var imageLinkURL:String;
        public var title:String;
        public var type:String;
        public static const IMAGE:String = "image";
        public static const PIE_CHART:String = "piechart";
        public static const BAR_CHART:String = "barchart";
        public static const COLUMN_CHART:String = "columnchart";
        public static const LINE_CHART:String = "linechart";

        public function PopUpMediaInfo()
        {
            return;
        }// end function

        static function toPopUpMediaInfo(obj:Object) : PopUpMediaInfo
        {
            var _loc_2:PopUpMediaInfo = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new PopUpMediaInfo;
                _loc_2.caption = obj.caption;
                _loc_2.title = obj.title;
                _loc_2.type = obj.type;
                if (obj.value)
                {
                    _loc_3 = obj.value;
                    _loc_2.chartFields = _loc_3.fields as Array;
                    _loc_2.chartNormalizationField = _loc_3.normalizeField;
                    _loc_2.imageLinkURL = _loc_3.linkURL;
                    _loc_2.imageSourceURL = _loc_3.sourceURL;
                }
            }
            return _loc_2;
        }// end function

    }
}
