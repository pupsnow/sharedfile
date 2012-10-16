package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.utils.*;

    public class ExecuteResult extends EventDispatcher
    {
        private var _results:Array;
        private var _messages:Array;

        public function ExecuteResult()
        {
            return;
        }// end function

        public function get results() : Array
        {
            return this._results;
        }// end function

        public function set results(value:Array) : void
        {
            this._results = value;
            dispatchEvent(new Event("resultsChanged"));
            return;
        }// end function

        public function get messages() : Array
        {
            return this._messages;
        }// end function

        public function set messages(value:Array) : void
        {
            this._messages = value;
            dispatchEvent(new Event("messagesChanged"));
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

    }
}
