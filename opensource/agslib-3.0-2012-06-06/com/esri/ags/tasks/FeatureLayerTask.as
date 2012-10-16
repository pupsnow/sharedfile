package com.esri.ags.tasks
{
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class FeatureLayerTask extends BaseTask
    {
        private var _gdbVersion:String;
        private static const MIME_MAP:Object = {avi:"video/x-msvideo", csv:"text/csv", doc:"application/msword", docx:"application/vnd.openxmlformats-officedocument.wordprocessingml.document", f4v:"video/mp4", flv:"video/x-flv", gif:"image/gif", htm:"text/html", html:"text/html", jpeg:"image/jpeg", jpg:"image/jpeg", mov:"video/quicktime", mpeg:"video/mpeg", mpg:"video/mpeg", pdf:"application/pdf", png:"image/png", ppt:"application/powerpoint", pptx:"application/vnd.openxmlformats-officedocument.presentationml.presentation", swf:"application/x-shockwave-flash", tif:"image/tiff", txt:"text/plain", xls:"application/vnd.ms-excel", xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", xml:"text/xml", zip:"application/zip"};

        public function FeatureLayerTask(url:String = null)
        {
            super(url);
            method = URLRequestMethod.POST;
            return;
        }// end function

        public function get gdbVersion() : String
        {
            return this._gdbVersion;
        }// end function

        public function set gdbVersion(value:String) : void
        {
            if (this._gdbVersion !== value)
            {
                this._gdbVersion = value;
                dispatchEvent(new Event("gdbVersionChanged"));
            }
            return;
        }// end function

        public function applyEdits(adds:Array, updates:Array, deletes:Array, objectIdField:String, rollbackOnFailure:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var arrToBeNormalizedObject:Array;
            var arrToBeNormalizedGeometry:Array;
            var i:int;
            var adds:* = adds;
            var updates:* = updates;
            var deletes:* = deletes;
            var objectIdField:* = objectIdField;
            var rollbackOnFailure:* = rollbackOnFailure;
            var responder:* = responder;
            var generateUrlVariables:* = function () : void
            {
                var _loc_2:Array = null;
                var _loc_3:Graphic = null;
                var _loc_1:* = new URLVariables();
                _loc_1.f = "json";
                if (gdbVersion)
                {
                    _loc_1.gdbVersion = gdbVersion;
                }
                if (adds)
                {
                    _loc_1.adds = JSONUtil.encode(adds);
                }
                if (updates)
                {
                    _loc_1.updates = JSONUtil.encode(updates);
                }
                if (deletes)
                {
                }
                if (objectIdField)
                {
                    _loc_2 = [];
                    for each (_loc_3 in deletes)
                    {
                        
                        _loc_2.push(_loc_3.attributes[objectIdField]);
                    }
                    _loc_1.deletes = _loc_2.join();
                }
                _loc_1.rollbackOnFailure = rollbackOnFailure;
                asyncToken = sendURLVariables2("/applyEdits", _loc_1, handleApplyEdits, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::applyEdits:{1}", id, url);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (autoNormalize)
            {
                arrToBeNormalizedObject;
                arrToBeNormalizedGeometry;
                if (adds)
                {
                    i;
                    while (i < adds.length)
                    {
                        
                        if (adds[i].geometry)
                        {
                            arrToBeNormalizedObject.push({type:"adds", feature:adds[i]});
                            arrToBeNormalizedGeometry.push(adds[i].geometry);
                        }
                        i = (i + 1);
                    }
                }
                if (updates)
                {
                    i;
                    while (i < updates.length)
                    {
                        
                        if (updates[i].geometry)
                        {
                            arrToBeNormalizedObject.push({type:"updates", feature:updates[i]});
                            arrToBeNormalizedGeometry.push(updates[i].geometry);
                        }
                        i = (i + 1);
                    }
                }
                if (arrToBeNormalizedGeometry.length > 0)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                var _loc_5:Graphic = null;
                var _loc_6:Graphic = null;
                var _loc_3:* = item as Array;
                var _loc_4:int = 0;
                while (_loc_4 < arrToBeNormalizedObject.length)
                {
                    
                    if (arrToBeNormalizedObject[_loc_4].type == "adds")
                    {
                        for each (_loc_5 in adds)
                        {
                            
                            if (_loc_5 == arrToBeNormalizedObject[_loc_4].feature)
                            {
                                _loc_5.geometry = _loc_3[_loc_4];
                                break;
                            }
                        }
                    }
                    else if (arrToBeNormalizedObject[_loc_4].type == "updates")
                    {
                        for each (_loc_6 in updates)
                        {
                            
                            if (_loc_6 == arrToBeNormalizedObject[_loc_4].feature)
                            {
                                _loc_6.geometry = _loc_3[_loc_4];
                                break;
                            }
                        }
                    }
                    _loc_4 = _loc_4 + 1;
                }
                generateUrlVariables();
                return;
            }// end function
            ;
                    var faultFunction:* = function (fault:Fault, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.fault(fault);
                }
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
                return;
            }// end function
            ;
                    GeometryUtil.normalizeCentralMeridian(arrToBeNormalizedGeometry, GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultFunction, asyncToken));
                }
                else
                {
                    this.generateUrlVariables();
                }
            }
            else
            {
                this.generateUrlVariables();
            }
            return asyncToken;
        }// end function

        private function handleApplyEdits(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:IResponder = null;
            var _loc_5:FeatureLayerEvent = null;
            var _loc_3:* = FeatureEditResults.toFeatureEditResults(decodedObject);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleApplyEdits:{1}", id, _loc_3);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            if (hasEventListener(FeatureLayerEvent.EDITS_COMPLETE))
            {
                _loc_5 = new FeatureLayerEvent(FeatureLayerEvent.EDITS_COMPLETE);
                _loc_5.featureEditResults = _loc_3;
                dispatchEvent(_loc_5);
            }
            return;
        }// end function

        public function queryAttachmentInfos(objectId:Number, responder:IResponder = null) : AsyncToken
        {
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            if (this.gdbVersion)
            {
                _loc_3.gdbVersion = this.gdbVersion;
            }
            var _loc_4:* = "/" + objectId + "/attachments";
            var _loc_5:* = sendURLVariables(_loc_4, _loc_3, responder, this.handleQueryAttachmentInfos);
            _loc_5["objectId"] = objectId;
            _loc_5["baseURL"] = this.getProxiedURL() + _loc_4;
            _loc_5["url"] = this.url;
            var _loc_6:* = this.getURLandProxyParams();
            if (this.gdbVersion)
            {
                _loc_6.gdbVersion = this.gdbVersion;
            }
            if (this.token)
            {
                _loc_6.token = this.token;
            }
            _loc_5["extraVariables"] = _loc_6;
            return _loc_5;
        }// end function

        private function handleQueryAttachmentInfos(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:Array = null;
            var _loc_4:IResponder = null;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            var _loc_7:URLVariables = null;
            var _loc_8:Credential = null;
            var _loc_9:String = null;
            var _loc_10:Object = null;
            var _loc_11:AttachmentInfo = null;
            var _loc_12:AttachmentEvent = null;
            if (decodedObject)
            {
            }
            if (decodedObject.attachmentInfos is Array)
            {
                _loc_3 = [];
                _loc_5 = asyncToken["objectId"];
                _loc_6 = asyncToken["baseURL"];
                _loc_7 = asyncToken["extraVariables"];
                _loc_8 = IdentityManager.instance.findCredential(asyncToken["url"]);
                if (_loc_8)
                {
                }
                if (_loc_8.token)
                {
                    _loc_7.token = _loc_8.token;
                }
                _loc_9 = _loc_7.toString();
                for each (_loc_10 in decodedObject.attachmentInfos)
                {
                    
                    _loc_11 = AttachmentInfo.toAttachmentInfo(_loc_10);
                    _loc_11.objectId = _loc_5;
                    _loc_11.url = _loc_6 + "/" + _loc_11.id;
                    if (_loc_9)
                    {
                        _loc_11.url = _loc_11.url + ("?" + _loc_9);
                    }
                    _loc_3.push(_loc_11);
                }
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleQueryAttachmentInfos:{1}", id, _loc_3);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            if (hasEventListener(AttachmentEvent.QUERY_ATTACHMENT_INFOS_COMPLETE))
            {
                _loc_12 = new AttachmentEvent(AttachmentEvent.QUERY_ATTACHMENT_INFOS_COMPLETE);
                _loc_12.attachmentInfos = _loc_3;
                dispatchEvent(_loc_12);
            }
            return;
        }// end function

        public function deleteAttachments(objectId:Number, attachmentIds:Array, rollbackOnFailure:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var _loc_5:* = new URLVariables();
            _loc_5.f = "json";
            if (this.gdbVersion)
            {
                _loc_5.gdbVersion = this.gdbVersion;
            }
            if (attachmentIds)
            {
                _loc_5.attachmentIds = attachmentIds.join();
            }
            _loc_5.rollbackOnFailure = rollbackOnFailure;
            var _loc_6:* = "/" + objectId + "/deleteAttachments";
            var _loc_7:* = sendURLVariables(_loc_6, _loc_5, responder, this.handleDeleteAttachments);
            _loc_7["objectId"] = objectId;
            return _loc_7;
        }// end function

        private function handleDeleteAttachments(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:Array = null;
            var _loc_4:IResponder = null;
            var _loc_5:Object = null;
            var _loc_6:FeatureEditResult = null;
            var _loc_7:AttachmentEvent = null;
            if (decodedObject)
            {
            }
            if (decodedObject.deleteAttachmentResults is Array)
            {
                _loc_3 = [];
                for each (_loc_5 in decodedObject.deleteAttachmentResults)
                {
                    
                    _loc_6 = FeatureEditResult.toFeatureEditResult(_loc_5);
                    _loc_6.attachmentId = _loc_6.objectId;
                    _loc_6.objectId = asyncToken["objectId"];
                    _loc_3.push(_loc_6);
                }
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDeleteAttachments:{1}", id, _loc_3);
            }
            for each (_loc_4 in asyncToken.responders)
            {
                
                _loc_4.result(_loc_3);
            }
            if (hasEventListener(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE))
            {
                _loc_7 = new AttachmentEvent(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE);
                _loc_7.featureEditResults = _loc_3;
                dispatchEvent(_loc_7);
            }
            return;
        }// end function

        public function addAttachment(objectId:Number, data:ByteArray, name:String, contentType:String = null, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var multipartURLLoader:MultipartURLLoader;
            var p:String;
            var onComplete:Function;
            var onIOError:Function;
            var onSecurityError:Function;
            var objectId:* = objectId;
            var data:* = data;
            var name:* = name;
            var contentType:* = contentType;
            var responder:* = responder;
            onComplete = function (event:Event) : void
            {
                var _loc_3:FeatureEditResult = null;
                var _loc_4:IResponder = null;
                var _loc_5:AttachmentEvent = null;
                var _loc_2:* = JSONUtil.decode(multipartURLLoader.loader.data);
                if (_loc_2.error)
                {
                    handleError(_loc_2.error, asyncToken);
                }
                else
                {
                    _loc_3 = FeatureEditResult.toFeatureEditResult(_loc_2.addAttachmentResult);
                    _loc_3.attachmentId = _loc_3.objectId;
                    _loc_3.objectId = objectId;
                    for each (_loc_4 in asyncToken.responders)
                    {
                        
                        _loc_4.result(_loc_3);
                    }
                    if (hasEventListener(AttachmentEvent.ADD_ATTACHMENT_COMPLETE))
                    {
                        _loc_5 = new AttachmentEvent(AttachmentEvent.ADD_ATTACHMENT_COMPLETE);
                        _loc_5.featureEditResult = _loc_3;
                        dispatchEvent(_loc_5);
                    }
                }
                return;
            }// end function
            ;
            onIOError = function (event:IOErrorEvent) : void
            {
                ioErrorHandler(event, asyncToken);
                return;
            }// end function
            ;
            onSecurityError = function (event:SecurityErrorEvent) : void
            {
                securityErrorHandler(event, asyncToken);
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var urlVariables:* = this.getURLandProxyParams();
            urlVariables.f = "json";
            if (this.gdbVersion)
            {
                urlVariables.gdbVersion = this.gdbVersion;
            }
            var credential:* = IdentityManager.instance.findCredential(url);
            if (credential)
            {
            }
            if (credential.token)
            {
                urlVariables.token = credential.token;
            }
            else if (this.token)
            {
                urlVariables.token = this.token;
            }
            multipartURLLoader = new MultipartURLLoader();
            var _loc_7:int = 0;
            var _loc_8:* = urlVariables;
            while (_loc_8 in _loc_7)
            {
                
                p = _loc_8[_loc_7];
                multipartURLLoader.addVariable(p, urlVariables[p]);
            }
            if (!contentType)
            {
                contentType = this.getContentType(name);
            }
            multipartURLLoader.addFile(data, name, "attachment", contentType);
            var path:* = this.getProxiedURL() + "/" + objectId + "/addAttachment";
            multipartURLLoader.load(path);
            multipartURLLoader.addEventListener(Event.COMPLETE, onComplete);
            multipartURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            multipartURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            return asyncToken;
        }// end function

        public function updateAttachment(objectId:Number, attachmentId:Number, data:ByteArray, name:String, contentType:String = null, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var multipartURLLoader:MultipartURLLoader;
            var p:String;
            var onComplete:Function;
            var onIOError:Function;
            var onSecurityError:Function;
            var objectId:* = objectId;
            var attachmentId:* = attachmentId;
            var data:* = data;
            var name:* = name;
            var contentType:* = contentType;
            var responder:* = responder;
            onComplete = function (event:Event) : void
            {
                var _loc_3:FeatureEditResult = null;
                var _loc_4:IResponder = null;
                var _loc_5:AttachmentEvent = null;
                var _loc_2:* = JSONUtil.decode(multipartURLLoader.loader.data);
                if (_loc_2.error)
                {
                    handleError(_loc_2.error, asyncToken);
                }
                else
                {
                    _loc_3 = FeatureEditResult.toFeatureEditResult(_loc_2.updateAttachmentResult);
                    _loc_3.attachmentId = _loc_3.objectId;
                    _loc_3.objectId = objectId;
                    for each (_loc_4 in asyncToken.responders)
                    {
                        
                        _loc_4.result(_loc_3);
                    }
                    if (hasEventListener(AttachmentEvent.UPDATE_ATTACHMENT_COMPLETE))
                    {
                        _loc_5 = new AttachmentEvent(AttachmentEvent.UPDATE_ATTACHMENT_COMPLETE);
                        _loc_5.featureEditResult = _loc_3;
                        dispatchEvent(_loc_5);
                    }
                }
                return;
            }// end function
            ;
            onIOError = function (event:IOErrorEvent) : void
            {
                ioErrorHandler(event, asyncToken);
                return;
            }// end function
            ;
            onSecurityError = function (event:SecurityErrorEvent) : void
            {
                securityErrorHandler(event, asyncToken);
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var urlVariables:* = this.getURLandProxyParams();
            urlVariables.f = "json";
            if (this.gdbVersion)
            {
                urlVariables.gdbVersion = this.gdbVersion;
            }
            urlVariables.attachmentId = attachmentId;
            var credential:* = IdentityManager.instance.findCredential(url);
            if (credential)
            {
            }
            if (credential.token)
            {
                urlVariables.token = credential.token;
            }
            else if (this.token)
            {
                urlVariables.token = this.token;
            }
            multipartURLLoader = new MultipartURLLoader();
            var _loc_8:int = 0;
            var _loc_9:* = urlVariables;
            while (_loc_9 in _loc_8)
            {
                
                p = _loc_9[_loc_8];
                multipartURLLoader.addVariable(p, urlVariables[p]);
            }
            if (!contentType)
            {
                contentType = this.getContentType(name);
            }
            multipartURLLoader.addFile(data, name, "attachment", contentType);
            var path:* = this.getProxiedURL() + "/" + objectId + "/updateAttachment";
            multipartURLLoader.load(path);
            multipartURLLoader.addEventListener(Event.COMPLETE, onComplete);
            multipartURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            multipartURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            return asyncToken;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent, asyncToken:AsyncToken) : void
        {
            handleStringError(event.text, asyncToken);
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent, asyncToken:AsyncToken) : void
        {
            handleStringError(event.text, asyncToken);
            throw new SecurityError(event.text);
        }// end function

        private function getProxiedURL() : String
        {
            var _loc_1:String = null;
            var _loc_3:URL = null;
            var _loc_2:* = new URL(this.url);
            _loc_1 = _loc_2.path ? (_loc_2.path) : ("");
            if (this.proxyURL)
            {
                _loc_3 = new URL(this.proxyURL);
                _loc_1 = _loc_3.path + "?" + _loc_1;
            }
            return _loc_1;
        }// end function

        private function getURLandProxyParams() : URLVariables
        {
            var _loc_2:String = null;
            var _loc_4:URL = null;
            var _loc_1:* = new URLVariables();
            var _loc_3:* = new URL(this.url);
            for (_loc_2 in _loc_3.query)
            {
                
                _loc_1[_loc_2] = _loc_3.query[_loc_2];
            }
            if (this.proxyURL)
            {
                _loc_4 = new URL(this.proxyURL);
                if (_loc_4.query)
                {
                    for (_loc_2 in _loc_4.query)
                    {
                        
                        if (!_loc_1[_loc_2])
                        {
                            _loc_1[_loc_2] = _loc_4.query[_loc_2];
                        }
                    }
                }
            }
            return _loc_1;
        }// end function

        private function getContentType(name:String) : String
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_2:String = "application/octet-stream";
            if (name)
            {
                _loc_3 = name.lastIndexOf(".");
                if (_loc_3 != -1)
                {
                    _loc_4 = name.substring((_loc_3 + 1));
                    _loc_5 = MIME_MAP[_loc_4.toLowerCase()];
                    if (_loc_5)
                    {
                        _loc_2 = _loc_5;
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
