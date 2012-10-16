package com.esri.ags.tasks.supportClasses
{

    public class DataFile extends Object implements IJSONSupport
    {
        public var itemID:String;
        public var url:String;

        public function DataFile(url:String = null, itemID:String = null)
        {
            this.url = url;
            this.itemID = itemID;
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (this.itemID)
            {
                _loc_2.itemID = this.itemID;
            }
            if (this.url)
            {
                _loc_2.url = this.url;
            }
            return _loc_2;
        }// end function

        static function toDataFile(obj:Object) : DataFile
        {
            var _loc_2:DataFile = null;
            if (obj)
            {
                _loc_2 = new DataFile;
                _loc_2.itemID = obj.itemID;
                _loc_2.url = obj.url;
            }
            return _loc_2;
        }// end function

    }
}
