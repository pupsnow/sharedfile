package com.esri.ags.geometry
{
    import com.esri.ags.*;
    import com.esri.ags.utils.*;
    import mx.events.*;

    public class WebMercatorExtent extends Extent
    {

        public function WebMercatorExtent(minlon:Number = 0, minlat:Number = 0, maxlon:Number = 0, maxlat:Number = 0)
        {
            super(WebMercatorUtil.longitudeToX(minlon), WebMercatorUtil.latitudeToY(minlat), WebMercatorUtil.longitudeToX(maxlon), WebMercatorUtil.latitudeToY(maxlat), new SpatialReference(WebMercatorUtil.MER_WKID));
            return;
        }// end function

        public function get maxlat() : Number
        {
            return WebMercatorUtil.yToLatitude(ymax);
        }// end function

        private function set _1081126469maxlat(value:Number) : void
        {
            ymax = WebMercatorUtil.latitudeToY(value);
            return;
        }// end function

        public function get maxlon() : Number
        {
            return WebMercatorUtil.xToLongitude(xmax);
        }// end function

        private function set _1081126041maxlon(value:Number) : void
        {
            xmax = WebMercatorUtil.longitudeToX(value);
            return;
        }// end function

        public function get minlat() : Number
        {
            return WebMercatorUtil.yToLatitude(ymin);
        }// end function

        private function set _1074036211minlat(value:Number) : void
        {
            ymin = WebMercatorUtil.latitudeToY(value);
            return;
        }// end function

        public function get minlon() : Number
        {
            return WebMercatorUtil.xToLongitude(xmin);
        }// end function

        private function set _1074035783minlon(value:Number) : void
        {
            xmin = WebMercatorUtil.longitudeToX(value);
            return;
        }// end function

        public function set minlat(value:Number) : void
        {
            arguments = this.minlat;
            if (arguments !== value)
            {
                this._1074036211minlat = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minlat", arguments, value));
                }
            }
            return;
        }// end function

        public function set maxlat(value:Number) : void
        {
            arguments = this.maxlat;
            if (arguments !== value)
            {
                this._1081126469maxlat = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxlat", arguments, value));
                }
            }
            return;
        }// end function

        public function set maxlon(value:Number) : void
        {
            arguments = this.maxlon;
            if (arguments !== value)
            {
                this._1081126041maxlon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxlon", arguments, value));
                }
            }
            return;
        }// end function

        public function set minlon(value:Number) : void
        {
            arguments = this.minlon;
            if (arguments !== value)
            {
                this._1074035783minlon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minlon", arguments, value));
                }
            }
            return;
        }// end function

    }
}
