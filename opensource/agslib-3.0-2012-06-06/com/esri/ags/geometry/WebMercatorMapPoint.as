package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.utils.*;

    public class WebMercatorMapPoint extends MapPoint
    {

        public function WebMercatorMapPoint(lon:Number = 0, lat:Number = 0)
        {
            super(WebMercatorUtil.longitudeToX(lon), WebMercatorUtil.latitudeToY(lat), new SpatialReference(WebMercatorUtil.MER_WKID));
            return;
        }// end function

        public function get lat() : Number
        {
            return WebMercatorUtil.yToLatitude(y);
        }// end function

        public function set lat(value:Number) : void
        {
            y = WebMercatorUtil.latitudeToY(value);
            return;
        }// end function

        public function get lon() : Number
        {
            return WebMercatorUtil.xToLongitude(x);
        }// end function

        public function set lon(value:Number) : void
        {
            x = WebMercatorUtil.longitudeToX(value);
            return;
        }// end function

    }
}
