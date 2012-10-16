package com.esri.ags.components.supportClasses
{
    import com.esri.ags.skins.supportClasses.*;
    import flash.events.*;
    import mx.core.*;
    import mx.events.*;
    import mx.managers.*;
    import spark.components.*;

    final public class MemoButton extends Button
    {
        private var m_memoWindow:MemoWindow;
        private var m_memoArea:MemoArea;
        private var m_memoWindowTitle:String;
        private static var _skinParts:Object = {iconDisplay:false, labelDisplay:false};

        public function MemoButton(memoArea:MemoArea, memoWindowTitle:String)
        {
            label = resourceManager.getString("ESRIMessages", "memoButtonEdit") + "...";
            this.m_memoArea = memoArea;
            this.m_memoWindowTitle = memoWindowTitle;
            return;
        }// end function

        override protected function clickHandler(event:MouseEvent) : void
        {
            super.clickHandler(event);
            this.m_memoWindow = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as Application, MemoWindow, true) as MemoWindow;
            this.m_memoWindow.title = this.m_memoWindowTitle;
            this.m_memoWindow.richTextEditor.htmlText = this.m_memoArea.htmlText;
            PopUpManager.centerPopUp(this.m_memoWindow);
            this.m_memoWindow.addEventListener(Event.COMPLETE, this.completeHandler);
            this.m_memoWindow.addEventListener(CloseEvent.CLOSE, this.closeHandler);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_2:* = this.m_memoArea.data as String;
            var _loc_3:* = this.m_memoWindow.richTextEditor.htmlText;
            var _loc_4:* = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, PropertyChangeEventKind.UPDATE, "data", _loc_2, _loc_3, this.m_memoArea);
            dispatchEvent(_loc_4);
            this.m_memoArea.data = _loc_3;
            this.closeHandler(event);
            return;
        }// end function

        private function closeHandler(event:Event) : void
        {
            this.m_memoWindow.removeEventListener(Event.COMPLETE, this.completeHandler);
            this.m_memoWindow.removeEventListener(CloseEvent.CLOSE, this.closeHandler);
            PopUpManager.removePopUp(this.m_memoWindow);
            this.m_memoWindow = null;
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
