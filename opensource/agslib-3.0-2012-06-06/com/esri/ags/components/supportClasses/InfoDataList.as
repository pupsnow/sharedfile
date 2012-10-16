package com.esri.ags.components.supportClasses
{
    import com.esri.ags.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;

    public class InfoDataList extends List implements IDataRenderer
    {
        private var _itemRenderer:InfoDataListItemRenderer;
        private static var _skinParts:Object = {scroller:false, dropIndicator:false, dataGroup:false};

        public function InfoDataList()
        {
            this._itemRenderer = new InfoDataListItemRenderer();
            itemRenderer = new ClassFactory(InfoDataListItemRenderer);
            return;
        }// end function

        public function get data() : Object
        {
            return dataProvider;
        }// end function

        public function set data(value:Object) : void
        {
            var _loc_2:ArrayCollection = null;
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            if (value != null)
            {
                _loc_2 = dataProvider as ArrayCollection;
                if (_loc_2 === null)
                {
                    _loc_2 = new ArrayCollection();
                    dataProvider = _loc_2;
                }
                else
                {
                    _loc_2.removeAll();
                }
                _loc_3 = [];
                for (_loc_4 in value)
                {
                    
                    _loc_3.push(_loc_4);
                }
                _loc_3.sort();
                _loc_2.addItem({key:ESRIMessageCodes.getString("infowDataGridFirstColumnHeaderText"), value:ESRIMessageCodes.getString("infowDataGridSecondColumnHeaderText")});
                for each (_loc_5 in _loc_3)
                {
                    
                    _loc_2.addItem({key:_loc_5, value:value[_loc_5]});
                }
                _loc_2.refresh();
                dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            }
            return;
        }// end function

        override protected function measure() : void
        {
            super.measure();
            if (dataProvider)
            {
                measuredWidth = 200;
                measuredHeight = Math.min(this._itemRenderer.height * dataProvider.length + 2, 200);
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
