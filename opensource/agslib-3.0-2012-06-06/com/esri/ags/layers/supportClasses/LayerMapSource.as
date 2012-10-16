package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class LayerMapSource extends EventDispatcher implements ILayerSource, IJSONSupport
    {
        private var _mapLayerId:Number;
        private var _gdbVersion:String;

        public function LayerMapSource()
        {
            return;
        }// end function

        public function get mapLayerId() : Number
        {
            return this._mapLayerId;
        }// end function

        public function set mapLayerId(value:Number) : void
        {
            if (this._mapLayerId !== value)
            {
                this._mapLayerId = value;
                dispatchEvent(new Event("mapLayerIdChanged"));
            }
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

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"mapLayer"};
            _loc_2.mapLayerId = this.mapLayerId;
            if (this.gdbVersion)
            {
                _loc_2.gdbVersion = this.gdbVersion;
            }
            return _loc_2;
        }// end function

    }
}
