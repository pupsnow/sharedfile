package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.renderers.*;
    import com.esri.ags.utils.*;
    import flash.events.*;

    public class LayerDrawingOptions extends EventDispatcher implements IJSONSupport
    {
        private var _alpha:Number;
        private var _labelClasses:Array;
        private var _layerId:Number;
        private var _renderer:IRenderer;
        private var _scaleSymbols:Boolean;
        private var _scaleSymbolsSet:Boolean;
        private var _showLabels:Boolean;
        private var _showLabelsSet:Boolean;

        public function LayerDrawingOptions()
        {
            return;
        }// end function

        public function get alpha() : Number
        {
            return this._alpha;
        }// end function

        public function set alpha(value:Number) : void
        {
            if (this._alpha !== value)
            {
                this._alpha = value;
                dispatchEvent(new Event("alphaChanged"));
            }
            return;
        }// end function

        public function get labelClasses() : Array
        {
            return this._labelClasses;
        }// end function

        public function set labelClasses(value:Array) : void
        {
            this._labelClasses = value;
            dispatchEvent(new Event("labelClassesChanged"));
            return;
        }// end function

        public function get layerId() : Number
        {
            return this._layerId;
        }// end function

        public function set layerId(value:Number) : void
        {
            if (this._layerId !== value)
            {
                this._layerId = value;
                dispatchEvent(new Event("layerIdChanged"));
            }
            return;
        }// end function

        public function get renderer() : IRenderer
        {
            return this._renderer;
        }// end function

        public function set renderer(value:IRenderer) : void
        {
            this._renderer = value;
            dispatchEvent(new Event("rendererChanged"));
            return;
        }// end function

        public function get scaleSymbols() : Boolean
        {
            return this._scaleSymbols;
        }// end function

        public function set scaleSymbols(value:Boolean) : void
        {
            this._scaleSymbolsSet = true;
            if (this._scaleSymbols !== value)
            {
                this._scaleSymbols = value;
                dispatchEvent(new Event("scaleSymbolsChanged"));
            }
            return;
        }// end function

        public function get showLabels() : Boolean
        {
            return this._showLabels;
        }// end function

        public function set showLabels(value:Boolean) : void
        {
            this._showLabelsSet = true;
            if (this._showLabels !== value)
            {
                this._showLabels = value;
                dispatchEvent(new Event("showLabelsChanged"));
            }
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (isFinite(this.alpha))
            {
                _loc_2.transparency = (1 - this.alpha) * 100;
            }
            if (this.labelClasses)
            {
                _loc_2.labelingInfo = JSONUtil.toJSONArray(this.labelClasses);
            }
            if (this.renderer is IJSONSupport)
            {
                _loc_2.renderer = (this.renderer as IJSONSupport).toJSON();
            }
            if (this._scaleSymbolsSet)
            {
                _loc_2.scaleSymbols = this.scaleSymbols;
            }
            if (this._showLabelsSet)
            {
                _loc_2.showLabels = this.showLabels;
            }
            return _loc_2;
        }// end function

    }
}
