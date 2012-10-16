package com.esri.ags.portal.supportClasses
{
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.tasks.*;
    import flash.events.*;
    import mx.rpc.*;

    public class PortalFolder extends EventDispatcher
    {
        private var m_id:String;
        private var m_title:String;
        private var m_created:Date;
        private var m_portal:Portal;
        private var m_username:String;

        public function PortalFolder()
        {
            return;
        }// end function

        public function get id() : String
        {
            return this.m_id;
        }// end function

        public function get title() : String
        {
            return this.m_title;
        }// end function

        public function get created() : Date
        {
            var _loc_1:* = new Date();
            _loc_1.time = this.m_created.time;
            return _loc_1;
        }// end function

        public function get portal() : Portal
        {
            return this.m_portal;
        }// end function

        function setPortal(value:Portal) : void
        {
            this.m_portal = value;
            return;
        }// end function

        public function get username() : String
        {
            return this.m_username;
        }// end function

        public function getItems(responder:IResponder = null) : AsyncToken
        {
            var _loc_2:* = new GetUserContentTask(this.portal, this);
            return _loc_2.getItems(this.m_username, this.m_id, responder);
        }// end function

        static function fromJSON(obj:Object) : PortalFolder
        {
            var _loc_2:PortalFolder = null;
            if (obj)
            {
                _loc_2 = new PortalFolder;
                _loc_2.m_id = obj.id;
                _loc_2.m_title = obj.title;
                _loc_2.m_username = obj.username;
                _loc_2.m_created = new Date();
                _loc_2.m_created.time = obj.created;
            }
            return _loc_2;
        }// end function

    }
}
