package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;

    public class NoopSymbol extends Symbol
    {
        private static var m_instance:NoopSymbol;

        public function NoopSymbol()
        {
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            return;
        }// end function

        public static function get instance() : NoopSymbol
        {
            if (m_instance == null)
            {
                m_instance = new NoopSymbol;
            }
            return m_instance;
        }// end function

    }
}
