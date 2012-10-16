package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import mx.graphics.codec.*;
    import mx.utils.*;

    public class PictureFillSymbol extends FillSymbol implements IJSONSupport
    {
        private var m_source:Object;
        private var m_embed:Class;
        private var m_width:Number;
        private var m_height:Number;
        private var m_xscale:Number;
        private var m_yscale:Number;
        private var m_xoffset:Number;
        private var m_yoffset:Number;
        private var m_matrix:Matrix;
        private var m_stroke:SolidColorStroke;
        private var m_pattern:Array;
        private var m_angle:Number;
        private var m_bitmaps:Object;
        private var m_arrClippedBySidePoints:Array;
        private var m_imageData:String;
        private var m_imageDataContentType:String;
        private var m_imageDataWidth:Number;
        private var m_imageDataHeight:Number;
        private static var m_defaultSymbol:PictureFillSymbol;

        public function PictureFillSymbol(source:Object = null, width:Number = 0, height:Number = 0, xscale:Number = 1, yscale:Number = 1, xoffset:Number = 0, yoffset:Number = 0, angle:Number = 0, outline:SimpleLineSymbol = null)
        {
            this.m_embed = PictureFillSymbol_m_embed;
            this.m_matrix = new Matrix();
            this.m_stroke = new SolidColorStroke();
            this.m_bitmaps = {};
            this.m_source = this.m_embed;
            this.source = source;
            this.width = width;
            this.height = height;
            this.xscale = xscale;
            this.yscale = yscale;
            this.xoffset = xoffset;
            this.yoffset = yoffset;
            this.angle = angle;
            this.outline = outline;
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
                dispatchEventChange();
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
                this.m_width = value;
                dispatchEventChange();
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
                this.m_height = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get xscale() : Number
        {
            return this.m_xscale;
        }// end function

        private function set _750218286xscale(value:Number) : void
        {
            if (value != this.m_xscale)
            {
                this.m_xscale = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get yscale() : Number
        {
            return this.m_yscale;
        }// end function

        private function set _721589135yscale(value:Number) : void
        {
            if (value != this.m_yscale)
            {
                this.m_yscale = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get xoffset() : Number
        {
            return this.m_xoffset;
        }// end function

        private function set _1893520629xoffset(value:Number) : void
        {
            if (value != this.m_xoffset)
            {
                this.m_xoffset = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get yoffset() : Number
        {
            return this.m_yoffset;
        }// end function

        private function set _1006016948yoffset(value:Number) : void
        {
            if (value != this.m_yoffset)
            {
                this.m_yoffset = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get angle() : Number
        {
            return this.m_angle;
        }// end function

        private function set _92960979angle(value:Number) : void
        {
            if (value != this.m_angle)
            {
                this.m_angle = value;
                dispatchEventChange();
            }
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var sprite:* = sprite;
            var geometry:* = geometry;
            var attributes:* = attributes;
            var map:* = map;
            var mapExtent:* = map.extentExpanded;
            if (!(geometry is Polygon))
            {
            }
            if (geometry is Extent)
            {
                var getNewPolygon:* = function (geometry:Geometry) : Polygon
            {
                var _loc_2:Polygon = null;
                var _loc_5:Polygon = null;
                var _loc_6:Array = null;
                var _loc_7:Number = NaN;
                var _loc_8:Array = null;
                var _loc_9:MapPoint = null;
                var _loc_10:Number = NaN;
                var _loc_11:Number = NaN;
                var _loc_3:* = geometry is Polygon ? (Polygon(geometry)) : (Extent(geometry).toPolygon());
                var _loc_4:* = GeomUtils.intersects(map, _loc_3, _loc_3.extent);
                if (_loc_4)
                {
                }
                if (_loc_4.length > 0)
                {
                    _loc_5 = new Polygon();
                    for each (_loc_6 in _loc_3.rings)
                    {
                        
                        for each (_loc_7 in _loc_4)
                        {
                            
                            _loc_8 = [];
                            for each (_loc_9 in _loc_6)
                            {
                                
                                _loc_10 = map.toScreenX(_loc_9.x);
                                _loc_11 = map.toScreenY(_loc_9.y);
                                _loc_8.push(map.toMap(new Point(_loc_10 + _loc_7, _loc_11)));
                            }
                            _loc_5.addRing(_loc_8);
                        }
                    }
                    _loc_2 = _loc_5;
                }
                return _loc_2;
            }// end function
            ;
                if (!(this.m_source is Class))
                {
                }
                if (this.m_source is Bitmap)
                {
                    if (!map.wrapAround180)
                    {
                        if (mapExtent.intersects(geometry))
                        {
                            this.drawFillSymbol(sprite, this.m_source, map, map.extent.expand(3), geometry);
                        }
                    }
                    else
                    {
                        this.drawFillSymbol(sprite, this.m_source, map, map.extent.expand(3), this.getNewPolygon(geometry));
                    }
                }
                else
                {
                    if (!(this.m_source is String))
                    {
                    }
                    if (this.m_source is ByteArray)
                    {
                        if (!map.wrapAround180)
                        {
                            if (mapExtent.intersects(geometry))
                            {
                                this.drawLoadedFillSymbol(sprite, this.m_source, map, map.extent.expand(3), geometry);
                            }
                        }
                        else
                        {
                            this.drawLoadedFillSymbol(sprite, this.m_source, map, map.extent.expand(3), this.getNewPolygon(geometry));
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
            sprite.graphics.clear();
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            if (!(this.m_source is Class))
            {
            }
            if (this.m_source is Bitmap)
            {
                this.drawFillSymbol(_loc_4, this.m_source, null, null, null, width, height, shape);
            }
            else
            {
                if (!(this.m_source is String))
                {
                }
                if (this.m_source is ByteArray)
                {
                    this.drawLoadedFillSymbol(_loc_4, this.m_source, null, null, null, width, height, shape);
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
            var _loc_2:Object = {type:"esriPFS"};
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
            if (isFinite(this.angle))
            {
                isFinite(this.angle);
            }
            if (this.angle != 0)
            {
                _loc_2.angle = -this.angle;
            }
            if (isFinite(this.xoffset))
            {
                isFinite(this.xoffset);
            }
            if (this.xoffset != 0)
            {
                _loc_2.xoffset = SymbolFactory.pxToPt(this.xoffset);
            }
            if (isFinite(this.yoffset))
            {
                isFinite(this.yoffset);
            }
            if (this.yoffset != 0)
            {
                _loc_2.yoffset = SymbolFactory.pxToPt(this.yoffset);
            }
            if (outline)
            {
                _loc_2.outline = outline.toJSON();
            }
            if (isFinite(this.xscale))
            {
                isFinite(this.xscale);
            }
            if (this.xscale != 1)
            {
                _loc_2.xscale = this.xscale;
            }
            if (isFinite(this.yscale))
            {
                isFinite(this.yscale);
            }
            if (this.yscale != 1)
            {
                _loc_2.yscale = this.yscale;
            }
            return _loc_2;
        }// end function

        private function drawLoadedFillSymbol(sprite:Sprite, source:Object, map:Map, mapExtent:Extent, geometry:Geometry, width:Number = 0, height:Number = 0, shape:String = null) : void
        {
            var handleCacheResult:Function;
            var sprite:* = sprite;
            var source:* = source;
            var map:* = map;
            var mapExtent:* = mapExtent;
            var geometry:* = geometry;
            var width:* = width;
            var height:* = height;
            var shape:* = shape;
            handleCacheResult = function (resultSprite:CustomSprite, mapPoint:MapPoint) : void
            {
                var _loc_3:Bitmap = null;
                if (resultSprite.getChildAt(0) is Bitmap)
                {
                    _loc_3 = resultSprite.getChildAt(0) as Bitmap;
                    if (map)
                    {
                    }
                    if (mapExtent)
                    {
                    }
                    if (geometry)
                    {
                        if (geometry is Polygon)
                        {
                            drawPolygon(map, mapExtent, sprite, geometry as Polygon, _loc_3);
                        }
                        else
                        {
                            drawExtent(map, mapExtent, sprite, geometry as Extent, _loc_3);
                        }
                    }
                    else
                    {
                        drawSwatch(sprite, _loc_3, width, height, shape);
                    }
                }
                return;
            }// end function
            ;
            PictureMarkerSymbolCache.instance.getDisplayObject(source, null, null, handleCacheResult);
            return;
        }// end function

        private function drawFillSymbol(sprite:Sprite, source:Object, map:Map, mapExtent:Extent, geometry:Geometry, width:Number = 0, height:Number = 0, shape:String = null) : void
        {
            var _loc_9:* = this.m_bitmaps[source] as Bitmap;
            if (_loc_9 == null)
            {
                _loc_9 = source is Bitmap ? (source as Bitmap) : (new source);
                this.m_bitmaps[source] = _loc_9;
            }
            if (map)
            {
            }
            if (mapExtent)
            {
            }
            if (geometry)
            {
                if (geometry is Polygon)
                {
                    this.drawPolygon(map, mapExtent, sprite, geometry as Polygon, _loc_9);
                }
                else
                {
                    this.drawExtent(map, mapExtent, sprite, geometry as Extent, _loc_9);
                }
            }
            else
            {
                this.drawSwatch(sprite, _loc_9, width, height, shape);
            }
            return;
        }// end function

        private function drawSwatch(sprite:Sprite, bmp:Bitmap, width:Number, height:Number, shape:String = null) : void
        {
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_20:Array = null;
            _loc_6 = Math.min(width, bmp.bitmapData.width * this.m_xscale);
            _loc_7 = Math.min(height, bmp.bitmapData.height * this.m_yscale);
            bmp.width = _loc_6;
            bmp.height = _loc_7;
            var _loc_10:Number = 0;
            if (this.m_width)
            {
                _loc_13 = this.m_width * this.m_xscale;
                _loc_6 = Math.min(_loc_13, width);
                bmp.width = _loc_6;
            }
            if (this.m_height)
            {
                _loc_14 = this.m_height * this.m_yscale;
                _loc_7 = Math.min(_loc_14, height);
                bmp.height = _loc_7;
            }
            _loc_8 = _loc_6 / bmp.bitmapData.width;
            _loc_9 = _loc_7 / bmp.bitmapData.width;
            if (this.xoffset)
            {
                _loc_11 = this.xoffset - bmp.width / 2;
            }
            else
            {
                _loc_11 = (-bmp.width) / 2;
            }
            if (this.yoffset)
            {
                _loc_12 = -(this.yoffset + bmp.height / 2);
            }
            else
            {
                _loc_12 = (-bmp.height) / 2;
            }
            if (this.angle)
            {
                _loc_10 = 2 * Math.PI * (this.angle / 360);
            }
            this.m_matrix.createBox(_loc_6 / bmp.bitmapData.width, _loc_7 / bmp.bitmapData.height, _loc_10, _loc_11, _loc_12);
            sprite.graphics.beginBitmapFill(bmp.bitmapData, this.m_matrix, true, true);
            if (shape)
            {
            }
            if (shape != FeatureTemplate.TOOL_POLYGON)
            {
            }
            if (shape != FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON)
            {
            }
            if (shape != FeatureTemplate.TOOL_RECTANGLE)
            {
                if (m_outline)
                {
                    _loc_15 = Math.min(m_outline.width, height);
                    _loc_16 = _loc_15 / 2;
                    this.m_stroke.weight = _loc_15 == 0 ? (-1) : (_loc_15);
                    this.m_stroke.color = m_outline.color;
                    this.m_stroke.alpha = m_outline.alpha;
                    if (m_outline.style != SimpleLineSymbol.STYLE_SOLID)
                    {
                    }
                    if (m_outline.style != SimpleLineSymbol.STYLE_NULL)
                    {
                        if (this.m_stroke.weight != 0)
                        {
                            this.m_stroke.apply(sprite.graphics, null, null);
                        }
                    }
                }
                switch(shape)
                {
                    case FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON:
                    case FeatureTemplate.TOOL_FREEHAND:
                    {
                        sprite.graphics.moveTo((width - _loc_16) * 0.25, (height - _loc_16) * 0.5);
                        sprite.graphics.curveTo(_loc_16, (height - _loc_16) * 0.25, (width - _loc_16) * 0.25, _loc_16);
                        sprite.graphics.curveTo((width - _loc_16) * 0.5, _loc_16 - 5, (width - _loc_16) * 0.75, _loc_16);
                        sprite.graphics.curveTo(width - _loc_16, (height - _loc_16) * 0.25, (width - _loc_16) * 0.75, (height - _loc_16) * 0.5);
                        sprite.graphics.curveTo(width - _loc_16, (height - _loc_16) * 0.75, (width - _loc_16) * 0.75, height - _loc_16);
                        sprite.graphics.curveTo((width - _loc_16) * 0.5, height - _loc_16 + 5, (width - _loc_16) * 0.25, height - _loc_16);
                        sprite.graphics.curveTo(_loc_16, (height - _loc_16) * 0.75, (width - _loc_16) * 0.25, (height - _loc_16) * 0.5);
                        break;
                    }
                    case FeatureTemplate.TOOL_CIRCLE:
                    {
                        _loc_17 = Math.min(width, height);
                        sprite.graphics.drawCircle(width * 0.5, height * 0.5, _loc_17 * 0.5);
                        break;
                    }
                    case FeatureTemplate.TOOL_ELLIPSE:
                    {
                        sprite.graphics.drawEllipse(0, 0, width, height);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else if (m_outline)
            {
                _loc_18 = Math.min(m_outline.width, height);
                _loc_19 = _loc_18 / 2;
                this.m_stroke.weight = _loc_18;
                this.m_stroke.color = m_outline.color;
                this.m_stroke.alpha = m_outline.alpha;
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (this.m_stroke.weight != 0)
                    {
                        this.m_stroke.apply(sprite.graphics, null, null);
                    }
                    sprite.graphics.drawRoundRect(_loc_19, _loc_19, width - _loc_18, height - _loc_18, (width + height) / 8);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    sprite.graphics.drawRoundRect(0, 0, width, height, (width + height) / 8);
                }
                else
                {
                    _loc_20 = [_loc_19, _loc_19, _loc_19, height - _loc_19, width - _loc_19, height - _loc_19, width - _loc_19, _loc_19, _loc_19, _loc_19];
                    sprite.graphics.drawRect(_loc_19, _loc_19, width - _loc_18, height - _loc_18);
                    sprite.graphics.endFill();
                    SymbolUtil.drawStyledLine(sprite, _loc_20, this.m_stroke, this.pattern);
                }
            }
            else
            {
                sprite.graphics.drawRoundRect(0, 0, width, height, (width + height) / 8);
            }
            sprite.graphics.endFill();
            return;
        }// end function

        private function drawPolygon(map:Map, mapExtent:Extent, sprite:Sprite, polygon:Polygon, bmp:Bitmap) : void
        {
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Extent = null;
            var _loc_18:Boolean = false;
            var _loc_20:Array = null;
            var _loc_21:Array = null;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_26:Array = null;
            var _loc_27:MapPoint = null;
            var _loc_28:Array = null;
            var _loc_29:Array = null;
            var _loc_30:MapPoint = null;
            var _loc_6:* = polygon.extent;
            var _loc_7:* = toScreenX(map, _loc_6.xmin);
            var _loc_8:* = toScreenX(map, _loc_6.xmax);
            var _loc_9:* = toScreenY(map, _loc_6.ymin);
            var _loc_10:* = toScreenY(map, _loc_6.ymax);
            sprite.x = _loc_7;
            sprite.y = _loc_10;
            sprite.width = _loc_8 - _loc_7;
            sprite.height = _loc_9 - _loc_10;
            var _loc_13:Number = 0;
            if (this.m_width)
            {
                _loc_22 = this.m_width;
                if (this.m_xscale)
                {
                    _loc_22 = _loc_22 * this.m_xscale;
                }
                bmp.width = _loc_22;
                _loc_11 = _loc_22 / bmp.bitmapData.width;
                _loc_14 = this.xoffset ? (this.xoffset - bmp.width / 2) : ((-bmp.width) / 2);
            }
            else
            {
                _loc_23 = this.m_xscale ? (bmp.bitmapData.width * this.m_xscale) : (bmp.bitmapData.width);
                _loc_11 = _loc_23 / bmp.bitmapData.width;
                _loc_14 = this.xoffset ? (this.xoffset - _loc_23 / 2) : ((-_loc_23) / 2);
            }
            if (this.m_height)
            {
                _loc_24 = this.m_height;
                if (this.m_yscale)
                {
                    _loc_24 = _loc_24 * this.m_yscale;
                }
                bmp.height = _loc_24;
                _loc_12 = _loc_24 / bmp.bitmapData.height;
                _loc_15 = this.yoffset ? (-(this.yoffset + bmp.height / 2)) : ((-bmp.height) / 2);
            }
            else
            {
                _loc_25 = this.m_yscale ? (bmp.bitmapData.height * this.m_yscale) : (bmp.bitmapData.height);
                _loc_12 = _loc_25 / bmp.bitmapData.height;
                _loc_15 = this.yoffset ? (-(this.yoffset + _loc_25 / 2)) : ((-_loc_25) / 2);
            }
            if (this.angle)
            {
                _loc_13 = 2 * Math.PI * (this.angle / 360);
            }
            this.m_matrix.createBox(_loc_11, _loc_12, _loc_13, _loc_14, _loc_15);
            sprite.graphics.beginBitmapFill(bmp.bitmapData, this.m_matrix, true, true);
            var _loc_17:* = new Polygon();
            if (m_outline)
            {
                _loc_18 = true;
                this.m_stroke.color = m_outline.color;
                this.m_stroke.weight = m_outline.width;
                this.m_stroke.alpha = m_outline.alpha;
            }
            var _loc_19:Array = [];
            for each (_loc_20 in polygon.rings)
            {
                
                if (polygon.rings.length == 1)
                {
                    _loc_16 = _loc_6;
                }
                else
                {
                    _loc_17.rings = [_loc_20];
                    _loc_16 = _loc_17.extent;
                }
                if (_loc_20.length >= 2)
                {
                    _loc_26 = [];
                    for each (_loc_27 in _loc_20)
                    {
                        
                        _loc_26.push(toScreenX(map, _loc_27.x) - sprite.x);
                        _loc_26.push(toScreenY(map, _loc_27.y) - sprite.y);
                    }
                    if (mapExtent.contains(_loc_16))
                    {
                        this.tracePolygon(map, mapExtent, sprite, _loc_26, _loc_20, this.m_stroke, _loc_18);
                        _loc_19.push(_loc_20);
                        continue;
                    }
                    if (mapExtent.disjointExtent(_loc_16))
                    {
                        continue;
                    }
                    _loc_28 = _loc_20.slice();
                    this.m_arrClippedBySidePoints = [];
                    this.runBySideClipping(_loc_28, mapExtent, "left");
                    _loc_28 = this.m_arrClippedBySidePoints;
                    this.m_arrClippedBySidePoints = [];
                    this.runBySideClipping(_loc_28, mapExtent, "right");
                    _loc_28 = this.m_arrClippedBySidePoints;
                    this.m_arrClippedBySidePoints = [];
                    this.runBySideClipping(_loc_28, mapExtent, "top");
                    _loc_28 = this.m_arrClippedBySidePoints;
                    this.m_arrClippedBySidePoints = [];
                    this.runBySideClipping(_loc_28, mapExtent, "bottom");
                    _loc_28 = this.m_arrClippedBySidePoints;
                    _loc_29 = [];
                    for each (_loc_30 in _loc_28)
                    {
                        
                        _loc_29.push(toScreenX(map, _loc_30.x) - sprite.x);
                        _loc_29.push(toScreenY(map, _loc_30.y) - sprite.y);
                    }
                    this.tracePolygon(map, mapExtent, sprite, _loc_29, _loc_28, this.m_stroke, _loc_18);
                    _loc_19.push(_loc_28);
                }
            }
            sprite.graphics.endFill();
            for each (_loc_21 in _loc_19)
            {
                
                if (m_outline)
                {
                }
                if (m_outline.style != SimpleLineSymbol.STYLE_SOLID)
                {
                }
                if (m_outline.style != SimpleLineSymbol.STYLE_NULL)
                {
                    if (m_outline)
                    {
                    }
                    if (m_outline.style != SimpleLineSymbol.STYLE_SOLID)
                    {
                    }
                    if (m_outline.style != SimpleLineSymbol.STYLE_NULL)
                    {
                        this.traceSegmentStyledLine(map, mapExtent, sprite, this.m_stroke, _loc_21.slice());
                    }
                    continue;
                }
                return;
            }
            return;
        }// end function

        private function tracePolygon(map:Map, mapExtent:Extent, sprite:Sprite, arrOfScreenPoints:Array, arrOfMapPoints:Array, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (stroke.weight != 0)
                    {
                        stroke.apply(sprite.graphics, null, null);
                    }
                    this.graphicsFilling(map, sprite, arrOfScreenPoints);
                }
                else
                {
                    this.graphicsFilling(map, sprite, arrOfScreenPoints);
                }
            }
            else
            {
                this.graphicsFilling(map, sprite, arrOfScreenPoints);
            }
            return;
        }// end function

        private function graphicsFilling(map:Map, sprite:Sprite, arrOfPoints:Array) : void
        {
            sprite.graphics.moveTo(arrOfPoints[0], arrOfPoints[1]);
            var _loc_4:int = 2;
            while (_loc_4 < arrOfPoints.length)
            {
                
                sprite.graphics.lineTo(arrOfPoints[_loc_4], arrOfPoints[(_loc_4 + 1)]);
                _loc_4 = _loc_4 + 2;
            }
            return;
        }// end function

        private function traceSegmentStyledLine(map:Map, mapExtent:Extent, sprite:Sprite, stroke:SolidColorStroke, arrOfStyledPoints:Array) : void
        {
            var _loc_8:MapPoint = null;
            this.closePolygon(arrOfStyledPoints);
            var _loc_6:* = arrOfStyledPoints[0];
            var _loc_7:int = 1;
            while (_loc_7 < arrOfStyledPoints.length)
            {
                
                _loc_8 = arrOfStyledPoints[_loc_7];
                if (_loc_8.x == _loc_6.x)
                {
                }
                if (_loc_8.y != _loc_6.y)
                {
                    this.drawSegmentStyledPolygon(map, mapExtent, sprite, stroke, _loc_6, _loc_8);
                }
                _loc_6 = _loc_8;
                _loc_7 = _loc_7 + 1;
            }
            return;
        }// end function

        private function closePolygon(arrPoints:Array) : void
        {
            if (arrPoints[(arrPoints.length - 1)].x == arrPoints[0].x)
            {
            }
            if (arrPoints[(arrPoints.length - 1)].y != arrPoints[0].y)
            {
                arrPoints.push(arrPoints[0]);
            }
            return;
        }// end function

        private function drawSegmentStyledPolygon(map:Map, mapExtent:Extent, sprite:Sprite, stroke:SolidColorStroke, startPt:MapPoint, endPt:MapPoint) : void
        {
            var _loc_7:* = toScreenX(map, startPt.x);
            var _loc_8:* = toScreenY(map, startPt.y);
            var _loc_9:* = toScreenX(map, endPt.x);
            var _loc_10:* = toScreenY(map, endPt.y);
            var _loc_11:Array = [];
            _loc_11.push(_loc_7 - sprite.x);
            _loc_11.push(_loc_8 - sprite.y);
            _loc_11.push(_loc_9 - sprite.x);
            _loc_11.push(_loc_10 - sprite.y);
            SymbolUtil.drawStyledLine(sprite, _loc_11, stroke, this.pattern);
            return;
        }// end function

        private function drawExtent(map:Map, mapExtent:Extent, sprite:Sprite, extent:Extent, bmp:Bitmap) : void
        {
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_20:Boolean = false;
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Boolean = false;
            var _loc_26:MapPoint = null;
            var _loc_27:Array = null;
            var _loc_6:* = toScreenX(map, extent.xmin);
            var _loc_7:* = toScreenY(map, extent.ymin);
            var _loc_8:* = toScreenX(map, extent.xmax);
            var _loc_9:* = toScreenY(map, extent.ymax);
            sprite.x = _loc_6;
            sprite.y = _loc_9;
            sprite.width = _loc_8 - _loc_6;
            sprite.height = _loc_7 - _loc_9;
            var _loc_10:Number = 0;
            var _loc_11:Number = 0;
            var _loc_12:* = _loc_8 - _loc_6;
            var _loc_13:* = _loc_7 - _loc_9;
            var _loc_14:Array = [new MapPoint(extent.xmin, extent.ymin), new MapPoint(extent.xmin, extent.ymax), new MapPoint(extent.xmax, extent.ymax), new MapPoint(extent.xmax, extent.ymin)];
            var _loc_17:Number = 0;
            if (this.m_width)
            {
                _loc_21 = this.m_width;
                if (this.m_xscale)
                {
                    _loc_21 = _loc_21 * this.m_xscale;
                }
                bmp.width = _loc_21;
                _loc_15 = _loc_21 / bmp.bitmapData.width;
                _loc_18 = this.xoffset ? (this.xoffset - bmp.width / 2) : ((-bmp.width) / 2);
            }
            else
            {
                _loc_22 = this.m_xscale ? (bmp.bitmapData.width * this.m_xscale) : (bmp.bitmapData.width);
                _loc_15 = _loc_22 / bmp.bitmapData.width;
                _loc_18 = this.xoffset ? (this.xoffset - _loc_22 / 2) : ((-_loc_22) / 2);
            }
            if (this.m_height)
            {
                _loc_23 = this.m_height;
                if (this.m_yscale)
                {
                    _loc_23 = _loc_23 * this.m_yscale;
                }
                bmp.height = _loc_23;
                _loc_16 = _loc_23 / bmp.bitmapData.height;
                _loc_19 = this.yoffset ? (-(this.yoffset + bmp.height / 2)) : ((-bmp.height) / 2);
            }
            else
            {
                _loc_24 = this.m_yscale ? (bmp.bitmapData.height * this.m_yscale) : (bmp.bitmapData.height);
                _loc_16 = _loc_24 / bmp.bitmapData.height;
                _loc_19 = this.yoffset ? (-(this.yoffset + _loc_24 / 2)) : ((-_loc_24) / 2);
            }
            if (this.angle)
            {
                _loc_17 = 2 * Math.PI * (this.angle / 360);
            }
            this.m_matrix.createBox(_loc_15, _loc_16, _loc_17, _loc_18, _loc_19);
            sprite.graphics.beginBitmapFill(bmp.bitmapData, this.m_matrix, true, true);
            if (m_outline)
            {
                _loc_20 = true;
                this.m_stroke.color = m_outline.color;
                this.m_stroke.weight = m_outline.width;
                this.m_stroke.alpha = m_outline.alpha;
            }
            if (mapExtent.contains(extent))
            {
                this.traceExtent(map, mapExtent, sprite, _loc_10, _loc_11, _loc_12, _loc_13, _loc_14, this.m_stroke, _loc_20);
            }
            else if (mapExtent.disjointExtent(extent))
            {
            }
            else if (extent.contains(mapExtent))
            {
                for each (_loc_26 in _loc_14)
                {
                    
                    if (!mapExtent.contains(_loc_26))
                    {
                        _loc_25 = true;
                        continue;
                    }
                    _loc_25 = false;
                }
                if (_loc_25)
                {
                    _loc_27 = [];
                    _loc_27.push(toScreenX(map, mapExtent.xmin) - sprite.x, toScreenY(map, mapExtent.ymin) - sprite.y, toScreenX(map, mapExtent.xmax) - sprite.x, toScreenY(map, mapExtent.ymin) - sprite.y, toScreenX(map, mapExtent.xmax) - sprite.x, toScreenY(map, mapExtent.ymax) - sprite.y, toScreenX(map, mapExtent.xmin) - sprite.x, toScreenY(map, mapExtent.ymax) - sprite.y);
                    this.graphicsFilling(map, sprite, _loc_27);
                }
                else
                {
                    this.traceClippedExtent(map, mapExtent, sprite, _loc_14, this.m_stroke, _loc_20);
                }
            }
            else
            {
                this.traceClippedExtent(map, mapExtent, sprite, _loc_14, this.m_stroke, _loc_20);
            }
            sprite.graphics.endFill();
            return;
        }// end function

        private function traceExtent(map:Map, mapExtent:Extent, sprite:Sprite, px0:Number, py0:Number, px1:Number, py1:Number, arrOfMapPoints:Array, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            var _loc_11:Array = null;
            var _loc_12:Array = null;
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (stroke.weight != 0)
                    {
                        stroke.apply(sprite.graphics, null, null);
                    }
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                }
                else
                {
                    sprite.graphics.drawRect(px0, py1, px1 - px0, py0 - py1);
                    sprite.graphics.endFill();
                    _loc_11 = [px0, py0, px1, py0, px1, py1, px0, py1, px0, py0];
                    if (px1 != px0)
                    {
                    }
                    if (py1 == py0)
                    {
                        _loc_12 = [_loc_11[0], _loc_11[1], _loc_11[4], _loc_11[5]];
                        SymbolUtil.drawStyledLine(sprite, _loc_12, stroke, this.pattern);
                    }
                    else
                    {
                        SymbolUtil.drawStyledLine(sprite, _loc_11, stroke, this.pattern);
                    }
                }
            }
            else
            {
                sprite.graphics.drawRect(px0, py0, px1, py1);
            }
            return;
        }// end function

        private function traceClippedExtent(map:Map, mapExtent:Extent, sprite:Sprite, arrOfMapPoints:Array, stroke:SolidColorStroke, hasOutline:Boolean) : void
        {
            var _loc_9:MapPoint = null;
            var _loc_7:* = arrOfMapPoints.slice();
            this.m_arrClippedBySidePoints = [];
            this.runBySideClipping(_loc_7, mapExtent, "left");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = [];
            this.runBySideClipping(_loc_7, mapExtent, "right");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = [];
            this.runBySideClipping(_loc_7, mapExtent, "top");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.m_arrClippedBySidePoints = [];
            this.runBySideClipping(_loc_7, mapExtent, "bottom");
            _loc_7 = this.m_arrClippedBySidePoints;
            this.closePolygon(_loc_7);
            var _loc_8:Array = [];
            for each (_loc_9 in _loc_7)
            {
                
                _loc_8.push(toScreenX(map, _loc_9.x) - sprite.x, toScreenY(map, _loc_9.y) - sprite.y);
            }
            if (hasOutline)
            {
                if (m_outline.style == SimpleLineSymbol.STYLE_SOLID)
                {
                    if (this.m_stroke.weight != 0)
                    {
                        this.m_stroke.apply(sprite.graphics, null, null);
                    }
                    this.graphicsFilling(map, sprite, _loc_8);
                }
                else if (m_outline.style == SimpleLineSymbol.STYLE_NULL)
                {
                    this.graphicsFilling(map, sprite, _loc_8);
                }
                else
                {
                    this.graphicsFilling(map, sprite, _loc_8);
                    sprite.graphics.endFill();
                    SymbolUtil.drawStyledLine(sprite, _loc_8, this.m_stroke, this.pattern);
                }
            }
            else
            {
                this.graphicsFilling(map, sprite, _loc_8);
            }
            return;
        }// end function

        private function runBySideClipping(arrClippedPoints:Array, extent:Extent, side:String) : void
        {
            var _loc_8:int = 0;
            var _loc_4:* = new MapPoint(extent.xmin, extent.ymin);
            var _loc_5:* = new MapPoint(extent.xmax, extent.ymax);
            var _loc_6:* = new MapPoint(extent.xmax, extent.ymin);
            var _loc_7:* = new MapPoint(extent.xmin, extent.ymax);
            switch(side)
            {
                case "left":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_7, _loc_4, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_7, _loc_4, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "right":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_6, _loc_5, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_6, _loc_5, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "top":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_4, _loc_6, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_4, _loc_6, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                case "bottom":
                {
                    _loc_8 = 0;
                    while (_loc_8 < arrClippedPoints.length)
                    {
                        
                        if ((_loc_8 + 1) < arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, (_loc_8 + 1), _loc_5, _loc_7, extent, arrClippedPoints, side);
                        }
                        else if ((_loc_8 + 1) == arrClippedPoints.length)
                        {
                            this.getOutput(_loc_8, 0, _loc_5, _loc_7, extent, arrClippedPoints, side);
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function getOutput(vertex1:int, vertex2:int, point1:MapPoint, point2:MapPoint, extent:Extent, arrClippedPoints:Array, side:String) : void
        {
            switch(side)
            {
                case "left":
                {
                    if (arrClippedPoints[vertex1].x >= extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x >= extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].x >= extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x < extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x < extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x < extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x < extent.xmin)
                    {
                    }
                    if (arrClippedPoints[vertex2].x >= extent.xmin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "right":
                {
                    if (arrClippedPoints[vertex1].x <= extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x <= extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].x <= extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x > extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x > extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x > extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].x > extent.xmax)
                    {
                    }
                    if (arrClippedPoints[vertex2].x <= extent.xmax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "top":
                {
                    if (arrClippedPoints[vertex1].y >= extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y >= extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].y >= extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y < extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y < extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y < extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y < extent.ymin)
                    {
                    }
                    if (arrClippedPoints[vertex2].y >= extent.ymin)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                case "bottom":
                {
                    if (arrClippedPoints[vertex1].y <= extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y <= extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideInside");
                    }
                    if (arrClippedPoints[vertex1].y <= extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y > extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "InsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y > extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y > extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideOutside");
                    }
                    if (arrClippedPoints[vertex1].y > extent.ymax)
                    {
                    }
                    if (arrClippedPoints[vertex2].y <= extent.ymax)
                    {
                        this.clipping(arrClippedPoints[vertex1], arrClippedPoints[vertex2], point1, point2, "OutsideInside");
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function clipping(v1:MapPoint, v2:MapPoint, vc1:MapPoint, vc2:MapPoint, clippingOption:String) : void
        {
            var _loc_6:MapPoint = null;
            switch(clippingOption)
            {
                case "InsideInside":
                {
                    this.m_arrClippedBySidePoints.push(new MapPoint(v2.x, v2.y));
                    break;
                }
                case "InsideOutside":
                {
                    _loc_6 = this.intersect(v1, v2, vc1, vc2);
                    this.m_arrClippedBySidePoints.push(_loc_6);
                    break;
                }
                case "OutsideOutside":
                {
                    break;
                }
                case "OutsideInside":
                {
                    _loc_6 = this.intersect(v1, v2, vc1, vc2);
                    this.m_arrClippedBySidePoints.push(_loc_6);
                    this.m_arrClippedBySidePoints.push(new MapPoint(v2.x, v2.y));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function intersect(v1:MapPoint, v2:MapPoint, vc1:MapPoint, vc2:MapPoint) : MapPoint
        {
            var v1:* = v1;
            var v2:* = v2;
            var vc1:* = vc1;
            var vc2:* = vc2;
            var det:* = function (a:Number, b:Number, c:Number, d:Number) : Number
            {
                return a * d - b * c;
            }// end function
            ;
            var x:* = this.det(this.det(v1.x, v1.y, v2.x, v2.y), v1.x - v2.x, this.det(vc1.x, vc1.y, vc2.x, vc2.y), vc1.x - vc2.x) / this.det(v1.x - v2.x, v1.y - v2.y, vc1.x - vc2.x, vc1.y - vc2.y);
            var y:* = this.det(this.det(v1.x, v1.y, v2.x, v2.y), v1.y - v2.y, this.det(vc1.x, vc1.y, vc2.x, vc2.y), vc1.y - vc2.y) / this.det(v1.x - v2.x, v1.y - v2.y, vc1.x - vc2.x, vc1.y - vc2.y);
            return new MapPoint(x, y);
        }// end function

        function get pattern() : Array
        {
            switch(m_outline.style)
            {
                case SimpleLineSymbol.STYLE_DASH:
                {
                    this.m_pattern = [6, 6, 6, 6];
                    break;
                }
                case SimpleLineSymbol.STYLE_DOT:
                {
                    this.m_pattern = [1, 6, 1, 6];
                    break;
                }
                case SimpleLineSymbol.STYLE_DASHDOT:
                {
                    this.m_pattern = [6, 4, 1, 4];
                    break;
                }
                case SimpleLineSymbol.STYLE_DASHDOTDOT:
                {
                    this.m_pattern = [6, 4, 1, 4, 1, 4];
                    break;
                }
                default:
                {
                    this.m_pattern = [1, 0];
                    break;
                }
            }
            return this.m_pattern;
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

        public function set xoffset(value:Number) : void
        {
            arguments = this.xoffset;
            if (arguments !== value)
            {
                this._1893520629xoffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xoffset", arguments, value));
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

        public function set yoffset(value:Number) : void
        {
            arguments = this.yoffset;
            if (arguments !== value)
            {
                this._1006016948yoffset = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "yoffset", arguments, value));
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

        public function set yscale(value:Number) : void
        {
            arguments = this.yscale;
            if (arguments !== value)
            {
                this._721589135yscale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "yscale", arguments, value));
                }
            }
            return;
        }// end function

        public function set xscale(value:Number) : void
        {
            arguments = this.xscale;
            if (arguments !== value)
            {
                this._750218286xscale = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xscale", arguments, value));
                }
            }
            return;
        }// end function

        public function set angle(value:Number) : void
        {
            arguments = this.angle;
            if (arguments !== value)
            {
                this._92960979angle = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "angle", arguments, value));
                }
            }
            return;
        }// end function

        public static function fromJSON(obj:Object) : PictureFillSymbol
        {
            return SymbolFactory.toPFS(obj);
        }// end function

        static function get defaultSymbol() : Symbol
        {
            if (m_defaultSymbol == null)
            {
                m_defaultSymbol = new PictureFillSymbol;
            }
            return m_defaultSymbol;
        }// end function

    }
}
