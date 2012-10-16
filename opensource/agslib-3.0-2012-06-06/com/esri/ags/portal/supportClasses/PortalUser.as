package com.esri.ags.portal.supportClasses
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.tasks.*;
    import com.esri.ags.portal.utils.*;
    import flash.events.*;
    import mx.rpc.*;

    public class PortalUser extends EventDispatcher
    {
        private var m_username:String;
        private var m_fullname:String;
        private var m_culture:String;
        private var m_description:String;
        private var m_email:String;
        private var m_access:String;
        private var m_tags:Array;
        private var m_organizationId:String;
        private var m_organizationRole:String;
        private var m_thumbnailURL:String;
        private var m_created:Date;
        private var m_modified:Date;
        private var m_groups:Array;
        private var m_portal:Portal;

        public function PortalUser()
        {
            this.m_tags = [];
            this.m_groups = [];
            return;
        }// end function

        public function get username() : String
        {
            return this.m_username;
        }// end function

        public function get fullname() : String
        {
            return this.m_fullname;
        }// end function

        public function get culture() : String
        {
            return this.m_culture;
        }// end function

        public function get description() : String
        {
            return this.m_description;
        }// end function

        public function get email() : String
        {
            return this.m_email;
        }// end function

        public function get access() : String
        {
            return this.m_access;
        }// end function

        public function get tags() : Array
        {
            return this.m_tags.concat();
        }// end function

        public function get organizationId() : String
        {
            return this.m_organizationId;
        }// end function

        public function get organizationRole() : String
        {
            return this.m_organizationRole;
        }// end function

        public function get thumbnailURL() : String
        {
            if (!this.m_thumbnailURL)
            {
                return null;
            }
            var _loc_1:* = this.m_portal.endpointURL.appendPath("community/users/" + this.username + "/info/" + this.m_thumbnailURL);
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

        public function get groups() : Array
        {
            return this.m_groups.concat();
        }// end function

        public function get portal() : Portal
        {
            return this.m_portal;
        }// end function

        function setPortal(value:Portal) : void
        {
            var _loc_2:PortalGroup = null;
            this.m_portal = value;
            for each (_loc_2 in this.m_groups)
            {
                
                _loc_2.setPortal(value);
            }
            return;
        }// end function

        public function getFolders(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new GetUserContentTask(this.portal, this);
            return _loc_2.getFolders(this.username, responder);
        }// end function

        public function getItems(folderId:String, responder:IResponder = null) : AsyncToken
        {
            var _loc_3:* = new GetUserContentTask(this.portal, this);
            return _loc_3.getItems(this.username, folderId, responder);
        }// end function

        static function fromJSON(obj:Object) : PortalUser
        {
            var _loc_2:PortalUser = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new PortalUser;
                _loc_2.m_access = obj.access;
                _loc_2.m_created = new Date();
                _loc_2.m_created.time = obj.created;
                if (obj.culture)
                {
                }
                if (obj.region)
                {
                    _loc_2.m_culture = obj.culture + "-" + obj.region;
                }
                _loc_2.m_description = obj.description;
                _loc_2.m_email = obj.email;
                _loc_2.m_fullname = obj.fullName;
                _loc_2.m_modified = new Date();
                _loc_2.m_modified.time = obj.modified;
                _loc_2.m_organizationId = obj.orgId;
                _loc_2.m_organizationRole = obj.role;
                for each (_loc_3 in obj.tags)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_tags.push(String(_loc_3));
                    }
                }
                _loc_2.m_thumbnailURL = obj.thumbnail;
                for each (_loc_3 in obj.groups)
                {
                    
                    _loc_2.m_groups.push(PortalGroup.fromJSON(_loc_3));
                }
                _loc_2.m_username = obj.username;
            }
            return _loc_2;
        }// end function

    }
}
