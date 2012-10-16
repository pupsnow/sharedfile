package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class ServiceAreaSolveResult extends EventDispatcher
    {
        private var _536683137facilities:Array;
        private var _462094004messages:Array;
        private var _2080244404pointBarriers:Array;
        private var _252377468polylineBarriers:Array;
        private var _1493912842polygonBarriers:Array;
        private var _429874555serviceAreaPolygons:Array;
        private var _445647857serviceAreaPolylines:Array;

        public function ServiceAreaSolveResult()
        {
            return;
        }// end function

        public function get facilities() : Array
        {
            return this._536683137facilities;
        }// end function

        public function set facilities(value:Array) : void
        {
            arguments = this._536683137facilities;
            if (arguments !== value)
            {
                this._536683137facilities = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "facilities", arguments, value));
                }
            }
            return;
        }// end function

        public function get messages() : Array
        {
            return this._462094004messages;
        }// end function

        public function set messages(value:Array) : void
        {
            arguments = this._462094004messages;
            if (arguments !== value)
            {
                this._462094004messages = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "messages", arguments, value));
                }
            }
            return;
        }// end function

        public function get pointBarriers() : Array
        {
            return this._2080244404pointBarriers;
        }// end function

        public function set pointBarriers(value:Array) : void
        {
            arguments = this._2080244404pointBarriers;
            if (arguments !== value)
            {
                this._2080244404pointBarriers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pointBarriers", arguments, value));
                }
            }
            return;
        }// end function

        public function get polylineBarriers() : Array
        {
            return this._252377468polylineBarriers;
        }// end function

        public function set polylineBarriers(value:Array) : void
        {
            arguments = this._252377468polylineBarriers;
            if (arguments !== value)
            {
                this._252377468polylineBarriers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "polylineBarriers", arguments, value));
                }
            }
            return;
        }// end function

        public function get polygonBarriers() : Array
        {
            return this._1493912842polygonBarriers;
        }// end function

        public function set polygonBarriers(value:Array) : void
        {
            arguments = this._1493912842polygonBarriers;
            if (arguments !== value)
            {
                this._1493912842polygonBarriers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "polygonBarriers", arguments, value));
                }
            }
            return;
        }// end function

        public function get serviceAreaPolygons() : Array
        {
            return this._429874555serviceAreaPolygons;
        }// end function

        public function set serviceAreaPolygons(value:Array) : void
        {
            arguments = this._429874555serviceAreaPolygons;
            if (arguments !== value)
            {
                this._429874555serviceAreaPolygons = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "serviceAreaPolygons", arguments, value));
                }
            }
            return;
        }// end function

        public function get serviceAreaPolylines() : Array
        {
            return this._445647857serviceAreaPolylines;
        }// end function

        public function set serviceAreaPolylines(value:Array) : void
        {
            arguments = this._445647857serviceAreaPolylines;
            if (arguments !== value)
            {
                this._445647857serviceAreaPolylines = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "serviceAreaPolylines", arguments, value));
                }
            }
            return;
        }// end function

    }
}
