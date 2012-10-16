package com.esri.ags.utils
{
    import flash.net.*;
    import mx.utils.*;

    public class URL extends Object
    {
        public var path:String;
        public var query:URLVariables;
        public var sourceURL:String;

        public function URL(sourceURL:String = null)
        {
            this.update(sourceURL);
            return;
        }// end function

        public function update(sourceURL:String) : void
        {
            var _loc_2:int = 0;
            var _loc_3:String = null;
            this.sourceURL = sourceURL;
            this.path = null;
            this.query = null;
            if (sourceURL)
            {
                _loc_2 = sourceURL.indexOf("?");
                if (_loc_2 == -1)
                {
                    this.path = sourceURL;
                }
                else
                {
                    this.path = sourceURL.substring(0, _loc_2);
                    if ((_loc_2 + 1) < sourceURL.length)
                    {
                        _loc_3 = sourceURL.substring((_loc_2 + 1));
                        if (_loc_3.lastIndexOf("&") == (_loc_3.length - 1))
                        {
                            _loc_3 = _loc_3.substring(0, (_loc_3.length - 1));
                        }
                        if (_loc_3)
                        {
                            this.query = new URLVariables(_loc_3);
                        }
                    }
                }
            }
            return;
        }// end function

        public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

    }
}
