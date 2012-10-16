package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import mx.core.*;

    public class InfoSymbolWindow extends InfoComponent
    {
        public var content:IVisualElement;
        private static var _skinParts:Object = {contentGroup:false};

        public function InfoSymbolWindow(map:Map, styleName:String)
        {
            super(map);
            this.styleName = styleName;
            return;
        }// end function

        public function get positionX() : Number
        {
            return anchorX - map.scrollRectX;
        }// end function

        public function get positionY() : Number
        {
            return anchorY - map.scrollRectY;
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === contentGroup)
            {
                contentGroup.addElement(this.content);
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
