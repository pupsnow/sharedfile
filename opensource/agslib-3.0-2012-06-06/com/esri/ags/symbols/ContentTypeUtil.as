package com.esri.ags.symbols
{
    import flash.utils.*;

    class ContentTypeUtil extends Object
    {

        function ContentTypeUtil()
        {
            return;
        }// end function

        public static function getContentType(imageBytes:ByteArray) : String
        {
            var _loc_2:String = null;
            if (imageBytes)
            {
            }
            if (imageBytes.length >= 4)
            {
                if (imageBytes[0] == 137)
                {
                }
                if (imageBytes[1] == 80)
                {
                }
                if (imageBytes[2] == 78)
                {
                }
                if (imageBytes[3] == 71)
                {
                    _loc_2 = "image/png";
                }
                else
                {
                    if (imageBytes[0] == 255)
                    {
                    }
                    if (imageBytes[1] == 216)
                    {
                    }
                    if (imageBytes[2] == 255)
                    {
                    }
                    if (imageBytes[3] == 224)
                    {
                        _loc_2 = "image/jpeg";
                    }
                    else
                    {
                        if (imageBytes[0] == 71)
                        {
                        }
                        if (imageBytes[1] == 73)
                        {
                        }
                        if (imageBytes[2] == 70)
                        {
                            _loc_2 = "image/gif";
                        }
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
