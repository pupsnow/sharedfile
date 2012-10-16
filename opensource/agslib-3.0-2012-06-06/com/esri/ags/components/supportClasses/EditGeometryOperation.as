package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.tools.*;

    public class EditGeometryOperation extends Object implements IOperation
    {
        public var feature:Graphic;
        public var featureLayer:FeatureLayer;
        public var restoreEditTool:Boolean;
        private var _undoGeometry:Geometry;
        private var _redoGeometry:Geometry;
        private var _editTool:EditTool;
        private var _lastActiveEdit:String;

        public function EditGeometryOperation(undoGeometry:Geometry, redoGeometry:Geometry, editFeature:Graphic, editFeatureLayer:FeatureLayer, editTool:EditTool, lastActiveEdit:String)
        {
            this.feature = editFeature;
            this.featureLayer = editFeatureLayer;
            this._undoGeometry = undoGeometry;
            this._redoGeometry = redoGeometry;
            this._editTool = editTool;
            this._lastActiveEdit = lastActiveEdit;
            return;
        }// end function

        public function performUndo() : void
        {
            this.feature.geometry = this._undoGeometry;
            this.updateGeometry();
            return;
        }// end function

        public function performRedo() : void
        {
            this.feature.geometry = this._redoGeometry;
            this.updateGeometry();
            return;
        }// end function

        private function updateGeometry() : void
        {
            this.featureLayer.applyEdits(null, [this.feature], null);
            if (this.restoreEditTool)
            {
                if (!(this.feature.geometry is Polyline))
                {
                }
                if (this.feature.geometry is Polygon)
                {
                    if (this._lastActiveEdit == "moveEditVertices")
                    {
                        this._editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.feature]);
                    }
                    else
                    {
                        this._editTool.activate(EditTool.MOVE | EditTool.SCALE | EditTool.ROTATE, [this.feature]);
                    }
                }
                else
                {
                    this._editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.feature]);
                }
            }
            return;
        }// end function

    }
}
