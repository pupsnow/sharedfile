package com.esri.ags.symbols
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.collections.*;
    import mx.events.*;

    public class CompositeSymbol extends Symbol
    {
        private var _symbols:ArrayCollection;

        public function CompositeSymbol(symbols:Object = null)
        {
            if (symbols)
            {
                this.symbols = symbols;
            }
            return;
        }// end function

        public function get symbols() : Object
        {
            if (this._symbols == null)
            {
                this._symbols = new ArrayCollection();
                this._symbols.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            return this._symbols;
        }// end function

        public function set symbols(value:Object) : void
        {
            var _loc_2:Array = null;
            if (this._symbols)
            {
                this._symbols.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            }
            if (value is Array)
            {
                this._symbols = new ArrayCollection(value as Array);
            }
            else if (value is ArrayCollection)
            {
                this._symbols = value as ArrayCollection;
            }
            else
            {
                _loc_2 = [];
                if (value != null)
                {
                    _loc_2.push(value);
                }
                this._symbols = new ArrayCollection(_loc_2);
            }
            this._symbols.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChangeHandler);
            dispatchEventChange();
            dispatchEvent(new Event("symbolsChange"));
            return;
        }// end function

        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map) : void
        {
            var boundingRectangle1:Rectangle;
            var count:Number;
            var numPictureMarkerSymbol:Number;
            var loadCompleteHandler:Function;
            var loadCompleteHandler2:Function;
            var k:int;
            var child:CompositeSymbolComponent;
            var symbol:Symbol;
            var drawSprite:Sprite;
            var loadPictureMarker:Boolean;
            var n:int;
            var dSprite:Sprite;
            var sprite:* = sprite;
            var geometry:* = geometry;
            var attributes:* = attributes;
            var map:* = map;
            loadCompleteHandler = function (event:PictureMarkerSymbolEvent) : void
            {
                event.target.removeEventListener(PictureMarkerSymbolEvent.COMPLETE, loadCompleteHandler);
                var _loc_3:* = count - 1;
                count = _loc_3;
                event.target.visible = true;
                if (count == 0)
                {
                    positionSprite(false);
                }
                return;
            }// end function
            ;
            loadCompleteHandler2 = function (event:PictureMarkerSymbolEvent) : void
            {
                event.target.removeEventListener(PictureMarkerSymbolEvent.COMPLETE, loadCompleteHandler2);
                var _loc_3:* = count - 1;
                count = _loc_3;
                if (count == 0)
                {
                    sprite.visible = true;
                    positionSprite(false);
                }
                return;
            }// end function
            ;
            var positionSprite:* = function (redrawSymbol:Boolean) : void
            {
                var _loc_4:Symbol = null;
                var _loc_5:Sprite = null;
                var _loc_6:Boolean = false;
                var _loc_7:int = 0;
                var _loc_8:Sprite = null;
                var _loc_2:* = new Rectangle();
                numPictureMarkerSymbol = 0;
                var _loc_3:int = 0;
                while (_loc_3 < _symbols.length)
                {
                    
                    _loc_4 = Symbol(_symbols.getItemAt(_loc_3));
                    _loc_5 = sprite.getChildAt(_loc_3) as CompositeSymbolComponent;
                    if (redrawSymbol)
                    {
                        if (_loc_4 is PictureMarkerSymbol)
                        {
                            _loc_6 = PictureMarkerSymbol(_loc_4).doNotLoad(map, _loc_5, geometry);
                            if (_loc_6)
                            {
                                var _loc_10:* = numPictureMarkerSymbol + 1;
                                numPictureMarkerSymbol = _loc_10;
                                count = numPictureMarkerSymbol;
                                sprite.visible = false;
                                _loc_5.addEventListener(PictureMarkerSymbolEvent.COMPLETE, loadCompleteHandler2, false, 0, false);
                                _loc_4.draw(_loc_5, geometry, attributes, map);
                            }
                            else
                            {
                                _loc_4.draw(_loc_5, geometry, attributes, map);
                                _loc_2 = _loc_2.union(_loc_5.getBounds(sprite));
                            }
                        }
                        else
                        {
                            _loc_4.draw(_loc_5, geometry, attributes, map);
                            _loc_2 = _loc_2.union(_loc_5.getBounds(sprite));
                        }
                    }
                    else if (sprite.visible)
                    {
                        _loc_2 = _loc_2.union(_loc_5.getBounds(sprite));
                    }
                    _loc_3 = _loc_3 + 1;
                }
                if (numPictureMarkerSymbol == 0)
                {
                    sprite.x = _loc_2.x;
                    sprite.y = _loc_2.y;
                    sprite.width = _loc_2.width;
                    sprite.height = _loc_2.height;
                    _loc_7 = 0;
                    while (_loc_7 < sprite.numChildren)
                    {
                        
                        _loc_8 = sprite.getChildAt(_loc_7) as Sprite;
                        _loc_8.x = _loc_8.x - sprite.x;
                        _loc_8.y = _loc_8.y - sprite.y;
                        _loc_7 = _loc_7 + 1;
                    }
                }
                return;
            }// end function
            ;
            if (!geometry)
            {
                return;
            }
            count;
            numPictureMarkerSymbol;
            if (this._symbols)
            {
            }
            if (sprite.numChildren != this._symbols.length)
            {
                removeAllChildren(sprite);
            }
            else if (this._symbols)
            {
                k;
                while (k < this._symbols.length)
                {
                    
                    child = sprite.getChildAt(k) as CompositeSymbolComponent;
                    if (child.symbol !== this._symbols[k])
                    {
                        removeAllChildren(sprite);
                        break;
                    }
                    k = (k + 1);
                }
            }
            if (sprite.numChildren == 0)
            {
                if (this._symbols)
                {
                    boundingRectangle1 = new Rectangle();
                    var _loc_6:int = 0;
                    var _loc_7:* = this._symbols;
                    while (_loc_7 in _loc_6)
                    {
                        
                        symbol = _loc_7[_loc_6];
                        drawSprite = new CompositeSymbolComponent();
                        CompositeSymbolComponent(drawSprite).symbol = symbol;
                        sprite.addChild(drawSprite);
                        if (symbol is PictureMarkerSymbol)
                        {
                            loadPictureMarker = PictureMarkerSymbol(symbol).doNotLoad(map, drawSprite, geometry);
                            if (loadPictureMarker)
                            {
                                numPictureMarkerSymbol = (numPictureMarkerSymbol + 1);
                                count = numPictureMarkerSymbol;
                                drawSprite.visible = false;
                                drawSprite.addEventListener(PictureMarkerSymbolEvent.COMPLETE, loadCompleteHandler, false, 0, true);
                                symbol.draw(drawSprite, geometry, attributes, map);
                            }
                            else
                            {
                                symbol.draw(drawSprite, geometry, attributes, map);
                                boundingRectangle1 = boundingRectangle1.union(drawSprite.getBounds(sprite));
                            }
                            continue;
                        }
                        symbol.draw(drawSprite, geometry, attributes, map);
                        boundingRectangle1 = boundingRectangle1.union(drawSprite.getBounds(sprite));
                    }
                    if (numPictureMarkerSymbol == 0)
                    {
                        sprite.x = boundingRectangle1.x;
                        sprite.y = boundingRectangle1.y;
                        sprite.width = boundingRectangle1.width;
                        sprite.height = boundingRectangle1.height;
                        while (n < sprite.numChildren)
                        {
                            
                            dSprite = sprite.getChildAt(n) as Sprite;
                            dSprite.x = dSprite.x - sprite.x;
                            dSprite.y = dSprite.y - sprite.y;
                            n = (n + 1);
                        }
                    }
                }
            }
            else
            {
                if (this._symbols)
                {
                }
                if (sprite.numChildren == this._symbols.length)
                {
                    this.positionSprite(true);
                }
            }
            return;
        }// end function

        override public function clear(sprite:Sprite) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Symbol = null;
            if (this._symbols)
            {
            }
            if (sprite.numChildren == this._symbols.length)
            {
                _loc_2 = 0;
                while (_loc_2 < this._symbols.length)
                {
                    
                    _loc_3 = Symbol(this._symbols.getItemAt(_loc_2));
                    _loc_3.clear(Sprite(sprite.getChildAt(_loc_2)));
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        override public function destroy(sprite:Sprite) : void
        {
            removeAllChildren(sprite);
            sprite.x = 0;
            sprite.y = 0;
            return;
        }// end function

        protected function collectionChangeHandler(event:CollectionEvent) : void
        {
            dispatchEventChange();
            return;
        }// end function

    }
}
