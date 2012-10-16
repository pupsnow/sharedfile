package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class GPMessage extends EventDispatcher
    {
        private var _3575610type:String;
        private var _1724546052description:String;

        public function GPMessage()
        {
            return;
        }// end function

        public function get type() : String
        {
            return this._3575610type;
        }// end function

        public function set type(value:String) : void
        {
            arguments = this._3575610type;
            if (arguments !== value)
            {
                this._3575610type = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", arguments, value));
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

        static function toGPMessage(decodedObject:Object) : GPMessage
        {
            var _loc_2:* = new GPMessage;
            _loc_2.type = decodedObject.type;
            _loc_2.description = decodedObject.description;
            return _loc_2;
        }// end function

    }
}
