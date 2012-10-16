package com.esri.ags.skins.supportClasses
{
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class EditorDropDownListItemRenderer extends ItemRenderer implements IBindingClient, IStateClient2
    {
        private var _545079617_EditorDropDownListItemRenderer_Rect1:Rect;
        private var _643972744_EditorDropDownListItemRenderer_SetProperty1:SetProperty;
        private var _643972745_EditorDropDownListItemRenderer_SetProperty2:SetProperty;
        private var _643972746_EditorDropDownListItemRenderer_SetProperty3:SetProperty;
        private var _643972747_EditorDropDownListItemRenderer_SetProperty4:SetProperty;
        private var _643972748_EditorDropDownListItemRenderer_SetProperty5:SetProperty;
        private var _643972749_EditorDropDownListItemRenderer_SetProperty6:SetProperty;
        private var _272498133_EditorDropDownListItemRenderer_SolidColor1:SolidColor;
        public var _EditorDropDownListItemRenderer_SolidColorStroke1:SolidColorStroke;
        public var _EditorDropDownListItemRenderer_SolidColorStroke2:SolidColorStroke;
        public var _EditorDropDownListItemRenderer_SolidColorStroke3:SolidColorStroke;
        private var _881046205dropDownLabel:Label;
        private var _100313435image:BitmapImage;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function EditorDropDownListItemRenderer()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._EditorDropDownListItemRenderer_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_EditorDropDownListItemRendererWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return EditorDropDownListItemRenderer[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.name = "EditorDropDownListItemRenderer";
            this.focusEnabled = false;
            this.mxmlContent = [this._EditorDropDownListItemRenderer_Rect1_i(), this._EditorDropDownListItemRenderer_BitmapImage1_i(), this._EditorDropDownListItemRenderer_Label1_i()];
            this.currentState = "normal";
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty3 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty5 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty4 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            var _loc_2:* = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            this._EditorDropDownListItemRenderer_SetProperty6 = SetProperty(new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_SolidColor1", name:"color", value:undefined}));
            states = [new State({name:"normal", overrides:[_loc_2]}), new State({name:"hovered", overrides:[_loc_2]}), new State({name:"selected", overrides:[_loc_2]}), new State({name:"normalAndShowsCaret", overrides:[new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_Rect1", name:"stroke", value:this._EditorDropDownListItemRenderer_SolidColorStroke1_i()}), _loc_2]}), new State({name:"hoveredAndShowsCaret", overrides:[new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_Rect1", name:"stroke", value:this._EditorDropDownListItemRenderer_SolidColorStroke2_i()}), _loc_2]}), new State({name:"selectedAndShowsCaret", overrides:[new SetProperty().initializeFromObject({target:"_EditorDropDownListItemRenderer_Rect1", name:"stroke", value:this._EditorDropDownListItemRenderer_SolidColorStroke3_i()}), _loc_2]})];
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty3", this._EditorDropDownListItemRenderer_SetProperty3);
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty1", this._EditorDropDownListItemRenderer_SetProperty1);
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty5", this._EditorDropDownListItemRenderer_SetProperty5);
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty4", this._EditorDropDownListItemRenderer_SetProperty4);
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty2", this._EditorDropDownListItemRenderer_SetProperty2);
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SetProperty6", this._EditorDropDownListItemRenderer_SetProperty6);
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

        override public function set data(value:Object) : void
        {
            super.data = value;
            if (value)
            {
                this.image.source = value.icon;
            }
            return;
        }// end function

        override public function set label(value:String) : void
        {
            super.label = value;
            this.dropDownLabel.text = label;
            var _loc_2:* = resourceManager.getString("ESRIMessages", "editorNewSelectionLabel");
            var _loc_3:* = resourceManager.getString("ESRIMessages", "editorAddSelectionLabel");
            var _loc_4:* = resourceManager.getString("ESRIMessages", "editorSubtractSelectionLabel");
            switch(label)
            {
                case _loc_2:
                {
                    this.dropDownLabel.toolTip = resourceManager.getString("ESRIMessages", "editorNewSelectionTooltip");
                    break;
                }
                case _loc_3:
                {
                    this.dropDownLabel.toolTip = resourceManager.getString("ESRIMessages", "editorAddSelectionTooltip");
                    break;
                }
                case _loc_4:
                {
                    this.dropDownLabel.toolTip = resourceManager.getString("ESRIMessages", "editorSubtractSelectionTooltip");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _EditorDropDownListItemRenderer_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.fill = this._EditorDropDownListItemRenderer_SolidColor1_i();
            _loc_1.initialized(this, "_EditorDropDownListItemRenderer_Rect1");
            this._EditorDropDownListItemRenderer_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_Rect1", this._EditorDropDownListItemRenderer_Rect1);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this._EditorDropDownListItemRenderer_SolidColor1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SolidColor1", this._EditorDropDownListItemRenderer_SolidColor1);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.left = 3;
            _loc_1.verticalCenter = 0;
            _loc_1.initialized(this, "image");
            this.image = _loc_1;
            BindingManager.executeBindings(this, "image", this.image);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.left = 23;
            _loc_1.right = 3;
            _loc_1.top = 6;
            _loc_1.bottom = 4;
            _loc_1.verticalCenter = 0;
            _loc_1.id = "dropDownLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.dropDownLabel = _loc_1;
            BindingManager.executeBindings(this, "dropDownLabel", this.dropDownLabel);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.weight = 1;
            this._EditorDropDownListItemRenderer_SolidColorStroke1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SolidColorStroke1", this._EditorDropDownListItemRenderer_SolidColorStroke1);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_SolidColorStroke2_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.weight = 1;
            this._EditorDropDownListItemRenderer_SolidColorStroke2 = _loc_1;
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SolidColorStroke2", this._EditorDropDownListItemRenderer_SolidColorStroke2);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_SolidColorStroke3_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.weight = 1;
            this._EditorDropDownListItemRenderer_SolidColorStroke3 = _loc_1;
            BindingManager.executeBindings(this, "_EditorDropDownListItemRenderer_SolidColorStroke3", this._EditorDropDownListItemRenderer_SolidColorStroke3);
            return _loc_1;
        }// end function

        private function _EditorDropDownListItemRenderer_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : uint
            {
                return getStyle("selectionColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SolidColorStroke1.color");
            result[1] = new Binding(this, function () : uint
            {
                return getStyle("selectionColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SolidColorStroke2.color");
            result[2] = new Binding(this, function () : uint
            {
                return getStyle("selectionColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SolidColorStroke3.color");
            result[3] = new Binding(this, function ()
            {
                return getStyle("rollOverColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty1.value");
            result[4] = new Binding(this, function ()
            {
                return getStyle("rollOverColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty2.value");
            result[5] = new Binding(this, function ()
            {
                return getStyle("contentBackgroundColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty3.value");
            result[6] = new Binding(this, function ()
            {
                return getStyle("contentBackgroundColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty4.value");
            result[7] = new Binding(this, function ()
            {
                return getStyle("selectionColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty5.value");
            result[8] = new Binding(this, function ()
            {
                return getStyle("selectionColor");
            }// end function
            , null, "_EditorDropDownListItemRenderer_SetProperty6.value");
            return result;
        }// end function

        public function get _EditorDropDownListItemRenderer_Rect1() : Rect
        {
            return this._545079617_EditorDropDownListItemRenderer_Rect1;
        }// end function

        public function set _EditorDropDownListItemRenderer_Rect1(value:Rect) : void
        {
            var _loc_2:* = this._545079617_EditorDropDownListItemRenderer_Rect1;
            if (_loc_2 !== value)
            {
                this._545079617_EditorDropDownListItemRenderer_Rect1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_Rect1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty1() : SetProperty
        {
            return this._643972744_EditorDropDownListItemRenderer_SetProperty1;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty1(value:SetProperty) : void
        {
            var _loc_2:* = this._643972744_EditorDropDownListItemRenderer_SetProperty1;
            if (_loc_2 !== value)
            {
                this._643972744_EditorDropDownListItemRenderer_SetProperty1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty2() : SetProperty
        {
            return this._643972745_EditorDropDownListItemRenderer_SetProperty2;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty2(value:SetProperty) : void
        {
            var _loc_2:* = this._643972745_EditorDropDownListItemRenderer_SetProperty2;
            if (_loc_2 !== value)
            {
                this._643972745_EditorDropDownListItemRenderer_SetProperty2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty3() : SetProperty
        {
            return this._643972746_EditorDropDownListItemRenderer_SetProperty3;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty3(value:SetProperty) : void
        {
            var _loc_2:* = this._643972746_EditorDropDownListItemRenderer_SetProperty3;
            if (_loc_2 !== value)
            {
                this._643972746_EditorDropDownListItemRenderer_SetProperty3 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty3", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty4() : SetProperty
        {
            return this._643972747_EditorDropDownListItemRenderer_SetProperty4;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty4(value:SetProperty) : void
        {
            var _loc_2:* = this._643972747_EditorDropDownListItemRenderer_SetProperty4;
            if (_loc_2 !== value)
            {
                this._643972747_EditorDropDownListItemRenderer_SetProperty4 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty4", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty5() : SetProperty
        {
            return this._643972748_EditorDropDownListItemRenderer_SetProperty5;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty5(value:SetProperty) : void
        {
            var _loc_2:* = this._643972748_EditorDropDownListItemRenderer_SetProperty5;
            if (_loc_2 !== value)
            {
                this._643972748_EditorDropDownListItemRenderer_SetProperty5 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty5", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SetProperty6() : SetProperty
        {
            return this._643972749_EditorDropDownListItemRenderer_SetProperty6;
        }// end function

        public function set _EditorDropDownListItemRenderer_SetProperty6(value:SetProperty) : void
        {
            var _loc_2:* = this._643972749_EditorDropDownListItemRenderer_SetProperty6;
            if (_loc_2 !== value)
            {
                this._643972749_EditorDropDownListItemRenderer_SetProperty6 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SetProperty6", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorDropDownListItemRenderer_SolidColor1() : SolidColor
        {
            return this._272498133_EditorDropDownListItemRenderer_SolidColor1;
        }// end function

        public function set _EditorDropDownListItemRenderer_SolidColor1(value:SolidColor) : void
        {
            var _loc_2:* = this._272498133_EditorDropDownListItemRenderer_SolidColor1;
            if (_loc_2 !== value)
            {
                this._272498133_EditorDropDownListItemRenderer_SolidColor1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorDropDownListItemRenderer_SolidColor1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get dropDownLabel() : Label
        {
            return this._881046205dropDownLabel;
        }// end function

        public function set dropDownLabel(value:Label) : void
        {
            var _loc_2:* = this._881046205dropDownLabel;
            if (_loc_2 !== value)
            {
                this._881046205dropDownLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dropDownLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get image() : BitmapImage
        {
            return this._100313435image;
        }// end function

        public function set image(value:BitmapImage) : void
        {
            var _loc_2:* = this._100313435image;
            if (_loc_2 !== value)
            {
                this._100313435image = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "image", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            EditorDropDownListItemRenderer._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
