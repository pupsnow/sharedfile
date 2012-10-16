package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.renderers.*;
    import flash.events.*;

    public class DrawingInfo extends EventDispatcher
    {
        private var _alpha:Number;
        private var _renderer:IRenderer;

        public function DrawingInfo()
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

        static function toDrawingInfo(obj:Object) : DrawingInfo
        {
            var _loc_2:DrawingInfo = null;
            var _loc_3:Number = NaN;
            if (obj)
            {
                _loc_2 = new DrawingInfo;
                _loc_3 = obj.transparency;
                if (!isNaN(_loc_3))
                {
                    _loc_2.alpha = 1 - _loc_3 / 100;
                }
                _loc_2.renderer = Renderer.fromJSON(obj.renderer);
            }
            return _loc_2;
        }// end function

    }
}
