package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.controls.sliderClasses.*;
    import mx.events.*;
    import spark.components.supportClasses.*;

    public class TimeSlider extends SkinnableComponent implements ITimeSlider
    {
        public var playPauseButton:ToggleButtonBase;
        public var pauseButton:ButtonBase;
        public var playButton:ButtonBase;
        public var nextButton:ButtonBase;
        public var previousButton:ButtonBase;
        public var slider:Slider;
        private var _timer:Timer;
        private var _isPlaying:Boolean;
        private var _isPlayingChanged:Boolean;
        private var _wasPlayingBeforeSeeking:Boolean;
        private var _excludeDataAtLeadingThumb:Boolean;
        private var _excludeDataAtLeadingThumbChanged:Boolean;
        private var _excludeDataAtTrailingThumb:Boolean;
        private var _excludeDataAtTrailingThumbChanged:Boolean;
        private var _loop:Boolean;
        private var _singleThumbAsTimeInstant:Boolean;
        private var _singleThumbAsTimeInstantChanged:Boolean;
        private var _thumbCount:int = 1;
        private var _thumbIndexes:Array;
        private var _thumbIndexesChanged:Boolean;
        private var _timeStops:Array;
        private var _timeStopsChanged:Boolean;
        private static var _skinParts:Object = {slider:true, nextButton:false, previousButton:false, playPauseButton:false, pauseButton:false, playButton:false};

        public function TimeSlider()
        {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.timer_timerHandler, false, 0, true);
            return;
        }// end function

        override public function set enabled(value:Boolean) : void
        {
            if (enabled != value)
            {
                invalidateSkinState();
            }
            super.enabled = value;
            return;
        }// end function

        public function get excludeDataAtLeadingThumb() : Boolean
        {
            return this._excludeDataAtLeadingThumb;
        }// end function

        public function set excludeDataAtLeadingThumb(value:Boolean) : void
        {
            if (this._excludeDataAtLeadingThumb != value)
            {
                this._excludeDataAtLeadingThumb = value;
                this._excludeDataAtLeadingThumbChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("excludeDataAtLeadingThumbChanged"));
            }
            return;
        }// end function

        public function get excludeDataAtTrailingThumb() : Boolean
        {
            return this._excludeDataAtTrailingThumb;
        }// end function

        public function set excludeDataAtTrailingThumb(value:Boolean) : void
        {
            if (this._excludeDataAtTrailingThumb != value)
            {
                this._excludeDataAtTrailingThumb = value;
                this._excludeDataAtTrailingThumbChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("excludeDataAtTrailingThumbChanged"));
            }
            return;
        }// end function

        public function get fullTimeExtent() : TimeExtent
        {
            var _loc_1:TimeExtent = null;
            if (this.timeStops)
            {
            }
            if (this.timeStops.length > 1)
            {
                _loc_1 = new TimeExtent();
                _loc_1.startTime = this.timeStops[0];
                _loc_1.endTime = this.timeStops[(this.timeStops.length - 1)];
            }
            return _loc_1;
        }// end function

        public function get loop() : Boolean
        {
            return this._loop;
        }// end function

        public function set loop(value:Boolean) : void
        {
            if (this._loop != value)
            {
                this._loop = value;
                dispatchEvent(new Event("loopChanged"));
            }
            return;
        }// end function

        public function get playing() : Boolean
        {
            return this._isPlaying;
        }// end function

        public function get singleThumbAsTimeInstant() : Boolean
        {
            return this._singleThumbAsTimeInstant;
        }// end function

        public function set singleThumbAsTimeInstant(value:Boolean) : void
        {
            if (this._singleThumbAsTimeInstant != value)
            {
                this._singleThumbAsTimeInstant = value;
                this._singleThumbAsTimeInstantChanged = true;
                invalidateProperties();
                dispatchEvent(new Event("singleThumbAsTimeInstantChanged"));
            }
            return;
        }// end function

        public function get thumbCount() : int
        {
            return this._thumbCount;
        }// end function

        public function set thumbCount(value:int) : void
        {
            var _loc_2:* = value > 2 ? (2) : (value);
            _loc_2 = value < 1 ? (1) : (_loc_2);
            if (this._thumbCount != _loc_2)
            {
                this._thumbCount = _loc_2;
                if (this.slider)
                {
                    this.slider.thumbCount = _loc_2;
                }
                dispatchEvent(new Event("thumbCountChanged"));
            }
            return;
        }// end function

        public function get thumbIndexes() : Array
        {
            if (this.slider)
            {
            }
            if (this.timeStops)
            {
                return this.thumbCount == 1 ? ([this.slider.value]) : (this.slider.values);
            }
            else
            {
                return this._thumbIndexes;
            }
        }// end function

        public function set thumbIndexes(value:Array) : void
        {
            this._thumbIndexes = value;
            this._thumbIndexesChanged = true;
            invalidateProperties();
            return;
        }// end function

        public function get thumbMovingRate() : int
        {
            return this._timer.delay;
        }// end function

        public function set thumbMovingRate(value:int) : void
        {
            if (this._timer.delay != value)
            {
                this._timer.delay = value;
                dispatchEvent(new Event("thumbMovingRateChanged"));
            }
            return;
        }// end function

        public function get timeExtent() : TimeExtent
        {
            var _loc_1:TimeExtent = null;
            if (this.timeStops)
            {
            }
            if (this.timeStops.length > 1)
            {
            }
            if (this.slider)
            {
                _loc_1 = new TimeExtent();
                if (this.thumbCount == 1)
                {
                    if (this.singleThumbAsTimeInstant)
                    {
                        _loc_1.startTime = this.timeStops[this.slider.value];
                        _loc_1.endTime = _loc_1.startTime;
                    }
                    else
                    {
                        _loc_1.startTime = this.timeStops[0];
                        _loc_1.endTime = this.timeStops[this.slider.value];
                    }
                }
                else
                {
                    _loc_1.startTime = this.timeStops[this.slider.values[0]];
                    _loc_1.endTime = this.timeStops[this.slider.values[1]];
                }
                _loc_1.startTime = _loc_1.startTime ? (new Date(_loc_1.startTime.time)) : (null);
                _loc_1.endTime = _loc_1.endTime ? (new Date(_loc_1.endTime.time)) : (null);
                if (this.excludeDataAtLeadingThumb)
                {
                }
                if (this.thumbCount == 2)
                {
                }
                if (_loc_1.endTime)
                {
                    var _loc_2:* = _loc_1.endTime;
                    var _loc_3:* = _loc_1.endTime.seconds - 1;
                    _loc_2.seconds = _loc_3;
                }
                if (this.excludeDataAtTrailingThumb)
                {
                }
                if (this.thumbCount == 2)
                {
                }
                if (_loc_1.startTime)
                {
                    var _loc_2:* = _loc_1.startTime;
                    var _loc_3:* = _loc_1.startTime.seconds + 1;
                    _loc_2.seconds = _loc_3;
                }
            }
            return _loc_1;
        }// end function

        public function get timeStops() : Array
        {
            return this._timeStops;
        }// end function

        public function set timeStops(value:Array) : void
        {
            this._timeStops = value;
            this._timeStopsChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("timeStopsChanged"));
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Boolean = false;
            super.commitProperties();
            var _loc_2:* = this.slider.maximum;
            if (this._timeStopsChanged)
            {
                if (this.slider)
                {
                    if (this.timeStops)
                    {
                    }
                    if (this.timeStops.length > 0)
                    {
                        this.slider.maximum = this.timeStops.length - 1;
                        if (this._thumbIndexes)
                        {
                        }
                        if (!this._thumbIndexesChanged)
                        {
                            this.slider.values = this._thumbIndexes;
                        }
                    }
                    else
                    {
                        this.slider.maximum = 0;
                    }
                }
            }
            if (_loc_2 > this.slider.maximum)
            {
                _loc_1 = true;
            }
            if (this._thumbIndexesChanged)
            {
                if (this.slider)
                {
                }
                if (this.timeStops)
                {
                    this.slider.values = this._thumbIndexes;
                }
            }
            if (!this._excludeDataAtLeadingThumbChanged)
            {
            }
            if (!this._excludeDataAtTrailingThumbChanged)
            {
            }
            if (!this._singleThumbAsTimeInstantChanged)
            {
            }
            if (!this._timeStopsChanged)
            {
            }
            if (this._thumbIndexesChanged)
            {
                if (this.slider)
                {
                }
                if (this.timeStops)
                {
                }
                if (!_loc_1)
                {
                    if (this.thumbCount == 2)
                    {
                        if (!this._excludeDataAtLeadingThumbChanged)
                        {
                        }
                    }
                    if (this._excludeDataAtTrailingThumbChanged)
                    {
                        this.dispatchTimeExtentEvent();
                    }
                    else
                    {
                        if (this.thumbCount == 1)
                        {
                        }
                        if (this._singleThumbAsTimeInstantChanged)
                        {
                            this.dispatchTimeExtentEvent();
                        }
                        else
                        {
                            if (!this._timeStopsChanged)
                            {
                            }
                            if (this._thumbIndexesChanged)
                            {
                                this.dispatchTimeExtentEvent();
                            }
                        }
                    }
                }
                this._excludeDataAtLeadingThumbChanged = false;
                this._excludeDataAtTrailingThumbChanged = false;
                this._singleThumbAsTimeInstantChanged = false;
                this._timeStopsChanged = false;
                this._thumbIndexesChanged = false;
            }
            if (this._isPlayingChanged)
            {
                this._isPlayingChanged = false;
                if (this._isPlaying)
                {
                    if (this.isAtStart())
                    {
                        this.isAtStart();
                    }
                    if (this.isAtEnd())
                    {
                        this.playPauseButton.selected = false;
                    }
                    else
                    {
                        if (this.isAtEnd())
                        {
                            this.moveToStart();
                        }
                        this._timer.start();
                        if (this.playPauseButton)
                        {
                            this.playPauseButton.selected = true;
                        }
                    }
                }
                else
                {
                    this._timer.reset();
                    if (this.playPauseButton)
                    {
                        this.playPauseButton.selected = false;
                    }
                }
            }
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            return enabled ? ("normal") : ("disabled");
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance == this.nextButton)
            {
                this.nextButton.addEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
            }
            else if (instance == this.pauseButton)
            {
                this.pauseButton.addEventListener(MouseEvent.CLICK, this.pauseButton_clickHandler);
            }
            else if (instance == this.playButton)
            {
                this.playButton.addEventListener(MouseEvent.CLICK, this.playButton_clickHandler);
            }
            else if (instance == this.playPauseButton)
            {
                this.playPauseButton.addEventListener(MouseEvent.CLICK, this.playPauseButton_clickHandler);
            }
            else if (instance == this.previousButton)
            {
                this.previousButton.addEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
            }
            else if (instance == this.slider)
            {
                this.slider.allowThumbOverlap = false;
                this.slider.snapInterval = 1;
                this.slider.thumbCount = this.thumbCount;
                this.slider.minimum = 0;
                this.slider.maximum = this.timeStops ? ((this.timeStops.length - 1)) : (0);
                if (this._thumbIndexes)
                {
                }
                if (this.timeStops)
                {
                    this.slider.values = this._thumbIndexes;
                }
                this.slider.addEventListener(SliderEvent.CHANGE, this.slider_changeHandler);
                this.slider.addEventListener(SliderEvent.THUMB_PRESS, this.slider_thumbPressHandler);
                this.slider.addEventListener(SliderEvent.THUMB_RELEASE, this.slider_thumbReleaseHandler);
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance == this.nextButton)
            {
                this.nextButton.removeEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
            }
            else if (instance == this.pauseButton)
            {
                this.pauseButton.removeEventListener(MouseEvent.CLICK, this.pauseButton_clickHandler);
            }
            else if (instance == this.playButton)
            {
                this.playButton.removeEventListener(MouseEvent.CLICK, this.playButton_clickHandler);
            }
            else if (instance == this.playPauseButton)
            {
                this.playPauseButton.removeEventListener(MouseEvent.CLICK, this.playPauseButton_clickHandler);
            }
            else if (instance == this.previousButton)
            {
                this.previousButton.removeEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
            }
            else if (instance == this.slider)
            {
                this.slider.removeEventListener(SliderEvent.CHANGE, this.slider_changeHandler);
                this.slider.removeEventListener(SliderEvent.THUMB_PRESS, this.slider_thumbPressHandler);
                this.slider.removeEventListener(SliderEvent.THUMB_RELEASE, this.slider_thumbReleaseHandler);
            }
            return;
        }// end function

        public function createTimeStopsByCount(timeExtent:TimeExtent, count:int = 10) : void
        {
            if (timeExtent)
            {
            }
            if (timeExtent.startTime)
            {
            }
            if (!timeExtent.endTime)
            {
                return;
            }
            var _loc_3:* = Math.max(2, count);
            var _loc_4:* = timeExtent.startTime.time;
            var _loc_5:* = timeExtent.endTime.time;
            var _loc_6:* = _loc_5 - _loc_4;
            var _loc_7:* = _loc_6 / (_loc_3 - 1);
            var _loc_8:Array = [new Date(_loc_4)];
            var _loc_9:int = 1;
            while (_loc_9 < (_loc_3 - 1))
            {
                
                _loc_4 = _loc_4 + _loc_7;
                _loc_8.push(new Date(_loc_4));
                _loc_9 = _loc_9 + 1;
            }
            _loc_8.push(new Date(_loc_5));
            this.timeStops = _loc_8;
            return;
        }// end function

        public function createTimeStopsByTimeInterval(timeExtent:TimeExtent, timeInterval:Number, timeIntervalUnits:String) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:String = null;
            var _loc_11:Number = NaN;
            var _loc_12:Date = null;
            var _loc_4:* = TimeInfo.UNIT_TIMES_MS[timeIntervalUnits];
            if (timeExtent)
            {
            }
            if (timeExtent.startTime)
            {
            }
            if (timeExtent.endTime)
            {
            }
            if (!isNaN(timeInterval))
            {
                isNaN(timeInterval);
            }
            if (timeInterval > 0)
            {
            }
            if (isNaN(_loc_4))
            {
                return;
            }
            var _loc_5:* = timeExtent.startTime.time;
            var _loc_6:* = timeExtent.endTime.time;
            var _loc_7:Array = [new Date(_loc_5)];
            var _loc_8:* = Math.floor(timeInterval) == timeInterval;
            if (_loc_8)
            {
            }
            if (timeIntervalUnits != TimeInfo.UNIT_MILLISECONDS)
            {
            }
            if (timeIntervalUnits != TimeInfo.UNIT_SECONDS)
            {
            }
            if (timeIntervalUnits != TimeInfo.UNIT_MINUTES)
            {
            }
            if (timeIntervalUnits != TimeInfo.UNIT_HOURS)
            {
            }
            if (timeIntervalUnits != TimeInfo.UNIT_DAYS)
            {
            }
            if (timeIntervalUnits == TimeInfo.UNIT_WEEKS)
            {
                _loc_9 = timeInterval * _loc_4;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5 = _loc_5 + _loc_9;
                    _loc_7.push(new Date(_loc_5));
                }
                this.timeStops = _loc_7;
            }
            else
            {
                switch(timeIntervalUnits)
                {
                    case TimeInfo.UNIT_MONTHS:
                    {
                        _loc_10 = "monthUTC";
                        _loc_11 = 1;
                        break;
                    }
                    case TimeInfo.UNIT_YEARS:
                    {
                        _loc_10 = "fullYearUTC";
                        _loc_11 = 1;
                        break;
                    }
                    case TimeInfo.UNIT_DECADES:
                    {
                        _loc_10 = "fullYearUTC";
                        _loc_11 = 10;
                        break;
                    }
                    case TimeInfo.UNIT_CENTURIES:
                    {
                        _loc_10 = "fullYearUTC";
                        _loc_11 = 100;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (_loc_10)
                {
                    while (_loc_5 < _loc_6)
                    {
                        
                        _loc_12 = new Date(_loc_5);
                        _loc_12[_loc_10] = _loc_12[_loc_10] + timeInterval * _loc_11;
                        _loc_7.push(_loc_12);
                        _loc_5 = _loc_12.time;
                    }
                    this.timeStops = _loc_7;
                }
            }
            return;
        }// end function

        public function play() : void
        {
            if (!this.playing)
            {
                this._isPlaying = true;
                this._isPlayingChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function pause() : void
        {
            if (this.playing)
            {
                this._isPlaying = false;
                this._isPlayingChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function next() : void
        {
            this.pause();
            this.stepForward();
            return;
        }// end function

        private function stepForward() : void
        {
            var _loc_1:int = 0;
            if (this.timeStops)
            {
            }
            if (this.thumbIndexes)
            {
            }
            if (!this.isAtEnd())
            {
                _loc_1 = 0;
                while (_loc_1 < this.thumbIndexes.length)
                {
                    
                    if (this.thumbIndexes[_loc_1] < (this.timeStops.length - 1))
                    {
                        this.setThumbAt(_loc_1, (this.thumbIndexes[_loc_1] + 1));
                    }
                    _loc_1 = _loc_1 + 1;
                }
                this.dispatchTimeExtentEvent();
            }
            return;
        }// end function

        private function isAtEnd() : Boolean
        {
            var _loc_1:Boolean = true;
            if (this.slider)
            {
            }
            if (this.thumbIndexes)
            {
            }
            if (this.thumbIndexes.length > 0)
            {
            }
            if (this.thumbIndexes[(this.thumbIndexes.length - 1)] < this.slider.maximum)
            {
                _loc_1 = false;
            }
            return _loc_1;
        }// end function

        public function previous() : void
        {
            this.pause();
            this.stepBack();
            return;
        }// end function

        private function stepBack() : void
        {
            var _loc_1:int = 0;
            if (this.timeStops)
            {
            }
            if (this.thumbIndexes)
            {
            }
            if (!this.isAtStart())
            {
                _loc_1 = 0;
                while (_loc_1 < this.thumbIndexes.length)
                {
                    
                    if (this.thumbIndexes[_loc_1] > 0)
                    {
                        this.setThumbAt(_loc_1, (this.thumbIndexes[_loc_1] - 1));
                    }
                    _loc_1 = _loc_1 + 1;
                }
                this.dispatchTimeExtentEvent();
            }
            return;
        }// end function

        private function isAtStart() : Boolean
        {
            var _loc_1:Boolean = true;
            if (this.thumbIndexes)
            {
            }
            if (this.thumbIndexes.length > 0)
            {
            }
            if (this.thumbIndexes[0] > 0)
            {
                _loc_1 = false;
            }
            return _loc_1;
        }// end function

        private function moveToStart() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            if (this.timeStops)
            {
            }
            if (this.thumbIndexes)
            {
            }
            if (!this.isAtStart())
            {
                _loc_1 = this.thumbIndexes[0];
                _loc_2 = 0;
                while (_loc_2 < this.thumbIndexes.length)
                {
                    
                    if (this.thumbIndexes[_loc_2] > 0)
                    {
                        this.setThumbAt(_loc_2, this.thumbIndexes[_loc_2] - _loc_1);
                    }
                    _loc_2 = _loc_2 + 1;
                }
                this.dispatchTimeExtentEvent();
            }
            return;
        }// end function

        private function setThumbAt(thumbIndex:int, timeStopIndex:int) : void
        {
            if (this.slider)
            {
                this.slider.setThumbValueAt(thumbIndex, timeStopIndex);
            }
            return;
        }// end function

        private function dispatchTimeExtentEvent() : void
        {
            dispatchEvent(new TimeExtentEvent(this.timeExtent));
            return;
        }// end function

        private function nextButton_clickHandler(event:MouseEvent) : void
        {
            this.next();
            return;
        }// end function

        private function pauseButton_clickHandler(event:MouseEvent) : void
        {
            this.pause();
            return;
        }// end function

        private function playButton_clickHandler(event:MouseEvent) : void
        {
            this.play();
            return;
        }// end function

        private function playPauseButton_clickHandler(event:MouseEvent) : void
        {
            if (this.playing)
            {
                this.pause();
            }
            else
            {
                this.play();
            }
            return;
        }// end function

        private function previousButton_clickHandler(event:MouseEvent) : void
        {
            this.previous();
            return;
        }// end function

        private function slider_changeHandler(event:SliderEvent) : void
        {
            if (this.playing)
            {
            }
            if (event.clickTarget == SliderEventClickTarget.TRACK)
            {
                this._timer.reset();
                this._timer.start();
            }
            this.dispatchTimeExtentEvent();
            return;
        }// end function

        private function slider_thumbPressHandler(event:SliderEvent) : void
        {
            if (this.playing)
            {
                this._wasPlayingBeforeSeeking = true;
                this.pause();
            }
            return;
        }// end function

        private function slider_thumbReleaseHandler(event:SliderEvent) : void
        {
            if (this._wasPlayingBeforeSeeking)
            {
                this._wasPlayingBeforeSeeking = false;
                this.play();
            }
            return;
        }// end function

        private function timer_timerHandler(event:TimerEvent) : void
        {
            if (this.isAtStart())
            {
                this.isAtStart();
            }
            if (this.isAtEnd())
            {
                this.pause();
            }
            else
            {
                if (this.loop)
                {
                }
                if (this.isAtEnd())
                {
                    this.moveToStart();
                }
                else
                {
                    this.stepForward();
                    if (!this.loop)
                    {
                    }
                    if (this.isAtEnd())
                    {
                        this.pause();
                    }
                }
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
