package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;
    import spark.components.supportClasses.*;

    public class InfoComponent extends SkinnableComponent implements IDataRenderer
    {
        protected var m_map:Map;
        public var contentGroup:Group;
        private var m_data:Object;
        private var m_dataChanged:Boolean = false;
        private var m_anchorX:Number;
        private var m_anchorY:Number;
        private var m_anchorChanged:Boolean = false;
        static const BORDER_PLACEMENT:String = "borderPlacement";
        static const BORDER_THICKNESS:String = "borderThickness";
        static const BORDER_COLOR:String = "borderColor";
        static const BORDER_ALPHA:String = "borderAlpha";
        static const INFO_PLACEMENT_MODE:String = "infoPlacementMode";
        static const INFO_PLACEMENT:String = "infoPlacement";
        static const INFO_OFFSET_X:String = "infoOffsetX";
        static const INFO_OFFSET_Y:String = "infoOffsetY";
        static const INFO_OFFSET_W:String = "infoOffsetW";
        static const UPPER_LEFT_RADIUS:String = "upperLeftRadius";
        static const LOWER_LEFT_RADIUS:String = "lowerLeftRadius";
        static const UPPER_RIGHT_RADIUS:String = "upperRightRadius";
        static const LOWER_RIGHT_RADIUS:String = "lowerRightRadius";
        private static var _skinParts:Object = {contentGroup:false};

        public function InfoComponent(map:Map)
        {
            this.m_map = map;
            addEventListener(KeyboardEvent.KEY_DOWN, this.stopEventPropagation);
            addEventListener(KeyboardEvent.KEY_UP, this.stopEventPropagation);
            addEventListener(MouseEvent.CLICK, this.stopEventPropagation);
            addEventListener(MouseEvent.DOUBLE_CLICK, this.stopEventPropagation);
            addEventListener(MouseEvent.MOUSE_DOWN, this.stopEventPropagation);
            addEventListener(MouseEvent.MOUSE_WHEEL, this.stopEventPropagation);
            addEventListener(ChildExistenceChangedEvent.CHILD_ADD, this.childAddHandler);
            addEventListener(InfoPlacementEvent.INFO_PLACEMENT, this.infoPlacementHandler);
            return;
        }// end function

        public function get data() : Object
        {
            return this.m_data;
        }// end function

        public function set data(value:Object) : void
        {
            if (this.m_data != value)
            {
                this.m_data = value;
                this.m_dataChanged = true;
                invalidateProperties();
                dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            }
            return;
        }// end function

        private function infoPlacementHandler(event:InfoPlacementEvent) : void
        {
            setStyle(INFO_PLACEMENT, event.infoPlacement);
            return;
        }// end function

        public function get map() : Map
        {
            return this.m_map;
        }// end function

        private function stopEventPropagation(event:Event) : void
        {
            event.stopPropagation();
            return;
        }// end function

        private function childAddHandler(event:ChildExistenceChangedEvent) : void
        {
            if (this.data)
            {
            }
            if (event.relatedObject is IDataRenderer)
            {
                IDataRenderer(event.relatedObject).data = this.data;
            }
            return;
        }// end function

        public function get anchorX() : Number
        {
            return this.m_anchorX;
        }// end function

        private function set _862612413anchorX(value:Number) : void
        {
            if (this.m_anchorX !== value)
            {
                this.m_anchorX = value;
                this.m_anchorChanged = true;
                invalidateProperties();
                if (skin)
                {
                    skin.invalidateDisplayList();
                }
            }
            return;
        }// end function

        public function get anchorY() : Number
        {
            return this.m_anchorY;
        }// end function

        private function set _862612412anchorY(value:Number) : void
        {
            if (this.m_anchorY !== value)
            {
                this.m_anchorY = value;
                this.m_anchorChanged = true;
                invalidateProperties();
                if (skin)
                {
                    skin.invalidateDisplayList();
                }
            }
            return;
        }// end function

        override public function styleChanged(styleProp:String) : void
        {
            super.styleChanged(styleProp);
            switch(styleProp)
            {
                case INFO_OFFSET_X:
                case INFO_OFFSET_Y:
                case INFO_OFFSET_W:
                case INFO_PLACEMENT:
                case UPPER_LEFT_RADIUS:
                case UPPER_RIGHT_RADIUS:
                case LOWER_LEFT_RADIUS:
                case LOWER_RIGHT_RADIUS:
                case BORDER_THICKNESS:
                {
                    invalidateSize();
                }
                case BORDER_COLOR:
                case BORDER_ALPHA:
                {
                    invalidateDisplayList();
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:IDataRenderer = null;
            super.commitProperties();
            if (this.m_dataChanged)
            {
                this.m_dataChanged = false;
                if (this.contentGroup)
                {
                    _loc_1 = this.contentGroup.numElements;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_3 = this.contentGroup.getElementAt(_loc_2) as IDataRenderer;
                        if (_loc_3)
                        {
                            _loc_3.data = this.m_data;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                }
            }
            if (this.m_anchorChanged)
            {
                this.m_anchorChanged = false;
                move(this.anchorX, this.anchorY);
            }
            return;
        }// end function

        public function set anchorY(value:Number) : void
        {
            arguments = this.anchorY;
            if (arguments !== value)
            {
                this._862612412anchorY = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "anchorY", arguments, value));
                }
            }
            return;
        }// end function

        public function set anchorX(value:Number) : void
        {
            arguments = this.anchorX;
            if (arguments !== value)
            {
                this._862612413anchorX = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "anchorX", arguments, value));
                }
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
