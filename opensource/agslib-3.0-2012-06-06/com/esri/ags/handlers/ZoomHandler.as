package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.geom.*;

    final class ZoomHandler extends EventDispatcher
    {
        private var m_map:Map;
        private var m_mouseDownPoint:Point;
        private var m_lastMouseEvent:MouseEvent;
        private var m_rubberband:Rubberband = null;
        private static const SMALL_DIST:Number = 3;

        function ZoomHandler(map:Map)
        {
            this.m_map = map;
            this.m_rubberband = new Rubberband(map, this.onRubberbandEnd);
            return;
        }// end function

        public function onMouseDown(event:MouseEvent) : void
        {
            this.m_lastMouseEvent = event;
            this.m_mouseDownPoint = this.m_map.globalToLocal(new Point(event.stageX, event.stageY));
            if (this.m_map.rubberbandZoomEnabled)
            {
                this.m_rubberband.start(event);
            }
            else
            {
                this.m_map.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpAfterMouseDownHandler, false);
            }
            return;
        }// end function

        private function onRubberbandEnd() : void
        {
            if (this.m_rubberband.dx > SMALL_DIST)
            {
                if (this.m_rubberband.dy > SMALL_DIST)
                {
                    if (!this.m_rubberband.lastMouseEvent.altKey)
                    {
                    }
                    if (this.m_rubberband.lastMouseEvent.ctrlKey)
                    {
                        this.m_rubberband.zoomOut();
                    }
                    else
                    {
                        this.m_rubberband.zoomIn();
                    }
                }
                else
                {
                    this.mouseDidNotMoveAfterUpEvent();
                }
            }
            else
            {
                this.mouseDidNotMoveAfterUpEvent();
            }
            return;
        }// end function

        private function stage_mouseUpAfterMouseDownHandler(event:MouseEvent) : void
        {
            this.m_map.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpAfterMouseDownHandler, false);
            this.mouseDidNotMoveAfterUpEvent();
            return;
        }// end function

        private function mouseDidNotMoveAfterUpEvent() : void
        {
            if (this.m_map.clickRecenterEnabled)
            {
                this.m_map.panToXY(this.m_mouseDownPoint.x, this.m_mouseDownPoint.y);
            }
            return;
        }// end function

    }
}
