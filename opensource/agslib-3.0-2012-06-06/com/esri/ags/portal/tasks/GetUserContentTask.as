package com.esri.ags.portal.tasks
{
    import GetUserContentTask.as$385.*;
    import com.esri.ags.events.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.tasks.*;
    import flash.events.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class GetUserContentTask extends BaseTask
    {
        private var m_portal:Portal;
        private var m_target:IEventDispatcher;

        public function GetUserContentTask(portal:Portal, target:IEventDispatcher)
        {
            super(portal.endpointURL.sourceURL);
            this.m_portal = portal;
            this.m_target = target;
            return;
        }// end function

        public function getFolders(username:String, responder:IResponder = null) : AsyncToken
        {
            var username:* = username;
            var responder:* = responder;
            var token:* = new AsyncToken(null);
            if (responder)
            {
                token.addResponder(responder);
            }
            var asyncResponder:* = new AsyncResponder(function (result:PortalUserContentFetchResult, token:AsyncToken) : void
            {
                m_target.dispatchEvent(new PortalEvent(PortalEvent.GET_FOLDERS_COMPLETE, null, null, result.folders, null));
                applyResult(result.folders, token);
                return;
            }// end function
            , function (fault:Fault, token:AsyncToken) : void
            {
                dispatchFault(fault, token);
                return;
            }// end function
            , token);
            this.getContent(username, null, asyncResponder);
            return token;
        }// end function

        public function getItems(username:String, folderId:String, responder:IResponder) : AsyncToken
        {
            var username:* = username;
            var folderId:* = folderId;
            var responder:* = responder;
            var token:* = new AsyncToken(null);
            if (responder)
            {
                token.addResponder(responder);
            }
            var asyncResponder:* = new AsyncResponder(function (result:PortalUserContentFetchResult, token:AsyncToken) : void
            {
                m_target.dispatchEvent(new PortalEvent(PortalEvent.GET_ITEMS_COMPLETE, null, null, null, result.items));
                applyResult(result.items, token);
                return;
            }// end function
            , function (fault:Fault, token:AsyncToken) : void
            {
                dispatchFault(fault, token);
                return;
            }// end function
            , token);
            this.getContent(username, folderId, asyncResponder);
            return token;
        }// end function

        public function getContent(username:String, folderId:String = null, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, url);
            }
            var _loc_4:* = new URLVariables();
            _loc_4.f = "json";
            var _loc_5:* = "/content/users/" + username;
            if (folderId)
            {
            }
            if (folderId !== "")
            {
                _loc_5 = _loc_5 + ("/" + folderId);
            }
            var _loc_6:* = new UserContentRequest(username, responder);
            sendURLVariables2(_loc_5, _loc_4, this.handleDecodedObject, _loc_6);
            return _loc_6.innerToken;
        }// end function

        private function handleDecodedObject(decodedObject:Object, request:UserContentRequest) : void
        {
            var _loc_3:PortalUserContentFetchResult = null;
            var _loc_7:PortalItem = null;
            var _loc_8:Object = null;
            var _loc_9:PortalFolder = null;
            var _loc_10:Object = null;
            var _loc_4:* = decodedObject.currentFolder;
            var _loc_5:Array = [];
            if (decodedObject.items)
            {
                for each (_loc_8 in decodedObject.items)
                {
                    
                    _loc_7 = PortalItem.fromJSON(_loc_8);
                    _loc_7.setPortal(this.m_portal);
                    _loc_5.push(_loc_7);
                }
            }
            var _loc_6:Array = [];
            if (decodedObject.folders)
            {
                for each (_loc_10 in decodedObject.folders)
                {
                    
                    _loc_9 = PortalFolder.fromJSON(_loc_10);
                    _loc_9.setPortal(this.m_portal);
                    _loc_6.push(_loc_9);
                }
            }
            _loc_3 = new PortalUserContentFetchResult(request.username, _loc_5, _loc_6, _loc_4);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, _loc_5);
            }
            this.applyResult(_loc_3, request.innerToken);
            return;
        }// end function

        private function applyResult(result:Object, asyncToken:AsyncToken) : void
        {
            var event:ResultEvent;
            var responder:IResponder;
            var result:* = result;
            var asyncToken:* = asyncToken;
            event = ResultEvent.createEvent(result, asyncToken);
            var _loc_4:int = 0;
            var _loc_5:* = asyncToken.responders;
            do
            {
                
                responder = _loc_5[_loc_4];
                try
                {
                    responder.mx.rpc:IResponder::result(result);
                }
                catch (error:Error)
                {
                    if (error.errorID == 1034)
                    {
                        responder.mx.rpc:IResponder::result(event);
                    }
                    else
                    {
                        throw error;
                    }
                }
            }while (_loc_5 in _loc_4)
            dispatchEvent(event);
            return;
        }// end function

        private function dispatchFault(fault:Fault, asyncToken:AsyncToken) : void
        {
            var event:FaultEvent;
            var responder:IResponder;
            var fault:* = fault;
            var asyncToken:* = asyncToken;
            event = FaultEvent.createEvent(fault, asyncToken);
            var _loc_4:int = 0;
            var _loc_5:* = asyncToken.responders;
            do
            {
                
                responder = _loc_5[_loc_4];
                try
                {
                    responder.mx.rpc:IResponder::fault(fault);
                }
                catch (error:Error)
                {
                    if (error.errorID == 1034)
                    {
                        responder.mx.rpc:IResponder::fault(event);
                    }
                    else
                    {
                        throw error;
                    }
                }
            }while (_loc_5 in _loc_4)
            dispatchEvent(event);
            this.m_target.dispatchEvent(event);
            return;
        }// end function

    }
}
