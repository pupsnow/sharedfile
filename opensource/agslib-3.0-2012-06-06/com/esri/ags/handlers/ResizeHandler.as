package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.events.*;

    public class ResizeHandler extends Object
    {
        private var m_map:Map;
        private var m_oldWidth:Number;
        private var m_oldHeight:Number;
        private var m_timer:Timer;
        private static const DELAY:Number = 250;

        public function ResizeHandler(map:Map)
        {
            this.m_map = map;
            this.m_map.scrollRect = new Rectangle(0, 0, map.width, map.height);
            this.m_map.addEventListener(ResizeEvent.RESIZE, this.resizeFirstHandler);
            return;
        }// end function

        private function updateMapScrollRect() : void
        {
            var _loc_1:Rectangle = null;
            if (this.m_map.width > 0)
            {
            }
            if (this.m_map.height > 0)
            {
                _loc_1 = this.m_map.scrollRect;
                _loc_1.width = this.m_map.width;
                _loc_1.height = this.m_map.height;
                this.m_map.scrollRect = _loc_1;
            }
            return;
        }// end function

        private function resizeFirstHandler(event:ResizeEvent) : void
        {
            if (event.oldWidth > 0)
            {
            }
            if (event.oldHeight > 0)
            {
                this.m_oldWidth = event.oldWidth;
                this.m_oldHeight = event.oldHeight;
                if (this.m_map.extent)
                {
                    this.m_map.isResizing = true;
                    this.m_map.removeEventListener(ResizeEvent.RESIZE, this.resizeFirstHandler);
                    this.m_map.addEventListener(ResizeEvent.RESIZE, this.resizeAfterHandler);
                    this.m_timer = new Timer(DELAY, 1);
                    this.m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerCompleteHandler);
                    this.m_timer.start();
                }
            }
            this.updateMapScrollRect();
            return;
        }// end function

        private function resizeAfterHandler(event:ResizeEvent) : void
        {
            this.m_timer.reset();
            this.m_timer.start();
            this.updateMapScrollRect();
            return;
        }// end function

        private function timerCompleteHandler(event:TimerEvent) : void
        {
            if (this.m_map.isTweening)
            {
                this.m_timer.reset();
                this.m_timer.start();
            }
            else
            {
                this.m_map.isResizing = false;
                this.m_map.removeEventListener(ResizeEvent.RESIZE, this.resizeAfterHandler);
                this.m_map.addEventListener(ResizeEvent.RESIZE, this.resizeFirstHandler);
                this.m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.timerCompleteHandler);
                this.m_timer = null;
                if (this.m_map.width > 0)
                {
                }
                if (this.m_map.height > 0)
                {
                    this.updateExtent();
                }
            }
            return;
        }// end function

        private function updateExtent() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Rectangle = null;
            var _loc_4:Rectangle = null;
            this.updateMapScrollRect();
            _loc_1 = this.m_map.width / this.m_oldWidth;
            _loc_2 = this.m_map.height / this.m_oldHeight;
            _loc_3 = GeomUtils.extentToRect(this.m_map.extent);
            _loc_4 = new Rectangle(_loc_3.x, _loc_3.y, _loc_3.width * _loc_1, _loc_3.height * _loc_2);
            var _loc_5:* = GeomUtils.rectToExtent(_loc_4);
            _loc_5.spatialReference = this.m_map.extent.spatialReference;
            this.m_map.animateExtent = false;
            this.m_map.extent = _loc_5;
            return;
        }// end function

    }
}
