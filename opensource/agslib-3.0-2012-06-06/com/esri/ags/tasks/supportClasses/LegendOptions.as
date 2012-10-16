package com.esri.ags.tasks.supportClasses
{

    public class LegendOptions extends Object implements IJSONSupport
    {
        public var legendLayers:Array;

        public function LegendOptions()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:LegendLayer = null;
            var _loc_5:Object = null;
            var _loc_2:Object = {};
            if (this.legendLayers)
            {
                _loc_3 = [];
                for each (_loc_4 in this.legendLayers)
                {
                    
                    if (_loc_4.layerId)
                    {
                        _loc_5 = {id:_loc_4.layerId};
                        if (_loc_4.subLayerIds)
                        {
                            _loc_5.subLayerIds = _loc_4.subLayerIds.concat();
                        }
                        _loc_3.push(_loc_5);
                    }
                }
                _loc_2.operationalLayers = _loc_3;
            }
            return _loc_2;
        }// end function

    }
}
