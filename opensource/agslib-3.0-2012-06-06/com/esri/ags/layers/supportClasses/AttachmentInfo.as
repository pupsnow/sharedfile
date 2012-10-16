package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class AttachmentInfo extends EventDispatcher
    {
        private var _389131437contentType:String;
        private var _3355id:Number;
        private var _3373707name:String;
        private var _90495162objectId:Number;
        private var _3530753size:Number;
        private var _116079url:String;

        public function AttachmentInfo()
        {
            return;
        }// end function

        public function get contentType() : String
        {
            return this._389131437contentType;
        }// end function

        public function set contentType(value:String) : void
        {
            arguments = this._389131437contentType;
            if (arguments !== value)
            {
                this._389131437contentType = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentType", arguments, value));
                }
            }
            return;
        }// end function

        public function get id() : Number
        {
            return this._3355id;
        }// end function

        public function set id(value:Number) : void
        {
            arguments = this._3355id;
            if (arguments !== value)
            {
                this._3355id = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", arguments, value));
                }
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._3373707name;
        }// end function

        public function set name(value:String) : void
        {
            arguments = this._3373707name;
            if (arguments !== value)
            {
                this._3373707name = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", arguments, value));
                }
            }
            return;
        }// end function

        public function get objectId() : Number
        {
            return this._90495162objectId;
        }// end function

        public function set objectId(value:Number) : void
        {
            arguments = this._90495162objectId;
            if (arguments !== value)
            {
                this._90495162objectId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "objectId", arguments, value));
                }
            }
            return;
        }// end function

        public function get size() : Number
        {
            return this._3530753size;
        }// end function

        public function set size(value:Number) : void
        {
            arguments = this._3530753size;
            if (arguments !== value)
            {
                this._3530753size = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "size", arguments, value));
                }
            }
            return;
        }// end function

        public function get url() : String
        {
            return this._116079url;
        }// end function

        public function set url(value:String) : void
        {
            arguments = this._116079url;
            if (arguments !== value)
            {
                this._116079url = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "url", arguments, value));
                }
            }
            return;
        }// end function

        static function toAttachmentInfo(obj:Object) : AttachmentInfo
        {
            var _loc_2:AttachmentInfo = null;
            if (obj)
            {
                _loc_2 = new AttachmentInfo;
                _loc_2.contentType = obj.contentType;
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
                _loc_2.size = obj.size;
            }
            return _loc_2;
        }// end function

    }
}
