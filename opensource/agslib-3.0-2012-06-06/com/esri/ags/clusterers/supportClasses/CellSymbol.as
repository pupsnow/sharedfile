package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.events.*;

    public class CellSymbol extends Symbol
    {
        private var m_backgroundColor:uint = 7786752;
        private var m_backgroundAlpha:Number = 1;
        private var m_borderThickness:Number = 1;
        private var m_borderColor:uint = 0;
        private var m_borderAlpha:Number = 1;
        private var m_cornerRadius:Number = 15;
        private var m_paddingLeft:Number = 2;
        private var m_paddingRight:Number = 2;
        private var m_paddingTop:Number = 2;
        private var m_paddingBottom:Number = 2;
        private var m_size:Number = 70;
        private var m_textFormat:TextFormat;
        private static const EXTENT:Extent = new Extent();
        private static var m_instance:CellSymbol;

        public function CellSymbol()
        {
            return;
        }// end function

        public function get textFormat() : TextFormat
        {
            return this.m_textFormat;
        }// end function

        private function set _1475072900textFormat(value:TextFormat) : void
        {
            if (this.m_textFormat !== value)
            {
                this.m_textFormat = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get borderAlpha() : Number
        {
            return this.m_borderAlpha;
        }// end function

        private function set _720898194borderAlpha(value:Number) : void
        {
            if (this.m_borderAlpha !== value)
            {
                this.m_borderAlpha = value;
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
            if (this.m_borderColor !== value)
            {
                this.m_borderColor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get borderThickness() : Number
        {
            return this.m_borderThickness;
        }// end function

        private function set _1329173672borderThickness(value:Number) : void
        {
            if (this.m_borderThickness !== value)
            {
                this.m_borderThickness = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get backgroundAlpha() : Number
        {
            return this.m_backgroundAlpha;
        }// end function

        private function set _1285191888backgroundAlpha(value:Number) : void
        {
            if (this.m_backgroundAlpha !== value)
            {
                this.m_backgroundAlpha = value;
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
            if (this.m_backgroundColor !== value)
            {
                this.m_backgroundColor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get cornerRadius() : Number
        {
            return this.m_cornerRadius;
        }// end function

        private function set _583595847cornerRadius(value:Number) : void
        {
            if (this.m_cornerRadius !== value)
            {
                this.m_cornerRadius = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get paddingBottom() : Number
        {
            return this.m_paddingBottom;
        }// end function

        private function set _202355100paddingBottom(value:Number) : void
        {
            if (this.m_paddingBottom !== value)
            {
                this.m_paddingBottom = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get paddingTop() : Number
        {
            return this.m_paddingTop;
        }// end function

        private function set _90130308paddingTop(value:Number) : void
        {
            if (this.m_paddingTop !== value)
            {
                this.m_paddingTop = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get paddingRight() : Number
        {
            return this.m_paddingRight;
        }// end function

        private function set _713848971paddingRight(value:Number) : void
        {
            if (this.m_paddingRight !== value)
            {
                this.m_paddingRight = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get paddingLeft() : Number
        {
            return this.m_paddingLeft;
        }// end function

        private function set _1501175880paddingLeft(value:Number) : void
        {
            if (this.m_paddingLeft !== value)
            {
                this.m_paddingLeft = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get size() : Number
        {
            return this.m_size;
        }// end function

        private function set _3530753size(value:Number) : void
        {
            if (this.m_size !== value)
            {
                this.m_size = value;
                dispatchEventChange();
            }
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            sprite.graphics.clear();
            removeAllChildren(sprite);
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var _loc_6:MapPoint = null;
            var _loc_5:* = sprite as ClusterGraphic;
            if (_loc_5)
            {
                _loc_6 = _loc_5.mapPoint;
                if (map.wrapAround180)
                {
                    this.drawWrapAround(sprite, _loc_6, _loc_5, map);
                }
                else if (map.extent.containsXY(_loc_6.x, _loc_6.y))
                {
                    this.drawMapPoint(sprite, _loc_6.x, _loc_6.y, _loc_5, map);
                }
            }
            return;
        }// end function

        private function drawWrapAround(parent:Sprite, mapPoint:MapPoint, clusterGraphic:ClusterGraphic, map:Map) : void
        {
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Sprite = null;
            parent.x = 0;
            parent.y = 0;
            SpritePool.instance.releaseAllChildren(parent);
            var _loc_5:* = map.toScreenX(mapPoint.x);
            var _loc_6:* = map.toScreenY(mapPoint.y);
            var _loc_12:* = mapPoint.x;
            EXTENT.xmax = mapPoint.x;
            EXTENT.xmin = _loc_12;
            var _loc_12:* = mapPoint.y;
            EXTENT.ymax = mapPoint.y;
            EXTENT.ymin = _loc_12;
            EXTENT.spatialReference = map.spatialReference;
            mapPoint.spatialReference = map.spatialReference;
            var _loc_7:* = GeomUtils.intersects(map, mapPoint, EXTENT);
            for each (_loc_8 in _loc_7)
            {
                
                _loc_9 = map.toMapX(_loc_5 + _loc_8);
                _loc_10 = map.toMapY(_loc_6);
                if (map.extent.containsXY(_loc_9, _loc_10))
                {
                    _loc_11 = SpritePool.instance.acquire();
                    this.drawMapPoint(_loc_11, _loc_9, _loc_10, clusterGraphic, map);
                    parent.addChild(_loc_11);
                }
            }
            return;
        }// end function

        private function drawMapPoint(sprite:Sprite, mapPointX:Number, mapPointY:Number, clusterGraphic:ClusterGraphic, map:Map) : void
        {
            var _loc_7:Number = NaN;
            sprite.x = toScreenX(map, mapPointX);
            sprite.y = toScreenY(map, mapPointY);
            var _loc_6:* = sprite.getChildByName("textField") as TextField;
            if (_loc_6 === null)
            {
                _loc_6 = new TextField();
                _loc_6.name = "textField";
                _loc_6.selectable = false;
                _loc_6.mouseEnabled = false;
                _loc_6.mouseWheelEnabled = false;
                _loc_6.autoSize = TextFieldAutoSize.CENTER;
                _loc_6.antiAliasType = AntiAliasType.ADVANCED;
                sprite.addChild(_loc_6);
            }
            _loc_6.text = clusterGraphic.cluster.weight.toString();
            if (this.m_textFormat)
            {
                _loc_6.embedFonts = FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(this.m_textFormat);
                _loc_6.setTextFormat(this.m_textFormat);
            }
            _loc_6.x = -1 - (_loc_6.textWidth >> 1);
            _loc_6.y = -2 - (_loc_6.textHeight >> 1);
            _loc_7 = this.m_size * -0.5;
            var _loc_8:* = this.m_size - this.paddingLeft - this.paddingRight;
            var _loc_9:* = this.m_size - this.paddingTop - this.paddingBottom;
            var _loc_10:* = _loc_7 + this.paddingRight;
            var _loc_11:* = _loc_7 + this.paddingTop;
            sprite.graphics.clear();
            if (this.borderThickness > 0)
            {
                sprite.graphics.lineStyle(this.borderThickness, this.borderColor, this.borderAlpha, true);
            }
            sprite.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
            sprite.graphics.drawRoundRect(_loc_10, _loc_11, _loc_8, _loc_9, this.cornerRadius, this.cornerRadius);
            sprite.graphics.endFill();
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            SpritePool.instance.releaseAllChildren(sprite);
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, shape:String = null) : UIComponent
        {
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            if (this.borderThickness > 0)
            {
                _loc_4.graphics.lineStyle(this.borderThickness, this.borderColor, this.borderAlpha);
            }
            _loc_4.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
            _loc_4.graphics.drawRoundRect(0, 0, width, height, this.cornerRadius, this.cornerRadius);
            _loc_4.graphics.endFill();
            return _loc_4;
        }// end function

        public function set paddingTop(value:Number) : void
        {
            arguments = this.paddingTop;
            if (arguments !== value)
            {
                this._90130308paddingTop = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingTop", arguments, value));
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

        public function set textFormat(value:TextFormat) : void
        {
            arguments = this.textFormat;
            if (arguments !== value)
            {
                this._1475072900textFormat = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "textFormat", arguments, value));
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

        public function set cornerRadius(value:Number) : void
        {
            arguments = this.cornerRadius;
            if (arguments !== value)
            {
                this._583595847cornerRadius = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cornerRadius", arguments, value));
                }
            }
            return;
        }// end function

        public function set borderThickness(value:Number) : void
        {
            arguments = this.borderThickness;
            if (arguments !== value)
            {
                this._1329173672borderThickness = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderThickness", arguments, value));
                }
            }
            return;
        }// end function

        public function set borderAlpha(value:Number) : void
        {
            arguments = this.borderAlpha;
            if (arguments !== value)
            {
                this._720898194borderAlpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderAlpha", arguments, value));
                }
            }
            return;
        }// end function

        public function set paddingLeft(value:Number) : void
        {
            arguments = this.paddingLeft;
            if (arguments !== value)
            {
                this._1501175880paddingLeft = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingLeft", arguments, value));
                }
            }
            return;
        }// end function

        public function set paddingBottom(value:Number) : void
        {
            arguments = this.paddingBottom;
            if (arguments !== value)
            {
                this._202355100paddingBottom = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingBottom", arguments, value));
                }
            }
            return;
        }// end function

        public function set backgroundAlpha(value:Number) : void
        {
            arguments = this.backgroundAlpha;
            if (arguments !== value)
            {
                this._1285191888backgroundAlpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundAlpha", arguments, value));
                }
            }
            return;
        }// end function

        public function set size(value:Number) : void
        {
            arguments = this.size;
            if (arguments !== value)
            {
                this._3530753size = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "size", arguments, value));
                }
            }
            return;
        }// end function

        public function set paddingRight(value:Number) : void
        {
            arguments = this.paddingRight;
            if (arguments !== value)
            {
                this._713848971paddingRight = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paddingRight", arguments, value));
                }
            }
            return;
        }// end function

        static function get instance() : CellSymbol
        {
            if (m_instance === null)
            {
                m_instance = new CellSymbol;
            }
            return m_instance;
        }// end function

    }
}
