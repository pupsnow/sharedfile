package com.esri.ags.symbols
{
    import flash.text.*;
    import mx.utils.*;

    public class SymbolFactory extends Object
    {

        public function SymbolFactory()
        {
            return;
        }// end function

        public static function fromJSON(obj:Object) : Symbol
        {
            var _loc_2:Symbol = null;
            if (obj)
            {
                switch(obj.type)
                {
                    case "esriSMS":
                    {
                        _loc_2 = toSMS(obj);
                        break;
                    }
                    case "esriPMS":
                    {
                        _loc_2 = toPMS(obj);
                        break;
                    }
                    case "esriSLS":
                    {
                        _loc_2 = toSLS(obj);
                        break;
                    }
                    case "esriSFS":
                    {
                        _loc_2 = toSFS(obj);
                        break;
                    }
                    case "esriPFS":
                    {
                        _loc_2 = toPFS(obj);
                        break;
                    }
                    case "esriTS":
                    {
                        _loc_2 = toTS(obj);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        public static function toSMS(symObj:Object) : SimpleMarkerSymbol
        {
            var _loc_2:SimpleMarkerSymbol = null;
            if (symObj)
            {
                _loc_2 = new SimpleMarkerSymbol();
                if (symObj.color)
                {
                    _loc_2.alpha = symObj.color[3] / 255;
                    _loc_2.color = rgbToUint(symObj.color[0], symObj.color[1], symObj.color[2]);
                }
                if (symObj.angle is Number)
                {
                    _loc_2.angle = -symObj.angle;
                }
                _loc_2.outline = toSLS(symObj.outline);
                _loc_2.size = ptToPx(symObj.size);
                switch(symObj.style)
                {
                    case "esriSMSCircle":
                    {
                        _loc_2.style = SimpleMarkerSymbol.STYLE_CIRCLE;
                        break;
                    }
                    case "esriSMSSquare":
                    {
                        _loc_2.style = SimpleMarkerSymbol.STYLE_SQUARE;
                        break;
                    }
                    case "esriSMSDiamond":
                    {
                        _loc_2.style = SimpleMarkerSymbol.STYLE_DIAMOND;
                        break;
                    }
                    case "esriSMSCross":
                    {
                        _loc_2.style = SimpleMarkerSymbol.STYLE_CROSS;
                        break;
                    }
                    case "esriSMSX":
                    {
                        _loc_2.style = SimpleMarkerSymbol.STYLE_X;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_2.xoffset = ptToPx(symObj.xoffset);
                _loc_2.yoffset = ptToPx(symObj.yoffset);
                if (_loc_2.outline)
                {
                    if (_loc_2.style !== SimpleMarkerSymbol.STYLE_CROSS)
                    {
                    }
                }
                if (_loc_2.style === SimpleMarkerSymbol.STYLE_X)
                {
                    _loc_2.outline.width = Math.ceil(_loc_2.outline.width);
                }
            }
            return _loc_2;
        }// end function

        public static function toPMS(symObj:Object) : PictureMarkerSymbol
        {
            var _loc_2:PictureMarkerSymbol = null;
            if (symObj)
            {
                _loc_2 = new PictureMarkerSymbol();
                _loc_2.source = toPictureSource(symObj);
                if (symObj.angle is Number)
                {
                    _loc_2.angle = -symObj.angle;
                }
                _loc_2.width = ptToPx(symObj.width);
                _loc_2.height = ptToPx(symObj.height);
                _loc_2.xoffset = ptToPx(symObj.xoffset);
                _loc_2.yoffset = ptToPx(symObj.yoffset);
            }
            return _loc_2;
        }// end function

        public static function toSLS(symObj:Object) : SimpleLineSymbol
        {
            var _loc_2:SimpleLineSymbol = null;
            if (symObj)
            {
                _loc_2 = new SimpleLineSymbol();
                if (symObj.color)
                {
                    _loc_2.alpha = symObj.color[3] / 255;
                    _loc_2.color = rgbToUint(symObj.color[0], symObj.color[1], symObj.color[2]);
                    switch(symObj.style)
                    {
                        case "esriSLSSolid":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_SOLID;
                            break;
                        }
                        case "esriSLSDash":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_DASH;
                            break;
                        }
                        case "esriSLSDot":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_DOT;
                            break;
                        }
                        case "esriSLSDashDot":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_DASHDOT;
                            break;
                        }
                        case "esriSLSDashDotDot":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_DASHDOTDOT;
                            break;
                        }
                        case "esriSLSNull":
                        {
                            _loc_2.style = SimpleLineSymbol.STYLE_NULL;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                else
                {
                    _loc_2.style = SimpleLineSymbol.STYLE_NULL;
                }
                _loc_2.width = ptToPx(symObj.width);
            }
            return _loc_2;
        }// end function

        public static function toSFS(symObj:Object) : SimpleFillSymbol
        {
            var _loc_2:SimpleFillSymbol = null;
            if (symObj)
            {
                _loc_2 = new SimpleFillSymbol();
                if (symObj.color)
                {
                    _loc_2.alpha = symObj.color[3] / 255;
                    _loc_2.color = rgbToUint(symObj.color[0], symObj.color[1], symObj.color[2]);
                    switch(symObj.style)
                    {
                        case "esriSFSSolid":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_SOLID;
                            break;
                        }
                        case "esriSFSHorizontal":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_HORIZONTAL;
                            break;
                        }
                        case "esriSFSVertical":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_VERTICAL;
                            break;
                        }
                        case "esriSFSForwardDiagonal":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_FORWARD_DIAGONAL;
                            break;
                        }
                        case "esriSFSBackwardDiagonal":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_BACKWARD_DIAGONAL;
                            break;
                        }
                        case "esriSFSCross":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_CROSS;
                            break;
                        }
                        case "esriSFSDiagonalCross":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_DIAGONAL_CROSS;
                            break;
                        }
                        case "esriSFSNull":
                        {
                            _loc_2.style = SimpleFillSymbol.STYLE_NULL;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                else
                {
                    _loc_2.style = SimpleFillSymbol.STYLE_NULL;
                }
                _loc_2.outline = toSLS(symObj.outline);
            }
            return _loc_2;
        }// end function

        public static function toPFS(symObj:Object) : PictureFillSymbol
        {
            var _loc_2:PictureFillSymbol = null;
            if (symObj)
            {
                _loc_2 = new PictureFillSymbol();
                _loc_2.outline = toSLS(symObj.outline);
                _loc_2.height = ptToPx(symObj.height);
                _loc_2.width = ptToPx(symObj.width);
                _loc_2.xoffset = ptToPx(symObj.xoffset);
                _loc_2.yoffset = ptToPx(symObj.yoffset);
                _loc_2.xscale = symObj.xscale;
                _loc_2.yscale = symObj.yscale;
                _loc_2.source = toPictureSource(symObj);
                if (symObj.angle is Number)
                {
                    _loc_2.angle = -symObj.angle;
                }
            }
            return _loc_2;
        }// end function

        public static function toTS(symObj:Object) : TextSymbol
        {
            var _loc_2:TextSymbol = null;
            var _loc_3:Object = null;
            var _loc_4:TextFormat = null;
            if (symObj)
            {
                _loc_2 = new TextSymbol();
                if (symObj.angle is Number)
                {
                    _loc_2.angle = -symObj.angle;
                }
                if (symObj.backgroundColor is Array)
                {
                    _loc_2.background = true;
                    _loc_2.backgroundColor = rgbToUint(symObj.backgroundColor[0], symObj.backgroundColor[1], symObj.backgroundColor[2]);
                }
                if (symObj.borderLineColor is Array)
                {
                    _loc_2.border = true;
                    _loc_2.borderColor = rgbToUint(symObj.borderLineColor[0], symObj.borderLineColor[1], symObj.borderLineColor[2]);
                }
                if (symObj.color is Array)
                {
                    _loc_2.alpha = symObj.color[3] / 255;
                    _loc_2.color = rgbToUint(symObj.color[0], symObj.color[1], symObj.color[2]);
                }
                if (symObj.xoffset is Number)
                {
                    _loc_2.xoffset = ptToPx(symObj.xoffset);
                }
                if (symObj.yoffset is Number)
                {
                    _loc_2.yoffset = ptToPx(symObj.yoffset);
                }
                if (symObj.font)
                {
                    _loc_3 = symObj.font;
                    _loc_4 = new TextFormat();
                    if (_loc_3.family)
                    {
                        _loc_4.font = _loc_3.family;
                    }
                    if (_loc_3.size is Number)
                    {
                        _loc_4.size = _loc_3.size;
                    }
                    if (_loc_3.decoration == "underline")
                    {
                        _loc_4.underline = true;
                    }
                    if (_loc_3.style == "italic")
                    {
                        _loc_4.italic = true;
                    }
                    if (_loc_3.weight == "bold")
                    {
                        _loc_4.bold = true;
                    }
                    _loc_2.textFormat = _loc_4;
                }
                _loc_2.textAttribute = "TEXT";
                _loc_2.placement = TextSymbol.PLACEMENT_START;
            }
            return _loc_2;
        }// end function

        static function rgbToUint(r:int, g:int, b:int) : uint
        {
            return r << 16 | g << 8 | b << 0;
        }// end function

        public static function colorAndAlphaToRGBA(color:uint, alpha:Number) : Array
        {
            return [color >> 16 & 255, color >> 8 & 255, color & 255, Math.round(alpha * 255)];
        }// end function

        static function ptToPx(pt:Number) : Number
        {
            return pt / 72 * 96;
        }// end function

        public static function pxToPt(px:Number) : Number
        {
            return px * 72 / 96;
        }// end function

        static function toPictureSource(symObj:Object) : Object
        {
            var result:Object;
            var url:String;
            var base64Decoder:Base64Decoder;
            var symObj:* = symObj;
            var imageData:* = symObj.imageData;
            url = symObj.url;
            if (imageData)
            {
                base64Decoder = new Base64Decoder();
                try
                {
                    base64Decoder.decode(imageData);
                    result = base64Decoder.toByteArray();
                }
                catch (error:Error)
                {
                    result = url;
                }
            }
            else
            {
                result = url;
            }
            return result;
        }// end function

    }
}
