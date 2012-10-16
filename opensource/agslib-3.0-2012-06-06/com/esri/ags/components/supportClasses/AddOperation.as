package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;

    public class AddOperation extends Object implements IOperation
    {
        private var _feature:Graphic;
        private var _featureLayer:FeatureLayer;

        public function AddOperation(feature:Graphic, featureLayer:FeatureLayer)
        {
            this._feature = feature;
            this._featureLayer = featureLayer;
            return;
        }// end function

        public function performUndo() : void
        {
            var _loc_1:Array = [this._feature];
            this._featureLayer.applyEdits(null, null, _loc_1);
            return;
        }// end function

        public function performRedo() : void
        {
            var _loc_1:Array = [this._feature];
            this._featureLayer.applyEdits(_loc_1, null, null);
            return;
        }// end function

    }
}
