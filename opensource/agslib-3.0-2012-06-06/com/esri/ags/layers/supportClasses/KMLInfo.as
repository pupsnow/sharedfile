package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import mx.utils.*;

    public class KMLInfo extends Object implements IEventDispatcher
    {
        private var _1188704303featureInfos:Array;
        private var _683249211folders:Array;
        private var _522081470polygonFeatureLayers:Array;
        private var _1397935624polylineFeatureLayers:Array;
        private var _999297064pointFeatureLayers:Array;
        private var _2128219338groundOverlays:Array;
        private var _410205871screenOverlays:Array;
        private var _37342677networkLinks:Array;
        private var _bindingEventDispatcher:EventDispatcher;

        public function KMLInfo()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            return;
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get featureInfos() : Array
        {
            return this._1188704303featureInfos;
        }// end function

        public function set featureInfos(value:Array) : void
        {
            arguments = this._1188704303featureInfos;
            if (arguments !== value)
            {
                this._1188704303featureInfos = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "featureInfos", arguments, value));
                }
            }
            return;
        }// end function

        public function get folders() : Array
        {
            return this._683249211folders;
        }// end function

        public function set folders(value:Array) : void
        {
            arguments = this._683249211folders;
            if (arguments !== value)
            {
                this._683249211folders = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "folders", arguments, value));
                }
            }
            return;
        }// end function

        public function get polygonFeatureLayers() : Array
        {
            return this._522081470polygonFeatureLayers;
        }// end function

        public function set polygonFeatureLayers(value:Array) : void
        {
            arguments = this._522081470polygonFeatureLayers;
            if (arguments !== value)
            {
                this._522081470polygonFeatureLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "polygonFeatureLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function get polylineFeatureLayers() : Array
        {
            return this._1397935624polylineFeatureLayers;
        }// end function

        public function set polylineFeatureLayers(value:Array) : void
        {
            arguments = this._1397935624polylineFeatureLayers;
            if (arguments !== value)
            {
                this._1397935624polylineFeatureLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "polylineFeatureLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function get pointFeatureLayers() : Array
        {
            return this._999297064pointFeatureLayers;
        }// end function

        public function set pointFeatureLayers(value:Array) : void
        {
            arguments = this._999297064pointFeatureLayers;
            if (arguments !== value)
            {
                this._999297064pointFeatureLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pointFeatureLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function get groundOverlays() : Array
        {
            return this._2128219338groundOverlays;
        }// end function

        public function set groundOverlays(value:Array) : void
        {
            arguments = this._2128219338groundOverlays;
            if (arguments !== value)
            {
                this._2128219338groundOverlays = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "groundOverlays", arguments, value));
                }
            }
            return;
        }// end function

        public function get screenOverlays() : Array
        {
            return this._410205871screenOverlays;
        }// end function

        public function set screenOverlays(value:Array) : void
        {
            arguments = this._410205871screenOverlays;
            if (arguments !== value)
            {
                this._410205871screenOverlays = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "screenOverlays", arguments, value));
                }
            }
            return;
        }// end function

        public function get networkLinks() : Array
        {
            return this._37342677networkLinks;
        }// end function

        public function set networkLinks(value:Array) : void
        {
            arguments = this._37342677networkLinks;
            if (arguments !== value)
            {
                this._37342677networkLinks = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "networkLinks", arguments, value));
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

        static function toKMLInfo(obj:Object) : KMLInfo
        {
            var _loc_2:KMLInfo = null;
            var _loc_3:Object = null;
            var _loc_4:Boolean = false;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Object = null;
            var _loc_8:KMLFeatureInfo = null;
            var _loc_9:Object = null;
            var _loc_10:FeatureSet = null;
            var _loc_11:FeatureLayer = null;
            var _loc_12:Graphic = null;
            var _loc_13:LayerDetails = null;
            var _loc_14:Array = null;
            var _loc_15:int = 0;
            var _loc_16:SimpleRenderer = null;
            var _loc_17:SimpleRenderer = null;
            var _loc_18:SimpleRenderer = null;
            var _loc_19:Object = null;
            var _loc_20:Object = null;
            var _loc_21:Object = null;
            var _loc_22:KMLLayer = null;
            if (obj)
            {
                _loc_2 = new KMLInfo;
                if (obj.featureInfos)
                {
                    _loc_2.featureInfos = [];
                    for each (_loc_3 in obj.featureInfos)
                    {
                        
                        _loc_2.featureInfos.push(KMLFeatureInfo.toKMLFeatureInfo(_loc_3));
                    }
                }
                if (obj.folders)
                {
                    _loc_2.folders = [];
                    _loc_4 = true;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_2.featureInfos.length)
                    {
                        
                        _loc_8 = _loc_2.featureInfos[_loc_5];
                        if (_loc_8.type != KMLFeatureInfo.POINT)
                        {
                        }
                        if (_loc_8.type != KMLFeatureInfo.LINE)
                        {
                        }
                        if (_loc_8.type != KMLFeatureInfo.POLYGON)
                        {
                        }
                        if (_loc_8.type != KMLFeatureInfo.GROUND_OVERLAY)
                        {
                        }
                        if (_loc_8.type == KMLFeatureInfo.SCREEN_OVERLAY)
                        {
                            _loc_4 = false;
                            break;
                            continue;
                        }
                        _loc_5 = _loc_5 + 1;
                    }
                    _loc_6 = obj.folders[0].id;
                    for each (_loc_7 in obj.folders)
                    {
                        
                        if (_loc_4)
                        {
                            if (_loc_7.parentFolderId != -1)
                            {
                                if (_loc_7.parentFolderId == _loc_6)
                                {
                                    _loc_7.parentFolderId = -1;
                                }
                                _loc_2.folders.push(KMLFolder.toKMLFolder(_loc_7));
                            }
                            continue;
                        }
                        _loc_2.folders.push(KMLFolder.toKMLFolder(_loc_7));
                    }
                }
                if (obj.featureCollection)
                {
                    _loc_2.polygonFeatureLayers = [];
                    _loc_2.polylineFeatureLayers = [];
                    _loc_2.pointFeatureLayers = [];
                    for each (_loc_9 in obj.featureCollection.layers)
                    {
                        
                        _loc_10 = FeatureSet.fromJSON(_loc_9.featureSet);
                        if (_loc_10.features.length > 0)
                        {
                            _loc_11 = new FeatureLayer();
                            _loc_11.id = NameUtil.createUniqueName(_loc_11);
                            for each (_loc_12 in _loc_10.features)
                            {
                                
                                if (_loc_12.attributes.description)
                                {
                                }
                                if (_loc_12.attributes.description.indexOf("\n") != -1)
                                {
                                    _loc_14 = _loc_12.attributes.description.split("\n");
                                    _loc_15 = 0;
                                    while (_loc_15 < _loc_14.length)
                                    {
                                        
                                        _loc_14[_loc_15] = StringUtil.trim(String(_loc_14[_loc_15]));
                                        _loc_15 = _loc_15 + 1;
                                    }
                                    _loc_12.attributes.description = _loc_14.join(" ");
                                }
                            }
                            _loc_13 = LayerDetails.toLayerDetails(_loc_9.layerDefinition);
                            if (_loc_13.name)
                            {
                                var _loc_25:* = _loc_13.name;
                                _loc_11.name = _loc_13.name;
                                _loc_11.id = _loc_25;
                            }
                            _loc_11.renderer = _loc_13.drawingInfo.renderer;
                            _loc_11.initialExtent = _loc_13.extent;
                            _loc_11.featureCollection = new FeatureCollection(_loc_10, _loc_13);
                            _loc_11.infoWindowRenderer = createInfoWindowRenderer(_loc_9.popupInfo);
                            switch(_loc_10.geometryType)
                            {
                                case Geometry.POLYGON:
                                {
                                    if (!_loc_11.renderer)
                                    {
                                        _loc_16 = new SimpleRenderer();
                                        _loc_16.symbol = new SimpleFillSymbol();
                                        _loc_11.renderer = _loc_16;
                                    }
                                    _loc_2.polygonFeatureLayers.push(_loc_11);
                                    break;
                                }
                                case Geometry.POLYLINE:
                                {
                                    if (!_loc_11.renderer)
                                    {
                                        _loc_17 = new SimpleRenderer();
                                        _loc_17.symbol = new SimpleLineSymbol();
                                        _loc_11.renderer = _loc_17;
                                    }
                                    _loc_2.polylineFeatureLayers.push(_loc_11);
                                    break;
                                }
                                case Geometry.MAPPOINT:
                                {
                                    if (!_loc_11.renderer)
                                    {
                                        _loc_18 = new SimpleRenderer();
                                        _loc_18.symbol = new SimpleMarkerSymbol();
                                        _loc_11.renderer = _loc_18;
                                    }
                                    _loc_2.pointFeatureLayers.push(_loc_11);
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                        }
                    }
                }
                if (obj.groundOverlays)
                {
                    _loc_2.groundOverlays = [];
                    for each (_loc_19 in obj.groundOverlays)
                    {
                        
                        _loc_2.groundOverlays.push(KMLGroundOverlay.toKMLGroundOverlay(_loc_19));
                    }
                }
                if (obj.screenOverlays)
                {
                    _loc_2.screenOverlays = [];
                    for each (_loc_20 in obj.screenOverlays)
                    {
                        
                        _loc_2.screenOverlays.push(KMLScreenOverlay.toKMLScreenOverlay(_loc_20));
                    }
                }
                if (obj.networkLinks)
                {
                    _loc_2.networkLinks = [];
                    for each (_loc_21 in obj.networkLinks)
                    {
                        
                        _loc_22 = new KMLLayer();
                        _loc_22.id = String(_loc_21.id);
                        _loc_22.name = _loc_21.name;
                        _loc_22.description = _loc_21.description;
                        _loc_22.snippet = _loc_21.snippet;
                        _loc_22.visible = _loc_21.visibility != 0;
                        _loc_22.viewFormat = _loc_21.viewFormat;
                        _loc_22.refreshMode = _loc_21.refreshMode;
                        _loc_22.refreshInterval = _loc_21.refreshInterval;
                        _loc_22.viewRefreshMode = _loc_21.viewRefreshMode;
                        _loc_22.viewRefreshTime = _loc_21.viewRefreshTime;
                        _loc_22.httpQuery = _loc_21.httpQuery;
                        _loc_22.url = _loc_21.href;
                        _loc_2.networkLinks.push(_loc_22);
                    }
                }
            }
            return _loc_2;
        }// end function

        private static function createInfoWindowRenderer(popUpInfoObject:Object) : IFactory
        {
            var _loc_2:ClassFactory = null;
            var _loc_3:PopUpInfo = null;
            if (popUpInfoObject)
            {
                _loc_3 = PopUpInfo.toPopUpInfo(popUpInfoObject);
                _loc_2 = new ClassFactory(PopUpRenderer);
                _loc_2.properties = {popUpInfo:_loc_3};
            }
            return _loc_2;
        }// end function

    }
}
