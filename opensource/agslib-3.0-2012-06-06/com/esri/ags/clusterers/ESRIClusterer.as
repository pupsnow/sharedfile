package com.esri.ags.clusterers
{
    import com.esri.ags.*;
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import mx.events.*;

    public class ESRIClusterer extends BaseClusterer
    {
        protected var m_clusterWeightFunction:Function;
        protected var m_graphicToMapPointFunction:Function;
        protected var m_extentExpandFactor:Number;
        protected var m_sizeInPixels:Number;
        protected var m_symbol:Symbol;
        private var m_minGraphicCount:int;
        private var m_overallMinCount:int;
        private var m_overallMinWeight:Number;
        private var m_overallMaxWeight:Number;
        private var m_overallMaxCount:int;

        public function ESRIClusterer()
        {
            this.m_clusterWeightFunction = this.clusterWeightPrivate;
            this.m_graphicToMapPointFunction = this.graphicToMapPointPrivate;
            this.extentExpandFactor = 2;
            this.minGraphicCount = 1;
            this.sizeInPixels = 70;
            this.symbol = SimpleClusterSymbol.instance;
            return;
        }// end function

        public function get symbol() : Symbol
        {
            return this.m_symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            if (value !== this.m_symbol)
            {
                this.m_symbol = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get overallMinCount() : int
        {
            return this.m_overallMinCount;
        }// end function

        public function set overallMinCount(value:int) : void
        {
            if (this.m_overallMinCount !== value)
            {
                this.m_overallMinCount = value;
                dispatchEventChange("overallMinCountChanged");
            }
            return;
        }// end function

        public function get overallMaxCount() : int
        {
            return this.m_overallMaxCount;
        }// end function

        public function set overallMaxCount(value:int) : void
        {
            if (this.m_overallMaxCount !== value)
            {
                this.m_overallMaxCount = value;
                dispatchEventChange("overallMaxCountChanged");
            }
            return;
        }// end function

        public function get overallMinWeight() : Number
        {
            return this.m_overallMinWeight;
        }// end function

        public function set overallMinWeight(value:Number) : void
        {
            if (this.m_overallMinWeight !== value)
            {
                this.m_overallMinWeight = value;
                dispatchEventChange("overallMinWeightChanged");
            }
            return;
        }// end function

        public function get overallMaxWeight() : Number
        {
            return this.m_overallMaxWeight;
        }// end function

        public function set overallMaxWeight(value:Number) : void
        {
            if (this.m_overallMaxWeight !== value)
            {
                this.m_overallMaxWeight = value;
                dispatchEventChange("overallMaxWeightChanged");
            }
            return;
        }// end function

        public function get extentExpandFactor() : Number
        {
            return this.m_extentExpandFactor;
        }// end function

        private function set _581858093extentExpandFactor(value:Number) : void
        {
            if (this.m_extentExpandFactor !== value)
            {
                this.m_extentExpandFactor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get sizeInPixels() : Number
        {
            return this.m_sizeInPixels;
        }// end function

        private function set _1497430867sizeInPixels(value:Number) : void
        {
            if (this.m_sizeInPixels !== value)
            {
                this.m_sizeInPixels = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get minGraphicCount() : int
        {
            return this.m_minGraphicCount;
        }// end function

        private function set _749842823minGraphicCount(value:int) : void
        {
            if (this.m_minGraphicCount !== value)
            {
                this.m_minGraphicCount = value;
                dispatchEventChange();
            }
            return;
        }// end function

        protected function createClusterGraphic(cluster:Cluster, arr:Array) : void
        {
            var _loc_4:int = 0;
            var _loc_3:* = cluster.graphics.length;
            if (_loc_3 <= this.m_minGraphicCount)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    arr.push(cluster.graphics[_loc_4]);
                    _loc_4 = _loc_4 + 1;
                }
            }
            else
            {
                this.m_clusterWeightFunction(cluster);
                arr.push(new ClusterGraphic(cluster.center, this.symbol, cluster));
            }
            return;
        }// end function

        private function clusterWeightPrivate(cluster:Cluster) : void
        {
            cluster.weight = cluster.graphics.length;
            return;
        }// end function

        public function get clusterWeightFunction() : Function
        {
            return this.m_clusterWeightFunction === this.clusterWeightPrivate ? (null) : (this.m_clusterWeightFunction);
        }// end function

        private function set _570622730clusterWeightFunction(value:Function) : void
        {
            if (this.m_clusterWeightFunction !== value)
            {
                this.m_clusterWeightFunction = value === null ? (this.clusterWeightPrivate) : (value);
                dispatchEventChange();
            }
            return;
        }// end function

        private function graphicToMapPointPrivate(graphic:Graphic) : MapPoint
        {
            return graphic.geometry as MapPoint;
        }// end function

        public function get graphicToMapPointFunction() : Function
        {
            return this.m_graphicToMapPointFunction === this.graphicToMapPointPrivate ? (null) : (this.m_graphicToMapPointFunction);
        }// end function

        private function set _1528348881graphicToMapPointFunction(value:Function) : void
        {
            if (this.m_graphicToMapPointFunction !== value)
            {
                this.m_graphicToMapPointFunction = value === null ? (this.graphicToMapPointPrivate) : (value);
                dispatchEventChange();
            }
            return;
        }// end function

        protected function initializeOverallValues() : void
        {
            this.m_overallMinCount = int.MAX_VALUE;
            this.m_overallMaxCount = int.MIN_VALUE;
            this.m_overallMinWeight = Number.POSITIVE_INFINITY;
            this.m_overallMaxWeight = Number.NEGATIVE_INFINITY;
            return;
        }// end function

        public function set sizeInPixels(value:Number) : void
        {
            arguments = this.sizeInPixels;
            if (arguments !== value)
            {
                this._1497430867sizeInPixels = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "sizeInPixels", arguments, value));
                }
            }
            return;
        }// end function

        public function set graphicToMapPointFunction(value:Function) : void
        {
            arguments = this.graphicToMapPointFunction;
            if (arguments !== value)
            {
                this._1528348881graphicToMapPointFunction = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "graphicToMapPointFunction", arguments, value));
                }
            }
            return;
        }// end function

        public function set extentExpandFactor(value:Number) : void
        {
            arguments = this.extentExpandFactor;
            if (arguments !== value)
            {
                this._581858093extentExpandFactor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "extentExpandFactor", arguments, value));
                }
            }
            return;
        }// end function

        public function set clusterWeightFunction(value:Function) : void
        {
            arguments = this.clusterWeightFunction;
            if (arguments !== value)
            {
                this._570622730clusterWeightFunction = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "clusterWeightFunction", arguments, value));
                }
            }
            return;
        }// end function

        public function set minGraphicCount(value:int) : void
        {
            arguments = this.minGraphicCount;
            if (arguments !== value)
            {
                this._749842823minGraphicCount = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minGraphicCount", arguments, value));
                }
            }
            return;
        }// end function

    }
}
