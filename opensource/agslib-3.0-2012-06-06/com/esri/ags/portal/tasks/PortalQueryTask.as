package com.esri.ags.portal.tasks
{
    import PortalQueryTask.as$405.*;
    import com.esri.ags.events.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.tasks.*;
    import flash.events.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class PortalQueryTask extends BaseTask
    {
        private var m_portal:Portal;
        private var m_target:IEventDispatcher;

        public function PortalQueryTask(portal:Portal, target:IEventDispatcher = null)
        {
            super(portal.endpointURL.sourceURL);
            this.m_portal = portal;
            this.m_target = target;
            addEventListener(FaultEvent.FAULT, this.handleFaultEvent);
            return;
        }// end function

        public function get portal() : Portal
        {
            return this.m_portal;
        }// end function

        public function get target() : IEventDispatcher
        {
            if (this.m_target)
            {
                return this.m_target;
            }
            return this.portal;
        }// end function

        public function queryGroups(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            return this.execute("/community/groups", this.handleGroupDecodedObject, queryParameters, responder);
        }// end function

        public function queryItems(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            return this.execute("/search", this.handleItemDecodedObject, queryParameters, responder);
        }// end function

        public function queryUsers(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            return this.execute("/community/users", this.handleUserDecodedObject, queryParameters, responder);
        }// end function

        private function execute(searchSuffix:String, decoder:Function, queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            if (queryParameters == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::execute::a portalQueryParameters was not defined", id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, queryParameters);
            }
            var _loc_5:* = this.getURLVariables(queryParameters);
            var _loc_6:* = new PortalQueryTaskAsyncToken();
            _loc_6.queryParameters = queryParameters;
            if (responder)
            {
                _loc_6.addResponder(responder);
            }
            return sendURLVariables2(searchSuffix, _loc_5, decoder, _loc_6);
        }// end function

        private function getURLVariables(queryParameters:PortalQueryParameters) : URLVariables
        {
            var _loc_2:* = new URLVariables();
            var _loc_3:* = queryParameters.clone();
            _loc_2.f = "json";
            if (this.m_portal.portalCulture)
            {
            }
            if (!this.m_portal.signedIn)
            {
                _loc_2.culture = this.m_portal.portalCulture;
            }
            _loc_2.start = _loc_3.startIndex;
            _loc_2.num = _loc_3.limit;
            if (_loc_3.query)
            {
            }
            if (_loc_3.query == "")
            {
                logger.warn("queryParameters.query is not set");
            }
            else
            {
                if (this.m_portal.info.organizationId)
                {
                }
                if (!this.m_portal.info.canSearchPublic)
                {
                    _loc_3.query = "(" + _loc_3.query + ")";
                    _loc_3.addQueryCondition("orgid:" + this.m_portal.info.organizationId, "AND");
                }
                _loc_2.q = _loc_3.query;
            }
            if (_loc_3.sortField)
            {
                _loc_2.sortField = _loc_3.sortField;
            }
            if (_loc_3.sortOrder !== PortalQueryParameters.ASCENDING_SORT)
            {
            }
            if (_loc_3.sortOrder === PortalQueryParameters.DESCENDING_SORT)
            {
                _loc_2.sortOrder = _loc_3.sortOrder;
            }
            return _loc_2;
        }// end function

        private function handleGroupDecodedObject(decodedObject:Object, asyncToken:PortalQueryTaskAsyncToken) : void
        {
            var _loc_4:PortalGroup = null;
            var _loc_5:Object = null;
            var _loc_3:Array = [];
            if (decodedObject.results)
            {
                for each (_loc_5 in decodedObject.results)
                {
                    
                    _loc_4 = PortalGroup.fromJSON(_loc_5);
                    _loc_4.setPortal(this.m_portal);
                    _loc_3.push(_loc_4);
                }
            }
            this.handleDecodedObject(PortalEvent.QUERY_GROUPS_COMPLETE, decodedObject, _loc_3, asyncToken);
            return;
        }// end function

        private function handleItemDecodedObject(decodedObject:Object, asyncToken:PortalQueryTaskAsyncToken) : void
        {
            var _loc_4:PortalItem = null;
            var _loc_5:Object = null;
            var _loc_3:Array = [];
            if (decodedObject.results)
            {
                for each (_loc_5 in decodedObject.results)
                {
                    
                    _loc_4 = PortalItem.fromJSON(_loc_5);
                    _loc_4.setPortal(this.m_portal);
                    _loc_3.push(_loc_4);
                }
            }
            this.handleDecodedObject(PortalEvent.QUERY_ITEMS_COMPLETE, decodedObject, _loc_3, asyncToken);
            return;
        }// end function

        private function handleUserDecodedObject(decodedObject:Object, asyncToken:PortalQueryTaskAsyncToken) : void
        {
            var _loc_4:PortalUser = null;
            var _loc_5:Object = null;
            var _loc_3:Array = [];
            if (decodedObject.results)
            {
                for each (_loc_5 in decodedObject.results)
                {
                    
                    _loc_4 = PortalUser.fromJSON(_loc_5);
                    _loc_4.setPortal(this.m_portal);
                    _loc_3.push(_loc_4);
                }
            }
            this.handleDecodedObject(PortalEvent.QUERY_USERS_COMPLETE, decodedObject, _loc_3, asyncToken);
            return;
        }// end function

        private function handleDecodedObject(eventType:String, decodedObject:Object, results:Array, asyncToken:PortalQueryTaskAsyncToken) : void
        {
            var _loc_6:PortalQueryResult = null;
            var _loc_5:* = decodedObject.total;
            var _loc_7:* = asyncToken.queryParameters;
            var _loc_8:PortalQueryParameters = null;
            if (decodedObject.nextStart != -1)
            {
                _loc_8 = _loc_7.clone();
                _loc_8.query = decodedObject.query;
                _loc_8.startIndex = decodedObject.nextStart;
                _loc_8.limit = _loc_7.limit;
                _loc_8.sortOrder = _loc_7.sortOrder;
            }
            _loc_6 = new PortalQueryResult(_loc_7, _loc_8, _loc_5, results);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, results);
            }
            this.dispatchResult(_loc_6, asyncToken);
            this.target.dispatchEvent(new PortalEvent(eventType, _loc_6));
            return;
        }// end function

        private function dispatchResult(result:PortalQueryResult, asyncToken:AsyncToken) : void
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

        private function handleFaultEvent(event:FaultEvent) : void
        {
            this.target.dispatchEvent(event);
            return;
        }// end function

    }
}
