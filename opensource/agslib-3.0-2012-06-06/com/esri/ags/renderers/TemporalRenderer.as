package com.esri.ags.renderers
{
    import com.esri.ags.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.renderers.supportClasses.*;
    import com.esri.ags.symbols.*;

    public class TemporalRenderer extends Renderer implements IRenderer
    {
        public var latestObservationRenderer:IRenderer;
        public var observationRenderer:IRenderer;
        public var trackRenderer:IRenderer;
        public var observationAger:SymbolAger;

        public function TemporalRenderer(observationRenderer:IRenderer = null, latestObservationRenderer:IRenderer = null, trackRenderer:IRenderer = null, observationAger:SymbolAger = null)
        {
            this.observationRenderer = observationRenderer;
            this.latestObservationRenderer = latestObservationRenderer;
            this.trackRenderer = trackRenderer;
            this.observationAger = observationAger;
            return;
        }// end function

        override public function getSymbol(graphic:Graphic) : Symbol
        {
            var _loc_2:Symbol = null;
            var _loc_3:* = graphic.graphicsLayer as FeatureLayer;
            if (_loc_3)
            {
            }
            if (_loc_3.startTimeField)
            {
                if (_loc_3.isLatestObservation(graphic))
                {
                    if (this.latestObservationRenderer)
                    {
                        _loc_2 = this.latestObservationRenderer.getSymbol(graphic);
                    }
                    else if (this.observationRenderer)
                    {
                        _loc_2 = this.observationRenderer.getSymbol(graphic);
                        if (this.observationAger)
                        {
                            _loc_2 = this.observationAger.getAgedSymbol(_loc_2, graphic);
                        }
                    }
                }
                else if (_loc_3.isTrack(graphic))
                {
                    if (this.trackRenderer)
                    {
                        _loc_2 = this.trackRenderer.getSymbol(graphic);
                    }
                }
                else if (this.observationRenderer)
                {
                    _loc_2 = this.observationRenderer.getSymbol(graphic);
                    if (this.observationAger)
                    {
                        _loc_2 = this.observationAger.getAgedSymbol(_loc_2, graphic);
                    }
                }
            }
            else if (this.observationRenderer)
            {
                _loc_2 = this.observationRenderer.getSymbol(graphic);
            }
            return _loc_2;
        }// end function

    }
}
