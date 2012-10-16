package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MouseHandler extends Object
    {
        private var m_map:Map;
        private var m_enabled:Boolean = false;
        private var m_zoomHandler:ZoomHandler;
        private var m_panHandler:PanHandler;
        private var m_touchHandler:TouchHandler;
        private var m_scrollWheelZoomEnabled:Boolean = true;
        private var _multiTouchEnabled:Boolean = true;
        private var _mouseWheelChangePending:Boolean;

        public function MouseHandler(map:Map)
        {
            this.m_map = map;
            this.m_zoomHandler = new ZoomHandler(map);
            this.m_panHandler = new PanHandler(map);
            this.m_touchHandler = new TouchHandler(map);
            return;
        }// end function

        public function get scrollWheelZoomEnabled() : Boolean
        {
            return this.m_scrollWheelZoomEnabled;
        }// end function

        public function set scrollWheelZoomEnabled(value:Boolean) : void
        {
            this.m_scrollWheelZoomEnabled = value;
            if (this.m_scrollWheelZoomEnabled)
            {
                this.m_map.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler, false);
                this.m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            }
            else
            {
                this.m_map.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler, false);
                this.m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            }
            return;
        }// end function

        public function get multiTouchEnabled() : Boolean
        {
            return this._multiTouchEnabled;
        }// end function

        public function set multiTouchEnabled(value:Boolean) : void
        {
            this._multiTouchEnabled = value;
            if (this._multiTouchEnabled)
            {
                this.m_touchHandler.enable();
            }
            else
            {
                this.m_touchHandler.disable();
            }
            return;
        }// end function

        public function enable() : void
        {
            if (this.m_enabled)
            {
                return;
            }
            if (this.m_scrollWheelZoomEnabled)
            {
                this.m_map.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler, false);
                this.m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            }
            this.m_map.layerHolder.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
            this.m_map.layerHolder.addEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler, true);
            this.m_map.layerHolder.addEventListener(MouseEvent.MOUSE_OVER, this.m_panHandler.onMouseOver, false);
            this.m_map.layerHolder.addEventListener(MouseEvent.MOUSE_OUT, this.m_panHandler.onMouseOut, false);
            if (this.multiTouchEnabled)
            {
                this.m_touchHandler.enable();
            }
            this.m_map.doubleClickEnabled = true;
            this.m_enabled = true;
            return;
        }// end function

        public function disable() : void
        {
            this.m_map.layerHolder.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
            this.m_map.layerHolder.removeEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler, true);
            this.m_map.layerHolder.removeEventListener(MouseEvent.MOUSE_OVER, this.m_panHandler.onMouseOver, false);
            this.m_map.layerHolder.removeEventListener(MouseEvent.MOUSE_OUT, this.m_panHandler.onMouseOut, false);
            this.scrollWheelZoomEnabled = false;
            this.m_panHandler.removeOpenCursor();
            this.m_touchHandler.disable();
            this.m_enabled = false;
            return;
        }// end function

        public function stopPanning() : void
        {
            this.m_panHandler.stopPanning();
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this.m_map.isTweening)
            {
            }
            if (!this.m_map.isPanning)
            {
                return;
            }
            if (this.targetHasEventListener(event))
            {
                return;
            }
            this.m_map.setFocus();
            if (event.shiftKey)
            {
                this.m_zoomHandler.onMouseDown(event);
            }
            else if (this.m_map.panEnabled)
            {
                this.m_panHandler.onMouseDown(event);
            }
            return;
        }// end function

        private function map_doubleClickHandler(event:MouseEvent) : void
        {
            var _loc_2:MapPoint = null;
            var _loc_3:Number = NaN;
            var _loc_4:Boolean = false;
            var _loc_5:Extent = null;
            if (this.m_map.doubleClickZoomEnabled)
            {
            }
            if (!event.shiftKey)
            {
            }
            if (!this.targetHasEventListener(event))
            {
                this.m_map.setFocus();
                _loc_2 = this.m_map.toMapFromStage(event.stageX, event.stageY);
                _loc_3 = 0.5;
                if (!event.altKey)
                {
                }
                _loc_4 = event.ctrlKey;
                if (_loc_4)
                {
                    _loc_3 = 2;
                }
                _loc_5 = this.m_map.extent;
                _loc_5 = _loc_5.centerAt(_loc_2);
                _loc_5 = _loc_5.expand(_loc_3);
                this.m_map.extent = _loc_5;
            }
            return;
        }// end function

        private function targetHasEventListener(event:MouseEvent) : Boolean
        {
            var _loc_3:Graphic = null;
            var _loc_4:IEventDispatcher = null;
            var _loc_2:* = event.target as DisplayObject;
            while (_loc_2)
            {
                
                if (_loc_2 is Layer)
                {
                    return false;
                }
                if (_loc_2 == this.m_map.layerContainer)
                {
                    return false;
                }
                if (_loc_2 is InfoComponent)
                {
                    return true;
                }
                if (_loc_2 is Graphic)
                {
                    _loc_3 = Graphic(_loc_2);
                    if (_loc_3.checkForMouseListeners)
                    {
                        if (_loc_3.hasEventListener(MouseEvent.MOUSE_DOWN))
                        {
                            return true;
                        }
                        if (_loc_3.hasEventListener(MouseEvent.MOUSE_MOVE))
                        {
                            return true;
                        }
                        if (_loc_3.hasEventListener(MouseEvent.MOUSE_UP))
                        {
                            return true;
                        }
                        if (_loc_3.hasEventListener(MouseEvent.CLICK))
                        {
                            return true;
                        }
                        if (_loc_3.hasEventListener(MouseEvent.DOUBLE_CLICK))
                        {
                            return true;
                        }
                    }
                    return false;
                }
                if (_loc_2 is IEventDispatcher)
                {
                }
                if (!(_loc_2 is CustomSWFLoader))
                {
                    _loc_4 = IEventDispatcher(_loc_2);
                    if (_loc_4.hasEventListener(MouseEvent.MOUSE_DOWN))
                    {
                        return true;
                    }
                    if (_loc_4.hasEventListener(MouseEvent.MOUSE_MOVE))
                    {
                        return true;
                    }
                    if (_loc_4.hasEventListener(MouseEvent.MOUSE_UP))
                    {
                        return true;
                    }
                    if (_loc_4.hasEventListener(MouseEvent.CLICK))
                    {
                        return true;
                    }
                    if (_loc_4.hasEventListener(MouseEvent.DOUBLE_CLICK))
                    {
                        return true;
                    }
                }
                _loc_2 = _loc_2.parent;
            }
            return false;
        }// end function

        private function extentChangeHandler(event:ExtentEvent) : void
        {
            this._mouseWheelChangePending = false;
            return;
        }// end function

        private function mouseWheelHandler(event:MouseEvent) : void
        {
            event.stopPropagation();
            if (this._mouseWheelChangePending)
            {
                return;
            }
            var _loc_2:* = this.m_map.globalToLocal(new Point(event.stageX, event.stageY));
            if (event.delta < 0)
            {
                if (this.m_map.level <= 0)
                {
                }
                if (this.m_map.level == -1)
                {
                    this.zoom(_loc_2.x, _loc_2.y, 2);
                }
            }
            else if (event.delta > 0)
            {
                if (this.m_map.lods != null)
                {
                }
                if (this.m_map.level < (this.m_map.lods.length - 1))
                {
                    this.zoom(_loc_2.x, _loc_2.y, 0.5);
                }
            }
            return;
        }// end function

        private function zoom(px:Number, py:Number, fac:Number) : void
        {
            var _loc_4:Extent = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            this._mouseWheelChangePending = true;
            if (fac < 1)
            {
                this.m_map.zoomIn();
            }
            else
            {
                this.m_map.zoomOut();
            }
            _loc_4 = this.m_map.extent;
            _loc_5 = this.m_map.toScreenX2(_loc_4.xmin);
            _loc_6 = this.m_map.toScreenY2(_loc_4.ymin);
            _loc_7 = this.m_map.toScreenX2(_loc_4.xmax);
            _loc_8 = this.m_map.toScreenY2(_loc_4.ymax);
            fac = _loc_4.width / this.m_map.m_oldExtent.width;
            _loc_9 = _loc_5 + px * fac;
            _loc_10 = _loc_8 + py * fac;
            _loc_11 = _loc_9 - px;
            _loc_12 = _loc_10 - py;
            var _loc_13:* = this.m_map.toMapX2(_loc_5 - _loc_11);
            var _loc_14:* = this.m_map.toMapX2(_loc_7 - _loc_11);
            var _loc_15:* = this.m_map.toMapY2(_loc_6 - _loc_12);
            var _loc_16:* = this.m_map.toMapY2(_loc_8 - _loc_12);
            this.m_map.extent = new Extent(_loc_13, _loc_15, _loc_14, _loc_16, this.m_map.spatialReference);
            return;
        }// end function

    }
}
