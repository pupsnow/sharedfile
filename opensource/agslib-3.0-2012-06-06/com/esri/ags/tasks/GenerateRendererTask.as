package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.renderers.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.rpc.*;

    public class GenerateRendererTask extends BaseTask
    {
        private var _executeLastResult:IRenderer;
        private var _gdbVersion:String;
        private var _source:ILayerSource;

        public function GenerateRendererTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function get executeLastResult() : IRenderer
        {
            return this._executeLastResult;
        }// end function

        public function set executeLastResult(value:IRenderer) : void
        {
            this._executeLastResult = value;
            dispatchEvent(new Event("executeLastResultChanged"));
            return;
        }// end function

        public function get gdbVersion() : String
        {
            return this._gdbVersion;
        }// end function

        public function set gdbVersion(value:String) : void
        {
            if (this._gdbVersion !== value)
            {
                this._gdbVersion = value;
                dispatchEvent(new Event("gdbVersionChanged"));
            }
            return;
        }// end function

        public function get source() : ILayerSource
        {
            return this._source;
        }// end function

        public function set source(value:ILayerSource) : void
        {
            this._source = value;
            dispatchEvent(new Event("sourceChanged"));
            return;
        }// end function

        public function execute(generateRendererParameters:GenerateRendererParameters, responder:IResponder = null) : AsyncToken
        {
            var _loc_3:* = new URLVariables();
            _loc_3.f = "json";
            if (this.source)
            {
                _loc_3.layer = JSONUtil.encode({source:this.source});
            }
            if (this.gdbVersion)
            {
                _loc_3.gdbVersion = this.gdbVersion;
            }
            _loc_3.classificationDef = JSONUtil.encode(generateRendererParameters.classificationDefinition);
            if (generateRendererParameters.where)
            {
                _loc_3.where = generateRendererParameters.where;
            }
            return sendURLVariables("/generateRenderer", _loc_3, responder, this.handleExecute);
        }// end function

        private function handleExecute(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            this.executeLastResult = Renderer.fromJSON(decodedObject);
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.executeLastResult);
            }
            dispatchEvent(new GenerateRendererEvent(GenerateRendererEvent.EXECUTE_COMPLETE, this.executeLastResult));
            return;
        }// end function

    }
}
