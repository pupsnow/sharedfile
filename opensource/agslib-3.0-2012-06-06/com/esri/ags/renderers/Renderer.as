package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.symbols.*;

    public class Renderer extends Object implements IRenderer
    {

        public function Renderer()
        {
            return;
        }// end function

        public function getSymbol(graphic:Graphic) : Symbol
        {
            return null;
        }// end function

        public static function fromJSON(obj:Object) : IRenderer
        {
            var _loc_2:IRenderer = null;
            if (obj)
            {
                if (obj.type == "simple")
                {
                    _loc_2 = SimpleRenderer.fromJSON(obj);
                }
                else if (obj.type == "uniqueValue")
                {
                    _loc_2 = UniqueValueRenderer.fromJSON(obj);
                }
                else if (obj.type == "classBreaks")
                {
                    _loc_2 = ClassBreaksRenderer.fromJSON(obj);
                }
            }
            return _loc_2;
        }// end function

    }
}
