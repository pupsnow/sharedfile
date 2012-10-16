package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.collections.*;
    import mx.events.*;
    import spark.components.*;

    public class ButtonBarField extends ButtonBar implements IDataRenderer
    {
        private var m_valueField:String = "value";
        private var m_data:Object;
        private var m_dataChanged:Boolean = false;
        private static var _skinParts:Object = {lastButton:false, firstButton:false, middleButton:true, dataGroup:false};

        public function ButtonBarField()
        {
            requireSelection = true;
            addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        public function get valueField() : String
        {
            return this.m_valueField;
        }// end function

        private function set _2019909129valueField(value:String) : void
        {
            if (this.m_valueField != value)
            {
                this.m_valueField = value;
                this.m_dataChanged = true;
                invalidateProperties();
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
                this.m_dataChanged = true;
                invalidateProperties();
                dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:IList = null;
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            super.commitProperties();
            if (this.m_dataChanged)
            {
                this.m_dataChanged = false;
                _loc_1 = dataProvider;
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
            }
            return;
        }// end function

        private function commitNewDataValue(newValue:Object) : void
        {
            var _loc_2:PropertyChangeEvent = null;
            if (this.data != newValue)
            {
                _loc_2 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.data, newValue, this);
                dispatchEvent(_loc_2);
                this.m_data = newValue;
            }
            return;
        }// end function

        private function clickHandler(event:Event) : void
        {
            var _loc_2:Object = null;
            if (selectedItem is String)
            {
                _loc_2 = selectedItem;
            }
            else if (selectedItem)
            {
                _loc_2 = selectedItem[this.valueField];
            }
            else
            {
                _loc_2 = null;
            }
            this.commitNewDataValue(_loc_2);
            return;
        }// end function

        public function set valueField(value:String) : void
        {
            arguments = this.valueField;
            if (arguments !== value)
            {
                this._2019909129valueField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "valueField", arguments, value));
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
