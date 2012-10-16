package com.esri.ags.symbols
{
    import mx.events.*;

    public class LineSymbol extends Symbol
    {
        protected var m_width:Number = 1;
        protected var m_color:uint;
        protected var m_alpha:Number;

        public function LineSymbol()
        {
            return;
        }// end function

        public function get width() : Number
        {
            return this.m_width;
        }// end function

        private function set _113126854width(value:Number) : void
        {
            if (value != this.m_width)
            {
                this.m_width = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this.m_color;
        }// end function

        private function set _94842723color(value:uint) : void
        {
            if (value != this.m_color)
            {
                this.m_color = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get alpha() : Number
        {
            return this.m_alpha;
        }// end function

        private function set _92909918alpha(value:Number) : void
        {
            if (value != this.m_alpha)
            {
                this.m_alpha = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function set color(value:uint) : void
        {
            arguments = this.color;
            if (arguments !== value)
            {
                this._94842723color = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "color", arguments, value));
                }
            }
            return;
        }// end function

        public function set alpha(value:Number) : void
        {
            arguments = this.alpha;
            if (arguments !== value)
            {
                this._92909918alpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "alpha", arguments, value));
                }
            }
            return;
        }// end function

        public function set width(value:Number) : void
        {
            arguments = this.width;
            if (arguments !== value)
            {
                this._113126854width = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "width", arguments, value));
                }
            }
            return;
        }// end function

    }
}
