package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class Field extends EventDispatcher
    {
        private var _92902992alias:String;
        private var _1326197564domain:IDomain;
        private var _1602416228editable:Boolean;
        private var _1106363674length:int;
        private var _3373707name:String;
        private var _1905967263nullable:Boolean;
        private var _3575610type:String;
        public static const TYPE_INTEGER:String = "esriFieldTypeInteger";
        public static const TYPE_SMALL_INTEGER:String = "esriFieldTypeSmallInteger";
        public static const TYPE_DOUBLE:String = "esriFieldTypeDouble";
        public static const TYPE_SINGLE:String = "esriFieldTypeSingle";
        public static const TYPE_STRING:String = "esriFieldTypeString";
        public static const TYPE_DATE:String = "esriFieldTypeDate";
        public static const TYPE_GEOMETRY:String = "esriFieldTypeGeometry";
        public static const TYPE_OID:String = "esriFieldTypeOID";
        public static const TYPE_BLOB:String = "esriFieldTypeBlob";
        public static const TYPE_GLOBAL_ID:String = "esriFieldTypeGlobalID";
        public static const TYPE_RASTER:String = "esriFieldTypeRaster";
        public static const TYPE_GUID:String = "esriFieldTypeGUID";
        public static const TYPE_XML:String = "esriFieldTypeXML";

        public function Field()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get alias() : String
        {
            return this._92902992alias;
        }// end function

        public function set alias(value:String) : void
        {
            arguments = this._92902992alias;
            if (arguments !== value)
            {
                this._92902992alias = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "alias", arguments, value));
                }
            }
            return;
        }// end function

        public function get domain() : IDomain
        {
            return this._1326197564domain;
        }// end function

        public function set domain(value:IDomain) : void
        {
            arguments = this._1326197564domain;
            if (arguments !== value)
            {
                this._1326197564domain = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "domain", arguments, value));
                }
            }
            return;
        }// end function

        public function get editable() : Boolean
        {
            return this._1602416228editable;
        }// end function

        public function set editable(value:Boolean) : void
        {
            arguments = this._1602416228editable;
            if (arguments !== value)
            {
                this._1602416228editable = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "editable", arguments, value));
                }
            }
            return;
        }// end function

        public function get length() : int
        {
            return this._1106363674length;
        }// end function

        public function set length(value:int) : void
        {
            arguments = this._1106363674length;
            if (arguments !== value)
            {
                this._1106363674length = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "length", arguments, value));
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

        public function get nullable() : Boolean
        {
            return this._1905967263nullable;
        }// end function

        public function set nullable(value:Boolean) : void
        {
            arguments = this._1905967263nullable;
            if (arguments !== value)
            {
                this._1905967263nullable = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nullable", arguments, value));
                }
            }
            return;
        }// end function

        public function get type() : String
        {
            return this._3575610type;
        }// end function

        public function set type(value:String) : void
        {
            arguments = this._3575610type;
            if (arguments !== value)
            {
                this._3575610type = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", arguments, value));
                }
            }
            return;
        }// end function

        static function toField(obj:Object) : Field
        {
            var _loc_2:Field = null;
            if (obj)
            {
                _loc_2 = new Field;
                _loc_2.alias = obj.alias;
                _loc_2.domain = DomainFactory.toDomain(obj.domain);
                _loc_2.editable = obj.editable;
                _loc_2.length = obj.length;
                _loc_2.name = obj.name;
                _loc_2.nullable = obj.nullable;
                _loc_2.type = obj.type;
            }
            return _loc_2;
        }// end function

    }
}
