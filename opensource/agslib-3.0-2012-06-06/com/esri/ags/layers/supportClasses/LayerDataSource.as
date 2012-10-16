package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.utils.*;
    import flash.events.*;

    public class LayerDataSource extends EventDispatcher implements ILayerSource, IJSONSupport
    {
        private var _dataSource:IDataSource;
        private var _fields:Array;

        public function LayerDataSource()
        {
            return;
        }// end function

        public function get dataSource() : IDataSource
        {
            return this._dataSource;
        }// end function

        public function set dataSource(value:IDataSource) : void
        {
            this._dataSource = value;
            dispatchEvent(new Event("dataSourceChanged"));
            return;
        }// end function

        public function get fields() : Array
        {
            return this._fields;
        }// end function

        public function set fields(value:Array) : void
        {
            this._fields = value;
            dispatchEvent(new Event("fieldsChanged"));
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:Field = null;
            var _loc_5:Object = null;
            var _loc_2:Object = {type:"dataLayer"};
            if (this.dataSource is IJSONSupport)
            {
                _loc_2.dataSource = (this.dataSource as IJSONSupport).toJSON();
            }
            if (this.fields)
            {
                _loc_3 = [];
                for each (_loc_4 in this.fields)
                {
                    
                    _loc_5 = {name:_loc_4.name};
                    if (_loc_4.alias)
                    {
                        _loc_5.alias = _loc_4.alias;
                    }
                    _loc_3.push(_loc_5);
                }
                _loc_2.fields = _loc_3;
            }
            return _loc_2;
        }// end function

    }
}
