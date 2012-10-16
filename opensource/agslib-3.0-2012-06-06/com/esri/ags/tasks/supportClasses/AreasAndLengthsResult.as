package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.utils.*;

    public class AreasAndLengthsResult extends EventDispatcher
    {
        private var _areas:Array;
        private var _lengths:Array;

        public function AreasAndLengthsResult()
        {
            return;
        }// end function

        public function get areas() : Array
        {
            return this._areas;
        }// end function

        public function set areas(value:Array) : void
        {
            this._areas = value;
            dispatchEvent(new Event("areasChanged"));
            return;
        }// end function

        public function get lengths() : Array
        {
            return this._lengths;
        }// end function

        public function set lengths(value:Array) : void
        {
            this._lengths = value;
            dispatchEvent(new Event("lengthsChanged"));
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

    }
}
