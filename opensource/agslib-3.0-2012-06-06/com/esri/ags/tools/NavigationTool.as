package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.events.*;

    public class NavigationTool extends BaseTool
    {
        private var _extents:Array;
        private var _navType:String = null;
        private var _start:MapPoint = null;
        private var _active:Boolean = false;
        private var _prevExtent:Boolean = false;
        private var _nextExtent:Boolean = false;
        private var _extentCursor:Number = -1;
        private var _rubberband:Rubberband = null;
        public static const PAN:String = "pan";
        public static const ZOOM_IN:String = "zoomin";
        public static const ZOOM_OUT:String = "zoomout";
        private static const SMALL_DIST:Number = 3;

        public function NavigationTool(map:Map = null)
        {
            this._extents = [];
            super(map);
            return;
        }// end function

        public function get isFirstExtent() : Boolean
        {
            return this._extentCursor <= 0;
        }// end function

        public function get isLastExtent() : Boolean
        {
            return this._extentCursor == (this._extents.length - 1);
        }// end function

        override public function get map() : Map
        {
            return super.map;
        }// end function

        override public function set map(map:Map) : void
        {
            this.resetVars();
            this.removeMapListeners();
            super.map = map;
            this.addMapListeners();
            this._rubberband = new Rubberband(map, this.onRubberbandEnd);
            if (map)
            {
            }
            if (map.extent)
            {
                this._extents.push(map.extent.duplicate());
                this.normalizeCursor();
            }
            return;
        }// end function

        public function activate(navType:String, enableGraphicsLayerMouseEvents:Boolean = false) : void
        {
            if (!this.map)
            {
                return;
            }
            if (!this._active)
            {
                deactivateMapTools(true, false, false, !enableGraphicsLayerMouseEvents, false);
                this._active = true;
            }
            switch(navType)
            {
                case ZOOM_IN:
                case ZOOM_OUT:
                {
                    this.deactivate2();
                    this.map.addEventListener(MouseEvent.MOUSE_DOWN, this.map_mouseDownHandler, false, 0, true);
                    this._navType = navType;
                    break;
                }
                case PAN:
                {
                    this.deactivate2();
                    this.map.panEnabled = true;
                    this._navType = navType;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function deactivate() : void
        {
            if (this._active)
            {
                this.deactivate2();
                this._navType = null;
                this._start = null;
                this._active = false;
                activateMapTools(true, false, false, true, false);
            }
            return;
        }// end function

        public function zoomToNextExtent() : void
        {
            if (this.isLastExtent)
            {
                return;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._extentCursor + 1;
            _loc_1._extentCursor = _loc_2;
            this.normalizeCursor();
            this._nextExtent = true;
            this.map.extent = this._extents[this._extentCursor];
            return;
        }// end function

        public function zoomToPrevExtent() : void
        {
            if (this.isFirstExtent)
            {
                return;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._extentCursor - 1;
            _loc_1._extentCursor = _loc_2;
            this.normalizeCursor();
            this._prevExtent = true;
            this.map.extent = this._extents[this._extentCursor];
            return;
        }// end function

        private function resetVars() : void
        {
            this._extents = [];
            this._navType = null;
            this._start = null;
            this._active = false;
            this._prevExtent = false;
            this._nextExtent = false;
            this._extentCursor = -1;
            return;
        }// end function

        private function addMapListeners() : void
        {
            if (this.map)
            {
                this.map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler, false, 10, true);
            }
            return;
        }// end function

        private function removeMapListeners() : void
        {
            if (this.map)
            {
                this.map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            }
            return;
        }// end function

        private function normalizeCursor() : void
        {
            if (this._extentCursor < 0)
            {
                this._extentCursor = 0;
                dispatchEvent(new Event("cursorChange"));
            }
            else if (this._extentCursor > this._extents.length)
            {
                this._extentCursor = this._extents.length;
                dispatchEvent(new Event("cursorChange"));
            }
            return;
        }// end function

        private function deactivate2() : void
        {
            if (!this.map)
            {
                return;
            }
            if (this._navType == PAN)
            {
                this.map.panEnabled = false;
            }
            else
            {
                if (this._navType != ZOOM_IN)
                {
                }
                if (this._navType == ZOOM_OUT)
                {
                    this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.map_mouseDownHandler);
                }
            }
            return;
        }// end function

        private function onRubberbandEnd() : void
        {
            if (this._rubberband.dx > SMALL_DIST)
            {
            }
            if (this._rubberband.dy > SMALL_DIST)
            {
                if (this._navType == ZOOM_IN)
                {
                    this._rubberband.zoomIn();
                }
                else
                {
                    this._rubberband.zoomOut();
                }
            }
            return;
        }// end function

        private function extentChangeHandler(event:ExtentEvent) : void
        {
            if (!this._prevExtent)
            {
            }
            if (!this._nextExtent)
            {
                this._extents = this._extents.splice(0, (this._extentCursor + 1));
                this._extents.push(event.extent.duplicate());
                this._extentCursor = this._extents.length - 1;
            }
            var _loc_2:Boolean = false;
            this._nextExtent = false;
            this._prevExtent = _loc_2;
            dispatchEvent(event);
            return;
        }// end function

        private function map_mouseDownHandler(event:MouseEvent) : void
        {
            this._rubberband.start(event);
            return;
        }// end function

    }
}
