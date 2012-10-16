package com.esri.ags.portal
{
    import WebMapUtil.as$409.*;
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.tasks.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import com.esri.ags.virtualearth.*;
    import flash.events.*;
    import flash.net.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;

    public class WebMapUtil extends EventDispatcher
    {
        private var _webMapTask:WebMapTask;
        private var m_portalURL:String;
        public var bingMapsKey:String;
        public var geometryService:GeometryService;
        public var ignorePopUps:Boolean = false;
        private var _proxyURLObj:URL;
        private static const WEB_MERCATOR_IDS:Array = [102100, 3857, 102113];

        public function WebMapUtil()
        {
            this.m_portalURL = BASE_URL;
            this._proxyURLObj = new URL();
            this._webMapTask = new WebMapTask();
            return;
        }// end function

        public function get portalURL() : String
        {
            return this.m_portalURL;
        }// end function

        public function set portalURL(value:String) : void
        {
            if (this.m_portalURL != value)
            {
                this.m_portalURL = value;
                this._webMapTask.url = value;
                IdentityManager.instance.registerPortal(this._webMapTask.url);
            }
            return;
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURLObj.sourceURL;
        }// end function

        public function set proxyURL(value:String) : void
        {
            this._proxyURLObj.update(value);
            return;
        }// end function

        public function createMapById(itemId:String, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var getItemResultFunction:Function;
            var itemId:* = itemId;
            var responder:* = responder;
            getItemResultFunction = function (item:Object, token:Object = null) : void
            {
                var getItemDataResultFunction:Function;
                var item:* = item;
                var token:* = token;
                getItemDataResultFunction = function (itemData:Object, token:Object = null) : void
                {
                    var createMapCallback:Function;
                    var itemData:* = itemData;
                    var token:* = token;
                    createMapCallback = function (event:WebMapEvent) : void
                    {
                        var _loc_2:IResponder = null;
                        for each (_loc_2 in asyncToken.responders)
                        {
                            
                            _loc_2.result(event);
                        }
                        dispatchEvent(event);
                        return;
                    }// end function
                    ;
                    createMap(item, itemData, WebMapEvent.CREATE_MAP_BY_ID_COMPLETE, createMapCallback, asyncToken);
                    return;
                }// end function
                ;
                _webMapTask.getItemData(itemId, new AsyncResponder(getItemDataResultFunction, faultHandler, asyncToken));
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            this._webMapTask.getItem(itemId, new AsyncResponder(getItemResultFunction, this.faultHandler, asyncToken));
            return asyncToken;
        }// end function

        public function createMapByItem(item:Object, itemData:Object, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var createMapCallback:Function;
            var item:* = item;
            var itemData:* = itemData;
            var responder:* = responder;
            createMapCallback = function (event:WebMapEvent) : void
            {
                var _loc_2:IResponder = null;
                for each (_loc_2 in asyncToken.responders)
                {
                    
                    _loc_2.result(event);
                }
                dispatchEvent(event);
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            this.createMap(item, itemData, WebMapEvent.CREATE_MAP_BY_ITEM_COMPLETE, createMapCallback, asyncToken);
            return asyncToken;
        }// end function

        public function getItem(itemId:String, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var getItemResultFunction:Function;
            var itemId:* = itemId;
            var responder:* = responder;
            getItemResultFunction = function (item:Object, token:Object = null) : void
            {
                var getItemDataResultFunction:Function;
                var item:* = item;
                var token:* = token;
                getItemDataResultFunction = function (itemData:Object, token:Object = null) : void
                {
                    var _loc_4:IResponder = null;
                    var _loc_3:* = new WebMapEvent(WebMapEvent.GET_ITEM_COMPLETE);
                    _loc_3.item = item;
                    _loc_3.itemData = itemData;
                    for each (_loc_4 in asyncToken.responders)
                    {
                        
                        _loc_4.result(_loc_3);
                    }
                    dispatchEvent(_loc_3);
                    return;
                }// end function
                ;
                _webMapTask.getItemData(itemId, new AsyncResponder(getItemDataResultFunction, faultHandler, asyncToken));
                return;
            }// end function
            ;
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            this._webMapTask.getItem(itemId, new AsyncResponder(getItemResultFunction, this.faultHandler, asyncToken));
            return asyncToken;
        }// end function

        private function faultHandler(fault:Fault, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.fault(fault);
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
            return;
        }// end function

        private function createMap(item:Object, itemData:Object, eventType:String, callback:Function, asyncToken:AsyncToken) : void
        {
            var getItemPropsCallback:Function;
            var item:* = item;
            var itemData:* = itemData;
            var eventType:* = eventType;
            var callback:* = callback;
            var asyncToken:* = asyncToken;
            getItemPropsCallback = function (webMap:Object) : void
            {
                var getLayersCallback:Function;
                var webMap:* = webMap;
                getLayersCallback = function (layers:Array) : void
                {
                    var preCreateMapCallback:Function;
                    var layers:* = layers;
                    preCreateMapCallback = function (layers:Array, errors:Array, extent:Extent = null) : void
                    {
                        var _loc_4:* = new WebMapEvent(eventType);
                        _loc_4.errors = errors;
                        _loc_4.item = item;
                        _loc_4.itemData = itemData;
                        _loc_4.map = new Map();
                        _loc_4.map.extent = extent;
                        _loc_4.map.layers = layers;
                        callback(_loc_4);
                        return;
                    }// end function
                    ;
                    preCreateMap(item, layers, preCreateMapCallback, asyncToken);
                    return;
                }// end function
                ;
                getLayers(webMap, getLayersCallback);
                return;
            }// end function
            ;
            this.getItemProps(ObjectUtil.copy(itemData), getItemPropsCallback);
            return;
        }// end function

        private function getItemProps(webMap:Object, callback:Function) : void
        {
            var asyncTokens:Array;
            var LAYER:String;
            var FINISHED:String;
            var layer:Object;
            var getItemDataResult:Function;
            var getItemDataFault:Function;
            var layerURL:String;
            var token:AsyncToken;
            var webMap:* = webMap;
            var callback:* = callback;
            getItemDataResult = function (itemData:Object, token:AsyncToken) : void
            {
                var _loc_3:Object = null;
                token[FINISHED] = true;
                if (itemData)
                {
                }
                if (itemData.layers)
                {
                    layer = token[LAYER];
                    layerURL = layer.url;
                    if (layerURL.indexOf("/FeatureServer") > -1)
                    {
                        for each (_loc_3 in itemData.layers)
                        {
                            
                            if (stringEndsWith(layerURL, "/FeatureServer/" + _loc_3.id))
                            {
                                layer.itemProperties = _loc_3;
                                processFSItemProperties(layer);
                            }
                        }
                    }
                    else
                    {
                        layer.layers = itemData.layers;
                    }
                }
                processTokens();
                return;
            }// end function
            ;
            getItemDataFault = function (error:Object, token:AsyncToken) : void
            {
                token[FINISHED] = true;
                processTokens();
                return;
            }// end function
            ;
            var processTokens:* = function () : void
            {
                for each (token in asyncTokens)
                {
                    
                    if (!token[FINISHED])
                    {
                        return;
                    }
                }
                callback(webMap);
                return;
            }// end function
            ;
            asyncTokens;
            LAYER;
            FINISHED;
            var _loc_4:int = 0;
            var _loc_5:* = webMap.operationalLayers;
            while (_loc_5 in _loc_4)
            {
                
                layer = _loc_5[_loc_4];
                if (layer.itemId)
                {
                }
                if (!layer.type)
                {
                }
                if (layer.url)
                {
                    layerURL = layer.url;
                    if (layerURL.indexOf("/FeatureServer") <= -1)
                    {
                        if (!layer.layers)
                        {
                        }
                        if (layerURL.indexOf("/MapServer") > -1)
                        {
                        }
                    }
                    if (layerURL.indexOf("/MapServer/") === -1)
                    {
                        token = this._webMapTask.getItemData(layer.itemId);
                        token.addResponder(new AsyncResponder(getItemDataResult, getItemDataFault, token));
                        token[LAYER] = layer;
                        asyncTokens.push(token);
                    }
                }
            }
            if (asyncTokens.length == 0)
            {
                this.callback(webMap);
            }
            return;
        }// end function

        private function processFSItemProperties(layer:Object) : void
        {
            if (layer.itemProperties.layerDefinition)
            {
                if (layer.layerDefinition)
                {
                    if (!layer.layerDefinition.drawingInfo)
                    {
                        layer.layerDefinition.drawingInfo = layer.itemProperties.layerDefinition.drawingInfo;
                    }
                    if (!layer.layerDefinition.definitionExpression)
                    {
                        layer.layerDefinition.definitionExpression = layer.itemProperties.layerDefinition.definitionExpression;
                    }
                    if (layer.layerDefinition.minScale === null)
                    {
                        layer.layerDefinition.minScale = layer.itemProperties.layerDefinition.minScale;
                    }
                    if (layer.layerDefinition.maxScale === null)
                    {
                        layer.layerDefinition.maxScale = layer.itemProperties.layerDefinition.maxScale;
                    }
                }
                else
                {
                    layer.layerDefinition = layer.itemProperties.layerDefinition;
                }
            }
            if (layer.itemProperties.popupInfo)
            {
            }
            if (!layer.popupInfo)
            {
            }
            if (!layer.disablePopup)
            {
                layer.popupInfo = layer.itemProperties.popupInfo;
            }
            return;
        }// end function

        private function getLayers(webMap:Object, callback:Function) : void
        {
            var layers:Array;
            var loaders:Array;
            var i:int;
            var layer:Object;
            var baseMapTitle:String;
            var operationalLayers:Array;
            var numFCLayers:int;
            var fcLayer:Object;
            var baseMapLayers:Array;
            var webMap:* = webMap;
            var callback:* = callback;
            layers;
            loaders;
            var newOpLayers:Array;
            if (webMap.operationalLayers is Array)
            {
                operationalLayers = webMap.operationalLayers as Array;
                i;
                while (i < operationalLayers.length)
                {
                    
                    layer = operationalLayers[i];
                    if (layer.featureCollection)
                    {
                        if (layer.featureCollection.layers is Array)
                        {
                            numFCLayers = (layer.featureCollection.layers as Array).length;
                            var _loc_4:int = 0;
                            var _loc_5:* = layer.featureCollection.layers;
                            while (_loc_5 in _loc_4)
                            {
                                
                                fcLayer = _loc_5[_loc_4];
                                fcLayer.opacity = layer.opacity;
                                fcLayer.visibility = layer.visibility;
                                if (numFCLayers == 1)
                                {
                                    fcLayer.title = layer.title;
                                }
                                newOpLayers.push(fcLayer);
                            }
                        }
                    }
                    else
                    {
                        newOpLayers.push(layer);
                    }
                    i = (i + 1);
                }
            }
            if (webMap.baseMap)
            {
            }
            if (webMap.baseMap.baseMapLayers is Array)
            {
                baseMapTitle = webMap.baseMap.title;
                baseMapLayers = webMap.baseMap.baseMapLayers as Array;
                i;
                while (i < baseMapLayers.length)
                {
                    
                    layer = baseMapLayers[i];
                    layer.baseMapLayer = true;
                    layer.id = "base" + i;
                    layers.push(layer);
                    i = (i + 1);
                }
            }
            i;
            while (i < newOpLayers.length)
            {
                
                layer = newOpLayers[i];
                layer.id = "operational" + i;
                layers.push(layer);
                i = (i + 1);
            }
            var _loc_4:int = 0;
            var _loc_5:* = layers;
            while (_loc_5 in _loc_4)
            {
                
                layer = _loc_5[_loc_4];
                if (layer.url)
                {
                }
                if (!layer.type)
                {
                    var getServiceInfoCallback:* = function () : void
            {
                var isFinished:Function;
                var nonRefLayers:Array;
                var refLayers:Array;
                isFinished = function (item:MyURLLoader, index:int, array:Array) : Boolean
                {
                    return item.finished;
                }// end function
                ;
                if (loaders.every(isFinished))
                {
                    nonRefLayers;
                    refLayers;
                    i = 0;
                    while (i < layers.length)
                    {
                        
                        layer = layers[i];
                        if (layer.url)
                        {
                            if (i != 0)
                            {
                            }
                            if (layers[0].layerObject)
                            {
                                layer.layerObject = initLayer(layer, layers, baseMapTitle);
                            }
                        }
                        if (layer.isReference)
                        {
                            refLayers.push(layer);
                        }
                        else
                        {
                            nonRefLayers.push(layer);
                        }
                        var _loc_3:* = i + 1;
                        i = _loc_3;
                    }
                    layers = nonRefLayers.concat(refLayers);
                    callback(layers);
                }
                return;
            }// end function
            ;
                    loaders.push(this.getServiceInfo(layer, getServiceInfoCallback));
                    continue;
                }
                layer.layerObject = this.initLayer(layer, layers, baseMapTitle);
            }
            if (loaders.length == 0)
            {
                this.callback(layers);
            }
            return;
        }// end function

        private function preCreateMap(item:Object, layers:Array, callback:Function, asyncToken:AsyncToken) : void
        {
            var basemapSR:SpatialReference;
            var mapLayers:Array;
            var errors:Array;
            var mapExtent:Extent;
            var projectingExtent:Boolean;
            var layer:Object;
            var mapLayer:Layer;
            var fault:Fault;
            var extentGCS:Extent;
            var geometryService:GeometryService;
            var projectParameters:ProjectParameters;
            var item:* = item;
            var layers:* = layers;
            var callback:* = callback;
            var asyncToken:* = asyncToken;
            mapLayers;
            errors;
            var i:int;
            while (i < layers.length)
            {
                
                layer = layers[i];
                mapLayer = layer.layerObject as Layer;
                if (mapLayer)
                {
                    mapLayers.push(mapLayer);
                    if (i == 0)
                    {
                        basemapSR = mapLayer.spatialReference ? (mapLayer.spatialReference) : (layers[0].spatialReference);
                    }
                }
                else
                {
                    if (i == 0)
                    {
                        fault = new Fault(null, "Unable to load the base map layer", layer.error);
                        this.faultHandler(fault, asyncToken);
                        return;
                    }
                    if (layer.error)
                    {
                        errors.push(layer.error);
                    }
                }
                i = (i + 1);
            }
            if (basemapSR)
            {
            }
            if (item)
            {
            }
            if (item.extent)
            {
                try
                {
                    extentGCS = new Extent(item.extent[0][0], item.extent[0][1], item.extent[1][0], item.extent[1][1], new SpatialReference(4326));
                    if (basemapSR.wkid === 4326)
                    {
                        mapExtent = extentGCS;
                    }
                    else if (WEB_MERCATOR_IDS.indexOf(basemapSR.wkid) != -1)
                    {
                        extentGCS.xmin = Math.max(extentGCS.xmin, -180);
                        extentGCS.xmax = Math.min(extentGCS.xmax, 180);
                        extentGCS.ymin = Math.max(extentGCS.ymin, -89.99);
                        extentGCS.ymax = Math.min(extentGCS.ymax, 89.99);
                        mapExtent = WebMercatorUtil.geographicToWebMercator(extentGCS) as Extent;
                    }
                    else
                    {
                        geometryService = this.geometryService;
                        if (!geometryService)
                        {
                        }
                        if (GeometryServiceSingleton.instance.url)
                        {
                            geometryService = GeometryServiceSingleton.instance;
                        }
                        if (geometryService)
                        {
                            var projectResultFunction:* = function (result:Array, token:Object = null) : void
            {
                callback(mapLayers, errors, result[0]);
                return;
            }// end function
            ;
                            var projectFaultFunction:* = function (error:Object, token:Object = null) : void
            {
                callback(mapLayers, errors);
                return;
            }// end function
            ;
                            projectingExtent;
                            projectParameters = new ProjectParameters();
                            projectParameters.geometries = [extentGCS];
                            projectParameters.outSpatialReference = basemapSR;
                            geometryService.project(projectParameters, new AsyncResponder(projectResultFunction, projectFaultFunction));
                        }
                    }
                }
                catch (error:Error)
                {
                }
            }
            if (!projectingExtent)
            {
                this.callback(mapLayers, errors, mapExtent);
            }
            return;
        }// end function

        private function getServiceInfo(layer:Object, callback:Function) : MyURLLoader
        {
            var _loc_6:String = null;
            var _loc_3:* = new URL(layer.url);
            var _loc_4:* = this.getExtraVariables(_loc_3, false);
            _loc_4.f = "json";
            var _loc_5:* = _loc_3.path + "?" + _loc_4.toString();
            if (this._proxyURLObj.path)
            {
                _loc_4 = this.getExtraVariables(_loc_3, true);
                _loc_4.f = "json";
                _loc_6 = this._proxyURLObj.path + "?" + _loc_3.path;
                _loc_6 = _loc_6 + ("?" + _loc_4.toString());
            }
            var _loc_7:* = new MyURLLoader();
            _loc_7.callback = callback;
            _loc_7.layer = layer;
            _loc_7.layerURL = _loc_3;
            _loc_7.proxiedURL = _loc_6;
            _loc_7.urlRequest = new URLRequest(_loc_5);
            _loc_7.load(_loc_7.urlRequest);
            return _loc_7;
        }// end function

        private function getExtraVariables(urlObj:URL, includeProxyParams:Boolean) : URLVariables
        {
            var _loc_4:Object = null;
            var _loc_3:* = new URLVariables();
            if (includeProxyParams)
            {
                for (_loc_4 in this._proxyURLObj.query)
                {
                    
                    _loc_3[_loc_4] = this._proxyURLObj.query[_loc_4];
                }
            }
            for (_loc_4 in urlObj.query)
            {
                
                _loc_3[_loc_4] = urlObj.query[_loc_4];
            }
            return _loc_3;
        }// end function

        private function initLayer(layerObject:Object, layers:Array, baseMapTitle:String) : Layer
        {
            var _loc_4:Layer = null;
            var _loc_5:FeatureLayer = null;
            var _loc_7:WMSLayer = null;
            var _loc_8:Array = null;
            var _loc_9:Extent = null;
            var _loc_10:Object = null;
            var _loc_11:Array = null;
            var _loc_12:WMSLayerInfo = null;
            var _loc_13:KMLLayer = null;
            var _loc_14:FeatureSet = null;
            var _loc_15:LayerDetails = null;
            var _loc_16:String = null;
            var _loc_17:ArcGISImageServiceLayer = null;
            var _loc_18:Array = null;
            var _loc_19:IRenderer = null;
            var _loc_6:* = layerObject.layerDefinition;
            if (layerObject.type === "OpenStreetMap")
            {
                _loc_4 = new OpenStreetMapLayer();
                var _loc_20:* = layerObject.id;
                _loc_4.name = layerObject.id;
                _loc_4.id = _loc_20;
            }
            else if (layerObject.type === "WMS")
            {
                _loc_7 = new WMSLayer();
                _loc_7.alpha = layerObject.opacity;
                var _loc_20:* = layerObject.id;
                _loc_7.name = layerObject.id;
                _loc_7.id = _loc_20;
                _loc_7.visible = layerObject.visibility;
                _loc_7.url = layerObject.mapUrl ? (layerObject.mapUrl) : (layerObject.url);
                _loc_7.skipGetCapabilities = true;
                _loc_7.title = layerObject.title;
                _loc_7.version = layerObject.version;
                if (layerObject.extent)
                {
                    _loc_9 = new Extent(layerObject.extent[0][0], layerObject.extent[0][1], layerObject.extent[1][0], layerObject.extent[1][1], new SpatialReference(4326));
                    _loc_7.initialExtent = _loc_9;
                }
                if (layerObject.format)
                {
                    _loc_7.imageFormat = layerObject.format;
                }
                _loc_8 = [];
                if (layerObject.layers is Array)
                {
                    for each (_loc_10 in layerObject.layers)
                    {
                        
                        _loc_8.push(WMSLayerInfo.toWMSLayerInfo(_loc_10));
                    }
                    _loc_7.layerInfos = _loc_8;
                }
                if (layerObject.maxHeight > 0)
                {
                    _loc_7.maxImageHeight = layerObject.maxHeight;
                }
                if (layerObject.maxWidth > 0)
                {
                    _loc_7.maxImageWidth = layerObject.maxWidth;
                }
                if (layerObject.spatialReferences is Array)
                {
                    _loc_11 = layerObject.spatialReferences as Array;
                    if (_loc_11.length > 0)
                    {
                        _loc_7.spatialReference = new SpatialReference(_loc_11[0]);
                    }
                }
                if (layerObject.visibleLayers is Array)
                {
                    _loc_7.visibleLayers = new ArrayList(layerObject.visibleLayers);
                }
                else
                {
                    _loc_7.visibleLayers = new ArrayList();
                    for each (_loc_12 in _loc_8)
                    {
                        
                        _loc_7.visibleLayers.addItem(_loc_12.name);
                    }
                }
                _loc_4 = _loc_7;
            }
            else if (layerObject.type === "KML")
            {
                _loc_13 = new KMLLayer();
                var _loc_20:* = layerObject.id;
                _loc_13.name = layerObject.id;
                _loc_13.id = _loc_20;
                _loc_13.visible = layerObject.visibility;
                _loc_13.alpha = layerObject.opacity;
                _loc_13.url = layerObject.url;
                _loc_13.visibleFolders = layerObject.visibleFolders;
                _loc_4 = _loc_13;
            }
            else
            {
                if (_loc_6)
                {
                }
                if (!layerObject.url)
                {
                    _loc_14 = FeatureSet.fromJSON(layerObject.featureSet);
                    if (_loc_14)
                    {
                    }
                    if (_loc_14.features)
                    {
                    }
                    if (_loc_14.features.length > 0)
                    {
                        _loc_5 = new FeatureLayer();
                        _loc_5.alpha = layerObject.opacity;
                        var _loc_20:* = layerObject.id;
                        _loc_5.name = layerObject.id;
                        _loc_5.id = _loc_20;
                        _loc_5.visible = layerObject.visibility;
                        _loc_5.outFields = ["*"];
                        _loc_15 = LayerDetails.toLayerDetails(_loc_6);
                        _loc_5.featureCollection = new FeatureCollection(_loc_14, _loc_15);
                        if (!layerObject.title)
                        {
                        }
                        if (_loc_15.name)
                        {
                            _loc_5.name = _loc_15.name;
                        }
                        if (!this.ignorePopUps)
                        {
                            _loc_5.infoWindowRenderer = this.createInfoWindowRenderer(layerObject.popupInfo);
                        }
                        _loc_4 = _loc_5;
                    }
                }
                else
                {
                    if (layerObject.type !== "BingMapsAerial")
                    {
                    }
                    if (layerObject.type !== "BingMapsRoad")
                    {
                    }
                    if (layerObject.type === "BingMapsHybrid")
                    {
                        _loc_16 = VETiledLayer.MAP_STYLE_AERIAL_WITH_LABELS;
                        if (layerObject.type === "BingMapsAerial")
                        {
                            _loc_16 = VETiledLayer.MAP_STYLE_AERIAL;
                        }
                        else if (layerObject.type === "BingMapsRoad")
                        {
                            _loc_16 = VETiledLayer.MAP_STYLE_ROAD;
                        }
                        _loc_4 = new VETiledLayer("en-US", _loc_16);
                        VETiledLayer(_loc_4).key = this.bingMapsKey;
                        var _loc_20:* = layerObject.id;
                        _loc_4.name = layerObject.id;
                        _loc_4.id = _loc_20;
                    }
                    else
                    {
                        if (layerObject.resourceInfo)
                        {
                        }
                        if (layerObject.resourceInfo.mapName)
                        {
                            if (layerObject.resourceInfo.singleFusedMapCache === true)
                            {
                                if (!layerObject.baseMapLayer)
                                {
                                    if (this.sameSpatialReferenceAsBasemap(layerObject, layers))
                                    {
                                        if (this.sameTilingSchemeAsBasemap(layerObject, layers))
                                        {
                                            _loc_4 = this.loadAsCached(layerObject);
                                        }
                                        else
                                        {
                                            _loc_4 = this.loadAsDynamic(layerObject);
                                        }
                                    }
                                    else
                                    {
                                        _loc_4 = this.loadAsDynamic(layerObject);
                                    }
                                }
                                else
                                {
                                    _loc_4 = this.loadAsCached(layerObject);
                                }
                            }
                            else
                            {
                                _loc_4 = this.loadAsDynamic(layerObject);
                            }
                            if (layerObject.baseMapLayer)
                            {
                                layerObject.spatialReference = SpatialReference.fromJSON(layerObject.resourceInfo.spatialReference);
                            }
                        }
                        else
                        {
                            if (layerObject.resourceInfo)
                            {
                            }
                            if (layerObject.resourceInfo.pixelSizeX)
                            {
                                _loc_17 = new ArcGISImageServiceLayer();
                                _loc_17.alpha = layerObject.opacity;
                                var _loc_20:* = layerObject.id;
                                _loc_17.name = layerObject.id;
                                _loc_17.id = _loc_20;
                                _loc_17.url = layerObject.url;
                                _loc_17.visible = layerObject.visibility;
                                _loc_18 = layerObject.bandIds;
                                if (!_loc_18)
                                {
                                }
                                if (layerObject.resourceInfo.bandCount > 3)
                                {
                                    _loc_18 = [0, 1, 2];
                                }
                                _loc_17.bandIds = _loc_18;
                                if (layerObject.useProxy)
                                {
                                    _loc_17.proxyURL = this.proxyURL;
                                }
                                if (layerObject.baseMapLayer)
                                {
                                }
                                if (layerObject.resourceInfo.extent)
                                {
                                    layerObject.spatialReference = SpatialReference.fromJSON(layerObject.resourceInfo.extent.spatialReference);
                                }
                                _loc_4 = _loc_17;
                            }
                            else
                            {
                                if (layerObject.resourceInfo)
                                {
                                }
                                if (layerObject.resourceInfo.type === "Feature Layer")
                                {
                                    _loc_5 = new FeatureLayer();
                                    _loc_5.alpha = layerObject.opacity;
                                    var _loc_20:* = layerObject.id;
                                    _loc_5.name = layerObject.id;
                                    _loc_5.id = _loc_20;
                                    _loc_5.outFields = ["*"];
                                    _loc_5.url = layerObject.url;
                                    _loc_5.visible = layerObject.visibility;
                                    if (layerObject.mode === 0)
                                    {
                                        _loc_5.mode = FeatureLayer.MODE_SNAPSHOT;
                                    }
                                    else if (layerObject.mode === 1)
                                    {
                                        _loc_5.mode = FeatureLayer.MODE_ON_DEMAND;
                                    }
                                    else if (layerObject.mode === 2)
                                    {
                                        _loc_5.mode = FeatureLayer.MODE_SELECTION;
                                    }
                                    if (layerObject.useProxy)
                                    {
                                        _loc_5.proxyURL = this.proxyURL;
                                    }
                                    if (!this.ignorePopUps)
                                    {
                                        _loc_5.infoWindowRenderer = this.createInfoWindowRenderer(layerObject.popupInfo);
                                    }
                                    if (_loc_6)
                                    {
                                        if (_loc_6.drawingInfo)
                                        {
                                            _loc_19 = Renderer.fromJSON(_loc_6.drawingInfo.renderer);
                                            if (_loc_19)
                                            {
                                                _loc_5.renderer = _loc_19;
                                            }
                                        }
                                        if (_loc_6.definitionExpression)
                                        {
                                            _loc_5.definitionExpression = _loc_6.definitionExpression;
                                        }
                                        if (_loc_6.minScale >= 0)
                                        {
                                            _loc_5.minScale = _loc_6.minScale;
                                        }
                                        if (_loc_6.maxScale >= 0)
                                        {
                                            _loc_5.maxScale = _loc_6.maxScale;
                                        }
                                    }
                                    _loc_4 = _loc_5;
                                }
                            }
                        }
                    }
                }
            }
            if (_loc_4)
            {
            }
            if (_loc_4.id === _loc_4.name)
            {
                if (layerObject.title)
                {
                    _loc_4.name = layerObject.title;
                }
                else if (layerObject.resourceInfo)
                {
                    if (layerObject.resourceInfo.documentInfo)
                    {
                    }
                    if (layerObject.resourceInfo.documentInfo.Title)
                    {
                        _loc_4.name = layerObject.resourceInfo.documentInfo.Title;
                    }
                    else if (layerObject.resourceInfo.name)
                    {
                        _loc_4.name = layerObject.resourceInfo.name;
                    }
                    else
                    {
                        if (layerObject.baseMapLayer)
                        {
                        }
                        if (baseMapTitle)
                        {
                        }
                        if (!layerObject.isReference)
                        {
                            _loc_4.name = baseMapTitle;
                        }
                    }
                }
                else
                {
                    if (layerObject.baseMapLayer)
                    {
                    }
                    if (baseMapTitle)
                    {
                        _loc_4.name = baseMapTitle;
                    }
                }
            }
            return _loc_4;
        }// end function

        private function loadAsCached(layerObject:Object) : Layer
        {
            var _loc_3:Array = null;
            var _loc_2:* = new ArcGISTiledMapServiceLayer();
            _loc_2.alpha = layerObject.opacity;
            _loc_2.displayLevels = layerObject.displayLevels;
            var _loc_4:* = layerObject.id;
            _loc_2.name = layerObject.id;
            _loc_2.id = _loc_4;
            _loc_2.url = layerObject.url;
            _loc_2.visible = layerObject.visibility;
            if (layerObject.useProxy)
            {
                _loc_2.proxyURL = this.proxyURL;
            }
            if (!this.ignorePopUps)
            {
                _loc_3 = this.createLayerInfoWindowRenderers(layerObject.layers as Array);
                if (_loc_3)
                {
                    _loc_2.layerInfoWindowRenderers = _loc_3;
                }
            }
            return _loc_2;
        }// end function

        private function loadAsDynamic(layerObject:Object) : Layer
        {
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_9:Array = null;
            var _loc_2:* = new ArcGISDynamicMapServiceLayer();
            _loc_2.alpha = layerObject.opacity;
            var _loc_10:* = layerObject.id;
            _loc_2.name = layerObject.id;
            _loc_2.id = _loc_10;
            _loc_2.url = layerObject.url;
            _loc_2.visible = layerObject.visibility;
            if (layerObject.useProxy)
            {
                _loc_2.proxyURL = this.proxyURL;
            }
            if (layerObject.visibleLayers)
            {
                _loc_3 = layerObject.resourceInfo.layers;
                _loc_4 = layerObject.visibleLayers;
                _loc_5 = "," + _loc_4 + ",";
                _loc_6 = [];
                _loc_7 = ",";
                _loc_8 = 0;
                while (_loc_8 < _loc_3.length)
                {
                    
                    if (_loc_3[_loc_8].subLayerIds)
                    {
                        if (_loc_5.indexOf("," + _loc_3[_loc_8].id + ",") != -1)
                        {
                        }
                        if (_loc_7.indexOf("," + _loc_3[_loc_8].id + ",") > -1)
                        {
                            _loc_7 = _loc_7 + (_loc_3[_loc_8].subLayerIds.toString() + ",");
                        }
                    }
                    else
                    {
                        if (_loc_5.indexOf("," + _loc_3[_loc_8].id + ",") > -1)
                        {
                        }
                        if (_loc_7.indexOf("," + _loc_3[_loc_8].id + ",") == -1)
                        {
                            _loc_6.push(_loc_3[_loc_8].id);
                        }
                    }
                    _loc_8 = _loc_8 + 1;
                }
                _loc_2.visibleLayers = new ArrayCollection(_loc_6);
            }
            if (!this.ignorePopUps)
            {
                _loc_9 = this.createLayerInfoWindowRenderers(layerObject.layers as Array);
                if (_loc_9)
                {
                    _loc_2.layerInfoWindowRenderers = _loc_9;
                }
            }
            return _loc_2;
        }// end function

        private function createLayerInfoWindowRenderers(popupLayers:Array) : Array
        {
            var _loc_2:Array = null;
            var _loc_3:Object = null;
            var _loc_4:LayerInfoWindowRenderer = null;
            if (popupLayers)
            {
                _loc_2 = [];
                for each (_loc_3 in popupLayers)
                {
                    
                    if (!isNaN(_loc_3.id))
                    {
                    }
                    if (_loc_3.popupInfo)
                    {
                    }
                    if (!_loc_3.layerUrl)
                    {
                        _loc_4 = new LayerInfoWindowRenderer();
                        _loc_4.layerId = _loc_3.id;
                        _loc_4.infoWindowRenderer = this.createInfoWindowRenderer(_loc_3.popupInfo);
                        _loc_2.push(_loc_4);
                    }
                }
            }
            return _loc_2;
        }// end function

        private function createInfoWindowRenderer(popUpInfoObject:Object) : IFactory
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

        private function sameSpatialReferenceAsBasemap(layerObject:Object, layers:Array) : Boolean
        {
            var _loc_3:SpatialReference = null;
            var _loc_4:* = layers[0].layerObject as Layer;
            if (_loc_4)
            {
                _loc_3 = _loc_4.spatialReference ? (_loc_4.spatialReference) : (layers[0].spatialReference);
            }
            var _loc_5:* = SpatialReference.fromJSON(layerObject.resourceInfo.spatialReference);
            if (_loc_3)
            {
            }
            if (_loc_5)
            {
                if (_loc_3.toSR() === _loc_5.toSR())
                {
                    return true;
                }
                if (WEB_MERCATOR_IDS.indexOf(_loc_3.wkid) != -1)
                {
                }
                if (WEB_MERCATOR_IDS.indexOf(_loc_5.wkid) != -1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function sameTilingSchemeAsBasemap(layerObject:Object, layers:Array) : Boolean
        {
            var _loc_5:Object = null;
            var _loc_6:Boolean = false;
            var _loc_7:Array = null;
            var _loc_8:Object = null;
            var _loc_3:* = layers[0].layerObject as TiledMapServiceLayer;
            if (!_loc_3)
            {
                return false;
            }
            var _loc_4:Array = [];
            for each (_loc_5 in layers)
            {
                
                if (_loc_5.baseMapLayer)
                {
                    if (_loc_5.resourceInfo)
                    {
                    }
                    if (_loc_5.resourceInfo.tileInfo)
                    {
                        _loc_7 = _loc_5.resourceInfo.tileInfo.lods;
                    }
                    else if (_loc_5.layerObject is TiledMapServiceLayer)
                    {
                        _loc_7 = TiledMapServiceLayer(_loc_5.layerObject).tileInfo.lods;
                    }
                    for each (_loc_8 in _loc_7)
                    {
                        
                        _loc_4.push(_loc_8.scale);
                    }
                }
            }
            if (layerObject.resourceInfo.tileInfo)
            {
                for each (_loc_8 in layerObject.resourceInfo.tileInfo.lods)
                {
                    
                    if (_loc_4.indexOf(_loc_8.scale) != -1)
                    {
                        _loc_6 = true;
                        break;
                    }
                }
            }
            return _loc_6;
        }// end function

        private static function stringEndsWith(input:String, suffix:String) : Boolean
        {
            return suffix === input.substring(input.length - suffix.length);
        }// end function

    }
}
