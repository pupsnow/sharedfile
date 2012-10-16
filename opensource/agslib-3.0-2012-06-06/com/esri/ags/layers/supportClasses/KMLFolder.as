package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class KMLFolder extends EventDispatcher
    {
        private var _3355id:Number;
        private var _3373707name:String;
        private var _1724546052description:String;
        private var _2061635299snippet:String;
        private var _466743410visible:Boolean;
        private var _1745427213parentFolderId:Number;
        private var _1672286966subFolderIds:Array;
        private var _1188704303featureInfos:Array;

        public function KMLFolder()
        {
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

        public function get description() : String
        {
            return this._1724546052description;
        }// end function

        public function set description(value:String) : void
        {
            arguments = this._1724546052description;
            if (arguments !== value)
            {
                this._1724546052description = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", arguments, value));
                }
            }
            return;
        }// end function

        public function get snippet() : String
        {
            return this._2061635299snippet;
        }// end function

        public function set snippet(value:String) : void
        {
            arguments = this._2061635299snippet;
            if (arguments !== value)
            {
                this._2061635299snippet = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snippet", arguments, value));
                }
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._466743410visible;
        }// end function

        public function set visible(value:Boolean) : void
        {
            arguments = this._466743410visible;
            if (arguments !== value)
            {
                this._466743410visible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", arguments, value));
                }
            }
            return;
        }// end function

        public function get parentFolderId() : Number
        {
            return this._1745427213parentFolderId;
        }// end function

        public function set parentFolderId(value:Number) : void
        {
            arguments = this._1745427213parentFolderId;
            if (arguments !== value)
            {
                this._1745427213parentFolderId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "parentFolderId", arguments, value));
                }
            }
            return;
        }// end function

        public function get subFolderIds() : Array
        {
            return this._1672286966subFolderIds;
        }// end function

        public function set subFolderIds(value:Array) : void
        {
            arguments = this._1672286966subFolderIds;
            if (arguments !== value)
            {
                this._1672286966subFolderIds = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subFolderIds", arguments, value));
                }
            }
            return;
        }// end function

        public function get featureInfos() : Array
        {
            return this._1188704303featureInfos;
        }// end function

        public function set featureInfos(value:Array) : void
        {
            arguments = this._1188704303featureInfos;
            if (arguments !== value)
            {
                this._1188704303featureInfos = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "featureInfos", arguments, value));
                }
            }
            return;
        }// end function

        static function toKMLFolder(obj:Object) : KMLFolder
        {
            var _loc_2:KMLFolder = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new KMLFolder;
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
                _loc_2.description = obj.description;
                _loc_2.snippet = obj.snippet;
                _loc_2.visible = obj.visibility == 1 ? (true) : (false);
                _loc_2.parentFolderId = obj.parentFolderId;
                _loc_2.subFolderIds = obj.subFolderIds;
                if (obj.featureInfos)
                {
                    _loc_2.featureInfos = [];
                    for each (_loc_3 in obj.featureInfos)
                    {
                        
                        _loc_2.featureInfos.push(KMLFeatureInfo.toKMLFeatureInfo(_loc_3));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
