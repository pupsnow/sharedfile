package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;

    public class ClusterGraphic extends Graphic
    {

        public function ClusterGraphic(mapPoint:MapPoint, symbol:Symbol, cluster:Cluster)
        {
            var _loc_4:Graphic = null;
            super(mapPoint, symbol, cluster);
            if (cluster)
            {
                for each (_loc_4 in cluster.graphics)
                {
                    
                    _loc_4.clusterGraphic = this;
                }
            }
            return;
        }// end function

        override protected function removedHandler(event:Event) : void
        {
            var _loc_2:Graphic = null;
            super.removedHandler(event);
            if (event.target === this)
            {
            }
            if (this.cluster)
            {
                for each (_loc_2 in this.cluster.graphics)
                {
                    
                    _loc_2.clusterGraphic = null;
                }
            }
            return;
        }// end function

        public function get mapPoint() : MapPoint
        {
            return geometry as MapPoint;
        }// end function

        public function get cluster() : Cluster
        {
            return attributes as Cluster;
        }// end function

    }
}
