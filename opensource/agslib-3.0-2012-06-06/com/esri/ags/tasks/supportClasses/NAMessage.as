package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;

    public class NAMessage extends EventDispatcher
    {
        private var _type:int;
        private var _description:String;

        public function NAMessage()
        {
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function set type(value:int) : void
        {
            if (this._type !== value)
            {
                this._type = value;
                dispatchEvent(new Event("typeChanged"));
            }
            return;
        }// end function

        public function get description() : String
        {
            return this._description;
        }// end function

        public function set description(value:String) : void
        {
            if (this._description !== value)
            {
                this._description = value;
                dispatchEvent(new Event("descriptionChanged"));
            }
            return;
        }// end function

        static function toNAMessage(obj:Object) : NAMessage
        {
            var _loc_2:NAMessage = null;
            if (obj)
            {
                _loc_2 = new NAMessage;
                _loc_2.type = obj.type;
                _loc_2.description = obj.description;
            }
            return _loc_2;
        }// end function

    }
}
