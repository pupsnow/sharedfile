package com.esri.ags.tasks
{
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class LegendTask extends BaseTask
    {
        private var _1897299539lastResult:Array;

        public function LegendTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function getLegend(layer:Layer, returnBytes:Boolean, responder:IResponder = null) : AsyncToken
        {
            var dynamicMapServiceLayer:ArcGISDynamicMapServiceLayer;
            var handleDecodedObject:Function;
            var params:ImageParameters;
            var layer:* = layer;
            var returnBytes:* = returnBytes;
            var responder:* = responder;
            handleDecodedObject = function (decodedObject:Object, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                var _loc_4:Array = null;
                var _loc_5:Array = null;
                var _loc_6:Array = null;
                var _loc_7:int = 0;
                var _loc_8:Array = null;
                var _loc_9:Array = null;
                var _loc_10:LayerInfo = null;
                var _loc_11:LayerInfo = null;
                var _loc_12:LayerInfo = null;
                if (decodedObject.layers)
                {
                    _loc_4 = [];
                    if (dynamicMapServiceLayer)
                    {
                        _loc_8 = dynamicMapServiceLayer.dynamicLayerInfos ? (dynamicMapServiceLayer.dynamicLayerInfos) : (dynamicMapServiceLayer.layerInfos);
                        if (dynamicMapServiceLayer.visibleLayers)
                        {
                            _loc_9 = getActualVisibleLayers(dynamicMapServiceLayer.visibleLayers.toArray(), _loc_8.slice());
                            for each (_loc_10 in _loc_8)
                            {
                                
                                _loc_10.defaultVisibility = _loc_9.indexOf(_loc_10.layerId) != -1 ? (true) : (false);
                                updateMinMaxScaleOnLayerInfos(_loc_10, _loc_8);
                                _loc_4.push(_loc_10);
                            }
                        }
                        else
                        {
                            for each (_loc_11 in _loc_8)
                            {
                                
                                if (_loc_11.parentLayerId != -1)
                                {
                                }
                                if (!isNaN(_loc_11.parentLayerId))
                                {
                                    _loc_12 = findLayerById(_loc_11.parentLayerId, _loc_8);
                                    _loc_11.defaultVisibility = _loc_12.defaultVisibility;
                                }
                                updateMinMaxScaleOnLayerInfos(_loc_11, _loc_8);
                                _loc_4.push(_loc_11);
                            }
                        }
                    }
                    else if (layer is ArcGISTiledMapServiceLayer)
                    {
                        _loc_4 = ArcGISTiledMapServiceLayer(layer).layerInfos;
                    }
                    _loc_5 = findRootLayers(_loc_4);
                    _loc_6 = [];
                    _loc_7 = 0;
                    while (_loc_7 < _loc_5.length)
                    {
                        
                        _loc_6.push(createSubLayers(_loc_5[_loc_7], _loc_4, decodedObject));
                        _loc_7 = _loc_7 + 1;
                    }
                }
                lastResult = _loc_6;
                if (Log.isDebug())
                {
                    logger.debug("{0}::handleDecodedObject:{1}", id, lastResult);
                }
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.result(lastResult);
                }
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::getLegend:{1}", id, url);
            }
            var urlVariables:* = new URLVariables();
            urlVariables.f = "json";
            if (returnBytes)
            {
                urlVariables.returnbytes = true;
            }
            if (layer is ArcGISDynamicMapServiceLayer)
            {
                dynamicMapServiceLayer = ArcGISDynamicMapServiceLayer(layer);
                if (ArcGISDynamicMapServiceLayer(layer).version >= 10.1)
                {
                    params = new ImageParameters();
                    params.dynamicLayerInfos = dynamicMapServiceLayer.dynamicLayerInfos;
                    params.layerDefinitions = dynamicMapServiceLayer.layerDefinitions;
                    params.layerDrawingOptions = dynamicMapServiceLayer.layerDrawingOptions;
                    params.layerInfos = dynamicMapServiceLayer.layerInfos;
                    if (dynamicMapServiceLayer.visibleLayers)
                    {
                        params.layerIds = dynamicMapServiceLayer.visibleLayers.toArray();
                        params.layerOption = ImageParameters.LAYER_OPTION_SHOW;
                    }
                    params.mapScale = dynamicMapServiceLayer.map ? (dynamicMapServiceLayer.map.scale) : (0);
                    params.appendToURLVariables(urlVariables);
                }
            }
            return sendURLVariables("/legend", urlVariables, responder, handleDecodedObject);
        }// end function

        private function getActualVisibleLayers(layerIds:Array, layerInfos:Array) : Array
        {
            var _loc_4:LayerInfo = null;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_3:Array = [];
            layerIds = layerIds ? (layerIds.concat()) : (null);
            if (layerIds)
            {
                for each (_loc_4 in layerInfos)
                {
                    
                    _loc_5 = layerIds.indexOf(_loc_4.layerId);
                    if (_loc_4.subLayerIds)
                    {
                    }
                    if (_loc_5 != -1)
                    {
                        layerIds.splice(_loc_5, 1);
                        for each (_loc_6 in _loc_4.subLayerIds)
                        {
                            
                            layerIds.push(_loc_6);
                        }
                    }
                }
                for each (_loc_4 in layerInfos.reverse())
                {
                    
                    if (layerIds.indexOf(_loc_4.layerId) != -1)
                    {
                    }
                    if (layerIds.indexOf(_loc_4.parentLayerId) == -1)
                    {
                    }
                    if (_loc_4.parentLayerId != -1)
                    {
                        layerIds.push(_loc_4.parentLayerId);
                    }
                }
                _loc_3 = layerIds;
            }
            return _loc_3;
        }// end function

        private function updateMinMaxScaleOnLayerInfos(copyLayerInfo:LayerInfo, copyLayerInfos:Array) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:LayerInfo = null;
            if (copyLayerInfo.subLayerIds)
            {
                for each (_loc_3 in copyLayerInfo.subLayerIds)
                {
                    
                    _loc_4 = this.findLayerById(_loc_3, copyLayerInfos);
                    if (_loc_4)
                    {
                        if (copyLayerInfo.minScale > 0)
                        {
                            if (_loc_4.minScale != 0)
                            {
                                if (_loc_4.minScale > 0)
                                {
                                }
                            }
                            if (_loc_4.minScale > copyLayerInfo.minScale)
                            {
                                _loc_4.minScale = copyLayerInfo.minScale;
                            }
                        }
                        if (copyLayerInfo.maxScale)
                        {
                            if (_loc_4.maxScale != 0)
                            {
                                if (_loc_4.maxScale > 0)
                                {
                                }
                            }
                            if (_loc_4.maxScale < copyLayerInfo.maxScale)
                            {
                                _loc_4.maxScale = copyLayerInfo.maxScale;
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        private function findRootLayers(layerInfos:Array) : Array
        {
            var _loc_3:LayerInfo = null;
            var _loc_2:Array = [];
            for each (_loc_3 in layerInfos)
            {
                
                if (!isNaN(_loc_3.parentLayerId))
                {
                    isNaN(_loc_3.parentLayerId);
                }
                if (_loc_3.parentLayerId == -1)
                {
                    _loc_2.push(_loc_3);
                }
            }
            return _loc_2;
        }// end function

        private function createSubLayers(layerInfo:LayerInfo, layerInfos:Array, response:Object) : LayerLegendInfo
        {
            var _loc_5:Number = NaN;
            var _loc_6:LayerInfo = null;
            var _loc_7:Object = null;
            var _loc_8:int = 0;
            var _loc_4:* = new LayerLegendInfo();
            if (layerInfo.subLayerIds)
            {
                _loc_4.layerId = String(layerInfo.layerId);
                _loc_4.layerType = "Group Layer";
                _loc_4.layerName = layerInfo.name;
                _loc_4.layerLegendInfos = [];
                _loc_4.visible = layerInfo.defaultVisibility;
                _loc_4.minScale = layerInfo.minScale;
                _loc_4.maxScale = layerInfo.maxScale;
                for each (_loc_5 in layerInfo.subLayerIds)
                {
                    
                    _loc_6 = this.findLayerById(_loc_5, layerInfos);
                    if (_loc_6)
                    {
                        _loc_4.layerLegendInfos.push(this.createSubLayers(_loc_6, layerInfos, response));
                    }
                }
            }
            else
            {
                _loc_8 = 0;
                while (_loc_8 < response.layers.length)
                {
                    
                    if (layerInfo.layerId == response.layers[_loc_8].layerId)
                    {
                        _loc_7 = response.layers[_loc_8];
                        break;
                        continue;
                    }
                    _loc_8 = _loc_8 + 1;
                }
                _loc_4 = LayerLegendInfo.toLayerLegendInfo(_loc_7);
                if (_loc_4)
                {
                    _loc_4.minScale = layerInfo.minScale;
                    _loc_4.maxScale = layerInfo.maxScale;
                    _loc_4.visible = layerInfo.defaultVisibility;
                }
            }
            return _loc_4;
        }// end function

        private function findLayerById(id:Number, layerInfos:Array) : LayerInfo
        {
            var _loc_3:LayerInfo = null;
            for each (_loc_3 in layerInfos)
            {
                
                if (id == _loc_3.layerId)
                {
                    return _loc_3;
                }
            }
            return null;
        }// end function

        public function get lastResult() : Array
        {
            return this._1897299539lastResult;
        }// end function

        public function set lastResult(value:Array) : void
        {
            arguments = this._1897299539lastResult;
            if (arguments !== value)
            {
                this._1897299539lastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
