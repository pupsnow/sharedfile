package com.esri.ags.events
{
    import com.esri.ags.tasks.supportClasses.*;
    import flash.events.*;

    public class ClosestFacilityEvent extends Event
    {
        public var closestFacilitySolveResult:ClosestFacilitySolveResult;
        public static const SOLVE_COMPLETE:String = "solveComplete";

        public function ClosestFacilityEvent(type:String, closestFacilitySolveResult:ClosestFacilitySolveResult = null)
        {
            super(type);
            this.closestFacilitySolveResult = closestFacilitySolveResult;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ClosestFacilityEvent(type, this.closestFacilitySolveResult);
        }// end function

        override public function toString() : String
        {
            return formatToString("ClosestFacilityEvent", "type", "closestFacilitySolveResult");
        }// end function

    }
}
