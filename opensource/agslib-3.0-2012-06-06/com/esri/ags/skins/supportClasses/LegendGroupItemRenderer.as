package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.symbols.*;
    import flashx.textLayout.formats.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;
    import spark.components.supportClasses.*;

    public class LegendGroupItemRenderer extends ItemRenderer
    {
        private var _809612678contentGroup:Group;
        private var _198148454templateLabel:Label;
        private var __moduleFactoryInitialized:Boolean = false;

        public function LegendGroupItemRenderer()
        {
            mx_internal::_document = this;
            this.name = "LegendGroupItemRenderer";
            this.width = 230;
            this.height = 35;
            this.autoDrawBackground = false;
            this.focusEnabled = false;
            this.mouseChildren = false;
            this.mxmlContent = [this._LegendGroupItemRenderer_HGroup1_c()];
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
            this.contentGroup.removeAllElements();
            this.templateLabel.setStyle("textAlign", TextAlign.CENTER);
            this.templateLabel.text = value.label;
            if (value.symbol)
            {
                if (!(value.symbol is CompositeSymbol))
                {
                    this.contentGroup.addElement(IVisualElement(Symbol(value.symbol).createSwatch(this.contentGroup.width, this.contentGroup.height)));
                }
            }
            return;
        }// end function

        private function _LegendGroupItemRenderer_HGroup1_c() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.paddingLeft = 10;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._LegendGroupItemRenderer_Group1_i(), this._LegendGroupItemRenderer_Label1_i()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _LegendGroupItemRenderer_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.width = 30;
            _loc_1.height = 30;
            _loc_1.id = "contentGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.contentGroup = _loc_1;
            BindingManager.executeBindings(this, "contentGroup", this.contentGroup);
            return _loc_1;
        }// end function

        private function _LegendGroupItemRenderer_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "templateLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.templateLabel = _loc_1;
            BindingManager.executeBindings(this, "templateLabel", this.templateLabel);
            return _loc_1;
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
