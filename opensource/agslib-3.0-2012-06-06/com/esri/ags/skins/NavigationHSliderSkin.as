package com.esri.ags.skins
{
    import flash.display.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.skins.*;
    import spark.skins.spark.*;

    public class NavigationHSliderSkin extends SparkSkin implements IBindingClient, IStateClient2
    {
        private var _1443184785dataTip:ClassFactory;
        private var _110342614thumb:Button;
        private var _110355062ticks:UIComponent;
        private var _110621003track:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:HSlider;
        private static const exclusions:Array = ["track", "thumb"];
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function NavigationHSliderSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._NavigationHSliderSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_NavigationHSliderSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return NavigationHSliderSkin[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.minHeight = 11;
            this.mxmlContent = [this._NavigationHSliderSkin_UIComponent1_i(), this._NavigationHSliderSkin_Button1_i(), this._NavigationHSliderSkin_Button2_i()];
            this.currentState = "normal";
            this._NavigationHSliderSkin_ClassFactory1_i();
            states = [new State({name:"normal", overrides:[]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({name:"alpha", value:0.5})]})];
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

        override public function get colorizeExclusions() : Array
        {
            return exclusions;
        }// end function

        override protected function initializationComplete() : void
        {
            useChromeColor = true;
            super.initializationComplete();
            return;
        }// end function

        override protected function measure() : void
        {
            var _loc_1:* = this.thumb.getLayoutBoundsX();
            this.thumb.setLayoutBoundsPosition(0, this.thumb.getLayoutBoundsY());
            super.measure();
            this.thumb.setLayoutBoundsPosition(_loc_1, this.thumb.getLayoutBoundsY());
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            this.drawTicks();
            return;
        }// end function

        private function drawTicks() : void
        {
            var _loc_7:Number = NaN;
            var _loc_1:* = getStyle("symbolColor");
            var _loc_2:Number = 1;
            var _loc_3:Number = 3;
            var _loc_4:Number = -3;
            var _loc_5:Number = 1;
            var _loc_6:* = this.ticks.graphics;
            var _loc_8:* = this.hostComponent.minimum;
            _loc_6.clear();
            if (_loc_2 > 0)
            {
                _loc_6.lineStyle(_loc_5, _loc_1);
                do
                {
                    
                    _loc_7 = Math.round(this.getXFromValue(_loc_8));
                    _loc_6.moveTo(_loc_7, 0);
                    _loc_6.lineTo(_loc_7, _loc_3);
                    _loc_8 = _loc_2 + _loc_8;
                }while (_loc_8 < this.hostComponent.maximum)
                _loc_7 = Math.round(this.getMaxX());
                _loc_6.moveTo(_loc_7, 0);
                _loc_6.lineTo(_loc_7, _loc_3);
                this.ticks.height = _loc_3 - _loc_4;
            }
            return;
        }// end function

        private function getXFromValue(v:Number) : Number
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = this.getMaxX();
            var _loc_3:* = this.getMinX();
            if (v == this.hostComponent.minimum)
            {
                _loc_4 = _loc_3;
            }
            else if (v == this.hostComponent.maximum)
            {
                _loc_4 = _loc_2;
            }
            else
            {
                _loc_4 = _loc_3 + (this.hostComponent.maximum - v) * (_loc_2 - _loc_3) / (this.hostComponent.maximum - this.hostComponent.minimum);
            }
            return _loc_4;
        }// end function

        private function getMinX() : Number
        {
            return this.thumb.width / 2;
        }// end function

        private function getMaxX() : Number
        {
            return width - this.thumb.width / 2;
        }// end function

        private function _NavigationHSliderSkin_ClassFactory1_i() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = NavigationHSliderSkinInnerClass0;
            _loc_1.properties = {outerDocument:this};
            this.dataTip = _loc_1;
            BindingManager.executeBindings(this, "dataTip", this.dataTip);
            return _loc_1;
        }// end function

        private function _NavigationHSliderSkin_UIComponent1_i() : UIComponent
        {
            var _loc_1:* = new UIComponent();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.id = "ticks";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.ticks = _loc_1;
            BindingManager.executeBindings(this, "ticks", this.ticks);
            return _loc_1;
        }// end function

        private function _NavigationHSliderSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 100;
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.bottom = 0;
            _loc_1.minWidth = 33;
            _loc_1.setStyle("skinClass", HSliderTrackSkin);
            _loc_1.id = "track";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.track = _loc_1;
            BindingManager.executeBindings(this, "track", this.track);
            return _loc_1;
        }// end function

        private function _NavigationHSliderSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 11;
            _loc_1.height = 11;
            _loc_1.bottom = 0;
            _loc_1.setStyle("skinClass", HSliderThumbSkin);
            _loc_1.id = "thumb";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.thumb = _loc_1;
            BindingManager.executeBindings(this, "thumb", this.thumb);
            return _loc_1;
        }// end function

        private function _NavigationHSliderSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Object
            {
                return ticks.height;
            }// end function
            , null, "track.top");
            result[1] = new Binding(this, function () : Object
            {
                return ticks.height;
            }// end function
            , null, "thumb.top");
            return result;
        }// end function

        public function get dataTip() : ClassFactory
        {
            return this._1443184785dataTip;
        }// end function

        public function set dataTip(value:ClassFactory) : void
        {
            var _loc_2:* = this._1443184785dataTip;
            if (_loc_2 !== value)
            {
                this._1443184785dataTip = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dataTip", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get thumb() : Button
        {
            return this._110342614thumb;
        }// end function

        public function set thumb(value:Button) : void
        {
            var _loc_2:* = this._110342614thumb;
            if (_loc_2 !== value)
            {
                this._110342614thumb = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumb", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get ticks() : UIComponent
        {
            return this._110355062ticks;
        }// end function

        public function set ticks(value:UIComponent) : void
        {
            var _loc_2:* = this._110355062ticks;
            if (_loc_2 !== value)
            {
                this._110355062ticks = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ticks", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get track() : Button
        {
            return this._110621003track;
        }// end function

        public function set track(value:Button) : void
        {
            var _loc_2:* = this._110621003track;
            if (_loc_2 !== value)
            {
                this._110621003track = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "track", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : HSlider
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:HSlider) : void
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
            NavigationHSliderSkin._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
