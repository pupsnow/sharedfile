package com.esri.ags.layers.supportClasses
{
    import flash.events.*;
    import mx.events.*;

    public class FeatureType extends EventDispatcher
    {
        private var _1837548591domains:Object;
        private var _3355id:String;
        private var _3373707name:String;
        private var _1981727545templates:Array;

        public function FeatureType()
        {
            return;
        }// end function

        public function get domains() : Object
        {
            return this._1837548591domains;
        }// end function

        public function set domains(value:Object) : void
        {
            arguments = this._1837548591domains;
            if (arguments !== value)
            {
                this._1837548591domains = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "domains", arguments, value));
                }
            }
            return;
        }// end function

        public function get id() : String
        {
            return this._3355id;
        }// end function

        public function set id(value:String) : void
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

        public function get templates() : Array
        {
            return this._1981727545templates;
        }// end function

        public function set templates(value:Array) : void
        {
            arguments = this._1981727545templates;
            if (arguments !== value)
            {
                this._1981727545templates = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "templates", arguments, value));
                }
            }
            return;
        }// end function

        static function toFeatureType(obj:Object) : FeatureType
        {
            var _loc_2:FeatureType = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            if (obj)
            {
                _loc_2 = new FeatureType;
                if (obj.domains)
                {
                    _loc_2.domains = new Object();
                    for (_loc_3 in obj.domains)
                    {
                        
                        _loc_2.domains[_loc_3] = DomainFactory.toDomain(obj.domains[_loc_3]);
                    }
                }
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
                if (obj.templates)
                {
                    _loc_2.templates = [];
                    for each (_loc_4 in obj.templates)
                    {
                        
                        _loc_2.templates.push(FeatureTemplate.toFeatureTemplate(_loc_4));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
