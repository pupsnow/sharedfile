package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;
    import mx.events.*;

    public class FeatureTemplate extends EventDispatcher
    {
        private var _1724546052description:String;
        private var _577056042drawingTool:String;
        private var _3373707name:String;
        private var _598792926prototype:Graphic;
        public static const TOOL_AUTO_COMPLETE_FREEHAND_POLYGON:String = "esriFeatureEditToolAutoCompleteFreehand";
        public static const TOOL_AUTO_COMPLETE_POLYGON:String = "esriFeatureEditToolAutoCompletePolygon";
        public static const TOOL_CIRCLE:String = "esriFeatureEditToolCircle";
        public static const TOOL_ELLIPSE:String = "esriFeatureEditToolEllipse";
        public static const TOOL_FREEHAND:String = "esriFeatureEditToolFreehand";
        public static const TOOL_LINE:String = "esriFeatureEditToolLine";
        public static const TOOL_NONE:String = "esriFeatureEditToolNone";
        public static const TOOL_POINT:String = "esriFeatureEditToolPoint";
        public static const TOOL_POLYGON:String = "esriFeatureEditToolPolygon";
        public static const TOOL_RECTANGLE:String = "esriFeatureEditToolRectangle";

        public function FeatureTemplate()
        {
            return;
        }// end function

        public function get description() : String
        {
            return this._1724546052description;
        }// end function

        public function set description(value:String) : void
        {
            arguments = this._1724546052description;
            if (arguments !== value)
            {
                this._1724546052description = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", arguments, value));
                }
            }
            return;
        }// end function

        public function get drawingTool() : String
        {
            return this._577056042drawingTool;
        }// end function

        public function set drawingTool(value:String) : void
        {
            arguments = this._577056042drawingTool;
            if (arguments !== value)
            {
                this._577056042drawingTool = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "drawingTool", arguments, value));
                }
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._3373707name;
        }// end function

        public function set name(value:String) : void
        {
            arguments = this._3373707name;
            if (arguments !== value)
            {
                this._3373707name = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", arguments, value));
                }
            }
            return;
        }// end function

        public function get prototype() : Graphic
        {
            return this._598792926prototype;
        }// end function

        public function set prototype(value:Graphic) : void
        {
            arguments = this._598792926prototype;
            if (arguments !== value)
            {
                this._598792926prototype = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "prototype", arguments, value));
                }
            }
            return;
        }// end function

        static function toFeatureTemplate(obj:Object) : FeatureTemplate
        {
            var _loc_2:FeatureTemplate = null;
            if (obj)
            {
                _loc_2 = new FeatureTemplate;
                _loc_2.description = obj.description;
                _loc_2.drawingTool = obj.drawingTool;
                _loc_2.name = obj.name;
                if (obj.prototype)
                {
                    _loc_2.prototype = new Graphic();
                    _loc_2.prototype.attributes = obj.prototype.attributes;
                }
            }
            return _loc_2;
        }// end function

    }
}
