package com.esri.ags.tasks.supportClasses
{

    public class AttributeParameterValue extends Object implements IJSONSupport
    {
        public var attributeName:String;
        public var parameterName:String;
        public var parameterValue:String;

        public function AttributeParameterValue()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {attributeName:this.attributeName, parameterName:this.parameterName, value:this.parameterValue};
            return _loc_2;
        }// end function

    }
}
