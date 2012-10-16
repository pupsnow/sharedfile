package com.esri.ags.tools
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import flash.events.*;

    public class BaseTool extends EventDispatcher
    {
        private var _mapNavState:Object;
        private var _mapInfoWindowRenderersState:Object;
        private var _map:Map;

        public function BaseTool(map:Map = null)
        {
            super(null);
            this.map = map;
            return;
        }// end function

        public function get map() : Map
        {
            return this._map;
        }// end function

        public function set map(map:Map) : void
        {
            this._map = map;
            return;
        }// end function

        protected function deactivateMapTools(nav:Boolean, slider:Boolean, fixedPan:Boolean, graphics:Boolean, infoWindowRenderers:Boolean) : void
        {
            if (!this.map)
            {
                return;
            }
            if (nav)
            {
                this._mapNavState = {isDoubleClickZoom:this.map.doubleClickZoomEnabled, isClickRecenter:this.map.clickRecenterEnabled, isPan:this.map.panEnabled, isRubberbandZoom:this.map.rubberbandZoomEnabled, isOpenHandCursor:this.map.openHandCursorVisible};
                this.map.doubleClickZoomEnabled = false;
                this.map.clickRecenterEnabled = false;
                this.map.panEnabled = false;
                this.map.rubberbandZoomEnabled = false;
                this.map.openHandCursorVisible = false;
            }
            if (slider)
            {
                this.map.zoomSliderVisible = false;
            }
            if (fixedPan)
            {
                this.map.panArrowsVisible = false;
            }
            if (graphics)
            {
                this.setGraphicsLayersMouseChildren(false);
            }
            if (infoWindowRenderers)
            {
                this._mapInfoWindowRenderersState = {isInfoWindowRenderersEnabled:this.map.infoWindowRenderersEnabled};
                this.map.infoWindowRenderersEnabled = false;
            }
            return;
        }// end function

        protected function activateMapTools(nav:Boolean, slider:Boolean, fixedPan:Boolean, graphics:Boolean, infoWindowRenderers:Boolean) : void
        {
            if (!this.map)
            {
                return;
            }
            if (nav)
            {
            }
            if (this._mapNavState)
            {
                if (this._mapNavState.isDoubleClickZoom)
                {
                    this.map.doubleClickZoomEnabled = true;
                }
                if (this._mapNavState.isClickRecenter)
                {
                    this.map.clickRecenterEnabled = true;
                }
                if (this._mapNavState.isPan)
                {
                    this.map.panEnabled = true;
                }
                if (this._mapNavState.isRubberbandZoom)
                {
                    this.map.rubberbandZoomEnabled = true;
                }
                if (this._mapNavState.isOpenHandCursor)
                {
                    this.map.openHandCursorVisible = true;
                }
                if (this._mapNavState.isInfoWindowRenderersEnabled)
                {
                }
            }
            if (slider)
            {
                this.map.zoomSliderVisible = true;
            }
            if (fixedPan)
            {
                this.map.panArrowsVisible = true;
            }
            if (graphics)
            {
                this.setGraphicsLayersMouseChildren(true);
            }
            if (infoWindowRenderers)
            {
                if (infoWindowRenderers)
                {
                }
                if (this._mapInfoWindowRenderersState)
                {
                    if (this._mapInfoWindowRenderersState.isInfoWindowRenderersEnabled)
                    {
                        this.map.infoWindowRenderersEnabled = true;
                    }
                }
            }
            return;
        }// end function

        private function setGraphicsLayersMouseChildren(value:Boolean) : void
        {
            var _loc_2:Array = null;
            var _loc_3:Layer = null;
            if (this.map)
            {
            }
            if (this.map.layerContainer)
            {
                _loc_2 = this.map.layerContainer.layers;
                for each (_loc_3 in _loc_2)
                {
                    
                    if (_loc_3 is GraphicsLayer)
                    {
                        _loc_3.mouseChildren = value;
                    }
                }
            }
            return;
        }// end function

    }
}
