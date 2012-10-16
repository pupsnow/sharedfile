package com.esri.ags.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class ImageLoader extends Loader
    {
        private var _loaded:Boolean;
        private var _cancelled:Boolean;
        private var _errored:Boolean;
        private var _completeEvent:Event;
        private var _alphaFrameIncrease:Number;
        private var _context:LoaderContext;
        public var id:String;
        public var cancel:Boolean;
        private var _fadeInFrameCount:uint = 1;
        private var _smoothing:Boolean;

        public function ImageLoader()
        {
            this._alphaFrameIncrease = 1 / this.fadeInFrameCount;
            this._context = new LoaderContext();
            this._context.checkPolicyFile = true;
            contentLoaderInfo.addEventListener(Event.OPEN, this.contentLoaderInfo_openHandler, false, 0, true);
            contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.contentLoaderInfo_progressEventHandler, false, 0, true);
            contentLoaderInfo.addEventListener(Event.COMPLETE, this.contentLoaderInfo_completeHandler, false, 0, true);
            contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.contentLoaderInfo_ioErrorEventHandler, false, 0, true);
            addEventListener(Event.REMOVED, this.removedHandler);
            return;
        }// end function

        public function get fadeInFrameCount() : uint
        {
            return this._fadeInFrameCount;
        }// end function

        public function set fadeInFrameCount(value:uint) : void
        {
            this._fadeInFrameCount = value;
            this._alphaFrameIncrease = 1 / value;
            return;
        }// end function

        public function get smoothing() : Boolean
        {
            return this._smoothing;
        }// end function

        public function set smoothing(value:Boolean) : void
        {
            if (this._smoothing != value)
            {
                this._smoothing = value;
                if (this._loaded)
                {
                    this.setContentSmoothing(this._smoothing);
                }
            }
            return;
        }// end function

        override public function load(request:URLRequest, context:LoaderContext = null) : void
        {
            var _loc_3:* = context ? (context) : (this._context);
            super.load(request, _loc_3);
            return;
        }// end function

        private function setContentSmoothing(smoothing:Boolean) : void
        {
            var _loc_2:* = content as Bitmap;
            if (_loc_2)
            {
                _loc_2.smoothing = smoothing;
            }
            return;
        }// end function

        private function cancelDownload() : void
        {
            if (this.cancel)
            {
            }
            if (!this._loaded)
            {
            }
            if (!this._cancelled)
            {
            }
            if (!this._errored)
            {
                try
                {
                    close();
                }
                catch (error:Error)
                {
                }
                finally
                {
                    unload();
                }
                this._cancelled = true;
            }
            return;
        }// end function

        private function removedHandler(event:Event) : void
        {
            if (!this._loaded)
            {
                this.cancel = true;
                this.cancelDownload();
            }
            else
            {
                unload();
            }
            return;
        }// end function

        private function contentLoaderInfo_openHandler(event:Event) : void
        {
            this.cancelDownload();
            dispatchEvent(event);
            return;
        }// end function

        private function contentLoaderInfo_progressEventHandler(event:ProgressEvent) : void
        {
            this.cancelDownload();
            dispatchEvent(event);
            return;
        }// end function

        private function contentLoaderInfo_completeHandler(event:Event) : void
        {
            this._loaded = true;
            if (this.smoothing)
            {
                this.setContentSmoothing(true);
            }
            if (this.fadeInFrameCount > 1)
            {
                alpha = this._alphaFrameIncrease;
                addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                this._completeEvent = event;
            }
            else
            {
                dispatchEvent(event);
            }
            return;
        }// end function

        private function contentLoaderInfo_ioErrorEventHandler(event:IOErrorEvent) : void
        {
            this._errored = true;
            dispatchEvent(event);
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            alpha = alpha + this._alphaFrameIncrease;
            if (alpha > 0.99)
            {
                alpha = 1;
                removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                dispatchEvent(this._completeEvent);
            }
            return;
        }// end function

    }
}
