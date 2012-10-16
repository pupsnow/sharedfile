package com.esri.ags.skins
{
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.events.*;
    import spark.layouts.*;
    import spark.primitives.*;
    import spark.skins.*;
    import spark.skins.spark.*;

    public class EditorSelectionDropDownListSkin extends SparkSkin implements IBindingClient, IStateClient2
    {
        public var _EditorSelectionDropDownListSkin_SolidColorStroke1:SolidColorStroke;
        private var _1332194002background:Rect;
        private var _1391998104bgFill:SolidColor;
        private var _1780559212bitmapImage:BitmapImage;
        private var _1383304148border:Rect;
        private var _385593099dataGroup:DataGroup;
        private var _433014735dropDown:Group;
        private var _906978543dropShadow:RectangularDropShadow;
        private var _137111012openButton:Button;
        private var _106851532popUp:PopUpAnchor;
        private var _402164678scroller:Scroller;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _770043015m_embed:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:DropDownList;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function EditorSelectionDropDownListSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._770043015m_embed = EditorSelectionDropDownListSkin_m_embed;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._EditorSelectionDropDownListSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_EditorSelectionDropDownListSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return EditorSelectionDropDownListSkin[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.mxmlContent = [this._EditorSelectionDropDownListSkin_Button1_i(), this._EditorSelectionDropDownListSkin_BitmapImage1_i()];
            this.currentState = "normal";
            this.addEventListener("initialize", this.___EditorSelectionDropDownListSkin_SparkSkin1_initialize);
            var _EditorSelectionDropDownListSkin_PopUpAnchor1_factory:* = new DeferredInstanceFromFunction(this._EditorSelectionDropDownListSkin_PopUpAnchor1_i, this._EditorSelectionDropDownListSkin_PopUpAnchor1_r);
            states = [new State({name:"normal", overrides:[new SetProperty().initializeFromObject({target:"popUp", name:"displayPopUp", value:false})]}), new State({name:"open", overrides:[new AddItems().initializeFromObject({destructionPolicy:"auto", itemsFactory:_EditorSelectionDropDownListSkin_PopUpAnchor1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"popUp", name:"displayPopUp", value:true})]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({name:"alpha", value:0.3})]})];
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

        protected function dropDownListSkin_initializeHandler(event:FlexEvent) : void
        {
            this.hostComponent.addEventListener(IndexChangeEvent.CHANGE, this.dropDownList_changeHandler);
            this.hostComponent.addEventListener(FlexEvent.VALUE_COMMIT, this.dropDownList_valueCommitHandler);
            return;
        }// end function

        private function dropDownList_valueCommitHandler(event:FlexEvent) : void
        {
            this.selectIcon();
            return;
        }// end function

        private function dropDownList_changeHandler(event:IndexChangeEvent) : void
        {
            this.selectIcon();
            return;
        }// end function

        private function selectIcon() : void
        {
            if (this.hostComponent.selectedItem)
            {
                this.bitmapImage.source = this.hostComponent.selectedItem.icon;
            }
            else
            {
                this.bitmapImage.source = this.m_embed;
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            if (getStyle("borderVisible") == false)
            {
                if (this.border)
                {
                    this.border.visible = false;
                }
                if (this.background)
                {
                    var _loc_3:int = 0;
                    this.background.bottom = 0;
                    var _loc_3:* = _loc_3;
                    this.background.right = _loc_3;
                    var _loc_3:* = _loc_3;
                    this.background.top = _loc_3;
                    this.background.left = _loc_3;
                }
                if (this.scroller)
                {
                    this.scroller.minViewportInset = 0;
                }
            }
            else
            {
                if (this.border)
                {
                    this.border.visible = true;
                }
                if (this.background)
                {
                    var _loc_3:int = 1;
                    this.background.bottom = 1;
                    var _loc_3:* = _loc_3;
                    this.background.right = _loc_3;
                    var _loc_3:* = _loc_3;
                    this.background.top = _loc_3;
                    this.background.left = _loc_3;
                }
                if (this.scroller)
                {
                    this.scroller.minViewportInset = 1;
                }
            }
            if (this.dropShadow)
            {
                this.dropShadow.visible = getStyle("dropShadowVisible");
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _EditorSelectionDropDownListSkin_PopUpAnchor1_i() : PopUpAnchor
        {
            var _loc_1:* = new PopUpAnchor();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.popUpPosition = "below";
            _loc_1.popUpWidthMatchesAnchorWidth = false;
            _loc_1.popUp = this._EditorSelectionDropDownListSkin_Group1_i();
            _loc_1.id = "popUp";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.popUp = _loc_1;
            BindingManager.executeBindings(this, "popUp", this.popUp);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_PopUpAnchor1_r() : void
        {
            var _loc_1:String = null;
            this.popUp = null;
            var _loc_1:String = null;
            this.dropDown = null;
            var _loc_1:String = null;
            this.dropShadow = null;
            var _loc_1:String = null;
            this.border = null;
            var _loc_1:String = null;
            this._EditorSelectionDropDownListSkin_SolidColorStroke1 = null;
            var _loc_1:String = null;
            this.background = null;
            var _loc_1:String = null;
            this.bgFill = null;
            var _loc_1:String = null;
            this.scroller = null;
            var _loc_1:String = null;
            this.dataGroup = null;
            return;
        }// end function

        private function _EditorSelectionDropDownListSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.maxHeight = 134;
            _loc_1.minHeight = 22;
            _loc_1.mxmlContent = [this._EditorSelectionDropDownListSkin_RectangularDropShadow1_i(), this._EditorSelectionDropDownListSkin_Rect1_i(), this._EditorSelectionDropDownListSkin_Rect2_i(), this._EditorSelectionDropDownListSkin_Scroller1_i()];
            _loc_1.id = "dropDown";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.dropDown = _loc_1;
            BindingManager.executeBindings(this, "dropDown", this.dropDown);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_RectangularDropShadow1_i() : RectangularDropShadow
        {
            var _loc_1:* = new RectangularDropShadow();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.alpha = 0.6;
            _loc_1.angle = 90;
            _loc_1.blurX = 20;
            _loc_1.blurY = 20;
            _loc_1.color = 0;
            _loc_1.distance = 5;
            _loc_1.id = "dropShadow";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.dropShadow = _loc_1;
            BindingManager.executeBindings(this, "dropShadow", this.dropShadow);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._EditorSelectionDropDownListSkin_SolidColorStroke1_i();
            _loc_1.initialized(this, "border");
            this.border = _loc_1;
            BindingManager.executeBindings(this, "border", this.border);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.weight = 1;
            this._EditorSelectionDropDownListSkin_SolidColorStroke1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSelectionDropDownListSkin_SolidColorStroke1", this._EditorSelectionDropDownListSkin_SolidColorStroke1);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_Rect2_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._EditorSelectionDropDownListSkin_SolidColor1_i();
            _loc_1.initialized(this, "background");
            this.background = _loc_1;
            BindingManager.executeBindings(this, "background", this.background);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 16777215;
            this.bgFill = _loc_1;
            BindingManager.executeBindings(this, "bgFill", this.bgFill);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_Scroller1_i() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.focusEnabled = false;
            _loc_1.minViewportInset = 1;
            _loc_1.viewport = this._EditorSelectionDropDownListSkin_DataGroup1_i();
            _loc_1.id = "scroller";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.scroller = _loc_1;
            BindingManager.executeBindings(this, "scroller", this.scroller);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_DataGroup1_i() : DataGroup
        {
            var _loc_1:* = new DataGroup();
            _loc_1.itemRenderer = this._EditorSelectionDropDownListSkin_ClassFactory1_c();
            _loc_1.layout = this._EditorSelectionDropDownListSkin_VerticalLayout1_c();
            _loc_1.id = "dataGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.dataGroup = _loc_1;
            BindingManager.executeBindings(this, "dataGroup", this.dataGroup);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_ClassFactory1_c() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = DefaultItemRenderer;
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            _loc_1.gap = 0;
            _loc_1.horizontalAlign = "contentJustify";
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.focusEnabled = false;
            _loc_1.setStyle("skinClass", DropDownListButtonSkin);
            _loc_1.id = "openButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.openButton = _loc_1;
            BindingManager.executeBindings(this, "openButton", this.openButton);
            return _loc_1;
        }// end function

        private function _EditorSelectionDropDownListSkin_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.left = 3;
            _loc_1.verticalCenter = 0;
            _loc_1.initialized(this, "bitmapImage");
            this.bitmapImage = _loc_1;
            BindingManager.executeBindings(this, "bitmapImage", this.bitmapImage);
            return _loc_1;
        }// end function

        public function ___EditorSelectionDropDownListSkin_SparkSkin1_initialize(event:FlexEvent) : void
        {
            this.dropDownListSkin_initializeHandler(event);
            return;
        }// end function

        private function _EditorSelectionDropDownListSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Number
            {
                return getStyle("borderAlpha");
            }// end function
            , null, "_EditorSelectionDropDownListSkin_SolidColorStroke1.alpha");
            result[1] = new Binding(this, function () : uint
            {
                return getStyle("borderColor");
            }// end function
            , null, "_EditorSelectionDropDownListSkin_SolidColorStroke1.color");
            result[2] = new Binding(this, function () : Number
            {
                return getStyle("cornerRadius");
            }// end function
            , function (_sourceFunctionReturnValue:Number) : void
            {
                openButton.setStyle("cornerRadius", _sourceFunctionReturnValue);
                return;
            }// end function
            , "openButton.cornerRadius");
            result[3] = new Binding(this, null, null, "bitmapImage.source", "m_embed");
            return result;
        }// end function

        public function get background() : Rect
        {
            return this._1332194002background;
        }// end function

        public function set background(value:Rect) : void
        {
            var _loc_2:* = this._1332194002background;
            if (_loc_2 !== value)
            {
                this._1332194002background = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "background", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get bgFill() : SolidColor
        {
            return this._1391998104bgFill;
        }// end function

        public function set bgFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1391998104bgFill;
            if (_loc_2 !== value)
            {
                this._1391998104bgFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "bgFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get bitmapImage() : BitmapImage
        {
            return this._1780559212bitmapImage;
        }// end function

        public function set bitmapImage(value:BitmapImage) : void
        {
            var _loc_2:* = this._1780559212bitmapImage;
            if (_loc_2 !== value)
            {
                this._1780559212bitmapImage = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "bitmapImage", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get border() : Rect
        {
            return this._1383304148border;
        }// end function

        public function set border(value:Rect) : void
        {
            var _loc_2:* = this._1383304148border;
            if (_loc_2 !== value)
            {
                this._1383304148border = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "border", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get dataGroup() : DataGroup
        {
            return this._385593099dataGroup;
        }// end function

        public function set dataGroup(value:DataGroup) : void
        {
            var _loc_2:* = this._385593099dataGroup;
            if (_loc_2 !== value)
            {
                this._385593099dataGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dataGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get dropDown() : Group
        {
            return this._433014735dropDown;
        }// end function

        public function set dropDown(value:Group) : void
        {
            var _loc_2:* = this._433014735dropDown;
            if (_loc_2 !== value)
            {
                this._433014735dropDown = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dropDown", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get dropShadow() : RectangularDropShadow
        {
            return this._906978543dropShadow;
        }// end function

        public function set dropShadow(value:RectangularDropShadow) : void
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

        public function get openButton() : Button
        {
            return this._137111012openButton;
        }// end function

        public function set openButton(value:Button) : void
        {
            var _loc_2:* = this._137111012openButton;
            if (_loc_2 !== value)
            {
                this._137111012openButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "openButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get popUp() : PopUpAnchor
        {
            return this._106851532popUp;
        }// end function

        public function set popUp(value:PopUpAnchor) : void
        {
            var _loc_2:* = this._106851532popUp;
            if (_loc_2 !== value)
            {
                this._106851532popUp = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "popUp", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get scroller() : Scroller
        {
            return this._402164678scroller;
        }// end function

        public function set scroller(value:Scroller) : void
        {
            var _loc_2:* = this._402164678scroller;
            if (_loc_2 !== value)
            {
                this._402164678scroller = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scroller", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get m_embed() : Class
        {
            return this._770043015m_embed;
        }// end function

        public function set m_embed(value:Class) : void
        {
            var _loc_2:* = this._770043015m_embed;
            if (_loc_2 !== value)
            {
                this._770043015m_embed = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_embed", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : DropDownList
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:DropDownList) : void
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
            EditorSelectionDropDownListSkin._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
