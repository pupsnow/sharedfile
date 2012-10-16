package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class ServiceAreaEvent extends Event
    {
        public var serviceAreaSolveResult:ServiceAreaSolveResult;
        public static const SOLVE_COMPLETE:String = "solveComplete";

        public function ServiceAreaEvent(type:String, serviceAreaSolveResult:ServiceAreaSolveResult = null)
        {
            super(type);
            this.serviceAreaSolveResult = serviceAreaSolveResult;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ServiceAreaEvent(type, this.serviceAreaSolveResult);
        }// end function

        override public function toString() : String
        {
            return formatToString("ServiceAreaEvent", "type", "serviceAreaSolveResult");
        }// end function

    }
}
