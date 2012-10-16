package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.layouts.*;
    import spark.skins.spark.mediaClasses.normal.*;

    public class TimeSliderSkin extends Skin implements IBindingClient, IStateClient2
    {
        private var _779770692dateFormatter:DateFormatter;
        private var _1749722107nextButton:Button;
        private var _1996635380playPauseButton:ToggleButton;
        private var _498435831previousButton:Button;
        private var _899647263slider:HSlider;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:TimeSlider;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function TimeSliderSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._TimeSliderSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_TimeSliderSkinWatcherSetupUtil");
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
            this.layout = this._TimeSliderSkin_HorizontalLayout1_c();
            this.mxmlContent = [this._TimeSliderSkin_ToggleButton1_i(), this._TimeSliderSkin_HSlider1_i(), this._TimeSliderSkin_Button1_i(), this._TimeSliderSkin_Button2_i()];
            this.currentState = "normal";
            this._TimeSliderSkin_DateFormatter1_i();
            states = [new State({name:"normal", overrides:[]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({target:"playPauseButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"slider", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"previousButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"nextButton", name:"enabled", value:false})]})];
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

        private function dataTipFormatter(value:Number) : String
        {
            return this.dateFormatter.format(this.hostComponent.timeStops[value]);
        }// end function

        private function _TimeSliderSkin_DateFormatter1_i() : DateFormatter
        {
            var _loc_1:* = new DateFormatter();
            _loc_1.formatString = "MMM D, YYYY at L:NN A";
            this.dateFormatter = _loc_1;
            BindingManager.executeBindings(this, "dateFormatter", this.dateFormatter);
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_HorizontalLayout1_c() : HorizontalLayout
        {
            var _loc_1:* = new HorizontalLayout();
            _loc_1.verticalAlign = "middle";
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_ToggleButton1_i() : ToggleButton
        {
            var _loc_1:* = new ToggleButton();
            _loc_1.setStyle("skinClass", PlayPauseButtonSkin);
            _loc_1.id = "playPauseButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.playPauseButton = _loc_1;
            BindingManager.executeBindings(this, "playPauseButton", this.playPauseButton);
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_HSlider1_i() : HSlider
        {
            var _loc_1:* = new HSlider();
            _loc_1.percentWidth = 100;
            _loc_1.dataTipFormatFunction = this.dataTipFormatter;
            _loc_1.tickInterval = 1;
            _loc_1.id = "slider";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.slider = _loc_1;
            BindingManager.executeBindings(this, "slider", this.slider);
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", TimeSliderPreviousButtonSkin);
            _loc_1.id = "previousButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.previousButton = _loc_1;
            BindingManager.executeBindings(this, "previousButton", this.previousButton);
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", TimeSliderNextButtonSkin);
            _loc_1.id = "nextButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.nextButton = _loc_1;
            BindingManager.executeBindings(this, "nextButton", this.nextButton);
            return _loc_1;
        }// end function

        private function _TimeSliderSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Boolean
            {
                return hostComponent.timeStops != null;
            }// end function
            , null, "slider.showDataTip");
            result[1] = new Binding(this, function () : Boolean
            {
                if (hostComponent.thumbCount == 1)
                {
                }
                return !hostComponent.singleThumbAsTimeInstant;
            }// end function
            , function (_sourceFunctionReturnValue:Boolean) : void
            {
                slider.setStyle("showTrackHighlight", _sourceFunctionReturnValue);
                return;
            }// end function
            , "slider.showTrackHighlight");
            return result;
        }// end function

        public function get dateFormatter() : DateFormatter
        {
            return this._779770692dateFormatter;
        }// end function

        public function set dateFormatter(value:DateFormatter) : void
        {
            var _loc_2:* = this._779770692dateFormatter;
            if (_loc_2 !== value)
            {
                this._779770692dateFormatter = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dateFormatter", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get nextButton() : Button
        {
            return this._1749722107nextButton;
        }// end function

        public function set nextButton(value:Button) : void
        {
            var _loc_2:* = this._1749722107nextButton;
            if (_loc_2 !== value)
            {
                this._1749722107nextButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nextButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get playPauseButton() : ToggleButton
        {
            return this._1996635380playPauseButton;
        }// end function

        public function set playPauseButton(value:ToggleButton) : void
        {
            var _loc_2:* = this._1996635380playPauseButton;
            if (_loc_2 !== value)
            {
                this._1996635380playPauseButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "playPauseButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get previousButton() : Button
        {
            return this._498435831previousButton;
        }// end function

        public function set previousButton(value:Button) : void
        {
            var _loc_2:* = this._498435831previousButton;
            if (_loc_2 !== value)
            {
                this._498435831previousButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "previousButton", _loc_2, value));
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

        public function get hostComponent() : TimeSlider
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:TimeSlider) : void
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
