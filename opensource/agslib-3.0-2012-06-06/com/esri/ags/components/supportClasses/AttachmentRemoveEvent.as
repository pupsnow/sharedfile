package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class AttachmentRemoveEvent extends Event
    {
        public var attachmentInfo:AttachmentInfo;
        public static const REMOVE_ATTACHMENT:String = "removeAttachment";

        public function AttachmentRemoveEvent(attachmentInfo:AttachmentInfo)
        {
            super(REMOVE_ATTACHMENT, true);
            this.attachmentInfo = attachmentInfo;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AttachmentRemoveEvent(this.attachmentInfo);
        }// end function

    }
}
