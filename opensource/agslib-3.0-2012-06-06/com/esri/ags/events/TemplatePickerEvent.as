package com.esri.ags.events
{
    import com.esri.ags.components.supportClasses.*;
    import flash.events.*;

    public class TemplatePickerEvent extends Event
    {
        public var selectedTemplate:Template;
        public static const SELECTED_TEMPLATE_CHANGE:String = "selectedTemplateChange";

        public function TemplatePickerEvent(type:String, selectedTemplate:Template = null)
        {
            super(type);
            this.selectedTemplate = selectedTemplate;
            return;
        }// end function

        override public function clone() : Event
        {
            return new TemplatePickerEvent(type, this.selectedTemplate);
        }// end function

        override public function toString() : String
        {
            return formatToString("TemplatePickerEvent", "type", "selectedTemplate");
        }// end function

    }
}
