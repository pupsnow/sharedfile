package com.esri.ags.skins.supportClasses
{
    import flash.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.containers.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.styles.*;

    public class MemoWindow extends TitleWindow implements IBindingClient
    {
        private var _1943129152applyButton:Button;
        private var _1990131276cancelButton:Button;
        private var _1417224458richTextEditor:RichTextEditor;
        private var _documentDescriptor_:UIComponentDescriptor;
        private var __moduleFactoryInitialized:Boolean = false;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function MemoWindow()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._documentDescriptor_ = new UIComponentDescriptor({type:TitleWindow, stylesFactory:function () : void
            {
                this.paddingBottom = 0;
                this.paddingLeft = 0;
                this.paddingRight = 0;
                this.paddingTop = 0;
                this.verticalGap = 0;
                return;
            }// end function
            , propertiesFactory:function () : Object
            {
                return {childDescriptors:[new UIComponentDescriptor({type:RichTextEditor, id:"richTextEditor", stylesFactory:function () : void
                {
                    this.headerHeight = 0;
                    return;
                }// end function
                }), new UIComponentDescriptor({type:HBox, stylesFactory:function () : void
                {
                    this.paddingBottom = 2;
                    this.paddingLeft = 2;
                    this.paddingRight = 2;
                    this.paddingTop = 2;
                    this.verticalAlign = "middle";
                    return;
                }// end function
                , propertiesFactory:function () : Object
                {
                    return {percentWidth:100, childDescriptors:[new UIComponentDescriptor({type:Button, id:"cancelButton", events:{click:"__cancelButton_click"}}), new UIComponentDescriptor({type:Spacer, propertiesFactory:function () : Object
                    {
                        return {percentWidth:100};
                    }// end function
                    }), new UIComponentDescriptor({type:Button, id:"applyButton", events:{click:"__applyButton_click"}})]};
                }// end function
                })]};
            }// end function
            });
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._MemoWindow_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_MemoWindowWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return [propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.layout = "vertical";
            this.showCloseButton = true;
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
            var factory:* = factory;
            super.moduleFactory = factory;
            if (this.__moduleFactoryInitialized)
            {
                return;
            }
            this.__moduleFactoryInitialized = true;
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration(null, styleManager);
            }
            this.styleDeclaration.defaultFactory = function () : void
            {
                this.paddingBottom = 0;
                this.paddingLeft = 0;
                this.paddingRight = 0;
                this.paddingTop = 0;
                this.verticalGap = 0;
                return;
            }// end function
            ;
            return;
        }// end function

        override public function initialize() : void
        {
            .mx_internal::setDocumentDescriptor(this._documentDescriptor_);
            super.initialize();
            return;
        }// end function

        protected function applyButton_clickHandler(event:MouseEvent) : void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        protected function cancelButton_clickHandler(event:MouseEvent) : void
        {
            dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            return;
        }// end function

        public function __cancelButton_click(event:MouseEvent) : void
        {
            this.cancelButton_clickHandler(event);
            return;
        }// end function

        public function __applyButton_click(event:MouseEvent) : void
        {
            this.applyButton_clickHandler(event);
            return;
        }// end function

        private function _MemoWindow_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "memoWindowCancel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "cancelButton.label");
            result[1] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "memoWindowApply");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "applyButton.label");
            return result;
        }// end function

        public function get applyButton() : Button
        {
            return this._1943129152applyButton;
        }// end function

        public function set applyButton(value:Button) : void
        {
            var _loc_2:* = this._1943129152applyButton;
            if (_loc_2 !== value)
            {
                this._1943129152applyButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "applyButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get cancelButton() : Button
        {
            return this._1990131276cancelButton;
        }// end function

        public function set cancelButton(value:Button) : void
        {
            var _loc_2:* = this._1990131276cancelButton;
            if (_loc_2 !== value)
            {
                this._1990131276cancelButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cancelButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get richTextEditor() : RichTextEditor
        {
            return this._1417224458richTextEditor;
        }// end function

        public function set richTextEditor(value:RichTextEditor) : void
        {
            var _loc_2:* = this._1417224458richTextEditor;
            if (_loc_2 !== value)
            {
                this._1417224458richTextEditor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "richTextEditor", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            _watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
