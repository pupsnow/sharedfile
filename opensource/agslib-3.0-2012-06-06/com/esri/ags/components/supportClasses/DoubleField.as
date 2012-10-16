package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;
    import spark.formatters.*;
    import spark.validators.*;

    public class DoubleField extends TextInput implements IDataRenderer
    {
        private var m_listenerAdded:Boolean = false;
        protected var m_valid:Boolean = true;
        protected var m_validator:NumberValidator;
        protected var m_numberFormatter:NumberFormatter;
        private var m_oldDataValue:Object;
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function DoubleField(value:Object = null)
        {
            var _loc_2:* = resourceManager.getString("validators", "decimalSeparator");
            restrict = "0-9\\-\\" + _loc_2;
            this.m_numberFormatter = new NumberFormatter();
            this.m_numberFormatter.useGrouping = false;
            this.data = value;
            this.m_validator = new NumberValidator();
            this.m_validator.required = false;
            this.m_validator.source = this;
            this.m_validator.property = "text";
            this.m_validator.trigger = this;
            this.m_validator.triggerEvent = Event.CHANGE;
            this.m_validator.addEventListener(ValidationResultEvent.INVALID, this.invalidHandler);
            this.m_validator.addEventListener(ValidationResultEvent.VALID, this.validHandler);
            addEventListener(FlexEvent.ENTER, this.enterHandler);
            return;
        }// end function

        public function get data() : Object
        {
            return text === "" ? (null) : (this.m_numberFormatter.parse(text).value);
        }// end function

        public function set data(value:Object) : void
        {
            this.m_oldDataValue = value;
            text = value === null ? ("") : (this.m_numberFormatter.format(value));
            return;
        }// end function

        public function get maxValue() : Number
        {
            return this.m_validator.maxValue as Number;
        }// end function

        private function set _399227501maxValue(value:Number) : void
        {
            this.m_validator.maxValue = value;
            return;
        }// end function

        public function get minValue() : Number
        {
            return this.m_validator.minValue as Number;
        }// end function

        private function set _1376969153minValue(value:Number) : void
        {
            this.m_validator.minValue = value;
            return;
        }// end function

        override protected function focusInHandler(event:FocusEvent) : void
        {
            super.focusInHandler(event);
            if (!this.m_listenerAdded)
            {
                FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true, 1, true);
                this.m_listenerAdded = true;
            }
            return;
        }// end function

        override protected function focusOutHandler(event:FocusEvent) : void
        {
            super.focusOutHandler(event);
            if (this.m_listenerAdded)
            {
                FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
                this.m_listenerAdded = false;
            }
            this.commitDataChange();
            return;
        }// end function

        private function enterHandler(event:FlexEvent) : void
        {
            this.commitDataChange();
            return;
        }// end function

        private function invalidHandler(event:ValidationResultEvent) : void
        {
            this.m_valid = false;
            dispatchEvent(new ValidationResultEvent(event.type, true, false, event.field, event.results));
            return;
        }// end function

        private function validHandler(event:ValidationResultEvent) : void
        {
            this.m_valid = true;
            dispatchEvent(new ValidationResultEvent(event.type, true, false, event.field, event.results));
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this.getTargetAsDoubleField(event.target) !== this)
            {
            }
            if (this.m_valid)
            {
                stage.focus = null;
                this.commitDataChange();
                FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
                this.m_listenerAdded = false;
            }
            return;
        }// end function

        private function getTargetAsDoubleField(target:Object) : DoubleField
        {
            var _loc_2:* = target as DoubleField;
            if (_loc_2)
            {
                return _loc_2;
            }
            if (target.parent)
            {
                return this.getTargetAsDoubleField(target.parent);
            }
            return null;
        }// end function

        private function commitDataChange() : void
        {
            var _loc_1:PropertyChangeEvent = null;
            if (this.m_valid)
            {
            }
            if (this.m_oldDataValue != this.data)
            {
                _loc_1 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.m_oldDataValue, this.data, this);
                dispatchEvent(_loc_1);
                this.m_oldDataValue = this.data;
            }
            return;
        }// end function

        public function set minValue(value:Number) : void
        {
            arguments = this.minValue;
            if (arguments !== value)
            {
                this._1376969153minValue = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minValue", arguments, value));
                }
            }
            return;
        }// end function

        public function set maxValue(value:Number) : void
        {
            arguments = this.maxValue;
            if (arguments !== value)
            {
                this._399227501maxValue = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxValue", arguments, value));
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
