package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.utils.*;
    import flash.events.*;
    import mx.events.*;

    public class DatumTransform extends Object implements IEventDispatcher
    {
        private var _3651311wkid:Number;
        private var _117792wkt:String;
        private var _bindingEventDispatcher:EventDispatcher;

        public function DatumTransform()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            return;
        }// end function

        function toDatumTransform() : String
        {
            var _loc_1:String = "";
            if (!isNaN(this.wkid))
            {
                _loc_1 = String(this.wkid);
            }
            else if (this.wkt)
            {
                _loc_1 = JSONUtil.encode({wkt:this.wkt});
            }
            return _loc_1;
        }// end function

        public function get wkid() : Number
        {
            return this._3651311wkid;
        }// end function

        public function set wkid(value:Number) : void
        {
            arguments = this._3651311wkid;
            if (arguments !== value)
            {
                this._3651311wkid = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "wkid", arguments, value));
                }
            }
            return;
        }// end function

        public function get wkt() : String
        {
            return this._117792wkt;
        }// end function

        public function set wkt(value:String) : void
        {
            arguments = this._117792wkt;
            if (arguments !== value)
            {
                this._117792wkt = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "wkt", arguments, value));
                }
            }
            return;
        }// end function

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false) : void
        {
            this._bindingEventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._bindingEventDispatcher.dispatchEvent(event);
        }// end function

        public function hasEventListener(type:String) : Boolean
        {
            return this._bindingEventDispatcher.hasEventListener(type);
        }// end function

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
        {
            this._bindingEventDispatcher.removeEventListener(type, listener, useCapture);
            return;
        }// end function

        public function willTrigger(type:String) : Boolean
        {
            return this._bindingEventDispatcher.willTrigger(type);
        }// end function

    }
}
