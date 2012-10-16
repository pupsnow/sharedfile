package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.symbols.*;

    public class AlgorithmicColorRamp extends Object implements IColorRamp, IJSONSupport
    {
        public var algorithm:String = "esriHSVAlgorithm";
        public var fromAlpha:Number = 1;
        public var fromColor:uint;
        public var toAlpha:Number = 1;
        public var toColor:uint;
        public static const HSV_ALGORITHM:String = "esriHSVAlgorithm";
        public static const CIE_LAB_ALGORITHM:String = "esriCIELabAlgorithm";
        public static const LAB_LCH_ALGORITHM:String = "esriLabLChAlgorithm";

        public function AlgorithmicColorRamp()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"algorithmic"};
            _loc_2.algorithm = this.algorithm;
            _loc_2.fromColor = SymbolFactory.colorAndAlphaToRGBA(this.fromColor, this.fromAlpha);
            _loc_2.toColor = SymbolFactory.colorAndAlphaToRGBA(this.toColor, this.toAlpha);
            return _loc_2;
        }// end function

    }
}
