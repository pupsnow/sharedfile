package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class NavigationHorizontalSkin extends Skin implements IBindingClient, IStateClient2
    {
        private var _176943407_NavigationHorizontalSkin_HGroup1:HGroup;
        private var _1060399231numberFormatter:NumberFormatter;
        private var _899647263slider:HSlider;
        private var _406320554zoomInButton:Button;
        private var _1032333709zoomOutButton:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:Navigation;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function NavigationHorizontalSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._NavigationHorizontalSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_NavigationHorizontalSkinWatcherSetupUtil");
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
            this.mxmlContent = [this._NavigationHorizontalSkin_Rect1_c(), this._NavigationHorizontalSkin_HGroup1_i()];
            this.currentState = "normal";
            this._NavigationHorizontalSkin_NumberFormatter1_i();
            var _NavigationHorizontalSkin_HSlider1_factory:* = new DeferredInstanceFromFunction(this._NavigationHorizontalSkin_HSlider1_i);
            states = [new State({name:"normal", overrides:[]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({target:"zoomOutButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"slider", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"zoomInButton", name:"enabled", value:false})]}), new State({name:"normalWithSlider", overrides:[new AddItems().initializeFromObject({itemsFactory:_NavigationHorizontalSkin_HSlider1_factory, destination:"_NavigationHorizontalSkin_HGroup1", propertyName:"mxmlContent", position:"after", relativeTo:["zoomOutButton"]}), new SetProperty().initializeFromObject({target:"slider", name:"enabled", value:true})]}), new State({name:"disabledWithSlider", overrides:[new AddItems().initializeFromObject({itemsFactory:_NavigationHorizontalSkin_HSlider1_factory, destination:"_NavigationHorizontalSkin_HGroup1", propertyName:"mxmlContent", position:"after", relativeTo:["zoomOutButton"]}), new SetProperty().initializeFromObject({target:"zoomOutButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"slider", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"zoomInButton", name:"enabled", value:false})]})];
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

        private function formatSliderDataTip(value:Number) : String
        {
            var _loc_2:* = this.hostComponent.map.lods[value];
            return _loc_2 ? ("1:" + this.numberFormatter.format(_loc_2.scale)) : (resourceManager.getString("ESRIMessages", "navigationError"));
        }// end function

        private function _NavigationHorizontalSkin_NumberFormatter1_i() : NumberFormatter
        {
            var _loc_1:* = new NumberFormatter();
            _loc_1.rounding = "nearest";
            this.numberFormatter = _loc_1;
            BindingManager.executeBindings(this, "numberFormatter", this.numberFormatter);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.radiusX = 10;
            _loc_1.radiusY = 10;
            _loc_1.fill = this._NavigationHorizontalSkin_SolidColor1_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.5;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_HGroup1_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.gap = 7;
            _loc_1.paddingBottom = 5;
            _loc_1.paddingLeft = 3;
            _loc_1.paddingRight = 3;
            _loc_1.paddingTop = 4;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._NavigationHorizontalSkin_Button1_i(), this._NavigationHorizontalSkin_Button2_i()];
            _loc_1.id = "_NavigationHorizontalSkin_HGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._NavigationHorizontalSkin_HGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_NavigationHorizontalSkin_HGroup1", this._NavigationHorizontalSkin_HGroup1);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", NavigationZoomOutButtonSkin);
            _loc_1.id = "zoomOutButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.zoomOutButton = _loc_1;
            BindingManager.executeBindings(this, "zoomOutButton", this.zoomOutButton);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_HSlider1_i() : HSlider
        {
            var _loc_1:* = new HSlider();
            _loc_1.dataTipFormatFunction = this.formatSliderDataTip;
            _loc_1.showDataTip = true;
            _loc_1.snapInterval = 1;
            _loc_1.setStyle("liveDragging", false);
            _loc_1.setStyle("skinClass", NavigationHSliderSkin);
            _loc_1.id = "slider";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.slider = _loc_1;
            BindingManager.executeBindings(this, "slider", this.slider);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", NavigationZoomInButtonSkin);
            _loc_1.id = "zoomInButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.zoomInButton = _loc_1;
            BindingManager.executeBindings(this, "zoomInButton", this.zoomInButton);
            return _loc_1;
        }// end function

        private function _NavigationHorizontalSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "zoomOutTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "zoomOutButton.toolTip");
            result[1] = new Binding(this, function () : Number
            {
                return hostComponent.map.level;
            }// end function
            , null, "slider.value");
            result[2] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "zoomInTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "zoomInButton.toolTip");
            return result;
        }// end function

        public function get _NavigationHorizontalSkin_HGroup1() : HGroup
        {
            return this._176943407_NavigationHorizontalSkin_HGroup1;
        }// end function

        public function set _NavigationHorizontalSkin_HGroup1(value:HGroup) : void
        {
            var _loc_2:* = this._176943407_NavigationHorizontalSkin_HGroup1;
            if (_loc_2 !== value)
            {
                this._176943407_NavigationHorizontalSkin_HGroup1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_NavigationHorizontalSkin_HGroup1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get numberFormatter() : NumberFormatter
        {
            return this._1060399231numberFormatter;
        }// end function

        public function set numberFormatter(value:NumberFormatter) : void
        {
            var _loc_2:* = this._1060399231numberFormatter;
            if (_loc_2 !== value)
            {
                this._1060399231numberFormatter = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numberFormatter", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get slider() : HSlider
        {
            return this._899647263slider;
        }// end function

        public function set slider(value:HSlider) : void
        {
            var _loc_2:* = this._899647263slider;
            if (_loc_2 !== value)
            {
                this._899647263slider = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slider", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get zoomInButton() : Button
        {
            return this._406320554zoomInButton;
        }// end function

        public function set zoomInButton(value:Button) : void
        {
            var _loc_2:* = this._406320554zoomInButton;
            if (_loc_2 !== value)
            {
                this._406320554zoomInButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoomInButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get zoomOutButton() : Button
        {
            return this._1032333709zoomOutButton;
        }// end function

        public function set zoomOutButton(value:Button) : void
        {
            var _loc_2:* = this._1032333709zoomOutButton;
            if (_loc_2 !== value)
            {
                this._1032333709zoomOutButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoomOutButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : Navigation
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:Navigation) : void
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
