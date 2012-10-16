package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class FeatureLayerDetails extends LayerDetails
    {
        private var _allowGeometryUpdates:Boolean;
        private var _editFieldsInfo:EditFieldsInfo;
        private var _globalIdField:String;
        private var _ownershipBasedAccessControlForFeatures:OwnershipBasedAccessControlForFeatures;
        private var _supportsRollbackOnFailure:Boolean;
        private var _syncCanReturnChanges:Boolean;
        private var _templates:Array;
        private var _zDefault:Number;
        private var _zDefaultsEnabled:Boolean;

        public function FeatureLayerDetails()
        {
            return;
        }// end function

        public function get allowGeometryUpdates() : Boolean
        {
            return this._allowGeometryUpdates;
        }// end function

        public function set allowGeometryUpdates(value:Boolean) : void
        {
            if (this._allowGeometryUpdates !== value)
            {
                this._allowGeometryUpdates = value;
                dispatchEvent(new Event("allowGeometryUpdatesChanged"));
            }
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

        public function get zDefault() : Number
        {
            return this._zDefault;
        }// end function

        public function set zDefault(value:Number) : void
        {
            if (this._zDefault !== value)
            {
                this._zDefault = value;
                dispatchEvent(new Event("zDefaultChanged"));
            }
            return;
        }// end function

        public function get zDefaultsEnabled() : Boolean
        {
            return this._zDefaultsEnabled;
        }// end function

        public function set zDefaultsEnabled(value:Boolean) : void
        {
            if (this._zDefaultsEnabled !== value)
            {
                this._zDefaultsEnabled = value;
                dispatchEvent(new Event("zDefaultsEnabledChanged"));
            }
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

        static function toFeatureLayerDetails(obj:Object) : FeatureLayerDetails
        {
            var _loc_2:FeatureLayerDetails = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = LayerDetails.toLayerDetails(obj, FeatureLayerDetails) as FeatureLayerDetails;
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
                if (_loc_2.version < 10.1)
                {
                    if (_loc_2.capabilities)
                    {
                        if (_loc_2.capabilities)
                        {
                        }
                    }
                    if (_loc_2.capabilities.indexOf("Editing") != -1)
                    {
                        _loc_2.allowGeometryUpdates = true;
                    }
                }
                else
                {
                    _loc_2.allowGeometryUpdates = obj.allowGeometryUpdates != null ? (obj.allowGeometryUpdates) : (true);
                }
                _loc_2.zDefault = obj.zDefault;
                if (!obj.zDefaultsEnabled)
                {
                }
                _loc_2.zDefaultsEnabled = obj.enableZDefaults;
            }
            return _loc_2;
        }// end function

    }
}
