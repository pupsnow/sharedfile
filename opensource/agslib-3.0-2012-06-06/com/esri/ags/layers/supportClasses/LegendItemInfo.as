package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.symbols.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class LegendItemInfo extends EventDispatcher
    {
        private var _887523944symbol:Symbol;
        private var _102727412label:String;
        private var _823812830values:Array;

        public function LegendItemInfo()
        {
            return;
        }// end function

        override public function toString() : String
        {
            return ObjectUtil.toString(this);
        }// end function

        public function get symbol() : Symbol
        {
            return this._887523944symbol;
        }// end function

        public function set symbol(value:Symbol) : void
        {
            arguments = this._887523944symbol;
            if (arguments !== value)
            {
                this._887523944symbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "symbol", arguments, value));
                }
            }
            return;
        }// end function

        public function get label() : String
        {
            return this._102727412label;
        }// end function

        public function set label(value:String) : void
        {
            arguments = this._102727412label;
            if (arguments !== value)
            {
                this._102727412label = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", arguments, value));
                }
            }
            return;
        }// end function

        public function get values() : Array
        {
            return this._823812830values;
        }// end function

        public function set values(value:Array) : void
        {
            arguments = this._823812830values;
            if (arguments !== value)
            {
                this._823812830values = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "values", arguments, value));
                }
            }
            return;
        }// end function

        static function toLegendItemInfo(obj:Object) : LegendItemInfo
        {
            var _loc_2:LegendItemInfo = null;
            if (obj)
            {
                _loc_2 = new LegendItemInfo;
                _loc_2.label = obj.label;
                _loc_2.symbol = new PictureMarkerSymbol();
                _loc_2.values = obj.values;
                if (!obj.imageData)
                {
                }
                if (obj.url)
                {
                    PictureMarkerSymbol(_loc_2.symbol).source = toPictureSource(obj);
                }
            }
            return _loc_2;
        }// end function

        private static function toPictureSource(obj:Object) : Object
        {
            var result:Object;
            var url:String;
            var base64Decoder:Base64Decoder;
            var obj:* = obj;
            var imageData:* = obj.imageData;
            url = obj.url;
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
