package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.net.*;
    import mx.utils.*;

    public class ImageServiceParameters extends Object
    {
        public var bandIds:Array;
        public var compressionQuality:Number;
        public var extent:Extent;
        public var format:String;
        public var height:Number;
        public var imageSpatialReference:SpatialReference;
        public var interpolation:String;
        public var mosaicRule:MosaicRule;
        public var noData:Number;
        var normalize:Boolean;
        public var renderingRule:RasterFunction;
        public var timeExtent:TimeExtent;
        public var width:Number;
        public static const INTERPOLATION_BILINEAR:String = "RSP_BilinearInterpolation";
        public static const INTERPOLATION_CUBICCONVOLUTION:String = "RSP_CubicConvolution";
        public static const INTERPOLATION_MAJORITY:String = "RSP_Majority";
        public static const INTERPOLATION_NEARESTNEIGHBOR:String = "RSP_NearestNeighbor";

        public function ImageServiceParameters()
        {
            return;
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        function appendToURLVariables(urlVariables:URLVariables) : void
        {
            if (this.extent)
            {
                if (this.normalize)
                {
                    this.extent = this.extent.normalize(true) as Extent;
                }
                urlVariables.bbox = this.extent.xmin + "," + this.extent.ymin + "," + this.extent.xmax + "," + this.extent.ymax;
                if (this.extent.spatialReference)
                {
                    urlVariables.bboxSR = this.extent.spatialReference.toSR();
                }
            }
            if (isFinite(this.width))
            {
                isFinite(this.width);
            }
            if (isFinite(this.height))
            {
                urlVariables.size = this.width + "," + this.height;
            }
            if (this.imageSpatialReference)
            {
                urlVariables.imageSR = this.imageSpatialReference.toSR();
            }
            else
            {
                if (this.extent)
                {
                }
                if (this.extent.spatialReference)
                {
                    urlVariables.imageSR = this.extent.spatialReference.toSR();
                }
            }
            if (this.format)
            {
                urlVariables.format = this.format;
            }
            if (this.interpolation)
            {
                urlVariables.interpolation = this.interpolation;
            }
            if (isFinite(this.compressionQuality))
            {
                urlVariables.compressionQuality = this.compressionQuality;
            }
            if (this.bandIds)
            {
                urlVariables.bandIds = this.bandIds.join();
            }
            if (this.mosaicRule)
            {
                urlVariables.mosaicRule = JSONUtil.encode(this.mosaicRule);
            }
            if (isFinite(this.noData))
            {
                urlVariables.noData = this.noData;
            }
            if (this.renderingRule)
            {
                urlVariables.renderingRule = JSONUtil.encode(this.renderingRule);
            }
            if (this.timeExtent)
            {
                urlVariables.time = this.timeExtent.toTimeParam();
            }
            return;
        }// end function

    }
}
