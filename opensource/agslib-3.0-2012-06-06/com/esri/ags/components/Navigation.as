package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import flash.events.*;
    import mx.binding.utils.*;
    import mx.events.*;
    import spark.components.supportClasses.*;

    public class Navigation extends SkinnableComponent
    {
        public var slider:SliderBase;
        public var zoomInButton:ButtonBase;
        public var zoomOutButton:ButtonBase;
        private var m_map_lodsChangeWatcher:ChangeWatcher;
        private var m_map:Map;
        private static var _skinParts:Object = {slider:false, zoomInButton:false, zoomOutButton:false};

        public function Navigation()
        {
            addEventListener(MouseEvent.MOUSE_WHEEL, this.stopImmediatePropagation);
            addEventListener(MouseEvent.MOUSE_DOWN, this.stopImmediatePropagation);
            return;
        }// end function

        public function get map() : Map
        {
            return this.m_map;
        }// end function

        public function set map(value:Map) : void
        {
            if (this.m_map)
            {
                this.m_map_lodsChangeWatcher.unwatch();
                this.m_map.removeEventListener(MapEvent.LOAD, this.map_loadHandler);
                this.m_map.removeEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
                this.m_map.removeEventListener(ResizeEvent.RESIZE, this.map_resizeHandler);
            }
            this.m_map = value;
            if (this.m_map)
            {
                this.m_map_lodsChangeWatcher = ChangeWatcher.watch(this.m_map, "lods", this.map_lodsChangeHandler);
                this.m_map.addEventListener(MapEvent.LOAD, this.map_loadHandler);
                this.m_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler);
                this.m_map.addEventListener(ResizeEvent.RESIZE, this.map_resizeHandler);
            }
            dispatchEvent(new Event("mapChanged"));
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (this.m_map)
            {
            }
            if (!this.m_map.loaded)
            {
                return "disabled";
            }
            if (!enabled)
            {
                if (this.m_map.lods)
                {
                }
                return this.m_map.lods.length > 0 ? ("disabledWithSlider") : ("disabled");
            }
            if (this.m_map.lods)
            {
            }
            return this.m_map.lods.length > 0 ? ("normalWithSlider") : ("normal");
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.zoomInButton)
            {
                this.zoomInButton.addEventListener(MouseEvent.CLICK, this.zoomInButton_clickHandler);
            }
            else if (instance === this.zoomOutButton)
            {
                this.zoomOutButton.addEventListener(MouseEvent.CLICK, this.zoomOutButton_clickHandler);
            }
            else if (instance === this.slider)
            {
                if (this.m_map.lods)
                {
                }
                if (this.m_map.lods.length > 0)
                {
                    this.slider.maximum = this.m_map.lods.length - 1;
                }
                this.slider.focusEnabled = false;
                this.slider.addEventListener(Event.CHANGE, this.slider_changeHandler);
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.zoomInButton)
            {
                this.zoomInButton.removeEventListener(MouseEvent.CLICK, this.zoomInButton_clickHandler);
            }
            else if (instance === this.zoomOutButton)
            {
                this.zoomOutButton.removeEventListener(MouseEvent.CLICK, this.zoomOutButton_clickHandler);
            }
            else if (instance === this.slider)
            {
                this.slider.removeEventListener(Event.CHANGE, this.slider_changeHandler);
            }
            return;
        }// end function

        private function zoomIn() : void
        {
            if (this.m_map)
            {
                this.m_map.zoomIn();
            }
            return;
        }// end function

        private function zoomOut() : void
        {
            if (this.m_map)
            {
                this.m_map.zoomOut();
            }
            return;
        }// end function

        private function map_extentChangeHandler(event:ExtentEvent) : void
        {
            if (this.slider)
            {
            }
            if (event.lod)
            {
                this.slider.value = event.lod.level;
            }
            return;
        }// end function

        private function map_loadHandler(event:MapEvent) : void
        {
            invalidateSkinState();
            return;
        }// end function

        private function map_lodsChangeHandler(event:Event) : void
        {
            if (this.slider)
            {
                if (this.m_map.lods)
                {
                }
                if (this.m_map.lods.length > 0)
                {
                    this.slider.maximum = this.m_map.lods.length - 1;
                }
                if (this.slider.skin)
                {
                    this.slider.skin.invalidateDisplayList();
                }
            }
            invalidateSkinState();
            return;
        }// end function

        private function map_resizeHandler(event:ResizeEvent) : void
        {
            var _loc_2:Number = NaN;
            if (includeInLayout)
            {
            }
            if (this.map)
            {
            }
            if (this.map.staticLayer === parent)
            {
                _loc_2 = this.y + this.height;
                if (_loc_2 > this.map.height)
                {
                    this.visible = false;
                }
                else
                {
                    this.visible = true;
                }
            }
            return;
        }// end function

        private function stopImmediatePropagation(event:Event) : void
        {
            event.stopImmediatePropagation();
            return;
        }// end function

        private function slider_changeHandler(event:Event) : void
        {
            if (this.m_map)
            {
                this.m_map.level = this.slider.value;
            }
            return;
        }// end function

        private function zoomInButton_clickHandler(event:MouseEvent) : void
        {
            if (event.currentTarget === this.zoomInButton)
            {
                this.zoomIn();
            }
            event.stopImmediatePropagation();
            return;
        }// end function

        private function zoomOutButton_clickHandler(event:MouseEvent) : void
        {
            if (event.currentTarget === this.zoomOutButton)
            {
                this.zoomOut();
            }
            event.stopImmediatePropagation();
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
