package com.esri.ags.clusterers
{
    import com.esri.ags.layers.*;
    import flash.events.*;
    import mx.collections.*;

    public class BaseClusterer extends EventDispatcher implements IClusterer
    {

        public function BaseClusterer()
        {
            return;
        }// end function

        protected function dispatchEventChange(type:String = null) : void
        {
            dispatchEvent(new Event(type ? (type) : (Event.CHANGE)));
            return;
        }// end function

        public function initialize(graphicsLayer:GraphicsLayer) : void
        {
            return;
        }// end function

        public function removeGraphics(graphicsLayer:GraphicsLayer) : void
        {
            while (graphicsLayer.numChildren)
            {
                
                graphicsLayer.removeChildAt(0);
            }
            return;
        }// end function

        public function clusterGraphics(graphicsLayer:GraphicsLayer, graphicCollection:ArrayCollection) : Array
        {
            return null;
        }// end function

        public function destroy(graphicsLayer:GraphicsLayer) : void
        {
            return;
        }// end function

    }
}
