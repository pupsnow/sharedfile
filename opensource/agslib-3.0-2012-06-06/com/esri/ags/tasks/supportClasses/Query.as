package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class Query extends EventDispatcher
    {
        private var _1846020210geometry:Geometry;
        private var _351034749groupByFieldsForStatistics:Array;
        private var _717949806maxAllowableOffset:Number;
        private var _1489617159objectIds:Array;
        private var _1359063202orderByFields:Array;
        private var _961734567outFields:Array;
        private var _1929069035outSpatialReference:SpatialReference;
        private var _674237679outStatistics:Array;
        private var _440011761relationParam:String;
        private var _662206914returnGeometry:Boolean = false;
        private var _860946780spatialRelationship:String = "esriSpatialRelIntersects";
        private var _3556653text:String;
        private var _396226647timeExtent:TimeExtent;
        private var _113097959where:String;
        private var _returnM:Boolean;
        private var _returnZ:Boolean;
        public static const SPATIAL_REL_CONTAINS:String = "esriSpatialRelContains";
        public static const SPATIAL_REL_CROSSES:String = "esriSpatialRelCrosses";
        public static const SPATIAL_REL_ENVELOPEINTERSECTS:String = "esriSpatialRelEnvelopeIntersects";
        public static const SPATIAL_REL_INDEXINTERSECTS:String = "esriSpatialRelIndexIntersects";
        public static const SPATIAL_REL_INTERSECTS:String = "esriSpatialRelIntersects";
        public static const SPATIAL_REL_OVERLAPS:String = "esriSpatialRelOverlaps";
        public static const SPATIAL_REL_RELATION:String = "esriSpatialRelRelation";
        public static const SPATIAL_REL_TOUCHES:String = "esriSpatialRelTouches";
        public static const SPATIAL_REL_WITHIN:String = "esriSpatialRelWithin";

        public function Query()
        {
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

        function getShallowClone() : Query
        {
            var _loc_1:* = new Query();
            _loc_1.geometry = this.geometry;
            _loc_1.groupByFieldsForStatistics = this.groupByFieldsForStatistics;
            _loc_1.maxAllowableOffset = this.maxAllowableOffset;
            _loc_1.objectIds = this.objectIds;
            _loc_1.orderByFields = this.orderByFields;
            _loc_1.outFields = this.outFields;
            _loc_1.outSpatialReference = this.outSpatialReference;
            _loc_1.outStatistics = this.outStatistics;
            _loc_1.relationParam = this.relationParam;
            _loc_1.returnGeometry = this.returnGeometry;
            _loc_1.returnM = this.returnM;
            _loc_1.returnZ = this.returnZ;
            _loc_1.spatialRelationship = this.spatialRelationship;
            _loc_1.text = this.text;
            _loc_1.timeExtent = this.timeExtent;
            _loc_1.where = this.where;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get geometry() : Geometry
        {
            return this._1846020210geometry;
        }// end function

        public function set geometry(value:Geometry) : void
        {
            arguments = this._1846020210geometry;
            if (arguments !== value)
            {
                this._1846020210geometry = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "geometry", arguments, value));
                }
            }
            return;
        }// end function

        public function get groupByFieldsForStatistics() : Array
        {
            return this._351034749groupByFieldsForStatistics;
        }// end function

        public function set groupByFieldsForStatistics(value:Array) : void
        {
            arguments = this._351034749groupByFieldsForStatistics;
            if (arguments !== value)
            {
                this._351034749groupByFieldsForStatistics = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "groupByFieldsForStatistics", arguments, value));
                }
            }
            return;
        }// end function

        public function get maxAllowableOffset() : Number
        {
            return this._717949806maxAllowableOffset;
        }// end function

        public function set maxAllowableOffset(value:Number) : void
        {
            arguments = this._717949806maxAllowableOffset;
            if (arguments !== value)
            {
                this._717949806maxAllowableOffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxAllowableOffset", arguments, value));
                }
            }
            return;
        }// end function

        public function get objectIds() : Array
        {
            return this._1489617159objectIds;
        }// end function

        public function set objectIds(value:Array) : void
        {
            arguments = this._1489617159objectIds;
            if (arguments !== value)
            {
                this._1489617159objectIds = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "objectIds", arguments, value));
                }
            }
            return;
        }// end function

        public function get orderByFields() : Array
        {
            return this._1359063202orderByFields;
        }// end function

        public function set orderByFields(value:Array) : void
        {
            arguments = this._1359063202orderByFields;
            if (arguments !== value)
            {
                this._1359063202orderByFields = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "orderByFields", arguments, value));
                }
            }
            return;
        }// end function

        public function get outFields() : Array
        {
            return this._961734567outFields;
        }// end function

        public function set outFields(value:Array) : void
        {
            arguments = this._961734567outFields;
            if (arguments !== value)
            {
                this._961734567outFields = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outFields", arguments, value));
                }
            }
            return;
        }// end function

        public function get outSpatialReference() : SpatialReference
        {
            return this._1929069035outSpatialReference;
        }// end function

        public function set outSpatialReference(value:SpatialReference) : void
        {
            arguments = this._1929069035outSpatialReference;
            if (arguments !== value)
            {
                this._1929069035outSpatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outSpatialReference", arguments, value));
                }
            }
            return;
        }// end function

        public function get outStatistics() : Array
        {
            return this._674237679outStatistics;
        }// end function

        public function set outStatistics(value:Array) : void
        {
            arguments = this._674237679outStatistics;
            if (arguments !== value)
            {
                this._674237679outStatistics = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outStatistics", arguments, value));
                }
            }
            return;
        }// end function

        public function get relationParam() : String
        {
            return this._440011761relationParam;
        }// end function

        public function set relationParam(value:String) : void
        {
            arguments = this._440011761relationParam;
            if (arguments !== value)
            {
                this._440011761relationParam = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "relationParam", arguments, value));
                }
            }
            return;
        }// end function

        public function get returnGeometry() : Boolean
        {
            return this._662206914returnGeometry;
        }// end function

        public function set returnGeometry(value:Boolean) : void
        {
            arguments = this._662206914returnGeometry;
            if (arguments !== value)
            {
                this._662206914returnGeometry = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "returnGeometry", arguments, value));
                }
            }
            return;
        }// end function

        public function get spatialRelationship() : String
        {
            return this._860946780spatialRelationship;
        }// end function

        public function set spatialRelationship(value:String) : void
        {
            arguments = this._860946780spatialRelationship;
            if (arguments !== value)
            {
                this._860946780spatialRelationship = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "spatialRelationship", arguments, value));
                }
            }
            return;
        }// end function

        public function get text() : String
        {
            return this._3556653text;
        }// end function

        public function set text(value:String) : void
        {
            arguments = this._3556653text;
            if (arguments !== value)
            {
                this._3556653text = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "text", arguments, value));
                }
            }
            return;
        }// end function

        public function get timeExtent() : TimeExtent
        {
            return this._396226647timeExtent;
        }// end function

        public function set timeExtent(value:TimeExtent) : void
        {
            arguments = this._396226647timeExtent;
            if (arguments !== value)
            {
                this._396226647timeExtent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timeExtent", arguments, value));
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
