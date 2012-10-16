package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.portal.supportClasses.*;
    import flash.events.*;
    import spark.components.supportClasses.*;

    public class PopUpMediaBrowser extends SkinnableComponent
    {
        public var nextButton:ButtonBase;
        public var previousButton:ButtonBase;
        private var _activeIndex:int;
        private var _activeIndexChanged:Boolean;
        public var attributes:Object;
        public var formattedAttributes:Object;
        public var popUpFieldInfos:Array;
        private var _popUpMediaInfos:Array;
        private var _popUpMediaInfosChanged:Boolean;
        private static var _skinParts:Object = {nextButton:true, previousButton:true};

        public function PopUpMediaBrowser()
        {
            return;
        }// end function

        public function get activeIndex() : int
        {
            return this._activeIndex;
        }// end function

        public function set activeIndex(value:int) : void
        {
            if (this._activeIndex !== value)
            {
                this._activeIndex = value;
                this._activeIndexChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("activeIndexChanged"));
            }
            return;
        }// end function

        public function get activeMediaInfo() : PopUpMediaInfo
        {
            if (this.popUpMediaInfos)
            {
            }
            return this.popUpMediaInfos.length > this.activeIndex ? (this.popUpMediaInfos[this.activeIndex]) : (null);
        }// end function

        public function get popUpMediaInfos() : Array
        {
            return this._popUpMediaInfos;
        }// end function

        public function set popUpMediaInfos(value:Array) : void
        {
            this._popUpMediaInfos = value;
            this._popUpMediaInfosChanged = true;
            invalidateProperties();
            this.activeIndex = 0;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this._popUpMediaInfosChanged)
            {
                this._popUpMediaInfosChanged = false;
                if (skin)
                {
                    skin.invalidateProperties();
                }
                if (this.nextButton)
                {
                    if (this.popUpMediaInfos)
                    {
                    }
                    if (this.popUpMediaInfos.length > 1)
                    {
                        this.nextButton.visible = true;
                    }
                    else
                    {
                        this.nextButton.visible = false;
                    }
                }
                if (this.previousButton)
                {
                    if (this.popUpMediaInfos)
                    {
                    }
                    if (this.popUpMediaInfos.length > 1)
                    {
                        this.previousButton.visible = true;
                    }
                    else
                    {
                        this.previousButton.visible = false;
                    }
                }
            }
            if (this._activeIndexChanged)
            {
                this._activeIndexChanged = false;
                if (skin)
                {
                    skin.invalidateProperties();
                }
            }
            return;
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance == this.nextButton)
            {
                this.nextButton.addEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
            }
            else if (instance == this.previousButton)
            {
                this.previousButton.addEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance == this.nextButton)
            {
                this.nextButton.removeEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
            }
            else if (instance == this.previousButton)
            {
                this.previousButton.removeEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
            }
            return;
        }// end function

        public function getChartData() : Array
        {
            var _loc_1:Array = null;
            var _loc_4:Number = NaN;
            var _loc_5:String = null;
            var _loc_6:Number = NaN;
            var _loc_7:Object = null;
            var _loc_8:PopUpFieldInfo = null;
            var _loc_2:* = this.attributes;
            var _loc_3:* = this.activeMediaInfo;
            if (_loc_2)
            {
            }
            if (_loc_3.chartFields)
            {
                _loc_1 = [];
                _loc_4 = _loc_2[_loc_3.chartNormalizationField];
                for each (_loc_5 in _loc_3.chartFields)
                {
                    
                    _loc_6 = _loc_2[_loc_5];
                    if (isFinite(_loc_6))
                    {
                        isFinite(_loc_6);
                    }
                    if (isFinite(_loc_4))
                    {
                        isFinite(_loc_4);
                    }
                    if (_loc_4 != 0)
                    {
                        _loc_6 = _loc_6 / _loc_4;
                    }
                    _loc_7 = {name:_loc_5, value:_loc_6};
                    _loc_8 = this.getPopUpFieldInfo(_loc_5);
                    if (_loc_8)
                    {
                    }
                    if (_loc_8.label)
                    {
                        _loc_7.name = _loc_8.label;
                    }
                    _loc_1.push(_loc_7);
                }
            }
            return _loc_1;
        }// end function

        private function getPopUpFieldInfo(fieldName:String) : PopUpFieldInfo
        {
            var _loc_2:PopUpFieldInfo = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:PopUpFieldInfo = null;
            var _loc_3:* = this.popUpFieldInfos;
            if (_loc_3)
            {
                _loc_4 = 0;
                _loc_5 = _loc_3.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_6 = _loc_3[_loc_4];
                    if (fieldName === _loc_6.fieldName)
                    {
                        _loc_2 = _loc_6;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_2;
        }// end function

        private function nextButton_clickHandler(event:MouseEvent) : void
        {
            if (this.popUpMediaInfos)
            {
            }
            if (this.popUpMediaInfos.length > 0)
            {
                if (this.activeIndex == (this.popUpMediaInfos.length - 1))
                {
                    this.activeIndex = 0;
                }
                else
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.activeIndex + 1;
                    _loc_2.activeIndex = _loc_3;
                }
            }
            return;
        }// end function

        private function previousButton_clickHandler(event:MouseEvent) : void
        {
            if (this.popUpMediaInfos)
            {
            }
            if (this.popUpMediaInfos.length > 0)
            {
                if (this.activeIndex == 0)
                {
                    this.activeIndex = this.popUpMediaInfos.length - 1;
                }
                else
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.activeIndex - 1;
                    _loc_2.activeIndex = _loc_3;
                }
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
