package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import spark.components.supportClasses.*;

    public class AttachmentInspector extends SkinnableComponent
    {
        public var addButton:ButtonBase;
        public var browseButton:ButtonBase;
        public var cancelButton:ButtonBase;
        private var m_attachmentInfos:IList;
        private var m_attachmentName:String;
        private var m_attachmentSize:Number;
        private var m_attachmentLoaded:Boolean = false;
        private var m_feature:Graphic;
        private var m_featureChanged:Boolean = false;
        private var m_featureLayer:FeatureLayer;
        private var m_fileReference:FileReference;
        private var m_addEnabled:Boolean = true;
        private var m_deleteEnabled:Boolean = true;
        private var m_queryAttachmentInfos:Boolean = false;
        private var m_addingAttachment:Boolean = false;
        private var m_infoWindowLabel:String = null;
        private const m_log:ILogger;
        private static var _skinParts:Object = {addButton:false, cancelButton:false, browseButton:false};

        public function AttachmentInspector()
        {
            this.m_attachmentInfos = new ArrayList();
            this.m_log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            addEventListener(AttachmentRemoveEvent.REMOVE_ATTACHMENT, this.attachmentRemoveHandler);
            return;
        }// end function

        public function get attachmentInfos() : IList
        {
            return this.m_attachmentInfos;
        }// end function

        public function set attachmentInfos(value:IList) : void
        {
            this.m_attachmentInfos = value;
            dispatchEvent(new Event("attachmentInfosChanged"));
            return;
        }// end function

        public function get attachmentName() : String
        {
            return this.m_attachmentName;
        }// end function

        public function set attachmentName(value:String) : void
        {
            if (this.m_attachmentName !== value)
            {
                this.m_attachmentName = value;
                dispatchEvent(new Event("attachmentNameChanged"));
            }
            return;
        }// end function

        public function get attachmentSize() : Number
        {
            return this.m_attachmentSize;
        }// end function

        public function set attachmentSize(value:Number) : void
        {
            if (this.m_attachmentSize !== value)
            {
                this.m_attachmentSize = value;
                dispatchEvent(new Event("attachmentSizeChanged"));
            }
            return;
        }// end function

        public function clear() : void
        {
            if (Log.isDebug())
            {
                this.m_log.debug("AttachmentInspector::clear");
            }
            this.attachmentInfos.removeAll();
            invalidateSkinState();
            if (this.m_featureLayer)
            {
                this.m_featureLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsComplete);
            }
            this.m_featureLayer = null;
            this.m_feature = null;
            this.resetAttachmentInfo();
            return;
        }// end function

        override public function set enabled(value:Boolean) : void
        {
            if (enabled !== value)
            {
                invalidateSkinState();
            }
            super.enabled = value;
            return;
        }// end function

        public function get feature() : Graphic
        {
            return this.m_feature;
        }// end function

        private function set _979207434feature(value:Graphic) : void
        {
            if (value)
            {
            }
            if (this.m_feature !== value)
            {
                this.m_feature = value;
                this.m_featureChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("featureChanged"));
            }
            return;
        }// end function

        public function get featureLayer() : FeatureLayer
        {
            return this.m_featureLayer;
        }// end function

        public function refresh() : void
        {
            this.showAttachments(this.m_feature, this.m_featureLayer);
            return;
        }// end function

        public function get deleteEnabled() : Boolean
        {
            return this.m_deleteEnabled;
        }// end function

        private function set _1814366442deleteEnabled(value:Boolean) : void
        {
            if (this.m_deleteEnabled != value)
            {
                this.m_deleteEnabled = value;
            }
            return;
        }// end function

        public function get addEnabled() : Boolean
        {
            return this.m_addEnabled;
        }// end function

        private function set _298640224addEnabled(value:Boolean) : void
        {
            if (this.m_addEnabled != value)
            {
                this.m_addEnabled = value;
            }
            return;
        }// end function

        public function get infoWindowLabel() : String
        {
            return this.m_infoWindowLabel;
        }// end function

        public function set infoWindowLabel(value:String) : void
        {
            if (this.m_infoWindowLabel != value)
            {
                this.m_infoWindowLabel = value;
                dispatchEvent(new Event("infoWindowLabelChanged", true));
            }
            return;
        }// end function

        public function showAttachments(feature:Graphic, featureLayer:FeatureLayer = null) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (this.m_featureLayer)
            {
                this.m_featureLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsComplete);
            }
            if (feature)
            {
                this.resetAttachmentInfo();
                if (featureLayer)
                {
                    this.m_featureLayer = featureLayer;
                }
                else
                {
                    this.m_featureLayer = feature.graphicsLayer as FeatureLayer;
                }
                if (this.m_featureLayer)
                {
                    if (this.m_featureLayer.layerDetails)
                    {
                    }
                    if (this.m_featureLayer.layerDetails.hasAttachments)
                    {
                        this.queryAttachmentInfos(feature.attributes[this.m_featureLayer.layerDetails.objectIdField], feature);
                    }
                    else
                    {
                        if (this.m_featureLayer.tableDetails)
                        {
                        }
                        if (this.m_featureLayer.tableDetails.hasAttachments)
                        {
                            this.queryAttachmentInfos(feature.attributes[this.m_featureLayer.tableDetails.objectIdField], feature);
                        }
                        else
                        {
                            _loc_3 = resourceManager.getString("ESRIMessages", "attachmentInspectorNoAttachmentsSupported");
                            if (hasEventListener(FaultEvent.FAULT))
                            {
                                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, new Fault("attachmentInspectorNoAttachmentsSupported", _loc_3)));
                            }
                            if (Log.isWarn())
                            {
                                this.m_log.warn(_loc_3);
                            }
                        }
                    }
                }
                else
                {
                    _loc_4 = resourceManager.getString("ESRIMessages", "attachmentInspectorNotFeatureLayer");
                    if (hasEventListener(FaultEvent.FAULT))
                    {
                        dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, new Fault("attachmentInspectorNotFeatureLayer", _loc_4)));
                    }
                    if (Log.isError())
                    {
                        this.m_log.error(resourceManager.getString("ESRIMessages", "attachmentInspectorNotFeatureLayer"));
                    }
                }
            }
            else
            {
                this.clear();
            }
            return;
        }// end function

        private function queryAttachmentInfos(objectId:Number, feature:Graphic) : void
        {
            this.m_featureLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsComplete);
            this.m_feature = feature;
            dispatchEvent(new Event("featureChanged"));
            var _loc_3:* = this.m_featureLayer.queryAttachmentInfos(objectId);
            _loc_3.addResponder(new Responder(this.queryAttachmentInfos_resultHandler, this.faultHandler));
            this.m_queryAttachmentInfos = true;
            invalidateSkinState();
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this.m_featureChanged)
            {
                this.m_featureChanged = false;
                callLater(this.showAttachments, [this.m_feature]);
            }
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (enabled === false)
            {
                return "disabled";
            }
            if (this.m_feature === null)
            {
                return "disabled";
            }
            if (this.m_queryAttachmentInfos)
            {
                if (this.m_attachmentInfos)
                {
                }
                return this.m_attachmentInfos.length ? ("queryAttachmentInfosWithList") : ("queryAttachmentInfos");
            }
            if (this.m_attachmentLoaded)
            {
                if (this.attachmentInfos !== null)
                {
                }
                if (this.attachmentInfos.length === 0)
                {
                    return "attachmentLoadedNoAttachmentsInList";
                }
                return "attachmentLoaded";
            }
            if (this.attachmentInfos !== null)
            {
            }
            if (this.attachmentInfos.length === 0)
            {
                return "noAttachmentsInList";
            }
            return "normal";
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.addButton)
            {
                this.addButton.addEventListener(MouseEvent.CLICK, this.addButton_clickHandler);
            }
            else if (instance === this.cancelButton)
            {
                this.cancelButton.addEventListener(MouseEvent.CLICK, this.cancelButton_clickHandler);
            }
            else if (instance === this.browseButton)
            {
                this.browseButton.addEventListener(MouseEvent.CLICK, this.browseButton_clickHandler);
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.addButton)
            {
                this.addButton.removeEventListener(MouseEvent.CLICK, this.addButton_clickHandler);
            }
            else if (instance === this.cancelButton)
            {
                this.cancelButton.removeEventListener(MouseEvent.CLICK, this.cancelButton_clickHandler);
            }
            else if (instance === this.browseButton)
            {
                this.browseButton.removeEventListener(MouseEvent.CLICK, this.browseButton_clickHandler);
            }
            return;
        }// end function

        private function addAttachment_resultHandler(featureEditResult:FeatureEditResult) : void
        {
            var _loc_2:AttachmentEvent = null;
            this.m_addingAttachment = false;
            if (hasEventListener(AttachmentEvent.ADD_ATTACHMENT_COMPLETE))
            {
                _loc_2 = new AttachmentEvent(AttachmentEvent.ADD_ATTACHMENT_COMPLETE, this.m_featureLayer);
                _loc_2.featureEditResult = featureEditResult;
                dispatchEvent(_loc_2);
            }
            if (featureEditResult.success)
            {
                this.showAttachments(this.m_feature, this.m_featureLayer);
            }
            else if (Log.isError())
            {
                this.m_log.error(featureEditResult.error.message);
            }
            return;
        }// end function

        private function addButton_clickHandler(event:MouseEvent) : void
        {
            if (this.m_feature)
            {
            }
            if (this.m_featureLayer)
            {
            }
            if (this.m_fileReference)
            {
                if (!this.m_addingAttachment)
                {
                    if (this.m_featureLayer.layerDetails)
                    {
                        this.addAttachment(this.m_feature.attributes[this.m_featureLayer.layerDetails.objectIdField]);
                        this.m_addingAttachment = true;
                    }
                    else if (this.m_featureLayer.tableDetails)
                    {
                        this.addAttachment(this.m_feature.attributes[this.m_featureLayer.tableDetails.objectIdField]);
                        this.m_addingAttachment = true;
                    }
                }
            }
            else if (Log.isWarn())
            {
                this.m_log.warn("Undefined FeatureLayer, Feature or FileReference");
            }
            return;
        }// end function

        private function addAttachment(objectId:Number) : void
        {
            var _loc_2:* = this.m_featureLayer.addAttachment(objectId, this.m_fileReference.data, this.m_fileReference.name);
            _loc_2.addResponder(new Responder(this.addAttachment_resultHandler, this.faultHandler));
            return;
        }// end function

        private function attachmentRemoveHandler(event:AttachmentRemoveEvent) : void
        {
            if (this.m_featureLayer.layerDetails)
            {
                this.deleteAttachments(event, this.m_feature.attributes[this.m_featureLayer.layerDetails.objectIdField]);
            }
            else if (this.m_featureLayer.tableDetails)
            {
                this.deleteAttachments(event, this.m_feature.attributes[this.m_featureLayer.tableDetails.objectIdField]);
            }
            return;
        }// end function

        private function deleteAttachments(event:AttachmentRemoveEvent, objectId:Number) : void
        {
            var _loc_3:* = this.m_featureLayer.deleteAttachments(objectId, [event.attachmentInfo.id]);
            _loc_3.addResponder(new Responder(this.deleteAttachments_resultHandler, this.faultHandler));
            return;
        }// end function

        private function browseButton_clickHandler(event:MouseEvent) : void
        {
            this.resetAttachmentInfo();
            if (this.m_feature)
            {
            }
            if (this.m_featureLayer)
            {
                this.m_fileReference = new FileReference();
                this.m_fileReference.addEventListener(IOErrorEvent.IO_ERROR, this.fileReference_ioErrorHandler);
                this.m_fileReference.addEventListener(Event.COMPLETE, this.fileReference_completeHandler);
                this.m_fileReference.addEventListener(Event.SELECT, this.fileReference_selectHandler);
                this.m_fileReference.addEventListener(Event.CANCEL, this.fileReference_cancelHandler);
                this.m_fileReference.browse();
            }
            else if (Log.isWarn())
            {
                this.m_log.warn("Undefined FeatureLayer or Feature");
            }
            return;
        }// end function

        private function cancelButton_clickHandler(event:MouseEvent) : void
        {
            this.resetAttachmentInfo();
            return;
        }// end function

        private function deleteAttachments_resultHandler(featureEditResults:Array) : void
        {
            var _loc_3:FeatureEditResult = null;
            var _loc_4:AttachmentEvent = null;
            if (hasEventListener(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE))
            {
                _loc_4 = new AttachmentEvent(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE, this.m_featureLayer);
                if (featureEditResults)
                {
                }
                if (featureEditResults.length)
                {
                    _loc_4.featureEditResult = featureEditResults[0];
                }
                _loc_4.featureEditResults = featureEditResults;
                dispatchEvent(_loc_4);
            }
            var _loc_2:Boolean = true;
            for each (_loc_3 in featureEditResults)
            {
                
                if (_loc_3.success === false)
                {
                    _loc_2 = false;
                    break;
                }
            }
            if (_loc_2)
            {
                this.refresh();
            }
            return;
        }// end function

        private function faultHandler(fault:Fault) : void
        {
            this.m_addingAttachment = false;
            this.m_queryAttachmentInfos = false;
            if (Log.isError())
            {
                this.m_log.error(fault.message);
            }
            if (hasEventListener(FaultEvent.FAULT))
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
            }
            invalidateSkinState();
            return;
        }// end function

        private function featureLayer_editsComplete(event:FeatureLayerEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:FeatureEditResult = null;
            if (event.featureEditResults)
            {
            }
            if (this.m_feature)
            {
            }
            if (this.m_featureLayer)
            {
                if (this.m_featureLayer.layerDetails)
                {
                    _loc_2 = this.m_feature.attributes[this.m_featureLayer.layerDetails.objectIdField];
                }
                else if (this.m_featureLayer.tableDetails)
                {
                    _loc_2 = this.m_feature.attributes[this.m_featureLayer.tableDetails.objectIdField];
                }
                else
                {
                    _loc_2 = -1;
                }
                for each (_loc_3 in event.featureEditResults.deleteResults)
                {
                    
                    if (_loc_3.success)
                    {
                    }
                    if (_loc_3.objectId === _loc_2)
                    {
                        this.clear();
                    }
                }
            }
            return;
        }// end function

        private function fileReference_cancelHandler(event:Event) : void
        {
            this.resetAttachmentInfo();
            return;
        }// end function

        private function fileReference_completeHandler(event:Event) : void
        {
            if (Log.isDebug())
            {
                this.m_log.debug("fileReference_completeHandler::{0} {1} Bytes", this.m_fileReference.name, this.m_fileReference.size);
            }
            this.attachmentName = this.m_fileReference.name;
            this.attachmentSize = this.m_fileReference.size;
            this.m_attachmentLoaded = true;
            invalidateSkinState();
            return;
        }// end function

        private function fileReference_ioErrorHandler(event:IOErrorEvent) : void
        {
            if (Log.isError())
            {
                this.m_log.error(event.text);
            }
            if (hasEventListener(IOErrorEvent.IO_ERROR))
            {
                dispatchEvent(event);
            }
            return;
        }// end function

        private function fileReference_selectHandler(event:Event) : void
        {
            if (Log.isDebug())
            {
                this.m_log.debug(event.toString());
            }
            this.m_fileReference.load();
            return;
        }// end function

        private function queryAttachmentInfos_resultHandler(attachmentInfos:Array) : void
        {
            var _loc_2:AttachmentEvent = null;
            if (hasEventListener(AttachmentEvent.QUERY_ATTACHMENT_INFOS_COMPLETE))
            {
                _loc_2 = new AttachmentEvent(AttachmentEvent.QUERY_ATTACHMENT_INFOS_COMPLETE, this.m_featureLayer);
                _loc_2.attachmentInfos = attachmentInfos;
                dispatchEvent(_loc_2);
            }
            this.m_queryAttachmentInfos = false;
            this.attachmentInfos = new ArrayList(attachmentInfos);
            invalidateSkinState();
            return;
        }// end function

        private function resetAttachmentInfo() : void
        {
            if (this.m_fileReference)
            {
                this.m_fileReference.removeEventListener(Event.CANCEL, this.fileReference_cancelHandler);
                this.m_fileReference.removeEventListener(Event.COMPLETE, this.fileReference_completeHandler);
                this.m_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, this.fileReference_ioErrorHandler);
                this.m_fileReference.removeEventListener(Event.SELECT, this.fileReference_selectHandler);
                this.m_fileReference = null;
            }
            this.m_attachmentLoaded = false;
            this.attachmentName = null;
            this.attachmentSize = NaN;
            invalidateSkinState();
            return;
        }// end function

        public function set addEnabled(value:Boolean) : void
        {
            arguments = this.addEnabled;
            if (arguments !== value)
            {
                this._298640224addEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set feature(value:Graphic) : void
        {
            arguments = this.feature;
            if (arguments !== value)
            {
                this._979207434feature = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "feature", arguments, value));
                }
            }
            return;
        }// end function

        public function set deleteEnabled(value:Boolean) : void
        {
            arguments = this.deleteEnabled;
            if (arguments !== value)
            {
                this._1814366442deleteEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteEnabled", arguments, value));
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
