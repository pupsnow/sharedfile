package com.esri.ags.components.supportClasses
{

    final public class SmallIntegerField extends IntegerField
    {
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function SmallIntegerField(value:Object)
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
