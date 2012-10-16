package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.utils.*;

    public class TableDetails extends EventDispatcher
    {
        private var _canModifyTable:Boolean;
        private var _capabilities:Array;
        private var _definitionExpression:String;
        private var _description:String;
        private var _displayField:String;
        private var _fields:Array;
        private var _hasAttachments:Boolean;
        private var _htmlPopupType:String;
        private var _id:Number;
        private var _isDataVersioned:Boolean;
        private var _maxRecordCount:Number;
        private var _name:String;
        private var _objectIdField:String;
        private var _relationships:Array;
        var serverVersionIs10plus:Boolean;
        private var _supportedQueryFormats:Array;
        private var _supportsAdvancedQueries:Boolean;
        private var _supportsStatistics:Boolean;
        private var _timeInfo:TimeInfo;
        private var _type:String;
        private var _typeIdField:String;
        private var _types:Array;
        private var _version:Number;
        public static const POPUP_NONE:String = "esriServerHTMLPopupTypeNone";
        public static const POPUP_HTML_TEXT:String = "esriServerHTMLPopupTypeAsHTMLText";
        public static const POPUP_URL:String = "esriServerHTMLPopupTypeAsURL";

        public function TableDetails()
        {
            return;
        }// end function

        public function get canModifyTable() : Boolean
        {
            return this._canModifyTable;
        }// end function

        public function set canModifyTable(value:Boolean) : void
        {
            if (this._canModifyTable !== value)
            {
                this._canModifyTable = value;
                dispatchEvent(new Event("canModifyTableChanged"));
            }
            return;
        }// end function

        public function get capabilities() : Array
        {
            return this._capabilities;
        }// end function

        public function set capabilities(value:Array) : void
        {
            this._capabilities = value;
            dispatchEvent(new Event("capabilitiesChanged"));
            return;
        }// end function

        public function get definitionExpression() : String
        {
            return this._definitionExpression;
        }// end function

        public function set definitionExpression(value:String) : void
        {
            if (this._definitionExpression !== value)
            {
                this._definitionExpression = value;
                dispatchEvent(new Event("definitionExpressionChanged"));
            }
            return;
        }// end function

        public function get description() : String
        {
            return this._description;
        }// end function

        public function set description(value:String) : void
        {
            if (this._description !== value)
            {
                this._description = value;
                dispatchEvent(new Event("descriptionChanged"));
            }
            return;
        }// end function

        public function get displayField() : String
        {
            return this._displayField;
        }// end function

        public function set displayField(value:String) : void
        {
            if (this._displayField !== value)
            {
                this._displayField = value;
                dispatchEvent(new Event("displayFieldChanged"));
            }
            return;
        }// end function

        public function get fields() : Array
        {
            return this._fields;
        }// end function

        public function set fields(value:Array) : void
        {
            this._fields = value;
            dispatchEvent(new Event("fieldsChanged"));
            return;
        }// end function

        public function get hasAttachments() : Boolean
        {
            return this._hasAttachments;
        }// end function

        public function set hasAttachments(value:Boolean) : void
        {
            if (this._hasAttachments !== value)
            {
                this._hasAttachments = value;
                dispatchEvent(new Event("hasAttachmentsChanged"));
            }
            return;
        }// end function

        public function get htmlPopupType() : String
        {
            return this._htmlPopupType;
        }// end function

        public function set htmlPopupType(value:String) : void
        {
            if (this._htmlPopupType !== value)
            {
                this._htmlPopupType = value;
                dispatchEvent(new Event("htmlPopupTypeChanged"));
            }
            return;
        }// end function

        public function get id() : Number
        {
            return this._id;
        }// end function

        public function set id(value:Number) : void
        {
            if (this._id !== value)
            {
                this._id = value;
                dispatchEvent(new Event("idChanged"));
            }
            return;
        }// end function

        public function get isDataVersioned() : Boolean
        {
            return this._isDataVersioned;
        }// end function

        public function set isDataVersioned(value:Boolean) : void
        {
            if (this._isDataVersioned !== value)
            {
                this._isDataVersioned = value;
                dispatchEvent(new Event("isDataVersionedChanged"));
            }
            return;
        }// end function

        public function get maxRecordCount() : Number
        {
            return this._maxRecordCount;
        }// end function

        public function set maxRecordCount(value:Number) : void
        {
            if (this._maxRecordCount !== value)
            {
                this._maxRecordCount = value;
                dispatchEvent(new Event("maxRecordCountChanged"));
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function set name(value:String) : void
        {
            if (this._name !== value)
            {
                this._name = value;
                dispatchEvent(new Event("nameChanged"));
            }
            return;
        }// end function

        public function get objectIdField() : String
        {
            var _loc_1:Field = null;
            if (!this._objectIdField)
            {
                for each (_loc_1 in this.fields)
                {
                    
                    if (_loc_1.type == Field.TYPE_OID)
                    {
                        this._objectIdField = _loc_1.name;
                        break;
                    }
                }
            }
            return this._objectIdField;
        }// end function

        public function set objectIdField(value:String) : void
        {
            if (this._objectIdField !== value)
            {
                this._objectIdField = value;
                dispatchEvent(new Event("objectIdFieldChanged"));
            }
            return;
        }// end function

        public function get relationships() : Array
        {
            return this._relationships;
        }// end function

        public function set relationships(value:Array) : void
        {
            this._relationships = value;
            dispatchEvent(new Event("relationshipsChanged"));
            return;
        }// end function

        public function get supportedQueryFormats() : Array
        {
            return this._supportedQueryFormats;
        }// end function

        public function set supportedQueryFormats(value:Array) : void
        {
            this._supportedQueryFormats = value;
            dispatchEvent(new Event("supportedQueryFormatsChanged"));
            return;
        }// end function

        public function get supportsAdvancedQueries() : Boolean
        {
            return this._supportsAdvancedQueries;
        }// end function

        public function set supportsAdvancedQueries(value:Boolean) : void
        {
            if (this._supportsAdvancedQueries !== value)
            {
                this._supportsAdvancedQueries = value;
                dispatchEvent(new Event("supportsAdvancedQueriesChanged"));
            }
            return;
        }// end function

        public function get supportsStatistics() : Boolean
        {
            return this._supportsStatistics;
        }// end function

        public function set supportsStatistics(value:Boolean) : void
        {
            if (this._supportsStatistics !== value)
            {
                this._supportsStatistics = value;
                dispatchEvent(new Event("supportsStatisticsChanged"));
            }
            return;
        }// end function

        public function get timeInfo() : TimeInfo
        {
            return this._timeInfo;
        }// end function

        public function set timeInfo(value:TimeInfo) : void
        {
            this._timeInfo = value;
            dispatchEvent(new Event("timeInfoChanged"));
            return;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function set type(value:String) : void
        {
            if (this._type !== value)
            {
                this._type = value;
                dispatchEvent(new Event("typeChanged"));
            }
            return;
        }// end function

        public function get typeIdField() : String
        {
            return this._typeIdField;
        }// end function

        public function set typeIdField(value:String) : void
        {
            if (this._typeIdField !== value)
            {
                this._typeIdField = value;
                dispatchEvent(new Event("typeIdFieldChanged"));
            }
            return;
        }// end function

        public function get types() : Array
        {
            return this._types;
        }// end function

        public function set types(value:Array) : void
        {
            this._types = value;
            dispatchEvent(new Event("typesChanged"));
            return;
        }// end function

        public function get version() : Number
        {
            return this._version;
        }// end function

        public function set version(value:Number) : void
        {
            if (this._version !== value)
            {
                this._version = value;
                dispatchEvent(new Event("versionChanged"));
            }
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this, null, ["prototype"]);
        }// end function

        static function toTableDetails(obj:Object, classType:Class = null) : TableDetails
        {
            var _loc_3:TableDetails = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            if (obj)
            {
                _loc_3 = classType ? (new classType) : (new TableDetails);
                _loc_3.canModifyTable = obj.canModifyLayer;
                if (obj.capabilities)
                {
                    _loc_3.capabilities = StringUtil.trimArrayElements(obj.capabilities, ",").split(",");
                }
                _loc_3.definitionExpression = obj.definitionExpression;
                _loc_3.description = obj.description;
                _loc_3.displayField = obj.displayField;
                if (obj.fields)
                {
                    _loc_3.fields = [];
                    for each (_loc_4 in obj.fields)
                    {
                        
                        _loc_3.fields.push(Field.toField(_loc_4));
                    }
                }
                _loc_3.hasAttachments = obj.hasAttachments;
                _loc_3.htmlPopupType = obj.htmlPopupType;
                _loc_3.id = obj.id;
                _loc_3.isDataVersioned = obj.isDataVersioned;
                _loc_3.maxRecordCount = obj.maxRecordCount;
                _loc_3.name = obj.name;
                _loc_3.objectIdField = obj.objectIdField;
                if (obj.relationships)
                {
                    _loc_3.relationships = [];
                    for each (_loc_5 in obj.relationships)
                    {
                        
                        _loc_3.relationships.push(Relationship.toRelationship(_loc_5));
                    }
                }
                if (obj.supportedQueryFormats)
                {
                    _loc_3.supportedQueryFormats = StringUtil.trimArrayElements(obj.supportedQueryFormats, ",").split(",");
                }
                _loc_3.supportsAdvancedQueries = obj.supportsAdvancedQueries;
                _loc_3.supportsStatistics = obj.supportsStatistics;
                _loc_3.timeInfo = TimeInfo.toTimeInfo(obj.timeInfo);
                _loc_3.type = obj.type;
                _loc_3.typeIdField = LayerDetails.getActualFieldName(obj.typeIdField, _loc_3.fields);
                if (obj.types)
                {
                    _loc_3.types = [];
                    for each (_loc_6 in obj.types)
                    {
                        
                        _loc_3.types.push(FeatureType.toFeatureType(_loc_6));
                    }
                }
                _loc_3.version = LayerDetails.getVersion(obj);
                _loc_3.serverVersionIs10plus = _loc_3.version >= 10;
                LayerDetails.fixInheritedDomains(_loc_3.types, _loc_3.fields);
            }
            return _loc_3;
        }// end function

    }
}
