package com.esri.ags.renderers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.symbols.*;

    public class TimeRampAger extends SymbolAger implements IJSONSupport
    {
        public var alphaRange:AlphaRange;
        public var colorRange:ColorRange;
        public var sizeRange:SizeRange;

        public function TimeRampAger(alphaRange:AlphaRange = null, colorRange:ColorRange = null, sizeRange:SizeRange = null)
        {
            this.alphaRange = alphaRange;
            this.colorRange = colorRange;
            this.sizeRange = sizeRange;
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
                    else if (_loc_5 != null)
                    {
                        if (_loc_7 < _loc_5.time)
                        {
                            _loc_7 = _loc_5.time;
                        }
                        symbol = this.ageSymbol(symbol, _loc_7, _loc_5.time, _loc_6.time);
                    }
                }
            }
            return symbol;
        }// end function

        private function ageSymbol(symbol:Symbol, featureStartTime:Number, mapStartTime:Number, mapEndTime:Number) : Symbol
        {
            var _loc_6:Number = NaN;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            var _loc_11:uint = 0;
            var _loc_12:uint = 0;
            var _loc_13:uint = 0;
            var _loc_14:uint = 0;
            var _loc_15:uint = 0;
            var _loc_16:uint = 0;
            var _loc_17:Number = NaN;
            var _loc_5:* = (featureStartTime - mapStartTime) / (mapEndTime - mapStartTime);
            if (mapStartTime == mapEndTime)
            {
                _loc_5 = 1;
            }
            if (this.alphaRange)
            {
                if (this.alphaRange.fromAlpha == this.alphaRange.toAlpha)
                {
                    _loc_6 = this.alphaRange.fromAlpha;
                }
                else if (this.alphaRange.fromAlpha < this.alphaRange.toAlpha)
                {
                    _loc_6 = this.alphaRange.fromAlpha + _loc_5 * (this.alphaRange.toAlpha - this.alphaRange.fromAlpha);
                }
                else
                {
                    _loc_6 = this.alphaRange.fromAlpha - _loc_5 * (this.alphaRange.fromAlpha - this.alphaRange.toAlpha);
                }
                symbol = this.setSymbolAlpha(symbol, _loc_6);
            }
            if (this.colorRange)
            {
                if (this.colorRange.fromColor == this.colorRange.toColor)
                {
                    _loc_7 = this.colorRange.fromColor;
                }
                else
                {
                    _loc_8 = (this.colorRange.fromColor & 16711680) >> 16;
                    _loc_9 = (this.colorRange.fromColor & 65280) >> 8;
                    _loc_10 = this.colorRange.fromColor & 255;
                    _loc_11 = (this.colorRange.toColor & 16711680) >> 16;
                    _loc_12 = (this.colorRange.toColor & 65280) >> 8;
                    _loc_13 = this.colorRange.toColor & 255;
                    if (_loc_8 < _loc_11)
                    {
                        _loc_14 = _loc_8 + _loc_5 * (_loc_11 - _loc_8);
                    }
                    else
                    {
                        _loc_14 = _loc_8 - _loc_5 * (_loc_8 - _loc_11);
                    }
                    if (_loc_9 < _loc_12)
                    {
                        _loc_15 = _loc_9 + _loc_5 * (_loc_12 - _loc_9);
                    }
                    else
                    {
                        _loc_15 = _loc_9 - _loc_5 * (_loc_9 - _loc_12);
                    }
                    if (_loc_10 < _loc_13)
                    {
                        _loc_16 = _loc_10 + _loc_5 * (_loc_13 - _loc_10);
                    }
                    else
                    {
                        _loc_16 = _loc_10 - _loc_5 * (_loc_10 - _loc_13);
                    }
                    _loc_7 = _loc_14 << 16 | _loc_15 << 8 | _loc_16;
                }
                symbol = this.setSymbolColor(symbol, _loc_7);
            }
            if (this.sizeRange)
            {
                if (this.sizeRange.fromSize == this.sizeRange.toSize)
                {
                    _loc_17 = this.sizeRange.fromSize;
                }
                else if (this.sizeRange.fromSize < this.sizeRange.toSize)
                {
                    _loc_17 = this.sizeRange.fromSize + _loc_5 * (this.sizeRange.toSize - this.sizeRange.fromSize);
                }
                else
                {
                    _loc_17 = this.sizeRange.fromSize - _loc_5 * (this.sizeRange.fromSize - this.sizeRange.toSize);
                }
                symbol = this.setSymbolSize(symbol, _loc_17);
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
            var _loc_2:Object = {};
            if (this.alphaRange)
            {
                _loc_2.alphaRange = [Math.round(this.alphaRange.fromAlpha * 255), Math.round(this.alphaRange.toAlpha * 255)];
            }
            if (this.colorRange)
            {
                _loc_2.colorRange = [SymbolFactory.colorAndAlphaToRGBA(this.colorRange.fromColor, 1), SymbolFactory.colorAndAlphaToRGBA(this.colorRange.toColor, 1)];
            }
            if (this.sizeRange)
            {
                _loc_2.sizeRange = [SymbolFactory.pxToPt(this.sizeRange.fromSize), SymbolFactory.pxToPt(this.sizeRange.toSize)];
            }
            return _loc_2;
        }// end function

    }
}
