package com.esri.ags.components.supportClasses
{
    import flash.events.*;
    import mx.controls.*;
    import mx.events.*;

    final public class MemoArea extends TextArea
    {
        private var m_listenerAdded:Boolean = false;
        private var m_oldDataValue:String;

        public function MemoArea(value:Object)
        {
            this.data = value;
            addEventListener(Event.CHANGE, this.changeHandler);
            return;
        }// end function

        override public function get data() : Object
        {
            return htmlText;
        }// end function

        override public function set data(value:Object) : void
        {
            this.m_oldDataValue = value as String;
            htmlText = this.m_oldDataValue;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (!this.m_listenerAdded)
            {
                this.m_listenerAdded = true;
            }
            return;
        }// end function

        private function changeHandler(event:Event) : void
        {
            this.commitDataChange();
            return;
        }// end function

        private function commitDataChange() : void
        {
            var _loc_1:PropertyChangeEvent = null;
            if (this.m_oldDataValue != this.data)
            {
                _loc_1 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", this.m_oldDataValue, htmlText, this);
                dispatchEvent(_loc_1);
                this.m_oldDataValue = htmlText;
            }
            return;
        }// end function

    }
}
