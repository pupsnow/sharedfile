package com.esri.ags.renderers.supportClasses
{

    public class ColorRange extends Object
    {
        public var fromColor:uint;
        public var toColor:uint;

        public function ColorRange(fromColor:uint = 0, toColor:uint = 16777215)
        {
            this.fromColor = fromColor;
            this.toColor = toColor;
            return;
        }// end function

    }
}
