package com.esri.ags.events
{
    import com.esri.ags.portal.supportClasses.*;
    import flash.events.*;

    public class PortalEvent extends Event
    {
        private var m_queryResult:PortalQueryResult;
        private var m_groupMembers:PortalGroupMembers;
        private var m_folders:Array;
        private var m_items:Array;
        private var m_item:PortalItem;
        public static const LOAD:String = "load";
        public static const UNLOAD:String = "unload";
        public static const QUERY_GROUPS_COMPLETE:String = "queryGroupsComplete";
        public static const QUERY_ITEMS_COMPLETE:String = "queryItemsComplete";
        public static const QUERY_USERS_COMPLETE:String = "queryUsersComplete";
        public static const GET_FOLDERS_COMPLETE:String = "getFoldersComplete";
        public static const GET_ITEM_COMPLETE:String = "getItemComplete";
        public static const GET_ITEMS_COMPLETE:String = "getItemsComplete";
        public static const GET_MEMBERS_COMPLETE:String = "getMembersComplete";

        public function PortalEvent(type:String, queryResult:PortalQueryResult = null, groupMembers:PortalGroupMembers = null, folders:Array = null, items:Array = null, item:PortalItem = null)
        {
            super(type, false, false);
            this.m_queryResult = queryResult;
            this.m_groupMembers = groupMembers;
            this.m_folders = folders;
            this.m_items = items;
            this.m_item = item;
            return;
        }// end function

        public function get queryResult() : PortalQueryResult
        {
            return this.m_queryResult;
        }// end function

        public function get groupMembers() : PortalGroupMembers
        {
            return this.m_groupMembers;
        }// end function

        public function get folders() : Array
        {
            return this.m_folders.concat();
        }// end function

        public function get items() : Array
        {
            return this.m_items.concat();
        }// end function

        public function get item() : PortalItem
        {
            return this.m_item;
        }// end function

        override public function clone() : Event
        {
            return new PortalEvent(type, this.m_queryResult, this.m_groupMembers, this.m_folders, this.m_items, this.m_item);
        }// end function

        override public function toString() : String
        {
            return formatToString("PortalEvent", "type", "queryResult");
        }// end function

    }
}
