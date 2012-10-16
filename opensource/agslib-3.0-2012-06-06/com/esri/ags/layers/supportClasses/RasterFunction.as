package com.esri.ags.layers.supportClasses
{
    import mx.utils.*;

    public class RasterFunction extends Object implements IJSONSupport
    {
        public var arguments:Object;
        public var functionName:String;

        public function RasterFunction()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            arguments = {};
            arguments.rasterFunction = this.functionName;
            if (this.arguments)
            {
                arguments.rasterFunctionArguments = ObjectUtil.copy(this.arguments);
            }
            else
            {
                arguments.rasterFunctionArguments = null;
            }
            return arguments;
        }// end function

    }
}
