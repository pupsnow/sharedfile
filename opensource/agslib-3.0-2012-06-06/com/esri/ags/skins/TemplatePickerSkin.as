package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.skins.supportClasses.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.binding.utils.*;
    import mx.collections.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.events.*;
    import spark.layouts.*;
    import spark.primitives.*;

    public class TemplatePickerSkin extends Skin implements IBindingClient, IStateClient2
    {
        public var _TemplatePickerSkin_Rect1:Rect;
        public var _TemplatePickerSkin_SWFLoader1:SWFLoader;
        private var _1345339748_TemplatePickerSkin_Scroller1:Scroller;
        private var _3587215vGrp:VGroup;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _changeWatcher:ChangeWatcher;
        private var _templateCollectionChanged:Boolean;
        private var _selectedTemplateChanged:Boolean;
        private var _skinSelectedTemplate:Template;
        private var _currentList:List;
        private var _selectedTemplateChangeWatcher:ChangeWatcher;
        private var _templatePickerListItemRenderer:ClassFactory;
        private var _itemRenderer:TemplatePickerListItemRenderer;
        private var _1097519085loader:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:TemplatePicker;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function TemplatePickerSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._templatePickerListItemRenderer = new ClassFactory(TemplatePickerListItemRenderer);
            this._itemRenderer = new TemplatePickerListItemRenderer();
            this._1097519085loader = TemplatePickerSkin_loader;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._TemplatePickerSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_TemplatePickerSkinWatcherSetupUtil");
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
            this.mxmlContent = [];
            this.currentState = "normal";
            this.addEventListener("initialize", this.___TemplatePickerSkin_Skin1_initialize);
            var _TemplatePickerSkin_Rect1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSkin_Rect1_i);
            var _TemplatePickerSkin_SWFLoader1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSkin_SWFLoader1_i);
            var _TemplatePickerSkin_Scroller1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSkin_Scroller1_i);
            states = [new State({name:"normal", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSkin_Scroller1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_TemplatePickerSkin_Scroller1", name:"enabled", value:true})]}), new State({name:"loading", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSkin_SWFLoader1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSkin_Rect1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSkin_Scroller1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_TemplatePickerSkin_Scroller1", name:"enabled", value:true})]})];
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

        private function this_initializeHandler(event:FlexEvent) : void
        {
            this._changeWatcher = ChangeWatcher.watch(this.hostComponent, "templateCollection", this.templateCollectionChangeHandler);
            this._selectedTemplateChangeWatcher = ChangeWatcher.watch(this.hostComponent, "selectedTemplate", this.selectTemplateChangeWatcher);
            return;
        }// end function

        private function templateCollectionChangeHandler(event:Event = null) : void
        {
            invalidateProperties();
            this._templateCollectionChanged = true;
            return;
        }// end function

        private function selectTemplateChangeWatcher(event:Event = null) : void
        {
            invalidateProperties();
            this._selectedTemplateChanged = true;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:FeatureLayer = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:RegExp = null;
            var _loc_7:Label = null;
            var _loc_8:List = null;
            var _loc_9:TileLayout = null;
            super.commitProperties();
            if (this._templateCollectionChanged)
            {
                this._templateCollectionChanged = false;
                this.vGrp.removeAllElements();
                _loc_1 = 0;
                while (_loc_1 < this.hostComponent.templateCollection.length)
                {
                    
                    _loc_2 = this.hostComponent.templateCollection[_loc_1].featureLayer;
                    _loc_2.removeEventListener(FlexEvent.HIDE, this.featureLayer_hideShowHandler);
                    _loc_2.removeEventListener(FlexEvent.SHOW, this.featureLayer_hideShowHandler);
                    _loc_2.removeEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_isInScaleRangeChangeHandler);
                    _loc_2.addEventListener(FlexEvent.HIDE, this.featureLayer_hideShowHandler);
                    _loc_2.addEventListener(FlexEvent.SHOW, this.featureLayer_hideShowHandler);
                    _loc_2.addEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_isInScaleRangeChangeHandler);
                    _loc_4 = getQualifiedClassName(_loc_2);
                    _loc_5 = _loc_4.indexOf("::");
                    if (_loc_5 != -1)
                    {
                        _loc_4 = _loc_4.substr(_loc_5 + 2);
                    }
                    _loc_6 = new RegExp("^" + _loc_4 + "\\d*$", _loc_1);
                    if (_loc_2.name.search(_loc_6) != -1)
                    {
                        _loc_3 = _loc_2.layerDetails.name;
                    }
                    else
                    {
                        _loc_3 = _loc_2.name;
                    }
                    _loc_7 = new Label();
                    _loc_7.text = _loc_3;
                    _loc_7.setStyle("textDecoration", "underline");
                    _loc_7.setStyle("fontWeight", "bold");
                    _loc_7.setStyle("fontSize", 14);
                    this.vGrp.addElement(_loc_7);
                    _loc_8 = new List();
                    _loc_8.name = _loc_2.name;
                    _loc_8.addEventListener(IndexChangeEvent.CHANGE, this.listChangeHandler, false, -1, true);
                    _loc_8.dataProvider = new ArrayCollection(this.hostComponent.templateCollection[_loc_1].selectedTemplates);
                    _loc_8.itemRenderer = this._templatePickerListItemRenderer;
                    _loc_8.setStyle("borderVisible", false);
                    _loc_9 = new TileLayout();
                    _loc_9.verticalGap = 0;
                    _loc_9.horizontalGap = 0;
                    _loc_8.layout = _loc_9;
                    this.vGrp.addElement(_loc_8);
                    if (_loc_2.visible)
                    {
                    }
                    if (!_loc_2.isInScaleRange)
                    {
                        _loc_8.enabled = false;
                    }
                    _loc_1 = _loc_1 + 1;
                }
                invalidateDisplayList();
                this.selectTemplatFromList();
            }
            if (this._selectedTemplateChanged)
            {
                this._selectedTemplateChanged = false;
                this.selectTemplatFromList();
            }
            return;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            var _loc_3:int = 0;
            var _loc_5:Number = NaN;
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            var _loc_4:* = Math.floor(this.hostComponent.width / this._itemRenderer.width);
            _loc_4 = Math.floor(this.hostComponent.width / this._itemRenderer.width) < _loc_4 ? ((_loc_4 - 1)) : (_loc_4);
            if (this.vGrp)
            {
                _loc_5 = 0;
                while (_loc_5 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_5) is List)
                    {
                        List(this.vGrp.getElementAt(_loc_5)).percentWidth = 100;
                        _loc_3 = List(this.vGrp.getElementAt(_loc_5)).dataProvider.length;
                        if (_loc_3 <= _loc_4)
                        {
                            List(this.vGrp.getElementAt(_loc_5)).height = this._itemRenderer.height;
                        }
                        else
                        {
                            List(this.vGrp.getElementAt(_loc_5)).height = Math.ceil(_loc_3 / _loc_4) * this._itemRenderer.height;
                        }
                    }
                    _loc_5 = _loc_5 + 1;
                }
                this.vGrp.invalidateSize();
            }
            return;
        }// end function

        private function selectTemplatFromList() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (!this.hostComponent.templateCollection)
            {
            }
            else if (this.hostComponent.selectedTemplate == this._skinSelectedTemplate)
            {
            }
            else if (!this.hostComponent.selectedTemplate)
            {
                this._skinSelectedTemplate = null;
                _loc_1 = 0;
                while (_loc_1 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_1) is List)
                    {
                        if (List(this.vGrp.getElementAt(_loc_1)).selectedIndex != -1)
                        {
                            List(this.vGrp.getElementAt(_loc_1)).selectedIndex = -1;
                        }
                    }
                    _loc_1 = _loc_1 + 1;
                }
            }
            else
            {
                _loc_2 = 0;
                while (_loc_2 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_2) is List)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < List(this.vGrp.getElementAt(_loc_2)).dataProvider.length)
                        {
                            
                            if (List(this.vGrp.getElementAt(_loc_2)).dataProvider.getItemAt(_loc_3).featureLayer === this.hostComponent.selectedTemplate.featureLayer)
                            {
                            }
                            if (List(this.vGrp.getElementAt(_loc_2)).dataProvider.getItemAt(_loc_3).featureType === this.hostComponent.selectedTemplate.featureType)
                            {
                            }
                            if (List(this.vGrp.getElementAt(_loc_2)).dataProvider.getItemAt(_loc_3).featureTemplate === this.hostComponent.selectedTemplate.featureTemplate)
                            {
                                List(this.vGrp.getElementAt(_loc_2)).selectedIndex = _loc_3;
                                this._skinSelectedTemplate = this.hostComponent.selectedTemplate;
                            }
                            _loc_3 = _loc_3 + 1;
                        }
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        private function featureLayer_hideShowHandler(event:FlexEvent) : void
        {
            this.enableDisableList(event.target as FeatureLayer, false);
            return;
        }// end function

        private function featureLayer_isInScaleRangeChangeHandler(event:LayerEvent) : void
        {
            this.enableDisableList(event.target as FeatureLayer, true);
            return;
        }// end function

        private function enableDisableList(featureLayer:FeatureLayer, checkScaleRange:Boolean) : void
        {
            var _loc_4:List = null;
            var _loc_3:Number = 0;
            while (_loc_3 < this.vGrp.numElements)
            {
                
                if (this.vGrp.getElementAt(_loc_3) is List)
                {
                }
                if (List(this.vGrp.getElementAt(_loc_3)).name == featureLayer.name)
                {
                    _loc_4 = List(this.vGrp.getElementAt(_loc_3));
                    _loc_4.enabled = checkScaleRange ? (featureLayer.isInScaleRange) : (featureLayer.visible);
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function listChangeHandler(event:IndexChangeEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            this.vGrp.removeEventListener(MouseEvent.MOUSE_DOWN, this.vGrp_mouseDownHandler);
            callLater(this.addListener);
            if (event.newIndex != -1)
            {
                this._currentList = List(event.target);
                this._skinSelectedTemplate = List(event.target).selectedItem;
                this.hostComponent.selectedTemplate = this._skinSelectedTemplate;
                _loc_2 = 0;
                while (_loc_2 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_2) is List)
                    {
                        if (List(this.vGrp.getElementAt(_loc_2)) !== this._currentList)
                        {
                            List(this.vGrp.getElementAt(_loc_2)).selectedIndex = -1;
                        }
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            else if (this.hostComponent.selectedTemplate)
            {
                _loc_3 = 0;
                while (_loc_3 < this.vGrp.numElements)
                {
                    
                    if (this.vGrp.getElementAt(_loc_3) is List)
                    {
                        if (List(event.target) === this._currentList)
                        {
                            this._skinSelectedTemplate = null;
                            this.hostComponent.selectedTemplate = null;
                        }
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return;
        }// end function

        private function addListener() : void
        {
            this.vGrp.addEventListener(MouseEvent.MOUSE_DOWN, this.vGrp_mouseDownHandler);
            return;
        }// end function

        private function vGrp_mouseDownHandler(event:MouseEvent) : void
        {
            if (event.target is TemplatePickerListItemRenderer)
            {
                if (this.hostComponent.selectedTemplate)
                {
                }
                if (List(TemplatePickerListItemRenderer(event.target).owner).selectedItem == this.hostComponent.selectedTemplate)
                {
                    this.hostComponent.clearSelection();
                }
            }
            else
            {
                this.hostComponent.clearSelection();
            }
            return;
        }// end function

        private function _TemplatePickerSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 40;
            _loc_1.height = 40;
            _loc_1.horizontalCenter = 0;
            _loc_1.radiusX = 5;
            _loc_1.radiusY = 5;
            _loc_1.verticalCenter = 0;
            _loc_1.fill = this._TemplatePickerSkin_SolidColor1_c();
            _loc_1.initialized(this, "_TemplatePickerSkin_Rect1");
            this._TemplatePickerSkin_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSkin_Rect1", this._TemplatePickerSkin_Rect1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSkin_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 8421504;
            return _loc_1;
        }// end function

        private function _TemplatePickerSkin_SWFLoader1_i() : SWFLoader
        {
            var _loc_1:* = new SWFLoader();
            _loc_1.width = 30;
            _loc_1.height = 30;
            _loc_1.autoLoad = true;
            _loc_1.horizontalCenter = 0;
            _loc_1.scaleContent = true;
            _loc_1.verticalCenter = 0;
            _loc_1.id = "_TemplatePickerSkin_SWFLoader1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._TemplatePickerSkin_SWFLoader1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSkin_SWFLoader1", this._TemplatePickerSkin_SWFLoader1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSkin_Scroller1_i() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.focusEnabled = false;
            _loc_1.hasFocusableChildren = true;
            _loc_1.viewport = this._TemplatePickerSkin_VGroup1_i();
            _loc_1.setStyle("horizontalScrollPolicy", "auto");
            _loc_1.setStyle("verticalScrollPolicy", "auto");
            _loc_1.id = "_TemplatePickerSkin_Scroller1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._TemplatePickerSkin_Scroller1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSkin_Scroller1", this._TemplatePickerSkin_Scroller1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSkin_VGroup1_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.id = "vGrp";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.vGrp = _loc_1;
            BindingManager.executeBindings(this, "vGrp", this.vGrp);
            return _loc_1;
        }// end function

        public function ___TemplatePickerSkin_Skin1_initialize(event:FlexEvent) : void
        {
            this.this_initializeHandler(event);
            return;
        }// end function

        private function _TemplatePickerSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Object
            {
                return loader;
            }// end function
            , null, "_TemplatePickerSkin_SWFLoader1.source");
            return result;
        }// end function

        public function get _TemplatePickerSkin_Scroller1() : Scroller
        {
            return this._1345339748_TemplatePickerSkin_Scroller1;
        }// end function

        public function set _TemplatePickerSkin_Scroller1(value:Scroller) : void
        {
            var _loc_2:* = this._1345339748_TemplatePickerSkin_Scroller1;
            if (_loc_2 !== value)
            {
                this._1345339748_TemplatePickerSkin_Scroller1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_TemplatePickerSkin_Scroller1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get vGrp() : VGroup
        {
            return this._3587215vGrp;
        }// end function

        public function set vGrp(value:VGroup) : void
        {
            var _loc_2:* = this._3587215vGrp;
            if (_loc_2 !== value)
            {
                this._3587215vGrp = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "vGrp", _loc_2, value));
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

        public function get hostComponent() : TemplatePicker
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:TemplatePicker) : void
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
