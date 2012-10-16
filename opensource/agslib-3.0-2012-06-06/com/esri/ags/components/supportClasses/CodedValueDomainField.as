package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.supportClasses.*;
    import mx.collections.*;
    import mx.events.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.events.*;

    final public class CodedValueDomainField extends DropDownList implements IDataRenderer
    {
        private var m_codedValueNotInDomain:CodedValue;
        private var m_data:Object;
        private static var _skinParts:Object = {scroller:false, dropDown:false, labelDisplay:false, openButton:true, dropIndicator:false, dataGroup:false};

        public function CodedValueDomainField(domain:CodedValueDomain, fieldValue:Object, editable:Boolean)
        {
            var _loc_5:CodedValue = null;
            var _loc_6:String = null;
            minWidth = 128;
            labelField = "name";
            enabled = editable;
            this.dataProvider = new ArrayList(domain.codedValues.concat());
            var _loc_4:Boolean = false;
            for each (_loc_5 in domain.codedValues)
            {
                
                if (_loc_5.code == fieldValue)
                {
                    _loc_4 = true;
                    break;
                }
            }
            if (!_loc_4)
            {
            }
            if (fieldValue)
            {
                _loc_6 = fieldValue.toString();
                this.m_codedValueNotInDomain = new CodedValue();
                this.m_codedValueNotInDomain.code = _loc_6;
                this.m_codedValueNotInDomain.name = _loc_6;
                dataProvider.addItemAt(this.m_codedValueNotInDomain, 0);
                addEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            }
            this.data = fieldValue;
            addEventListener(DropDownEvent.CLOSE, this.closeHandler);
            return;
        }// end function

        override public function set dataProvider(value:IList) : void
        {
            var _loc_4:int = 0;
            super.dataProvider = value;
            var _loc_2:* = dataProvider;
            var _loc_3:int = 0;
            _loc_4 = 1;
            while (_loc_4 < _loc_2.length)
            {
                
                if (_loc_2.getItemAt(_loc_4).name.length > _loc_2.getItemAt(_loc_3).name.length)
                {
                    _loc_3 = _loc_4;
                }
                _loc_4 = _loc_4 + 1;
            }
            typicalItem = _loc_2.getItemAt(_loc_3);
            return;
        }// end function

        public function get data() : Object
        {
            return this.m_data;
        }// end function

        public function set data(value:Object) : void
        {
            var _loc_2:IList = null;
            var _loc_3:int = 0;
            var _loc_4:CodedValue = null;
            if (this.m_data != value)
            {
                this.m_data = value;
                _loc_2 = dataProvider;
                if (_loc_2)
                {
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2.length)
                    {
                        
                        _loc_4 = _loc_2.getItemAt(_loc_3) as CodedValue;
                        if (_loc_4.code == value)
                        {
                            selectedIndex = _loc_3;
                            break;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                }
            }
            return;
        }// end function

        private function creationCompleteHandler(event:FlexEvent) : void
        {
            removeEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            var _loc_2:* = dataProvider as IList;
            if (_loc_2)
            {
            }
            if (_loc_2.length)
            {
            }
            if (this.m_codedValueNotInDomain === _loc_2.getItemAt(0))
            {
            }
            if (labelDisplay)
            {
                if (labelDisplay is TextBase)
                {
                    (labelDisplay as TextBase).setStyle("lineThrough", true);
                }
            }
            return;
        }// end function

        private function closeHandler(event:DropDownEvent) : void
        {
            var _loc_2:* = selectedItem as CodedValue;
            this.commitDataChange(_loc_2);
            if (labelDisplay is TextBase)
            {
                (labelDisplay as TextBase).setStyle("lineThrough", selectedItem === this.m_codedValueNotInDomain);
            }
            return;
        }// end function

        private function commitDataChange(codedValue:CodedValue) : void
        {
            var _loc_2:Object = null;
            var _loc_3:PropertyChangeEvent = null;
            if (codedValue)
            {
            }
            if (this.m_data != codedValue.code)
            {
                _loc_2 = codedValue.code;
            }
            else if (this.m_data)
            {
                _loc_2 = null;
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
