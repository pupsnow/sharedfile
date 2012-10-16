package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.symbols.*;
    import flash.events.*;

    public class LabelOptions extends EventDispatcher implements IJSONSupport
    {
        private var _alpha:Number = 1;
        private var _backgroundAlpha:Number = 1;
        private var _backgroundColor:Number;
        private var _borderLineAlpha:Number = 1;
        private var _borderLineColor:Number;
        private var _borderLineSize:Number = 1;
        private var _color:uint;
        private var _fontDecoration:String = "none";
        private var _fontFamily:String = "Arial";
        private var _fontSize:Number = 12;
        private var _fontStyle:String = "normal";
        private var _fontWeight:String = "normal";
        private var _haloAlpha:Number = 0.5;
        private var _haloColor:Number;
        private var _haloSize:Number = 1;
        private var _horizontalAlignment:String = "center";
        private var _kerning:Boolean = true;
        private var _rightToLeft:Boolean;
        private var _verticalAlignment:String = "baseline";
        private var _xoffset:Number = 0;
        private var _yoffset:Number = 0;

        public function LabelOptions()
        {
            return;
        }// end function

        public function get alpha() : Number
        {
            return this._alpha;
        }// end function

        public function set alpha(value:Number) : void
        {
            if (this._alpha !== value)
            {
                this._alpha = value;
                dispatchEvent(new Event("alphaChanged"));
            }
            return;
        }// end function

        public function get backgroundAlpha() : Number
        {
            return this._backgroundAlpha;
        }// end function

        public function set backgroundAlpha(value:Number) : void
        {
            if (this._backgroundAlpha !== value)
            {
                this._backgroundAlpha = value;
                dispatchEvent(new Event("backgroundAlphaChanged"));
            }
            return;
        }// end function

        public function get backgroundColor() : Number
        {
            return this._backgroundColor;
        }// end function

        public function set backgroundColor(value:Number) : void
        {
            if (this._backgroundColor !== value)
            {
                this._backgroundColor = value;
                dispatchEvent(new Event("backgroundColorChanged"));
            }
            return;
        }// end function

        public function get borderLineAlpha() : Number
        {
            return this._borderLineAlpha;
        }// end function

        public function set borderLineAlpha(value:Number) : void
        {
            if (this._borderLineAlpha !== value)
            {
                this._borderLineAlpha = value;
                dispatchEvent(new Event("borderLineAlphaChanged"));
            }
            return;
        }// end function

        public function get borderLineColor() : Number
        {
            return this._borderLineColor;
        }// end function

        public function set borderLineColor(value:Number) : void
        {
            if (this._borderLineColor !== value)
            {
                this._borderLineColor = value;
                dispatchEvent(new Event("borderLineColorChanged"));
            }
            return;
        }// end function

        public function get borderLineSize() : Number
        {
            return this._borderLineSize;
        }// end function

        public function set borderLineSize(value:Number) : void
        {
            if (this._borderLineSize !== value)
            {
                this._borderLineSize = value;
                dispatchEvent(new Event("borderLineSizeChanged"));
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this._color;
        }// end function

        public function set color(value:uint) : void
        {
            if (this._color !== value)
            {
                this._color = value;
                dispatchEvent(new Event("colorChanged"));
            }
            return;
        }// end function

        public function get fontDecoration() : String
        {
            return this._fontDecoration;
        }// end function

        public function set fontDecoration(value:String) : void
        {
            if (this._fontDecoration !== value)
            {
                this._fontDecoration = value;
                dispatchEvent(new Event("fontDecorationChanged"));
            }
            return;
        }// end function

        public function get fontFamily() : String
        {
            return this._fontFamily;
        }// end function

        public function set fontFamily(value:String) : void
        {
            if (this._fontFamily !== value)
            {
                this._fontFamily = value;
                dispatchEvent(new Event("fontFamilyChanged"));
            }
            return;
        }// end function

        public function get fontSize() : Number
        {
            return this._fontSize;
        }// end function

        public function set fontSize(value:Number) : void
        {
            if (this._fontSize !== value)
            {
                this._fontSize = value;
                dispatchEvent(new Event("fontSizeChanged"));
            }
            return;
        }// end function

        public function get fontStyle() : String
        {
            return this._fontStyle;
        }// end function

        public function set fontStyle(value:String) : void
        {
            if (this._fontStyle !== value)
            {
                this._fontStyle = value;
                dispatchEvent(new Event("fontStyleChanged"));
            }
            return;
        }// end function

        public function get fontWeight() : String
        {
            return this._fontWeight;
        }// end function

        public function set fontWeight(value:String) : void
        {
            if (this._fontWeight !== value)
            {
                this._fontWeight = value;
                dispatchEvent(new Event("fontWeightChanged"));
            }
            return;
        }// end function

        public function get haloAlpha() : Number
        {
            return this._haloAlpha;
        }// end function

        public function set haloAlpha(value:Number) : void
        {
            if (this._haloAlpha !== value)
            {
                this._haloAlpha = value;
                dispatchEvent(new Event("haloAlphaChanged"));
            }
            return;
        }// end function

        public function get haloColor() : Number
        {
            return this._haloColor;
        }// end function

        public function set haloColor(value:Number) : void
        {
            if (this._haloColor !== value)
            {
                this._haloColor = value;
                dispatchEvent(new Event("haloColorChanged"));
            }
            return;
        }// end function

        public function get haloSize() : Number
        {
            return this._haloSize;
        }// end function

        public function set haloSize(value:Number) : void
        {
            if (this._haloSize !== value)
            {
                this._haloSize = value;
                dispatchEvent(new Event("haloSizeChanged"));
            }
            return;
        }// end function

        public function get horizontalAlignment() : String
        {
            return this._horizontalAlignment;
        }// end function

        public function set horizontalAlignment(value:String) : void
        {
            if (this._horizontalAlignment !== value)
            {
                this._horizontalAlignment = value;
                dispatchEvent(new Event("horizontalAlignmentChanged"));
            }
            return;
        }// end function

        public function get kerning() : Boolean
        {
            return this._kerning;
        }// end function

        public function set kerning(value:Boolean) : void
        {
            if (this._kerning !== value)
            {
                this._kerning = value;
                dispatchEvent(new Event("kerningChanged"));
            }
            return;
        }// end function

        public function get rightToLeft() : Boolean
        {
            return this._rightToLeft;
        }// end function

        public function set rightToLeft(value:Boolean) : void
        {
            if (this._rightToLeft !== value)
            {
                this._rightToLeft = value;
                dispatchEvent(new Event("rightToLeftChanged"));
            }
            return;
        }// end function

        public function get verticalAlignment() : String
        {
            return this._verticalAlignment;
        }// end function

        public function set verticalAlignment(value:String) : void
        {
            if (this._verticalAlignment !== value)
            {
                this._verticalAlignment = value;
                dispatchEvent(new Event("verticalAlignmentChanged"));
            }
            return;
        }// end function

        public function get xoffset() : Number
        {
            return this._xoffset;
        }// end function

        public function set xoffset(value:Number) : void
        {
            if (this._xoffset !== value)
            {
                this._xoffset = value;
                dispatchEvent(new Event("xoffsetChanged"));
            }
            return;
        }// end function

        public function get yoffset() : Number
        {
            return this._yoffset;
        }// end function

        public function set yoffset(value:Number) : void
        {
            if (this._yoffset !== value)
            {
                this._yoffset = value;
                dispatchEvent(new Event("yoffsetChanged"));
            }
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"esriTS"};
            var _loc_3:* = isFinite(this.alpha) ? (this.alpha) : (1);
            _loc_2.color = SymbolFactory.colorAndAlphaToRGBA(this.color, _loc_3);
            if (this.backgroundColor >= 0)
            {
                _loc_3 = isFinite(this.backgroundAlpha) ? (this.backgroundAlpha) : (1);
                _loc_2.backgroundColor = SymbolFactory.colorAndAlphaToRGBA(this.backgroundColor, _loc_3);
            }
            if (this.borderLineColor >= 0)
            {
            }
            if (this.borderLineSize > 0)
            {
                _loc_3 = isFinite(this.borderLineAlpha) ? (this.borderLineAlpha) : (1);
                _loc_2.borderLineColor = SymbolFactory.colorAndAlphaToRGBA(this.borderLineColor, _loc_3);
                _loc_2.borderLineSize = SymbolFactory.pxToPt(this.borderLineSize);
            }
            if (this.haloColor >= 0)
            {
            }
            if (this.haloSize > 0)
            {
                _loc_3 = isFinite(this.haloAlpha) ? (this.haloAlpha) : (1);
                _loc_2.haloColor = SymbolFactory.colorAndAlphaToRGBA(this.haloColor, _loc_3);
                _loc_2.haloSize = SymbolFactory.pxToPt(this.haloSize);
            }
            if (this.horizontalAlignment)
            {
                _loc_2.horizontalAlignment = this.horizontalAlignment;
            }
            _loc_2.kerning = this.kerning;
            _loc_2.rightToLeft = this.rightToLeft;
            if (this.verticalAlignment)
            {
                _loc_2.verticalAlignment = this.verticalAlignment;
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
            var _loc_4:Object = {};
            if (this.fontDecoration)
            {
                _loc_4.decoration = this.fontDecoration;
            }
            if (this.fontFamily)
            {
                _loc_4.family = this.fontFamily;
            }
            if (this.fontSize > 0)
            {
                _loc_4.size = SymbolFactory.pxToPt(this.fontSize);
            }
            if (this.fontStyle)
            {
                _loc_4.style = this.fontStyle;
            }
            if (this.fontWeight)
            {
                _loc_4.weight = this.fontWeight;
            }
            _loc_2.font = _loc_4;
            return _loc_2;
        }// end function

    }
}
