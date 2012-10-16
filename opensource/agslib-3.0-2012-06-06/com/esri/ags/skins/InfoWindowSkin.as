package com.esri.ags.skins
{
    import com.esri.ags.components.supportClasses.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.filters.*;
    import spark.primitives.*;

    public class InfoWindowSkin extends Skin implements IBindingClient, IStateClient2
    {
        private var _312699062closeButton:InfoWindowCloseButton;
        private var _833446526containerGroup:VGroup;
        private var _809612678contentGroup:Group;
        private var _906978543dropShadow:DropShadowFilter;
        private var _1161933810headerGroup:HGroup;
        private var _607740351labelText:InfoWindowLabel;
        private var _3433509path:Path;
        private var _1233990472pathFill:SolidColor;
        private var _836392637pathStroke:SolidColorStroke;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:InfoWindow;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function InfoWindowSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._InfoWindowSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_InfoWindowSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return [propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.clipAndEnableScrolling = false;
            this.minHeight = 8;
            this.minWidth = 8;
            this.mxmlContent = [this._InfoWindowSkin_Path1_i(), this._InfoWindowSkin_VGroup1_i()];
            this.currentState = "withHeader";
            this._InfoWindowSkin_DropShadowFilter1_i();
            this._InfoWindowSkin_SolidColor1_i();
            this._InfoWindowSkin_SolidColorStroke1_i();
            states = [new State({name:"withHeader", overrides:[]}), new State({name:"withoutHeader", overrides:[new SetProperty().initializeFromObject({target:"headerGroup", name:"includeInLayout", value:false}), new SetProperty().initializeFromObject({target:"headerGroup", name:"visible", value:false})]})];
            var i:uint;
            while (i < bindings.length)
            {
                
                Binding(bindings[i]).execute();
                i = (i + 1);
            }
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
            var _loc_7:int = 0;
            var _loc_2:Number = 0;
            var _loc_3:Number = 0;
            var _loc_4:* = getStyle("borderThickness");
            if (_loc_4 > 0)
            {
                _loc_7 = _loc_4 + _loc_4;
                _loc_2 = _loc_2 + _loc_7;
                _loc_3 = _loc_3 + _loc_7;
            }
            var _loc_5:* = getStyle("infoOffsetX");
            var _loc_6:* = getStyle("infoOffsetY");
            switch(infoPlacement)
            {
                case InfoPlacement.CENTER:
                {
                    break;
                }
                case InfoPlacement.TOP:
                case InfoPlacement.BOTTOM:
                {
                    _loc_3 = _loc_3 + _loc_6;
                    break;
                }
                case InfoPlacement.LEFT:
                case InfoPlacement.RIGHT:
                {
                    _loc_2 = _loc_2 + _loc_5;
                    break;
                }
                default:
                {
                    _loc_2 = _loc_2 + _loc_5;
                    _loc_3 = _loc_3 + _loc_6;
                    break;
                }
            }
            measuredWidth = this.containerGroup.measuredWidth + _loc_2;
            measuredHeight = this.containerGroup.measuredHeight + _loc_3;
            measuredMinWidth = this.containerGroup.measuredMinWidth + _loc_2;
            measuredMinHeight = this.containerGroup.measuredMinHeight + _loc_3;
            this.path.measuredWidth = measuredWidth;
            this.path.measuredHeight = measuredHeight;
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
            var _loc_12:* = Math.min(_loc_7, getStyle("upperLeftRadius"));
            var _loc_13:* = Math.min(_loc_7, getStyle("upperRightRadius"));
            var _loc_14:* = Math.min(_loc_7, getStyle("lowerLeftRadius"));
            var _loc_15:* = Math.min(_loc_7, getStyle("lowerRightRadius"));
            switch(infoPlacement)
            {
                case InfoPlacement.UPPERLEFT:
                case InfoPlacement.UPPER_LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9 - _loc_11) + " " + (-_loc_10));
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9));
                    }
                    _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_11));
                    this.containerGroup.move(_loc_8 - unscaledWidth, _loc_8 - unscaledHeight);
                    break;
                }
                case InfoPlacement.TOP:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_11) + " " + (-_loc_10));
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10));
                    }
                    _loc_4 = _loc_4 + ("H " + _loc_11);
                    this.containerGroup.move(_loc_8 - _loc_5, _loc_8 - unscaledHeight);
                    break;
                }
                case InfoPlacement.LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9) + " " + _loc_11);
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_6);
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_9));
                    }
                    _loc_4 = _loc_4 + ("V " + (-_loc_11));
                    this.containerGroup.move(_loc_8 - unscaledWidth, _loc_8 - _loc_6);
                    break;
                }
                case InfoPlacement.CENTER:
                {
                    if (_loc_15 > 0)
                    {
                        _loc_4 = "M " + (_loc_5 - _loc_15) + " " + _loc_6;
                    }
                    else
                    {
                        _loc_4 = "M " + _loc_5 + " " + _loc_6;
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_15)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    this.containerGroup.move(_loc_8 - _loc_5, _loc_8 - _loc_6);
                    break;
                }
                case InfoPlacement.RIGHT:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_9 + " " + (-_loc_11));
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6 + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_6));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_6 - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_6);
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_9);
                    }
                    _loc_4 = _loc_4 + ("V " + _loc_11);
                    this.containerGroup.move(_loc_8 + _loc_9, _loc_8 - _loc_6);
                    break;
                }
                case InfoPlacement.LOWERLEFT:
                case InfoPlacement.LOWER_LEFT:
                {
                    _loc_4 = _loc_4 + ("L " + (-_loc_9) + " " + (_loc_10 + _loc_11));
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-unscaledWidth));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_10);
                    }
                    _loc_4 = _loc_4 + ("H " + (-_loc_9 - _loc_11));
                    this.containerGroup.move(_loc_8 - unscaledWidth, _loc_8 + _loc_10);
                    break;
                }
                case InfoPlacement.BOTTOM:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_11 + " " + _loc_10);
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_5 - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_5);
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5 + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + (-_loc_5));
                    }
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + _loc_10);
                    }
                    _loc_4 = _loc_4 + ("H " + (-_loc_11));
                    this.containerGroup.move(_loc_8 - _loc_5, _loc_8 + _loc_10);
                    break;
                }
                case InfoPlacement.LOWERRIGHT:
                case InfoPlacement.LOWER_RIGHT:
                {
                    _loc_4 = _loc_4 + ("L " + (_loc_9 + _loc_11) + " " + _loc_10);
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (unscaledHeight - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + unscaledHeight);
                    }
                    if (_loc_14 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_14));
                        _loc_4 = _loc_4 + this.lowerLeftCurve(_loc_14);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + _loc_9);
                    }
                    _loc_4 = _loc_4 + ("V " + (_loc_10 + _loc_11));
                    this.containerGroup.move(_loc_8 + _loc_9, _loc_8 + _loc_10);
                    break;
                }
                default:
                {
                    _loc_4 = _loc_4 + ("L " + _loc_9 + " " + (-_loc_10 - _loc_11));
                    if (_loc_12 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight + _loc_12));
                        _loc_4 = _loc_4 + this.upperLeftCurve(_loc_12);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-unscaledHeight));
                    }
                    if (_loc_13 > 0)
                    {
                        _loc_4 = _loc_4 + ("H " + (unscaledWidth - _loc_13));
                        _loc_4 = _loc_4 + this.upperRightCurve(_loc_13);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("H " + unscaledWidth);
                    }
                    if (_loc_15 > 0)
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10 - _loc_15));
                        _loc_4 = _loc_4 + this.lowerRightCurve(_loc_15);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("V " + (-_loc_10));
                    }
                    _loc_4 = _loc_4 + ("H " + (_loc_9 + _loc_11));
                    this.containerGroup.move(_loc_8 + _loc_9, _loc_8 - unscaledHeight);
                    break;
                }
            }
            this.path.data = _loc_4 + "Z";
            return;
        }// end function

        private function upperLeftCurve(upperLeftRadius:Number) : String
        {
            return "q 0 " + (-upperLeftRadius) + " " + upperLeftRadius + " " + (-upperLeftRadius);
        }// end function

        private function upperRightCurve(upperRightRadius:Number) : String
        {
            return "q " + upperRightRadius + " 0 " + upperRightRadius + " " + upperRightRadius;
        }// end function

        private function lowerLeftCurve(lowerLeftRadius:Number) : String
        {
            return "q " + (-lowerLeftRadius) + " 0 " + (-lowerLeftRadius) + " " + (-lowerLeftRadius);
        }// end function

        private function lowerRightCurve(lowerRightRadius:Number) : String
        {
            return "q 0 " + lowerRightRadius + " " + (-lowerRightRadius) + " " + lowerRightRadius;
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
            if (_loc_8 === "none")
            {
                return infoPlacement;
            }
            switch(infoPlacement)
            {
                case InfoPlacement.UPPERLEFT:
                case InfoPlacement.UPPER_LEFT:
                {
                    _loc_6 = this.hostComponent.anchorX - unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY - unscaledHeight;
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
                    _loc_6 = this.hostComponent.anchorX - unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY + unscaledHeight;
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
                    _loc_6 = this.hostComponent.anchorX + unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY + unscaledHeight;
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
                    _loc_6 = this.hostComponent.anchorX - unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY - unscaledHeight * 0.5;
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
                    _loc_6 = this.hostComponent.anchorX + unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY - unscaledHeight * 0.5;
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
                    _loc_9 = this.hostComponent.anchorX - unscaledWidth * 0.5;
                    _loc_10 = this.hostComponent.anchorX + unscaledWidth * 0.5;
                    _loc_7 = this.hostComponent.anchorY - unscaledHeight;
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
                    _loc_11 = this.hostComponent.anchorX - unscaledWidth * 0.5;
                    _loc_12 = this.hostComponent.anchorX + unscaledWidth * 0.5;
                    _loc_7 = this.hostComponent.anchorY + unscaledHeight;
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
                    _loc_6 = this.hostComponent.anchorX + unscaledWidth;
                    _loc_7 = this.hostComponent.anchorY - unscaledHeight;
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

        private function _InfoWindowSkin_DropShadowFilter1_i() : DropShadowFilter
        {
            var _loc_1:* = new DropShadowFilter();
            this.dropShadow = _loc_1;
            BindingManager.executeBindings(this, "dropShadow", this.dropShadow);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this.pathFill = _loc_1;
            BindingManager.executeBindings(this, "pathFill", this.pathFill);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.pixelHinting = true;
            this.pathStroke = _loc_1;
            BindingManager.executeBindings(this, "pathStroke", this.pathStroke);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_Path1_i() : Path
        {
            var _loc_1:* = new Path();
            _loc_1.initialized(this, "path");
            this.path = _loc_1;
            BindingManager.executeBindings(this, "path", this.path);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_VGroup1_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.minHeight = 0;
            _loc_1.minWidth = 0;
            _loc_1.mxmlContent = [this._InfoWindowSkin_HGroup1_i(), this._InfoWindowSkin_Group1_i()];
            _loc_1.id = "containerGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.containerGroup = _loc_1;
            BindingManager.executeBindings(this, "containerGroup", this.containerGroup);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_HGroup1_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.percentWidth = 100;
            _loc_1.minWidth = 0;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._InfoWindowSkin_InfoWindowLabel1_i(), this._InfoWindowSkin_Rect1_c(), this._InfoWindowSkin_InfoWindowCloseButton1_i()];
            _loc_1.id = "headerGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.headerGroup = _loc_1;
            BindingManager.executeBindings(this, "headerGroup", this.headerGroup);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_InfoWindowLabel1_i() : InfoWindowLabel
        {
            var _loc_1:* = new InfoWindowLabel();
            _loc_1.id = "labelText";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.labelText = _loc_1;
            BindingManager.executeBindings(this, "labelText", this.labelText);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.percentWidth = 100;
            _loc_1.height = 10;
            _loc_1.minWidth = 0;
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_InfoWindowCloseButton1_i() : InfoWindowCloseButton
        {
            var _loc_1:* = new InfoWindowCloseButton();
            _loc_1.id = "closeButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.closeButton = _loc_1;
            BindingManager.executeBindings(this, "closeButton", this.closeButton);
            return _loc_1;
        }// end function

        private function _InfoWindowSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
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

        private function _InfoWindowSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : int
            {
                return getStyle("verticalGap");
            }// end function
            , null, "containerGroup.gap");
            result[1] = new Binding(this, function () : Number
            {
                return getStyle("paddingBottom");
            }// end function
            , null, "containerGroup.paddingBottom");
            result[2] = new Binding(this, function () : Number
            {
                return getStyle("paddingLeft");
            }// end function
            , null, "containerGroup.paddingLeft");
            result[3] = new Binding(this, function () : Number
            {
                return getStyle("paddingRight");
            }// end function
            , null, "containerGroup.paddingRight");
            result[4] = new Binding(this, function () : Number
            {
                return getStyle("paddingTop");
            }// end function
            , null, "containerGroup.paddingTop");
            return result;
        }// end function

        public function get closeButton() : InfoWindowCloseButton
        {
            return this._312699062closeButton;
        }// end function

        public function set closeButton(value:InfoWindowCloseButton) : void
        {
            var _loc_2:* = this._312699062closeButton;
            if (_loc_2 !== value)
            {
                this._312699062closeButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "closeButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get containerGroup() : VGroup
        {
            return this._833446526containerGroup;
        }// end function

        public function set containerGroup(value:VGroup) : void
        {
            var _loc_2:* = this._833446526containerGroup;
            if (_loc_2 !== value)
            {
                this._833446526containerGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "containerGroup", _loc_2, value));
                }
            }
            return;
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

        public function get headerGroup() : HGroup
        {
            return this._1161933810headerGroup;
        }// end function

        public function set headerGroup(value:HGroup) : void
        {
            var _loc_2:* = this._1161933810headerGroup;
            if (_loc_2 !== value)
            {
                this._1161933810headerGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "headerGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get labelText() : InfoWindowLabel
        {
            return this._607740351labelText;
        }// end function

        public function set labelText(value:InfoWindowLabel) : void
        {
            var _loc_2:* = this._607740351labelText;
            if (_loc_2 !== value)
            {
                this._607740351labelText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelText", _loc_2, value));
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

        public function get hostComponent() : InfoWindow
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:InfoWindow) : void
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

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            _watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
