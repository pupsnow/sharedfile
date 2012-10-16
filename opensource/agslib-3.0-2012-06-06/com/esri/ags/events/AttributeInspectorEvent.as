package com.esri.ags.events
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    final public class AttributeInspectorEvent extends Event
    {
        public var feature:Graphic;
        public var featureLayer:FeatureLayer;
        public var field:Field;
        public var newValue:Object;
        public var oldValue:Object;
        public static const DELETE_FEATURE:String = "deleteFeature";
        public static const SAVE_FEATURE:String = "saveFeature";
        public static const SHOW_FEATURE:String = "showFeature";
        public static const UPDATE_FEATURE:String = "updateFeature";

        public function AttributeInspectorEvent(type:String, bubbles:Boolean, featureLayer:FeatureLayer = null, feature:Graphic = null, field:Field = null, oldValue:Object = null, newValue:Object = null)
        {
            super(type, bubbles);
            this.featureLayer = featureLayer;
            this.feature = feature;
            this.field = field;
            this.oldValue = oldValue;
            this.newValue = newValue;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AttributeInspectorEvent(type, bubbles, this.featureLayer, this.feature, this.field, this.oldValue, this.newValue);
        }// end function

    }
}
