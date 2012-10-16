package com.esri.ags.events
{
    import com.esri.ags.*;
    import flash.events.*;

    public class QueryEvent extends Event
    {
        public var count:Number;
        public var featureSet:FeatureSet;
        public var relatedRecords:Object;
        public var objectIds:Array;
        public static const EXECUTE_COMPLETE:String = "executeComplete";
        public static const EXECUTE_FOR_COUNT_COMPLETE:String = "executeForCountComplete";
        public static const EXECUTE_FOR_IDS_COMPLETE:String = "executeForIdsComplete";
        public static const EXECUTE_RELATIONSHIP_QUERY_COMPLETE:String = "executeRelationshipQueryComplete";

        public function QueryEvent(type:String, count:Number = NaN, featureSet:FeatureSet = null, objectIds:Array = null, relatedRecords:Object = null)
        {
            super(type);
            this.count = count;
            this.featureSet = featureSet;
            this.objectIds = objectIds;
            this.relatedRecords = relatedRecords;
            return;
        }// end function

        override public function clone() : Event
        {
            return new QueryEvent(type, this.count, this.featureSet, this.objectIds, this.relatedRecords);
        }// end function

        override public function toString() : String
        {
            return formatToString("QueryEvent", "type", "count", "featureSet", "objectIds", "relatedRecords");
        }// end function

    }
}
