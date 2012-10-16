package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;

    public class UniqueValueDefinition extends Object implements IClassificationDefinition, IJSONSupport
    {
        public var baseSymbol:Symbol;
        public var colorRamp:IColorRamp;
        public var field:String;
        public var field2:String;
        public var field3:String;
        public var fieldDelimiter:String;

        public function UniqueValueDefinition()
        {
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_2:Object = {type:"uniqueValueDef"};
            if (this.baseSymbol is IJSONSupport)
            {
                _loc_2.baseSymbol = (this.baseSymbol as IJSONSupport).toJSON();
            }
            if (this.colorRamp is IJSONSupport)
            {
                _loc_2.colorRamp = (this.colorRamp as IJSONSupport).toJSON();
            }
            if (this.fieldDelimiter)
            {
                _loc_2.fieldDelimiter = this.fieldDelimiter;
            }
            if (this.field)
            {
                _loc_3 = [this.field];
                if (this.field2)
                {
                    _loc_3.push(this.field2);
                    if (this.field3)
                    {
                        _loc_3.push(this.field3);
                    }
                }
            }
            _loc_2.uniqueValueFields = _loc_3;
            return _loc_2;
        }// end function

    }
}
