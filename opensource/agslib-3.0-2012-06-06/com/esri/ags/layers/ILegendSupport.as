package com.esri.ags.layers
{
    import mx.rpc.*;

    public interface ILegendSupport extends IEventDispatcher
    {

        public function ILegendSupport();

        function getLegendInfos(responder:IResponder = null) : AsyncToken;

    }
}
