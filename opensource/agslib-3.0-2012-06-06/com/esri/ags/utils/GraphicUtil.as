package com.esri.ags.utils
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;

    public class GraphicUtil extends Object
    {

        public function GraphicUtil()
        {
            return;
        }// end function

        public static function getGraphicsExtent(graphics:Array) : Extent
        {
            var _loc_2:Extent = null;
            var _loc_3:Geometry = null;
            var _loc_4:MapPoint = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:Extent = null;
            if (graphics)
            {
            }
            if (graphics.length > 0)
            {
                _loc_3 = Graphic(graphics[0]).geometry;
                _loc_2 = _loc_3.extent;
                if (_loc_2)
                {
                    _loc_2 = _loc_2.duplicate();
                }
                else
                {
                    _loc_4 = _loc_3 as MapPoint;
                    if (_loc_3 is MapPoint)
                    {
                        _loc_4 = _loc_3 as MapPoint;
                    }
                    else
                    {
                        if (_loc_3 is Multipoint)
                        {
                        }
                        if (Multipoint(_loc_3).points)
                        {
                        }
                        if (Multipoint(_loc_3).points.length == 1)
                        {
                            _loc_4 = Multipoint(_loc_3).points[0];
                        }
                    }
                    if (_loc_4)
                    {
                        _loc_2 = new Extent(_loc_4.x, _loc_4.y, _loc_4.x, _loc_4.y, _loc_4.spatialReference);
                    }
                }
                if (_loc_2)
                {
                    _loc_5 = 1;
                    _loc_6 = graphics.length;
                    while (_loc_5 < _loc_6)
                    {
                        
                        _loc_3 = Graphic(graphics[_loc_5]).geometry;
                        if (_loc_3 is MapPoint)
                        {
                            _loc_2.unionPoint(_loc_3 as MapPoint);
                        }
                        else
                        {
                            _loc_7 = _loc_3.extent;
                            if (_loc_7)
                            {
                                _loc_2.unionExtent(_loc_7);
                            }
                            else
                            {
                                if (_loc_3 is Multipoint)
                                {
                                }
                                if (Multipoint(_loc_3).points)
                                {
                                }
                                if (Multipoint(_loc_3).points.length == 1)
                                {
                                    _loc_2.unionPoint(Multipoint(_loc_3).points[0]);
                                }
                            }
                        }
                        _loc_5 = _loc_5 + 1;
                    }
                }
                if (_loc_2)
                {
                }
                if (_loc_2.width <= 0)
                {
                }
                if (_loc_2.height <= 0)
                {
                    _loc_2 = null;
                }
            }
            return _loc_2;
        }// end function

        public static function getGeometries(graphics:Array) : Array
        {
            var _loc_3:Graphic = null;
            var _loc_2:Array = [];
            for each (_loc_3 in graphics)
            {
                
                _loc_2.push(_loc_3.geometry);
            }
            return _loc_2;
        }// end function

    }
}
