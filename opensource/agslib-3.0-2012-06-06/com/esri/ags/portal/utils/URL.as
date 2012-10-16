package com.esri.ags.portal.utils
{
    import flash.net.*;

    public class URL extends Object
    {
        private var m_sourceURL:String;
        private var m_protocol:String;
        private var m_host:String;
        private var m_port:Number;
        private var m_path:String;
        private var m_query:URLVariables;
        private var m_useSSL:Boolean = false;
        private static const parser:RegExp = /((?P<protocol>[a-zA-Z]+):\/\/)?(?P<host>[^:\/\?]*)(:(?P<port>\d+))?((?P<path>[^?]*))?(\??(?P<query>.*))?/;

        public function URL(sourceURL:String = null)
        {
            this.update(sourceURL);
            return;
        }// end function

        public function get sourceURL() : String
        {
            return this.m_sourceURL;
        }// end function

        public function get protocol() : String
        {
            return this.m_protocol;
        }// end function

        public function get host() : String
        {
            return this.m_host;
        }// end function

        public function get port() : Number
        {
            return this.m_port;
        }// end function

        public function get path() : String
        {
            return this.m_path;
        }// end function

        public function get query() : URLVariables
        {
            return this.m_query;
        }// end function

        public function get useSSL() : Boolean
        {
            return this.m_useSSL;
        }// end function

        public function update(value:String) : void
        {
            var _loc_2:Array = null;
            var _loc_3:String = null;
            if (this.m_sourceURL != value)
            {
                this.m_sourceURL = value;
                if (this.m_sourceURL)
                {
                    _loc_2 = parser.exec(this.sourceURL);
                    this.m_protocol = _loc_2.protocol != "" ? (_loc_2.protocol) : ("");
                    if (this.m_protocol != "")
                    {
                    }
                    if (this.m_protocol.lastIndexOf("https") != -1)
                    {
                        this.m_useSSL = true;
                    }
                    this.m_host = _loc_2.host != "" ? (_loc_2.host) : (null);
                    this.m_port = _loc_2.port != "" ? (_loc_2.port) : (NaN);
                    this.m_path = _loc_2.path != "" ? (_loc_2.path) : (null);
                    if (this.m_path)
                    {
                    }
                    if (this.m_path.charAt(0) == "/")
                    {
                        this.m_path = this.m_path.substring(1);
                    }
                    _loc_3 = _loc_2.query;
                    if (_loc_3)
                    {
                        if (_loc_3.lastIndexOf("&") == (_loc_3.length - 1))
                        {
                            _loc_3 = _loc_3.substring(0, (_loc_3.length - 1));
                        }
                        if (_loc_3)
                        {
                            this.m_query = new URLVariables(_loc_3);
                        }
                        else
                        {
                            this.m_query = new URLVariables();
                        }
                    }
                }
            }
            return;
        }// end function

        public function withProtocol(protocol:String) : URL
        {
            return fromValues(protocol, this.host, this.port, this.path, this.query, this.useSSL);
        }// end function

        public function withSSL(useSSL:Boolean) : URL
        {
            return fromValues(this.protocol, this.host, this.port, this.path, this.query, useSSL);
        }// end function

        public function withPath(path:String) : URL
        {
            return fromValues(this.protocol, this.host, this.port, path, this.query, this.useSSL);
        }// end function

        public function appendPath(path:String) : URL
        {
            var _loc_2:* = this.path ? (this.path) : ("");
            if (_loc_2.charAt((_loc_2.length - 1)) !== "/")
            {
            }
            if (path.charAt(0) !== "/")
            {
                _loc_2 = _loc_2 + "/";
            }
            else
            {
                if (_loc_2.charAt((_loc_2.length - 1)) == "/")
                {
                }
                if (path.charAt(0) == "/")
                {
                    _loc_2 = _loc_2.substring(0, (_loc_2.length - 1));
                }
            }
            _loc_2 = _loc_2 + path;
            return fromValues(this.protocol, this.host, this.port, _loc_2, this.query, this.useSSL);
        }// end function

        public function withQuery(query:URLVariables) : URL
        {
            return fromValues(this.protocol, this.host, this.port, this.path, query, this.useSSL);
        }// end function

        public function hasURLVariable(key:String) : Boolean
        {
            if (!this.m_query)
            {
                return false;
            }
            if (this.m_query[key] != null)
            {
            }
            return this.m_query[key] != undefined;
        }// end function

        public function addURLVariable(key:String, value:String) : URL
        {
            if (!this.m_query)
            {
                this.m_query = new URLVariables();
            }
            this.m_query[key] = value;
            return this;
        }// end function

        public function clone() : URL
        {
            var _loc_2:String = null;
            var _loc_1:* = new URL();
            _loc_1.m_host = this.m_host;
            _loc_1.m_path = this.m_path;
            _loc_1.m_port = this.m_port;
            _loc_1.m_protocol = this.m_protocol;
            _loc_1.m_sourceURL = this.toString();
            _loc_1.m_useSSL = this.m_useSSL;
            for (_loc_2 in this.m_query)
            {
                
                _loc_1.addURLVariable(_loc_2, this.m_query[_loc_2]);
            }
            return _loc_1;
        }// end function

        public function toString() : String
        {
            return formatToString(this.m_protocol, this.m_host, this.m_port, this.m_path, this.m_query, this.m_useSSL);
        }// end function

        public static function fromValues(protocol:String, host:String, port:Number = NaN, path:String = "", query:URLVariables = null, useSSL:Boolean = false) : URL
        {
            var _loc_7:* = formatToString(protocol, host, port, path, query, useSSL);
            return new URL(_loc_7);
        }// end function

        private static function formatToString(protocol:String, host:String, port:Number = NaN, path:String = "", query:URLVariables = null, useSSL:Boolean = false) : String
        {
            if (protocol)
            {
            }
            var _loc_7:* = protocol != "" ? (protocol.toLowerCase()) : ("");
            if (useSSL)
            {
            }
            if (_loc_7 != "")
            {
            }
            if (_loc_7.lastIndexOf("https") == -1)
            {
                _loc_7 = _loc_7.replace("http", "https");
            }
            if (_loc_7)
            {
            }
            var _loc_8:* = _loc_7 != "" ? (_loc_7 + "://") : ("");
            _loc_8 = _loc_8 + host;
            if (!isNaN(port))
            {
                _loc_8 = _loc_8 + (":" + port);
            }
            if (path)
            {
            }
            if (path != "")
            {
                if (_loc_8.charAt((_loc_8.length - 1)) !== "/")
                {
                }
                if (path.charAt(0) !== "/")
                {
                    _loc_8 = _loc_8 + "/";
                }
                _loc_8 = _loc_8 + path;
            }
            if (query)
            {
            }
            if (query.toString() !== "")
            {
                _loc_8 = _loc_8 + ("?" + query.toString());
            }
            return _loc_8;
        }// end function

    }
}
