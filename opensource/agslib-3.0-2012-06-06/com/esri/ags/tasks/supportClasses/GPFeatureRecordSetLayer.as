package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;

    public class GPFeatureRecordSetLayer extends Object
    {
        public var geometryType:String;
        public var spatialReference:SpatialReference;
        public var features:Array;
        public var exceededTransferLimit:Boolean;
        public var fields:Array;
        public var hasM:Boolean;
        public var hasZ:Boolean;

        public function GPFeatureRecordSetLayer()
        {
            return;
        }// end function

    }
}
