package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.*;

    public class MergeOperation extends Object implements IOperation
    {
        private var _adds:Array;
        private var _deletes:Array;
        private var _addsFeatureLayer:FeatureLayer;
        private var _deleteFeaturesArray:Array;

        public function MergeOperation(adds:Array, deletes:Array, addsFeatureLayer:FeatureLayer, deleteFeaturesArray:Array)
        {
            this._adds = adds;
            this._deletes = deletes;
            this._addsFeatureLayer = addsFeatureLayer;
            this._deleteFeaturesArray = deleteFeaturesArray;
            return;
        }// end function

        public function performUndo() : void
        {
            var _loc_1:Number = NaN;
            if (this._deleteFeaturesArray.length == 1)
            {
                this._addsFeatureLayer.applyEdits(this._deletes, null, this._adds);
            }
            else
            {
                this._addsFeatureLayer.applyEdits(null, null, this._adds);
                _loc_1 = 0;
                while (_loc_1 < this._deleteFeaturesArray.length)
                {
                    
                    FeatureLayer(this._deleteFeaturesArray[_loc_1].featureLayer).applyEdits(this._deleteFeaturesArray[_loc_1].selectedFeatures as Array, null, null);
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

        public function performRedo() : void
        {
            var _loc_1:Number = NaN;
            if (this._deleteFeaturesArray.length == 1)
            {
                this._addsFeatureLayer.applyEdits(this._adds, null, this._deletes);
            }
            else
            {
                this._addsFeatureLayer.applyEdits(this._adds, null, null);
                _loc_1 = 0;
                while (_loc_1 < this._deleteFeaturesArray.length)
                {
                    
                    FeatureLayer(this._deleteFeaturesArray[_loc_1].featureLayer).applyEdits(null, null, this._deleteFeaturesArray[_loc_1].selectedFeatures as Array);
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

    }
}
