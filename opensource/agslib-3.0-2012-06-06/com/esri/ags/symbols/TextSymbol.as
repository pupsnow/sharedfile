package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.core.*;
    import mx.events.*;

    public class TextSymbol extends Symbol
    {
        private var m_placement:String;
        private var m_angle:Number;
        private var m_textFormat:TextFormat;
        private var m_text:String;
        private var m_textAttribute:String;
        private var m_textFunction:Function;
        private var m_htmlText:String;
        private var m_color:uint;
        private var m_alpha:Number;
        private var m_background:Boolean;
        private var m_backgroundColor:uint;
        private var m_border:Boolean;
        private var m_borderColor:uint;
        private var m_xoffset:Number;
        private var m_yoffset:Number;
        private var m_textField:FTETextField;
        private var m_rotationSprite:Sprite;
        private var m_doRotation:Boolean;
        private var m_hasChildren:Boolean;
        public static const PLACEMENT_START:String = "start";
        public static const PLACEMENT_MIDDLE:String = "middle";
        public static const PLACEMENT_END:String = "end";
        public static const PLACEMENT_BELOW:String = "below";
        public static const PLACEMENT_ABOVE:String = "above";

        public function TextSymbol(text:String = null, htmlText:String = null, color:uint = 0, alpha:Number = 1, border:Boolean = false, borderColor:uint = 0, background:Boolean = false, backgroundColor:uint = 16777215, placement:String = "middle", angle:Number = 0, xoffset:Number = 0, yoffset:Number = 0, textFormat:TextFormat = null, textAttribute:String = null, textFunction:Function = null)
        {
            this.m_text = text;
            this.m_htmlText = htmlText;
            this.m_color = color;
            this.m_alpha = alpha;
            this.m_border = border;
            this.m_borderColor = borderColor;
            this.m_background = background;
            this.m_backgroundColor = backgroundColor;
            this.m_placement = placement;
            this.m_angle = angle;
            this.m_xoffset = xoffset;
            this.m_yoffset = yoffset;
            this.m_textFormat = textFormat;
            this.m_textAttribute = textAttribute;
            this.m_textFunction = textFunction;
            return;
        }// end function

        public function get placement() : String
        {
            return this.m_placement;
        }// end function

        private function set _1792938725placement(value:String) : void
        {
            if (value != this.m_placement)
            {
                this.m_placement = value;
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

        public function get text() : String
        {
            return this.m_text;
        }// end function

        private function set _3556653text(value:String) : void
        {
            if (value != this.m_text)
            {
                this.m_text = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get textAttribute() : String
        {
            return this.m_textAttribute;
        }// end function

        private function set _287967215textAttribute(value:String) : void
        {
            if (value != this.m_textAttribute)
            {
                this.m_textAttribute = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get textFunction() : Function
        {
            return this.m_textFunction;
        }// end function

        private function set _1112711205textFunction(value:Function) : void
        {
            if (value != this.m_textFunction)
            {
                this.m_textFunction = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get htmlText() : String
        {
            return this.m_htmlText;
        }// end function

        private function set _337185928htmlText(value:String) : void
        {
            if (value != this.m_htmlText)
            {
                this.m_htmlText = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this.m_color;
        }// end function

        private function set _94842723color(value:uint) : void
        {
            if (value != this.m_color)
            {
                this.m_color = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get alpha() : Number
        {
            return this.m_alpha;
        }// end function

        private function set _92909918alpha(value:Number) : void
        {
            if (value != this.m_alpha)
            {
                this.m_alpha = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get border() : Boolean
        {
            return this.m_border;
        }// end function

        private function set _1383304148border(value:Boolean) : void
        {
            if (value != this.m_border)
            {
                this.m_border = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get borderColor() : uint
        {
            return this.m_borderColor;
        }// end function

        private function set _722830999borderColor(value:uint) : void
        {
            if (value != this.m_borderColor)
            {
                this.m_borderColor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get background() : Boolean
        {
            return this.m_background;
        }// end function

        private function set _1332194002background(value:Boolean) : void
        {
            if (value != this.m_background)
            {
                this.m_background = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get backgroundColor() : uint
        {
            return this.m_backgroundColor;
        }// end function

        private function set _1287124693backgroundColor(value:uint) : void
        {
            if (value != this.m_backgroundColor)
            {
                this.m_backgroundColor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get textFormat() : TextFormat
        {
            return this.m_textFormat;
        }// end function

        public function set textFormat(value:TextFormat) : void
        {
            this.m_textFormat = value;
            dispatchEventChange();
            dispatchEvent(new Event("textFormatChanged"));
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

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var multipoint:Multipoint;
            var sprite:* = sprite;
            var geometry:* = geometry;
            var attributes:* = attributes;
            var map:* = map;
            var mapExtent:* = map.extentExpanded;
            if (geometry is MapPoint)
            {
                if (!map.wrapAround180)
                {
                    if (mapExtent.intersects(geometry))
                    {
                        if (sprite.numChildren > 0)
                        {
                            this.getChildFromSprite(sprite);
                        }
                        if (sprite.numChildren == 0)
                        {
                            this.m_hasChildren = false;
                            this.m_textField = new FTETextField();
                            this.m_textField.name = "textField";
                            this.m_textField.selectable = false;
                            this.m_textField.autoSize = TextFieldAutoSize.LEFT;
                        }
                        this.drawTextPoint(map, sprite, geometry as MapPoint, attributes);
                        showAllChildren(sprite);
                    }
                    else
                    {
                        hideAllChildren(sprite);
                    }
                }
                else
                {
                    var getNewPointGeometry:* = function (geometry:MapPoint) : Multipoint
            {
                var _loc_2:Multipoint = null;
                var _loc_6:Number = NaN;
                var _loc_7:Number = NaN;
                var _loc_8:Number = NaN;
                var _loc_3:* = MapPoint(geometry);
                var _loc_4:* = new Extent(_loc_3.x, _loc_3.y, _loc_3.x, _loc_3.y, geometry.spatialReference);
                var _loc_5:* = GeomUtils.intersects(map, _loc_3, _loc_4);
                if (_loc_5)
                {
                }
                if (_loc_5.length > 0)
                {
                    _loc_2 = new Multipoint();
                    _loc_6 = map.toScreenX(_loc_3.x);
                    _loc_7 = map.toScreenY(_loc_3.y);
                    for each (_loc_8 in _loc_5)
                    {
                        
                        _loc_2.addPoint(map.toMap(new Point(_loc_6 + _loc_8, _loc_7)));
                    }
                }
                return _loc_2;
            }// end function
            ;
                    multipoint = this.getNewPointGeometry(geometry);
                    if (multipoint)
                    {
                    }
                    if (multipoint.points.length > 0)
                    {
                        this.drawTextMultipoint(map, sprite, MapPoint(geometry), multipoint, attributes);
                        showAllChildren(sprite);
                    }
                    else
                    {
                        hideAllChildren(sprite);
                    }
                }
            }
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            removeAllChildren(sprite);
            sprite.graphics.clear();
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        private function getChildFromSprite(sprite:Sprite) : void
        {
            var _loc_2:DisplayObject = null;
            this.m_hasChildren = true;
            _loc_2 = sprite.getChildAt(0);
            if (_loc_2 is DisplayObjectContainer)
            {
            }
            if (_loc_2.name == "rotationSprite")
            {
                this.m_rotationSprite = _loc_2 as Sprite;
                this.m_textField = DisplayObjectContainer(_loc_2).getChildAt(0) as FTETextField;
            }
            else if (this.m_angle)
            {
                this.m_textField = sprite.removeChildAt(0) as FTETextField;
                this.m_rotationSprite = new Sprite();
                this.m_rotationSprite.name = "rotationSprite";
                this.m_rotationSprite.addChild(this.m_textField);
                sprite.addChild(this.m_rotationSprite);
            }
            else
            {
                this.m_textField = _loc_2 as FTETextField;
            }
            return;
        }// end function

        private function drawTextPoint(map:Map, sprite:Sprite, point:MapPoint, attributes:Object) : void
        {
            var _loc_7:Object = null;
            var _loc_8:Object = null;
            var _loc_9:Boolean = false;
            if (this.m_text)
            {
                this.m_textField.text = this.m_text;
            }
            else if (this.m_htmlText)
            {
                this.m_textField.htmlText = this.m_htmlText;
            }
            else if (this.m_textAttribute)
            {
                if (attributes)
                {
                    _loc_7 = attributes[this.m_textAttribute];
                    if (_loc_7 != null)
                    {
                        this.m_textField.text = String(_loc_7);
                        this.m_textField.visible = true;
                    }
                    else
                    {
                        this.m_textField.visible = false;
                    }
                }
                else
                {
                    this.m_textField.visible = false;
                }
            }
            else if (this.m_textFunction != null)
            {
                _loc_8 = this.m_textFunction(point, attributes);
                if (_loc_8 != null)
                {
                    this.m_textField.text = String(_loc_8);
                    this.m_textField.visible = true;
                }
                else
                {
                    this.m_textField.visible = false;
                }
            }
            this.m_textField.textColor = this.m_color;
            this.m_textField.background = this.m_background;
            this.m_textField.backgroundColor = this.m_backgroundColor;
            this.m_textField.border = this.m_border;
            this.m_textField.borderColor = this.m_borderColor;
            if (this.m_angle)
            {
                this.m_doRotation = true;
                if (!this.m_hasChildren)
                {
                    this.m_rotationSprite = new Sprite();
                    this.m_rotationSprite.name = "rotationSprite";
                    this.m_rotationSprite.addChild(this.m_textField);
                    sprite.addChild(this.m_rotationSprite);
                }
            }
            else
            {
                this.m_doRotation = false;
            }
            if (this.m_alpha)
            {
                this.m_textField.alpha = this.m_alpha;
            }
            if (this.m_textFormat)
            {
                _loc_9 = FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(this.m_textFormat);
                if (_loc_9)
                {
                    this.m_textField.embedFonts = true;
                }
                this.m_textField.setTextFormat(this.m_textFormat);
            }
            var _loc_5:* = this.m_textField.width;
            var _loc_6:* = this.m_textField.height;
            sprite.x = toScreenX(map, point.x) - _loc_5 / 2;
            sprite.y = toScreenY(map, point.y) - _loc_6 / 2;
            sprite.width = _loc_5;
            sprite.height = _loc_6;
            switch(this.m_placement)
            {
                case PLACEMENT_START:
                {
                    sprite.x = sprite.x + _loc_5 / 2;
                    break;
                }
                case PLACEMENT_END:
                {
                    sprite.x = sprite.x - _loc_5 / 2;
                    break;
                }
                case PLACEMENT_ABOVE:
                {
                    sprite.y = sprite.y - _loc_6 / 2;
                    break;
                }
                case PLACEMENT_BELOW:
                {
                    sprite.y = sprite.y + _loc_6 / 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.xoffset)
            {
                sprite.x = sprite.x + this.xoffset;
            }
            if (this.yoffset)
            {
                sprite.y = sprite.y - this.yoffset;
            }
            if (!this.m_doRotation)
            {
                if (!this.m_hasChildren)
                {
                    sprite.addChild(this.m_textField);
                }
                else if (DisplayObject(sprite.getChildAt(0)).name != "textField")
                {
                    sprite.removeChildAt(0);
                    sprite.addChild(this.m_textField);
                }
            }
            else
            {
                this.m_rotationSprite.x = _loc_5 / 2;
                this.m_rotationSprite.y = _loc_6 / 2;
                this.m_textField.x = (-_loc_5) / 2;
                this.m_textField.y = (-_loc_6) / 2;
                this.m_rotationSprite.rotation = this.m_angle;
            }
            return;
        }// end function

        private function drawTextMultipoint(map:Map, sprite:Sprite, point:MapPoint, multipoint:Multipoint, attributes:Object) : void
        {
            var _loc_6:Extent = null;
            var _loc_7:Array = [];
            _loc_6 = multipoint.points.length == 1 ? (new Extent(multipoint.points[0].x, multipoint.points[0].y, multipoint.points[0].x, multipoint.points[0].y)) : (multipoint.extent);
            var _loc_8:int = 0;
            while (_loc_8 < multipoint.points.slice().length)
            {
                
                _loc_7.push(multipoint.points[_loc_8] as MapPoint);
                _loc_8 = _loc_8 + 1;
            }
            while (sprite.numChildren > 0)
            {
                
                sprite.removeChildAt(0);
            }
            this.traceMultipoint(map, sprite, point, _loc_7, _loc_6, attributes);
            return;
        }// end function

        private function traceMultipoint(map:Map, sprite:Sprite, mapPoint:MapPoint, arr:Array, multipointExtent:Extent, attributes:Object) : void
        {
            var _loc_7:MapPoint = null;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:FTETextField = null;
            for each (_loc_7 in arr)
            {
                
                _loc_8 = toScreenX(map, _loc_7.x);
                _loc_9 = toScreenY(map, _loc_7.y);
                _loc_10 = this.getMultipointTextField(mapPoint, attributes);
                if (!this.m_angle)
                {
                    sprite.addChild(_loc_10);
                    this.symbolPlacement(map, _loc_10, _loc_8, _loc_9, sprite, null, multipointExtent);
                    continue;
                }
                this.m_rotationSprite = new UIComponent();
                this.m_rotationSprite.addChild(_loc_10);
                this.m_rotationSprite.name = "rotationSprite";
                this.m_rotationSprite.rotation = this.m_angle;
                sprite.addChild(this.m_rotationSprite);
                this.symbolPlacement(map, _loc_10, _loc_8, _loc_9, sprite, this.m_rotationSprite, multipointExtent);
            }
            return;
        }// end function

        private function getMultipointTextField(point:MapPoint, attributes:Object) : FTETextField
        {
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Boolean = false;
            var _loc_3:* = new FTETextField();
            _loc_3.name = "textField";
            _loc_3.selectable = false;
            _loc_3.autoSize = TextFieldAutoSize.LEFT;
            if (this.m_text)
            {
                _loc_3.text = this.m_text;
            }
            else if (this.m_htmlText)
            {
                _loc_3.htmlText = this.m_htmlText;
            }
            else if (this.m_textAttribute)
            {
                if (attributes)
                {
                    _loc_4 = attributes[this.m_textAttribute];
                    if (_loc_4 != null)
                    {
                        _loc_3.text = String(_loc_4);
                        _loc_3.visible = true;
                    }
                    else
                    {
                        _loc_3.visible = false;
                    }
                }
                else
                {
                    _loc_3.visible = false;
                }
            }
            else if (this.m_textFunction != null)
            {
                _loc_5 = this.m_textFunction(point, attributes);
                if (_loc_5 != null)
                {
                    _loc_3.text = String(_loc_5);
                    _loc_3.visible = true;
                }
                else
                {
                    _loc_3.visible = false;
                }
            }
            _loc_3.textColor = this.m_color;
            _loc_3.background = this.m_background;
            _loc_3.backgroundColor = this.m_backgroundColor;
            _loc_3.border = this.m_border;
            _loc_3.borderColor = this.m_borderColor;
            if (this.m_alpha)
            {
                _loc_3.alpha = this.m_alpha;
            }
            if (this.m_textFormat)
            {
                _loc_6 = FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(this.m_textFormat);
                if (_loc_6)
                {
                    _loc_3.embedFonts = true;
                }
                _loc_3.setTextFormat(this.m_textFormat);
            }
            return _loc_3;
        }// end function

        private function symbolPlacement(map:Map, textField:FTETextField, sx:Number, sy:Number, sprite:Sprite, rotationSprite:Sprite = null, multipointExtent:Extent = null) : void
        {
            var _loc_8:* = toScreenX(map, multipointExtent.xmin);
            var _loc_9:* = toScreenY(map, multipointExtent.ymin);
            var _loc_10:* = toScreenX(map, multipointExtent.xmax);
            var _loc_11:* = toScreenY(map, multipointExtent.ymax);
            sprite.x = _loc_8 - textField.width / 2;
            sprite.width = _loc_10 + textField.width - _loc_8;
            if (!rotationSprite)
            {
                textField.x = sx - (textField.width / 2 + sprite.x);
            }
            else
            {
                rotationSprite.x = sx - sprite.x;
                textField.x = (-textField.width) / 2;
            }
            sprite.y = _loc_11 - textField.height / 2;
            sprite.height = _loc_9 + textField.height - _loc_11;
            if (!rotationSprite)
            {
                textField.y = sy - (textField.height / 2 + sprite.y);
            }
            else
            {
                rotationSprite.y = sy - sprite.y;
                textField.y = (-textField.height) / 2;
            }
            switch(this.m_placement)
            {
                case PLACEMENT_START:
                {
                    sprite.x = sprite.x + textField.width / 2;
                    break;
                }
                case PLACEMENT_END:
                {
                    sprite.x = sprite.x - textField.width / 2;
                    break;
                }
                case PLACEMENT_ABOVE:
                {
                    sprite.y = sprite.y - textField.height / 2;
                    break;
                }
                case PLACEMENT_BELOW:
                {
                    sprite.y = sprite.y + textField.height / 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.xoffset)
            {
                sprite.x = sprite.x + this.xoffset;
                if (rotationSprite)
                {
                    rotationSprite.x = rotationSprite.x + this.xoffset;
                }
            }
            if (this.yoffset)
            {
                sprite.y = sprite.y - this.yoffset;
                if (rotationSprite)
                {
                    rotationSprite.y = rotationSprite.y - this.yoffset;
                }
            }
            return;
        }// end function

        function toServerJSON(point:MapPoint, attributes:Object) : Object
        {
            var _loc_8:Object = null;
            var _loc_9:Object = null;
            var _loc_3:Object = {type:"esriTS"};
            var _loc_4:* = this.textFormat;
            var _loc_5:* = isFinite(this.alpha) ? (this.alpha) : (1);
            if (_loc_4)
            {
            }
            var _loc_6:* = _loc_4.color is uint ? (_loc_4.color as uint) : (this.color);
            _loc_3.color = SymbolFactory.colorAndAlphaToRGBA(_loc_6, _loc_5);
            if (isFinite(this.angle))
            {
                isFinite(this.angle);
            }
            if (this.angle != 0)
            {
                _loc_3.angle = -this.angle;
            }
            if (this.background)
            {
                _loc_3.backgroundColor = SymbolFactory.colorAndAlphaToRGBA(this.backgroundColor, 1);
            }
            if (this.border)
            {
                _loc_3.borderLineColor = SymbolFactory.colorAndAlphaToRGBA(this.borderColor, 1);
            }
            if (isFinite(this.xoffset))
            {
                isFinite(this.xoffset);
            }
            if (this.xoffset != 0)
            {
                _loc_3.xoffset = SymbolFactory.pxToPt(this.xoffset);
            }
            if (isFinite(this.yoffset))
            {
                isFinite(this.yoffset);
            }
            if (this.yoffset != 0)
            {
                _loc_3.yoffset = SymbolFactory.pxToPt(this.yoffset);
            }
            if (_loc_4)
            {
            }
            if (_loc_4.kerning)
            {
                _loc_3.kerning = true;
            }
            if (this.text)
            {
                _loc_3.text = this.text;
            }
            else if (this.htmlText)
            {
                _loc_3.text = this.htmlText;
            }
            else if (this.textAttribute)
            {
                if (attributes)
                {
                    _loc_8 = attributes[this.textAttribute];
                    if (_loc_8 != null)
                    {
                        _loc_3.text = String(_loc_8);
                    }
                }
            }
            else if (this.textFunction != null)
            {
                _loc_9 = this.textFunction(point, attributes);
                if (_loc_9 != null)
                {
                    _loc_3.text = String(_loc_9);
                }
            }
            switch(this.placement)
            {
                case PLACEMENT_ABOVE:
                {
                    _loc_3.horizontalAlignment = "center";
                    _loc_3.verticalAlignment = "bottom";
                    break;
                }
                case PLACEMENT_BELOW:
                {
                    _loc_3.horizontalAlignment = "center";
                    _loc_3.verticalAlignment = "top";
                    break;
                }
                case PLACEMENT_END:
                {
                    _loc_3.horizontalAlignment = "right";
                    _loc_3.verticalAlignment = "middle";
                    break;
                }
                case PLACEMENT_START:
                {
                    _loc_3.horizontalAlignment = "left";
                    _loc_3.verticalAlignment = "middle";
                    break;
                }
                default:
                {
                    _loc_3.horizontalAlignment = "center";
                    _loc_3.verticalAlignment = "middle";
                    break;
                    break;
                }
            }
            var _loc_7:Object = {family:"Times New Roman", size:9};
            _loc_3.font = _loc_7;
            if (_loc_4)
            {
                if (_loc_4.font)
                {
                    _loc_7.family = _loc_4.font;
                }
                if (_loc_4.size is Number)
                {
                    _loc_7.size = SymbolFactory.pxToPt(_loc_4.size as Number);
                }
                if (_loc_4.underline)
                {
                    _loc_7.decoration = "underline";
                }
                if (_loc_4.italic)
                {
                    _loc_7.style = "italic";
                }
                if (_loc_4.bold)
                {
                    _loc_7.weight = "bold";
                }
            }
            return _loc_3;
        }// end function

        public function set placement(value:String) : void
        {
            arguments = this.placement;
            if (arguments !== value)
            {
                this._1792938725placement = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "placement", arguments, value));
                }
            }
            return;
        }// end function

        public function set text(value:String) : void
        {
            arguments = this.text;
            if (arguments !== value)
            {
                this._3556653text = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "text", arguments, value));
                }
            }
            return;
        }// end function

        public function set borderColor(value:uint) : void
        {
            arguments = this.borderColor;
            if (arguments !== value)
            {
                this._722830999borderColor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderColor", arguments, value));
                }
            }
            return;
        }// end function

        public function set backgroundColor(value:uint) : void
        {
            arguments = this.backgroundColor;
            if (arguments !== value)
            {
                this._1287124693backgroundColor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundColor", arguments, value));
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

        public function set textAttribute(value:String) : void
        {
            arguments = this.textAttribute;
            if (arguments !== value)
            {
                this._287967215textAttribute = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "textAttribute", arguments, value));
                }
            }
            return;
        }// end function

        public function set htmlText(value:String) : void
        {
            arguments = this.htmlText;
            if (arguments !== value)
            {
                this._337185928htmlText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "htmlText", arguments, value));
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

        public function set color(value:uint) : void
        {
            arguments = this.color;
            if (arguments !== value)
            {
                this._94842723color = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "color", arguments, value));
                }
            }
            return;
        }// end function

        public function set alpha(value:Number) : void
        {
            arguments = this.alpha;
            if (arguments !== value)
            {
                this._92909918alpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "alpha", arguments, value));
                }
            }
            return;
        }// end function

        public function set background(value:Boolean) : void
        {
            arguments = this.background;
            if (arguments !== value)
            {
                this._1332194002background = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "background", arguments, value));
                }
            }
            return;
        }// end function

        public function set textFunction(value:Function) : void
        {
            arguments = this.textFunction;
            if (arguments !== value)
            {
                this._1112711205textFunction = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "textFunction", arguments, value));
                }
            }
            return;
        }// end function

        public function set border(value:Boolean) : void
        {
            arguments = this.border;
            if (arguments !== value)
            {
                this._1383304148border = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "border", arguments, value));
                }
            }
            return;
        }// end function

    }
}
