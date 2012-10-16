package com.esri.ags.tasks
{
    import com.esri.ags.events.*;
    import flash.net.*;
    import mx.rpc.*;

    public class JSONTask extends BaseTask
    {
        public var executeLastResult:Object;

        public function JSONTask(url:String = null)
        {
            super(url);
            return;
        }// end function

        public function execute(urlVariables:URLVariables = null, responder:IResponder = null) : AsyncToken
        {
            return sendURLVariables(null, urlVariables, responder, this.handleDecodedObject);
        }// end function

        private function handleDecodedObject(decodedObject:Object, asyncToken:AsyncToken) : void
        {
            var _loc_3:IResponder = null;
            this.executeLastResult = decodedObject;
            for each (_loc_3 in asyncToken.responders)
            {
                
                _loc_3.result(this.executeLastResult);
            }
            dispatchEvent(new JSONEvent(JSONEvent.EXECUTE_COMPLETE, this.executeLastResult));
            return;
        }// end function

    }
}
