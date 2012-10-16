package com.esri.ags.handlers
{
    import com.esri.ags.*;
    import flash.events.*;
    import flash.ui.*;

    public class KeyboardHandler extends Object
    {
        private var m_map:Map;
        private var m_enabled:Boolean = false;

        public function KeyboardHandler(map:Map)
        {
            this.m_map = map;
            return;
        }// end function

        public function enable() : void
        {
            if (this.m_enabled)
            {
                return;
            }
            this.m_map.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.m_enabled = true;
            return;
        }// end function

        public function disable() : void
        {
            this.m_map.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.m_enabled = false;
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (!this.m_map.extent)
            {
                return;
            }
            switch(event.keyCode)
            {
                case Keyboard.NUMPAD_ADD:
                case 187:
                {
                    this.m_map.zoomIn();
                    break;
                }
                case Keyboard.NUMPAD_SUBTRACT:
                case 189:
                {
                    this.m_map.zoomOut();
                    break;
                }
                case Keyboard.LEFT:
                case Keyboard.NUMPAD_4:
                {
                    this.m_map.panLeft();
                    break;
                }
                case Keyboard.RIGHT:
                case Keyboard.NUMPAD_6:
                {
                    this.m_map.panRight();
                    break;
                }
                case Keyboard.UP:
                case Keyboard.NUMPAD_8:
                {
                    this.m_map.panUp();
                    break;
                }
                case Keyboard.DOWN:
                case Keyboard.NUMPAD_2:
                {
                    this.m_map.panDown();
                    break;
                }
                case Keyboard.PAGE_UP:
                case Keyboard.NUMPAD_9:
                {
                    this.m_map.panUpperRight();
                    break;
                }
                case Keyboard.PAGE_DOWN:
                case Keyboard.NUMPAD_3:
                {
                    this.m_map.panLowerRight();
                    break;
                }
                case Keyboard.END:
                case Keyboard.NUMPAD_1:
                {
                    this.m_map.panLowerLeft();
                    break;
                }
                case Keyboard.HOME:
                case Keyboard.NUMPAD_7:
                {
                    this.m_map.panUpperLeft();
                    break;
                }
                case 70:
                {
                    this.m_map.zoomToInitialExtent();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
