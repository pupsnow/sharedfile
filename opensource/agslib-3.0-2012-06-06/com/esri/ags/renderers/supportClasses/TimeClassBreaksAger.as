package com.esri.ags.renderers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.symbols.*;

    public class TimeClassBreaksAger extends SymbolAger implements IJSONSupport
    {
        public var timeUnits:String;
        public var infos:Array;
        public static const UNIT_DAYS:String = "esriTimeUnitsDays";
        public static const UNIT_HOURS:String = "esriTimeUnitsHours";
        public static const UNIT_MILLISECONDS:String = "esriTimeUnitsMilliseconds";
        public static const UNIT_MINUTES:String = "esriTimeUnitsMinutes";
        public static const UNIT_SECONDS:String = "esriTimeUnitsSeconds";

        public function TimeClassBreaksAger(timeUnits:String = "esriTimeUnitsSeconds", infos:Array = null)
        {
            this.timeUnits = timeUnits;
            this.infos = infos;
            return;
        }// end function

        override public function getAgedSymbol(symbol:Symbol, graphic:Graphic) : Symbol
        {
            var _loc_4:TimeExtent = null;
            var _loc_5:Date = null;
            var _loc_6:Date = null;
            var _loc_7:Number = NaN;
            var _loc_3:* = graphic.graphicsLayer as FeatureLayer;
            if (_loc_3)
            {
                _loc_4 = graphic.graphicsLayer.map.timeExtent;
                if (_loc_4 == null)
                {
                }
                else if (_loc_4.endTime != null)
                {
                    _loc_5 = _loc_4.startTime;
                    _loc_6 = _loc_4.endTime;
                    _loc_7 = Number(graphic.attributes[_loc_3.startTimeField]);
                    if (_loc_6 == null)
                    {
                    }
                    else
                    {
                        if (_loc_5 != null)
                        {
                            if (_loc_7 < _loc_5.time)
                            {
                                _loc_7 = _loc_5.time;
                            }
                        }
                        symbol = this.ageSymbol(symbol, _loc_7, _loc_6.time);
                    }
                }
            }
            return symbol;
        }// end function

        private function ageSymbol(symbol:Symbol, featureStartTime:Number, mapEndTime:Number) : Symbol
        {
            var _loc_5:Number = NaN;
            var _loc_4:* = mapEndTime - featureStartTime;
            switch(this.timeUnits)
            {
                case UNIT_MILLISECONDS:
                {
                    _loc_5 = _loc_4;
                    break;
                }
                case UNIT_SECONDS:
                {
                    _loc_5 = _loc_4 / 1000;
                    break;
                }
                case UNIT_MINUTES:
                {
                    _loc_5 = _loc_4 / 1000 / 60;
                    break;
                }
                case UNIT_HOURS:
                {
                    _loc_5 = _loc_4 / 1000 / 60 / 60;
                    break;
                }
                case UNIT_DAYS:
                {
                    _loc_5 = _loc_4 / 1000 / 60 / 60 / 24;
                    break;
                }
                default:
                {
                    return symbol;
                    break;
                }
            }
            var _loc_6:* = this.findInfo(_loc_5);
            if (_loc_6)
            {
                symbol = this.setSymbolAttributes(symbol, _loc_6);
            }
            return symbol;
        }// end function

        private function findInfo(unitlessTime:Number) : TimeClassBreakInfo
        {
            var _loc_3:TimeClassBreakInfo = null;
            var _loc_2:int = 0;
            while (_loc_2 < this.infos.length)
            {
                
                _loc_3 = this.infos[_loc_2];
                if (_loc_3.minAge <= unitlessTime)
                {
                }
                if (unitlessTime < _loc_3.maxAge)
                {
                    return _loc_3;
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        private function setSymbolAttributes(symbol:Symbol, info:TimeClassBreakInfo) : Symbol
        {
            if (!isNaN(info.alpha))
            {
                symbol = this.setSymbolAlpha(symbol, info.alpha);
            }
            if (!isNaN(info.color))
            {
                symbol = this.setSymbolColor(symbol, info.color);
            }
            if (!isNaN(info.size))
            {
                symbol = this.setSymbolSize(symbol, info.size);
            }
            return symbol;
        }// end function

        private function setSymbolAlpha(symbol:Symbol, alpha:Number) : Symbol
        {
            var _loc_3:CompositeSymbol = null;
            var _loc_4:Symbol = null;
            if (symbol is SimpleMarkerSymbol)
            {
                (symbol as SimpleMarkerSymbol).alpha = alpha;
            }
            else if (symbol is SimpleLineSymbol)
            {
                (symbol as SimpleLineSymbol).alpha = alpha;
            }
            else if (symbol is SimpleFillSymbol)
            {
                (symbol as SimpleFillSymbol).alpha = alpha;
            }
            else if (symbol is TextSymbol)
            {
                (symbol as TextSymbol).alpha = alpha;
            }
            else if (symbol is CartographicLineSymbol)
            {
                (symbol as CartographicLineSymbol).alpha = alpha;
            }
            else if (symbol is CompositeSymbol)
            {
                _loc_3 = symbol as CompositeSymbol;
                for each (_loc_4 in _loc_3.symbols)
                {
                    
                    this.setSymbolAlpha(_loc_4, alpha);
                }
            }
            return symbol;
        }// end function

        private function setSymbolColor(symbol:Symbol, color:uint) : Symbol
        {
            var _loc_3:CompositeSymbol = null;
            var _loc_4:Symbol = null;
            if (symbol is SimpleMarkerSymbol)
            {
                (symbol as SimpleMarkerSymbol).color = color;
            }
            else if (symbol is SimpleLineSymbol)
            {
                (symbol as SimpleLineSymbol).color = color;
            }
            else if (symbol is SimpleFillSymbol)
            {
                (symbol as SimpleFillSymbol).color = color;
            }
            else if (symbol is TextSymbol)
            {
                (symbol as TextSymbol).color = color;
            }
            else if (symbol is CartographicLineSymbol)
            {
                (symbol as CartographicLineSymbol).color = color;
            }
            else if (symbol is CompositeSymbol)
            {
                _loc_3 = symbol as CompositeSymbol;
                for each (_loc_4 in _loc_3.symbols)
                {
                    
                    this.setSymbolColor(_loc_4, color);
                }
            }
            return symbol;
        }// end function

        private function setSymbolSize(symbol:Symbol, size:Number) : Symbol
        {
            if (symbol is SimpleMarkerSymbol)
            {
                (symbol as SimpleMarkerSymbol).size = size;
            }
            else if (symbol is SimpleLineSymbol)
            {
                (symbol as SimpleLineSymbol).width = size;
            }
            else if (symbol is SimpleFillSymbol)
            {
                if ((symbol as SimpleFillSymbol).outline)
                {
                    (symbol as SimpleFillSymbol).outline.width = size;
                }
            }
            return symbol;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:Array = null;
            var _loc_4:TimeClassBreakInfo = null;
            var _loc_5:Object = null;
            var _loc_2:Object = {};
            _loc_2.ageUnits = this.timeUnits;
            if (this.infos)
            {
                _loc_3 = [];
                for each (_loc_4 in this.infos)
                {
                    
                    _loc_5 = {};
                    _loc_5.oldestAge = _loc_4.maxAge == Infinity ? (Number.MAX_VALUE) : (_loc_4.maxAge);
                    if (!isNaN(_loc_4.alpha))
                    {
                        _loc_5.alpha = Math.round(_loc_4.alpha * 255);
                    }
                    if (!isNaN(_loc_4.color))
                    {
                        _loc_5.color = SymbolFactory.colorAndAlphaToRGBA(_loc_4.color, 1);
                    }
                    if (!isNaN(_loc_4.size))
                    {
                        _loc_5.size = SymbolFactory.pxToPt(_loc_4.size);
                    }
                    _loc_3.push(_loc_5);
                }
            }
            _loc_2.agerClassBreakInfos = _loc_3;
            return _loc_2;
        }// end function

    }
}
