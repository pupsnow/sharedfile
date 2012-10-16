package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class FormDescriptor extends EventDispatcher
    {
        private var m_features:Array;
        private var m_featureLayer:FeatureLayer;
        private var m_activeFeature:Graphic = null;
        private var m_activeFeatureType:FeatureType = null;
        private var m_updateEnabled:Boolean = false;
        private var m_singleToMultilineThreshold:int = 40;

        public function FormDescriptor(featureLayer:FeatureLayer)
        {
            this.m_features = [];
            this.m_featureLayer = featureLayer;
            return;
        }// end function

        public function get featureLayer() : FeatureLayer
        {
            return this.m_featureLayer;
        }// end function

        public function get activeFeature() : Graphic
        {
            return this.m_activeFeature;
        }// end function

        public function get activeFeatureIndex() : int
        {
            var _loc_1:int = -1;
            if (this.m_features.length > 0)
            {
            }
            if (this.m_activeFeature)
            {
                _loc_1 = this.m_features.indexOf(this.m_activeFeature);
            }
            return _loc_1;
        }// end function

        public function get activeFeatureType() : FeatureType
        {
            return this.m_activeFeatureType;
        }// end function

        public function set activeFeatureType(value:FeatureType) : void
        {
            if (this.m_activeFeatureType != value)
            {
                this.m_activeFeatureType = value;
                dispatchEvent(new FormFieldEvent(FormFieldEvent.RENDERER_CHANGE));
            }
            return;
        }// end function

        public function get numFeatures() : int
        {
            return this.m_features.length;
        }// end function

        public function get hasFeatures() : Boolean
        {
            return this.numFeatures > 0;
        }// end function

        public function get updateEnabled() : Boolean
        {
            return this.m_updateEnabled;
        }// end function

        public function set updateEnabled(value:Boolean) : void
        {
            if (this.m_updateEnabled !== value)
            {
                this.m_updateEnabled = value;
                dispatchEvent(new FormFieldEvent(FormFieldEvent.RENDERER_CHANGE));
            }
            return;
        }// end function

        public function get singleToMultilineThreshold() : int
        {
            return this.m_singleToMultilineThreshold;
        }// end function

        public function set singleToMultilineThreshold(value:int) : void
        {
            if (this.m_singleToMultilineThreshold !== value)
            {
                this.m_singleToMultilineThreshold = value;
                dispatchEvent(new FormFieldEvent(FormFieldEvent.RENDERER_CHANGE));
            }
            return;
        }// end function

        public function selectFeature(featureIndex:int) : void
        {
            if (featureIndex !== this.activeFeatureIndex)
            {
                if (featureIndex >= 0)
                {
                }
                if (featureIndex >= this.numFeatures)
                {
                    this.m_activeFeature = null;
                }
                else
                {
                    this.m_activeFeature = this.m_features[featureIndex];
                }
                this.updateFeatureType();
                dispatchEvent(new FormFieldEvent(FormFieldEvent.DATA_CHANGE));
            }
            return;
        }// end function

        public function unselectFeature() : void
        {
            this.selectFeature(-1);
            return;
        }// end function

        public function addFeature(feature:Graphic) : void
        {
            if (!this.contains(feature))
            {
                this.m_features.push(feature);
            }
            return;
        }// end function

        public function removeFeature(graphic:Graphic) : void
        {
            var _loc_2:* = this.indexOf(graphic);
            if (_loc_2 > -1)
            {
                this.m_features.splice(_loc_2, 1);
                if (graphic === this.activeFeature)
                {
                    this.selectFeature(0);
                }
            }
            return;
        }// end function

        public function removeFeatureById(objectId:Number) : void
        {
            var _loc_3:Graphic = null;
            var _loc_2:* = this.objectIdField;
            for each (_loc_3 in this.m_features)
            {
                
                if (_loc_3.attributes[_loc_2] === objectId)
                {
                    this.removeFeature(_loc_3);
                    return;
                }
            }
            return;
        }// end function

        public function removeAllFeatures() : void
        {
            this.m_features.length = 0;
            this.m_activeFeature = null;
            this.m_activeFeatureType = null;
            return;
        }// end function

        public function contains(feature:Graphic) : Boolean
        {
            return this.m_features.lastIndexOf(feature) != -1;
        }// end function

        public function indexOf(feature:Graphic) : int
        {
            return this.m_features.indexOf(feature);
        }// end function

        private function updateFeatureType() : void
        {
            var _loc_2:Array = null;
            var _loc_3:FeatureType = null;
            this.m_activeFeatureType = null;
            var _loc_1:* = this.featureLayer.typeIdField;
            if (this.activeFeature)
            {
            }
            if (_loc_1)
            {
                _loc_2 = this.featureLayer.types;
                for each (_loc_3 in _loc_2)
                {
                    
                    if (_loc_3.id == this.activeFeature.attributes[_loc_1])
                    {
                        this.m_activeFeatureType = _loc_3;
                    }
                }
            }
            return;
        }// end function

        private function get objectIdField() : String
        {
            var _loc_1:String = null;
            if (this.featureLayer.layerDetails)
            {
                _loc_1 = this.featureLayer.layerDetails.objectIdField;
            }
            else if (this.featureLayer.tableDetails)
            {
                _loc_1 = this.featureLayer.tableDetails.objectIdField;
            }
            else
            {
                throw new Error("Cannot find an OBJECTID field");
            }
            return _loc_1;
        }// end function

    }
}
