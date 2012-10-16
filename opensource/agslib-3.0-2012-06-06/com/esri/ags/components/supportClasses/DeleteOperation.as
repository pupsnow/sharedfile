package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.*;

    public class DeleteOperation extends Object implements IOperation
    {
        private var _featuresDeleted:Array;

        public function DeleteOperation(featuresDeleted:Array)
        {
            this._featuresDeleted = featuresDeleted;
            return;
        }// end function

        public function performUndo() : void
        {
            var _loc_1:Number = 0;
            while (_loc_1 < this._featuresDeleted.length)
            {
                
                FeatureLayer(this._featuresDeleted[_loc_1].featureLayer).applyEdits(this._featuresDeleted[_loc_1].selectedFeatures, null, null);
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function performRedo() : void
        {
            var _loc_1:Number = 0;
            while (_loc_1 < this._featuresDeleted.length)
            {
                
                FeatureLayer(this._featuresDeleted[_loc_1].featureLayer).applyEdits(null, null, this._featuresDeleted[_loc_1].selectedFeatures);
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

    }
}
