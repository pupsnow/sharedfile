package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.utils.*;
    import mx.utils.*;

    public class ClassBreaksRenderer extends Renderer implements IRenderer, IJSONSupport
    {
        public var field:String;
        public var defaultLabel:String;
        public var defaultSymbol:Symbol;
        public var infos:Array;
        public var isMaxInclusive:Boolean = true;
        public var normalizationField:String;
        public var normalizationTotal:Number;
        public var normalizationType:String;
        public static const NORMALIZE_BY_FIELD:String = "esriNormalizeByField";
        public static const NORMALIZE_BY_LOG:String = "esriNormalizeByLog";
        public static const NORMALIZE_BY_PERCENT_OF_TOTAL:String = "esriNormalizeByPercentOfTotal";

        public function ClassBreaksRenderer(field:String = null, defaultSymbol:Symbol = null, infos:Array = null)
        {
            this.field = field;
            this.defaultSymbol = defaultSymbol;
            this.infos = infos;
            return;
        }// end function

        override public function getSymbol(graphic:Graphic) : Symbol
        {
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            var _loc_5:Boolean = false;
            var _loc_6:ClassBreakInfo = null;
            var _loc_7:Number = NaN;
            var _loc_2:* = this.defaultSymbol;
            if (this.field)
            {
            }
            if (graphic.attributes)
            {
                _loc_4 = graphic.attributes[this.field];
                if (_loc_4 != null)
                {
                    _loc_3 = Number(_loc_4);
                    if (_loc_3 == 0)
                    {
                    }
                    if (_loc_4 is String)
                    {
                    }
                    if (StringUtil.trim(_loc_4 as String) != "0")
                    {
                        _loc_3 = NaN;
                    }
                }
            }
            if (!isNaN(_loc_3))
            {
                if (this.normalizationType == NORMALIZE_BY_LOG)
                {
                    _loc_3 = Math.log(_loc_3) * Math.LOG10E;
                }
                else
                {
                    if (this.normalizationType == NORMALIZE_BY_PERCENT_OF_TOTAL)
                    {
                    }
                    if (!isNaN(this.normalizationTotal))
                    {
                        _loc_3 = _loc_3 / this.normalizationTotal * 100;
                    }
                    else
                    {
                        if (this.normalizationType == NORMALIZE_BY_FIELD)
                        {
                        }
                        if (this.normalizationField)
                        {
                            _loc_4 = graphic.attributes[this.normalizationField];
                            if (_loc_4 != null)
                            {
                                _loc_7 = Number(_loc_4);
                                if (_loc_7 == 0)
                                {
                                }
                                if (_loc_4 is String)
                                {
                                }
                                if (StringUtil.trim(_loc_4 as String) != "0")
                                {
                                    _loc_7 = NaN;
                                }
                            }
                            if (!isNaN(_loc_7))
                            {
                                _loc_3 = _loc_3 / _loc_7;
                            }
                        }
                    }
                }
                _loc_5 = this.isMaxInclusive;
                for each (_loc_6 in this.infos)
                {
                    
                    if (_loc_5)
                    {
                        if (_loc_6.minValue <= _loc_3)
                        {
                        }
                        if (_loc_3 <= _loc_6.maxValue)
                        {
                            _loc_2 = _loc_6.symbol;
                            break;
                        }
                        continue;
                    }
                    if (_loc_6.minValue <= _loc_3)
                    {
                    }
                    if (_loc_3 < _loc_6.maxValue)
                    {
                        _loc_2 = _loc_6.symbol;
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_4:ClassBreakInfo = null;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Object = null;
            var _loc_9:Symbol = null;
            var _loc_2:Object = {type:"classBreaks"};
            _loc_2.field = this.field;
            var _loc_3:* = this.defaultSymbol is IJSONSupport ? (999999999999999880000000000000) : (Number.MAX_VALUE);
            if (this.infos)
            {
            }
            if (this.infos[0] is ClassBreakInfo)
            {
                _loc_4 = this.infos[0] as ClassBreakInfo;
                _loc_2.minValue = _loc_4.minValue === -Infinity ? (-_loc_3) : (_loc_4.minValue);
            }
            var _loc_5:Array = [];
            for each (_loc_4 in this.infos)
            {
                
                _loc_8 = {};
                _loc_6 = _loc_4.minValue === -Infinity ? (-_loc_3) : (_loc_4.minValue);
                if (isFinite(_loc_7))
                {
                    isFinite(_loc_7);
                }
                if (_loc_7 != _loc_6)
                {
                    _loc_8.classMinValue = _loc_6;
                }
                _loc_7 = _loc_4.maxValue === Infinity ? (_loc_3) : (_loc_4.maxValue);
                _loc_8.classMaxValue = _loc_7;
                if (_loc_4.description)
                {
                    _loc_8.description = _loc_4.description;
                }
                if (_loc_4.label)
                {
                    _loc_8.label = _loc_4.label;
                }
                _loc_9 = _loc_4.symbol;
                if (_loc_9 is IJSONSupport)
                {
                    _loc_8.symbol = (_loc_9 as IJSONSupport).toJSON();
                }
                _loc_5.push(_loc_8);
            }
            _loc_2.classBreakInfos = _loc_5;
            if (this.defaultLabel)
            {
                _loc_2.defaultLabel = this.defaultLabel;
            }
            if (this.defaultSymbol is IJSONSupport)
            {
                _loc_2.defaultSymbol = (this.defaultSymbol as IJSONSupport).toJSON();
            }
            if (this.normalizationField)
            {
                _loc_2.normalizationField = this.normalizationField;
            }
            if (!isNaN(this.normalizationTotal))
            {
                _loc_2.normalizationTotal = this.normalizationTotal;
            }
            if (this.normalizationType)
            {
                _loc_2.normalizationType = this.normalizationType;
            }
            return _loc_2;
        }// end function

        public static function fromJSON(obj:Object) : ClassBreaksRenderer
        {
            var _loc_2:ClassBreaksRenderer = null;
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            var _loc_5:ClassBreakInfo = null;
            if (obj)
            {
                _loc_2 = new ClassBreaksRenderer;
                _loc_2.field = obj.field;
                _loc_2.defaultLabel = obj.defaultLabel;
                _loc_2.defaultSymbol = SymbolFactory.fromJSON(obj.defaultSymbol);
                _loc_3 = obj.minValue;
                if (!isNaN(_loc_3))
                {
                }
                if (obj.classBreakInfos)
                {
                    _loc_2.infos = [];
                    for each (_loc_4 in obj.classBreakInfos)
                    {
                        
                        _loc_5 = ClassBreakInfo.toClassBreakInfo(_loc_4);
                        if (_loc_5.minValue === -Infinity)
                        {
                            _loc_5.minValue = _loc_3;
                        }
                        _loc_2.infos.push(_loc_5);
                        _loc_3 = _loc_5.maxValue;
                    }
                }
                _loc_2.normalizationField = obj.normalizationField;
                _loc_2.normalizationTotal = obj.normalizationTotal;
                _loc_2.normalizationType = obj.normalizationType;
            }
            return _loc_2;
        }// end function

    }
}
