package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import flash.filters.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class ScaleBarUSSkin extends Skin implements IBindingClient
    {
        public var _ScaleBarUSSkin_Line1:Line;
        public var _ScaleBarUSSkin_Line2:Line;
        public var _ScaleBarUSSkin_Line3:Line;
        private var _102727412label:Label;
        private var _122811344solidColorStroke:SolidColorStroke;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:ScaleBar;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function ScaleBarUSSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._ScaleBarUSSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_ScaleBarUSSkinWatcherSetupUtil");
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
            this.minWidth = 200;
            this.filters = [this._ScaleBarUSSkin_GlowFilter1_c()];
            this.mxmlContent = [this._ScaleBarUSSkin_Line1_i(), this._ScaleBarUSSkin_Line2_i(), this._ScaleBarUSSkin_Line3_i(), this._ScaleBarUSSkin_Label1_i()];
            this._ScaleBarUSSkin_SolidColorStroke1_i();
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
            this.label.text = this.hostComponent.textUS;
            this.label.x = this.hostComponent.lengthUS - this.label.getExplicitOrMeasuredWidth() * 0.5;
            super.measure();
            return;
        }// end function

        private function _ScaleBarUSSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 0;
            _loc_1.weight = 2;
            this.solidColorStroke = _loc_1;
            BindingManager.executeBindings(this, "solidColorStroke", this.solidColorStroke);
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_GlowFilter1_c() : GlowFilter
        {
            var _loc_1:* = new GlowFilter();
            _loc_1.alpha = 1;
            _loc_1.blurX = 3;
            _loc_1.blurY = 3;
            _loc_1.color = 16777215;
            _loc_1.strength = 7;
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_Line1_i() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.xFrom = 0;
            _loc_1.xTo = 0;
            _loc_1.yFrom = 12;
            _loc_1.yTo = 20;
            _loc_1.initialized(this, "_ScaleBarUSSkin_Line1");
            this._ScaleBarUSSkin_Line1 = _loc_1;
            BindingManager.executeBindings(this, "_ScaleBarUSSkin_Line1", this._ScaleBarUSSkin_Line1);
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_Line2_i() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.xFrom = 0;
            _loc_1.yFrom = 20;
            _loc_1.yTo = 20;
            _loc_1.initialized(this, "_ScaleBarUSSkin_Line2");
            this._ScaleBarUSSkin_Line2 = _loc_1;
            BindingManager.executeBindings(this, "_ScaleBarUSSkin_Line2", this._ScaleBarUSSkin_Line2);
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_Line3_i() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.yFrom = 12;
            _loc_1.yTo = 20;
            _loc_1.initialized(this, "_ScaleBarUSSkin_Line3");
            this._ScaleBarUSSkin_Line3 = _loc_1;
            BindingManager.executeBindings(this, "_ScaleBarUSSkin_Line3", this._ScaleBarUSSkin_Line3);
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.y = 0;
            _loc_1.id = "label";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.label = _loc_1;
            BindingManager.executeBindings(this, "label", this.label);
            return _loc_1;
        }// end function

        private function _ScaleBarUSSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, null, null, "_ScaleBarUSSkin_Line1.stroke", "solidColorStroke");
            result[1] = new Binding(this, null, null, "_ScaleBarUSSkin_Line2.stroke", "solidColorStroke");
            result[2] = new Binding(this, function () : Number
            {
                return hostComponent.lengthUS;
            }// end function
            , null, "_ScaleBarUSSkin_Line2.xTo");
            result[3] = new Binding(this, null, null, "_ScaleBarUSSkin_Line3.stroke", "solidColorStroke");
            result[4] = new Binding(this, function () : Number
            {
                return hostComponent.lengthUS;
            }// end function
            , null, "_ScaleBarUSSkin_Line3.xFrom");
            result[5] = new Binding(this, function () : Number
            {
                return hostComponent.lengthUS;
            }// end function
            , null, "_ScaleBarUSSkin_Line3.xTo");
            result[6] = new Binding(this, function () : String
            {
                var _loc_1:* = getStyle("fontFamily");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , function (_sourceFunctionReturnValue:String) : void
            {
                label.setStyle("fontFamily", _sourceFunctionReturnValue);
                return;
            }// end function
            , "label.fontFamily");
            result[7] = new Binding(this, function () : Number
            {
                return getStyle("fontSize");
            }// end function
            , function (_sourceFunctionReturnValue:Number) : void
            {
                label.setStyle("fontSize", _sourceFunctionReturnValue);
                return;
            }// end function
            , "label.fontSize");
            result[8] = new Binding(this, function () : String
            {
                var _loc_1:* = getStyle("fontWeight");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , function (_sourceFunctionReturnValue:String) : void
            {
                label.setStyle("fontWeight", _sourceFunctionReturnValue);
                return;
            }// end function
            , "label.fontWeight");
            return result;
        }// end function

        public function get label() : Label
        {
            return this._102727412label;
        }// end function

        public function set label(value:Label) : void
        {
            var _loc_2:* = this._102727412label;
            if (_loc_2 !== value)
            {
                this._102727412label = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get solidColorStroke() : SolidColorStroke
        {
            return this._122811344solidColorStroke;
        }// end function

        public function set solidColorStroke(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._122811344solidColorStroke;
            if (_loc_2 !== value)
            {
                this._122811344solidColorStroke = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "solidColorStroke", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : ScaleBar
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:ScaleBar) : void
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
