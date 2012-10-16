package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    final public class UpdateFeatureTypeEvent extends Event
    {
        public var featureLayer:FeatureLayer;
        public var graphic:Graphic;
        public var field:Field;
        public var featureType:FeatureType;
        public static const UPDATE_FEATURE_TYPE:String = "updateFeatureType";

        public function UpdateFeatureTypeEvent()
        {
            super(UPDATE_FEATURE_TYPE, true);
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new UpdateFeatureTypeEvent();
            _loc_1.featureLayer = this.featureLayer;
            _loc_1.graphic = this.graphic;
            _loc_1.field = this.field;
            _loc_1.featureType = this.featureType;
            return _loc_1;
        }// end function

    }
}
