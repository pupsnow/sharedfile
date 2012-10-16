package com.esri.ags.portal.supportClasses
{
    import flash.events.*;

    public class PopUpInfo extends EventDispatcher
    {
        private var _description:String;
        public var popUpFieldInfos:Array;
        public var popUpMediaInfos:Array;
        private var _showAttachments:Boolean;
        private var _title:String;

        public function PopUpInfo()
        {
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
                dispatchEvent(new Event("descriptionChange"));
            }
            return;
        }// end function

        public function get showAttachments() : Boolean
        {
            return this._showAttachments;
        }// end function

        public function set showAttachments(value:Boolean) : void
        {
            if (this._showAttachments !== value)
            {
                this._showAttachments = value;
                dispatchEvent(new Event("showAttachmentsChange"));
            }
            return;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        public function set title(value:String) : void
        {
            if (this._title !== value)
            {
                this._title = value;
                dispatchEvent(new Event("titleChange"));
            }
            return;
        }// end function

        static function toPopUpInfo(obj:Object) : PopUpInfo
        {
            var _loc_2:PopUpInfo = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            if (obj)
            {
                _loc_2 = new PopUpInfo;
                _loc_2.description = obj.description;
                if (obj.fieldInfos is Array)
                {
                    _loc_2.popUpFieldInfos = [];
                    for each (_loc_3 in obj.fieldInfos)
                    {
                        
                        _loc_2.popUpFieldInfos.push(PopUpFieldInfo.toPopUpFieldInfo(_loc_3));
                    }
                }
                if (obj.mediaInfos is Array)
                {
                    _loc_2.popUpMediaInfos = [];
                    for each (_loc_4 in obj.mediaInfos)
                    {
                        
                        _loc_2.popUpMediaInfos.push(PopUpMediaInfo.toPopUpMediaInfo(_loc_4));
                    }
                }
                _loc_2.showAttachments = obj.showAttachments;
                _loc_2.title = obj.title;
            }
            return _loc_2;
        }// end function

    }
}
