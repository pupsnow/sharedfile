package com.esri.ags.utils
{
    import SymbolUtil.as$51.*;
    import flash.display.*;
    import mx.graphics.*;

    public class SymbolUtil extends Object
    {

        public function SymbolUtil()
        {
            return;
        }// end function

        public static function drawStyledLine(sprite:Sprite, points:Array, stroke:SolidColorStroke, pattern:Array) : void
        {
            var _loc_6:int = 0;
            var _loc_5:* = new LineStylePen();
            _loc_5.pattern = pattern.concat();
            _loc_5.stroke = stroke;
            _loc_5.initialize(sprite.graphics);
            if (points.length > 1)
            {
                _loc_5.moveTo(points[0], points[1]);
                _loc_6 = 2;
                while (_loc_6 < points.length)
                {
                    
                    if (points[0] == points[_loc_6])
                    {
                    }
                    if (points[1] != points[(_loc_6 + 1)])
                    {
                        _loc_5.lineTo(points[_loc_6], points[(_loc_6 + 1)]);
                    }
                    points[0] = points[_loc_6];
                    points[1] = points[(_loc_6 + 1)];
                    _loc_6 = _loc_6 + 2;
                }
                _loc_5.commit();
            }
            return;
        }// end function

    }
}
