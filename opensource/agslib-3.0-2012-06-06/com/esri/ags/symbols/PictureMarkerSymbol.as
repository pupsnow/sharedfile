package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.graphics.codec.*;
    import mx.utils.*;

    public class PictureMarkerSymbol extends MarkerSymbol implements IJSONSupport
    {
        private var m_source:Object;
        private var m_embed:Class;
        private var m_width:Number;
        private var m_height:Number;
        private var m_dispObj:DisplayObject;
        private var m_hasChildren:Boolean;
        private var m_rotationSprite:Sprite;
        var m_editModeOn:Boolean;
        private var m_myWidth:Number;
        private var m_myHeight:Number;
        private var m_spriteToPoint:Dictionary;
        private var m_spriteToMultipointArray:Dictionary;
        private var m_imageData:String;
        private var m_imageDataContentType:String;
        private var m_imageDataWidth:Number;
        private var m_imageDataHeight:Number;

        public function PictureMarkerSymbol(source:Object = null, width:Number = 0, height:Number = 0, xoffset:Number = 0, yoffset:Number = 0, angle:Number = 0)
        {
            this.m_embed = PictureMarkerSymbol_m_embed;
            this.m_spriteToPoint = new Dictionary();
            this.m_spriteToMultipointArray = new Dictionary();
            this.m_source = this.m_embed;
            this.source = source;
            this.width = width;
            this.height = height;
            this.xoffset = xoffset;
            this.yoffset = yoffset;
            this.angle = angle;
            return;
        }// end function

        public function get source() : Object
        {
            return this.m_source;
        }// end function

        private function set _896505829source(value:Object) : void
        {
            if (value != this.m_source)
            {
                this.m_dispObj = null;
                this.m_imageData = null;
                this.m_imageDataContentType = null;
                this.m_imageDataWidth = NaN;
                this.m_imageDataHeight = NaN;
                if (value == null)
                {
                    this.m_source = this.m_embed;
                }
                else
                {
                    this.m_source = value;
                }
                dispatchEvent(new Event(Event.CHANGE));
            }
            return;
        }// end function

        public function get width() : Number
        {
            return this.m_width;
        }// end function

        private function set _113126854width(value:Number) : void
        {
            if (value != this.m_width)
            {
                this.m_myWidth = value;
                this.m_width = value;
                dispatchEvent(new Event(Event.CHANGE));
            }
            return;
        }// end function

        public function get height() : Number
        {
            return this.m_height;
        }// end function

        private function set _1221029593height(value:Number) : void
        {
            if (value != this.m_height)
            {
                this.m_myHeight = value;
                this.m_height = value;
                dispatchEvent(new Event(Event.CHANGE));
            }
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var sourceGeometryObject:Object;
            var sourceMultipoint:Multipoint;
            var sourceOriginalMultipoint:Multipoint;
            var sourceMultipointGeometryObject:Object;
            var sourceNewMultipointGeometry:Geometry;
            var sourceOriginalMultipointGeometry:Geometry;
            var loadedGeometryObject:Object;
            var loadedMultipoint:Multipoint;
            var loadedOriginalMultipoint:Multipoint;
            var loadedMultipointGeometryObject:Object;
            var loadedNewMultipointGeometry:Geometry;
            var loadedOriginalMultipointGeometry:Geometry;
            var sprite:* = sprite;
            var geometry:* = geometry;
            var attributes:* = attributes;
            var map:* = map;
            var getSourcePoint:* = function (geometry:Geometry) : MapPoint
            {
                var ptSource:MapPoint;
                var sourceObject:DisplayObject;
                var geometry:* = geometry;
                var addToCustomSprite:* = function (srcObject:DisplayObject) : void
                {
                    m_dispObj = new CustomSprite(ptSource);
                    m_dispObj.name = "displayObject";
                    CustomSprite(m_dispObj).addChild(srcObject);
                    if (m_editModeOn)
                    {
                        CustomSprite(m_dispObj).mouseChildren = false;
                    }
                    return;
                }// end function
                ;
                if (geometry is MapPoint)
                {
                    ptSource = geometry as MapPoint;
                }
                else
                {
                    if (sprite.numChildren == 2)
                    {
                        sprite.removeChildAt(0);
                    }
                    ptSource = Multipoint(geometry).points[0] as MapPoint;
                }
                if (sprite.numChildren > 0)
                {
                    getChildFromSprite(sprite);
                }
                if (sprite.numChildren == 0)
                {
                    m_hasChildren = false;
                    if (sprite is CompositeSymbolComponent)
                    {
                        CompositeSymbolComponent(sprite).source = m_source;
                    }
                    else
                    {
                        Graphic(sprite).source = m_source;
                    }
                    if (m_source is Class)
                    {
                        sourceObject = new m_source();
                        if (sourceObject is BitmapAsset)
                        {
                            new activation.addToCustomSprite(sourceObject);
                        }
                        else
                        {
                            m_dispObj = new CustomSWFLoader();
                            m_dispObj.name = "displayObject";
                            CustomSWFLoader(m_dispObj).maintainAspectRatio = false;
                            CustomSWFLoader(m_dispObj).source = m_source;
                            CustomSWFLoader(m_dispObj).mapPoint = ptSource;
                            if (m_editModeOn)
                            {
                                CustomSWFLoader(m_dispObj).mouseChildren = false;
                            }
                        }
                    }
                    else
                    {
                        new activation.addToCustomSprite(m_source as Bitmap);
                    }
                }
                return ptSource;
            }// end function
            ;
            var getLoadedPoint:* = function (geometry:Geometry) : MapPoint
            {
                var _loc_2:MapPoint = null;
                if (geometry is MapPoint)
                {
                    _loc_2 = geometry as MapPoint;
                }
                else
                {
                    if (sprite.numChildren == 2)
                    {
                        sprite.removeChildAt(0);
                    }
                    _loc_2 = Multipoint(geometry).points[0] as MapPoint;
                }
                return _loc_2;
            }// end function
            ;
            if (!geometry)
            {
                return;
            }
            var mapExtent:* = map.extentExpanded;
            if (!(this.m_source is Class))
            {
            }
            if (this.m_source is Bitmap)
            {
                if (!(geometry is MapPoint))
                {
                    if (geometry is Multipoint)
                    {
                    }
                }
                if (Multipoint(geometry).points.length == 1)
                {
                    if (!map.wrapAround180)
                    {
                        if (mapExtent.intersects(geometry))
                        {
                            this.drawSourcePoint(map, sprite, this.getSourcePoint(geometry));
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                    }
                    else
                    {
                        sourceGeometryObject = this.getNewPointGeometry(map, geometry);
                        sourceMultipoint = sourceGeometryObject.newGeometry;
                        sourceOriginalMultipoint = sourceGeometryObject.originalGeometry;
                        if (sourceMultipoint)
                        {
                        }
                        if (sourceMultipoint.points.length > 0)
                        {
                            this.drawSourceMultipoint(map, sprite, sourceMultipoint, sourceOriginalMultipoint);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                    }
                }
                else if (!map.wrapAround180)
                {
                    if (mapExtent.intersects(geometry))
                    {
                        this.drawSourceMultipoint(map, sprite, geometry, geometry);
                        showAllChildren(sprite);
                    }
                    else
                    {
                        hideAllChildren(sprite);
                    }
                }
                else
                {
                    sourceMultipointGeometryObject = this.getNewMultipointGeometry(map, geometry);
                    sourceNewMultipointGeometry = sourceMultipointGeometryObject.newGeometry;
                    sourceOriginalMultipointGeometry = sourceMultipointGeometryObject.originalGeometry;
                    if (sourceNewMultipointGeometry)
                    {
                        this.drawSourceMultipoint(map, sprite, sourceNewMultipointGeometry, sourceOriginalMultipointGeometry);
                        showAllChildren(sprite);
                    }
                    else
                    {
                        hideAllChildren(sprite);
                    }
                }
            }
            else
            {
                if (!(this.m_source is String))
                {
                }
                if (this.m_source is ByteArray)
                {
                    if (!(geometry is MapPoint))
                    {
                        if (geometry is Multipoint)
                        {
                        }
                    }
                    if (Multipoint(geometry).points.length == 1)
                    {
                        if (!map.wrapAround180)
                        {
                            if (mapExtent.intersects(geometry))
                            {
                                this.drawLoadedPoint(map, sprite, this.getLoadedPoint(geometry));
                                showAllChildren(sprite);
                            }
                            else
                            {
                                hideAllChildren(sprite);
                            }
                        }
                        else
                        {
                            loadedGeometryObject = this.getNewPointGeometry(map, geometry);
                            loadedMultipoint = loadedGeometryObject.newGeometry;
                            loadedOriginalMultipoint = loadedGeometryObject.originalGeometry;
                            if (loadedMultipoint)
                            {
                            }
                            if (loadedMultipoint.points.length > 0)
                            {
                                this.drawLoadedMultipoint(map, sprite, loadedMultipoint, loadedOriginalMultipoint);
                                showAllChildren(sprite);
                            }
                            else
                            {
                                hideAllChildren(sprite);
                            }
                        }
                    }
                    else if (!map.wrapAround180)
                    {
                        if (mapExtent.intersects(geometry))
                        {
                            this.drawLoadedMultipoint(map, sprite, geometry, geometry);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                    }
                    else
                    {
                        loadedMultipointGeometryObject = this.getNewMultipointGeometry(map, geometry);
                        loadedNewMultipointGeometry = loadedMultipointGeometryObject.newGeometry;
                        loadedOriginalMultipointGeometry = loadedMultipointGeometryObject.originalGeometry;
                        if (loadedNewMultipointGeometry)
                        {
                            this.drawLoadedMultipoint(map, sprite, loadedNewMultipointGeometry, loadedOriginalMultipointGeometry);
                            showAllChildren(sprite);
                        }
                        else
                        {
                            hideAllChildren(sprite);
                        }
                    }
                }
            }
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            sprite.graphics.clear();
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            removeAllChildren(sprite);
            sprite.graphics.clear();
            sprite.mouseChildren = true;
            sprite.rotation = 0;
            sprite.x = 0;
            sprite.y = 0;
            delete this.m_spriteToPoint[sprite];
            delete this.m_spriteToMultipointArray[sprite];
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            var swatchSprite:Sprite;
            var centerX:Number;
            var centerY:Number;
            var imageWidth:Number;
            var imageHeight:Number;
            var width:* = width;
            var height:* = height;
            var shape:* = shape;
            var swatchPlacement:* = function () : void
            {
                m_dispObj.width = imageWidth;
                m_dispObj.height = imageHeight;
                swatchSprite.width = imageWidth;
                swatchSprite.height = imageHeight;
                swatchSprite.x = centerX - imageWidth / 2;
                swatchSprite.y = centerY - imageHeight / 2;
                if (!m_angle)
                {
                    swatchSprite.addChild(m_dispObj);
                    m_dispObj.x = 0;
                    m_dispObj.y = 0;
                }
                else
                {
                    m_rotationSprite = new UIComponent();
                    m_rotationSprite.x = imageWidth / 2;
                    m_rotationSprite.y = imageHeight / 2;
                    m_dispObj.x = (-imageWidth) / 2;
                    m_dispObj.y = (-imageHeight) / 2;
                    m_rotationSprite.addChild(m_dispObj);
                    m_rotationSprite.rotation = m_angle;
                    swatchSprite.addChild(m_rotationSprite);
                }
                return;
            }// end function
            ;
            var swatch:* = new UIComponent();
            swatch.width = width;
            swatch.height = height;
            swatchSprite = new UIComponent();
            swatch.addChild(swatchSprite);
            centerX = width * 0.5;
            centerY = height * 0.5;
            removeAllChildren(swatchSprite);
            if (!(this.m_source is Class))
            {
            }
            if (this.m_source is Bitmap)
            {
                this.m_dispObj = this.m_source is Bitmap ? (this.m_source as Bitmap) : (new this.m_source() as DisplayObject);
                if (this.m_width)
                {
                    imageWidth = Math.min(this.m_width, width);
                }
                else
                {
                    imageWidth = Math.min(this.m_dispObj.width, width);
                }
                if (this.m_height)
                {
                    imageHeight = Math.min(this.m_height, height);
                }
                else
                {
                    imageHeight = Math.min(this.m_dispObj.height, height);
                }
                this.swatchPlacement();
            }
            else
            {
                var handleCacheResult:* = function (resultSprite:CustomSprite, mapPoint:MapPoint) : void
            {
                m_dispObj = resultSprite as DisplayObject;
                if (m_myWidth)
                {
                }
                if (m_myHeight)
                {
                    imageWidth = Math.min(m_myWidth, width);
                    imageHeight = Math.min(m_myHeight, height);
                    swatchPlacement();
                }
                else
                {
                    imageWidth = Math.min(m_dispObj.width, width);
                    imageHeight = Math.min(m_dispObj.width, height);
                }
                swatchPlacement();
                return;
            }// end function
            ;
                PictureMarkerSymbolCache.instance.getDisplayObject(this.m_source, null, null, handleCacheResult);
            }
            return swatch;
        }// end function

        function doNotLoad(map:Map, sprite:Sprite, geometry:Geometry) : Boolean
        {
            var _loc_4:Boolean = false;
            var _loc_5:Array = null;
            var _loc_6:Multipoint = null;
            var _loc_7:Multipoint = null;
            var _loc_8:Polyline = null;
            var _loc_9:Array = null;
            var _loc_10:Array = null;
            var _loc_11:Number = NaN;
            var _loc_12:Polygon = null;
            var _loc_13:Array = null;
            var _loc_14:Array = null;
            var _loc_15:Number = NaN;
            var _loc_16:Extent = null;
            var _loc_17:Polygon = null;
            var _loc_18:Array = null;
            var _loc_19:Array = null;
            var _loc_20:Number = NaN;
            if (this.m_source is Class)
            {
                _loc_4 = false;
            }
            else if (PictureMarkerSymbolCache.instance.isComplete(String(this.m_source)))
            {
                _loc_4 = false;
            }
            else
            {
                _loc_5 = [];
                switch(geometry.type)
                {
                    case Geometry.MAPPOINT:
                    {
                        if (map.wrapAround180)
                        {
                            _loc_6 = this.getNewPointGeometry(map, geometry).newGeometry;
                            if (_loc_6)
                            {
                                _loc_5 = _loc_6.points.slice();
                            }
                            if (sprite.numChildren == _loc_5.length)
                            {
                                _loc_4 = false;
                            }
                            else
                            {
                                _loc_4 = true;
                            }
                        }
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        _loc_7 = !map.wrapAround180 ? (geometry as Multipoint) : (this.getNewMultipointGeometry(map, geometry).newGeometry);
                        if (_loc_7)
                        {
                            _loc_5 = _loc_7.points.slice();
                        }
                        if (sprite.numChildren == _loc_5.length)
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        _loc_8 = !map.wrapAround180 ? (geometry as Polyline) : (this.getNewMultipointGeometry(map, geometry).newGeometry as Polyline);
                        _loc_9 = [];
                        if (_loc_8)
                        {
                            for each (_loc_10 in _loc_8.paths.slice())
                            {
                                
                                if (_loc_10.length > 2)
                                {
                                    if (_loc_10[(_loc_10.length - 1)].x == _loc_10[0].x)
                                    {
                                    }
                                    _loc_9 = _loc_10[(_loc_10.length - 1)].y == _loc_10[0].y ? (_loc_10.slice(1, _loc_10.length)) : (_loc_10);
                                }
                                _loc_11 = 0;
                                while (_loc_11 < _loc_9.length)
                                {
                                    
                                    _loc_5.push(_loc_9[_loc_11] as MapPoint);
                                    _loc_11 = _loc_11 + 1;
                                }
                            }
                        }
                        if (sprite.numChildren == _loc_5.length)
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        _loc_12 = !map.wrapAround180 ? (geometry as Polygon) : (this.getNewMultipointGeometry(map, geometry).newGeometry as Polygon);
                        _loc_13 = [];
                        if (_loc_12)
                        {
                            for each (_loc_14 in _loc_12.rings.slice())
                            {
                                
                                if (_loc_14.length > 2)
                                {
                                    if (_loc_14[(_loc_14.length - 1)].x == _loc_14[0].x)
                                    {
                                    }
                                    _loc_13 = _loc_14[(_loc_14.length - 1)].y == _loc_14[0].y ? (_loc_14.slice(1, _loc_14.length)) : (_loc_14);
                                }
                                _loc_15 = 0;
                                while (_loc_15 < _loc_13.length)
                                {
                                    
                                    _loc_5.push(_loc_13[_loc_15] as MapPoint);
                                    _loc_15 = _loc_15 + 1;
                                }
                            }
                        }
                        if (sprite.numChildren == _loc_5.length)
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                        break;
                    }
                    case Geometry.EXTENT:
                    {
                        if (!map.wrapAround180)
                        {
                            _loc_16 = geometry as Extent;
                            _loc_5.push(new MapPoint(_loc_16.xmin, _loc_16.ymax), new MapPoint(_loc_16.xmin, _loc_16.ymin), new MapPoint(_loc_16.xmax, _loc_16.ymin), new MapPoint(_loc_16.xmax, _loc_16.ymax));
                        }
                        else
                        {
                            _loc_17 = this.getNewMultipointGeometry(map, geometry).newGeometry as Polygon;
                            _loc_18 = [];
                            if (_loc_17)
                            {
                                for each (_loc_19 in _loc_17.rings.slice())
                                {
                                    
                                    if (_loc_19.length > 2)
                                    {
                                        if (_loc_19[(_loc_19.length - 1)].x == _loc_19[0].x)
                                        {
                                        }
                                        _loc_18 = _loc_19[(_loc_19.length - 1)].y == _loc_19[0].y ? (_loc_19.slice(1, _loc_19.length)) : (_loc_19);
                                    }
                                    _loc_20 = 0;
                                    while (_loc_20 < _loc_18.length)
                                    {
                                        
                                        _loc_5.push(_loc_18[_loc_20] as MapPoint);
                                        _loc_20 = _loc_20 + 1;
                                    }
                                }
                            }
                        }
                        if (sprite.numChildren == _loc_5.length)
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return _loc_4;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_3:String = null;
            var _loc_4:DisplayObject = null;
            var _loc_5:ByteArray = null;
            var _loc_6:BitmapData = null;
            var _loc_7:PNGEncoder = null;
            var _loc_8:DisplayObject = null;
            var _loc_9:ImageSnapshot = null;
            var _loc_10:Base64Encoder = null;
            var _loc_2:Object = {type:"esriPMS"};
            if (this.source is String)
            {
                _loc_3 = this.source as String;
                if (!URLUtil.isHttpURL(_loc_3))
                {
                    _loc_4 = FlexGlobals.topLevelApplication as DisplayObject;
                    _loc_3 = URLUtil.getFullURL(_loc_4.loaderInfo.loaderURL, _loc_3);
                }
                _loc_2.url = _loc_3;
            }
            else
            {
                if (!this.m_imageData)
                {
                    try
                    {
                        if (this.source is Bitmap)
                        {
                            _loc_6 = (this.source as Bitmap).bitmapData;
                            _loc_7 = new PNGEncoder();
                            _loc_5 = _loc_7.encode(_loc_6);
                            this.m_imageDataContentType = _loc_7.contentType;
                            this.m_imageDataWidth = _loc_6.width;
                            this.m_imageDataHeight = _loc_6.height;
                        }
                        else if (this.source is ByteArray)
                        {
                            _loc_5 = this.source as ByteArray;
                            this.m_imageDataContentType = ContentTypeUtil.getContentType(_loc_5);
                        }
                        else if (this.source is Class)
                        {
                            _loc_8 = new this.source() as DisplayObject;
                            if (_loc_8)
                            {
                                _loc_9 = ImageSnapshot.captureImage(_loc_8);
                                _loc_5 = _loc_9.data;
                                this.m_imageDataContentType = _loc_9.contentType;
                                this.m_imageDataWidth = _loc_8.width;
                                this.m_imageDataHeight = _loc_8.height;
                            }
                        }
                        if (_loc_5)
                        {
                            _loc_10 = new Base64Encoder();
                            _loc_10.insertNewLines = false;
                            _loc_10.encodeBytes(_loc_5);
                            this.m_imageData = _loc_10.toString();
                        }
                    }
                    catch (error:Error)
                    {
                    }
                }
                if (this.m_imageData)
                {
                    _loc_2.imageData = this.m_imageData;
                }
                if (this.m_imageDataContentType)
                {
                    _loc_2.contentType = this.m_imageDataContentType;
                }
            }
            if (this.width <= 0)
            {
            }
            if (this.m_imageDataWidth > 0)
            {
                _loc_2.width = this.width > 0 ? (SymbolFactory.pxToPt(this.width)) : (SymbolFactory.pxToPt(this.m_imageDataWidth));
            }
            if (this.height <= 0)
            {
            }
            if (this.m_imageDataHeight > 0)
            {
                _loc_2.height = this.height > 0 ? (SymbolFactory.pxToPt(this.height)) : (SymbolFactory.pxToPt(this.m_imageDataHeight));
            }
            if (isFinite(angle))
            {
                isFinite(angle);
            }
            if (angle != 0)
            {
                _loc_2.angle = -angle;
            }
            if (isFinite(xoffset))
            {
                isFinite(xoffset);
            }
            if (xoffset != 0)
            {
                _loc_2.xoffset = SymbolFactory.pxToPt(xoffset);
            }
            if (isFinite(yoffset))
            {
                isFinite(yoffset);
            }
            if (yoffset != 0)
            {
                _loc_2.yoffset = SymbolFactory.pxToPt(yoffset);
            }
            return _loc_2;
        }// end function

        private function getNewPointGeometry(map:Map, geometry1:Geometry) : Object
        {
            var _loc_7:Multipoint = null;
            var _loc_8:Multipoint = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:Object = {};
            var _loc_4:* = geometry1 is MapPoint ? (MapPoint(geometry1)) : (MapPoint(Multipoint(geometry1).points[0]));
            var _loc_5:* = new Extent(_loc_4.x, _loc_4.y, _loc_4.x, _loc_4.y, geometry1.spatialReference);
            var _loc_6:* = GeomUtils.intersects(map, _loc_4, _loc_5);
            if (_loc_6)
            {
            }
            if (_loc_6.length > 0)
            {
                _loc_7 = new Multipoint();
                _loc_8 = new Multipoint();
                _loc_9 = map.toScreenX(_loc_4.x);
                _loc_10 = map.toScreenY(_loc_4.y);
                for each (_loc_11 in _loc_6)
                {
                    
                    _loc_7.addPoint(map.toMap(new Point(_loc_9 + _loc_11, _loc_10)));
                    _loc_8.addPoint(_loc_4);
                }
                _loc_3.newGeometry = _loc_7;
                _loc_3.originalGeometry = _loc_8;
            }
            return _loc_3;
        }// end function

        private function getNewMultipointGeometry(map:Map, geometry:Geometry) : Object
        {
            var _loc_4:Array = null;
            var _loc_5:Multipoint = null;
            var _loc_6:Multipoint = null;
            var _loc_7:MapPoint = null;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_12:Polyline = null;
            var _loc_13:Polyline = null;
            var _loc_14:Array = null;
            var _loc_15:Number = NaN;
            var _loc_16:Array = null;
            var _loc_17:Array = null;
            var _loc_18:MapPoint = null;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:Array = null;
            var _loc_22:Polygon = null;
            var _loc_23:Polygon = null;
            var _loc_24:Array = null;
            var _loc_25:Number = NaN;
            var _loc_26:Array = null;
            var _loc_27:Array = null;
            var _loc_28:MapPoint = null;
            var _loc_29:Number = NaN;
            var _loc_30:Number = NaN;
            var _loc_31:Polygon = null;
            var _loc_32:Array = null;
            var _loc_33:Polygon = null;
            var _loc_34:Polygon = null;
            var _loc_35:Array = null;
            var _loc_36:Number = NaN;
            var _loc_37:Array = null;
            var _loc_38:Array = null;
            var _loc_39:MapPoint = null;
            var _loc_40:Number = NaN;
            var _loc_41:Number = NaN;
            var _loc_3:Object = {};
            switch(geometry.type)
            {
                case Geometry.MULTIPOINT:
                {
                    _loc_4 = GeomUtils.intersects(map, geometry, geometry.extent);
                    if (_loc_4)
                    {
                    }
                    if (_loc_4.length > 0)
                    {
                        _loc_5 = new Multipoint();
                        _loc_6 = new Multipoint();
                        for each (_loc_7 in Multipoint(geometry).points)
                        {
                            
                            _loc_8 = map.toScreenX(_loc_7.x);
                            _loc_9 = map.toScreenY(_loc_7.y);
                            for each (_loc_10 in _loc_4)
                            {
                                
                                _loc_5.addPoint(map.toMap(new Point(_loc_8 + _loc_10, _loc_9)));
                                _loc_6.addPoint(_loc_7);
                            }
                        }
                        _loc_3.newGeometry = _loc_5;
                        _loc_3.originalGeometry = _loc_6;
                    }
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_11 = GeomUtils.intersects(map, geometry, geometry.extent);
                    if (_loc_11)
                    {
                    }
                    if (_loc_11.length > 0)
                    {
                        _loc_12 = new Polyline();
                        _loc_13 = new Polyline();
                        for each (_loc_14 in Polyline(geometry).paths)
                        {
                            
                            for each (_loc_15 in _loc_11)
                            {
                                
                                _loc_16 = [];
                                _loc_17 = [];
                                for each (_loc_18 in _loc_14)
                                {
                                    
                                    _loc_19 = map.toScreenX(_loc_18.x);
                                    _loc_20 = map.toScreenY(_loc_18.y);
                                    _loc_16.push(map.toMap(new Point(_loc_19 + _loc_15, _loc_20)));
                                    _loc_17.push(_loc_18);
                                }
                                _loc_12.addPath(_loc_16);
                                _loc_13.addPath(_loc_17);
                            }
                        }
                        _loc_3.newGeometry = _loc_12;
                        _loc_3.originalGeometry = _loc_13;
                    }
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_21 = GeomUtils.intersects(map, geometry, geometry.extent);
                    if (_loc_21)
                    {
                    }
                    if (_loc_21.length > 0)
                    {
                        _loc_22 = new Polygon();
                        _loc_23 = new Polygon();
                        for each (_loc_24 in Polygon(geometry).rings)
                        {
                            
                            for each (_loc_25 in _loc_21)
                            {
                                
                                _loc_26 = [];
                                _loc_27 = [];
                                for each (_loc_28 in _loc_24)
                                {
                                    
                                    _loc_29 = map.toScreenX(_loc_28.x);
                                    _loc_30 = map.toScreenY(_loc_28.y);
                                    _loc_26.push(map.toMap(new Point(_loc_29 + _loc_25, _loc_30)));
                                    _loc_27.push(_loc_28);
                                }
                                _loc_22.addRing(_loc_26);
                                _loc_23.addRing(_loc_27);
                            }
                        }
                        _loc_3.newGeometry = _loc_22;
                        _loc_3.originalGeometry = _loc_23;
                    }
                    break;
                }
                case Geometry.EXTENT:
                {
                    _loc_31 = Extent(geometry).toPolygon();
                    _loc_32 = GeomUtils.intersects(map, _loc_31, _loc_31.extent);
                    if (_loc_32)
                    {
                    }
                    if (_loc_32.length > 0)
                    {
                        _loc_33 = new Polygon();
                        _loc_34 = new Polygon();
                        for each (_loc_35 in _loc_31.rings)
                        {
                            
                            for each (_loc_36 in _loc_32)
                            {
                                
                                _loc_37 = [];
                                _loc_38 = [];
                                for each (_loc_39 in _loc_35)
                                {
                                    
                                    _loc_40 = map.toScreenX(_loc_39.x);
                                    _loc_41 = map.toScreenY(_loc_39.y);
                                    _loc_37.push(map.toMap(new Point(_loc_40 + _loc_36, _loc_41)));
                                    _loc_38.push(_loc_39);
                                }
                                _loc_33.addRing(_loc_37);
                                _loc_34.addRing(_loc_38);
                            }
                        }
                        _loc_3.newGeometry = _loc_33;
                        _loc_3.originalGeometry = _loc_34;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_3;
        }// end function

        private function getChildFromSprite(sprite:Sprite) : void
        {
            var _loc_2:DisplayObject = null;
            this.m_hasChildren = true;
            if (sprite is CompositeSymbolComponent)
            {
            }
            if (CompositeSymbolComponent(sprite).source === this.m_source)
            {
                if (sprite is Graphic)
                {
                }
            }
            if (Graphic(sprite).source !== this.m_source)
            {
                removeAllChildren(sprite);
            }
            else
            {
                _loc_2 = sprite.getChildAt(0);
                if (_loc_2 is DisplayObjectContainer)
                {
                }
                if (_loc_2.name == "rotationSprite")
                {
                    this.m_rotationSprite = _loc_2 as UIComponent;
                    this.m_dispObj = DisplayObjectContainer(_loc_2).getChildAt(0);
                }
                else if (m_angle)
                {
                    this.m_dispObj = sprite.removeChildAt(0);
                    this.m_rotationSprite = new UIComponent();
                    this.m_rotationSprite.name = "rotationSprite";
                    this.m_rotationSprite.addChild(this.m_dispObj);
                    sprite.addChild(this.m_rotationSprite);
                }
                else
                {
                    this.m_dispObj = _loc_2;
                }
            }
            return;
        }// end function

        private function drawSourcePoint(map:Map, sprite:Sprite, point:MapPoint) : void
        {
            sprite.x = toScreenX(map, point.x);
            sprite.y = toScreenY(map, point.y);
            if (this.m_dispObj is CustomSWFLoader)
            {
                if (!m_angle)
                {
                    if (!this.m_hasChildren)
                    {
                        sprite.addChild(this.m_dispObj);
                    }
                    else if (DisplayObject(sprite.getChildAt(0)).name != "displayObject")
                    {
                        sprite.removeChildAt(0);
                        sprite.addChild(this.m_dispObj);
                    }
                }
                else
                {
                    if (!this.m_hasChildren)
                    {
                        this.m_rotationSprite = new UIComponent();
                        this.m_rotationSprite.name = "rotationSprite";
                        this.m_rotationSprite.addChild(this.m_dispObj);
                        sprite.addChild(this.m_rotationSprite);
                    }
                    if (this.m_myWidth)
                    {
                        this.m_rotationSprite.x = this.m_myWidth / 2;
                        this.m_dispObj.x = (-this.m_myWidth) / 2;
                    }
                    else
                    {
                        this.m_dispObj.width = CustomSWFLoader(this.m_dispObj).contentWidth;
                        this.m_rotationSprite.x = this.m_dispObj.width / 2;
                        this.m_dispObj.x = (-this.m_dispObj.width) / 2;
                    }
                    if (this.m_myHeight)
                    {
                        this.m_rotationSprite.y = this.m_myHeight / 2;
                        this.m_dispObj.y = (-this.m_myHeight) / 2;
                    }
                    else
                    {
                        this.m_dispObj.height = CustomSWFLoader(this.m_dispObj).contentHeight;
                        this.m_rotationSprite.y = this.m_dispObj.height / 2;
                        this.m_dispObj.y = (-this.m_dispObj.height) / 2;
                    }
                    this.m_rotationSprite.rotation = m_angle;
                }
                if (this.m_myWidth)
                {
                    this.m_dispObj.width = this.m_myWidth;
                    sprite.x = sprite.x - this.m_myWidth / 2;
                    this.m_dispObj.x = 0;
                    sprite.width = this.m_myWidth;
                }
                else
                {
                    this.m_dispObj.width = CustomSWFLoader(this.m_dispObj).contentWidth;
                    sprite.x = sprite.x - this.m_dispObj.width / 2;
                    this.m_dispObj.x = 0;
                    sprite.width = this.m_dispObj.width;
                }
                if (this.m_myHeight)
                {
                    this.m_dispObj.height = this.m_myHeight;
                    sprite.y = sprite.y - this.m_myHeight / 2;
                    this.m_dispObj.y = 0;
                    sprite.height = this.m_myHeight;
                }
                else
                {
                    this.m_dispObj.height = CustomSWFLoader(this.m_dispObj).contentHeight;
                    sprite.y = sprite.y - this.m_dispObj.height / 2;
                    this.m_dispObj.y = 0;
                    sprite.height = this.m_dispObj.height;
                }
                if (xoffset)
                {
                    sprite.x = sprite.x + xoffset;
                }
                if (yoffset)
                {
                    sprite.y = sprite.y - yoffset;
                }
            }
            else
            {
                if (this.m_myWidth)
                {
                    this.m_dispObj.width = this.m_myWidth;
                    sprite.x = sprite.x - this.m_myWidth / 2;
                    this.m_dispObj.x = 0;
                    sprite.width = this.m_myWidth;
                }
                else
                {
                    sprite.x = sprite.x - this.m_dispObj.width / 2;
                    this.m_dispObj.x = 0;
                    sprite.width = this.m_dispObj.width;
                }
                if (this.m_myHeight)
                {
                    this.m_dispObj.height = this.m_myHeight;
                    sprite.y = sprite.y - this.m_myHeight / 2;
                    this.m_dispObj.y = 0;
                    sprite.height = this.m_myHeight;
                }
                else
                {
                    sprite.y = sprite.y - this.m_dispObj.height / 2;
                    this.m_dispObj.y = 0;
                    sprite.height = this.m_dispObj.height;
                }
                if (xoffset)
                {
                    sprite.x = sprite.x + xoffset;
                }
                if (yoffset)
                {
                    sprite.y = sprite.y - yoffset;
                }
                if (!m_angle)
                {
                    if (!this.m_hasChildren)
                    {
                        sprite.addChild(this.m_dispObj);
                    }
                    else if (DisplayObject(sprite.getChildAt(0)).name != "displayObject")
                    {
                        sprite.removeChildAt(0);
                        sprite.addChild(this.m_dispObj);
                    }
                }
                else
                {
                    if (!this.m_hasChildren)
                    {
                        this.m_rotationSprite = new UIComponent();
                        this.m_rotationSprite.name = "rotationSprite";
                        this.m_rotationSprite.addChild(this.m_dispObj);
                        sprite.addChild(this.m_rotationSprite);
                    }
                    if (this.m_myWidth)
                    {
                        this.m_rotationSprite.x = this.m_myWidth / 2;
                        this.m_dispObj.x = (-this.m_myWidth) / 2;
                    }
                    else
                    {
                        this.m_rotationSprite.x = this.m_dispObj.width / 2;
                        this.m_dispObj.x = (-this.m_dispObj.width) / 2;
                    }
                    if (this.m_myHeight)
                    {
                        this.m_rotationSprite.y = this.m_myHeight / 2;
                        this.m_dispObj.y = (-this.m_myHeight) / 2;
                    }
                    else
                    {
                        this.m_rotationSprite.y = this.m_dispObj.height / 2;
                        this.m_dispObj.y = (-this.m_dispObj.height) / 2;
                    }
                    this.m_rotationSprite.rotation = m_angle;
                }
            }
            return;
        }// end function

        private function drawLoadedPoint(map:Map, sprite:Sprite, point:MapPoint) : void
        {
            var mapPoint:MapPoint;
            var dObject:DisplayObject;
            var map:* = map;
            var sprite:* = sprite;
            var point:* = point;
            sprite.x = toScreenX(map, point.x);
            sprite.y = toScreenY(map, point.y);
            if (sprite.numChildren == 0)
            {
                var handleCacheResult:* = function (resultSprite:CustomSprite, mapPoint:MapPoint) : void
            {
                delete m_spriteToPoint[sprite];
                if (m_editModeOn)
                {
                    resultSprite.mouseChildren = false;
                }
                m_dispObj = resultSprite as DisplayObject;
                if (!m_angle)
                {
                    sprite.addChild(m_dispObj);
                    symbolPlacement(map, m_dispObj, 0, 0, sprite, null);
                }
                else
                {
                    m_rotationSprite = new UIComponent();
                    m_rotationSprite.name = "rotationSprite";
                    m_rotationSprite.addChild(m_dispObj);
                    sprite.addChild(m_rotationSprite);
                    symbolPlacement(map, m_dispObj, 0, 0, sprite, m_rotationSprite, null);
                    m_rotationSprite.rotation = m_angle;
                }
                sprite.dispatchEvent(new PictureMarkerSymbolEvent(PictureMarkerSymbolEvent.COMPLETE));
                return;
            }// end function
            ;
                if (sprite is CompositeSymbolComponent)
                {
                    CompositeSymbolComponent(sprite).source = this.m_source;
                }
                else
                {
                    Graphic(sprite).source = this.m_source;
                }
                mapPoint = this.m_spriteToPoint[sprite];
                if (mapPoint == null)
                {
                    PictureMarkerSymbolCache.instance.getDisplayObject(this.m_source, point, point, handleCacheResult);
                    this.m_spriteToPoint[sprite] = point;
                }
            }
            else
            {
                if (sprite is CompositeSymbolComponent)
                {
                }
                if (CompositeSymbolComponent(sprite).source === this.m_source)
                {
                    if (sprite is Graphic)
                    {
                    }
                }
                if (Graphic(sprite).source !== this.m_source)
                {
                    removeAllChildren(sprite);
                    this.drawLoadedPoint(map, sprite, point);
                }
                else
                {
                    dObject = sprite.getChildAt(0);
                    if (dObject is DisplayObjectContainer)
                    {
                    }
                    if (dObject.name == "rotationSprite")
                    {
                        this.m_rotationSprite = dObject as UIComponent;
                        this.m_dispObj = DisplayObjectContainer(dObject).getChildAt(0);
                        this.symbolPlacement(map, this.m_dispObj, 0, 0, sprite, this.m_rotationSprite, null);
                        this.m_rotationSprite.rotation = m_angle;
                    }
                    else if (m_angle)
                    {
                        this.m_dispObj = sprite.removeChildAt(0);
                        this.m_rotationSprite = new UIComponent();
                        this.m_rotationSprite.name = "rotationSprite";
                        this.m_rotationSprite.addChild(this.m_dispObj);
                        sprite.addChild(this.m_rotationSprite);
                        this.symbolPlacement(map, this.m_dispObj, 0, 0, sprite, this.m_rotationSprite, null);
                        this.m_rotationSprite.rotation = m_angle;
                    }
                    else
                    {
                        this.m_dispObj = dObject;
                        this.symbolPlacement(map, this.m_dispObj, 0, 0, sprite, null, null);
                    }
                }
            }
            return;
        }// end function

        private function drawSourceMultipoint(map:Map, sprite:Sprite, geometry:Geometry, originalGeometry:Geometry) : void
        {
            var sourceMultipointExtent:Extent;
            var arrOfSourcePoints:Array;
            var arrOfOriginalSourcePoints:Array;
            var multipoint:Multipoint;
            var polyline:Polyline;
            var polygon:Polygon;
            var extent:Extent;
            var map:* = map;
            var sprite:* = sprite;
            var geometry:* = geometry;
            var originalGeometry:* = originalGeometry;
            var traceMultipointGeometry:* = function () : void
            {
                if (sprite.numChildren == 0)
                {
                    sourceMultipoint(map, sprite, arrOfSourcePoints, arrOfOriginalSourcePoints, sourceMultipointExtent);
                }
                else
                {
                    getChildrenFromSprite(map, sprite, sourceMultipointExtent, arrOfSourcePoints, arrOfOriginalSourcePoints, true);
                }
                return;
            }// end function
            ;
            arrOfSourcePoints;
            arrOfOriginalSourcePoints;
            if (geometry is Multipoint)
            {
                multipoint = Multipoint(geometry) as Multipoint;
                sourceMultipointExtent = multipoint.points.length == 1 ? (new Extent(multipoint.points[0].x, multipoint.points[0].y, multipoint.points[0].x, multipoint.points[0].y)) : (multipoint.extent);
                arrOfSourcePoints = multipoint.points.slice();
                arrOfOriginalSourcePoints = Multipoint(originalGeometry).points.slice();
                this.traceMultipointGeometry();
            }
            else
            {
                if (sprite is CompositeSymbolComponent)
                {
                }
                if (geometry is Polyline)
                {
                    var getPolylinePoints:* = function (geomPolyline:Polyline) : Array
            {
                var _loc_4:Array = null;
                var _loc_5:Number = NaN;
                var _loc_2:Array = [];
                var _loc_3:Array = [];
                for each (_loc_4 in geomPolyline.paths.slice())
                {
                    
                    if (_loc_4.length > 1)
                    {
                        if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                        {
                        }
                        _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                    }
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3.length)
                    {
                        
                        _loc_2.push(_loc_3[_loc_5] as MapPoint);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                return _loc_2;
            }// end function
            ;
                    polyline = Polyline(geometry) as Polyline;
                    sourceMultipointExtent = polyline.extent;
                    arrOfSourcePoints = this.getPolylinePoints(polyline);
                    arrOfOriginalSourcePoints = this.getPolylinePoints(Polyline(originalGeometry));
                    this.traceMultipointGeometry();
                }
                else
                {
                    if (sprite is CompositeSymbolComponent)
                    {
                    }
                    if (geometry is Polygon)
                    {
                        var getPolygonPoints:* = function (geomPolygon:Polygon) : Array
            {
                var _loc_4:Array = null;
                var _loc_5:Number = NaN;
                var _loc_2:Array = [];
                var _loc_3:Array = [];
                for each (_loc_4 in geomPolygon.rings.slice())
                {
                    
                    if (_loc_4.length > 1)
                    {
                        if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                        {
                        }
                        _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                    }
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3.length)
                    {
                        
                        _loc_2.push(_loc_3[_loc_5] as MapPoint);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                return _loc_2;
            }// end function
            ;
                        polygon = Polygon(geometry) as Polygon;
                        sourceMultipointExtent = polygon.extent;
                        arrOfSourcePoints = this.getPolygonPoints(polygon);
                        arrOfOriginalSourcePoints = this.getPolygonPoints(Polygon(originalGeometry));
                        this.traceMultipointGeometry();
                    }
                    else
                    {
                        if (sprite is CompositeSymbolComponent)
                        {
                        }
                        if (geometry is Extent)
                        {
                            var getExtentPoints:* = function (geomExtent:Extent) : Array
            {
                var _loc_2:Array = [];
                _loc_2.push(new MapPoint(geomExtent.xmin, geomExtent.ymax), new MapPoint(geomExtent.xmin, geomExtent.ymin), new MapPoint(geomExtent.xmax, geomExtent.ymin), new MapPoint(geomExtent.xmax, geomExtent.ymax));
                return _loc_2;
            }// end function
            ;
                            extent = Extent(geometry) as Extent;
                            sourceMultipointExtent = extent;
                            arrOfSourcePoints = this.getExtentPoints(extent);
                            arrOfOriginalSourcePoints = this.getExtentPoints(Extent(originalGeometry));
                            this.traceMultipointGeometry();
                        }
                    }
                }
            }
            return;
        }// end function

        private function sourceMultipoint(map:Map, sprite:Sprite, arr:Array, arrOriginal:Array, sourceMultipointExtent:Extent) : void
        {
            var point:MapPoint;
            var sx:Number;
            var sy:Number;
            var map:* = map;
            var sprite:* = sprite;
            var arr:* = arr;
            var arrOriginal:* = arrOriginal;
            var sourceMultipointExtent:* = sourceMultipointExtent;
            var addToCustomSprite:* = function (srcObject:DisplayObject, mapPoint:MapPoint) : void
            {
                m_dispObj = new CustomSprite(mapPoint);
                m_dispObj.name = "displayObject";
                CustomSprite(m_dispObj).addChild(srcObject);
                if (m_editModeOn)
                {
                    CustomSprite(m_dispObj).mouseChildren = false;
                }
                return;
            }// end function
            ;
            if (sprite is CompositeSymbolComponent)
            {
                CompositeSymbolComponent(sprite).source = this.m_source;
            }
            else
            {
                Graphic(sprite).source = this.m_source;
            }
            var useSWFLoader:Boolean;
            if (this.m_source is Class)
            {
            }
            if (!(new this.m_source() is BitmapAsset))
            {
                useSWFLoader;
            }
            var i:int;
            while (i < arr.length)
            {
                
                point = arr[i];
                if (this.m_source is Bitmap)
                {
                    this.addToCustomSprite(new Bitmap(Bitmap(this.m_source).bitmapData), arrOriginal[i]);
                }
                else if (useSWFLoader)
                {
                    this.m_dispObj = new CustomSWFLoader();
                    this.m_dispObj.name = "displayObject";
                    CustomSWFLoader(this.m_dispObj).source = this.m_source;
                    CustomSWFLoader(this.m_dispObj).maintainAspectRatio = false;
                    CustomSWFLoader(this.m_dispObj).mapPoint = arrOriginal[i];
                    if (this.m_editModeOn)
                    {
                        CustomSWFLoader(this.m_dispObj).mouseChildren = false;
                    }
                }
                else
                {
                    this.addToCustomSprite(new this.m_source() as DisplayObject, arrOriginal[i]);
                }
                sx = toScreenX(map, point.x);
                sy = toScreenY(map, point.y);
                if (!m_angle)
                {
                    sprite.addChild(this.m_dispObj);
                    this.symbolPlacement(map, this.m_dispObj, sx, sy, sprite, null, sourceMultipointExtent);
                }
                else
                {
                    this.m_rotationSprite = new UIComponent();
                    this.m_rotationSprite.addChild(this.m_dispObj);
                    this.m_rotationSprite.name = "rotationSprite";
                    sprite.addChild(this.m_rotationSprite);
                    this.symbolPlacement(map, this.m_dispObj, sx, sy, sprite, this.m_rotationSprite, sourceMultipointExtent);
                    this.m_rotationSprite.rotation = m_angle;
                }
                i = (i + 1);
            }
            return;
        }// end function

        private function drawLoadedMultipoint(map:Map, sprite:Sprite, geometry:Geometry, originalGeometry:Geometry) : void
        {
            var loadedMultipointExtent:Extent;
            var arrOfPoints:Array;
            var arrOfOriginalPoints:Array;
            var multipoint:Multipoint;
            var polyline:Polyline;
            var polygon:Polygon;
            var extent:Extent;
            var map:* = map;
            var sprite:* = sprite;
            var geometry:* = geometry;
            var originalGeometry:* = originalGeometry;
            var traceLoadedMultipoint:* = function () : void
            {
                if (sprite.numChildren == 0)
                {
                    loadedMultipoint(map, sprite, arrOfPoints, arrOfOriginalPoints, loadedMultipointExtent);
                }
                else
                {
                    getChildrenFromSprite(map, sprite, loadedMultipointExtent, arrOfPoints, arrOfOriginalPoints, false);
                }
                return;
            }// end function
            ;
            sprite.x = 0;
            sprite.y = 0;
            arrOfPoints;
            arrOfOriginalPoints;
            if (geometry is Multipoint)
            {
                multipoint = Multipoint(geometry) as Multipoint;
                loadedMultipointExtent = multipoint.points.length == 1 ? (new Extent(multipoint.points[0].x, multipoint.points[0].y, multipoint.points[0].x, multipoint.points[0].y)) : (multipoint.extent);
                arrOfPoints = multipoint.points.slice();
                arrOfOriginalPoints = Multipoint(originalGeometry).points.slice();
                this.traceLoadedMultipoint();
            }
            else
            {
                if (sprite is CompositeSymbolComponent)
                {
                }
                if (geometry is Polyline)
                {
                    var getPolylinePoints:* = function (geomPolyline:Polyline) : Array
            {
                var _loc_4:Array = null;
                var _loc_5:Number = NaN;
                var _loc_2:Array = [];
                var _loc_3:Array = [];
                for each (_loc_4 in geomPolyline.paths.slice())
                {
                    
                    if (_loc_4.length > 1)
                    {
                        if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                        {
                        }
                        _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                    }
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3.length)
                    {
                        
                        _loc_2.push(_loc_3[_loc_5] as MapPoint);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                return _loc_2;
            }// end function
            ;
                    polyline = Polyline(geometry) as Polyline;
                    loadedMultipointExtent = polyline.extent;
                    arrOfPoints = this.getPolylinePoints(polyline);
                    arrOfOriginalPoints = this.getPolylinePoints(Polyline(originalGeometry));
                    this.traceLoadedMultipoint();
                }
                else
                {
                    if (sprite is CompositeSymbolComponent)
                    {
                    }
                    if (geometry is Polygon)
                    {
                        var getPolygonPoints:* = function (geomPolygon:Polygon) : Array
            {
                var _loc_4:Array = null;
                var _loc_5:Number = NaN;
                var _loc_2:Array = [];
                var _loc_3:Array = [];
                for each (_loc_4 in geomPolygon.rings.slice())
                {
                    
                    if (_loc_4.length > 1)
                    {
                        if (_loc_4[(_loc_4.length - 1)].x == _loc_4[0].x)
                        {
                        }
                        _loc_3 = _loc_4[(_loc_4.length - 1)].y == _loc_4[0].y ? (_loc_4.slice(1, _loc_4.length)) : (_loc_4);
                    }
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3.length)
                    {
                        
                        _loc_2.push(_loc_3[_loc_5] as MapPoint);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                return _loc_2;
            }// end function
            ;
                        polygon = Polygon(geometry) as Polygon;
                        loadedMultipointExtent = polygon.extent;
                        arrOfPoints = this.getPolygonPoints(polygon);
                        arrOfOriginalPoints = this.getPolygonPoints(Polygon(originalGeometry));
                        this.traceLoadedMultipoint();
                    }
                    else
                    {
                        if (sprite is CompositeSymbolComponent)
                        {
                        }
                        if (geometry is Extent)
                        {
                            var getExtentPoints:* = function (geomExtent:Extent) : Array
            {
                var _loc_2:Array = [];
                _loc_2.push(new MapPoint(geomExtent.xmin, geomExtent.ymax), new MapPoint(geomExtent.xmin, geomExtent.ymin), new MapPoint(geomExtent.xmax, geomExtent.ymin), new MapPoint(geomExtent.xmax, geomExtent.ymax));
                return _loc_2;
            }// end function
            ;
                            extent = Extent(geometry) as Extent;
                            loadedMultipointExtent = extent;
                            arrOfPoints = this.getExtentPoints(extent);
                            arrOfOriginalPoints = this.getExtentPoints(Extent(originalGeometry));
                            this.traceLoadedMultipoint();
                        }
                    }
                }
            }
            return;
        }// end function

        private function getChildrenFromSprite(map:Map, sprite:Sprite, multipointExtent:Extent, arrOfPoints:Array, arrOfOriginalPoints:Array, isSource:Boolean) : void
        {
            var _loc_9:DisplayObject = null;
            var _loc_10:DisplayObject = null;
            var _loc_11:Number = NaN;
            var _loc_12:Array = null;
            var _loc_13:Array = null;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Array = null;
            var _loc_17:Array = null;
            var _loc_18:Number = NaN;
            var _loc_7:Array = [];
            var _loc_8:Array = [];
            while (sprite.numChildren > 0)
            {
                
                _loc_9 = sprite.removeChildAt(0);
                if (_loc_9 is DisplayObjectContainer)
                {
                }
                if (_loc_9.name == "rotationSprite")
                {
                    _loc_10 = DisplayObjectContainer(_loc_9).getChildAt(0);
                    _loc_7.push(_loc_10);
                    _loc_8.push(_loc_9);
                    continue;
                }
                if (m_angle)
                {
                    _loc_7.push(_loc_9);
                    this.m_rotationSprite = new UIComponent();
                    this.m_rotationSprite.name = "rotationSprite";
                    this.m_rotationSprite.addChild(_loc_9);
                    _loc_8.push(this.m_rotationSprite);
                    continue;
                }
                _loc_7.push(_loc_9);
            }
            if (_loc_7.length != arrOfPoints.length)
            {
                if (_loc_8.length != 0)
                {
                }
            }
            if (_loc_8.length == arrOfPoints.length)
            {
                this.storedMultipoint(map, sprite, arrOfPoints, arrOfOriginalPoints, _loc_7, _loc_8, multipointExtent, isSource);
            }
            else if (_loc_7.length > arrOfPoints.length)
            {
                while (_loc_7.length > arrOfPoints.length)
                {
                    
                    _loc_7.pop();
                }
                if (_loc_8.length != 0)
                {
                    while (_loc_8.length > arrOfPoints.length)
                    {
                        
                        _loc_8.pop();
                    }
                }
                this.storedMultipoint(map, sprite, arrOfPoints, arrOfOriginalPoints, _loc_7, _loc_8, multipointExtent, isSource);
            }
            else
            {
                if (_loc_7.length >= arrOfPoints.length)
                {
                    if (_loc_8.length != 0)
                    {
                    }
                }
                if (_loc_8.length < arrOfPoints.length)
                {
                    if (isSource)
                    {
                        this.sourceMultipoint(map, sprite, arrOfPoints, arrOfOriginalPoints, multipointExtent);
                    }
                    else
                    {
                        _loc_11 = _loc_7.length;
                        _loc_12 = [];
                        _loc_13 = [];
                        _loc_14 = 0;
                        while (_loc_14 < _loc_11)
                        {
                            
                            _loc_12.push(arrOfPoints[_loc_14]);
                            _loc_13.push(arrOfOriginalPoints[_loc_14]);
                            _loc_14 = _loc_14 + 1;
                        }
                        this.storedMultipoint(map, sprite, _loc_12, _loc_13, _loc_7, _loc_8, multipointExtent, isSource);
                        _loc_15 = arrOfPoints.length - _loc_7.length;
                        _loc_16 = [];
                        _loc_17 = [];
                        if (_loc_15 == 1)
                        {
                            _loc_16.push(arrOfPoints[(arrOfPoints.length - 1)]);
                            _loc_17.push(arrOfOriginalPoints[(arrOfOriginalPoints.length - 1)]);
                        }
                        else
                        {
                            _loc_18 = _loc_11;
                            while (_loc_18 < arrOfPoints.length)
                            {
                                
                                _loc_16.push(arrOfPoints[_loc_18]);
                                _loc_17.push(arrOfOriginalPoints[_loc_18]);
                                _loc_18 = _loc_18 + 1;
                            }
                        }
                        this.loadedMultipoint(map, sprite, _loc_16, _loc_17, multipointExtent);
                    }
                }
            }
            return;
        }// end function

        private function storedMultipoint(map:Map, sprite:Sprite, arr:Array, arrOriginal:Array, arrDisplayObject:Array, arrRotationSprite:Array, multipointExtent:Extent, isSource:Boolean) : void
        {
            var _loc_9:int = 0;
            var _loc_10:MapPoint = null;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            if (sprite is CompositeSymbolComponent)
            {
            }
            if (CompositeSymbolComponent(sprite).source === this.m_source)
            {
                if (sprite is Graphic)
                {
                }
            }
            if (Graphic(sprite).source !== this.m_source)
            {
                removeAllChildren(sprite);
                if (isSource)
                {
                    this.sourceMultipoint(map, sprite, arr, arrOriginal, multipointExtent);
                }
                else
                {
                    this.loadedMultipoint(map, sprite, arr, arrOriginal, multipointExtent);
                }
            }
            else
            {
                _loc_9 = 0;
                while (_loc_9 < arr.length)
                {
                    
                    _loc_10 = arr[_loc_9];
                    _loc_11 = toScreenX(map, _loc_10.x);
                    _loc_12 = toScreenY(map, _loc_10.y);
                    arrDisplayObject[_loc_9].mapPoint = arrOriginal[_loc_9];
                    if (arrRotationSprite.length == 0)
                    {
                        sprite.addChild(arrDisplayObject[_loc_9]);
                        this.symbolPlacement(map, arrDisplayObject[_loc_9], _loc_11, _loc_12, sprite, null, multipointExtent);
                    }
                    else
                    {
                        sprite.addChild(arrRotationSprite[_loc_9]);
                        this.symbolPlacement(map, arrDisplayObject[_loc_9], _loc_11, _loc_12, sprite, arrRotationSprite[_loc_9] as Sprite, multipointExtent);
                        Sprite(arrRotationSprite[_loc_9]).rotation = m_angle;
                    }
                    _loc_9 = _loc_9 + 1;
                }
            }
            return;
        }// end function

        private function loadedMultipoint(map:Map, sprite:Sprite, arr:Array, arrOriginal:Array, loadedMultipointExtent:Extent) : void
        {
            var count:Number;
            var handleCacheResult:Function;
            var i:Number;
            var map:* = map;
            var sprite:* = sprite;
            var arr:* = arr;
            var arrOriginal:* = arrOriginal;
            var loadedMultipointExtent:* = loadedMultipointExtent;
            handleCacheResult = function (resultSprite:CustomSprite, mapPoint:MapPoint) : void
            {
                var _loc_6:* = count - 1;
                count = _loc_6;
                if (m_editModeOn)
                {
                    resultSprite.mouseChildren = false;
                }
                m_dispObj = resultSprite as DisplayObject;
                var _loc_3:* = toScreenX(map, mapPoint.x);
                var _loc_4:* = toScreenY(map, mapPoint.y);
                if (!m_angle)
                {
                    sprite.addChild(m_dispObj);
                    symbolPlacement(map, m_dispObj, _loc_3, _loc_4, sprite, null, loadedMultipointExtent);
                }
                else
                {
                    m_rotationSprite = new UIComponent();
                    m_rotationSprite.addChild(m_dispObj);
                    m_rotationSprite.name = "rotationSprite";
                    sprite.addChild(m_rotationSprite);
                    symbolPlacement(map, m_dispObj, _loc_3, _loc_4, sprite, m_rotationSprite, loadedMultipointExtent);
                    m_rotationSprite.rotation = m_angle;
                }
                if (count == 0)
                {
                    delete m_spriteToMultipointArray[sprite];
                    sprite.dispatchEvent(new PictureMarkerSymbolEvent(PictureMarkerSymbolEvent.COMPLETE));
                }
                return;
            }// end function
            ;
            if (sprite is CompositeSymbolComponent)
            {
                CompositeSymbolComponent(sprite).source = this.m_source;
            }
            else
            {
                Graphic(sprite).source = this.m_source;
            }
            count = arr.length;
            var array:* = this.m_spriteToMultipointArray[sprite];
            if (array == null)
            {
                this.m_spriteToMultipointArray[sprite] = arr;
                i;
                while (i < arr.length)
                {
                    
                    PictureMarkerSymbolCache.instance.getDisplayObject(this.m_source, MapPoint(arr[i]), MapPoint(arrOriginal[i]), handleCacheResult);
                    i = (i + 1);
                }
            }
            return;
        }// end function

        private function symbolPlacement(map:Map, dispObj:DisplayObject, sx:Number, sy:Number, sprite:Sprite, rotationSprite:Sprite = null, multipointExtent:Extent = null) : void
        {
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            if (multipointExtent)
            {
                _loc_8 = toScreenX(map, multipointExtent.xmin);
                _loc_9 = toScreenY(map, multipointExtent.ymin);
                _loc_10 = toScreenX(map, multipointExtent.xmax);
                _loc_11 = toScreenY(map, multipointExtent.ymax);
                if (this.m_myWidth)
                {
                    dispObj.width = this.m_myWidth;
                }
                else if (dispObj is CustomSWFLoader)
                {
                    dispObj.width = CustomSWFLoader(dispObj).contentWidth;
                }
                if (this.m_myHeight)
                {
                    dispObj.height = this.m_myHeight;
                }
                else if (dispObj is CustomSWFLoader)
                {
                    dispObj.height = CustomSWFLoader(dispObj).contentHeight;
                }
                sprite.x = _loc_8 - dispObj.width / 2;
                sprite.y = _loc_11 - dispObj.height / 2;
                sprite.width = _loc_10 + dispObj.width - _loc_8;
                sprite.height = _loc_9 + dispObj.height - _loc_11;
                if (!rotationSprite)
                {
                    dispObj.x = sx - (dispObj.width / 2 + sprite.x);
                    dispObj.y = sy - (dispObj.height / 2 + sprite.y);
                }
                else
                {
                    rotationSprite.x = sx - sprite.x;
                    rotationSprite.y = sy - sprite.y;
                    dispObj.x = (-dispObj.width) / 2;
                    dispObj.y = (-dispObj.height) / 2;
                }
                if (xoffset)
                {
                    sprite.x = sprite.x + xoffset;
                }
                if (yoffset)
                {
                    sprite.y = sprite.y - yoffset;
                }
            }
            else
            {
                if (this.m_myWidth)
                {
                    dispObj.width = this.m_myWidth;
                }
                else if (dispObj is CustomSWFLoader)
                {
                    dispObj.width = CustomSWFLoader(dispObj).contentWidth;
                }
                if (this.m_myHeight)
                {
                    dispObj.height = this.m_myHeight;
                }
                else if (dispObj is CustomSWFLoader)
                {
                    dispObj.height = CustomSWFLoader(dispObj).contentHeight;
                }
                sprite.x = sprite.x - dispObj.width / 2;
                sprite.y = sprite.y - dispObj.height / 2;
                dispObj.x = 0;
                dispObj.y = 0;
                sprite.width = dispObj.width;
                sprite.height = dispObj.height;
                if (rotationSprite)
                {
                    rotationSprite.x = dispObj.width / 2;
                    rotationSprite.y = dispObj.height / 2;
                    dispObj.x = (-dispObj.width) / 2;
                    dispObj.y = (-dispObj.height) / 2;
                }
                if (xoffset)
                {
                    sprite.x = sprite.x + xoffset;
                }
                if (yoffset)
                {
                    sprite.y = sprite.y - yoffset;
                }
            }
            return;
        }// end function

        public function set height(value:Number) : void
        {
            arguments = this.height;
            if (arguments !== value)
            {
                this._1221029593height = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "height", arguments, value));
                }
            }
            return;
        }// end function

        public function set source(value:Object) : void
        {
            arguments = this.source;
            if (arguments !== value)
            {
                this._896505829source = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "source", arguments, value));
                }
            }
            return;
        }// end function

        public function set width(value:Number) : void
        {
            arguments = this.width;
            if (arguments !== value)
            {
                this._113126854width = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "width", arguments, value));
                }
            }
            return;
        }// end function

        public static function fromJSON(obj:Object) : PictureMarkerSymbol
        {
            return SymbolFactory.toPMS(obj);
        }// end function

    }
}
