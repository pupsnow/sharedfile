package com.esri.ags.events
{
    import com.esri.ags.clusterers.supportClasses.*;
    import flash.events.*;

    public class FlareEvent extends Event
    {
        public var cluster:Cluster;
        public static const FLARE_OUT_START:String = "flareOutStart";
        public static const FLARE_OUT_COMPLETE:String = "flareOutComplete";
        public static const FLARE_IN_START:String = "flareInStart";
        public static const FLARE_IN_COMPLETE:String = "flareInComplete";

        public function FlareEvent(type:String, cluster:Cluster)
        {
            super(type, true, true);
            this.cluster = cluster;
            return;
        }// end function

        override public function clone() : Event
        {
            return new FlareEvent(type, this.cluster);
        }// end function

        override public function toString() : String
        {
            return formatToString("FlareEvent", "type", "cluster");
        }// end function

    }
}
