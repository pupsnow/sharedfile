package com.esri.ags.events
{
    import com.esri.ags.layers.*;
    import flash.events.*;
    import mx.rpc.*;

    public class LayerEvent extends Event
    {
        public var fault:Fault;
        public var isInScaleRange:Boolean;
        public var layer:Layer;
        public var updateSuccess:Boolean;
        public static const IS_IN_SCALE_RANGE_CHANGE:String = "isInScaleRangeChange";
        public static const LOAD:String = "load";
        public static const LOAD_ERROR:String = "loadError";
        public static const UPDATE_END:String = "updateEnd";
        public static const UPDATE_START:String = "updateStart";

        public function LayerEvent(type:String, layer:Layer, fault:Fault = null, updateSuccess:Boolean = false, isInScaleRange:Boolean = false)
        {
            super(type);
            this.layer = layer;
            this.fault = fault;
            this.updateSuccess = updateSuccess;
            this.isInScaleRange = isInScaleRange;
            return;
        }// end function

        override public function clone() : Event
        {
            return new LayerEvent(type, this.layer, this.fault, this.updateSuccess, this.isInScaleRange);
        }// end function

        override public function toString() : String
        {
            return formatToString("LayerEvent", "type", "layer", "fault", "updateSuccess", "isInScaleRange");
        }// end function

    }
}
