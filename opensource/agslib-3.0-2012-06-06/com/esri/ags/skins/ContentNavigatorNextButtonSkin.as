package com.esri.ags.skins
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class ContentNavigatorNextButtonSkin extends Skin implements IStateClient2
    {
        private var _1233990472pathFill:SolidColor;
        private var _795922041rectFill:SolidColor;
        private var _5620028rectStroke:SolidColorStroke;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:Button;

        public function ContentNavigatorNextButtonSkin()
        {
            mx_internal::_document = this;
            this.width = 16;
            this.height = 16;
            this.mxmlContent = [this._ContentNavigatorNextButtonSkin_Rect1_c(), this._ContentNavigatorNextButtonSkin_Path1_c()];
            this.currentState = "disabled";
            states = [new State({name:"disabled", overrides:[]}), new State({name:"down", overrides:[new SetProperty().initializeFromObject({target:"rectStroke", name:"alpha", value:0.7}), new SetProperty().initializeFromObject({target:"rectFill", name:"alpha", value:0.7})]}), new State({name:"over", overrides:[new SetProperty().initializeFromObject({target:"rectStroke", name:"alpha", value:0.7})]}), new State({name:"up", overrides:[]})];
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
            var _loc_3:* = getStyle("color");
            if (isNaN(_loc_3))
            {
                _loc_3 = 16777215;
            }
            this.rectStroke.color = _loc_3;
            this.rectFill.color = _loc_3;
            this.pathFill.color = _loc_3;
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _ContentNavigatorNextButtonSkin_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._ContentNavigatorNextButtonSkin_SolidColorStroke1_i();
            _loc_1.fill = this._ContentNavigatorNextButtonSkin_SolidColor1_i();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _ContentNavigatorNextButtonSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.alpha = 0;
            _loc_1.weight = 1;
            this.rectStroke = _loc_1;
            BindingManager.executeBindings(this, "rectStroke", this.rectStroke);
            return _loc_1;
        }// end function

        private function _ContentNavigatorNextButtonSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0;
            this.rectFill = _loc_1;
            BindingManager.executeBindings(this, "rectFill", this.rectFill);
            return _loc_1;
        }// end function

        private function _ContentNavigatorNextButtonSkin_Path1_c() : Path
        {
            var _loc_1:* = new Path();
            _loc_1.fill = this._ContentNavigatorNextButtonSkin_SolidColor2_i();
            _loc_1.data = "M 3 3 L 13 8 L 3 13 Z";
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _ContentNavigatorNextButtonSkin_SolidColor2_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            this.pathFill = _loc_1;
            BindingManager.executeBindings(this, "pathFill", this.pathFill);
            return _loc_1;
        }// end function

        public function get pathFill() : SolidColor
        {
            return this._1233990472pathFill;
        }// end function

        public function set pathFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1233990472pathFill;
            if (_loc_2 !== value)
            {
                this._1233990472pathFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pathFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get rectFill() : SolidColor
        {
            return this._795922041rectFill;
        }// end function

        public function set rectFill(value:SolidColor) : void
        {
            var _loc_2:* = this._795922041rectFill;
            if (_loc_2 !== value)
            {
                this._795922041rectFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rectFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get rectStroke() : SolidColorStroke
        {
            return this._5620028rectStroke;
        }// end function

        public function set rectStroke(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._5620028rectStroke;
            if (_loc_2 !== value)
            {
                this._5620028rectStroke = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rectStroke", _loc_2, value));
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
