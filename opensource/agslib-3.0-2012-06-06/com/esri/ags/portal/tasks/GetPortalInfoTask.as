package com.esri.ags.portal.tasks
{
    import GetPortalInfoTask.as$400.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.portal.utils.*;
    import com.esri.ags.tasks.*;
    import flash.net.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class GetPortalInfoTask extends BaseTask
    {
        private var m_portal:Portal;
        private var m_info:PortalInfo;
        private var m_user:PortalUser;

        public function GetPortalInfoTask(portal:Portal)
        {
            super(portal.endpointURL.sourceURL);
            this.m_portal = portal;
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

        public function signIn(username:String = null, password:String = null, responder:IResponder = null) : AsyncToken
        {
            var _loc_4:* = new GetCredentialTask(this.m_portal);
            var _loc_5:* = new AsyncToken(null);
            if (responder)
            {
                _loc_5.addResponder(responder);
            }
            var _loc_6:* = new AsyncResponder(this.handleCredential, handleFault, _loc_5);
            _loc_4.execute(username, password, _loc_6);
            return _loc_5;
        }// end function

        public function getInfo(responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, url);
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            if (!this.m_portal.signedIn)
            {
                if (urlObj.query)
                {
                }
            }
            var _loc_3:* = urlObj.query.token;
            if (this.m_portal.portalCulture)
            {
            }
            if (!_loc_3)
            {
                _loc_2.culture = this.m_portal.portalCulture;
            }
            return sendURLVariables("/accounts/self", _loc_2, responder, this.handlePortalInfoObject);
        }// end function

        private function getInfo2(asyncToken:AsyncToken) : void
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, url);
            }
            var _loc_2:* = new URLVariables();
            _loc_2.f = "json";
            sendURLVariables2("/accounts/self", _loc_2, this.handlePortalInfoObject, asyncToken);
            return;
        }// end function

        private function handleCredential(credential:Credential, asyncToken:AsyncToken) : void
        {
            if (Log.isDebug())
            {
                logger.debug("::handleCredential:{1}", credential);
            }
            this.getInfo2(asyncToken);
            return;
        }// end function

        private function handlePortalInfoObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var task:GetPortalInfoTask;
            var responder:IResponder;
            var portalGetTask:PortalGetTask;
            var decodedObject:* = decodedObject;
            var asyncToken:* = asyncToken;
            this.m_info = PortalInfo.fromJSON(decodedObject);
            this.m_info.setPortal(this.m_portal);
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, ObjectUtil.toString(this.m_info, null, ["portal"]));
            }
            task;
            var endpointURL:* = this.m_portal.endpointURL;
            var portalCulture:* = this.m_portal.portalCulture;
            var signedIn:* = this.m_portal.signedIn;
            endpointURL.update(endpointURL.withSSL(this.m_info.allSSL).sourceURL);
            if (this.m_info.culture)
            {
                if (!signedIn)
                {
                }
                if (this.m_info.culture == portalCulture)
                {
                    if (signedIn)
                    {
                    }
                }
            }
            if (!portalCulture)
            {
                var _loc_4:* = this.m_info.culture;
                portalCulture = this.m_info.culture;
                this.m_portal.portalCulture = _loc_4;
            }
            if (this.m_info.username)
            {
            }
            if (signedIn)
            {
                if (signedIn)
                {
                }
                if (this.m_info.username)
                {
                }
            }
            if (this.m_info.username != this.m_portal.user.username)
            {
                portalGetTask = new PortalGetTask(this.m_portal);
                responder = new AsyncResponder(function (user:PortalUser, asyncToken:AsyncToken) : void
            {
                m_user = user;
                if (asyncToken)
                {
                    for each (responder in asyncToken.responders)
                    {
                        
                        responder.result(task);
                    }
                }
                return;
            }// end function
            , handleFault, asyncToken);
                portalGetTask.getUser(this.m_info.username, responder);
            }
            else
            {
                this.m_user = this.m_portal.user;
                if (asyncToken)
                {
                    var _loc_4:int = 0;
                    var _loc_5:* = asyncToken.responders;
                    while (_loc_5 in _loc_4)
                    {
                        
                        responder = _loc_5[_loc_4];
                        responder.result(task);
                    }
                }
            }
            return;
        }// end function

    }
}
