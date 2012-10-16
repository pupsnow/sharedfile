package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class EditFieldsInfo extends EventDispatcher
    {
        private var _creationDateField:String;
        private var _creatorField:String;
        private var _editDateField:String;
        private var _editorField:String;
        private var _realm:String;

        public function EditFieldsInfo()
        {
            return;
        }// end function

        public function get creationDateField() : String
        {
            return this._creationDateField;
        }// end function

        public function set creationDateField(value:String) : void
        {
            this._creationDateField = value;
            dispatchEvent(new Event("creationDateFieldChanged"));
            return;
        }// end function

        public function get creatorField() : String
        {
            return this._creatorField;
        }// end function

        public function set creatorField(value:String) : void
        {
            this._creatorField = value;
            dispatchEvent(new Event("creatorFieldChanged"));
            return;
        }// end function

        public function get editDateField() : String
        {
            return this._editDateField;
        }// end function

        public function set editDateField(value:String) : void
        {
            this._editDateField = value;
            dispatchEvent(new Event("editDateFieldChanged"));
            return;
        }// end function

        public function get editorField() : String
        {
            return this._editorField;
        }// end function

        public function set editorField(value:String) : void
        {
            this._editorField = value;
            dispatchEvent(new Event("editorFieldChanged"));
            return;
        }// end function

        public function get realm() : String
        {
            return this._realm;
        }// end function

        public function set realm(value:String) : void
        {
            if (this._realm !== value)
            {
                this._realm = value;
                dispatchEvent(new Event("realmChanged"));
            }
            return;
        }// end function

        static function toEditFieldsInfo(obj:Object) : EditFieldsInfo
        {
            var _loc_2:EditFieldsInfo = null;
            if (obj)
            {
                _loc_2 = new EditFieldsInfo;
                _loc_2.creationDateField = obj.creationDateField;
                _loc_2.creatorField = obj.creatorField;
                _loc_2.editDateField = obj.editDateField;
                _loc_2.editorField = obj.editorField;
                _loc_2.realm = obj.realm;
            }
            return _loc_2;
        }// end function

    }
}
