package com.esri.ags.events
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import flash.events.*;

    public class MapEvent extends Event
    {
        public var map:Map;
        public var layer:Layer;
        public var index:int = -1;
        public static const LOAD:String = "load";
        public static const LAYER_ADD:String = "layerAdd";
        public static const LAYER_REMOVE:String = "layerRemove";
        public static const LAYER_REMOVE_ALL:String = "layerRemoveAll";
        public static const LAYER_REORDER:String = "layerReorder";

        public function MapEvent(type:String, map:Map = null, layer:Layer = null, index:int = -1)
        {
            super(type);
            this.map = map;
            this.layer = layer;
            this.index = index;
            return;
        }// end function

        override public function clone() : Event
        {
            return new MapEvent(type, this.map, this.layer, this.index);
        }// end function

        override public function toString() : String
        {
            return formatToString("MapEvent", "type", "map", "layer", "index");
        }// end function

    }
}
