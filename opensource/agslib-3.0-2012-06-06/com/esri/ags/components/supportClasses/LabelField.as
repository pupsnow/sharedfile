package com.esri.ags.components.supportClasses
{
    import spark.components.*;

    public class LabelField extends Label implements IDataRenderer
    {
        private var m_labelFunction:Function;
        private var m_data:Object = null;

        public function LabelField(value:Object = null)
        {
            this.data = value;
            width = 150;
            return;
        }// end function

        public function get labelFunction() : Function
        {
            return this.m_labelFunction;
        }// end function

        public function set labelFunction(value:Function) : void
        {
            if (this.m_labelFunction != value)
            {
                this.m_labelFunction = value;
                this.updateLabelValue();
            }
            return;
        }// end function

        public function get data() : Object
        {
            return this.m_data;
        }// end function

        public function set data(value:Object) : void
        {
            if (this.m_data != value)
            {
                this.m_data = value;
                this.updateLabelValue();
            }
            return;
        }// end function

        private function updateLabelValue() : void
        {
            if (this.m_labelFunction != null)
            {
                text = this.m_labelFunction(this.m_data);
            }
            else if (this.m_data)
            {
                text = this.m_data.toString();
            }
            else
            {
                text = null;
            }
            return;
        }// end function

    }
}
