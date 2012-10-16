package com.esri.ags.skins
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class InfoWindowCloseButtonSkin extends Skin implements IStateClient2
    {
        private var _1116087206_InfoWindowCloseButtonSkin_BitmapImage1:BitmapImage;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonOverSkin_1926502883:Class;
        private var _embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDownSkin_1566493109:Class;
        private var _embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonUpSkin_204473604:Class;
        private var _embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDisabledSkin_1505954533:Class;
        private var _213507019hostComponent:Button;

        public function InfoWindowCloseButtonSkin()
        {
            this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonOverSkin_1926502883 = InfoWindowCloseButtonSkin__embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonOverSkin_1926502883;
            this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDownSkin_1566493109 = InfoWindowCloseButtonSkin__embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDownSkin_1566493109;
            this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonUpSkin_204473604 = InfoWindowCloseButtonSkin__embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonUpSkin_204473604;
            this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDisabledSkin_1505954533 = InfoWindowCloseButtonSkin__embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDisabledSkin_1505954533;
            mx_internal::_document = this;
            this.minHeight = 18;
            this.minWidth = 18;
            this.mxmlContent = [this._InfoWindowCloseButtonSkin_BitmapImage1_i()];
            this.currentState = "disabled";
            states = [new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({target:"_InfoWindowCloseButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDisabledSkin_1505954533})]}), new State({name:"down", overrides:[new SetProperty().initializeFromObject({target:"_InfoWindowCloseButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonDownSkin_1566493109})]}), new State({name:"over", overrides:[new SetProperty().initializeFromObject({target:"_InfoWindowCloseButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonOverSkin_1926502883})]}), new State({name:"up", overrides:[]})];
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

        private function _InfoWindowCloseButtonSkin_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.source = this._embed_mxml_____________assets_skins_callout_icons_swf_Callout_closeButtonUpSkin_204473604;
            _loc_1.initialized(this, "_InfoWindowCloseButtonSkin_BitmapImage1");
            this._InfoWindowCloseButtonSkin_BitmapImage1 = _loc_1;
            BindingManager.executeBindings(this, "_InfoWindowCloseButtonSkin_BitmapImage1", this._InfoWindowCloseButtonSkin_BitmapImage1);
            return _loc_1;
        }// end function

        public function get _InfoWindowCloseButtonSkin_BitmapImage1() : BitmapImage
        {
            return this._1116087206_InfoWindowCloseButtonSkin_BitmapImage1;
        }// end function

        public function set _InfoWindowCloseButtonSkin_BitmapImage1(value:BitmapImage) : void
        {
            var _loc_2:* = this._1116087206_InfoWindowCloseButtonSkin_BitmapImage1;
            if (_loc_2 !== value)
            {
                this._1116087206_InfoWindowCloseButtonSkin_BitmapImage1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_InfoWindowCloseButtonSkin_BitmapImage1", _loc_2, value));
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
