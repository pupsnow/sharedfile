package com.esri.ags.layers.supportClasses
{
    import mx.utils.*;

    public class LayerDefinition extends Object
    {
        public var definition:String;
        public var layerId:Number;

        public function LayerDefinition()
        {
            return;
        }// end function

        static function getLayerDefsAsJSON(layerDefs:Array) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_7:LayerDefinition = null;
            var _loc_2:Object = {};
            var _loc_3:int = 0;
            while (_loc_3 < layerDefs.length)
            {
                
                _loc_4 = layerDefs[_loc_3];
                _loc_5 = null;
                if (_loc_4 is String)
                {
                    _loc_5 = _loc_4 as String;
                    _loc_6 = _loc_3;
                }
                else if (_loc_4 is LayerDefinition)
                {
                    _loc_7 = _loc_4 as LayerDefinition;
                    if (isFinite(_loc_7.layerId))
                    {
                        _loc_5 = _loc_7.definition;
                        _loc_6 = _loc_7.layerId;
                    }
                }
                if (_loc_5)
                {
                }
                if (_loc_5.length > 0)
                {
                    _loc_5 = StringUtil.trim(_loc_5);
                    if (_loc_5)
                    {
                    }
                    if (_loc_5.length > 0)
                    {
                        _loc_2[_loc_6] = _loc_5;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        static function getLayerDefsAsString(layerDefs:Array) : String
        {
            var _loc_4:Object = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_7:LayerDefinition = null;
            var _loc_2:Array = [];
            var _loc_3:int = 0;
            while (_loc_3 < layerDefs.length)
            {
                
                _loc_4 = layerDefs[_loc_3];
                _loc_5 = null;
                if (_loc_4 is String)
                {
                    _loc_5 = _loc_4 as String;
                    _loc_6 = _loc_3;
                }
                else if (_loc_4 is LayerDefinition)
                {
                    _loc_7 = _loc_4 as LayerDefinition;
                    if (isFinite(_loc_7.layerId))
                    {
                        _loc_5 = _loc_7.definition;
                        _loc_6 = _loc_7.layerId;
                    }
                }
                if (_loc_5)
                {
                }
                if (_loc_5.length > 0)
                {
                    _loc_5 = StringUtil.trim(_loc_5);
                    if (_loc_5)
                    {
                    }
                    if (_loc_5.length > 0)
                    {
                        _loc_2.push(_loc_6 + ":" + _loc_5);
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2.join(";");
        }// end function

    }
}
