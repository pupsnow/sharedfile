package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class MapServiceInfo extends Object implements IEventDispatcher
    {
        private var _1487597642capabilities:Array;
        private var _806358636copyrightText:String;
        private var _1724546052description:String;
        private var _1473534871documentInfo:Object;
        private var _1274708295fields:Array;
        private var _1187420519fullExtent:Extent;
        private var _1584182457hasVersionedData:Boolean;
        private var _549748850initialExtent:Extent;
        private var _1109732030layers:Array;
        private var _836535815mapName:String;
        private var _137366946maxImageHeight:int;
        private var _1672104367maxImageWidth:int;
        private var _692225222maxRecordCount:Number;
        private var _396505670maxScale:Number;
        private var _1379690984minScale:Number;
        private var _453144057serviceDescription:String;
        private var _1787285089singleFusedMapCache:Boolean;
        private var _784017063spatialReference:SpatialReference;
        private var _1532600893supportsDynamicLayers:Boolean;
        private var _881377691tables:Array;
        private var _2106317700tileInfo:TileInfo;
        private var _2077688549timeInfo:TimeInfo;
        private var _111433583units:String;
        private var version:Number;
        var rawObj:Object;
        private var _bindingEventDispatcher:EventDispatcher;

        public function MapServiceInfo()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            return;
        }// end function

        public function get imageServiceVersion() : Number
        {
            if (isNaN(this.version))
            {
                if (!("fields" in this.rawObj))
                {
                }
                if (!("objectIdField" in this.rawObj))
                {
                }
                if ("timeInfo" in this.rawObj)
                {
                    this.version = 10;
                }
                else
                {
                    this.version = 9.3;
                }
            }
            return this.version;
        }// end function

        public function get mapServiceVersion() : Number
        {
            if (isNaN(this.version))
            {
                if (!("capabilities" in this.rawObj))
                {
                }
                if ("tables" in this.rawObj)
                {
                    this.version = 10;
                }
                else if ("supportedImageFormatTypes" in this.rawObj)
                {
                    this.version = 9.31;
                }
                else
                {
                    this.version = 9.3;
                }
            }
            return this.version;
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
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

        public function get copyrightText() : String
        {
            return this._806358636copyrightText;
        }// end function

        public function set copyrightText(value:String) : void
        {
            arguments = this._806358636copyrightText;
            if (arguments !== value)
            {
                this._806358636copyrightText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "copyrightText", arguments, value));
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

        public function get documentInfo() : Object
        {
            return this._1473534871documentInfo;
        }// end function

        public function set documentInfo(value:Object) : void
        {
            arguments = this._1473534871documentInfo;
            if (arguments !== value)
            {
                this._1473534871documentInfo = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "documentInfo", arguments, value));
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

        public function get fullExtent() : Extent
        {
            return this._1187420519fullExtent;
        }// end function

        public function set fullExtent(value:Extent) : void
        {
            arguments = this._1187420519fullExtent;
            if (arguments !== value)
            {
                this._1187420519fullExtent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fullExtent", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasVersionedData() : Boolean
        {
            return this._1584182457hasVersionedData;
        }// end function

        public function set hasVersionedData(value:Boolean) : void
        {
            arguments = this._1584182457hasVersionedData;
            if (arguments !== value)
            {
                this._1584182457hasVersionedData = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasVersionedData", arguments, value));
                }
            }
            return;
        }// end function

        public function get initialExtent() : Extent
        {
            return this._549748850initialExtent;
        }// end function

        public function set initialExtent(value:Extent) : void
        {
            arguments = this._549748850initialExtent;
            if (arguments !== value)
            {
                this._549748850initialExtent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "initialExtent", arguments, value));
                }
            }
            return;
        }// end function

        public function get layers() : Array
        {
            return this._1109732030layers;
        }// end function

        public function set layers(value:Array) : void
        {
            arguments = this._1109732030layers;
            if (arguments !== value)
            {
                this._1109732030layers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layers", arguments, value));
                }
            }
            return;
        }// end function

        public function get mapName() : String
        {
            return this._836535815mapName;
        }// end function

        public function set mapName(value:String) : void
        {
            arguments = this._836535815mapName;
            if (arguments !== value)
            {
                this._836535815mapName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mapName", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxImageHeight() : int
        {
            return this._137366946maxImageHeight;
        }// end function

        public function set maxImageHeight(value:int) : void
        {
            arguments = this._137366946maxImageHeight;
            if (arguments !== value)
            {
                this._137366946maxImageHeight = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxImageHeight", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxImageWidth() : int
        {
            return this._1672104367maxImageWidth;
        }// end function

        public function set maxImageWidth(value:int) : void
        {
            arguments = this._1672104367maxImageWidth;
            if (arguments !== value)
            {
                this._1672104367maxImageWidth = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxImageWidth", arguments, value));
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

        public function get serviceDescription() : String
        {
            return this._453144057serviceDescription;
        }// end function

        public function set serviceDescription(value:String) : void
        {
            arguments = this._453144057serviceDescription;
            if (arguments !== value)
            {
                this._453144057serviceDescription = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "serviceDescription", arguments, value));
                }
            }
            return;
        }// end function

        public function get singleFusedMapCache() : Boolean
        {
            return this._1787285089singleFusedMapCache;
        }// end function

        public function set singleFusedMapCache(value:Boolean) : void
        {
            arguments = this._1787285089singleFusedMapCache;
            if (arguments !== value)
            {
                this._1787285089singleFusedMapCache = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "singleFusedMapCache", arguments, value));
                }
            }
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this._784017063spatialReference;
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            arguments = this._784017063spatialReference;
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

        public function get supportsDynamicLayers() : Boolean
        {
            return this._1532600893supportsDynamicLayers;
        }// end function

        public function set supportsDynamicLayers(value:Boolean) : void
        {
            arguments = this._1532600893supportsDynamicLayers;
            if (arguments !== value)
            {
                this._1532600893supportsDynamicLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "supportsDynamicLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function get tables() : Array
        {
            return this._881377691tables;
        }// end function

        public function set tables(value:Array) : void
        {
            arguments = this._881377691tables;
            if (arguments !== value)
            {
                this._881377691tables = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tables", arguments, value));
                }
            }
            return;
        }// end function

        public function get tileInfo() : TileInfo
        {
            return this._2106317700tileInfo;
        }// end function

        public function set tileInfo(value:TileInfo) : void
        {
            arguments = this._2106317700tileInfo;
            if (arguments !== value)
            {
                this._2106317700tileInfo = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tileInfo", arguments, value));
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

        public function get units() : String
        {
            return this._111433583units;
        }// end function

        public function set units(value:String) : void
        {
            arguments = this._111433583units;
            if (arguments !== value)
            {
                this._111433583units = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "units", arguments, value));
                }
            }
            return;
        }// end function

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false) : void
        {
            this._bindingEventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._bindingEventDispatcher.dispatchEvent(event);
        }// end function

        public function hasEventListener(type:String) : Boolean
        {
            return this._bindingEventDispatcher.hasEventListener(type);
        }// end function

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
        {
            this._bindingEventDispatcher.removeEventListener(type, listener, useCapture);
            return;
        }// end function

        public function willTrigger(type:String) : Boolean
        {
            return this._bindingEventDispatcher.willTrigger(type);
        }// end function

        static function toMapServiceInfo(obj:Object) : MapServiceInfo
        {
            var _loc_2:MapServiceInfo = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            if (obj)
            {
                _loc_2 = new MapServiceInfo;
                _loc_2.rawObj = obj;
                if (obj.capabilities)
                {
                    _loc_2.capabilities = String(obj.capabilities).split(",");
                }
                _loc_2.copyrightText = obj.copyrightText;
                _loc_2.description = obj.description;
                _loc_2.documentInfo = obj.documentInfo;
                if (obj.fields)
                {
                    _loc_2.fields = [];
                    for each (_loc_3 in obj.fields)
                    {
                        
                        _loc_2.fields.push(Field.toField(_loc_3));
                    }
                }
                _loc_2.fullExtent = Extent.fromJSON(obj.fullExtent);
                _loc_2.hasVersionedData = obj.hasVersionedData;
                _loc_2.initialExtent = Extent.fromJSON(obj.initialExtent);
                if (obj.layers)
                {
                    _loc_2.layers = [];
                    for each (_loc_4 in obj.layers)
                    {
                        
                        _loc_2.layers.push(LayerInfo.toLayerInfo(_loc_4));
                    }
                }
                _loc_2.mapName = obj.mapName;
                _loc_2.maxImageHeight = obj.maxImageHeight;
                _loc_2.maxImageWidth = obj.maxImageWidth;
                _loc_2.maxRecordCount = obj.maxRecordCount;
                _loc_2.maxScale = obj.maxScale > 0 ? (obj.maxScale) : (0);
                _loc_2.minScale = obj.minScale > 0 ? (obj.minScale) : (0);
                _loc_2.serviceDescription = obj.serviceDescription;
                _loc_2.singleFusedMapCache = obj.singleFusedMapCache;
                _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
                _loc_2.supportsDynamicLayers = obj.supportsDynamicLayers;
                if (obj.tables)
                {
                    _loc_2.tables = [];
                    for each (_loc_5 in obj.tables)
                    {
                        
                        _loc_2.tables.push(TableInfo.toTableInfo(_loc_5));
                    }
                }
                _loc_2.tileInfo = TileInfo.toTileInfo(obj.tileInfo);
                _loc_2.timeInfo = TimeInfo.toTimeInfo(obj.timeInfo);
                _loc_2.units = obj.units;
                _loc_2.version = parseFloat(obj.currentVersion);
            }
            return _loc_2;
        }// end function

    }
}
