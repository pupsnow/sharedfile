package com.esri.ags.utils
{
    import ESRIMessageCodes.as$91.*;
    import mx.resources.*;
    import mx.utils.*;

    public class ESRIMessageCodes extends Object
    {
        public static const ESRI_MESSAGES:String = "ESRIMessages";
        public static const GEOMETRYSERVICE_REQUIRED:String = "E0001E";
        public static const USE_SUBCLASS:String = "E0002E";
        public static const INVALID_UPDATE_DELAY:String = "E0003E";
        public static const SET_EXTENT_TO_NULL:String = "E0004W";
        public static const INVALID_TILE_SERVICE:String = "E0005E";
        public static const NULL_SPATIAL_REFERENCE:String = "E0006E";
        public static const INVALID_EXECUTE_INPUT_PARAMETERS:String = "E0007E";
        public static const UNABLE_TO_PARSE_STRING:String = "E0008E";
        public static const DOES_NOT_CONFIRN_TO_RFC822:String = "E0009E";
        public static const UNSUPPORTED_QUERY_PARAMETERS:String = "E00010E";
        public static const INVALID_FEATURE_LAYER:String = "E0011E";

        public function ESRIMessageCodes(singletonEnforcer:SingletonEnforcer)
        {
            return;
        }// end function

        static function formatMessage(errorCode:String, ... args) : String
        {
            args = ResourceManager.getInstance().getString(ESRIMessageCodes.ESRI_MESSAGES, errorCode, args);
            return StringUtil.substitute("{0}: {1}", errorCode, args);
        }// end function

        static function getString(resourceName:String, ... args) : String
        {
            return ResourceManager.getInstance().getString(ESRIMessageCodes.ESRI_MESSAGES, resourceName, args);
        }// end function

    }
}
