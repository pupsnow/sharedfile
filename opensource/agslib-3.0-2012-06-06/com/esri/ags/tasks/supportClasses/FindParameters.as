package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class FindParameters extends Object
    {
        public var returnGeometry:Boolean = false;
        public var layerDefinitions:Array;
        public var layerIds:Array;
        public var maxAllowableOffset:Number;
        public var searchFields:Array;
        public var searchText:String;
        public var outSpatialReference:SpatialReference;
        public var contains:Boolean = true;
        public var dynamicLayerInfos:Array;
        public var returnM:Boolean;
        public var returnZ:Boolean;

        public function FindParameters()
        {
            return;
        }// end function

    }
}
