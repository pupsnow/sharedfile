package com.esri.ags.clusterers.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.symbols.*;
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.events.*;

    public class FlareSymbol extends Symbol
    {
        private var m_size:Number = 30;
        private var m_haloColor:uint = 16777215;
        private var m_haloAlpha:Number = 0.01;
        private var m_backgroundColor:uint = 7786752;
        private var m_backgroundAlpha:Number = 1;
        private var m_borderThickness:Number = 1;
        private var m_borderColor:uint = 0;
        private var m_borderAlpha:Number = 1;
        private var m_flareMaxCount:int = 30;
        private var m_maxCountPerRing:int = 6;
        private var m_ringAngleStart:Number = 5;
        private var m_ringAngleInc:Number = 15;
        private var m_ringDistanceStart:Number = 30;
        private var m_ringDistanceInc:Number = 20;
        private var m_flareSize:Number = 5;
        private var m_flareSizeIncOnRollOver:Number = 2;
        private var m_textFormat:TextFormat;
        private var m_fractionDigits:uint = 0;
        private var m_weights:Array;
        private var m_backgroundColors:Array;
        private var m_backgroundAlphas:Array;
        private var m_sizes:Array;
        var m_textFunction:Function;
        private static const EXTENT:Extent = new Extent();
        private static var m_instance:FlareSymbol;

        public function FlareSymbol()
        {
            this.m_textFunction = this.textFunctionPrivate;
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

        public function get backgroundColors() : Array
        {
            return this.m_backgroundColors;
        }// end function

        private function set _1246159934backgroundColors(value:Array) : void
        {
            if (this.m_backgroundColors !== value)
            {
                this.m_backgroundColors = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get backgroundAlphas() : Array
        {
            return this.m_backgroundAlphas;
        }// end function

        private function set _1186242979backgroundAlphas(value:Array) : void
        {
            if (this.m_backgroundAlphas !== value)
            {
                this.m_backgroundAlphas = value;
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

        public function get flareMaxCount() : int
        {
            return this.m_flareMaxCount;
        }// end function

        private function set _337846265flareMaxCount(value:int) : void
        {
            if (this.m_flareMaxCount !== value)
            {
                this.m_flareMaxCount = value;
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

        public function get haloColor() : uint
        {
            return this.m_haloColor;
        }// end function

        private function set _1433516921haloColor(value:uint) : void
        {
            if (this.m_haloColor !== value)
            {
                this.m_haloColor = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get haloAlpha() : Number
        {
            return this.m_haloAlpha;
        }// end function

        private function set _1435449726haloAlpha(value:Number) : void
        {
            if (this.m_haloAlpha !== value)
            {
                this.m_haloAlpha = Math.max(0.01, value);
                dispatchEventChange();
            }
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            sprite.x = 0;
            sprite.y = 0;
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
                    this.drawMapPoint(sprite, _loc_6, _loc_5, map);
                }
            }
            return;
        }// end function

        private function drawWrapAround(sprite:Sprite, origPoint:MapPoint, clusterGraphic:ClusterGraphic, map:Map) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:MapPoint = null;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_5:* = map.toScreenX(origPoint.x);
            var _loc_6:* = map.toScreenY(origPoint.y);
            var _loc_13:* = origPoint.x;
            EXTENT.xmax = origPoint.x;
            EXTENT.xmin = _loc_13;
            var _loc_13:* = origPoint.y;
            EXTENT.ymax = origPoint.y;
            EXTENT.ymin = _loc_13;
            EXTENT.spatialReference = map.spatialReference;
            origPoint.spatialReference = map.spatialReference;
            var _loc_7:* = GeomUtils.intersects(map, origPoint, EXTENT);
            var _loc_8:Array = [];
            for each (_loc_9 in _loc_7)
            {
                
                _loc_11 = map.toMapX(_loc_5 + _loc_9);
                _loc_12 = map.toMapY(_loc_6);
                if (map.extent.containsXY(_loc_11, _loc_12))
                {
                    _loc_8.push(new MapPoint(_loc_11, _loc_12));
                }
            }
            for each (_loc_10 in _loc_8)
            {
                
                this.drawMapPoint(sprite, _loc_10, clusterGraphic, map);
            }
            return;
        }// end function

        private function drawMapPoint(sprite:Sprite, mapPoint:MapPoint, clusterGraphic:ClusterGraphic, map:Map) : void
        {
            var _loc_5:* = new FlareContainer();
            _loc_5.x = toScreenX(map, mapPoint.x);
            _loc_5.y = toScreenY(map, mapPoint.y);
            _loc_5.init(this, clusterGraphic.cluster);
            sprite.addChild(_loc_5);
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            removeAllChildren(sprite);
            return;
        }// end function

        public function get maxCountPerRing() : int
        {
            return this.m_maxCountPerRing;
        }// end function

        private function set _549288862maxCountPerRing(value:int) : void
        {
            if (this.m_maxCountPerRing !== value)
            {
                this.m_maxCountPerRing = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get ringAngleStart() : Number
        {
            return this.m_ringAngleStart;
        }// end function

        private function set _683880863ringAngleStart(value:Number) : void
        {
            if (this.m_ringAngleStart !== value)
            {
                this.m_ringAngleStart = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get ringAngleInc() : Number
        {
            return this.m_ringAngleInc;
        }// end function

        private function set _285331365ringAngleInc(value:Number) : void
        {
            if (this.m_ringAngleInc !== value)
            {
                this.m_ringAngleInc = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get ringDistanceStart() : Number
        {
            return this.m_ringDistanceStart;
        }// end function

        private function set _91992803ringDistanceStart(value:Number) : void
        {
            if (this.m_ringDistanceStart !== value)
            {
                this.m_ringDistanceStart = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get ringDistanceInc() : Number
        {
            return this.m_ringDistanceInc;
        }// end function

        private function set _1957434201ringDistanceInc(value:Number) : void
        {
            if (this.m_ringDistanceInc !== value)
            {
                this.m_ringDistanceInc = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get flareSize() : Number
        {
            return this.m_flareSize;
        }// end function

        private function set _1178686225flareSize(value:Number) : void
        {
            if (this.m_flareSize !== value)
            {
                this.m_flareSize = value;
                dispatchEventChange();
            }
            return;
        }// end function

        public function get flareSizeIncOnRollOver() : Number
        {
            return this.m_flareSizeIncOnRollOver;
        }// end function

        private function set _1595130815flareSizeIncOnRollOver(value:Number) : void
        {
            if (this.m_flareSizeIncOnRollOver !== value)
            {
                this.m_flareSizeIncOnRollOver = value;
                dispatchEventChange();
            }
            return;
        }// end function

        private function textFunctionPrivate(cluster:Cluster) : String
        {
            return cluster.weight.toFixed(this.fractionDigits);
        }// end function

        public function get textFunction() : Function
        {
            return this.m_textFunction === this.textFunctionPrivate ? (null) : (this.m_textFunction);
        }// end function

        public function set textFunction(value:Function) : void
        {
            if (!value)
            {
            }
            this.m_textFunction = this.textFunctionPrivate;
            return;
        }// end function

        override public function createSwatch(width:Number = 50, height:Number = 50, featureTemplateTool:String = null) : UIComponent
        {
            var _loc_4:* = new UIComponent();
            _loc_4.width = width;
            _loc_4.height = height;
            var _loc_5:* = Math.min(width, height) * 0.5;
            if (this.borderThickness > 0)
            {
                _loc_4.graphics.lineStyle(this.borderThickness, this.borderColor, this.borderAlpha);
            }
            _loc_4.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
            _loc_4.graphics.drawCircle(width * 0.5, height * 0.5, _loc_5);
            _loc_4.graphics.endFill();
            return _loc_4;
        }// end function

        public function set ringAngleInc(value:Number) : void
        {
            arguments = this.ringAngleInc;
            if (arguments !== value)
            {
                this._285331365ringAngleInc = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ringAngleInc", arguments, value));
                }
            }
            return;
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

        public function set ringDistanceInc(value:Number) : void
        {
            arguments = this.ringDistanceInc;
            if (arguments !== value)
            {
                this._1957434201ringDistanceInc = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ringDistanceInc", arguments, value));
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

        public function set haloColor(value:uint) : void
        {
            arguments = this.haloColor;
            if (arguments !== value)
            {
                this._1433516921haloColor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "haloColor", arguments, value));
                }
            }
            return;
        }// end function

        public function set flareSizeIncOnRollOver(value:Number) : void
        {
            arguments = this.flareSizeIncOnRollOver;
            if (arguments !== value)
            {
                this._1595130815flareSizeIncOnRollOver = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "flareSizeIncOnRollOver", arguments, value));
                }
            }
            return;
        }// end function

        public function set ringDistanceStart(value:Number) : void
        {
            arguments = this.ringDistanceStart;
            if (arguments !== value)
            {
                this._91992803ringDistanceStart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ringDistanceStart", arguments, value));
                }
            }
            return;
        }// end function

        public function set ringAngleStart(value:Number) : void
        {
            arguments = this.ringAngleStart;
            if (arguments !== value)
            {
                this._683880863ringAngleStart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ringAngleStart", arguments, value));
                }
            }
            return;
        }// end function

        public function set haloAlpha(value:Number) : void
        {
            arguments = this.haloAlpha;
            if (arguments !== value)
            {
                this._1435449726haloAlpha = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "haloAlpha", arguments, value));
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

        public function set flareSize(value:Number) : void
        {
            arguments = this.flareSize;
            if (arguments !== value)
            {
                this._1178686225flareSize = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "flareSize", arguments, value));
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

        public function set backgroundColors(value:Array) : void
        {
            arguments = this.backgroundColors;
            if (arguments !== value)
            {
                this._1246159934backgroundColors = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundColors", arguments, value));
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

        public function set backgroundAlphas(value:Array) : void
        {
            arguments = this.backgroundAlphas;
            if (arguments !== value)
            {
                this._1186242979backgroundAlphas = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundAlphas", arguments, value));
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

        public function set flareMaxCount(value:int) : void
        {
            arguments = this.flareMaxCount;
            if (arguments !== value)
            {
                this._337846265flareMaxCount = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "flareMaxCount", arguments, value));
                }
            }
            return;
        }// end function

        public function set maxCountPerRing(value:int) : void
        {
            arguments = this.maxCountPerRing;
            if (arguments !== value)
            {
                this._549288862maxCountPerRing = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxCountPerRing", arguments, value));
                }
            }
            return;
        }// end function

        static function get instance() : FlareSymbol
        {
            if (m_instance === null)
            {
                m_instance = new FlareSymbol;
            }
            return m_instance;
        }// end function

    }
}
