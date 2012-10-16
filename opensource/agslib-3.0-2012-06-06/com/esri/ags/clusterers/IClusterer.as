package com.esri.ags.clusterers
{
    import com.esri.ags.layers.*;
    import mx.collections.*;

    public interface IClusterer extends IEventDispatcher
    {

        public function IClusterer();

        function initialize(graphicsLayer:GraphicsLayer) : void;

        function removeGraphics(graphicsLayer:GraphicsLayer) : void;

        function clusterGraphics(graphicsLayer:GraphicsLayer, graphicCollection:ArrayCollection) : Array;

        function destroy(graphicsLayer:GraphicsLayer) : void;

    }
}
