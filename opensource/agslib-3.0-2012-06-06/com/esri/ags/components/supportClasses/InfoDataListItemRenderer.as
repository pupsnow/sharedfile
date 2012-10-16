package com.esri.ags.components.supportClasses
{
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.layouts.*;
    import spark.primitives.*;

    public class InfoDataListItemRenderer extends ItemRenderer
    {
        private var m_key:String;
        private var m_value:String;
        private var m_keyLabel:Label;
        private var m_valueLabel:Label;

        public function InfoDataListItemRenderer()
        {
            height = 25;
            var _loc_1:* = new HorizontalLayout();
            _loc_1.verticalAlign = VerticalAlign.MIDDLE;
            layout = _loc_1;
            return;
        }// end function

        override public function get data() : Object
        {
            return {key:this.m_key, value:this.m_value};
        }// end function

        override public function set data(value:Object) : void
        {
            super.data = value;
            if (value)
            {
                this.m_key = value.key;
                this.m_value = value.value;
                invalidateProperties();
                dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            }
            return;
        }// end function

        override protected function createChildren() : void
        {
            super.createChildren();
            this.m_keyLabel = new Label();
            this.m_keyLabel.percentWidth = 50;
            this.m_keyLabel.maxDisplayedLines = 1;
            this.m_valueLabel = new Label();
            this.m_valueLabel.percentWidth = 50;
            this.m_valueLabel.maxDisplayedLines = 1;
            var _loc_1:* = new Line();
            _loc_1.yTo = 25;
            _loc_1.stroke = new SolidColorStroke(0, 1, 1, false, "normal", "square");
            this.addElement(this.m_keyLabel);
            this.addElement(_loc_1);
            this.addElement(this.m_valueLabel);
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            this.m_keyLabel.text = this.m_key;
            this.m_valueLabel.text = this.m_value;
            return;
        }// end function

    }
}
