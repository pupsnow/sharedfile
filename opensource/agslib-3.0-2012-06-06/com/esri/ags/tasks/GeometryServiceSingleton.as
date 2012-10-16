package com.esri.ags.tasks
{

    public class GeometryServiceSingleton extends Object
    {
        private static var _instance:GeometryService;

        public function GeometryServiceSingleton()
        {
            return;
        }// end function

        public function get proxyURL() : String
        {
            return instance.proxyURL;
        }// end function

        public function set proxyURL(value:String) : void
        {
            instance.proxyURL = value;
            return;
        }// end function

        public function get requestTimeout() : int
        {
            return instance.requestTimeout;
        }// end function

        public function set requestTimeout(value:int) : void
        {
            instance.requestTimeout = value;
            return;
        }// end function

        public function get showBusyCursor() : Boolean
        {
            return instance.showBusyCursor;
        }// end function

        public function set showBusyCursor(value:Boolean) : void
        {
            instance.showBusyCursor = value;
            return;
        }// end function

        public function get token() : String
        {
            return instance.token;
        }// end function

        public function set token(value:String) : void
        {
            instance.token = value;
            return;
        }// end function

        public function get url() : String
        {
            return instance.url;
        }// end function

        public function set url(value:String) : void
        {
            instance.url = value;
            return;
        }// end function

        public static function get instance() : GeometryService
        {
            if (!_instance)
            {
                _instance = new GeometryService();
            }
            return _instance;
        }// end function

    }
}
