package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LayerDetails extends EventDispatcher
    {
        private var _671807175canModifyLayer:Boolean;
        private var _133086943canScaleSymbols:Boolean;
        private var _1487597642capabilities:Array;
        private var _1522889671copyright:String;
        private var _2040924109defaultVisibility:Boolean;
        private var _1463703627definitionExpression:String;
        private var _1724546052description:String;
        private var _1591853400displayField:String;
        private var _577384980drawingInfo:DrawingInfo;
        private var _1289044182extent:Extent;
        private var _1274708295fields:Array;
        private var _1590525236geometryType:String;
        private var _840295242hasAttachments:Boolean;
        private var _490667207hasLabels:Boolean;
        private var _3195123hasM:Boolean;
        private var _3195136hasZ:Boolean;
        private var _684574363htmlPopupType:String;
        private var _3355id:Number;
        private var _1043998237isDataVersioned:Boolean;
        private var _692225222maxRecordCount:Number;
        private var _396505670maxScale:Number;
        private var _1379690984minScale:Number;
        private var _3373707name:String;
        private var _997111495parentLayer:LayerInfo;
        private var _472535355relationships:Array;
        var serverVersionIs10plus:Boolean;
        private var _603336798subLayers:Array;
        private var _590752066supportedQueryFormats:Array;
        private var _912810432supportsAdvancedQueries:Boolean;
        private var _552055495supportsStatistics:Boolean;
        private var _2077688549timeInfo:TimeInfo;
        private var _3575610type:String;
        private var _1938427899typeIdField:String;
        private var _110844025types:Array;
        private var _351608024version:Number;
        private var _objectIdField:String;
        private var _spatialReference:SpatialReference;
        public static const POPUP_NONE:String = "esriServerHTMLPopupTypeNone";
        public static const POPUP_HTML_TEXT:String = "esriServerHTMLPopupTypeAsHTMLText";
        public static const POPUP_URL:String = "esriServerHTMLPopupTypeAsURL";

        public function LayerDetails()
        {
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

        private function set _1856816032objectIdField(value:String) : void
        {
            this._objectIdField = value;
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            if (!this._spatialReference)
            {
                if (this.extent)
                {
                    this._spatialReference = this.extent.spatialReference;
                }
            }
            return this._spatialReference;
        }// end function

        private function set _784017063spatialReference(value:SpatialReference) : void
        {
            this._spatialReference = value;
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this, null, ["prototype"]);
        }// end function

        public function get canModifyLayer() : Boolean
        {
            return this._671807175canModifyLayer;
        }// end function

        public function set canModifyLayer(value:Boolean) : void
        {
            arguments = this._671807175canModifyLayer;
            if (arguments !== value)
            {
                this._671807175canModifyLayer = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "canModifyLayer", arguments, value));
                }
            }
            return;
        }// end function

        public function get canScaleSymbols() : Boolean
        {
            return this._133086943canScaleSymbols;
        }// end function

        public function set canScaleSymbols(value:Boolean) : void
        {
            arguments = this._133086943canScaleSymbols;
            if (arguments !== value)
            {
                this._133086943canScaleSymbols = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "canScaleSymbols", arguments, value));
                }
            }
            return;
        }// end function

        public function get capabilities() : Array
        {
            return this._1487597642capabilities;
        }// end function

        public function set capabilities(value:Array) : void
        {
            arguments = this._1487597642capabilities;
            if (arguments !== value)
            {
                this._1487597642capabilities = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "capabilities", arguments, value));
                }
            }
            return;
        }// end function

        public function get copyright() : String
        {
            return this._1522889671copyright;
        }// end function

        public function set copyright(value:String) : void
        {
            arguments = this._1522889671copyright;
            if (arguments !== value)
            {
                this._1522889671copyright = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "copyright", arguments, value));
                }
            }
            return;
        }// end function

        public function get defaultVisibility() : Boolean
        {
            return this._2040924109defaultVisibility;
        }// end function

        public function set defaultVisibility(value:Boolean) : void
        {
            arguments = this._2040924109defaultVisibility;
            if (arguments !== value)
            {
                this._2040924109defaultVisibility = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "defaultVisibility", arguments, value));
                }
            }
            return;
        }// end function

        public function get definitionExpression() : String
        {
            return this._1463703627definitionExpression;
        }// end function

        public function set definitionExpression(value:String) : void
        {
            arguments = this._1463703627definitionExpression;
            if (arguments !== value)
            {
                this._1463703627definitionExpression = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "definitionExpression", arguments, value));
                }
            }
            return;
        }// end function

        public function get description() : String
        {
            return this._1724546052description;
        }// end function

        public function set description(value:String) : void
        {
            arguments = this._1724546052description;
            if (arguments !== value)
            {
                this._1724546052description = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", arguments, value));
                }
            }
            return;
        }// end function

        public function get displayField() : String
        {
            return this._1591853400displayField;
        }// end function

        public function set displayField(value:String) : void
        {
            arguments = this._1591853400displayField;
            if (arguments !== value)
            {
                this._1591853400displayField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "displayField", arguments, value));
                }
            }
            return;
        }// end function

        public function get drawingInfo() : DrawingInfo
        {
            return this._577384980drawingInfo;
        }// end function

        public function set drawingInfo(value:DrawingInfo) : void
        {
            arguments = this._577384980drawingInfo;
            if (arguments !== value)
            {
                this._577384980drawingInfo = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "drawingInfo", arguments, value));
                }
            }
            return;
        }// end function

        public function get extent() : Extent
        {
            return this._1289044182extent;
        }// end function

        public function set extent(value:Extent) : void
        {
            arguments = this._1289044182extent;
            if (arguments !== value)
            {
                this._1289044182extent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "extent", arguments, value));
                }
            }
            return;
        }// end function

        public function get fields() : Array
        {
            return this._1274708295fields;
        }// end function

        public function set fields(value:Array) : void
        {
            arguments = this._1274708295fields;
            if (arguments !== value)
            {
                this._1274708295fields = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fields", arguments, value));
                }
            }
            return;
        }// end function

        public function get geometryType() : String
        {
            return this._1590525236geometryType;
        }// end function

        public function set geometryType(value:String) : void
        {
            arguments = this._1590525236geometryType;
            if (arguments !== value)
            {
                this._1590525236geometryType = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "geometryType", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasAttachments() : Boolean
        {
            return this._840295242hasAttachments;
        }// end function

        public function set hasAttachments(value:Boolean) : void
        {
            arguments = this._840295242hasAttachments;
            if (arguments !== value)
            {
                this._840295242hasAttachments = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasAttachments", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasLabels() : Boolean
        {
            return this._490667207hasLabels;
        }// end function

        public function set hasLabels(value:Boolean) : void
        {
            arguments = this._490667207hasLabels;
            if (arguments !== value)
            {
                this._490667207hasLabels = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasLabels", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasM() : Boolean
        {
            return this._3195123hasM;
        }// end function

        public function set hasM(value:Boolean) : void
        {
            arguments = this._3195123hasM;
            if (arguments !== value)
            {
                this._3195123hasM = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasM", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasZ() : Boolean
        {
            return this._3195136hasZ;
        }// end function

        public function set hasZ(value:Boolean) : void
        {
            arguments = this._3195136hasZ;
            if (arguments !== value)
            {
                this._3195136hasZ = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasZ", arguments, value));
                }
            }
            return;
        }// end function

        public function get htmlPopupType() : String
        {
            return this._684574363htmlPopupType;
        }// end function

        public function set htmlPopupType(value:String) : void
        {
            arguments = this._684574363htmlPopupType;
            if (arguments !== value)
            {
                this._684574363htmlPopupType = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "htmlPopupType", arguments, value));
                }
            }
            return;
        }// end function

        public function get id() : Number
        {
            return this._3355id;
        }// end function

        public function set id(value:Number) : void
        {
            arguments = this._3355id;
            if (arguments !== value)
            {
                this._3355id = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", arguments, value));
                }
            }
            return;
        }// end function

        public function get isDataVersioned() : Boolean
        {
            return this._1043998237isDataVersioned;
        }// end function

        public function set isDataVersioned(value:Boolean) : void
        {
            arguments = this._1043998237isDataVersioned;
            if (arguments !== value)
            {
                this._1043998237isDataVersioned = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isDataVersioned", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxRecordCount() : Number
        {
            return this._692225222maxRecordCount;
        }// end function

        public function set maxRecordCount(value:Number) : void
        {
            arguments = this._692225222maxRecordCount;
            if (arguments !== value)
            {
                this._692225222maxRecordCount = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxRecordCount", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxScale() : Number
        {
            return this._396505670maxScale;
        }// end function

        public function set maxScale(value:Number) : void
        {
            arguments = this._396505670maxScale;
            if (arguments !== value)
            {
                this._396505670maxScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxScale", arguments, value));
                }
            }
            return;
        }// end function

        public function get minScale() : Number
        {
            return this._1379690984minScale;
        }// end function

        public function set minScale(value:Number) : void
        {
            arguments = this._1379690984minScale;
            if (arguments !== value)
            {
                this._1379690984minScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minScale", arguments, value));
                }
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._3373707name;
        }// end function

        public function set name(value:String) : void
        {
            arguments = this._3373707name;
            if (arguments !== value)
            {
                this._3373707name = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", arguments, value));
                }
            }
            return;
        }// end function

        public function get parentLayer() : LayerInfo
        {
            return this._997111495parentLayer;
        }// end function

        public function set parentLayer(value:LayerInfo) : void
        {
            arguments = this._997111495parentLayer;
            if (arguments !== value)
            {
                this._997111495parentLayer = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "parentLayer", arguments, value));
                }
            }
            return;
        }// end function

        public function get relationships() : Array
        {
            return this._472535355relationships;
        }// end function

        public function set relationships(value:Array) : void
        {
            arguments = this._472535355relationships;
            if (arguments !== value)
            {
                this._472535355relationships = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "relationships", arguments, value));
                }
            }
            return;
        }// end function

        public function get subLayers() : Array
        {
            return this._603336798subLayers;
        }// end function

        public function set subLayers(value:Array) : void
        {
            arguments = this._603336798subLayers;
            if (arguments !== value)
            {
                this._603336798subLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function get supportedQueryFormats() : Array
        {
            return this._590752066supportedQueryFormats;
        }// end function

        public function set supportedQueryFormats(value:Array) : void
        {
            arguments = this._590752066supportedQueryFormats;
            if (arguments !== value)
            {
                this._590752066supportedQueryFormats = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "supportedQueryFormats", arguments, value));
                }
            }
            return;
        }// end function

        public function get supportsAdvancedQueries() : Boolean
        {
            return this._912810432supportsAdvancedQueries;
        }// end function

        public function set supportsAdvancedQueries(value:Boolean) : void
        {
            arguments = this._912810432supportsAdvancedQueries;
            if (arguments !== value)
            {
                this._912810432supportsAdvancedQueries = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "supportsAdvancedQueries", arguments, value));
                }
            }
            return;
        }// end function

        public function get supportsStatistics() : Boolean
        {
            return this._552055495supportsStatistics;
        }// end function

        public function set supportsStatistics(value:Boolean) : void
        {
            arguments = this._552055495supportsStatistics;
            if (arguments !== value)
            {
                this._552055495supportsStatistics = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "supportsStatistics", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeInfo() : TimeInfo
        {
            return this._2077688549timeInfo;
        }// end function

        public function set timeInfo(value:TimeInfo) : void
        {
            arguments = this._2077688549timeInfo;
            if (arguments !== value)
            {
                this._2077688549timeInfo = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeInfo", arguments, value));
                }
            }
            return;
        }// end function

        public function get type() : String
        {
            return this._3575610type;
        }// end function

        public function set type(value:String) : void
        {
            arguments = this._3575610type;
            if (arguments !== value)
            {
                this._3575610type = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", arguments, value));
                }
            }
            return;
        }// end function

        public function get typeIdField() : String
        {
            return this._1938427899typeIdField;
        }// end function

        public function set typeIdField(value:String) : void
        {
            arguments = this._1938427899typeIdField;
            if (arguments !== value)
            {
                this._1938427899typeIdField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "typeIdField", arguments, value));
                }
            }
            return;
        }// end function

        public function get types() : Array
        {
            return this._110844025types;
        }// end function

        public function set types(value:Array) : void
        {
            arguments = this._110844025types;
            if (arguments !== value)
            {
                this._110844025types = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "types", arguments, value));
                }
            }
            return;
        }// end function

        public function get version() : Number
        {
            return this._351608024version;
        }// end function

        public function set version(value:Number) : void
        {
            arguments = this._351608024version;
            if (arguments !== value)
            {
                this._351608024version = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "version", arguments, value));
                }
            }
            return;
        }// end function

        public function set objectIdField(value:String) : void
        {
            arguments = this.objectIdField;
            if (arguments !== value)
            {
                this._1856816032objectIdField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "objectIdField", arguments, value));
                }
            }
            return;
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            arguments = this.spatialReference;
            if (arguments !== value)
            {
                this._784017063spatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "spatialReference", arguments, value));
                }
            }
            return;
        }// end function

        static function toLayerDetails(obj:Object, classType:Class = null) : LayerDetails
        {
            var _loc_3:LayerDetails = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_7:Object = null;
            if (obj)
            {
                _loc_3 = classType ? (new classType) : (new LayerDetails);
                _loc_3.canModifyLayer = obj.canModifyLayer;
                _loc_3.canScaleSymbols = obj.canScaleSymbols;
                if (obj.capabilities)
                {
                    _loc_3.capabilities = StringUtil.trimArrayElements(obj.capabilities, ",").split(",");
                }
                _loc_3.copyright = obj.copyrightText;
                _loc_3.defaultVisibility = obj.defaultVisibility;
                _loc_3.definitionExpression = obj.definitionExpression;
                _loc_3.description = obj.description;
                _loc_3.displayField = obj.displayField;
                _loc_3.drawingInfo = DrawingInfo.toDrawingInfo(obj.drawingInfo);
                _loc_3.extent = Extent.fromJSON(obj.extent);
                if (obj.fields)
                {
                    _loc_3.fields = [];
                    for each (_loc_4 in obj.fields)
                    {
                        
                        _loc_3.fields.push(Field.toField(_loc_4));
                    }
                }
                _loc_3.geometryType = obj.geometryType;
                _loc_3.hasAttachments = obj.hasAttachments;
                _loc_3.hasLabels = obj.hasLabels;
                _loc_3.hasM = obj.hasM;
                _loc_3.hasZ = obj.hasZ;
                _loc_3.htmlPopupType = obj.htmlPopupType;
                _loc_3.id = obj.id;
                _loc_3.isDataVersioned = obj.isDataVersioned;
                _loc_3.maxRecordCount = obj.maxRecordCount;
                if (!obj.effectiveMaxScale)
                {
                }
                if (!obj.maxScale)
                {
                }
                _loc_3.maxScale = 0;
                if (!obj.effectiveMinScale)
                {
                }
                if (!obj.minScale)
                {
                }
                _loc_3.minScale = 0;
                _loc_3.name = obj.name;
                _loc_3.objectIdField = obj.objectIdField;
                _loc_3.parentLayer = LayerInfo.toLayerInfo(obj.parentLayer);
                if (obj.relationships)
                {
                    _loc_3.relationships = [];
                    for each (_loc_5 in obj.relationships)
                    {
                        
                        _loc_3.relationships.push(Relationship.toRelationship(_loc_5));
                    }
                }
                if (obj.subLayers)
                {
                    _loc_3.subLayers = [];
                    for each (_loc_6 in obj.subLayers)
                    {
                        
                        _loc_3.subLayers.push(LayerInfo.toLayerInfo(_loc_6));
                    }
                }
                if (obj.supportedQueryFormats)
                {
                    _loc_3.supportedQueryFormats = StringUtil.trimArrayElements(obj.supportedQueryFormats, ",").split(",");
                }
                _loc_3.supportsAdvancedQueries = obj.supportsAdvancedQueries;
                _loc_3.supportsStatistics = obj.supportsStatistics;
                _loc_3.timeInfo = TimeInfo.toTimeInfo(obj.timeInfo);
                if (_loc_3.timeInfo)
                {
                }
                if (_loc_3.timeInfo.exportOptions)
                {
                    _loc_3.timeInfo.exportOptions.layerId = _loc_3.id;
                }
                _loc_3.type = obj.type;
                _loc_3.typeIdField = getActualFieldName(obj.typeIdField, _loc_3.fields);
                if (obj.types)
                {
                    _loc_3.types = [];
                    for each (_loc_7 in obj.types)
                    {
                        
                        _loc_3.types.push(FeatureType.toFeatureType(_loc_7));
                    }
                }
                _loc_3.version = getVersion(obj);
                _loc_3.serverVersionIs10plus = _loc_3.version >= 10;
                fixInheritedDomains(_loc_3.types, _loc_3.fields);
            }
            return _loc_3;
        }// end function

        static function getVersion(obj:Object) : Number
        {
            var _loc_2:* = parseFloat(obj.currentVersion);
            if (isNaN(_loc_2))
            {
                if (!("capabilities" in obj))
                {
                }
                if (!("drawingInfo" in obj))
                {
                }
                if (!("hasAttachments" in obj))
                {
                }
                if (!("htmlPopupType" in obj))
                {
                }
                if (!("relationships" in obj))
                {
                }
                if (!("timeInfo" in obj))
                {
                }
                if (!("typeIdField" in obj))
                {
                }
                if ("types" in obj)
                {
                    _loc_2 = 10;
                }
                else
                {
                    _loc_2 = 9.3;
                }
            }
            return _loc_2;
        }// end function

        static function fixInheritedDomains(types:Array, fields:Array) : void
        {
            var _loc_3:FeatureType = null;
            var _loc_4:String = null;
            var _loc_5:IDomain = null;
            var _loc_6:Field = null;
            if (types)
            {
            }
            if (!fields)
            {
                return;
            }
            for each (_loc_3 in types)
            {
                
                for (_loc_4 in _loc_3.domains)
                {
                    
                    _loc_5 = _loc_3.domains[_loc_4];
                    if (_loc_5 is InheritedDomain)
                    {
                        for each (_loc_6 in fields)
                        {
                            
                            if (_loc_4 == _loc_6.name)
                            {
                                _loc_3.domains[_loc_4] = _loc_6.domain;
                                break;
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        static function getActualFieldName(fieldName:String, fields:Array) : String
        {
            var _loc_4:Field = null;
            var _loc_3:* = fieldName;
            if (fieldName)
            {
            }
            if (fields)
            {
                fieldName = fieldName.toLowerCase();
                for each (_loc_4 in fields)
                {
                    
                    if (_loc_4.name)
                    {
                    }
                    if (fieldName == _loc_4.name.toLowerCase())
                    {
                        _loc_3 = _loc_4.name;
                        break;
                    }
                }
            }
            return _loc_3;
        }// end function

    }
}
