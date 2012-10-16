package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import flash.utils.*;
    import flashx.textLayout.formats.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class TemplatePickerListItemRenderer extends ItemRenderer implements IStateClient2
    {
        private var _806444053_TemplatePickerListItemRenderer_SolidColor1:SolidColor;
        private var _109038013_TemplatePickerListItemRenderer_SolidColorStroke1:SolidColorStroke;
        private var _809612678contentGroup:Group;
        private var _198148454templateLabel:Label;
        private var __moduleFactoryInitialized:Boolean = false;
        private var m_featureLayerToDynamicMapServiceLayer:Dictionary;

        public function TemplatePickerListItemRenderer()
        {
            this.m_featureLayerToDynamicMapServiceLayer = new Dictionary();
            mx_internal::_document = this;
            this.name = "TemplatePickerListItemRenderer";
            this.width = 80;
            this.height = 80;
            this.focusEnabled = false;
            this.mouseChildren = false;
            this.mxmlContent = [this._TemplatePickerListItemRenderer_Rect1_c(), this._TemplatePickerListItemRenderer_Group1_i(), this._TemplatePickerListItemRenderer_Label1_i()];
            this.currentState = "normal";
            states = [new State({name:"normal", overrides:[new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColor1", name:"color", value:16777215})]}), new State({name:"hovered", overrides:[new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColorStroke1", name:"color", value:0}), new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColor1", name:"color", value:13689072})]}), new State({name:"selected", overrides:[new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColorStroke1", name:"color", value:0}), new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColorStroke1", name:"weight", value:3}), new SetProperty().initializeFromObject({target:"_TemplatePickerListItemRenderer_SolidColor1", name:"color", value:16777215})]})];
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
            var _loc_2:String = null;
            super.data = value;
            value.addEventListener(Event.CHANGE, this.changeEventHandler);
            this.contentGroup.removeAllElements();
            this.templateLabel.setStyle("textAlign", TextAlign.CENTER);
            if (value.featureTemplate)
            {
                this.templateLabel.text = value.featureTemplate.name;
                toolTip = value.featureTemplate.description != "" ? (value.featureTemplate.name + ": " + value.featureTemplate.description) : (value.featureTemplate.name);
                _loc_2 = value.featureTemplate.drawingTool;
            }
            var _loc_3:* = value.symbol;
            if (_loc_3)
            {
                this.contentGroup.addElement(IVisualElement(_loc_3.createSwatch(this.contentGroup.width, this.contentGroup.height, _loc_2)));
            }
            else
            {
                enabled = false;
            }
            if (List(owner).enabled)
            {
                if (value.featureLayer.visible)
                {
                }
            }
            if (!value.featureLayer.isInScaleRange)
            {
                enabled = false;
            }
            return;
        }// end function

        private function changeEventHandler(event:Event) : void
        {
            if (event.target.featureLayer.visible)
            {
            }
            enabled = !event.target.featureLayer.isInScaleRange ? (false) : (true);
            return;
        }// end function

        private function _TemplatePickerListItemRenderer_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._TemplatePickerListItemRenderer_SolidColorStroke1_i();
            _loc_1.fill = this._TemplatePickerListItemRenderer_SolidColor1_i();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _TemplatePickerListItemRenderer_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 16777215;
            _loc_1.weight = 2;
            this._TemplatePickerListItemRenderer_SolidColorStroke1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerListItemRenderer_SolidColorStroke1", this._TemplatePickerListItemRenderer_SolidColorStroke1);
            return _loc_1;
        }// end function

        private function _TemplatePickerListItemRenderer_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this._TemplatePickerListItemRenderer_SolidColor1 = _loc_1;
            BindingManager.executeBindings(this, "_TemplatePickerListItemRenderer_SolidColor1", this._TemplatePickerListItemRenderer_SolidColor1);
            return _loc_1;
        }// end function

        private function _TemplatePickerListItemRenderer_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.width = 60;
            _loc_1.height = 40;
            _loc_1.left = 10;
            _loc_1.right = 10;
            _loc_1.top = 5;
            _loc_1.bottom = 35;
            _loc_1.id = "contentGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.contentGroup = _loc_1;
            BindingManager.executeBindings(this, "contentGroup", this.contentGroup);
            return _loc_1;
        }// end function

        private function _TemplatePickerListItemRenderer_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.width = 40;
            _loc_1.height = 40;
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 50;
            _loc_1.bottom = 0;
            _loc_1.maxDisplayedLines = 2;
            _loc_1.id = "templateLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.templateLabel = _loc_1;
            BindingManager.executeBindings(this, "templateLabel", this.templateLabel);
            return _loc_1;
        }// end function

        public function get _TemplatePickerListItemRenderer_SolidColor1() : SolidColor
        {
            return this._806444053_TemplatePickerListItemRenderer_SolidColor1;
        }// end function

        public function set _TemplatePickerListItemRenderer_SolidColor1(value:SolidColor) : void
        {
            var _loc_2:* = this._806444053_TemplatePickerListItemRenderer_SolidColor1;
            if (_loc_2 !== value)
            {
                this._806444053_TemplatePickerListItemRenderer_SolidColor1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_TemplatePickerListItemRenderer_SolidColor1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _TemplatePickerListItemRenderer_SolidColorStroke1() : SolidColorStroke
        {
            return this._109038013_TemplatePickerListItemRenderer_SolidColorStroke1;
        }// end function

        public function set _TemplatePickerListItemRenderer_SolidColorStroke1(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._109038013_TemplatePickerListItemRenderer_SolidColorStroke1;
            if (_loc_2 !== value)
            {
                this._109038013_TemplatePickerListItemRenderer_SolidColorStroke1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_TemplatePickerListItemRenderer_SolidColorStroke1", _loc_2, value));
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

        public function get templateLabel() : Label
        {
            return this._198148454templateLabel;
        }// end function

        public function set templateLabel(value:Label) : void
        {
            var _loc_2:* = this._198148454templateLabel;
            if (_loc_2 !== value)
            {
                this._198148454templateLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "templateLabel", _loc_2, value));
                }
            }
            return;
        }// end function

    }
}
