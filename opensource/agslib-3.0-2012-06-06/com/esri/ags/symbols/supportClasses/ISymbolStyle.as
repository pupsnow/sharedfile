package com.esri.ags.symbols.supportClasses
{
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.geom.*;

    public interface ISymbolStyle
    {

        public function ISymbolStyle();

        function get symbol() : Symbol;

        function set symbol(value:Symbol) : void;

        function drawGeometry(canvas:Object, geometry:Geometry, screenX:Number, screenY:Number) : Rectangle;

    }
}
