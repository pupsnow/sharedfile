package com.esri.ags.components
{
    import IdentityManager.as$359.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.skins.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.logging.*;
    import mx.managers.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class IdentityManager extends EventDispatcher
    {
        private var _portalDomains:Array;
        private var _log:ILogger;
        private var _keyRing:Object;
        private var _serverInfos:Array;
        var credentials:Array;
        private var _currentAsyncToken:AsyncToken;
        private var _currentSignInInfo:SignInInfo;
        private var _soReqs:Array;
        private var _xoReqs:Array;
        private var _enabled:Boolean = false;
        var errorCodes:Array;
        public var signInWindowClass:Class;
        private static var _instance:IdentityManager;
        private static const RES_URL:String = "resURL";
        private static const SERVER_INFO:String = "serverInfo";
        private static const _agsRest:String = "/rest/services";
        private static const _gwTokenURL:String = "/sharing/generateToken";
        private static const _gwDomains:Array = [{regex:/https?:\/\/www\.arcgis\.com/i, tokenServiceUrl:"https://www.arcgis.com/sharing/generateToken"}, {regex:/https?:\/\/dev\.arcgis\.com/i, tokenServiceUrl:"https://dev.arcgis.com/sharing/generateToken"}, {regex:/https?:\/\/.*dev[^.]*\.arcgis\.com/i, tokenServiceUrl:"https://devext.arcgis.com/sharing/generateToken"}, {regex:/https?:\/\/.*qa[^.]*\.arcgis\.com/i, tokenServiceUrl:"https://qaext.arcgis.com/sharing/generateToken"}, {regex:/https?:\/\/.*.arcgis\.com/i, tokenServiceUrl:"https://www.arcgis.com/sharing/generateToken"}];
        private static const _regexSDirUrl:RegExp = /http.+\/rest\/services\/?/ig;
        private static const _regexServerType:RegExp = /(\/(MapServer|GeocodeServer|GPServer|GeometryServer|ImageServer|NAServer|FeatureServer|GeoDataServer|GlobeServer|MobileServer)).*/ig;

        public function IdentityManager(enforcer:SingletonEnforcer)
        {
            this._portalDomains = ["arcgis.com"];
            this._keyRing = {};
            this._serverInfos = [];
            this.credentials = [];
            this._soReqs = [];
            this._xoReqs = [];
            this.errorCodes = [499, 498, 403, 401];
            this.signInWindowClass = SignInWindow;
            return;
        }// end function

        public function get currentSignInInfo() : SignInInfo
        {
            return this._currentSignInInfo;
        }// end function

        public function get enabled() : Boolean
        {
            return this._enabled;
        }// end function

        public function set enabled(value:Boolean) : void
        {
            if (this._enabled !== value)
            {
                this._enabled = value;
                if (Log.isInfo())
                {
                    this.logger.info("IdentityManager has been " + (value ? ("enabled") : ("disabled")));
                }
                dispatchEvent(new Event("enabledChanged"));
            }
            return;
        }// end function

        function get logger() : ILogger
        {
            if (!this._log)
            {
                this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            }
            return this._log;
        }// end function

        public function findCredential(url:String, userId:String = null) : Credential
        {
            var _loc_3:Credential = null;
            var _loc_4:Credential = null;
            if (userId)
            {
                for each (_loc_4 in this.credentials)
                {
                    
                    if (this.hasSameOrigin(url, _loc_4.server))
                    {
                        this.hasSameOrigin(url, _loc_4.server);
                    }
                    if (userId === _loc_4.userId)
                    {
                        _loc_3 = _loc_4;
                        break;
                    }
                }
            }
            else
            {
                for each (_loc_4 in this.credentials)
                {
                    
                    if (this.hasSameOrigin(url, _loc_4.server))
                    {
                        this.hasSameOrigin(url, _loc_4.server);
                    }
                    if (this.getIdenticalSvcIdx(url, _loc_4) !== -1)
                    {
                        _loc_3 = _loc_4;
                        break;
                    }
                }
            }
            return _loc_3;
        }// end function

        public function findServerInfo(url:String) : ServerInfo
        {
            var _loc_2:ServerInfo = null;
            var _loc_3:ServerInfo = null;
            for each (_loc_3 in this._serverInfos)
            {
                
                if (this.hasSameOrigin(_loc_3.server, url))
                {
                    _loc_2 = _loc_3;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function generateCredential(serverInfo:ServerInfo, username:String, password:String, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var referer:String;
            var topLevelApplication:Object;
            var serverInfo:* = serverInfo;
            var username:* = username;
            var password:* = password;
            var responder:* = responder;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            urlVariables.username = username;
            urlVariables.password = password;
            if (serverInfo.tokenServiceURL.toLowerCase().indexOf("/sharing/generatetoken") === -1)
            {
            }
            if (serverInfo.tokenServiceURL.toLowerCase().indexOf("/sharing/rest/generatetoken") !== -1)
            {
                topLevelApplication = FlexGlobals.topLevelApplication;
                if (topLevelApplication.parameters)
                {
                }
                if (topLevelApplication.parameters.builder)
                {
                    referer;
                }
                else
                {
                    referer = (topLevelApplication as DisplayObject).loaderInfo.loaderURL;
                    if (URLUtil.isHttpURL(referer))
                    {
                        referer = this.getOrigin(referer);
                    }
                }
                if (referer)
                {
                    urlVariables.referer = referer;
                }
            }
            var urlRequest:* = new URLRequest();
            urlRequest.data = urlVariables;
            urlRequest.method = URLRequestMethod.POST;
            urlRequest.url = serverInfo.tokenServiceURL;
            var urlLoader:* = new MyURLLoader();
            urlLoader.callback = function (json:Object) : void
            {
                var _loc_2:String = null;
                var _loc_3:Credential = null;
                if (json.token)
                {
                    _loc_2 = serverInfo.server;
                    if (!_keyRing[_loc_2])
                    {
                        _keyRing[_loc_2] = {};
                    }
                    _keyRing[_loc_2][username] = password;
                    _loc_3 = new Credential();
                    _loc_3.expires = json.expires;
                    _loc_3.server = _loc_2;
                    _loc_3.token = json.token;
                    _loc_3.userId = username;
                    setAsyncTokenResult(_loc_3, asyncToken);
                }
                else
                {
                    setAsyncTokenFault(new Fault(null, "Unable to generate token"), asyncToken);
                }
                return;
            }// end function
            ;
            urlLoader.errback = function (fault:Fault) : void
            {
                setAsyncTokenFault(fault, asyncToken);
                return;
            }// end function
            ;
            urlLoader.load(urlRequest);
            return asyncToken;
        }// end function

        public function getCredential(url:String, retry:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var serverInfo:ServerInfo;
            var url:* = url;
            var retry:* = retry;
            var responder:* = responder;
            var getToWork:* = function () : void
            {
                asyncToken[RES_URL] = url;
                asyncToken[SERVER_INFO] = serverInfo;
                if (_currentAsyncToken)
                {
                    if (hasSameOrigin(url, _currentAsyncToken[RES_URL]))
                    {
                        _soReqs.push(asyncToken);
                    }
                    else
                    {
                        _xoReqs.push(asyncToken);
                    }
                }
                else
                {
                    doSignIn(asyncToken);
                }
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var match:* = this.findCredential2(url, retry);
            if (match)
            {
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.setAsyncTokenResult, [match, asyncToken]);
                }
                else
                {
                    this.setAsyncTokenResult(match, asyncToken);
                }
                return asyncToken;
            }
            serverInfo = this.findServerInfo(url);
            if (serverInfo)
            {
                this.getToWork();
            }
            else
            {
                var tokenSvcResult:* = function (tokenSvcURL:String) : void
            {
                serverInfo = new ServerInfo();
                serverInfo.server = getOrigin(url);
                serverInfo.tokenServiceURL = tokenSvcURL;
                registerServers([serverInfo]);
                getToWork();
                return;
            }// end function
            ;
                var tokenSvcFault:* = function (tokenSvcFault:Fault) : void
            {
                setAsyncTokenFault(tokenSvcFault, asyncToken);
                return;
            }// end function
            ;
                this.getTokenSvcURL(url, new Responder(tokenSvcResult, tokenSvcFault));
            }
            return asyncToken;
        }// end function

        private function getResourceName(resURL:String) : String
        {
            var _loc_2:String = null;
            if (resURL.toLowerCase().indexOf(_agsRest) !== -1)
            {
                if (!resURL.replace(_regexSDirUrl, "").replace(_regexServerType, ""))
                {
                    resURL.replace(_regexSDirUrl, "").replace(_regexServerType, "");
                }
                _loc_2 = ESRIMessageCodes.getString("signInWindow_resources");
            }
            else
            {
                _loc_2 = ESRIMessageCodes.getString("signInWindow_resources");
            }
            return _loc_2;
        }// end function

        private function getTokenSvcURL(resURL:String, responder:IResponder) : void
        {
            var infoURL:String;
            var urlVariables:URLVariables;
            var urlRequest:URLRequest;
            var urlLoader:MyURLLoader;
            var tokenServiceUrl:String;
            var domain:Object;
            var regex:RegExp;
            var origin:String;
            var resURL:* = resURL;
            var responder:* = responder;
            if (resURL.toLowerCase().indexOf(_agsRest) !== -1)
            {
                infoURL = resURL.substring(0, resURL.toLowerCase().indexOf(_agsRest) + "/rest/".length) + "info";
                urlVariables = new URLVariables();
                urlVariables.f = "json";
                urlRequest = new URLRequest();
                urlRequest.data = urlVariables;
                urlRequest.url = infoURL;
                urlLoader = new MyURLLoader();
                urlLoader.callback = function (json:Object) : void
            {
                var _loc_2:String = null;
                if (json.currentVersion >= 10.01)
                {
                }
                if (json.authInfo)
                {
                }
                if (json.authInfo.tokenServicesUrl)
                {
                    _loc_2 = json.authInfo.tokenServicesUrl;
                    if (_loc_2.lastIndexOf("/generateToken") !== _loc_2.length - "/generateToken".length)
                    {
                        if (_loc_2.charAt((_loc_2.length - 1)) !== "/")
                        {
                            _loc_2 = _loc_2 + "/";
                        }
                        _loc_2 = _loc_2 + "generateToken";
                    }
                    responder.result(_loc_2);
                }
                else
                {
                    responder.fault(new Fault(null, "Unable to get token service url from (" + infoURL + ") Version 10.01+ required."));
                }
                return;
            }// end function
            ;
                urlLoader.errback = function (fault:Fault) : void
            {
                responder.fault(fault);
                return;
            }// end function
            ;
                urlLoader.load(urlRequest);
            }
            else if (this.isPortalResource(resURL))
            {
                var _loc_4:int = 0;
                var _loc_5:* = _gwDomains;
                while (_loc_5 in _loc_4)
                {
                    
                    domain = _loc_5[_loc_4];
                    regex = domain.regex;
                    if (regex.test(resURL))
                    {
                        tokenServiceUrl = domain.tokenServiceUrl;
                        break;
                    }
                }
                if (!tokenServiceUrl)
                {
                    origin = this.getOrigin(resURL);
                    tokenServiceUrl = origin.replace(/http:/i, "https:") + _gwTokenURL;
                }
                responder.result(tokenServiceUrl);
            }
            else
            {
                responder.fault(new Fault(null, "Unable to get token service url for: " + resURL));
            }
            return;
        }// end function

        function registerPortal(portalURL:String) : void
        {
            var _loc_2:* = URLUtil.getServerNameWithPort(portalURL);
            if (_loc_2)
            {
                _loc_2 = _loc_2.toLowerCase();
                if (this._portalDomains.indexOf(_loc_2) === -1)
                {
                    this._portalDomains.push(_loc_2);
                }
            }
            return;
        }// end function

        public function registerServers(serverInfos:Array) : void
        {
            var _loc_2:ServerInfo = null;
            if (this._serverInfos)
            {
                for each (_loc_2 in serverInfos)
                {
                    
                    if (!this.findServerInfo(_loc_2.server))
                    {
                        this._serverInfos.push(_loc_2);
                    }
                }
            }
            else
            {
                this._serverInfos = serverInfos;
            }
            return;
        }// end function

        private function findCredential2(resURL:String, retry:Boolean) : Credential
        {
            var _loc_3:Credential = null;
            var _loc_5:int = 0;
            var _loc_6:Credential = null;
            var _loc_7:int = 0;
            var _loc_4:Array = [];
            for each (_loc_3 in this.credentials)
            {
                
                if (this.hasSameOrigin(_loc_3.server, resURL))
                {
                    _loc_4.push(_loc_3);
                }
            }
            _loc_5 = -1;
            if (_loc_4.length > 0)
            {
                if (_loc_4.length === 1)
                {
                    _loc_6 = _loc_4[0];
                    if (retry)
                    {
                        _loc_5 = this.getIdenticalSvcIdx(resURL, _loc_6);
                        if (_loc_5 !== -1)
                        {
                            _loc_6.resources.splice(_loc_5, 1);
                            if (_loc_6.resources.length === 0)
                            {
                                this.credentials.splice(this.credentials.indexOf(_loc_6), 1);
                            }
                        }
                    }
                    else
                    {
                        if (this.getIdenticalSvcIdx(resURL, _loc_6) === -1)
                        {
                            _loc_6.resources.push(resURL);
                        }
                        return _loc_6;
                    }
                }
                else
                {
                    for each (_loc_3 in _loc_4)
                    {
                        
                        _loc_7 = this.getIdenticalSvcIdx(resURL, _loc_3);
                        if (_loc_7 !== -1)
                        {
                            _loc_6 = _loc_3;
                            _loc_5 = _loc_7;
                            break;
                        }
                    }
                    if (retry)
                    {
                        if (_loc_6)
                        {
                            _loc_6.resources.splice(_loc_5, 1);
                            if (_loc_6.resources.length === 0)
                            {
                                this.credentials.splice(this.credentials.indexOf(_loc_6), 1);
                            }
                        }
                    }
                    else if (_loc_6)
                    {
                        return _loc_6;
                    }
                }
            }
            return null;
        }// end function

        private function getIdenticalSvcIdx(resURL:String, credential:Credential) : int
        {
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_3:int = -1;
            if (credential)
            {
            }
            if (credential.resources)
            {
                _loc_4 = credential.resources;
                _loc_5 = 0;
                _loc_6 = _loc_4.length;
                while (_loc_5 < _loc_6)
                {
                    
                    if (this.isIdenticalService(resURL, _loc_4[_loc_5]))
                    {
                        _loc_3 = _loc_5;
                        break;
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            return _loc_3;
        }// end function

        private function isIdenticalService(resURL1:String, resURL2:String) : Boolean
        {
            if (this.isPortalResource(resURL1))
            {
                return true;
            }
            var _loc_3:* = resURL1.replace(_regexSDirUrl, "").replace(_regexServerType, "$1");
            var _loc_4:* = resURL2.replace(_regexSDirUrl, "").replace(_regexServerType, "$1");
            return _loc_3 === _loc_4;
        }// end function

        function isPortalResource(resURL:String) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:String = null;
            resURL = resURL.toLowerCase();
            if (resURL.indexOf(_agsRest) === -1)
            {
                for each (_loc_3 in this._portalDomains)
                {
                    
                    if (resURL.indexOf(_loc_3) !== -1)
                    {
                        _loc_2 = true;
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        private function getSuffix(resURL:String) : String
        {
            return resURL.replace(_regexSDirUrl, "").replace(_regexServerType, "$1");
        }// end function

        private function hasSameOrigin(url1:String, url2:String) : Boolean
        {
            return URLUtil.getServerNameWithPort(url1) === URLUtil.getServerNameWithPort(url2);
        }// end function

        private function getOrigin(resURL:String) : String
        {
            return URLUtil.getProtocol(resURL) + "://" + URLUtil.getServerNameWithPort(resURL);
        }// end function

        private function doSignIn(asyncToken:AsyncToken) : void
        {
            this._currentAsyncToken = asyncToken;
            var _loc_2:* = this._currentAsyncToken[RES_URL];
            this._currentSignInInfo = new SignInInfo();
            this._currentSignInInfo.resourceName = this.getResourceName(_loc_2);
            this._currentSignInInfo.resourceURL = _loc_2;
            this._currentSignInInfo.serverInfo = asyncToken[SERVER_INFO];
            var _loc_3:* = new IdentityManagerEvent(IdentityManagerEvent.SHOW_SIGN_IN_WINDOW, true);
            if (dispatchEvent(_loc_3))
            {
                dispatchEvent(_loc_3);
            }
            if (this.signInWindowClass)
            {
                this.popUpSignInWindow(_loc_3);
            }
            return;
        }// end function

        public function setCredentialForCurrentSignIn(credential:Credential) : void
        {
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_4:AsyncToken = null;
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            if (credential)
            {
                _loc_2 = this._currentAsyncToken[RES_URL];
                if (!credential.resources)
                {
                    credential.resources = [];
                }
                credential.resources.push(_loc_2);
                credential.setKeyRing(this._keyRing);
                credential.startRefreshTimer();
                if (this.credentials.indexOf(credential) === -1)
                {
                    this.credentials.push(credential);
                }
                _loc_3 = this._soReqs;
                this._soReqs = [];
                _loc_5 = {};
                for each (_loc_4 in _loc_3)
                {
                    
                    _loc_6 = _loc_4[RES_URL];
                    if (!this.isIdenticalService(_loc_6, _loc_2))
                    {
                        _loc_7 = this.getSuffix(_loc_6);
                        if (!_loc_5[_loc_7])
                        {
                            _loc_5[_loc_7] = true;
                            credential.resources.push(_loc_6);
                        }
                    }
                }
                this.setAsyncTokenResult(credential, this._currentAsyncToken);
                for each (_loc_4 in _loc_3)
                {
                    
                    this.setAsyncTokenResult(credential, _loc_4);
                }
                this._currentAsyncToken = null;
                this._currentSignInInfo = null;
                if (this._xoReqs.length > 0)
                {
                    this.doSignIn(this._xoReqs.shift());
                }
            }
            else
            {
                this.setAsyncTokenFault(new Fault(null, "Sign in aborted"), this._currentAsyncToken);
                this._currentAsyncToken = null;
                this._currentSignInInfo = null;
                if (this._soReqs.length > 0)
                {
                    this.doSignIn(this._soReqs.shift());
                }
                else if (this._xoReqs.length > 0)
                {
                    this.doSignIn(this._xoReqs.shift());
                }
            }
            return;
        }// end function

        private function popUpSignInWindow(event:IdentityManagerEvent) : void
        {
            var _loc_2:* = FlexGlobals.topLevelApplication as DisplayObject;
            var _loc_3:* = PopUpManager.createPopUp(_loc_2, this.signInWindowClass, true);
            PopUpManager.centerPopUp(_loc_3);
            return;
        }// end function

        private function setAsyncTokenFault(info:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.fault(info);
            }
            return;
        }// end function

        private function setAsyncTokenResult(data:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(data);
            }
            return;
        }// end function

        public static function get instance() : IdentityManager
        {
            if (!_instance)
            {
                _instance = new IdentityManager(new SingletonEnforcer());
            }
            return _instance;
        }// end function

    }
}
