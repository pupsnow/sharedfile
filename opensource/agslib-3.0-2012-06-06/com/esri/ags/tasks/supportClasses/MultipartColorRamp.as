package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.utils.*;

    public class MultipartColorRamp extends Object implements IColorRamp, IJSONSupport
    {
        public var colorRamps:Array;

        public function MultipartColorRamp()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:IColorRamp = null;
            var _loc_2:Object = {type:"multipart"};
            if (this.colorRamps)
            {
                _loc_3 = [];
                for each (_loc_4 in this.colorRamps)
                {
                    
                    if (_loc_4 is IJSONSupport)
                    {
                        _loc_3.push((_loc_4 as IJSONSupport).toJSON());
                    }
                }
            }
            _loc_2.colorRamps = _loc_3;
            return _loc_2;
        }// end function

    }
}
