package com.esri.ags.layers
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.events.*;
    import mx.logging.*;

    public class MapImageLayer extends Layer
    {
        private var _log:ILogger;
        private var _mapImageProvider:ArrayCollection;
        private var _imageLoader:ImageLoader;
        private var _loaderToMapImage:Dictionary;
        private var _mapImageToLoader:Dictionary;
        private var _initialExtent:Extent;
        private static const WEB_MERCATOR_IDS:Array = [102100, 3857, 102113];

        public function MapImageLayer()
        {
            this._log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this._mapImageProvider = new ArrayCollection();
            this._loaderToMapImage = new Dictionary();
            this._mapImageToLoader = new Dictionary();
            this._mapImageProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            return;
        }// end function

        protected function creationCompleteHandler(event:FlexEvent) : void
        {
            removeEventListener(FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
            setLoaded(true);
            return;
        }// end function

        override public function get initialExtent() : Extent
        {
            return this._initialExtent ? (this._initialExtent) : (new Extent(-180, -90, 180, 90, new SpatialReference(4326)));
        }// end function

        public function set initialExtent(value:Extent) : void
        {
            this._initialExtent = value;
            return;
        }// end function

        public function get mapImageProvider() : Object
        {
            return this._mapImageProvider;
        }// end function

        public function set mapImageProvider(value:Object) : void
        {
            var _loc_3:Array = null;
            if (this._mapImageProvider)
            {
                this._mapImageProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            if (value is Array)
            {
                this._mapImageProvider = new ArrayCollection(value as Array);
            }
            else if (value is ArrayCollection)
            {
                this._mapImageProvider = value as ArrayCollection;
            }
            else
            {
                _loc_3 = [];
                if (value != null)
                {
                    _loc_3.push(value);
                }
                this._mapImageProvider = new ArrayCollection(_loc_3);
            }
            this._mapImageProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            var _loc_2:* = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc_2.kind = CollectionEventKind.RESET;
            this.collectionChangeHandler(_loc_2);
            dispatchEvent(new Event("imageProviderChanged"));
            return;
        }// end function

        protected function collectionChangeHandler(event:CollectionEvent) : void
        {
            dispatchEvent(event);
            switch(event.kind)
            {
                case CollectionEventKind.ADD:
                {
                    this.collectionAddHandler(event);
                    break;
                }
                case CollectionEventKind.REMOVE:
                {
                    this.collectionRemoveHandler(event);
                    break;
                }
                case CollectionEventKind.MOVE:
                {
                    this.collectionMoveHandler(event);
                    break;
                }
                case CollectionEventKind.REPLACE:
                {
                    this.collectionReplaceHandler(event);
                    break;
                }
                case CollectionEventKind.REFRESH:
                case CollectionEventKind.RESET:
                {
                    this.collectionRefreshOrResetHandler();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function updateLayer() : void
        {
            var _loc_1:ImageLoader = null;
            this.resetTransformMatrix();
            graphics.clear();
            var _loc_2:* = numChildren;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = ImageLoader(getChildAt(_loc_3));
                this.positionAndSize(_loc_1, this._loaderToMapImage[_loc_1]);
                _loc_3 = _loc_3 + 1;
            }
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }// end function

        override protected function zoomStartHandler(event:ZoomEvent) : void
        {
            return;
        }// end function

        override protected function zoomUpdateHandler(event:ZoomEvent) : void
        {
            var _loc_2:* = map.layerContainer ? (map.layerContainer.scrollRect) : (null);
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = event.x + _loc_2.x - _loc_2.x * event.zoomFactor;
            var _loc_4:* = event.y + _loc_2.y - _loc_2.y * event.zoomFactor;
            var _loc_5:* = this.transform.matrix;
            if (_loc_5)
            {
                _loc_5.identity();
            }
            else
            {
                _loc_5 = new Matrix();
            }
            _loc_5.scale(event.zoomFactor, event.zoomFactor);
            _loc_5.translate(_loc_3, _loc_4);
            this.transform.matrix = _loc_5;
            return;
        }// end function

        override protected function zoomEndHandler(event:ZoomEvent) : void
        {
            this.zoomUpdateHandler(event);
            return;
        }// end function

        public function add(mapImage:MapImage) : void
        {
            this._mapImageProvider.addItem(mapImage);
            return;
        }// end function

        public function remove(mapImage:MapImage) : void
        {
            var _loc_2:* = this._mapImageProvider.getItemIndex(mapImage);
            if (_loc_2 > -1)
            {
                this._mapImageProvider.removeItemAt(_loc_2);
            }
            return;
        }// end function

        public function removeAll() : void
        {
            this._mapImageProvider.removeAll();
            return;
        }// end function

        public function getImageVisibility(mapImage:MapImage) : Boolean
        {
            return ImageLoader(this._mapImageToLoader[mapImage]).visible;
        }// end function

        public function setImageVisibility(mapImage:MapImage, isVisible:Boolean) : void
        {
            ImageLoader(this._mapImageToLoader[mapImage]).visible = isVisible;
            return;
        }// end function

        private function collectionAddHandler(event:CollectionEvent) : void
        {
            var _loc_2:MapImage = null;
            for each (_loc_2 in event.items)
            {
                
                this.addAndLoadImage(_loc_2, true, event.location);
            }
            return;
        }// end function

        private function collectionMoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:MapImage = null;
            for each (_loc_2 in event.items)
            {
                
                setChildIndex(this._mapImageToLoader[_loc_2], event.location);
            }
            return;
        }// end function

        private function collectionRefreshOrResetHandler() : void
        {
            var _loc_1:MapImage = null;
            removeAllChildren();
            this._loaderToMapImage = new Dictionary();
            this._mapImageToLoader = new Dictionary();
            for each (_loc_1 in this._mapImageProvider)
            {
                
                this.addAndLoadImage(_loc_1);
            }
            return;
        }// end function

        private function collectionRemoveHandler(event:CollectionEvent) : void
        {
            var _loc_2:MapImage = null;
            var _loc_3:ImageLoader = null;
            for each (_loc_2 in event.items)
            {
                
                _loc_3 = this._mapImageToLoader[_loc_2];
                removeChild(_loc_3);
                delete this._mapImageToLoader[_loc_2];
                delete this._loaderToMapImage[_loc_3];
            }
            return;
        }// end function

        private function collectionReplaceHandler(event:CollectionEvent) : void
        {
            var _loc_2:PropertyChangeEvent = null;
            var _loc_5:ImageLoader = null;
            _loc_2 = PropertyChangeEvent(event.items[0]);
            var _loc_3:* = MapImage(_loc_2.newValue);
            this.addAndLoadImage(_loc_3, true, event.location);
            var _loc_4:* = _loc_2.oldValue as MapImage;
            if (_loc_4)
            {
                _loc_5 = this._mapImageToLoader[_loc_4];
                removeChild(_loc_5);
            }
            return;
        }// end function

        private function addAndLoadImage(mapImage:MapImage, doPosition:Boolean = false, position:Number = 0) : void
        {
            var _loc_4:* = mapImage.source;
            if (!(_loc_4 is Class))
            {
            }
            if (_loc_4 == Bitmap)
            {
            }
            else
            {
                this._imageLoader = new ImageLoader();
                this._imageLoader.addEventListener(Event.COMPLETE, this.imageLoader_completeHandler, false, 0, true);
                this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR, this.imageLoader_ioErrorHandler, false, 0, true);
                ImageLoader(this._imageLoader).load(new URLRequest(_loc_4 as String));
                this._loaderToMapImage[this._imageLoader] = mapImage;
                this._mapImageToLoader[mapImage] = this._imageLoader;
                if (doPosition)
                {
                    addChildAt(this._imageLoader, position);
                }
                else
                {
                    addChild(this._imageLoader);
                }
            }
            return;
        }// end function

        private function positionAndSize(loader:ImageLoader, mapImage:MapImage) : void
        {
            var _loc_4:Number = NaN;
            if (map)
            {
            }
            if (!map.loaded)
            {
                return;
            }
            var _loc_3:* = mapImage.extent;
            if (_loc_3.spatialReference)
            {
                _loc_4 = _loc_3.spatialReference.wkid;
            }
            var _loc_5:* = new MapPoint(_loc_3.xmin, _loc_3.ymax);
            var _loc_6:* = new MapPoint(_loc_3.xmax, _loc_3.ymin);
            if (_loc_4)
            {
            }
            if (_loc_4 == 4326)
            {
            }
            if (WEB_MERCATOR_IDS.indexOf(map.spatialReference.wkid) != -1)
            {
                _loc_5 = WebMercatorUtil.geographicToWebMercator(_loc_5) as MapPoint;
                _loc_6 = WebMercatorUtil.geographicToWebMercator(_loc_6) as MapPoint;
            }
            var _loc_7:* = map.toScreen(_loc_5);
            var _loc_8:* = map.toScreen(_loc_6);
            var _loc_9:* = mapImage.rotation;
            loader.x = _loc_7.x + map.layerContainer.scrollRect.x;
            loader.y = _loc_7.y + map.layerContainer.scrollRect.y;
            loader.width = Math.abs(_loc_8.x - _loc_7.x);
            loader.height = Math.abs(_loc_7.y - _loc_8.y);
            loader.rotation = _loc_9;
            return;
        }// end function

        private function imageLoader_completeHandler(event:Event) : void
        {
            var _loc_2:* = ImageLoader(event.target);
            this.positionAndSize(_loc_2, this._loaderToMapImage[_loc_2]);
            return;
        }// end function

        private function imageLoader_ioErrorHandler(event:IOErrorEvent) : void
        {
            if (Log.isError())
            {
                this._log.error("{0}::{1}", id, event.text);
            }
            return;
        }// end function

        private function resetTransformMatrix() : void
        {
            var _loc_1:* = this.transform.matrix;
            if (_loc_1)
            {
                _loc_1.identity();
            }
            else
            {
                _loc_1 = new Matrix();
            }
            this.transform.matrix = _loc_1;
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));
            return;
        }// end function

    }
}
