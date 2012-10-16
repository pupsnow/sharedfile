package com.esri.ags.clusterers
{
    import com.esri.ags.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import flash.utils.*;
    import mx.collections.*;

    public class GridClusterer extends ESRIClusterer
    {
        private var m_center:MapPoint;

        public function GridClusterer()
        {
            return;
        }// end function

        override public function clusterGraphics(graphicsLayer:GraphicsLayer, graphicCollection:ArrayCollection) : Array
        {
            var _loc_6:MapPoint = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_16:Graphic = null;
            var _loc_17:MapPoint = null;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:int = 0;
            var _loc_21:Cluster = null;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_3:Array = [];
            initializeOverallValues();
            var _loc_4:* = graphicsLayer.map;
            if (_loc_4.extent === null)
            {
                return _loc_3;
            }
            if (this.m_center === null)
            {
                this.m_center = _loc_4.extent.center;
            }
            var _loc_5:* = new Dictionary();
            _loc_6 = _loc_4.extent.center;
            _loc_7 = _loc_4.extent.width;
            _loc_8 = _loc_4.extent.height;
            _loc_9 = m_sizeInPixels * _loc_7 / _loc_4.width;
            var _loc_10:* = _loc_9 * 0.5;
            _loc_11 = m_sizeInPixels * _loc_8 / _loc_4.height;
            var _loc_12:* = _loc_11 * 0.5;
            _loc_13 = Math.ceil(_loc_7 * 0.5 / _loc_9) * _loc_9;
            _loc_14 = Math.ceil(_loc_8 * 0.5 / _loc_11) * _loc_11;
            var _loc_15:* = new Extent(_loc_6.x - _loc_13, _loc_6.y - _loc_14, _loc_6.x + _loc_13, _loc_6.y + _loc_14).expand(m_extentExpandFactor);
            for each (_loc_16 in graphicCollection)
            {
                
                if (_loc_16.visible === false)
                {
                    continue;
                }
                _loc_17 = m_graphicToMapPointFunction(_loc_16);
                if (_loc_17)
                {
                    if (!_loc_4.wrapAround180)
                    {
                    }
                    if (_loc_15.containsXY(_loc_17.x, _loc_17.y))
                    {
                        _loc_18 = Math.floor((_loc_17.x - this.m_center.x) / _loc_9);
                        _loc_19 = Math.floor((_loc_17.y - this.m_center.y) / _loc_11);
                        _loc_20 = _loc_18 << 16 | _loc_19 & 65535;
                        _loc_21 = _loc_5[_loc_20];
                        if (_loc_21 === null)
                        {
                            _loc_22 = _loc_18 * _loc_9 + this.m_center.x + _loc_10;
                            _loc_23 = _loc_19 * _loc_11 + this.m_center.y + _loc_12;
                            _loc_5[_loc_20] = new Cluster(new MapPoint(_loc_22, _loc_23), 1, [_loc_16]);
                        }
                        else
                        {
                            _loc_21.graphics.push(_loc_16);
                        }
                    }
                    continue;
                }
                _loc_3.push(_loc_16);
            }
            this.createGraphicsFromClusters(_loc_5, _loc_3);
            return _loc_3;
        }// end function

        override public function destroy(graphicsLayer:GraphicsLayer) : void
        {
            this.m_center = null;
            return;
        }// end function

        private function createGraphicsFromClusters(dict:Dictionary, arrOfGraphics:Array) : void
        {
            var _loc_3:Cluster = null;
            for each (_loc_3 in dict)
            {
                
                overallMinCount = Math.min(overallMinCount, _loc_3.graphics.length);
                overallMaxCount = Math.max(overallMaxCount, _loc_3.graphics.length);
                createClusterGraphic(_loc_3, arrOfGraphics);
            }
            return;
        }// end function

    }
}
