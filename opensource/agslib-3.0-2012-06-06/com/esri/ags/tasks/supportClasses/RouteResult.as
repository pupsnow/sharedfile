package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;
    import mx.events.*;

    public class RouteResult extends EventDispatcher
    {
        private var _224454868directions:DirectionsFeatureSet;
        private var _108704329route:Graphic;
        private var _167466100routeName:String;
        private var _109770929stops:Array;

        public function RouteResult()
        {
            return;
        }// end function

        public function get directions() : DirectionsFeatureSet
        {
            return this._224454868directions;
        }// end function

        public function set directions(value:DirectionsFeatureSet) : void
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

        public function get route() : Graphic
        {
            return this._108704329route;
        }// end function

        public function set route(value:Graphic) : void
        {
            arguments = this._108704329route;
            if (arguments !== value)
            {
                this._108704329route = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "route", arguments, value));
                }
            }
            return;
        }// end function

        public function get routeName() : String
        {
            return this._167466100routeName;
        }// end function

        public function set routeName(value:String) : void
        {
            arguments = this._167466100routeName;
            if (arguments !== value)
            {
                this._167466100routeName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "routeName", arguments, value));
                }
            }
            return;
        }// end function

        public function get stops() : Array
        {
            return this._109770929stops;
        }// end function

        public function set stops(value:Array) : void
        {
            arguments = this._109770929stops;
            if (arguments !== value)
            {
                this._109770929stops = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "stops", arguments, value));
                }
            }
            return;
        }// end function

    }
}
