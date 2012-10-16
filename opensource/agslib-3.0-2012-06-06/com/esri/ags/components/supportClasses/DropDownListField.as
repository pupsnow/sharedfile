package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.collections.*;
    import mx.events.*;
    import spark.components.*;

    public class DropDownListField extends DropDownList implements IDataRenderer
    {
        private var m_valueField:String = "value";
        private var m_data:Object;
        private static var _skinParts:Object = {scroller:false, dropDown:false, labelDisplay:false, openButton:true, dropIndicator:false, dataGroup:false};

        public function DropDownListField()
        {
            minWidth = 128;
            requireSelection = true;
            addEventListener(DropdownEvent.CLOSE, this.closeHandler);
            return;
        }// end function

        public function get valueField() : String
        {
            return this.m_valueField;
        }// end function

        public function set valueField(value:String) : void
        {
            if (this.m_valueField != value)
            {
                this.m_valueField = value;
                this.refreshSelectedItem();
            }
            return;
        }// end function

        public function get data() : Object
        {
            return this.m_data;
        }// end function

        public function set data(value:Object) : void
        {
            if (this.m_data != value)
            {
                this.m_data = value;
                this.refreshSelectedItem();
            }
            return;
        }// end function

        private function refreshSelectedItem() : void
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            var _loc_1:* = dataProvider;
            if (_loc_1)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1.length)
                {
                    
                    _loc_3 = _loc_1.getItemAt(_loc_2);
                    if (_loc_3 == this.m_data)
                    {
                        selectedIndex = _loc_2;
                        break;
                    }
                    if (_loc_3.hasOwnProperty(this.valueField))
                    {
                        _loc_3.hasOwnProperty(this.valueField);
                    }
                    if (_loc_3[this.valueField] === this.m_data)
                    {
                        selectedIndex = _loc_2;
                        break;
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        private function closeHandler(event:Event) : void
        {
            var _loc_3:PropertyChangeEvent = null;
            var _loc_2:Object = null;
            if (selectedItem is String)
            {
                _loc_2 = selectedItem;
            }
            else
            {
                _loc_2 = selectedItem[this.valueField];
            }
            if (this.m_data != _loc_2)
            {
                _loc_3 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.m_data, _loc_2, this);
                dispatchEvent(_loc_3);
                this.m_data = _loc_2;
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
