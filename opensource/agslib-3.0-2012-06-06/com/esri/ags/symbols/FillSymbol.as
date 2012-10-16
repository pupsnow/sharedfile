package com.esri.ags.symbols
{
    import flash.events.*;
    import mx.events.*;

    public class FillSymbol extends Symbol
    {
        protected var m_outline:SimpleLineSymbol;

        public function FillSymbol()
        {
            return;
        }// end function

        public function get outline() : SimpleLineSymbol
        {
            return this.m_outline;
        }// end function

        private function set _1106245566outline(value:SimpleLineSymbol) : void
        {
            if (this.m_outline)
            {
                this.m_outline.removeEventListener(Event.CHANGE, this.outline_changeHandler);
            }
            this.m_outline = value;
            if (this.m_outline)
            {
                this.m_outline.addEventListener(Event.CHANGE, this.outline_changeHandler);
            }
            dispatchEventChange();
            return;
        }// end function

        function outline_changeHandler(event:Event) : void
        {
            dispatchEventChange();
            return;
        }// end function

        public function set outline(value:SimpleLineSymbol) : void
        {
            arguments = this.outline;
            if (arguments !== value)
            {
                this._1106245566outline = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outline", arguments, value));
                }
            }
            return;
        }// end function

    }
}
