package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;

    public class QueryDataSource extends EventDispatcher implements IDataSource, IJSONSupport
    {
        private var _geometryType:String;
        private var _oidFields:Array;
        private var _query:String;
        private var _spatialReference:SpatialReference;
        private var _workspaceId:String;

        public function QueryDataSource()
        {
            return;
        }// end function

        public function get geometryType() : String
        {
            return this._geometryType;
        }// end function

        public function set geometryType(value:String) : void
        {
            if (this._geometryType !== value)
            {
                this._geometryType = value;
                dispatchEvent(new Event("geometryTypeChanged"));
            }
            return;
        }// end function

        public function get oidFields() : Array
        {
            return this._oidFields;
        }// end function

        public function set oidFields(value:Array) : void
        {
            this._oidFields = value;
            dispatchEvent(new Event("oidFieldsChanged"));
            return;
        }// end function

        public function get query() : String
        {
            return this._query;
        }// end function

        public function set query(value:String) : void
        {
            if (this._query !== value)
            {
                this._query = value;
                dispatchEvent(new Event("queryChanged"));
            }
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this._spatialReference;
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            this._spatialReference = value;
            dispatchEvent(new Event("spatialReferenceChanged"));
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
            var _loc_2:Object = {type:"queryTable"};
            _loc_2.query = this.query;
            _loc_2.workspaceId = this.workspaceId;
            if (this.oidFields)
            {
                _loc_2.oidFields = this.oidFields.join();
            }
            if (this.geometryType)
            {
                _loc_2.geometryType = this.geometryType;
            }
            if (this.spatialReference)
            {
                _loc_2.spatialReference = this.spatialReference.toJSON();
            }
            return _loc_2;
        }// end function

    }
}
