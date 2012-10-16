package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class ClosestFacilitySolveResult extends EventDispatcher
    {
        private var _224454868directions:Array;
        private var _536683137facilities:Array;
        private var _1598466591incidents:Array;
        private var _462094004messages:Array;
        private var _2080244404pointBarriers:Array;
        private var _252377468polylineBarriers:Array;
        private var _1493912842polygonBarriers:Array;
        private var _925132982routes:Array;

        public function ClosestFacilitySolveResult()
        {
            return;
        }// end function

        public function get directions() : Array
        {
            return this._224454868directions;
        }// end function

        public function set directions(value:Array) : void
        {
            arguments = this._224454868directions;
            if (arguments !== value)
            {
                this._224454868directions = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "directions", arguments, value));
                }
            }
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

        public function get incidents() : Array
        {
            return this._1598466591incidents;
        }// end function

        public function set incidents(value:Array) : void
        {
            arguments = this._1598466591incidents;
            if (arguments !== value)
            {
                this._1598466591incidents = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "incidents", arguments, value));
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

        public function get routes() : Array
        {
            return this._925132982routes;
        }// end function

        public function set routes(value:Array) : void
        {
            arguments = this._925132982routes;
            if (arguments !== value)
            {
                this._925132982routes = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "routes", arguments, value));
                }
            }
            return;
        }// end function

    }
}
