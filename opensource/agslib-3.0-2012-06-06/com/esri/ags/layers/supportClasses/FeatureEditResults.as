package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class FeatureEditResults extends EventDispatcher
    {
        private var _1289186283addResults:Array;
        private var _892774347deleteResults:Array;
        private var _398403859updateResults:Array;

        public function FeatureEditResults()
        {
            return;
        }// end function

        public function get addResults() : Array
        {
            return this._1289186283addResults;
        }// end function

        public function set addResults(value:Array) : void
        {
            arguments = this._1289186283addResults;
            if (arguments !== value)
            {
                this._1289186283addResults = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addResults", arguments, value));
                }
            }
            return;
        }// end function

        public function get deleteResults() : Array
        {
            return this._892774347deleteResults;
        }// end function

        public function set deleteResults(value:Array) : void
        {
            arguments = this._892774347deleteResults;
            if (arguments !== value)
            {
                this._892774347deleteResults = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteResults", arguments, value));
                }
            }
            return;
        }// end function

        public function get updateResults() : Array
        {
            return this._398403859updateResults;
        }// end function

        public function set updateResults(value:Array) : void
        {
            arguments = this._398403859updateResults;
            if (arguments !== value)
            {
                this._398403859updateResults = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "updateResults", arguments, value));
                }
            }
            return;
        }// end function

        static function toFeatureEditResults(obj:Object) : FeatureEditResults
        {
            var _loc_2:FeatureEditResults = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            if (obj)
            {
                _loc_2 = new FeatureEditResults;
                if (obj.addResults)
                {
                    _loc_2.addResults = [];
                    for each (_loc_3 in obj.addResults)
                    {
                        
                        _loc_2.addResults.push(FeatureEditResult.toFeatureEditResult(_loc_3));
                    }
                }
                if (obj.deleteResults)
                {
                    _loc_2.deleteResults = [];
                    for each (_loc_4 in obj.deleteResults)
                    {
                        
                        _loc_2.deleteResults.push(FeatureEditResult.toFeatureEditResult(_loc_4));
                    }
                }
                if (obj.updateResults)
                {
                    _loc_2.updateResults = [];
                    for each (_loc_5 in obj.updateResults)
                    {
                        
                        _loc_2.updateResults.push(FeatureEditResult.toFeatureEditResult(_loc_5));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
