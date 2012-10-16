package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;

    public interface IRenderer
    {

        public function IRenderer();

        function getSymbol(graphic:Graphic) : Symbol;

    }
}
