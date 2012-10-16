package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;
    import mx.rpc.events.*;

    public class IdentifyTask extends BaseTask
    {
        private var _2143403096executeLastResult:Array;
        private var _gdbVersion:String;

        public function IdentifyTask(url:String = null)
        {
            super(url);
            return;
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

        public function execute(identifyParameters:IdentifyParameters, responder:IResponder = null) : AsyncToken
        {
            var asyncToken:AsyncToken;
            var identifyParameters:* = identifyParameters;
            var responder:* = responder;
            var generateUrlVariables:* = function (geometry:Geometry = null) : void
            {
                var _loc_2:int = 0;
                var _loc_4:Object = null;
                var _loc_5:LayerTimeOptions = null;
                var _loc_6:Object = null;
                var _loc_3:* = new URLVariables();
                _loc_3.f = "json";
                if (identifyParameters.dynamicLayerInfos)
                {
                    if (identifyParameters.layerOption)
                    {
                        _loc_3.layers = identifyParameters.layerOption;
                    }
                    _loc_3.dynamicLayers = getDynamicLayersJSON(identifyParameters);
                }
                else
                {
                    if (identifyParameters.layerOption)
                    {
                        _loc_3.layers = identifyParameters.layerOption;
                        if (identifyParameters.layerIds)
                        {
                            _loc_3.layers = _loc_3.layers + (":" + identifyParameters.layerIds.join());
                        }
                    }
                    if (identifyParameters.layerDefinitions)
                    {
                    }
                    if (identifyParameters.layerDefinitions.length > 0)
                    {
                        _loc_3.layerDefs = JSONUtil.encode(LayerDefinition.getLayerDefsAsJSON(identifyParameters.layerDefinitions));
                    }
                    if (identifyParameters.layerTimeOptions)
                    {
                    }
                    if (identifyParameters.layerTimeOptions.length > 0)
                    {
                        _loc_4 = {};
                        _loc_2 = 0;
                        while (_loc_2 < identifyParameters.layerTimeOptions.length)
                        {
                            
                            _loc_5 = identifyParameters.layerTimeOptions[_loc_2] as LayerTimeOptions;
                            if (_loc_5)
                            {
                            }
                            if (isFinite(_loc_5.layerId))
                            {
                                _loc_4[_loc_5.layerId] = _loc_5;
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                        _loc_3.layerTimeOptions = JSONUtil.encode(_loc_4);
                    }
                }
                _loc_3.returnGeometry = identifyParameters.returnGeometry;
                _loc_3.imageDisplay = identifyParameters.width + "," + identifyParameters.height + "," + identifyParameters.dpi;
                if (gdbVersion)
                {
                    _loc_3.gdbVersion = gdbVersion;
                }
                if (geometry)
                {
                    _loc_6 = geometry.toJSON();
                    delete _loc_6.spatialReference;
                    _loc_3.geometry = JSONUtil.encode(_loc_6);
                    _loc_3.geometryType = geometry.type;
                }
                if (identifyParameters.spatialReference)
                {
                    _loc_3.sr = identifyParameters.spatialReference.toSR();
                }
                else
                {
                    if (identifyParameters.geometry)
                    {
                    }
                    if (identifyParameters.geometry.spatialReference)
                    {
                        _loc_3.sr = identifyParameters.geometry.spatialReference.toSR();
                    }
                    else
                    {
                        if (identifyParameters.mapExtent)
                        {
                        }
                        if (identifyParameters.mapExtent.spatialReference)
                        {
                            _loc_3.sr = identifyParameters.mapExtent.spatialReference.toSR();
                        }
                    }
                }
                _loc_3.tolerance = isNaN(identifyParameters.tolerance) ? (0) : (identifyParameters.tolerance);
                if (identifyParameters.mapExtent)
                {
                    _loc_3.mapExtent = identifyParameters.mapExtent.xmin + "," + identifyParameters.mapExtent.ymin + "," + identifyParameters.mapExtent.xmax + "," + identifyParameters.mapExtent.ymax;
                }
                if (!isNaN(identifyParameters.maxAllowableOffset))
                {
                    _loc_3.maxAllowableOffset = identifyParameters.maxAllowableOffset;
                }
                if (identifyParameters.timeExtent)
                {
                    _loc_3.time = identifyParameters.timeExtent.toTimeParam();
                }
                if (identifyParameters.returnGeometry)
                {
                    if (identifyParameters.returnM)
                    {
                        _loc_3.returnM = true;
                    }
                    if (identifyParameters.returnZ)
                    {
                        _loc_3.returnZ = true;
                    }
                }
                asyncToken = sendURLVariables2("/identify", _loc_3, handleDecodedObject, asyncToken);
                return;
            }// end function
            ;
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, identifyParameters);
            }
            asyncToken = new AsyncToken(null);
            if (responder)
            {
                asyncToken.addResponder(responder);
            }
            if (identifyParameters.geometry)
            {
                if (autoNormalize)
                {
                    var getNormalizedGeometryFunction:* = function (item:Object, token:Object = null) : void
            {
                generateUrlVariables((item as Array)[0] as Geometry);
                return;
            }// end function
            ;
                    var faultHandler:* = function (fault:Fault, asyncToken:AsyncToken) : void
            {
                var _loc_3:IResponder = null;
                for each (_loc_3 in asyncToken.responders)
                {
                    
                    _loc_3.fault(fault);
                }
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, false, fault));
                return;
            }// end function
            ;
                    GeometryUtil.normalizeCentralMeridian([identifyParameters.geometry], GeometryServiceSingleton.instance, new AsyncResponder(getNormalizedGeometryFunction, faultHandler, asyncToken));
                }
                else
                {
                    this.generateUrlVariables(identifyParameters.geometry);
                }
            }
            else
            {
                this.generateUrlVariables();
            }
            return asyncToken;
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:Object = null;
            var _loc_5:IResponder = null;
            var _loc_3:Array = [];
            for each (_loc_4 in decodedObject.results)
            {
                
                _loc_3.push(IdentifyResult.toIdentifyResult(_loc_4));
            }
            if (Log.isDebug())
            {
                logger.debug("{0}::handleDecodedObject:{1}", id, _loc_3);
            }
            this.executeLastResult = _loc_3;
            for each (_loc_5 in asyncToken.responders)
            {
                
                _loc_5.result(this.executeLastResult);
            }
            dispatchEvent(new IdentifyEvent(IdentifyEvent.EXECUTE_COMPLETE, this.executeLastResult));
            return;
        }// end function

        private function getDynamicLayersJSON(identifyParameters:IdentifyParameters) : String
        {
            var _loc_2:String = null;
            var _loc_6:Number = NaN;
            var _loc_7:LayerInfo = null;
            var _loc_9:Array = null;
            var _loc_10:Array = null;
            var _loc_11:Object = null;
            var _loc_12:String = null;
            var _loc_13:LayerTimeOptions = null;
            var _loc_3:Array = [];
            var _loc_4:Array = [];
            var _loc_5:* = identifyParameters.layerOption;
            if (!_loc_5)
            {
                _loc_5 = IdentifyParameters.LAYER_OPTION_TOP;
            }
            if (_loc_5 != IdentifyParameters.LAYER_OPTION_TOP)
            {
            }
            if (_loc_5 == IdentifyParameters.LAYER_OPTION_VISIBLE)
            {
                _loc_9 = AGSUtil.getVisibleLayers(null, identifyParameters.dynamicLayerInfos);
                _loc_10 = AGSUtil.getLayersForScale(identifyParameters.mapScale, identifyParameters.dynamicLayerInfos);
                for each (_loc_7 in identifyParameters.dynamicLayerInfos)
                {
                    
                    if (!_loc_7.subLayerIds)
                    {
                        _loc_6 = _loc_7.layerId;
                        if (_loc_9.indexOf(_loc_6) != -1)
                        {
                        }
                        if (_loc_10.indexOf(_loc_6) != -1)
                        {
                            _loc_4.push(_loc_7);
                        }
                    }
                }
            }
            else
            {
                _loc_4 = identifyParameters.dynamicLayerInfos;
            }
            var _loc_8:* = identifyParameters.layerIds;
            for each (_loc_7 in _loc_4)
            {
                
                if (!_loc_7.subLayerIds)
                {
                    _loc_6 = _loc_7.layerId;
                    if (_loc_8)
                    {
                    }
                    if (_loc_8.indexOf(_loc_6) != -1)
                    {
                        _loc_11 = {id:_loc_6};
                        if (_loc_7 is DynamicLayerInfo)
                        {
                            _loc_11.source = (_loc_7 as DynamicLayerInfo).source;
                        }
                        else
                        {
                            _loc_11.source = {type:"mapLayer", mapLayerId:_loc_6};
                        }
                        _loc_12 = AGSUtil.getDefinitionExpression(_loc_6, identifyParameters.layerDefinitions);
                        if (_loc_12)
                        {
                            _loc_11.definitionExpression = _loc_12;
                        }
                        _loc_13 = AGSUtil.getLayerTimeOptions(_loc_6, identifyParameters.layerTimeOptions);
                        if (_loc_13)
                        {
                            _loc_11.layerTimeOptions = _loc_13;
                        }
                        _loc_3.push(_loc_11);
                    }
                }
            }
            _loc_2 = JSONUtil.encode(_loc_3);
            return _loc_2;
        }// end function

        public function get executeLastResult() : Array
        {
            return this._2143403096executeLastResult;
        }// end function

        public function set executeLastResult(value:Array) : void
        {
            arguments = this._2143403096executeLastResult;
            if (arguments !== value)
            {
                this._2143403096executeLastResult = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executeLastResult", arguments, value));
                }
            }
            return;
        }// end function

    }
}
