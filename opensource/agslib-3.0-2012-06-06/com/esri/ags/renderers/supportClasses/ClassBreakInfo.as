package com.esri.ags.renderers.supportClasses
{
    import com.esri.ags.symbols.*;

    public class ClassBreakInfo extends Object
    {
        public var description:String;
        public var label:String;
        public var maxValue:Number = 1.#INF;
        public var minValue:Number = -1.#INF;
        public var symbol:Symbol;

        public function ClassBreakInfo(symbol:Symbol = null, minValue:Number = -1.#INF, maxValue:Number = 1.#INF)
        {
            this.symbol = symbol;
            this.maxValue = maxValue;
            this.minValue = minValue;
            return;
        }// end function

        static function toClassBreakInfo(obj:Object) : ClassBreakInfo
        {
            var _loc_2:ClassBreakInfo = null;
            if (obj)
            {
                _loc_2 = new ClassBreakInfo;
                _loc_2.description = obj.description;
                _loc_2.label = obj.label;
                if (obj.classMaxValue is Number)
                {
                    _loc_2.maxValue = obj.classMaxValue;
                }
                if (obj.classMinValue is Number)
                {
                    _loc_2.minValue = obj.classMinValue;
                }
                _loc_2.symbol = SymbolFactory.fromJSON(obj.symbol);
            }
            return _loc_2;
        }// end function

    }
}
