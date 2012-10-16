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

    public class AttachmentRendererDeleteButtonSkin extends SparkSkin implements IStateClient2
    {
        public var _AttachmentRendererDeleteButtonSkin_Ellipse1:Ellipse;
        public var _AttachmentRendererDeleteButtonSkin_Ellipse2:Ellipse;
        public var _AttachmentRendererDeleteButtonSkin_Ellipse3:Ellipse;
        public var _AttachmentRendererDeleteButtonSkin_Ellipse4:Ellipse;
        public var _AttachmentRendererDeleteButtonSkin_Ellipse5:Ellipse;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:Button;
        private static const exclusions:Array = ["nextSymbol"];

        public function AttachmentRendererDeleteButtonSkin()
        {
            mx_internal::_document = this;
            this.mxmlContent = [this._AttachmentRendererDeleteButtonSkin_Ellipse1_i(), this._AttachmentRendererDeleteButtonSkin_Ellipse6_c(), this._AttachmentRendererDeleteButtonSkin_Group1_c()];
            this.currentState = "up";
            var _loc_1:* = new DeferredInstanceFromFunction(this._AttachmentRendererDeleteButtonSkin_Ellipse2_i);
            var _loc_2:* = new DeferredInstanceFromFunction(this._AttachmentRendererDeleteButtonSkin_Ellipse3_i);
            var _loc_3:* = new DeferredInstanceFromFunction(this._AttachmentRendererDeleteButtonSkin_Ellipse4_i);
            var _loc_4:* = new DeferredInstanceFromFunction(this._AttachmentRendererDeleteButtonSkin_Ellipse5_i);
            states = [new State({name:"up", overrides:[]}), new State({name:"over", overrides:[]}), new State({name:"down", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_4, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRendererDeleteButtonSkin_Ellipse1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_3, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRendererDeleteButtonSkin_Ellipse1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRendererDeleteButtonSkin_Ellipse1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRendererDeleteButtonSkin_Ellipse1"]})]}), new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({name:"alpha", value:0.5})]})];
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

        override public function get colorizeExclusions() : Array
        {
            return exclusions;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse1_i() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttachmentRendererDeleteButtonSkin_SolidColor1_c();
            _loc_1.initialized(this, "_AttachmentRendererDeleteButtonSkin_Ellipse1");
            this._AttachmentRendererDeleteButtonSkin_Ellipse1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRendererDeleteButtonSkin_Ellipse1", this._AttachmentRendererDeleteButtonSkin_Ellipse1);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColor1_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse2_i() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.height = 1;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.fill = this._AttachmentRendererDeleteButtonSkin_SolidColor2_c();
            _loc_1.initialized(this, "_AttachmentRendererDeleteButtonSkin_Ellipse2");
            this._AttachmentRendererDeleteButtonSkin_Ellipse2 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRendererDeleteButtonSkin_Ellipse2", this._AttachmentRendererDeleteButtonSkin_Ellipse2);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColor2_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.4;
            _loc_1.color = 16777215;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse3_i() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.height = 1;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 2;
            _loc_1.fill = this._AttachmentRendererDeleteButtonSkin_SolidColor3_c();
            _loc_1.initialized(this, "_AttachmentRendererDeleteButtonSkin_Ellipse3");
            this._AttachmentRendererDeleteButtonSkin_Ellipse3 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRendererDeleteButtonSkin_Ellipse3", this._AttachmentRendererDeleteButtonSkin_Ellipse3);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColor3_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 16777215;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse4_i() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.width = 1;
            _loc_1.left = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttachmentRendererDeleteButtonSkin_SolidColor4_c();
            _loc_1.initialized(this, "_AttachmentRendererDeleteButtonSkin_Ellipse4");
            this._AttachmentRendererDeleteButtonSkin_Ellipse4 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRendererDeleteButtonSkin_Ellipse4", this._AttachmentRendererDeleteButtonSkin_Ellipse4);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColor4_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 16777215;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse5_i() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.width = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttachmentRendererDeleteButtonSkin_SolidColor5_c();
            _loc_1.initialized(this, "_AttachmentRendererDeleteButtonSkin_Ellipse5");
            this._AttachmentRendererDeleteButtonSkin_Ellipse5 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRendererDeleteButtonSkin_Ellipse5", this._AttachmentRendererDeleteButtonSkin_Ellipse5);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColor5_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 16777215;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Ellipse6_c() : Ellipse
        {
            var _loc_1:* = new Ellipse();
            _loc_1.width = 16;
            _loc_1.height = 16;
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._AttachmentRendererDeleteButtonSkin_SolidColorStroke1_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColorStroke1_c() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 16777215;
            _loc_1.weight = 2;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Group1_c() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.horizontalCenter = 0;
            _loc_1.verticalCenter = 0;
            _loc_1.mxmlContent = [this._AttachmentRendererDeleteButtonSkin_Line1_c(), this._AttachmentRendererDeleteButtonSkin_Line2_c()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Line1_c() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.xFrom = 1;
            _loc_1.xTo = 7;
            _loc_1.yFrom = 1;
            _loc_1.yTo = 7;
            _loc_1.stroke = this._AttachmentRendererDeleteButtonSkin_SolidColorStroke2_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColorStroke2_c() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 16777215;
            _loc_1.weight = 3;
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_Line2_c() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.xFrom = 1;
            _loc_1.xTo = 7;
            _loc_1.yFrom = 7;
            _loc_1.yTo = 1;
            _loc_1.stroke = this._AttachmentRendererDeleteButtonSkin_SolidColorStroke3_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttachmentRendererDeleteButtonSkin_SolidColorStroke3_c() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 16777215;
            _loc_1.weight = 3;
            return _loc_1;
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
