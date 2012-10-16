package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;

    public class ClassBreaksDefinition extends Object implements IClassificationDefinition, IJSONSupport
    {
        public var baseSymbol:Symbol;
        public var breakCount:int;
        public var classificationField:String;
        public var classificationMethod:String;
        public var colorRamp:IColorRamp;
        public var normalizationField:String;
        public var normalizationType:String;
        public var standardDeviationInterval:Number;
        public static const CLASSIFY_EQUAL_INTERVAL:String = "esriClassifyEqualInterval";
        public static const CLASSIFY_GEOMETRICAL_INTERVAL:String = "esriClassifyGeometricalInterval";
        public static const CLASSIFY_NATURAL_BREAKS:String = "esriClassifyNaturalBreaks";
        public static const CLASSIFY_QUANTILE:String = "esriClassifyQuantile";
        public static const CLASSIFY_STANDARD_DEVIATION:String = "esriClassifyStandardDeviation";
        public static const INTERVAL_ONE:Number = 1;
        public static const INTERVAL_ONE_HALF:Number = 0.5;
        public static const INTERVAL_ONE_THIRD:Number = 0.33;
        public static const INTERVAL_ONE_QUARTER:Number = 0.25;
        public static const NORMALIZE_BY_FIELD:String = "esriNormalizeByField";
        public static const NORMALIZE_BY_LOG:String = "esriNormalizeByLog";
        public static const NORMALIZE_BY_PERCENT_OF_TOTAL:String = "esriNormalizeByPercentOfTotal";

        public function ClassBreaksDefinition()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"classBreaksDef", breakCount:this.breakCount, classificationField:this.classificationField, classificationMethod:this.classificationMethod, normalizationField:this.normalizationField, normalizationType:this.normalizationType};
            for (key in _loc_2)
            {
                
                if (_loc_2[key] == null)
                {
                    delete _loc_2[key];
                }
            }
            if (this.baseSymbol is IJSONSupport)
            {
                _loc_2.baseSymbol = (this.baseSymbol as IJSONSupport).toJSON();
            }
            if (this.colorRamp is IJSONSupport)
            {
                _loc_2.colorRamp = (this.colorRamp as IJSONSupport).toJSON();
            }
            if (!isNaN(this.standardDeviationInterval))
            {
                _loc_2.standardDeviationInterval = this.standardDeviationInterval;
            }
            return _loc_2;
        }// end function

    }
}
