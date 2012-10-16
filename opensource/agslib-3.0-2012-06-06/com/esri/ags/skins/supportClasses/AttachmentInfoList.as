package com.esri.ags.skins.supportClasses
{
    import mx.events.*;
    import spark.components.*;

    public class AttachmentInfoList extends List
    {
        private var _1814366442deleteEnabled:Boolean = true;
        private var _809145774isEditable:Boolean = true;
        private static var _skinParts:Object = {scroller:false, dropIndicator:false, dataGroup:false};

        public function AttachmentInfoList()
        {
            return;
        }// end function

        public function get deleteEnabled() : Boolean
        {
            return this._1814366442deleteEnabled;
        }// end function

        public function set deleteEnabled(value:Boolean) : void
        {
            arguments = this._1814366442deleteEnabled;
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

        public function get isEditable() : Boolean
        {
            return this._809145774isEditable;
        }// end function

        public function set isEditable(value:Boolean) : void
        {
            arguments = this._809145774isEditable;
            if (arguments !== value)
            {
                this._809145774isEditable = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isEditable", arguments, value));
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
