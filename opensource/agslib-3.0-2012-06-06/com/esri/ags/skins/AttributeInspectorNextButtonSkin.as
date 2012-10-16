package com.esri.ags.skins
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class AttributeInspectorNextButtonSkin extends SparkSkin implements IStateClient2
    {
        private var _1692304338_AttributeInspectorNextButtonSkin_GradientEntry1:GradientEntry;
        private var _1692304339_AttributeInspectorNextButtonSkin_GradientEntry2:GradientEntry;
        private var _1692304340_AttributeInspectorNextButtonSkin_GradientEntry3:GradientEntry;
        private var _1692304341_AttributeInspectorNextButtonSkin_GradientEntry4:GradientEntry;
        public var _AttributeInspectorNextButtonSkin_Rect1:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect2:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect3:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect4:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect5:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect6:Rect;
        public var _AttributeInspectorNextButtonSkin_Rect7:Rect;
        private var _1567560682_AttributeInspectorNextButtonSkin_SolidColor1:SolidColor;
        private var _1259558293nextSymbol:Group;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _213507019hostComponent:Button;
        private static const exclusions:Array = ["nextSymbol"];

        public function AttributeInspectorNextButtonSkin()
        {
            mx_internal::_document = this;
            this.mxmlContent = [this._AttributeInspectorNextButtonSkin_Rect1_i(), this._AttributeInspectorNextButtonSkin_Rect8_c(), this._AttributeInspectorNextButtonSkin_Group1_i()];
            this.currentState = "up";
            var _loc_1:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect2_i);
            var _loc_2:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect3_i);
            var _loc_3:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect4_i);
            var _loc_4:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect5_i);
            var _loc_5:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect6_i);
            var _loc_6:* = new DeferredInstanceFromFunction(this._AttributeInspectorNextButtonSkin_Rect7_i);
            states = [new State({name:"up", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]})]}), new State({name:"over", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry1", name:"color", value:13290186}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry2", name:"color", value:9276813}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry3", name:"alpha", value:0.22}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry4", name:"alpha", value:0.22}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_SolidColor1", name:"alpha", value:0.12})]}), new State({name:"down", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_6, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_5, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_4, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_3, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry1", name:"color", value:11053224}), new SetProperty().initializeFromObject({target:"_AttributeInspectorNextButtonSkin_GradientEntry2", name:"color", value:7039851})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_loc_2, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new AddItems().initializeFromObject({itemsFactory:_loc_1, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttributeInspectorNextButtonSkin_Rect1"]}), new SetProperty().initializeFromObject({name:"alpha", value:0.5})]})];
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

        private function _AttributeInspectorNextButtonSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_LinearGradient1_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect1");
            this._AttributeInspectorNextButtonSkin_Rect1 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect1", this._AttributeInspectorNextButtonSkin_Rect1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_LinearGradient1_c() : LinearGradient
        {
            var _loc_1:* = new LinearGradient();
            _loc_1.rotation = 90;
            _loc_1.entries = [this._AttributeInspectorNextButtonSkin_GradientEntry1_i(), this._AttributeInspectorNextButtonSkin_GradientEntry2_i()];
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_GradientEntry1_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 16777215;
            this._AttributeInspectorNextButtonSkin_GradientEntry1 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_GradientEntry1", this._AttributeInspectorNextButtonSkin_GradientEntry1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_GradientEntry2_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 14474460;
            this._AttributeInspectorNextButtonSkin_GradientEntry2 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_GradientEntry2", this._AttributeInspectorNextButtonSkin_GradientEntry2);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect2_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.stroke = this._AttributeInspectorNextButtonSkin_LinearGradientStroke1_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect2");
            this._AttributeInspectorNextButtonSkin_Rect2 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect2", this._AttributeInspectorNextButtonSkin_Rect2);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_LinearGradientStroke1_c() : LinearGradientStroke
        {
            var _loc_1:* = new LinearGradientStroke();
            _loc_1.rotation = 90;
            _loc_1.weight = 1;
            _loc_1.entries = [this._AttributeInspectorNextButtonSkin_GradientEntry3_i(), this._AttributeInspectorNextButtonSkin_GradientEntry4_i()];
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_GradientEntry3_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 16711422;
            this._AttributeInspectorNextButtonSkin_GradientEntry3 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_GradientEntry3", this._AttributeInspectorNextButtonSkin_GradientEntry3);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_GradientEntry4_i() : GradientEntry
        {
            var _loc_1:* = new GradientEntry();
            _loc_1.color = 15395562;
            this._AttributeInspectorNextButtonSkin_GradientEntry4 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_GradientEntry4", this._AttributeInspectorNextButtonSkin_GradientEntry4);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect3_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 11;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor1_i();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect3");
            this._AttributeInspectorNextButtonSkin_Rect3 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect3", this._AttributeInspectorNextButtonSkin_Rect3);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.3;
            _loc_1.color = 16777215;
            this._AttributeInspectorNextButtonSkin_SolidColor1 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_SolidColor1", this._AttributeInspectorNextButtonSkin_SolidColor1);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect4_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 1;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor2_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect4");
            this._AttributeInspectorNextButtonSkin_Rect4 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect4", this._AttributeInspectorNextButtonSkin_Rect4);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor2_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.4;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect5_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.height = 1;
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 2;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor3_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect5");
            this._AttributeInspectorNextButtonSkin_Rect5 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect5", this._AttributeInspectorNextButtonSkin_Rect5);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor3_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect6_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 1;
            _loc_1.left = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor4_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect6");
            this._AttributeInspectorNextButtonSkin_Rect6 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect6", this._AttributeInspectorNextButtonSkin_Rect6);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor4_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect7_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor5_c();
            _loc_1.initialized(this, "_AttributeInspectorNextButtonSkin_Rect7");
            this._AttributeInspectorNextButtonSkin_Rect7 = _loc_1;
            BindingManager.executeBindings(this, "_AttributeInspectorNextButtonSkin_Rect7", this._AttributeInspectorNextButtonSkin_Rect7);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor5_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 0.12;
            _loc_1.color = 0;
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Rect8_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.width = 38;
            _loc_1.height = 24;
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._AttributeInspectorNextButtonSkin_SolidColorStroke1_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColorStroke1_c() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 1250067;
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.horizontalCenter = 3;
            _loc_1.verticalCenter = 0;
            _loc_1.mxmlContent = [this._AttributeInspectorNextButtonSkin_Path1_c()];
            _loc_1.id = "nextSymbol";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.nextSymbol = _loc_1;
            BindingManager.executeBindings(this, "nextSymbol", this.nextSymbol);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_Path1_c() : Path
        {
            var _loc_1:* = new Path();
            _loc_1.data = "M 1 0 L 1 13 L 8 7 L 1 0 Z";
            _loc_1.winding = "evenOdd";
            _loc_1.fill = this._AttributeInspectorNextButtonSkin_SolidColor6_c();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttributeInspectorNextButtonSkin_SolidColor6_c() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.alpha = 1;
            _loc_1.color = 5592405;
            return _loc_1;
        }// end function

        public function get _AttributeInspectorNextButtonSkin_GradientEntry1() : GradientEntry
        {
            return this._1692304338_AttributeInspectorNextButtonSkin_GradientEntry1;
        }// end function

        public function set _AttributeInspectorNextButtonSkin_GradientEntry1(value:GradientEntry) : void
        {
            var _loc_2:* = this._1692304338_AttributeInspectorNextButtonSkin_GradientEntry1;
            if (_loc_2 !== value)
            {
                this._1692304338_AttributeInspectorNextButtonSkin_GradientEntry1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttributeInspectorNextButtonSkin_GradientEntry1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _AttributeInspectorNextButtonSkin_GradientEntry2() : GradientEntry
        {
            return this._1692304339_AttributeInspectorNextButtonSkin_GradientEntry2;
        }// end function

        public function set _AttributeInspectorNextButtonSkin_GradientEntry2(value:GradientEntry) : void
        {
            var _loc_2:* = this._1692304339_AttributeInspectorNextButtonSkin_GradientEntry2;
            if (_loc_2 !== value)
            {
                this._1692304339_AttributeInspectorNextButtonSkin_GradientEntry2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttributeInspectorNextButtonSkin_GradientEntry2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _AttributeInspectorNextButtonSkin_GradientEntry3() : GradientEntry
        {
            return this._1692304340_AttributeInspectorNextButtonSkin_GradientEntry3;
        }// end function

        public function set _AttributeInspectorNextButtonSkin_GradientEntry3(value:GradientEntry) : void
        {
            var _loc_2:* = this._1692304340_AttributeInspectorNextButtonSkin_GradientEntry3;
            if (_loc_2 !== value)
            {
                this._1692304340_AttributeInspectorNextButtonSkin_GradientEntry3 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttributeInspectorNextButtonSkin_GradientEntry3", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _AttributeInspectorNextButtonSkin_GradientEntry4() : GradientEntry
        {
            return this._1692304341_AttributeInspectorNextButtonSkin_GradientEntry4;
        }// end function

        public function set _AttributeInspectorNextButtonSkin_GradientEntry4(value:GradientEntry) : void
        {
            var _loc_2:* = this._1692304341_AttributeInspectorNextButtonSkin_GradientEntry4;
            if (_loc_2 !== value)
            {
                this._1692304341_AttributeInspectorNextButtonSkin_GradientEntry4 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttributeInspectorNextButtonSkin_GradientEntry4", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _AttributeInspectorNextButtonSkin_SolidColor1() : SolidColor
        {
            return this._1567560682_AttributeInspectorNextButtonSkin_SolidColor1;
        }// end function

        public function set _AttributeInspectorNextButtonSkin_SolidColor1(value:SolidColor) : void
        {
            var _loc_2:* = this._1567560682_AttributeInspectorNextButtonSkin_SolidColor1;
            if (_loc_2 !== value)
            {
                this._1567560682_AttributeInspectorNextButtonSkin_SolidColor1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttributeInspectorNextButtonSkin_SolidColor1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get nextSymbol() : Group
        {
            return this._1259558293nextSymbol;
        }// end function

        public function set nextSymbol(value:Group) : void
        {
            var _loc_2:* = this._1259558293nextSymbol;
            if (_loc_2 !== value)
            {
                this._1259558293nextSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nextSymbol", _loc_2, value));
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
