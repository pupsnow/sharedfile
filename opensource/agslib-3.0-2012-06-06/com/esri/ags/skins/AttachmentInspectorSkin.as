package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.skins.supportClasses.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.collections.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.effects.*;
    import spark.effects.animation.*;
    import spark.events.*;
    import spark.layouts.*;
    import spark.skins.spark.*;

    public class AttachmentInspectorSkin extends Skin implements IBindingClient, IStateClient2
    {
        public var _AttachmentInspectorSkin_HGroup1:HGroup;
        public var _AttachmentInspectorSkin_HGroup2:HGroup;
        public var _AttachmentInspectorSkin_Label1:Label;
        public var _AttachmentInspectorSkin_Label2:Label;
        public var _AttachmentInspectorSkin_Label3:Label;
        public var _AttachmentInspectorSkin_Label4:Label;
        public var _AttachmentInspectorSkin_SWFLoader1:SWFLoader;
        private var _484847821addButton:Button;
        private var _856935711animate:Animate;
        private var _1034195793attachmentInfoList:AttachmentInfoList;
        private var _51026477attachmentLayout:AttachmentLayout;
        private var _398731868browseButton:Button;
        private var _1990131276cancelButton:Button;
        private var _1060399231numberFormatter:NumberFormatter;
        private var _45423539simpleMotionPath:SimpleMotionPath;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _1097519085loader:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:AttachmentInspector;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function AttachmentInspectorSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._1097519085loader = AttachmentInspectorSkin_loader;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._AttachmentInspectorSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_AttachmentInspectorSkinWatcherSetupUtil");
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
            this.layout = this._AttachmentInspectorSkin_VerticalLayout1_c();
            this.mxmlContent = [];
            this.currentState = "normal";
            this._AttachmentInspectorSkin_Animate1_i();
            this._AttachmentInspectorSkin_NumberFormatter1_i();
            var _AttachmentInspectorSkin_AttachmentInfoList1_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_AttachmentInfoList1_i);
            var _AttachmentInspectorSkin_Button1_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_Button1_i);
            var _AttachmentInspectorSkin_HGroup1_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_HGroup1_i);
            var _AttachmentInspectorSkin_HGroup2_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_HGroup2_i);
            var _AttachmentInspectorSkin_Label1_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_Label1_i);
            var _AttachmentInspectorSkin_Label2_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_Label2_i);
            var _AttachmentInspectorSkin_SWFLoader1_factory:* = new DeferredInstanceFromFunction(this._AttachmentInspectorSkin_SWFLoader1_i);
            states = [new State({name:"normal", overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Button1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_AttachmentInfoList1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Button1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Label1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"attachmentInfoList", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"browseButton", name:"enabled", value:false})]}), new State({name:"queryAttachmentInfos", stateGroups:["queryAttachmentInfosGroup"], overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Button1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_SWFLoader1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"browseButton", name:"enabled", value:false})]}), new State({name:"queryAttachmentInfosWithList", stateGroups:["queryAttachmentInfosGroup"], overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Button1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_SWFLoader1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"attachmentLoaded", stateGroups:["loadState"], overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_HGroup2_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_HGroup1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_AttachmentInfoList1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"attachmentLoadedNoAttachmentsInList", stateGroups:["noAttachmentsState", "loadState"], overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_HGroup2_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_HGroup1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"noAttachmentsInList", stateGroups:["noAttachmentsState"], overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Button1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_AttachmentInspectorSkin_Label2_factory, destination:null, propertyName:"mxmlContent", position:"first"})]})];
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

        private function attachmentInfoList_caretChangeHandler(event:IndexChangeEvent) : void
        {
            var _loc_2:Point = null;
            var _loc_3:Number = NaN;
            if (event.newIndex != -1)
            {
                _loc_2 = this.attachmentInfoList.layout.getScrollPositionDeltaToElement(event.newIndex);
                _loc_3 = (Math.max(_loc_2.x, this.attachmentInfoList.layout.target.horizontalScrollPosition) - Math.min(_loc_2.x, this.attachmentInfoList.layout.target.horizontalScrollPosition)) * 4;
                this.simpleMotionPath.valueFrom = this.attachmentInfoList.layout.target.horizontalScrollPosition;
                this.simpleMotionPath.valueTo = _loc_2.x;
                this.animate.duration = _loc_3;
                this.animate.play();
                event.target.invalidateDisplayList();
            }
            return;
        }// end function

        private function attachmentInfoList_keyUpHandler(event:KeyboardEvent) : void
        {
            var _loc_2:AttachmentInfo = null;
            if (event.eventPhase === EventPhase.AT_TARGET)
            {
                if (event.keyCode !== 46)
                {
                }
            }
            if (event.keyCode === 8)
            {
            }
            if (this.hostComponent.deleteEnabled)
            {
            }
            if (this.hostComponent.featureLayer.isEditable)
            {
                _loc_2 = this.attachmentInfoList.selectedItem as AttachmentInfo;
                if (_loc_2)
                {
                    dispatchEvent(new AttachmentRemoveEvent(_loc_2));
                }
            }
            return;
        }// end function

        private function attachmentInfoList_clickHandler(event:MouseEvent) : void
        {
            var _loc_2:AttachmentInfo = null;
            var _loc_3:String = null;
            var _loc_4:AttachmentMouseEvent = null;
            if (!(event.target is Button))
            {
            }
            if (!(event.target is HScrollBar))
            {
                if (!(event.target is DataGroup))
                {
                    _loc_2 = this.attachmentInfoList.selectedItem as AttachmentInfo;
                    if (_loc_2)
                    {
                        _loc_3 = event.type === MouseEvent.CLICK ? (AttachmentMouseEvent.ATTACHMENT_CLICK) : (AttachmentMouseEvent.ATTACHMENT_DOUBLE_CLICK);
                        _loc_4 = new AttachmentMouseEvent(_loc_3, _loc_2);
                        _loc_4.copyProperties(event);
                        dispatchEvent(_loc_4);
                        this.attachmentInfoList.setFocus();
                    }
                }
                else
                {
                    this.attachmentInfoList.selectedIndex = -1;
                }
            }
            return;
        }// end function

        private function attachmentInfoList_addHandler() : void
        {
            this.attachmentInfoList.selectedIndex = 0;
            return;
        }// end function

        private function isAddingAttachmentAllowed(featureLayer:FeatureLayer) : Boolean
        {
            var _loc_2:Boolean = false;
            if (featureLayer.layerDetails is FeatureLayerDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureLayerDetails).isCreateAllowed;
            }
            else if (featureLayer.tableDetails is FeatureTableDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureTableDetails).isCreateAllowed;
            }
            if (!_loc_2)
            {
                _loc_2 = featureLayer.isUpdateAllowed(this.hostComponent.feature);
            }
            return _loc_2;
        }// end function

        private function _AttachmentInspectorSkin_Animate1_i() : Animate
        {
            var _loc_1:* = new Animate();
            new Vector.<MotionPath>(1)[0] = this._AttachmentInspectorSkin_SimpleMotionPath1_i();
            _loc_1.motionPaths = new Vector.<MotionPath>(1);
            this.animate = _loc_1;
            BindingManager.executeBindings(this, "animate", this.animate);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_SimpleMotionPath1_i() : SimpleMotionPath
        {
            var _loc_1:* = new SimpleMotionPath();
            _loc_1.property = "horizontalScrollPosition";
            this.simpleMotionPath = _loc_1;
            BindingManager.executeBindings(this, "simpleMotionPath", this.simpleMotionPath);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_NumberFormatter1_i() : NumberFormatter
        {
            var _loc_1:* = new NumberFormatter();
            _loc_1.precision = 2;
            _loc_1.rounding = "nearest";
            this.numberFormatter = _loc_1;
            BindingManager.executeBindings(this, "numberFormatter", this.numberFormatter);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            _loc_1.horizontalAlign = "center";
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_SWFLoader1_i() : SWFLoader
        {
            var _loc_1:* = new SWFLoader();
            _loc_1.setStyle("horizontalAlign", "center");
            _loc_1.id = "_AttachmentInspectorSkin_SWFLoader1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_SWFLoader1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_SWFLoader1", this._AttachmentInspectorSkin_SWFLoader1);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_AttachmentInfoList1_i() : AttachmentInfoList
        {
            var _loc_1:* = new AttachmentInfoList();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.doubleClickEnabled = true;
            _loc_1.itemRenderer = this._AttachmentInspectorSkin_ClassFactory1_c();
            _loc_1.minHeight = 140;
            _loc_1.minWidth = 200;
            _loc_1.useVirtualLayout = false;
            _loc_1.layout = this._AttachmentInspectorSkin_AttachmentLayout1_i();
            _loc_1.setStyle("skinClass", ListSkin);
            _loc_1.addEventListener("add", this.__attachmentInfoList_add);
            _loc_1.addEventListener("caretChange", this.__attachmentInfoList_caretChange);
            _loc_1.addEventListener("click", this.__attachmentInfoList_click);
            _loc_1.addEventListener("doubleClick", this.__attachmentInfoList_doubleClick);
            _loc_1.addEventListener("keyUp", this.__attachmentInfoList_keyUp);
            _loc_1.id = "attachmentInfoList";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.attachmentInfoList = _loc_1;
            BindingManager.executeBindings(this, "attachmentInfoList", this.attachmentInfoList);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_ClassFactory1_c() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = AttachmentRenderer;
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_AttachmentLayout1_i() : AttachmentLayout
        {
            var _loc_1:* = new AttachmentLayout();
            _loc_1.distance = 100;
            this.attachmentLayout = _loc_1;
            BindingManager.executeBindings(this, "attachmentLayout", this.attachmentLayout);
            return _loc_1;
        }// end function

        public function __attachmentInfoList_add(event:FlexEvent) : void
        {
            callLater(this.attachmentInfoList_addHandler);
            return;
        }// end function

        public function __attachmentInfoList_caretChange(event:IndexChangeEvent) : void
        {
            this.attachmentInfoList_caretChangeHandler(event);
            return;
        }// end function

        public function __attachmentInfoList_click(event:MouseEvent) : void
        {
            this.attachmentInfoList_clickHandler(event);
            return;
        }// end function

        public function __attachmentInfoList_doubleClick(event:MouseEvent) : void
        {
            this.attachmentInfoList_clickHandler(event);
            return;
        }// end function

        public function __attachmentInfoList_keyUp(event:KeyboardEvent) : void
        {
            this.attachmentInfoList_keyUpHandler(event);
            return;
        }// end function

        private function _AttachmentInspectorSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "_AttachmentInspectorSkin_Label1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_Label1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_Label1", this._AttachmentInspectorSkin_Label1);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "_AttachmentInspectorSkin_Label2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_Label2 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_Label2", this._AttachmentInspectorSkin_Label2);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.id = "browseButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.browseButton = _loc_1;
            BindingManager.executeBindings(this, "browseButton", this.browseButton);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_HGroup1_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._AttachmentInspectorSkin_Label3_i(), this._AttachmentInspectorSkin_Label4_i()];
            _loc_1.id = "_AttachmentInspectorSkin_HGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_HGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_HGroup1", this._AttachmentInspectorSkin_HGroup1);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Label3_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "_AttachmentInspectorSkin_Label3";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_Label3 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_Label3", this._AttachmentInspectorSkin_Label3);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Label4_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "_AttachmentInspectorSkin_Label4";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_Label4 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_Label4", this._AttachmentInspectorSkin_Label4);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_HGroup2_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._AttachmentInspectorSkin_Button2_i(), this._AttachmentInspectorSkin_Button3_i()];
            _loc_1.id = "_AttachmentInspectorSkin_HGroup2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentInspectorSkin_HGroup2 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentInspectorSkin_HGroup2", this._AttachmentInspectorSkin_HGroup2);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.id = "addButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.addButton = _loc_1;
            BindingManager.executeBindings(this, "addButton", this.addButton);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_Button3_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.id = "cancelButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.cancelButton = _loc_1;
            BindingManager.executeBindings(this, "cancelButton", this.cancelButton);
            return _loc_1;
        }// end function

        private function _AttachmentInspectorSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, null, null, "animate.target", "attachmentLayout");
            result[1] = new Binding(this, function () : Object
            {
                return loader;
            }// end function
            , null, "_AttachmentInspectorSkin_SWFLoader1.source");
            result[2] = new Binding(this, function () : IList
            {
                return hostComponent.attachmentInfos;
            }// end function
            , null, "attachmentInfoList.dataProvider");
            result[3] = new Binding(this, function () : Boolean
            {
                if (hostComponent.deleteEnabled)
                {
                }
                return hostComponent.featureLayer.isUpdateAllowed(hostComponent.feature);
            }// end function
            , null, "attachmentInfoList.deleteEnabled");
            result[4] = new Binding(this, function () : Boolean
            {
                return hostComponent.featureLayer.isEditable;
            }// end function
            , null, "attachmentInfoList.isEditable");
            result[5] = new Binding(this, function () : Number
            {
                return attachmentInfoList.selectedIndex;
            }// end function
            , null, "attachmentLayout.index");
            result[6] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attachmentInspectorNoAttachmentsSupported");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_AttachmentInspectorSkin_Label1.text");
            result[7] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attachmentInspectorNoAttachments");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_AttachmentInspectorSkin_Label2.text");
            result[8] = new Binding(this, function () : Boolean
            {
                if (hostComponent.featureLayer.isEditable)
                {
                }
                if (hostComponent.addEnabled)
                {
                }
                return isAddingAttachmentAllowed(hostComponent.featureLayer);
            }// end function
            , null, "browseButton.includeInLayout");
            result[9] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attachmentInspectorBrowseLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "browseButton.label");
            result[10] = new Binding(this, function () : Boolean
            {
                if (hostComponent.featureLayer.isEditable)
                {
                }
                if (hostComponent.addEnabled)
                {
                }
                return isAddingAttachmentAllowed(hostComponent.featureLayer);
            }// end function
            , null, "browseButton.visible");
            result[11] = new Binding(this, function () : String
            {
                var _loc_1:* = hostComponent.attachmentName;
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_AttachmentInspectorSkin_Label3.text");
            result[12] = new Binding(this, function () : String
            {
                var _loc_1:* = numberFormatter.format(hostComponent.attachmentSize / 1024) + " " + resourceManager.getString("ESRIMessages", "attachmentInspectorKiloBytes");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_AttachmentInspectorSkin_Label4.text");
            result[13] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attachmentInspectorAddLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "addButton.label");
            result[14] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "attachmentInspectorCancelLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "cancelButton.label");
            return result;
        }// end function

        public function get addButton() : Button
        {
            return this._484847821addButton;
        }// end function

        public function set addButton(value:Button) : void
        {
            var _loc_2:* = this._484847821addButton;
            if (_loc_2 !== value)
            {
                this._484847821addButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get animate() : Animate
        {
            return this._856935711animate;
        }// end function

        public function set animate(value:Animate) : void
        {
            var _loc_2:* = this._856935711animate;
            if (_loc_2 !== value)
            {
                this._856935711animate = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "animate", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get attachmentInfoList() : AttachmentInfoList
        {
            return this._1034195793attachmentInfoList;
        }// end function

        public function set attachmentInfoList(value:AttachmentInfoList) : void
        {
            var _loc_2:* = this._1034195793attachmentInfoList;
            if (_loc_2 !== value)
            {
                this._1034195793attachmentInfoList = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attachmentInfoList", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get attachmentLayout() : AttachmentLayout
        {
            return this._51026477attachmentLayout;
        }// end function

        public function set attachmentLayout(value:AttachmentLayout) : void
        {
            var _loc_2:* = this._51026477attachmentLayout;
            if (_loc_2 !== value)
            {
                this._51026477attachmentLayout = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attachmentLayout", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get browseButton() : Button
        {
            return this._398731868browseButton;
        }// end function

        public function set browseButton(value:Button) : void
        {
            var _loc_2:* = this._398731868browseButton;
            if (_loc_2 !== value)
            {
                this._398731868browseButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "browseButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get cancelButton() : Button
        {
            return this._1990131276cancelButton;
        }// end function

        public function set cancelButton(value:Button) : void
        {
            var _loc_2:* = this._1990131276cancelButton;
            if (_loc_2 !== value)
            {
                this._1990131276cancelButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cancelButton", _loc_2, value));
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

        public function get simpleMotionPath() : SimpleMotionPath
        {
            return this._45423539simpleMotionPath;
        }// end function

        public function set simpleMotionPath(value:SimpleMotionPath) : void
        {
            var _loc_2:* = this._45423539simpleMotionPath;
            if (_loc_2 !== value)
            {
                this._45423539simpleMotionPath = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "simpleMotionPath", _loc_2, value));
                }
            }
            return;
        }// end function

        private function get loader() : Class
        {
            return this._1097519085loader;
        }// end function

        private function set loader(value:Class) : void
        {
            var _loc_2:* = this._1097519085loader;
            if (_loc_2 !== value)
            {
                this._1097519085loader = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "loader", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : AttachmentInspector
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:AttachmentInspector) : void
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
