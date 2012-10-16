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

    public class TemplatePickerSimpleSkin extends Skin implements IBindingClient, IStateClient2
    {
        public var _TemplatePickerSimpleSkin_Rect1:Rect;
        public var _TemplatePickerSimpleSkin_SWFLoader1:SWFLoader;
        private var _228152402_TemplatePickerSimpleSkin_Scroller1:Scroller;
        private var _3587215vGrp:VGroup;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _changeWatcher:ChangeWatcher;
        private var _templateCollectionChanged:Boolean;
        private var _selectedTemplateChanged:Boolean;
        private var _skinSelectedTemplate:Template;
        private var _selectedTemplateChangeWatcher:ChangeWatcher;
        private var _templatePickerListItemRenderer:ClassFactory;
        private var _itemRenderer:TemplatePickerListItemRenderer;
        private var _1097519085loader:Class;
        public var templateList:List;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:TemplatePicker;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function TemplatePickerSimpleSkin()
        {
            var bindings:Array;
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._templatePickerListItemRenderer = new ClassFactory(TemplatePickerListItemRenderer);
            this._itemRenderer = new TemplatePickerListItemRenderer();
            this._1097519085loader = TemplatePickerSimpleSkin_loader;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            bindings = this._TemplatePickerSimpleSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_TemplatePickerSimpleSkinWatcherSetupUtil");
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
            this.addEventListener("initialize", this.___TemplatePickerSimpleSkin_Skin1_initialize);
            var _TemplatePickerSimpleSkin_Rect1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSimpleSkin_Rect1_i);
            var _TemplatePickerSimpleSkin_SWFLoader1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSimpleSkin_SWFLoader1_i);
            var _TemplatePickerSimpleSkin_Scroller1_factory:* = new DeferredInstanceFromFunction(this._TemplatePickerSimpleSkin_Scroller1_i);
            states = [new State({name:"normal", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSimpleSkin_Scroller1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_TemplatePickerSimpleSkin_Scroller1", name:"enabled", value:true})]}), new State({name:"loading", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSimpleSkin_SWFLoader1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSimpleSkin_Rect1_factory, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_TemplatePickerSimpleSkin_Scroller1_factory, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"_TemplatePickerSimpleSkin_Scroller1", name:"enabled", value:true})]})];
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
            var _loc_1:Array = null;
            var _loc_2:Number = NaN;
            var _loc_3:TileLayout = null;
            var _loc_4:FeatureLayer = null;
            var _loc_5:Template = null;
            super.commitProperties();
            if (this._templateCollectionChanged)
            {
                this._templateCollectionChanged = false;
                this.vGrp.removeAllElements();
                _loc_1 = [];
                _loc_2 = 0;
                while (_loc_2 < this.hostComponent.templateCollection.length)
                {
                    
                    _loc_4 = this.hostComponent.templateCollection[_loc_2].featureLayer;
                    _loc_4.removeEventListener(FlexEvent.HIDE, this.featureLayer_hideShowHandler);
                    _loc_4.removeEventListener(FlexEvent.SHOW, this.featureLayer_hideShowHandler);
                    _loc_4.removeEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_hideShowHandler);
                    _loc_4.addEventListener(FlexEvent.HIDE, this.featureLayer_hideShowHandler);
                    _loc_4.addEventListener(FlexEvent.SHOW, this.featureLayer_hideShowHandler);
                    _loc_4.addEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_hideShowHandler);
                    for each (_loc_5 in this.hostComponent.templateCollection[_loc_2].selectedTemplates)
                    {
                        
                        _loc_1.push(_loc_5);
                    }
                    _loc_2 = _loc_2 + 1;
                }
                this.templateList = new List();
                this.templateList.addEventListener(IndexChangeEvent.CHANGE, this.templateList_changeHandler, false, -1, true);
                this.templateList.dataProvider = new ArrayCollection(_loc_1);
                this.templateList.itemRenderer = this._templatePickerListItemRenderer;
                this.templateList.setStyle("borderVisible", false);
                _loc_3 = new TileLayout();
                _loc_3.verticalGap = 0;
                _loc_3.horizontalGap = 0;
                this.templateList.layout = _loc_3;
                this.vGrp.addElement(this.templateList);
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
            var _loc_4:int = 0;
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (this.vGrp)
            {
            }
            if (this.vGrp.numElements > 0)
            {
                this.templateList = List(this.vGrp.getElementAt(0));
                this.templateList.percentWidth = 100;
                _loc_3 = this.templateList.dataProvider.length;
                _loc_4 = Math.floor(this.hostComponent.width / this._itemRenderer.width);
                if (_loc_3 <= _loc_4)
                {
                    this.templateList.height = this._itemRenderer.height;
                }
                else
                {
                    this.templateList.height = Math.ceil(_loc_3 / _loc_4) * this._itemRenderer.height;
                }
                this.vGrp.invalidateSize();
            }
            return;
        }// end function

        private function selectTemplatFromList() : void
        {
            var _loc_1:Number = NaN;
            if (!this.hostComponent.templateCollection)
            {
            }
            else if (this.hostComponent.selectedTemplate == this._skinSelectedTemplate)
            {
            }
            else if (!this.hostComponent.selectedTemplate)
            {
                this._skinSelectedTemplate = null;
                this.templateList.selectedIndex = -1;
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < this.templateList.dataProvider.length)
                {
                    
                    if (this.templateList.dataProvider.getItemAt(_loc_1).featureLayer === this.hostComponent.selectedTemplate.featureLayer)
                    {
                    }
                    if (this.templateList.dataProvider.getItemAt(_loc_1).featureType === this.hostComponent.selectedTemplate.featureType)
                    {
                    }
                    if (this.templateList.dataProvider.getItemAt(_loc_1).featureTemplate === this.hostComponent.selectedTemplate.featureTemplate)
                    {
                        this.templateList.selectedIndex = _loc_1;
                        this._skinSelectedTemplate = this.hostComponent.selectedTemplate;
                    }
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

        private function featureLayer_hideShowHandler(event:Event) : void
        {
            var _loc_2:Number = 0;
            while (_loc_2 < this.templateList.dataProvider.length)
            {
                
                if (this.templateList.dataProvider.getItemAt(_loc_2).featureLayer === event.target)
                {
                    this.templateList.dataProvider.getItemAt(_loc_2).dispatchEvent(new Event(Event.CHANGE));
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function templateList_changeHandler(event:IndexChangeEvent) : void
        {
            if (this.templateList.selectedItem.featureLayer.visible)
            {
            }
            if (!this.templateList.selectedItem.featureLayer.isInScaleRange)
            {
                event.preventDefault();
            }
            else
            {
                this.templateList.removeEventListener(MouseEvent.MOUSE_DOWN, this.templateList_mouseDownHandler);
                callLater(this.addListener);
                if (event.newIndex != -1)
                {
                    this._skinSelectedTemplate = this.templateList.selectedItem;
                    this.hostComponent.selectedTemplate = this._skinSelectedTemplate;
                }
                else if (this.hostComponent.selectedTemplate)
                {
                    this._skinSelectedTemplate = null;
                    this.hostComponent.selectedTemplate = null;
                }
            }
            return;
        }// end function

        private function addListener() : void
        {
            this.templateList.addEventListener(MouseEvent.MOUSE_DOWN, this.templateList_mouseDownHandler);
            return;
        }// end function

        private function templateList_mouseDownHandler(event:MouseEvent) : void
        {
            if (List(event.currentTarget).selectedItem == this.hostComponent.selectedTemplate)
            {
                List(event.currentTarget).selectedIndex = -1;
            }
            return;
        }// end function

        private function _TemplatePickerSimpleSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 40;
            _loc_1.height = 40;
            _loc_1.horizontalCenter = 0;
            _loc_1.radiusX = 5;
            _loc_1.radiusY = 5;
            _loc_1.verticalCenter = 0;
            _loc_1.fill = this._TemplatePickerSimpleSkin_SolidColor1_c();
            _loc_1.initialized(this, "_TemplatePickerSimpleSkin_Rect1");
            this._TemplatePickerSimpleSkin_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSimpleSkin_Rect1", this._TemplatePickerSimpleSkin_Rect1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSimpleSkin_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 8421504;
            return _loc_1;
        }// end function

        private function _TemplatePickerSimpleSkin_SWFLoader1_i() : SWFLoader
        {
            var _loc_1:* = new SWFLoader();
            _loc_1.width = 30;
            _loc_1.height = 30;
            _loc_1.autoLoad = true;
            _loc_1.horizontalCenter = 0;
            _loc_1.scaleContent = true;
            _loc_1.verticalCenter = 0;
            _loc_1.id = "_TemplatePickerSimpleSkin_SWFLoader1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._TemplatePickerSimpleSkin_SWFLoader1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSimpleSkin_SWFLoader1", this._TemplatePickerSimpleSkin_SWFLoader1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSimpleSkin_Scroller1_i() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.focusEnabled = false;
            _loc_1.hasFocusableChildren = true;
            _loc_1.viewport = this._TemplatePickerSimpleSkin_VGroup1_i();
            _loc_1.setStyle("horizontalScrollPolicy", "auto");
            _loc_1.setStyle("verticalScrollPolicy", "auto");
            _loc_1.id = "_TemplatePickerSimpleSkin_Scroller1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._TemplatePickerSimpleSkin_Scroller1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerSimpleSkin_Scroller1", this._TemplatePickerSimpleSkin_Scroller1);
            return _loc_1;
        }// end function

        private function _TemplatePickerSimpleSkin_VGroup1_i() : VGroup
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

        public function ___TemplatePickerSimpleSkin_Skin1_initialize(event:FlexEvent) : void
        {
            this.this_initializeHandler(event);
            return;
        }// end function

        private function _TemplatePickerSimpleSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Object
            {
                return loader;
            }// end function
            , null, "_TemplatePickerSimpleSkin_SWFLoader1.source");
            return result;
        }// end function

        public function get _TemplatePickerSimpleSkin_Scroller1() : Scroller
        {
            return this._228152402_TemplatePickerSimpleSkin_Scroller1;
        }// end function

        public function set _TemplatePickerSimpleSkin_Scroller1(value:Scroller) : void
        {
            var _loc_2:* = this._228152402_TemplatePickerSimpleSkin_Scroller1;
            if (_loc_2 !== value)
            {
                this._228152402_TemplatePickerSimpleSkin_Scroller1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_TemplatePickerSimpleSkin_Scroller1", _loc_2, value));
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
