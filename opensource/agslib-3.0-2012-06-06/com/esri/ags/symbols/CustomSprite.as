package com.esri.ags.symbols
{
    import com.esri.ags.geometry.*;
    import flash.display.*;

    class CustomSprite extends Sprite
    {
        public var mapPoint:MapPoint;

        function CustomSprite(mapPoint:MapPoint = null) : void
        {
            this.mapPoint = mapPoint;
            return;
        }// end function

    }
}
