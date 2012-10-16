package com.esri.ags.skins
{
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.filters.*;
    import spark.primitives.*;

    public class NavigationVSliderSkinInnerClass0 extends DataRenderer implements IBindingClient
    {
        private var _1184053038labelDisplay:Label;
        private var _88844982outerDocument:NavigationVSliderSkin;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function NavigationVSliderSkinInnerClass0()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._NavigationVSliderSkinInnerClass0_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_NavigationVSliderSkinInnerClass0WatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return NavigationVSliderSkinInnerClass0[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.x = 20;
            this.minHeight = 24;
            this.minWidth = 40;
            this.mxmlContent = [this._NavigationVSliderSkinInnerClass0_Rect1_c(), this._NavigationVSliderSkinInnerClass0_Label1_i()];
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

        private function _NavigationVSliderSkinInnerClass0_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.fill = this._NavigationVSliderSkinInnerClass0_SolidColor1_c();
            _loc_1.filters = [this._NavigationVSliderSkinInnerClass0_DropShadowFilter1_c()];
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _NavigationVSliderSkinInnerClass0_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.9;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _NavigationVSliderSkinInnerClass0_DropShadowFilter1_c() : DropShadowFilter
        {
            var _loc_1:* = new DropShadowFilter();
            _loc_1.angle = 90;
            _loc_1.color = 10066329;
            _loc_1.distance = 3;
            return _loc_1;
        }// end function

        private function _NavigationVSliderSkinInnerClass0_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.left = 5;
            _loc_1.right = 5;
            _loc_1.top = 5;
            _loc_1.bottom = 5;
            _loc_1.horizontalCenter = 0;
            _loc_1.verticalCenter = 1;
            _loc_1.setStyle("color", 16777215);
            _loc_1.setStyle("fontSize", 11);
            _loc_1.setStyle("fontWeight", "normal");
            _loc_1.setStyle("textAlign", "center");
            _loc_1.setStyle("verticalAlign", "middle");
            _loc_1.id = "labelDisplay";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.labelDisplay = _loc_1;
            BindingManager.executeBindings(this, "labelDisplay", this.labelDisplay);
            return _loc_1;
        }// end function

        private function _NavigationVSliderSkinInnerClass0_bindingsSetup() : Array
        {
            var _loc_1:Array = [];
            _loc_1[0] = new Binding(this, null, null, "labelDisplay.text", "data");
            return _loc_1;
        }// end function

        public function get labelDisplay() : Label
        {
            return this._1184053038labelDisplay;
        }// end function

        public function set labelDisplay(value:Label) : void
        {
            var _loc_2:* = this._1184053038labelDisplay;
            if (_loc_2 !== value)
            {
                this._1184053038labelDisplay = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelDisplay", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get outerDocument() : NavigationVSliderSkin
        {
            return this._88844982outerDocument;
        }// end function

        public function set outerDocument(value:NavigationVSliderSkin) : void
        {
            var _loc_2:* = this._88844982outerDocument;
            if (_loc_2 !== value)
            {
                this._88844982outerDocument = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outerDocument", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            NavigationVSliderSkinInnerClass0._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
