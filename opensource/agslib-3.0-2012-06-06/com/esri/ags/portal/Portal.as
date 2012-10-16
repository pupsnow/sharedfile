package com.esri.ags.portal
{
    import Portal.as$242.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.portal.tasks.*;
    import com.esri.ags.portal.utils.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class Portal extends EventDispatcher implements IMXMLObject
    {
        private var m_log:ILogger;
        var endpointURL:URL;
        var _1433818018portalCulture:String;
        private var m_url:URL;
        private var m_culture:String = null;
        private var m_info:PortalInfo;
        private var m_user:PortalUser;

        public function Portal()
        {
            this.m_url = new URL();
            IdentityManager.instance.enabled = true;
            return;
        }// end function

        private function get logger() : ILogger
        {
            if (!this.m_log)
            {
                this.m_log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            }
            return this.m_log;
        }// end function

        public function get url() : String
        {
            return this.m_url.sourceURL;
        }// end function

        private function set _116079url(value:String) : void
        {
            var _loc_2:* = this.url;
            if (this.url != value)
            {
                this.logger.debug("::set url({0})", value);
                this.setURL(value);
            }
            return;
        }// end function

        private function setURL(value:String) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this.logger.debug("::setURL({0})", value);
            var _loc_2:* = this.url;
            if (_loc_2 != value)
            {
                if (value)
                {
                }
                if (value != "")
                {
                    this.m_url.update(value);
                    this.endpointURL = this.m_url.clone();
                    if (this.m_url.path)
                    {
                        _loc_3 = this.m_url.path.lastIndexOf("sharing/rest/");
                        _loc_4 = _loc_3 == -1 ? (this.m_url.path.lastIndexOf("sharing/")) : (_loc_3);
                        _loc_5 = _loc_3 == -1 ? ("sharing/".length) : ("sharing/rest/".length);
                        if (_loc_4 != -1)
                        {
                            this.endpointURL = this.endpointURL.withPath(this.m_url.path.substring(0, _loc_4 + _loc_5));
                        }
                    }
                    else
                    {
                        this.endpointURL = this.endpointURL.appendPath("sharing/rest/");
                    }
                    IdentityManager.instance.registerPortal(this.endpointURL.sourceURL);
                }
                else
                {
                    this.m_url.update(null);
                    this.endpointURL = null;
                }
                this.dispatchChangeEvent("url", _loc_2, value);
            }
            return;
        }// end function

        public function get culture() : String
        {
            return this.m_culture;
        }// end function

        private function set _1121473966culture(value:String) : void
        {
            this.logger.debug("::set culture({0})", value);
            if (this.m_culture != value)
            {
                this.m_culture = value;
            }
            return;
        }// end function

        public function get info() : PortalInfo
        {
            return this.m_info;
        }// end function

        public function get user() : PortalUser
        {
            return this.m_user;
        }// end function

        private function setUser(user:PortalUser) : void
        {
            this.m_user = user;
            if (this.m_user)
            {
            }
            if (this.m_user.culture)
            {
                this.portalCulture = this.m_user.culture;
            }
            return;
        }// end function

        public function get loaded() : Boolean
        {
            return this.m_info != null;
        }// end function

        public function get signedIn() : Boolean
        {
            return this.m_user != null;
        }// end function

        public function load(url:String = null, culture:String = null) : void
        {
            this.internalLoad(url, culture, false, null);
            return;
        }// end function

        public function unload() : void
        {
            this.logger.debug("::unload()");
            this.internalUnload();
            return;
        }// end function

        public function signIn() : void
        {
            this.internalSignIn(null, null);
            return;
        }// end function

        public function signInWithCredentials(username:String, password:String) : void
        {
            this.internalSignIn(username, password);
            return;
        }// end function

        public function signOut() : void
        {
            if (Log.isDebug())
            {
                this.logger.debug("::signOut()");
            }
            if (this.signedIn)
            {
                this.internalUnload(true);
                this.internalLoad(null, null, false, null);
            }
            return;
        }// end function

        public function queryGroups(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            var portal:Portal;
            var queryParameters:* = queryParameters;
            var responder:* = responder;
            portal;
            var operationResponder:* = new AsyncResponder(function (nextResponder:IResponder, nullToken:AsyncToken) : void
            {
                var _loc_3:* = new PortalQueryTask(portal);
                _loc_3.queryGroups(queryParameters, nextResponder);
                return;
            }// end function
            , function (fault:Fault, nullToken:AsyncToken) : void
            {
                return;
            }// end function
            );
            return this.loadThenExecute(operationResponder, responder);
        }// end function

        public function queryItems(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            var portal:Portal;
            var queryParameters:* = queryParameters;
            var responder:* = responder;
            portal;
            var operationResponder:* = new AsyncResponder(function (nextResponder:IResponder, nullToken:AsyncToken) : void
            {
                var _loc_3:* = new PortalQueryTask(portal);
                _loc_3.queryItems(queryParameters, nextResponder);
                return;
            }// end function
            , function (fault:Fault, nullToken:AsyncToken) : void
            {
                return;
            }// end function
            );
            return this.loadThenExecute(operationResponder, responder);
        }// end function

        public function queryUsers(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            var portal:Portal;
            var queryParameters:* = queryParameters;
            var responder:* = responder;
            portal;
            var operationResponder:* = new AsyncResponder(function (nextResponder:IResponder, nullToken:AsyncToken) : void
            {
                var _loc_3:* = new PortalQueryTask(portal);
                _loc_3.queryUsers(queryParameters, nextResponder);
                return;
            }// end function
            , function (fault:Fault, nullToken:AsyncToken) : void
            {
                return;
            }// end function
            );
            return this.loadThenExecute(operationResponder, responder);
        }// end function

        public function getItem(itemId:String, responder:IResponder = null) : AsyncToken
        {
            var portal:Portal;
            var itemId:* = itemId;
            var responder:* = responder;
            portal;
            var operationResponder:* = new AsyncResponder(function (nextResponder:IResponder, nullToken:AsyncToken) : void
            {
                var _loc_3:* = new PortalGetTask(portal, portal);
                _loc_3.getItem(itemId, nextResponder);
                return;
            }// end function
            , function (fault:Fault, nullToken:AsyncToken) : void
            {
                return;
            }// end function
            );
            return this.loadThenExecute(operationResponder, responder);
        }// end function

        public function initialized(document:Object, id:String) : void
        {
            return;
        }// end function

        private function loadThenExecute(operationResponder:IResponder, responder:IResponder) : AsyncToken
        {
            var token:AsyncToken;
            var currentCredential:Credential;
            var loadPortalDuringProcess:Boolean;
            var checkCredendialResponder:IResponder;
            var loadToken:AsyncToken;
            var operationResponder:* = operationResponder;
            var responder:* = responder;
            if (!this.endpointURL)
            {
                if (Log.isError())
                {
                    this.logger.error("No URL endpoint defined for the portal.");
                }
                return null;
            }
            token = new AsyncToken();
            if (responder)
            {
                token.addResponder(responder);
            }
            var resultResponder:* = new AsyncResponder(this.applyResult, this.handleFault, token);
            currentCredential = IdentityManager.instance.findCredential(this.endpointURL.sourceURL);
            if (currentCredential != null)
            {
            }
            if (!this.signedIn)
            {
                currentCredential.destroy();
                currentCredential;
            }
            loadPortalDuringProcess = !this.loaded;
            checkCredendialResponder = new AsyncResponder(function (getItemData:Object, resultResponder:IResponder) : void
            {
                var getItemData:* = getItemData;
                var resultResponder:* = resultResponder;
                var newCredential:* = IdentityManager.instance.findCredential(endpointURL.sourceURL);
                if (currentCredential != newCredential)
                {
                    internalLoad(null, null, true).addResponder(new AsyncResponder(function (portalInfoTask:Object, asyncToken:AsyncToken) : void
                {
                    resultResponder.result(getItemData);
                    dispatchEvent(new PortalEvent(PortalEvent.LOAD));
                    return;
                }// end function
                , function (fault:Fault, resultResponder:IResponder) : void
                {
                    resultResponder.fault(fault);
                    return;
                }// end function
                , token));
                }
                else
                {
                    if (loadPortalDuringProcess)
                    {
                        dispatchEvent(new PortalEvent(PortalEvent.LOAD));
                    }
                    resultResponder.result(getItemData);
                }
                return;
            }// end function
            , function (fault:Fault, resultResponder:IResponder) : void
            {
                resultResponder.fault(fault);
                return;
            }// end function
            , resultResponder);
            if (loadPortalDuringProcess)
            {
                loadToken = this.internalLoad(null, null, true);
                responder = new AsyncResponder(function (data:Object, token:Object) : void
            {
                operationResponder.result(checkCredendialResponder);
                return;
            }// end function
            , function (fault:Fault, token:Object) : void
            {
                operationResponder.fault(fault);
                return;
            }// end function
            );
                loadToken.addResponder(responder);
            }
            else
            {
                operationResponder.result(checkCredendialResponder);
            }
            return token;
        }// end function

        private function initPortal(url:String, culture:String) : void
        {
            this.logger.debug("::initPortal({0}, {1})", url, culture);
            this.setURL(url);
            this.portalCulture = culture;
            return;
        }// end function

        private function internalLoad(url:String = null, culture:String = null, noEvent:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var _loc_8:LoadRequest = null;
            if (url)
            {
            }
            var _loc_5:* = url != "" ? (url) : (this.m_url ? (this.m_url.sourceURL) : (null));
            var _loc_6:String = null;
            if (!IdentityManager.instance.findCredential(_loc_5))
            {
                _loc_6 = culture ? (culture) : (this.m_culture ? (this.m_culture) : (null));
            }
            this.logger.debug("::load({0}, {1})", _loc_5, _loc_6);
            var _loc_7:* = new AsyncToken();
            if (_loc_5)
            {
                if (this.loaded)
                {
                }
                if (_loc_5 != this.url)
                {
                    this.internalUnload(true);
                }
                if (responder)
                {
                    _loc_7.addResponder(responder);
                }
                this.initPortal(_loc_5, _loc_6);
                _loc_8 = new LoadRequest();
                _loc_8.token = _loc_7;
                _loc_8.noEvent = noEvent;
                this.loadPortalInfo().addResponder(new AsyncResponder(this.handlePortalInfoComplete, this.handleFault, _loc_8));
            }
            else if (this.loaded)
            {
                this.unload();
            }
            return _loc_7;
        }// end function

        private function internalUnload(noEvent:Boolean = false) : void
        {
            var _loc_2:Credential = null;
            if (this.signedIn)
            {
                _loc_2 = IdentityManager.instance.findCredential(this.endpointURL.sourceURL, this.m_user.username);
                if (_loc_2)
                {
                    _loc_2.destroy();
                }
                this.setUser(null);
            }
            if (this.loaded)
            {
            }
            if (!noEvent)
            {
                this.m_info = null;
                dispatchEvent(new PortalEvent(PortalEvent.UNLOAD));
            }
            return;
        }// end function

        private function internalSignIn(username:String, password:String) : void
        {
            if (!this.endpointURL)
            {
                if (Log.isError())
                {
                    this.logger.error("No URL endpoint defined for the portal.");
                }
                return;
            }
            if (Log.isInfo())
            {
                this.logger.info(" signing in to portal : " + this.url);
            }
            var _loc_3:* = new LoadRequest();
            var _loc_4:* = new GetPortalInfoTask(this);
            _loc_4.signIn(username, password, new AsyncResponder(this.handlePortalInfoComplete, this.handleFault, _loc_3));
            return;
        }// end function

        private function loadPortalInfo(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new GetPortalInfoTask(this);
            return _loc_2.getInfo(responder);
        }// end function

        private function applyResult(result:Object, token:AsyncToken) : void
        {
            var event:ResultEvent;
            var responder:IResponder;
            var result:* = result;
            var token:* = token;
            event = ResultEvent.createEvent(result, token);
            if (token)
            {
                var _loc_4:int = 0;
                var _loc_5:* = token.responders;
                do
                {
                    
                    responder = _loc_5[_loc_4];
                    try
                    {
                        responder.result(result);
                    }
                    catch (error:Error)
                    {
                        if (error.errorID == 1034)
                        {
                            responder.result(event);
                        }
                        else
                        {
                            throw error;
                        }
                    }
                }while (_loc_5 in _loc_4)
            }
            dispatchEvent(event);
            return;
        }// end function

        private function handlePortalInfoComplete(task:GetPortalInfoTask, loadRequest:LoadRequest = null) : void
        {
            this.m_info = task.info;
            this.setUser(task.user);
            this.applyResult(null, loadRequest.token);
            if (loadRequest)
            {
                if (!loadRequest.noEvent)
                {
                    dispatchEvent(new PortalEvent(PortalEvent.LOAD));
                }
            }
            return;
        }// end function

        private function handleFault(fault:Fault, token:Object) : void
        {
            var asyncToken:AsyncToken;
            var event:FaultEvent;
            var responder:IResponder;
            var fault:* = fault;
            var token:* = token;
            if (Log.isError())
            {
                this.logger.error("::handleFault::{0}", fault.faultString);
            }
            if (token is AsyncToken)
            {
                asyncToken = token as AsyncToken;
            }
            else if (token is LoadRequest)
            {
                asyncToken = (token as LoadRequest).token;
            }
            event = FaultEvent.createEvent(fault, asyncToken);
            if (asyncToken)
            {
                var _loc_4:int = 0;
                var _loc_5:* = asyncToken.responders;
                do
                {
                    
                    responder = _loc_5[_loc_4];
                    try
                    {
                        responder.fault(fault);
                    }
                    catch (error:Error)
                    {
                        if (error.errorID == 1034)
                        {
                            responder.fault(event);
                        }
                        else
                        {
                            throw error;
                        }
                    }
                }while (_loc_5 in _loc_4)
            }
            dispatchEvent(event);
            return;
        }// end function

        private function dispatchChangeEvent(prop:String, oldValue, value) : void
        {
            if (hasEventListener("propertyChange"))
            {
                dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop, oldValue, value));
            }
            return;
        }// end function

        function get portalCulture() : String
        {
            return this._1433818018portalCulture;
        }// end function

        function set portalCulture(value:String) : void
        {
            arguments = this._1433818018portalCulture;
            if (arguments !== value)
            {
                this._1433818018portalCulture = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "esri_internal::portalCulture", arguments, value));
                }
            }
            return;
        }// end function

        public function set url(value:String) : void
        {
            arguments = this.url;
            if (arguments !== value)
            {
                this._116079url = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "url", arguments, value));
                }
            }
            return;
        }// end function

        public function set culture(value:String) : void
        {
            arguments = this.culture;
            if (arguments !== value)
            {
                this._1121473966culture = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "culture", arguments, value));
                }
            }
            return;
        }// end function

    }
}
