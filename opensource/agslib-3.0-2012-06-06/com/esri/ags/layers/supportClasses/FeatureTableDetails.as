package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class FeatureTableDetails extends TableDetails
    {
        private var _editFieldsInfo:EditFieldsInfo;
        private var _globalIdField:String;
        private var _ownershipBasedAccessControlForFeatures:OwnershipBasedAccessControlForFeatures;
        private var _supportsRollbackOnFailure:Boolean;
        private var _syncCanReturnChanges:Boolean;
        private var _templates:Array;

        public function FeatureTableDetails()
        {
            return;
        }// end function

        public function get editFieldsInfo() : EditFieldsInfo
        {
            return this._editFieldsInfo;
        }// end function

        public function set editFieldsInfo(value:EditFieldsInfo) : void
        {
            this._editFieldsInfo = value;
            dispatchEvent(new Event("editFieldsInfoChanged"));
            return;
        }// end function

        public function get globalIdField() : String
        {
            return this._globalIdField;
        }// end function

        public function set globalIdField(value:String) : void
        {
            if (this._globalIdField !== value)
            {
                this._globalIdField = value;
                dispatchEvent(new Event("globalIdFieldChanged"));
            }
            return;
        }// end function

        public function get isCreateAllowed() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!capabilities)
            {
                _loc_1 = true;
            }
            else
            {
                if (this.version < 10.1)
                {
                }
                if (this.isEditable())
                {
                    _loc_1 = true;
                }
                else if (capabilities.indexOf("Create") != -1)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1;
        }// end function

        public function get isDeleteAllowed() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!capabilities)
            {
                _loc_1 = true;
            }
            else
            {
                if (this.version < 10.1)
                {
                }
                if (this.isEditable())
                {
                    _loc_1 = true;
                }
                else if (capabilities.indexOf("Delete") != -1)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1;
        }// end function

        public function get isUpdateAllowed() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!capabilities)
            {
                _loc_1 = true;
            }
            else
            {
                if (this.version < 10.1)
                {
                }
                if (this.isEditable())
                {
                    _loc_1 = true;
                }
                else if (capabilities.indexOf("Update") != -1)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1;
        }// end function

        public function get ownershipBasedAccessControlForFeatures() : OwnershipBasedAccessControlForFeatures
        {
            return this._ownershipBasedAccessControlForFeatures;
        }// end function

        public function set ownershipBasedAccessControlForFeatures(value:OwnershipBasedAccessControlForFeatures) : void
        {
            this._ownershipBasedAccessControlForFeatures = value;
            dispatchEvent(new Event("ownershipBasedAccessControlForFeaturesChanged"));
            return;
        }// end function

        public function get supportsRollbackOnFailure() : Boolean
        {
            return this._supportsRollbackOnFailure;
        }// end function

        public function set supportsRollbackOnFailure(value:Boolean) : void
        {
            if (this._supportsRollbackOnFailure !== value)
            {
                this._supportsRollbackOnFailure = value;
                dispatchEvent(new Event("supportsRollbackOnFailureChanged"));
            }
            return;
        }// end function

        public function get syncCanReturnChanges() : Boolean
        {
            return this._syncCanReturnChanges;
        }// end function

        public function set syncCanReturnChanges(value:Boolean) : void
        {
            if (this._syncCanReturnChanges !== value)
            {
                this._syncCanReturnChanges = value;
                dispatchEvent(new Event("syncCanReturnChangesChanged"));
            }
            return;
        }// end function

        public function get templates() : Array
        {
            return this._templates;
        }// end function

        public function set templates(value:Array) : void
        {
            this._templates = value;
            dispatchEvent(new Event("templatesChanged"));
            return;
        }// end function

        private function isEditable() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!capabilities)
            {
                _loc_1 = true;
            }
            else if (capabilities.indexOf("Editing") != -1)
            {
                _loc_1 = true;
            }
            return _loc_1;
        }// end function

        static function toFeatureTableDetails(obj:Object) : FeatureTableDetails
        {
            var _loc_2:FeatureTableDetails = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = TableDetails.toTableDetails(obj, FeatureTableDetails) as FeatureTableDetails;
                _loc_2.editFieldsInfo = EditFieldsInfo.toEditFieldsInfo(obj.editFieldsInfo);
                _loc_2.globalIdField = obj.globalIdField;
                _loc_2.ownershipBasedAccessControlForFeatures = OwnershipBasedAccessControlForFeatures.toOwnershipBasedAccessControlForFeatures(obj.ownershipBasedAccessControlForFeatures);
                _loc_2.supportsRollbackOnFailure = obj.supportsRollbackOnFailure;
                _loc_2.syncCanReturnChanges = obj.syncCanReturnChanges;
                if (obj.templates)
                {
                    _loc_2.templates = [];
                    for each (_loc_3 in obj.templates)
                    {
                        
                        _loc_2.templates.push(FeatureTemplate.toFeatureTemplate(_loc_3));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
