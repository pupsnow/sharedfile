package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.utils.*;
    import flash.net.*;
    import mx.utils.*;

    public class ImageParameters extends Object
    {
        public var dpi:Number;
        public var dynamicLayerInfos:Array;
        public var extent:Extent;
        public var format:String;
        public var gdbVersion:String;
        public var height:Number;
        public var imageSpatialReference:SpatialReference;
        public var layerDefinitions:Array;
        public var layerDrawingOptions:Array;
        public var layerIds:Array;
        var layerInfos:Array;
        public var layerOption:String;
        public var layerTimeOptions:Array;
        var mapScale:Number;
        var normalize:Boolean;
        public var timeExtent:TimeExtent;
        public var transparent:Boolean = true;
        public var width:Number;
        public static const LAYER_OPTION_EXCLUDE:String = "exclude";
        public static const LAYER_OPTION_HIDE:String = "hide";
        public static const LAYER_OPTION_INCLUDE:String = "include";
        public static const LAYER_OPTION_SHOW:String = "show";
        private static const COLON_OR_SEMI_COLON:RegExp = /[;:]/;

        public function ImageParameters()
        {
            return;
        }// end function

        function appendToURLVariables(urlVariables:URLVariables) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            var _loc_4:int = 0;
            var _loc_5:LayerTimeOptions = null;
            if (!this.dynamicLayerInfos)
            {
                if (this.layerDrawingOptions)
                {
                }
            }
            if (this.layerDrawingOptions.length > 0)
            {
                urlVariables.dynamicLayers = this.getDynamicLayersJSON();
            }
            else
            {
                if (this.layerOption)
                {
                }
                if (this.layerIds)
                {
                    if (this.layerOption == LAYER_OPTION_SHOW)
                    {
                    }
                    if (this.layerIds.length == 0)
                    {
                        urlVariables.layers = this.layerOption + ":-1";
                    }
                    else
                    {
                        urlVariables.layers = this.layerOption + ":" + this.layerIds.join();
                    }
                }
                if (this.layerDefinitions)
                {
                }
                if (this.layerDefinitions.length > 0)
                {
                    if (hasColonOrSemicolon(this.layerDefinitions))
                    {
                        _loc_2 = JSONUtil.encode(LayerDefinition.getLayerDefsAsJSON(this.layerDefinitions));
                    }
                    else
                    {
                        _loc_2 = LayerDefinition.getLayerDefsAsString(this.layerDefinitions);
                    }
                    if (_loc_2)
                    {
                    }
                    if (_loc_2.length > 0)
                    {
                        urlVariables.layerDefs = _loc_2;
                    }
                }
                if (this.layerTimeOptions)
                {
                }
                if (this.layerTimeOptions.length > 0)
                {
                    _loc_3 = {};
                    _loc_4 = 0;
                    while (_loc_4 < this.layerTimeOptions.length)
                    {
                        
                        _loc_5 = this.layerTimeOptions[_loc_4] as LayerTimeOptions;
                        if (_loc_5)
                        {
                        }
                        if (isFinite(_loc_5.layerId))
                        {
                            _loc_3[_loc_5.layerId] = _loc_5;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    urlVariables.layerTimeOptions = JSONUtil.encode(_loc_3);
                }
            }
            if (isFinite(this.width))
            {
                isFinite(this.width);
            }
            if (isFinite(this.height))
            {
                urlVariables.size = this.width + "," + this.height;
            }
            if (this.format)
            {
                urlVariables.format = this.format;
            }
            if (this.gdbVersion)
            {
                urlVariables.gdbVersion = this.gdbVersion;
            }
            urlVariables.transparent = this.transparent;
            if (this.extent)
            {
                if (this.normalize)
                {
                    this.extent = this.extent.normalize(true) as Extent;
                }
                urlVariables.bbox = this.extent.xmin + "," + this.extent.ymin + "," + this.extent.xmax + "," + this.extent.ymax;
                if (this.extent.spatialReference)
                {
                    urlVariables.bboxSR = this.extent.spatialReference.toSR();
                }
            }
            if (isFinite(this.dpi))
            {
                urlVariables.dpi = this.dpi;
            }
            if (this.imageSpatialReference)
            {
                urlVariables.imageSR = this.imageSpatialReference.toSR();
            }
            else
            {
                if (this.extent)
                {
                }
                if (this.extent.spatialReference)
                {
                    urlVariables.imageSR = this.extent.spatialReference.toSR();
                }
            }
            if (this.timeExtent)
            {
                urlVariables.time = this.timeExtent.toTimeParam();
            }
            return;
        }// end function

        private function getDynamicLayersJSON() : String
        {
            var _loc_1:String = null;
            var _loc_6:LayerInfo = null;
            var _loc_7:Number = NaN;
            var _loc_8:Object = null;
            var _loc_9:String = null;
            var _loc_10:LayerDrawingOptions = null;
            var _loc_11:LayerTimeOptions = null;
            var _loc_2:Array = [];
            var _loc_3:* = this.dynamicLayerInfos ? (this.dynamicLayerInfos) : (this.layerInfos);
            var _loc_4:* = AGSUtil.getVisibleLayers(this.layerIds, _loc_3, this.layerOption);
            var _loc_5:* = AGSUtil.getLayersForScale(this.mapScale, _loc_3);
            for each (_loc_6 in _loc_3)
            {
                
                if (!_loc_6.subLayerIds)
                {
                    _loc_7 = _loc_6.layerId;
                    if (_loc_4.indexOf(_loc_7) != -1)
                    {
                    }
                    if (_loc_5.indexOf(_loc_7) != -1)
                    {
                        _loc_8 = {id:_loc_7};
                        if (_loc_6 is DynamicLayerInfo)
                        {
                            _loc_8.source = (_loc_6 as DynamicLayerInfo).source;
                        }
                        else
                        {
                            _loc_8.source = {type:"mapLayer", mapLayerId:_loc_7};
                        }
                        _loc_9 = AGSUtil.getDefinitionExpression(_loc_7, this.layerDefinitions);
                        if (_loc_9)
                        {
                            _loc_8.definitionExpression = _loc_9;
                        }
                        _loc_10 = AGSUtil.getLayerDrawingOptions(_loc_7, this.layerDrawingOptions);
                        if (_loc_10)
                        {
                            _loc_8.drawingInfo = _loc_10;
                        }
                        _loc_11 = AGSUtil.getLayerTimeOptions(_loc_7, this.layerTimeOptions);
                        if (_loc_11)
                        {
                            _loc_8.layerTimeOptions = _loc_11;
                        }
                        _loc_2.push(_loc_8);
                    }
                }
            }
            _loc_1 = JSONUtil.encode(_loc_2);
            return _loc_1;
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        private static function hasColonOrSemicolon(layerDefs:Array) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:Object = null;
            var _loc_4:LayerDefinition = null;
            for each (_loc_3 in layerDefs)
            {
                
                if (_loc_3 is String)
                {
                    _loc_2 = (_loc_3 as String).search(COLON_OR_SEMI_COLON) != -1;
                }
                else if (_loc_3 is LayerDefinition)
                {
                    _loc_4 = _loc_3 as LayerDefinition;
                    if (isFinite(_loc_4.layerId))
                    {
                        isFinite(_loc_4.layerId);
                    }
                    if (_loc_4.definition)
                    {
                        _loc_2 = _loc_4.definition.search(COLON_OR_SEMI_COLON) != -1;
                    }
                }
                if (_loc_2)
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

    }
}
