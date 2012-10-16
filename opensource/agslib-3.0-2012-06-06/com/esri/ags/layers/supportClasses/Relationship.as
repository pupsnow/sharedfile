package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class Relationship extends EventDispatcher
    {
        private var _845213070cardinality:String;
        private var _3355id:Number;
        private var _221334403isComposite:Boolean;
        private var _477705691keyField:String;
        private var _719958026keyFieldInRelationshipTable:String;
        private var _3373707name:String;
        private var _586452702relatedTableId:Number;
        private var _565558321relationshipTableId:Number;
        private var _3506294role:String;

        public function Relationship()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get cardinality() : String
        {
            return this._845213070cardinality;
        }// end function

        public function set cardinality(value:String) : void
        {
            arguments = this._845213070cardinality;
            if (arguments !== value)
            {
                this._845213070cardinality = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cardinality", arguments, value));
                }
            }
            return;
        }// end function

        public function get id() : Number
        {
            return this._3355id;
        }// end function

        public function set id(value:Number) : void
        {
            arguments = this._3355id;
            if (arguments !== value)
            {
                this._3355id = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", arguments, value));
                }
            }
            return;
        }// end function

        public function get isComposite() : Boolean
        {
            return this._221334403isComposite;
        }// end function

        public function set isComposite(value:Boolean) : void
        {
            arguments = this._221334403isComposite;
            if (arguments !== value)
            {
                this._221334403isComposite = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isComposite", arguments, value));
                }
            }
            return;
        }// end function

        public function get keyField() : String
        {
            return this._477705691keyField;
        }// end function

        public function set keyField(value:String) : void
        {
            arguments = this._477705691keyField;
            if (arguments !== value)
            {
                this._477705691keyField = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "keyField", arguments, value));
                }
            }
            return;
        }// end function

        public function get keyFieldInRelationshipTable() : String
        {
            return this._719958026keyFieldInRelationshipTable;
        }// end function

        public function set keyFieldInRelationshipTable(value:String) : void
        {
            arguments = this._719958026keyFieldInRelationshipTable;
            if (arguments !== value)
            {
                this._719958026keyFieldInRelationshipTable = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "keyFieldInRelationshipTable", arguments, value));
                }
            }
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

        public function get relatedTableId() : Number
        {
            return this._586452702relatedTableId;
        }// end function

        public function set relatedTableId(value:Number) : void
        {
            arguments = this._586452702relatedTableId;
            if (arguments !== value)
            {
                this._586452702relatedTableId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "relatedTableId", arguments, value));
                }
            }
            return;
        }// end function

        public function get relationshipTableId() : Number
        {
            return this._565558321relationshipTableId;
        }// end function

        public function set relationshipTableId(value:Number) : void
        {
            arguments = this._565558321relationshipTableId;
            if (arguments !== value)
            {
                this._565558321relationshipTableId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "relationshipTableId", arguments, value));
                }
            }
            return;
        }// end function

        public function get role() : String
        {
            return this._3506294role;
        }// end function

        public function set role(value:String) : void
        {
            arguments = this._3506294role;
            if (arguments !== value)
            {
                this._3506294role = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "role", arguments, value));
                }
            }
            return;
        }// end function

        static function toRelationship(obj:Object) : Relationship
        {
            var _loc_2:Relationship = null;
            if (obj)
            {
                _loc_2 = new Relationship;
                _loc_2.cardinality = obj.cardinality;
                _loc_2.id = obj.id;
                _loc_2.isComposite = obj.isComposite;
                _loc_2.keyField = obj.keyField;
                _loc_2.keyFieldInRelationshipTable = obj.keyFieldInRelationshipTable;
                _loc_2.name = obj.name;
                _loc_2.relatedTableId = obj.relatedTableId;
                _loc_2.relationshipTableId = obj.relationshipTableId;
                _loc_2.role = obj.role;
            }
            return _loc_2;
        }// end function

    }
}
