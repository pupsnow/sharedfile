package com.esri.ags.layers.supportClasses
{
    import flash.utils.*;
    import mx.core.*;

    public class StaticLayer_m_globe extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function StaticLayer_m_globe()
        {
            this.dataClass = StaticLayer_m_globe_dataClass;
            initialWidth = 480 / 20;
            initialHeight = 480 / 20;
            return;
        }// end function

        override public function get movieClipData() : ByteArray
        {
            if (bytes == null)
            {
                bytes = ByteArray(new this.dataClass());
            }
            return bytes;
        }// end function

    }
}
