package com.esri.ags.tasks
{
    import BaseTask.as$360.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.rpc.http.*;
    import mx.utils.*;

    public class BaseTask extends EventDispatcher implements IMXMLObject
    {
        private var _log:ILogger;
        private var _httpService:HTTPService;
        private var _idManager:IdentityManager;
        private var _autoNormalize:Boolean = true;
        private var _concurrency:String = "multiple";
        private var _disableClientCaching:Boolean;
        protected var id:String = "";
        private var _method:String = "GET";
        private var _proxyURLObj:URL;
        private var _requestTimeout:int = -1;
        private var _showBusyCursor:Boolean = false;
        private var _token:String;
        protected const urlObj:URL;

        public function BaseTask(url:String = null)
        {
            var traceHandler:Function;
            var url:* = url;
            this._httpService = new HTTPService();
            this._idManager = IdentityManager.instance;
            this._proxyURLObj = new URL();
            this.urlObj = new URL();
            traceHandler = function (event:Event) : void
            {
                return;
            }// end function
            ;
            this.url = url;
            this._httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            this._httpService.addEventListener(ResultEvent.RESULT, traceHandler);
            this._httpService.addEventListener(FaultEvent.FAULT, traceHandler);
            return;
        }// end function

        public function get autoNormalize() : Boolean
        {
            return this._autoNormalize;
        }// end function

        public function set autoNormalize(value:Boolean) : void
        {
            if (this._autoNormalize !== value)
            {
                this._autoNormalize = value;
                dispatchEvent(new Event("autoNormalizeChanged"));
            }
            return;
        }// end function

        public function get concurrency() : String
        {
            return this._concurrency;
        }// end function

        public function set concurrency(value:String) : void
        {
            if (this._concurrency !== value)
            {
                this._concurrency = value;
                dispatchEvent(new Event("concurrencyChanged"));
            }
            return;
        }// end function

        public function get disableClientCaching() : Boolean
        {
            return this._disableClientCaching;
        }// end function

        public function set disableClientCaching(value:Boolean) : void
        {
            if (this._disableClientCaching !== value)
            {
                this._disableClientCaching = value;
                dispatchEvent(new Event("disableClientCachingChanged"));
            }
            return;
        }// end function

        public function get method() : String
        {
            return this._method;
        }// end function

        public function set method(value:String) : void
        {
            if (this._method !== value)
            {
                if (value != URLRequestMethod.GET)
                {
                }
            }
            if (value == URLRequestMethod.POST)
            {
                this._method = value;
                dispatchEvent(new Event("methodChanged"));
            }
            return;
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURLObj.sourceURL;
        }// end function

        public function set proxyURL(value:String) : void
        {
            if (this.proxyURL !== value)
            {
                this._proxyURLObj.update(value);
                dispatchEvent(new Event("proxyURLChanged"));
            }
            return;
        }// end function

        public function get requestTimeout() : int
        {
            return this._requestTimeout;
        }// end function

        public function set requestTimeout(value:int) : void
        {
            if (this._requestTimeout !== value)
            {
                this._requestTimeout = value;
                dispatchEvent(new Event("requestTimeoutChanged"));
            }
            return;
        }// end function

        public function get showBusyCursor() : Boolean
        {
            return this._showBusyCursor;
        }// end function

        public function set showBusyCursor(value:Boolean) : void
        {
            if (this._showBusyCursor !== value)
            {
                this._showBusyCursor = value;
                dispatchEvent(new Event("showBusyCursorChanged"));
            }
            return;
        }// end function

        public function get token() : String
        {
            return this._token;
        }// end function

        public function set token(value:String) : void
        {
            if (this._token !== value)
            {
                this._token = value;
                dispatchEvent(new Event("tokenChanged"));
            }
            return;
        }// end function

        public function get url() : String
        {
            return this.urlObj.sourceURL;
        }// end function

        public function set url(value:String) : void
        {
            if (this.url !== value)
            {
                this.urlObj.update(value);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        public function initialized(document:Object, id:String) : void
        {
            this.id = id;
            return;
        }// end function

        protected function updateHTTPService() : void
        {
            this._httpService.request = {};
            this._httpService.method = this.method;
            this._httpService.requestTimeout = this.requestTimeout;
            this._httpService.showBusyCursor = this.showBusyCursor;
            this._httpService.concurrency = this.concurrency;
            return;
        }// end function

        protected function sendURLVariables(urlSuffix:String, urlVariables:URLVariables, responder:IResponder, operation:Function) : AsyncToken
        {
            var _loc_5:* = new AsyncToken(null);
            if (responder)
            {
                _loc_5.addResponder(responder);
            }
            return this.sendURLVariables2(urlSuffix, urlVariables, operation, _loc_5);
        }// end function

        function sendURLVariables2(urlSuffix:String, urlVariables:URLVariables, operation:Function, asyncToken:AsyncToken) : AsyncToken
        {
            var _loc_8:int = 0;
            var _loc_9:String = null;
            var _loc_10:Credential = null;
            var _loc_5:* = new RequestVO();
            _loc_5.urlSuffix = urlSuffix;
            _loc_5.urlVariables = urlVariables;
            _loc_5.operation = operation;
            _loc_5.asyncToken = asyncToken;
            var _loc_6:* = this.urlObj.path ? (this.urlObj.path) : ("");
            if (urlSuffix)
            {
                _loc_8 = _loc_6.lastIndexOf("/");
                if (_loc_8 != -1)
                {
                    _loc_9 = _loc_6.slice(_loc_8);
                    if (_loc_9 != "/")
                    {
                    }
                    if (_loc_9.toLowerCase() == urlSuffix)
                    {
                        _loc_6 = _loc_6.slice(0, _loc_8);
                    }
                }
                _loc_6 = _loc_6 + urlSuffix;
            }
            _loc_5.fullURLPath = _loc_6;
            if (!this.token)
            {
                if (this.urlObj.query)
                {
                }
            }
            if (!this.urlObj.query.token)
            {
                if (urlVariables)
                {
                }
            }
            var _loc_7:* = urlVariables.token;
            if (this._idManager.enabled)
            {
            }
            if (!_loc_7)
            {
                _loc_10 = this._idManager.findCredential(_loc_6);
                if (_loc_10)
                {
                    _loc_5.agsToken = _loc_10.token;
                }
            }
            return this.sendURLVariables3(_loc_5);
        }// end function

        private function sendURLVariables3(requestVO:RequestVO) : AsyncToken
        {
            var _loc_7:Object = null;
            var _loc_9:URLVariables = null;
            var _loc_10:Boolean = false;
            var _loc_13:int = 0;
            var _loc_14:String = null;
            var _loc_15:MyURLLoader = null;
            var _loc_16:URLRequest = null;
            var _loc_17:AsyncToken = null;
            var _loc_2:* = requestVO.urlSuffix;
            var _loc_3:* = requestVO.urlVariables;
            var _loc_4:* = requestVO.operation;
            var _loc_5:* = requestVO.asyncToken;
            var _loc_6:* = requestVO.agsToken ? (requestVO.agsToken) : (this.token);
            this.updateHTTPService();
            this._httpService.url = requestVO.fullURLPath;
            var _loc_8:* = new URLVariables();
            for (_loc_7 in _loc_3)
            {
                
                _loc_8[_loc_7] = _loc_3[_loc_7];
            }
            _loc_9 = new URLVariables();
            for (_loc_7 in this.urlObj.query)
            {
                
                if (!_loc_8[_loc_7])
                {
                    _loc_9[_loc_7] = this.urlObj.query[_loc_7];
                }
            }
            if (_loc_6)
            {
                if (_loc_9.token)
                {
                    _loc_9.token = _loc_6;
                }
                else
                {
                    _loc_8.token = _loc_6;
                }
            }
            if (this.disableClientCaching)
            {
            }
            if (!_loc_9._ts)
            {
            }
            if (!_loc_8._ts)
            {
                _loc_8._ts = new Date().time;
            }
            if (this.proxyURL)
            {
                this._httpService.url = this._proxyURLObj.path + "?" + this._httpService.url;
                if (this._proxyURLObj.query)
                {
                    for (_loc_7 in this._proxyURLObj.query)
                    {
                        
                        if (!_loc_9[_loc_7])
                        {
                        }
                        if (!_loc_8[_loc_7])
                        {
                            _loc_9[_loc_7] = this._proxyURLObj.query[_loc_7];
                        }
                    }
                }
            }
            var _loc_11:* = _loc_9.toString();
            if (_loc_11)
            {
            }
            if (_loc_11.length > 0)
            {
                _loc_10 = true;
                this._httpService.url = this._httpService.url + ("?" + _loc_11);
            }
            if (this._httpService.method != URLRequestMethod.POST)
            {
                _loc_13 = this._httpService.url.length + _loc_8.toString().length;
                if (_loc_13 > 2000)
                {
                    this._httpService.method = URLRequestMethod.POST;
                }
                else
                {
                    if (!requestVO.agsToken)
                    {
                    }
                    if (Security.sandboxType != Security.APPLICATION)
                    {
                        if (!_loc_9.token)
                        {
                        }
                    }
                    if (_loc_8.token)
                    {
                        this._httpService.method = URLRequestMethod.POST;
                    }
                }
            }
            if (_loc_8.layerDefs)
            {
            }
            if (this._httpService.method != URLRequestMethod.POST)
            {
                _loc_14 = _loc_8.layerDefs;
                delete _loc_8.layerDefs;
            }
            var _loc_12:* = _loc_8.toString();
            if (this._httpService.method != URLRequestMethod.POST)
            {
                if (_loc_12)
                {
                }
                if (_loc_12.length > 0)
                {
                    this._httpService.url = this._httpService.url + ((_loc_10 ? ("&") : ("?")) + _loc_12);
                    if (_loc_14)
                    {
                        this._httpService.url = this._httpService.url + ("&layerDefs=" + encodeURIComponent(_loc_14));
                    }
                }
            }
            else
            {
                if (_loc_12)
                {
                }
                if (_loc_12.length == 0)
                {
                    _loc_8.forceFlashPOST = true;
                }
                this._httpService.request = _loc_8;
            }
            if (_loc_8.f == "amf")
            {
                _loc_15 = new MyURLLoader();
                _loc_15.requestVO = requestVO;
                _loc_15.addEventListener(Event.COMPLETE, this.loaderCompleteHandler);
                _loc_15.addEventListener(IOErrorEvent.IO_ERROR, this.loaderIOErrorHandler);
                _loc_15.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityErrorHandler);
                _loc_16 = new URLRequest(this._httpService.url);
                _loc_16.data = this._httpService.request is URLVariables ? (this._httpService.request) : (null);
                _loc_16.method = this._httpService.method;
                _loc_15.load(_loc_16);
            }
            else
            {
                _loc_17 = this._httpService.send();
                _loc_17.addResponder(new AsyncResponder(this.handleResultEvent, this.handleFaultEvent, requestVO));
            }
            return _loc_5;
        }// end function

        private function handleResultEvent(event:ResultEvent, requestVO:RequestVO) : void
        {
            var asyncToken:AsyncToken;
            var decodedObject:Object;
            var resultFault:Fault;
            var responder:IResponder;
            var errorCode:int;
            var isPortalResource:Boolean;
            var hasAGSToken:Boolean;
            var event:* = event;
            var requestVO:* = requestVO;
            asyncToken = requestVO.asyncToken;
            var operation:* = requestVO.operation;
            if (event.result == "")
            {
                this.handleStringError("Empty Result. Check Input Parameters", asyncToken);
            }
            else
            {
                try
                {
                    decodedObject = JSONUtil.decode(event.result as String);
                }
                catch (refError:ReferenceError)
                {
                    throw refError;
                    ;
                }
                catch (resultError:Error)
                {
                    if (Log.isError())
                    {
                        logger.error("{0}::{1}", id, resultError.message);
                    }
                    resultFault = new Fault(null, resultError.message);
                    var _loc_5:int = 0;
                    var _loc_6:* = asyncToken.responders;
                    while (_loc_6 in _loc_5)
                    {
                        
                        responder = _loc_6[_loc_5];
                        responder.fault(resultFault);
                    }
                    dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, resultFault));
                    return;
                }
                if (decodedObject.error)
                {
                    errorCode = decodedObject.error.code;
                    isPortalResource = this._idManager.isPortalResource(requestVO.fullURLPath);
                    hasAGSToken = requestVO.agsToken != null;
                    if (this._idManager.enabled)
                    {
                    }
                    if (this._idManager.errorCodes.indexOf(errorCode) !== -1)
                    {
                        if (isPortalResource)
                        {
                            if (isPortalResource)
                            {
                            }
                        }
                    }
                    if (!hasAGSToken)
                    {
                        var credentialResult:* = function (credential:Credential) : void
            {
                requestVO.agsToken = credential.token;
                sendURLVariables3(requestVO);
                return;
            }// end function
            ;
                        var credentialFault:* = function (fault:Fault) : void
            {
                handleFault(fault, asyncToken);
                return;
            }// end function
            ;
                        this._idManager.getCredential(requestVO.fullURLPath, hasAGSToken, new Responder(credentialResult, credentialFault));
                    }
                    else
                    {
                        this.handleError(decodedObject.error, asyncToken);
                    }
                }
                else
                {
                    operation.call(this, decodedObject, asyncToken);
                }
            }
            return;
        }// end function

        private function handleFaultEvent(event:FaultEvent, requestVO:RequestVO) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:SecurityErrorEvent = null;
            if (Log.isError())
            {
                this.logger.error("{0}::{1}", this.id, event);
            }
            for each (_loc_3 in requestVO.asyncToken.responders)
            {
                
                _loc_3.fault(event.fault);
            }
            dispatchEvent(event);
            if (event.fault)
            {
            }
            if (event.fault.rootCause)
            {
                _loc_4 = event.fault.rootCause as SecurityErrorEvent;
                if (_loc_4)
                {
                    throw new SecurityError(_loc_4.text);
                }
            }
            return;
        }// end function

        protected function handleFault(fault:Fault, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            if (Log.isError())
            {
                this.logger.error("{0}::{1}", this.id, fault);
            }
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.fault(fault);
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, fault));
            return;
        }// end function

        protected function handleError(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_8:IResponder = null;
            if (Log.isError())
            {
                this.logger.error("{0}::{1}", this.id, ObjectUtil.toString(decodedObject));
            }
            var _loc_3:* = decodedObject.code;
            var _loc_4:* = decodedObject.message;
            var _loc_5:* = decodedObject.details as Array;
            var _loc_6:* = _loc_5 ? (_loc_5.join("\n")) : ("");
            var _loc_7:* = new Fault(_loc_3, _loc_4, _loc_6);
            _loc_7.content = decodedObject;
            for each (_loc_8 in asyncToken.responders)
            {
                
                _loc_8.fault(_loc_7);
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, _loc_7));
            return;
        }// end function

        protected function handleStringError(errorString:String, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            if (Log.isError())
            {
                this.logger.error("{0}::{1}", this.id, errorString);
            }
            var _loc_3:* = new Fault(null, errorString);
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.fault(_loc_3);
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, _loc_3));
            return;
        }// end function

        protected function get logger() : ILogger
        {
            if (!this._log)
            {
                this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, ".").replace("$", "-"));
            }
            return this._log;
        }// end function

        private function loaderCompleteHandler(event:Event) : void
        {
            var loader:MyURLLoader;
            var data:ByteArray;
            var obj:Object;
            var result:String;
            var resultEvent:ResultEvent;
            var event:* = event;
            loader = event.target as MyURLLoader;
            this.removeEventListeners(loader);
            data = loader.data;
            try
            {
                obj = data.readObject();
            }
            catch (error:Error)
            {
                data.position = 0;
                result = data.readUTFBytes(data.length);
                resultEvent = new ResultEvent(ResultEvent.RESULT, false, false, result);
                handleResultEvent(resultEvent, loader.requestVO);
                return;
            }
            var operation:* = loader.requestVO.operation;
            var asyncToken:* = loader.requestVO.asyncToken;
            operation.call(this, obj, asyncToken);
            return;
        }// end function

        private function loaderIOErrorHandler(event:IOErrorEvent) : void
        {
            var _loc_2:* = event.target as MyURLLoader;
            this.removeEventListeners(_loc_2);
            this.handleStringError(event.text, _loc_2.requestVO.asyncToken);
            return;
        }// end function

        private function loaderSecurityErrorHandler(event:SecurityErrorEvent) : void
        {
            var _loc_2:* = event.target as MyURLLoader;
            this.removeEventListeners(_loc_2);
            this.handleStringError(event.text, _loc_2.requestVO.asyncToken);
            throw new SecurityError(event.text);
        }// end function

        private function removeEventListeners(loader:MyURLLoader) : void
        {
            loader.removeEventListener(Event.COMPLETE, this.loaderCompleteHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderIOErrorHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityErrorHandler);
            return;
        }// end function

    }
}
