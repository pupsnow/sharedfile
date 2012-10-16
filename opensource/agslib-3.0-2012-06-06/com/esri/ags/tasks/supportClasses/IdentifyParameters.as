package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;

    public class IdentifyParameters extends Object
    {
        public var layerOption:String = "top";
        public var geometry:Geometry;
        public var spatialReference:SpatialReference;
        public var layerDefinitions:Array;
        public var layerIds:Array;
        public var tolerance:Number = 2;
        public var returnGeometry:Boolean = false;
        public var mapExtent:Extent;
        public var maxAllowableOffset:Number;
        public var width:Number;
        public var height:Number;
        public var dpi:Number = 96;
        public var timeExtent:TimeExtent;
        public var layerTimeOptions:Array;
        public var dynamicLayerInfos:Array;
        public var mapScale:Number;
        public var returnM:Boolean;
        public var returnZ:Boolean;
        public static const LAYER_OPTION_ALL:String = "all";
        public static const LAYER_OPTION_TOP:String = "top";
        public static const LAYER_OPTION_VISIBLE:String = "visible";

        public function IdentifyParameters()
        {
            return;
        }// end function

    }
}
