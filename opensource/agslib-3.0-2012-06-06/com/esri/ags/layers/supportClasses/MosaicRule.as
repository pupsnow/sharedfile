package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.geometry.*;

    public class MosaicRule extends Object implements IJSONSupport
    {
        public var ascending:Boolean = false;
        public var lockRasterIds:Array;
        public var method:String;
        public var objectIds:Array;
        public var operation:String;
        public var sortField:String;
        public var sortValue:Object;
        public var viewpoint:MapPoint;
        public var where:String;
        public static const METHOD_NONE:String = "esriMosaicNone";
        public static const METHOD_CENTER:String = "esriMosaicCenter";
        public static const METHOD_NADIR:String = "esriMosaicNadir";
        public static const METHOD_VIEWPOINT:String = "esriMosaicViewpoint";
        public static const METHOD_ATTRIBUTE:String = "esriMosaicAttribute";
        public static const METHOD_LOCK_RASTER:String = "esriMosaicLockRaster";
        public static const METHOD_NORTHWEST:String = "esriMosaicNorthwest";
        public static const METHOD_SEAMLINE:String = "esriMosaicSeamline";
        public static const OPERATION_FIRST:String = "MT_FIRST";
        public static const OPERATION_LAST:String = "MT_LAST";
        public static const OPERATION_MIN:String = "MT_MIN";
        public static const OPERATION_MAX:String = "MT_MAX";
        public static const OPERATION_MEAN:String = "MT_MEAN";
        public static const OPERATION_BLEND:String = "MT_BLEND";

        public function MosaicRule()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {ascending:this.ascending, mosaicMethod:this.method, mosaicOperation:this.operation, sortField:this.sortField, sortValue:this.sortValue, where:this.where};
            for (key in _loc_2)
            {
                
                if (_loc_2[key] == null)
                {
                    delete _loc_2[key];
                }
            }
            if (this.lockRasterIds)
            {
                _loc_2.lockRasterIds = this.lockRasterIds.concat();
            }
            if (this.objectIds)
            {
                _loc_2.fids = this.objectIds.concat();
            }
            if (this.viewpoint)
            {
                _loc_2.viewpoint = this.viewpoint.toJSON();
            }
            return _loc_2;
        }// end function

    }
}
