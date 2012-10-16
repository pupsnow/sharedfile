package com.esri.ags.portal.supportClasses
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.utils.*;
    import flash.events.*;
    import mx.utils.*;

    public class PortalInfo extends EventDispatcher
    {
        private var m_access:String;
        private var m_allSSL:Boolean;
        private var m_basemapGalleryGroupQuery:String;
        private var m_canSearchPublic:Boolean;
        private var m_canSharePublic:Boolean;
        private var m_culture:String;
        private var m_defaultBasemap:Object;
        private var m_defaultExtent:Extent;
        private var m_description:String;
        private var m_featuredGroupsQueries:Array;
        private var m_featuredItemsGroupQuery:String;
        private var m_portalName:String;
        private var m_portalMode:String;
        private var m_organizationId:String;
        private var m_isOrganization:Boolean;
        private var m_organizationName:String;
        private var m_thumbnailURL:String;
        private var m_symbolSetsGroupQuery:String;
        private var m_portal:Portal;
        var username:String;

        public function PortalInfo()
        {
            this.m_featuredGroupsQueries = [];
            return;
        }// end function

        public function get access() : String
        {
            return this.m_access;
        }// end function

        public function get allSSL() : Boolean
        {
            return this.m_allSSL;
        }// end function

        public function get basemapGalleryGroupQuery() : String
        {
            return this.m_basemapGalleryGroupQuery;
        }// end function

        public function get canSearchPublic() : Boolean
        {
            return this.m_canSearchPublic;
        }// end function

        public function get canSharePublic() : Boolean
        {
            return this.m_canSharePublic;
        }// end function

        public function get culture() : String
        {
            return this.m_culture;
        }// end function

        public function get defaultBasemap() : Object
        {
            return this.m_defaultBasemap;
        }// end function

        public function get defaultExtent() : Extent
        {
            return this.m_defaultExtent;
        }// end function

        public function get description() : String
        {
            return this.m_description;
        }// end function

        public function get featuredGroupsQueries() : Array
        {
            return this.m_featuredGroupsQueries.concat();
        }// end function

        public function get featuredItemsGroupQuery() : String
        {
            return this.m_featuredItemsGroupQuery;
        }// end function

        public function get portalName() : String
        {
            return this.m_portalName;
        }// end function

        public function get portalMode() : String
        {
            return this.m_portalMode;
        }// end function

        public function get organizationId() : String
        {
            return this.m_organizationId;
        }// end function

        public function get isOrganization() : Boolean
        {
            return this.m_isOrganization;
        }// end function

        public function get organizationName() : String
        {
            return this.m_organizationName;
        }// end function

        public function get thumbnailURL() : String
        {
            if (!this.m_thumbnailURL)
            {
                return null;
            }
            var _loc_1:* = this.m_portal.endpointURL.appendPath("accounts/self/resources/" + this.m_thumbnailURL);
            var _loc_2:* = IdentityManager.instance.findCredential(this.m_portal.endpointURL.sourceURL);
            if (_loc_2)
            {
                _loc_1.addURLVariable("token", _loc_2.token);
            }
            return _loc_1.toString();
        }// end function

        public function get symbolSetsGroupQuery() : String
        {
            return this.m_symbolSetsGroupQuery;
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

        override public function toString() : String
        {
            return ObjectUtil.toString(this, null, ["portal"]);
        }// end function

        static function fromJSON(obj:Object) : PortalInfo
        {
            var _loc_2:PortalInfo = null;
            var _loc_3:Object = null;
            var _loc_4:String = null;
            if (obj)
            {
                _loc_2 = new PortalInfo;
                _loc_2.m_access = obj.access;
                _loc_2.m_allSSL = obj.allSSL;
                _loc_2.m_basemapGalleryGroupQuery = obj.basemapGalleryGroupQuery;
                _loc_2.m_canSearchPublic = obj.hasOwnProperty("canSearchPublic") ? (obj.canSearchPublic) : (true);
                _loc_2.m_canSharePublic = obj.hasOwnProperty("canSharePublic") ? (obj.canSharePublic) : (true);
                _loc_2.m_culture = obj.culture;
                _loc_2.m_description = obj.description;
                _loc_2.m_defaultBasemap = obj.defaultBasemap;
                if (obj.defaultExtent)
                {
                    _loc_2.m_defaultExtent = Extent.fromJSON(obj.defaultExtent);
                }
                _loc_2.m_featuredItemsGroupQuery = obj.featuredItemsGroupQuery;
                if (obj.featuredGroupsQueries)
                {
                }
                if (obj.featuredGroupsQueries != "")
                {
                    _loc_2.m_featuredGroupsQueries = obj.featuredGroupsQueries;
                }
                else
                {
                    for each (_loc_3 in obj.featuredGroups)
                    {
                        
                        _loc_4 = "";
                        if (_loc_3.title)
                        {
                            _loc_4 = _loc_4 + ("title:\"" + _loc_3.title + "\"");
                        }
                        if (_loc_3.owner)
                        {
                            if (_loc_4.length > 0)
                            {
                                _loc_4 = _loc_4 + " AND ";
                            }
                            _loc_4 = _loc_4 + ("owner:" + _loc_3.owner);
                        }
                        if (_loc_4.length > 0)
                        {
                            _loc_4 = "(" + _loc_4 + ")";
                        }
                        _loc_2.m_featuredGroupsQueries.push(_loc_4);
                    }
                }
                _loc_2.m_organizationId = obj.id;
                if (_loc_2.m_access)
                {
                }
                if (_loc_2.m_access.length <= 0)
                {
                }
                _loc_2.m_isOrganization = false;
                _loc_2.m_organizationName = obj.name;
                _loc_2.m_portalMode = obj.portalMode;
                _loc_2.m_portalName = obj.portalName;
                _loc_2.m_thumbnailURL = obj.thumbnail;
                _loc_2.m_symbolSetsGroupQuery = obj.symbolSetsGroupQuery;
                if (!_loc_2.m_thumbnailURL)
                {
                    _loc_2.m_thumbnailURL = obj.portalThumbnail;
                }
                if (obj.user)
                {
                }
                if (obj.user.username)
                {
                    _loc_2.username = obj.user.username;
                    if (obj.user.culture)
                    {
                    }
                    if (obj.user.region)
                    {
                        _loc_2.m_culture = obj.user.culture + "-" + obj.user.region;
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
