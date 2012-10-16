package com.esri.ags.components.supportClasses
{
    import com.esri.ags.components.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.rpc.*;

    public class Credential extends EventDispatcher
    {
        private var _idManager:IdentityManager;
        private var _refreshTimerId:uint;
        private var _keyRing:Object;
        public var expires:Number;
        var resources:Array;
        public var server:String;
        public var token:String;
        private var _userId:String;
        private static const TOKEN_REFRESH_BUFFER:Number = 120000;

        public function Credential()
        {
            this._idManager = IdentityManager.instance;
            return;
        }// end function

        public function get userId() : String
        {
            return this._userId;
        }// end function

        public function set userId(value:String) : void
        {
            if (this._userId !== value)
            {
                this._userId = value;
                dispatchEvent(new Event("userIdChanged"));
            }
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:int = 0;
            if (this._idManager)
            {
                _loc_1 = this._idManager.credentials.indexOf(this);
                if (_loc_1 > -1)
                {
                    this._idManager.credentials.splice(_loc_1, 1);
                }
                this._idManager = null;
                this._keyRing = null;
                clearTimeout(this._refreshTimerId);
                this.expires = NaN;
                this.resources = null;
                this.server = null;
                this.token = null;
                this.userId = null;
            }
            return;
        }// end function

        function setKeyRing(keyRing:Object) : void
        {
            this._keyRing = keyRing;
            return;
        }// end function

        private function refreshToken() : void
        {
            var serverInfo:ServerInfo;
            var password:String;
            if (this._idManager)
            {
            }
            if (Log.isDebug())
            {
                this._idManager.logger.debug("Refreshing credential for userId \'{0}\' at {1}", this.userId, this.server);
            }
            if (this.server)
            {
            }
            if (this.userId)
            {
            }
            if (this._keyRing)
            {
            }
            if (this._keyRing[this.server])
            {
                serverInfo = this._idManager.findServerInfo(this.server);
                password = this._keyRing[this.server][this.userId];
                if (serverInfo)
                {
                }
                if (password)
                {
                    var genCredResult:* = function (credential:Credential) : void
            {
                token = credential.token;
                expires = credential.expires;
                startRefreshTimer();
                return;
            }// end function
            ;
                    var genCredFault:* = function (credFault:Fault) : void
            {
                if (Log.isError())
                {
                    _idManager.logger.error("Error refreshing credential for userId \'{0}\' at {1}: {2}", userId, server, credFault.faultString);
                }
                return;
            }// end function
            ;
                    this._idManager.generateCredential(serverInfo, this.userId, password, new Responder(genCredResult, genCredFault));
                }
            }
            return;
        }// end function

        function startRefreshTimer() : void
        {
            var _loc_1:Number = NaN;
            if (isFinite(this.expires))
            {
                clearTimeout(this._refreshTimerId);
                _loc_1 = this.expires - TOKEN_REFRESH_BUFFER - new Date().time;
                if (_loc_1 < 0)
                {
                    _loc_1 = TOKEN_REFRESH_BUFFER;
                }
                this._refreshTimerId = setTimeout(this.refreshToken, _loc_1);
            }
            return;
        }// end function

    }
}
