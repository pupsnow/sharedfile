package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import mx.validators.*;
    import spark.components.*;

    public class IntegerField extends TextInput implements IDataRenderer
    {
        private var m_listenerAdded:Boolean = false;
        protected var m_valid:Boolean = true;
        protected var m_validator:NumberValidator;
        private var m_oldDataValue:Object;
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function IntegerField(value:Object = null)
        {
            restrict = "0-9\\-";
            this.data = value;
            this.m_validator = new NumberValidator();
            this.m_validator.required = false;
            this.m_validator.domain = NumberValidatorDomainType.INT;
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
            return text === "" ? (null) : (int(text));
        }// end function

        public function set data(value:Object) : void
        {
            this.m_oldDataValue = value;
            text = value === null ? ("") : (value.toString());
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
            if (this.getTargetAsIntegerField(event.target) !== this)
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

        private function getTargetAsIntegerField(target:Object) : IntegerField
        {
            var _loc_2:* = target as IntegerField;
            if (_loc_2)
            {
                return _loc_2;
            }
            if (target.parent)
            {
                return this.getTargetAsIntegerField(target.parent);
            }
            return null;
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

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
