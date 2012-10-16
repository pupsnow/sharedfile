package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class RasterData extends EventDispatcher implements IJSONSupport
    {
        private var _1268779017format:String;
        private var _1178662034itemID:String;
        private var _116079url:String;

        public function RasterData(url:String = null, format:String = null, itemID:String = null)
        {
            this.url = url;
            this.format = format;
            this.itemID = itemID;
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (this.format)
            {
                _loc_2.format = this.format;
            }
            if (this.itemID)
            {
                _loc_2.itemID = this.itemID;
            }
            if (this.url)
            {
                _loc_2.url = this.url;
            }
            return _loc_2;
        }// end function

        public function get format() : String
        {
            return this._1268779017format;
        }// end function

        public function set format(value:String) : void
        {
            arguments = this._1268779017format;
            if (arguments !== value)
            {
                this._1268779017format = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "format", arguments, value));
                }
            }
            return;
        }// end function

        public function get itemID() : String
        {
            return this._1178662034itemID;
        }// end function

        public function set itemID(value:String) : void
        {
            arguments = this._1178662034itemID;
            if (arguments !== value)
            {
                this._1178662034itemID = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "itemID", arguments, value));
                }
            }
            return;
        }// end function

        public function get url() : String
        {
            return this._116079url;
        }// end function

        public function set url(value:String) : void
        {
            arguments = this._116079url;
            if (arguments !== value)
            {
                this._116079url = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "url", arguments, value));
                }
            }
            return;
        }// end function

        static function toRasterData(obj:Object) : RasterData
        {
            var _loc_2:RasterData = null;
            if (obj)
            {
                _loc_2 = new RasterData;
                _loc_2.format = obj.format;
                _loc_2.itemID = obj.itemID;
                _loc_2.url = obj.url;
            }
            return _loc_2;
        }// end function

    }
}
