package com.esri.ags.symbols
{
    import mx.events.*;

    public class MarkerSymbol extends Symbol
    {
        protected var m_angle:Number = 0;
        protected var m_xoffset:Number = 0;
        protected var m_yoffset:Number = 0;

        public function MarkerSymbol()
        {
            return;
        }// end function

        public function get angle() : Number
        {
            return this.m_angle;
        }// end function

        private function set _92960979angle(value:Number) : void
        {
            if (value != this.m_angle)
            {
                this.m_angle = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get xoffset() : Number
        {
            return this.m_xoffset;
        }// end function

        private function set _1893520629xoffset(value:Number) : void
        {
            if (value != this.m_xoffset)
            {
                this.m_xoffset = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get yoffset() : Number
        {
            return this.m_yoffset;
        }// end function

        private function set _1006016948yoffset(value:Number) : void
        {
            if (value != this.m_yoffset)
            {
                this.m_yoffset = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function set xoffset(value:Number) : void
        {
            arguments = this.xoffset;
            if (arguments !== value)
            {
                this._1893520629xoffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xoffset", arguments, value));
                }
            }
            return;
        }// end function

        public function set yoffset(value:Number) : void
        {
            arguments = this.yoffset;
            if (arguments !== value)
            {
                this._1006016948yoffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "yoffset", arguments, value));
                }
            }
            return;
        }// end function

        public function set angle(value:Number) : void
        {
            arguments = this.angle;
            if (arguments !== value)
            {
                this._92960979angle = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "angle", arguments, value));
                }
            }
            return;
        }// end function

    }
}
