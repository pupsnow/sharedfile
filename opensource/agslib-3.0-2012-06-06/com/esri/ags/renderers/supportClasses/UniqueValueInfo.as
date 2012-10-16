package com.esri.ags.renderers.supportClasses
{
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;

    public class UniqueValueInfo extends Object implements IJSONSupport
    {
        public var description:String;
        public var label:String;
        public var symbol:Symbol;
        public var value:String;

        public function UniqueValueInfo(symbol:Symbol = null, value:String = null)
        {
            this.symbol = symbol;
            this.value = value;
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (this.description)
            {
                _loc_2.description = this.description;
            }
            if (this.label)
            {
                _loc_2.label = this.label;
            }
            if (this.symbol is IJSONSupport)
            {
                _loc_2.symbol = (this.symbol as IJSONSupport).toJSON();
            }
            _loc_2.value = this.value;
            return _loc_2;
        }// end function

        static function toUniqueValueInfo(obj:Object) : UniqueValueInfo
        {
            var _loc_2:UniqueValueInfo = null;
            if (obj)
            {
                _loc_2 = new UniqueValueInfo;
                _loc_2.description = obj.description;
                _loc_2.label = obj.label;
                _loc_2.symbol = SymbolFactory.fromJSON(obj.symbol);
                _loc_2.value = obj.value;
            }
            return _loc_2;
        }// end function

    }
}
