package com.esri.ags
{
    import com.esri.ags.clusterers.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import mx.utils.*;

    public class Graphic extends UIComponent implements IJSONSupport
    {
        private var _lastSymbol:Symbol;
        private var _invalidateGraphicFlag:Boolean = false;
        var source:Object;
        var clusterGraphic:ClusterGraphic;
        private var _attributes:Object;
        private var _checkForMouseListeners:Boolean = true;
        private var _geometry:Geometry;
        private var _graphicsLayer:GraphicsLayer;
        private var _infoWindowRendererFactory:IFactory;
        private var _symbol:Symbol;

        public function Graphic(geometry:Geometry = null, symbol:Symbol = null, attributes:Object = null)
        {
            this._lastSymbol = NoopSymbol.instance;
            this.geometry = geometry;
            this.symbol = symbol;
            this.attributes = attributes;
            this.addEventListener(FlexEvent.SHOW, this.showHandler);
            this.addEventListener(Event.ADDED, this.addedHandler);
            this.addEventListener(Event.REMOVED, this.removedHandler);
            return;
        }// end function

        public function get attributes() : Object
        {
            return this._attributes;
        }// end function

        public function set attributes(value:Object) : void
        {
            if (this._attributes is IEventDispatcher)
            {
                IEventDispatcher(this._attributes).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.attributes_changeHandler);
            }
            this._attributes = value;
            if (this._attributes is IEventDispatcher)
            {
                IEventDispatcher(this._attributes).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.attributes_changeHandler, false, 0, true);
            }
            this.dispatchChangeEvent();
            this.invalidateGraphic();
            return;
        }// end function

        public function get checkForMouseListeners() : Boolean
        {
            return this._checkForMouseListeners;
        }// end function

        private function set _1781723163checkForMouseListeners(value:Boolean) : void
        {
            this._checkForMouseListeners = value;
            return;
        }// end function

        public function get geometry() : Geometry
        {
            return this._geometry;
        }// end function

        public function set geometry(value:Geometry) : void
        {
            if (this._geometry is IEventDispatcher)
            {
                IEventDispatcher(this._geometry).removeEventListener(Event.CHANGE, this.geometry_changeHandler);
            }
            this._geometry = value;
            if (this._geometry is IEventDispatcher)
            {
                IEventDispatcher(this._geometry).addEventListener(Event.CHANGE, this.geometry_changeHandler, false, 0, true);
            }
            this.dispatchChangeEvent();
            this.invalidateGraphic();
            return;
        }// end function

        public function get graphicsLayer() : GraphicsLayer
        {
            if (!this._graphicsLayer)
            {
            }
            if (this.clusterGraphic)
            {
                this._graphicsLayer = this.clusterGraphic.graphicsLayer;
            }
            return this._graphicsLayer;
        }// end function

        function setGraphicsLayer(value:GraphicsLayer) : void
        {
            this._graphicsLayer = value;
            return;
        }// end function

        public function get infoWindowRenderer() : IFactory
        {
            return this._infoWindowRendererFactory;
        }// end function

        private function set _354420447infoWindowRenderer(value:IFactory) : void
        {
            this._infoWindowRendererFactory = value;
            return;
        }// end function

        public function get symbol() : Symbol
        {
            return this._symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            if (this._symbol)
            {
                this._symbol.removeEventListener(Event.CHANGE, this.symbol_changeHandler);
            }
            this._symbol = value;
            if (this._symbol)
            {
                this._symbol.addEventListener(Event.CHANGE, this.symbol_changeHandler, false, 0, true);
            }
            this.dispatchChangeEvent();
            this.invalidateGraphic();
            return;
        }// end function

        function get $visible() : Boolean
        {
            return super.visible;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:Map = null;
            super.commitProperties();
            if (this._invalidateGraphicFlag)
            {
            }
            if (visible)
            {
            }
            if (parent)
            {
            }
            if (parent.visible)
            {
            }
            if (this._graphicsLayer)
            {
                this._invalidateGraphicFlag = false;
                _loc_1 = this._graphicsLayer.map;
                if (_loc_1)
                {
                }
                if (_loc_1.loaded)
                {
                }
                if (!_loc_1.isTweening)
                {
                }
                if (!_loc_1.isResizing)
                {
                    this.drawWithSymbol(this.getActiveSymbol(this._graphicsLayer), _loc_1);
                }
            }
            return;
        }// end function

        function getActiveSymbol(layer:GraphicsLayer) : Symbol
        {
            var _loc_2:Symbol = null;
            if (this._geometry)
            {
            }
            if (this._symbol)
            {
                return this._symbol;
            }
            if (layer)
            {
                if (layer.renderer)
                {
                    _loc_2 = layer.renderer.getSymbol(this);
                    return _loc_2 ? (_loc_2) : (NoopSymbol.instance);
                }
                if (layer.symbol)
                {
                    return layer.symbol;
                }
            }
            return this._geometry ? (this._geometry.defaultSymbol) : (NoopSymbol.instance);
        }// end function

        function drawWithSymbol(symbol:Symbol, map:Map) : void
        {
            if (this._lastSymbol !== symbol)
            {
                this._lastSymbol.destroy(this);
                this._lastSymbol = symbol;
                this._lastSymbol.initialize(this, this.geometry, this.attributes, map);
            }
            symbol.clear(this);
            symbol.draw(this, this.geometry, this.attributes, map);
            return;
        }// end function

        public function refresh() : void
        {
            this.invalidateGraphic();
            return;
        }// end function

        function invalidateGraphic() : void
        {
            this._invalidateGraphicFlag = true;
            invalidateProperties();
            return;
        }// end function

        private function dispatchChangeEvent() : void
        {
            dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (this.attributes)
            {
                _loc_2.attributes = ObjectUtil.copy(this.attributes);
            }
            if (this.geometry)
            {
                _loc_2.geometry = this.geometry.toJSON();
            }
            return _loc_2;
        }// end function

        function toText() : String
        {
            var _loc_3:String = null;
            var _loc_1:String = "";
            if (this.geometry)
            {
                _loc_1 = _loc_1 + ("geometry:" + this.geometry);
            }
            var _loc_2:String = "";
            for (_loc_3 in this.attributes)
            {
                
                if (_loc_2.length > 0)
                {
                    _loc_2 = _loc_2 + ",";
                }
                _loc_2 = _loc_2 + (_loc_3 + "=" + this.attributes[_loc_3]);
            }
            if (_loc_2.length > 0)
            {
                if (_loc_1.length > 0)
                {
                    _loc_1 = _loc_1 + ",";
                }
                _loc_1 = _loc_1 + ("attributes:" + _loc_2);
            }
            return "Graphic[" + _loc_1 + "]";
        }// end function

        private function showHandler(event:FlexEvent) : void
        {
            this.invalidateGraphic();
            return;
        }// end function

        protected function addedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                this._graphicsLayer = parent as GraphicsLayer;
                this.invalidateGraphic();
            }
            return;
        }// end function

        protected function removedHandler(event:Event) : void
        {
            if (event.target === this)
            {
                if (this._graphicsLayer)
                {
                    this.getActiveSymbol(this._graphicsLayer).destroy(this);
                }
                if (this.clusterGraphic === null)
                {
                    this._graphicsLayer = null;
                }
            }
            return;
        }// end function

        function attributes_changeHandler(event:PropertyChangeEvent) : void
        {
            this.invalidateGraphic();
            return;
        }// end function

        function geometry_changeHandler(event:Event) : void
        {
            this.invalidateGraphic();
            return;
        }// end function

        function symbol_changeHandler(event:Event) : void
        {
            this.invalidateGraphic();
            return;
        }// end function

        public function set infoWindowRenderer(value:IFactory) : void
        {
            arguments = this.infoWindowRenderer;
            if (arguments !== value)
            {
                this._354420447infoWindowRenderer = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "infoWindowRenderer", arguments, value));
                }
            }
            return;
        }// end function

        public function set checkForMouseListeners(value:Boolean) : void
        {
            arguments = this.checkForMouseListeners;
            if (arguments !== value)
            {
                this._1781723163checkForMouseListeners = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "checkForMouseListeners", arguments, value));
                }
            }
            return;
        }// end function

        public static function fromJSON(obj:Object) : Graphic
        {
            var _loc_2:Graphic = null;
            if (obj)
            {
                _loc_2 = new Graphic;
                _loc_2.attributes = obj.attributes;
                _loc_2.geometry = Geometry.fromJSON(obj.geometry);
            }
            return _loc_2;
        }// end function

    }
}
