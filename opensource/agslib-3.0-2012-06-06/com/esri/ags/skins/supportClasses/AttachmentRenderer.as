package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.graphics.*;
    import mx.states.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.primitives.*;

    public class AttachmentRenderer extends ItemRenderer implements IBindingClient, IStateClient2
    {
        public var _AttachmentRenderer_Button1:Button;
        private var _126674913_AttachmentRenderer_SolidColor1:SolidColor;
        public var _AttachmentRenderer_VGroup1:VGroup;
        private var _100313435image:Image;
        private var _607923297labelName:Label;
        private var _607766251labelSize:Label;
        private var _1060399231numberFormatter:NumberFormatter;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _1576244879genericDocumentImageClass:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function AttachmentRenderer()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._1576244879genericDocumentImageClass = AttachmentRenderer_genericDocumentImageClass;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._AttachmentRenderer_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_AttachmentRendererWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return AttachmentRenderer[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.buttonMode = true;
            this.focusEnabled = false;
            this.mxmlContent = [this._AttachmentRenderer_Rect1_c(), this._AttachmentRenderer_VGroup1_i()];
            this.currentState = "normal";
            this._AttachmentRenderer_NumberFormatter1_i();
            var _AttachmentRenderer_Button1_factory:* = new DeferredInstanceFromFunction(this._AttachmentRenderer_Button1_i);
            states = [new State({name:"normal", overrides:[]}), new State({name:"hovered", overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentRenderer_Button1_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRenderer_VGroup1"]}), new SetProperty().initializeFromObject({target:"_AttachmentRenderer_SolidColor1", name:"color", value:13689072})]}), new State({name:"selected", overrides:[new AddItems().initializeFromObject({itemsFactory:_AttachmentRenderer_Button1_factory, destination:null, propertyName:"mxmlContent", position:"after", relativeTo:["_AttachmentRenderer_VGroup1"]}), new SetProperty().initializeFromObject({target:"_AttachmentRenderer_SolidColor1", name:"color", value:3368601})]})];
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

        override public function get owner() : DisplayObjectContainer
        {
            return super.owner;
        }// end function

        public function set _106164915owner(value:DisplayObjectContainer) : void
        {
            super.owner = value;
            return;
        }// end function

        override public function set data(value:Object) : void
        {
            super.data = value;
            var _loc_2:* = value as AttachmentInfo;
            if (_loc_2)
            {
                if (this.isContentTypeAnImage(_loc_2))
                {
                    if (this.urlContainsToken(_loc_2.url))
                    {
                        this.urlContainsToken(_loc_2.url);
                    }
                    if (Security.sandboxType != Security.APPLICATION)
                    {
                        this.loadImageUsingPostToAddReferHeader(_loc_2.url);
                    }
                    else
                    {
                        this.image.source = _loc_2.url;
                    }
                }
                else
                {
                    this.image.source = this.genericDocumentImageClass;
                }
                this.image.toolTip = _loc_2.name;
                this.setLabelName(_loc_2);
                this.setLabelSize(_loc_2);
            }
            return;
        }// end function

        private function deleteButton_mouseDownHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            return;
        }// end function

        private function deleteButton_mouseUpHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            Alert.show(resourceManager.getString("ESRIMessages", "attachmentInspectorDeleteAlertText"), data.name, Alert.YES | Alert.CANCEL, null, this.alert_closeHandler);
            return;
        }// end function

        private function alert_closeHandler(event:CloseEvent) : void
        {
            var _loc_2:AttachmentInfo = null;
            if (event.detail === Alert.YES)
            {
                _loc_2 = List(this.owner).dataProvider.getItemAt(itemIndex) as AttachmentInfo;
                if (_loc_2)
                {
                    dispatchEvent(new AttachmentRemoveEvent(_loc_2));
                }
            }
            return;
        }// end function

        private function isContentTypeAnImage(attachment:AttachmentInfo) : Boolean
        {
            if (attachment.contentType === "image/gif")
            {
                return true;
            }
            if (attachment.contentType === "image/png")
            {
                return true;
            }
            if (attachment.contentType === "image/jpeg")
            {
                return true;
            }
            return false;
        }// end function

        private function setLabelName(attachmentInfo:AttachmentInfo) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_2:* = attachmentInfo.name.length;
            if (_loc_2 > 12)
            {
                _loc_3 = attachmentInfo.name.lastIndexOf(".");
                if (_loc_3 > -1)
                {
                    _loc_4 = attachmentInfo.name.substr(0, 8) + "..";
                    _loc_5 = attachmentInfo.name.substr(_loc_3, 4);
                    this.labelName.text = _loc_4 + _loc_5;
                }
                else
                {
                    this.labelName.text = attachmentInfo.name.substr(0, 8) + "...";
                }
                this.labelName.toolTip = attachmentInfo.name;
            }
            else
            {
                this.labelName.text = attachmentInfo.name;
                this.labelName.toolTip = null;
            }
            return;
        }// end function

        private function setLabelSize(attachmentInfo:AttachmentInfo) : void
        {
            if (attachmentInfo.size < 1024)
            {
                this.labelSize.text = attachmentInfo.size + " " + resourceManager.getString("ESRIMessages", "attachmentInspectorBytes");
            }
            else if (attachmentInfo.size < 1048576)
            {
                this.labelSize.text = this.numberFormatter.format(attachmentInfo.size / 1024) + " " + resourceManager.getString("ESRIMessages", "attachmentInspectorKiloBytes");
            }
            else
            {
                this.labelSize.text = this.numberFormatter.format(attachmentInfo.size / 1048576) + " " + resourceManager.getString("ESRIMessages", "attachmentInspectorMegaBytes");
            }
            return;
        }// end function

        private function loadImageUsingPostToAddReferHeader(url:String) : void
        {
            var doNothingAndShowDefault:Function;
            var completeHandler:Function;
            var url:* = url;
            doNothingAndShowDefault = function (event:Event) : void
            {
                var _loc_2:* = event.target as URLLoader;
                _loc_2.close();
                return;
            }// end function
            ;
            completeHandler = function (event:Event) : void
            {
                var _loc_2:* = event.target as URLLoader;
                _loc_2.close();
                image.source = _loc_2.data;
                return;
            }// end function
            ;
            var urlLoader:* = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doNothingAndShowDefault);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, doNothingAndShowDefault);
            urlLoader.addEventListener(Event.COMPLETE, completeHandler);
            var request:* = new URLRequest(url);
            request.method = URLRequestMethod.POST;
            urlLoader.load(request);
            return;
        }// end function

        private function urlContainsToken(url:String) : Boolean
        {
            return url.indexOf("token=") > -1;
        }// end function

        private function _AttachmentRenderer_NumberFormatter1_i() : NumberFormatter
        {
            var _loc_1:* = new NumberFormatter();
            _loc_1.precision = 2;
            _loc_1.rounding = "nearest";
            this.numberFormatter = _loc_1;
            BindingManager.executeBindings(this, "numberFormatter", this.numberFormatter);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_Rect1_c() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.radiusX = 2;
            _loc_1.fill = this._AttachmentRenderer_SolidColor1_i();
            _loc_1.initialized(this, null);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_SolidColor1_i() : SolidColor
        {
            var _loc_1:* = new SolidColor();
            _loc_1.color = 16777215;
            this._AttachmentRenderer_SolidColor1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRenderer_SolidColor1", this._AttachmentRenderer_SolidColor1);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_VGroup1_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.left = 8;
            _loc_1.right = 8;
            _loc_1.top = 8;
            _loc_1.bottom = 8;
            _loc_1.horizontalAlign = "center";
            _loc_1.mxmlContent = [this._AttachmentRenderer_Image1_i(), this._AttachmentRenderer_Label1_i(), this._AttachmentRenderer_Label2_i()];
            _loc_1.id = "_AttachmentRenderer_VGroup1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentRenderer_VGroup1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRenderer_VGroup1", this._AttachmentRenderer_VGroup1);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_Image1_i() : Image
        {
            var _loc_1:* = new Image();
            _loc_1.maxHeight = 64;
            _loc_1.maxWidth = 64;
            _loc_1.id = "image";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.image = _loc_1;
            BindingManager.executeBindings(this, "image", this.image);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "labelName";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.labelName = _loc_1;
            BindingManager.executeBindings(this, "labelName", this.labelName);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.id = "labelSize";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.labelSize = _loc_1;
            BindingManager.executeBindings(this, "labelSize", this.labelSize);
            return _loc_1;
        }// end function

        private function _AttachmentRenderer_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.right = -4;
            _loc_1.top = -6;
            _loc_1.buttonMode = true;
            _loc_1.emphasized = true;
            _loc_1.setStyle("skinClass", AttachmentRendererDeleteButtonSkin);
            _loc_1.addEventListener("mouseDown", this.___AttachmentRenderer_Button1_mouseDown);
            _loc_1.addEventListener("mouseUp", this.___AttachmentRenderer_Button1_mouseUp);
            _loc_1.id = "_AttachmentRenderer_Button1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._AttachmentRenderer_Button1 = _loc_1;
            BindingManager.executeBindings(this, "_AttachmentRenderer_Button1", this._AttachmentRenderer_Button1);
            return _loc_1;
        }// end function

        public function ___AttachmentRenderer_Button1_mouseDown(event:MouseEvent) : void
        {
            this.deleteButton_mouseDownHandler(event);
            return;
        }// end function

        public function ___AttachmentRenderer_Button1_mouseUp(event:MouseEvent) : void
        {
            this.deleteButton_mouseUpHandler(event);
            return;
        }// end function

        private function _AttachmentRenderer_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : Object
            {
                return genericDocumentImageClass;
            }// end function
            , null, "image.source");
            result[1] = new Binding(this, function () : Boolean
            {
                if (AttachmentInfoList(owner).deleteEnabled)
                {
                }
                return AttachmentInfoList(owner).isEditable;
            }// end function
            , null, "_AttachmentRenderer_Button1.includeInLayout");
            result[2] = new Binding(this, function () : Boolean
            {
                if (AttachmentInfoList(owner).deleteEnabled)
                {
                }
                return AttachmentInfoList(owner).isEditable;
            }// end function
            , null, "_AttachmentRenderer_Button1.visible");
            return result;
        }// end function

        public function get _AttachmentRenderer_SolidColor1() : SolidColor
        {
            return this._126674913_AttachmentRenderer_SolidColor1;
        }// end function

        public function set _AttachmentRenderer_SolidColor1(value:SolidColor) : void
        {
            var _loc_2:* = this._126674913_AttachmentRenderer_SolidColor1;
            if (_loc_2 !== value)
            {
                this._126674913_AttachmentRenderer_SolidColor1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_AttachmentRenderer_SolidColor1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get image() : Image
        {
            return this._100313435image;
        }// end function

        public function set image(value:Image) : void
        {
            var _loc_2:* = this._100313435image;
            if (_loc_2 !== value)
            {
                this._100313435image = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "image", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get labelName() : Label
        {
            return this._607923297labelName;
        }// end function

        public function set labelName(value:Label) : void
        {
            var _loc_2:* = this._607923297labelName;
            if (_loc_2 !== value)
            {
                this._607923297labelName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelName", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get labelSize() : Label
        {
            return this._607766251labelSize;
        }// end function

        public function set labelSize(value:Label) : void
        {
            var _loc_2:* = this._607766251labelSize;
            if (_loc_2 !== value)
            {
                this._607766251labelSize = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelSize", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get numberFormatter() : NumberFormatter
        {
            return this._1060399231numberFormatter;
        }// end function

        public function set numberFormatter(value:NumberFormatter) : void
        {
            var _loc_2:* = this._1060399231numberFormatter;
            if (_loc_2 !== value)
            {
                this._1060399231numberFormatter = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numberFormatter", _loc_2, value));
                }
            }
            return;
        }// end function

        private function get genericDocumentImageClass() : Class
        {
            return this._1576244879genericDocumentImageClass;
        }// end function

        private function set genericDocumentImageClass(value:Class) : void
        {
            var _loc_2:* = this._1576244879genericDocumentImageClass;
            if (_loc_2 !== value)
            {
                this._1576244879genericDocumentImageClass = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "genericDocumentImageClass", _loc_2, value));
                }
            }
            return;
        }// end function

        override public function set owner(value:DisplayObjectContainer) : void
        {
            var _loc_2:* = this.owner;
            if (_loc_2 !== value)
            {
                this._106164915owner = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "owner", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            AttachmentRenderer._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
