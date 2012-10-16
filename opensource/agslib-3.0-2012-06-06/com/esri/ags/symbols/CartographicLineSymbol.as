package com.esri.ags.symbols
{
    import flash.display.*;
    import mx.events.*;

    public class CartographicLineSymbol extends SimpleLineSymbol
    {
        private var m_cap:String;
        private var m_join:String;
        private var m_miterLimit:Number;
        public static const CAP_BUTT:String = "butt";
        public static const CAP_ROUND:String = "round";
        public static const CAP_SQUARE:String = "square";
        public static const JOIN_MITER:String = "miter";
        public static const JOIN_ROUND:String = "round";
        public static const JOIN_BEVEL:String = "bevel";

        public function CartographicLineSymbol(style:String = "solid", color:Number = 0, alpha:Number = 1, width:Number = 1, cap:String = "butt", join:String = "miter", miterLimit:Number = 10)
        {
            super(style, color, alpha, width);
            this.m_cap = cap;
            this.m_join = join;
            this.m_miterLimit = miterLimit;
            return;
        }// end function

        public function get cap() : String
        {
            return this.m_cap;
        }// end function

        private function set _98258cap(value:String) : void
        {
            if (value != this.m_cap)
            {
                this.m_cap = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get join() : String
        {
            return this.m_join;
        }// end function

        private function set _3267882join(value:String) : void
        {
            if (value != this.m_join)
            {
                this.m_join = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get miterLimit() : Number
        {
            return this.m_miterLimit;
        }// end function

        private function set _1961018954miterLimit(value:Number) : void
        {
            if (value != this.m_miterLimit)
            {
                this.m_miterLimit = value;
                dispatchEventChange();
            }
            return;
        }// end function

        override protected function setLineStyle(graphics:Graphics) : void
        {
            if (this.m_cap == "butt")
            {
                this.m_cap = "none";
            }
            graphics.lineStyle(width, color, alpha, false, "normal", this.cap, this.join, this.miterLimit);
            return;
        }// end function

        public function set cap(value:String) : void
        {
            arguments = this.cap;
            if (arguments !== value)
            {
                this._98258cap = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cap", arguments, value));
                }
            }
            return;
        }// end function

        public function set miterLimit(value:Number) : void
        {
            arguments = this.miterLimit;
            if (arguments !== value)
            {
                this._1961018954miterLimit = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "miterLimit", arguments, value));
                }
            }
            return;
        }// end function

        public function set join(value:String) : void
        {
            arguments = this.join;
            if (arguments !== value)
            {
                this._3267882join = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "join", arguments, value));
                }
            }
            return;
        }// end function

    }
}
