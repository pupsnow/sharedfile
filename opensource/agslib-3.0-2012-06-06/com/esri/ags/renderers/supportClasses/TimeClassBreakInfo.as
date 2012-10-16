package com.esri.ags.renderers.supportClasses
{

    public class TimeClassBreakInfo extends Object
    {
        public var minAge:Number = 0;
        public var maxAge:Number = 1.#INF;
        public var alpha:Number = NaN;
        public var color:Number = NaN;
        public var size:Number = NaN;

        public function TimeClassBreakInfo(minAge:Number = 0, maxAge:Number = 1.#INF, alpha:Number = NaN, color:Number = NaN, size:Number = NaN)
        {
            this.minAge = minAge;
            this.maxAge = maxAge;
            this.alpha = alpha;
            this.color = color;
            this.size = size;
            return;
        }// end function

    }
}
