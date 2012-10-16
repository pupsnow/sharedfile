package com.esri.ags.components.supportClasses
{
    import mx.utils.*;

    final public class RangeDomainField extends DoubleField
    {
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function RangeDomainField(value:Number, minValue:Number, maxValue:Number)
        {
            super(value);
            m_validator.minValue = minValue;
            m_validator.maxValue = maxValue;
            var _loc_4:* = StringUtil.substitute(resourceManager.getString("ESRIMessages", "attributeInspectorFieldRangeValidationError"), minValue, maxValue);
            var _loc_5:* = _loc_4;
            m_validator.greaterThanMaxError = _loc_4;
            m_validator.lessThanMinError = _loc_5;
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
