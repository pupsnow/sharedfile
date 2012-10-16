package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class TableDataSource extends EventDispatcher implements IDataSource, IJSONSupport
    {
        private var _dataSourceName:String;
        private var _workspaceId:String;
        private var _gdbVersion:String;

        public function TableDataSource()
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
            var _loc_2:Object = {type:"table"};
            _loc_2.dataSourceName = this.dataSourceName;
            _loc_2.workspaceId = this.workspaceId;
            if (this.gdbVersion)
            {
                _loc_2.gdbVersion = this.gdbVersion;
            }
            return _loc_2;
        }// end function

    }
}
