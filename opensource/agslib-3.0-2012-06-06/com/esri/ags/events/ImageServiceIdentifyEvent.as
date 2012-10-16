package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class ImageServiceIdentifyEvent extends Event
    {
        public var identifyResult:ImageServiceIdentifyResult;
        public static const EXECUTE_COMPLETE:String = "executeComplete";

        public function ImageServiceIdentifyEvent(type:String, identifyResult:ImageServiceIdentifyResult = null)
        {
            super(type);
            this.identifyResult = identifyResult;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ImageServiceIdentifyEvent(type, this.identifyResult);
        }// end function

        override public function toString() : String
        {
            return formatToString("ImageServiceIdentifyEvent", "type", "identifyResult");
        }// end function

    }
}
