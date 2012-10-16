package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import mx.rpc.*;

    public class EditAttributesOperation extends Object implements IOperation
    {
        public var feature:Graphic;
        public var restoreAttributeInspector:Boolean;
        private var _arrayChangedAttributes:Array;
        private var _featureLayer:FeatureLayer;
        private var _attributeInspector:AttributeInspector;

        public function EditAttributesOperation(editFeature:Graphic, arrayChangedAttributes:Array, attributeInspector:AttributeInspector)
        {
            this.feature = editFeature;
            this._arrayChangedAttributes = arrayChangedAttributes;
            this._featureLayer = FeatureLayer(this.feature.graphicsLayer);
            this._attributeInspector = attributeInspector;
            return;
        }// end function

        public function performUndo() : void
        {
            var _loc_4:Object = null;
            var _loc_5:Graphic = null;
            var _loc_6:Array = null;
            if (this.restoreAttributeInspector)
            {
                this.feature = this._attributeInspector.activeFeature;
            }
            var _loc_1:Object = {};
            var _loc_2:* = this._featureLayer.layerDetails.objectIdField;
            _loc_1[_loc_2] = this.feature.attributes[_loc_2];
            var _loc_3:Array = [];
            for each (_loc_4 in this._arrayChangedAttributes)
            {
                
                _loc_1[_loc_4.field.name] = _loc_4.oldValue;
                _loc_3.push({field:_loc_4.field, value:this.feature.attributes[_loc_4.field]});
                this.feature.attributes[_loc_4.field.name] = _loc_4.oldValue;
            }
            _loc_5 = new Graphic(null, null, _loc_1);
            _loc_6 = [_loc_5];
            this._featureLayer.applyEdits(null, _loc_6, null, false, new AsyncResponder(this.undoattributeInspector_editsCompleteHandler, this.undoattributeInspector_faultHandler, {currentAttributes:_loc_3}));
            return;
        }// end function

        public function performRedo() : void
        {
            var _loc_4:Object = null;
            var _loc_5:Graphic = null;
            var _loc_6:Array = null;
            if (this.restoreAttributeInspector)
            {
                this.feature = this._attributeInspector.activeFeature;
            }
            var _loc_1:Object = {};
            var _loc_2:* = this._featureLayer.layerDetails.objectIdField;
            _loc_1[_loc_2] = this.feature.attributes[_loc_2];
            var _loc_3:Array = [];
            for each (_loc_4 in this._arrayChangedAttributes)
            {
                
                _loc_1[_loc_4.field.name] = _loc_4.newValue;
                _loc_3.push({field:_loc_4.field, value:this.feature.attributes[_loc_4.field]});
                this.feature.attributes[_loc_4.field.name] = _loc_4.newValue;
            }
            _loc_5 = new Graphic(null, null, _loc_1);
            _loc_6 = [_loc_5];
            this._featureLayer.applyEdits(null, _loc_6, null, false, new AsyncResponder(this.undoattributeInspector_editsCompleteHandler, this.undoattributeInspector_faultHandler, {currentAttributes:_loc_3}));
            return;
        }// end function

        private function undoattributeInspector_editsCompleteHandler(featureEditResults:FeatureEditResults, token:Object = null) : void
        {
            var _loc_3:FeatureEditResult = null;
            var _loc_4:Object = null;
            for each (_loc_3 in featureEditResults.updateResults)
            {
                
                if (_loc_3.success === false)
                {
                    for each (_loc_4 in token.currentAttributes)
                    {
                        
                        this.feature.attributes[_loc_4.field.name] = _loc_4.value;
                    }
                    this.feature.refresh();
                    if (this.restoreAttributeInspector)
                    {
                        this._attributeInspector.refreshActiveFeature();
                    }
                    continue;
                }
                this.feature.refresh();
                if (this.restoreAttributeInspector)
                {
                    this._attributeInspector.refresh();
                }
            }
            return;
        }// end function

        private function undoattributeInspector_faultHandler(fault:Fault, token:Object = null) : void
        {
            return;
        }// end function

    }
}
