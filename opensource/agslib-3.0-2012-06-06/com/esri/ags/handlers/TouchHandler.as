package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import flash.events.*;
    import flash.geom.*;

    class TouchHandler extends Object
    {
        private var _map:Map;
        private var _enabled:Boolean;
        private var _isPinching:Boolean;

        function TouchHandler(map:Map)
        {
            this._map = map;
            return;
        }// end function

        public function enable() : void
        {
            if (this._enabled)
            {
                return;
            }
            this._map.addEventListener(TransformGestureEvent.GESTURE_ZOOM, this.map_gestureZoomHandler);
            this._map.addEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, this.map_gestureTwoFingerTapHandler);
            return;
        }// end function

        public function disable() : void
        {
            this._map.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, this.map_gestureZoomHandler);
            this._map.removeEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, this.map_gestureTwoFingerTapHandler);
            this._enabled = false;
            return;
        }// end function

        private function map_gestureZoomHandler(event:TransformGestureEvent) : void
        {
            var _loc_3:Point = null;
            var _loc_2:* = event.phase;
            if (_loc_2 === GesturePhase.BEGIN)
            {
                if (!this._map.isPanning)
                {
                }
            }
            if (!this._map.isTweening)
            {
                this._isPinching = true;
                this._map.pinchStartHandler();
            }
            else
            {
                if (_loc_2 === GesturePhase.UPDATE)
                {
                }
                if (this._isPinching)
                {
                    _loc_3 = this._map.globalToLocal(new Point(event.stageX, event.stageY));
                    this._map.pinchUpdateHandler(event.scaleX, _loc_3.x, _loc_3.y);
                }
                else
                {
                    if (_loc_2 === GesturePhase.END)
                    {
                    }
                    if (this._isPinching)
                    {
                        this._isPinching = false;
                        this._map.pinchEndHandler();
                    }
                }
            }
            return;
        }// end function

        private function map_gestureTwoFingerTapHandler(event:GestureEvent) : void
        {
            this._map.zoomOut();
            return;
        }// end function

    }
}
