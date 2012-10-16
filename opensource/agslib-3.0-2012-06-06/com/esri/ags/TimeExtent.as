package com.esri.ags
{
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class TimeExtent extends EventDispatcher implements IJSONSupport
    {
        private var _1607243192endTime:Date;
        private var _2129294769startTime:Date;

        public function TimeExtent(startTime:Date = null, endTime:Date = null)
        {
            this.startTime = startTime;
            this.endTime = endTime;
            return;
        }// end function

        private function isTimeInstant() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this.startTime)
            {
            }
            if (this.endTime)
            {
                _loc_1 = this.startTime.time === this.endTime.time;
            }
            return _loc_1;
        }// end function

        public function intersects(timeExtent:TimeExtent) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (timeExtent)
            {
                _loc_3 = this.startTime ? (this.startTime.time) : (-Infinity);
                _loc_4 = timeExtent.startTime ? (timeExtent.startTime.time) : (-Infinity);
                _loc_5 = this.endTime ? (this.endTime.time) : (Infinity);
                _loc_6 = timeExtent.endTime ? (timeExtent.endTime.time) : (Infinity);
                if (_loc_4 >= _loc_3)
                {
                }
                if (_loc_4 <= _loc_5)
                {
                    _loc_7 = _loc_4;
                }
                else
                {
                    if (_loc_3 >= _loc_4)
                    {
                    }
                    if (_loc_3 <= _loc_6)
                    {
                        _loc_7 = _loc_3;
                    }
                }
                if (_loc_5 >= _loc_4)
                {
                }
                if (_loc_5 <= _loc_6)
                {
                    _loc_8 = _loc_5;
                }
                else
                {
                    if (_loc_6 >= _loc_3)
                    {
                    }
                    if (_loc_6 <= _loc_5)
                    {
                        _loc_8 = _loc_6;
                    }
                }
                if (!isNaN(_loc_7))
                {
                }
                if (!isNaN(_loc_8))
                {
                    _loc_2 = true;
                }
            }
            return _loc_2;
        }// end function

        public function intersection(timeExtent:TimeExtent) : TimeExtent
        {
            var _loc_2:TimeExtent = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (timeExtent)
            {
                _loc_3 = this.startTime ? (this.startTime.time) : (-Infinity);
                _loc_4 = timeExtent.startTime ? (timeExtent.startTime.time) : (-Infinity);
                _loc_5 = this.endTime ? (this.endTime.time) : (Infinity);
                _loc_6 = timeExtent.endTime ? (timeExtent.endTime.time) : (Infinity);
                if (_loc_4 >= _loc_3)
                {
                }
                if (_loc_4 <= _loc_5)
                {
                    _loc_7 = _loc_4;
                }
                else
                {
                    if (_loc_3 >= _loc_4)
                    {
                    }
                    if (_loc_3 <= _loc_6)
                    {
                        _loc_7 = _loc_3;
                    }
                }
                if (_loc_5 >= _loc_4)
                {
                }
                if (_loc_5 <= _loc_6)
                {
                    _loc_8 = _loc_5;
                }
                else
                {
                    if (_loc_6 >= _loc_3)
                    {
                    }
                    if (_loc_6 <= _loc_5)
                    {
                        _loc_8 = _loc_6;
                    }
                }
                if (!isNaN(_loc_7))
                {
                }
                if (!isNaN(_loc_8))
                {
                    _loc_2 = new TimeExtent();
                    _loc_2.startTime = _loc_7 === -Infinity ? (null) : (new Date(_loc_7));
                    _loc_2.endTime = _loc_8 === Infinity ? (null) : (new Date(_loc_8));
                }
            }
            return _loc_2;
        }// end function

        public function offset(timeOffset:Number, timeOffsetUnits:String) : TimeExtent
        {
            var _loc_5:Boolean = false;
            var _loc_6:Number = NaN;
            var _loc_7:String = null;
            var _loc_8:Number = NaN;
            var _loc_3:* = new TimeExtent();
            var _loc_4:* = TimeInfo.UNIT_TIMES_MS[timeOffsetUnits];
            if (!isNaN(_loc_4))
            {
            }
            if (!isNaN(timeOffset))
            {
                if (!this.startTime)
                {
                }
            }
            if (this.endTime)
            {
                _loc_5 = Math.floor(timeOffset) == timeOffset;
                if (_loc_5)
                {
                }
                if (timeOffsetUnits != TimeInfo.UNIT_MILLISECONDS)
                {
                }
                if (timeOffsetUnits != TimeInfo.UNIT_SECONDS)
                {
                }
                if (timeOffsetUnits != TimeInfo.UNIT_MINUTES)
                {
                }
                if (timeOffsetUnits != TimeInfo.UNIT_HOURS)
                {
                }
                if (timeOffsetUnits != TimeInfo.UNIT_DAYS)
                {
                }
                if (timeOffsetUnits == TimeInfo.UNIT_WEEKS)
                {
                    _loc_6 = timeOffset * _loc_4;
                    if (this.startTime)
                    {
                        _loc_3.startTime = new Date(this.startTime.time + _loc_6);
                    }
                    if (this.endTime)
                    {
                        _loc_3.endTime = new Date(this.endTime.time + _loc_6);
                    }
                }
                else
                {
                    switch(timeOffsetUnits)
                    {
                        case TimeInfo.UNIT_MONTHS:
                        {
                            _loc_7 = "month";
                            _loc_8 = 1;
                            break;
                        }
                        case TimeInfo.UNIT_YEARS:
                        {
                            _loc_7 = "fullYear";
                            _loc_8 = 1;
                            break;
                        }
                        case TimeInfo.UNIT_DECADES:
                        {
                            _loc_7 = "fullYear";
                            _loc_8 = 10;
                            break;
                        }
                        case TimeInfo.UNIT_CENTURIES:
                        {
                            _loc_7 = "fullYear";
                            _loc_8 = 100;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (_loc_7)
                    {
                        if (this.startTime)
                        {
                            _loc_3.startTime = new Date(this.startTime.time);
                            _loc_3.startTime[_loc_7] = _loc_3.startTime[_loc_7] + timeOffset * _loc_8;
                        }
                        if (this.endTime)
                        {
                            _loc_3.endTime = new Date(this.endTime.time);
                            _loc_3.endTime[_loc_7] = _loc_3.endTime[_loc_7] + timeOffset * _loc_8;
                        }
                    }
                }
            }
            else
            {
                _loc_3.startTime = this.startTime ? (new Date(this.startTime.time)) : (null);
                _loc_3.endTime = this.endTime ? (new Date(this.endTime.time)) : (null);
            }
            return _loc_3;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function union(timeExtent:TimeExtent) : TimeExtent
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_2:* = new TimeExtent();
            if (timeExtent)
            {
                _loc_3 = this.startTime ? (this.startTime.time) : (-Infinity);
                _loc_4 = timeExtent.startTime ? (timeExtent.startTime.time) : (-Infinity);
                _loc_5 = this.endTime ? (this.endTime.time) : (Infinity);
                _loc_6 = timeExtent.endTime ? (timeExtent.endTime.time) : (Infinity);
                _loc_7 = Math.min(_loc_3, _loc_4);
                _loc_8 = Math.max(_loc_5, _loc_6);
                _loc_2.startTime = _loc_7 === -Infinity ? (null) : (new Date(_loc_7));
                _loc_2.endTime = _loc_8 === Infinity ? (null) : (new Date(_loc_8));
            }
            return _loc_2;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Array = [];
            if (this.isTimeInstant())
            {
                _loc_2[0] = this.startTime.time;
            }
            else
            {
                _loc_2[0] = this.startTime ? (this.startTime.time) : (null);
                _loc_2[1] = this.endTime ? (this.endTime.time) : (null);
            }
            return _loc_2;
        }// end function

        function toTimeParam() : String
        {
            var _loc_1:String = null;
            if (this.isTimeInstant())
            {
                _loc_1 = String(this.startTime.time);
            }
            else
            {
                _loc_1 = (this.startTime ? (String(this.startTime.time)) : ("null")) + "," + (this.endTime ? (String(this.endTime.time)) : ("null"));
            }
            return _loc_1;
        }// end function

        public function get endTime() : Date
        {
            return this._1607243192endTime;
        }// end function

        public function set endTime(value:Date) : void
        {
            arguments = this._1607243192endTime;
            if (arguments !== value)
            {
                this._1607243192endTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "endTime", arguments, value));
                }
            }
            return;
        }// end function

        public function get startTime() : Date
        {
            return this._2129294769startTime;
        }// end function

        public function set startTime(value:Date) : void
        {
            arguments = this._2129294769startTime;
            if (arguments !== value)
            {
                this._2129294769startTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "startTime", arguments, value));
                }
            }
            return;
        }// end function

        static function fromJSON(obj:Object) : TimeExtent
        {
            var _loc_2:TimeExtent = null;
            var _loc_3:Array = null;
            if (obj is Array)
            {
                _loc_3 = obj as Array;
                if (_loc_3.length == 1)
                {
                    _loc_2 = new TimeExtent;
                    _loc_2.endTime = new Date(_loc_3[0]);
                    _loc_2.startTime = new Date(_loc_3[0]);
                }
                else if (_loc_3.length == 2)
                {
                    _loc_2 = new TimeExtent;
                    if (_loc_3[1] != null)
                    {
                        _loc_2.endTime = new Date(_loc_3[1]);
                    }
                    if (_loc_3[0] != null)
                    {
                        _loc_2.startTime = new Date(_loc_3[0]);
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
