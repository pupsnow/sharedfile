package com.esri.ags.portal.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.utils.*;
    import com.esri.ags.tasks.*;
    import flash.events.*;
    import mx.rpc.*;
    import mx.utils.*;

    public class PortalItem extends EventDispatcher
    {
        private var m_access:String;
        private var m_accessInformation:String;
        private var m_avgRating:Number;
        private var m_created:Date;
        private var m_culture:String;
        private var m_description:String;
        private var m_extent:Extent;
        private var m_id:String;
        private var m_licenseInformation:String;
        private var m_modified:Date;
        private var m_name:String;
        private var m_numComments:uint;
        private var m_numRatings:uint;
        private var m_numViews:uint;
        private var m_owner:String;
        private var m_portal:Portal;
        private var m_snippet:String;
        private var m_spatialReference:SpatialReference;
        private var m_tags:Array;
        private var m_thumbnailURL:String;
        private var m_title:String;
        private var m_type:String;
        private var m_typeKeywords:Array;
        private var m_size:uint;
        private var m_url:String;
        public static const TYPE_WEB_MAP:String = "Web Map";
        public static const TYPE_FEATURE_SERVICE:String = "Feature Service";
        public static const TYPE_MAP_SERVICE:String = "Map Service";
        public static const TYPE_IMAGE_SERVICE:String = "Image Service";
        public static const TYPE_KML_SERVICE:String = "KML";
        public static const TYPE_WMS_SERVICE:String = "WMS";
        public static const TYPE_WMTS_SERVICE:String = "WMTS";
        public static const TYPE_FEATURE_COLLECTION:String = "Feature Collection";
        public static const TYPE_GEODATA_SERVICE:String = "Geodata Service";
        public static const TYPE_GEOMETRY_SERVICE:String = "Geometry Service";
        public static const TYPE_GEOCODING_SERVICE:String = "Geocoding Service";
        public static const TYPE_NETWORK_ANALYSIS_SERVICE:String = "Network Analysis Service";
        public static const TYPE_GEOPROCESSING_SERVICE:String = "Geoprocessing Service";
        public static const TYPE_WEB_MAPPING_APPLICATION:String = "Web Mapping Application";
        public static const TYPE_SYMBOL_SET:String = "Symbol Set";
        public static const TYPE_COLOR_SET:String = "Color Set";
        public static const TYPE_SHAPEFILE:String = "Shapefile";
        public static const TYPE_CSV:String = "CSV";

        public function PortalItem()
        {
            this.m_tags = [];
            this.m_typeKeywords = [];
            return;
        }// end function

        public function get access() : String
        {
            return this.m_access;
        }// end function

        public function get accessInformation() : String
        {
            return this.m_accessInformation;
        }// end function

        public function get avgRating() : Number
        {
            return this.m_avgRating;
        }// end function

        public function get created() : Date
        {
            var _loc_1:* = new Date();
            _loc_1.time = this.m_created.time;
            return _loc_1;
        }// end function

        public function get culture() : String
        {
            return this.m_culture;
        }// end function

        public function get description() : String
        {
            return this.m_description;
        }// end function

        public function get extent() : Extent
        {
            return this.m_extent;
        }// end function

        public function get id() : String
        {
            return this.m_id;
        }// end function

        public function get itemDataURL() : String
        {
            if (this.m_portal)
            {
            }
            if (!this.id)
            {
                return null;
            }
            var _loc_1:* = this.m_portal.endpointURL.appendPath("/content/items/" + this.id + "/data");
            var _loc_2:* = IdentityManager.instance.findCredential(this.m_portal.endpointURL.sourceURL);
            if (_loc_2)
            {
                _loc_1.addURLVariable("token", _loc_2.token);
            }
            return _loc_1.toString();
        }// end function

        public function get itemURL() : String
        {
            if (this.m_portal)
            {
            }
            if (!this.id)
            {
                return null;
            }
            var _loc_1:* = this.m_portal.endpointURL.appendPath("/content/items/" + this.id);
            var _loc_2:* = IdentityManager.instance.findCredential(this.m_portal.endpointURL.sourceURL);
            if (_loc_2)
            {
                _loc_1.addURLVariable("token", _loc_2.token);
            }
            return _loc_1.toString();
        }// end function

        public function get licenseInformation() : String
        {
            return this.m_licenseInformation;
        }// end function

        public function get modified() : Date
        {
            var _loc_1:* = new Date();
            _loc_1.time = this.m_modified.time;
            return _loc_1;
        }// end function

        public function get name() : String
        {
            return this.m_name;
        }// end function

        public function get numComments() : uint
        {
            return this.m_numComments;
        }// end function

        public function get numRatings() : uint
        {
            return this.m_numRatings;
        }// end function

        public function get numViews() : uint
        {
            return this.m_numViews;
        }// end function

        public function get owner() : String
        {
            return this.m_owner;
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

        public function get snippet() : String
        {
            return this.m_snippet;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this.m_spatialReference;
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
            var _loc_1:* = this.m_portal.endpointURL.appendPath("content/items/" + this.m_id + "/info/" + this.m_thumbnailURL);
            var _loc_2:* = IdentityManager.instance.findCredential(this.m_portal.endpointURL.sourceURL);
            if (_loc_2)
            {
                _loc_1.addURLVariable("token", _loc_2.token);
            }
            return _loc_1.toString();
        }// end function

        public function get title() : String
        {
            return this.m_title;
        }// end function

        public function get type() : String
        {
            return this.m_type;
        }// end function

        public function get typeKeywords() : Array
        {
            return this.m_typeKeywords.concat();
        }// end function

        public function get size() : uint
        {
            return this.m_size;
        }// end function

        public function get url() : String
        {
            return this.m_url;
        }// end function

        public function getJSONData(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:AsyncToken = null;
            var _loc_4:URL = null;
            var _loc_5:JSONTask = null;
            var _loc_3:* = this.itemDataURL;
            if (_loc_3)
            {
                _loc_4 = this.m_portal.endpointURL.appendPath("/content/items/" + this.id + "/data");
                _loc_5 = new JSONTask(_loc_4.toString());
                _loc_2 = _loc_5.execute(null, responder);
            }
            return _loc_2;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this, null, [this.portal]);
        }// end function

        static function fromJSON(obj:Object) : PortalItem
        {
            var _loc_2:PortalItem = null;
            var _loc_3:Object = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            if (obj)
            {
                _loc_2 = new PortalItem;
                _loc_2.m_access = obj.access;
                _loc_2.m_accessInformation = obj.accessInformation;
                _loc_2.m_avgRating = obj.avgRating;
                _loc_2.m_created = new Date();
                _loc_2.m_created.time = obj.created;
                _loc_2.m_culture = obj.culture;
                _loc_2.m_description = obj.description;
                _loc_2.m_id = obj.id;
                _loc_2.m_licenseInformation = obj.licenseInformation;
                _loc_2.m_modified = new Date();
                _loc_2.m_modified.time = obj.modified;
                _loc_2.m_name = obj.name;
                _loc_2.m_numComments = obj.numComments;
                _loc_2.m_numRatings = obj.numRatings;
                _loc_2.m_numViews = obj.numViews;
                _loc_2.m_owner = obj.owner;
                _loc_2.m_size = obj.size;
                _loc_2.m_snippet = obj.snippet;
                if (obj.spatialReference)
                {
                    _loc_2.m_spatialReference = new SpatialReference(obj.spatialReference);
                }
                if (obj.extent)
                {
                }
                if (obj.extent is Array)
                {
                }
                if (obj.extent.length === 2)
                {
                    _loc_4 = obj.extent[0];
                    _loc_5 = obj.extent[1];
                    if (_loc_4.length === 2)
                    {
                    }
                    if (_loc_5.length === 2)
                    {
                        if (_loc_2.spatialReference)
                        {
                            _loc_2.m_extent = new Extent(_loc_4[0], _loc_4[1], _loc_5[0], _loc_5[1], _loc_2.spatialReference);
                        }
                        else
                        {
                            _loc_2.m_extent = new WebMercatorExtent(_loc_4[0], _loc_4[1], _loc_5[0], _loc_5[1]);
                        }
                    }
                }
                for each (_loc_3 in obj.tags)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_tags.push(String(_loc_3));
                    }
                }
                _loc_2.m_thumbnailURL = obj.thumbnail;
                _loc_2.m_title = obj.title;
                _loc_2.m_type = obj.type;
                for each (_loc_3 in obj.typeKeywords)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_typeKeywords.push(String(_loc_3));
                    }
                }
                _loc_2.m_url = obj.url;
            }
            return _loc_2;
        }// end function

    }
}
