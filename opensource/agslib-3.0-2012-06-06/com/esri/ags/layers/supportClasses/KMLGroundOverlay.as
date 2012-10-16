package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.geometry.*;
    import flash.events.*;

    public class KMLGroundOverlay extends MapImage
    {
        private var _id:Number;
        private var _name:String;
        private var _description:String;
        private var _snippet:String;
        private var _visible:Boolean;

        public function KMLGroundOverlay()
        {
            return;
        }// end function

        public function get id() : Number
        {
            return this._id;
        }// end function

        public function set id(value:Number) : void
        {
            if (this._id !== value)
            {
                this._id = value;
                dispatchEvent(new Event("idChanged"));
            }
            return;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function set name(value:String) : void
        {
            if (this._name !== value)
            {
                this._name = value;
                dispatchEvent(new Event("nameChanged"));
            }
            return;
        }// end function

        public function get description() : String
        {
            return this._description;
        }// end function

        public function set description(value:String) : void
        {
            if (this._description !== value)
            {
                this._description = value;
                dispatchEvent(new Event("descriptionChanged"));
            }
            return;
        }// end function

        public function get snippet() : String
        {
            return this._snippet;
        }// end function

        public function set snippet(value:String) : void
        {
            if (this._snippet !== value)
            {
                this._snippet = value;
                dispatchEvent(new Event("snippetChanged"));
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        public function set visible(value:Boolean) : void
        {
            if (this._visible !== value)
            {
                this._visible = value;
                dispatchEvent(new Event("visibleChanged"));
            }
            return;
        }// end function

        static function toKMLGroundOverlay(obj:Object) : KMLGroundOverlay
        {
            var _loc_2:KMLGroundOverlay = null;
            if (obj)
            {
                _loc_2 = new KMLGroundOverlay;
                _loc_2.id = obj.id;
                _loc_2.name = obj.name;
                _loc_2.description = obj.description;
                _loc_2.snippet = obj.snippet;
                _loc_2.visible = obj.visibility == 1 ? (true) : (false);
                _loc_2.rotation = obj.rotation;
                _loc_2.source = obj.href;
                _loc_2.extent = Extent.fromJSON(obj.extent);
                _loc_2.width = obj.width;
                _loc_2.height = obj.height;
            }
            return _loc_2;
        }// end function

    }
}
