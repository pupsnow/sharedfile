package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;

    public class ImageServiceIdentifyParameters extends Object
    {
        public var geometry:Geometry;
        public var mosaicRule:MosaicRule;
        public var pixelSizeX:Number;
        public var pixelSizeY:Number;

        public function ImageServiceIdentifyParameters()
        {
            return;
        }// end function

    }
}
