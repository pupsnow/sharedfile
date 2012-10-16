package com.esri.ags.events
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;

    public class FeatureLayerEvent extends Event
    {
        public var featureLayer:FeatureLayer;
        public var adds:Array;
        public var updates:Array;
        public var deletes:Array;
        public var featureEditResults:FeatureEditResults;
        public var features:Array;
        public var featureSet:FeatureSet;
        public var objectIds:Array;
        public var count:Number;
        public var relatedRecords:Object;
        public var selectionMethod:String;
        public static const EDITS_COMPLETE:String = "editsComplete";
        public static const EDITS_STARTING:String = "editsStarting";
        public static const QUERY_COUNT_COMPLETE:String = "queryCountComplete";
        public static const QUERY_FEATURES_COMPLETE:String = "queryFeaturesComplete";
        public static const QUERY_IDS_COMPLETE:String = "queryIdsComplete";
        public static const QUERY_RELATED_FEATURES_COMPLETE:String = "queryRelatedFeaturesComplete";
        public static const SELECTION_CLEAR:String = "selectionClear";
        public static const SELECTION_COMPLETE:String = "selectionComplete";

        public function FeatureLayerEvent(type:String, featureLayer:FeatureLayer = null, cancelable:Boolean = false)
        {
            super(type, false, cancelable);
            this.featureLayer = featureLayer;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new FeatureLayerEvent(type, this.featureLayer, cancelable);
            _loc_1.adds = this.adds;
            _loc_1.count = this.count;
            _loc_1.deletes = this.deletes;
            _loc_1.featureEditResults = this.featureEditResults;
            _loc_1.features = this.features;
            _loc_1.featureSet = this.featureSet;
            _loc_1.objectIds = this.objectIds;
            _loc_1.relatedRecords = this.relatedRecords;
            _loc_1.selectionMethod = this.selectionMethod;
            _loc_1.updates = this.updates;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return formatToString("FeatureLayerEvent", "type", "featureLayer", "cancelable");
        }// end function

    }
}
