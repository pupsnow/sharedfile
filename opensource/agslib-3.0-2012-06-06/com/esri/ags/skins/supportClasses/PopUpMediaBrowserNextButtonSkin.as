package com.esri.ags.skins.supportClasses
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class PopUpMediaBrowserNextButtonSkin extends SparkSkin implements IStateClient2
    {
        public var _PopUpMediaBrowserNextButtonSkin_Rect1:Rect;
        public var _PopUpMediaBrowserNextButtonSkin_Rect2:Rect;
        private var _1064507762nextSymbolFill:SolidColor;
        private var _1502512065rectSymbolFill:SolidColor;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:Button;
        private static const symbols:Array = ["rectSymbolFill"];

        public function PopUpMediaBrowserNextButtonSkin()
        {
            mx_internal::_document = this;
            this.minHeight = 20;
            this.minWidth = 15;
            this.mxmlContent = [this._PopUpMediaBrowserNextButtonSkin_Path1_c()];
            this.currentState = "up";
            var _loc_1:* = new DeferredInstanceFromFunction(this._PopUpMediaBrowserNextButtonSkin_Rect1_i);
            var _loc_2:* = new DeferredInstanceFromFunction(this._PopUpMediaBrowserNextButtonSkin_Rect2_i);
            states = [new State({name:"up", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"over", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"down", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"first"})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({name:"alpha", value:0.5})]})];
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

        override public function get symbolItems() : Array
        {
            return symbols;
        }// end function

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
        {
            if (currentState != "over")
            {
            }
            if (currentState == "down")
            {
                this.nextSymbolFill.color = getStyle("chromeColor");
            }
            else
            {
                this.nextSymbolFill.color = getStyle("symbolColor");
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            return;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.fill = this._PopUpMediaBrowserNextButtonSkin_SolidColor1_c();
            _loc_1.initialized(this, "_PopUpMediaBrowserNextButtonSkin_Rect1");
            this._PopUpMediaBrowserNextButtonSkin_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_PopUpMediaBrowserNextButtonSkin_Rect1", this._PopUpMediaBrowserNextButtonSkin_Rect1);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0;
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_Rect2_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.fill = this._PopUpMediaBrowserNextButtonSkin_SolidColor2_i();
            _loc_1.initialized(this, "_PopUpMediaBrowserNextButtonSkin_Rect2");
            this._PopUpMediaBrowserNextButtonSkin_Rect2 = _loc_1;
            BindingManager.executeBindings(this, "_PopUpMediaBrowserNextButtonSkin_Rect2", this._PopUpMediaBrowserNextButtonSkin_Rect2);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_SolidColor2_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 0;
            this.rectSymbolFill = _loc_1;
            BindingManager.executeBindings(this, "rectSymbolFill", this.rectSymbolFill);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_Path1_c() : Path
        {
            var _loc_1:* = new Path();
            _loc_1.data = "M 1 0 L 1 13 L 8 7 L 1 0 Z";
            _loc_1.horizontalCenter = 0;
            _loc_1.verticalCenter = 0;
            _loc_1.winding = "evenOdd";
            _loc_1.fill = this._PopUpMediaBrowserNextButtonSkin_SolidColor3_i();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserNextButtonSkin_SolidColor3_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 0;
            this.nextSymbolFill = _loc_1;
            BindingManager.executeBindings(this, "nextSymbolFill", this.nextSymbolFill);
            return _loc_1;
        }// end function

        public function get nextSymbolFill() : SolidColor
        {
            return this._1064507762nextSymbolFill;
        }// end function

        public function set nextSymbolFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1064507762nextSymbolFill;
            if (_loc_2 !== value)
            {
                this._1064507762nextSymbolFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nextSymbolFill", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get rectSymbolFill() : SolidColor
        {
            return this._1502512065rectSymbolFill;
        }// end function

        public function set rectSymbolFill(value:SolidColor) : void
        {
            var _loc_2:* = this._1502512065rectSymbolFill;
            if (_loc_2 !== value)
            {
                this._1502512065rectSymbolFill = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rectSymbolFill", _loc_2, value));
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
