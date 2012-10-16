package com.esri.ags.components.supportClasses
{
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.validators.*;

    final public class CalendarField extends DateField
    {
        private var m_isDateValid:Boolean = true;
        private var m_dateValidator:DateValidator;
        private var m_dateFormatter:DateFormatter;
        private var m_oldDataValue:Object;

        public function CalendarField(time:Object = null)
        {
            if (time)
            {
                this.data = time;
            }
            yearNavigationEnabled = true;
            editable = false;
            addEventListener(CalendarLayoutChangeEvent.CHANGE, this.changeHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            labelFunction = this.formatDate;
            return;
        }// end function

        override public function get data() : Object
        {
            return selectedDate ? (selectedDate.time) : (null);
        }// end function

        override public function set data(value:Object) : void
        {
            var _loc_2:Date = null;
            if (value is Number)
            {
                _loc_2 = new Date();
                _loc_2.time = Number(value);
                selectedDate = _loc_2;
                this.m_oldDataValue = value;
            }
            return;
        }// end function

        public function formatDate(value:Date) : String
        {
            var _loc_2:String = null;
            if (!this.m_dateFormatter)
            {
                _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "popUpFormat_shortDate");
                this.m_dateFormatter = new DateFormatter();
                this.m_dateFormatter.formatString = _loc_2;
            }
            return this.m_dateFormatter.format(value);
        }// end function

        override protected function measure() : void
        {
            var _loc_1:* = mx_internal::downArrowButton.getExplicitOrMeasuredWidth();
            var _loc_2:* = mx_internal::downArrowButton.getExplicitOrMeasuredHeight();
            var _loc_3:* = new Date(2004, 11, 31);
            var _loc_4:* = this.formatDate(_loc_3);
            var _loc_5:* = measureText(_loc_4).width + 8 + 2 + _loc_1;
            measuredWidth = measureText(_loc_4).width + 8 + 2 + _loc_1;
            measuredMinWidth = _loc_5;
            var _loc_5:* = measuredWidth + (getStyle("paddingLeft") + getStyle("paddingRight"));
            measuredWidth = measuredWidth + (getStyle("paddingLeft") + getStyle("paddingRight"));
            measuredMinWidth = _loc_5;
            var _loc_5:* = textInput.getExplicitOrMeasuredHeight();
            measuredHeight = textInput.getExplicitOrMeasuredHeight();
            measuredMinHeight = _loc_5;
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            if (mx_internal::downArrowButton)
            {
                mx_internal::downArrowButton.visible = enabled;
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function creationCompleteHandler(event:FlexEvent) : void
        {
            removeEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            var _loc_2:* = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "popUpFormat_shortDate");
            this.m_dateValidator = new DateValidator();
            this.m_dateValidator.required = false;
            this.m_dateValidator.source = this;
            this.m_dateValidator.property = "text";
            this.m_dateValidator.trigger = this.textInput;
            this.m_dateValidator.triggerEvent = Event.CHANGE;
            this.m_dateValidator.inputFormat = _loc_2;
            this.m_dateValidator.addEventListener(ValidationResultEvent.VALID, this.dateValidator_validHandler);
            this.m_dateValidator.addEventListener(ValidationResultEvent.INVALID, this.dateValidator_invalidHandler);
            return;
        }// end function

        private function dateValidator_invalidHandler(event:ValidationResultEvent) : void
        {
            this.m_isDateValid = false;
            return;
        }// end function

        private function dateValidator_validHandler(event:ValidationResultEvent) : void
        {
            this.m_isDateValid = true;
            return;
        }// end function

        protected function changeHandler(event:CalendarLayoutChangeEvent) : void
        {
            if (this.m_isDateValid)
            {
                this.commitDataChange();
            }
            return;
        }// end function

        private function commitDataChange() : void
        {
            var _loc_1:PropertyChangeEvent = null;
            if (this.m_oldDataValue != this.data)
            {
                _loc_1 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.m_oldDataValue, this.data, this);
                dispatchEvent(_loc_1);
                this.m_oldDataValue = this.data;
            }
            return;
        }// end function

    }
}
