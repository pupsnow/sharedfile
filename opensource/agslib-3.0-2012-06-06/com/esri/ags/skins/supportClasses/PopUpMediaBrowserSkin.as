package com.esri.ags.skins.supportClasses
{
    import com.esri.ags.portal.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.charts.*;
    import mx.charts.chartClasses.*;
    import mx.charts.series.*;
    import mx.charts.series.items.*;
    import mx.core.*;
    import mx.events.*;
    import mx.graphics.*;
    import spark.components.*;
    import spark.formatters.*;
    import spark.layouts.*;
    import spark.primitives.*;
    import spark.skins.*;

    public class PopUpMediaBrowserSkin extends SparkSkin implements IBindingClient
    {
        public var _PopUpMediaBrowserSkin_AxisRenderer1:AxisRenderer;
        public var _PopUpMediaBrowserSkin_AxisRenderer2:AxisRenderer;
        public var _PopUpMediaBrowserSkin_AxisRenderer3:AxisRenderer;
        private var _334588332barAxis:CategoryAxis;
        private var _1780940917barChart:BarChart;
        private var _1081199722barSeries:BarSeries;
        private var _1824869424borderRect:Rect;
        private var _565851672borderRectSymbol:SolidColorStroke;
        private var _1094765394captionLabel:Label;
        private var _2106026985columnAxis:CategoryAxis;
        private var _860964312columnChart:ColumnChart;
        private var _464296595columnSeries:ColumnSeries;
        private var _1053257947countLabel:Label;
        private var _100313435image:Image;
        private var _1267703681imageOrChartGroup:Group;
        private var _1188098485lineAxis:CategoryAxis;
        private var _1822289846lineChart:LineChart;
        private var _200617077lineSeries:LineSeries;
        private var _1749722107nextButton:Button;
        private var _1060399231numberFormatter:NumberFormatter;
        private var _718516814pieChart:PieChart;
        private var _343391453pieSeries:PieSeries;
        private var _498435831previousButton:Button;
        private var _1791483012titleLabel:Label;
        private var __moduleFactoryInitialized:Boolean = false;
        private var imageLinkURL:String;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:PopUpMediaBrowser;
        private static const symbols:Array = ["borderRectSymbol"];
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function PopUpMediaBrowserSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._PopUpMediaBrowserSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_supportClasses_PopUpMediaBrowserSkinWatcherSetupUtil");
                var _loc_2:* = watcherSetupUtilClass;
                _loc_2.watcherSetupUtilClass["init"](null);
            }
            _watcherSetupUtil.setup(this, function (propertyName:String)
            {
                return target[propertyName];
            }// end function
            , function (propertyName:String)
            {
                return PopUpMediaBrowserSkin[propertyName];
            }// end function
            , bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.layout = this._PopUpMediaBrowserSkin_VerticalLayout1_c();
            this.mxmlContent = [this._PopUpMediaBrowserSkin_Label1_i(), this._PopUpMediaBrowserSkin_HGroup1_c(), this._PopUpMediaBrowserSkin_Label2_i(), this._PopUpMediaBrowserSkin_Label3_i()];
            this._PopUpMediaBrowserSkin_NumberFormatter1_i();
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

        override protected function commitProperties() : void
        {
            var _loc_5:IVisualElement = null;
            var _loc_6:Array = null;
            super.commitProperties();
            var _loc_1:* = this.hostComponent.attributes;
            var _loc_2:* = this.hostComponent.formattedAttributes;
            var _loc_3:* = this.hostComponent.activeMediaInfo;
            var _loc_4:int = 0;
            while (_loc_4 < this.imageOrChartGroup.numElements)
            {
                
                _loc_5 = this.imageOrChartGroup.getElementAt(_loc_4);
                if (_loc_5 !== this.borderRect)
                {
                    this.hideElement(_loc_5);
                }
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_3)
            {
                if (_loc_3.type === PopUpMediaInfo.IMAGE)
                {
                    this.showElement(this.image);
                    this.imageLinkURL = StringUtil.substitute(_loc_3.imageLinkURL, _loc_1);
                    if (this.imageLinkURL)
                    {
                        this.image.buttonMode = true;
                    }
                    else
                    {
                        this.image.buttonMode = false;
                    }
                    this.image.source = StringUtil.substitute(_loc_3.imageSourceURL, _loc_1);
                }
                else
                {
                    _loc_6 = this.hostComponent.getChartData();
                    if (_loc_3.type === PopUpMediaInfo.BAR_CHART)
                    {
                        this.showElement(this.barChart);
                        this.barSeries.styleName = _loc_3.chartSeriesStyleName;
                        this.barChart.dataProvider = _loc_6;
                    }
                    else if (_loc_3.type === PopUpMediaInfo.COLUMN_CHART)
                    {
                        this.showElement(this.columnChart);
                        this.columnSeries.styleName = _loc_3.chartSeriesStyleName;
                        this.columnChart.dataProvider = _loc_6;
                    }
                    else if (_loc_3.type === PopUpMediaInfo.LINE_CHART)
                    {
                        this.showElement(this.lineChart);
                        this.lineSeries.styleName = _loc_3.chartSeriesStyleName;
                        this.lineChart.dataProvider = _loc_6;
                    }
                    else if (_loc_3.type === PopUpMediaInfo.PIE_CHART)
                    {
                        this.showElement(this.pieChart);
                        this.pieSeries.styleName = _loc_3.chartSeriesStyleName;
                        this.pieChart.dataProvider = _loc_6;
                    }
                }
                this.titleLabel.text = StringUtil.substitute(_loc_3.title, _loc_2);
                if (this.hostComponent.popUpMediaInfos)
                {
                }
                if (this.hostComponent.popUpMediaInfos.length > 1)
                {
                    this.showElement(this.countLabel);
                    this.countLabel.text = "(" + (this.hostComponent.activeIndex + 1) + " " + resourceManager.getString("ESRIMessages", "attributeInspectorOf") + " " + this.hostComponent.popUpMediaInfos.length + ")";
                }
                else
                {
                    this.hideElement(this.countLabel);
                }
                this.captionLabel.text = StringUtil.substitute(_loc_3.caption, _loc_2);
            }
            return;
        }// end function

        private function image_clickHandler(event:MouseEvent) : void
        {
            if (this.imageLinkURL)
            {
                navigateToURL(new URLRequest(this.imageLinkURL));
            }
            return;
        }// end function

        private function imageOrChartGroup_resizeHandler(event:ResizeEvent) : void
        {
            this.imageOrChartGroup.height = this.imageOrChartGroup.width;
            return;
        }// end function

        private function hideElement(element:IVisualElement) : void
        {
            if (element.visible)
            {
                element.visible = false;
                element.includeInLayout = false;
            }
            return;
        }// end function

        private function showElement(element:IVisualElement) : void
        {
            if (!element.visible)
            {
                element.visible = true;
                element.includeInLayout = true;
            }
            return;
        }// end function

        private function barSeriesDataTipFunction(hd:HitData) : String
        {
            var _loc_2:DataTransform = null;
            var _loc_5:IAxis = null;
            var _loc_7:IAxis = null;
            var _loc_10:String = null;
            _loc_2 = this.barSeries.dataTransform;
            var _loc_3:* = this.barSeries.minField;
            var _loc_4:* = this.barSeries.displayName;
            _loc_5 = _loc_2.getAxis(CartesianTransform.HORIZONTAL_AXIS);
            var _loc_6:* = _loc_5 is NumericAxis;
            _loc_7 = _loc_2.getAxis(CartesianTransform.VERTICAL_AXIS);
            var _loc_8:* = _loc_7 is NumericAxis;
            var _loc_9:* = BarSeriesItem(hd.chartItem);
            var _loc_11:String = "";
            var _loc_12:* = _loc_4;
            if (_loc_12)
            {
            }
            if (_loc_12 != "")
            {
                _loc_11 = _loc_11 + ("<b>" + _loc_12 + "</b><BR/>");
            }
            var _loc_13:* = _loc_7.displayName;
            if (_loc_13 != "")
            {
                _loc_11 = _loc_11 + ("<i>" + _loc_13 + ":</i> ");
            }
            _loc_10 = _loc_7.formatForScreen(_loc_9.yValue);
            _loc_11 = _loc_11 + (_loc_8 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            var _loc_14:* = _loc_5.displayName;
            if (_loc_3 == "")
            {
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + ":</i> ");
                }
                _loc_10 = _loc_5.formatForScreen(_loc_9.xValue);
                _loc_11 = _loc_11 + (_loc_6 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            }
            else
            {
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + " (high):</i> ");
                }
                else
                {
                    _loc_11 = _loc_11 + "<i>high:</i> ";
                }
                _loc_10 = _loc_5.formatForScreen(_loc_9.xValue);
                _loc_11 = _loc_11 + (_loc_6 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + " (low):</i> ");
                }
                else
                {
                    _loc_11 = _loc_11 + "<i>low:</i> ";
                }
                _loc_10 = _loc_5.formatForScreen(_loc_9.minValue);
                _loc_11 = _loc_11 + (_loc_6 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            }
            return _loc_11;
        }// end function

        private function columnSeriesDataTipFunction(hd:HitData) : String
        {
            var _loc_2:DataTransform = null;
            var _loc_5:IAxis = null;
            var _loc_7:IAxis = null;
            var _loc_10:String = null;
            _loc_2 = this.columnSeries.dataTransform;
            var _loc_3:* = this.columnSeries.minField;
            var _loc_4:* = this.columnSeries.displayName;
            _loc_5 = _loc_2.getAxis(CartesianTransform.HORIZONTAL_AXIS);
            var _loc_6:* = _loc_5 is NumericAxis;
            _loc_7 = _loc_2.getAxis(CartesianTransform.VERTICAL_AXIS);
            var _loc_8:* = _loc_7 is NumericAxis;
            var _loc_9:* = ColumnSeriesItem(hd.chartItem);
            var _loc_11:String = "";
            var _loc_12:* = _loc_4;
            if (_loc_12 != null)
            {
            }
            if (_loc_12.length > 0)
            {
                _loc_11 = _loc_11 + ("<b>" + _loc_12 + "</b><BR/>");
            }
            var _loc_13:* = _loc_5.displayName;
            if (_loc_13 != "")
            {
                _loc_11 = _loc_11 + ("<i>" + _loc_13 + ":</i> ");
            }
            _loc_10 = _loc_5.formatForScreen(_loc_9.xValue);
            _loc_11 = _loc_11 + (_loc_6 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            var _loc_14:* = _loc_7.displayName;
            if (_loc_3 == "")
            {
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + ":</i> ");
                }
                _loc_10 = _loc_7.formatForScreen(_loc_9.yValue);
                _loc_11 = _loc_11 + (_loc_8 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            }
            else
            {
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + " (high):</i> ");
                }
                else
                {
                    _loc_11 = _loc_11 + "<i>high:</i> ";
                }
                _loc_10 = _loc_7.formatForScreen(_loc_9.yValue);
                _loc_11 = _loc_11 + (_loc_8 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
                if (_loc_14 != "")
                {
                    _loc_11 = _loc_11 + ("<i>" + _loc_14 + " (low):</i> ");
                }
                else
                {
                    _loc_11 = _loc_11 + "<i>low:</i> ";
                }
                _loc_10 = _loc_7.formatForScreen(_loc_9.minValue);
                _loc_11 = _loc_11 + (_loc_8 ? (this.numberFormatter.format(_loc_10)) : (_loc_10 + "\n"));
            }
            return _loc_11;
        }// end function

        private function lineSeriesDataTipFunction(hd:HitData) : String
        {
            var _loc_2:DataTransform = null;
            var _loc_4:IAxis = null;
            var _loc_6:IAxis = null;
            var _loc_9:String = null;
            _loc_2 = this.lineSeries.dataTransform;
            var _loc_3:* = this.lineSeries.displayName;
            _loc_4 = _loc_2.getAxis(CartesianTransform.HORIZONTAL_AXIS);
            var _loc_5:* = _loc_4 is NumericAxis;
            _loc_6 = _loc_2.getAxis(CartesianTransform.VERTICAL_AXIS);
            var _loc_7:* = _loc_6 is NumericAxis;
            var _loc_8:* = LineSeriesItem(hd.chartItem);
            var _loc_10:String = "";
            var _loc_11:* = _loc_3;
            if (_loc_11)
            {
            }
            if (_loc_11 != "")
            {
                _loc_10 = _loc_10 + ("<b>" + _loc_11 + "</b><BR/>");
            }
            var _loc_12:* = _loc_4.displayName;
            if (_loc_12 != "")
            {
                _loc_10 = _loc_10 + ("<i>" + _loc_12 + ":</i> ");
            }
            _loc_9 = _loc_4.formatForScreen(_loc_8.xValue);
            _loc_10 = _loc_10 + (_loc_5 ? (this.numberFormatter.format(_loc_9)) : (_loc_9 + "\n"));
            var _loc_13:* = _loc_6.displayName;
            if (_loc_13 != "")
            {
                _loc_10 = _loc_10 + ("<i>" + _loc_13 + ":</i> ");
            }
            _loc_9 = _loc_6.formatForScreen(_loc_8.yValue);
            _loc_10 = _loc_10 + (_loc_7 ? (this.numberFormatter.format(_loc_9)) : (_loc_9 + "\n"));
            return _loc_10;
        }// end function

        private function pieSeriesDataTipFunction(hd:HitData) : String
        {
            var _loc_2:* = this.pieSeries.dataTransform;
            var _loc_3:* = this.pieSeries.nameField;
            var _loc_4:* = this.pieSeries.displayName;
            var _loc_5:* = PieSeriesItem(hd.chartItem);
            var _loc_6:String = "";
            var _loc_7:String = "";
            if (_loc_3 != "")
            {
                _loc_7 = _loc_5.item[_loc_3];
            }
            if (_loc_7 != "")
            {
                _loc_6 = _loc_6 + ("<b>" + _loc_7 + ":</b> <b> " + Math.round(_loc_5.percentValue * 10) / 10 + "%</b><BR/>");
            }
            else
            {
                _loc_6 = _loc_6 + ("<b>" + Math.round(_loc_5.percentValue * 10) / 10 + "%</b><BR/>");
            }
            _loc_6 = _loc_6 + ("<i>(" + this.numberFormatter.format(_loc_5.value) + ")</i>");
            return _loc_6;
        }// end function

        private function _PopUpMediaBrowserSkin_NumberFormatter1_i() : NumberFormatter
        {
            var _loc_1:* = new NumberFormatter();
            _loc_1.trailingZeros = false;
            _loc_1.initialized(this, "numberFormatter");
            this.numberFormatter = _loc_1;
            BindingManager.executeBindings(this, "numberFormatter", this.numberFormatter);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("fontWeight", "bold");
            _loc_1.id = "titleLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.titleLabel = _loc_1;
            BindingManager.executeBindings(this, "titleLabel", this.titleLabel);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_HGroup1_c() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.percentWidth = 100;
            _loc_1.gap = 2;
            _loc_1.verticalAlign = "middle";
            _loc_1.mxmlContent = [this._PopUpMediaBrowserSkin_Button1_i(), this._PopUpMediaBrowserSkin_Group1_i(), this._PopUpMediaBrowserSkin_Button2_i()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.percentHeight = 100;
            _loc_1.setStyle("skinClass", PopUpMediaBrowserPreviousButtonSkin);
            _loc_1.id = "previousButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.previousButton = _loc_1;
            BindingManager.executeBindings(this, "previousButton", this.previousButton);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.percentWidth = 100;
            _loc_1.mxmlContent = [this._PopUpMediaBrowserSkin_Rect1_i(), this._PopUpMediaBrowserSkin_Image1_i(), this._PopUpMediaBrowserSkin_BarChart1_i(), this._PopUpMediaBrowserSkin_ColumnChart1_i(), this._PopUpMediaBrowserSkin_LineChart1_i(), this._PopUpMediaBrowserSkin_PieChart1_i()];
            _loc_1.addEventListener("resize", this.__imageOrChartGroup_resize);
            _loc_1.id = "imageOrChartGroup";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.imageOrChartGroup = _loc_1;
            BindingManager.executeBindings(this, "imageOrChartGroup", this.imageOrChartGroup);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Rect1_i() : Rect
        {
            var _loc_1:* = new Rect();
            _loc_1.left = 0;
            _loc_1.right = 0;
            _loc_1.top = 0;
            _loc_1.bottom = 0;
            _loc_1.stroke = this._PopUpMediaBrowserSkin_SolidColorStroke1_i();
            _loc_1.initialized(this, "borderRect");
            this.borderRect = _loc_1;
            BindingManager.executeBindings(this, "borderRect", this.borderRect);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_SolidColorStroke1_i() : SolidColorStroke
        {
            var _loc_1:* = new SolidColorStroke();
            _loc_1.color = 0;
            _loc_1.weight = 1;
            this.borderRectSymbol = _loc_1;
            BindingManager.executeBindings(this, "borderRectSymbol", this.borderRectSymbol);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Image1_i() : Image
        {
            var _loc_1:* = new Image();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.smooth = true;
            _loc_1.setStyle("enableLoadingState", true);
            _loc_1.addEventListener("click", this.__image_click);
            _loc_1.id = "image";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.image = _loc_1;
            BindingManager.executeBindings(this, "image", this.image);
            return _loc_1;
        }// end function

        public function __image_click(event:MouseEvent) : void
        {
            this.image_clickHandler(event);
            return;
        }// end function

        private function _PopUpMediaBrowserSkin_BarChart1_i() : BarChart
        {
            var _loc_1:* = new BarChart();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.dataTipFunction = this.barSeriesDataTipFunction;
            _loc_1.showDataTips = true;
            _loc_1.series = [this._PopUpMediaBrowserSkin_BarSeries1_i()];
            _loc_1.verticalAxis = this._PopUpMediaBrowserSkin_CategoryAxis1_i();
            _loc_1.verticalAxisRenderers = [this._PopUpMediaBrowserSkin_AxisRenderer1_i()];
            _loc_1.id = "barChart";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.barChart = _loc_1;
            BindingManager.executeBindings(this, "barChart", this.barChart);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_BarSeries1_i() : BarSeries
        {
            var _loc_1:* = new BarSeries();
            _loc_1.xField = "value";
            _loc_1.id = "barSeries";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.barSeries = _loc_1;
            BindingManager.executeBindings(this, "barSeries", this.barSeries);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_CategoryAxis1_i() : CategoryAxis
        {
            var _loc_1:* = new CategoryAxis();
            _loc_1.categoryField = "name";
            this.barAxis = _loc_1;
            BindingManager.executeBindings(this, "barAxis", this.barAxis);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_AxisRenderer1_i() : AxisRenderer
        {
            var _loc_1:* = new AxisRenderer();
            _loc_1.setStyle("showLabels", false);
            _loc_1.id = "_PopUpMediaBrowserSkin_AxisRenderer1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._PopUpMediaBrowserSkin_AxisRenderer1 = _loc_1;
            BindingManager.executeBindings(this, "_PopUpMediaBrowserSkin_AxisRenderer1", this._PopUpMediaBrowserSkin_AxisRenderer1);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_ColumnChart1_i() : ColumnChart
        {
            var _loc_1:* = new ColumnChart();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.dataTipFunction = this.columnSeriesDataTipFunction;
            _loc_1.showDataTips = true;
            _loc_1.series = [this._PopUpMediaBrowserSkin_ColumnSeries1_i()];
            _loc_1.horizontalAxis = this._PopUpMediaBrowserSkin_CategoryAxis2_i();
            _loc_1.horizontalAxisRenderers = [this._PopUpMediaBrowserSkin_AxisRenderer2_i()];
            _loc_1.id = "columnChart";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.columnChart = _loc_1;
            BindingManager.executeBindings(this, "columnChart", this.columnChart);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_ColumnSeries1_i() : ColumnSeries
        {
            var _loc_1:* = new ColumnSeries();
            _loc_1.yField = "value";
            _loc_1.id = "columnSeries";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.columnSeries = _loc_1;
            BindingManager.executeBindings(this, "columnSeries", this.columnSeries);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_CategoryAxis2_i() : CategoryAxis
        {
            var _loc_1:* = new CategoryAxis();
            _loc_1.categoryField = "name";
            this.columnAxis = _loc_1;
            BindingManager.executeBindings(this, "columnAxis", this.columnAxis);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_AxisRenderer2_i() : AxisRenderer
        {
            var _loc_1:* = new AxisRenderer();
            _loc_1.setStyle("showLabels", false);
            _loc_1.id = "_PopUpMediaBrowserSkin_AxisRenderer2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._PopUpMediaBrowserSkin_AxisRenderer2 = _loc_1;
            BindingManager.executeBindings(this, "_PopUpMediaBrowserSkin_AxisRenderer2", this._PopUpMediaBrowserSkin_AxisRenderer2);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_LineChart1_i() : LineChart
        {
            var _loc_1:* = new LineChart();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.dataTipFunction = this.lineSeriesDataTipFunction;
            _loc_1.showDataTips = true;
            _loc_1.series = [this._PopUpMediaBrowserSkin_LineSeries1_i()];
            _loc_1.horizontalAxis = this._PopUpMediaBrowserSkin_CategoryAxis3_i();
            _loc_1.horizontalAxisRenderers = [this._PopUpMediaBrowserSkin_AxisRenderer3_i()];
            _loc_1.id = "lineChart";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.lineChart = _loc_1;
            BindingManager.executeBindings(this, "lineChart", this.lineChart);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_LineSeries1_i() : LineSeries
        {
            var _loc_1:* = new LineSeries();
            _loc_1.yField = "value";
            _loc_1.id = "lineSeries";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.lineSeries = _loc_1;
            BindingManager.executeBindings(this, "lineSeries", this.lineSeries);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_CategoryAxis3_i() : CategoryAxis
        {
            var _loc_1:* = new CategoryAxis();
            _loc_1.categoryField = "name";
            this.lineAxis = _loc_1;
            BindingManager.executeBindings(this, "lineAxis", this.lineAxis);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_AxisRenderer3_i() : AxisRenderer
        {
            var _loc_1:* = new AxisRenderer();
            _loc_1.setStyle("showLabels", false);
            _loc_1.id = "_PopUpMediaBrowserSkin_AxisRenderer3";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._PopUpMediaBrowserSkin_AxisRenderer3 = _loc_1;
            BindingManager.executeBindings(this, "_PopUpMediaBrowserSkin_AxisRenderer3", this._PopUpMediaBrowserSkin_AxisRenderer3);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_PieChart1_i() : PieChart
        {
            var _loc_1:* = new PieChart();
            _loc_1.left = 1;
            _loc_1.right = 1;
            _loc_1.top = 1;
            _loc_1.bottom = 1;
            _loc_1.dataTipFunction = this.pieSeriesDataTipFunction;
            _loc_1.showDataTips = true;
            _loc_1.series = [this._PopUpMediaBrowserSkin_PieSeries1_i()];
            _loc_1.id = "pieChart";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.pieChart = _loc_1;
            BindingManager.executeBindings(this, "pieChart", this.pieChart);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_PieSeries1_i() : PieSeries
        {
            var _loc_1:* = new PieSeries();
            _loc_1.field = "value";
            _loc_1.labelField = "name";
            _loc_1.nameField = "name";
            _loc_1.id = "pieSeries";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.pieSeries = _loc_1;
            BindingManager.executeBindings(this, "pieSeries", this.pieSeries);
            return _loc_1;
        }// end function

        public function __imageOrChartGroup_resize(event:ResizeEvent) : void
        {
            this.imageOrChartGroup_resizeHandler(event);
            return;
        }// end function

        private function _PopUpMediaBrowserSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.percentHeight = 100;
            _loc_1.setStyle("skinClass", PopUpMediaBrowserNextButtonSkin);
            _loc_1.id = "nextButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.nextButton = _loc_1;
            BindingManager.executeBindings(this, "nextButton", this.nextButton);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("textAlign", "end");
            _loc_1.id = "countLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.countLabel = _loc_1;
            BindingManager.executeBindings(this, "countLabel", this.countLabel);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_Label3_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.setStyle("fontStyle", "italic");
            _loc_1.id = "captionLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.captionLabel = _loc_1;
            BindingManager.executeBindings(this, "captionLabel", this.captionLabel);
            return _loc_1;
        }// end function

        private function _PopUpMediaBrowserSkin_bindingsSetup() : Array
        {
            var _loc_1:Array = [];
            _loc_1[0] = new Binding(this, null, null, "_PopUpMediaBrowserSkin_AxisRenderer1.axis", "barAxis");
            _loc_1[1] = new Binding(this, null, null, "_PopUpMediaBrowserSkin_AxisRenderer2.axis", "columnAxis");
            _loc_1[2] = new Binding(this, null, null, "_PopUpMediaBrowserSkin_AxisRenderer3.axis", "lineAxis");
            return _loc_1;
        }// end function

        public function get barAxis() : CategoryAxis
        {
            return this._334588332barAxis;
        }// end function

        public function set barAxis(value:CategoryAxis) : void
        {
            var _loc_2:* = this._334588332barAxis;
            if (_loc_2 !== value)
            {
                this._334588332barAxis = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "barAxis", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get barChart() : BarChart
        {
            return this._1780940917barChart;
        }// end function

        public function set barChart(value:BarChart) : void
        {
            var _loc_2:* = this._1780940917barChart;
            if (_loc_2 !== value)
            {
                this._1780940917barChart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "barChart", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get barSeries() : BarSeries
        {
            return this._1081199722barSeries;
        }// end function

        public function set barSeries(value:BarSeries) : void
        {
            var _loc_2:* = this._1081199722barSeries;
            if (_loc_2 !== value)
            {
                this._1081199722barSeries = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "barSeries", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get borderRect() : Rect
        {
            return this._1824869424borderRect;
        }// end function

        public function set borderRect(value:Rect) : void
        {
            var _loc_2:* = this._1824869424borderRect;
            if (_loc_2 !== value)
            {
                this._1824869424borderRect = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderRect", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get borderRectSymbol() : SolidColorStroke
        {
            return this._565851672borderRectSymbol;
        }// end function

        public function set borderRectSymbol(value:SolidColorStroke) : void
        {
            var _loc_2:* = this._565851672borderRectSymbol;
            if (_loc_2 !== value)
            {
                this._565851672borderRectSymbol = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "borderRectSymbol", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get captionLabel() : Label
        {
            return this._1094765394captionLabel;
        }// end function

        public function set captionLabel(value:Label) : void
        {
            var _loc_2:* = this._1094765394captionLabel;
            if (_loc_2 !== value)
            {
                this._1094765394captionLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "captionLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get columnAxis() : CategoryAxis
        {
            return this._2106026985columnAxis;
        }// end function

        public function set columnAxis(value:CategoryAxis) : void
        {
            var _loc_2:* = this._2106026985columnAxis;
            if (_loc_2 !== value)
            {
                this._2106026985columnAxis = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnAxis", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get columnChart() : ColumnChart
        {
            return this._860964312columnChart;
        }// end function

        public function set columnChart(value:ColumnChart) : void
        {
            var _loc_2:* = this._860964312columnChart;
            if (_loc_2 !== value)
            {
                this._860964312columnChart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnChart", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get columnSeries() : ColumnSeries
        {
            return this._464296595columnSeries;
        }// end function

        public function set columnSeries(value:ColumnSeries) : void
        {
            var _loc_2:* = this._464296595columnSeries;
            if (_loc_2 !== value)
            {
                this._464296595columnSeries = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnSeries", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get countLabel() : Label
        {
            return this._1053257947countLabel;
        }// end function

        public function set countLabel(value:Label) : void
        {
            var _loc_2:* = this._1053257947countLabel;
            if (_loc_2 !== value)
            {
                this._1053257947countLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "countLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get image() : Image
        {
            return this._100313435image;
        }// end function

        public function set image(value:Image) : void
        {
            var _loc_2:* = this._100313435image;
            if (_loc_2 !== value)
            {
                this._100313435image = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "image", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get imageOrChartGroup() : Group
        {
            return this._1267703681imageOrChartGroup;
        }// end function

        public function set imageOrChartGroup(value:Group) : void
        {
            var _loc_2:* = this._1267703681imageOrChartGroup;
            if (_loc_2 !== value)
            {
                this._1267703681imageOrChartGroup = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageOrChartGroup", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get lineAxis() : CategoryAxis
        {
            return this._1188098485lineAxis;
        }// end function

        public function set lineAxis(value:CategoryAxis) : void
        {
            var _loc_2:* = this._1188098485lineAxis;
            if (_loc_2 !== value)
            {
                this._1188098485lineAxis = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineAxis", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get lineChart() : LineChart
        {
            return this._1822289846lineChart;
        }// end function

        public function set lineChart(value:LineChart) : void
        {
            var _loc_2:* = this._1822289846lineChart;
            if (_loc_2 !== value)
            {
                this._1822289846lineChart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineChart", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get lineSeries() : LineSeries
        {
            return this._200617077lineSeries;
        }// end function

        public function set lineSeries(value:LineSeries) : void
        {
            var _loc_2:* = this._200617077lineSeries;
            if (_loc_2 !== value)
            {
                this._200617077lineSeries = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineSeries", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get nextButton() : Button
        {
            return this._1749722107nextButton;
        }// end function

        public function set nextButton(value:Button) : void
        {
            var _loc_2:* = this._1749722107nextButton;
            if (_loc_2 !== value)
            {
                this._1749722107nextButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nextButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get numberFormatter() : NumberFormatter
        {
            return this._1060399231numberFormatter;
        }// end function

        public function set numberFormatter(value:NumberFormatter) : void
        {
            var _loc_2:* = this._1060399231numberFormatter;
            if (_loc_2 !== value)
            {
                this._1060399231numberFormatter = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numberFormatter", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pieChart() : PieChart
        {
            return this._718516814pieChart;
        }// end function

        public function set pieChart(value:PieChart) : void
        {
            var _loc_2:* = this._718516814pieChart;
            if (_loc_2 !== value)
            {
                this._718516814pieChart = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pieChart", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pieSeries() : PieSeries
        {
            return this._343391453pieSeries;
        }// end function

        public function set pieSeries(value:PieSeries) : void
        {
            var _loc_2:* = this._343391453pieSeries;
            if (_loc_2 !== value)
            {
                this._343391453pieSeries = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pieSeries", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get previousButton() : Button
        {
            return this._498435831previousButton;
        }// end function

        public function set previousButton(value:Button) : void
        {
            var _loc_2:* = this._498435831previousButton;
            if (_loc_2 !== value)
            {
                this._498435831previousButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "previousButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get titleLabel() : Label
        {
            return this._1791483012titleLabel;
        }// end function

        public function set titleLabel(value:Label) : void
        {
            var _loc_2:* = this._1791483012titleLabel;
            if (_loc_2 !== value)
            {
                this._1791483012titleLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "titleLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : PopUpMediaBrowser
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:PopUpMediaBrowser) : void
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
            PopUpMediaBrowserSkin._watcherSetupUtil = watcherSetupUtil;
            return;
        }// end function

    }
}
