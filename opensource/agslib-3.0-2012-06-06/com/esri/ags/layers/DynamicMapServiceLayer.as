package com.esri.ags.layers
{
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class DynamicMapServiceLayer extends Layer
    {
        private var _log:ILogger;
        private var _img:ImageLoader;
        private var _imgLoading:ImageLoader;
        private var _imgExtent:Extent;
        private var _imgScrollRectX:Number;
        private var _imgScrollRectY:Number;
        private var _hiddenExtent:Extent;

        public function DynamicMapServiceLayer()
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            mouseChildren = false;
            mouseEnabled = false;
            return;
        }// end function

        override protected function removeAllChildren() : void
        {
            super.removeAllChildren();
            this.graphics.clear();
            var _loc_1:* = this.transform.matrix;
            if (_loc_1)
            {
                _loc_1.identity();
            }
            else
            {
                _loc_1 = new Matrix();
            }
            this.transform.matrix = _loc_1;
            return;
        }// end function

        override protected function updateLayer() : void
        {
            if (this._imgLoading)
            {
                this.cancelLoadingImage();
            }
            this._imgLoading = new ImageLoader();
            this._imgLoading.addEventListener(Event.COMPLETE, this.imageLoader_completeHandler, false, 0, true);
            this._imgLoading.addEventListener(IOErrorEvent.IO_ERROR, this.imageLoader_ioErrorHandler, false, 0, true);
            this.loadMapImage(this._imgLoading);
            return;
        }// end function

        protected function loadMapImage(loader:Loader) : void
        {
            return;
        }// end function

        private function cancelLoadingImage() : void
        {
            this._imgLoading.removeEventListener(Event.COMPLETE, this.imageLoader_completeHandler);
            this._imgLoading.removeEventListener(IOErrorEvent.IO_ERROR, this.imageLoader_ioErrorHandler);
            this._imgLoading.cancel = true;
            this._imgLoading = null;
            return;
        }// end function

        private function addAndDrawImg() : void
        {
            var _loc_1:Bitmap = null;
            var _loc_2:Matrix = null;
            addChild(this._img);
            try
            {
                _loc_1 = this._img.content as Bitmap;
            }
            catch (err:SecurityError)
            {
            }
            if (_loc_1)
            {
                this._img.visible = false;
                _loc_2 = new Matrix();
                _loc_2.translate(this._img.x, this._img.y);
                graphics.clear();
                graphics.beginBitmapFill(_loc_1.bitmapData, _loc_2);
                graphics.drawRect(this._img.x, this._img.y, _loc_1.width, _loc_1.height);
                graphics.endFill();
            }
            return;
        }// end function

        override protected function removedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                removeMapListeners();
                this.removeAllChildren();
                if (this._imgLoading)
                {
                    this.cancelLoadingImage();
                }
            }
            return;
        }// end function

        override protected function hideHandler(event:FlexEvent) : void
        {
            super.hideHandler(event);
            if (map)
            {
                this._hiddenExtent = map.extent.duplicate();
            }
            else
            {
                this._hiddenExtent = null;
            }
            return;
        }// end function

        override protected function showHandler(event:FlexEvent) : void
        {
            super.showHandler(event);
            if (map)
            {
            }
            if (map.extent)
            {
            }
            if (this._hiddenExtent)
            {
            }
            if (!map.extent.equalsExtent(this._hiddenExtent))
            {
                this.removeAllChildren();
            }
            return;
        }// end function

        override protected function zoomStartHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Matrix = null;
            if (this._imgExtent)
            {
            }
            if (map.layerContainer)
            {
            }
            if (map)
            {
                _loc_2 = map.toScreenX(this._imgExtent.xmin);
                _loc_3 = map.toScreenX(this._imgExtent.xmax);
                _loc_4 = map.toScreenY(this._imgExtent.ymax);
                _loc_5 = _loc_2;
                _loc_6 = _loc_4;
                _loc_7 = _loc_3 - _loc_2;
                _loc_8 = _loc_7 / map.width;
                _loc_9 = map.layerContainer.scrollRect.x;
                _loc_10 = map.layerContainer.scrollRect.y;
                _loc_11 = _loc_5 + _loc_9 - _loc_9 * _loc_8;
                _loc_12 = _loc_6 + _loc_10 - _loc_10 * _loc_8;
                _loc_11 = _loc_11 - (this._imgScrollRectX - _loc_9) * _loc_8;
                _loc_12 = _loc_12 - (this._imgScrollRectY - _loc_10) * _loc_8;
                _loc_13 = this.transform.matrix;
                if (_loc_13)
                {
                    _loc_13.identity();
                }
                else
                {
                    _loc_13 = new Matrix();
                }
                _loc_13.scale(_loc_8, _loc_8);
                _loc_13.translate(_loc_11, _loc_12);
                this.transform.matrix = _loc_13;
            }
            return;
        }// end function

        override protected function zoomEndHandler(event:ZoomEvent) : void
        {
            this.zoomUpdateHandler(event);
            return;
        }// end function

        private function imageLoader_completeHandler(event:Event) : void
        {
            var _loc_2:* = ImageLoader(event.target);
            if (map)
            {
            }
            if (map.isTweening)
            {
                _loc_2.cancel = true;
            }
            else
            {
                this.removeAllChildren();
                this._img = _loc_2;
                this._imgExtent = map.extent.duplicate();
                this._imgScrollRectX = map.layerContainer.scrollRect.x;
                this._imgScrollRectY = map.layerContainer.scrollRect.y;
                this._img.x = this._img.x + map.layerContainer.scrollRect.x;
                this._img.y = this._img.y + map.layerContainer.scrollRect.y;
                this.addAndDrawImg();
            }
            this._imgLoading = null;
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
            return;
        }// end function

        private function imageLoader_ioErrorHandler(event:IOErrorEvent) : void
        {
            var _loc_2:* = ImageLoader(event.target);
            if (map)
            {
            }
            if (map.isTweening)
            {
                _loc_2.cancel = true;
            }
            else
            {
                this.removeAllChildren();
            }
            this._imgLoading = null;
            if (Log.isError())
            {
                this._log.error("{0}::{1}", id, event.text);
            }
            var _loc_3:* = new Fault(null, event.text);
            _loc_3.rootCause = event;
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, _loc_3, false));
            return;
        }// end function

    }
}
