package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.events.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class FindTask extends BaseTask
    {
        private var _2143403096executeLastResult:Array;
        private var _gdbVersion:String;

        public function FindTask(url:String = null)
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

        public function execute(findParameters:FindParameters, responder:IResponder = null) : AsyncToken
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::execute:{1}", id, findParameters);
            }
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            if (findParameters.dynamicLayerInfos)
            {
                _loc_3.dynamicLayers = this.getDynamicLayersJSON(findParameters);
            }
            else
            {
                if (findParameters.layerIds)
                {
                    _loc_3.layers = findParameters.layerIds.join();
                }
                if (findParameters.layerDefinitions)
                {
                }
                if (findParameters.layerDefinitions.length > 0)
                {
                    _loc_3.layerDefs = JSONUtil.encode(LayerDefinition.getLayerDefsAsJSON(findParameters.layerDefinitions));
                }
            }
            _loc_3.contains = findParameters.contains;
            _loc_3.returnGeometry = findParameters.returnGeometry;
            _loc_3.searchText = findParameters.searchText;
            if (this.gdbVersion)
            {
                _loc_3.gdbVersion = this.gdbVersion;
            }
            if (findParameters.searchFields)
            {
                _loc_3.searchFields = findParameters.searchFields.join();
            }
            if (findParameters.outSpatialReference)
            {
                _loc_3.sr = findParameters.outSpatialReference.toSR();
            }
            if (!isNaN(findParameters.maxAllowableOffset))
            {
                _loc_3.maxAllowableOffset = findParameters.maxAllowableOffset;
            }
            if (findParameters.returnGeometry)
            {
                if (findParameters.returnM)
                {
                    _loc_3.returnM = true;
                }
                if (findParameters.returnZ)
                {
                    _loc_3.returnZ = true;
                }
            }
            return sendURLVariables("/find", _loc_3, responder, this.handleDecodedObject);
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_4:Object = null;
            var _loc_5:IResponder = null;
            var _loc_3:Array = [];
            for each (_loc_4 in decodedObject.results)
            {
                
                _loc_3.push(FindResult.toFindResult(_loc_4));
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
            dispatchEvent(new FindEvent(FindEvent.EXECUTE_COMPLETE, this.executeLastResult));
            return;
        }// end function

        private function getDynamicLayersJSON(findParameters:FindParameters) : String
        {
            var _loc_2:String = null;
            var _loc_7:LayerInfo = null;
            var _loc_8:Number = NaN;
            var _loc_9:Object = null;
            var _loc_10:String = null;
            var _loc_3:Array = [];
            var _loc_4:* = findParameters.dynamicLayerInfos;
            var _loc_5:* = findParameters.layerDefinitions;
            var _loc_6:* = findParameters.layerIds;
            for each (_loc_7 in _loc_4)
            {
                
                if (!_loc_7.subLayerIds)
                {
                    _loc_8 = _loc_7.layerId;
                    if (_loc_6)
                    {
                    }
                    if (_loc_6.indexOf(_loc_8) != -1)
                    {
                        _loc_9 = {id:_loc_8};
                        if (_loc_7 is DynamicLayerInfo)
                        {
                            _loc_9.source = (_loc_7 as DynamicLayerInfo).source;
                        }
                        else
                        {
                            _loc_9.source = {type:"mapLayer", mapLayerId:_loc_8};
                        }
                        _loc_10 = AGSUtil.getDefinitionExpression(_loc_8, _loc_5);
                        if (_loc_10)
                        {
                            _loc_9.definitionExpression = _loc_10;
                        }
                        _loc_3.push(_loc_9);
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
