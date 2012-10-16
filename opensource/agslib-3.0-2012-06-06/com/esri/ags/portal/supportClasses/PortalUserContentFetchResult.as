package com.esri.ags.portal.supportClasses
{

    public class PortalUserContentFetchResult extends Object
    {
        private var m_username:String;
        private var m_items:Array;
        private var m_folders:Array;
        private var m_inFolder:String;

        public function PortalUserContentFetchResult(username:String, items:Array, folders:Array, inFolder:String = null)
        {
            this.m_username = username;
            this.m_items = items;
            this.m_folders = folders;
            this.m_inFolder = inFolder;
            return;
        }// end function

        public function get username() : String
        {
            return this.m_username;
        }// end function

        public function get items() : Array
        {
            return this.m_items.concat();
        }// end function

        public function get folders() : Array
        {
            return this.m_folders.concat();
        }// end function

        public function get inFolder() : String
        {
            return this.m_inFolder;
        }// end function

    }
}
