package com.esri.ags.symbols.supportClasses
{
    import __AS3__.vec.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.events.*;

    public class SymbolStyle extends EventDispatcher
    {
        protected var m_symbol:Symbol;
        private static const RAD_PER_DEG:Number = 0.0174533;

        public function SymbolStyle()
        {
            return;
        }// end function

        public function get symbol() : Symbol
        {
            return this.m_symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            if (this.m_symbol)
            {
                this.m_symbol.removeEventListener(Event.CHANGE, this.handleSymbolChange);
            }
            this.m_symbol = value;
            if (this.m_symbol)
            {
                this.updateStyle();
                this.m_symbol.addEventListener(Event.CHANGE, this.handleSymbolChange);
            }
            return;
        }// end function

        protected function rotatePoints(points:Vector.<Number>, origin:Point, angle:Number) : Rectangle
        {
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_4:* = Math.cos((360 - angle) * RAD_PER_DEG);
            var _loc_5:* = Math.sin((360 - angle) * RAD_PER_DEG);
            var _loc_6:* = points.length;
            var _loc_7:* = Number.MAX_VALUE;
            var _loc_8:* = Number.MIN_VALUE;
            var _loc_9:* = Number.MAX_VALUE;
            var _loc_10:* = Number.MIN_VALUE;
            var _loc_15:uint = 0;
            while (_loc_15 < _loc_6)
            {
                
                _loc_11 = points[_loc_15] - origin.x;
                _loc_12 = points[(_loc_15 + 1)] - origin.y;
                _loc_13 = _loc_11 * _loc_4 + _loc_12 * _loc_5 + origin.x;
                _loc_14 = (-_loc_11) * _loc_5 + _loc_12 * _loc_4 + origin.y;
                points[_loc_15] = _loc_13;
                points[(_loc_15 + 1)] = _loc_14;
                _loc_7 = Math.min(_loc_7, _loc_13);
                _loc_8 = Math.max(_loc_8, _loc_13);
                _loc_9 = Math.min(_loc_9, _loc_14);
                _loc_10 = Math.max(_loc_10, _loc_14);
                _loc_15 = _loc_15 + 2;
            }
            return new Rectangle(_loc_7, _loc_9, _loc_8 - _loc_7, _loc_10 - _loc_9);
        }// end function

        protected function updateStyle() : void
        {
            return;
        }// end function

        protected function dispatchChangedEvent(prop:String, oldValue, value) : void
        {
            if (hasEventListener("propertyChange"))
            {
                dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop, oldValue, value));
            }
            return;
        }// end function

        private function handleSymbolChange(event:Event) : void
        {
            this.updateStyle();
            return;
        }// end function

    }
}
