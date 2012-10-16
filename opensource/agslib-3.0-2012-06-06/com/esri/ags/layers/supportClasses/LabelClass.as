package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class LabelClass extends EventDispatcher implements IJSONSupport
    {
        private var _1323184980labelExpression:String;
        private var _1737186038labelOptions:LabelOptions;
        private var _1253983825labelPlacement:String;
        private var _396505670maxScale:Number = 0;
        private var _1379690984minScale:Number = 0;
        private var _1959650322useCodedValues:Boolean = true;
        private var _113097959where:String;
        private static const DEFAULT_LABEL_OPTIONS:LabelOptions = new LabelOptions();

        public function LabelClass()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            _loc_2.labelExpression = this.labelExpression;
            _loc_2.symbol = this.labelOptions ? (this.labelOptions.toJSON()) : (DEFAULT_LABEL_OPTIONS.toJSON());
            _loc_2.labelPlacement = this.labelPlacement;
            if (this.maxScale > 0)
            {
                _loc_2.maxScale = this.maxScale;
            }
            if (this.minScale > 0)
            {
                _loc_2.minScale = this.minScale;
            }
            _loc_2.useCodedValues = this.useCodedValues;
            if (this.where)
            {
                _loc_2.where = this.where;
            }
            return _loc_2;
        }// end function

        public function get labelExpression() : String
        {
            return this._1323184980labelExpression;
        }// end function

        public function set labelExpression(value:String) : void
        {
            arguments = this._1323184980labelExpression;
            if (arguments !== value)
            {
                this._1323184980labelExpression = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelExpression", arguments, value));
                }
            }
            return;
        }// end function

        public function get labelOptions() : LabelOptions
        {
            return this._1737186038labelOptions;
        }// end function

        public function set labelOptions(value:LabelOptions) : void
        {
            arguments = this._1737186038labelOptions;
            if (arguments !== value)
            {
                this._1737186038labelOptions = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelOptions", arguments, value));
                }
            }
            return;
        }// end function

        public function get labelPlacement() : String
        {
            return this._1253983825labelPlacement;
        }// end function

        public function set labelPlacement(value:String) : void
        {
            arguments = this._1253983825labelPlacement;
            if (arguments !== value)
            {
                this._1253983825labelPlacement = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelPlacement", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxScale() : Number
        {
            return this._396505670maxScale;
        }// end function

        public function set maxScale(value:Number) : void
        {
            arguments = this._396505670maxScale;
            if (arguments !== value)
            {
                this._396505670maxScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxScale", arguments, value));
                }
            }
            return;
        }// end function

        public function get minScale() : Number
        {
            return this._1379690984minScale;
        }// end function

        public function set minScale(value:Number) : void
        {
            arguments = this._1379690984minScale;
            if (arguments !== value)
            {
                this._1379690984minScale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minScale", arguments, value));
                }
            }
            return;
        }// end function

        public function get useCodedValues() : Boolean
        {
            return this._1959650322useCodedValues;
        }// end function

        public function set useCodedValues(value:Boolean) : void
        {
            arguments = this._1959650322useCodedValues;
            if (arguments !== value)
            {
                this._1959650322useCodedValues = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "useCodedValues", arguments, value));
                }
            }
            return;
        }// end function

        public function get where() : String
        {
            return this._113097959where;
        }// end function

        public function set where(value:String) : void
        {
            arguments = this._113097959where;
            if (arguments !== value)
            {
                this._113097959where = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "where", arguments, value));
                }
            }
            return;
        }// end function

    }
}
