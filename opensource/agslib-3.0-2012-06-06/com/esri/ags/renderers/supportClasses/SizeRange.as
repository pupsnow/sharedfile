package com.esri.ags.renderers.supportClasses
{

    public class SizeRange extends Object
    {
        public var fromSize:Number;
        public var toSize:Number;

        public function SizeRange(fromSize:Number = 1, toSize:Number = 10)
        {
            this.fromSize = fromSize;
            this.toSize = toSize;
            return;
        }// end function

    }
}
