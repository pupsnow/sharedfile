package com.esri.ags.events
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class ExtentEvent extends Event
    {
        public var extent:Extent;
        public var levelChange:Boolean;
        public var lod:LOD;
        public static const EXTENT_CHANGE:String = "extentChange";

        public function ExtentEvent(type:String, extent:Extent = null, levelChange:Boolean = false, lod:LOD = null)
        {
            super(type);
            this.extent = extent;
            this.levelChange = levelChange;
            this.lod = lod;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ExtentEvent(type, this.extent, this.levelChange, this.lod);
        }// end function

        override public function toString() : String
        {
            return formatToString("ExtentEvent", "type", "extent", "levelChange", "lod");
        }// end function

    }
}
