package com.esri.ags.events
{
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class AttachmentEvent extends Event
    {
        public var featureLayer:FeatureLayer;
        public var attachmentInfos:Array;
        public var featureEditResults:Array;
        public var featureEditResult:FeatureEditResult;
        public static const ADD_ATTACHMENT_COMPLETE:String = "addAttachmentComplete";
        public static const DELETE_ATTACHMENTS_COMPLETE:String = "deleteAttachmentsComplete";
        public static const QUERY_ATTACHMENT_INFOS_COMPLETE:String = "queryAttachmentInfosComplete";
        public static const UPDATE_ATTACHMENT_COMPLETE:String = "updateAttachmentComplete";

        public function AttachmentEvent(type:String, featureLayer:FeatureLayer = null)
        {
            super(type);
            this.featureLayer = featureLayer;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new AttachmentEvent(type, this.featureLayer);
            _loc_1.attachmentInfos = this.attachmentInfos;
            _loc_1.featureEditResult = this.featureEditResult;
            _loc_1.featureEditResults = this.featureEditResults;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("AttachmentEvent", "type", "featureLayer");
        }// end function

    }
}
