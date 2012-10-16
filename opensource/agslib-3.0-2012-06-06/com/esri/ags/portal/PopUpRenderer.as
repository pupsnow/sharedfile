package com.esri.ags.portal
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.formatters.*;
    import mx.utils.*;
    import spark.components.supportClasses.*;

    public class PopUpRenderer extends SkinnableComponent implements IGraphicRenderer
    {
        private const _dateFormatter:DateFormatter;
        private const _numberFormatter:NumberFormatter;
        private var _formattedAttributes:Object;
        private var _graphic:Graphic;
        private var _graphicChanged:Boolean;
        private var _popUpInfo:PopUpInfo;
        private var _validPopUpMediaInfos:Array;

        public function PopUpRenderer()
        {
            this._dateFormatter = new DateFormatter();
            this._numberFormatter = new NumberFormatter();
            return;
        }// end function

        public function get formattedAttributes() : Object
        {
            return this._formattedAttributes;
        }// end function

        public function get featureLayer() : FeatureLayer
        {
            return this.graphic ? (this.graphic.graphicsLayer as FeatureLayer) : (null);
        }// end function

        public function get graphic() : Graphic
        {
            return this._graphic;
        }// end function

        public function set graphic(value:Graphic) : void
        {
            this._graphic = value;
            this._graphicChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("graphicChange"));
            return;
        }// end function

        public function get map() : Map
        {
            var _loc_1:Map = null;
            var _loc_3:GraphicsLayer = null;
            var _loc_2:* = this.graphic;
            if (_loc_2)
            {
                _loc_3 = _loc_2.graphicsLayer;
                if (_loc_3)
                {
                    _loc_1 = _loc_3.map;
                }
            }
            return _loc_1;
        }// end function

        public function get popUpInfo() : PopUpInfo
        {
            return this._popUpInfo;
        }// end function

        public function set popUpInfo(value:PopUpInfo) : void
        {
            this._popUpInfo = value;
            dispatchEvent(new Event("popUpInfoChange"));
            return;
        }// end function

        public function get validPopUpMediaInfos() : Array
        {
            return this._validPopUpMediaInfos;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Object = null;
            var _loc_3:FeatureLayer = null;
            var _loc_4:LayerDetails = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:Object = null;
            var _loc_9:PopUpFieldInfo = null;
            var _loc_10:Array = null;
            var _loc_11:PopUpMediaInfo = null;
            var _loc_12:String = null;
            var _loc_13:String = null;
            var _loc_14:String = null;
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_17:String = null;
            super.commitProperties();
            if (this._graphicChanged)
            {
                this._graphicChanged = false;
                if (skin)
                {
                    skin.invalidateProperties();
                }
                _loc_1 = this.graphic.attributes;
                _loc_2 = _loc_1 ? (ObjectUtil.copy(_loc_1)) : ({});
                _loc_3 = this.featureLayer;
                _loc_4 = _loc_3 ? (_loc_3.layerDetails) : (null);
                _loc_5 = this.popUpInfo ? (this.popUpInfo.popUpFieldInfos) : (null);
                _loc_6 = this.popUpInfo ? (this.popUpInfo.popUpMediaInfos) : (null);
                for each (_loc_9 in _loc_5)
                {
                    
                    _loc_7 = _loc_9.fieldName;
                    _loc_8 = _loc_2[_loc_7];
                    _loc_2[_loc_7] = this.formatValue(_loc_8, _loc_9, _loc_4);
                }
                if (_loc_4)
                {
                    _loc_12 = _loc_4.typeIdField;
                    _loc_13 = _loc_12 ? (_loc_1[_loc_12]) : (null);
                    for (_loc_7 in _loc_1)
                    {
                        
                        _loc_8 = _loc_1[_loc_7];
                        if (_loc_8 != null)
                        {
                            _loc_14 = this.getDomainName(_loc_7, _loc_8, _loc_13, _loc_4);
                            if (_loc_14)
                            {
                                _loc_2[_loc_7] = _loc_14;
                                continue;
                            }
                            if (_loc_7 === _loc_12)
                            {
                                _loc_15 = this.getTypeName(_loc_13, _loc_4);
                                if (_loc_15)
                                {
                                    _loc_2[_loc_7] = _loc_15;
                                }
                            }
                        }
                    }
                }
                this._formattedAttributes = _loc_2;
                _loc_10 = [];
                for each (_loc_11 in _loc_6)
                {
                    
                    switch(_loc_11.type)
                    {
                        case PopUpMediaInfo.IMAGE:
                        {
                            _loc_16 = _loc_11.imageSourceURL;
                            if (_loc_16)
                            {
                                _loc_16 = StringUtil.substitute(_loc_16, _loc_1);
                                if (_loc_16)
                                {
                                    _loc_16 = StringUtil.trim(_loc_16);
                                    if (_loc_16)
                                    {
                                        _loc_10.push(_loc_11);
                                    }
                                }
                            }
                            break;
                        }
                        case PopUpMediaInfo.BAR_CHART:
                        case PopUpMediaInfo.COLUMN_CHART:
                        case PopUpMediaInfo.LINE_CHART:
                        case PopUpMediaInfo.PIE_CHART:
                        {
                            for each (_loc_17 in _loc_11.chartFields)
                            {
                                
                                if (_loc_1[_loc_17] != null)
                                {
                                    _loc_10.push(_loc_11);
                                    break;
                                }
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                this._validPopUpMediaInfos = _loc_10;
            }
            return;
        }// end function

        private function formatValue(fieldValue:Object, fieldInfo:PopUpFieldInfo, layerDetails:LayerDetails) : Object
        {
            var _loc_7:Field = null;
            var _loc_9:Field = null;
            var _loc_10:Date = null;
            var _loc_11:String = null;
            var _loc_12:String = null;
            if (fieldValue != null)
            {
            }
            if (fieldInfo)
            {
            }
            if (!fieldInfo.format)
            {
                return fieldValue;
            }
            var _loc_4:* = fieldValue;
            var _loc_5:* = fieldInfo.fieldName;
            var _loc_6:* = fieldInfo.format;
            var _loc_8:* = layerDetails ? (layerDetails.fields) : (null);
            for each (_loc_9 in _loc_8)
            {
                
                if (_loc_5 === _loc_9.name)
                {
                    _loc_7 = _loc_9;
                    break;
                }
            }
            if (_loc_7)
            {
                if (!fieldInfo.label)
                {
                    fieldInfo.label = _loc_7.alias;
                }
                if (_loc_7.type === Field.TYPE_DATE)
                {
                }
                if (fieldValue is Number)
                {
                    _loc_10 = new Date(fieldValue);
                    if (_loc_10.milliseconds === 999)
                    {
                        var _loc_13:* = _loc_10;
                        var _loc_14:* = _loc_10.milliseconds + 1;
                        _loc_13.milliseconds = _loc_14;
                    }
                    if (_loc_6.useUTC)
                    {
                        _loc_10.minutes = _loc_10.minutes + _loc_10.timezoneOffset;
                    }
                    fieldValue = _loc_10;
                }
            }
            if (fieldValue is Number)
            {
                if (_loc_6.precision < 0)
                {
                    this._numberFormatter.rounding = NumberBaseRoundType.NONE;
                }
                else
                {
                    this._numberFormatter.rounding = NumberBaseRoundType.NEAREST;
                }
                this._numberFormatter.precision = _loc_6.precision;
                this._numberFormatter.useThousandsSeparator = _loc_6.useThousandsSeparator;
                _loc_4 = this._numberFormatter.format(fieldValue);
            }
            else if (fieldValue is Date)
            {
                _loc_11 = _loc_6.dateFormat ? (_loc_6.dateFormat) : (PopUpFieldFormat.SHORT_DATE_SHORT_TIME);
                _loc_12 = resourceManager.getString(ESRIMessageCodes.ESRI_MESSAGES, "popUpFormat_" + _loc_11);
                if (_loc_12)
                {
                    this._dateFormatter.formatString = _loc_12;
                }
                else
                {
                    this._dateFormatter.formatString = _loc_11;
                }
                _loc_4 = this._dateFormatter.format(fieldValue);
                if (!_loc_4)
                {
                    _loc_4 = this._dateFormatter.error + " (" + this._dateFormatter.formatString + ")";
                }
            }
            return _loc_4;
        }// end function

        private function getDomainName(fieldName:String, fieldValue:Object, typeId:String, layerDetails:LayerDetails) : String
        {
            var _loc_5:String = null;
            var _loc_6:IDomain = null;
            var _loc_7:Boolean = false;
            var _loc_9:FeatureType = null;
            var _loc_10:Array = null;
            var _loc_11:Field = null;
            var _loc_12:Array = null;
            var _loc_13:CodedValue = null;
            var _loc_8:* = layerDetails.types;
            if (_loc_8)
            {
            }
            if (typeId)
            {
                for each (_loc_9 in _loc_8)
                {
                    
                    if (typeId === _loc_9.id)
                    {
                        _loc_7 = true;
                        _loc_6 = _loc_9.domains ? (_loc_9.domains[fieldName]) : (null);
                        break;
                    }
                }
            }
            if (!_loc_6)
            {
            }
            if (!_loc_7)
            {
                _loc_10 = layerDetails.fields;
                for each (_loc_11 in _loc_10)
                {
                    
                    if (fieldName === _loc_11.name)
                    {
                        _loc_6 = _loc_11.domain;
                        break;
                    }
                }
            }
            if (_loc_6 is CodedValueDomain)
            {
                _loc_12 = CodedValueDomain(_loc_6).codedValues;
                for each (_loc_13 in _loc_12)
                {
                    
                    if (fieldValue == _loc_13.code)
                    {
                        _loc_5 = _loc_13.name;
                        break;
                    }
                }
            }
            return _loc_5;
        }// end function

        private function getTypeName(typeId:String, layerDetails:LayerDetails) : String
        {
            var _loc_3:String = null;
            var _loc_5:FeatureType = null;
            var _loc_4:* = layerDetails.types;
            if (_loc_4)
            {
                for each (_loc_5 in _loc_4)
                {
                    
                    if (typeId === _loc_5.id)
                    {
                        _loc_3 = _loc_5.name;
                        break;
                    }
                }
            }
            return _loc_3;
        }// end function

    }
}
