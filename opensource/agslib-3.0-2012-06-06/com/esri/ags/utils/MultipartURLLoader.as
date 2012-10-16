package com.esri.ags.utils
{
    import MultipartURLLoader.as$289.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MultipartURLLoader extends EventDispatcher
    {
        private var _loader:URLLoader;
        private var _boundary:String;
        private var _variableNames:Array;
        private var _fileNames:Array;
        private var _variables:Dictionary;
        private var _files:Dictionary;
        private var _async:Boolean = false;
        private var _path:String;
        private var _data:ByteArray;
        private var _prepared:Boolean = false;
        private var asyncWriteTimeoutId:Number;
        private var asyncFilePointer:uint = 0;
        private var totalFilesSize:uint = 0;
        private var writtenBytes:uint = 0;
        public var requestHeaders:Array;
        public static var BLOCK_SIZE:uint = 65536;

        public function MultipartURLLoader()
        {
            this._fileNames = new Array();
            this._files = new Dictionary();
            this._variableNames = new Array();
            this._variables = new Dictionary();
            this._loader = new URLLoader();
            this.requestHeaders = new Array();
            return;
        }// end function

        public function load(path:String, async:Boolean = false) : void
        {
            if (path != null)
            {
            }
            if (path == "")
            {
                throw new IllegalOperationError("You cant load without specifing PATH");
            }
            this._path = path;
            this._async = async;
            if (this._async)
            {
                if (!this._prepared)
                {
                }
                else
                {
                    this.doSend();
                }
            }
            else
            {
                this._data = this.constructPostData();
                this.doSend();
            }
            return;
        }// end function

        public function close() : void
        {
            try
            {
                this._loader.close();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function addVariable(name:String, value:Object = "") : void
        {
            if (this._variableNames.indexOf(name) == -1)
            {
                this._variableNames.push(name);
            }
            this._variables[name] = value;
            this._prepared = false;
            return;
        }// end function

        public function addFile(fileContent:ByteArray, fileName:String, dataField:String = "Filedata", contentType:String = "application/octet-stream") : void
        {
            var _loc_5:FilePart = null;
            if (this._fileNames.indexOf(fileName) == -1)
            {
                this._fileNames.push(fileName);
                this._files[fileName] = new FilePart(fileContent, fileName, dataField, contentType);
                this.totalFilesSize = this.totalFilesSize + fileContent.length;
            }
            else
            {
                _loc_5 = this._files[fileName] as FilePart;
                this.totalFilesSize = this.totalFilesSize - _loc_5.fileContent.length;
                _loc_5.fileContent = fileContent;
                _loc_5.fileName = fileName;
                _loc_5.dataField = dataField;
                _loc_5.contentType = contentType;
                this.totalFilesSize = this.totalFilesSize + fileContent.length;
            }
            this._prepared = false;
            return;
        }// end function

        public function clearVariables() : void
        {
            this._variableNames = new Array();
            this._variables = new Dictionary();
            this._prepared = false;
            return;
        }// end function

        public function clearFiles() : void
        {
            var _loc_1:String = null;
            for each (_loc_1 in this._fileNames)
            {
                
                (this._files[_loc_1] as FilePart).dispose();
            }
            this._fileNames = new Array();
            this._files = new Dictionary();
            this.totalFilesSize = 0;
            this._prepared = false;
            return;
        }// end function

        public function dispose() : void
        {
            clearInterval(this.asyncWriteTimeoutId);
            this.removeListener();
            this.close();
            this._loader = null;
            this._boundary = null;
            this._variableNames = null;
            this._variables = null;
            this._fileNames = null;
            this._files = null;
            this.requestHeaders = null;
            this._data = null;
            return;
        }// end function

        public function getBoundary() : String
        {
            var _loc_1:int = 0;
            if (this._boundary == null)
            {
                this._boundary = "";
                _loc_1 = 0;
                while (_loc_1 < 32)
                {
                    
                    this._boundary = this._boundary + String.fromCharCode(int(97 + Math.random() * 25));
                    _loc_1 = _loc_1 + 1;
                }
            }
            return this._boundary;
        }// end function

        public function get dataFormat() : String
        {
            return this._loader.dataFormat;
        }// end function

        public function set dataFormat(format:String) : void
        {
            if (format != URLLoaderDataFormat.BINARY)
            {
            }
            if (format != URLLoaderDataFormat.TEXT)
            {
            }
            if (format != URLLoaderDataFormat.VARIABLES)
            {
                throw new IllegalOperationError("Illegal URLLoader Data Format");
            }
            this._loader.dataFormat = format;
            return;
        }// end function

        public function get loader() : URLLoader
        {
            return this._loader;
        }// end function

        private function doSend() : void
        {
            var _loc_1:* = new URLRequest();
            _loc_1.url = this._path;
            _loc_1.contentType = "multipart/form-data; boundary=" + this.getBoundary();
            _loc_1.method = URLRequestMethod.POST;
            _loc_1.data = this._data;
            if (this.requestHeaders.length)
            {
            }
            if (this.requestHeaders != null)
            {
                _loc_1.requestHeaders = this.requestHeaders.concat();
            }
            this.addListener();
            this._loader.load(_loc_1);
            return;
        }// end function

        private function constructPostData() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            _loc_1.endian = Endian.BIG_ENDIAN;
            _loc_1 = this.constructVariablesPart(_loc_1);
            _loc_1 = this.constructFilesPart(_loc_1);
            _loc_1 = this.closeDataObject(_loc_1);
            return _loc_1;
        }// end function

        private function closeDataObject(postData:ByteArray) : ByteArray
        {
            postData = this.BOUNDARY(postData);
            postData = this.DOUBLEDASH(postData);
            return postData;
        }// end function

        private function constructVariablesPart(postData:ByteArray) : ByteArray
        {
            var _loc_2:uint = 0;
            var _loc_3:String = null;
            var _loc_4:String = null;
            for each (_loc_4 in this._variableNames)
            {
                
                postData = this.BOUNDARY(postData);
                postData = this.LINEBREAK(postData);
                _loc_3 = "Content-Disposition: form-data; name=\"" + _loc_4 + "\"";
                _loc_2 = 0;
                while (_loc_2 < _loc_3.length)
                {
                    
                    postData.writeByte(_loc_3.charCodeAt(_loc_2));
                    _loc_2 = _loc_2 + 1;
                }
                postData = this.LINEBREAK(postData);
                postData = this.LINEBREAK(postData);
                postData.writeUTFBytes(this._variables[_loc_4]);
                postData = this.LINEBREAK(postData);
            }
            return postData;
        }// end function

        private function constructFilesPart(postData:ByteArray) : ByteArray
        {
            var _loc_2:uint = 0;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (this._fileNames.length)
            {
                for each (_loc_4 in this._fileNames)
                {
                    
                    postData = this.getFilePartHeader(postData, this._files[_loc_4] as FilePart);
                    postData = this.getFilePartData(postData, this._files[_loc_4] as FilePart);
                    postData = this.LINEBREAK(postData);
                }
                postData = this.closeFilePartsData(postData);
            }
            return postData;
        }// end function

        private function closeFilePartsData(postData:ByteArray) : ByteArray
        {
            var _loc_2:uint = 0;
            var _loc_3:String = null;
            postData = this.BOUNDARY(postData);
            postData = this.LINEBREAK(postData);
            _loc_3 = "Content-Disposition: form-data; name=\"Upload\"";
            _loc_2 = 0;
            while (_loc_2 < _loc_3.length)
            {
                
                postData.writeByte(_loc_3.charCodeAt(_loc_2));
                _loc_2 = _loc_2 + 1;
            }
            postData = this.LINEBREAK(postData);
            postData = this.LINEBREAK(postData);
            _loc_3 = "Submit Query";
            _loc_2 = 0;
            while (_loc_2 < _loc_3.length)
            {
                
                postData.writeByte(_loc_3.charCodeAt(_loc_2));
                _loc_2 = _loc_2 + 1;
            }
            postData = this.LINEBREAK(postData);
            return postData;
        }// end function

        private function getFilePartHeader(postData:ByteArray, part:FilePart) : ByteArray
        {
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            postData = this.BOUNDARY(postData);
            postData = this.LINEBREAK(postData);
            _loc_4 = "Content-Disposition: form-data; name=\"Filename\"";
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                postData.writeByte(_loc_4.charCodeAt(_loc_3));
                _loc_3 = _loc_3 + 1;
            }
            postData = this.LINEBREAK(postData);
            postData = this.LINEBREAK(postData);
            postData.writeUTFBytes(part.fileName);
            postData = this.LINEBREAK(postData);
            postData = this.BOUNDARY(postData);
            postData = this.LINEBREAK(postData);
            _loc_4 = "Content-Disposition: form-data; name=\"" + part.dataField + "\"; filename=\"";
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                postData.writeByte(_loc_4.charCodeAt(_loc_3));
                _loc_3 = _loc_3 + 1;
            }
            postData.writeUTFBytes(part.fileName);
            postData = this.QUOTATIONMARK(postData);
            postData = this.LINEBREAK(postData);
            _loc_4 = "Content-Type: " + part.contentType;
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                postData.writeByte(_loc_4.charCodeAt(_loc_3));
                _loc_3 = _loc_3 + 1;
            }
            postData = this.LINEBREAK(postData);
            postData = this.LINEBREAK(postData);
            return postData;
        }// end function

        private function getFilePartData(postData:ByteArray, part:FilePart) : ByteArray
        {
            postData.writeBytes(part.fileContent, 0, part.fileContent.length);
            return postData;
        }// end function

        private function onProgress(event:ProgressEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            this.removeListener();
            dispatchEvent(event);
            return;
        }// end function

        private function onIOError(event:IOErrorEvent) : void
        {
            this.removeListener();
            dispatchEvent(event);
            return;
        }// end function

        private function onSecurityError(event:SecurityErrorEvent) : void
        {
            this.removeListener();
            dispatchEvent(event);
            return;
        }// end function

        private function onHTTPStatus(event:HTTPStatusEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function addListener() : void
        {
            this._loader.addEventListener(Event.COMPLETE, this.onComplete, false, 0, false);
            this._loader.addEventListener(ProgressEvent.PROGRESS, this.onProgress, false, 0, false);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, false);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus, false, 0, false);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError, false, 0, false);
            return;
        }// end function

        private function removeListener() : void
        {
            this._loader.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            return;
        }// end function

        private function BOUNDARY(p:ByteArray) : ByteArray
        {
            var _loc_2:* = this.getBoundary().length;
            p = this.DOUBLEDASH(p);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                p.writeByte(this._boundary.charCodeAt(_loc_3));
                _loc_3 = _loc_3 + 1;
            }
            return p;
        }// end function

        private function LINEBREAK(p:ByteArray) : ByteArray
        {
            p.writeShort(3338);
            return p;
        }// end function

        private function QUOTATIONMARK(p:ByteArray) : ByteArray
        {
            p.writeByte(34);
            return p;
        }// end function

        private function DOUBLEDASH(p:ByteArray) : ByteArray
        {
            p.writeShort(11565);
            return p;
        }// end function

    }
}
