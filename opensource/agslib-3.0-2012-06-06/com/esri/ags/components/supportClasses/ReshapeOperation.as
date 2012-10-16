package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;

    public class ReshapeOperation extends Object implements IOperation
    {
        private var _feature:Graphic;
        private var _featureLayer:FeatureLayer;
        private var _undoGeometry:Geometry;
        private var _redoGeometry:Geometry;

        public function ReshapeOperation(feature:Graphic, featureLayer:FeatureLayer, undoGeometry:Geometry, redoGeometry:Geometry)
        {
            this._feature = feature;
            this._featureLayer = featureLayer;
            this._undoGeometry = undoGeometry;
            this._redoGeometry = redoGeometry;
            return;
        }// end function

        public function performUndo() : void
        {
            this._feature.geometry = this._undoGeometry;
            this._featureLayer.applyEdits(null, [this._feature], null);
            return;
        }// end function

        public function performRedo() : void
        {
            this._feature.geometry = this._redoGeometry;
            this._featureLayer.applyEdits(null, [this._feature], null);
            return;
        }// end function

    }
}
