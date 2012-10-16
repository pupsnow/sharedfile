package com.esri.ags.portal.supportClasses
{

    public class PopUpFieldInfo extends Object
    {
        public var fieldName:String;
        public var format:PopUpFieldFormat;
        public var label:String;
        public var visible:Boolean = false;

        public function PopUpFieldInfo()
        {
            return;
        }// end function

        static function toPopUpFieldInfo(obj:Object) : PopUpFieldInfo
        {
            var _loc_2:PopUpFieldInfo = null;
            if (obj)
            {
                _loc_2 = new PopUpFieldInfo;
                _loc_2.fieldName = obj.fieldName;
                _loc_2.format = PopUpFieldFormat.toPopUpFieldFormat(obj.format);
                _loc_2.label = obj.label;
                _loc_2.visible = obj.visible;
            }
            return _loc_2;
        }// end function

    }
}
