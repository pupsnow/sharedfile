package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class ParameterValue extends EventDispatcher
    {
        private var _1953757368paramName:String;
        private var _1789070852dataType:String;
        private var _111972721value:Object;

        public function ParameterValue()
        {
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_1:String = null;
            var _loc_2:ParameterValue = null;
            if (this.value is FeatureSet)
            {
                _loc_2 = new ParameterValue();
                _loc_2.dataType = this.dataType;
                _loc_2.paramName = this.paramName;
                _loc_2.value = this.value.toString();
                _loc_1 = ObjectUtil.toString(_loc_2);
            }
            else
            {
                _loc_1 = ObjectUtil.toString(this);
            }
            return _loc_1;
        }// end function

        public function get paramName() : String
        {
            return this._1953757368paramName;
        }// end function

        public function set paramName(value:String) : void
        {
            arguments = this._1953757368paramName;
            if (arguments !== value)
            {
                this._1953757368paramName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paramName", arguments, value));
                }
            }
            return;
        }// end function

        public function get dataType() : String
        {
            return this._1789070852dataType;
        }// end function

        public function set dataType(value:String) : void
        {
            arguments = this._1789070852dataType;
            if (arguments !== value)
            {
                this._1789070852dataType = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dataType", arguments, value));
                }
            }
            return;
        }// end function

        public function get value() : Object
        {
            return this._111972721value;
        }// end function

        public function set value(value:Object) : void
        {
            arguments = this._111972721value;
            if (arguments !== value)
            {
                this._111972721value = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", arguments, value));
                }
            }
            return;
        }// end function

        static function toParameterValue(obj:Object, token:String = null) : ParameterValue
        {
            var _loc_7:Array = null;
            var _loc_8:String = null;
            var _loc_9:Object = null;
            var _loc_3:* = new ParameterValue;
            var _loc_4:* = obj.paramName;
            var _loc_5:* = obj.dataType;
            var _loc_6:* = obj.value;
            _loc_3.paramName = _loc_4;
            _loc_3.dataType = _loc_5;
            if (_loc_6 is Array)
            {
            }
            if (_loc_5)
            {
            }
            if (_loc_5.indexOf("GPMultiValue:") === 0)
            {
                _loc_7 = [];
                _loc_8 = _loc_5.substring("GPMultiValue:".length);
                for each (_loc_9 in _loc_6)
                {
                    
                    _loc_7.push(toValue(_loc_8, _loc_9, token));
                }
                _loc_3.value = _loc_7;
            }
            else
            {
                _loc_3.value = toValue(_loc_5, _loc_6, token);
            }
            return _loc_3;
        }// end function

        static function toValue(dataType:String, obj:Object, token:String) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:Date = null;
            var _loc_6:Number = NaN;
            var _loc_7:String = null;
            var _loc_8:DataFile = null;
            var _loc_9:MapImage = null;
            var _loc_10:RasterData = null;
            if (dataType == "GPFeatureRecordSetLayer")
            {
                if (obj.mapImage)
                {
                    _loc_4 = MapImage.toMapImage(obj.mapImage);
                }
                else
                {
                    _loc_4 = FeatureSet.fromJSON(obj);
                }
            }
            else if (dataType == "GPLinearUnit")
            {
                _loc_4 = LinearUnit.toLinearUnit(obj);
            }
            else if (dataType == "GPRasterDataLayer")
            {
                if (obj is String)
                {
                    _loc_4 = obj;
                }
                if (obj.mapImage)
                {
                    _loc_4 = MapImage.toMapImage(obj.mapImage);
                }
                else
                {
                    _loc_4 = RasterData.toRasterData(obj);
                }
            }
            else if (dataType == "GPDataFile")
            {
                _loc_4 = DataFile.toDataFile(obj);
            }
            else if (dataType == "GPRecordSet")
            {
                _loc_4 = FeatureSet.fromJSON(obj);
            }
            else if (dataType == "GPDate")
            {
                if (obj is Number)
                {
                    _loc_5 = new Date(obj);
                }
                else
                {
                    _loc_6 = Date.parse(obj);
                    if (!isNaN(_loc_6))
                    {
                        _loc_5 = new Date(_loc_6);
                    }
                    else
                    {
                        _loc_7 = String(obj);
                        _loc_5 = DateUtil.parseDate(_loc_7);
                    }
                }
                _loc_4 = _loc_5;
            }
            else
            {
                _loc_4 = obj;
            }
            if (_loc_4 is DataFile)
            {
                _loc_8 = _loc_4 as DataFile;
                _loc_8.url = appendToken(_loc_8.url, token);
            }
            else if (_loc_4 is MapImage)
            {
                _loc_9 = _loc_4 as MapImage;
                if (_loc_9.source is String)
                {
                    _loc_9.source = appendToken(String(_loc_9.source), token);
                }
            }
            else if (_loc_4 is RasterData)
            {
                _loc_10 = _loc_4 as RasterData;
                _loc_10.url = appendToken(_loc_10.url, token);
            }
            return _loc_4;
        }// end function

        static function appendToken(url:String, token:String) : String
        {
            if (url)
            {
            }
            if (token)
            {
                url = url + (url.indexOf("?") === -1 ? ("?") : ("&"));
                url = url + ("token=" + encodeURIComponent(token));
            }
            return url;
        }// end function

    }
}
