package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.*;

    public class DrawTool extends BaseTool
    {
        private var m_map:Map;
        private var m_active:Boolean = false;
        private var m_fillSymbol:Symbol;
        private var m_lineSymbol:Symbol;
        private var m_markerSymbol:Symbol;
        private var m_graphicsLayer:GraphicsLayer;
        private var m_respectDrawingVertexOrder:Boolean;
        private var m_numberOfCirclePoints:int = 100;
        private var m_showDrawTips:Boolean = true;
        private var m_drawType:String;
        private var polyline:Polyline;
        private var polygon:Polygon;
        private var multipoint:Multipoint;
        private var extent:Extent;
        private var circle:Polygon;
        private var ellipse:Polygon;
        private var m_graphic:Graphic;
        private var m_snapDistance:Number = 15;
        private var m_snapMode:String = "onDemand";
        private var m_snapOption:String = "edgeAndVertex";
        private var m_snappingEnabled:Boolean = true;
        private var m_snapGraphic:Graphic;
        private var m_snapPointGraphic:Graphic;
        private var m_lastTimer:Number = 0;
        private var m_mapLayers:ArrayCollection;
        private var m_tempLayer:GraphicsLayer;
        private var m_startPoint:MapPoint;
        private var m_pointArray:Array;
        private var m_lastScreenPoint:Point;
        private var m_finishedDrawing:Boolean;
        private var m_mouseMove:Boolean;
        private var m_isSnapping:Boolean;
        private var m_toolTip:IToolTip;
        private var m_toolTipText:String;
        private var m_circleCenter:MapPoint;
        private var m_defaultDrawSize:Number = 100;
        private var m_circleRadius:Number;
        private var m_ellipseCenter:MapPoint;
        private var m_ellipseScreenCenter:Point;
        private var m_ellipseRadiusX:Number;
        private var m_ellipseRadiusY:Number;
        private var m_extentCenter:MapPoint;
        private var m_minFreehandPointInterval:Number = 10;
        private var m_snapToVertexSymbol:SimpleMarkerSymbol;
        private var m_snapToEdgeSymbol:SimpleMarkerSymbol;
        public static const MAPPOINT:String = "mappoint";
        public static const MULTIPOINT:String = "multipoint";
        public static const POLYLINE:String = "polyline";
        public static const FREEHAND_POLYLINE:String = "freehandpolyline";
        public static const POLYGON:String = "polygon";
        public static const LINE:String = "line";
        public static const FREEHAND_POLYGON:String = "freehandpolygon";
        public static const EXTENT:String = "extent";
        public static const CIRCLE:String = "circle";
        public static const ELLIPSE:String = "ellipse";
        public static const SNAP_MODE_ALWAYS_ON:String = "alwaysOn";
        public static const SNAP_MODE_OFF:String = "off";
        public static const SNAP_MODE_ON_DEMAND:String = "onDemand";
        public static const SNAP_OPTION_EDGE:String = "edge";
        public static const SNAP_OPTION_VERTEX:String = "vertex";
        public static const SNAP_OPTION_EDGE_AND_VERTEX:String = "edgeAndVertex";

        public function DrawTool(map:Map = null)
        {
            this.m_fillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0, 0.5, new SimpleLineSymbol());
            this.m_tempLayer = new GraphicsLayer();
            this.m_snapToVertexSymbol = new SimpleMarkerSymbol("cross", 18, 0, 1, 0, 0, 0, new SimpleLineSymbol("solid", 0, 1, 4));
            this.m_snapToEdgeSymbol = new SimpleMarkerSymbol("cross", 18, 0, 1, 0, 0, 0, new SimpleLineSymbol("solid", 0, 1, 2));
            super(map);
            return;
        }// end function

        public function get fillSymbol() : Symbol
        {
            return this.m_fillSymbol;
        }// end function

        private function set _571283205fillSymbol(value:Symbol) : void
        {
            if (value != this.m_fillSymbol)
            {
                this.m_fillSymbol = value;
            }
            return;
        }// end function

        public function get lineSymbol() : Symbol
        {
            return this.m_lineSymbol;
        }// end function

        private function set _182302036lineSymbol(value:Symbol) : void
        {
            if (value != this.m_lineSymbol)
            {
                this.m_lineSymbol = value;
            }
            return;
        }// end function

        public function get markerSymbol() : Symbol
        {
            return this.m_markerSymbol;
        }// end function

        private function set _1854578062markerSymbol(value:Symbol) : void
        {
            if (value != this.m_markerSymbol)
            {
                this.m_markerSymbol = value;
            }
            return;
        }// end function

        public function get respectDrawingVertexOrder() : Boolean
        {
            return this.m_respectDrawingVertexOrder;
        }// end function

        private function set _51670670respectDrawingVertexOrder(value:Boolean) : void
        {
            if (value != this.m_respectDrawingVertexOrder)
            {
                this.m_respectDrawingVertexOrder = value;
            }
            return;
        }// end function

        public function get graphicsLayer() : GraphicsLayer
        {
            return this.m_graphicsLayer;
        }// end function

        public function set graphicsLayer(value:GraphicsLayer) : void
        {
            if (value != this.m_graphicsLayer)
            {
                this.m_graphicsLayer = value;
            }
            return;
        }// end function

        override public function get map() : Map
        {
            return super.map;
        }// end function

        override public function set map(map:Map) : void
        {
            this.resetVars();
            super.map = map;
            return;
        }// end function

        public function get showDrawTips() : Boolean
        {
            return this.m_showDrawTips;
        }// end function

        private function set _1678859079showDrawTips(value:Boolean) : void
        {
            if (value != this.m_showDrawTips)
            {
                this.m_showDrawTips = value;
            }
            return;
        }// end function

        public function get defaultDrawSize() : Number
        {
            return this.m_defaultDrawSize;
        }// end function

        private function set _1171171526defaultDrawSize(value:Number) : void
        {
            if (value != this.m_defaultDrawSize)
            {
                this.m_defaultDrawSize = value;
            }
            return;
        }// end function

        public function get snapDistance() : Number
        {
            return this.m_snapDistance;
        }// end function

        private function set _236816929snapDistance(value:Number) : void
        {
            if (value != this.m_snapDistance)
            {
                this.m_snapDistance = value;
                if (this.m_snapDistance != 0)
                {
                }
                if (this.m_snapMode == SNAP_MODE_OFF)
                {
                    this.m_snappingEnabled = false;
                    this.m_isSnapping = false;
                }
                else
                {
                    this.m_snappingEnabled = true;
                }
            }
            return;
        }// end function

        public function get snapMode() : String
        {
            return this.m_snapMode;
        }// end function

        private function set _283748493snapMode(value:String) : void
        {
            if (value != this.m_snapMode)
            {
                this.m_snapMode = value;
                if (this.m_snapDistance != 0)
                {
                }
                if (this.m_snapMode == SNAP_MODE_OFF)
                {
                    this.m_snappingEnabled = false;
                    this.m_isSnapping = false;
                }
                else
                {
                    this.m_snappingEnabled = true;
                }
            }
            return;
        }// end function

        public function get snapOption() : String
        {
            return this.m_snapOption;
        }// end function

        private function set _2136939297snapOption(value:String) : void
        {
            if (value != this.m_snapOption)
            {
                this.m_snapOption = value;
                if (this.m_snapOption != SNAP_OPTION_EDGE)
                {
                }
                if (this.m_snapOption != SNAP_OPTION_VERTEX)
                {
                    this.m_snapOption = SNAP_OPTION_EDGE_AND_VERTEX;
                }
            }
            return;
        }// end function

        public function get minFreehandPointInterval() : Number
        {
            return this.m_minFreehandPointInterval;
        }// end function

        private function set _595995176minFreehandPointInterval(value:Number) : void
        {
            if (value != this.m_minFreehandPointInterval)
            {
                this.m_minFreehandPointInterval = value;
            }
            return;
        }// end function

        public function activate(drawType:String, enableGraphicsLayerMouseEvents:Boolean = false) : void
        {
            this.deactivate();
            if (!this.map)
            {
                return;
            }
            var _loc_3:* = this.map.panEnabled;
            var _loc_4:* = this.map.rubberbandZoomEnabled;
            if (this.m_active == false)
            {
                deactivateMapTools(true, false, false, !enableGraphicsLayerMouseEvents, true);
                this.m_active = true;
            }
            if (this.m_finishedDrawing == false)
            {
                this.removeGraphic(this.m_graphic);
            }
            this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.map_mouseDownHandler);
            this.map.addEventListener(MouseEvent.ROLL_OVER, this.map_rollOverHandler, false, -1, true);
            this.map.addEventListener(MouseEvent.ROLL_OUT, this.map_rollOutHandler, false, -1, true);
            this.m_mapLayers = this.map.layers as ArrayCollection;
            switch(drawType)
            {
                case MAPPOINT:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipMappoint");
                    this.map.panEnabled = _loc_3;
                    this.map.rubberbandZoomEnabled = _loc_4;
                    this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler, false, -1, true);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler, false, -1, true);
                    break;
                }
                case MULTIPOINT:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipMultipointStart");
                    this.map.panEnabled = _loc_3;
                    this.map.rubberbandZoomEnabled = _loc_4;
                    this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler, false, -1, true);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler, false, -1, true);
                    break;
                }
                case POLYLINE:
                case POLYGON:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolylinePolygonStart");
                    this.map.panEnabled = _loc_3;
                    this.map.rubberbandZoomEnabled = _loc_4;
                    this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler, false, -1, true);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler, false, -1, true);
                    break;
                }
                case LINE:
                case FREEHAND_POLYLINE:
                case FREEHAND_POLYGON:
                case EXTENT:
                case CIRCLE:
                case ELLIPSE:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipOther");
                    this.map.panEnabled = false;
                    this.map.rubberbandZoomEnabled = false;
                    this.map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler, false, -1, true);
                    break;
                }
                default:
                {
                    return;
                    break;
                }
            }
            this.m_drawType = drawType;
            return;
        }// end function

        public function deactivate() : void
        {
            if (!this.m_active)
            {
                return;
            }
            this.deactivate2();
            this.m_active = false;
            this.m_drawType = null;
            this.m_mouseMove = false;
            activateMapTools(true, false, false, true, true);
            return;
        }// end function

        private function map_rollOverHandler(event:MouseEvent) : void
        {
            if (!this.map.loaded)
            {
                return;
            }
            if (this.m_showDrawTips)
            {
                if (!this.m_toolTip)
                {
                    this.m_toolTip = ToolTipManager.createToolTip(this.m_toolTipText, event.stageX + 10, event.stageY - 10);
                }
                else
                {
                    this.m_toolTip.visible = true;
                    this.m_toolTip.text = this.m_toolTipText;
                }
            }
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            return;
        }// end function

        private function map_rollOutHandler(event:MouseEvent) : void
        {
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            if (this.m_toolTip)
            {
                this.m_toolTip.visible = false;
            }
            return;
        }// end function

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            if (this.m_toolTip)
            {
                this.m_toolTip.text = this.m_toolTipText;
                this.m_toolTip.x = event.stageX + 10;
                this.m_toolTip.y = event.stageY - 10;
            }
            return;
        }// end function

        private function resetVars() : void
        {
            this.m_drawType = null;
            return;
        }// end function

        private function deactivate2() : void
        {
            if (!this.map)
            {
                return;
            }
            if (!this.m_finishedDrawing)
            {
                this.removeGraphic(this.m_graphic);
            }
            if (this.m_toolTip)
            {
                ToolTipManager.destroyToolTip(this.m_toolTip);
                this.m_toolTip = null;
            }
            if (this.m_snapGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_snapGraphic);
                this.m_snapGraphic = null;
            }
            if (this.m_snapPointGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_snapPointGraphic);
                this.m_snapPointGraphic = null;
            }
            this.map.removeEventListener(MouseEvent.ROLL_OVER, this.map_rollOverHandler);
            this.map.removeEventListener(MouseEvent.ROLL_OUT, this.map_rollOutHandler);
            this.map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
            this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler);
            this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
            this.map.removeEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler);
            return;
        }// end function

        private function map_mouseMoveFirstHandler(event:MouseEvent) : void
        {
            var _loc_2:MapPoint = null;
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            if (!this.map.loaded)
            {
                return;
            }
            if (this.m_snappingEnabled)
            {
                _loc_2 = this.map.toMapFromStage(event.stageX, event.stageY);
                _loc_3 = 0;
                if (this.map.wrapAround180)
                {
                }
                if (this.map.extent.spatialReference.info)
                {
                    _loc_4 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                    _loc_2.x = _loc_4.x;
                    _loc_3 = _loc_4.frameId;
                }
                this.checkForSnapping(_loc_2, this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false)), _loc_3);
            }
            return;
        }// end function

        private function map_clickFirstHandler(event:MapMouseEvent) : void
        {
            if (!this.map.loaded)
            {
                return;
            }
            this.m_finishedDrawing = false;
            this.m_graphic = new Graphic();
            dispatchEvent(new DrawEvent(DrawEvent.DRAW_START, this.m_graphic));
            var _loc_2:* = event.mapPoint;
            switch(this.m_drawType)
            {
                case MAPPOINT:
                {
                    if (this.m_snapGraphic)
                    {
                        this.m_snapGraphic.visible = false;
                    }
                    if (this.m_snapPointGraphic)
                    {
                        this.m_snapPointGraphic.visible = false;
                    }
                    if (this.m_snappingEnabled)
                    {
                    }
                    this.m_graphic.geometry = this.m_isSnapping ? (this.m_snapPointGraphic.geometry) : (_loc_2);
                    this.m_graphic.geometry.spatialReference = this.map.spatialReference;
                    this.m_graphic.symbol = this.m_markerSymbol;
                    if (this.m_graphicsLayer)
                    {
                        this.graphicsLayer.add(this.m_graphic);
                    }
                    this.m_finishedDrawing = true;
                    if (this.map.wrapAround180)
                    {
                        this.m_graphic.geometry = MapPoint(this.m_graphic.geometry).normalize();
                    }
                    dispatchEvent(new DrawEvent(DrawEvent.DRAW_END, this.m_graphic));
                    this.m_graphic = null;
                    break;
                }
                case MULTIPOINT:
                {
                    this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipMultipointFinish");
                    this.multipoint = new Multipoint();
                    this.multipoint.spatialReference = this.map.spatialReference;
                    this.m_pointArray = [];
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                    }
                    else
                    {
                        this.m_pointArray.push(_loc_2);
                    }
                    this.multipoint.points = this.m_pointArray;
                    this.m_graphic.geometry = this.multipoint;
                    this.m_graphic.symbol = this.m_markerSymbol;
                    this.addGraphic(this.m_graphic);
                    this.m_lastTimer = getTimer();
                    break;
                }
                case POLYLINE:
                {
                    this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
                    this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                    this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler);
                    this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
                    this.map.addEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler);
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolylinePolygonComplete");
                    this.polyline = new Polyline();
                    this.polyline.spatialReference = this.map.spatialReference;
                    this.m_pointArray = [];
                    this.polyline.paths = [];
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry, this.m_snapPointGraphic.geometry);
                    }
                    else
                    {
                        this.m_pointArray.push(_loc_2, _loc_2);
                    }
                    this.polyline.paths.push(this.m_pointArray);
                    this.m_graphic.geometry = this.polyline;
                    this.m_graphic.symbol = this.m_lineSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case POLYGON:
                {
                    this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
                    this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                    this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler);
                    this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                    this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
                    this.map.addEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler);
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolygonContinueDrawing");
                    this.polygon = new Polygon();
                    this.polygon.spatialReference = this.map.spatialReference;
                    this.m_pointArray = [];
                    this.polygon.rings = [];
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry, this.m_snapPointGraphic.geometry);
                    }
                    else
                    {
                        this.m_pointArray.push(_loc_2, _loc_2);
                    }
                    this.polygon.rings.push(this.m_pointArray);
                    this.m_graphic.geometry = this.polygon;
                    this.m_graphic.symbol = this.m_fillSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function map_clickNextHandler(event:MapMouseEvent) : void
        {
            var _loc_3:uint = 0;
            var _loc_2:* = event.mapPoint;
            switch(this.m_drawType)
            {
                case MULTIPOINT:
                {
                    _loc_3 = getTimer();
                    if (_loc_3 - this.m_lastTimer < 300)
                    {
                        this.m_finishedDrawing = true;
                        this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipMultipointStart");
                        if (this.m_snapGraphic)
                        {
                            this.m_snapGraphic.visible = false;
                        }
                        if (this.m_snapPointGraphic)
                        {
                            this.m_snapPointGraphic.visible = false;
                        }
                        this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler);
                        this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
                        this.removeLayerEndDraw();
                        this.m_graphic = null;
                    }
                    else
                    {
                        if (this.m_snappingEnabled)
                        {
                        }
                        if (this.m_isSnapping)
                        {
                            this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                        }
                        else
                        {
                            this.m_pointArray.push(_loc_2);
                        }
                        this.multipoint.points = this.multipoint.points;
                        this.m_graphic.refresh();
                    }
                    this.m_lastTimer = _loc_3;
                    break;
                }
                case POLYLINE:
                {
                    this.m_pointArray.pop();
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                    }
                    else
                    {
                        this.m_pointArray.push(_loc_2);
                        this.m_pointArray.push(_loc_2);
                    }
                    this.polyline.paths = this.polyline.paths;
                    this.m_graphic.refresh();
                    break;
                }
                case POLYGON:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolylinePolygonComplete");
                    this.m_pointArray.pop();
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                        this.m_pointArray.push(this.m_snapPointGraphic.geometry);
                    }
                    else
                    {
                        this.m_pointArray.push(_loc_2);
                        this.m_pointArray.push(_loc_2);
                    }
                    this.polygon.rings = this.polygon.rings;
                    this.m_graphic.refresh();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function map_doubleClickHandler(event:MouseEvent) : void
        {
            var _loc_2:Graphics = null;
            this.m_finishedDrawing = true;
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.removeEventListener(MapMouseEvent.MAP_CLICK, this.map_clickNextHandler);
            this.map.removeEventListener(MouseEvent.DOUBLE_CLICK, this.map_doubleClickHandler);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler, false, -1, true);
            this.map.addEventListener(MapMouseEvent.MAP_CLICK, this.map_clickFirstHandler, false, -1, true);
            if (this.m_snapGraphic)
            {
                this.m_snapGraphic.visible = false;
            }
            if (this.m_snapPointGraphic)
            {
                this.m_snapPointGraphic.visible = false;
            }
            switch(this.m_drawType)
            {
                case POLYLINE:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolylinePolygonStart");
                    this.m_pointArray.pop();
                    this.m_pointArray.pop();
                    this.polyline.paths = this.polyline.paths;
                    if (this.m_pointArray.length >= 2)
                    {
                        this.removeLayerEndDraw();
                    }
                    else
                    {
                        this.removeGraphic(this.m_graphic);
                    }
                    break;
                }
                case POLYGON:
                {
                    this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipPolylinePolygonStart");
                    this.m_pointArray.pop();
                    this.m_pointArray.pop();
                    this.m_pointArray.push(this.m_pointArray[0]);
                    this.polygon.rings = this.polygon.rings;
                    if (!GeomUtils.isClockwise(this.m_pointArray))
                    {
                    }
                    if (!this.m_respectDrawingVertexOrder)
                    {
                        this.m_pointArray.reverse();
                    }
                    if (this.m_pointArray.length > 3)
                    {
                        this.removeLayerEndDraw();
                    }
                    else
                    {
                        this.removeGraphic(this.m_graphic);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.m_graphic = null;
            return;
        }// end function

        private function map_mouseDownHandler(event:MapMouseEvent) : void
        {
            if (!this.map.loaded)
            {
                return;
            }
            this.m_mouseMove = false;
            this.m_finishedDrawing = false;
            if (this.m_toolTip)
            {
                this.m_toolTip.visible = false;
            }
            this.m_graphic = new Graphic();
            dispatchEvent(new DrawEvent(DrawEvent.DRAW_START, this.m_graphic));
            this.map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.addEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            var _loc_2:* = this.map.toMapFromStage(event.stageX, event.stageY);
            switch(this.m_drawType)
            {
                case FREEHAND_POLYLINE:
                {
                    this.m_lastScreenPoint = new Point(event.stageX, event.stageY);
                    this.polyline = new Polyline();
                    this.polyline.spatialReference = this.map.spatialReference;
                    this.polyline.paths = [];
                    this.m_pointArray = [];
                    this.m_pointArray.push(_loc_2);
                    this.polyline.paths.push(this.m_pointArray);
                    this.m_graphic.geometry = this.polyline;
                    this.m_graphic.symbol = this.m_lineSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case LINE:
                {
                    this.polyline = new Polyline();
                    this.polyline.spatialReference = this.map.spatialReference;
                    this.polyline.paths = [];
                    this.m_pointArray = [];
                    this.m_pointArray.push(_loc_2, _loc_2);
                    this.polyline.paths.push(this.m_pointArray);
                    this.m_graphic.geometry = this.polyline;
                    this.m_graphic.symbol = this.m_lineSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case FREEHAND_POLYGON:
                {
                    this.m_lastScreenPoint = new Point(event.stageX, event.stageY);
                    this.polygon = new Polygon();
                    this.polygon.spatialReference = this.map.spatialReference;
                    this.polygon.rings = [];
                    this.m_pointArray = [];
                    this.m_pointArray.push(_loc_2);
                    this.polygon.rings.push(this.m_pointArray);
                    this.m_graphic.geometry = this.polygon;
                    this.m_graphic.symbol = this.m_fillSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case EXTENT:
                {
                    this.m_startPoint = _loc_2;
                    this.m_extentCenter = _loc_2;
                    this.extent = new Extent();
                    this.extent.spatialReference = this.map.spatialReference;
                    this.extent.xmin = this.m_startPoint.x;
                    this.extent.ymin = this.m_startPoint.y;
                    this.extent.xmax = this.extent.xmin;
                    this.extent.ymax = this.extent.ymin;
                    this.m_graphic.geometry = this.extent;
                    this.m_graphic.symbol = this.m_fillSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case CIRCLE:
                {
                    this.circle = new Polygon();
                    this.circle.spatialReference = this.map.spatialReference;
                    this.m_circleCenter = _loc_2;
                    this.m_circleRadius = 1;
                    this.m_graphic.geometry = this.circle;
                    this.m_graphic.symbol = this.m_fillSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                case ELLIPSE:
                {
                    this.ellipse = new Polygon();
                    this.ellipse.spatialReference = this.map.spatialReference;
                    this.m_ellipseCenter = _loc_2;
                    this.m_ellipseScreenCenter = this.map.toScreen(_loc_2);
                    this.m_ellipseRadiusX = 2;
                    this.m_ellipseRadiusY = 1;
                    this.m_graphic.geometry = this.ellipse;
                    this.m_graphic.symbol = this.m_fillSymbol;
                    this.addGraphic(this.m_graphic);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function map_mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_4:Object = null;
            var _loc_5:MapPoint = null;
            var _loc_6:Point = null;
            var _loc_7:Object = null;
            var _loc_8:MapPoint = null;
            var _loc_9:Point = null;
            this.m_mouseMove = true;
            var _loc_2:* = this.map.toMapFromStage(event.stageX, event.stageY);
            var _loc_3:Number = 0;
            switch(this.m_drawType)
            {
                case POLYLINE:
                {
                    if (this.m_snappingEnabled)
                    {
                        if (this.map.wrapAround180)
                        {
                        }
                        if (this.map.extent.spatialReference.info)
                        {
                            _loc_4 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                            _loc_5 = new MapPoint(_loc_4.x, _loc_2.y, _loc_2.spatialReference);
                            _loc_3 = _loc_4.frameId;
                            this.checkForSnapping(_loc_5, this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false)), _loc_3);
                        }
                        else
                        {
                            this.checkForSnapping(_loc_2, this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false)), _loc_3);
                        }
                    }
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                    }
                    this.m_pointArray[(this.m_pointArray.length - 1)] = this.m_snapPointGraphic.geometry ? (this.m_snapPointGraphic.geometry) : (_loc_2);
                    this.polyline.paths = this.polyline.paths;
                    this.m_graphic.refresh();
                    break;
                }
                case LINE:
                {
                    this.m_pointArray[(this.m_pointArray.length - 1)] = _loc_2;
                    this.polyline.paths = this.polyline.paths;
                    this.m_graphic.refresh();
                    break;
                }
                case FREEHAND_POLYLINE:
                {
                    _loc_6 = new Point(event.stageX, event.stageY);
                    if (Point.distance(this.m_lastScreenPoint, _loc_6) > this.m_minFreehandPointInterval)
                    {
                        this.m_lastScreenPoint = _loc_6;
                        this.m_pointArray.push(_loc_2);
                        this.polyline.paths = this.polyline.paths;
                        this.m_graphic.refresh();
                    }
                    break;
                }
                case POLYGON:
                {
                    if (this.m_snappingEnabled)
                    {
                        if (this.map.wrapAround180)
                        {
                        }
                        if (this.map.extent.spatialReference.info)
                        {
                            _loc_7 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                            _loc_8 = new MapPoint(_loc_7.x, _loc_2.y, _loc_2.spatialReference);
                            _loc_3 = _loc_7.frameId;
                            this.checkForSnapping(_loc_8, this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false)), _loc_3);
                        }
                        else
                        {
                            this.checkForSnapping(_loc_2, this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false)), _loc_3);
                        }
                    }
                    if (this.m_snappingEnabled)
                    {
                    }
                    if (this.m_isSnapping)
                    {
                    }
                    this.m_pointArray[(this.m_pointArray.length - 1)] = this.m_snapPointGraphic.geometry ? (this.m_snapPointGraphic.geometry) : (_loc_2);
                    this.polygon.rings = this.polygon.rings;
                    this.m_graphic.refresh();
                    break;
                }
                case FREEHAND_POLYGON:
                {
                    _loc_9 = new Point(event.stageX, event.stageY);
                    if (Point.distance(this.m_lastScreenPoint, _loc_9) > this.m_minFreehandPointInterval)
                    {
                        this.m_lastScreenPoint = _loc_9;
                        this.m_pointArray.push(_loc_2);
                        this.polygon.rings = this.polygon.rings;
                        this.m_graphic.refresh();
                    }
                    break;
                }
                case EXTENT:
                {
                    this.extent.xmin = Math.min(this.m_startPoint.x, _loc_2.x);
                    this.extent.ymin = Math.min(this.m_startPoint.y, _loc_2.y);
                    this.extent.xmax = this.extent.xmin + Math.abs(this.m_startPoint.x - _loc_2.x);
                    this.extent.ymax = this.extent.ymin + Math.abs(this.m_startPoint.y - _loc_2.y);
                    this.m_graphic.refresh();
                    break;
                }
                case CIRCLE:
                {
                    this.m_circleRadius = this.calculateRadius(_loc_2);
                    this.updateCirclePolygon();
                    this.m_graphic.refresh();
                    break;
                }
                case ELLIPSE:
                {
                    this.m_ellipseRadiusX = Math.abs(_loc_2.x - this.m_ellipseCenter.x);
                    this.m_ellipseRadiusY = Math.abs(_loc_2.y - this.m_ellipseCenter.y);
                    this.updateEllipsePolygon();
                    this.m_graphic.refresh();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function map_mouseUpHandler(event:MouseEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            this.m_finishedDrawing = true;
            if (this.m_toolTip)
            {
                this.m_toolTip.visible = true;
            }
            this.m_toolTipText = ESRIMessageCodes.getString("drawTooltipOther");
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            this.map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler, false, -1, true);
            switch(this.m_drawType)
            {
                case LINE:
                {
                    if (this.m_pointArray[0] != this.m_pointArray[1])
                    {
                        this.removeLayerEndDraw();
                    }
                    else
                    {
                        this.removeGraphic(this.m_graphic);
                    }
                    break;
                }
                case FREEHAND_POLYLINE:
                {
                    if (this.m_pointArray.length >= 2)
                    {
                        this.removeLayerEndDraw();
                    }
                    else
                    {
                        this.removeGraphic(this.m_graphic);
                    }
                    break;
                }
                case FREEHAND_POLYGON:
                {
                    this.m_pointArray.push(this.m_pointArray[0]);
                    this.polygon.rings = this.polygon.rings;
                    if (!GeomUtils.isClockwise(this.m_pointArray))
                    {
                    }
                    if (!this.m_respectDrawingVertexOrder)
                    {
                        this.m_pointArray.reverse();
                    }
                    if (this.m_pointArray.length > 3)
                    {
                        this.removeLayerEndDraw();
                    }
                    else
                    {
                        this.removeGraphic(this.m_graphic);
                    }
                    break;
                }
                case EXTENT:
                {
                    if (!this.m_mouseMove)
                    {
                        _loc_2 = this.map.toScreenX(this.m_extentCenter.x);
                        _loc_3 = this.map.toScreenY(this.m_extentCenter.y);
                        _loc_4 = this.m_defaultDrawSize / 2;
                        this.extent.xmin = this.map.toMapX(_loc_2 - _loc_4);
                        this.extent.ymin = this.map.toMapY(_loc_3 + _loc_4);
                        this.extent.xmax = this.map.toMapX(_loc_2 + _loc_4);
                        this.extent.ymax = this.map.toMapY(_loc_3 - _loc_4);
                        this.m_graphic.refresh();
                    }
                    this.removeLayerEndDraw();
                    break;
                }
                case CIRCLE:
                {
                    if (!this.m_mouseMove)
                    {
                        this.m_circleRadius = this.m_defaultDrawSize / 2;
                        this.updateCirclePolygon();
                        this.m_graphic.refresh();
                    }
                    this.removeLayerEndDraw();
                    break;
                }
                case ELLIPSE:
                {
                    if (!this.m_mouseMove)
                    {
                        this.m_ellipseRadiusX = this.m_defaultDrawSize / 2;
                        this.m_ellipseRadiusY = this.m_defaultDrawSize / 4;
                        this.updateEllipsePolygon();
                        this.m_graphic.refresh();
                    }
                    this.removeLayerEndDraw();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.m_graphic = null;
            return;
        }// end function

        private function calculateRadius(point:MapPoint) : Number
        {
            var _loc_2:* = point.x - this.m_circleCenter.x;
            var _loc_3:* = point.y - this.m_circleCenter.y;
            return Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3);
        }// end function

        private function updateCirclePolygon() : void
        {
            if (this.circle.rings != null)
            {
            }
            if (this.circle.rings.length > 0)
            {
                this.circle.removeRing(0);
            }
            this.circle.addRing(this.createCirclePoints());
            return;
        }// end function

        private function updateEllipsePolygon() : void
        {
            if (this.ellipse.rings != null)
            {
            }
            if (this.ellipse.rings.length > 0)
            {
                this.ellipse.removeRing(0);
            }
            if (this.m_mouseMove)
            {
                this.ellipse.addRing(this.createEllipsePoints(this.m_ellipseRadiusX, this.m_ellipseRadiusY, this.m_ellipseCenter.x, this.m_ellipseCenter.y));
            }
            else
            {
                this.ellipse.addRing(this.createEllipsePoints(this.m_ellipseRadiusX, this.m_ellipseRadiusY, this.m_ellipseScreenCenter.x, this.m_ellipseScreenCenter.y));
            }
            return;
        }// end function

        private function createCirclePoints() : Array
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Point = null;
            var _loc_1:* = new Array();
            if (this.m_mouseMove)
            {
                _loc_2 = 0;
                while (_loc_2 < this.m_numberOfCirclePoints)
                {
                    
                    _loc_3 = Math.sin(Math.PI * 2 * _loc_2 / this.m_numberOfCirclePoints);
                    _loc_4 = Math.cos(Math.PI * 2 * _loc_2 / this.m_numberOfCirclePoints);
                    _loc_5 = this.m_circleCenter.x + this.m_circleRadius * _loc_4;
                    _loc_6 = this.m_circleCenter.y + this.m_circleRadius * _loc_3;
                    _loc_1[_loc_2] = new MapPoint(_loc_5, _loc_6);
                    _loc_2 = _loc_2 + 1;
                }
            }
            else
            {
                _loc_2 = 0;
                while (_loc_2 < this.m_numberOfCirclePoints)
                {
                    
                    _loc_3 = Math.sin(Math.PI * 2 * _loc_2 / this.m_numberOfCirclePoints);
                    _loc_4 = Math.cos(Math.PI * 2 * _loc_2 / this.m_numberOfCirclePoints);
                    _loc_7 = this.map.toScreen(this.m_circleCenter);
                    _loc_7.x = _loc_7.x + this.m_circleRadius * _loc_4;
                    _loc_7.y = _loc_7.y + this.m_circleRadius * _loc_3;
                    _loc_1[_loc_2] = this.map.toMap(_loc_7);
                    _loc_2 = _loc_2 + 1;
                }
            }
            _loc_1.push(_loc_1[0]);
            if (!GeomUtils.isClockwise(_loc_1))
            {
                _loc_1.reverse();
            }
            return _loc_1;
        }// end function

        private function createEllipsePoints(dx:Number, dy:Number, centerX:Number, centerY:Number) : Array
        {
            var _loc_5:int = 0;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            _loc_5 = 100;
            var _loc_6:* = new Array();
            var _loc_7:* = dx * dy;
            var _loc_8:* = dx * dx;
            var _loc_9:* = dy * dy;
            _loc_6[_loc_5 * 0 + 0] = centerX + dx;
            _loc_6[_loc_5 * 0 + 1] = centerY;
            _loc_6[_loc_5 * 8 + 0] = centerX + dx;
            _loc_6[_loc_5 * 8 + 1] = centerY;
            _loc_6[_loc_5 * 2 + 0] = centerX;
            _loc_6[_loc_5 * 2 + 1] = centerY - dy;
            _loc_6[_loc_5 * 4 + 0] = centerX - dx;
            _loc_6[_loc_5 * 4 + 1] = centerY;
            _loc_6[_loc_5 * 6 + 0] = centerX;
            _loc_6[_loc_5 * 6 + 1] = centerY + dy;
            var _loc_10:* = _loc_5 > 0 ? (Math.PI / 2 / _loc_5) : (0);
            var _loc_11:Number = 0;
            var _loc_12:Number = 1;
            while (_loc_12 < _loc_5)
            {
                
                _loc_11 = _loc_11 + _loc_10;
                _loc_15 = Math.tan(_loc_11);
                _loc_16 = _loc_7 / Math.sqrt(_loc_15 * _loc_15 * _loc_8 + _loc_9);
                _loc_17 = _loc_16 * _loc_15;
                _loc_6[(_loc_5 * 0 + _loc_12) * 2 + 0] = centerX + _loc_16;
                _loc_6[(_loc_5 * 2 - _loc_12) * 2 + 0] = centerX - _loc_16;
                _loc_6[(_loc_5 * 2 + _loc_12) * 2 + 0] = centerX - _loc_16;
                _loc_6[(_loc_5 * 4 - _loc_12) * 2 + 0] = centerX + _loc_16;
                _loc_6[(_loc_5 * 0 + _loc_12) * 2 + 1] = centerY - _loc_17;
                _loc_6[(_loc_5 * 2 - _loc_12) * 2 + 1] = centerY - _loc_17;
                _loc_6[(_loc_5 * 2 + _loc_12) * 2 + 1] = centerY + _loc_17;
                _loc_6[(_loc_5 * 4 - _loc_12) * 2 + 1] = centerY + _loc_17;
                _loc_12 = _loc_12 + 1;
            }
            var _loc_13:* = new Array();
            if (this.m_mouseMove)
            {
                _loc_14 = 0;
                while (_loc_14 < _loc_6.length)
                {
                    
                    _loc_13.push(new MapPoint(_loc_6[_loc_14], _loc_6[(_loc_14 + 1)]));
                    _loc_14 = _loc_14 + 2;
                }
            }
            else
            {
                _loc_14 = 0;
                while (_loc_14 < _loc_6.length)
                {
                    
                    _loc_13.push(this.map.toMap(new Point(_loc_6[_loc_14], _loc_6[(_loc_14 + 1)])));
                    _loc_14 = _loc_14 + 2;
                }
            }
            if (!GeomUtils.isClockwise(_loc_13))
            {
                _loc_13.reverse();
            }
            return _loc_13;
        }// end function

        private function addGraphic(graphic:Graphic) : void
        {
            if (this.m_graphicsLayer)
            {
                this.graphicsLayer.add(graphic);
            }
            else
            {
                this.m_tempLayer.clear();
                this.m_tempLayer.add(graphic);
                this.map.addLayer(this.m_tempLayer);
            }
            return;
        }// end function

        private function checkForSnapping(pt:MapPoint, isCntrlKeyDown:Boolean, frameId:Number = 0) : void
        {
            var _loc_4:Point = null;
            var _loc_5:Extent = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_9:Array = null;
            var _loc_10:int = 0;
            var _loc_11:Array = null;
            var _loc_12:int = 0;
            var _loc_13:Array = null;
            var _loc_14:int = 0;
            var _loc_15:Array = null;
            var _loc_16:int = 0;
            var _loc_17:Boolean = false;
            var _loc_18:Array = null;
            var _loc_19:Array = null;
            var _loc_20:int = 0;
            var _loc_21:Object = null;
            var _loc_22:Extent = null;
            var _loc_23:Graphic = null;
            var _loc_24:MapPoint = null;
            var _loc_25:Multipoint = null;
            var _loc_26:MapPoint = null;
            var _loc_27:MapPoint = null;
            var _loc_28:Polyline = null;
            var _loc_29:Array = null;
            var _loc_30:MapPoint = null;
            var _loc_31:MapPoint = null;
            var _loc_32:Array = null;
            var _loc_33:MapPoint = null;
            var _loc_34:Polygon = null;
            var _loc_35:Array = null;
            var _loc_36:MapPoint = null;
            var _loc_37:MapPoint = null;
            var _loc_38:Array = null;
            var _loc_39:MapPoint = null;
            var _loc_40:Extent = null;
            var _loc_41:Array = null;
            var _loc_42:MapPoint = null;
            var _loc_43:MapPoint = null;
            var _loc_44:Array = null;
            var _loc_45:MapPoint = null;
            var _loc_46:Number = NaN;
            var _loc_47:MapPoint = null;
            var _loc_48:MapPoint = null;
            if (isCntrlKeyDown)
            {
                _loc_4 = this.map.toScreen(pt);
                if (!this.m_snapGraphic)
                {
                    this.m_snapGraphic = new Graphic();
                    this.m_snapGraphic.symbol = new SimpleMarkerSymbol("circle", this.m_snapDistance * 2, 13421772, 0.4, 0, 0, 0, new SimpleLineSymbol("solid", 16777215));
                    this.m_snapGraphic.geometry = pt;
                    this.map.defaultGraphicsLayer.add(this.m_snapGraphic);
                }
                else
                {
                    this.m_snapGraphic.visible = true;
                    this.m_snapGraphic.symbol = new SimpleMarkerSymbol("circle", this.m_snapDistance * 2, 13421772, 0.4, 0, 0, 0, new SimpleLineSymbol("solid", 16777215));
                    this.m_snapGraphic.geometry = pt;
                    this.m_snapGraphic.refresh();
                }
                _loc_5 = new Extent();
                if (this.map.wrapAround180)
                {
                    _loc_21 = this.map.extent.normalize(false, true);
                    if (_loc_21 is Extent)
                    {
                        _loc_5 = _loc_21 as Extent;
                    }
                    else if (_loc_21 is Array)
                    {
                        for each (_loc_22 in _loc_21)
                        {
                            
                            _loc_5 = _loc_5.union(_loc_22);
                        }
                    }
                }
                else
                {
                    _loc_5 = this.map.extent;
                }
                _loc_6 = [];
                _loc_7 = [];
                _loc_8 = 0;
                while (_loc_8 < this.m_mapLayers.length)
                {
                    
                    if (this.m_mapLayers.getItemAt(_loc_8) is GraphicsLayer)
                    {
                        for each (_loc_23 in GraphicsLayer(this.m_mapLayers.getItemAt(_loc_8)).graphicProvider)
                        {
                            
                            if (_loc_23 !== this.m_graphic)
                            {
                            }
                            if (_loc_23.geometry)
                            {
                                switch(_loc_23.geometry.type)
                                {
                                    case Geometry.MAPPOINT:
                                    {
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            _loc_24 = this.map.wrapAround180 ? (MapPoint(_loc_23.geometry).normalize()) : (MapPoint(_loc_23.geometry));
                                            if (_loc_5.containsXY(_loc_24.x, _loc_24.y))
                                            {
                                                _loc_6.push(_loc_24);
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.MULTIPOINT:
                                    {
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            _loc_25 = _loc_23.geometry as Multipoint;
                                            for each (_loc_26 in Multipoint(_loc_23.geometry).points)
                                            {
                                                
                                                _loc_27 = this.map.wrapAround180 ? (_loc_26.normalize()) : (_loc_26);
                                                if (_loc_5.containsXY(_loc_27.x, _loc_27.y))
                                                {
                                                    _loc_6.push(_loc_27);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.POLYLINE:
                                    {
                                        _loc_28 = _loc_23.geometry as Polyline;
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_29 in _loc_28.paths)
                                            {
                                                
                                                for each (_loc_30 in _loc_29)
                                                {
                                                    
                                                    _loc_31 = this.map.wrapAround180 ? (_loc_30.normalize()) : (_loc_30);
                                                    if (_loc_5.containsXY(_loc_31.x, _loc_31.y))
                                                    {
                                                        _loc_6.push(_loc_31);
                                                    }
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_32 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(_loc_28), _loc_4);
                                            for each (_loc_33 in _loc_32)
                                            {
                                                
                                                if (_loc_5.containsXY(_loc_33.x, _loc_33.y))
                                                {
                                                    _loc_7.push(_loc_33);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.POLYGON:
                                    {
                                        _loc_34 = _loc_23.geometry as Polygon;
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_35 in _loc_34.rings)
                                            {
                                                
                                                for each (_loc_36 in _loc_35)
                                                {
                                                    
                                                    _loc_37 = this.map.wrapAround180 ? (_loc_36.normalize()) : (_loc_36);
                                                    if (_loc_5.containsXY(_loc_37.x, _loc_37.y))
                                                    {
                                                        _loc_6.push(_loc_37);
                                                    }
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_38 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(_loc_34), _loc_4);
                                            for each (_loc_39 in _loc_38)
                                            {
                                                
                                                if (_loc_5.containsXY(_loc_39.x, _loc_39.y))
                                                {
                                                    _loc_7.push(_loc_39);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.EXTENT:
                                    {
                                        _loc_40 = _loc_23.geometry as Extent;
                                        _loc_41 = [new MapPoint(_loc_40.xmin, _loc_40.ymin), new MapPoint(_loc_40.xmin, _loc_40.ymax), new MapPoint(_loc_40.xmax, _loc_40.ymax), new MapPoint(_loc_40.xmax, _loc_40.ymin)];
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_42 in _loc_41)
                                            {
                                                
                                                _loc_43 = this.map.wrapAround180 ? (_loc_42.normalize()) : (_loc_42);
                                                if (_loc_5.containsXY(_loc_43.x, _loc_43.y))
                                                {
                                                    _loc_6.push(_loc_43);
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_44 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(this.extentToPolyline(_loc_40)), _loc_4);
                                            for each (_loc_45 in _loc_44)
                                            {
                                                
                                                if (_loc_5.containsXY(_loc_45.x, _loc_45.y))
                                                {
                                                    _loc_7.push(_loc_45);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    _loc_8 = _loc_8 + 1;
                }
                _loc_9 = [];
                _loc_10 = 0;
                while (_loc_10 < _loc_6.length)
                {
                    
                    _loc_9.push(Math.pow(this.map.toScreenX(_loc_6[_loc_10].x) - _loc_4.x, 2) + Math.pow(this.map.toScreenY(_loc_6[_loc_10].y) - _loc_4.y, 2));
                    _loc_10 = _loc_10 + 1;
                }
                _loc_11 = _loc_9.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
                _loc_12 = _loc_11[0];
                _loc_13 = [];
                _loc_14 = 0;
                while (_loc_14 < _loc_7.length)
                {
                    
                    _loc_13.push(Math.pow(this.map.toScreenX(_loc_7[_loc_14].x) - _loc_4.x, 2) + Math.pow(this.map.toScreenY(_loc_7[_loc_14].y) - _loc_4.y, 2));
                    _loc_14 = _loc_14 + 1;
                }
                _loc_15 = _loc_13.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
                _loc_16 = _loc_15[0];
                if (_loc_9.length > 0)
                {
                }
                if (_loc_13.length > 0)
                {
                    _loc_17 = _loc_9[_loc_12] < _loc_13[_loc_16] ? (true) : (false);
                }
                else
                {
                    if (_loc_9.length > 0)
                    {
                    }
                    if (_loc_13.length == 0)
                    {
                        _loc_17 = true;
                    }
                    else
                    {
                        if (_loc_13.length > 0)
                        {
                        }
                        if (_loc_9.length == 0)
                        {
                            _loc_17 = false;
                        }
                    }
                }
                _loc_18 = [];
                _loc_19 = [];
                if (_loc_17)
                {
                    _loc_18 = _loc_9;
                    _loc_20 = _loc_12;
                    _loc_19 = _loc_6;
                }
                else
                {
                    _loc_18 = _loc_13;
                    _loc_20 = _loc_16;
                    _loc_19 = _loc_7;
                }
                if (_loc_18.length > 0)
                {
                }
                if (Math.sqrt(_loc_18[_loc_20]) < this.m_snapDistance)
                {
                    this.m_isSnapping = true;
                    if (this.map.wrapAround180)
                    {
                    }
                    _loc_46 = this.map.extent.spatialReference.info ? (this.map.extent.spatialReference.info.world * frameId) : (0);
                    _loc_47 = _loc_19[_loc_20];
                    _loc_48 = new MapPoint(_loc_47.x + _loc_46, _loc_47.y, _loc_47.spatialReference);
                    if (!this.m_snapPointGraphic)
                    {
                        this.m_snapPointGraphic = new Graphic();
                        this.m_snapPointGraphic.symbol = this.m_snapOption == SNAP_OPTION_EDGE_AND_VERTEX ? (_loc_17 ? (this.m_snapToVertexSymbol) : (this.m_snapToEdgeSymbol)) : (this.m_snapToEdgeSymbol);
                        this.m_snapPointGraphic.geometry = _loc_48;
                        this.map.defaultGraphicsLayer.add(this.m_snapPointGraphic);
                    }
                    else
                    {
                        this.m_snapPointGraphic.visible = true;
                        this.m_snapPointGraphic.geometry = _loc_48;
                        this.m_snapPointGraphic.symbol = this.m_snapOption == SNAP_OPTION_EDGE_AND_VERTEX ? (_loc_17 ? (this.m_snapToVertexSymbol) : (this.m_snapToEdgeSymbol)) : (this.m_snapToEdgeSymbol);
                    }
                }
                else
                {
                    this.m_isSnapping = false;
                    if (this.m_snapPointGraphic)
                    {
                        this.m_snapPointGraphic.visible = false;
                    }
                }
            }
            else
            {
                this.m_isSnapping = false;
                if (this.m_snapPointGraphic)
                {
                    this.m_snapPointGraphic.visible = false;
                }
                if (this.m_snapGraphic)
                {
                    this.m_snapGraphic.visible = false;
                }
            }
            return;
        }// end function

        private function getEdgesForPolylinePolygon(geometry:Geometry) : Array
        {
            var _loc_6:MapPoint = null;
            var _loc_7:int = 0;
            var _loc_8:MapPoint = null;
            var _loc_2:Array = [];
            var _loc_3:* = geometry.type == Geometry.POLYLINE ? (Polyline(geometry).paths) : (Polygon(geometry).rings);
            var _loc_4:Array = [];
            var _loc_5:Number = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                _loc_4 = _loc_3[_loc_5];
                _loc_6 = this.map.wrapAround180 ? (MapPoint(_loc_4[0]).normalize()) : (_loc_4[0]);
                _loc_7 = 1;
                while (_loc_7 < _loc_4.length)
                {
                    
                    _loc_8 = this.map.wrapAround180 ? (MapPoint(_loc_4[_loc_7]).normalize()) : (_loc_4[_loc_7]);
                    if (_loc_8.x == _loc_6.x)
                    {
                    }
                    if (_loc_8.y != _loc_6.y)
                    {
                        _loc_2.push({startPoint:_loc_6, endPoint:_loc_8});
                    }
                    _loc_6 = _loc_8;
                    _loc_7 = _loc_7 + 1;
                }
                _loc_5 = _loc_5 + 1;
            }
            return _loc_2;
        }// end function

        private function getPointsOnEdges(edges:Array, point:Point) : Array
        {
            var _loc_5:Point = null;
            var _loc_6:Point = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_3:Array = [];
            var _loc_4:Number = 0;
            while (_loc_4 < edges.length)
            {
                
                _loc_5 = this.map.toScreen(edges[_loc_4].startPoint);
                _loc_6 = this.map.toScreen(edges[_loc_4].endPoint);
                _loc_7 = Math.pow(_loc_6.x - _loc_5.x, 2) + Math.pow(_loc_6.y - _loc_5.y, 2);
                _loc_8 = ((point.x - _loc_5.x) * (_loc_6.x - _loc_5.x) + (point.y - _loc_5.y) * (_loc_6.y - _loc_5.y)) / _loc_7;
                if (_loc_8 > 0)
                {
                }
                if (_loc_8 < 1)
                {
                    _loc_9 = _loc_5.x + _loc_8 * (_loc_6.x - _loc_5.x);
                    _loc_10 = _loc_5.y + _loc_8 * (_loc_6.y - _loc_5.y);
                    _loc_3.push(new MapPoint(this.map.toMapX(_loc_9), this.map.toMapY(_loc_10)));
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        private function extentToPolyline(extent:Extent) : Polyline
        {
            var _loc_2:Array = [new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmax, extent.ymax), new MapPoint(extent.xmax, extent.ymin), new MapPoint(extent.xmin, extent.ymin)];
            var _loc_3:* = new Polyline();
            _loc_3.addPath(_loc_2);
            return _loc_3;
        }// end function

        function removeGraphic(graphic:Graphic) : void
        {
            if (this.m_graphicsLayer)
            {
                this.graphicsLayer.remove(graphic);
            }
            else
            {
                this.m_tempLayer.remove(graphic);
            }
            return;
        }// end function

        private function removeLayerEndDraw() : void
        {
            if (this.m_tempLayer)
            {
                this.map.removeLayer(this.m_tempLayer);
            }
            if (this.map.wrapAround180)
            {
                var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                var _loc_3:* = item as Array;
                m_graphic.geometry = _loc_3[0];
                return;
            }// end function
            ;
                GeometryUtil.normalizeCentralMeridian2([this.m_graphic.geometry], new Responder(getNormalizedGeometryFunction, null));
            }
            dispatchEvent(new DrawEvent(DrawEvent.DRAW_END, this.m_graphic));
            return;
        }// end function

        public function set snapDistance(value:Number) : void
        {
            arguments = this.snapDistance;
            if (arguments !== value)
            {
                this._236816929snapDistance = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snapDistance", arguments, value));
                }
            }
            return;
        }// end function

        public function set showDrawTips(value:Boolean) : void
        {
            arguments = this.showDrawTips;
            if (arguments !== value)
            {
                this._1678859079showDrawTips = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showDrawTips", arguments, value));
                }
            }
            return;
        }// end function

        public function set minFreehandPointInterval(value:Number) : void
        {
            arguments = this.minFreehandPointInterval;
            if (arguments !== value)
            {
                this._595995176minFreehandPointInterval = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minFreehandPointInterval", arguments, value));
                }
            }
            return;
        }// end function

        public function set respectDrawingVertexOrder(value:Boolean) : void
        {
            arguments = this.respectDrawingVertexOrder;
            if (arguments !== value)
            {
                this._51670670respectDrawingVertexOrder = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "respectDrawingVertexOrder", arguments, value));
                }
            }
            return;
        }// end function

        public function set snapMode(value:String) : void
        {
            arguments = this.snapMode;
            if (arguments !== value)
            {
                this._283748493snapMode = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snapMode", arguments, value));
                }
            }
            return;
        }// end function

        public function set defaultDrawSize(value:Number) : void
        {
            arguments = this.defaultDrawSize;
            if (arguments !== value)
            {
                this._1171171526defaultDrawSize = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultDrawSize", arguments, value));
                }
            }
            return;
        }// end function

        public function set markerSymbol(value:Symbol) : void
        {
            arguments = this.markerSymbol;
            if (arguments !== value)
            {
                this._1854578062markerSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "markerSymbol", arguments, value));
                }
            }
            return;
        }// end function

        public function set lineSymbol(value:Symbol) : void
        {
            arguments = this.lineSymbol;
            if (arguments !== value)
            {
                this._182302036lineSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineSymbol", arguments, value));
                }
            }
            return;
        }// end function

        public function set snapOption(value:String) : void
        {
            arguments = this.snapOption;
            if (arguments !== value)
            {
                this._2136939297snapOption = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snapOption", arguments, value));
                }
            }
            return;
        }// end function

        public function set fillSymbol(value:Symbol) : void
        {
            arguments = this.fillSymbol;
            if (arguments !== value)
            {
                this._571283205fillSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fillSymbol", arguments, value));
                }
            }
            return;
        }// end function

    }
}
