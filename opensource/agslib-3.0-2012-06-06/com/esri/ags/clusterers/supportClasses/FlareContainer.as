package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import flash.events.*;
    import flash.text.*;
    import mx.core.*;
    import mx.effects.easing.*;

    final public class FlareContainer extends UIComponent
    {
        var cluster:Cluster;
        var flareSymbol:FlareSymbol;
        private var m_updateDisplayListFunction:Function;
        private var m_distance:Number;
        private var m_factor:Number = 0;
        private var m_textField:TextField;
        public var flareFactorIncOut:Number = 0.05;
        public var flareFactorIncIn:Number = 0.1;
        public var backgroundColor:uint;
        public var backgroundAlpha:Number;
        static var lastFlareContainer:FlareContainer;

        public function FlareContainer()
        {
            this.m_updateDisplayListFunction = this.updateDisplayListCluster;
            this.doubleClickEnabled = false;
            this.m_textField = new TextField();
            this.m_textField.name = "textField";
            this.m_textField.mouseEnabled = false;
            this.m_textField.mouseWheelEnabled = false;
            this.m_textField.selectable = false;
            this.m_textField.autoSize = TextFieldAutoSize.CENTER;
            addChild(this.m_textField);
            return;
        }// end function

        public function get parentGraphic() : Graphic
        {
            return parent as Graphic;
        }// end function

        public function init(flareSymbol:FlareSymbol, cluster:Cluster) : void
        {
            this.flareSymbol = flareSymbol;
            this.cluster = cluster;
            this.m_textField.text = flareSymbol.m_textFunction(cluster);
            removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            if (cluster.graphics.length <= flareSymbol.flareMaxCount)
            {
                addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
                addEventListener(FlareMouseEvent.FLARE_CLICK, this.flareClickHandler);
            }
            invalidateDisplayList();
            return;
        }// end function

        private function flareClickHandler(event:FlareMouseEvent) : void
        {
            var _loc_2:GraphicsLayer = null;
            if (lastFlareContainer)
            {
            }
            if (lastFlareContainer !== this)
            {
                this.m_factor = 1;
                lastFlareContainer.flareIn();
            }
            lastFlareContainer = this;
            if (event.graphic.infoWindowRenderer)
            {
                removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            }
            else
            {
                _loc_2 = parent.parent as GraphicsLayer;
                if (_loc_2.infoWindowRenderer)
                {
                    removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
                }
            }
            return;
        }// end function

        private function rollOverHandler(event:MouseEvent) : void
        {
            if (event.eventPhase === EventPhase.AT_TARGET)
            {
                removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
                addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
                removeChild(this.m_textField);
                this.addFlares();
                this.m_factor = 0;
                FlareEasing.easing = Bounce.easeOut;
                this.m_updateDisplayListFunction = this.updateDisplayListFlare;
                addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                addEventListener(Event.ENTER_FRAME, this.enterFrameOutHandler);
                event.updateAfterEvent();
                mouseChildren = false;
                dispatchEvent(new FlareEvent(FlareEvent.FLARE_OUT_START, this.cluster));
            }
            return;
        }// end function

        private function addFlares() : void
        {
            var _loc_5:Graphic = null;
            var _loc_6:FlareElement = null;
            var _loc_1:int = 0;
            var _loc_2:* = this.flareSymbol.ringAngleStart;
            var _loc_3:Number = 0;
            var _loc_4:* = 360 / Math.min(this.flareSymbol.maxCountPerRing, this.cluster.graphics.length);
            this.m_distance = this.flareSymbol.ringDistanceStart;
            for each (_loc_5 in this.cluster.graphics)
            {
                
                if (_loc_1 === this.flareSymbol.maxCountPerRing)
                {
                    _loc_1 = 0;
                    _loc_2 = _loc_2 + this.flareSymbol.ringAngleInc;
                    _loc_3 = 0;
                    this.m_distance = this.m_distance + this.flareSymbol.ringDistanceInc;
                }
                _loc_6 = new FlareElement(_loc_5, _loc_2 + _loc_3, this.m_distance, this.flareSymbol.flareSize);
                addChild(_loc_6);
                _loc_6.initialize();
                _loc_3 = _loc_3 + _loc_4;
                _loc_1 = _loc_1 + 1;
            }
            this.swapZ();
            return;
        }// end function

        private function swapZ() : void
        {
            var _loc_1:int = 0;
            var _loc_2:* = numChildren - 1;
            while (_loc_1 < _loc_2)
            {
                
                swapChildrenAt(_loc_1++, _loc_2--);
            }
            return;
        }// end function

        private function enterFrameOutHandler(event:Event) : void
        {
            if (this.m_factor > 1)
            {
                removeEventListener(Event.ENTER_FRAME, this.enterFrameOutHandler);
                mouseChildren = true;
                dispatchEvent(new FlareEvent(FlareEvent.FLARE_OUT_COMPLETE, this.cluster));
            }
            else
            {
                this.m_factor = this.m_factor + this.flareFactorIncOut;
                invalidateDisplayList();
            }
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (event.currentTarget === this)
            {
                event.stopImmediatePropagation();
            }
            return;
        }// end function

        private function rollOutHandler(event:MouseEvent) : void
        {
            if (event.eventPhase === EventPhase.AT_TARGET)
            {
                removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
                if (this.m_factor < 1)
                {
                    removeEventListener(Event.ENTER_FRAME, this.enterFrameOutHandler);
                }
                else
                {
                    this.m_factor = 1;
                }
                event.updateAfterEvent();
                this.flareIn();
            }
            return;
        }// end function

        public function flareIn() : void
        {
            if (this.m_factor >= 0)
            {
                mouseChildren = false;
                FlareEasing.easing = Linear.easeIn;
                addEventListener(Event.ENTER_FRAME, this.enterFrameInHandler);
                dispatchEvent(new FlareEvent(FlareEvent.FLARE_IN_START, this.cluster));
            }
            return;
        }// end function

        private function enterFrameInHandler(event:Event) : void
        {
            this.m_factor = this.m_factor - this.flareFactorIncIn;
            if (this.m_factor <= 0)
            {
                removeEventListener(Event.ENTER_FRAME, this.enterFrameInHandler);
                removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                this.removeFlares();
                addChild(this.m_textField);
                this.m_updateDisplayListFunction = this.updateDisplayListCluster;
                addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
                dispatchEvent(new FlareEvent(FlareEvent.FLARE_IN_COMPLETE, this.cluster));
            }
            invalidateDisplayList();
            return;
        }// end function

        private function removeFlares() : void
        {
            while (numChildren)
            {
                
                removeChildAt(0);
            }
            return;
        }// end function

        private function updateDisplayListCluster() : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            graphics.clear();
            if (this.flareSymbol.borderThickness > 0)
            {
                graphics.lineStyle(this.flareSymbol.borderThickness, this.flareSymbol.borderColor, this.flareSymbol.borderAlpha);
            }
            var _loc_1:* = this.flareSymbol.size;
            this.backgroundColor = this.flareSymbol.backgroundColor;
            this.backgroundAlpha = this.flareSymbol.backgroundAlpha;
            var _loc_2:* = this.cluster.weight;
            if (this.flareSymbol.weights)
            {
                _loc_3 = 0;
                _loc_4 = this.flareSymbol.weights.length;
                while (_loc_3 < _loc_4)
                {
                    
                    if (this.flareSymbol.weights[_loc_3] >= _loc_2)
                    {
                        if (this.flareSymbol.sizes)
                        {
                        }
                        if (_loc_3 < this.flareSymbol.sizes.length)
                        {
                            _loc_1 = this.flareSymbol.sizes[_loc_3];
                        }
                        if (this.flareSymbol.backgroundColors)
                        {
                        }
                        if (_loc_3 < this.flareSymbol.backgroundColors.length)
                        {
                            this.backgroundColor = this.flareSymbol.backgroundColors[_loc_3];
                        }
                        if (this.flareSymbol.backgroundAlphas)
                        {
                        }
                        if (_loc_3 < this.flareSymbol.backgroundAlphas.length)
                        {
                            this.backgroundAlpha = this.flareSymbol.backgroundAlphas[_loc_3];
                        }
                        break;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
            graphics.drawCircle(0, 0, _loc_1 * 0.5);
            graphics.endFill();
            if (this.flareSymbol.textFormat)
            {
                this.m_textField.embedFonts = FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(this.flareSymbol.textFormat);
                this.m_textField.setTextFormat(this.flareSymbol.textFormat);
            }
            this.m_textField.x = this.m_textField.textWidth * -0.5 - 2;
            this.m_textField.y = this.m_textField.textHeight * -0.5 - 2;
            return;
        }// end function

        private function updateDisplayListFlare() : void
        {
            var _loc_3:FlareElement = null;
            graphics.clear();
            var _loc_1:* = Math.max(this.m_distance, this.flareSymbol.size);
            graphics.beginFill(this.flareSymbol.haloColor, this.flareSymbol.haloAlpha);
            graphics.drawCircle(0, 0, _loc_1 + this.flareSymbol.flareSize);
            graphics.endFill();
            var _loc_2:int = 0;
            while (_loc_2 < numChildren)
            {
                
                _loc_3 = FlareElement(getChildAt(_loc_2));
                _loc_3.updateFactor(this.m_factor);
                _loc_3.updateDisplayList();
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            this.m_updateDisplayListFunction();
            return;
        }// end function

    }
}
