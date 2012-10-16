package com.esri.serialization.json
{

    public class JSON extends Object
    {

        public function JSON()
        {
            return;
        }// end function

        public static function encode(o:Object) : String
        {
            var _loc_2:* = new JSONEncoder(o);
            return _loc_2.getString();
        }// end function

        public static function decode(s:String)
        {
            var _loc_2:* = new JSONDecoder(s);
            return _loc_2.getValue();
        }// end function

    }
}
