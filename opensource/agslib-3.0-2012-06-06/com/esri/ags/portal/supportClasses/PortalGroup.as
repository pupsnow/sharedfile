package com.esri.ags.portal.supportClasses
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.tasks.*;
    import com.esri.ags.portal.utils.*;
    import flash.events.*;
    import mx.rpc.*;

    public class PortalGroup extends EventDispatcher
    {
        private var m_id:String;
        private var m_title:String;
        private var m_isInvitationOnly:Boolean;
        private var m_owner:String;
        private var m_description:String;
        private var m_snippet:String;
        private var m_tags:Array;
        private var m_thumbnailURL:String;
        private var m_created:Date;
        private var m_modified:Date;
        private var m_access:String;
        private var m_portal:Portal;

        public function PortalGroup()
        {
            this.m_tags = [];
            return;
        }// end function

        public function get id() : String
        {
            return this.m_id;
        }// end function

        public function get title() : String
        {
            return this.m_title;
        }// end function

        public function get isInvitationOnly() : Boolean
        {
            return this.m_isInvitationOnly;
        }// end function

        public function get owner() : String
        {
            return this.m_owner;
        }// end function

        public function get description() : String
        {
            return this.m_description;
        }// end function

        public function get snippet() : String
        {
            return this.m_snippet;
        }// end function

        public function get tags() : Array
        {
            return this.m_tags.concat();
        }// end function

        public function get thumbnailURL() : String
        {
            if (!this.m_thumbnailURL)
            {
                return null;
            }
            var _loc_1:* = this.m_portal.endpointURL.appendPath("community/groups/" + this.m_id + "/info/" + this.m_thumbnailURL);
            var _loc_2:* = IdentityManager.instance.findCredential(this.m_portal.endpointURL.sourceURL);
            if (_loc_2)
            {
                _loc_1.addURLVariable("token", _loc_2.token);
            }
            return _loc_1.toString();
        }// end function

        public function get created() : Date
        {
            var _loc_1:* = new Date();
            _loc_1.time = this.m_created.time;
            return _loc_1;
        }// end function

        public function get modified() : Date
        {
            var _loc_1:* = new Date();
            _loc_1.time = this.m_modified.time;
            return _loc_1;
        }// end function

        public function get access() : String
        {
            return this.m_access;
        }// end function

        public function get portal() : Portal
        {
            return this.m_portal;
        }// end function

        function setPortal(value:Portal) : void
        {
            this.m_portal = value;
            return;
        }// end function

        public function getMembers(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new GetGroupMembersTask(this);
            return _loc_2.execute(responder);
        }// end function

        public function queryItems(queryParameters:PortalQueryParameters, responder:IResponder = null) : AsyncToken
        {
            var _loc_3:* = new PortalQueryTask(this.m_portal, this);
            return _loc_3.queryItems(queryParameters.clone().inGroup(this.id), responder);
        }// end function

        static function fromJSON(obj:Object) : PortalGroup
        {
            var _loc_2:PortalGroup = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new PortalGroup;
                _loc_2.m_id = obj.id;
                _loc_2.m_title = obj.title;
                _loc_2.m_isInvitationOnly = obj.isInvitationOnly;
                _loc_2.m_owner = obj.owner;
                _loc_2.m_description = obj.description;
                _loc_2.m_snippet = obj.snippet;
                for each (_loc_3 in obj.tags)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_tags.push(String(_loc_3));
                    }
                }
                _loc_2.m_thumbnailURL = obj.thumbnail;
                _loc_2.m_created = new Date();
                _loc_2.m_created.time = obj.created;
                _loc_2.m_modified = new Date();
                _loc_2.m_modified.time = obj.modified;
                _loc_2.m_access = obj.access;
            }
            return _loc_2;
        }// end function

    }
}
