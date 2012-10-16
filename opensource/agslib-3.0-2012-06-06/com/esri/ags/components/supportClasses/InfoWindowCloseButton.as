package com.esri.ags.components.supportClasses
{
    import spark.components.*;

    public class InfoWindowCloseButton extends Button
    {
        private static var _skinParts:Object = {iconDisplay:false, labelDisplay:false};

        public function InfoWindowCloseButton()
        {
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
