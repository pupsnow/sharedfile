package com.esri.ags.symbols
{
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.logging.*;

    public class PictureMarkerSymbolCache extends Object
    {
        private var m_sourceToObject:Dictionary;
        private var m_logger:ILogger;
        private var m_customSprite:CustomSprite;
        private var m_loaderContext:LoaderContext;
        private var m_broken:Class;
        private static var m_instance:PictureMarkerSymbolCache;

        public function PictureMarkerSymbolCache()
        {
            this.m_sourceToObject = new Dictionary();
            this.m_loaderContext = new LoaderContext(true);
            this.m_broken = PictureMarkerSymbolCache_m_broken;
            return;
        }// end function

        private function get logger() : ILogger
        {
            if (this.m_logger === null)
            {
                this.m_logger = Log.getLogger(getQualifiedClassName(PictureMarkerSymbolCache).replace(/::/, "."));
            }
            return this.m_logger;
        }// end function

        public function getCachedObject(source:Object, callback:Function, matrix:Matrix = null) : void
        {
            var customPictureMarkerObject:CustomPictureMarkerObject;
            var bitmap:Bitmap;
            var text:String;
            var clazz:Class;
            var loader:Loader;
            var instance:*;
            var displayObject:DisplayObject;
            var bitmapData:BitmapData;
            var source:* = source;
            var callback:* = callback;
            var matrix:* = matrix;
            customPictureMarkerObject = this.m_sourceToObject[source];
            if (customPictureMarkerObject === null)
            {
                text = source as String;
                if (text)
                {
                    var completeHandler:* = function (event:Event) : void
            {
                var _loc_3:Object = null;
                var _loc_2:* = event.target as LoaderInfo;
                customPictureMarkerObject.isComplete = true;
                customPictureMarkerObject.bitmap = loader.content as Bitmap;
                for each (_loc_3 in customPictureMarkerObject.arrFunction)
                {
                    
                    _loc_3.operation(customPictureMarkerObject);
                }
                return;
            }// end function
            ;
                    customPictureMarkerObject = new CustomPictureMarkerObject();
                    customPictureMarkerObject.arrFunction = [{operation:callback, pt:null, originalPt:null}];
                    customPictureMarkerObject.isComplete = false;
                    this.m_sourceToObject[source] = customPictureMarkerObject;
                    loader = new Loader();
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                    loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                    loader.load(new URLRequest(text), this.m_loaderContext);
                    return;
                }
                clazz = source as Class;
                if (clazz)
                {
                    instance = new clazz;
                    bitmap = instance as Bitmap;
                    if (bitmap === null)
                    {
                        displayObject = instance as DisplayObject;
                        if (displayObject)
                        {
                            bitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0);
                            bitmapData.draw(displayObject, matrix);
                            bitmap = new Bitmap(bitmapData);
                        }
                        else
                        {
                            bitmap = new this.m_broken();
                        }
                    }
                    if (bitmap)
                    {
                        customPictureMarkerObject = new CustomPictureMarkerObject();
                        customPictureMarkerObject.bitmap = bitmap;
                        customPictureMarkerObject.isComplete = true;
                        this.m_sourceToObject[source] = customPictureMarkerObject;
                        this.callback(customPictureMarkerObject);
                    }
                    return;
                }
                bitmap = source as Bitmap;
                if (bitmap)
                {
                    customPictureMarkerObject = new CustomPictureMarkerObject();
                    customPictureMarkerObject.bitmap = bitmap;
                    customPictureMarkerObject.isComplete = true;
                    this.m_sourceToObject[source] = customPictureMarkerObject;
                    this.callback(customPictureMarkerObject);
                    return;
                }
                customPictureMarkerObject = new CustomPictureMarkerObject();
                customPictureMarkerObject.bitmap = new this.m_broken();
                customPictureMarkerObject.isComplete = true;
                this.m_sourceToObject[source] = customPictureMarkerObject;
                this.callback(customPictureMarkerObject);
            }
            else if (customPictureMarkerObject.isComplete === false)
            {
                customPictureMarkerObject.arrFunction.push({operation:callback, pt:null, originalPt:null});
            }
            else if (customPictureMarkerObject.isComplete)
            {
                this.callback(customPictureMarkerObject);
            }
            else
            {
                this.callback(customPictureMarkerObject);
            }
            return;
        }// end function

        public function getDisplayObject(source:Object, point:MapPoint, originalPoint:MapPoint, operation:Function) : void
        {
            var completeHandler:Function;
            var ioErrorHandler:Function;
            var loader:Loader;
            var source:* = source;
            var point:* = point;
            var originalPoint:* = originalPoint;
            var operation:* = operation;
            completeHandler = function (event:Event) : void
            {
                var i:Number;
                var event:* = event;
                var loaderInfo:* = event.target as LoaderInfo;
                CustomPictureMarkerObject(m_sourceToObject[source]).isComplete = true;
                try
                {
                    if (loaderInfo.content is Bitmap)
                    {
                        CustomPictureMarkerObject(m_sourceToObject[source]).bitmap = loaderInfo.content as Bitmap;
                        i;
                        while (i < CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction.length)
                        {
                            
                            addBitmapImage(CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[i].operation, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[i].pt, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[i].originalPt, CustomPictureMarkerObject(m_sourceToObject[source]).bitmap);
                            i = (i + 1);
                        }
                    }
                    else
                    {
                        handleNonBitmapImage();
                    }
                }
                catch (error:Error)
                {
                    if (error is SecurityError)
                    {
                        handleNonBitmapImage();
                    }
                }
                return;
            }// end function
            ;
            var handleNonBitmapImage:* = function () : void
            {
                m_customSprite = new CustomSprite();
                if (CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[0].originalPt)
                {
                    m_customSprite.mapPoint = CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[0].originalPt;
                }
                m_customSprite.addChild(loader);
                CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[0].operation(m_customSprite, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[0].pt);
                var _loc_1:Number = 1;
                while (_loc_1 < CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction.length)
                {
                    
                    loadNonBitmapImage(CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_1].operation, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_1].pt, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_1].originalPt, source);
                    _loc_1 = _loc_1 + 1;
                }
                return;
            }// end function
            ;
            ioErrorHandler = function (event:Event) : void
            {
                if (Log.isError())
                {
                    logger.error(event.toString());
                }
                CustomPictureMarkerObject(m_sourceToObject[source]).isComplete = true;
                CustomPictureMarkerObject(m_sourceToObject[source]).bitmap = new m_broken();
                var _loc_2:Number = 0;
                while (_loc_2 < CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction.length)
                {
                    
                    addBitmapImage(CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_2].operation, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_2].pt, CustomPictureMarkerObject(m_sourceToObject[source]).arrFunction[_loc_2].originalPt, CustomPictureMarkerObject(m_sourceToObject[source]).bitmap);
                    _loc_2 = _loc_2 + 1;
                }
                m_sourceToObject[source] = null;
                return;
            }// end function
            ;
            var customPictureMarkerObject:* = this.m_sourceToObject[source];
            if (customPictureMarkerObject === null)
            {
                customPictureMarkerObject = new CustomPictureMarkerObject();
                customPictureMarkerObject.arrFunction = [];
                loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                if (source is String)
                {
                    loader.load(new URLRequest(String(source)), this.m_loaderContext);
                }
                else
                {
                    loader.loadBytes(source as ByteArray, new LoaderContext());
                }
                customPictureMarkerObject.isComplete = false;
                customPictureMarkerObject.arrFunction.push({operation:operation, pt:point, originalPt:originalPoint});
                this.m_sourceToObject[source] = customPictureMarkerObject;
            }
            else if (customPictureMarkerObject.isComplete === false)
            {
                customPictureMarkerObject.arrFunction.push({operation:operation, pt:point, originalPt:originalPoint});
            }
            else if (customPictureMarkerObject.isComplete)
            {
                if (customPictureMarkerObject.bitmap)
                {
                    this.addBitmapImage(operation, point, originalPoint, customPictureMarkerObject.bitmap);
                }
                else
                {
                    this.loadNonBitmapImage(operation, point, originalPoint, source);
                }
            }
            return;
        }// end function

        public function isComplete(source:String) : Boolean
        {
            if (this.m_sourceToObject[source])
            {
            }
            return CustomPictureMarkerObject(this.m_sourceToObject[source]).isComplete;
        }// end function

        private function addBitmapImage(operation:Function, mapPoint:MapPoint, originalPt:MapPoint, bitmap:Bitmap) : void
        {
            this.m_customSprite = new CustomSprite(originalPt);
            this.m_customSprite.addChild(new Bitmap(bitmap.bitmapData));
            this.operation(this.m_customSprite, mapPoint);
            return;
        }// end function

        private function loadNonBitmapImage(operation:Function, mapPoint:MapPoint, originalPt:MapPoint, source:Object) : void
        {
            var loader:Loader;
            var operation:* = operation;
            var mapPoint:* = mapPoint;
            var originalPt:* = originalPt;
            var source:* = source;
            var completeHandler:* = function (event:Event) : void
            {
                m_customSprite = new CustomSprite();
                if (originalPt)
                {
                    m_customSprite.mapPoint = originalPt;
                }
                m_customSprite.addChild(loader);
                operation(m_customSprite, mapPoint);
                return;
            }// end function
            ;
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            if (source is String)
            {
                loader.load(new URLRequest(String(source)), this.m_loaderContext);
            }
            else
            {
                loader.loadBytes(source as ByteArray, new LoaderContext());
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            if (Log.isError())
            {
                this.logger.error(event.toString());
            }
            return;
        }// end function

        public static function get instance() : PictureMarkerSymbolCache
        {
            if (m_instance === null)
            {
                m_instance = new PictureMarkerSymbolCache;
            }
            return m_instance;
        }// end function

    }
}
