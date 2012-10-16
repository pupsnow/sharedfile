package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.ui.*;
    import mx.utils.*;

    public class PolylineVertexLayer extends EventDispatcher
    {
        private var _vertexDragInProgress:Boolean = false;
        private var _tool:EditTool;
        private var _map:Map;
        private var _childrenPerPath:Array;
        private var _vertexIndex:int;
        private var _pathIndex:int;
        private var _selectedVertexStartGeometry:MapPoint;
        public var selectedVertex:Graphic;
        public var initialMouseDownPoint:MapPoint;
        public var initialMouseDownVertexPoint:MapPoint;
        public var polyLine:Polyline;
        public var mouseMovePoint:MapPoint;
        public var arrGraphics:Array;

        public function PolylineVertexLayer()
        {
            this.polyLine = new Polyline();
            this.arrGraphics = [];
            return;
        }// end function

        public function init(map:Map, tool:EditTool) : void
        {
            this._tool = tool;
            this._map = map;
            this._tool.addEventListener(EditEvent.TOOL_DEACTIVATE, this.editToolDeactiveHandler);
            return;
        }// end function

        private function vertex_mouseOver(event:MouseEvent) : void
        {
            var _loc_2:Graphic = null;
            var _loc_3:ContextMenu = null;
            var _loc_4:ContextMenuItem = null;
            this.selectedVertex = event.target as Graphic;
            this._vertexIndex = this.selectedVertex.attributes.index;
            this._pathIndex = this.selectedVertex.attributes.pathIndex;
            this._childrenPerPath = [];
            for each (_loc_2 in this.arrGraphics)
            {
                
                if (_loc_2.attributes.pathIndex == this._pathIndex)
                {
                    this._childrenPerPath.push(_loc_2);
                }
            }
            if (this._tool.allowDeleteVertices)
            {
            }
            if (this._childrenPerPath.length > 2)
            {
                _loc_3 = new ContextMenu();
                if (_loc_3)
                {
                    _loc_3.hideBuiltInItems();
                    _loc_3.addEventListener(ContextMenuEvent.MENU_SELECT, this.onContextMenuSelect);
                    _loc_4 = new ContextMenuItem(ESRIMessageCodes.getString("editToolContextMenuItem"));
                    _loc_4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onContextMenuDelete);
                    if (_loc_3.customItems)
                    {
                        _loc_3.customItems.push(_loc_4);
                    }
                    this.selectedVertex.contextMenu = _loc_3;
                }
            }
            dispatchEvent(new Event("vertexMouseOver"));
            return;
        }// end function

        private function vertex_mouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event("vertexMouseOut"));
            return;
        }// end function

        private function onContextMenuSelect(event:ContextMenuEvent) : void
        {
            dispatchEvent(new EditEvent(EditEvent.CONTEXT_MENU_SELECT, event.target as ContextMenu, null, this._vertexIndex, this._pathIndex));
            return;
        }// end function

        private function vertex_mouseDown(event:MouseEvent) : void
        {
            var _loc_2:Graphic = null;
            if (this.selectedVertex)
            {
                this._selectedVertexStartGeometry = this.selectedVertex.geometry as MapPoint;
                this.initialMouseDownVertexPoint = ObjectUtil.copy(this._selectedVertexStartGeometry) as MapPoint;
                this.initialMouseDownPoint = this._map.toMapFromStage(event.stageX, event.stageY);
                for each (_loc_2 in this.arrGraphics)
                {
                    
                    if (_loc_2 !== this.selectedVertex)
                    {
                        _loc_2.removeEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
                    }
                }
                dispatchEvent(new Event("vertexMoveStart"));
                this._map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
                this._map.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            return;
        }// end function

        private function mouseMoveFirstHandler(event:MouseEvent) : void
        {
            this._vertexDragInProgress = true;
            dispatchEvent(new Event("vertexMoveFirst"));
            event.target.addEventListener(MouseEvent.CLICK, this.vertexMouseClickHandler, false, 1, true);
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this._map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            return;
        }// end function

        private function mouseMoveNextHandler(event:MouseEvent) : void
        {
            var _loc_2:MapPoint = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (this._vertexDragInProgress)
            {
                this._tool.snapping = this._tool.snapMode == EditTool.SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false));
                _loc_2 = this._map.toMapFromStage(event.stageX, event.stageY);
                this.mouseMovePoint = _loc_2;
                _loc_3 = _loc_2.x - this.initialMouseDownPoint.x;
                _loc_4 = _loc_2.y - this.initialMouseDownPoint.y;
                this.initialMouseDownPoint.x = this.initialMouseDownPoint.x + _loc_3;
                this.initialMouseDownPoint.y = this.initialMouseDownPoint.y + _loc_4;
                this.selectedVertex.geometry = new MapPoint(MapPoint(this.selectedVertex.geometry).x + _loc_3, MapPoint(this.selectedVertex.geometry).y + _loc_4);
                dispatchEvent(new Event("vertexMove"));
            }
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            var _loc_2:Graphic = null;
            this._tool.snapping = false;
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            for each (_loc_2 in this.arrGraphics)
            {
                
                _loc_2.addEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
            }
            if (this._vertexDragInProgress)
            {
                this._vertexDragInProgress = false;
            }
            dispatchEvent(new Event("vertexMoveStop"));
            return;
        }// end function

        private function vertexMouseClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            event.target.removeEventListener(MouseEvent.CLICK, this.vertexMouseClickHandler);
            return;
        }// end function

        public function load(polyline:Polyline) : void
        {
            var _loc_4:int = 0;
            this.clear();
            var _loc_2:Array = [];
            var _loc_3:int = 0;
            while (_loc_3 < polyline.paths.length)
            {
                
                _loc_2 = polyline.paths[_loc_3];
                _loc_4 = 0;
                while (_loc_4 <= (_loc_2.length - 1))
                {
                    
                    this.addGraphic(_loc_2[_loc_4], _loc_4 * 2, _loc_3, this._tool.vertexSymbol);
                    _loc_4 = _loc_4 + 1;
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function addGraphic(pt:MapPoint, index:int, pathIndex:int, symbol:Symbol) : void
        {
            var _loc_5:Graphic = null;
            _loc_5 = new Graphic(pt, symbol);
            _loc_5.attributes = {index:index, pathIndex:pathIndex};
            _loc_5.buttonMode = true;
            _loc_5.mouseChildren = false;
            _loc_5.addEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
            _loc_5.addEventListener(MouseEvent.MOUSE_OUT, this.vertex_mouseOut);
            _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.vertex_mouseDown);
            this.arrGraphics.push(_loc_5);
            this._map.defaultGraphicsLayer.add(_loc_5);
            return;
        }// end function

        private function onContextMenuDelete(event:ContextMenuEvent) : void
        {
            this._map.defaultGraphicsLayer.remove(this.selectedVertex);
            var _loc_2:* = this.arrGraphics.indexOf(this.selectedVertex);
            if (_loc_2 !== -1)
            {
                this.arrGraphics.splice(_loc_2, 1);
            }
            dispatchEvent(new Event("vertexDelete"));
            return;
        }// end function

        private function editToolDeactiveHandler(event:EditEvent) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in this.arrGraphics)
            {
                
                _loc_2.removeEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
                _loc_2.removeEventListener(MouseEvent.MOUSE_OUT, this.vertex_mouseOut);
                _loc_2.removeEventListener(MouseEvent.MOUSE_DOWN, this.vertex_mouseDown);
            }
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this._map.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        public function clear() : void
        {
            var _loc_1:Graphic = null;
            for each (_loc_1 in this.arrGraphics)
            {
                
                this._map.defaultGraphicsLayer.remove(_loc_1);
            }
            this.arrGraphics = [];
            return;
        }// end function

        public function hide() : void
        {
            var _loc_1:Graphic = null;
            for each (_loc_1 in this.arrGraphics)
            {
                
                _loc_1.visible = false;
            }
            return;
        }// end function

        public function show() : void
        {
            var _loc_1:Graphic = null;
            for each (_loc_1 in this.arrGraphics)
            {
                
                _loc_1.visible = true;
            }
            return;
        }// end function

    }
}
