package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;

    public interface ITimeSlider extends IEventDispatcher
    {

        public function ITimeSlider();

        function get timeExtent() : TimeExtent;

    }
}
