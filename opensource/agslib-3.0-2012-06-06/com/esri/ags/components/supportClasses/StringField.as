package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;

    public class StringField extends TextInput implements IDataRenderer
    {
        private var m_listenerAdded:Boolean = false;
        private var m_oldDataValue:Object;
        private static var _skinParts:Object = {promptDisplay:false, textDisplay:false};

        public function StringField(value:Object = null)
        {
            this.data = value;
            addEventListener(FlexEvent.ENTER, this.enterHandler);
            return;
        }// end function

        public function get data() : Object
        {
            return text;
        }// end function

        public function set data(value:Object) : void
        {
            this.m_oldDataValue = value;
            text = value ? (value.toString()) : (null);
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

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this.getTargetAsStringField(event.target) !== this)
            {
                stage.focus = null;
                this.commitDataChange();
                FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
                this.m_listenerAdded = false;
            }
            return;
        }// end function

        private function getTargetAsStringField(target:Object) : StringField
        {
            var _loc_2:* = target as StringField;
            if (_loc_2)
            {
                return _loc_2;
            }
            if (target.parent)
            {
                return this.getTargetAsStringField(target.parent);
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
