package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class FeatureEditResult extends EventDispatcher
    {
        private var _1434081890attachmentId:Number;
        private var _96784904error:Error;
        private var _90495162objectId:Number;
        private var _1867169789success:Boolean;

        public function FeatureEditResult()
        {
            return;
        }// end function

        public function get attachmentId() : Number
        {
            return this._1434081890attachmentId;
        }// end function

        public function set attachmentId(value:Number) : void
        {
            arguments = this._1434081890attachmentId;
            if (arguments !== value)
            {
                this._1434081890attachmentId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attachmentId", arguments, value));
                }
            }
            return;
        }// end function

        public function get error() : Error
        {
            return this._96784904error;
        }// end function

        public function set error(value:Error) : void
        {
            arguments = this._96784904error;
            if (arguments !== value)
            {
                this._96784904error = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "error", arguments, value));
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

        public function get success() : Boolean
        {
            return this._1867169789success;
        }// end function

        public function set success(value:Boolean) : void
        {
            arguments = this._1867169789success;
            if (arguments !== value)
            {
                this._1867169789success = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "success", arguments, value));
                }
            }
            return;
        }// end function

        static function toFeatureEditResult(obj:Object) : FeatureEditResult
        {
            var _loc_2:FeatureEditResult = null;
            if (obj)
            {
                _loc_2 = new FeatureEditResult;
                if (obj.error)
                {
                    _loc_2.error = new Error(obj.error.description, obj.error.code);
                }
                _loc_2.objectId = obj.objectId;
                _loc_2.success = obj.success;
            }
            return _loc_2;
        }// end function

    }
}
