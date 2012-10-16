package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class RouteEvent extends Event
    {
        public var routeSolveResult:RouteSolveResult;
        public static const SOLVE_COMPLETE:String = "solveComplete";

        public function RouteEvent(type:String, routeSolveResult:RouteSolveResult = null)
        {
            super(type);
            this.routeSolveResult = routeSolveResult;
            return;
        }// end function

        override public function clone() : Event
        {
            return new RouteEvent(type, this.routeSolveResult);
        }// end function

        override public function toString() : String
        {
            return formatToString("RouteEvent", "type", "routeSolveResult");
        }// end function

    }
}
