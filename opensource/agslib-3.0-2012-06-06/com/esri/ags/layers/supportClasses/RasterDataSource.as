package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class RasterDataSource extends EventDispatcher implements IDataSource, IJSONSupport
    {
        private var _dataSourceName:String;
        private var _workspaceId:String;

        public function RasterDataSource()
        {
            return;
        }// end function

        public function get dataSourceName() : String
        {
            return this._dataSourceName;
        }// end function

        public function set dataSourceName(value:String) : void
        {
            if (this._dataSourceName !== value)
            {
                this._dataSourceName = value;
                dispatchEvent(new Event("dataSourceNameChanged"));
            }
            return;
        }// end function

        public function get workspaceId() : String
        {
            return this._workspaceId;
        }// end function

        public function set workspaceId(value:String) : void
        {
            if (this._workspaceId !== value)
            {
                this._workspaceId = value;
                dispatchEvent(new Event("workspaceIdChanged"));
            }
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"raster"};
            _loc_2.dataSourceName = this.dataSourceName;
            _loc_2.workspaceId = this.workspaceId;
            return _loc_2;
        }// end function

    }
}
