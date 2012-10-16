package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;

    public class UniqueValueRenderer extends Renderer implements IRenderer, IJSONSupport
    {
        public var field:String;
        public var field2:String;
        public var field3:String;
        public var fieldDelimiter:String = ",";
        public var defaultLabel:String;
        public var defaultSymbol:Symbol;
        public var infos:Array;

        public function UniqueValueRenderer(field:String = null, defaultSymbol:Symbol = null, infos:Array = null)
        {
            this.field = field;
            this.defaultSymbol = defaultSymbol;
            this.infos = infos;
            return;
        }// end function

        override public function getSymbol(graphic:Graphic) : Symbol
        {
            var _loc_3:String = null;
            var _loc_4:UniqueValueInfo = null;
            var _loc_2:* = this.defaultSymbol;
            if (this.field)
            {
            }
            if (graphic.attributes)
            {
                _loc_3 = String(graphic.attributes[this.field]);
                if (this.field2)
                {
                }
                if (this.fieldDelimiter)
                {
                    _loc_3 = _loc_3 + (this.fieldDelimiter + String(graphic.attributes[this.field2]));
                    if (this.field3)
                    {
                        _loc_3 = _loc_3 + (this.fieldDelimiter + String(graphic.attributes[this.field3]));
                    }
                }
            }
            if (_loc_3)
            {
                for each (_loc_4 in this.infos)
                {
                    
                    if (_loc_3 === _loc_4.value)
                    {
                        _loc_2 = _loc_4.symbol;
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"uniqueValue"};
            _loc_2.field1 = this.field;
            if (this.field2)
            {
                _loc_2.field2 = this.field2;
            }
            if (this.field3)
            {
                _loc_2.field3 = this.field3;
            }
            if (this.fieldDelimiter)
            {
                _loc_2.fieldDelimiter = this.fieldDelimiter;
            }
            if (this.defaultLabel)
            {
                _loc_2.defaultLabel = this.defaultLabel;
            }
            if (this.defaultSymbol is IJSONSupport)
            {
                _loc_2.defaultSymbol = (this.defaultSymbol as IJSONSupport).toJSON();
            }
            _loc_2.uniqueValueInfos = JSONUtil.toJSONArray(this.infos);
            return _loc_2;
        }// end function

        public static function fromJSON(obj:Object) : UniqueValueRenderer
        {
            var _loc_2:UniqueValueRenderer = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new UniqueValueRenderer;
                _loc_2.field = obj.field1;
                _loc_2.field2 = obj.field2;
                _loc_2.field3 = obj.field3;
                if (obj.fieldDelimiter)
                {
                    _loc_2.fieldDelimiter = obj.fieldDelimiter;
                }
                _loc_2.defaultLabel = obj.defaultLabel;
                _loc_2.defaultSymbol = SymbolFactory.fromJSON(obj.defaultSymbol);
                if (obj.uniqueValueInfos)
                {
                    _loc_2.infos = [];
                    for each (_loc_3 in obj.uniqueValueInfos)
                    {
                        
                        _loc_2.infos.push(UniqueValueInfo.toUniqueValueInfo(_loc_3));
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
