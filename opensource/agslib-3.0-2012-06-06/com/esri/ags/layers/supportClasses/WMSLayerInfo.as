package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;

    public class WMSLayerInfo extends EventDispatcher
    {
        private var _3373707name:String;
        private var _110371416title:String;
        private var _1732898850abstract:String;
        private var _1289044182extent:Extent;
        private var _603336798subLayers:Array;

        public function WMSLayerInfo()
        {
            return;
        }// end function

        public function get name() : String
        {
            return this._3373707name;
        }// end function

        public function set name(value:String) : void
        {
            arguments = this._3373707name;
            if (arguments !== value)
            {
                this._3373707name = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", arguments, value));
                }
            }
            return;
        }// end function

        public function get title() : String
        {
            return this._110371416title;
        }// end function

        public function set title(value:String) : void
        {
            arguments = this._110371416title;
            if (arguments !== value)
            {
                this._110371416title = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "title", arguments, value));
                }
            }
            return;
        }// end function

        public function get abstract() : String
        {
            return this._1732898850abstract;
        }// end function

        public function set abstract(value:String) : void
        {
            arguments = this._1732898850abstract;
            if (arguments !== value)
            {
                this._1732898850abstract = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "abstract", arguments, value));
                }
            }
            return;
        }// end function

        public function get extent() : Extent
        {
            return this._1289044182extent;
        }// end function

        public function set extent(value:Extent) : void
        {
            arguments = this._1289044182extent;
            if (arguments !== value)
            {
                this._1289044182extent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "extent", arguments, value));
                }
            }
            return;
        }// end function

        public function get subLayers() : Array
        {
            return this._603336798subLayers;
        }// end function

        public function set subLayers(value:Array) : void
        {
            arguments = this._603336798subLayers;
            if (arguments !== value)
            {
                this._603336798subLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subLayers", arguments, value));
                }
            }
            return;
        }// end function

        static function toWMSLayerInfo(obj:Object) : WMSLayerInfo
        {
            var _loc_2:WMSLayerInfo = null;
            if (obj)
            {
                _loc_2 = new WMSLayerInfo;
                _loc_2.abstract = obj.abstract;
                _loc_2.name = obj.name;
                _loc_2.title = obj.title;
            }
            return _loc_2;
        }// end function

    }
}
