package com.esri.ags.tasks.supportClasses
{
    import mx.utils.*;

    public class LayoutOptions extends Object implements IJSONSupport
    {
        public var author:String;
        public var copyright:String;
        public var customTextElements:Object;
        public var legendOptions:LegendOptions;
        public var scaleBarOptions:ScaleBarOptions;
        public var title:String;

        public function LayoutOptions()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:Object = null;
            var _loc_2:Object = {};
            if (this.author)
            {
                _loc_2.authorText = this.author;
            }
            if (this.copyright)
            {
                _loc_2.copyrightText = this.copyright;
            }
            if (this.customTextElements)
            {
                _loc_3 = [];
                for (key in this.customTextElements)
                {
                    
                    _loc_4 = {};
                    _loc_4[key] = String(this.customTextElements[key]);
                    _loc_3.push(_loc_4);
                }
                _loc_2.customTextElements = _loc_3;
            }
            if (this.legendOptions)
            {
                _loc_2.legendOptions = this.legendOptions.toJSON();
            }
            if (this.scaleBarOptions)
            {
                _loc_2.scaleBarOptions = ObjectUtil.copy(this.scaleBarOptions);
            }
            if (this.title)
            {
                _loc_2.titleText = this.title;
            }
            return _loc_2;
        }// end function

    }
}
