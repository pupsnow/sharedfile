package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import flash.events.*;
    import flash.ui.*;
    import mx.managers.*;

    final class PanHandler extends Object
    {
        private var m_closeCursorID:int = -1;
        private var m_closeHandCursor:Class;
        private var m_openCursorID:int = -1;
        private var m_openHandCursor:Class;
        private var m_map:Map;
        private var m_mapMouseX:Number;
        private var m_mapMouseY:Number;
        private var m_mapX:Number;
        private var m_mapY:Number;
        private var m_mouseDownX:Number;
        private var m_mouseDownY:Number;
        private var m_mouseDown:Boolean = false;
        private var m_targetX:Number;
        private var m_targetY:Number;
        private var m_scrollRectX:Number;
        private var m_scrollRectY:Number;

        function PanHandler(map:Map)
        {
            this.m_closeHandCursor = PanHandler_m_closeHandCursor;
            this.m_openHandCursor = PanHandler_m_openHandCursor;
            this.m_map = map;
            return;
        }// end function

        public function onMouseOver(event:MouseEvent) : void
        {
            if (Mouse.supportsCursor)
            {
            }
            if (this.m_map.panEnabled)
            {
            }
            if (this.m_map.openHandCursorVisible)
            {
                this.m_map.cursorManager.removeCursor(this.m_openCursorID);
                this.m_openCursorID = this.m_map.cursorManager.setCursor(this.m_openHandCursor, CursorManagerPriority.LOW, -10, -8);
            }
            return;
        }// end function

        public function onMouseOut(event:MouseEvent) : void
        {
            this.removeOpenCursor();
            return;
        }// end function

        public function removeOpenCursor() : void
        {
            this.m_map.cursorManager.removeCursor(this.m_openCursorID);
            return;
        }// end function

        public function onMouseDown(event:MouseEvent) : void
        {
            this.m_mapMouseX = this.m_map.mouseX;
            this.m_mapMouseY = this.m_map.mouseY;
            if (!this.m_map.isPanning)
            {
                this.m_targetX = this.m_map.mouseX;
                this.m_targetY = this.m_map.mouseY;
                this.m_mapX = this.m_map.mouseX;
                this.m_mapY = this.m_map.mouseY;
                this.m_mouseDownX = this.m_map.mouseX;
                this.m_mouseDownY = this.m_map.mouseY;
                this.m_scrollRectX = this.m_map.scrollRectX;
                this.m_scrollRectY = this.m_map.scrollRectY;
            }
            this.m_mouseDown = true;
            this.m_map.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveFirstHandler);
            this.m_map.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
            return;
        }// end function

        private function stage_mouseMoveFirstHandler(event:MouseEvent) : void
        {
            var _loc_2:* = Math.abs(this.m_map.mouseX - this.m_mapMouseX);
            var _loc_3:* = Math.abs(this.m_map.mouseY - this.m_mapMouseY);
            if (_loc_2 < this.m_map.mapMouseClickTolerance)
            {
            }
            if (_loc_3 >= this.m_map.mapMouseClickTolerance)
            {
                this.m_map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveFirstHandler);
                if (Mouse.supportsCursor)
                {
                    this.m_map.cursorManager.removeCursor(this.m_closeCursorID);
                    this.m_closeCursorID = this.m_map.cursorManager.setCursor(this.m_closeHandCursor, CursorManagerPriority.MEDIUM, -9, -8);
                }
                this.m_map.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveOtherHandler);
                if (!this.m_map.isPanning)
                {
                    this.m_map.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                    this.m_map.m_oldExtent = this.m_map.extent.duplicate();
                    this.m_map.dispatchPanStart(this.m_mapMouseX, this.m_mapMouseY);
                }
                this.stage_mouseMoveOtherHandler(event);
            }
            return;
        }// end function

        private function stage_mouseMoveOtherHandler(event:MouseEvent) : void
        {
            var _loc_2:* = this.m_map.mouseX - this.m_mapMouseX;
            var _loc_3:* = this.m_map.mouseY - this.m_mapMouseY;
            this.m_targetX = this.m_targetX + _loc_2;
            this.m_targetY = this.m_targetY + _loc_3;
            this.m_mapMouseX = this.m_map.mouseX;
            this.m_mapMouseY = this.m_map.mouseY;
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_2:* = this.m_targetX - this.m_mapX;
            var _loc_3:* = this.m_targetY - this.m_mapY;
            if (!this.m_mouseDown)
            {
            }
            if (Math.abs(_loc_2) < 1)
            {
            }
            if (Math.abs(_loc_3) < 1)
            {
                this.m_map.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                this.m_map.dispatchPanEnd(this.m_targetX, this.m_targetY);
            }
            else
            {
                _loc_4 = this.m_mapX;
                _loc_5 = this.m_mapY;
                _loc_6 = this.m_map.panEasingFactor;
                this.m_mapX = this.m_mapX + _loc_2 * _loc_6;
                this.m_mapY = this.m_mapY + _loc_3 * _loc_6;
                _loc_2 = _loc_4 - this.m_mapX;
                _loc_3 = _loc_5 - this.m_mapY;
                this.m_scrollRectX = this.m_scrollRectX + _loc_2;
                this.m_scrollRectY = this.m_scrollRectY + _loc_3;
                this.m_map.layerContainer.updateScrollRect(this.m_scrollRectX, this.m_scrollRectY);
                this.m_map.dispatchPanUpdate(this.m_mouseDownX, this.m_mouseDownY, this.m_mapX, this.m_mapY);
                this.m_map.m_endExtent = this.m_map.extent;
            }
            return;
        }// end function

        public function stopPanning() : void
        {
            this.m_map.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            this.m_map.dispatchPanEnd(this.m_mapX, this.m_mapY, false);
            return;
        }// end function

        private function stage_mouseUpHandler(event:MouseEvent) : void
        {
            this.m_map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveFirstHandler);
            this.m_map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveOtherHandler);
            this.m_map.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
            this.m_mouseDown = false;
            this.m_map.cursorManager.removeCursor(this.m_closeCursorID);
            return;
        }// end function

    }
}
