package com.esri.ags.components.supportClasses
{

    final public class SingleField extends DoubleField
    {
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function SingleField(value:Object)
        {
            super(value);
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
