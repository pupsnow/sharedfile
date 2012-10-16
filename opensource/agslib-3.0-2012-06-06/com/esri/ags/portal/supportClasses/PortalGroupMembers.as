package com.esri.ags.portal.supportClasses
{
    import flash.events.*;

    public class PortalGroupMembers extends EventDispatcher
    {
        private var m_owner:String;
        private var m_admins:Array;
        private var m_users:Array;

        public function PortalGroupMembers()
        {
            this.m_admins = [];
            this.m_users = [];
            return;
        }// end function

        public function get owner() : String
        {
            return this.m_owner;
        }// end function

        public function get admins() : Array
        {
            return this.m_admins.concat();
        }// end function

        public function get users() : Array
        {
            return this.m_users.concat();
        }// end function

        static function fromJSON(obj:Object) : PortalGroupMembers
        {
            var _loc_2:PortalGroupMembers = null;
            var _loc_3:String = null;
            if (obj)
            {
                _loc_2 = new PortalGroupMembers;
                if (obj.owner !== "undefined")
                {
                    _loc_2.m_owner = obj.owner as String;
                }
                for each (_loc_3 in obj.admins)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_admins.push(_loc_3 as String);
                    }
                }
                for each (_loc_3 in obj.users)
                {
                    
                    if (_loc_3 !== "undefined")
                    {
                        _loc_2.m_users.push(_loc_3 as String);
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
