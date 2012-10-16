package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import com.esri.ags.skins.supportClasses.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.layouts.*;

    public class AttributeInspectorSkin extends Skin implements IBindingClient, IStateClient2
    {
        public var _AttributeInspectorSkin_HGroup1:HGroup;
        public var _AttributeInspectorSkin_Label1:Label;
        private var _1245745987deleteButton:Button;
        private var _1020183064editSummaryLabel:Label;
        private var _3322014list:List;
        private var _1749722107nextButton:Button;
        private var _1641788370okButton:Button;
        private var _498435831previousButton:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:AttributeInspector;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function AttributeInspectorSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._AttributeInspectorSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_AttributeInspectorSkinWatcherSetupUtil");
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
            this.layout = this._AttributeInspectorSkin_VerticalLayout1_c();
            this.mxmlContent = [this._AttributeInspectorSkin_HGroup1_i(), this._AttributeInspectorSkin_List1_i(), this._AttributeInspectorSkin_Label2_i(), this._AttributeInspectorSkin_HGroup2_c()];
            this.currentState = "normal";
            states = [new State({name:"normal", overrides:[]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({target:"previousButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"nextButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"list", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"editSummaryLabel", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"deleteButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"okButton", name:"enabled", value:false})]}), new State({name:"invalid", overrides:[]})];
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

        private function _AttributeInspectorSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            _loc_1.horizontalAlign = "center";
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_HGroup1_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.gap = 8;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._AttributeInspectorSkin_Button1_i(), this._AttributeInspectorSkin_Label1_i(), this._AttributeInspectorSkin_Button2_i()];
            _loc_1.id = "_AttributeInspectorSkin_HGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttributeInspectorSkin_HGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorSkin_HGroup1", this._AttributeInspectorSkin_HGroup1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", AttributeInspectorPreviousButtonSkin);
            _loc_1.id = "previousButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.previousButton = _loc_1;
            BindingManager.executeBindings(this, "previousButton", this.previousButton);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("fontSize", 14);
            _loc_1.setStyle("fontWeight", "bold");
            _loc_1.setStyle("textAlign", "center");
            _loc_1.id = "_AttributeInspectorSkin_Label1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttributeInspectorSkin_Label1 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorSkin_Label1", this._AttributeInspectorSkin_Label1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("skinClass", AttributeInspectorNextButtonSkin);
            _loc_1.id = "nextButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.nextButton = _loc_1;
            BindingManager.executeBindings(this, "nextButton", this.nextButton);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_List1_i() : List
        {
            var _loc_1:List = null;
            _loc_1 = new List();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.hasFocusableChildren = true;
            _loc_1.itemRenderer = this._AttributeInspectorSkin_ClassFactory1_c();
            _loc_1.useVirtualLayout = false;
            _loc_1.layout = this._AttributeInspectorSkin_FormLayout1_c();
            _loc_1.setStyle("borderVisible", false);
            _loc_1.setStyle("horizontalScrollPolicy", "off");
            _loc_1.setStyle("verticalScrollPolicy", "auto");
            _loc_1.id = "list";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.list = _loc_1;
            BindingManager.executeBindings(this, "list", this.list);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_ClassFactory1_c() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = AttributeInspectorRenderer;
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_FormLayout1_c() : FormLayout
        {
            var _loc_1:* = new FormLayout();
            _loc_1.gap = 0;
            _loc_1.paddingBottom = 10;
            _loc_1.paddingLeft = 10;
            _loc_1.paddingRight = 10;
            _loc_1.paddingTop = 10;
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("fontStyle", "italic");
            _loc_1.id = "editSummaryLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.editSummaryLabel = _loc_1;
            BindingManager.executeBindings(this, "editSummaryLabel", this.editSummaryLabel);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_HGroup2_c() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._AttributeInspectorSkin_Button3_i(), this._AttributeInspectorSkin_Button4_i()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Button3_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.buttonMode = true;
            _loc_1.setStyle("skinClass", AttributeInspectorDeleteButtonSkin);
            _loc_1.id = "deleteButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.deleteButton = _loc_1;
            BindingManager.executeBindings(this, "deleteButton", this.deleteButton);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_Button4_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.id = "okButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.okButton = _loc_1;
            BindingManager.executeBindings(this, "okButton", this.okButton);
            return _loc_1;
        }// end function

        private function _AttributeInspectorSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Boolean
            {
                return hostComponent.numFeatures > 1;
            }// end function
            , null, "_AttributeInspectorSkin_HGroup1.includeInLayout");
            result[1] = new Binding(this, function () : Boolean
            {
                return hostComponent.numFeatures > 1;
            }// end function
            , null, "_AttributeInspectorSkin_HGroup1.visible");
            result[2] = new Binding(this, function () : String
            {
                var _loc_1:* = (hostComponent.activeFeatureIndex + 1) + " " + resourceManager.getString("ESRIMessages", "attributeInspectorOf") + " " + hostComponent.numFeatures;
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_AttributeInspectorSkin_Label1.text");
            result[3] = new Binding(this, function () : Number
            {
                return hostComponent.getStyle("formMaxHeight");
            }// end function
            , null, "list.maxHeight");
            result[4] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attributeInspectorDeleteLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "deleteButton.label");
            result[5] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attributeInspectorOkLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "okButton.label");
            return result;
        }// end function

        public function get deleteButton() : Button
        {
            return this._1245745987deleteButton;
        }// end function

        public function set deleteButton(value:Button) : void
        {
            var _loc_2:* = this._1245745987deleteButton;
            if (_loc_2 !== value)
            {
                this._1245745987deleteButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get editSummaryLabel() : Label
        {
            return this._1020183064editSummaryLabel;
        }// end function

        public function set editSummaryLabel(value:Label) : void
        {
            var _loc_2:* = this._1020183064editSummaryLabel;
            if (_loc_2 !== value)
            {
                this._1020183064editSummaryLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "editSummaryLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get list() : List
        {
            return this._3322014list;
        }// end function

        public function set list(value:List) : void
        {
            var _loc_2:* = this._3322014list;
            if (_loc_2 !== value)
            {
                this._3322014list = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "list", _loc_2, value));
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

        public function get okButton() : Button
        {
            return this._1641788370okButton;
        }// end function

        public function set okButton(value:Button) : void
        {
            var _loc_2:* = this._1641788370okButton;
            if (_loc_2 !== value)
            {
                this._1641788370okButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "okButton", _loc_2, value));
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

        public function get hostComponent() : AttributeInspector
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:AttributeInspector) : void
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
