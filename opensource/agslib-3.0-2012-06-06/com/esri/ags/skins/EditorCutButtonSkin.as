package com.esri.ags.skins
{
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class EditorCutButtonSkin extends SparkSkin implements IBindingClient, IStateClient2
    {
        private var _1677451127_EditorCutButtonSkin_GradientEntry1:GradientEntry;
        private var _1677451126_EditorCutButtonSkin_GradientEntry2:GradientEntry;
        public var _EditorCutButtonSkin_Rect1:Rect;
        public var _EditorCutButtonSkin_Rect2:Rect;
        public var _EditorCutButtonSkin_Rect3:Rect;
        public var _EditorCutButtonSkin_Rect4:Rect;
        public var _EditorCutButtonSkin_Rect5:Rect;
        public var _EditorCutButtonSkin_Rect6:Rect;
        public var _EditorCutButtonSkin_Rect7:Rect;
        private var _897344191_EditorCutButtonSkin_SolidColor1:SolidColor;
        private var _104387img:BitmapImage;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _583595847cornerRadius:Number = 2;
        private var _embed_mxml_____________assets_skins_EditCut16_png_995285847:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:ToggleButton;
        private static const exclusions:Array = ["img"];
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function EditorCutButtonSkin()
        {
            var bindings:Array;
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._embed_mxml_____________assets_skins_EditCut16_png_995285847 = EditorCutButtonSkin__embed_mxml_____________assets_skins_EditCut16_png_995285847;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            bindings = this._EditorCutButtonSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_EditorCutButtonSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return EditorCutButtonSkin[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.minHeight = 21;
            this.minWidth = 21;
            this.mxmlContent = [this._EditorCutButtonSkin_Rect1_i(), this._EditorCutButtonSkin_Rect7_i(), this._EditorCutButtonSkin_BitmapImage1_i()];
            this.currentState = "up";
            var _EditorCutButtonSkin_Rect2_factory:* = new DeferredInstanceFromFunction(this._EditorCutButtonSkin_Rect2_i);
            var _EditorCutButtonSkin_Rect3_factory:* = new DeferredInstanceFromFunction(this._EditorCutButtonSkin_Rect3_i);
            var _EditorCutButtonSkin_Rect4_factory:* = new DeferredInstanceFromFunction(this._EditorCutButtonSkin_Rect4_i);
            var _EditorCutButtonSkin_Rect5_factory:* = new DeferredInstanceFromFunction(this._EditorCutButtonSkin_Rect5_i);
            var _EditorCutButtonSkin_Rect6_factory:* = new DeferredInstanceFromFunction(this._EditorCutButtonSkin_Rect6_i);
            states = [new State({name:"up", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]})]}), new State({name:"over", stateGroups:["overStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry2", name:"color", value:9276813}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_SolidColor1", name:"alpha", value:0.12})]}), new State({name:"down", stateGroups:["downStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect6_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect5_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect4_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect3_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry2", name:"color", value:9276813})]}), new State({name:"disabled", stateGroups:["disabledStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({name:"alpha", value:0.3})]}), new State({name:"upAndSelected", stateGroups:["selectedStates", "selectedUpStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect6_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect5_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect4_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect3_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry2", name:"color", value:9276813}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_SolidColor1", name:"alpha", value:0.12})]}), new State({name:"overAndSelected", stateGroups:["selectedStates", "overStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect6_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect5_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect4_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect3_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry2", name:"color", value:9276813}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_SolidColor1", name:"alpha", value:0.12})]}), new State({name:"downAndSelected", stateGroups:["selectedStates", "downStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect6_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect5_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect4_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect3_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_GradientEntry2", name:"color", value:9276813})]}), new State({name:"disabledAndSelected", stateGroups:["selectedStates", "selectedUpStates", "disabledStates"], overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect6_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect5_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect4_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect3_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_EditorCutButtonSkin_Rect2_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_EditorCutButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({name:"alpha", value:0.3}), new SetProperty().initializeFromObject({target:"_EditorCutButtonSkin_SolidColor1", name:"alpha", value:0.12})]})];
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

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            var _loc_3:* = getStyle("cornerRadius");
            if (this.cornerRadius != _loc_3)
            {
                this.cornerRadius = _loc_3;
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _EditorCutButtonSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._EditorCutButtonSkin_LinearGradient1_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect1");
            this._EditorCutButtonSkin_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect1", this._EditorCutButtonSkin_Rect1);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_LinearGradient1_c() : LinearGradient
        {
            var _loc_1:* = new LinearGradient();
            _loc_1.rotation = 90;
            _loc_1.entries = [this._EditorCutButtonSkin_GradientEntry1_i(), this._EditorCutButtonSkin_GradientEntry2_i()];
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_GradientEntry1_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 16777215;
            this._EditorCutButtonSkin_GradientEntry1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_GradientEntry1", this._EditorCutButtonSkin_GradientEntry1);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_GradientEntry2_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 14474460;
            this._EditorCutButtonSkin_GradientEntry2 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_GradientEntry2", this._EditorCutButtonSkin_GradientEntry2);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect2_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 9;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.fill = this._EditorCutButtonSkin_SolidColor1_i();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect2");
            this._EditorCutButtonSkin_Rect2 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect2", this._EditorCutButtonSkin_Rect2);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.33;
            _loc_1.color = 16777215;
            this._EditorCutButtonSkin_SolidColor1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_SolidColor1", this._EditorCutButtonSkin_SolidColor1);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect3_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 1;
            _loc_1.left = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._EditorCutButtonSkin_SolidColor2_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect3");
            this._EditorCutButtonSkin_Rect3 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect3", this._EditorCutButtonSkin_Rect3);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColor2_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.4;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect4_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._EditorCutButtonSkin_SolidColor3_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect4");
            this._EditorCutButtonSkin_Rect4 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect4", this._EditorCutButtonSkin_Rect4);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColor3_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect5_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 1;
            _loc_1.left = 2;
            _loc_1.right = 2;
            _loc_1.top = 1;
            _loc_1.fill = this._EditorCutButtonSkin_SolidColor4_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect5");
            this._EditorCutButtonSkin_Rect5 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect5", this._EditorCutButtonSkin_Rect5);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColor4_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect6_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 1;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 2;
            _loc_1.fill = this._EditorCutButtonSkin_SolidColor5_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect6");
            this._EditorCutButtonSkin_Rect6 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect6", this._EditorCutButtonSkin_Rect6);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColor5_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_Rect7_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 38;
            _loc_1.height = 24;
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._EditorCutButtonSkin_SolidColorStroke1_c();
            _loc_1.initialized(this, "_EditorCutButtonSkin_Rect7");
            this._EditorCutButtonSkin_Rect7 = _loc_1;
            BindingManager.executeBindings(this, "_EditorCutButtonSkin_Rect7", this._EditorCutButtonSkin_Rect7);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_SolidColorStroke1_c() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 1250067;
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.left = 10;
            _loc_1.right = 10;
            _loc_1.top = 2;
            _loc_1.bottom = 2;
            _loc_1.horizontalCenter = 0;
            _loc_1.source = this._embed_mxml_____________assets_skins_EditCut16_png_995285847;
            _loc_1.verticalCenter = 0;
            _loc_1.initialized(this, "img");
            this.img = _loc_1;
            BindingManager.executeBindings(this, "img", this.img);
            return _loc_1;
        }// end function

        private function _EditorCutButtonSkin_bindingsSetup() : Array
        {
            var _loc_1:Array = [];
            _loc_1[0] = new Binding(this, null, null, "_EditorCutButtonSkin_Rect1.radiusX", "cornerRadius");
            _loc_1[1] = new Binding(this, null, null, "_EditorCutButtonSkin_Rect2.radiusX", "cornerRadius");
            _loc_1[2] = new Binding(this, null, null, "_EditorCutButtonSkin_Rect7.radiusX", "cornerRadius");
            return _loc_1;
        }// end function

        public function get _EditorCutButtonSkin_GradientEntry1() : GradientEntry
        {
            return this._1677451127_EditorCutButtonSkin_GradientEntry1;
        }// end function

        public function set _EditorCutButtonSkin_GradientEntry1(value:GradientEntry) : void
        {
            var _loc_2:* = this._1677451127_EditorCutButtonSkin_GradientEntry1;
            if (_loc_2 !== value)
            {
                this._1677451127_EditorCutButtonSkin_GradientEntry1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorCutButtonSkin_GradientEntry1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorCutButtonSkin_GradientEntry2() : GradientEntry
        {
            return this._1677451126_EditorCutButtonSkin_GradientEntry2;
        }// end function

        public function set _EditorCutButtonSkin_GradientEntry2(value:GradientEntry) : void
        {
            var _loc_2:* = this._1677451126_EditorCutButtonSkin_GradientEntry2;
            if (_loc_2 !== value)
            {
                this._1677451126_EditorCutButtonSkin_GradientEntry2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorCutButtonSkin_GradientEntry2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorCutButtonSkin_SolidColor1() : SolidColor
        {
            return this._897344191_EditorCutButtonSkin_SolidColor1;
        }// end function

        public function set _EditorCutButtonSkin_SolidColor1(value:SolidColor) : void
        {
            var _loc_2:* = this._897344191_EditorCutButtonSkin_SolidColor1;
            if (_loc_2 !== value)
            {
                this._897344191_EditorCutButtonSkin_SolidColor1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorCutButtonSkin_SolidColor1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get img() : BitmapImage
        {
            return this._104387img;
        }// end function

        public function set img(value:BitmapImage) : void
        {
            var _loc_2:* = this._104387img;
            if (_loc_2 !== value)
            {
                this._104387img = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "img", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get cornerRadius() : Number
        {
            return this._583595847cornerRadius;
        }// end function

        public function set cornerRadius(value:Number) : void
        {
            var _loc_2:* = this._583595847cornerRadius;
            if (_loc_2 !== value)
            {
                this._583595847cornerRadius = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cornerRadius", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : ToggleButton
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:ToggleButton) : void
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
            EditorCutButtonSkin._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
