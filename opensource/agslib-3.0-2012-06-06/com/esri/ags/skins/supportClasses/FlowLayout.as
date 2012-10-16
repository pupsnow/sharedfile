package com.esri.ags.skins.supportClasses
{
    import mx.core.*;
    import spark.components.supportClasses.*;
    import spark.layouts.supportClasses.*;

    public class FlowLayout extends LayoutBase
    {

        public function FlowLayout()
        {
            return;
        }// end function

        override public function updateDisplayList(containerWidth:Number, containerHeight:Number) : void
        {
            var _loc_8:ILayoutElement = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            var _loc_5:* = target;
            var _loc_6:* = _loc_5.numElements;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_5.getElementAt(_loc_7);
                if (_loc_8.includeInLayout)
                {
                    _loc_8.setLayoutBoundsSize(NaN, NaN);
                    _loc_9 = _loc_8.getLayoutBoundsWidth();
                    _loc_10 = _loc_8.getLayoutBoundsHeight();
                    _loc_11 = Math.max(280, containerWidth);
                    if (_loc_3 + _loc_9 > _loc_11)
                    {
                        _loc_3 = 0;
                        _loc_4 = _loc_4 + (_loc_10 + 5);
                    }
                    _loc_8.setLayoutBoundsPosition(_loc_3, _loc_4);
                    _loc_3 = _loc_3 + (_loc_9 + 5);
                }
                _loc_7 = _loc_7 + 1;
            }
            return;
        }// end function

    }
}
