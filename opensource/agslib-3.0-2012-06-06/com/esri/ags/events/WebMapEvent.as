package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;

    public class WebMapEvent extends Event
    {
        public var errors:Array;
        public var item:Object;
        public var itemData:Object;
        public var map:Map;
        public static const CREATE_MAP_BY_ID_COMPLETE:String = "createMapByIdComplete";
        public static const CREATE_MAP_BY_ITEM_COMPLETE:String = "createMapByItemComplete";
        public static const GET_ITEM_COMPLETE:String = "getItemComplete";

        public function WebMapEvent(type:String)
        {
            super(type);
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new WebMapEvent(type);
            _loc_1.errors = this.errors;
            _loc_1.item = this.item;
            _loc_1.itemData = this.itemData;
            _loc_1.map = this.map;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("WebMapEvent", "type", "errors", "item", "itemData", "map");
        }// end function

    }
}
