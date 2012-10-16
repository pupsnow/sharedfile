package com.esri.ags.skins
{
    import com.esri.ags.components.supportClasses.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.filters.*;
    import spark.primitives.*;

    public class InfoSymbolWindowSkin extends Skin
    {
        private var _809612678contentGroup:Group;
        private var _906978543dropShadow:DropShadowFilter;
        private var _3433509path:Path;
        private var _1233990472pathFill:SolidColor;
        private var _836392637pathStroke:SolidColorStroke;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:InfoSymbolWindow;

        public function InfoSymbolWindowSkin()
        {
            mx_internal::_document = this;
            this.clipAndEnableScrolling = false;
            this.minHeight = 8;
            this.minWidth = 8;
            this.mxmlContent = [this._InfoSymbolWindowSkin_Path1_i(), this._InfoSymbolWindowSkin_Group1_i()];
            this._InfoSymbolWindowSkin_DropShadowFilter1_i();
            this._InfoSymbolWindowSkin_SolidColor1_i();
            this._InfoSymbolWindowSkin_SolidColorStroke1_i();
            return;
        }// end function

        override public function set moduleFactory(factory:IFlexModuleFactory) : void
        {
            super.moduleFactory = factory;
            if (this.__moduleFactoryInitialized)
            {
                return;
            }
            this.__moduleFactoryInitialized = true;
            return;
        }// end function

        override public function initialize() : void
        {
            super.initialize();
            return;
        }// end function

        override protected function measure() : void
        {
            var _loc_1:* = getStyle("infoPlacement");
            this.measureWidthHeight(_loc_1);
            return;
        }// end function

        private function measureWidthHeight(infoPlacement:String) : void
        {
            var _loc_11:int = 0;
            var _loc_2:Number = 0;
            var _loc_3:Number = 0;
            var _loc_4:* = getStyle("borderThickness");
            if (_loc_4 > 0)
            {
                _loc_11 = _loc_4 + _loc_4;
                _loc_2 = _loc_2 + _loc_11;
                _loc_3 = _loc_3 + _loc_11;
            }
            var _loc_5:* = getStyle("paddingLeft");
            _loc_2 = _loc_2 + _loc_5;
            var _loc_6:* = getStyle("paddingRight");
            _loc_2 = _loc_2 + _loc_6;
            var _loc_7:* = getStyle("paddingTop");
            _loc_3 = _loc_3 + _loc_7;
            var _loc_8:* = getStyle("paddingBottom");
            _loc_3 = _loc_3 + _loc_8;
            var _loc_9:* = getStyle("infoOffsetX");
            var _loc_10:* = getStyle("infoOffsetY");
            switch(infoPlacement)
            {
                case InfoPlacement.CENTER:
                {
                    break;
                }
                case InfoPlacement.TOP:
                case InfoPlacement.BOTTOM:
                {
                    _loc_3 = _loc_3 + _loc_10;
                    break;
                }
                case InfoPlacement.LEFT:
                case InfoPlacement.RIGHT:
                {
                    _loc_2 = _loc_2 + _loc_9;
                    break;
                }
                default:
                {
                    _loc_2 = _loc_2 + _loc_9;
                    _loc_3 = _loc_3 + _loc_10;
                    break;
                }
            }
            measuredWidth = this.contentGroup.measuredWidth + _loc_2;
            measuredHeight = this.contentGroup.measuredHeight + _loc_3;
            measuredMinWidth = this.contentGroup.measuredMinWidth + _loc_2;
            measuredMinHeight = this.contentGroup.measuredMinHeight + _loc_3;
            this.path.measuredWidth = measuredWidth;
            this.path.measuredHeight = measuredHeight;
            this.hostComponent.width = measuredWidth;
            this.hostComponent.height = measuredHeight;
            return;
        }// end function

        private function updateParts(unscaledWidth:Number, unscaledHeight:Number, infoPlacement:String) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_4:String = "M 0 0";
            _loc_5 = unscaledWidth * 0.5;
            _loc_6 = unscaledHeight * 0.5;
            _loc_7 = Math.min(_loc_5, _loc_6) * 0.5;
            var _loc_8:* = getStyle("borderThickness");
            var _loc_9:* = getStyle("infoOffsetX");
            var _loc_10:* = getStyle("infoOffsetY");
            var _loc_11:* = getStyle("infoOffsetW");
            var _loc_12:* = getStyle("paddingLeft");
            var _loc_13:* = getStyle("paddingTop");
            var _loc_14:* = Math.min(_loc_7, getStyle("upperLeftRadius"));
            var _loc_15:* = Math.min(_loc_7, getStyle("upperRightRadius"));
            var _loc_16:* = Math.min(_loc_7, getStyle("lowerLeftRadius"));
            var _loc_17:* = Math.min(_loc_7, getStyle("lowerRightRadius"));
            switch(infoPlacement)
            {
                case InfoPlacement.UPPERLEFT:
                case InfoPlacement.UPPER_LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9 - _loc_11) + " " + (-_loc_10));
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9));
                    }
                    _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_11));
                    this.contentGroup.move(_loc_8 - unscaledWidth + _loc_12, _loc_8 - unscaledHeight + _loc_13);
                    break;
                }
                case InfoPlacement.TOP:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_11) + " " + (-_loc_10));
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10));
                    }
                    _loc_4 = _loc_4 + ("H " + _loc_11);
                    this.contentGroup.move(_loc_8 - _loc_5 + _loc_12, _loc_8 - unscaledHeight + _loc_13);
                    break;
                }
                case InfoPlacement.LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9) + " " + _loc_11);
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_6);
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9));
                    }
                    _loc_4 = _loc_4 + ("V " + (-_loc_11));
                    this.contentGroup.move(_loc_8 - unscaledWidth + _loc_12, _loc_8 - _loc_6 + _loc_13);
                    break;
                }
                case InfoPlacement.CENTER:
                {
                    if (_loc_17 > 0)
                    {
                        _loc_4 = "M " + (_loc_5 - _loc_17) + " " + _loc_6;
                    }
                    else
                    {
                        _loc_4 = "M " + _loc_5 + " " + _loc_6;
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_17)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    this.contentGroup.move(_loc_8 - _loc_5 + _loc_12, _loc_8 - _loc_6 + _loc_13);
                    break;
                }
                case InfoPlacement.RIGHT:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_9 + " " + (-_loc_11));
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_6);
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_9);
                    }
                    _loc_4 = _loc_4 + ("V " + _loc_11);
                    this.contentGroup.move(_loc_8 + _loc_9 + _loc_12, _loc_8 - _loc_6 + _loc_13);
                    break;
                }
                case InfoPlacement.LOWERLEFT:
                case InfoPlacement.LOWER_LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9) + " " + (_loc_10 + _loc_11));
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_10);
                    }
                    _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_11));
                    this.contentGroup.move(_loc_8 - unscaledWidth + _loc_12, _loc_8 + _loc_10 + _loc_13);
                    break;
                }
                case InfoPlacement.BOTTOM:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_11 + " " + _loc_10);
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_10);
                    }
                    _loc_4 = _loc_4 + ("H " + (-_loc_11));
                    this.contentGroup.move(_loc_8 - _loc_5 + _loc_12, _loc_8 + _loc_10 + _loc_13);
                    break;
                }
                case InfoPlacement.LOWERRIGHT:
                case InfoPlacement.LOWER_RIGHT:
                {
                    _loc_4 = _loc_4 + ("L " + (_loc_9 + _loc_11) + " " + _loc_10);
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_16 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_16));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_16);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_9);
                    }
                    _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_11));
                    this.contentGroup.move(_loc_8 + _loc_9 + _loc_12, _loc_8 + _loc_10 + _loc_13);
                    break;
                }
                default:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_9 + " " + (-_loc_10 - _loc_11));
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_14));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_15));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_17 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_17));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_17);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10));
                    }
                    _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_11));
                    this.contentGroup.move(_loc_8 + _loc_9 + _loc_12, _loc_8 - unscaledHeight + _loc_13);
                    break;
                }
            }
            this.path.data = _loc_4 + "Z";
            return;
        }// end function

        private function upperLeftCurve(radius:Number) : String
        {
            return "q 0 " + (-radius) + " " + radius + " " + (-radius);
        }// end function

        private function upperRightCurve(radius:Number) : String
        {
            return "q " + radius + " 0 " + radius + " " + radius;
        }// end function

        private function lowerLeftCurve(radius:Number) : String
        {
            return "q " + (-radius) + " 0 " + (-radius) + " " + (-radius);
        }// end function

        private function lowerRightCurve(radius:Number) : String
        {
            return "q 0 " + radius + " " + (-radius) + " " + radius;
        }// end function

        private function updateInfoPlacement(unscaledWidth:Number, unscaledHeight:Number, infoPlacement:String) : String
        {
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_8:* = getStyle("infoPlacementMode");
            if (_loc_8 !== "none")
            {
            }
            if (this.hostComponent.map.wrapAround180)
            {
                return infoPlacement;
            }
            switch(infoPlacement)
            {
                case InfoPlacement.UPPERLEFT:
                case InfoPlacement.UPPER_LEFT:
                {
                    _loc_6 = this.hostComponent.positionX - unscaledWidth;
                    _loc_7 = this.hostComponent.positionY - unscaledHeight;
                    _loc_4 = _loc_6 < 0;
                    _loc_5 = _loc_7 < 0;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.UPPERRIGHT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    break;
                }
                case InfoPlacement.LOWERLEFT:
                case InfoPlacement.LOWER_LEFT:
                {
                    _loc_6 = this.hostComponent.positionX - unscaledWidth;
                    _loc_7 = this.hostComponent.positionY + unscaledHeight;
                    _loc_4 = _loc_6 < 0;
                    _loc_5 = _loc_7 > this.hostComponent.map.height;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.UPPERRIGHT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.UPPERLEFT;
                    }
                    break;
                }
                case InfoPlacement.LOWERRIGHT:
                case InfoPlacement.LOWER_RIGHT:
                {
                    _loc_6 = this.hostComponent.positionX + unscaledWidth;
                    _loc_7 = this.hostComponent.positionY + unscaledHeight;
                    _loc_4 = _loc_6 > this.hostComponent.map.width;
                    _loc_5 = _loc_7 > this.hostComponent.map.height;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.UPPERLEFT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.UPPERRIGHT;
                    }
                    break;
                }
                case InfoPlacement.LEFT:
                {
                    _loc_6 = this.hostComponent.positionX - unscaledWidth;
                    _loc_7 = this.hostComponent.positionY - unscaledHeight * 0.5;
                    _loc_4 = _loc_6 < 0;
                    _loc_5 = _loc_7 < 0;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.RIGHT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    break;
                }
                case InfoPlacement.RIGHT:
                {
                    _loc_6 = this.hostComponent.positionX + unscaledWidth;
                    _loc_7 = this.hostComponent.positionY - unscaledHeight * 0.5;
                    _loc_4 = _loc_6 > this.hostComponent.map.width;
                    _loc_5 = _loc_7 < 0;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.LEFT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    break;
                }
                case InfoPlacement.TOP:
                {
                    _loc_9 = this.hostComponent.positionX - unscaledWidth * 0.5;
                    _loc_10 = this.hostComponent.positionX + unscaledWidth * 0.5;
                    _loc_7 = this.hostComponent.positionY - unscaledHeight;
                    _loc_5 = _loc_7 < 0;
                    if (_loc_5)
                    {
                    }
                    if (_loc_9 > 0)
                    {
                    }
                    if (_loc_10 < this.hostComponent.map.width)
                    {
                        return InfoPlacement.BOTTOM;
                    }
                    if (_loc_5)
                    {
                    }
                    if (_loc_9 < 0)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    if (_loc_5)
                    {
                    }
                    if (_loc_10 > this.hostComponent.map.width)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    if (_loc_9 < 0)
                    {
                        return InfoPlacement.UPPERRIGHT;
                    }
                    if (_loc_10 > this.hostComponent.map.width)
                    {
                        return InfoPlacement.UPPERLEFT;
                    }
                    break;
                }
                case InfoPlacement.BOTTOM:
                {
                    _loc_11 = this.hostComponent.positionX - unscaledWidth * 0.5;
                    _loc_12 = this.hostComponent.positionX + unscaledWidth * 0.5;
                    _loc_7 = this.hostComponent.positionY + unscaledHeight;
                    _loc_5 = _loc_7 > this.hostComponent.map.height;
                    if (_loc_5)
                    {
                    }
                    if (_loc_11 > 0)
                    {
                    }
                    if (_loc_12 < this.hostComponent.map.width)
                    {
                        return InfoPlacement.TOP;
                    }
                    if (_loc_5)
                    {
                    }
                    if (_loc_11 < 0)
                    {
                        return InfoPlacement.UPPERRIGHT;
                    }
                    if (_loc_5)
                    {
                    }
                    if (_loc_12 > this.hostComponent.map.width)
                    {
                        return InfoPlacement.UPPERLEFT;
                    }
                    if (_loc_11 < 0)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    if (_loc_12 > this.hostComponent.map.width)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    break;
                }
                default:
                {
                    _loc_6 = this.hostComponent.positionX + unscaledWidth;
                    _loc_7 = this.hostComponent.positionY - unscaledHeight;
                    _loc_4 = _loc_6 > this.hostComponent.map.width;
                    _loc_5 = _loc_7 < 0;
                    if (_loc_4)
                    {
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERLEFT;
                    }
                    if (_loc_4)
                    {
                        return InfoPlacement.UPPERLEFT;
                    }
                    if (_loc_5)
                    {
                        return InfoPlacement.LOWERRIGHT;
                    }
                    break;
                }
            }
            return infoPlacement;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (unscaledWidth > 0)
            {
            }
            if (unscaledHeight > 0)
            {
                _loc_3 = getStyle("infoPlacement");
                _loc_4 = this.updateInfoPlacement(unscaledWidth, unscaledHeight, _loc_3);
                if (_loc_4 !== _loc_3)
                {
                    this.measureWidthHeight(_loc_4);
                }
                this.updateParts(measuredWidth, measuredHeight, _loc_4);
                this.pathFill.color = getStyle("backgroundColor");
                this.pathFill.alpha = getStyle("backgroundAlpha");
                this.path.fill = this.pathFill.alpha > 0 ? (this.pathFill) : (null);
                this.pathStroke.weight = getStyle("borderThickness");
                this.pathStroke.color = getStyle("borderColor");
                this.pathStroke.alpha = getStyle("borderAlpha");
                this.path.stroke = this.pathStroke.weight > 0 ? (this.pathStroke) : (null);
                _loc_5 = getStyle("shadowDistance");
                if (_loc_5 == 0)
                {
                }
                if (filters.length > 0)
                {
                    filters = [];
                }
                else
                {
                    _loc_6 = getStyle("shadowAlpha");
                    _loc_7 = getStyle("shadowAngle");
                    _loc_8 = getStyle("shadowColor");
                    if (_loc_5 === this.dropShadow.distance)
                    {
                    }
                    if (_loc_6 === this.dropShadow.alpha)
                    {
                    }
                    if (_loc_7 === this.dropShadow.angle)
                    {
                    }
                    if (_loc_8 !== this.dropShadow.color)
                    {
                        this.dropShadow.distance = _loc_5;
                        this.dropShadow.alpha = _loc_6;
                        this.dropShadow.angle = _loc_7;
                        this.dropShadow.color = _loc_8;
                        filters = [this.dropShadow];
                    }
                }
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _InfoSymbolWindowSkin_DropShadowFilter1_i() : DropShadowFilter
        {
            var _loc_1:* = new DropShadowFilter();
            this.dropShadow = _loc_1;
            BindingManager.executeBindings(this, "dropShadow", this.dropShadow);
            return _loc_1;
        }// end function

        private function _InfoSymbolWindowSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this.pathFill = _loc_1;
            BindingManager.executeBindings(this, "pathFill", this.pathFill);
            return _loc_1;
        }// end function

        private function _InfoSymbolWindowSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.pixelHinting = true;
            this.pathStroke = _loc_1;
            BindingManager.executeBindings(this, "pathStroke", this.pathStroke);
            return _loc_1;
        }// end function

        private function _InfoSymbolWindowSkin_Path1_i() : Path
        {
            var _loc_1:* = new Path();
            _loc_1.minHeight = 0;
            _loc_1.minWidth = 0;
            _loc_1.initialized(this, "path");
            this.path = _loc_1;
            BindingManager.executeBindings(this, "path", this.path);
            return _loc_1;
        }// end function

        private function _InfoSymbolWindowSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.minHeight = 0;
            _loc_1.minWidth = 0;
            _loc_1.id = "contentGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.contentGroup = _loc_1;
            BindingManager.executeBindings(this, "contentGroup", this.contentGroup);
            return _loc_1;
        }// end function

        public function get contentGroup() : Group
        {
            return this._809612678contentGroup;
        }// end function

        public function set contentGroup(value:Group) : void
        {
            var _loc_2:* = this._809612678contentGroup;
            if (_loc_2 !== value)
            {
                this._809612678contentGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get dropShadow() : DropShadowFilter
        {
            return this._906978543dropShadow;
        }// end function

        public function set dropShadow(value:DropShadowFilter) : void
        {
            var _loc_2:* = this._906978543dropShadow;
            if (_loc_2 !== value)
            {
                this._906978543dropShadow = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dropShadow", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get path() : Path
        {
            return this._3433509path;
        }// end function

        public function set path(value:Path) : void
        {
            var _loc_2:* = this._3433509path;
            if (_loc_2 !== value)
            {
                this._3433509path = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "path", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pathFill() : SolidColor
        {
            return this._1233990472pathFill;
        }// end function

        public function set pathFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1233990472pathFill;
            if (_loc_2 !== value)
            {
                this._1233990472pathFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pathFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pathStroke() : SolidColorStroke
        {
            return this._836392637pathStroke;
        }// end function

        public function set pathStroke(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._836392637pathStroke;
            if (_loc_2 !== value)
            {
                this._836392637pathStroke = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pathStroke", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : InfoSymbolWindow
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:InfoSymbolWindow) : void
        {
            var _loc_2:* = this._213507019hostComponent;
            if (_loc_2 !== value)
            {
                this._213507019hostComponent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hostComponent", _loc_2, value));
                }
            }
            return;
        }// end function

    }
}
