package com.esri.ags.utils
{

    public class ESRIError extends Error
    {

        public function ESRIError(errorCode:String, ... args)
        {
            super(ESRIMessageCodes.formatMessage(errorCode, args));
            return;
        }// end function

    }
}
