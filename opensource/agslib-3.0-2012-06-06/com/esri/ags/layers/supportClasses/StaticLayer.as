package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.virtualearth.*;
    import flash.events.*;
    import flash.net.*;
    import mx.binding.utils.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;

    public class StaticLayer extends Group
    {
        private var m_map:Map;
        private var m_scaleBarVisibleCW:ChangeWatcher;
        private var m_images:Array;
        private var m_length:Number;
        private var m_width:Number;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_logo:Class;
        private var m_logoImg:Image;
        private var m_bingLogo:Class;
        private var m_bingLogoImg:Image;
        private var m_globe:Class;
        private var m_globeImg:Image;
        private var _panArrowsVisible:Boolean = false;
        private var _panArrowsVisibleChanged:Boolean = false;
        private var _logoVisible:Boolean = false;
        private var _logoVisibleChanged:Boolean = false;
        private var _bingLogoVisible:Boolean = false;
        private var _bingLogoVisibleChanged:Boolean = false;
        static var m_esriLogo:Class = StaticLayer_m_esriLogo;

        public function StaticLayer(map:Map)
        {
            this.m_logo = StaticLayer_m_logo;
            this.m_bingLogo = StaticLayer_m_bingLogo;
            this.m_globe = StaticLayer_m_globe;
            mouseEnabled = false;
            mouseEnabledWhereTransparent = false;
            this.logoVisible = true;
            this.m_map = map;
            this.m_map.addEventListener(MapEvent.LAYER_ADD, this.map_layerAddEventHandler, false, 0, true);
            this.m_map.addEventListener(MapEvent.LAYER_REMOVE, this.map_layerRemoveEventHandler, false, 0, true);
            return;
        }// end function

        function get panArrowsVisible() : Boolean
        {
            return this._panArrowsVisible;
        }// end function

        function set panArrowsVisible(value:Boolean) : void
        {
            if (this._panArrowsVisible !== value)
            {
                this._panArrowsVisible = value;
                this._panArrowsVisibleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        function showPanArrows() : void
        {
            if (!this.m_images)
            {
            }
            if (UIComponentGlobals.designMode)
            {
                return;
            }
            this.m_images = [];
            var offset:* = this.m_map.getStyle("panSkinOffset") as Number;
            var dSkin:* = this.m_map.getStyle("panDownSkin");
            var dImg:* = new Image();
            dImg.source = dSkin;
            dImg.setStyle("bottom", offset);
            dImg.setStyle("horizontalCenter", 0);
            dImg.buttonMode = true;
            dImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panDown();
                return;
            }// end function
            );
            addElement(dImg);
            this.m_images.push(dImg);
            var lSkin:* = this.m_map.getStyle("panLeftSkin");
            var lImg:* = new Image();
            lImg.source = lSkin;
            lImg.setStyle("left", offset);
            lImg.setStyle("verticalCenter", 0);
            lImg.buttonMode = true;
            lImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panLeft();
                return;
            }// end function
            );
            addElement(lImg);
            this.m_images.push(lImg);
            var llSkin:* = this.m_map.getStyle("panLowerLeftSkin");
            var llImg:* = new Image();
            llImg.source = llSkin;
            llImg.setStyle("bottom", offset);
            llImg.setStyle("left", offset);
            llImg.buttonMode = true;
            llImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panLowerLeft();
                return;
            }// end function
            );
            addElement(llImg);
            this.m_images.push(llImg);
            var lrSkin:* = this.m_map.getStyle("panLowerRightSkin");
            var lrImg:* = new Image();
            lrImg.source = lrSkin;
            lrImg.setStyle("bottom", offset);
            lrImg.setStyle("right", offset);
            lrImg.buttonMode = true;
            lrImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panLowerRight();
                return;
            }// end function
            );
            addElement(lrImg);
            this.m_images.push(lrImg);
            var rSkin:* = this.m_map.getStyle("panRightSkin");
            var rImg:* = new Image();
            rImg.source = rSkin;
            rImg.setStyle("right", offset);
            rImg.setStyle("verticalCenter", 0);
            rImg.buttonMode = true;
            rImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panRight();
                return;
            }// end function
            );
            addElement(rImg);
            this.m_images.push(rImg);
            var ulSkin:* = this.m_map.getStyle("panUpperLeftSkin");
            var ulImg:* = new Image();
            ulImg.source = ulSkin;
            ulImg.setStyle("top", offset);
            ulImg.setStyle("left", offset);
            ulImg.buttonMode = true;
            ulImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panUpperLeft();
                return;
            }// end function
            );
            addElement(ulImg);
            this.m_images.push(ulImg);
            var urSkin:* = this.m_map.getStyle("panUpperRightSkin");
            var urImg:* = new Image();
            urImg.source = urSkin;
            urImg.setStyle("top", offset);
            urImg.setStyle("right", offset);
            urImg.buttonMode = true;
            urImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panUpperRight();
                return;
            }// end function
            );
            addElement(urImg);
            this.m_images.push(urImg);
            var uSkin:* = this.m_map.getStyle("panUpSkin");
            var uImg:* = new Image();
            uImg.source = uSkin;
            uImg.setStyle("top", offset);
            uImg.setStyle("horizontalCenter", 0);
            uImg.buttonMode = true;
            uImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                m_map.panUp();
                return;
            }// end function
            );
            addElement(uImg);
            this.m_images.push(uImg);
            return;
        }// end function

        function hidePanArrows() : void
        {
            var _loc_1:Image = null;
            if (this.m_images)
            {
                for each (_loc_1 in this.m_images)
                {
                    
                    removeElement(_loc_1);
                }
                this.m_images = null;
            }
            return;
        }// end function

        function get logoVisible() : Boolean
        {
            return this._logoVisible;
        }// end function

        function set logoVisible(value:Boolean) : void
        {
            if (this._logoVisible !== value)
            {
                this._logoVisible = value;
                this._logoVisibleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function showLogo() : void
        {
            if (!this.m_logoImg)
            {
                this.m_logoImg = new Image();
                this.m_logoImg.source = this.m_logo;
                this.m_logoImg.setStyle("bottom", 6);
                this.m_logoImg.setStyle("right", 28);
                this.m_logoImg.buttonMode = true;
                this.m_logoImg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                event.stopPropagation();
                navigateToURL(new URLRequest("http://www.esri.com"));
                return;
            }// end function
            );
                addElement(this.m_logoImg);
            }
            return;
        }// end function

        private function hideLogo() : void
        {
            if (this.m_logoImg)
            {
                removeElement(this.m_logoImg);
                this.m_logoImg = null;
            }
            return;
        }// end function

        private function get bingLogoVisible() : Boolean
        {
            return this._bingLogoVisible;
        }// end function

        private function set bingLogoVisible(value:Boolean) : void
        {
            if (this._bingLogoVisible !== value)
            {
                this._bingLogoVisible = value;
                this._bingLogoVisibleChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function showBingLogo() : void
        {
            if (!this.m_bingLogoImg)
            {
                this.m_bingLogoImg = new Image();
                this.m_bingLogoImg.source = this.m_bingLogo;
                this.m_bingLogoImg.mouseChildren = false;
                this.m_bingLogoImg.mouseEnabled = false;
                this.positionBingLogo();
                addElement(this.m_bingLogoImg);
            }
            return;
        }// end function

        private function hideBingLogo() : void
        {
            if (this.m_bingLogoImg)
            {
                removeElement(this.m_bingLogoImg);
                this.m_bingLogoImg = null;
            }
            return;
        }// end function

        override protected function createChildren() : void
        {
            super.createChildren();
            if (UIComponentGlobals.designMode)
            {
                this.m_globeImg = new Image();
                this.m_globeImg.source = this.m_globe;
                this.m_globeImg.setStyle("horizontalCenter", 0);
                this.m_globeImg.setStyle("verticalCenter", 0);
                addElement(this.m_globeImg);
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            this.m_length = this.m_map.getStyle("crosshairLength") as Number;
            this.m_width = this.m_map.getStyle("crosshairWidth") as Number;
            this.m_color = this.m_map.getStyle("crosshairColor") as uint;
            this.m_alpha = this.m_map.getStyle("crosshairAlpha") as Number;
            if (this._panArrowsVisibleChanged)
            {
                this._panArrowsVisibleChanged = false;
                if (this.panArrowsVisible)
                {
                    this.showPanArrows();
                }
                else
                {
                    this.hidePanArrows();
                }
            }
            if (this._logoVisibleChanged)
            {
                this._logoVisibleChanged = false;
                if (this.logoVisible)
                {
                    this.showLogo();
                }
                else
                {
                    this.hideLogo();
                }
            }
            if (this._bingLogoVisibleChanged)
            {
                this._bingLogoVisibleChanged = false;
                if (this.bingLogoVisible)
                {
                    this.showBingLogo();
                    if (this.m_scaleBarVisibleCW)
                    {
                        if (!this.m_scaleBarVisibleCW.isWatching())
                        {
                            this.m_scaleBarVisibleCW.reset(this.m_map);
                        }
                    }
                    else
                    {
                        this.m_scaleBarVisibleCW = ChangeWatcher.watch(this.m_map, "scaleBarVisible", this.scaleBarVisible_changeHandler);
                    }
                }
                else
                {
                    this.hideBingLogo();
                    if (this.m_scaleBarVisibleCW)
                    {
                        this.m_scaleBarVisibleCW.unwatch();
                    }
                }
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            graphics.clear();
            if (this.m_map.crosshairVisible)
            {
                _loc_3 = unscaledWidth * 0.5;
                _loc_4 = unscaledHeight * 0.5;
                graphics.lineStyle(this.m_width, this.m_color, this.m_alpha);
                graphics.moveTo(_loc_3 - this.m_length, _loc_4);
                graphics.lineTo(_loc_3 + this.m_length, _loc_4);
                graphics.moveTo(_loc_3, _loc_4 - this.m_length);
                graphics.lineTo(_loc_3, _loc_4 + this.m_length);
            }
            if (this.m_globeImg)
            {
                var _loc_5:* = Math.min(width, height);
                this.m_globeImg.height = Math.min(width, height);
                this.m_globeImg.width = _loc_5;
            }
            return;
        }// end function

        private function checkIfBingLogoRequired(event:Event = null) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:Layer = null;
            var _loc_4:Layer = null;
            for each (_loc_3 in this.m_map.layers)
            {
                
                if (_loc_3 is IVETiledLayer)
                {
                    _loc_4 = Layer(_loc_3);
                    if (_loc_4.loaded)
                    {
                    }
                    if (_loc_4.visible)
                    {
                    }
                    if (_loc_4.isInScaleRange)
                    {
                        _loc_2 = true;
                        break;
                    }
                }
            }
            this.bingLogoVisible = _loc_2;
            return;
        }// end function

        private function positionBingLogo() : void
        {
            var _loc_1:Number = NaN;
            if (this.m_bingLogoImg)
            {
                _loc_1 = this.m_map.getStyle("panSkinOffset") as Number;
                this.m_bingLogoImg.setStyle("left", this.m_map.scaleBarVisible ? (0) : (15 + _loc_1));
                this.m_bingLogoImg.setStyle("bottom", this.m_map.scaleBarVisible ? (55) : (2));
            }
            return;
        }// end function

        private function map_layerAddEventHandler(event:MapEvent) : void
        {
            var _loc_2:Layer = null;
            if (event.layer is IVETiledLayer)
            {
                _loc_2 = Layer(event.layer);
                if (_loc_2.loaded)
                {
                    this.checkIfBingLogoRequired();
                }
                else
                {
                    _loc_2.addEventListener(LayerEvent.LOAD, this.bing_loadHandler, false, 0, true);
                }
                _loc_2.addEventListener(FlexEvent.HIDE, this.checkIfBingLogoRequired, false, 0, true);
                _loc_2.addEventListener(FlexEvent.SHOW, this.checkIfBingLogoRequired, false, 0, true);
                _loc_2.addEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.checkIfBingLogoRequired, false, 0, true);
            }
            return;
        }// end function

        private function map_layerRemoveEventHandler(event:MapEvent) : void
        {
            var _loc_2:Layer = null;
            if (event.layer is IVETiledLayer)
            {
                _loc_2 = Layer(event.layer);
                _loc_2.removeEventListener(FlexEvent.HIDE, this.checkIfBingLogoRequired);
                _loc_2.removeEventListener(FlexEvent.SHOW, this.checkIfBingLogoRequired);
                _loc_2.removeEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.checkIfBingLogoRequired);
                this.checkIfBingLogoRequired();
            }
            return;
        }// end function

        private function bing_loadHandler(event:LayerEvent) : void
        {
            event.layer.removeEventListener(LayerEvent.LOAD, this.bing_loadHandler);
            this.checkIfBingLogoRequired();
            return;
        }// end function

        private function scaleBarVisible_changeHandler(event:Event) : void
        {
            this.positionBingLogo();
            return;
        }// end function

    }
}
