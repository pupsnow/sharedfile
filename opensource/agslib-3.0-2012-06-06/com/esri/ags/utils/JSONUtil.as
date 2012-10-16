package com.esri.ags.utils
{
    import com.esri.ags.geometry.*;
    import com.esri.serialization.json.*;

    public class JSONUtil extends Object
    {

        public function JSONUtil()
        {
            return;
        }// end function

        public static function encode(object:Object) : String
        {
            return JSON.stringify(object);
        }// end function

        public static function decode(string:String) : Object
        {
            var result:Object;
            var decoder:JSONDecoder;
            var string:* = string;
            try
            {
                result = JSON.parse(string);
            }
            catch (refError:ReferenceError)
            {
                throw refError;
                ;
            }
            catch (error:Error)
            {
            }
            if (!result)
            {
                try
                {
                    decoder = new JSONDecoder(string);
                    result = decoder.getValue();
                }
                catch (jsonParseError:JSONParseError)
                {
                    throw new Error(jsonParseError.message + " at location " + jsonParseError.location);
                }
            }
            return result;
        }// end function

        static function toJSONArray(objects:Array) : Array
        {
            var _loc_2:Array = null;
            var _loc_3:Object = null;
            if (objects)
            {
                _loc_2 = [];
                for each (_loc_3 in objects)
                {
                    
                    if (_loc_3 is IJSONSupport)
                    {
                        _loc_2.push((_loc_3 as IJSONSupport).toJSON());
                        continue;
                    }
                    _loc_2.push(_loc_3);
                }
            }
            return _loc_2;
        }// end function

        static function toJSONArrayNoSR(geometries:Array) : Array
        {
            var _loc_2:Array = null;
            var _loc_3:Geometry = null;
            var _loc_4:Object = null;
            if (geometries)
            {
                _loc_2 = [];
                for each (_loc_3 in geometries)
                {
                    
                    _loc_4 = _loc_3.toJSON();
                    delete _loc_4.spatialReference;
                    _loc_2.push(_loc_4);
                }
            }
            return _loc_2;
        }// end function

        Date.prototype.toJSON = function (k:String)
        {
            return this.time;
        }// end function
        ;
    }
}
