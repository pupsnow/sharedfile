package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;

    public class ImageServiceIdentifyResult extends EventDispatcher
    {
        private var _1168064729catalogItems:FeatureSet;
        private var _1262889956catalogItemVisibilities:Array;
        private var _1901043637location:MapPoint;
        private var _3373707name:String;
        private var _90495162objectId:Number;
        private var _926053069properties:Object;
        private var _111972721value:String;

        public function ImageServiceIdentifyResult()
        {
            return;
        }// end function

        public function get catalogItems() : FeatureSet
        {
            return this._1168064729catalogItems;
        }// end function

        public function set catalogItems(value:FeatureSet) : void
        {
            arguments = this._1168064729catalogItems;
            if (arguments !== value)
            {
                this._1168064729catalogItems = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "catalogItems", arguments, value));
                }
            }
            return;
        }// end function

        public function get catalogItemVisibilities() : Array
        {
            return this._1262889956catalogItemVisibilities;
        }// end function

        public function set catalogItemVisibilities(value:Array) : void
        {
            arguments = this._1262889956catalogItemVisibilities;
            if (arguments !== value)
            {
                this._1262889956catalogItemVisibilities = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "catalogItemVisibilities", arguments, value));
                }
            }
            return;
        }// end function

        public function get location() : MapPoint
        {
            return this._1901043637location;
        }// end function

        public function set location(value:MapPoint) : void
        {
            arguments = this._1901043637location;
            if (arguments !== value)
            {
                this._1901043637location = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "location", arguments, value));
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

        public function get properties() : Object
        {
            return this._926053069properties;
        }// end function

        public function set properties(value:Object) : void
        {
            arguments = this._926053069properties;
            if (arguments !== value)
            {
                this._926053069properties = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "properties", arguments, value));
                }
            }
            return;
        }// end function

        public function get value() : String
        {
            return this._111972721value;
        }// end function

        public function set value(value:String) : void
        {
            arguments = this._111972721value;
            if (arguments !== value)
            {
                this._111972721value = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", arguments, value));
                }
            }
            return;
        }// end function

        static function toImageServiceIdentifyResult(obj:Object) : ImageServiceIdentifyResult
        {
            var _loc_2:ImageServiceIdentifyResult = null;
            if (obj)
            {
                _loc_2 = new ImageServiceIdentifyResult;
                _loc_2.catalogItems = FeatureSet.fromJSON(obj.catalogItems);
                _loc_2.catalogItemVisibilities = obj.catalogItemVisibilities;
                _loc_2.location = MapPoint.fromJSON(obj.location);
                _loc_2.name = obj.name;
                _loc_2.objectId = obj.objectId;
                _loc_2.properties = obj.properties;
                _loc_2.value = obj.value;
            }
            return _loc_2;
        }// end function

    }
}
