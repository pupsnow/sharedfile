package com.esri.ags.portal.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.tasks.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;

    public class GetGroupMembersTask extends BaseTask
    {
        private var m_group:PortalGroup;

        public function GetGroupMembersTask(group:PortalGroup)
        {
            super(group.portal.endpointURL.sourceURL);
            this.m_group = group;
            return;
        }// end function

        public function get group() : PortalGroup
        {
            return this.m_group;
        }// end function

        public function execute(responder:IResponder = null) : AsyncToken
        {
            if (this.group.id)
            {
            }
            if (this.group.id == "")
            {
                logger.error("groupId is not defined");
                return null;
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            return sendURLVariables("/community/groups/" + this.group.id + "/users", _loc_2, responder, this.handleDecodedObject);
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:* = PortalGroupMembers.fromJSON(decodedObject);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, ObjectUtil.toString(_loc_3));
            }
            this.applyResult(_loc_3, asyncToken);
            this.group.dispatchEvent(new PortalEvent(PortalEvent.GET_MEMBERS_COMPLETE, null, _loc_3, null, null));
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

        private function handleFaultEvent(event:FaultEvent) : void
        {
            this.group.dispatchEvent(event);
            return;
        }// end function

    }
}
