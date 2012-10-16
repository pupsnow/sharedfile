package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class RouteSolveResult extends EventDispatcher
    {
        private var _1901243757routeResults:Array;
        private var _2080244404pointBarriers:Array;
        private var _252377468polylineBarriers:Array;
        private var _1493912842polygonBarriers:Array;
        private var _462094004messages:Array;

        public function RouteSolveResult()
        {
            return;
        }// end function

        public function get routeResults() : Array
        {
            return this._1901243757routeResults;
        }// end function

        public function set routeResults(value:Array) : void
        {
            arguments = this._1901243757routeResults;
            if (arguments !== value)
            {
                this._1901243757routeResults = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "routeResults", arguments, value));
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

    }
}
