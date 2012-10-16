package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.layouts.*;

    public class ContentNavigatorSkin extends Skin implements IBindingClient, IStateClient2
    {
        public var _ContentNavigatorSkin_Label1:Label;
        private var _489174083_ContentNavigatorSkin_Label2:Label;
        private var _1925769653borderContainer:BorderContainer;
        private var _1824516047borderFill:SolidColor;
        private var _312699062closeButton:Button;
        private var _809612678contentGroup:Group;
        private var _1749722107nextButton:Button;
        private var _498435831previousButton:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:ContentNavigator;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function ContentNavigatorSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._ContentNavigatorSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_ContentNavigatorSkinWatcherSetupUtil");
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
            this.layout = this._ContentNavigatorSkin_VerticalLayout1_c();
            this.mxmlContent = [this._ContentNavigatorSkin_BorderContainer1_i(), this._ContentNavigatorSkin_Group1_i()];
            this.currentState = "normal";
            states = [new State({name:"normal", overrides:[]}), new State({name:"normalLabel", stateGroups:["labelState"], overrides:[]}), new State({name:"noPrevious", stateGroups:["noPreviousState"], overrides:[]}), new State({name:"noPreviousLabel", stateGroups:["noPreviousState", "labelState"], overrides:[]}), new State({name:"noNext", stateGroups:["noNextState"], overrides:[]}), new State({name:"noNextLabel", stateGroups:["noNextState", "labelState"], overrides:[]}), new State({name:"noNavigation", stateGroups:["noNextState", "noPreviousState", "noNavigationState"], overrides:[new SetProperty().initializeFromObject({target:"previousButton", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"_ContentNavigatorSkin_Label2", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"nextButton", name:"visible", value:false})]}), new State({name:"noNavigationLabel", stateGroups:["noNextState", "noPreviousState", "noNavigationState", "labelState"], overrides:[new SetProperty().initializeFromObject({target:"previousButton", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"_ContentNavigatorSkin_Label2", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"nextButton", name:"visible", value:false})]}), new State({name:"noContent", stateGroups:["noNextState", "noPreviousState", "noNavigationState"], overrides:[new SetProperty().initializeFromObject({target:"previousButton", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"_ContentNavigatorSkin_Label2", name:"visible", value:false}), new SetProperty().initializeFromObject({target:"nextButton", name:"visible", value:false})]}), new State({name:"disabled", overrides:[]})];
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

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            this.borderContainer.setStyle("color", getStyle("headerColor"));
            var _loc_3:* = getStyle("headerBackgroundColor");
            this.borderFill.color = isNaN(_loc_3) ? (0) : (_loc_3);
            var _loc_4:* = getStyle("headerBackgroundAlpha");
            this.borderFill.alpha = isNaN(_loc_4) ? (1) : (_loc_4);
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _ContentNavigatorSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_BorderContainer1_i() : BorderContainer
        {
            var _loc_1:* = new BorderContainer();
            _loc_1.percentWidth = 100;
            _loc_1.minHeight = 0;
            _loc_1.backgroundFill = this._ContentNavigatorSkin_SolidColor1_i();
            _loc_1.layout = this._ContentNavigatorSkin_HorizontalLayout1_c();
            _loc_1.mxmlContentFactory = new DeferredInstanceFromFunction(this._ContentNavigatorSkin_Array11_c);
            _loc_1.setStyle("borderVisible", false);
            _loc_1.id = "borderContainer";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.borderContainer = _loc_1;
            BindingManager.executeBindings(this, "borderContainer", this.borderContainer);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this.borderFill = _loc_1;
            BindingManager.executeBindings(this, "borderFill", this.borderFill);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_HorizontalLayout1_c() : HorizontalLayout
        {
            var _loc_1:* = new HorizontalLayout();
            _loc_1.paddingBottom = 3;
            _loc_1.paddingLeft = 3;
            _loc_1.paddingRight = 3;
            _loc_1.paddingTop = 3;
            _loc_1.verticalAlign = "middle";
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Array11_c() : Array
        {
            var _loc_1:Array = [this._ContentNavigatorSkin_Label1_i(), this._ContentNavigatorSkin_Button1_i(), this._ContentNavigatorSkin_Label2_i(), this._ContentNavigatorSkin_Button2_i(), this._ContentNavigatorSkin_Button3_i()];
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.maxDisplayedLines = 1;
            _loc_1.maxWidth = 300;
            _loc_1.minWidth = 20;
            _loc_1.showTruncationTip = true;
            _loc_1.id = "_ContentNavigatorSkin_Label1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._ContentNavigatorSkin_Label1 = _loc_1;
            BindingManager.executeBindings(this, "_ContentNavigatorSkin_Label1", this._ContentNavigatorSkin_Label1);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", ContentNavigatorPreviousButtonSkin);
            _loc_1.id = "previousButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.previousButton = _loc_1;
            BindingManager.executeBindings(this, "previousButton", this.previousButton);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.maxDisplayedLines = 1;
            _loc_1.id = "_ContentNavigatorSkin_Label2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._ContentNavigatorSkin_Label2 = _loc_1;
            BindingManager.executeBindings(this, "_ContentNavigatorSkin_Label2", this._ContentNavigatorSkin_Label2);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", ContentNavigatorNextButtonSkin);
            _loc_1.id = "nextButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.nextButton = _loc_1;
            BindingManager.executeBindings(this, "nextButton", this.nextButton);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Button3_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", ContentNavigatorCloseButtonSkin);
            _loc_1.id = "closeButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.closeButton = _loc_1;
            BindingManager.executeBindings(this, "closeButton", this.closeButton);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.mouseChildren = true;
            _loc_1.mouseEnabled = false;
            _loc_1.id = "contentGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.contentGroup = _loc_1;
            BindingManager.executeBindings(this, "contentGroup", this.contentGroup);
            return _loc_1;
        }// end function

        private function _ContentNavigatorSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = hostComponent.labelText;
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_ContentNavigatorSkin_Label1.text");
            result[1] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "previousButtonTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "previousButton.toolTip");
            result[2] = new Binding(this, function () : String
            {
                var _loc_1:* = (hostComponent.selectedIndex + 1) + " " + resourceManager.getString("ESRIMessages", "attributeInspectorOf") + " " + hostComponent.dataProvider.length;
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_ContentNavigatorSkin_Label2.text");
            result[3] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "nextButtonTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "nextButton.toolTip");
            result[4] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "closeButtonTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "closeButton.toolTip");
            return result;
        }// end function

        public function get _ContentNavigatorSkin_Label2() : Label
        {
            return this._489174083_ContentNavigatorSkin_Label2;
        }// end function

        public function set _ContentNavigatorSkin_Label2(value:Label) : void
        {
            var _loc_2:* = this._489174083_ContentNavigatorSkin_Label2;
            if (_loc_2 !== value)
            {
                this._489174083_ContentNavigatorSkin_Label2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_ContentNavigatorSkin_Label2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get borderContainer() : BorderContainer
        {
            return this._1925769653borderContainer;
        }// end function

        public function set borderContainer(value:BorderContainer) : void
        {
            var _loc_2:* = this._1925769653borderContainer;
            if (_loc_2 !== value)
            {
                this._1925769653borderContainer = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderContainer", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get borderFill() : SolidColor
        {
            return this._1824516047borderFill;
        }// end function

        public function set borderFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1824516047borderFill;
            if (_loc_2 !== value)
            {
                this._1824516047borderFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get closeButton() : Button
        {
            return this._312699062closeButton;
        }// end function

        public function set closeButton(value:Button) : void
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

        public function get hostComponent() : ContentNavigator
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:ContentNavigator) : void
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
