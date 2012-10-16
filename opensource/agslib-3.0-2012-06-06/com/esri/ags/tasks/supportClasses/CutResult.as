package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.utils.*;

    public class CutResult extends EventDispatcher
    {
        private var _geometries:Array;
        private var _cutIndexes:Array;

        public function CutResult()
        {
            return;
        }// end function

        public function get geometries() : Array
        {
            return this._geometries;
        }// end function

        public function set geometries(value:Array) : void
        {
            this._geometries = value;
            dispatchEvent(new Event("geometriesChanged"));
            return;
        }// end function

        public function get cutIndexes() : Array
        {
            return this._cutIndexes;
        }// end function

        public function set cutIndexes(value:Array) : void
        {
            this._cutIndexes = value;
            dispatchEvent(new Event("cutIndexesChanged"));
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

    }
}
