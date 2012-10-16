package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.events.*;

    public class ContentNavigator extends SkinnableComponent implements IInfoWindowContent
    {
        public var contentGroup:Group;
        public var previousButton:ButtonBase;
        public var nextButton:ButtonBase;
        public var closeButton:ButtonBase;
        private const m_infoWindowRenderersCache:Dictionary;
        private var _607740351labelText:String;
        private var m_selectedIndex:int = -1;
        private var m_selectedIndexChanged:Boolean = false;
        private var m_dataProvider:IList;
        private static var _skinParts:Object = {contentGroup:true, previousButton:false, nextButton:false, closeButton:false};

        public function ContentNavigator()
        {
            this.m_infoWindowRenderersCache = new Dictionary(true);
            return;
        }// end function

        public function get showInfoWindowHeader() : Boolean
        {
            return false;
        }// end function

        public function get selectedIndex() : int
        {
            return this.m_selectedIndex;
        }// end function

        public function set selectedIndex(value:int) : void
        {
            var _loc_2:IndexChangeEvent = null;
            if (this.m_selectedIndex !== value)
            {
                _loc_2 = new IndexChangeEvent(IndexChangeEvent.CHANGE, true, false, this.m_selectedIndex, value);
                this.m_selectedIndex = value;
                this.m_selectedIndexChanged = true;
                invalidateProperties();
                invalidateSkinState();
                dispatchEvent(_loc_2);
            }
            return;
        }// end function

        public function get selectedItem() : Object
        {
            return this.m_dataProvider ? (this.m_dataProvider.getItemAt(this.selectedIndex)) : (null);
        }// end function

        public function set selectedItem(value:Object) : void
        {
            var _loc_2:int = 0;
            if (this.m_dataProvider)
            {
                _loc_2 = this.m_dataProvider.getItemIndex(value);
                if (_loc_2 > -1)
                {
                    this.selectedIndex = _loc_2;
                }
            }
            return;
        }// end function

        public function get dataProvider() : IList
        {
            return this.m_dataProvider;
        }// end function

        public function set dataProvider(value:IList) : void
        {
            if (this.m_dataProvider !== value)
            {
                if (this.m_dataProvider)
                {
                    this.m_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler);
                }
                this.m_selectedIndex = -2;
                this.m_dataProvider = value;
                if (this.m_dataProvider)
                {
                    if (this.m_dataProvider.length)
                    {
                        this.selectedIndex = 0;
                    }
                    else
                    {
                        this.selectedIndex = -1;
                    }
                    this.m_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler);
                }
                else
                {
                    this.selectedIndex = -1;
                }
                dispatchEvent(new Event("dataProviderChanged"));
            }
            return;
        }// end function

        private function dataProvider_collectionChangeHandler(event:CollectionEvent) : void
        {
            switch(event.kind)
            {
                case CollectionEventKind.ADD:
                {
                    this.doCollectionAdd(event);
                    break;
                }
                case CollectionEventKind.REMOVE:
                {
                    this.doCollectionRemove(event);
                    break;
                }
                case CollectionEventKind.REPLACE:
                {
                    this.doCollectionReplace(event);
                    break;
                }
                case CollectionEventKind.RESET:
                {
                    this.doCollectionReset(event);
                    break;
                }
                case CollectionEventKind.UPDATE:
                {
                    this.doCollectionUpdate(event);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function doCollectionUpdate(event:CollectionEvent) : void
        {
            if (this.selectedIndex === event.location)
            {
                this.m_selectedIndexChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function doCollectionReset(event:CollectionEvent) : void
        {
            this.selectedIndex = -1;
            return;
        }// end function

        private function doCollectionReplace(event:CollectionEvent) : void
        {
            if (this.selectedIndex === event.location)
            {
                this.m_selectedIndexChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        private function doCollectionRemove(event:CollectionEvent) : void
        {
            if (this.selectedIndex === event.location)
            {
                this.m_selectedIndexChanged = true;
                invalidateProperties();
            }
            if (this.selectedIndex >= this.dataProvider.length)
            {
                this.selectedIndex = this.dataProvider.length - 1;
            }
            invalidateSkinState();
            return;
        }// end function

        private function doCollectionAdd(event:CollectionEvent) : void
        {
            if (this.dataProvider.length === 1)
            {
                this.selectedIndex = 0;
            }
            invalidateSkinState();
            return;
        }// end function

        override public function set enabled(value:Boolean) : void
        {
            if (enabled !== value)
            {
                invalidateSkinState();
            }
            super.enabled = value;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:IVisualElement = null;
            var _loc_2:Object = null;
            var _loc_3:Graphic = null;
            var _loc_4:IFactory = null;
            var _loc_5:InfoDataList = null;
            if (this.m_selectedIndexChanged)
            {
                this.m_selectedIndexChanged = false;
                if (this.m_selectedIndex === -1)
                {
                    this.contentGroup.removeAllElements();
                    this.labelText = null;
                }
                else
                {
                    _loc_2 = this.m_dataProvider.getItemAt(this.m_selectedIndex);
                    _loc_3 = _loc_2 as Graphic;
                    if (_loc_3)
                    {
                        if (!_loc_3.infoWindowRenderer)
                        {
                            if (_loc_3.graphicsLayer)
                            {
                            }
                        }
                        if (_loc_3.graphicsLayer.infoWindowRenderer)
                        {
                            if (!_loc_3.infoWindowRenderer)
                            {
                            }
                            _loc_4 = _loc_3.graphicsLayer.infoWindowRenderer;
                            _loc_1 = this.m_infoWindowRenderersCache[_loc_4];
                            if (!_loc_1)
                            {
                                _loc_1 = _loc_4.newInstance();
                                this.m_infoWindowRenderersCache[_loc_4] = _loc_1;
                            }
                            this.setVisualElementProperties(_loc_1, _loc_3);
                        }
                        else
                        {
                            _loc_5 = new InfoDataList();
                            if (!_loc_3.attributes)
                            {
                            }
                            _loc_5.data = {};
                            _loc_5.percentWidth = 100;
                            _loc_5.percentHeight = 100;
                            _loc_1 = _loc_5;
                        }
                    }
                    else
                    {
                        _loc_1 = _loc_2 as IVisualElement;
                    }
                    if (_loc_1)
                    {
                        if ("label" in _loc_1)
                        {
                            this.labelText = _loc_1["label"];
                        }
                        else
                        {
                            this.labelText = null;
                        }
                        this.contentGroup.removeAllElements();
                        this.contentGroup.addElement(_loc_1);
                    }
                    else
                    {
                        this.labelText = null;
                    }
                }
                invalidateSkinState();
            }
            super.commitProperties();
            return;
        }// end function

        private function setVisualElementProperties(visualElement:IVisualElement, feature:Graphic) : void
        {
            if (visualElement is IDataRenderer)
            {
                IDataRenderer(visualElement).data = feature.attributes;
            }
            if (visualElement is IGraphicRenderer)
            {
                IGraphicRenderer(visualElement).graphic = feature;
            }
            if ("dataProvider" in visualElement)
            {
                visualElement["dataProvider"] = feature.attributes;
            }
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (enabled === false)
            {
                return "disabled";
            }
            if (this.selectedIndex === -1)
            {
                return "noContent";
            }
            if (this.dataProvider)
            {
                if (this.dataProvider.length === 1)
                {
                    return this.labelText ? ("noNavigationLabel") : ("noNavigation");
                }
                if (this.selectedIndex === 0)
                {
                    return this.labelText ? ("noPreviousLabel") : ("noPrevious");
                }
                if ((this.selectedIndex + 1) === this.dataProvider.length)
                {
                    return this.labelText ? ("noNextLabel") : ("noNext");
                }
            }
            return this.labelText ? ("normalLabel") : ("normal");
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.previousButton)
            {
                this.previousButton.addEventListener(MouseEvent.MOUSE_UP, this.previousButton_mouseUpHandler);
            }
            else if (instance === this.nextButton)
            {
                this.nextButton.addEventListener(MouseEvent.MOUSE_UP, this.nextButton_mouseUpHandler);
            }
            else if (instance === this.closeButton)
            {
                this.closeButton.addEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
            }
            return;
        }// end function

        private function closeButton_clickHandler(event:MouseEvent) : void
        {
            this.close();
            return;
        }// end function

        private function nextButton_mouseUpHandler(event:MouseEvent) : void
        {
            this.next();
            return;
        }// end function

        private function previousButton_mouseUpHandler(event:MouseEvent) : void
        {
            this.previous();
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.previousButton)
            {
                this.previousButton.removeEventListener(MouseEvent.MOUSE_UP, this.previousButton_mouseUpHandler);
            }
            else if (instance === this.nextButton)
            {
                this.nextButton.removeEventListener(MouseEvent.MOUSE_UP, this.nextButton_mouseUpHandler);
            }
            else if (instance === this.closeButton)
            {
                this.closeButton.removeEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
            }
            return;
        }// end function

        public function previous() : void
        {
            if (this.m_dataProvider)
            {
            }
            if (this.m_dataProvider.length)
            {
                if (this.selectedIndex === 0)
                {
                    this.selectedIndex = this.m_dataProvider.length - 1;
                }
                else
                {
                    (this.selectedIndex - 1);
                }
            }
            return;
        }// end function

        public function next() : void
        {
            if (this.m_dataProvider)
            {
            }
            if (this.m_dataProvider.length)
            {
                this.selectedIndex = (this.selectedIndex + 1) % this.m_dataProvider.length;
            }
            return;
        }// end function

        public function close() : void
        {
            dispatchEvent(new Event(Event.CLOSE, true, false));
            return;
        }// end function

        public function get labelText() : String
        {
            return this._607740351labelText;
        }// end function

        public function set labelText(value:String) : void
        {
            arguments = this._607740351labelText;
            if (arguments !== value)
            {
                this._607740351labelText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelText", arguments, value));
                }
            }
            return;
        }// end function

        override protected function get skinParts() : Object
        {
            return _skinParts;
        }// end function

    }
}
