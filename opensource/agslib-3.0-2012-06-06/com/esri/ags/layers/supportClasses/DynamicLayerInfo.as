package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class DynamicLayerInfo extends LayerInfo
    {
        private var _source:ILayerSource;

        public function DynamicLayerInfo()
        {
            return;
        }// end function

        public function get source() : ILayerSource
        {
            return this._source;
        }// end function

        public function set source(value:ILayerSource) : void
        {
            this._source = value;
            dispatchEvent(new Event("sourceChanged"));
            return;
        }// end function

        static function fromLayerInfo(layerInfo:LayerInfo) : DynamicLayerInfo
        {
            var _loc_2:DynamicLayerInfo = null;
            var _loc_3:LayerMapSource = null;
            if (layerInfo)
            {
                _loc_2 = new DynamicLayerInfo;
                _loc_2.defaultVisibility = layerInfo.defaultVisibility;
                _loc_2.layerId = layerInfo.layerId;
                _loc_2.maxScale = layerInfo.maxScale;
                _loc_2.minScale = layerInfo.minScale;
                _loc_2.name = layerInfo.name;
                _loc_2.parentLayerId = layerInfo.parentLayerId;
                if (layerInfo.subLayerIds)
                {
                    _loc_2.subLayerIds = layerInfo.subLayerIds.concat();
                }
                _loc_3 = new LayerMapSource();
                _loc_3.mapLayerId = layerInfo.layerId;
                _loc_2.source = _loc_3;
            }
            return _loc_2;
        }// end function

    }
}
