package com.esri.ags.clusterers
{
    import com.esri.ags.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import mx.collections.*;
    import mx.events.*;
    import mx.utils.*;

    public class WeightedClusterer extends ESRIClusterer
    {
        private var m_center:MapPoint;
        private var m_clusterDistance2:Number;
        private var m_clusterHeight:Number;
        private var m_clusterWidth:Number;
        private var m_orig:OrderedObject;
        private var m_overlapExists:Boolean;
        private var m_graphicWeightFunction:Function;

        public function WeightedClusterer()
        {
            this.m_graphicWeightFunction = this.graphicWeightPrivate;
            return;
        }// end function

        public function get center() : MapPoint
        {
            return this.m_center;
        }// end function

        private function set _1364013995center(value:MapPoint) : void
        {
            this.m_center = value;
            return;
        }// end function

        override public function clusterGraphics(graphicsLayer:GraphicsLayer, graphicCollection:ArrayCollection) : Array
        {
            var _loc_4:Map = null;
            var _loc_5:Extent = null;
            var _loc_6:Cluster = null;
            var _loc_3:Array = [];
            if (graphicCollection.length)
            {
                initializeOverallValues();
                _loc_4 = graphicsLayer.map;
                if (this.m_center === null)
                {
                    this.m_center = _loc_4.extent.center;
                }
                _loc_5 = _loc_4.extent.expand(m_extentExpandFactor);
                this.m_clusterWidth = m_sizeInPixels * _loc_4.extent.width / _loc_4.width;
                this.m_clusterHeight = m_sizeInPixels * _loc_4.extent.height / _loc_4.height;
                this.m_clusterDistance2 = this.m_clusterWidth * this.m_clusterWidth + this.m_clusterHeight * this.m_clusterHeight;
                this.convertGraphicsToClusters(graphicCollection, _loc_3, _loc_5, _loc_4);
                do
                {
                    
                    this.mergeOverlappingClusters();
                }while (this.m_overlapExists)
                for each (_loc_6 in this.m_orig)
                {
                    
                    createClusterGraphic(_loc_6, _loc_3);
                    overallMinCount = Math.min(overallMinCount, _loc_6.graphics.length);
                    overallMaxCount = Math.max(overallMaxCount, _loc_6.graphics.length);
                    overallMinWeight = Math.min(overallMinCount, _loc_6.weight);
                    overallMaxWeight = Math.max(overallMaxCount, _loc_6.weight);
                }
            }
            else
            {
                overallMinCount = 0;
                overallMaxCount = 0;
                overallMinWeight = 0;
                overallMaxWeight = 0;
            }
            return _loc_3;
        }// end function

        override public function destroy(graphicsLayer:GraphicsLayer) : void
        {
            this.m_center = null;
            this.m_orig = null;
            return;
        }// end function

        private function graphicWeightPrivate(graphic:Graphic) : Number
        {
            return 1;
        }// end function

        public function get graphicWeightFunction() : Function
        {
            return this.m_graphicWeightFunction === this.graphicWeightPrivate ? (null) : (this.m_graphicWeightFunction);
        }// end function

        private function set _576558216graphicWeightFunction(value:Function) : void
        {
            if (this.m_graphicWeightFunction !== value)
            {
                this.m_graphicWeightFunction = value === null ? (this.graphicWeightPrivate) : (value);
                dispatchEventChange();
            }
            return;
        }// end function

        private function convertGraphicsToClusters(inputGraphics:ArrayCollection, arrOfGraphics:Array, extent:Extent, map:Map) : void
        {
            var _loc_5:Graphic = null;
            var _loc_6:MapPoint = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:Cluster = null;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            this.m_orig = new OrderedObject();
            for each (_loc_5 in inputGraphics)
            {
                
                if (_loc_5.visible === false)
                {
                    continue;
                }
                _loc_6 = m_graphicToMapPointFunction(_loc_5);
                if (_loc_6)
                {
                    if (!map.wrapAround180)
                    {
                    }
                    if (extent.containsXY(_loc_6.x, _loc_6.y))
                    {
                        _loc_7 = this.toClusterX(_loc_6.x);
                        _loc_8 = this.toClusterY(_loc_6.y);
                        _loc_9 = _loc_7 << 16 | _loc_8 & 65535;
                        _loc_10 = this.m_orig[_loc_9];
                        if (_loc_10)
                        {
                            _loc_11 = this.m_graphicWeightFunction(_loc_5);
                            _loc_12 = _loc_10.weight + _loc_11;
                            _loc_10.center.x = (_loc_10.center.x * _loc_10.weight + _loc_6.x * _loc_11) / _loc_12;
                            _loc_10.center.y = (_loc_10.center.y * _loc_10.weight + _loc_6.y * _loc_11) / _loc_12;
                            _loc_10.weight = _loc_12;
                            _loc_10.graphics.push(_loc_5);
                        }
                        else
                        {
                            this.m_orig[_loc_9] = new Cluster(new MapPoint(_loc_6.x, _loc_6.y), this.m_graphicWeightFunction(_loc_5), [_loc_5]);
                        }
                    }
                    continue;
                }
                arrOfGraphics.push(_loc_5);
            }
            return;
        }// end function

        private function merge(lhs:Cluster, rhs:Cluster) : void
        {
            var _loc_3:* = lhs.weight + rhs.weight;
            lhs.center.x = (lhs.weight * lhs.center.x + rhs.weight * rhs.center.x) / _loc_3;
            lhs.center.y = (lhs.weight * lhs.center.y + rhs.weight * rhs.center.y) / _loc_3;
            lhs.weight = lhs.weight + rhs.weight;
            while (rhs.graphics.length)
            {
                
                lhs.graphics.push(rhs.graphics.pop());
            }
            rhs.graphics = null;
            return;
        }// end function

        private function mergeOverlappingClusters() : void
        {
            var _loc_2:Cluster = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            this.m_overlapExists = false;
            var _loc_1:* = new OrderedObject();
            for each (_loc_2 in this.m_orig)
            {
                
                if (_loc_2.graphics)
                {
                    _loc_3 = this.toClusterX(_loc_2.center.x);
                    _loc_4 = this.toClusterY(_loc_2.center.y);
                    this.searchAndMerge(_loc_2, (_loc_3 + 1), _loc_4 + 0);
                    this.searchAndMerge(_loc_2, (_loc_3 - 1), _loc_4 + 0);
                    this.searchAndMerge(_loc_2, _loc_3 + 0, (_loc_4 + 1));
                    this.searchAndMerge(_loc_2, _loc_3 + 0, (_loc_4 - 1));
                    this.searchAndMerge(_loc_2, (_loc_3 + 1), (_loc_4 + 1));
                    this.searchAndMerge(_loc_2, (_loc_3 + 1), (_loc_4 - 1));
                    this.searchAndMerge(_loc_2, (_loc_3 - 1), (_loc_4 + 1));
                    this.searchAndMerge(_loc_2, (_loc_3 - 1), (_loc_4 - 1));
                    _loc_5 = this.toClusterX(_loc_2.center.x);
                    _loc_6 = this.toClusterY(_loc_2.center.y);
                    _loc_7 = _loc_5 << 16 | _loc_6 & 65535;
                    _loc_1[_loc_7] = _loc_2;
                }
            }
            this.m_orig = _loc_1;
            return;
        }// end function

        private function searchAndMerge(cluster:Cluster, cx:int, cy:int) : void
        {
            var _loc_4:int = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            _loc_4 = cx << 16 | cy & 65535;
            var _loc_5:* = this.m_orig[_loc_4];
            if (_loc_5)
            {
            }
            if (_loc_5.graphics)
            {
                _loc_6 = cluster.center.x - _loc_5.center.x;
                _loc_7 = cluster.center.y - _loc_5.center.y;
                _loc_8 = _loc_6 * _loc_6 + _loc_7 * _loc_7;
                if (_loc_8 < this.m_clusterDistance2)
                {
                    this.m_overlapExists = true;
                    this.merge(cluster, _loc_5);
                }
            }
            return;
        }// end function

        private function toClusterX(x:Number) : Number
        {
            return Math.floor((x - this.m_center.x) / this.m_clusterWidth);
        }// end function

        private function toClusterY(y:Number) : Number
        {
            return Math.floor((y - this.m_center.y) / this.m_clusterHeight);
        }// end function

        public function set center(value:MapPoint) : void
        {
            arguments = this.center;
            if (arguments !== value)
            {
                this._1364013995center = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "center", arguments, value));
                }
            }
            return;
        }// end function

        public function set graphicWeightFunction(value:Function) : void
        {
            arguments = this.graphicWeightFunction;
            if (arguments !== value)
            {
                this._576558216graphicWeightFunction = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "graphicWeightFunction", arguments, value));
                }
            }
            return;
        }// end function

    }
}
