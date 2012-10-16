package com.esri.ags.skins
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;

    public class AttributeInspectorDeleteButtonSkin extends Skin implements IStateClient2
    {
        private var _1184053038labelDisplay:Label;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:Button;

        public function AttributeInspectorDeleteButtonSkin()
        {
            mx_internal::_document = this;
            this.mxmlContent = [this._AttributeInspectorDeleteButtonSkin_Label1_i()];
            this.currentState = "up";
            states = [new State({name:"up", overrides:[]}), new State({name:"over", overrides:[]}), new State({name:"down", overrides:[]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({name:"alpha", value:0.5}), new SetProperty().initializeFromObject({target:"labelDisplay", name:"alpha", value:0.7}), new SetStyle().initializeFromObject({target:"labelDisplay", name:"color", value:0}), new SetStyle().initializeFromObject({target:"labelDisplay", name:"textDecoration", value:"none"})]})];
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
            if (currentState != "over")
            {
            }
            if (currentState == "down")
            {
                this.labelDisplay.setStyle("color", getStyle("chromeColor"));
            }
            else
            {
                this.labelDisplay.setStyle("color", getStyle("accentColor"));
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _AttributeInspectorDeleteButtonSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.x = 0;
            _loc_1.y = 0;
            _loc_1.setStyle("fontFamily", "Arial");
            _loc_1.setStyle("fontSize", 12);
            _loc_1.setStyle("kerning", "on");
            _loc_1.setStyle("textAlign", "end");
            _loc_1.setStyle("textDecoration", "underline");
            _loc_1.id = "labelDisplay";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.labelDisplay = _loc_1;
            BindingManager.executeBindings(this, "labelDisplay", this.labelDisplay);
            return _loc_1;
        }// end function

        public function get labelDisplay() : Label
        {
            return this._1184053038labelDisplay;
        }// end function

        public function set labelDisplay(value:Label) : void
        {
            var _loc_2:* = this._1184053038labelDisplay;
            if (_loc_2 !== value)
            {
                this._1184053038labelDisplay = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelDisplay", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : Button
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:Button) : void
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

    }
}
