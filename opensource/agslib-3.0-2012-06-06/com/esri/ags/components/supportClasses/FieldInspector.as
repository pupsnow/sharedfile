package com.esri.ags.components.supportClasses
{
    import com.esri.ags.layers.*;
    import flash.events.*;
    import mx.core.*;

    final public class FieldInspector extends EventDispatcher
    {
        public var enabled:Boolean = true;
        public var featureLayer:FeatureLayer;
        public var fieldName:String;
        public var formItemOrder:int = 2147483647;
        public var label:String;
        public var memo:Boolean = false;
        public var editor:IFactory;
        public var visible:Boolean = true;
        public var toolTip:String;

        public function FieldInspector()
        {
            return;
        }// end function

    }
}
