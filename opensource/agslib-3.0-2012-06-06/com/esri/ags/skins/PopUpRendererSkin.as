package com.esri.ags.skins
{
    import __AS3__.vec.*;
    import com.esri.ags.*;
    import com.esri.ags.components.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.portal.*;
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.skins.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import flashx.textLayout.conversion.*;
    import flashx.textLayout.elements.*;
    import flashx.textLayout.events.*;
    import flashx.textLayout.formats.*;
    import mx.binding.*;
    import mx.containers.utilityClasses.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.layouts.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class PopUpRendererSkin extends SparkSkin implements IBindingClient
    {
        private var _1003854100attachmentInspector:AttachmentInspector;
        private var _3059377col1:ConstraintColumn;
        private var _3059378col2:ConstraintColumn;
        private var _985849673descriptionText:RichEditableText;
        private var _154927949keyValueGroup:Group;
        private var _1332575447keyValueGroupLayout:ConstraintLayout;
        private var _170486436mediaBrowser:PopUpMediaBrowser;
        private var _2135991700titleLine:Line;
        private var _672974044titleLineSymbol:SolidColorStroke;
        private var _2135756891titleText:RichEditableText;
        private var _847650903vGroup:VGroup;
        private var _1010098560zoomToButton:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        private var textLayoutConfiguration:Configuration;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:PopUpRenderer;
        private static const symbols:Array = ["titleLineSymbol"];
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function PopUpRendererSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._PopUpRendererSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_PopUpRendererSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return [propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.width = 270;
            this.maxHeight = 300;
            this.mxmlContent = [this._PopUpRendererSkin_Scroller1_c()];
            this._PopUpRendererSkin_AttachmentInspector1_i();
            this._PopUpRendererSkin_RichEditableText2_i();
            this._PopUpRendererSkin_Group1_i();
            this._PopUpRendererSkin_PopUpMediaBrowser1_i();
            this._PopUpRendererSkin_Line1_i();
            this._PopUpRendererSkin_RichEditableText1_i();
            this._PopUpRendererSkin_Button1_i();
            this.addEventListener("preinitialize", this.___PopUpRendererSkin_SparkSkin1_preinitialize);
            var i:uint;
            while (i < bindings.length)
            {
                
                Binding(bindings[i]).execute();
                i = (i + 1);
            }
            return;
        }// end function

        override public function set moduleFactory(factory:IFlexModuleFactory) : void
        {
            super.moduleFactory = factory;
            if (this.__moduleFactoryInitialized)
            {
                return;
            }
            this.__moduleFactoryInitialized = true;
            return;
        }// end function

        override public function initialize() : void
        {
            super.initialize();
            return;
        }// end function

        override public function get symbolItems() : Array
        {
            return symbols;
        }// end function

        private function skin_preinitializeHandler(event:FlexEvent) : void
        {
            this.textLayoutConfiguration = new Configuration();
            var _loc_2:* = new TextLayoutFormat();
            _loc_2.color = getStyle("linkActiveColor");
            _loc_2.textDecoration = TextDecoration.UNDERLINE;
            this.textLayoutConfiguration.defaultLinkActiveFormat = _loc_2;
            _loc_2 = new TextLayoutFormat();
            _loc_2.color = getStyle("linkHoverColor");
            _loc_2.textDecoration = TextDecoration.UNDERLINE;
            this.textLayoutConfiguration.defaultLinkHoverFormat = _loc_2;
            _loc_2 = new TextLayoutFormat();
            _loc_2.color = getStyle("linkNormalColor");
            _loc_2.textDecoration = TextDecoration.UNDERLINE;
            this.textLayoutConfiguration.defaultLinkNormalFormat = _loc_2;
            _loc_2 = new TextLayoutFormat();
            _loc_2.whiteSpaceCollapse = WhiteSpaceCollapse.PRESERVE;
            this.textLayoutConfiguration.textFlowInitialFormat = _loc_2;
            this.attachmentInspector.addEventListener(AttachmentMouseEvent.ATTACHMENT_CLICK, this.attachmentInspector_attachmentClickHandler);
            return;
        }// end function

        private function attachmentInspector_attachmentClickHandler(event:AttachmentMouseEvent) : void
        {
            navigateToURL(new URLRequest(event.attachmentInfo.url));
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_9:String = null;
            var _loc_10:Vector.<ConstraintRow> = null;
            var _loc_11:int = 0;
            var _loc_12:PopUpFieldInfo = null;
            var _loc_13:int = 0;
            var _loc_14:ConstraintRow = null;
            var _loc_15:Label = null;
            var _loc_16:RichEditableText = null;
            var _loc_17:Array = null;
            super.commitProperties();
            var _loc_1:* = this.hostComponent.featureLayer;
            var _loc_2:* = this.hostComponent.formattedAttributes;
            var _loc_3:* = this.hostComponent.graphic;
            var _loc_4:* = this.hostComponent.map;
            var _loc_5:* = this.hostComponent.popUpInfo;
            var _loc_6:* = this.hostComponent.validPopUpMediaInfos;
            var _loc_7:* = _loc_3 ? (_loc_3.geometry) : (null);
            var _loc_8:* = _loc_1 ? (_loc_1.layerDetails) : (null);
            this.vGroup.removeAllElements();
            if (_loc_5)
            {
                if (_loc_5.title)
                {
                    this.titleText.text = StringUtil.substitute(_loc_5.title, _loc_2);
                    if (this.titleText.text)
                    {
                        this.vGroup.addElement(this.titleText);
                        this.vGroup.addElement(this.titleLine);
                    }
                }
                if (_loc_5.description)
                {
                    _loc_9 = StringUtil.substitute(_loc_5.description, _loc_2);
                    if (_loc_9)
                    {
                        this.setTextFlow(this.descriptionText, _loc_9);
                        this.vGroup.addElement(this.descriptionText);
                    }
                }
                else if (_loc_5.popUpFieldInfos)
                {
                    _loc_10 = this.keyValueGroupLayout.constraintRows;
                    if (_loc_10.length < _loc_5.popUpFieldInfos.length)
                    {
                        _loc_13 = _loc_10.length + 1;
                        while (_loc_13 <= _loc_5.popUpFieldInfos.length)
                        {
                            
                            _loc_14 = new ConstraintRow();
                            _loc_14.initialized(this, null);
                            _loc_14.id = "row" + _loc_13;
                            _loc_10.push(_loc_14);
                            _loc_13 = _loc_13 + 1;
                        }
                        this.keyValueGroupLayout.constraintRows = _loc_10;
                    }
                    this.keyValueGroup.removeAllElements();
                    _loc_11 = 1;
                    for each (_loc_12 in _loc_5.popUpFieldInfos)
                    {
                        
                        if (_loc_12.visible)
                        {
                            _loc_15 = new Label();
                            if (!_loc_12.label)
                            {
                            }
                            _loc_15.text = _loc_12.fieldName;
                            _loc_15.left = 0;
                            _loc_15.right = "col1:0";
                            _loc_15.top = "row" + _loc_11 + ":" + (_loc_11 == 1 ? (5) : (15));
                            this.keyValueGroup.addElement(_loc_15);
                            _loc_9 = _loc_2[_loc_12.fieldName];
                            if (_loc_9)
                            {
                                _loc_16 = new RichEditableText();
                                _loc_17 = _loc_9.match(/^\s*((https?|ftp):\/\/\S+)\s*$/i);
                                if (_loc_17)
                                {
                                }
                                if (_loc_17.length > 0)
                                {
                                    _loc_9 = "<a href=\"" + _loc_17[1] + "\" target=\"_blank\">" + _loc_17[1] + "</a>";
                                }
                                this.setTextFlow(_loc_16, _loc_9);
                                _loc_16.editable = false;
                                _loc_16.left = "col2:5";
                                _loc_16.right = 0;
                                _loc_16.top = _loc_15.top;
                                this.keyValueGroup.addElement(_loc_16);
                            }
                            _loc_11 = _loc_11 + 1;
                        }
                    }
                    if (this.keyValueGroup.numElements > 0)
                    {
                        _loc_15.bottom = "row" + --_loc_11 + ":5";
                        this.vGroup.addElement(this.keyValueGroup);
                    }
                }
                if (_loc_6)
                {
                }
                if (_loc_6.length > 0)
                {
                    this.vGroup.addElement(this.mediaBrowser);
                    this.mediaBrowser.attributes = _loc_3.attributes;
                    this.mediaBrowser.formattedAttributes = _loc_2;
                    this.mediaBrowser.popUpFieldInfos = _loc_5.popUpFieldInfos;
                    this.mediaBrowser.popUpMediaInfos = _loc_6;
                }
                if (_loc_5.showAttachments)
                {
                }
                if (_loc_3)
                {
                }
                if (_loc_1)
                {
                }
                if (_loc_8)
                {
                }
                if (_loc_8.hasAttachments)
                {
                }
                if (_loc_8.objectIdField)
                {
                    this.vGroup.addElement(this.attachmentInspector);
                    this.attachmentInspector.showAttachments(_loc_3, _loc_1);
                }
                if (_loc_4)
                {
                }
                if (_loc_7)
                {
                    this.vGroup.addElement(this.zoomToButton);
                }
            }
            return;
        }// end function

        private function setTextFlow(textComp:RichEditableText, htmlText:String) : void
        {
            var _loc_3:TextFlow = null;
            if (textComp)
            {
            }
            if (htmlText != null)
            {
                _loc_3 = TextConverter.importToFlow(htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT, this.textLayoutConfiguration);
                if (_loc_3)
                {
                    _loc_3.addEventListener(FlowElementMouseEvent.CLICK, this.textFlow_linkClickHandler, false, 0, true);
                    textComp.textFlow = _loc_3;
                }
            }
            return;
        }// end function

        private function textFlow_linkClickHandler(event:FlowElementMouseEvent) : void
        {
            var _loc_2:* = event.flowElement as LinkElement;
            if (_loc_2)
            {
            }
            if (_loc_2.target != "_blank")
            {
                _loc_2.target = "_blank";
            }
            return;
        }// end function

        private function zoomToButton_clickHandler(event:MouseEvent) : void
        {
            var _loc_6:MapPoint = null;
            var _loc_7:Multipoint = null;
            var _loc_2:* = this.hostComponent.graphic;
            var _loc_3:* = this.hostComponent.map;
            var _loc_4:* = _loc_2.geometry;
            var _loc_5:* = _loc_4.extent;
            if (_loc_5)
            {
                _loc_3.extent = _loc_5;
                if (!_loc_3.extent.contains(_loc_5))
                {
                    var _loc_8:* = _loc_3;
                    var _loc_9:* = _loc_3.level - 1;
                    _loc_8.level = _loc_9;
                }
            }
            else
            {
                if (_loc_4 is MapPoint)
                {
                    _loc_6 = _loc_4 as MapPoint;
                }
                else if (_loc_4 is Multipoint)
                {
                    _loc_7 = _loc_4 as Multipoint;
                    if (_loc_7.points)
                    {
                    }
                    if (_loc_7.points.length > 0)
                    {
                        _loc_6 = _loc_7.points[0];
                    }
                }
                if (_loc_6)
                {
                    _loc_3.infoWindow.show(_loc_6);
                    _loc_3.zoom(1 / 16, _loc_6);
                    if (!_loc_3.extent.contains(_loc_6))
                    {
                        _loc_3.centerAt(_loc_6);
                    }
                }
            }
            return;
        }// end function

        private function _PopUpRendererSkin_AttachmentInspector1_i() : AttachmentInspector
        {
            var _loc_1:* = new AttachmentInspector();
            _loc_1.percentWidth = 100;
            _loc_1.addEnabled = false;
            _loc_1.deleteEnabled = false;
            _loc_1.id = "attachmentInspector";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.attachmentInspector = _loc_1;
            BindingManager.executeBindings(this, "attachmentInspector", this.attachmentInspector);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_RichEditableText2_i() : RichEditableText
        {
            var _loc_1:* = new RichEditableText();
            _loc_1.percentWidth = 100;
            _loc_1.editable = false;
            _loc_1.id = "descriptionText";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.descriptionText = _loc_1;
            BindingManager.executeBindings(this, "descriptionText", this.descriptionText);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.percentWidth = 100;
            _loc_1.layout = this._PopUpRendererSkin_ConstraintLayout1_i();
            _loc_1.id = "keyValueGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.keyValueGroup = _loc_1;
            BindingManager.executeBindings(this, "keyValueGroup", this.keyValueGroup);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_ConstraintLayout1_i() : ConstraintLayout
        {
            var _loc_1:* = new ConstraintLayout();
            new Vector.<ConstraintColumn>(2)[0] = this._PopUpRendererSkin_ConstraintColumn1_i();
            new Vector.<ConstraintColumn>(2)[1] = this._PopUpRendererSkin_ConstraintColumn2_i();
            _loc_1.constraintColumns = new Vector.<ConstraintColumn>(2);
            this.keyValueGroupLayout = _loc_1;
            BindingManager.executeBindings(this, "keyValueGroupLayout", this.keyValueGroupLayout);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_ConstraintColumn1_i() : ConstraintColumn
        {
            var _loc_1:* = new ConstraintColumn();
            _loc_1.maxWidth = 100;
            _loc_1.initialized(this, "col1");
            this.col1 = _loc_1;
            BindingManager.executeBindings(this, "col1", this.col1);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_ConstraintColumn2_i() : ConstraintColumn
        {
            var _loc_1:* = new ConstraintColumn();
            _loc_1.percentWidth = 100;
            _loc_1.initialized(this, "col2");
            this.col2 = _loc_1;
            BindingManager.executeBindings(this, "col2", this.col2);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_PopUpMediaBrowser1_i() : PopUpMediaBrowser
        {
            var _loc_1:* = new PopUpMediaBrowser();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("skinClass", PopUpMediaBrowserSkin);
            _loc_1.id = "mediaBrowser";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.mediaBrowser = _loc_1;
            BindingManager.executeBindings(this, "mediaBrowser", this.mediaBrowser);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_Line1_i() : Line
        {
            var _loc_1:* = new Line();
            _loc_1.percentWidth = 100;
            _loc_1.stroke = this._PopUpRendererSkin_SolidColorStroke1_i();
            _loc_1.initialized(this, "titleLine");
            this.titleLine = _loc_1;
            BindingManager.executeBindings(this, "titleLine", this.titleLine);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 0;
            _loc_1.weight = 1;
            this.titleLineSymbol = _loc_1;
            BindingManager.executeBindings(this, "titleLineSymbol", this.titleLineSymbol);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_RichEditableText1_i() : RichEditableText
        {
            var _loc_1:* = new RichEditableText();
            _loc_1.percentWidth = 100;
            _loc_1.editable = false;
            _loc_1.setStyle("fontWeight", "bold");
            _loc_1.id = "titleText";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.titleText = _loc_1;
            BindingManager.executeBindings(this, "titleText", this.titleText);
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.setStyle("fontWeight", "bold");
            _loc_1.addEventListener("click", this.__zoomToButton_click);
            _loc_1.id = "zoomToButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.zoomToButton = _loc_1;
            BindingManager.executeBindings(this, "zoomToButton", this.zoomToButton);
            return _loc_1;
        }// end function

        public function __zoomToButton_click(event:MouseEvent) : void
        {
            this.zoomToButton_clickHandler(event);
            return;
        }// end function

        private function _PopUpRendererSkin_Scroller1_c() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.viewport = this._PopUpRendererSkin_VGroup1_i();
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _PopUpRendererSkin_VGroup1_i() : VGroup
        {
            var _loc_1:* = new VGroup();
            _loc_1.paddingBottom = 5;
            _loc_1.paddingLeft = 5;
            _loc_1.paddingRight = 5;
            _loc_1.paddingTop = 5;
            _loc_1.id = "vGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.vGroup = _loc_1;
            BindingManager.executeBindings(this, "vGroup", this.vGroup);
            return _loc_1;
        }// end function

        public function ___PopUpRendererSkin_SparkSkin1_preinitialize(event:FlexEvent) : void
        {
            this.skin_preinitializeHandler(event);
            return;
        }// end function

        private function _PopUpRendererSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "zoomLabel");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "zoomToButton.label");
            return result;
        }// end function

        public function get attachmentInspector() : AttachmentInspector
        {
            return this._1003854100attachmentInspector;
        }// end function

        public function set attachmentInspector(value:AttachmentInspector) : void
        {
            var _loc_2:* = this._1003854100attachmentInspector;
            if (_loc_2 !== value)
            {
                this._1003854100attachmentInspector = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attachmentInspector", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get col1() : ConstraintColumn
        {
            return this._3059377col1;
        }// end function

        public function set col1(value:ConstraintColumn) : void
        {
            var _loc_2:* = this._3059377col1;
            if (_loc_2 !== value)
            {
                this._3059377col1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "col1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get col2() : ConstraintColumn
        {
            return this._3059378col2;
        }// end function

        public function set col2(value:ConstraintColumn) : void
        {
            var _loc_2:* = this._3059378col2;
            if (_loc_2 !== value)
            {
                this._3059378col2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "col2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get descriptionText() : RichEditableText
        {
            return this._985849673descriptionText;
        }// end function

        public function set descriptionText(value:RichEditableText) : void
        {
            var _loc_2:* = this._985849673descriptionText;
            if (_loc_2 !== value)
            {
                this._985849673descriptionText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "descriptionText", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get keyValueGroup() : Group
        {
            return this._154927949keyValueGroup;
        }// end function

        public function set keyValueGroup(value:Group) : void
        {
            var _loc_2:* = this._154927949keyValueGroup;
            if (_loc_2 !== value)
            {
                this._154927949keyValueGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "keyValueGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get keyValueGroupLayout() : ConstraintLayout
        {
            return this._1332575447keyValueGroupLayout;
        }// end function

        public function set keyValueGroupLayout(value:ConstraintLayout) : void
        {
            var _loc_2:* = this._1332575447keyValueGroupLayout;
            if (_loc_2 !== value)
            {
                this._1332575447keyValueGroupLayout = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "keyValueGroupLayout", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get mediaBrowser() : PopUpMediaBrowser
        {
            return this._170486436mediaBrowser;
        }// end function

        public function set mediaBrowser(value:PopUpMediaBrowser) : void
        {
            var _loc_2:* = this._170486436mediaBrowser;
            if (_loc_2 !== value)
            {
                this._170486436mediaBrowser = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mediaBrowser", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get titleLine() : Line
        {
            return this._2135991700titleLine;
        }// end function

        public function set titleLine(value:Line) : void
        {
            var _loc_2:* = this._2135991700titleLine;
            if (_loc_2 !== value)
            {
                this._2135991700titleLine = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "titleLine", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get titleLineSymbol() : SolidColorStroke
        {
            return this._672974044titleLineSymbol;
        }// end function

        public function set titleLineSymbol(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._672974044titleLineSymbol;
            if (_loc_2 !== value)
            {
                this._672974044titleLineSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "titleLineSymbol", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get titleText() : RichEditableText
        {
            return this._2135756891titleText;
        }// end function

        public function set titleText(value:RichEditableText) : void
        {
            var _loc_2:* = this._2135756891titleText;
            if (_loc_2 !== value)
            {
                this._2135756891titleText = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "titleText", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get vGroup() : VGroup
        {
            return this._847650903vGroup;
        }// end function

        public function set vGroup(value:VGroup) : void
        {
            var _loc_2:* = this._847650903vGroup;
            if (_loc_2 !== value)
            {
                this._847650903vGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "vGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get zoomToButton() : Button
        {
            return this._1010098560zoomToButton;
        }// end function

        public function set zoomToButton(value:Button) : void
        {
            var _loc_2:* = this._1010098560zoomToButton;
            if (_loc_2 !== value)
            {
                this._1010098560zoomToButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoomToButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : PopUpRenderer
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:PopUpRenderer) : void
        {
            var _loc_2:* = this._213507019hostComponent;
            if (_loc_2 !== value)
            {
                this._213507019hostComponent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hostComponent", _loc_2, value));
                }
            }
            return;
        }// end function

        public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2) : void
        {
            _watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
