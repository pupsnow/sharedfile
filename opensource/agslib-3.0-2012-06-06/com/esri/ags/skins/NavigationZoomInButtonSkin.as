package com.esri.ags.skins
{
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class NavigationZoomInButtonSkin extends Skin implements IStateClient2
    {
        private var _765626442_NavigationZoomInButtonSkin_BitmapImage1:BitmapImage;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Down_369240422:Class;
        private var _embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Disabled_1063484144:Class;
        private var _embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Up_1355758765:Class;
        private var _embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Over_369963320:Class;
        private var _213507019hostComponent:Button;

        public function NavigationZoomInButtonSkin()
        {
            this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Down_369240422 = NavigationZoomInButtonSkin__embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Down_369240422;
            this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Disabled_1063484144 = NavigationZoomInButtonSkin__embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Disabled_1063484144;
            this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Up_1355758765 = NavigationZoomInButtonSkin__embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Up_1355758765;
            this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Over_369963320 = NavigationZoomInButtonSkin__embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Over_369963320;
            mx_internal::_document = this;
            this.minHeight = 10;
            this.minWidth = 10;
            this.mxmlContent = [this._NavigationZoomInButtonSkin_BitmapImage1_i()];
            this.currentState = "disabled";
            states = [new State({name:"disabled", overrides:[new SetProperty().initializeFromObject({target:"_NavigationZoomInButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Disabled_1063484144})]}), new State({name:"down", overrides:[new SetProperty().initializeFromObject({target:"_NavigationZoomInButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Down_369240422})]}), new State({name:"over", overrides:[new SetProperty().initializeFromObject({target:"_NavigationZoomInButtonSkin_BitmapImage1", name:"source", value:this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Over_369963320})]}), new State({name:"up", overrides:[]})];
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

        private function _NavigationZoomInButtonSkin_BitmapImage1_i() : BitmapImage
        {
            var _loc_1:* = new BitmapImage();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.source = this._embed_mxml_____________assets_skins_navigation_icons_swf_PlusButton_Up_1355758765;
            _loc_1.initialized(this, "_NavigationZoomInButtonSkin_BitmapImage1");
            this._NavigationZoomInButtonSkin_BitmapImage1 = _loc_1;
            BindingManager.executeBindings(this, "_NavigationZoomInButtonSkin_BitmapImage1", this._NavigationZoomInButtonSkin_BitmapImage1);
            return _loc_1;
        }// end function

        public function get _NavigationZoomInButtonSkin_BitmapImage1() : BitmapImage
        {
            return this._765626442_NavigationZoomInButtonSkin_BitmapImage1;
        }// end function

        public function set _NavigationZoomInButtonSkin_BitmapImage1(value:BitmapImage) : void
        {
            var _loc_2:* = this._765626442_NavigationZoomInButtonSkin_BitmapImage1;
            if (_loc_2 !== value)
            {
                this._765626442_NavigationZoomInButtonSkin_BitmapImage1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_NavigationZoomInButtonSkin_BitmapImage1", _loc_2, value));
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
