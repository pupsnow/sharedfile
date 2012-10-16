package com.esri.ags.layers
{
    import __AS3__.vec.*;
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.tasks.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.formatters.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;

    public class FeatureLayer extends GraphicsLayer
    {
        private var _log:ILogger;
        private var _queryTask:QueryTask;
        private var _featureLayerTask:FeatureLayerTask;
        private var _querySnapshotDone:Boolean;
        private var _mapTimeExtentChanged:Boolean;
        private var _featureIds:Vector.<Number>;
        private var _featureMap:Dictionary;
        private var _featureRefCount:Dictionary;
        private var _selectedFeatures:Dictionary;
        private var _requestID:uint;
        private var _collectionAdded:Boolean;
        private var _counter:uint;
        private var _rendererIsTemporalRenderer:Boolean;
        private var _latestFeatures:Dictionary;
        private var _trackFeatures:Dictionary;
        private var _historicalFeatures:Array;
        private var _alphaSet:Boolean = false;
        private var _maxScaleSet:Boolean = false;
        private var _minScaleSet:Boolean = false;
        private var _rendererSet:Boolean = false;
        private var _rendererChanged:Boolean = false;
        private var _symbolSet:Boolean = false;
        var credential:Credential;
        private var _definitionExpression:String;
        private var _disableClientCaching:Boolean = false;
        private var _featureCollection:FeatureCollection;
        private var _featureCollectionChanged:Boolean = false;
        private var _gdbVersion:String;
        private var _layerDetails:LayerDetails;
        private var _maxAllowableOffset:Number;
        private var _mode:String = "onDemand";
        private var _onDemandCacheSize:uint = 1000;
        private var _outFields:Array;
        private var _outFieldsSet:Boolean;
        private var _proxyURL:String;
        private var _requestTimeout:int = -1;
        private var _returnM:Boolean;
        private var _returnZ:Boolean;
        private var _selectionColor:uint = 16776960;
        private var _selectionColorChanged:Boolean = false;
        private var _source:ILayerSource;
        private var _tableDetails:TableDetails;
        private var _timeDefinition:TimeExtent;
        private var _timeDefinitionChanged:Boolean = false;
        private var _timeOffset:Number;
        private var _timeOffsetUnits:String;
        private var _token:String;
        private var _trackIdField:String;
        private var _trackIdFieldSet:Boolean = false;
        private var _urlChanged:Boolean = false;
        const urlObj:URL;
        private var _useAMF:Boolean = true;
        private var _useAMFSet:Boolean;
        private var _useMapTime:Boolean = true;
        private var _userId:String;
        public static const SELECTION_ADD:String = "add";
        public static const SELECTION_NEW:String = "new";
        public static const SELECTION_SUBTRACT:String = "subtract";
        public static const MODE_SNAPSHOT:String = "snapshot";
        public static const MODE_ON_DEMAND:String = "onDemand";
        public static const MODE_SELECTION:String = "selection";
        private static const MAX_IN_CLAUSE_COUNT:uint = 1000;

        public function FeatureLayer(url:String = null, proxyURL:String = null, token:String = null)
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, ".").replace("$", "-"));
            this._queryTask = new QueryTask();
            this._featureLayerTask = new FeatureLayerTask();
            this._featureIds = new Vector.<Number>;
            this._featureMap = new Dictionary(true);
            this._featureRefCount = new Dictionary(true);
            this._selectedFeatures = new Dictionary(true);
            this._latestFeatures = new Dictionary(true);
            this._trackFeatures = new Dictionary(true);
            this._historicalFeatures = [];
            this.urlObj = new URL();
            this.url = url;
            this.proxyURL = proxyURL;
            this.token = token;
            if (FlexGlobals.topLevelApplication is UIComponent)
            {
                UIComponent(FlexGlobals.topLevelApplication).callLater(this.loadDetailsEarly);
            }
            return;
        }// end function

        override public function set alpha(value:Number) : void
        {
            super.alpha = value;
            this._alphaSet = true;
            return;
        }// end function

        override public function get graphicProvider() : Object
        {
            return new ArrayCollection($graphicProvider.toArray());
        }// end function

        override public function set graphicProvider(value:Object) : void
        {
            return;
        }// end function

        override public function set maxScale(value:Number) : void
        {
            super.maxScale = value;
            this._maxScaleSet = true;
            return;
        }// end function

        override public function set minScale(value:Number) : void
        {
            super.minScale = value;
            this._minScaleSet = true;
            return;
        }// end function

        override public function set renderer(value:IRenderer) : void
        {
            super.renderer = value;
            this._rendererSet = true;
            this._rendererChanged = true;
            invalidateProperties();
            return;
        }// end function

        override public function set symbol(value:Symbol) : void
        {
            super.symbol = value;
            this._symbolSet = true;
            return;
        }// end function

        private function get capabilities() : Array
        {
            var _loc_1:Array = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.capabilities;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.capabilities;
            }
            return _loc_1;
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
                this.refresh();
                dispatchEvent(new Event("definitionExpressionChanged"));
            }
            return;
        }// end function

        public function get disableClientCaching() : Boolean
        {
            return this._disableClientCaching;
        }// end function

        private function set _2076627820disableClientCaching(value:Boolean) : void
        {
            this._disableClientCaching = value;
            return;
        }// end function

        private function get displayField() : String
        {
            var _loc_1:String = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.displayField;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.displayField;
            }
            return _loc_1;
        }// end function

        function get editFieldsInfo() : EditFieldsInfo
        {
            var _loc_1:EditFieldsInfo = null;
            if (this._layerDetails is FeatureLayerDetails)
            {
                _loc_1 = (this._layerDetails as FeatureLayerDetails).editFieldsInfo;
            }
            else if (this._tableDetails is FeatureTableDetails)
            {
                _loc_1 = (this._tableDetails as FeatureTableDetails).editFieldsInfo;
            }
            return _loc_1;
        }// end function

        private function get endTimeField() : String
        {
            var _loc_1:String = null;
            var _loc_2:* = this.timeInfo;
            if (_loc_2)
            {
                _loc_1 = _loc_2.endTimeField;
            }
            return _loc_1;
        }// end function

        public function get featureCollection() : FeatureCollection
        {
            return this._featureCollection;
        }// end function

        public function set featureCollection(value:FeatureCollection) : void
        {
            this._featureCollection = value;
            this._featureCollectionChanged = true;
            invalidateProperties();
            this._layerDetails = null;
            this._tableDetails = null;
            setLoaded(false);
            return;
        }// end function

        function get featureIds() : Vector.<Number>
        {
            return this._featureIds.concat();
        }// end function

        public function get gdbVersion() : String
        {
            return this._gdbVersion;
        }// end function

        public function set gdbVersion(value:String) : void
        {
            if (this._gdbVersion !== value)
            {
                this._gdbVersion = value;
                dispatchEvent(new Event("gdbVersionChanged"));
            }
            return;
        }// end function

        function get isCollection() : Boolean
        {
            return this.featureCollection != null;
        }// end function

        function get isDefaultRenderer() : Boolean
        {
            return !this._rendererSet;
        }// end function

        public function get isEditable() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this.isCollection)
            {
                _loc_1 = true;
            }
            else if (this.capabilities)
            {
                if (this.capabilities.indexOf("Editing") != -1)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1;
        }// end function

        private function get isOnDemand() : Boolean
        {
            return this.mode == MODE_ON_DEMAND;
        }// end function

        function get isSelOnly() : Boolean
        {
            return this.mode == MODE_SELECTION;
        }// end function

        function get isSnapshot() : Boolean
        {
            return this.mode == MODE_SNAPSHOT;
        }// end function

        private function get isTable() : Boolean
        {
            return this._tableDetails != null;
        }// end function

        public function get layerDetails() : LayerDetails
        {
            return this._layerDetails;
        }// end function

        public function get maxAllowableOffset() : Number
        {
            return this._maxAllowableOffset;
        }// end function

        public function set maxAllowableOffset(value:Number) : void
        {
            if (this._maxAllowableOffset !== value)
            {
                this._maxAllowableOffset = value;
                if (!this.isEditable)
                {
                    this.refresh();
                }
                dispatchEvent(new Event("maxAllowableOffsetChanged"));
            }
            return;
        }// end function

        public function get mode() : String
        {
            return this._mode;
        }// end function

        private function set _3357091mode(value:String) : void
        {
            this._mode = value;
            return;
        }// end function

        private function get objectIdField() : String
        {
            var _loc_1:String = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.objectIdField;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.objectIdField;
            }
            return _loc_1;
        }// end function

        public function get onDemandCacheSize() : uint
        {
            return this._onDemandCacheSize;
        }// end function

        private function set _379477177onDemandCacheSize(value:uint) : void
        {
            this._onDemandCacheSize = value;
            return;
        }// end function

        public function get outFields() : Array
        {
            return this._outFields;
        }// end function

        private function set _961734567outFields(value:Array) : void
        {
            this._outFields = value;
            this._outFieldsSet = true;
            return;
        }// end function

        function get ownershipBasedAccessControlForFeatures() : OwnershipBasedAccessControlForFeatures
        {
            var _loc_1:OwnershipBasedAccessControlForFeatures = null;
            if (this._layerDetails is FeatureLayerDetails)
            {
                _loc_1 = (this._layerDetails as FeatureLayerDetails).ownershipBasedAccessControlForFeatures;
            }
            else if (this._tableDetails is FeatureTableDetails)
            {
                _loc_1 = (this._tableDetails as FeatureTableDetails).ownershipBasedAccessControlForFeatures;
            }
            return _loc_1;
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURL;
        }// end function

        private function set _985186271proxyURL(value:String) : void
        {
            this._proxyURL = value;
            return;
        }// end function

        public function get requestTimeout() : int
        {
            return this._requestTimeout;
        }// end function

        private function set _1124910034requestTimeout(value:int) : void
        {
            this._requestTimeout = value;
            return;
        }// end function

        public function get returnM() : Boolean
        {
            return this._returnM;
        }// end function

        public function set returnM(value:Boolean) : void
        {
            if (this._returnM !== value)
            {
                this._returnM = value;
                dispatchEvent(new Event("returnMChanged"));
            }
            return;
        }// end function

        public function get returnZ() : Boolean
        {
            return this._returnZ;
        }// end function

        public function set returnZ(value:Boolean) : void
        {
            if (this._returnZ !== value)
            {
                this._returnZ = value;
                dispatchEvent(new Event("returnZChanged"));
            }
            return;
        }// end function

        public function get selectedFeatures() : Array
        {
            var _loc_2:Graphic = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._selectedFeatures)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        function get selectedIds() : Array
        {
            var _loc_2:Object = null;
            var _loc_1:Array = [];
            for (_loc_2 in this._selectedFeatures)
            {
                
                _loc_1.push(Number(_loc_2));
            }
            return _loc_1;
        }// end function

        public function get selectionColor() : uint
        {
            return this._selectionColor;
        }// end function

        public function set selectionColor(value:uint) : void
        {
            if (this._selectionColor !== value)
            {
                this._selectionColor = value;
                this._selectionColorChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get source() : ILayerSource
        {
            return this._source;
        }// end function

        public function set source(value:ILayerSource) : void
        {
            this._source = value;
            this._urlChanged = true;
            invalidateProperties();
            this._layerDetails = null;
            this._tableDetails = null;
            setLoaded(false);
            dispatchEvent(new Event("sourceChanged"));
            return;
        }// end function

        function get startTimeField() : String
        {
            var _loc_1:String = null;
            var _loc_2:* = this.timeInfo;
            if (_loc_2)
            {
                _loc_1 = _loc_2.startTimeField;
            }
            return _loc_1;
        }// end function

        private function get supportedQueryFormats() : Array
        {
            var _loc_1:Array = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.supportedQueryFormats;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.supportedQueryFormats;
            }
            return _loc_1;
        }// end function

        public function get tableDetails() : TableDetails
        {
            return this._tableDetails;
        }// end function

        public function get timeDefinition() : TimeExtent
        {
            return this._timeDefinition;
        }// end function

        public function set timeDefinition(value:TimeExtent) : void
        {
            if (ObjectUtil.compare(this._timeDefinition, value) != 0)
            {
                this._timeDefinition = value;
                this._timeDefinitionChanged = true;
                invalidateProperties();
            }
            else
            {
                this._timeDefinition = value;
            }
            return;
        }// end function

        private function get timeExtentFromMapWithOffset() : TimeExtent
        {
            var _loc_1:TimeExtent = null;
            if (this.useMapTime)
            {
            }
            if (map)
            {
            }
            if (map.timeExtent)
            {
            }
            if (this.timeInfo)
            {
                if (!isNaN(this.timeOffset))
                {
                }
                if (this.timeOffsetUnits)
                {
                    _loc_1 = map.timeExtent.offset(-this.timeOffset, this.timeOffsetUnits);
                }
                else
                {
                    _loc_1 = map.timeExtent;
                }
            }
            return _loc_1;
        }// end function

        private function get timeInfo() : TimeInfo
        {
            var _loc_1:TimeInfo = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.timeInfo;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.timeInfo;
            }
            return _loc_1;
        }// end function

        public function get timeOffset() : Number
        {
            return this._timeOffset;
        }// end function

        public function set timeOffset(value:Number) : void
        {
            if (this._timeOffset !== value)
            {
                this._timeOffset = value;
                invalidateLayer();
                dispatchEvent(new Event("timeOffsetChanged"));
            }
            return;
        }// end function

        public function get timeOffsetUnits() : String
        {
            return this._timeOffsetUnits;
        }// end function

        public function set timeOffsetUnits(value:String) : void
        {
            if (this._timeOffsetUnits !== value)
            {
                this._timeOffsetUnits = value;
                invalidateLayer();
                dispatchEvent(new Event("timeOffsetUnitsChanged"));
            }
            return;
        }// end function

        public function get token() : String
        {
            return this._token;
        }// end function

        private function set _110541305token(value:String) : void
        {
            this._token = value;
            return;
        }// end function

        public function get trackIdField() : String
        {
            return this._trackIdField;
        }// end function

        public function set trackIdField(value:String) : void
        {
            this._trackIdFieldSet = true;
            if (this._trackIdField !== value)
            {
                this._trackIdField = value;
                this.refresh();
                dispatchEvent(new Event("trackIdFieldChanged"));
            }
            return;
        }// end function

        function get typeIdField() : String
        {
            var _loc_1:String = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.typeIdField;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.typeIdField;
            }
            return _loc_1;
        }// end function

        function get types() : Array
        {
            var _loc_1:Array = null;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.types;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.types;
            }
            return _loc_1;
        }// end function

        public function get url() : String
        {
            return this.urlObj.sourceURL;
        }// end function

        public function set url(value:String) : void
        {
            if (this.url != value)
            {
            }
            if (value)
            {
                this.urlObj.update(value);
                this._urlChanged = true;
                invalidateProperties();
                this._layerDetails = null;
                this._tableDetails = null;
                this.credential = null;
                setLoaded(false);
                dispatchEvent(new Event("urlChanged"));
            }
            return;
        }// end function

        public function get useAMF() : Boolean
        {
            return this._useAMF;
        }// end function

        public function set useAMF(value:Boolean) : void
        {
            this._useAMFSet = true;
            if (this._useAMF !== value)
            {
                this._useAMF = value;
                dispatchEvent(new Event("useAMFChanged"));
            }
            return;
        }// end function

        public function get useMapTime() : Boolean
        {
            return this._useMapTime;
        }// end function

        private function set _784516414useMapTime(value:Boolean) : void
        {
            this._useMapTime = value;
            this._mapTimeExtentChanged = true;
            invalidateProperties();
            return;
        }// end function

        public function get userId() : String
        {
            if (this._userId)
            {
                return this._userId;
            }
            if (this.credential)
            {
                return this.credential.userId;
            }
            return null;
        }// end function

        public function set userId(value:String) : void
        {
            if (this._userId !== value)
            {
                this._userId = value;
                dispatchEvent(new Event("userIdChanged"));
            }
            return;
        }// end function

        private function get version() : Number
        {
            var _loc_1:Number = NaN;
            if (this._layerDetails)
            {
                _loc_1 = this._layerDetails.version;
            }
            else if (this._tableDetails)
            {
                _loc_1 = this._tableDetails.version;
            }
            return _loc_1;
        }// end function

        override protected function addMapListeners() : void
        {
            super.addMapListeners();
            if (map)
            {
                map.addEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.map_timeExtentChangeHandler);
            }
            return;
        }// end function

        override protected function removeMapListeners() : void
        {
            super.removeMapListeners();
            if (map)
            {
                map.removeEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, this.map_timeExtentChangeHandler);
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:FeatureCollection = null;
            var _loc_2:Graphic = null;
            var _loc_3:Graphic = null;
            super.commitProperties();
            if (!this._urlChanged)
            {
            }
            if (this._featureCollectionChanged)
            {
                super.clear();
                this.clearTracks();
                this._querySnapshotDone = false;
                this._featureIds = new Vector.<Number>;
                this._featureMap = new Dictionary(true);
                this._featureRefCount = new Dictionary(true);
                this._selectedFeatures = new Dictionary(true);
                if (this._urlChanged)
                {
                    this._urlChanged = false;
                    if (this.url)
                    {
                    }
                    if (!this.isCollection)
                    {
                        this.loadDetails();
                    }
                }
                if (this._featureCollectionChanged)
                {
                    this._featureCollectionChanged = false;
                    this._collectionAdded = false;
                    _loc_1 = this.featureCollection;
                    if (_loc_1)
                    {
                    }
                    if (_loc_1.layerDefinition)
                    {
                        _loc_1.layerDefinition.objectIdField = "__object__id__";
                        this.initLayer(_loc_1.layerDefinition);
                    }
                    dispatchEvent(new Event("featureCollectionChanged"));
                }
            }
            if (this._selectionColorChanged)
            {
                for each (_loc_2 in this._selectedFeatures)
                {
                    
                    this.setSelectionFilter(_loc_2);
                }
                if (this._selectionColorChanged)
                {
                    this._selectionColorChanged = false;
                    dispatchEvent(new Event("selectionColorChanged"));
                }
            }
            if (this._timeDefinitionChanged)
            {
                this._timeDefinitionChanged = false;
                if (this.isSnapshot)
                {
                    this._querySnapshotDone = false;
                    this.clearIIF();
                    invalidateLayer();
                }
                dispatchEvent(new Event("timeDefinitionChanged"));
            }
            if (this._mapTimeExtentChanged)
            {
                this._mapTimeExtentChanged = false;
                if (!this.isSnapshot)
                {
                }
                if (!this.isSelOnly)
                {
                }
                if (this.isCollection)
                {
                    dispatchEvent(new LayerEvent(LayerEvent.UPDATE_START, this));
                    this.applyTimeFilter();
                    if (this._rendererIsTemporalRenderer)
                    {
                        this.invalidateVisibleGraphics();
                    }
                    addEventListener(Event.ENTER_FRAME, this.enterFrameHandlerFirst);
                }
                else if (this.isOnDemand)
                {
                    this.applyTimeFilter();
                    invalidateLayer();
                }
            }
            if (this._rendererChanged)
            {
                this._rendererChanged = false;
                if (!this._rendererIsTemporalRenderer)
                {
                }
                if (renderer is TemporalRenderer)
                {
                    this._rendererIsTemporalRenderer = true;
                    for each (_loc_3 in $graphicProvider)
                    {
                        
                        if (_loc_3.visible)
                        {
                            this.insertTemporalFeature(_loc_3);
                        }
                    }
                }
                else
                {
                    if (this._rendererIsTemporalRenderer)
                    {
                    }
                    if (!(renderer is TemporalRenderer))
                    {
                        this._rendererIsTemporalRenderer = false;
                        this.clearTracks();
                    }
                }
            }
            return;
        }// end function

        override public function moveToTop(graphic:Graphic) : void
        {
            if (!this.isTrack(graphic))
            {
                super.moveToTop(graphic);
            }
            return;
        }// end function

        override public function refresh() : void
        {
            super.refresh();
            if (!this.isCollection)
            {
                this._querySnapshotDone = false;
                this.clearIIF();
            }
            return;
        }// end function

        override protected function updateLayer() : void
        {
            var _loc_1:Array = null;
            var _loc_2:String = null;
            var _loc_3:Graphic = null;
            var _loc_4:Number = NaN;
            super.updateLayer();
            if (this.isCollection)
            {
                if (!this._collectionAdded)
                {
                    this._collectionAdded = true;
                    if (this.featureCollection.featureSet)
                    {
                        _loc_1 = this.featureCollection.featureSet.features;
                        if (_loc_1)
                        {
                        }
                        if (_loc_1.length > 0)
                        {
                            _loc_2 = this.objectIdField;
                            for each (_loc_3 in _loc_1)
                            {
                                
                                _loc_4 = NaN;
                                if (_loc_3.attributes)
                                {
                                    _loc_4 = _loc_3.attributes[_loc_2];
                                }
                                else
                                {
                                    _loc_3.attributes = {};
                                }
                                if (isNaN(_loc_4))
                                {
                                    var _loc_7:String = this;
                                    _loc_7._counter = this._counter + 1;
                                    _loc_4 = this._counter + 1;
                                    _loc_3.attributes[_loc_2] = _loc_4;
                                }
                                this.addFeatureIIf(_loc_4, _loc_3);
                                this.incRefCount(_loc_4);
                            }
                            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                            addEventListener(Event.ENTER_FRAME, this.enterFrameHandlerFirst);
                        }
                    }
                }
            }
            else
            {
                if (this.isSnapshot)
                {
                }
                if (this._querySnapshotDone)
                {
                }
                if (this.isOnDemand)
                {
                    this.updateQueryTask();
                    if (this.isSnapshot)
                    {
                        this.executeSnapshotQuery();
                    }
                    else
                    {
                        this.executeOnDemandQuery();
                    }
                    removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                }
            }
            return;
        }// end function

        override public function add(graphic:Graphic) : String
        {
            if (Log.isWarn())
            {
                this._log.warn("FeatureLayer.add() is not supported. Use applyEdits().");
            }
            return null;
        }// end function

        override public function clear() : void
        {
            if (Log.isWarn())
            {
                this._log.warn("FeatureLayer.clear() is not supported.");
            }
            return;
        }// end function

        override public function remove(graphic:Graphic) : void
        {
            if (Log.isWarn())
            {
                this._log.warn("FeatureLayer.remove() is not supported. Use applyEdits().");
            }
            return;
        }// end function

        final private function $add(graphic:Graphic) : void
        {
            super.add(graphic);
            return;
        }// end function

        private function incRefCount(oid:Number) : void
        {
            var _loc_2:* = this._featureMap[oid];
            if (_loc_2)
            {
                var _loc_3:* = this._featureRefCount;
                var _loc_4:* = _loc_2;
                var _loc_5:* = this._featureRefCount[_loc_2] + 1;
                _loc_3[_loc_4] = _loc_5;
            }
            return;
        }// end function

        private function decRefCount(oid:Number) : void
        {
            var _loc_2:* = this._featureMap[oid];
            if (_loc_2)
            {
                var _loc_3:* = this._featureRefCount;
                var _loc_4:* = _loc_2;
                var _loc_5:* = this._featureRefCount[_loc_2] - 1;
                _loc_3[_loc_4] = _loc_5;
            }
            return;
        }// end function

        private function getFeature(oid:Number) : Graphic
        {
            return this._featureMap[oid];
        }// end function

        private function addFeatureIIf(oid:Number, feature:Graphic) : Graphic
        {
            var _loc_3:* = this._featureMap[oid];
            if (!_loc_3)
            {
                this._featureMap[oid] = feature;
                this._featureIds.push(oid);
                this._featureRefCount[feature] = 0;
                this.insertTemporalFeature(feature);
                super.add(feature);
            }
            if (!_loc_3)
            {
            }
            return feature;
        }// end function

        private function removeFeatureIIf(oid:Number) : Graphic
        {
            var _loc_3:int = 0;
            var _loc_2:* = this._featureMap[oid];
            if (_loc_2)
            {
                if (this._featureRefCount[_loc_2])
                {
                    return null;
                }
                if (_loc_2.visible)
                {
                    this.removeTemporalFeature(_loc_2);
                }
                delete this._featureMap[oid];
                _loc_3 = this._featureIds.indexOf(oid);
                if (_loc_3 != -1)
                {
                    this._featureIds.splice(_loc_3, 1);
                }
                delete this._featureRefCount[_loc_2];
                super.remove(_loc_2);
            }
            return _loc_2;
        }// end function

        private function clearIIF() : void
        {
            var _loc_1:String = null;
            var _loc_2:Graphic = null;
            for (_loc_1 in this._featureMap)
            {
                
                if (!this._selectedFeatures[_loc_1])
                {
                    _loc_2 = this._featureMap[_loc_1];
                    this._featureRefCount[_loc_2] = 0;
                    this.removeFeatureIIf(Number(_loc_1));
                }
            }
            return;
        }// end function

        private function selectFeatureIIf(oid:Number, feature:Graphic) : Graphic
        {
            var _loc_3:* = this._selectedFeatures[oid];
            if (!_loc_3)
            {
                this.incRefCount(oid);
                this._selectedFeatures[oid] = feature;
                this.setSelectionFilter(feature);
            }
            if (!_loc_3)
            {
            }
            return feature;
        }// end function

        private function unSelectFeatureIIf(oid:Number) : Graphic
        {
            var _loc_2:* = this._selectedFeatures[oid];
            if (_loc_2)
            {
                this.decRefCount(oid);
                delete this._selectedFeatures[oid];
                this.clearSelectionFilter(_loc_2);
            }
            return _loc_2;
        }// end function

        private function setSelectionFilter(feature:Graphic) : void
        {
            var _loc_2:GlowFilter = null;
            var _loc_3:* = feature.filters;
            var _loc_4:* = this.glowFilterPosition(_loc_3);
            if (_loc_4 != -1)
            {
                _loc_2 = _loc_3[_loc_4];
            }
            else
            {
                _loc_2 = new GlowFilter();
                _loc_2.alpha = 0.6;
                _loc_2.blurX = 16;
                _loc_2.blurY = 16;
                _loc_2.inner = feature.geometry is Polygon;
                _loc_2.strength = 8;
                _loc_3.push(_loc_2);
            }
            _loc_2.color = this.selectionColor;
            feature.filters = _loc_3;
            return;
        }// end function

        private function clearSelectionFilter(feature:Graphic) : void
        {
            var _loc_2:* = feature.filters;
            var _loc_3:* = this.glowFilterPosition(_loc_2);
            if (_loc_3 != -1)
            {
                _loc_2.splice(_loc_3, 1);
            }
            feature.filters = _loc_2;
            return;
        }// end function

        private function glowFilterPosition(filters:Array) : int
        {
            var _loc_2:uint = 0;
            while (_loc_2 < filters.length)
            {
                
                if (filters[_loc_2] is GlowFilter)
                {
                    return _loc_2;
                }
                _loc_2 = _loc_2 + 1;
            }
            return -1;
        }// end function

        private function clearTracks() : void
        {
            var _loc_1:Graphic = null;
            for each (_loc_1 in this._trackFeatures)
            {
                
                removeChild(_loc_1);
            }
            this._latestFeatures = new Dictionary(true);
            this._trackFeatures = new Dictionary(true);
            this._historicalFeatures = [];
            return;
        }// end function

        function isLatestObservation(feature:Graphic) : Boolean
        {
            var _loc_2:Object = null;
            var _loc_3:Graphic = null;
            if (this.startTimeField)
            {
                if (!this.trackIdField)
                {
                    _loc_2 = this.id;
                }
                else
                {
                    _loc_2 = feature.attributes[this.trackIdField];
                }
                _loc_3 = this._latestFeatures[_loc_2];
                if (_loc_3 === feature)
                {
                    return true;
                }
            }
            return false;
        }// end function

        function isTrack(feature:Graphic) : Boolean
        {
            var _loc_2:Object = null;
            var _loc_3:Graphic = null;
            if (this.startTimeField)
            {
                if (!this.trackIdField)
                {
                    _loc_2 = this.id;
                }
                else
                {
                    _loc_2 = feature.attributes[this.trackIdField];
                }
                _loc_3 = this._trackFeatures[_loc_2];
                if (_loc_3 === feature)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function insertTemporalFeature(feature:Graphic) : void
        {
            var _loc_3:Object = null;
            var _loc_6:Graphic = null;
            var _loc_7:int = 0;
            var _loc_2:* = this.startTimeField;
            if (this._rendererIsTemporalRenderer)
            {
            }
            if (!_loc_2)
            {
                return;
            }
            if (!this.trackIdField)
            {
                _loc_3 = this.id;
            }
            else
            {
                _loc_3 = feature.attributes[this.trackIdField];
            }
            var _loc_4:* = Graphic(this._latestFeatures[_loc_3]);
            var _loc_5:* = this.getTrackPoint(feature.geometry);
            if (_loc_4)
            {
                _loc_6 = Graphic(this._trackFeatures[_loc_3]);
                if (Number(_loc_4.attributes[_loc_2]) <= Number(feature.attributes[_loc_2]))
                {
                    _loc_4.invalidateGraphic();
                    (this._historicalFeatures[_loc_3] as Array).push(_loc_4);
                    this._latestFeatures[_loc_3] = feature;
                    (Polyline(_loc_6.geometry).paths[0] as Array).push(_loc_5);
                    if (feature.parent === this)
                    {
                        setChildIndex(feature, (numChildren - 1));
                    }
                }
                else
                {
                    _loc_7 = this.findInsertLocationInTrack(_loc_3, feature);
                    (this._historicalFeatures[_loc_3] as Array).splice(_loc_7, 0, feature);
                    (Polyline(_loc_6.geometry).paths[0] as Array).splice(_loc_7, 0, _loc_5);
                }
                setChildIndex(_loc_6, 0);
                _loc_6.invalidateGraphic();
            }
            else
            {
                this._latestFeatures[_loc_3] = feature;
                this._historicalFeatures[_loc_3] = [];
                _loc_6 = new Graphic(new Polyline([[]]));
                this._trackFeatures[_loc_3] = _loc_6;
                (Polyline(_loc_6.geometry).paths[0] as Array).push(_loc_5);
                _loc_6.attributes = {};
                _loc_6.attributes[this.trackIdField] = _loc_3;
                addChildAt(_loc_6, 0);
            }
            return;
        }// end function

        private function findInsertLocationInTrack(trackID:Object, feature:Graphic) : int
        {
            var _loc_3:* = this.startTimeField;
            var _loc_4:* = this._historicalFeatures[trackID] as Array;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                if (Graphic(_loc_4[_loc_5]).attributes[_loc_3] > feature.attributes[_loc_3])
                {
                    return _loc_5;
                }
                _loc_5 = _loc_5 + 1;
            }
            return -1;
        }// end function

        private function getTrackPoint(geometry:Geometry) : MapPoint
        {
            var _loc_3:Polyline = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:Polygon = null;
            var _loc_2:MapPoint = null;
            if (geometry is MapPoint)
            {
                _loc_2 = geometry as MapPoint;
            }
            else if (geometry is Polyline)
            {
                _loc_3 = geometry as Polyline;
                if (_loc_3.paths.length > 0)
                {
                    _loc_4 = _loc_3.paths[0] as Array;
                    if (_loc_4.length > 0)
                    {
                        _loc_5 = _loc_4.length / 2 + 0.5;
                        _loc_2 = _loc_4[(_loc_5 - 1)] as MapPoint;
                    }
                }
            }
            else if (geometry is Polygon)
            {
                _loc_6 = geometry as Polygon;
                _loc_2 = _loc_6.extent.center;
            }
            return _loc_2;
        }// end function

        private function removeTemporalFeature(feature:Graphic) : void
        {
            var _loc_2:Object = null;
            var _loc_5:int = 0;
            if (this._rendererIsTemporalRenderer)
            {
            }
            if (!this.startTimeField)
            {
                return;
            }
            if (!this.trackIdField)
            {
                _loc_2 = this.id;
            }
            else
            {
                _loc_2 = feature.attributes[this.trackIdField];
            }
            var _loc_3:* = this._historicalFeatures[_loc_2] as Array;
            var _loc_4:* = Graphic(this._trackFeatures[_loc_2]);
            if (Graphic(this._latestFeatures[_loc_2]) === feature)
            {
                delete this._latestFeatures[_loc_2];
                if (_loc_3.length > 0)
                {
                    this._latestFeatures[_loc_2] = _loc_3.pop();
                    (Polyline(_loc_4.geometry).paths[0] as Array).pop();
                    _loc_4.invalidateGraphic();
                }
                else
                {
                    removeChild(_loc_4);
                    delete this._trackFeatures[_loc_2];
                    delete this._historicalFeatures[_loc_2];
                }
            }
            else
            {
                _loc_5 = this.findRemoveLocationInTrack(_loc_2, feature);
                _loc_3.splice(_loc_5, 1);
                (Polyline(_loc_4.geometry).paths[0] as Array).splice(_loc_5, 1);
                _loc_4.invalidateGraphic();
            }
            return;
        }// end function

        private function findRemoveLocationInTrack(trackID:Object, feature:Graphic) : int
        {
            var _loc_3:* = this._historicalFeatures[trackID] as Array;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                if (Graphic(_loc_3[_loc_4]) === feature)
                {
                    return _loc_4;
                }
                _loc_4 = _loc_4 + 1;
            }
            return -1;
        }// end function

        public function applyEdits(adds:Array, updates:Array, deletes:Array, rollbackOnFailure:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var _loc_6:AsyncToken = null;
            var _loc_8:FeatureLayerEvent = null;
            var _loc_9:FeatureEditResults = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:Graphic = null;
            var _loc_13:FeatureEditResult = null;
            if (hasEventListener(FeatureLayerEvent.EDITS_STARTING))
            {
                _loc_8 = new FeatureLayerEvent(FeatureLayerEvent.EDITS_STARTING, this, true);
                _loc_8.adds = adds;
                _loc_8.updates = updates;
                _loc_8.deletes = deletes;
                if (!dispatchEvent(_loc_8))
                {
                    return null;
                }
            }
            var _loc_7:* = this.objectIdField;
            if (this.isCollection)
            {
                _loc_6 = new AsyncToken(null);
                if (responder)
                {
                    _loc_6.addResponder(responder);
                }
                _loc_9 = new FeatureEditResults();
                if (adds)
                {
                    _loc_9.addResults = [];
                    _loc_10 = 0;
                    _loc_11 = adds.length;
                    while (_loc_10 < _loc_11)
                    {
                        
                        _loc_13 = new FeatureEditResult();
                        var _loc_14:String = this;
                        _loc_14._counter = this._counter + 1;
                        _loc_13.objectId = this._counter + 1;
                        _loc_13.success = true;
                        _loc_9.addResults.push(_loc_13);
                        _loc_10 = _loc_10 + 1;
                    }
                }
                if (updates)
                {
                    _loc_9.updateResults = [];
                    _loc_10 = 0;
                    _loc_11 = updates.length;
                    while (_loc_10 < _loc_11)
                    {
                        
                        _loc_12 = updates[_loc_10];
                        _loc_13 = new FeatureEditResult();
                        _loc_13.objectId = _loc_12.attributes[_loc_7];
                        _loc_13.success = true;
                        _loc_9.updateResults.push(_loc_13);
                        _loc_10 = _loc_10 + 1;
                    }
                }
                if (deletes)
                {
                    _loc_9.deleteResults = [];
                    _loc_10 = 0;
                    _loc_11 = deletes.length;
                    while (_loc_10 < _loc_11)
                    {
                        
                        _loc_12 = deletes[_loc_10];
                        _loc_13 = new FeatureEditResult();
                        _loc_13.objectId = _loc_12.attributes[_loc_7];
                        _loc_13.success = true;
                        _loc_9.deleteResults.push(_loc_13);
                        _loc_10 = _loc_10 + 1;
                    }
                }
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.editHandler, [_loc_9, adds, _loc_6]);
                }
                else
                {
                    this.editHandler(_loc_9, adds, _loc_6);
                }
            }
            else
            {
                this.updateFLTask();
                _loc_6 = this._featureLayerTask.applyEdits(adds, updates, deletes, _loc_7, rollbackOnFailure);
                _loc_6.addResponder(new AsyncResponder(this.editHandler, this.faultHandler, adds));
                if (responder)
                {
                    _loc_6.addResponder(responder);
                }
            }
            return _loc_6;
        }// end function

        function editHandler(results:FeatureEditResults, adds:Array, asyncToken:AsyncToken = null) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Graphic = null;
            var _loc_8:Array = null;
            var _loc_9:FeatureEditResult = null;
            var _loc_10:Graphic = null;
            var _loc_11:Array = null;
            var _loc_12:FeatureEditResult = null;
            var _loc_13:FeatureLayerEvent = null;
            var _loc_14:IResponder = null;
            var _loc_15:FeatureLayerEvent = null;
            var _loc_7:* = this.objectIdField;
            if (results.addResults)
            {
            }
            if (!this.isTable)
            {
                _loc_8 = [];
                _loc_4 = 0;
                _loc_5 = results.addResults.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_9 = results.addResults[_loc_4];
                    if (_loc_9.success)
                    {
                        _loc_6 = adds[_loc_4];
                        if (!_loc_6.attributes)
                        {
                            _loc_6.attributes = {};
                        }
                        _loc_6.attributes[_loc_7] = _loc_9.objectId;
                        if (_loc_6.parent)
                        {
                        }
                        if (_loc_6.parent != this)
                        {
                        }
                        if (_loc_6.parent is GraphicsLayer)
                        {
                            GraphicsLayer(_loc_6.parent).remove(_loc_6);
                        }
                        if (!this.isSelOnly)
                        {
                            _loc_10 = this.addFeatureIIf(_loc_9.objectId, _loc_6);
                            this.incRefCount(_loc_9.objectId);
                            _loc_8.push(_loc_10);
                        }
                    }
                    _loc_4 = _loc_4 + 1;
                }
                if (_loc_8.length > 0)
                {
                    this.applyTimeFilter(_loc_8);
                }
            }
            if (results.deleteResults)
            {
                _loc_11 = [];
                _loc_4 = 0;
                _loc_5 = results.deleteResults.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_12 = results.deleteResults[_loc_4];
                    if (_loc_12.success)
                    {
                        _loc_6 = this.getFeature(_loc_12.objectId);
                        if (_loc_6)
                        {
                            if (this.unSelectFeatureIIf(_loc_12.objectId))
                            {
                                _loc_11.push(_loc_6);
                            }
                            this._featureRefCount[_loc_6] = 0;
                            this.removeFeatureIIf(_loc_12.objectId);
                        }
                    }
                    _loc_4 = _loc_4 + 1;
                }
                if (_loc_11.length > 0)
                {
                    _loc_13 = new FeatureLayerEvent(FeatureLayerEvent.SELECTION_COMPLETE, this);
                    _loc_13.features = _loc_11;
                    _loc_13.selectionMethod = SELECTION_SUBTRACT;
                    dispatchEvent(_loc_13);
                }
            }
            if (asyncToken)
            {
                for each (_loc_14 in asyncToken.responders)
                {
                    
                    _loc_14.result(results);
                }
            }
            if (hasEventListener(FeatureLayerEvent.EDITS_COMPLETE))
            {
                _loc_15 = new FeatureLayerEvent(FeatureLayerEvent.EDITS_COMPLETE, this);
                _loc_15.featureEditResults = results;
                dispatchEvent(_loc_15);
            }
            return;
        }// end function

        public function clearSelection() : void
        {
            this.clearSelectionInternal(false);
            return;
        }// end function

        private function clearSelectionInternal(noEvent:Boolean) : void
        {
            var _loc_2:FeatureLayerEvent = null;
            var _loc_3:String = null;
            var _loc_4:Graphic = null;
            if (!noEvent)
            {
            }
            if (hasEventListener(FeatureLayerEvent.SELECTION_CLEAR))
            {
                _loc_2 = new FeatureLayerEvent(FeatureLayerEvent.SELECTION_CLEAR, this);
                _loc_2.features = [];
            }
            for (_loc_3 in this._selectedFeatures)
            {
                
                _loc_4 = this.unSelectFeatureIIf(Number(_loc_3));
                if (_loc_2)
                {
                }
                if (_loc_4)
                {
                    _loc_2.features.push(_loc_4);
                }
                this.removeFeatureIIf(Number(_loc_3));
            }
            this._selectedFeatures = new Dictionary(true);
            if (_loc_2)
            {
                dispatchEvent(_loc_2);
            }
            return;
        }// end function

        private function executeOnDemandQuery() : void
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var idsInExtent:Vector.<Number>;
            var oid:Number;
            var feature:Graphic;
            var notIn:String;
            var defExp:String;
            myResultFunction = function (result:FeatureSet, token:Object = null) : void
            {
                var _loc_3:Graphic = null;
                var _loc_5:Number = NaN;
                var _loc_6:Graphic = null;
                if (_requestID != token)
                {
                    return;
                }
                var _loc_4:* = thisLayer.objectIdField;
                if (_loc_4)
                {
                    if (onDemandCacheSize > 0)
                    {
                        purgeFeatures();
                        if (_rendererIsTemporalRenderer)
                        {
                            invalidateVisibleGraphics();
                        }
                    }
                    else
                    {
                        clearIIF();
                    }
                    for each (_loc_3 in result.features)
                    {
                        
                        _loc_5 = _loc_3.attributes[_loc_4];
                        _loc_6 = addFeatureIIf(_loc_5, _loc_3);
                        if (_loc_6 === _loc_3)
                        {
                            incRefCount(_loc_5);
                        }
                    }
                }
                else
                {
                    $graphicProvider.removeAll();
                    for each (_loc_3 in result.features)
                    {
                        
                        $add(_loc_3);
                    }
                }
                addEventListener(Event.ENTER_FRAME, enterFrameHandlerFirst);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object, token:Object = null) : void
            {
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, String(error));
                }
                dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, thisLayer, error as Fault, false));
                return;
            }// end function
            ;
            thisLayer;
            var extent:* = map.extent;
            var query:* = new Query();
            query.geometry = extent;
            if (!this.isEditable)
            {
                query.maxAllowableOffset = this.maxAllowableOffset;
            }
            query.outFields = this.getOutFieldsWithReqdFields();
            query.outSpatialReference = map.spatialReference;
            query.returnGeometry = true;
            query.returnM = this.returnM;
            query.returnZ = this.returnZ;
            query.timeExtent = this.timeExtentFromMapWithOffset;
            if (this._featureIds.length > 0)
            {
            }
            if (this.onDemandCacheSize > 0)
            {
                idsInExtent = new Vector.<Number>;
                var _loc_2:int = 0;
                var _loc_3:* = this._featureIds;
                while (_loc_3 in _loc_2)
                {
                    
                    oid = _loc_3[_loc_2];
                    feature = this._featureMap[oid];
                    if (feature.visible)
                    {
                    }
                    if (extent.intersects(feature.geometry))
                    {
                        idsInExtent.push(oid);
                        if (idsInExtent.length >= MAX_IN_CLAUSE_COUNT)
                        {
                            break;
                        }
                    }
                }
                if (idsInExtent.length > 0)
                {
                    notIn = this.objectIdField + " NOT IN (" + idsInExtent.join() + ")";
                }
            }
            if (this.definitionExpression)
            {
                defExp = StringUtil.trim(this.definitionExpression);
                if (defExp.length == 0)
                {
                }
            }
            if (defExp)
            {
            }
            if (notIn)
            {
                query.where = "(" + defExp + ") AND " + notIn;
            }
            else if (notIn)
            {
                query.where = notIn;
            }
            else if (defExp)
            {
                query.where = defExp;
            }
            var _loc_2:String = this;
            _loc_2._requestID = this._requestID + 1;
            this._queryTask.execute(query, new AsyncResponder(myResultFunction, myFaultFunction, ++this._requestID));
            return;
        }// end function

        private function invalidateVisibleGraphics() : void
        {
            var _loc_1:Graphic = null;
            for each (_loc_1 in $graphicProvider)
            {
                
                if (_loc_1.visible)
                {
                    _loc_1.invalidateGraphic();
                }
            }
            return;
        }// end function

        private function purgeFeatures() : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Graphic = null;
            var _loc_5:Boolean = false;
            var _loc_6:Extent = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Multipoint = null;
            var _loc_9:Graphic = null;
            if (this.isOnDemand)
            {
            }
            if (this._featureIds.length <= this.onDemandCacheSize)
            {
                return;
            }
            var _loc_1:* = map.extent;
            var _loc_2:uint = 0;
            do
            {
                
                _loc_3 = this._featureIds[_loc_2];
                if (!this._selectedFeatures[_loc_3])
                {
                    _loc_4 = this._featureMap[_loc_3];
                    _loc_5 = false;
                    _loc_6 = _loc_4.geometry ? (_loc_4.geometry.extent) : (null);
                    if (!_loc_4.visible)
                    {
                        _loc_5 = true;
                    }
                    else
                    {
                        if (_loc_6)
                        {
                        }
                        if (!_loc_1.intersects(_loc_6))
                        {
                            _loc_5 = true;
                        }
                        else
                        {
                            _loc_7 = _loc_4.geometry as MapPoint;
                            if (!_loc_7)
                            {
                            }
                            if (_loc_4.geometry is Multipoint)
                            {
                                _loc_8 = Multipoint(_loc_4.geometry);
                                if (_loc_8.points)
                                {
                                }
                                if (_loc_8.points.length == 1)
                                {
                                    _loc_7 = _loc_8.points[0] as MapPoint;
                                }
                            }
                            if (_loc_7)
                            {
                            }
                            if (!_loc_1.contains(_loc_7))
                            {
                                _loc_5 = true;
                            }
                        }
                    }
                    if (_loc_5)
                    {
                        this._featureRefCount[_loc_4] = 0;
                        _loc_9 = this.removeFeatureIIf(Number(_loc_3));
                        if (_loc_9)
                        {
                            _loc_2 = _loc_2 - 1;
                        }
                    }
                }
                _loc_2 = _loc_2 + 1;
                if (_loc_2 < this._featureIds.length)
                {
                }
            }while (this._featureIds.length > this.onDemandCacheSize)
            return;
        }// end function

        private function executeSnapshotQuery() : void
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (result:FeatureSet, token:Object = null) : void
            {
                var _loc_3:Graphic = null;
                var _loc_5:Number = NaN;
                if (_requestID != token)
                {
                    return;
                }
                var _loc_4:* = thisLayer.objectIdField;
                if (_loc_4)
                {
                    for each (_loc_3 in result.features)
                    {
                        
                        _loc_5 = _loc_3.attributes[_loc_4];
                        addFeatureIIf(_loc_5, _loc_3);
                        incRefCount(_loc_5);
                    }
                }
                else
                {
                    $graphicProvider.removeAll();
                    for each (_loc_3 in result.features)
                    {
                        
                        $add(_loc_3);
                    }
                }
                applyTimeFilter();
                _querySnapshotDone = true;
                addEventListener(Event.ENTER_FRAME, enterFrameHandlerFirst);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object, token:Object = null) : void
            {
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, String(error));
                }
                dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, thisLayer, error as Fault, false));
                return;
            }// end function
            ;
            thisLayer;
            var query:* = new Query();
            if (!this.isEditable)
            {
                query.maxAllowableOffset = this.maxAllowableOffset;
            }
            query.outFields = this.getOutFieldsWithReqdFields();
            query.outSpatialReference = map.spatialReference;
            query.returnGeometry = true;
            query.returnM = this.returnM;
            query.returnZ = this.returnZ;
            query.timeExtent = this.timeDefinition;
            query.where = this.definitionExpression ? (this.definitionExpression) : ("1=1");
            var _loc_2:String = this;
            _loc_2._requestID = this._requestID + 1;
            this._queryTask.execute(query, new AsyncResponder(myResultFunction, myFaultFunction, ++this._requestID));
            return;
        }// end function

        private function getOutFieldsWithReqdFields() : Array
        {
            var _loc_1:Array = null;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_2:* = this.outFields;
            if (_loc_2)
            {
            }
            if (_loc_2.indexOf("*") != -1)
            {
                _loc_1 = _loc_2;
            }
            else
            {
                _loc_1 = [];
                if (!this._outFieldsSet)
                {
                    _loc_2 = [this.displayField];
                }
                for each (_loc_3 in _loc_2)
                {
                    
                    if (_loc_3)
                    {
                    }
                    if (_loc_1.indexOf(_loc_3) == -1)
                    {
                        _loc_1.push(_loc_3);
                    }
                }
                _loc_4 = [this.objectIdField, this.typeIdField, this.startTimeField, this.endTimeField, this.trackIdField];
                if (this.editFieldsInfo)
                {
                }
                if (this.ownershipBasedAccessControlForFeatures)
                {
                    _loc_4.push(this.editFieldsInfo.creatorField);
                }
                for each (_loc_3 in _loc_4)
                {
                    
                    if (_loc_3)
                    {
                    }
                    if (_loc_1.indexOf(_loc_3) == -1)
                    {
                        _loc_1.push(_loc_3);
                    }
                }
                _loc_5 = this.getRendererFields();
                for each (_loc_3 in _loc_5)
                {
                    
                    if (_loc_3)
                    {
                    }
                    if (_loc_1.indexOf(_loc_3) == -1)
                    {
                        _loc_1.push(_loc_3);
                    }
                }
                if (_loc_1.length == 0)
                {
                    _loc_1 = null;
                }
            }
            return _loc_1;
        }// end function

        private function getRendererFields() : Array
        {
            var _loc_1:Array = null;
            var _loc_3:Array = null;
            var _loc_4:TemporalRenderer = null;
            var _loc_2:* = this.renderer;
            if (_loc_2)
            {
                _loc_1 = [];
                _loc_3 = [];
                if (_loc_2 is TemporalRenderer)
                {
                    _loc_4 = TemporalRenderer(_loc_2);
                    _loc_3.push(_loc_4.latestObservationRenderer);
                    _loc_3.push(_loc_4.observationRenderer);
                    _loc_3.push(_loc_4.trackRenderer);
                }
                else
                {
                    _loc_3.push(_loc_2);
                }
                for each (_loc_2 in _loc_3)
                {
                    
                    if (_loc_2 is ClassBreaksRenderer)
                    {
                        _loc_1.push(ClassBreaksRenderer(_loc_2).field);
                        continue;
                    }
                    if (_loc_2 is UniqueValueRenderer)
                    {
                        _loc_1.push(UniqueValueRenderer(_loc_2).field);
                        _loc_1.push(UniqueValueRenderer(_loc_2).field2);
                        _loc_1.push(UniqueValueRenderer(_loc_2).field3);
                    }
                }
            }
            return _loc_1;
        }// end function

        private function applyTimeFilter(features:Array = null) : void
        {
            var _loc_2:Graphic = null;
            var _loc_4:TimeExtent = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            if (!this.timeInfo)
            {
                return;
            }
            if (!features)
            {
                features = $graphicProvider.toArray();
            }
            var _loc_3:* = this.timeExtentFromMapWithOffset;
            if (_loc_3)
            {
                _loc_4 = this.isSnapshot ? (this.timeDefinition) : (null);
                if (_loc_4)
                {
                    _loc_3 = _loc_3.intersection(_loc_4);
                }
                if (_loc_3)
                {
                    _loc_5 = this.filterByTime(features, _loc_3);
                    _loc_6 = _loc_5[0];
                    for each (_loc_2 in _loc_6)
                    {
                        
                        if (!_loc_2.visible)
                        {
                            _loc_2.visible = true;
                            this.insertTemporalFeature(_loc_2);
                        }
                    }
                    _loc_7 = _loc_5[1];
                    for each (_loc_2 in _loc_7)
                    {
                        
                        if (_loc_2.visible)
                        {
                            _loc_2.visible = false;
                            this.removeTemporalFeature(_loc_2);
                        }
                    }
                }
                else
                {
                    for each (_loc_2 in features)
                    {
                        
                        if (_loc_2.visible)
                        {
                            _loc_2.visible = false;
                            this.removeTemporalFeature(_loc_2);
                        }
                    }
                }
            }
            else
            {
                for each (_loc_2 in features)
                {
                    
                    if (!_loc_2.visible)
                    {
                        _loc_2.visible = true;
                        this.insertTemporalFeature(_loc_2);
                    }
                }
            }
            return;
        }// end function

        private function loadDetails() : void
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            myResultFunction = function (result:Object, token:Object = null) : void
            {
                if (token == url)
                {
                    credential = IdentityManager.instance.findCredential(urlObj.path);
                    initLayer(result);
                }
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object, token:Object = null) : void
            {
                if (Log.isError())
                {
                    _log.error("{0}::{1}", id, String(error));
                }
                dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, thisLayer, error as Fault));
                return;
            }// end function
            ;
            thisLayer;
            var task:* = new DetailsTask(this.url);
            task.disableClientCaching = this.disableClientCaching;
            task.proxyURL = this.proxyURL;
            task.requestTimeout = this.requestTimeout;
            task.token = this.token;
            var responder:* = new AsyncResponder(myResultFunction, myFaultFunction, this.url);
            if (this.source)
            {
                task.getSourceDetails(this.source, responder);
            }
            else
            {
                task.getLayerOrTableDetails(responder);
            }
            return;
        }// end function

        private function loadDetailsEarly() : void
        {
            if (!parent)
            {
            }
            if (this._urlChanged)
            {
                this._urlChanged = false;
                this.loadDetails();
            }
            return;
        }// end function

        private function initLayer(details:Object) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:IRenderer = null;
            var _loc_4:ESRIError = null;
            this._layerDetails = details as LayerDetails;
            this._tableDetails = details as TableDetails;
            if (!this._layerDetails)
            {
            }
            if (this._tableDetails)
            {
                if (this._layerDetails)
                {
                    initialExtent = this._layerDetails.extent;
                    spatialReference = this._layerDetails.spatialReference;
                    if (!this._alphaSet)
                    {
                    }
                    if (this._layerDetails.drawingInfo)
                    {
                        _loc_2 = this._layerDetails.drawingInfo.alpha;
                        if (!isNaN(_loc_2))
                        {
                            this.alpha = _loc_2;
                            this._alphaSet = false;
                        }
                    }
                    if (!this._maxScaleSet)
                    {
                        this.maxScale = this._layerDetails.maxScale;
                        this._maxScaleSet = false;
                    }
                    if (!this._minScaleSet)
                    {
                        this.minScale = this._layerDetails.minScale;
                        this._minScaleSet = false;
                    }
                    if (!this._rendererSet)
                    {
                    }
                    if (!this._symbolSet)
                    {
                    }
                    if (this._layerDetails.drawingInfo)
                    {
                        _loc_3 = this._layerDetails.drawingInfo.renderer;
                        if (_loc_3)
                        {
                            this.renderer = _loc_3;
                            this._rendererSet = false;
                        }
                    }
                    if (!this._trackIdFieldSet)
                    {
                    }
                    if (this._layerDetails.timeInfo)
                    {
                        this.trackIdField = this._layerDetails.timeInfo.trackIdField;
                        this._trackIdFieldSet = false;
                    }
                }
                else if (this._tableDetails)
                {
                    if (!this._trackIdFieldSet)
                    {
                    }
                    if (this._tableDetails.timeInfo)
                    {
                        this.trackIdField = this._tableDetails.timeInfo.trackIdField;
                        this._trackIdFieldSet = false;
                    }
                }
                if (this._layerDetails)
                {
                }
                if (!this.isCollection)
                {
                    if (this._layerDetails.fields)
                    {
                    }
                }
                if (this._layerDetails.fields.length == 0)
                {
                    _loc_4 = new ESRIError(ESRIMessageCodes.INVALID_FEATURE_LAYER, this.url);
                    dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, this, new Fault(null, _loc_4.message)));
                    throw _loc_4;
                }
                setLoaded(true);
                invalidateLayer();
            }
            return;
        }// end function

        public function queryFeatures(parameters:Query, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var queryResults:Array;
            var collectionFault:Fault;
            var oidField:String;
            var parameters:* = parameters;
            var responder:* = responder;
            this.updateQueryTask();
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var query2:* = parameters.getShallowClone();
            query2.outFields = this.getOutFieldsWithReqdFields();
            query2.returnGeometry = true;
            query2.returnM = this.returnM;
            query2.returnZ = this.returnZ;
            if (map)
            {
            }
            if (map.spatialReference)
            {
                query2.outSpatialReference = map.spatialReference;
            }
            if (!this.applyQueryFilters(query2))
            {
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryFeaturesHandler, [new FeatureSet([]), asyncToken]);
                }
                else
                {
                    this.queryFeaturesHandler(new FeatureSet([]), asyncToken);
                }
                return asyncToken;
            }
            var queryTypes:* = this.canDoClientSideQuery(query2);
            if (queryTypes)
            {
                queryResults = this.doQuery(query2, queryTypes);
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryFeaturesHandler, [new FeatureSet(queryResults), asyncToken]);
                }
                else
                {
                    this.queryFeaturesHandler(new FeatureSet(queryResults), asyncToken);
                }
            }
            else if (this.isCollection)
            {
                collectionFault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.UNSUPPORTED_QUERY_PARAMETERS));
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.faultHandler, [collectionFault, asyncToken]);
                }
                else
                {
                    this.faultHandler(collectionFault, asyncToken);
                }
            }
            else
            {
                var myResultFunction:* = function (result:FeatureSet) : void
            {
                var _loc_2:Array = null;
                var _loc_3:uint = 0;
                var _loc_4:uint = 0;
                var _loc_5:Graphic = null;
                var _loc_6:Number = NaN;
                var _loc_7:Graphic = null;
                if (result)
                {
                }
                if (result.features)
                {
                    _loc_2 = result.features;
                    _loc_3 = _loc_2.length;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _loc_5 = _loc_2[_loc_4];
                        _loc_6 = _loc_5.attributes[oidField];
                        _loc_7 = getFeature(_loc_6);
                        if (_loc_7)
                        {
                            _loc_2.splice(_loc_4, 1, _loc_7);
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                }
                queryFeaturesHandler(result, asyncToken);
                return;
            }// end function
            ;
                var myFaultFunction:* = function (error:Object) : void
            {
                faultHandler(error as Fault, asyncToken);
                return;
            }// end function
            ;
                oidField = this.objectIdField;
                this._queryTask.execute(query2, new Responder(myResultFunction, myFaultFunction));
            }
            return asyncToken;
        }// end function

        private function queryFeaturesHandler(result:FeatureSet, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:FeatureLayerEvent = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(result);
            }
            _loc_4 = new FeatureLayerEvent(FeatureLayerEvent.QUERY_FEATURES_COMPLETE, this);
            _loc_4.featureSet = result;
            dispatchEvent(_loc_4);
            return;
        }// end function

        private function faultHandler(fault:Fault, token:Object = null) : void
        {
            var _loc_3:AsyncToken = null;
            var _loc_4:IResponder = null;
            if (token is AsyncToken)
            {
                _loc_3 = AsyncToken(token);
                for each (_loc_4 in _loc_3.responders)
                {
                    
                    _loc_4.fault(fault);
                }
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
            return;
        }// end function

        public function queryCount(parameters:Query, responder:IResponder = null) : AsyncToken
        {
            var _loc_6:Array = null;
            var _loc_7:Fault = null;
            this.updateQueryTask();
            var _loc_3:* = new AsyncToken(null);
            if (responder)
            {
                _loc_3.addResponder(responder);
            }
            var _loc_4:* = parameters.getShallowClone();
            if (!this.applyQueryFilters(_loc_4))
            {
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryCountHandler, [0, _loc_3]);
                }
                else
                {
                    this.queryCountHandler(0, _loc_3);
                }
                return _loc_3;
            }
            var _loc_5:* = this.canDoClientSideQuery(_loc_4);
            if (_loc_5)
            {
                _loc_6 = this.doQuery(_loc_4, _loc_5);
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryCountHandler, [_loc_6.length, _loc_3]);
                }
                else
                {
                    this.queryCountHandler(_loc_6.length, _loc_3);
                }
            }
            else if (this.isCollection)
            {
                _loc_7 = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.UNSUPPORTED_QUERY_PARAMETERS));
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.faultHandler, [_loc_7, _loc_3]);
                }
                else
                {
                    this.faultHandler(_loc_7, _loc_3);
                }
            }
            else
            {
                this._queryTask.executeForCount(_loc_4, new AsyncResponder(this.queryCountHandler, this.faultHandler, _loc_3));
            }
            return _loc_3;
        }// end function

        private function queryCountHandler(result:Number, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:FeatureLayerEvent = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(result);
            }
            _loc_4 = new FeatureLayerEvent(FeatureLayerEvent.QUERY_COUNT_COMPLETE, this);
            _loc_4.count = result;
            dispatchEvent(_loc_4);
            return;
        }// end function

        public function queryIds(parameters:Query, responder:IResponder = null) : AsyncToken
        {
            var _loc_6:Array = null;
            var _loc_7:Fault = null;
            this.updateQueryTask();
            var _loc_3:* = new AsyncToken(null);
            if (responder)
            {
                _loc_3.addResponder(responder);
            }
            var _loc_4:* = parameters.getShallowClone();
            if (!this.applyQueryFilters(_loc_4))
            {
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryIdsHandler, [[], _loc_3]);
                }
                else
                {
                    this.queryIdsHandler([], _loc_3);
                }
                return _loc_3;
            }
            var _loc_5:* = this.canDoClientSideQuery(_loc_4);
            if (_loc_5)
            {
                _loc_6 = this.doQuery(_loc_4, _loc_5, true);
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.queryIdsHandler, [_loc_6, _loc_3]);
                }
                else
                {
                    this.queryIdsHandler(_loc_6, _loc_3);
                }
            }
            else if (this.isCollection)
            {
                _loc_7 = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.UNSUPPORTED_QUERY_PARAMETERS));
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.faultHandler, [_loc_7, _loc_3]);
                }
                else
                {
                    this.faultHandler(_loc_7, _loc_3);
                }
            }
            else
            {
                this._queryTask.executeForIds(_loc_4, new AsyncResponder(this.queryIdsHandler, this.faultHandler, _loc_3));
            }
            return _loc_3;
        }// end function

        private function queryIdsHandler(result:Array, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            var _loc_4:FeatureLayerEvent = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(result);
            }
            _loc_4 = new FeatureLayerEvent(FeatureLayerEvent.QUERY_IDS_COMPLETE, this);
            _loc_4.objectIds = result;
            dispatchEvent(_loc_4);
            return;
        }// end function

        public function queryRelatedFeatures(parameters:RelationshipQuery, responder:IResponder = null) : AsyncToken
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var parameters:* = parameters;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new FeatureLayerEvent(FeatureLayerEvent.QUERY_RELATED_FEATURES_COMPLETE, thisLayer);
                _loc_2.relatedRecords = result;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            this.updateQueryTask();
            thisLayer;
            var asyncToken:* = this._queryTask.executeRelationshipQuery(parameters, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function selectFeatures(query:Query, selectionMethod:String = "new", responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var queryResults:Array;
            var collectionFault:Fault;
            var query:* = query;
            var selectionMethod:* = selectionMethod;
            var responder:* = responder;
            this.updateQueryTask();
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            var query2:* = query.getShallowClone();
            query2.outFields = this.getOutFieldsWithReqdFields();
            query2.returnGeometry = true;
            query2.returnM = this.returnM;
            query2.returnZ = this.returnZ;
            if (map)
            {
            }
            if (map.spatialReference)
            {
                query2.outSpatialReference = map.spatialReference;
            }
            if (!this.applyQueryFilters(query2))
            {
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.selectFeaturesHandler, [new FeatureSet([]), selectionMethod, asyncToken]);
                }
                else
                {
                    this.selectFeaturesHandler(new FeatureSet([]), selectionMethod, asyncToken);
                }
                return asyncToken;
            }
            var queryTypes:* = this.canDoClientSideQuery(query2);
            if (queryTypes)
            {
                queryResults = this.doQuery(query2, queryTypes);
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.selectFeaturesHandler, [new FeatureSet(queryResults), selectionMethod, asyncToken]);
                }
                else
                {
                    this.selectFeaturesHandler(new FeatureSet(queryResults), selectionMethod, asyncToken);
                }
            }
            else if (this.isCollection)
            {
                collectionFault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.UNSUPPORTED_QUERY_PARAMETERS));
                if (FlexGlobals.topLevelApplication is UIComponent)
                {
                    UIComponent(FlexGlobals.topLevelApplication).callLater(this.faultHandler, [collectionFault, asyncToken]);
                }
                else
                {
                    this.faultHandler(collectionFault, asyncToken);
                }
            }
            else
            {
                var myResultFunction:* = function (result:FeatureSet) : void
            {
                selectFeaturesHandler(result, selectionMethod, asyncToken);
                return;
            }// end function
            ;
                var myFaultFunction:* = function (error:Object) : void
            {
                faultHandler(error as Fault, asyncToken);
                return;
            }// end function
            ;
                this._queryTask.execute(query2, new Responder(myResultFunction, myFaultFunction));
            }
            return asyncToken;
        }// end function

        private function selectFeaturesHandler(result:FeatureSet, selectionMethod:String, asyncToken:AsyncToken) : void
        {
            var _loc_4:Boolean = false;
            var _loc_7:Graphic = null;
            var _loc_8:Number = NaN;
            var _loc_9:IResponder = null;
            var _loc_10:FeatureLayerEvent = null;
            var _loc_11:Graphic = null;
            var _loc_12:Graphic = null;
            switch(selectionMethod)
            {
                case SELECTION_NEW:
                {
                    this.clearSelectionInternal(true);
                    _loc_4 = true;
                    break;
                }
                case SELECTION_ADD:
                {
                    _loc_4 = true;
                    break;
                }
                case SELECTION_SUBTRACT:
                {
                    _loc_4 = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_5:Array = [];
            var _loc_6:* = this.objectIdField;
            if (_loc_4)
            {
                for each (_loc_7 in result.features)
                {
                    
                    _loc_8 = _loc_7.attributes[_loc_6];
                    _loc_11 = this.addFeatureIIf(_loc_8, _loc_7);
                    _loc_5.push(_loc_11);
                    this.selectFeatureIIf(_loc_8, _loc_11);
                }
            }
            else
            {
                for each (_loc_7 in result.features)
                {
                    
                    _loc_8 = _loc_7.attributes[_loc_6];
                    this.unSelectFeatureIIf(_loc_8);
                    _loc_12 = this.removeFeatureIIf(_loc_8);
                    if (_loc_12)
                    {
                        _loc_5.push(_loc_12);
                        continue;
                    }
                    _loc_5.push(_loc_7);
                }
            }
            for each (_loc_9 in asyncToken.responders)
            {
                
                _loc_9.result(_loc_5);
            }
            _loc_10 = new FeatureLayerEvent(FeatureLayerEvent.SELECTION_COMPLETE, this);
            _loc_10.features = _loc_5;
            _loc_10.selectionMethod = selectionMethod;
            dispatchEvent(_loc_10);
            return;
        }// end function

        private function applyQueryFilters(query:Query) : Boolean
        {
            var _loc_2:Array = null;
            query.where = this.getAttributeFilter(query.where);
            if (this.isEditable)
            {
            }
            if (!loaded)
            {
                query.maxAllowableOffset = this.maxAllowableOffset;
            }
            if (this.timeInfo)
            {
                _loc_2 = this.getTimeFilter(query.timeExtent);
                if (_loc_2[0])
                {
                    query.timeExtent = _loc_2[1];
                }
                else
                {
                    return false;
                }
            }
            return true;
        }// end function

        private function getAttributeFilter(queryWhere:String) : String
        {
            var _loc_2:* = this.definitionExpression;
            if (queryWhere)
            {
                queryWhere = _loc_2 ? ("(" + _loc_2 + ") AND (" + queryWhere + ")") : (queryWhere);
            }
            else
            {
                queryWhere = _loc_2;
            }
            return queryWhere;
        }// end function

        private function getTimeFilter(queryTime:TimeExtent) : Array
        {
            var _loc_2:TimeExtent = null;
            var _loc_3:* = this.isSnapshot ? (this.timeDefinition) : (null);
            if (_loc_3)
            {
            }
            if (queryTime)
            {
                _loc_2 = _loc_3.intersection(queryTime);
                if (!_loc_2)
                {
                    return [false];
                }
            }
            else
            {
                _loc_2 = queryTime;
            }
            return [true, _loc_2];
        }// end function

        private function canDoClientSideQuery(query:Query) : Array
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:TimeExtent = null;
            var _loc_8:TimeExtent = null;
            var _loc_2:Array = [];
            if (this.isTable)
            {
                return null;
            }
            if (!query.text)
            {
                if (query.where)
                {
                }
            }
            if (query.where === this.definitionExpression)
            {
            }
            if (!query.orderByFields)
            {
            }
            if (query.outStatistics)
            {
                return null;
            }
            if (query.geometry)
            {
                if (map)
                {
                }
                if (!this.isSelOnly)
                {
                }
                if (query.spatialRelationship === Query.SPATIAL_REL_INTERSECTS)
                {
                }
                if (query.geometry is Extent)
                {
                    if (!this.isSnapshot)
                    {
                    }
                    if (!this.isCollection)
                    {
                    }
                }
                if (map.extent.contains(query.geometry))
                {
                    _loc_2.push(1);
                }
                else
                {
                    return null;
                }
            }
            var _loc_3:* = query.objectIds;
            if (_loc_3)
            {
            }
            if (_loc_3.length > 0)
            {
                if (!this.isSnapshot)
                {
                }
                if (this.isCollection)
                {
                    _loc_2.push(2);
                }
                else
                {
                    _loc_4 = _loc_3.length;
                    _loc_5 = 0;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_4)
                    {
                        
                        if (this.getFeature(_loc_3[_loc_6]))
                        {
                            _loc_5 = _loc_5 + 1;
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                    if (_loc_5 === _loc_4)
                    {
                        _loc_2.push(2);
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            if (this.timeInfo)
            {
                _loc_7 = query.timeExtent;
                if (this.map)
                {
                }
                _loc_8 = this.useMapTime ? (this.map.timeExtent) : (null);
                if (!this.isSnapshot)
                {
                }
                if (this.isCollection)
                {
                    if (_loc_7)
                    {
                        _loc_2.push(3);
                    }
                }
                else if (this.isSelOnly)
                {
                    if (_loc_7)
                    {
                        return null;
                    }
                }
                else if (_loc_8)
                {
                    if (_loc_2.indexOf(2) != -1)
                    {
                        _loc_2.push(3);
                    }
                    else
                    {
                        return null;
                    }
                }
                else if (_loc_2.length > 0)
                {
                    if (_loc_7)
                    {
                        _loc_2.push(3);
                    }
                }
                else if (_loc_7)
                {
                    return null;
                }
            }
            return _loc_2.length > 0 ? (_loc_2) : (null);
        }// end function

        private function doQuery(query:Query, queryTypes:Array, returnIdsOnly:Boolean = false) : Array
        {
            var _loc_4:Array = null;
            var _loc_5:Graphic = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:Extent = null;
            var _loc_11:Array = null;
            var _loc_12:String = null;
            if (queryTypes.indexOf(2) != -1)
            {
                _loc_4 = [];
                _loc_7 = query.objectIds;
                _loc_8 = _loc_7.length;
                _loc_9 = 0;
                while (_loc_9 < _loc_8)
                {
                    
                    _loc_5 = this.getFeature(_loc_7[_loc_9]);
                    if (_loc_5)
                    {
                        _loc_4.push(_loc_5);
                    }
                    _loc_9 = _loc_9 + 1;
                }
            }
            else
            {
                _loc_4 = $graphicProvider.toArray();
            }
            if (queryTypes.indexOf(1) != -1)
            {
                _loc_6 = [];
                _loc_10 = Extent(query.geometry);
                for each (_loc_5 in _loc_4)
                {
                    
                    if (_loc_10.intersects(_loc_5.geometry))
                    {
                        _loc_6.push(_loc_5);
                    }
                }
                _loc_4 = _loc_6;
            }
            if (queryTypes.indexOf(3) != -1)
            {
                if (this.timeInfo)
                {
                    _loc_11 = this.filterByTime(_loc_4, query.timeExtent);
                    _loc_4 = _loc_11[0];
                }
            }
            if (returnIdsOnly)
            {
                _loc_6 = [];
                _loc_12 = this.objectIdField;
                for each (_loc_5 in _loc_4)
                {
                    
                    _loc_6.push(_loc_5.attributes[_loc_12]);
                }
                _loc_4 = _loc_6;
            }
            return _loc_4;
        }// end function

        private function filterByTime(features:Array, timeExtent:TimeExtent) : Array
        {
            var _loc_8:Graphic = null;
            var _loc_9:TimeExtent = null;
            var _loc_10:Object = null;
            var _loc_11:Object = null;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Date = null;
            var _loc_15:Date = null;
            var _loc_16:String = null;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_3:Array = [];
            var _loc_4:Array = [];
            var _loc_5:* = this.startTimeField;
            var _loc_6:* = this.endTimeField;
            if (_loc_5)
            {
            }
            var _loc_7:* = _loc_6;
            if (_loc_7)
            {
                _loc_9 = new TimeExtent();
                _loc_14 = new Date();
                _loc_15 = new Date();
                for each (_loc_8 in features)
                {
                    
                    _loc_10 = _loc_8.attributes[_loc_5];
                    _loc_11 = _loc_8.attributes[_loc_6];
                    _loc_12 = _loc_10 ? (Number(_loc_10)) : (NaN);
                    _loc_13 = _loc_11 ? (Number(_loc_11)) : (NaN);
                    if (isNaN(_loc_12))
                    {
                        _loc_9.startTime = null;
                    }
                    else
                    {
                        _loc_14.time = _loc_12;
                        _loc_9.startTime = _loc_14;
                    }
                    if (isNaN(_loc_13))
                    {
                        _loc_9.endTime = null;
                    }
                    else
                    {
                        _loc_15.time = _loc_13;
                        _loc_9.endTime = _loc_15;
                    }
                    if (timeExtent.intersects(_loc_9))
                    {
                        _loc_3.push(_loc_8);
                        continue;
                    }
                    _loc_4.push(_loc_8);
                }
            }
            else
            {
                if (!_loc_5)
                {
                }
                _loc_16 = _loc_6;
                _loc_17 = timeExtent.startTime ? (timeExtent.startTime.time) : (-Infinity);
                _loc_18 = timeExtent.endTime ? (timeExtent.endTime.time) : (Infinity);
                for each (_loc_8 in features)
                {
                    
                    _loc_19 = Number(_loc_8.attributes[_loc_16]);
                    if (_loc_19 >= _loc_17)
                    {
                    }
                    if (_loc_19 <= _loc_18)
                    {
                        _loc_3.push(_loc_8);
                        continue;
                    }
                    _loc_4.push(_loc_8);
                }
            }
            return [_loc_3, _loc_4];
        }// end function

        private function updateQueryTask() : void
        {
            this._queryTask.disableClientCaching = this.disableClientCaching;
            this._queryTask.gdbVersion = this.gdbVersion;
            this._queryTask.proxyURL = this.proxyURL;
            this._queryTask.requestTimeout = this.requestTimeout;
            this._queryTask.token = this.token;
            this._queryTask.url = this.url;
            if (!this._queryTask.source)
            {
            }
            if (this.source)
            {
                this._queryTask.source = this.source;
            }
            if (this._useAMFSet)
            {
                this._queryTask.useAMF = this.useAMF;
            }
            else if (this.supportedQueryFormats)
            {
                this._queryTask.useAMF = this.supportedQueryFormats.indexOf("AMF") >= 0;
            }
            else if (this._layerDetails)
            {
                this._queryTask.useAMF = this._layerDetails.serverVersionIs10plus;
            }
            else if (this._tableDetails)
            {
                this._queryTask.useAMF = this._tableDetails.serverVersionIs10plus;
            }
            return;
        }// end function

        public function queryAttachmentInfos(objectId:Number, responder:IResponder = null) : AsyncToken
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var objectId:* = objectId;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new AttachmentEvent(AttachmentEvent.QUERY_ATTACHMENT_INFOS_COMPLETE, thisLayer);
                _loc_2.attachmentInfos = result as Array;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            this.updateFLTask();
            thisLayer;
            var asyncToken:* = this._featureLayerTask.queryAttachmentInfos(objectId, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function addAttachment(objectId:Number, data:ByteArray, name:String, contentType:String = null, responder:IResponder = null) : AsyncToken
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var objectId:* = objectId;
            var data:* = data;
            var name:* = name;
            var contentType:* = contentType;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new AttachmentEvent(AttachmentEvent.ADD_ATTACHMENT_COMPLETE, thisLayer);
                _loc_2.featureEditResult = result as FeatureEditResult;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            this.updateFLTask();
            thisLayer;
            var asyncToken:* = this._featureLayerTask.addAttachment(objectId, data, name, contentType, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function updateAttachment(objectId:Number, attachmentId:Number, data:ByteArray, name:String, contentType:String = null, responder:IResponder = null) : AsyncToken
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var objectId:* = objectId;
            var attachmentId:* = attachmentId;
            var data:* = data;
            var name:* = name;
            var contentType:* = contentType;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new AttachmentEvent(AttachmentEvent.UPDATE_ATTACHMENT_COMPLETE, thisLayer);
                _loc_2.featureEditResult = result as FeatureEditResult;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            this.updateFLTask();
            thisLayer;
            var asyncToken:* = this._featureLayerTask.updateAttachment(objectId, attachmentId, data, name, contentType, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        public function deleteAttachments(objectId:Number, attachmentIds:Array, rollbackOnFailure:Boolean = false, responder:IResponder = null) : AsyncToken
        {
            var thisLayer:FeatureLayer;
            var myResultFunction:Function;
            var myFaultFunction:Function;
            var objectId:* = objectId;
            var attachmentIds:* = attachmentIds;
            var rollbackOnFailure:* = rollbackOnFailure;
            var responder:* = responder;
            myResultFunction = function (result:Object) : void
            {
                var _loc_2:* = new AttachmentEvent(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE, thisLayer);
                _loc_2.featureEditResults = result as Array;
                dispatchEvent(_loc_2);
                return;
            }// end function
            ;
            myFaultFunction = function (error:Object) : void
            {
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, error as Fault));
                return;
            }// end function
            ;
            this.updateFLTask();
            thisLayer;
            var asyncToken:* = this._featureLayerTask.deleteAttachments(objectId, attachmentIds, rollbackOnFailure, responder);
            asyncToken.addResponder(new Responder(myResultFunction, myFaultFunction));
            return asyncToken;
        }// end function

        private function updateFLTask() : void
        {
            this._featureLayerTask.disableClientCaching = this.disableClientCaching;
            this._featureLayerTask.gdbVersion = this.gdbVersion;
            this._featureLayerTask.proxyURL = this.proxyURL;
            this._featureLayerTask.requestTimeout = this.requestTimeout;
            this._featureLayerTask.token = this.token;
            this._featureLayerTask.url = this.url;
            return;
        }// end function

        public function isDeleteAllowed(graphic:Graphic) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (this.isCollection)
            {
                _loc_2 = true;
            }
            else if (this.capabilities)
            {
                if (this.version < 10.1)
                {
                }
                if (this.isEditable)
                {
                    _loc_2 = true;
                }
                else if (this.capabilities.indexOf("Delete") != -1)
                {
                    _loc_2 = true;
                    if (this.editFieldsInfo)
                    {
                    }
                    if (this.ownershipBasedAccessControlForFeatures)
                    {
                        _loc_3 = graphic.attributes[this.editFieldsInfo.creatorField];
                        if (_loc_3 != null)
                        {
                            if (_loc_3 != "anonymous")
                            {
                            }
                            if (_loc_3 != "")
                            {
                                if (this.userId)
                                {
                                    _loc_4 = this.editFieldsInfo.realm ? (this.userId + "@" + this.editFieldsInfo.realm) : (this.userId);
                                    if (!this.ownershipBasedAccessControlForFeatures.allowOthersToDelete)
                                    {
                                    }
                                    if (_loc_4.toLowerCase() != _loc_3.toLowerCase())
                                    {
                                        _loc_2 = false;
                                    }
                                }
                                else
                                {
                                    _loc_2 = this.ownershipBasedAccessControlForFeatures.allowOthersToDelete;
                                }
                            }
                        }
                        else
                        {
                            _loc_2 = this.ownershipBasedAccessControlForFeatures.allowOthersToDelete;
                        }
                    }
                }
            }
            return _loc_2;
        }// end function

        public function isUpdateAllowed(graphic:Graphic) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (this.isCollection)
            {
                _loc_2 = true;
            }
            else if (this.capabilities)
            {
                if (this.version < 10.1)
                {
                }
                if (this.isEditable)
                {
                    _loc_2 = true;
                }
                else if (this.capabilities.indexOf("Update") != -1)
                {
                    _loc_2 = true;
                    if (this.editFieldsInfo)
                    {
                    }
                    if (this.ownershipBasedAccessControlForFeatures)
                    {
                        _loc_3 = graphic.attributes[this.editFieldsInfo.creatorField];
                        if (_loc_3 != null)
                        {
                            if (_loc_3 != "anonymous")
                            {
                            }
                            if (_loc_3 != "")
                            {
                                if (this.userId)
                                {
                                    _loc_4 = this.editFieldsInfo.realm ? (this.userId + "@" + this.editFieldsInfo.realm) : (this.userId);
                                    if (!this.ownershipBasedAccessControlForFeatures.allowOthersToUpdate)
                                    {
                                    }
                                    if (_loc_4.toLowerCase() != _loc_3.toLowerCase())
                                    {
                                        _loc_2 = false;
                                    }
                                }
                                else
                                {
                                    _loc_2 = this.ownershipBasedAccessControlForFeatures.allowOthersToUpdate;
                                }
                            }
                        }
                        else
                        {
                            _loc_2 = this.ownershipBasedAccessControlForFeatures.allowOthersToUpdate;
                        }
                    }
                }
            }
            return _loc_2;
        }// end function

        public function getEditSummary(graphic:Graphic) : String
        {
            var _loc_3:Object = null;
            var _loc_2:String = "";
            if (this.loaded)
            {
                _loc_3 = this.getEditInfo(graphic);
                if (_loc_3)
                {
                    if (_loc_3.user != "")
                    {
                    }
                    if (_loc_3.user != "anonymous")
                    {
                    }
                    if (_loc_3.user != null)
                    {
                        if (_loc_3.displayPattern)
                        {
                            _loc_2 = _loc_3.action == "create" ? (this.getCreateStringBasedOnDisplayPattern(_loc_3, true)) : (this.getEditStringBasedOnDisplayPattern(_loc_3, true));
                        }
                        else
                        {
                            _loc_2 = _loc_3.action == "create" ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUser"), _loc_3.user)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUser"), _loc_3.user));
                        }
                    }
                    else if (_loc_3.displayPattern)
                    {
                        _loc_2 = _loc_3.action == "create" ? (this.getCreateStringBasedOnDisplayPattern(_loc_3, false)) : (this.getEditStringBasedOnDisplayPattern(_loc_3, false));
                    }
                }
            }
            return _loc_2;
        }// end function

        private function getEditInfo(graphic:Graphic) : Object
        {
            var _loc_2:Object = null;
            var _loc_5:String = null;
            var _loc_6:Number = NaN;
            var _loc_7:String = null;
            var _loc_8:Number = NaN;
            var _loc_3:* = new Date().getTime();
            var _loc_4:* = this.editFieldsInfo;
            if (_loc_4)
            {
                if (!_loc_4.editorField)
                {
                }
                if (_loc_4.editDateField)
                {
                    _loc_7 = graphic.attributes[_loc_4.editorField];
                    _loc_8 = graphic.attributes[_loc_4.editDateField];
                    if (!_loc_7)
                    {
                    }
                    if (_loc_8)
                    {
                        _loc_2 = this.getEditOrCreateData(_loc_7, _loc_8, _loc_3);
                        _loc_2.action = "edit";
                    }
                    else
                    {
                        if (!_loc_4.creatorField)
                        {
                        }
                        if (_loc_4.creationDateField)
                        {
                            _loc_5 = graphic.attributes[_loc_4.creatorField];
                            _loc_6 = graphic.attributes[_loc_4.creationDateField];
                            if (!_loc_5)
                            {
                            }
                            if (_loc_6)
                            {
                                _loc_2 = this.getEditOrCreateData(_loc_5, _loc_6, _loc_3);
                                _loc_2.action = "create";
                            }
                        }
                    }
                }
                else
                {
                    if (!_loc_4.creatorField)
                    {
                    }
                    if (_loc_4.creationDateField)
                    {
                        _loc_5 = graphic.attributes[_loc_4.creatorField];
                        _loc_6 = graphic.attributes[_loc_4.creationDateField];
                        if (!_loc_5)
                        {
                        }
                        if (_loc_6)
                        {
                            _loc_2 = this.getEditOrCreateData(_loc_5, _loc_6, _loc_3);
                            _loc_2.action = "create";
                        }
                    }
                }
            }
            return _loc_2;
        }// end function

        private function getEditOrCreateData(user:String, timeValue:Number, currentTime:Number) : Object
        {
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            var _loc_7:Date = null;
            var _loc_8:DateFormatter = null;
            var _loc_9:DateFormatter = null;
            var _loc_4:Object = {};
            if (timeValue)
            {
                _loc_5 = currentTime - timeValue;
                if (_loc_5 < 0)
                {
                    _loc_6 = "Full";
                }
                else if (_loc_5 < 60000)
                {
                    _loc_6 = "Seconds";
                }
                else if (_loc_5 < 2 * 60000)
                {
                    _loc_6 = "Minute";
                }
                else if (_loc_5 < 3600000)
                {
                    _loc_6 = "Minutes";
                }
                else if (_loc_5 < 2 * 3600000)
                {
                    _loc_6 = "Hour";
                }
                else if (_loc_5 < 24 * 3600000)
                {
                    _loc_6 = "Hours";
                }
                else if (_loc_5 < 7 * 24 * 3600000)
                {
                    _loc_6 = "Weekday";
                }
                else
                {
                    _loc_6 = "Full";
                }
            }
            _loc_4.user = user;
            if (_loc_6)
            {
                _loc_7 = new Date(timeValue);
                _loc_8 = new DateFormatter();
                _loc_8.formatString = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "dateFormat_shortDate");
                _loc_9 = new DateFormatter();
                _loc_9.formatString = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "dateFormat_shortTime");
                _loc_4.minutes = Math.floor(_loc_5 / 60000);
                _loc_4.hours = Math.floor(_loc_5 / 3600000);
                _loc_4.weekday = this.getWeekday(_loc_7.day);
                _loc_4.formattedDate = _loc_8.format(_loc_7);
                _loc_4.formattedTime = _loc_9.format(_loc_7);
                _loc_4.displayPattern = _loc_6;
                _loc_4.timeValue = timeValue;
            }
            return _loc_4;
        }// end function

        private function getWeekday(dayNumber:Number) : String
        {
            var _loc_2:String = null;
            switch(dayNumber)
            {
                case 0:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Sunday");
                    break;
                }
                case 1:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Monday");
                    break;
                }
                case 2:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Tuesday");
                    break;
                }
                case 3:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Wednesday");
                    break;
                }
                case 4:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Thursday");
                    break;
                }
                case 5:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Friday");
                    break;
                }
                case 6:
                {
                    _loc_2 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "weekday_Saturday");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function getCreateStringBasedOnDisplayPattern(editInfo:Object, isUser:Boolean) : String
        {
            var _loc_3:String = null;
            switch(editInfo.displayPattern)
            {
                case "Seconds":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserSeconds"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createSeconds"));
                    break;
                }
                case "Minute":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserMinute"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createMinute"));
                    break;
                }
                case "Minutes":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserMinutes"), editInfo.user, editInfo.minutes)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createMinutes"), editInfo.minutes));
                    break;
                }
                case "Hour":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserHour"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createHour"));
                    break;
                }
                case "Hours":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserHours"), editInfo.user, editInfo.hours)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createHours"), editInfo.hours));
                    break;
                }
                case "Weekday":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "."), editInfo.user, editInfo.weekday, editInfo.formattedTime)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createWeekDay"), editInfo.weekday, editInfo.formattedTime));
                    break;
                }
                case "Full":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createUserFull"), editInfo.user, editInfo.formattedDate, editInfo.formattedTime)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "createFull"), editInfo.formattedDate, editInfo.formattedTime));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_3;
        }// end function

        private function getEditStringBasedOnDisplayPattern(editInfo:Object, isUser:Boolean) : String
        {
            var _loc_3:String = null;
            switch(editInfo.displayPattern)
            {
                case "Seconds":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserSeconds"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editSeconds"));
                    break;
                }
                case "Minute":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserMinute"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editMinute"));
                    break;
                }
                case "Minutes":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserMinutes"), editInfo.user, editInfo.minutes)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editMinute"), editInfo.minutes));
                    break;
                }
                case "Hour":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserHour"), editInfo.user)) : (resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editHour"));
                    break;
                }
                case "Hours":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserHours"), editInfo.user, editInfo.hours)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editHours"), editInfo.hours));
                    break;
                }
                case "Weekday":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserWeekDay"), editInfo.user, editInfo.weekday, editInfo.formattedTime)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editWeekDay"), editInfo.weekday, editInfo.formattedTime));
                    break;
                }
                case "Full":
                {
                    _loc_3 = isUser ? (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editUserFull"), editInfo.user, editInfo.formattedDate, editInfo.formattedTime)) : (StringUtil.substitute(resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "editFull"), editInfo.formattedDate, editInfo.formattedTime));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_3;
        }// end function

        override protected function creationCompleteHandler(event:FlexEvent) : void
        {
            return;
        }// end function

        private function map_timeExtentChangeHandler(event:TimeExtentEvent) : void
        {
            if (this.useMapTime)
            {
            }
            if (this.timeInfo)
            {
                this._mapTimeExtentChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function enterFrameHandlerFirst(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandlerFirst);
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandlerSecond);
            return;
        }// end function

        private function enterFrameHandlerSecond(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandlerSecond);
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
            return;
        }// end function

        public function set proxyURL(value:String) : void
        {
            arguments = this.proxyURL;
            if (arguments !== value)
            {
                this._985186271proxyURL = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "proxyURL", arguments, value));
                }
            }
            return;
        }// end function

        public function set requestTimeout(value:int) : void
        {
            arguments = this.requestTimeout;
            if (arguments !== value)
            {
                this._1124910034requestTimeout = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "requestTimeout", arguments, value));
                }
            }
            return;
        }// end function

        public function set token(value:String) : void
        {
            arguments = this.token;
            if (arguments !== value)
            {
                this._110541305token = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "token", arguments, value));
                }
            }
            return;
        }// end function

        public function set disableClientCaching(value:Boolean) : void
        {
            arguments = this.disableClientCaching;
            if (arguments !== value)
            {
                this._2076627820disableClientCaching = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "disableClientCaching", arguments, value));
                }
            }
            return;
        }// end function

        public function set useMapTime(value:Boolean) : void
        {
            arguments = this.useMapTime;
            if (arguments !== value)
            {
                this._784516414useMapTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "useMapTime", arguments, value));
                }
            }
            return;
        }// end function

        public function set onDemandCacheSize(value:uint) : void
        {
            arguments = this.onDemandCacheSize;
            if (arguments !== value)
            {
                this._379477177onDemandCacheSize = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "onDemandCacheSize", arguments, value));
                }
            }
            return;
        }// end function

        public function set outFields(value:Array) : void
        {
            arguments = this.outFields;
            if (arguments !== value)
            {
                this._961734567outFields = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outFields", arguments, value));
                }
            }
            return;
        }// end function

        public function set mode(value:String) : void
        {
            arguments = this.mode;
            if (arguments !== value)
            {
                this._3357091mode = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mode", arguments, value));
                }
            }
            return;
        }// end function

    }
}
