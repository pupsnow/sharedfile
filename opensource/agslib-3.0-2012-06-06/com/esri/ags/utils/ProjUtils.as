package com.esri.ags.utils
{
    import com.esri.ags.geometry.*;

    public class ProjUtils extends Object
    {
        public static const TINY:Number = 1e-013;
        public static const HUGE:Number = 1e+030;
        public static const PI_PLUS_TINY:Number = 3.14159;
        public static const TWO_PI:Number = 6.28319;
        public static const PI_OVER_180:Number = 0.0174533;
        public static const ONE_EIGHTY_OVER_PI:Number = 57.2958;
        public static const DEGREE:Number = 0.0174533;
        public static const PI_OVER_2:Number = 1.5708;
        public static const PI_OVER_4:Number = 0.785398;
        public static const FIVE_EIGHTHS_PI:Number = 1.9635;
        public static const EARTH_RADIUS_IN_METERS:Number = 6371000;
        public static const METERS_PER_DEGREE:Number = 111195;
        public static const INCHES_PER_METER:Number = 39.3701;
        public static const PIXELS_PER_METER:Number = 3779.53;
        public static const PIXELS_PER_DEGREE:Number = 4.20264e+008;
        public static const PI_OVER_2_MINUS_EPSILON_DEG:Number = 89.999;
        public static const PI_OVER_2_MINUS_EPSILON_RAD:Number = 1.57078;
        public static const MINIMUM_WIDTH:Number = 1e-007;
        public static const DECDEG_PER_METER:Number = 111195;

        public function ProjUtils()
        {
            return;
        }// end function

        public static function convertScaleToMetersPerPixel(scale:Number) : Number
        {
            return scale / PIXELS_PER_METER;
        }// end function

        public static function convertScaleToDegreesPerPixel(scale:Number) : Number
        {
            return scale / PIXELS_PER_DEGREE;
        }// end function

        public static function convertDegreesPerPixelToScale(degreesPerPixel:Number) : Number
        {
            return degreesPerPixel * PIXELS_PER_DEGREE;
        }// end function

        public static function DDToRad(decDegrees:Number) : Number
        {
            return decDegrees * PI_OVER_180;
        }// end function

        public static function RadToDD(radians:Number) : Number
        {
            return radians / PI_OVER_180;
        }// end function

        public static function DD2Rad(point:MapPoint) : MapPoint
        {
            point.x = DDToRad(point.x);
            point.y = DDToRad(point.y);
            return point;
        }// end function

        public static function convertExtentToScale(extent:Extent, widthInPixels:Number, screenDPI:uint) : Number
        {
            if (extent != null)
            {
            }
            if (extent.spatialReference == null)
            {
                return 0;
            }
            return extent.width / widthInPixels * extent.spatialReference.toMeterFactor * 39.37 * screenDPI;
        }// end function

        public static function getExtentWidthForScale(scale:Number, extent:Extent, widthInPixels:Number, screenDPI:uint) : Number
        {
            return scale * widthInPixels / (39.37 * screenDPI * extent.spatialReference.toMeterFactor);
        }// end function

    }
}
