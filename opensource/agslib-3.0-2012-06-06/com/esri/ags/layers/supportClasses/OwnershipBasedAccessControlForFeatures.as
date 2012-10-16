package com.esri.ags.layers.supportClasses
{
    import flash.events.*;

    public class OwnershipBasedAccessControlForFeatures extends EventDispatcher
    {
        private var _allowOthersToDelete:Boolean;
        private var _allowOthersToUpdate:Boolean;

        public function OwnershipBasedAccessControlForFeatures()
        {
            return;
        }// end function

        public function get allowOthersToDelete() : Boolean
        {
            return this._allowOthersToDelete;
        }// end function

        public function set allowOthersToDelete(value:Boolean) : void
        {
            this._allowOthersToDelete = value;
            dispatchEvent(new Event("allowOthersToDeleteChanged"));
            return;
        }// end function

        public function get allowOthersToUpdate() : Boolean
        {
            return this._allowOthersToUpdate;
        }// end function

        public function set allowOthersToUpdate(value:Boolean) : void
        {
            this._allowOthersToUpdate = value;
            dispatchEvent(new Event("allowOthersToUpdateChanged"));
            return;
        }// end function

        static function toOwnershipBasedAccessControlForFeatures(obj:Object) : OwnershipBasedAccessControlForFeatures
        {
            var _loc_2:OwnershipBasedAccessControlForFeatures = null;
            if (obj)
            {
                _loc_2 = new OwnershipBasedAccessControlForFeatures;
                _loc_2.allowOthersToDelete = obj.allowOthersToDelete;
                _loc_2.allowOthersToUpdate = obj.allowOthersToUpdate;
            }
            return _loc_2;
        }// end function

    }
}
