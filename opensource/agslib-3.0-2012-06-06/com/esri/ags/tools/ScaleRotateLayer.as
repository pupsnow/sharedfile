package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import flash.geom.*;

    public class ScaleRotateLayer extends EventDispatcher
    {
        private var _tool:EditTool;
        private var _map:Map;
        private var _vertexIndex:int;
        private var _arrScaleVertices:Array;
        private var _arrExtentPoints:Array;
        private var _mouseDownPoint:MapPoint;
        private var _scaleVertexSymbol:SimpleMarkerSymbol;
        private var _skewVertexSymbol:SimpleMarkerSymbol;
        private var _rotateVertexSymbol:SimpleMarkerSymbol;
        private var _rotateLineSymbol:SimpleLineSymbol;
        public var selectedVertex:Graphic;
        public var anchorVertex:Graphic;
        public var movingVertexGeometry:MapPoint;
        public var polyLine:Polyline;
        public var arrGraphics:Array;

        public function ScaleRotateLayer()
        {
            this._scaleVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, 12, 16777215, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 1, 1));
            this._skewVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 10, 16777215, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 1, 1));
            this._rotateVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, 12, 65280, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 1, 1));
            this._rotateLineSymbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_DASH, 0, 1, 1);
            this.polyLine = new Polyline();
            this.arrGraphics = [];
            return;
        }// end function

        public function init(map:Map, tool:EditTool) : void
        {
            this._tool = tool;
            this._map = map;
            this._map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.mapExtentChangeHandler);
            this._tool.addEventListener(EditEvent.TOOL_DEACTIVATE, this.editToolDeactiveHandler);
            return;
        }// end function

        private function vertex_mouseOver(event:MouseEvent) : void
        {
            this.selectedVertex = event.target as Graphic;
            this._vertexIndex = this.selectedVertex.attributes.index;
            switch(this._vertexIndex)
            {
                case 0:
                {
                    this.anchorVertex = this._arrScaleVertices[4] as Graphic;
                    break;
                }
                case 1:
                {
                    this.anchorVertex = this._arrScaleVertices[5] as Graphic;
                    break;
                }
                case 2:
                {
                    this.anchorVertex = this._arrScaleVertices[6] as Graphic;
                    break;
                }
                case 3:
                {
                    this.anchorVertex = this._arrScaleVertices[7] as Graphic;
                    break;
                }
                case 4:
                {
                    this.anchorVertex = this._arrScaleVertices[0] as Graphic;
                    break;
                }
                case 5:
                {
                    this.anchorVertex = this._arrScaleVertices[1] as Graphic;
                    break;
                }
                case 6:
                {
                    this.anchorVertex = this._arrScaleVertices[2] as Graphic;
                    break;
                }
                case 7:
                {
                    this.anchorVertex = this._arrScaleVertices[3] as Graphic;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.selectedVertex.attributes.position == "rotateMiddle")
            {
                dispatchEvent(new Event("rotateVertexMouseOver"));
            }
            else
            {
                dispatchEvent(new Event("scaleVertexMouseOver"));
            }
            return;
        }// end function

        private function vertex_mouseOut(event:MouseEvent) : void
        {
            if (this.selectedVertex.attributes.position == "rotateMiddle")
            {
                dispatchEvent(new Event("rotateVertexMouseOut"));
            }
            else
            {
                dispatchEvent(new Event("scaleVertexMouseOut"));
            }
            return;
        }// end function

        private function vertex_mouseDown(event:MouseEvent) : void
        {
            var _loc_2:Graphic = null;
            if (this.selectedVertex)
            {
                this._mouseDownPoint = this._map.toMapFromStage(event.stageX, event.stageY);
                this.movingVertexGeometry = this.selectedVertex.geometry as MapPoint;
                for each (_loc_2 in this.arrGraphics)
                {
                    
                    if (_loc_2 !== this.selectedVertex)
                    {
                        _loc_2.removeEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
                    }
                }
                if (this.selectedVertex.attributes.position == "rotateMiddle")
                {
                    dispatchEvent(new Event("rotateVertexMoveStart"));
                }
                else
                {
                    dispatchEvent(new Event("scaleVertexMoveStart"));
                }
                this._map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
                this._map.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            return;
        }// end function

        private function mouseMoveFirstHandler(event:MouseEvent) : void
        {
            if (this.selectedVertex.attributes.position == "rotateMiddle")
            {
                dispatchEvent(new Event("rotateVertexMoveFirst"));
            }
            else
            {
                dispatchEvent(new Event("scaleVertexMoveFirst"));
            }
            event.target.addEventListener(MouseEvent.CLICK, this.vertexMouseClickHandler, false, 1, true);
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this._map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            return;
        }// end function

        private function mouseMoveNextHandler(event:MouseEvent) : void
        {
            var _loc_2:* = this._map.toMapFromStage(event.stageX, event.stageY).x - this._mouseDownPoint.x;
            var _loc_3:* = this._map.toMapFromStage(event.stageX, event.stageY).y - this._mouseDownPoint.y;
            this._mouseDownPoint.x = this._mouseDownPoint.x + _loc_2;
            this._mouseDownPoint.y = this._mouseDownPoint.y + _loc_3;
            this.movingVertexGeometry = new MapPoint(this.movingVertexGeometry.x + _loc_2, this.movingVertexGeometry.y + _loc_3);
            if (this.selectedVertex.attributes.position == "rotateMiddle")
            {
                dispatchEvent(new Event("rotateVertexMove"));
            }
            else
            {
                dispatchEvent(new Event("scaleVertexMove"));
            }
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            var _loc_2:Graphic = null;
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            this._map.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            for each (_loc_2 in this.arrGraphics)
            {
                
                _loc_2.addEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
            }
            if (this.selectedVertex.attributes.position == "rotateMiddle")
            {
                dispatchEvent(new Event("rotateVertexMoveStop"));
            }
            else
            {
                dispatchEvent(new Event("scaleVertexMoveStop"));
            }
            return;
        }// end function

        private function vertexMouseClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            event.target.removeEventListener(MouseEvent.CLICK, this.vertexMouseClickHandler);
            return;
        }// end function

        public function load(extent:Extent, scaleActive:Boolean, rotateActive:Boolean, scaleRotateActive:Boolean) : void
        {
            var _loc_6:Point = null;
            this.clear();
            this._arrScaleVertices = [];
            this._arrExtentPoints = [new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmax, extent.ymax), new MapPoint(extent.xmax, extent.ymin), new MapPoint(extent.xmin, extent.ymin)];
            var _loc_5:int = 0;
            while (_loc_5 < (this._arrExtentPoints.length - 1))
            {
                
                if (!scaleActive)
                {
                }
                if (scaleRotateActive)
                {
                    this.addGraphic(this._arrExtentPoints[_loc_5], _loc_5 * 2, this._scaleVertexSymbol);
                    this.addGraphic(new MapPoint((this._arrExtentPoints[_loc_5].x + this._arrExtentPoints[(_loc_5 + 1)].x) / 2, (this._arrExtentPoints[_loc_5].y + this._arrExtentPoints[(_loc_5 + 1)].y) / 2), _loc_5 * 2 + 1, this._skewVertexSymbol);
                }
                if (_loc_5 == 1)
                {
                    if (!rotateActive)
                    {
                    }
                }
                if (scaleRotateActive)
                {
                    _loc_6 = this._map.toScreen(new MapPoint((this._arrExtentPoints[_loc_5].x + this._arrExtentPoints[(_loc_5 + 1)].x) / 2, (this._arrExtentPoints[_loc_5].y + this._arrExtentPoints[(_loc_5 + 1)].y) / 2));
                    _loc_6.y = _loc_6.y - 30;
                    this.addGraphic(new Polyline([[new MapPoint((this._arrExtentPoints[_loc_5].x + this._arrExtentPoints[(_loc_5 + 1)].x) / 2, (this._arrExtentPoints[_loc_5].y + this._arrExtentPoints[(_loc_5 + 1)].y) / 2), this._map.toMap(_loc_6)]]), 9, this._rotateLineSymbol);
                    this.addGraphic(this._map.toMap(_loc_6), 8, this._rotateVertexSymbol);
                }
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        private function addGraphic(geom:Geometry, index:int, symbol:Symbol) : void
        {
            var _loc_4:Graphic = null;
            var _loc_5:String = null;
            _loc_4 = new Graphic(geom, symbol);
            if (_loc_4.geometry is MapPoint)
            {
                switch(index)
                {
                    case 0:
                    {
                        _loc_5 = "bottomLeft";
                        break;
                    }
                    case 1:
                    {
                        _loc_5 = "leftMiddle";
                        break;
                    }
                    case 2:
                    {
                        _loc_5 = "topLeft";
                        break;
                    }
                    case 3:
                    {
                        _loc_5 = "topMiddle";
                        break;
                    }
                    case 4:
                    {
                        _loc_5 = "topRight";
                        break;
                    }
                    case 5:
                    {
                        _loc_5 = "rightMiddle";
                        break;
                    }
                    case 6:
                    {
                        _loc_5 = "bottomRight";
                        break;
                    }
                    case 7:
                    {
                        _loc_5 = "bottomMiddle";
                        break;
                    }
                    case 8:
                    {
                        _loc_5 = "rotateMiddle";
                        _loc_4.name = "rotateMiddle";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_4.attributes = {index:index, position:_loc_5};
                _loc_4.mouseChildren = false;
                _loc_4.addEventListener(MouseEvent.MOUSE_OVER, this.vertex_mouseOver);
                _loc_4.addEventListener(MouseEvent.MOUSE_OUT, this.vertex_mouseOut);
                _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.vertex_mouseDown);
                if (index != 8)
                {
                    this._arrScaleVertices.push(_loc_4);
                }
            }
            else
            {
                _loc_4.name = "rotateVertexLine";
            }
            this.arrGraphics.push(_loc_4);
            this._map.defaultGraphicsLayer.add(_loc_4);
            return;
        }// end function

        private function mapExtentChangeHandler(event:ExtentEvent) : void
        {
            var _loc_2:Graphic = null;
            var _loc_3:Graphic = null;
            var _loc_4:Point = null;
            if (event.levelChange)
            {
                _loc_2 = this.getGraphicByName("rotateMiddle");
                _loc_3 = this.getGraphicByName("rotateVertexLineGraphic");
                if (_loc_2)
                {
                }
                if (_loc_3)
                {
                    _loc_4 = this._map.toScreen(new MapPoint((this._arrExtentPoints[1].x + this._arrExtentPoints[2].x) / 2, (this._arrExtentPoints[1].y + this._arrExtentPoints[2].y) / 2));
                    _loc_4.y = _loc_4.y - 30;
                    _loc_2.geometry = this._map.toMap(_loc_4);
                    _loc_3.geometry = new Polyline([[new MapPoint((this._arrExtentPoints[1].x + this._arrExtentPoints[2].x) / 2, (this._arrExtentPoints[1].y + this._arrExtentPoints[2].y) / 2), this._map.toMap(_loc_4)]]);
                }
            }
            return;
        }// end function

        private function getGraphicByName(name:String) : Graphic
        {
            var _loc_2:Graphic = null;
            var _loc_3:Graphic = null;
            for each (_loc_3 in this.arrGraphics)
            {
                
                if (_loc_3.name == name)
                {
                    _loc_2 = _loc_3;
                    break;
                }
            }
            return _loc_2;
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
            this._map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
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
