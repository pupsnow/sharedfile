package com.esri.ags.components
{
    import flash.events.*;
    import spark.components.*;

    public class LabelDataRenderer extends DataRenderer
    {
        private var m_label:String = "";

        public function LabelDataRenderer()
        {
            return;
        }// end function

        public function get label() : String
        {
            return this.m_label;
        }// end function

        public function set label(value:String) : void
        {
            if (this.m_label !== value)
            {
                this.m_label = value;
                dispatchEvent(new Event("labelChanged"));
            }
            return;
        }// end function

    }
}
