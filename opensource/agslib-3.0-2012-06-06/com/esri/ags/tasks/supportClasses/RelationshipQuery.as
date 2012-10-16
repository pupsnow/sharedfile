package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import flash.events.*;

    public class RelationshipQuery extends EventDispatcher
    {
        private var _definitionExpression:String;
        private var _maxAllowableOffset:Number;
        private var _objectIds:Array;
        private var _outFields:Array;
        private var _outSpatialReference:SpatialReference;
        private var _relationshipId:Number;
        private var _returnGeometry:Boolean;
        private var _returnM:Boolean;
        private var _returnZ:Boolean;

        public function RelationshipQuery()
        {
            return;
        }// end function

        public function get definitionExpression() : String
        {
            return this._definitionExpression;
        }// end function

        public function set definitionExpression(value:String) : void
        {
            if (this._definitionExpression !== value)
            {
                this._definitionExpression = value;
                dispatchEvent(new Event("definitionExpressionChanged"));
            }
            return;
        }// end function

        public function get maxAllowableOffset() : Number
        {
            return this._maxAllowableOffset;
        }// end function

        public function set maxAllowableOffset(value:Number) : void
        {
            if (this._maxAllowableOffset !== value)
            {
                this._maxAllowableOffset = value;
                dispatchEvent(new Event("maxAllowableOffsetChanged"));
            }
            return;
        }// end function

        public function get objectIds() : Array
        {
            return this._objectIds;
        }// end function

        public function set objectIds(value:Array) : void
        {
            this._objectIds = value;
            dispatchEvent(new Event("objectIdsChanged"));
            return;
        }// end function

        public function get outFields() : Array
        {
            return this._outFields;
        }// end function

        public function set outFields(value:Array) : void
        {
            this._outFields = value;
            dispatchEvent(new Event("outFieldsChanged"));
            return;
        }// end function

        public function get outSpatialReference() : SpatialReference
        {
            return this._outSpatialReference;
        }// end function

        public function set outSpatialReference(value:SpatialReference) : void
        {
            this._outSpatialReference = value;
            dispatchEvent(new Event("outSpatialReferenceChanged"));
            return;
        }// end function

        public function get relationshipId() : Number
        {
            return this._relationshipId;
        }// end function

        public function set relationshipId(value:Number) : void
        {
            if (this._relationshipId !== value)
            {
                this._relationshipId = value;
                dispatchEvent(new Event("relationshipIdChanged"));
            }
            return;
        }// end function

        public function get returnGeometry() : Boolean
        {
            return this._returnGeometry;
        }// end function

        public function set returnGeometry(value:Boolean) : void
        {
            if (this._returnGeometry !== value)
            {
                this._returnGeometry = value;
                dispatchEvent(new Event("returnGeometryChanged"));
            }
            return;
        }// end function

        public function get returnM() : Boolean
        {
            return this._returnM;
        }// end function

        public function set returnM(value:Boolean) : void
        {
            if (this._returnM !== value)
            {
                this._returnM = value;
                dispatchEvent(new Event("returnMChanged"));
            }
            return;
        }// end function

        public function get returnZ() : Boolean
        {
            return this._returnZ;
        }// end function

        public function set returnZ(value:Boolean) : void
        {
            if (this._returnZ !== value)
            {
                this._returnZ = value;
                dispatchEvent(new Event("returnZChanged"));
            }
            return;
        }// end function

    }
}
