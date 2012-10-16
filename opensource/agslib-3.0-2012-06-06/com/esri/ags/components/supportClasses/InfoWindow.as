package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.supportClasses.*;

    public class InfoWindow extends InfoComponent
    {
        private var m_contentChanged:Boolean = false;
        private var m_labelVisible:Boolean = true;
        private var m_closeButtonVisible:Boolean = true;
        private var m_infoWindowHeaderVisible:Boolean = true;
        private var m_content:UIComponent;
        public var labelText:TextBase;
        public var closeButton:ButtonBase;
        public var contentOwner:Object;
        private var m_label:String;
        private var m_labelChanged:Boolean = false;
        private var m_mapPointX:Number;
        private var m_mapPointY:Number;
        private var m_mapPoint:MapPoint;
        private var m_anchorX:Number;
        private var m_anchorY:Number;
        private static var _skinParts:Object = {labelText:false, contentGroup:false, closeButton:false};

        public function InfoWindow(map:Map)
        {
            super(map);
            var _loc_2:Boolean = false;
            visible = false;
            includeInLayout = _loc_2;
            addEventListener("infoWindowLabelChanged", this.labelChangedHandler);
            return;
        }// end function

        public function get label() : String
        {
            return this.m_label;
        }// end function

        private function set _102727412label(value:String) : void
        {
            if (this.m_label !== value)
            {
                this.m_label = value;
                this.m_labelChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get content() : UIComponent
        {
            return this.m_content;
        }// end function

        public function set content(value:UIComponent) : void
        {
            var _loc_2:IInfoWindowContent = null;
            if (this.m_content !== value)
            {
                if (this.m_content)
                {
                    this.m_content.removeEventListener(Event.CLOSE, this.infoWindowContent_closeHandler);
                }
                _loc_2 = value as IInfoWindowContent;
                if (_loc_2)
                {
                }
                if (_loc_2.showInfoWindowHeader === false)
                {
                    this.m_infoWindowHeaderVisible = false;
                    value.addEventListener(Event.CLOSE, this.infoWindowContent_closeHandler);
                }
                else
                {
                    this.m_infoWindowHeaderVisible = true;
                }
                this.m_content = value;
                this.m_contentChanged = true;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
                invalidateSkinState();
                dispatchEvent(new Event("contentChange"));
            }
            return;
        }// end function

        private function infoWindowContent_closeHandler(event:Event) : void
        {
            this.hide2(false);
            return;
        }// end function

        public function get labelVisible() : Boolean
        {
            return this.m_labelVisible;
        }// end function

        public function set labelVisible(value:Boolean) : void
        {
            this.m_labelVisible = value;
            invalidateProperties();
            invalidateSkinState();
            return;
        }// end function

        public function get closeButtonVisible() : Boolean
        {
            return this.m_closeButtonVisible;
        }// end function

        public function set closeButtonVisible(value:Boolean) : void
        {
            this.m_closeButtonVisible = value;
            invalidateProperties();
            invalidateSkinState();
            return;
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.closeButton)
            {
                this.closeButton.addEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
            }
            else
            {
                if (instance === contentGroup)
                {
                }
                if (this.m_contentChanged)
                {
                    this.m_contentChanged = false;
                    if (this.m_content)
                    {
                        contentGroup.addElement(this.m_content);
                    }
                }
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.closeButton)
            {
                this.closeButton.removeEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
            }
            return;
        }// end function

        private function closeButton_clickHandler(event:Event) : void
        {
            if (event.target === this.closeButton)
            {
                this.hide();
            }
            return;
        }// end function

        private function labelChangedHandler(event:Event) : void
        {
            invalidateProperties();
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (this.m_infoWindowHeaderVisible === false)
            {
                return "withoutHeader";
            }
            if (!this.m_labelVisible)
            {
            }
            return this.m_closeButtonVisible ? ("withHeader") : ("withoutHeader");
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:IDataRenderer = null;
            super.commitProperties();
            if (this.m_contentChanged)
            {
            }
            if (contentGroup)
            {
                this.m_contentChanged = false;
                while (contentGroup.numElements)
                {
                    
                    contentGroup.removeElementAt(0);
                }
                if (this.m_content)
                {
                    _loc_1 = this.m_content as IDataRenderer;
                    if (data)
                    {
                    }
                    if (_loc_1)
                    {
                    }
                    if (_loc_1.data === null)
                    {
                        _loc_1.data = data;
                    }
                    contentGroup.addElement(this.m_content);
                }
            }
            if (this.labelText)
            {
                if (this.m_labelChanged)
                {
                    this.m_labelChanged = false;
                    this.labelText.text = this.m_label;
                }
                if (this.m_label === null)
                {
                    if (this.m_content)
                    {
                    }
                    if (this.m_content.hasOwnProperty("label"))
                    {
                        this.labelText.text = this.m_content["label"];
                    }
                    else
                    {
                        if (this.m_content)
                        {
                        }
                        if (this.m_content.hasOwnProperty("infoWindowLabel"))
                        {
                            this.labelText.text = this.m_content["infoWindowLabel"];
                        }
                        else if (this.labelText.text)
                        {
                            this.labelText.text = "";
                        }
                    }
                }
                var _loc_2:* = this.labelVisible;
                this.labelText.includeInLayout = this.labelVisible;
                this.labelText.visible = _loc_2;
            }
            if (this.closeButton)
            {
                var _loc_2:* = this.closeButtonVisible;
                this.closeButton.includeInLayout = this.closeButtonVisible;
                this.closeButton.visible = _loc_2;
            }
            return;
        }// end function

        public function show(mapPoint:MapPoint, stagePoint:Point = null) : void
        {
            includeInLayout = true;
            this.m_mapPoint = mapPoint;
            if (map.wrapAround180)
            {
                this.getDenormalizedPoint(stagePoint);
            }
            else
            {
                this.m_mapPointX = mapPoint.x;
                this.m_mapPointY = mapPoint.y;
            }
            if (!m_map.isTweening)
            {
            }
            if (m_map.extentChanged)
            {
                m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
                m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            }
            else
            {
                this.showXY(m_map.toScreenX(this.m_mapPointX), m_map.toScreenY(this.m_mapPointY));
            }
            return;
        }// end function

        private function extentChangeHandler(event:ExtentEvent) : void
        {
            m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            if (m_map.wrapAround180)
            {
                this.getDenormalizedPoint();
            }
            this.showXY(m_map.toScreenX(this.m_mapPointX), m_map.toScreenY(this.m_mapPointY));
            return;
        }// end function

        private function getDenormalizedPoint(stagePoint:Point = null) : void
        {
            var _loc_2:MapPoint = null;
            if (includeInLayout)
            {
                _loc_2 = GeomUtils.denormalizePoint(map, this.m_mapPoint, stagePoint);
                if (_loc_2)
                {
                    visible = true;
                    this.m_mapPointX = _loc_2.x;
                    this.m_mapPointY = _loc_2.y;
                }
                else
                {
                    visible = false;
                }
            }
            return;
        }// end function

        public function hide() : void
        {
            this.hide2(true);
            return;
        }// end function

        function hide2(dispatchCloseEvent:Boolean = true) : void
        {
            if (!includeInLayout)
            {
            }
            if (visible)
            {
                var _loc_2:Boolean = false;
                visible = false;
                includeInLayout = _loc_2;
                this.removeMapListeners();
                if (dispatchCloseEvent)
                {
                    dispatchEvent(new Event(Event.CLOSE));
                }
            }
            return;
        }// end function

        function showXY(pixelX:Number, pixelY:Number) : void
        {
            anchorX = pixelX;
            anchorY = pixelY;
            visible = true;
            this.addMapListeners();
            dispatchEvent(new Event(Event.OPEN));
            return;
        }// end function

        private function addMapListeners() : void
        {
            this.removeMapListeners();
            m_map.addEventListener(PanEvent.PAN_START, this.map_panStartHandler);
            m_map.addEventListener(PanEvent.PAN_UPDATE, this.map_panUpdateHandler);
            m_map.addEventListener(ZoomEvent.ZOOM_START, this.map_zoomStartHandler);
            m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
            return;
        }// end function

        private function removeMapListeners() : void
        {
            m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
            m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.extentChangeHandler);
            m_map.removeEventListener(ZoomEvent.ZOOM_START, this.map_zoomStartHandler);
            m_map.removeEventListener(PanEvent.PAN_UPDATE, this.map_panUpdateHandler);
            m_map.removeEventListener(PanEvent.PAN_START, this.map_panStartHandler);
            return;
        }// end function

        private function map_extentChangeHandler(event:ExtentEvent) : void
        {
            if (m_map.wrapAround180)
            {
                this.getDenormalizedPoint();
            }
            anchorX = m_map.toScreenX(this.m_mapPointX);
            anchorY = m_map.toScreenY(this.m_mapPointY);
            return;
        }// end function

        private function map_panStartHandler(event:PanEvent) : void
        {
            this.m_anchorX = anchorX;
            this.m_anchorY = anchorY;
            return;
        }// end function

        private function map_panUpdateHandler(event:PanEvent) : void
        {
            anchorX = this.m_anchorX + event.point.x;
            anchorY = this.m_anchorY + event.point.y;
            return;
        }// end function

        private function map_zoomStartHandler(event:ZoomEvent) : void
        {
            m_map.addEventListener(ZoomEvent.ZOOM_END, this.map_zoomEndHandler);
            visible = false;
            return;
        }// end function

        private function map_zoomEndHandler(event:ZoomEvent) : void
        {
            m_map.removeEventListener(ZoomEvent.ZOOM_END, this.map_zoomEndHandler);
            visible = true;
            return;
        }// end function

        public function set label(value:String) : void
        {
            arguments = this.label;
            if (arguments !== value)
            {
                this._102727412label = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", arguments, value));
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
