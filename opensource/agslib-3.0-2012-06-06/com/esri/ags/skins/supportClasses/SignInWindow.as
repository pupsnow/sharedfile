package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.core.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.*;
    import mx.utils.*;
    import spark.components.*;
    import spark.layouts.*;

    public class SignInWindow extends TitleWindow implements IBindingClient
    {
        public var _SignInWindow_Button1:Button;
        public var _SignInWindow_Button2:Button;
        public var _SignInWindow_FormItem1:FormItem;
        public var _SignInWindow_FormItem2:FormItem;
        private var _1396097113errorMsg:Label;
        private var _177936123infoText:RichEditableText;
        private var _485099259insecureMsg:Label;
        private var _1216985755password:TextInput;
        private var _265713450username:TextInput;
        private var __moduleFactoryInitialized:Boolean = false;
        protected var _idManager:IdentityManager;
        protected var _90770136_busy:Boolean;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;
        private static var _skinParts:Object = {contentGroup:false, moveArea:false, closeButton:false, titleDisplay:false, controlBarGroup:false};

        public function SignInWindow()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._idManager = IdentityManager.instance;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._SignInWindow_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_SignInWindowWatcherSetupUtil");
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
            this.width = 325;
            this.layout = this._SignInWindow_VerticalLayout1_c();
            this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SignInWindow_Array1_c);
            this.addEventListener("close", this.___SignInWindow_TitleWindow1_close);
            this.addEventListener("initialize", this.___SignInWindow_TitleWindow1_initialize);
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

        protected function titlewindow_initializeHandler(event:FlexEvent) : void
        {
            var _loc_2:* = this._idManager.currentSignInInfo;
            var _loc_3:* = resourceManager.getString("ESRIMessages", "signInWindow_info");
            var _loc_4:* = URLUtil.getServerNameWithPort(_loc_2.resourceURL);
            this.infoText.text = StringUtil.substitute(_loc_3, _loc_2.resourceName, _loc_4);
            if (!URLUtil.isHttpsURL(_loc_2.serverInfo.tokenServiceURL))
            {
                this.insecureMsg.text = resourceManager.getString("ESRIMessages", "signInWindow_insecure");
                var _loc_5:Boolean = true;
                this.insecureMsg.includeInLayout = true;
                this.insecureMsg.visible = _loc_5;
            }
            return;
        }// end function

        protected function signIn() : void
        {
            var usr:String;
            var self:SignInWindow;
            var genCredResult:Function;
            var genCredFault:Function;
            genCredResult = function (credential:Credential) : void
            {
                _idManager.setCredentialForCurrentSignIn(credential);
                PopUpManager.removePopUp(self);
                return;
            }// end function
            ;
            genCredFault = function (credFault:Fault) : void
            {
                var _loc_2:* = credFault.faultString;
                if (_loc_2)
                {
                    if (_loc_2.indexOf("2048") == -1)
                    {
                    }
                }
                if (_loc_2.indexOf("2032") != -1)
                {
                    errorMsg.text = _loc_2;
                }
                else
                {
                    errorMsg.text = resourceManager.getString("ESRIMessages", "signInWindow_error");
                    password.text = "";
                    password.setFocus();
                }
                _busy = false;
                errorMsg.visible = true;
                return;
            }// end function
            ;
            usr = this.username.text;
            var pwd:* = this.password.text;
            if (usr)
            {
            }
            if (!pwd)
            {
                return;
            }
            this._busy = true;
            this.errorMsg.visible = false;
            self;
            var signInInfo:* = this._idManager.currentSignInInfo;
            this._idManager.generateCredential(signInInfo.serverInfo, usr, pwd, new Responder(genCredResult, genCredFault));
            return;
        }// end function

        protected function cancel() : void
        {
            this._idManager.setCredentialForCurrentSignIn(null);
            PopUpManager.removePopUp(this);
            return;
        }// end function

        private function _SignInWindow_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            _loc_1.gap = 0;
            _loc_1.paddingBottom = 6;
            _loc_1.paddingLeft = 6;
            _loc_1.paddingRight = 6;
            _loc_1.paddingTop = 6;
            return _loc_1;
        }// end function

        private function _SignInWindow_Array1_c() : Array
        {
            var _loc_1:Array = [this._SignInWindow_RichEditableText1_i(), this._SignInWindow_Form1_c(), this._SignInWindow_Label2_i(), this._SignInWindow_HGroup1_c()];
            return _loc_1;
        }// end function

        private function _SignInWindow_RichEditableText1_i() : RichEditableText
        {
            var _loc_1:* = new RichEditableText();
            _loc_1.percentWidth = 100;
            _loc_1.editable = false;
            _loc_1.focusEnabled = false;
            _loc_1.id = "infoText";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.infoText = _loc_1;
            BindingManager.executeBindings(this, "infoText", this.infoText);
            return _loc_1;
        }// end function

        private function _SignInWindow_Form1_c() : Form
        {
            var _loc_1:* = new Form();
            _loc_1.percentWidth = 100;
            _loc_1.layout = this._SignInWindow_FormLayout1_c();
            _loc_1.mxmlContentFactory = new DeferredInstanceFromFunction(this._SignInWindow_Array2_c);
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _SignInWindow_FormLayout1_c() : FormLayout
        {
            var _loc_1:* = new FormLayout();
            _loc_1.gap = 0;
            return _loc_1;
        }// end function

        private function _SignInWindow_Array2_c() : Array
        {
            var _loc_1:Array = [this._SignInWindow_FormItem1_i(), this._SignInWindow_FormItem2_i(), this._SignInWindow_Label1_i()];
            return _loc_1;
        }// end function

        private function _SignInWindow_FormItem1_i() : FormItem
        {
            var _loc_1:* = new FormItem();
            _loc_1.required = true;
            _loc_1.mxmlContentFactory = new DeferredInstanceFromFunction(this._SignInWindow_Array3_c);
            _loc_1.id = "_SignInWindow_FormItem1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._SignInWindow_FormItem1 = _loc_1;
            BindingManager.executeBindings(this, "_SignInWindow_FormItem1", this._SignInWindow_FormItem1);
            return _loc_1;
        }// end function

        private function _SignInWindow_Array3_c() : Array
        {
            var _loc_1:Array = [this._SignInWindow_TextInput1_i()];
            return _loc_1;
        }// end function

        private function _SignInWindow_TextInput1_i() : TextInput
        {
            var _loc_1:* = new TextInput();
            _loc_1.percentWidth = 100;
            _loc_1.addEventListener("enter", this.__username_enter);
            _loc_1.id = "username";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.username = _loc_1;
            BindingManager.executeBindings(this, "username", this.username);
            return _loc_1;
        }// end function

        public function __username_enter(event:FlexEvent) : void
        {
            this.signIn();
            return;
        }// end function

        private function _SignInWindow_FormItem2_i() : FormItem
        {
            var _loc_1:* = new FormItem();
            _loc_1.required = true;
            _loc_1.mxmlContentFactory = new DeferredInstanceFromFunction(this._SignInWindow_Array4_c);
            _loc_1.id = "_SignInWindow_FormItem2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._SignInWindow_FormItem2 = _loc_1;
            BindingManager.executeBindings(this, "_SignInWindow_FormItem2", this._SignInWindow_FormItem2);
            return _loc_1;
        }// end function

        private function _SignInWindow_Array4_c() : Array
        {
            var _loc_1:Array = [this._SignInWindow_TextInput2_i()];
            return _loc_1;
        }// end function

        private function _SignInWindow_TextInput2_i() : TextInput
        {
            var _loc_1:* = new TextInput();
            _loc_1.percentWidth = 100;
            _loc_1.displayAsPassword = true;
            _loc_1.addEventListener("enter", this.__password_enter);
            _loc_1.id = "password";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.password = _loc_1;
            BindingManager.executeBindings(this, "password", this.password);
            return _loc_1;
        }// end function

        public function __password_enter(event:FlexEvent) : void
        {
            this.signIn();
            return;
        }// end function

        private function _SignInWindow_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.includeInLayout = false;
            _loc_1.visible = false;
            _loc_1.setStyle("textAlign", "center");
            _loc_1.id = "insecureMsg";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.insecureMsg = _loc_1;
            BindingManager.executeBindings(this, "insecureMsg", this.insecureMsg);
            return _loc_1;
        }// end function

        private function _SignInWindow_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.visible = false;
            _loc_1.setStyle("textAlign", "center");
            _loc_1.id = "errorMsg";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.errorMsg = _loc_1;
            BindingManager.executeBindings(this, "errorMsg", this.errorMsg);
            return _loc_1;
        }// end function

        private function _SignInWindow_HGroup1_c() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.percentWidth = 100;
            _loc_1.gap = 10;
            _loc_1.horizontalAlign = "center";
            _loc_1.paddingTop = 10;
            _loc_1.mxmlContent = [this._SignInWindow_Button1_i(), this._SignInWindow_Button2_i()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _SignInWindow_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.addEventListener("click", this.___SignInWindow_Button1_click);
            _loc_1.id = "_SignInWindow_Button1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._SignInWindow_Button1 = _loc_1;
            BindingManager.executeBindings(this, "_SignInWindow_Button1", this._SignInWindow_Button1);
            return _loc_1;
        }// end function

        public function ___SignInWindow_Button1_click(event:MouseEvent) : void
        {
            this.signIn();
            return;
        }// end function

        private function _SignInWindow_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.addEventListener("click", this.___SignInWindow_Button2_click);
            _loc_1.id = "_SignInWindow_Button2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._SignInWindow_Button2 = _loc_1;
            BindingManager.executeBindings(this, "_SignInWindow_Button2", this._SignInWindow_Button2);
            return _loc_1;
        }// end function

        public function ___SignInWindow_Button2_click(event:MouseEvent) : void
        {
            this.cancel();
            return;
        }// end function

        public function ___SignInWindow_TitleWindow1_close(event:CloseEvent) : void
        {
            this.cancel();
            return;
        }// end function

        public function ___SignInWindow_TitleWindow1_initialize(event:FlexEvent) : void
        {
            this.titlewindow_initializeHandler(event);
            return;
        }// end function

        private function _SignInWindow_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "signInWindow_title");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "this.title");
            result[1] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "signInWindow_username");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_SignInWindow_FormItem1.label");
            result[2] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "signInWindow_password");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_SignInWindow_FormItem2.label");
            result[3] = new Binding(this, function () : Boolean
            {
                if (!_busy)
                {
                }
                if (username.text)
                {
                }
                return password.text;
            }// end function
            , null, "_SignInWindow_Button1.enabled");
            result[4] = new Binding(this, function () : String
            {
                var _loc_1:* = _busy ? (resourceManager.getString("ESRIMessages", "signInWindow_signingIn")) : (resourceManager.getString("ESRIMessages", "signInWindow_OK"));
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_SignInWindow_Button1.label");
            result[5] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "signInWindow_cancel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "_SignInWindow_Button2.label");
            return result;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

        public function get errorMsg() : Label
        {
            return this._1396097113errorMsg;
        }// end function

        public function set errorMsg(value:Label) : void
        {
            var _loc_2:* = this._1396097113errorMsg;
            if (_loc_2 !== value)
            {
                this._1396097113errorMsg = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "errorMsg", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get infoText() : RichEditableText
        {
            return this._177936123infoText;
        }// end function

        public function set infoText(value:RichEditableText) : void
        {
            var _loc_2:* = this._177936123infoText;
            if (_loc_2 !== value)
            {
                this._177936123infoText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "infoText", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get insecureMsg() : Label
        {
            return this._485099259insecureMsg;
        }// end function

        public function set insecureMsg(value:Label) : void
        {
            var _loc_2:* = this._485099259insecureMsg;
            if (_loc_2 !== value)
            {
                this._485099259insecureMsg = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "insecureMsg", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get password() : TextInput
        {
            return this._1216985755password;
        }// end function

        public function set password(value:TextInput) : void
        {
            var _loc_2:* = this._1216985755password;
            if (_loc_2 !== value)
            {
                this._1216985755password = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "password", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get username() : TextInput
        {
            return this._265713450username;
        }// end function

        public function set username(value:TextInput) : void
        {
            var _loc_2:* = this._265713450username;
            if (_loc_2 !== value)
            {
                this._265713450username = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "username", _loc_2, value));
                }
            }
            return;
        }// end function

        protected function get _busy() : Boolean
        {
            return this._90770136_busy;
        }// end function

        protected function set _busy(value:Boolean) : void
        {
            var _loc_2:* = this._90770136_busy;
            if (_loc_2 !== value)
            {
                this._90770136_busy = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_busy", _loc_2, value));
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
