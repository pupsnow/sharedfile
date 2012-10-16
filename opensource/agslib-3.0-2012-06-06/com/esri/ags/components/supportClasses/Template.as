package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;

    public class Template extends EventDispatcher
    {
        public var featureLayer:FeatureLayer;
        public var featureType:FeatureType;
        public var featureTemplate:FeatureTemplate;
        public var symbol:Symbol;

        public function Template()
        {
            return;
        }// end function

    }
}
