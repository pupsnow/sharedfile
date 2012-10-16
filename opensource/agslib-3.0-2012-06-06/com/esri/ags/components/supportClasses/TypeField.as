package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import mx.collections.*;
    import mx.events.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.events.*;

    final public class TypeField extends DropDownList implements IDataRenderer
    {
        private var m_featureTypeNotInDomain:FeatureType;
        private var m_oldFeatureType:Object;
        private var m_data:Object;
        private static var _skinParts:Object = {scroller:false, dropDown:false, labelDisplay:false, openButton:true, dropIndicator:false, dataGroup:false};

        public function TypeField(fieldValue:Object, featureLayer:FeatureLayer, editable:Boolean)
        {
            var _loc_7:FeatureType = null;
            var _loc_8:String = null;
            minWidth = 128;
            requireSelection = true;
            labelField = "name";
            enabled = editable;
            setStyle("contentBackgroundAlpha", 1);
            this.dataProvider = new ArrayList(featureLayer.types.concat());
            var _loc_4:Boolean = false;
            var _loc_5:* = dataProvider;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5.length)
            {
                
                _loc_7 = _loc_5.getItemAt(_loc_6) as FeatureType;
                if (_loc_7.id == fieldValue)
                {
                    _loc_4 = true;
                    break;
                }
                _loc_6 = _loc_6 + 1;
            }
            if (!_loc_4)
            {
            }
            if (fieldValue)
            {
                _loc_8 = fieldValue.toString();
                this.m_featureTypeNotInDomain = new FeatureType();
                this.m_featureTypeNotInDomain.id = _loc_8;
                this.m_featureTypeNotInDomain.name = _loc_8;
                _loc_5.addItemAt(this.m_featureTypeNotInDomain, 0);
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
            var _loc_4:FeatureType = null;
            if (this.m_data != value)
            {
                this.m_data = value;
                this.m_oldFeatureType = null;
                _loc_2 = dataProvider;
                if (_loc_2)
                {
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2.length)
                    {
                        
                        _loc_4 = _loc_2.getItemAt(_loc_3) as FeatureType;
                        if (_loc_4.id == value)
                        {
                            this.m_oldFeatureType = _loc_4;
                            selectedIndex = _loc_3;
                            break;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                }
            }
            return;
        }// end function

        override protected function measure() : void
        {
            super.measure();
            measuredWidth = measuredWidth + 8;
            measuredMinWidth = measuredMinWidth + 8;
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
            if (this.m_featureTypeNotInDomain === _loc_2.getItemAt(0))
            {
            }
            if (labelDisplay is TextBase)
            {
                (labelDisplay as TextBase).setStyle("lineThrough", true);
            }
            return;
        }// end function

        private function closeHandler(event:DropDownEvent) : void
        {
            var _loc_3:PropertyChangeEvent = null;
            var _loc_2:* = selectedItem as FeatureType;
            if (this.m_data != _loc_2.id)
            {
                _loc_3 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.data, _loc_2.id, this);
                dispatchEvent(_loc_3);
                _loc_3 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "featureType", this.m_oldFeatureType, _loc_2, this);
                dispatchEvent(_loc_3);
                this.m_data = _loc_2.id;
            }
            if (labelDisplay is TextBase)
            {
                (labelDisplay as TextBase).setStyle("lineThrough", this.m_featureTypeNotInDomain === selectedItem);
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
