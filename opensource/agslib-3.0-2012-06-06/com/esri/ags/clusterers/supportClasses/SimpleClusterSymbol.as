package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.events.*;

    public class SimpleClusterSymbol extends Symbol
    {
        private const GREEN:uint = 7786752;
        private var m_alpha:Number = 0.75;
        private var m_color:uint = 7786752;
        private var m_size:Number = 70;
        private var m_textFormat:TextFormat;
        private var m_fractionDigits:uint = 0;
        private var m_weights:Array;
        private var m_colors:Array;
        private var m_alphas:Array;
        private var m_sizes:Array;
        private static const EXTENT:Extent = new Extent();
        private static var m_instance:SimpleClusterSymbol;

        public function SimpleClusterSymbol()
        {
            return;
        }// end function

        public function get fractionDigits() : uint
        {
            return this.m_fractionDigits;
        }// end function

        private function set _1952600456fractionDigits(value:uint) : void
        {
            if (this.m_fractionDigits !== value)
            {
                this.m_fractionDigits = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get weights() : Array
        {
            return this.m_weights;
        }// end function

        private function set _1230441723weights(value:Array) : void
        {
            if (this.m_weights !== value)
            {
                this.m_weights = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get colors() : Array
        {
            return this.m_colors;
        }// end function

        private function set _1354842768colors(value:Array) : void
        {
            if (this.m_colors !== value)
            {
                this.m_colors = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get alphas() : Array
        {
            return this.m_alphas;
        }// end function

        private function set _1414759723alphas(value:Array) : void
        {
            if (this.m_alphas !== value)
            {
                this.m_alphas = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get sizes() : Array
        {
            return this.m_sizes;
        }// end function

        private function set _109453458sizes(value:Array) : void
        {
            if (this.m_sizes !== value)
            {
                this.m_sizes = value;
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
            if (this.m_color !== value)
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
            if (this.m_alpha !== value)
            {
                this.m_alpha = value;
                dispatchEventChange();
            }
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
            var _loc_11:int = 0;
            var _loc_12:int = 0;
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
            var _loc_7:* = clusterGraphic.cluster.weight;
            _loc_6.text = _loc_7.toFixed(this.m_fractionDigits);
            if (this.m_textFormat)
            {
                _loc_6.embedFonts = FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(this.m_textFormat);
                _loc_6.setTextFormat(this.m_textFormat);
            }
            _loc_6.x = -1 - (_loc_6.textWidth >> 1);
            _loc_6.y = -2 - (_loc_6.textHeight >> 1);
            var _loc_8:* = this.m_size;
            var _loc_9:* = this.m_color;
            var _loc_10:* = this.m_alpha;
            if (this.m_weights)
            {
                _loc_11 = 0;
                _loc_12 = this.m_weights.length;
                while (_loc_11 < _loc_12)
                {
                    
                    if (this.m_weights[_loc_11] >= _loc_7)
                    {
                        if (this.m_sizes)
                        {
                        }
                        if (_loc_11 < this.m_sizes.length)
                        {
                            _loc_8 = this.m_sizes[_loc_11];
                        }
                        if (this.m_colors)
                        {
                        }
                        if (_loc_11 < this.m_colors.length)
                        {
                            _loc_9 = this.m_colors[_loc_11];
                        }
                        if (this.m_alphas)
                        {
                        }
                        if (_loc_11 < this.m_alphas.length)
                        {
                            _loc_10 = this.m_alphas[_loc_11];
                        }
                        break;
                    }
                    _loc_11 = _loc_11 + 1;
                }
            }
            sprite.graphics.clear();
            sprite.graphics.beginFill(_loc_9, _loc_10);
            sprite.graphics.drawCircle(0, 0, _loc_8 * 0.5);
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
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            _loc_5 = width * 0.5;
            _loc_6 = height * 0.5;
            var _loc_7:* = Math.min(_loc_5, _loc_6);
            _loc_4.graphics.beginFill(this.m_color, this.m_alpha);
            _loc_4.graphics.drawCircle(_loc_5, _loc_6, _loc_7);
            _loc_4.graphics.endFill();
            return _loc_4;
        }// end function

        public function set sizes(value:Array) : void
        {
            arguments = this.sizes;
            if (arguments !== value)
            {
                this._109453458sizes = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "sizes", arguments, value));
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

        public function set fractionDigits(value:uint) : void
        {
            arguments = this.fractionDigits;
            if (arguments !== value)
            {
                this._1952600456fractionDigits = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fractionDigits", arguments, value));
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

        public function set weights(value:Array) : void
        {
            arguments = this.weights;
            if (arguments !== value)
            {
                this._1230441723weights = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "weights", arguments, value));
                }
            }
            return;
        }// end function

        public function set colors(value:Array) : void
        {
            arguments = this.colors;
            if (arguments !== value)
            {
                this._1354842768colors = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "colors", arguments, value));
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

        public function set alphas(value:Array) : void
        {
            arguments = this.alphas;
            if (arguments !== value)
            {
                this._1414759723alphas = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "alphas", arguments, value));
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

        static function get instance() : SimpleClusterSymbol
        {
            if (m_instance === null)
            {
                m_instance = new SimpleClusterSymbol;
            }
            return m_instance;
        }// end function

    }
}
