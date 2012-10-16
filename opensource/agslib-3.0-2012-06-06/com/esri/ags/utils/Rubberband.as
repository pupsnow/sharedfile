package com.esri.ags.utils
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;

    public class Rubberband extends Object
    {
        private var _map:Map;
        private var _onEnd:Function;
        private var _crossCursor:Class;
        private var _cursorID:int = -1;
        private var _fillStyle:String;
        private var _fillColor:Number;
        private var _fillAlpha:Number;
        private var _lineColor:Number;
        private var _lineAlpha:Number;
        private var _lineWidth:Number;
        public var startPt:Point;
        public var endPt:Point;
        public var lastMouseEvent:MouseEvent;

        public function Rubberband(map:Map, onEnd:Function)
        {
            this._crossCursor = Rubberband__crossCursor;
            this._map = map;
            this._onEnd = onEnd;
            return;
        }// end function

        public function get dx() : Number
        {
            return Math.abs(this.startPt.x - this.endPt.x);
        }// end function

        public function get dy() : Number
        {
            return Math.abs(this.startPt.y - this.endPt.y);
        }// end function

        public function start(event:MouseEvent) : void
        {
            this.lastMouseEvent = event;
            this._fillStyle = this._map.getStyle("rubberbandFillStyle");
            this._fillColor = this._map.getStyle("rubberbandFillColor");
            this._fillAlpha = this._map.getStyle("rubberbandFillAlpha");
            this._lineColor = this._map.getStyle("rubberbandLineColor");
            this._lineAlpha = this._map.getStyle("rubberbandLineAlpha");
            this._lineWidth = this._map.getStyle("rubberbandLineWidth");
            this.startPt = this._map.globalToLocal(new Point(event.stageX, event.stageY));
            this._map.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandlerFirst);
            this._map.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
            this._map.stage.addEventListener(Event.MOUSE_LEAVE, this.stage_mouseLeaveHandler);
            return;
        }// end function

        public function zoomIn() : void
        {
            var _loc_1:* = this._map.toMapX(Math.min(this.endPt.x, this.startPt.x));
            var _loc_2:* = this._map.toMapX(Math.max(this.endPt.x, this.startPt.x));
            var _loc_3:* = this._map.toMapY(Math.max(this.endPt.y, this.startPt.y));
            var _loc_4:* = this._map.toMapY(Math.min(this.endPt.y, this.startPt.y));
            this._map.extent = new Extent(_loc_1, _loc_3, _loc_2, _loc_4, this._map.spatialReference);
            return;
        }// end function

        public function zoomOut() : void
        {
            var _loc_1:* = Math.abs(this.endPt.x - this.startPt.x);
            var _loc_2:* = this._map.extent.width;
            var _loc_3:* = _loc_2 * this._map.width / _loc_1;
            var _loc_4:* = (_loc_3 - _loc_2) / 2;
            this._map.extent = new Extent(this._map.extent.xmin - _loc_4, this._map.extent.ymin - _loc_4, this._map.extent.xmax + _loc_4, this._map.extent.ymax + _loc_4, this._map.spatialReference);
            return;
        }// end function

        private function stage_mouseMoveHandlerFirst(event:MouseEvent) : void
        {
            this._map.cursorManager.removeCursor(this._cursorID);
            this._cursorID = this._map.cursorManager.setCursor(this._crossCursor, CursorManagerPriority.MEDIUM, -8, -8);
            this._map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandlerFirst);
            this._map.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandlerAfter);
            this.stage_mouseMoveHandlerAfter(event);
            return;
        }// end function

        private function stage_mouseMoveHandlerAfter(event:MouseEvent) : void
        {
            this.lastMouseEvent = event;
            var _loc_2:* = this._map.globalToLocal(new Point(event.stageX, event.stageY));
            var _loc_3:* = this._map.drawLayer;
            _loc_3.graphics.clear();
            _loc_3.graphics.beginFill(this._fillColor, this._fillAlpha);
            switch(this._fillStyle)
            {
                case "inside":
                {
                    _loc_3.graphics.lineStyle(this._lineWidth, this._lineColor, this._lineAlpha);
                    _loc_3.graphics.drawRect(this.startPt.x, this.startPt.y, _loc_2.x - this.startPt.x, _loc_2.y - this.startPt.y);
                    _loc_3.graphics.endFill();
                    break;
                }
                default:
                {
                    _loc_3.graphics.moveTo(0, 0);
                    _loc_3.graphics.lineTo(0 + this._map.width, 0);
                    _loc_3.graphics.lineTo(0 + this._map.width, 0 + this._map.height);
                    _loc_3.graphics.lineTo(0, 0 + this._map.height);
                    _loc_3.graphics.lineTo(0, 0);
                    _loc_3.graphics.lineStyle(this._lineWidth, this._lineColor, this._lineAlpha);
                    _loc_3.graphics.drawRect(this.startPt.x, this.startPt.y, _loc_2.x - this.startPt.x, _loc_2.y - this.startPt.y);
                    _loc_3.graphics.endFill();
                    break;
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        private function stage_mouseUpHandler(event:MouseEvent) : void
        {
            this._map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandlerFirst);
            this._map.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandlerAfter);
            this._map.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
            this._map.stage.removeEventListener(Event.MOUSE_LEAVE, this.stage_mouseLeaveHandler);
            this._map.drawLayer.graphics.clear();
            this.endPt = this._map.globalToLocal(new Point(event.stageX, event.stageY));
            this._map.cursorManager.removeCursor(this._cursorID);
            this._onEnd.call();
            return;
        }// end function

        private function stage_mouseLeaveHandler(event:Event) : void
        {
            if (this.lastMouseEvent)
            {
                this.stage_mouseUpHandler(this.lastMouseEvent);
            }
            return;
        }// end function

    }
}
