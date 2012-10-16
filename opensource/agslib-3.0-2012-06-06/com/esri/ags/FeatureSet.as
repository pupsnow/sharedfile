package com.esri.ags
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class FeatureSet extends EventDispatcher implements IJSONSupport
    {
        private var _1424604157displayFieldName:String;
        private var _144811523exceededTransferLimit:Boolean;
        private var _1274708295fields:Array;
        private var _3195123hasM:Boolean;
        private var _3195136hasZ:Boolean;
        private var _1590525236geometryType:String;
        private var _784017063spatialReference:SpatialReference;
        public var objectIdFieldName:String;
        public var globalIdFieldName:String;
        private var _features:Array;
        private var _fieldAliases:Object;

        public function FeatureSet(features:Array = null)
        {
            this.features = features;
            return;
        }// end function

        public function get attributes() : Array
        {
            var _loc_1:Array = null;
            var _loc_2:Graphic = null;
            if (this.features)
            {
                _loc_1 = [];
                for each (_loc_2 in this.features)
                {
                    
                    _loc_1.push(_loc_2.attributes);
                }
            }
            return _loc_1;
        }// end function

        public function get features() : Array
        {
            return this._features;
        }// end function

        public function set features(value:Array) : void
        {
            this._features = value;
            dispatchEvent(new Event("featuresChanged"));
            return;
        }// end function

        public function get fieldAliases() : Object
        {
            var _loc_1:Array = null;
            var _loc_2:Field = null;
            if (!this._fieldAliases)
            {
                _loc_1 = this.fields;
                if (_loc_1)
                {
                }
                if (_loc_1.length > 0)
                {
                    this._fieldAliases = {};
                    for each (_loc_2 in _loc_1)
                    {
                        
                        this._fieldAliases[_loc_2.name] = _loc_2.alias;
                    }
                }
            }
            return this._fieldAliases;
        }// end function

        private function set _786884444fieldAliases(value:Object) : void
        {
            this._fieldAliases = value;
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Graphic = null;
            var _loc_2:Object = {};
            if (this.displayFieldName)
            {
                _loc_2.displayFieldName = this.displayFieldName;
            }
            if (this.exceededTransferLimit)
            {
                _loc_2.exceededTransferLimit = this.exceededTransferLimit;
            }
            if (this.fieldAliases)
            {
                _loc_2.fieldAliases = ObjectUtil.copy(this.fieldAliases);
            }
            if (this.fields)
            {
                _loc_2.fields = ObjectUtil.copy(this.fields);
            }
            if (this.hasM)
            {
                _loc_2.hasM = true;
            }
            if (this.hasZ)
            {
                _loc_2.hasZ = true;
            }
            if (this.geometryType)
            {
                _loc_2.geometryType = this.geometryType;
            }
            else
            {
                if (this.features)
                {
                }
                if (this.features.length > 0)
                {
                    _loc_3 = this.features[0] as Graphic;
                    if (_loc_3)
                    {
                    }
                    if (_loc_3.geometry)
                    {
                        _loc_2.geometryType = _loc_3.geometry.type;
                    }
                }
            }
            if (this.spatialReference)
            {
                _loc_2.spatialReference = this.spatialReference.toJSON();
            }
            _loc_2.features = JSONUtil.toJSONArray(this.features);
            return _loc_2;
        }// end function

        override public function toString() : String
        {
            var _loc_2:Object = null;
            var _loc_1:String = "";
            for each (_loc_2 in this.features)
            {
                
                if (_loc_1.length > 0)
                {
                    _loc_1 = _loc_1 + ",";
                }
                _loc_1 = _loc_1 + _loc_2.toString();
            }
            return "FeatureSet[" + _loc_1 + "]";
        }// end function

        public function get displayFieldName() : String
        {
            return this._1424604157displayFieldName;
        }// end function

        public function set displayFieldName(value:String) : void
        {
            arguments = this._1424604157displayFieldName;
            if (arguments !== value)
            {
                this._1424604157displayFieldName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "displayFieldName", arguments, value));
                }
            }
            return;
        }// end function

        public function get exceededTransferLimit() : Boolean
        {
            return this._144811523exceededTransferLimit;
        }// end function

        public function set exceededTransferLimit(value:Boolean) : void
        {
            arguments = this._144811523exceededTransferLimit;
            if (arguments !== value)
            {
                this._144811523exceededTransferLimit = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "exceededTransferLimit", arguments, value));
                }
            }
            return;
        }// end function

        public function get fields() : Array
        {
            return this._1274708295fields;
        }// end function

        public function set fields(value:Array) : void
        {
            arguments = this._1274708295fields;
            if (arguments !== value)
            {
                this._1274708295fields = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fields", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasM() : Boolean
        {
            return this._3195123hasM;
        }// end function

        public function set hasM(value:Boolean) : void
        {
            arguments = this._3195123hasM;
            if (arguments !== value)
            {
                this._3195123hasM = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasM", arguments, value));
                }
            }
            return;
        }// end function

        public function get hasZ() : Boolean
        {
            return this._3195136hasZ;
        }// end function

        public function set hasZ(value:Boolean) : void
        {
            arguments = this._3195136hasZ;
            if (arguments !== value)
            {
                this._3195136hasZ = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasZ", arguments, value));
                }
            }
            return;
        }// end function

        public function get geometryType() : String
        {
            return this._1590525236geometryType;
        }// end function

        public function set geometryType(value:String) : void
        {
            arguments = this._1590525236geometryType;
            if (arguments !== value)
            {
                this._1590525236geometryType = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "geometryType", arguments, value));
                }
            }
            return;
        }// end function

        public function get spatialReference() : SpatialReference
        {
            return this._784017063spatialReference;
        }// end function

        public function set spatialReference(value:SpatialReference) : void
        {
            arguments = this._784017063spatialReference;
            if (arguments !== value)
            {
                this._784017063spatialReference = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "spatialReference", arguments, value));
                }
            }
            return;
        }// end function

        public function set fieldAliases(value:Object) : void
        {
            arguments = this.fieldAliases;
            if (arguments !== value)
            {
                this._786884444fieldAliases = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fieldAliases", arguments, value));
                }
            }
            return;
        }// end function

        public static function fromJSON(obj:Object) : FeatureSet
        {
            var _loc_2:FeatureSet = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Graphic = null;
            if (obj)
            {
                _loc_2 = new FeatureSet;
                _loc_2.displayFieldName = obj.displayFieldName;
                _loc_2.exceededTransferLimit = obj.exceededTransferLimit;
                _loc_2.fieldAliases = obj.fieldAliases;
                if (obj.fields)
                {
                    _loc_2.fields = [];
                    for each (_loc_4 in obj.fields)
                    {
                        
                        _loc_2.fields.push(Field.toField(_loc_4));
                    }
                }
                _loc_2.hasM = obj.hasM;
                _loc_2.hasZ = obj.hasZ;
                _loc_2.spatialReference = SpatialReference.fromJSON(obj.spatialReference);
                _loc_2.geometryType = obj.geometryType;
                _loc_2.features = [];
                for each (_loc_3 in obj.features)
                {
                    
                    _loc_5 = new Graphic();
                    _loc_5.attributes = _loc_3.attributes;
                    if (_loc_3.geometry)
                    {
                        _loc_5.geometry = Geometry.fromJSON2(_loc_3.geometry, _loc_2.spatialReference, _loc_2.geometryType);
                    }
                    if (_loc_3.symbol)
                    {
                        _loc_5.symbol = SymbolFactory.fromJSON(_loc_3.symbol);
                    }
                    _loc_2.features.push(_loc_5);
                }
            }
            return _loc_2;
        }// end function

    }
}
