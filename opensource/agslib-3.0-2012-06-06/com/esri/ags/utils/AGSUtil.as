package com.esri.ags.utils
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.net.*;
    import flash.system.*;
    import mx.utils.*;

    public class AGSUtil extends Object
    {

        public function AGSUtil()
        {
            return;
        }// end function

        public static function getURLRequest(urlObj:URL, urlSuffix:String, urlVariables:URLVariables = null, tokenProp:String = null, proxyURLObj:URL = null, overridePath:String = null, credToken:String = null) : URLRequest
        {
            var _loc_10:Object = null;
            var _loc_12:URLVariables = null;
            var _loc_13:String = null;
            var _loc_14:Boolean = false;
            var _loc_17:int = 0;
            var _loc_18:String = null;
            var _loc_8:* = new URLRequest();
            var _loc_9:String = "";
            if (overridePath)
            {
                _loc_9 = overridePath;
            }
            else if (urlObj.path)
            {
                _loc_9 = urlObj.path;
            }
            if (urlSuffix)
            {
                _loc_9 = _loc_9 + urlSuffix;
            }
            var _loc_11:* = new URLVariables();
            for (_loc_10 in urlVariables)
            {
                
                _loc_11[_loc_10] = urlVariables[_loc_10];
            }
            _loc_12 = new URLVariables();
            for (_loc_10 in urlObj.query)
            {
                
                if (!_loc_11[_loc_10])
                {
                    _loc_12[_loc_10] = urlObj.query[_loc_10];
                }
            }
            if (!credToken)
            {
            }
            _loc_13 = tokenProp;
            if (_loc_13)
            {
                if (_loc_12.token)
                {
                    _loc_12.token = _loc_13;
                }
                else
                {
                    _loc_11.token = _loc_13;
                }
            }
            if (proxyURLObj)
            {
            }
            if (proxyURLObj.sourceURL)
            {
                _loc_9 = proxyURLObj.path + "?" + _loc_9;
                if (proxyURLObj.query)
                {
                    for (_loc_10 in proxyURLObj.query)
                    {
                        
                        if (!_loc_12[_loc_10])
                        {
                        }
                        if (!_loc_11[_loc_10])
                        {
                            _loc_12[_loc_10] = proxyURLObj.query[_loc_10];
                        }
                    }
                }
            }
            var _loc_15:* = _loc_12.toString();
            if (_loc_15)
            {
            }
            if (_loc_15.length > 0)
            {
                _loc_14 = true;
                _loc_9 = _loc_9 + ("?" + _loc_15);
            }
            if (_loc_8.method != URLRequestMethod.POST)
            {
                _loc_17 = _loc_9.length + _loc_11.toString().length;
                if (_loc_17 > 2000)
                {
                    _loc_8.method = URLRequestMethod.POST;
                }
                else
                {
                    if (!credToken)
                    {
                    }
                    if (Security.sandboxType != Security.APPLICATION)
                    {
                        if (!_loc_12.token)
                        {
                        }
                    }
                    if (_loc_11.token)
                    {
                        _loc_8.method = URLRequestMethod.POST;
                    }
                }
            }
            if (_loc_11.layerDefs)
            {
            }
            if (_loc_8.method != URLRequestMethod.POST)
            {
                _loc_18 = _loc_11.layerDefs;
                delete _loc_11.layerDefs;
            }
            var _loc_16:* = _loc_11.toString();
            if (_loc_8.method != URLRequestMethod.POST)
            {
                if (_loc_16)
                {
                }
                if (_loc_16.length > 0)
                {
                    _loc_9 = _loc_9 + ((_loc_14 ? ("&") : ("?")) + _loc_16);
                    if (_loc_18)
                    {
                        _loc_9 = _loc_9 + ("&layerDefs=" + encodeURIComponent(_loc_18));
                    }
                }
            }
            else
            {
                if (_loc_16)
                {
                }
                if (_loc_16.length == 0)
                {
                    _loc_11.forceFlashPOST = true;
                }
                _loc_8.data = _loc_11;
            }
            _loc_8.url = _loc_9;
            return _loc_8;
        }// end function

        public static function getVisibleLayers(layerIds:Array, layerInfos:Array, layerOption:String = null) : Array
        {
            var _loc_5:LayerInfo = null;
            var _loc_6:int = 0;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_4:Array = [];
            layerIds = layerIds ? (layerIds.concat()) : (null);
            layerOption = layerOption ? (layerOption) : (ImageParameters.LAYER_OPTION_SHOW);
            if (layerIds)
            {
                for each (_loc_5 in layerInfos)
                {
                    
                    _loc_6 = layerIds.indexOf(_loc_5.layerId);
                    if (_loc_5.subLayerIds)
                    {
                    }
                    if (_loc_6 != -1)
                    {
                        layerIds.splice(_loc_6, 1);
                        for each (_loc_7 in _loc_5.subLayerIds)
                        {
                            
                            layerIds.push(_loc_7);
                        }
                    }
                }
            }
            if (layerOption === ImageParameters.LAYER_OPTION_SHOW)
            {
                _loc_4 = layerIds ? (layerIds) : (getDefaultVisibleLayers(layerInfos));
            }
            else if (layerOption === ImageParameters.LAYER_OPTION_HIDE)
            {
                for each (_loc_5 in layerInfos)
                {
                    
                    if (!_loc_5.subLayerIds)
                    {
                        if (layerIds)
                        {
                        }
                    }
                    if (layerIds.indexOf(_loc_5.layerId) == -1)
                    {
                        _loc_4.push(_loc_5.layerId);
                    }
                }
            }
            else if (layerOption === ImageParameters.LAYER_OPTION_INCLUDE)
            {
                _loc_4 = getDefaultVisibleLayers(layerInfos);
                if (layerIds)
                {
                    _loc_4 = _loc_4.concat(layerIds);
                }
            }
            else if (layerOption === ImageParameters.LAYER_OPTION_EXCLUDE)
            {
                _loc_4 = getDefaultVisibleLayers(layerInfos);
                for each (_loc_8 in layerIds)
                {
                    
                    _loc_6 = _loc_4.indexOf(_loc_8);
                    if (_loc_6 != -1)
                    {
                        _loc_4.splice(_loc_6, 1);
                    }
                }
            }
            return _loc_4;
        }// end function

        private static function getDefaultVisibleLayers(layerInfos:Array) : Array
        {
            var _loc_3:LayerInfo = null;
            var _loc_2:Array = [];
            for each (_loc_3 in layerInfos)
            {
                
                if (_loc_3.parentLayerId >= 0)
                {
                }
                if (_loc_2.indexOf(_loc_3.parentLayerId) == -1)
                {
                    continue;
                }
                if (_loc_3.defaultVisibility)
                {
                    _loc_2.push(_loc_3.layerId);
                }
            }
            return _loc_2;
        }// end function

        public static function getLayersForScale(scale:Number, layerInfos:Array) : Array
        {
            var _loc_4:LayerInfo = null;
            var _loc_5:Boolean = false;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_3:Array = [];
            if (scale > 0)
            {
            }
            if (layerInfos)
            {
                for each (_loc_4 in layerInfos)
                {
                    
                    if (_loc_4.parentLayerId >= 0)
                    {
                    }
                    if (_loc_3.indexOf(_loc_4.parentLayerId) == -1)
                    {
                        continue;
                    }
                    if (_loc_4.layerId >= 0)
                    {
                        _loc_5 = true;
                        _loc_6 = _loc_4.maxScale;
                        _loc_7 = _loc_4.minScale;
                        if (_loc_6 <= 0)
                        {
                        }
                        if (_loc_7 > 0)
                        {
                            if (_loc_6 > 0)
                            {
                            }
                            if (_loc_7 > 0)
                            {
                                if (_loc_6 <= scale)
                                {
                                }
                                _loc_5 = scale <= _loc_7;
                            }
                            else if (_loc_6 > 0)
                            {
                                _loc_5 = _loc_6 <= scale;
                            }
                            else if (_loc_7 > 0)
                            {
                                _loc_5 = scale <= _loc_7;
                            }
                        }
                        if (_loc_5)
                        {
                            _loc_3.push(_loc_4.layerId);
                        }
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function getDefinitionExpression(layerId:Number, layerDefs:Array) : String
        {
            var _loc_3:String = null;
            var _loc_4:Object = null;
            var _loc_5:LayerDefinition = null;
            if (layerDefs)
            {
                _loc_3 = layerDefs[layerId] as String;
                if (!_loc_3)
                {
                    for each (_loc_4 in layerDefs)
                    {
                        
                        if (_loc_4 is LayerDefinition)
                        {
                            _loc_5 = _loc_4 as LayerDefinition;
                            if (layerId == _loc_5.layerId)
                            {
                                _loc_3 = _loc_5.definition;
                                break;
                            }
                        }
                    }
                }
                if (_loc_3)
                {
                    _loc_3 = StringUtil.trim(_loc_3);
                }
            }
            return _loc_3;
        }// end function

        public static function getLayerDrawingOptions(layerId:Number, layerDrawingOptions:Array) : LayerDrawingOptions
        {
            var _loc_3:LayerDrawingOptions = null;
            var _loc_4:LayerDrawingOptions = null;
            for each (_loc_4 in layerDrawingOptions)
            {
                
                if (layerId == _loc_4.layerId)
                {
                    _loc_3 = _loc_4;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public static function getLayerTimeOptions(layerId:Number, layerTimeOptions:Array) : LayerTimeOptions
        {
            var _loc_3:LayerTimeOptions = null;
            var _loc_4:LayerTimeOptions = null;
            for each (_loc_4 in layerTimeOptions)
            {
                
                if (layerId == _loc_4.layerId)
                {
                    _loc_3 = _loc_4;
                    break;
                }
            }
            return _loc_3;
        }// end function

    }
}
