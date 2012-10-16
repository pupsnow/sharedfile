package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;
    import mx.events.*;

    public class FeatureCollection extends EventDispatcher
    {
        private var _150708852featureSet:FeatureSet;
        private var _892258940layerDefinition:LayerDetails;

        public function FeatureCollection(featureSet:FeatureSet = null, layerDefinition:LayerDetails = null)
        {
            this.featureSet = featureSet;
            this.layerDefinition = layerDefinition;
            return;
        }// end function

        public function get featureSet() : FeatureSet
        {
            return this._150708852featureSet;
        }// end function

        public function set featureSet(value:FeatureSet) : void
        {
            arguments = this._150708852featureSet;
            if (arguments !== value)
            {
                this._150708852featureSet = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "featureSet", arguments, value));
                }
            }
            return;
        }// end function

        public function get layerDefinition() : LayerDetails
        {
            return this._892258940layerDefinition;
        }// end function

        public function set layerDefinition(value:LayerDetails) : void
        {
            arguments = this._892258940layerDefinition;
            if (arguments !== value)
            {
                this._892258940layerDefinition = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layerDefinition", arguments, value));
                }
            }
            return;
        }// end function

    }
}
