package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class AttachmentMouseEvent extends MouseEvent
    {
        public var attachmentInfo:AttachmentInfo;
        private var m_mouseEvent:MouseEvent;
        public static const ATTACHMENT_CLICK:String = "attachmentClick";
        public static const ATTACHMENT_DOUBLE_CLICK:String = "attachmentDoubleClick";

        public function AttachmentMouseEvent(type:String, attachmentInfo:AttachmentInfo)
        {
            super(type, true);
            this.attachmentInfo = attachmentInfo;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new AttachmentMouseEvent(type, this.attachmentInfo);
            _loc_1.copyProperties(this.m_mouseEvent);
            return _loc_1;
        }// end function

        public function copyProperties(event:MouseEvent) : void
        {
            localX = event.localX;
            localY = event.localY;
            relatedObject = event.relatedObject;
            ctrlKey = event.ctrlKey;
            altKey = event.altKey;
            shiftKey = event.shiftKey;
            buttonDown = event.buttonDown;
            delta = event.delta;
            this.m_mouseEvent = event;
            return;
        }// end function

        override public function get stageX() : Number
        {
            return this.m_mouseEvent.stageX;
        }// end function

        override public function get stageY() : Number
        {
            return this.m_mouseEvent.stageY;
        }// end function

        override public function toString() : String
        {
            return formatToString("AttachmentMouseEvent", "type", "attachmentInfo", "localX", "localY", "stageX", "stageY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "delta");
        }// end function

    }
}
