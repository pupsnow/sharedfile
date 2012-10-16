package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.containers.utilityClasses.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.layouts.*;

    public class AttributeInspectorRenderer extends ItemRenderer implements IBindingClient, IStateClient2
    {
        private var _264525383contentCol:ConstraintColumn;
        private var _809612678contentGroup:Group;
        private var _1959283220labelCol:ConstraintColumn;
        private var _3506583row1:ConstraintRow;
        private var __moduleFactoryInitialized:Boolean = false;
        private var log:ILogger;
        private var m_renderer:UIComponent;
        private var m_refreshRenderer:Boolean = false;
        private var m_refreshRendererData:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function AttributeInspectorRenderer()
        {
            var bindings:Array;
            var target:Object;
            var watcherSetupUtilClass:Object;
            this.log = Log.getLogger(getQualifiedClassName(this).replace("::", "."));
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            bindings = this._AttributeInspectorRenderer_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_AttributeInspectorRendererWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return AttributeInspectorRenderer[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.autoDrawBackground = false;
            this.hasFocusableChildren = true;
            this.layout = this._AttributeInspectorRenderer_FormItemLayout1_c();
            this.mxmlContent = [this._AttributeInspectorRenderer_Label1_i(), this._AttributeInspectorRenderer_Group1_i()];
            this.currentState = "normal";
            states = [new State({name:"normal", overrides:[]}), new State({name:"disabled", stateGroups:["disabledStates"], overrides:[]}), new State({name:"error", stateGroups:["errorStates"], overrides:[]})];
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
            var _loc_2:FormField = null;
            this.log.debug("{0}::data::{1}", this, value);
            if (data != value)
            {
                _loc_2 = data as FormField;
                if (_loc_2)
                {
                    _loc_2.removeEventListener(FormFieldEvent.DATA_CHANGE, this.handleFieldDataChange);
                    _loc_2.removeEventListener(FormFieldEvent.RENDERER_CHANGE, this.handleFieldRendererChange);
                }
                super.data = value;
                _loc_2 = data as FormField;
                if (_loc_2)
                {
                    _loc_2.addEventListener(FormFieldEvent.DATA_CHANGE, this.handleFieldDataChange, false, 0, true);
                    _loc_2.addEventListener(FormFieldEvent.RENDERER_CHANGE, this.handleFieldRendererChange, false, 0, true);
                }
                this.m_refreshRenderer = true;
                this.m_refreshRendererData = true;
                invalidateProperties();
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:FormField = null;
            var _loc_2:Object = null;
            super.commitProperties();
            if (!this.m_refreshRenderer)
            {
            }
            if (this.m_refreshRendererData)
            {
                _loc_1 = data as FormField;
                if (this.m_renderer)
                {
                }
                if (!this.m_refreshRendererData)
                {
                }
                if (this.m_renderer is IDataRenderer)
                {
                    _loc_2 = (this.m_renderer as IDataRenderer).data;
                }
                if (!this.m_refreshRenderer)
                {
                }
                if (this.m_refreshRendererData)
                {
                    _loc_1.updateRenderer(this.m_renderer);
                }
                else if (this.m_refreshRenderer)
                {
                    this.m_refreshRenderer = false;
                    if (this.m_renderer)
                    {
                        this.contentGroup.removeElement(this.m_renderer);
                        this.m_renderer = null;
                    }
                    if (_loc_1)
                    {
                        this.m_renderer = _loc_1.getRendererInstance();
                        if (this.m_renderer)
                        {
                            if (!this.m_refreshRendererData)
                            {
                                (this.m_renderer as IDataRenderer).data = _loc_2;
                            }
                            this.contentGroup.addElement(this.m_renderer);
                        }
                    }
                }
                this.m_refreshRenderer = false;
                this.m_refreshRendererData = false;
            }
            return;
        }// end function

        protected function handleFieldRendererChange(event:FormFieldEvent) : void
        {
            this.m_refreshRenderer = true;
            invalidateProperties();
            invalidateDisplayList();
            return;
        }// end function

        protected function handleFieldDataChange(event:FormFieldEvent) : void
        {
            this.m_refreshRendererData = true;
            invalidateProperties();
            invalidateDisplayList();
            return;
        }// end function

        private function _AttributeInspectorRenderer_FormItemLayout1_c() : FormItemLayout
        {
            var _loc_1:* = new FormItemLayout();
            new Vector.<ConstraintColumn>(2)[0] = this._AttributeInspectorRenderer_ConstraintColumn1_i();
            new Vector.<ConstraintColumn>(2)[1] = this._AttributeInspectorRenderer_ConstraintColumn2_i();
            _loc_1.constraintColumns = new Vector.<ConstraintColumn>(2);
            new Vector.<ConstraintRow>(1)[0] = this._AttributeInspectorRenderer_ConstraintRow1_i();
            _loc_1.constraintRows = new Vector.<ConstraintRow>(1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_ConstraintColumn1_i() : ConstraintColumn
        {
            var _loc_1:* = new ConstraintColumn();
            _loc_1.initialized(this, "labelCol");
            this.labelCol = _loc_1;
            BindingManager.executeBindings(this, "labelCol", this.labelCol);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_ConstraintColumn2_i() : ConstraintColumn
        {
            var _loc_1:* = new ConstraintColumn();
            _loc_1.percentWidth = 100;
            _loc_1.initialized(this, "contentCol");
            this.contentCol = _loc_1;
            BindingManager.executeBindings(this, "contentCol", this.contentCol);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_ConstraintRow1_i() : ConstraintRow
        {
            var _loc_1:* = new ConstraintRow();
            _loc_1.percentHeight = 100;
            _loc_1.baseline = "maxAscent:10";
            _loc_1.minHeight = 32;
            _loc_1.initialized(this, "row1");
            this.row1 = _loc_1;
            BindingManager.executeBindings(this, "row1", this.row1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.left = "labelCol:0";
            _loc_1.right = "labelCol:10";
            _loc_1.bottom = "row1:0";
            _loc_1.baseline = "row1:0";
            _loc_1.focusEnabled = false;
            _loc_1.setStyle("textAlign", "right");
            _loc_1.id = "labelDisplay";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            labelDisplay = _loc_1;
            BindingManager.executeBindings(this, "labelDisplay", labelDisplay);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.left = "contentCol:10";
            _loc_1.right = "contentCol:0";
            _loc_1.bottom = "row1:0";
            _loc_1.baseline = "row1:0";
            _loc_1.hasFocusableChildren = true;
            _loc_1.tabChildren = true;
            _loc_1.tabFocusEnabled = true;
            _loc_1.layout = this._AttributeInspectorRenderer_VerticalLayout1_c();
            _loc_1.id = "contentGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.contentGroup = _loc_1;
            BindingManager.executeBindings(this, "contentGroup", this.contentGroup);
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            return _loc_1;
        }// end function

        private function _AttributeInspectorRenderer_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = data.label;
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "labelDisplay.text");
            return result;
        }// end function

        public function get contentCol() : ConstraintColumn
        {
            return this._264525383contentCol;
        }// end function

        public function set contentCol(value:ConstraintColumn) : void
        {
            var _loc_2:* = this._264525383contentCol;
            if (_loc_2 !== value)
            {
                this._264525383contentCol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentCol", _loc_2, value));
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

        public function get labelCol() : ConstraintColumn
        {
            return this._1959283220labelCol;
        }// end function

        public function set labelCol(value:ConstraintColumn) : void
        {
            var _loc_2:* = this._1959283220labelCol;
            if (_loc_2 !== value)
            {
                this._1959283220labelCol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelCol", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get row1() : ConstraintRow
        {
            return this._3506583row1;
        }// end function

        public function set row1(value:ConstraintRow) : void
        {
            var _loc_2:* = this._3506583row1;
            if (_loc_2 !== value)
            {
                this._3506583row1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "row1", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            AttributeInspectorRenderer._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
