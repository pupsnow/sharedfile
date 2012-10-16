package com.esri.ags.skins.supportClasses
{
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import spark.layouts.supportClasses.*;

    public class AttachmentLayout extends LayoutBase
    {
        private var m_distance:Number = 80;
        private var m_index:Number = 0;
        private var m_layoutWidth:Number;
        private var m_offsetZ:Number = 200;
        private var m_totalWidth:Number;

        public function AttachmentLayout()
        {
            return;
        }// end function

        public function get distance() : Number
        {
            return this.m_distance;
        }// end function

        public function set distance(value:Number) : void
        {
            if (this.m_distance != value)
            {
                this.m_distance = value;
                this.invalidateTarget();
            }
            return;
        }// end function

        override public function getScrollPositionDeltaToElement(index:int) : Point
        {
            var _loc_2:* = (this.m_totalWidth - this.m_layoutWidth) / (target.numElements - 1) * index;
            return new Point(_loc_2, 0);
        }// end function

        public function get index() : Number
        {
            return this.m_index;
        }// end function

        private function set _100346066index(value:Number) : void
        {
            if (this.m_index != value)
            {
                this.m_index = value;
                this.invalidateTarget();
            }
            return;
        }// end function

        public function get offsetZ() : Number
        {
            return this.m_offsetZ;
        }// end function

        public function set offsetZ(value:Number) : void
        {
            if (this.m_offsetZ !== value)
            {
                this.m_offsetZ = value;
                this.invalidateTarget();
            }
            return;
        }// end function

        override public function updateDisplayList(width:Number, height:Number) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:ILayoutElement = null;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Matrix3D = null;
            if (target)
            {
            }
            if (target.numElements > 0)
            {
                _loc_3 = target.numElements;
                _loc_4 = Math.max(this.index, 0);
                this.m_totalWidth = width + (_loc_3 - 1) * this.distance;
                this.m_layoutWidth = width;
                target.setContentSize(this.m_totalWidth, height);
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    _loc_6 = useVirtualLayout ? (target.getVirtualElementAt(_loc_5)) : (target.getElementAt(_loc_5));
                    _loc_6.setLayoutBoundsSize(NaN, NaN, false);
                    _loc_7 = _loc_6.getPreferredBoundsWidth() * 0.5;
                    _loc_8 = _loc_6.getPreferredBoundsHeight() * 0.5;
                    _loc_9 = 0;
                    _loc_10 = this.distance * _loc_5 - target.horizontalScrollPosition;
                    _loc_11 = new Matrix3D();
                    _loc_11.appendTranslation(_loc_10 + width * 0.5 - _loc_7, height * 0.5 - _loc_8, _loc_9);
                    _loc_6.setLayoutMatrix3D(_loc_11, false);
                    _loc_5 = _loc_5 + 1;
                }
            }
            return;
        }// end function

        override public function updateScrollRect(w:Number, h:Number) : void
        {
            if (target)
            {
                if (clipAndEnableScrolling)
                {
                    target.scrollRect = new Rectangle(0, 0, w, h);
                }
                else
                {
                    target.scrollRect = null;
                }
            }
            return;
        }// end function

        protected function invalidateTarget() : void
        {
            if (target)
            {
                target.invalidateSize();
                target.invalidateDisplayList();
            }
            return;
        }// end function

        override protected function scrollPositionChanged() : void
        {
            if (target)
            {
                target.invalidateDisplayList();
            }
            return;
        }// end function

        public function set index(value:Number) : void
        {
            arguments = this.index;
            if (arguments !== value)
            {
                this._100346066index = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "index", arguments, value));
                }
            }
            return;
        }// end function

    }
}
