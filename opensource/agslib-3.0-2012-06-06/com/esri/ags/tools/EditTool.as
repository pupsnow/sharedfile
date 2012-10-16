package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.ui.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.utils.*;

    public class EditTool extends BaseTool
    {
        private var moveCursor:Class;
        private var rotateCursor:Class;
        private var leftRightScaleCursor:Class;
        private var topBottomScaleCursor:Class;
        private var topLeftBottomRightScaleCursor:Class;
        private var bottomLeftTopRightScaleCursor:Class;
        private var m_map:Map;
        private var m_allowAddVertices:Boolean = true;
        private var m_allowDeleteVertices:Boolean = true;
        private var m_ghostVertexSymbol:Symbol;
        private var m_vertexSymbol:Symbol;
        private var m_snapGraphicSymbol:SimpleMarkerSymbol;
        private var m_snapPointVertexSymbol:SimpleMarkerSymbol;
        private var m_snapPointEdgeSymbol:SimpleMarkerSymbol;
        private var m_snapGraphicVertexSymbol:CompositeSymbol;
        private var m_snapGraphicEdgeSymbol:CompositeSymbol;
        private var m_active:Boolean = false;
        private var m_editType:Number;
        private var m_moveActive:Boolean;
        private var m_editVerticesActive:Boolean;
        private var m_allEditTypesActive:Boolean;
        private var m_scaleActive:Boolean;
        private var m_rotateActive:Boolean;
        private var m_scaleRotateActive:Boolean;
        private var m_distanceArray:Array;
        private var m_distanceHolderArray:Array;
        private var m_graphicDistanceHolderArray:Array;
        private var m_parentGraphicsLayer:GraphicsLayer;
        private var m_multipointGraphicSymbol:Symbol;
        private var m_noGraphicSymbol:Boolean;
        private var m_graphicArray:Array;
        private var m_graphic:Graphic;
        private var m_ghostGraphic:Graphic;
        private var m_ghostGraphicMoving:Boolean;
        private var m_initialGhostVertexMouseDownPoint:MapPoint;
        private var m_ghostVertexNeighborStartPoint:MapPoint;
        private var m_ghostVertexNeighborEndPoint:MapPoint;
        private var m_ghostVertexRatio:Number;
        private var m_initialMouseDownFrameId:Number = 0;
        private var m_snapGraphic:Graphic;
        private var m_arrayOfSegments:Array;
        private var m_polygonGraphicMoving:Boolean;
        private var m_closestPathOrRingIndex:Number;
        private var m_closestPointIndex:Number;
        private var m_scaleRotateTempExtentGraphic:Graphic;
        private var m_polygonVertexLayer:PolygonVertexLayer;
        private var m_polylineVertexLayer:PolylineVertexLayer;
        private var m_scaleRotatePolylineLayer:ScaleRotateLayer;
        private var m_scaleRotatePolygonLayer:ScaleRotateLayer;
        private var m_scaleRotateExtentLayer:ScaleRotateLayer;
        private var m_index:Number;
        private var m_pointIndex:int;
        private var m_pathIndex:int;
        private var m_ringIndex:int;
        private var m_multipointVertexIndex:Number;
        private var m_isGhostVertex:Boolean;
        private var m_templateSwatch:UIComponent;
        private var m_hideGraphicZoom:Boolean;
        private var m_isMultipointVertexEditing:Boolean;
        private var m_scalePointInitialGeometry:MapPoint;
        private var m_rotatePointInitialGeometry:MapPoint;
        private var m_scalePosition:String;
        private var m_scaleRotatePolyline:Polyline;
        private var m_pathsDirectionArray:Array;
        private var m_scaleRotatePolygon:Polygon;
        private var m_ringsDirectionArray:Array;
        private var m_scaleRotateExtent:Extent;
        private var m_arrayScaleRotateExtentPoints:Array;
        private var m_rotateAnchorPoint:MapPoint;
        private var m_scalingInProgress:Boolean;
        private var m_rotationInProgress:Boolean;
        private var m_mapLayers:ArrayCollection;
        private var m_snapDistance:Number = 15;
        private var m_snapMode:String = "onDemand";
        private var m_snapOption:String = "edgeAndVertex";
        private var m_snappingEnabled:Boolean = true;
        private var m_ghostVertexZ:Number;
        private var m_ghostVertexM:Number;
        var snapping:Boolean;
        public static const MOVE:Number = 1;
        public static const EDIT_VERTICES:Number = 2;
        public static const SCALE:Number = 4;
        public static const ROTATE:Number = 8;
        public static const SNAP_MODE_ALWAYS_ON:String = "alwaysOn";
        public static const SNAP_MODE_OFF:String = "off";
        public static const SNAP_MODE_ON_DEMAND:String = "onDemand";
        public static const SNAP_OPTION_EDGE:String = "edge";
        public static const SNAP_OPTION_VERTEX:String = "vertex";
        public static const SNAP_OPTION_EDGE_AND_VERTEX:String = "edgeAndVertex";

        public function EditTool(map:Map = null)
        {
            this.moveCursor = EditTool_moveCursor;
            this.rotateCursor = EditTool_rotateCursor;
            this.leftRightScaleCursor = EditTool_leftRightScaleCursor;
            this.topBottomScaleCursor = EditTool_topBottomScaleCursor;
            this.topLeftBottomRightScaleCursor = EditTool_topLeftBottomRightScaleCursor;
            this.bottomLeftTopRightScaleCursor = EditTool_bottomLeftTopRightScaleCursor;
            this.m_ghostVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 12, 16777215, 0.5, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 0.8, 1));
            this.m_vertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 12, 12566463, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 8355711, 1, 1));
            this.m_snapGraphicSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, this.m_snapDistance * 2, 13421772, 0.4, 0, 0, 0, new SimpleLineSymbol("solid", 16777215));
            this.m_snapPointVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CROSS, 18, 0, 1, 0, 0, 0, new SimpleLineSymbol("solid", 0, 1, 4));
            this.m_snapPointEdgeSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CROSS, 18, 0, 1, 0, 0, 0, new SimpleLineSymbol("solid", 0, 1, 2));
            this.m_arrayOfSegments = [];
            this.m_polygonVertexLayer = new PolygonVertexLayer();
            this.m_polylineVertexLayer = new PolylineVertexLayer();
            this.m_scaleRotatePolylineLayer = new ScaleRotateLayer();
            this.m_scaleRotatePolygonLayer = new ScaleRotateLayer();
            this.m_scaleRotateExtentLayer = new ScaleRotateLayer();
            this.m_scaleRotateExtent = new Extent();
            this.m_arrayScaleRotateExtentPoints = new Array();
            super(map);
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

        public function get allowAddVertices() : Boolean
        {
            return this.m_allowAddVertices;
        }// end function

        private function set _1541300401allowAddVertices(value:Boolean) : void
        {
            if (value != this.m_allowAddVertices)
            {
                this.m_allowAddVertices = value;
            }
            return;
        }// end function

        public function get allowDeleteVertices() : Boolean
        {
            return this.m_allowDeleteVertices;
        }// end function

        private function set _1235677805allowDeleteVertices(value:Boolean) : void
        {
            if (value != this.m_allowDeleteVertices)
            {
                this.m_allowDeleteVertices = value;
            }
            return;
        }// end function

        public function get ghostVertexSymbol() : Symbol
        {
            return this.m_ghostVertexSymbol;
        }// end function

        private function set _1067296907ghostVertexSymbol(value:Symbol) : void
        {
            if (value != this.m_ghostVertexSymbol)
            {
                this.m_ghostVertexSymbol = value;
                if (!(this.m_ghostVertexSymbol is FillSymbol))
                {
                }
                if (!(this.m_ghostVertexSymbol is LineSymbol))
                {
                }
                if (this.m_ghostVertexSymbol is InfoSymbol)
                {
                    this.ghostVertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 12, 16777215, 0.5, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 0.8, 1));
                }
            }
            return;
        }// end function

        public function get vertexSymbol() : Symbol
        {
            return this.m_vertexSymbol;
        }// end function

        private function set _1642837924vertexSymbol(value:Symbol) : void
        {
            if (value != this.m_vertexSymbol)
            {
                this.m_vertexSymbol = value;
                if (!(this.m_vertexSymbol is FillSymbol))
                {
                }
                if (!(this.m_vertexSymbol is LineSymbol))
                {
                }
                if (this.m_vertexSymbol is InfoSymbol)
                {
                    this.vertexSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 12, 12566463, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 8355711, 1, 1));
                }
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
                this.m_snappingEnabled = this.m_snapMode == SNAP_MODE_OFF ? (false) : (true);
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
                this.m_snappingEnabled = this.m_snapMode == SNAP_MODE_OFF ? (false) : (true);
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

        public function activate(editType:Number, graphics:Array) : void
        {
            this.deactivate();
            if (this.map == null)
            {
                return;
            }
            if (this.m_active == false)
            {
                deactivateMapTools(true, false, false, false, false);
                this.m_active = true;
            }
            this.m_snapGraphicVertexSymbol = new CompositeSymbol([this.vertexSymbol, this.m_snapPointVertexSymbol]);
            this.m_snapGraphicEdgeSymbol = new CompositeSymbol([this.vertexSymbol, this.m_snapPointEdgeSymbol]);
            this.map.panEnabled = true;
            this.map.rubberbandZoomEnabled = true;
            this.map.openHandCursorVisible = false;
            this.map.addEventListener(ZoomEvent.ZOOM_START, this.map_zoomStartHandler, false, 1, true);
            this.map.addEventListener(ZoomEvent.ZOOM_END, this.map_zoomEndHandler, false, 1, true);
            this.m_mapLayers = this.map.layers as ArrayCollection;
            if (graphics)
            {
            }
            if (graphics.length > 0)
            {
                if ((editType & EditTool.MOVE) === EditTool.MOVE)
                {
                    this.m_moveActive = true;
                }
                if ((editType & EditTool.EDIT_VERTICES) === EditTool.EDIT_VERTICES)
                {
                    this.m_editVerticesActive = true;
                }
                if ((editType & EditTool.SCALE) === EditTool.SCALE)
                {
                    this.m_scaleActive = true;
                }
                if ((editType & EditTool.ROTATE) === EditTool.ROTATE)
                {
                    this.m_rotateActive = true;
                }
                if (!this.m_moveActive)
                {
                }
                if (!this.m_editVerticesActive)
                {
                }
                if (!this.m_scaleActive)
                {
                }
                if (this.m_rotateActive)
                {
                    if (this.m_moveActive)
                    {
                    }
                    if (this.m_editVerticesActive)
                    {
                        if (!this.m_rotateActive)
                        {
                        }
                        if (!this.m_scaleActive)
                        {
                            if (graphics.length == 1)
                            {
                                this.m_allEditTypesActive = true;
                                this.addEventListeners([graphics[0]]);
                                this.editVerticesEnable(graphics[0]);
                                this.m_graphicArray = [graphics[0]];
                            }
                        }
                    }
                    else
                    {
                        if (this.m_moveActive)
                        {
                            if (!this.m_scaleActive)
                            {
                            }
                        }
                        if (this.m_rotateActive)
                        {
                            if (!this.m_editVerticesActive)
                            {
                                if (this.m_scaleActive)
                                {
                                }
                                if (this.m_rotateActive)
                                {
                                    this.m_scaleRotateActive = true;
                                }
                                if (graphics.length == 1)
                                {
                                    this.m_graphicArray = [graphics[0]];
                                    if (!(Graphic(graphics[0]).geometry is Polyline))
                                    {
                                    }
                                    if (!(Graphic(graphics[0]).geometry is Polygon))
                                    {
                                    }
                                    if (Graphic(graphics[0]).geometry is Extent)
                                    {
                                        this.addEventListeners([graphics[0]]);
                                        this.editVerticesEnable(graphics[0]);
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (this.m_editVerticesActive)
                            {
                                if (!this.m_scaleActive)
                                {
                                }
                            }
                            if (this.m_rotateActive)
                            {
                            }
                            else
                            {
                                if (this.m_scaleActive)
                                {
                                }
                                if (this.m_rotateActive)
                                {
                                    this.m_scaleRotateActive = true;
                                    if (graphics.length == 1)
                                    {
                                        this.m_graphicArray = [graphics[0]];
                                        if (!(Graphic(graphics[0]).geometry is Polyline))
                                        {
                                        }
                                        if (!(Graphic(graphics[0]).geometry is Polygon))
                                        {
                                        }
                                        if (Graphic(graphics[0]).geometry is Extent)
                                        {
                                            this.editVerticesEnable(graphics[0]);
                                        }
                                    }
                                }
                                else if (this.m_moveActive)
                                {
                                    this.addEventListeners(graphics);
                                    this.m_graphicArray = graphics;
                                }
                                else if (this.m_editVerticesActive)
                                {
                                    this.addEventListeners([graphics[0]]);
                                    this.editVerticesEnable(graphics[0]);
                                    this.m_graphicArray = [graphics[0]];
                                }
                                else if (this.m_scaleActive)
                                {
                                    this.m_graphicArray = [graphics[0]];
                                    if (!(Graphic(graphics[0]).geometry is Polyline))
                                    {
                                    }
                                    if (!(Graphic(graphics[0]).geometry is Polygon))
                                    {
                                    }
                                    if (Graphic(graphics[0]).geometry is Extent)
                                    {
                                        this.editVerticesEnable(graphics[0]);
                                    }
                                }
                                else if (this.m_rotateActive)
                                {
                                    this.m_graphicArray = [graphics[0]];
                                    if (!(Graphic(graphics[0]).geometry is Polyline))
                                    {
                                    }
                                    if (!(Graphic(graphics[0]).geometry is Polygon))
                                    {
                                    }
                                    if (Graphic(graphics[0]).geometry is Extent)
                                    {
                                        this.editVerticesEnable(graphics[0]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            this.m_editType = editType;
            dispatchEvent(new EditEvent(EditEvent.TOOL_ACTIVATE));
            return;
        }// end function

        private function addEventListeners(graphics:Array) : void
        {
            var _loc_2:Graphic = null;
            for each (_loc_2 in graphics)
            {
                
                if (_loc_2)
                {
                }
                if (_loc_2.graphicsLayer)
                {
                    if (!this.m_moveActive)
                    {
                    }
                    if (!this.m_allEditTypesActive)
                    {
                        if (this.m_editVerticesActive)
                        {
                            if (!(_loc_2.geometry is MapPoint))
                            {
                            }
                        }
                    }
                    if (_loc_2.geometry is Multipoint)
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            if (!(_loc_2.geometry is Polyline))
                            {
                            }
                            if (!(_loc_2.geometry is Polygon))
                            {
                            }
                            if (_loc_2.geometry is Extent)
                            {
                                _loc_2.addEventListener(MouseEvent.MOUSE_DOWN, this.graphicMouseDownHandler, false, -1, true);
                            }
                        }
                        else
                        {
                            _loc_2.addEventListener(MouseEvent.MOUSE_DOWN, this.graphicMouseDownHandler, false, -1, true);
                        }
                    }
                    if (!this.m_editVerticesActive)
                    {
                    }
                    if (this.m_allEditTypesActive)
                    {
                        if (!(_loc_2.geometry is Polyline))
                        {
                        }
                        if (_loc_2.geometry is Polygon)
                        {
                            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                        }
                    }
                    if (!this.m_moveActive)
                    {
                    }
                    if (this.m_allEditTypesActive)
                    {
                        _loc_2.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                        _loc_2.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
                    }
                    _loc_2.addEventListener(FlexEvent.HIDE, this.graphicHideHandler, false, -1, true);
                    _loc_2.addEventListener(FlexEvent.SHOW, this.graphicShowHandler, false, -1, true);
                    GraphicsLayer(_loc_2.parent).addEventListener(FlexEvent.HIDE, this.graphicHideHandler, false, -1, true);
                    GraphicsLayer(_loc_2.parent).addEventListener(FlexEvent.SHOW, this.graphicShowHandler, false, -1, true);
                    GraphicsLayer(_loc_2.parent).addEventListener(GraphicEvent.GRAPHIC_REMOVE, this.graphicRemoveHandler, false, -1, true);
                    GraphicsLayer(_loc_2.parent).addEventListener(GraphicsLayerEvent.GRAPHICS_CLEAR, this.graphicsClearHandler, false, -1, true);
                }
            }
            return;
        }// end function

        public function deactivate() : void
        {
            if (!this.m_active)
            {
                return;
            }
            if (this.m_editVerticesActive)
            {
                this.m_editVerticesActive = false;
            }
            if (this.m_moveActive)
            {
                this.m_moveActive = false;
            }
            if (this.m_allEditTypesActive)
            {
                this.m_allEditTypesActive = false;
            }
            if (this.m_rotateActive)
            {
                this.m_rotateActive = false;
            }
            if (this.m_scaleActive)
            {
                this.m_scaleActive = false;
            }
            if (this.m_scaleRotateActive)
            {
                this.m_scaleRotateActive = false;
            }
            this.deactivate2();
            this.m_active = false;
            this.m_editType = 0;
            activateMapTools(true, false, false, false, false);
            CursorManager.removeCursor(CursorManager.currentCursorID);
            dispatchEvent(new EditEvent(EditEvent.TOOL_DEACTIVATE));
            return;
        }// end function

        private function resetVars() : void
        {
            this.m_editType = 0;
            return;
        }// end function

        private function deactivate2() : void
        {
            var _loc_1:Graphic = null;
            if (!this.map)
            {
                return;
            }
            for each (_loc_1 in this.m_graphicArray)
            {
                
                _loc_1.removeEventListener(MouseEvent.MOUSE_DOWN, this.graphicMouseDownHandler);
                _loc_1.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                _loc_1.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
                _loc_1.removeEventListener(FlexEvent.HIDE, this.graphicHideHandler);
                _loc_1.removeEventListener(FlexEvent.SHOW, this.graphicShowHandler);
                if (_loc_1.parent)
                {
                    GraphicsLayer(_loc_1.parent).removeEventListener(FlexEvent.HIDE, this.graphicHideHandler);
                    GraphicsLayer(_loc_1.parent).removeEventListener(FlexEvent.SHOW, this.graphicShowHandler);
                    GraphicsLayer(_loc_1.parent).removeEventListener(GraphicEvent.GRAPHIC_REMOVE, this.graphicRemoveHandler);
                    GraphicsLayer(_loc_1.parent).removeEventListener(GraphicsLayerEvent.GRAPHICS_CLEAR, this.graphicsClearHandler);
                }
            }
            this.map.removeEventListener(ZoomEvent.ZOOM_START, this.map_zoomStartHandler);
            this.map.removeEventListener(ZoomEvent.ZOOM_END, this.map_zoomEndHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveNextHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            this.m_graphicArray = [];
            this.m_polygonGraphicMoving = false;
            this.m_hideGraphicZoom = false;
            this.m_scalingInProgress = false;
            this.m_rotationInProgress = false;
            this.removeTemporaryGraphics();
            return;
        }// end function

        private function map_mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:MapPoint = null;
            var _loc_3:Point = null;
            var _loc_4:int = 0;
            var _loc_5:Array = null;
            var _loc_6:Number = NaN;
            var _loc_7:Object = null;
            var _loc_8:MapPoint = null;
            var _loc_9:MapPoint = null;
            var _loc_10:Point = null;
            var _loc_11:Point = null;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Point = null;
            var _loc_18:Point = null;
            var _loc_19:MapPoint = null;
            var _loc_20:MapPoint = null;
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_26:MapPoint = null;
            var _loc_27:MapPoint = null;
            var _loc_28:ArrayCollection = null;
            var _loc_29:int = 0;
            if (!event.shiftKey)
            {
            }
            if (this.allowAddVertices)
            {
            }
            if (!this.m_polygonGraphicMoving)
            {
                _loc_2 = this.map.toMapFromStage(event.stageX, event.stageY);
                _loc_4 = 0;
                if (this.map.wrapAround180)
                {
                    _loc_7 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                    _loc_3 = this.map.toScreen(new MapPoint(_loc_7.x, _loc_2.y));
                    _loc_4 = _loc_7.frameId;
                }
                else
                {
                    _loc_3 = this.map.toScreen(_loc_2);
                }
                _loc_5 = [];
                _loc_6 = 0;
                while (_loc_6 < this.m_arrayOfSegments.length)
                {
                    
                    _loc_8 = MapPoint(this.m_arrayOfSegments[_loc_6].point);
                    _loc_9 = MapPoint(this.m_arrayOfSegments[(_loc_6 + 1)].point);
                    _loc_10 = this.map.toScreen(this.map.wrapAround180 ? (MapPoint(this.m_arrayOfSegments[_loc_6].point).normalize()) : (MapPoint(this.m_arrayOfSegments[_loc_6].point)));
                    _loc_11 = this.map.toScreen(this.map.wrapAround180 ? (MapPoint(this.m_arrayOfSegments[(_loc_6 + 1)].point).normalize()) : (MapPoint(this.m_arrayOfSegments[(_loc_6 + 1)].point)));
                    _loc_12 = Math.pow(_loc_11.x - _loc_10.x, 2) + Math.pow(_loc_11.y - _loc_10.y, 2);
                    _loc_13 = Math.sqrt(_loc_12);
                    _loc_14 = Math.abs(((_loc_10.y - _loc_3.y) * (_loc_11.x - _loc_10.x) - (_loc_10.x - _loc_3.x) * (_loc_11.y - _loc_10.y)) / _loc_12) * _loc_13;
                    _loc_15 = ((_loc_3.x - _loc_10.x) * (_loc_11.x - _loc_10.x) + (_loc_3.y - _loc_10.y) * (_loc_11.y - _loc_10.y)) / _loc_12;
                    if (_loc_15 >= 0)
                    {
                    }
                    if (_loc_15 <= 1)
                    {
                    }
                    if (_loc_14 < 5)
                    {
                        _loc_5.push({distance:_loc_14, sPoint:_loc_10, ePoint:_loc_11, sMapPoint:_loc_8, eMapPoint:_loc_9, ratio:_loc_15, pathOrRingIndex:this.m_arrayOfSegments[_loc_6].pathOrRingIndex, index:this.m_arrayOfSegments[_loc_6].index});
                    }
                    _loc_6 = _loc_6 + 2;
                }
                if (_loc_5.length > 0)
                {
                    _loc_16 = _loc_5[0].distance;
                    _loc_17 = _loc_5[0].sPoint;
                    _loc_18 = _loc_5[0].ePoint;
                    _loc_19 = _loc_5[0].sMapPoint;
                    _loc_20 = _loc_5[0].eMapPoint;
                    _loc_21 = _loc_5[0].ratio;
                    this.m_closestPathOrRingIndex = _loc_5[0].pathOrRingIndex;
                    this.m_closestPointIndex = _loc_5[0].index;
                    _loc_22 = 0;
                    while (_loc_22 < _loc_5.length)
                    {
                        
                        if (_loc_5[_loc_22].distance < _loc_16)
                        {
                            _loc_16 = _loc_5[_loc_22].distance;
                            _loc_17 = _loc_5[_loc_22].sPoint;
                            _loc_18 = _loc_5[_loc_22].ePoint;
                            _loc_19 = _loc_5[_loc_22].sMapPoint;
                            _loc_20 = _loc_5[_loc_22].eMapPoint;
                            _loc_21 = _loc_5[_loc_22].ratio;
                            this.m_closestPathOrRingIndex = _loc_5[_loc_22].pathOrRingIndex;
                            this.m_closestPointIndex = _loc_5[_loc_22].index;
                        }
                        _loc_22 = _loc_22 + 1;
                    }
                    if (this.map.wrapAround180)
                    {
                    }
                    _loc_23 = this.map.extent.spatialReference.info ? (this.map.extent.spatialReference.info.world * _loc_4) : (0);
                    _loc_24 = _loc_17.x + _loc_21 * (_loc_18.x - _loc_17.x);
                    _loc_25 = _loc_17.y + _loc_21 * (_loc_18.y - _loc_17.y);
                    _loc_26 = this.map.toMap(new Point(_loc_24, _loc_25));
                    _loc_27 = new MapPoint(_loc_26.x + _loc_23, _loc_26.y);
                    this.m_ghostVertexNeighborStartPoint = _loc_19;
                    this.m_ghostVertexNeighborEndPoint = _loc_20;
                    this.m_ghostVertexRatio = _loc_21;
                    if (!this.m_ghostGraphic)
                    {
                        this.m_ghostGraphic = new Graphic(_loc_27, this.ghostVertexSymbol);
                        this.m_ghostGraphic.addEventListener(MouseEvent.MOUSE_DOWN, this.tempGraphicMouseDownHandler);
                        _loc_28 = ArrayCollection(this.map.defaultGraphicsLayer.graphicProvider);
                        if (!_loc_28.length)
                        {
                            _loc_28.addItemAt(this.m_ghostGraphic, 0);
                        }
                        else
                        {
                            _loc_29 = _loc_28.getItemIndex(this.m_graphic);
                            if (_loc_29 != -1)
                            {
                                _loc_28.addItemAt(this.m_ghostGraphic, (_loc_29 + 1));
                            }
                            else
                            {
                                _loc_28.addItemAt(this.m_ghostGraphic, 0);
                            }
                        }
                    }
                    else
                    {
                        this.m_ghostGraphic.geometry = _loc_27;
                        this.m_ghostGraphic.refresh();
                        this.m_ghostGraphic.visible = true;
                    }
                }
                else if (this.m_ghostGraphic)
                {
                    this.m_ghostGraphic.visible = false;
                }
            }
            else if (this.m_ghostGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_ghostGraphic);
                this.m_ghostGraphic = null;
            }
            return;
        }// end function

        private function map_zoomStartHandler(event:ZoomEvent) : void
        {
            this.m_hideGraphicZoom = true;
            return;
        }// end function

        private function map_zoomEndHandler(event:ZoomEvent) : void
        {
            this.m_hideGraphicZoom = false;
            return;
        }// end function

        private function graphicRollOverHandler(event:MouseEvent) : void
        {
            if (!event.shiftKey)
            {
            }
            if (this.allowAddVertices)
            {
            }
            if (this.m_allEditTypesActive)
            {
            }
            if (Graphic(event.target).geometry is Polyline)
            {
            }
            if (this.m_allEditTypesActive)
            {
            }
            if (Graphic(event.target).geometry is Multipoint)
            {
                if (Graphic(event.target).symbol is SimpleMarkerSymbol)
                {
                }
            }
            if (!(Graphic(event.target).symbol is PictureMarkerSymbol))
            {
            }
            else
            {
                CursorManager.setCursor(this.moveCursor, CursorManagerPriority.HIGH, -16, -16);
            }
            return;
        }// end function

        private function graphicRollOutHandler(event:MouseEvent) : void
        {
            CursorManager.removeCursor(CursorManager.currentCursorID);
            return;
        }// end function

        private function tempGraphicMouseDownHandler(event:MouseEvent) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            this.m_initialGhostVertexMouseDownPoint = this.map.toMapFromStage(event.stageX, event.stageY);
            this.m_initialMouseDownFrameId = 0;
            if (this.map.wrapAround180)
            {
                this.m_initialMouseDownFrameId = Extent.normalizeX(this.m_initialGhostVertexMouseDownPoint.x, this.map.extent.spatialReference.info).frameId;
            }
            var _loc_2:* = Graphic(event.target);
            _loc_2.symbol = this.vertexSymbol;
            this.m_ghostGraphicMoving = true;
            _loc_2.geometry = new MapPoint(this.m_ghostVertexNeighborStartPoint.x + this.m_ghostVertexRatio * (this.m_ghostVertexNeighborEndPoint.x - this.m_ghostVertexNeighborStartPoint.x), MapPoint(_loc_2.geometry).y);
            if (this.m_graphic.geometry.type == Geometry.POLYLINE)
            {
                _loc_3 = Polyline(this.m_graphic.geometry).hasZ;
                _loc_4 = Polyline(this.m_graphic.geometry).hasM;
                this.handleMZ(_loc_2, _loc_4, _loc_3);
                this.m_pointIndex = this.m_closestPointIndex + 1;
                this.m_pathIndex = this.m_closestPathOrRingIndex;
                dispatchEvent(new EditEvent(EditEvent.GHOST_VERTEX_MOUSE_DOWN, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
                Polyline(this.m_graphic.geometry).insertPoint(this.m_pathIndex, this.m_pointIndex, MapPoint(_loc_2.geometry));
                Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
            }
            else
            {
                _loc_3 = Polygon(this.m_graphic.geometry).hasZ;
                _loc_4 = Polygon(this.m_graphic.geometry).hasM;
                this.handleMZ(_loc_2, _loc_4, _loc_3);
                this.m_pointIndex = this.m_closestPointIndex + 1;
                this.m_ringIndex = this.m_closestPathOrRingIndex;
                dispatchEvent(new EditEvent(EditEvent.GHOST_VERTEX_MOUSE_DOWN, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
                Polygon(this.m_graphic.geometry).insertPoint(this.m_ringIndex, this.m_pointIndex, MapPoint(Graphic(event.target).geometry));
                Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
            }
            this.m_graphic.refresh();
            event.target.addEventListener(MouseEvent.CLICK, this.ghostVertex_mouseClickHandler, false, 1, true);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
            this.map.addEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            return;
        }// end function

        private function handleMZ(graphic:Graphic, hasM:Boolean, hasZ:Boolean) : void
        {
            if (hasM)
            {
                MapPoint(graphic.geometry).m = 0;
            }
            if (hasZ)
            {
                if (!isNaN(FeatureLayerDetails(FeatureLayer(this.m_graphic.graphicsLayer).layerDetails).zDefault))
                {
                    MapPoint(graphic.geometry).z = FeatureLayerDetails(FeatureLayer(this.m_graphic.graphicsLayer).layerDetails).zDefault;
                }
                else
                {
                    MapPoint(graphic.geometry).z = 0;
                }
            }
            return;
        }// end function

        private function map_mouseMoveFirstHandler(event:MouseEvent) : void
        {
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveNextHandler);
            return;
        }// end function

        private function map_mouseMoveNextHandler(event:MouseEvent) : void
        {
            var _loc_2:MapPoint = null;
            var _loc_5:Number = NaN;
            var _loc_6:Object = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Array = null;
            var _loc_9:MapPoint = null;
            _loc_2 = this.map.toMapFromStage(event.stageX, event.stageY);
            var _loc_3:* = _loc_2.x - this.m_initialGhostVertexMouseDownPoint.x;
            var _loc_4:* = _loc_2.y - this.m_initialGhostVertexMouseDownPoint.y;
            this.m_initialGhostVertexMouseDownPoint.x = this.m_initialGhostVertexMouseDownPoint.x + _loc_3;
            this.m_initialGhostVertexMouseDownPoint.y = this.m_initialGhostVertexMouseDownPoint.y + _loc_4;
            this.m_ghostGraphic.geometry = new MapPoint(MapPoint(this.m_ghostGraphic.geometry).x + _loc_3, MapPoint(this.m_ghostGraphic.geometry).y + _loc_4);
            MapPoint(this.m_ghostGraphic.geometry).z = this.m_ghostVertexZ;
            MapPoint(this.m_ghostGraphic.geometry).m = this.m_ghostVertexM;
            if (this.m_snappingEnabled)
            {
                this.snapping = this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false));
                _loc_5 = 0;
                if (this.map.wrapAround180)
                {
                    _loc_6 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                    _loc_7 = new MapPoint(_loc_6.x, _loc_2.y, _loc_2.spatialReference);
                    _loc_5 = _loc_6.frameId;
                    this.checkForSnapping(this.m_ghostGraphic, false, this.m_initialGhostVertexMouseDownPoint, _loc_7, _loc_5);
                }
                else
                {
                    this.checkForSnapping(this.m_ghostGraphic, false, this.m_initialGhostVertexMouseDownPoint, _loc_2, _loc_5);
                }
            }
            if (this.m_graphic.geometry.type == Geometry.POLYLINE)
            {
                Polyline(this.m_graphic.geometry).setPoint(this.m_pathIndex, this.m_pointIndex, this.m_ghostGraphic.geometry as MapPoint);
            }
            else
            {
                Polygon(this.m_graphic.geometry).rings[this.m_ringIndex].pop();
                _loc_8 = Polygon(this.m_graphic.geometry).rings[this.m_ringIndex];
                _loc_8[this.m_pointIndex] = this.m_ghostGraphic.geometry as MapPoint;
                _loc_9 = new MapPoint(_loc_8[0].x, _loc_8[0].y);
                _loc_9.z = _loc_8[0].z;
                _loc_9.m = _loc_8[0].m;
                _loc_8.push(_loc_9);
            }
            this.m_graphic.refresh();
            return;
        }// end function

        private function map_mouseUpHandler(event:MouseEvent) : void
        {
            this.m_ghostGraphicMoving = false;
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveFirstHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveNextHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            if (this.m_snapGraphic)
            {
                this.m_snapGraphic.visible = false;
            }
            this.m_ghostGraphic.symbol = this.ghostVertexSymbol;
            if (this.m_graphic.geometry.type == Geometry.POLYLINE)
            {
                this.m_polylineVertexLayer.load(Polyline(this.m_graphic.geometry));
                Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_ADD, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            }
            else
            {
                this.m_polygonVertexLayer.load(Polygon(this.m_graphic.geometry));
                Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_ADD, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            }
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            this.calculateSegments(this.m_graphic);
            return;
        }// end function

        private function ghostVertex_mouseClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            event.target.removeEventListener(MouseEvent.CLICK, this.ghostVertex_mouseClickHandler);
            return;
        }// end function

        private function graphicRemoveHandler(event:GraphicEvent) : void
        {
            var _loc_2:* = this.m_graphicArray.indexOf(event.graphic);
            if (_loc_2 != -1)
            {
                this.m_graphicArray.splice(_loc_2, 1);
                if (!this.m_editVerticesActive)
                {
                }
                if (this.m_allEditTypesActive)
                {
                    this.removeTemporaryGraphics();
                }
            }
            return;
        }// end function

        private function graphicHideHandler(event:FlexEvent) : void
        {
            if (!this.m_hideGraphicZoom)
            {
                if (this.m_ghostGraphic)
                {
                    this.map.defaultGraphicsLayer.remove(this.m_ghostGraphic);
                    this.m_ghostGraphic = null;
                }
                if (this.m_snapGraphic)
                {
                    this.map.defaultGraphicsLayer.remove(this.m_snapGraphic);
                    this.m_snapGraphic = null;
                }
                if (this.m_scaleRotateTempExtentGraphic)
                {
                    this.map.defaultGraphicsLayer.remove(this.m_scaleRotateTempExtentGraphic);
                    this.m_scaleRotateTempExtentGraphic = null;
                }
                if (this.m_polygonVertexLayer.arrGraphics.length)
                {
                    this.m_polygonVertexLayer.hide();
                }
                if (this.m_polylineVertexLayer.arrGraphics.length)
                {
                    this.m_polylineVertexLayer.hide();
                }
                if (this.m_scaleRotatePolylineLayer.arrGraphics.length)
                {
                    this.m_scaleRotatePolylineLayer.hide();
                }
                if (this.m_scaleRotatePolygonLayer.arrGraphics.length)
                {
                    this.m_scaleRotatePolygonLayer.hide();
                }
                if (this.m_scaleRotateExtentLayer.arrGraphics.length)
                {
                    this.m_scaleRotateExtentLayer.hide();
                }
            }
            return;
        }// end function

        private function graphicShowHandler(event:FlexEvent) : void
        {
            if (this.m_snapGraphic)
            {
            }
            if (!this.m_snapGraphic.visible)
            {
                this.m_snapGraphic.visible = true;
            }
            if (this.m_ghostGraphic)
            {
            }
            if (!this.m_ghostGraphic.visible)
            {
                this.m_ghostGraphic.visible = true;
            }
            if (this.m_scaleRotateTempExtentGraphic)
            {
            }
            if (!this.m_scaleRotateTempExtentGraphic.visible)
            {
                this.m_scaleRotateTempExtentGraphic.visible = true;
            }
            if (this.m_polygonVertexLayer.arrGraphics.length)
            {
                this.m_polygonVertexLayer.show();
            }
            if (this.m_polylineVertexLayer.arrGraphics.length)
            {
                this.m_polylineVertexLayer.show();
            }
            if (this.m_scaleRotatePolylineLayer.arrGraphics.length)
            {
                this.m_scaleRotatePolylineLayer.show();
            }
            if (this.m_scaleRotatePolygonLayer.arrGraphics.length)
            {
                this.m_scaleRotatePolygonLayer.show();
            }
            if (this.m_scaleRotateExtentLayer.arrGraphics.length)
            {
                this.m_scaleRotateExtentLayer.show();
            }
            return;
        }// end function

        private function graphicsClearHandler(event:GraphicsLayerEvent) : void
        {
            this.m_graphicArray = [];
            this.removeTemporaryGraphics();
            return;
        }// end function

        private function removeTemporaryGraphics() : void
        {
            if (this.m_multipointGraphicSymbol)
            {
                this.m_graphic.removeEventListener(MouseEvent.MOUSE_OVER, this.multipointGraphicRollOverHandler);
                this.m_graphic.buttonMode = false;
                this.m_graphic.symbol = this.m_noGraphicSymbol ? (null) : (this.m_multipointGraphicSymbol);
                this.m_multipointGraphicSymbol = null;
            }
            if (this.m_polygonVertexLayer.arrGraphics.length)
            {
                this.m_polygonVertexLayer.clear();
            }
            if (this.m_polylineVertexLayer.arrGraphics.length)
            {
                this.m_polylineVertexLayer.clear();
            }
            if (this.m_scaleRotatePolylineLayer.arrGraphics.length)
            {
                this.m_scaleRotatePolylineLayer.clear();
            }
            if (this.m_scaleRotatePolygonLayer.arrGraphics.length)
            {
                this.m_scaleRotatePolygonLayer.clear();
            }
            if (this.m_scaleRotateExtentLayer.arrGraphics.length)
            {
                this.m_scaleRotateExtentLayer.clear();
            }
            if (this.m_scaleRotateTempExtentGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_scaleRotateTempExtentGraphic);
                this.m_scaleRotateTempExtentGraphic = null;
            }
            if (this.m_ghostGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_ghostGraphic);
                this.m_ghostGraphic = null;
            }
            if (this.m_snapGraphic)
            {
                this.map.defaultGraphicsLayer.remove(this.m_snapGraphic);
                this.m_snapGraphic = null;
            }
            return;
        }// end function

        private function graphicMouseDownHandler(event:MouseEvent) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Graphic = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Number = NaN;
            var _loc_9:Array = null;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:MapPoint = null;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:MapPoint = null;
            var _loc_2:* = this.map.toMapFromStage(event.stageX, event.stageY);
            var _loc_3:* = Graphic(event.currentTarget).geometry.type;
            if (this.m_moveActive)
            {
            }
            if (this.m_graphicArray.length == 1)
            {
                this.m_graphic = Graphic(event.currentTarget);
                this.m_parentGraphicsLayer = GraphicsLayer(this.m_graphic.parent);
                this.m_parentGraphicsLayer.moveToTop(this.m_graphic);
            }
            this.m_graphicDistanceHolderArray = new Array();
            for each (_loc_6 in this.m_graphicArray)
            {
                
                switch(_loc_6.geometry.type)
                {
                    case Geometry.MAPPOINT:
                    {
                        this.m_initialMouseDownFrameId = 0;
                        if (this.map.wrapAround180)
                        {
                        }
                        if (this.map.extent.spatialReference.info)
                        {
                            this.m_initialMouseDownFrameId = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info).frameId;
                            if (MapPoint(_loc_6.geometry).x != this.map.extent.spatialReference.info.valid[0])
                            {
                            }
                            if (MapPoint(_loc_6.geometry).x == this.map.extent.spatialReference.info.valid[1])
                            {
                                this.updateMouseDownFrameId(MapPoint(_loc_6.geometry), _loc_2);
                            }
                        }
                        this.m_distanceHolderArray = [];
                        _loc_4 = MapPoint(_loc_6.geometry).x - _loc_2.x;
                        _loc_5 = MapPoint(_loc_6.geometry).y - _loc_2.y;
                        this.m_distanceHolderArray[0] = [_loc_4, _loc_5, MapPoint(_loc_6.geometry).z, MapPoint(_loc_6.geometry).m];
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        this.m_distanceHolderArray = [];
                        if (!this.m_moveActive)
                        {
                            if (!this.m_editVerticesActive)
                            {
                            }
                            if (this.m_allEditTypesActive)
                            {
                                if (!(_loc_6.symbol is SimpleMarkerSymbol))
                                {
                                }
                            }
                        }
                        if (_loc_6.symbol is PictureMarkerSymbol)
                        {
                            if (!this.m_editVerticesActive)
                            {
                            }
                            if (this.m_allEditTypesActive)
                            {
                                this.m_isMultipointVertexEditing = true;
                                _loc_7 = Multipoint(_loc_6.geometry).getPoint(this.m_multipointVertexIndex);
                                _loc_4 = _loc_7.x - _loc_2.x;
                                _loc_5 = _loc_7.y - _loc_2.y;
                                this.m_distanceHolderArray[0] = [_loc_4, _loc_5, _loc_7.z, _loc_7.m];
                            }
                            else
                            {
                                _loc_8 = 0;
                                while (_loc_8 < Multipoint(_loc_6.geometry).points.length)
                                {
                                    
                                    _loc_7 = Multipoint(_loc_6.geometry).getPoint(_loc_8);
                                    _loc_4 = _loc_7.x - _loc_2.x;
                                    _loc_5 = _loc_7.y - _loc_2.y;
                                    this.m_distanceHolderArray[_loc_8] = [_loc_4, _loc_5, _loc_7.z, _loc_7.m];
                                    _loc_8 = _loc_8 + 1;
                                }
                            }
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = false;
                            this.m_scaleRotateExtentLayer.hide();
                        }
                        _loc_9 = [new MapPoint(Extent(_loc_6.geometry).xmin, Extent(_loc_6.geometry).ymin), new MapPoint(Extent(_loc_6.geometry).xmin, Extent(_loc_6.geometry).ymax), new MapPoint(Extent(_loc_6.geometry).xmax, Extent(_loc_6.geometry).ymax), new MapPoint(Extent(_loc_6.geometry).xmax, Extent(_loc_6.geometry).ymin)];
                        this.m_distanceHolderArray = [];
                        _loc_10 = 0;
                        while (_loc_10 < _loc_9.length)
                        {
                            
                            _loc_4 = _loc_9[_loc_10].x - _loc_2.x;
                            _loc_5 = _loc_9[_loc_10].y - _loc_2.y;
                            this.m_distanceHolderArray[_loc_10] = [_loc_4, _loc_5];
                            _loc_10 = _loc_10 + 1;
                        }
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        if (this.m_allEditTypesActive)
                        {
                            this.m_polygonVertexLayer.hide();
                            if (this.m_ghostGraphic)
                            {
                                this.map.defaultGraphicsLayer.remove(this.m_ghostGraphic);
                                this.m_ghostGraphic = null;
                            }
                        }
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = false;
                            this.m_scaleRotatePolygonLayer.hide();
                        }
                        this.m_polygonGraphicMoving = true;
                        this.m_distanceHolderArray = [];
                        _loc_11 = 0;
                        while (_loc_11 < Polygon(_loc_6.geometry).rings.length)
                        {
                            
                            this.m_distanceArray = [];
                            _loc_12 = 0;
                            while (_loc_12 < Polygon(_loc_6.geometry).rings[_loc_11].length)
                            {
                                
                                _loc_13 = Polygon(_loc_6.geometry).getPoint(_loc_11, _loc_12);
                                _loc_4 = _loc_13.x - _loc_2.x;
                                _loc_5 = _loc_13.y - _loc_2.y;
                                this.m_distanceArray[_loc_12] = [_loc_4, _loc_5, _loc_13.z, _loc_13.m];
                                _loc_12 = _loc_12 + 1;
                            }
                            this.m_distanceHolderArray[_loc_11] = this.m_distanceArray;
                            _loc_11 = _loc_11 + 1;
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        if (this.m_allEditTypesActive)
                        {
                            this.m_polylineVertexLayer.hide();
                        }
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = false;
                            this.m_scaleRotatePolylineLayer.hide();
                        }
                        this.m_distanceHolderArray = [];
                        _loc_14 = 0;
                        while (_loc_14 < Polyline(_loc_6.geometry).paths.length)
                        {
                            
                            this.m_distanceArray = [];
                            _loc_15 = 0;
                            while (_loc_15 < Polyline(_loc_6.geometry).paths[_loc_14].length)
                            {
                                
                                _loc_16 = Polyline(_loc_6.geometry).getPoint(_loc_14, _loc_15);
                                _loc_4 = _loc_16.x - _loc_2.x;
                                _loc_5 = _loc_16.y - _loc_2.y;
                                this.m_distanceArray[_loc_15] = [_loc_4, _loc_5, _loc_16.z, _loc_16.m];
                                _loc_15 = _loc_15 + 1;
                            }
                            this.m_distanceHolderArray[_loc_14] = this.m_distanceArray;
                            _loc_14 = _loc_14 + 1;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this.m_graphicDistanceHolderArray.push({graphic:_loc_6, distanceHolderArray:this.m_distanceHolderArray});
            }
            dispatchEvent(new EditEvent(EditEvent.GRAPHICS_MOVE_START, null, null, 0, 0, 0, this.m_graphicArray));
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this.map.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        private function mouseMoveFirstHandler(event:MouseEvent) : void
        {
            dispatchEvent(new EditEvent(EditEvent.GRAPHICS_MOVE_FIRST, null, null, 0, 0, 0, this.m_graphicArray));
            event.target.addEventListener(MouseEvent.CLICK, this.graphicMouseClickHandler, false, 1, true);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            return;
        }// end function

        private function mouseMoveNextHandler(event:MouseEvent) : void
        {
            var _loc_4:Graphic = null;
            var _loc_5:MapPoint = null;
            var _loc_6:Number = NaN;
            var _loc_7:Object = null;
            var _loc_8:MapPoint = null;
            var _loc_9:Multipoint = null;
            var _loc_10:Array = null;
            var _loc_11:Number = NaN;
            var _loc_12:Extent = null;
            var _loc_13:Array = null;
            var _loc_14:Number = NaN;
            var _loc_15:Polygon = null;
            var _loc_16:Number = NaN;
            var _loc_17:Array = null;
            var _loc_18:Number = NaN;
            var _loc_19:Polyline = null;
            var _loc_20:Number = NaN;
            var _loc_21:Array = null;
            var _loc_22:Number = NaN;
            var _loc_2:* = this.map.toMapFromStage(event.stageX, event.stageY);
            var _loc_3:Number = 0;
            while (_loc_3 < this.m_graphicDistanceHolderArray.length)
            {
                
                _loc_4 = Graphic(this.m_graphicDistanceHolderArray[_loc_3].graphic);
                switch(_loc_4.geometry.type)
                {
                    case Geometry.MAPPOINT:
                    {
                        _loc_5 = new MapPoint(_loc_2.x + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][0], _loc_2.y + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][1], _loc_4.geometry.spatialReference);
                        _loc_5.z = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][2];
                        _loc_5.m = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][3];
                        _loc_4.geometry = _loc_5;
                        if (this.m_snappingEnabled)
                        {
                            this.snapping = this.m_snapMode == SNAP_MODE_ALWAYS_ON ? (true) : (event.ctrlKey ? (true) : (false));
                            _loc_6 = 0;
                            if (this.map.wrapAround180)
                            {
                                _loc_7 = Extent.normalizeX(_loc_2.x, this.map.extent.spatialReference.info);
                                _loc_8 = new MapPoint(_loc_7.x, _loc_2.y, _loc_2.spatialReference);
                                _loc_6 = _loc_7.frameId;
                                this.checkForSnapping(_loc_4, true, null, _loc_8, _loc_6);
                            }
                            else
                            {
                                this.checkForSnapping(_loc_4, true, null, _loc_2, _loc_6);
                            }
                        }
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        if (!this.m_moveActive)
                        {
                            if (!this.m_editVerticesActive)
                            {
                            }
                            if (this.m_allEditTypesActive)
                            {
                                if (!(_loc_4.symbol is SimpleMarkerSymbol))
                                {
                                }
                            }
                        }
                        if (_loc_4.symbol is PictureMarkerSymbol)
                        {
                            if (!this.m_editVerticesActive)
                            {
                            }
                            if (this.m_allEditTypesActive)
                            {
                                _loc_5 = new MapPoint(_loc_2.x + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][0], _loc_2.y + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][1], _loc_4.geometry.spatialReference);
                                _loc_5.z = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][2];
                                _loc_5.m = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[0][3];
                                Multipoint(_loc_4.geometry).setPoint(this.m_multipointVertexIndex, _loc_5);
                                _loc_4.refresh();
                            }
                            else
                            {
                                _loc_9 = new Multipoint();
                                _loc_10 = [];
                                _loc_11 = 0;
                                while (_loc_11 < this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray.length)
                                {
                                    
                                    _loc_5 = new MapPoint(_loc_2.x + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_11][0], _loc_2.y + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_11][1]);
                                    _loc_5.z = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_11][2];
                                    _loc_5.m = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_11][3];
                                    _loc_10.push(_loc_5);
                                    _loc_11 = _loc_11 + 1;
                                }
                                _loc_9.points = _loc_10;
                                _loc_9.spatialReference = _loc_4.geometry.spatialReference;
                                _loc_4.geometry = _loc_9;
                            }
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        _loc_12 = new Extent();
                        _loc_13 = [];
                        _loc_14 = 0;
                        while (_loc_14 < this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray.length)
                        {
                            
                            _loc_13.push(new MapPoint(_loc_2.x + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_14][0], _loc_2.y + this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_14][1]));
                            _loc_14 = _loc_14 + 1;
                        }
                        _loc_12.xmin = _loc_13[0].x;
                        _loc_12.ymin = _loc_13[0].y;
                        _loc_12.xmax = _loc_13[2].x;
                        _loc_12.ymax = _loc_13[2].y;
                        _loc_12.spatialReference = _loc_4.geometry.spatialReference;
                        _loc_4.geometry = _loc_12;
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        _loc_15 = new Polygon();
                        _loc_16 = 0;
                        while (_loc_16 < this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray.length)
                        {
                            
                            this.m_distanceArray = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_16];
                            _loc_17 = [];
                            _loc_18 = 0;
                            while (_loc_18 < this.m_distanceArray.length)
                            {
                                
                                _loc_5 = new MapPoint(_loc_2.x + this.m_distanceArray[_loc_18][0], _loc_2.y + this.m_distanceArray[_loc_18][1]);
                                _loc_5.z = this.m_distanceArray[_loc_18][2];
                                _loc_5.m = this.m_distanceArray[_loc_18][3];
                                _loc_17.push(_loc_5);
                                _loc_18 = _loc_18 + 1;
                            }
                            _loc_15.addRing(_loc_17);
                            _loc_16 = _loc_16 + 1;
                        }
                        _loc_15.spatialReference = _loc_4.geometry.spatialReference;
                        _loc_4.geometry = _loc_15;
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        _loc_19 = new Polyline();
                        _loc_20 = 0;
                        while (_loc_20 < this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray.length)
                        {
                            
                            this.m_distanceArray = this.m_graphicDistanceHolderArray[_loc_3].distanceHolderArray[_loc_20];
                            _loc_21 = [];
                            _loc_22 = 0;
                            while (_loc_22 < this.m_distanceArray.length)
                            {
                                
                                _loc_5 = new MapPoint(_loc_2.x + this.m_distanceArray[_loc_22][0], _loc_2.y + this.m_distanceArray[_loc_22][1]);
                                _loc_5.z = this.m_distanceArray[_loc_22][2];
                                _loc_5.m = this.m_distanceArray[_loc_22][3];
                                _loc_21.push(_loc_5);
                                _loc_22 = _loc_22 + 1;
                            }
                            _loc_19.addPath(_loc_21);
                            _loc_20 = _loc_20 + 1;
                        }
                        _loc_19.spatialReference = _loc_4.geometry.spatialReference;
                        _loc_4.geometry = _loc_19;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            dispatchEvent(new EditEvent(EditEvent.GRAPHICS_MOVE, null, null, 0, 0, 0, this.m_graphicArray));
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveFirstHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveNextHandler);
            this.map.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            if (this.m_snapGraphic)
            {
                this.m_snapGraphic.visible = false;
            }
            if (!this.m_allEditTypesActive)
            {
            }
            if (!this.m_editVerticesActive)
            {
            }
            if (!this.m_scaleActive)
            {
            }
            if (this.m_rotateActive)
            {
                switch(this.m_graphic.geometry.type)
                {
                    case Geometry.MAPPOINT:
                    {
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        this.m_multipointVertexIndex = 0;
                        this.m_isMultipointVertexEditing = false;
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = true;
                            this.m_scaleRotatePolygonLayer.show();
                            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
                            this.m_scaleRotatePolygonLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                        }
                        else
                        {
                            this.m_polygonVertexLayer.show();
                            this.m_polygonGraphicMoving = false;
                            this.m_polygonVertexLayer.load(this.m_graphic.geometry as Polygon);
                            this.calculateSegments(this.m_graphic);
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = true;
                            this.m_scaleRotatePolylineLayer.show();
                            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
                            this.m_scaleRotatePolylineLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                        }
                        else
                        {
                            this.m_polylineVertexLayer.show();
                            this.m_polylineVertexLayer.load(this.m_graphic.geometry as Polyline);
                            this.calculateSegments(this.m_graphic);
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (this.m_rotateActive)
                        {
                            this.m_scaleRotateTempExtentGraphic.visible = true;
                            this.m_scaleRotateExtentLayer.show();
                            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(Extent(this.m_graphic.geometry));
                            this.m_scaleRotateExtentLayer.load(Extent(this.m_graphic.geometry), this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            dispatchEvent(new EditEvent(EditEvent.GRAPHICS_MOVE_STOP, null, null, 0, 0, 0, this.m_graphicArray));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, this.m_graphicArray));
            return;
        }// end function

        private function graphicMouseClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            event.target.removeEventListener(MouseEvent.CLICK, this.graphicMouseClickHandler);
            return;
        }// end function

        private function editVerticesEnable(graphic:Graphic) : void
        {
            var _loc_2:SimpleMarkerSymbol = null;
            var _loc_3:PictureMarkerSymbol = null;
            if (graphic.visible)
            {
                this.removeTemporaryGraphics();
                this.m_graphic = graphic;
                this.m_parentGraphicsLayer = this.m_graphic.graphicsLayer;
                if (this.m_parentGraphicsLayer)
                {
                    this.m_parentGraphicsLayer.moveToTop(this.m_graphic);
                }
                switch(this.m_graphic.geometry.type)
                {
                    case Geometry.MULTIPOINT:
                    {
                        if (!this.m_graphic.symbol)
                        {
                            this.m_noGraphicSymbol = true;
                            this.m_multipointGraphicSymbol = this.m_graphic.getActiveSymbol(this.m_parentGraphicsLayer);
                        }
                        else
                        {
                            this.m_multipointGraphicSymbol = this.m_graphic.symbol;
                        }
                        if (!(this.m_multipointGraphicSymbol is SimpleMarkerSymbol))
                        {
                        }
                        if (this.m_multipointGraphicSymbol is PictureMarkerSymbol)
                        {
                            this.m_graphic.addEventListener(MouseEvent.MOUSE_OVER, this.multipointGraphicRollOverHandler);
                            if (this.m_multipointGraphicSymbol is SimpleMarkerSymbol)
                            {
                                registerClassAlias("SimpleMarkerSymbol", SimpleMarkerSymbol);
                                registerClassAlias("SimpleLineSymbol", SimpleLineSymbol);
                                _loc_2 = ObjectUtil.copy(this.m_multipointGraphicSymbol) as SimpleMarkerSymbol;
                                _loc_2.m_editModeOn = true;
                                this.m_graphic.symbol = _loc_2;
                            }
                            else
                            {
                                registerClassAlias("PictureMarkerSymbol", PictureMarkerSymbol);
                                _loc_3 = ObjectUtil.copy(this.m_multipointGraphicSymbol) as PictureMarkerSymbol;
                                _loc_3.source = PictureMarkerSymbol(this.m_multipointGraphicSymbol).source;
                                _loc_3.m_editModeOn = true;
                                this.m_graphic.symbol = _loc_3;
                            }
                            this.m_graphic.buttonMode = true;
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (!this.m_rotateActive)
                        {
                        }
                        if (this.m_scaleRotateActive)
                        {
                            this.map.defaultGraphicsLayer.remove(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotateTempExtentGraphic = new Graphic(this.extentToPolyline(this.m_graphic.geometry.extent), new SimpleLineSymbol(SimpleLineSymbol.STYLE_DASH, 0, 1, 1));
                            this.map.defaultGraphicsLayer.add(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotatePolylineLayer.init(this.map, this);
                            this.m_scaleRotatePolylineLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMoveStart", this.polylineScaleVertexMoveStartHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMoveFirst", this.polylinePolygonScaleVertexMoveFirstHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMove", this.polylineScaleVertexMoveHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMoveStop", this.polylineScaleVertexMoveStopHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMoveStart", this.polylineRotateVertexMoveStartHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMoveFirst", this.polylinePolygonRotateVertexMoveFirstHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMove", this.polylineRotateVertexMoveHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMoveStop", this.polylineRotateVertexMoveStopHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMouseOver", this.scaleVertexMouseOverHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("scaleVertexMouseOut", this.scaleVertexMouseOutHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMouseOver", this.rotateVertexMouseOverHandler);
                            this.m_scaleRotatePolylineLayer.addEventListener("rotateVertexMouseOut", this.rotateVertexMouseOutHandler);
                        }
                        else
                        {
                            this.m_polylineVertexLayer.init(this.map, this);
                            this.m_polylineVertexLayer.load(this.m_graphic.geometry as Polyline);
                            this.calculateSegments(this.m_graphic);
                            this.m_polylineVertexLayer.addEventListener("vertexDelete", this.polylineVertexDeleteHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMouseOver", this.vertexMouseOverHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMouseOut", this.vertexMouseOutHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMoveStart", this.vertexMoveStartHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMoveFirst", this.vertexMoveFirstHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMove", this.polylineVertexMoveHandler);
                            this.m_polylineVertexLayer.addEventListener("vertexMoveStop", this.vertexMoveStopHandler);
                            this.m_polylineVertexLayer.addEventListener(EditEvent.CONTEXT_MENU_SELECT, this.onContextMenuSelect);
                        }
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (!this.m_rotateActive)
                        {
                        }
                        if (this.m_scaleRotateActive)
                        {
                            this.map.defaultGraphicsLayer.remove(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotateTempExtentGraphic = new Graphic(this.extentToPolyline(this.m_graphic.geometry.extent), new SimpleLineSymbol(SimpleLineSymbol.STYLE_DASH, 0, 1, 1));
                            this.map.defaultGraphicsLayer.add(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotatePolygonLayer.init(this.map, this);
                            this.m_scaleRotatePolygonLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMoveStart", this.polygonScaleVertexMoveStartHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMoveFirst", this.polylinePolygonScaleVertexMoveFirstHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMove", this.polygonScaleVertexMoveHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMoveStop", this.polygonScaleVertexMoveStopHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMoveStart", this.polygonRotateVertexMoveStartHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMoveFirst", this.polylinePolygonRotateVertexMoveFirstHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMove", this.polygonRotateVertexMoveHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMoveStop", this.polygonRotateVertexMoveStopHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMouseOver", this.scaleVertexMouseOverHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("scaleVertexMouseOut", this.scaleVertexMouseOutHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMouseOver", this.rotateVertexMouseOverHandler);
                            this.m_scaleRotatePolygonLayer.addEventListener("rotateVertexMouseOut", this.rotateVertexMouseOutHandler);
                        }
                        else
                        {
                            this.m_polygonVertexLayer.init(this.map, this);
                            this.m_polygonVertexLayer.load(this.m_graphic.geometry as Polygon);
                            this.calculateSegments(this.m_graphic);
                            this.m_polygonVertexLayer.addEventListener("vertexDelete", this.polygonVertexDeleteHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMouseOver", this.vertexMouseOverHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMouseOut", this.vertexMouseOutHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMoveStart", this.vertexMoveStartHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMoveFirst", this.vertexMoveFirstHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMove", this.polygonVertexMoveHandler);
                            this.m_polygonVertexLayer.addEventListener("vertexMoveStop", this.vertexMoveStopHandler);
                            this.m_polygonVertexLayer.addEventListener(EditEvent.CONTEXT_MENU_SELECT, this.onContextMenuSelect);
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        if (!this.m_scaleActive)
                        {
                        }
                        if (!this.m_rotateActive)
                        {
                        }
                        if (this.m_scaleRotateActive)
                        {
                            this.m_rotateActive = false;
                            this.m_scaleRotateActive = false;
                            this.map.defaultGraphicsLayer.remove(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotateTempExtentGraphic = new Graphic(this.extentToPolyline(Extent(this.m_graphic.geometry)), new SimpleLineSymbol(SimpleLineSymbol.STYLE_DASH, 0, 1, 1));
                            this.map.defaultGraphicsLayer.add(this.m_scaleRotateTempExtentGraphic);
                            this.m_scaleRotateExtentLayer.init(this.map, this);
                            this.m_scaleRotateExtentLayer.load(Extent(this.m_graphic.geometry), this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
                            this.m_scaleRotateExtentLayer.addEventListener("scaleVertexMoveStart", this.extentScaleVertexMoveStartHandler);
                            this.m_scaleRotateExtentLayer.addEventListener("scaleVertexMove", this.extentScaleVertexMoveHandler);
                            this.m_scaleRotateExtentLayer.addEventListener("scaleVertexMoveStop", this.extentScaleVertexMoveStopHandler);
                            this.m_scaleRotateExtentLayer.addEventListener("scaleVertexMouseOver", this.scaleVertexMouseOverHandler);
                            this.m_scaleRotateExtentLayer.addEventListener("scaleVertexMouseOut", this.scaleVertexMouseOutHandler);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function calculateSegments(graphic:Graphic) : void
        {
            var _loc_5:MapPoint = null;
            var _loc_6:int = 0;
            var _loc_7:MapPoint = null;
            var _loc_2:* = graphic.geometry.type == Geometry.POLYLINE ? (Polyline(graphic.geometry).paths) : (Polygon(graphic.geometry).rings);
            var _loc_3:Array = [];
            this.m_arrayOfSegments = [];
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_4];
                _loc_5 = _loc_3[0];
                _loc_6 = 1;
                while (_loc_6 < _loc_3.length)
                {
                    
                    _loc_7 = _loc_3[_loc_6];
                    if (_loc_7.x == _loc_5.x)
                    {
                    }
                    if (_loc_7.y != _loc_5.y)
                    {
                        this.m_arrayOfSegments.push({point:_loc_5, index:(_loc_6 - 1), pathOrRingIndex:_loc_4});
                        this.m_arrayOfSegments.push({point:_loc_7, index:_loc_6, pathOrRingIndex:_loc_4});
                    }
                    _loc_5 = _loc_7;
                    _loc_6 = _loc_6 + 1;
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function multipointGraphicRollOverHandler(event:MouseEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:ContextMenu = null;
            var _loc_4:ContextMenuItem = null;
            if (!this.m_isMultipointVertexEditing)
            {
                _loc_2 = 0;
                while (_loc_2 < Multipoint(this.m_graphic.geometry).points.length)
                {
                    
                    if (Multipoint(this.m_graphic.geometry).points[_loc_2] == event.target.mapPoint)
                    {
                        this.m_multipointVertexIndex = _loc_2;
                        break;
                        continue;
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            if (this.m_allowDeleteVertices)
            {
                _loc_3 = new ContextMenu();
                if (_loc_3)
                {
                    _loc_3.hideBuiltInItems();
                    _loc_3.addEventListener(ContextMenuEvent.MENU_SELECT, this.onMultipointContextMenuSelect);
                    _loc_4 = new ContextMenuItem(ESRIMessageCodes.getString("editToolContextMenuItem"));
                    _loc_4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onMultipointContextMenuDelete);
                    if (_loc_3.customItems)
                    {
                        _loc_3.customItems.push(_loc_4);
                    }
                    event.target.contextMenu = _loc_3;
                }
            }
            return;
        }// end function

        private function onMultipointContextMenuDelete(event:ContextMenuEvent) : void
        {
            var _loc_2:* = Multipoint(this.m_graphic.geometry).points;
            _loc_2.splice(this.m_multipointVertexIndex, 1);
            Multipoint(this.m_graphic.geometry).points = Multipoint(this.m_graphic.geometry).points;
            this.m_graphic.refresh();
            return;
        }// end function

        private function vertexMouseOverHandler(event:Event) : void
        {
            if (!this.m_ghostGraphicMoving)
            {
                this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                if (this.m_ghostGraphic)
                {
                    this.m_ghostGraphic.visible = false;
                }
                if (event.target is PolylineVertexLayer)
                {
                    this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
                    this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
                    dispatchEvent(new EditEvent(EditEvent.VERTEX_MOUSE_OVER, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
                }
                else
                {
                    this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
                    this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
                    dispatchEvent(new EditEvent(EditEvent.VERTEX_MOUSE_OVER, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
                }
            }
            return;
        }// end function

        private function vertexMouseOutHandler(event:Event) : void
        {
            if (!this.m_ghostGraphicMoving)
            {
                this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
                if (event.target is PolylineVertexLayer)
                {
                    if (this.m_polylineVertexLayer.selectedVertex)
                    {
                        this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
                        this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
                        dispatchEvent(new EditEvent(EditEvent.VERTEX_MOUSE_OUT, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
                    }
                }
                else if (this.m_polygonVertexLayer.selectedVertex)
                {
                    this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
                    this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
                    dispatchEvent(new EditEvent(EditEvent.VERTEX_MOUSE_OUT, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
                }
            }
            return;
        }// end function

        private function vertexMoveStartHandler(event:Event) : void
        {
            this.m_initialMouseDownFrameId = 0;
            if (event.target is PolylineVertexLayer)
            {
                if (this.map.wrapAround180)
                {
                }
                if (this.map.extent.spatialReference.info)
                {
                    this.m_initialMouseDownFrameId = Extent.normalizeX(this.m_polylineVertexLayer.initialMouseDownPoint.x, this.map.extent.spatialReference.info).frameId;
                    if (this.m_polylineVertexLayer.initialMouseDownVertexPoint.x != this.map.extent.spatialReference.info.valid[0])
                    {
                    }
                    if (this.m_polylineVertexLayer.initialMouseDownVertexPoint.x == this.map.extent.spatialReference.info.valid[1])
                    {
                        this.updateMouseDownFrameId(this.m_polylineVertexLayer.initialMouseDownVertexPoint, this.m_polylineVertexLayer.initialMouseDownPoint);
                    }
                }
                this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
                this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_START, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            }
            else
            {
                if (this.map.wrapAround180)
                {
                }
                if (this.map.extent.spatialReference.info)
                {
                    this.m_initialMouseDownFrameId = Extent.normalizeX(this.m_polygonVertexLayer.initialMouseDownPoint.x, this.map.extent.spatialReference.info).frameId;
                    if (this.m_polygonVertexLayer.initialMouseDownVertexPoint.x != this.map.extent.spatialReference.info.valid[0])
                    {
                    }
                    if (this.m_polygonVertexLayer.initialMouseDownVertexPoint.x == this.map.extent.spatialReference.info.valid[1])
                    {
                        this.updateMouseDownFrameId(this.m_polygonVertexLayer.initialMouseDownVertexPoint, this.m_polygonVertexLayer.initialMouseDownPoint);
                    }
                }
                this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
                this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_START, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            }
            return;
        }// end function

        private function vertexMoveFirstHandler(event:Event) : void
        {
            if (event.target is PolylineVertexLayer)
            {
                this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
                this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_FIRST, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            }
            else
            {
                this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
                this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_FIRST, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            }
            return;
        }// end function

        private function vertexMoveStopHandler(event:Event) : void
        {
            if (this.m_snapGraphic)
            {
                this.m_snapGraphic.visible = false;
            }
            if (event.target is PolylineVertexLayer)
            {
                if (this.m_polylineVertexLayer.selectedVertex.symbol !== this.vertexSymbol)
                {
                    this.m_polylineVertexLayer.selectedVertex.symbol = this.m_vertexSymbol;
                }
                this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
                this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_STOP, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            }
            else
            {
                if (this.m_polygonVertexLayer.selectedVertex.symbol !== this.m_vertexSymbol)
                {
                    this.m_polygonVertexLayer.selectedVertex.symbol = this.m_vertexSymbol;
                }
                this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
                this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
                dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE_STOP, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            }
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function polylineVertexMoveHandler(event:Event) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Object = null;
            var _loc_4:MapPoint = null;
            if (this.m_snappingEnabled)
            {
                _loc_2 = 0;
                if (this.map.wrapAround180)
                {
                    _loc_3 = Extent.normalizeX(this.m_polylineVertexLayer.mouseMovePoint.x, this.map.extent.spatialReference.info);
                    _loc_4 = new MapPoint(_loc_3.x, this.m_polylineVertexLayer.mouseMovePoint.y, this.m_polylineVertexLayer.mouseMovePoint.spatialReference);
                    _loc_2 = _loc_3.frameId;
                    this.checkForSnapping(this.m_polylineVertexLayer.selectedVertex, false, this.m_polylineVertexLayer.initialMouseDownPoint, _loc_4, _loc_2);
                }
                else
                {
                    this.checkForSnapping(this.m_polylineVertexLayer.selectedVertex, false, this.m_polylineVertexLayer.initialMouseDownPoint, this.m_polylineVertexLayer.mouseMovePoint, _loc_2);
                }
            }
            this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
            this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
            Polyline(this.m_graphic.geometry).setPoint(this.m_pathIndex, this.m_pointIndex, this.m_polylineVertexLayer.selectedVertex.geometry as MapPoint);
            Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
            this.m_graphic.refresh();
            this.calculateSegments(this.m_graphic);
            dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            return;
        }// end function

        private function polylineVertexDeleteHandler(event:Event) : void
        {
            this.m_pointIndex = this.m_polylineVertexLayer.selectedVertex.attributes.index / 2;
            this.m_pathIndex = this.m_polylineVertexLayer.selectedVertex.attributes.pathIndex;
            Polyline(this.m_graphic.geometry).removePoint(this.m_pathIndex, this.m_pointIndex);
            Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
            this.m_graphic.refresh();
            this.calculateSegments(this.m_graphic);
            dispatchEvent(new EditEvent(EditEvent.VERTEX_DELETE, null, this.m_graphic, this.m_pointIndex, this.m_pathIndex));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            this.m_polylineVertexLayer.load(Polyline(this.m_graphic.geometry));
            return;
        }// end function

        private function polygonVertexMoveHandler(event:Event) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Object = null;
            var _loc_6:MapPoint = null;
            if (this.m_snappingEnabled)
            {
                _loc_3 = 0;
                _loc_4 = 0;
                if (this.map.wrapAround180)
                {
                    _loc_5 = Extent.normalizeX(this.m_polygonVertexLayer.mouseMovePoint.x, this.map.extent.spatialReference.info);
                    _loc_6 = new MapPoint(_loc_5.x, this.m_polygonVertexLayer.mouseMovePoint.y, this.m_polygonVertexLayer.mouseMovePoint.spatialReference);
                    _loc_3 = _loc_5.frameId;
                    this.checkForSnapping(this.m_polygonVertexLayer.selectedVertex, false, this.m_polygonVertexLayer.initialMouseDownPoint, _loc_6, _loc_3);
                }
                else
                {
                    this.checkForSnapping(this.m_polygonVertexLayer.selectedVertex, false, this.m_polygonVertexLayer.initialMouseDownPoint, this.m_polygonVertexLayer.mouseMovePoint, _loc_3);
                }
            }
            this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
            this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
            Polygon(this.m_graphic.geometry).rings[this.m_ringIndex].pop();
            var _loc_2:* = Polygon(this.m_graphic.geometry).rings[this.m_ringIndex];
            _loc_2[this.m_pointIndex] = this.m_polygonVertexLayer.selectedVertex.geometry;
            _loc_2.push(new MapPoint(_loc_2[0].x, _loc_2[0].y));
            Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
            this.m_graphic.refresh();
            this.calculateSegments(this.m_graphic);
            dispatchEvent(new EditEvent(EditEvent.VERTEX_MOVE, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            return;
        }// end function

        private function polygonVertexDeleteHandler(event:Event) : void
        {
            this.m_pointIndex = this.m_polygonVertexLayer.selectedVertex.attributes.index / 2;
            this.m_ringIndex = this.m_polygonVertexLayer.selectedVertex.attributes.ringIndex;
            var _loc_2:* = Polygon(this.m_graphic.geometry).rings;
            var _loc_3:* = _loc_2[this.m_ringIndex];
            if (this.m_pointIndex == 0)
            {
                _loc_3.splice(this.m_pointIndex, 1);
                _loc_3.splice((_loc_3.length - 1), 1);
                _loc_3.push(_loc_3[0]);
            }
            else
            {
                _loc_3.splice(this.m_pointIndex, 1);
            }
            Polygon(this.m_graphic.geometry).rings = _loc_2;
            this.m_graphic.refresh();
            this.calculateSegments(this.m_graphic);
            dispatchEvent(new EditEvent(EditEvent.VERTEX_DELETE, null, this.m_graphic, this.m_pointIndex, 0, this.m_ringIndex));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            this.m_polygonVertexLayer.load(Polygon(this.m_graphic.geometry));
            return;
        }// end function

        private function onContextMenuSelect(event:EditEvent) : void
        {
            dispatchEvent(new EditEvent(EditEvent.CONTEXT_MENU_SELECT, event.contextMenu, this.m_graphic, event.pointIndex / 2, event.pathIndex, event.ringIndex));
            return;
        }// end function

        private function onMultipointContextMenuSelect(event:ContextMenuEvent) : void
        {
            dispatchEvent(new EditEvent(EditEvent.CONTEXT_MENU_SELECT, event.target as ContextMenu, this.m_graphic, this.m_multipointVertexIndex));
            return;
        }// end function

        private function polylineScaleVertexMoveStartHandler(event:Event) : void
        {
            var _loc_2:Array = null;
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            this.m_scalingInProgress = true;
            this.m_scalePointInitialGeometry = this.m_scaleRotatePolylineLayer.movingVertexGeometry;
            this.m_scalePosition = this.m_scaleRotatePolylineLayer.selectedVertex.attributes.position;
            this.m_pathsDirectionArray = [];
            for each (_loc_2 in Polyline(this.m_graphic.geometry).paths)
            {
                
                this.m_pathsDirectionArray.push(GeomUtils.isClockwise(_loc_2));
            }
            this.m_scaleRotatePolyline = ObjectUtil.copy(this.m_graphic.geometry) as Polyline;
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_START, null, this.m_graphic));
            return;
        }// end function

        private function polylineScaleVertexMoveHandler(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:* = this.m_scaleRotatePolylineLayer.movingVertexGeometry.x - this.m_scalePointInitialGeometry.x;
            var _loc_3:* = this.m_scaleRotatePolylineLayer.movingVertexGeometry.y - this.m_scalePointInitialGeometry.y;
            switch(this.m_scalePosition)
            {
                case "bottomLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "leftMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "topLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "topMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "topRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "rightMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "bottomRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).x = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolyline.extent.xmax - this.m_scaleRotatePolyline.extent.xmin);
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                case "bottomMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polyline(this.m_graphic.geometry).paths.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polyline(this.m_graphic.geometry).paths[_loc_4].length)
                        {
                            
                            MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_4][_loc_5]).y = this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolyline.paths[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolylineLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolyline.extent.ymax - this.m_scaleRotatePolyline.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
                    this.m_graphic.refresh();
                    break;
                }
                default:
                {
                    break;
                }
            }
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE, null, this.m_graphic));
            return;
        }// end function

        private function polylineScaleVertexMoveStopHandler(event:Event) : void
        {
            var _loc_3:Array = null;
            if (this.m_moveActive)
            {
                this.m_graphic.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                this.m_graphic.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            }
            this.m_scalingInProgress = false;
            CursorManager.removeAllCursors();
            var _loc_2:int = 0;
            while (_loc_2 < Polyline(this.m_graphic.geometry).paths.length)
            {
                
                _loc_3 = Polyline(this.m_graphic.geometry).paths[_loc_2];
                if (GeomUtils.isClockwise(_loc_3) != this.m_pathsDirectionArray[_loc_2])
                {
                    _loc_3.reverse();
                }
                _loc_2 = _loc_2 + 1;
            }
            this.m_graphic.refresh();
            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
            this.m_scaleRotatePolylineLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_STOP, null, this.m_graphic));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function polylineRotateVertexMoveStartHandler(event:Event) : void
        {
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            this.m_rotationInProgress = true;
            this.m_rotatePointInitialGeometry = this.m_scaleRotatePolylineLayer.movingVertexGeometry;
            this.m_scaleRotatePolyline = ObjectUtil.copy(this.m_graphic.geometry) as Polyline;
            this.m_rotateAnchorPoint = new MapPoint((this.m_scaleRotatePolyline.extent.xmax + this.m_scaleRotatePolyline.extent.xmin) / 2, (this.m_scaleRotatePolyline.extent.ymax + this.m_scaleRotatePolyline.extent.ymin) / 2);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE_START, null, this.m_graphic));
            return;
        }// end function

        private function polylineRotateVertexMoveHandler(event:Event) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_6:Number = NaN;
            _loc_2 = Math.atan2(this.m_rotatePointInitialGeometry.y - this.m_rotateAnchorPoint.y, this.m_rotatePointInitialGeometry.x - this.m_rotateAnchorPoint.x);
            _loc_3 = Math.atan2(this.m_scaleRotatePolylineLayer.movingVertexGeometry.y - this.m_rotateAnchorPoint.y, this.m_scaleRotatePolylineLayer.movingVertexGeometry.x - this.m_rotateAnchorPoint.x);
            var _loc_4:* = _loc_3 - _loc_2;
            var _loc_5:Number = 0;
            while (_loc_5 < Polyline(this.m_graphic.geometry).paths.length)
            {
                
                _loc_6 = 0;
                while (_loc_6 < Polyline(this.m_graphic.geometry).paths[_loc_5].length)
                {
                    
                    MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_5][_loc_6]).x = this.m_rotateAnchorPoint.x + (this.m_scaleRotatePolyline.paths[_loc_5][_loc_6].x - this.m_rotateAnchorPoint.x) * Math.cos(_loc_4) - (this.m_scaleRotatePolyline.paths[_loc_5][_loc_6].y - this.m_rotateAnchorPoint.y) * Math.sin(_loc_4);
                    MapPoint(Polyline(this.m_graphic.geometry).paths[_loc_5][_loc_6]).y = this.m_rotateAnchorPoint.y + (this.m_scaleRotatePolyline.paths[_loc_5][_loc_6].x - this.m_rotateAnchorPoint.x) * Math.sin(_loc_4) + (this.m_scaleRotatePolyline.paths[_loc_5][_loc_6].y - this.m_rotateAnchorPoint.y) * Math.cos(_loc_4);
                    _loc_6 = _loc_6 + 1;
                }
                _loc_5 = _loc_5 + 1;
            }
            Polyline(this.m_graphic.geometry).paths = Polyline(this.m_graphic.geometry).paths;
            this.m_graphic.refresh();
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE, null, this.m_graphic));
            return;
        }// end function

        private function polylineRotateVertexMoveStopHandler(event:Event) : void
        {
            if (this.m_moveActive)
            {
                this.m_graphic.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                this.m_graphic.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            }
            this.m_rotationInProgress = false;
            CursorManager.removeAllCursors();
            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
            this.m_scaleRotatePolylineLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE_STOP, null, this.m_graphic));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function polygonScaleVertexMoveStartHandler(event:Event) : void
        {
            var _loc_2:Array = null;
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            this.m_scalingInProgress = true;
            this.m_scalePointInitialGeometry = this.m_scaleRotatePolygonLayer.movingVertexGeometry;
            this.m_scalePosition = this.m_scaleRotatePolygonLayer.selectedVertex.attributes.position;
            this.m_ringsDirectionArray = [];
            for each (_loc_2 in Polygon(this.m_graphic.geometry).rings)
            {
                
                this.m_ringsDirectionArray.push(GeomUtils.isClockwise(_loc_2));
            }
            this.m_scaleRotatePolygon = ObjectUtil.copy(this.m_graphic.geometry) as Polygon;
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_START, null, this.m_graphic));
            return;
        }// end function

        private function polygonScaleVertexMoveHandler(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:* = this.m_scaleRotatePolygonLayer.movingVertexGeometry.x - this.m_scalePointInitialGeometry.x;
            var _loc_3:* = this.m_scaleRotatePolygonLayer.movingVertexGeometry.y - this.m_scalePointInitialGeometry.y;
            switch(this.m_scalePosition)
            {
                case "bottomLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "leftMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "topLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "topMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "topRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y + _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "rightMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "bottomRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).x = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x + _loc_2 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].x - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotatePolygon.extent.xmax - this.m_scaleRotatePolygon.extent.xmin);
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                case "bottomMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < Polygon(this.m_graphic.geometry).rings.length)
                    {
                        
                        _loc_5 = 0;
                        while (_loc_5 < Polygon(this.m_graphic.geometry).rings[_loc_4].length)
                        {
                            
                            MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_4][_loc_5]).y = this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - _loc_3 * (this.m_scaleRotatePolygon.rings[_loc_4][_loc_5].y - MapPoint(this.m_scaleRotatePolygonLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotatePolygon.extent.ymax - this.m_scaleRotatePolygon.extent.ymin);
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
                    this.m_graphic.refresh();
                    break;
                }
                default:
                {
                    break;
                }
            }
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE, null, this.m_graphic));
            return;
        }// end function

        private function polygonScaleVertexMoveStopHandler(event:Event) : void
        {
            var _loc_3:Array = null;
            if (this.m_moveActive)
            {
                this.m_graphic.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                this.m_graphic.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            }
            this.m_scalingInProgress = false;
            CursorManager.removeAllCursors();
            var _loc_2:int = 0;
            while (_loc_2 < Polygon(this.m_graphic.geometry).rings.length)
            {
                
                _loc_3 = Polygon(this.m_graphic.geometry).rings[_loc_2];
                if (GeomUtils.isClockwise(_loc_3) != this.m_ringsDirectionArray[_loc_2])
                {
                    _loc_3.reverse();
                }
                _loc_2 = _loc_2 + 1;
            }
            this.m_graphic.refresh();
            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
            this.m_scaleRotatePolygonLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_STOP, null, this.m_graphic));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function polygonRotateVertexMoveStartHandler(event:Event) : void
        {
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            this.m_rotationInProgress = true;
            this.m_rotatePointInitialGeometry = this.m_scaleRotatePolygonLayer.movingVertexGeometry;
            this.m_scaleRotatePolygon = ObjectUtil.copy(this.m_graphic.geometry) as Polygon;
            this.m_rotateAnchorPoint = new MapPoint((this.m_scaleRotatePolygon.extent.xmax + this.m_scaleRotatePolygon.extent.xmin) / 2, (this.m_scaleRotatePolygon.extent.ymax + this.m_scaleRotatePolygon.extent.ymin) / 2);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE_START, null, this.m_graphic));
            return;
        }// end function

        private function polygonRotateVertexMoveHandler(event:Event) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_6:Number = NaN;
            _loc_2 = Math.atan2(this.m_rotatePointInitialGeometry.y - this.m_rotateAnchorPoint.y, this.m_rotatePointInitialGeometry.x - this.m_rotateAnchorPoint.x);
            _loc_3 = Math.atan2(this.m_scaleRotatePolygonLayer.movingVertexGeometry.y - this.m_rotateAnchorPoint.y, this.m_scaleRotatePolygonLayer.movingVertexGeometry.x - this.m_rotateAnchorPoint.x);
            var _loc_4:* = _loc_3 - _loc_2;
            var _loc_5:Number = 0;
            while (_loc_5 < Polygon(this.m_graphic.geometry).rings.length)
            {
                
                _loc_6 = 0;
                while (_loc_6 < Polygon(this.m_graphic.geometry).rings[_loc_5].length)
                {
                    
                    MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_5][_loc_6]).x = this.m_rotateAnchorPoint.x + (this.m_scaleRotatePolygon.rings[_loc_5][_loc_6].x - this.m_rotateAnchorPoint.x) * Math.cos(_loc_4) - (this.m_scaleRotatePolygon.rings[_loc_5][_loc_6].y - this.m_rotateAnchorPoint.y) * Math.sin(_loc_4);
                    MapPoint(Polygon(this.m_graphic.geometry).rings[_loc_5][_loc_6]).y = this.m_rotateAnchorPoint.y + (this.m_scaleRotatePolygon.rings[_loc_5][_loc_6].x - this.m_rotateAnchorPoint.x) * Math.sin(_loc_4) + (this.m_scaleRotatePolygon.rings[_loc_5][_loc_6].y - this.m_rotateAnchorPoint.y) * Math.cos(_loc_4);
                    _loc_6 = _loc_6 + 1;
                }
                _loc_5 = _loc_5 + 1;
            }
            Polygon(this.m_graphic.geometry).rings = Polygon(this.m_graphic.geometry).rings;
            this.m_graphic.refresh();
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE, null, this.m_graphic));
            return;
        }// end function

        private function polygonRotateVertexMoveStopHandler(event:Event) : void
        {
            if (this.m_moveActive)
            {
                this.m_graphic.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                this.m_graphic.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            }
            this.m_rotationInProgress = false;
            CursorManager.removeAllCursors();
            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(this.m_graphic.geometry.extent);
            this.m_scaleRotatePolygonLayer.load(this.m_graphic.geometry.extent, this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE_STOP, null, this.m_graphic));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function extentScaleVertexMoveStartHandler(event:Event) : void
        {
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
            this.m_graphic.removeEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            this.m_scalingInProgress = true;
            this.m_scalePointInitialGeometry = this.m_scaleRotateExtentLayer.movingVertexGeometry;
            this.m_scalePosition = this.m_scaleRotateExtentLayer.selectedVertex.attributes.position;
            this.m_scaleRotateExtent = Extent(this.m_graphic.geometry);
            this.m_arrayScaleRotateExtentPoints = [new MapPoint(this.m_scaleRotateExtent.xmin, this.m_scaleRotateExtent.ymin), new MapPoint(this.m_scaleRotateExtent.xmin, this.m_scaleRotateExtent.ymax), new MapPoint(this.m_scaleRotateExtent.xmax, this.m_scaleRotateExtent.ymax), new MapPoint(this.m_scaleRotateExtent.xmax, this.m_scaleRotateExtent.ymin)];
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_START, null, this.m_graphic));
            return;
        }// end function

        private function extentScaleVertexMoveHandler(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = this.m_scaleRotateExtentLayer.movingVertexGeometry.x - this.m_scalePointInitialGeometry.x;
            var _loc_3:* = this.m_scaleRotateExtentLayer.movingVertexGeometry.y - this.m_scalePointInitialGeometry.y;
            var _loc_5:* = new Extent();
            var _loc_6:* = new Array();
            switch(this.m_scalePosition)
            {
                case "bottomLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x - _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y - _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "leftMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x - _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y);
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "topLeft":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x - _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y + _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "topMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x);
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y + _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "topRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x + _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y + _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "rightMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x + _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y);
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "bottomRight":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x + _loc_2 * (this.m_arrayScaleRotateExtentPoints[_loc_4].x - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).x) / Math.abs(this.m_scaleRotateExtent.xmax - this.m_scaleRotateExtent.xmin));
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y - _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case "bottomMiddle":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.m_arrayScaleRotateExtentPoints.length)
                    {
                        
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].x);
                        _loc_6.push(this.m_arrayScaleRotateExtentPoints[_loc_4].y - _loc_3 * (this.m_arrayScaleRotateExtentPoints[_loc_4].y - MapPoint(this.m_scaleRotateExtentLayer.anchorVertex.geometry).y) / Math.abs(this.m_scaleRotateExtent.ymax - this.m_scaleRotateExtent.ymin));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_6[4] > _loc_6[0])
            {
                _loc_5.xmin = _loc_6[0];
                _loc_5.xmax = _loc_6[4];
            }
            else
            {
                _loc_5.xmin = _loc_6[4];
                _loc_5.xmax = _loc_6[0];
            }
            if (_loc_6[5] > _loc_6[1])
            {
                _loc_5.ymin = _loc_6[1];
                _loc_5.ymax = _loc_6[5];
            }
            else
            {
                _loc_5.ymin = _loc_6[5];
                _loc_5.ymax = _loc_6[1];
            }
            _loc_5.spatialReference = this.m_graphic.geometry.spatialReference;
            this.m_graphic.geometry = _loc_5;
            this.m_graphic.refresh();
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE, null, this.m_graphic));
            return;
        }// end function

        private function extentScaleVertexMoveStopHandler(event:Event) : void
        {
            if (this.m_moveActive)
            {
                this.m_graphic.addEventListener(MouseEvent.ROLL_OVER, this.graphicRollOverHandler);
                this.m_graphic.addEventListener(MouseEvent.ROLL_OUT, this.graphicRollOutHandler);
            }
            this.m_scalingInProgress = false;
            CursorManager.removeAllCursors();
            this.m_scaleRotateTempExtentGraphic.geometry = this.extentToPolyline(Extent(this.m_graphic.geometry));
            this.m_scaleRotateExtentLayer.load(Extent(this.m_graphic.geometry), this.m_scaleActive, this.m_rotateActive, this.m_scaleRotateActive);
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_STOP, null, this.m_graphic));
            dispatchEvent(new EditEvent(EditEvent.GEOMETRY_UPDATE, null, null, 0, 0, 0, [this.m_graphic]));
            return;
        }// end function

        private function scaleVertexMouseOverHandler(event:Event) : void
        {
            switch(ScaleRotateLayer(event.currentTarget).selectedVertex.attributes.position)
            {
                case "bottomLeft":
                case "topRight":
                {
                    CursorManager.setCursor(this.bottomLeftTopRightScaleCursor, CursorManagerPriority.HIGH, -16, -16);
                    break;
                }
                case "topLeft":
                case "bottomRight":
                {
                    CursorManager.setCursor(this.topLeftBottomRightScaleCursor, CursorManagerPriority.HIGH, -16, -16);
                    break;
                }
                case "leftMiddle":
                case "rightMiddle":
                {
                    CursorManager.setCursor(this.leftRightScaleCursor, CursorManagerPriority.HIGH, -16, -16);
                    break;
                }
                case "topMiddle":
                case "bottomMiddle":
                {
                    CursorManager.setCursor(this.topBottomScaleCursor, CursorManagerPriority.HIGH, -16, -16);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function scaleVertexMouseOutHandler(event:Event) : void
        {
            if (!this.m_scalingInProgress)
            {
                CursorManager.removeAllCursors();
            }
            return;
        }// end function

        private function rotateVertexMouseOverHandler(event:Event) : void
        {
            CursorManager.setCursor(this.rotateCursor, CursorManagerPriority.HIGH, -16, -16);
            return;
        }// end function

        private function rotateVertexMouseOutHandler(event:Event) : void
        {
            if (!this.m_rotationInProgress)
            {
                CursorManager.removeAllCursors();
            }
            return;
        }// end function

        private function polylinePolygonScaleVertexMoveFirstHandler(event:Event) : void
        {
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_SCALE_FIRST, null, this.m_graphic));
            return;
        }// end function

        private function polylinePolygonRotateVertexMoveFirstHandler(event:Event) : void
        {
            dispatchEvent(new EditEvent(EditEvent.GRAPHIC_ROTATE_FIRST, null, this.m_graphic));
            return;
        }// end function

        private function extentToPolyline(extent:Extent) : Polyline
        {
            var _loc_2:Array = [new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmax, extent.ymax), new MapPoint(extent.xmax, extent.ymin), new MapPoint(extent.xmin, extent.ymin)];
            var _loc_3:* = new Polyline();
            _loc_3.addPath(_loc_2);
            return _loc_3;
        }// end function

        private function checkForSnapping(selectedVertex:Graphic, isMovingPoint:Boolean = false, initialMouseDownPoint:MapPoint = null, mouseMovePoint:MapPoint = null, mouseMoveFrameId:Number = 0) : void
        {
            var _loc_6:Extent = null;
            var _loc_7:Point = null;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
            var _loc_10:int = 0;
            var _loc_11:Array = null;
            var _loc_12:int = 0;
            var _loc_13:Array = null;
            var _loc_14:int = 0;
            var _loc_15:Array = null;
            var _loc_16:int = 0;
            var _loc_17:Array = null;
            var _loc_18:int = 0;
            var _loc_19:Boolean = false;
            var _loc_20:Array = null;
            var _loc_21:Array = null;
            var _loc_22:int = 0;
            var _loc_23:Object = null;
            var _loc_24:Extent = null;
            var _loc_25:Graphic = null;
            var _loc_26:MapPoint = null;
            var _loc_27:Multipoint = null;
            var _loc_28:MapPoint = null;
            var _loc_29:MapPoint = null;
            var _loc_30:Polyline = null;
            var _loc_31:Array = null;
            var _loc_32:MapPoint = null;
            var _loc_33:MapPoint = null;
            var _loc_34:Array = null;
            var _loc_35:MapPoint = null;
            var _loc_36:Polygon = null;
            var _loc_37:Array = null;
            var _loc_38:MapPoint = null;
            var _loc_39:MapPoint = null;
            var _loc_40:Array = null;
            var _loc_41:MapPoint = null;
            var _loc_42:Extent = null;
            var _loc_43:Array = null;
            var _loc_44:MapPoint = null;
            var _loc_45:MapPoint = null;
            var _loc_46:Array = null;
            var _loc_47:MapPoint = null;
            var _loc_48:Number = NaN;
            var _loc_49:MapPoint = null;
            var _loc_50:MapPoint = null;
            if (this.snapping)
            {
                if (!this.m_snapGraphic)
                {
                    this.m_snapGraphic = new Graphic();
                    this.m_snapGraphic.symbol = this.m_snapGraphicSymbol;
                    this.m_snapGraphic.geometry = selectedVertex.geometry;
                    this.map.defaultGraphicsLayer.add(this.m_snapGraphic);
                }
                else
                {
                    this.m_snapGraphic.visible = true;
                    this.m_snapGraphic.symbol = this.m_snapGraphicSymbol;
                    this.m_snapGraphic.geometry = selectedVertex.geometry;
                    this.m_snapGraphic.refresh();
                }
                _loc_6 = new Extent();
                if (this.map.wrapAround180)
                {
                    _loc_23 = this.map.extent.normalize(false, true);
                    if (_loc_23 is Extent)
                    {
                        _loc_6 = _loc_23 as Extent;
                    }
                    else if (_loc_23 is Array)
                    {
                        for each (_loc_24 in _loc_23)
                        {
                            
                            _loc_6 = _loc_6.union(_loc_24);
                        }
                    }
                }
                else
                {
                    _loc_6 = this.map.extent;
                }
                _loc_7 = this.map.toScreen(mouseMovePoint);
                _loc_8 = [];
                _loc_9 = [];
                _loc_10 = 0;
                while (_loc_10 < this.m_mapLayers.length)
                {
                    
                    if (this.m_mapLayers.getItemAt(_loc_10) is GraphicsLayer)
                    {
                        for each (_loc_25 in GraphicsLayer(this.m_mapLayers.getItemAt(_loc_10)).graphicProvider)
                        {
                            
                            if (_loc_25 !== this.m_graphic)
                            {
                            }
                            if (_loc_25.geometry)
                            {
                                switch(_loc_25.geometry.type)
                                {
                                    case Geometry.MAPPOINT:
                                    {
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            _loc_26 = this.map.wrapAround180 ? (MapPoint(_loc_25.geometry).normalize()) : (MapPoint(_loc_25.geometry));
                                            if (_loc_6.containsXY(_loc_26.x, _loc_26.y))
                                            {
                                                _loc_8.push(_loc_26);
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.MULTIPOINT:
                                    {
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            _loc_27 = _loc_25.geometry as Multipoint;
                                            for each (_loc_28 in Multipoint(_loc_25.geometry).points)
                                            {
                                                
                                                _loc_29 = this.map.wrapAround180 ? (_loc_28.normalize()) : (_loc_28);
                                                if (_loc_6.containsXY(_loc_29.x, _loc_29.y))
                                                {
                                                    _loc_8.push(_loc_29);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.POLYLINE:
                                    {
                                        _loc_30 = _loc_25.geometry as Polyline;
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_31 in _loc_30.paths)
                                            {
                                                
                                                for each (_loc_32 in _loc_31)
                                                {
                                                    
                                                    _loc_33 = this.map.wrapAround180 ? (_loc_32.normalize()) : (_loc_32);
                                                    if (_loc_6.containsXY(_loc_33.x, _loc_33.y))
                                                    {
                                                        _loc_8.push(_loc_33);
                                                    }
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_34 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(_loc_30), _loc_7);
                                            for each (_loc_35 in _loc_34)
                                            {
                                                
                                                if (_loc_6.containsXY(_loc_35.x, _loc_35.y))
                                                {
                                                    _loc_9.push(_loc_35);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.POLYGON:
                                    {
                                        _loc_36 = _loc_25.geometry as Polygon;
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_37 in _loc_36.rings)
                                            {
                                                
                                                for each (_loc_38 in _loc_37)
                                                {
                                                    
                                                    _loc_39 = this.map.wrapAround180 ? (_loc_38.normalize()) : (_loc_38);
                                                    if (_loc_6.containsXY(_loc_39.x, _loc_39.y))
                                                    {
                                                        _loc_8.push(_loc_39);
                                                    }
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_40 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(_loc_36), _loc_7);
                                            for each (_loc_41 in _loc_40)
                                            {
                                                
                                                if (_loc_6.containsXY(_loc_41.x, _loc_41.y))
                                                {
                                                    _loc_9.push(_loc_41);
                                                }
                                            }
                                        }
                                        break;
                                    }
                                    case Geometry.EXTENT:
                                    {
                                        _loc_42 = _loc_25.geometry as Extent;
                                        _loc_43 = [new MapPoint(_loc_42.xmin, _loc_42.ymin), new MapPoint(_loc_42.xmin, _loc_42.ymax), new MapPoint(_loc_42.xmax, _loc_42.ymax), new MapPoint(_loc_42.xmax, _loc_42.ymin)];
                                        if (this.m_snapOption != SNAP_OPTION_EDGE)
                                        {
                                            for each (_loc_44 in _loc_43)
                                            {
                                                
                                                _loc_45 = this.map.wrapAround180 ? (_loc_44.normalize()) : (_loc_44);
                                                if (_loc_6.containsXY(_loc_45.x, _loc_45.y))
                                                {
                                                    _loc_8.push(_loc_45);
                                                }
                                            }
                                        }
                                        if (this.m_snapOption != SNAP_OPTION_VERTEX)
                                        {
                                            _loc_46 = this.getPointsOnEdges(this.getEdgesForPolylinePolygon(this.extentToPolyline(_loc_42)), _loc_7);
                                            for each (_loc_47 in _loc_46)
                                            {
                                                
                                                if (_loc_6.containsXY(_loc_47.x, _loc_47.y))
                                                {
                                                    _loc_9.push(_loc_47);
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
                    _loc_10 = _loc_10 + 1;
                }
                _loc_11 = [];
                _loc_12 = 0;
                while (_loc_12 < _loc_8.length)
                {
                    
                    _loc_11.push(Math.pow(this.map.toScreenX(_loc_8[_loc_12].x) - _loc_7.x, 2) + Math.pow(this.map.toScreenY(_loc_8[_loc_12].y) - _loc_7.y, 2));
                    _loc_12 = _loc_12 + 1;
                }
                _loc_13 = _loc_11.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
                _loc_14 = _loc_13[0];
                _loc_15 = [];
                _loc_16 = 0;
                while (_loc_16 < _loc_9.length)
                {
                    
                    _loc_15.push(Math.pow(this.map.toScreenX(_loc_9[_loc_16].x) - _loc_7.x, 2) + Math.pow(this.map.toScreenY(_loc_9[_loc_16].y) - _loc_7.y, 2));
                    _loc_16 = _loc_16 + 1;
                }
                _loc_17 = _loc_15.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
                _loc_18 = _loc_17[0];
                if (_loc_11.length > 0)
                {
                }
                if (_loc_15.length > 0)
                {
                    _loc_19 = _loc_11[_loc_14] < _loc_15[_loc_18] ? (true) : (false);
                }
                else
                {
                    if (_loc_11.length > 0)
                    {
                    }
                    if (_loc_15.length == 0)
                    {
                        _loc_19 = true;
                    }
                    else
                    {
                        if (_loc_15.length > 0)
                        {
                        }
                        if (_loc_11.length == 0)
                        {
                            _loc_19 = false;
                        }
                    }
                }
                _loc_20 = [];
                _loc_21 = [];
                if (_loc_19)
                {
                    _loc_20 = _loc_11;
                    _loc_22 = _loc_14;
                    _loc_21 = _loc_8;
                }
                else
                {
                    _loc_20 = _loc_15;
                    _loc_22 = _loc_18;
                    _loc_21 = _loc_9;
                }
                if (_loc_20.length > 0)
                {
                }
                if (Math.sqrt(_loc_20[_loc_22]) < this.m_snapDistance)
                {
                    if (this.map.wrapAround180)
                    {
                    }
                    _loc_48 = this.map.extent.spatialReference.info ? (this.map.extent.spatialReference.info.world * (mouseMoveFrameId - this.m_initialMouseDownFrameId)) : (0);
                    _loc_49 = _loc_21[_loc_22];
                    _loc_50 = new MapPoint(_loc_49.x + _loc_48, _loc_49.y, _loc_49.spatialReference);
                    _loc_50.z = _loc_49.z;
                    _loc_50.m = _loc_49.m;
                    if (initialMouseDownPoint)
                    {
                        initialMouseDownPoint.x = initialMouseDownPoint.x + (_loc_50.x - MapPoint(selectedVertex.geometry).x);
                        initialMouseDownPoint.y = initialMouseDownPoint.y + (_loc_50.y - MapPoint(selectedVertex.geometry).y);
                    }
                    selectedVertex.geometry = _loc_50;
                    if (!isMovingPoint)
                    {
                        selectedVertex.symbol = this.m_snapOption == SNAP_OPTION_EDGE_AND_VERTEX ? (_loc_19 ? (this.m_snapGraphicVertexSymbol) : (this.m_snapGraphicEdgeSymbol)) : (this.m_snapGraphicEdgeSymbol);
                    }
                    this.m_snapGraphic.geometry = _loc_50;
                }
                else if (!isMovingPoint)
                {
                    selectedVertex.symbol = this.vertexSymbol;
                }
            }
            else if (this.m_snapGraphic)
            {
                this.m_snapGraphic.visible = false;
                if (!isMovingPoint)
                {
                    selectedVertex.symbol = this.vertexSymbol;
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

        private function updateMouseDownFrameId(initialMouseDownVertexPoint:MapPoint, initialMouseDownPoint:MapPoint) : void
        {
            var _loc_3:Array = [];
            var _loc_4:* = this.map.extent.spatialReference.info.world;
            var _loc_5:* = Math.floor(this.map.extent.xmin / _loc_4) * _loc_4 + (_loc_4 - this.map.extent.spatialReference.info.valid[1]);
            while (_loc_5 < this.map.extent.xmax)
            {
                
                _loc_3.push(_loc_5);
                _loc_5 = _loc_5 + _loc_4;
            }
            var _loc_6:Array = [];
            var _loc_7:int = 0;
            while (_loc_7 < _loc_3.length)
            {
                
                _loc_6.push(Math.abs(initialMouseDownPoint.x - _loc_3[_loc_7]));
                _loc_7 = _loc_7 + 1;
            }
            var _loc_8:* = _loc_6.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
            var _loc_9:* = _loc_8[0];
            var _loc_10:* = _loc_3[_loc_9];
            if (initialMouseDownVertexPoint.x == this.map.extent.spatialReference.info.valid[0])
            {
            }
            if (initialMouseDownPoint.x < _loc_10)
            {
                var _loc_11:String = this;
                var _loc_12:* = this.m_initialMouseDownFrameId + 1;
                _loc_11.m_initialMouseDownFrameId = _loc_12;
            }
            else
            {
                if (initialMouseDownVertexPoint.x == this.map.extent.spatialReference.info.valid[1])
                {
                }
                if (initialMouseDownPoint.x > _loc_10)
                {
                    var _loc_11:String = this;
                    var _loc_12:* = this.m_initialMouseDownFrameId - 1;
                    _loc_11.m_initialMouseDownFrameId = _loc_12;
                }
            }
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

        public function set allowAddVertices(value:Boolean) : void
        {
            arguments = this.allowAddVertices;
            if (arguments !== value)
            {
                this._1541300401allowAddVertices = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "allowAddVertices", arguments, value));
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

        public function set vertexSymbol(value:Symbol) : void
        {
            arguments = this.vertexSymbol;
            if (arguments !== value)
            {
                this._1642837924vertexSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "vertexSymbol", arguments, value));
                }
            }
            return;
        }// end function

        public function set ghostVertexSymbol(value:Symbol) : void
        {
            arguments = this.ghostVertexSymbol;
            if (arguments !== value)
            {
                this._1067296907ghostVertexSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ghostVertexSymbol", arguments, value));
                }
            }
            return;
        }// end function

        public function set allowDeleteVertices(value:Boolean) : void
        {
            arguments = this.allowDeleteVertices;
            if (arguments !== value)
            {
                this._1235677805allowDeleteVertices = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "allowDeleteVertices", arguments, value));
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

    }
}
