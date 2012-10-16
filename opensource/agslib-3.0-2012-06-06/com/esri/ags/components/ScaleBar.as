package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import mx.events.*;
    import mx.utils.*;
    import spark.components.supportClasses.*;

    public class ScaleBar extends SkinnableComponent
    {
        private var m_dirty:Boolean = false;
        private var m_widthRelativeToMapWidth:Number = 0.2;
        private var _877021045textUS:String;
        private var _1666306365textMetric:String;
        private var _1936401412lengthUS:Number = 0;
        private var _1258366922lengthMetric:Number = 0;
        private var m_map:Map;

        public function ScaleBar()
        {
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }// end function

        public function get map() : Map
        {
            return this.m_map;
        }// end function

        private function set _107868map(value:Map) : void
        {
            if (this.m_map)
            {
                this.m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
                this.m_map.removeEventListener(ResizeEvent.RESIZE, this.map_resizeHandler);
                this.m_map.removeEventListener(MapEvent.LOAD, this.map_loadHandler);
            }
            this.m_map = value;
            if (this.m_map)
            {
                this.m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler, false, 0, true);
                this.m_map.addEventListener(ResizeEvent.RESIZE, this.map_resizeHandler, false, 0, true);
                this.m_map.addEventListener(MapEvent.LOAD, this.map_loadHandler, false, 0, true);
            }
            return;
        }// end function

        override protected function attachSkin() : void
        {
            super.attachSkin();
            if (skin)
            {
                if (this.m_map)
                {
                }
                if (this.m_map.loaded === false)
                {
                    var _loc_1:Boolean = false;
                    skin.includeInLayout = false;
                    skin.visible = _loc_1;
                }
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Number = NaN;
            super.commitProperties();
            if (this.m_dirty)
            {
                this.m_dirty = false;
                if (this.m_map.loaded)
                {
                }
                if (this.m_map.scale > 0)
                {
                    _loc_1 = this.calcScale();
                    this.lengthUS = this.getAmericanWidth(_loc_1);
                    this.lengthMetric = this.getMetricWidth(_loc_1);
                    if (skin)
                    {
                        skin.invalidateSize();
                    }
                }
                else
                {
                    this.lengthUS = 0;
                    this.lengthMetric = 0;
                }
            }
            return;
        }// end function

        override public function setVisible(value:Boolean, noEvent:Boolean = false) : void
        {
            super.setVisible(value, noEvent);
            if (value)
            {
                this.m_dirty = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function calcNiceScale(metersPerPixel:Number, widthInPixels:Number) : Number
        {
            var _loc_3:* = metersPerPixel * widthInPixels;
            var _loc_4:* = Math.log(_loc_3) / Math.log(10);
            var _loc_5:* = Math.floor(_loc_4);
            var _loc_6:* = Math.pow(10, _loc_5);
            var _loc_7:* = _loc_3 / _loc_6;
            var _loc_8:Number = 0.1;
            if (_loc_7 < 0.2)
            {
                _loc_8 = 0.1;
            }
            else if (_loc_7 < 0.3)
            {
                _loc_8 = 0.2;
            }
            else if (_loc_7 < 0.4)
            {
                _loc_8 = 0.3;
            }
            else if (_loc_7 < 0.5)
            {
                _loc_8 = 0.4;
            }
            else if (_loc_7 < 1)
            {
                _loc_8 = 0.5;
            }
            else if (_loc_7 < 2)
            {
                _loc_8 = 1;
            }
            else if (_loc_7 < 3)
            {
                _loc_8 = 2;
            }
            else if (_loc_7 < 4)
            {
                _loc_8 = 3;
            }
            else if (_loc_7 < 5)
            {
                _loc_8 = 4;
            }
            else if (_loc_7 < 10)
            {
                _loc_8 = 5;
            }
            else
            {
                _loc_8 = 10;
            }
            return _loc_6 * _loc_8;
        }// end function

        private function calcScale() : Number
        {
            var _loc_1:* = this.m_map.scale;
            var _loc_2:* = this.m_map.extent.center;
            var _loc_3:* = this.m_map.spatialReference;
            if (!_loc_3)
            {
                return _loc_1;
            }
            if (_loc_3.toMeterFactor == ProjUtils.DECDEG_PER_METER)
            {
                _loc_1 = _loc_1 * Math.cos(ProjUtils.DDToRad(Math.min(ProjUtils.PI_OVER_2_MINUS_EPSILON_DEG, Math.abs(_loc_2.y))));
            }
            else
            {
                if (_loc_3.toMeterFactor == 1)
                {
                }
                if (this.m_map.spatialReference)
                {
                }
                if (this.m_map.spatialReference.isWebMercator())
                {
                    _loc_2 = WebMercatorUtil.webMercatorToGeographic(_loc_2) as MapPoint;
                    _loc_1 = _loc_1 * Math.cos(ProjUtils.DDToRad(Math.min(ProjUtils.PI_OVER_2_MINUS_EPSILON_DEG, Math.abs(_loc_2.y))));
                }
            }
            return _loc_1;
        }// end function

        private function getMetricWidth(scale:Number) : Number
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:Number = 0;
            _loc_3 = this.m_map.width * this.m_widthRelativeToMapWidth;
            _loc_5 = scale / ProjUtils.PIXELS_PER_METER;
            if (_loc_5 * _loc_3 < 800)
            {
                _loc_4 = this.calcNiceScale(_loc_5, _loc_3);
                _loc_2 = Math.round(_loc_4 / _loc_5);
                this.textMetric = StringUtil.substitute(resourceManager.getString("ESRIMessages", "scaleBarMeters"), Math.floor(_loc_4).toString());
            }
            else
            {
                _loc_4 = this.calcNiceScale(_loc_5 / 1000, _loc_3);
                _loc_2 = Math.round(_loc_4 * 1000 / _loc_5);
                this.textMetric = StringUtil.substitute(resourceManager.getString("ESRIMessages", "scaleBarKilometers"), Math.max(Math.floor(_loc_4), 0.5).toString());
            }
            return _loc_2;
        }// end function

        private function getAmericanWidth(scale:Number) : Number
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:Number = 0;
            _loc_3 = this.m_map.width * this.m_widthRelativeToMapWidth;
            _loc_5 = scale / ProjUtils.PIXELS_PER_METER;
            if (_loc_5 * _loc_3 < 800)
            {
                _loc_5 = _loc_5 * 39.37 / 12;
                _loc_4 = this.calcNiceScale(_loc_5, _loc_3);
                _loc_2 = Math.round(_loc_4 / _loc_5);
                this.textUS = StringUtil.substitute(resourceManager.getString("ESRIMessages", "scaleBarFeet"), Math.floor(_loc_4).toString());
            }
            else
            {
                _loc_5 = _loc_5 * 39.37 / (12 * 5280);
                _loc_4 = this.calcNiceScale(_loc_5, _loc_3);
                _loc_2 = Math.round(_loc_4 / _loc_5);
                this.textUS = StringUtil.substitute(resourceManager.getString("ESRIMessages", "scaleBarMiles"), Math.max(Math.floor(_loc_4), 0.5).toString());
            }
            return _loc_2;
        }// end function

        private function map_extentChangeHandler(event:ExtentEvent) : void
        {
            this.m_dirty = true;
            invalidateProperties();
            return;
        }// end function

        private function map_loadHandler(event:MapEvent) : void
        {
            this.m_map.removeEventListener(MapEvent.LOAD, this.map_loadHandler);
            if (skin)
            {
                var _loc_2:Boolean = true;
                skin.includeInLayout = true;
                skin.visible = _loc_2;
            }
            this.m_dirty = true;
            invalidateProperties();
            return;
        }// end function

        private function map_resizeHandler(event:ResizeEvent) : void
        {
            this.m_dirty = true;
            invalidateProperties();
            return;
        }// end function

        public function get textUS() : String
        {
            return this._877021045textUS;
        }// end function

        public function set textUS(value:String) : void
        {
            arguments = this._877021045textUS;
            if (arguments !== value)
            {
                this._877021045textUS = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "textUS", arguments, value));
                }
            }
            return;
        }// end function

        public function get textMetric() : String
        {
            return this._1666306365textMetric;
        }// end function

        public function set textMetric(value:String) : void
        {
            arguments = this._1666306365textMetric;
            if (arguments !== value)
            {
                this._1666306365textMetric = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "textMetric", arguments, value));
                }
            }
            return;
        }// end function

        public function get lengthUS() : Number
        {
            return this._1936401412lengthUS;
        }// end function

        public function set lengthUS(value:Number) : void
        {
            arguments = this._1936401412lengthUS;
            if (arguments !== value)
            {
                this._1936401412lengthUS = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lengthUS", arguments, value));
                }
            }
            return;
        }// end function

        public function get lengthMetric() : Number
        {
            return this._1258366922lengthMetric;
        }// end function

        public function set lengthMetric(value:Number) : void
        {
            arguments = this._1258366922lengthMetric;
            if (arguments !== value)
            {
                this._1258366922lengthMetric = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lengthMetric", arguments, value));
                }
            }
            return;
        }// end function

        public function set map(value:Map) : void
        {
            arguments = this.map;
            if (arguments !== value)
            {
                this._107868map = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "map", arguments, value));
                }
            }
            return;
        }// end function

    }
}
