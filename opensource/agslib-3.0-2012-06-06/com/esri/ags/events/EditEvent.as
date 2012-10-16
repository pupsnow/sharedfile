package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;
    import flash.ui.*;

    public class EditEvent extends Event
    {
        public var contextMenu:ContextMenu;
        public var graphic:Graphic;
        public var graphics:Array;
        public var pointIndex:int;
        public var pathIndex:int;
        public var ringIndex:int;
        public static const TOOL_ACTIVATE:String = "toolActivate";
        public static const CONTEXT_MENU_SELECT:String = "contextMenuSelect";
        public static const TOOL_DEACTIVATE:String = "toolDeactivate";
        public static const GEOMETRY_UPDATE:String = "geometryUpdate";
        public static const GHOST_VERTEX_MOUSE_DOWN:String = "ghostVertexMouseDown";
        public static const GRAPHICS_MOVE_START:String = "graphicsMoveStart";
        public static const GRAPHICS_MOVE_FIRST:String = "graphicsMoveFirst";
        public static const GRAPHICS_MOVE:String = "graphicsMove";
        public static const GRAPHICS_MOVE_STOP:String = "graphicsMoveStop";
        public static const GRAPHIC_ROTATE_START:String = "graphicRotateStart";
        public static const GRAPHIC_ROTATE_FIRST:String = "graphicRotateFirst";
        public static const GRAPHIC_ROTATE:String = "graphicRotate";
        public static const GRAPHIC_ROTATE_STOP:String = "graphicRotateStop";
        public static const GRAPHIC_SCALE_START:String = "graphicScaleStart";
        public static const GRAPHIC_SCALE_FIRST:String = "graphicScaleFirst";
        public static const GRAPHIC_SCALE:String = "graphicScale";
        public static const GRAPHIC_SCALE_STOP:String = "graphicScaleStop";
        public static const VERTEX_ADD:String = "vertexAdd";
        public static const VERTEX_DELETE:String = "vertexDelete";
        public static const VERTEX_MOUSE_OVER:String = "vertexMouseOver";
        public static const VERTEX_MOUSE_OUT:String = "vertexMouseOut";
        public static const VERTEX_MOVE_START:String = "vertexMoveStart";
        public static const VERTEX_MOVE_FIRST:String = "vertexMoveFirst";
        public static const VERTEX_MOVE:String = "vertexMove";
        public static const VERTEX_MOVE_STOP:String = "vertexMoveStop";

        public function EditEvent(type:String, contextMenu:ContextMenu = null, graphic:Graphic = null, pointIndex:int = 0, pathIndex:int = 0, ringIndex:int = 0, graphics:Array = null)
        {
            super(type);
            this.contextMenu = contextMenu;
            this.graphic = graphic;
            this.pointIndex = pointIndex;
            this.pathIndex = pathIndex;
            this.ringIndex = ringIndex;
            this.graphics = graphics;
            return;
        }// end function

        override public function clone() : Event
        {
            return new EditEvent(type, this.contextMenu, this.graphic, this.pointIndex, this.pathIndex, this.ringIndex, this.graphics);
        }// end function

        override public function toString() : String
        {
            return formatToString("EditEvent", "type", "contextMenu", "graphic", "pointIndex", "pathIndex", "ringIndex", "graphics");
        }// end function

    }
}
