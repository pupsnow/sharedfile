package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class AllDetails extends EventDispatcher
    {
        private var _1151687008layersDetails:Array;
        private var _177258467tablesDetails:Array;

        public function AllDetails()
        {
            return;
        }// end function

        public function get layersDetails() : Array
        {
            return this._1151687008layersDetails;
        }// end function

        public function set layersDetails(value:Array) : void
        {
            arguments = this._1151687008layersDetails;
            if (arguments !== value)
            {
                this._1151687008layersDetails = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layersDetails", arguments, value));
                }
            }
            return;
        }// end function

        public function get tablesDetails() : Array
        {
            return this._177258467tablesDetails;
        }// end function

        public function set tablesDetails(value:Array) : void
        {
            arguments = this._177258467tablesDetails;
            if (arguments !== value)
            {
                this._177258467tablesDetails = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tablesDetails", arguments, value));
                }
            }
            return;
        }// end function

        static function toAllDetails(obj:Object) : AllDetails
        {
            var _loc_2:AllDetails = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            if (obj)
            {
                _loc_2 = new AllDetails;
                if (obj.layers)
                {
                    _loc_2.layersDetails = [];
                    for each (_loc_3 in obj.layers)
                    {
                        
                        _loc_2.layersDetails.push(LayerDetails.toLayerDetails(_loc_3));
                    }
                }
                if (obj.tables)
                {
                    _loc_2.tablesDetails = [];
                    for each (_loc_4 in obj.tables)
                    {
                        
                        _loc_2.tablesDetails.push(TableDetails.toTableDetails(_loc_4));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
