package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;

    public class SimpleRenderer extends Renderer implements IRenderer, IJSONSupport
    {
        public var description:String;
        public var label:String;
        public var symbol:Symbol;

        public function SimpleRenderer(symbol:Symbol = null)
        {
            this.symbol = symbol;
            return;
        }// end function

        override public function getSymbol(graphic:Graphic) : Symbol
        {
            return this.symbol;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"simple"};
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
            return _loc_2;
        }// end function

        public static function fromJSON(obj:Object) : SimpleRenderer
        {
            var _loc_2:SimpleRenderer = null;
            if (obj)
            {
                _loc_2 = new SimpleRenderer;
                _loc_2.description = obj.description;
                _loc_2.label = obj.label;
                _loc_2.symbol = SymbolFactory.fromJSON(obj.symbol);
            }
            return _loc_2;
        }// end function

    }
}
