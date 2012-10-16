package com.esri.ags.events
{
    import flash.events.*;

    public class IdentityManagerEvent extends Event
    {
        public static const SHOW_SIGN_IN_WINDOW:String = "showSignInWindow";

        public function IdentityManagerEvent(type:String, cancelable:Boolean = false)
        {
            super(type, false, cancelable);
            return;
        }// end function

        override public function clone() : Event
        {
            return new IdentityManagerEvent(type, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("IdentityManagerEvent", "type", "cancelable");
        }// end function

    }
}
