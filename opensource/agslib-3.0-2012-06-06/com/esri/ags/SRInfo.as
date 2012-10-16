package com.esri.ags
{

    final public class SRInfo extends Object
    {
        public var wkid:Number;
        public var wkTemplate:String;
        public var altTemplate:String;
        public var valid:Array;
        public var origin:Array;
        private var _world:Number;

        public function SRInfo(wkid:Number)
        {
            this.wkid = wkid;
            return;
        }// end function

        public function get world() : Number
        {
            if (isNaN(this._world))
            {
                this._world = 2 * this.valid[1];
            }
            return this._world;
        }// end function

    }
}
