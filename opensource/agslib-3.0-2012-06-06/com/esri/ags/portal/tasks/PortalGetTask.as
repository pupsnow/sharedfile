package com.esri.ags.portal.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.tasks.*;
    import flash.events.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class PortalGetTask extends BaseTask
    {
        private var m_portal:Portal;
        private var m_target:IEventDispatcher;

        public function PortalGetTask(portal:Portal = null, target:IEventDispatcher = null)
        {
            super(portal.endpointURL.sourceURL);
            this.m_portal = portal;
            this.m_target = target;
            return;
        }// end function

        public function get portal() : Portal
        {
            return this.m_portal;
        }// end function

        public function set portal(value:Portal) : void
        {
            this.m_portal = value;
            super.url = this.portal.endpointURL.sourceURL;
            return;
        }// end function

        public function get target() : IEventDispatcher
        {
            return this.m_target;
        }// end function

        public function getItem(itemId:String, responder:IResponder = null) : AsyncToken
        {
            return this.execute("/content/items", this.handleItemDecodedObject, itemId, responder);
        }// end function

        public function getUser(username:String, responder:IResponder = null) : AsyncToken
        {
            return this.execute("/community/users", this.handleUserDecodedObject, username, responder);
        }// end function

        private function execute(searchSuffix:String, decoder:Function, id:String, responder:IResponder = null) : AsyncToken
        {
            if (id == null)
            {
                if (Log.isWarn())
                {
                    logger.warn("{0}::execute::a id was not defined", this.id);
                }
                return null;
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", this.id, id);
            }
            var _loc_5:* = this.getURLVariables();
            return sendURLVariables(searchSuffix + "/" + id, _loc_5, responder, decoder);
        }// end function

        private function getURLVariables() : URLVariables
        {
            var _loc_1:* = new URLVariables();
            _loc_1.f = "json";
            if (this.m_portal.portalCulture)
            {
                _loc_1.culture = this.m_portal.portalCulture;
            }
            return _loc_1;
        }// end function

        private function handleItemDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:PortalItem = null;
            if (decodedObject)
            {
                _loc_3 = PortalItem.fromJSON(decodedObject);
                _loc_3.setPortal(this.m_portal);
            }
            this.handleDecodedObject(_loc_3, asyncToken);
            if (this.target)
            {
                this.target.dispatchEvent(new PortalEvent(PortalEvent.GET_ITEM_COMPLETE, null, null, null, null, _loc_3));
            }
            return;
        }// end function

        private function handleUserDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:PortalUser = null;
            if (decodedObject)
            {
                _loc_3 = PortalUser.fromJSON(decodedObject);
                _loc_3.setPortal(this.m_portal);
            }
            this.handleDecodedObject(_loc_3, asyncToken);
            return;
        }// end function

        private function handleDecodedObject(portalObject:Object, asyncToken:AsyncToken) : void
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, portalObject);
            }
            this.dispatchResult(portalObject, asyncToken);
            return;
        }// end function

        private function dispatchResult(result:Object, asyncToken:AsyncToken) : void
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

    }
}
