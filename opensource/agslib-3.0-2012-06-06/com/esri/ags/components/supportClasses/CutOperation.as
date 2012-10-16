package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;

    public class CutOperation extends Object implements IOperation
    {
        private var _undoGeometryArray:Array;
        private var _redoGeometryArray:Array;
        private var _addsUpdates:Array;

        public function CutOperation(undoGeometryArray:Array, redoGeometryArray:Array, addsUpdates:Array)
        {
            this._undoGeometryArray = undoGeometryArray;
            this._redoGeometryArray = redoGeometryArray;
            this._addsUpdates = addsUpdates;
            return;
        }// end function

        public function performUndo() : void
        {
            var _loc_2:Geometry = null;
            var _loc_3:Number = NaN;
            var _loc_1:Number = 0;
            while (_loc_1 < this._addsUpdates.length)
            {
                
                if (this._addsUpdates[_loc_1].update)
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._undoGeometryArray.length)
                    {
                        
                        if (this._undoGeometryArray[_loc_3].feature === this._addsUpdates[_loc_1].feature)
                        {
                            _loc_2 = this._undoGeometryArray[_loc_3].geometry;
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    Graphic(this._addsUpdates[_loc_1].feature).geometry = _loc_2;
                    FeatureLayer(this._addsUpdates[_loc_1].featureLayer).applyEdits(null, [this._addsUpdates[_loc_1].feature], null);
                }
                else
                {
                    FeatureLayer(this._addsUpdates[_loc_1].featureLayer).applyEdits(null, null, [this._addsUpdates[_loc_1].feature]);
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function performRedo() : void
        {
            var _loc_2:Geometry = null;
            var _loc_3:Number = NaN;
            var _loc_1:Number = 0;
            while (_loc_1 < this._addsUpdates.length)
            {
                
                if (this._addsUpdates[_loc_1].update)
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._redoGeometryArray.length)
                    {
                        
                        if (this._redoGeometryArray[_loc_3].feature === this._addsUpdates[_loc_1].feature)
                        {
                            _loc_2 = this._redoGeometryArray[_loc_3].geometry;
                            break;
                            continue;
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    Graphic(this._addsUpdates[_loc_1].feature).geometry = _loc_2;
                    FeatureLayer(this._addsUpdates[_loc_1].featureLayer).applyEdits(null, [this._addsUpdates[_loc_1].feature], null);
                }
                else
                {
                    FeatureLayer(this._addsUpdates[_loc_1].featureLayer).applyEdits([this._addsUpdates[_loc_1].feature], null, null);
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

    }
}
