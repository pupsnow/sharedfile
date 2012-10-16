package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import flash.utils.*;
    import mx.collections.*;
    import mx.core.*;
    import mx.events.*;
    import mx.logging.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.globalization.*;

    public class AttributeInspector extends SkinnableComponent
    {
        public var list:ListBase;
        public var nextButton:ButtonBase;
        public var previousButton:ButtonBase;
        public var deleteButton:ButtonBase;
        public var okButton:ButtonBase;
        public var editSummaryLabel:Label;
        private const m_log:ILogger;
        private var m_invalidSources:Array;
        private var m_sortingCollator:SortingCollator;
        private var m_formDescriptors:Array;
        private var m_activeFormDescriptorChanged:Boolean = false;
        private var m_activeFormDescriptor:FormDescriptor = null;
        private var _761646858fieldInspectors:Array;
        private var m_activeFeatureIndex:int = -1;
        private var m_activeFeatureIndexChanged:Boolean = false;
        private var m_featureLayers:Array;
        private var m_formFieldsOrder:String = "fields";
        private var m_formFieldsChanged:Boolean = false;
        private var m_singleToMultilineThreshold:Number = 40;
        private var m_singleToMultilineThresholdChanged:Boolean = false;
        private var m_showGlobalID:Boolean = false;
        private var m_showObjectID:Boolean = false;
        private var m_deleteButtonVisible:Boolean = true;
        private var m_updateEnabled:Boolean = true;
        private var m_updateEnabledChanged:Boolean = false;
        private var m_infoWindowLabel:String;
        public static const FIELD_INSPECTOR_ORDER:String = "fieldInspector";
        public static const ALPHABETICAL_ORDER:String = "alphabetical";
        public static const FIELDS_ORDER:String = "fields";
        private static var _skinParts:Object = {editSummaryLabel:false, nextButton:false, previousButton:false, deleteButton:false, list:true, okButton:false};

        public function AttributeInspector(featureLayers:Array = null)
        {
            this.m_log = Log.getLogger(getQualifiedClassName(this).replace(/::/, "."));
            this.m_invalidSources = [];
            this.m_formDescriptors = [];
            this._761646858fieldInspectors = [];
            this.featureLayers = featureLayers;
            this.m_sortingCollator = new SortingCollator();
            this.m_sortingCollator.setStyle("locale", resourceManager.localeChain[0]);
            addEventListener(UpdateFeatureTypeEvent.UPDATE_FEATURE_TYPE, this.updateFeatureTypeHandler);
            addEventListener(ValidationResultEvent.INVALID, this.invalidHandler);
            return;
        }// end function

        private function setActiveFormDescriptor(value:FormDescriptor) : void
        {
            if (this.m_activeFormDescriptor != value)
            {
                if (this.m_activeFormDescriptor)
                {
                    this.m_activeFormDescriptor.unselectFeature();
                }
                this.m_activeFormDescriptor = value;
                this.m_activeFormDescriptorChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get activeFeatureIndex() : int
        {
            return this.m_activeFeatureIndex;
        }// end function

        public function set activeFeatureIndex(value:int) : void
        {
            if (this.m_activeFeatureIndex !== value)
            {
                this.activeFeatureIndex$ = value;
            }
            return;
        }// end function

        private function set activeFeatureIndex$(value:int) : void
        {
            this.m_activeFeatureIndex = value;
            this.m_activeFeatureIndexChanged = true;
            this.updateActiveFeature();
            invalidateProperties();
            invalidateSkinState();
            return;
        }// end function

        public function get featureLayers() : Array
        {
            return this.m_featureLayers;
        }// end function

        private function set _1730434088featureLayers(value:Array) : void
        {
            var _loc_4:FormDescriptor = null;
            var _loc_5:FeatureLayer = null;
            var _loc_6:FeatureLayer = null;
            var _loc_8:int = 0;
            var _loc_9:FormDescriptor = null;
            var _loc_10:uint = 0;
            var _loc_2:* = this.activeFeatureLayer;
            var _loc_3:* = this.activeFeature;
            var _loc_7:* = this.m_formDescriptors.length - 1;
            while (_loc_7 >= 0)
            {
                
                _loc_4 = this.m_formDescriptors[_loc_7];
                if (_loc_4)
                {
                }
                if (_loc_4.featureLayer)
                {
                }
                if (value.lastIndexOf(_loc_4.featureLayer) == -1)
                {
                    if (_loc_4 == this.m_activeFormDescriptor)
                    {
                        this.m_activeFormDescriptor = null;
                        this.m_activeFeatureIndex = -1;
                    }
                    _loc_4.featureLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsCompleteHandler);
                    _loc_4.featureLayer.removeEventListener(FeatureLayerEvent.SELECTION_CLEAR, this.featureLayer_selectionClearHandler);
                    _loc_4.featureLayer.removeEventListener(FeatureLayerEvent.SELECTION_COMPLETE, this.featureLayer_selectionCompleteHandler);
                    this.m_formDescriptors.splice(_loc_7, 1);
                }
                _loc_7 = _loc_7 - 1;
            }
            if (!this.m_activeFormDescriptor)
            {
                this.disposeListDataProvider();
            }
            this.m_featureLayers = value;
            for each (_loc_5 in this.m_featureLayers)
            {
                
                if (_loc_5)
                {
                }
                if (this.findFormDescriptor(_loc_5) == null)
                {
                    _loc_5.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsCompleteHandler);
                    _loc_5.addEventListener(FeatureLayerEvent.SELECTION_CLEAR, this.featureLayer_selectionClearHandler);
                    _loc_5.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE, this.featureLayer_selectionCompleteHandler);
                    this.addFormData(_loc_5, _loc_5.selectedFeatures);
                }
            }
            if (this.numFeatures > 0)
            {
                _loc_8 = 0;
                if (_loc_2)
                {
                }
                if (_loc_3)
                {
                    _loc_9 = this.findFormDescriptor(_loc_2);
                    if (_loc_9)
                    {
                        _loc_10 = _loc_9.indexOf(_loc_3);
                        if (_loc_10 != -1)
                        {
                            _loc_9.selectFeature(_loc_10);
                            this.updateActiveFeatureIndex();
                        }
                    }
                }
                this.activeFeatureIndex$ = _loc_8;
            }
            this.dispatchFormDataArrChanged();
            return;
        }// end function

        public function get formFieldsOrder() : String
        {
            return this.m_formFieldsOrder;
        }// end function

        private function set _420143951formFieldsOrder(value:String) : void
        {
            if (this.m_formFieldsOrder !== value)
            {
                this.m_formFieldsOrder = value;
                this.m_formFieldsChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get singleToMultilineThreshold() : Number
        {
            return this.m_singleToMultilineThreshold;
        }// end function

        private function set _705348479singleToMultilineThreshold(value:Number) : void
        {
            if (this.m_singleToMultilineThreshold != value)
            {
                this.m_singleToMultilineThreshold = value;
                this.m_singleToMultilineThresholdChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get showGlobalID() : Boolean
        {
            return this.m_showGlobalID;
        }// end function

        private function set _1393647077showGlobalID(value:Boolean) : void
        {
            if (this.m_showGlobalID !== value)
            {
                this.m_showGlobalID = value;
                this.m_formFieldsChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get showObjectID() : Boolean
        {
            return this.m_showObjectID;
        }// end function

        private function set _761476425showObjectID(value:Boolean) : void
        {
            if (this.m_showObjectID !== value)
            {
                this.m_showObjectID = value;
                this.m_formFieldsChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get deleteButtonVisible() : Boolean
        {
            return this.m_deleteButtonVisible;
        }// end function

        private function set _1419230453deleteButtonVisible(value:Boolean) : void
        {
            if (this.m_deleteButtonVisible != value)
            {
                this.m_deleteButtonVisible = value;
                invalidateProperties();
            }
            return;
        }// end function

        public function get updateEnabled() : Boolean
        {
            return this.m_updateEnabled;
        }// end function

        private function set _1189422648updateEnabled(value:Boolean) : void
        {
            if (this.m_updateEnabled != value)
            {
                this.m_updateEnabled = value;
                this.m_updateEnabledChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get infoWindowLabel() : String
        {
            return this.m_infoWindowLabel;
        }// end function

        public function set infoWindowLabel(value:String) : void
        {
            if (this.m_infoWindowLabel != value)
            {
                this.m_infoWindowLabel = value;
                dispatchEvent(new Event("infoWindowLabelChanged", true));
            }
            return;
        }// end function

        public function get activeFeature() : Graphic
        {
            if (this.m_activeFeatureIndex !== -1)
            {
            }
            if (!this.m_activeFormDescriptor)
            {
                return null;
            }
            return this.m_activeFormDescriptor.activeFeature;
        }// end function

        private function setActiveFeature(value:Graphic) : void
        {
            var _loc_2:FormDescriptor = null;
            var _loc_3:int = 0;
            if (this.activeFeature != value)
            {
                for each (_loc_2 in this.m_formDescriptors)
                {
                    
                    if (_loc_2.contains(value))
                    {
                        _loc_3 = _loc_2.indexOf(value);
                        if (this.m_activeFormDescriptor)
                        {
                            this.m_activeFormDescriptor.unselectFeature();
                        }
                        _loc_2.selectFeature(_loc_3);
                        this.setActiveFormDescriptor(_loc_2);
                        this.updateActiveFeatureIndex();
                        this.dispatchFormDataArrChanged();
                        dispatchEvent(new Event("activeFeatureChanged"));
                        if (hasEventListener(AttributeInspectorEvent.SHOW_FEATURE))
                        {
                            dispatchEvent(new AttributeInspectorEvent(AttributeInspectorEvent.SHOW_FEATURE, false, this.m_activeFormDescriptor.featureLayer, this.m_activeFormDescriptor.activeFeature));
                        }
                    }
                }
            }
            return;
        }// end function

        public function get activeFeatureLayer() : FeatureLayer
        {
            if (this.m_activeFeatureIndex !== -1)
            {
            }
            if (!this.m_activeFormDescriptor)
            {
                return null;
            }
            return this.m_activeFormDescriptor.featureLayer;
        }// end function

        public function get activeFeatureLayerEditable() : Boolean
        {
            if (this.m_activeFeatureIndex !== -1)
            {
            }
            if (!this.m_activeFormDescriptor)
            {
                return false;
            }
            return this.m_activeFormDescriptor.featureLayer.isEditable;
        }// end function

        public function get numFeatures() : int
        {
            var num:int;
            num;
            if (this.m_formDescriptors)
            {
            }
            if (this.m_formDescriptors.length > 0)
            {
                this.m_formDescriptors.map(function (aifd:FormDescriptor, index:int, array:Array) : void
            {
                num = num + aifd.numFeatures;
                return;
            }// end function
            );
            }
            return num;
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

        public function next() : void
        {
            if (this.activeFeatureIndex < (this.numFeatures - 1))
            {
                var _loc_1:String = this;
                var _loc_2:* = this.activeFeatureIndex + 1;
                _loc_1.activeFeatureIndex = _loc_2;
            }
            return;
        }// end function

        public function previous() : void
        {
            if (this.activeFeatureIndex > 0)
            {
                var _loc_1:String = this;
                var _loc_2:* = this.activeFeatureIndex - 1;
                _loc_1.activeFeatureIndex = _loc_2;
            }
            return;
        }// end function

        public function deleteActiveFeature() : void
        {
            if (this.activeFeatureIndex > -1)
            {
            }
            if (hasEventListener(AttributeInspectorEvent.DELETE_FEATURE))
            {
                dispatchEvent(new AttributeInspectorEvent(AttributeInspectorEvent.DELETE_FEATURE, false, this.m_activeFormDescriptor.featureLayer, this.m_activeFormDescriptor.activeFeature));
            }
            return;
        }// end function

        public function saveActiveFeature() : void
        {
            var _loc_1:AttributeInspectorEvent = null;
            if (this.activeFeatureIndex > -1)
            {
            }
            if (hasEventListener(AttributeInspectorEvent.SAVE_FEATURE))
            {
                _loc_1 = new AttributeInspectorEvent(AttributeInspectorEvent.SAVE_FEATURE, false);
                _loc_1.featureLayer = this.m_activeFormDescriptor.featureLayer;
                _loc_1.feature = this.m_activeFormDescriptor.activeFeature;
                callLater(this.dispatchSaveFeatureEvent, [_loc_1]);
            }
            return;
        }// end function

        private function dispatchSaveFeatureEvent(event:AttributeInspectorEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_1:FeatureLayer = null;
            this.activeFeatureIndex = -1;
            this.disposeListDataProvider();
            this.m_formDescriptors.length = 0;
            for each (_loc_1 in this.m_featureLayers)
            {
                
                this.addFormData(_loc_1, _loc_1.selectedFeatures);
            }
            if (this.numFeatures > 0)
            {
                this.activeFeatureIndex = 0;
            }
            this.dispatchFormDataArrChanged();
            return;
        }// end function

        public function refreshActiveFeature() : void
        {
            if (this.list)
            {
            }
            if (this.activeFeature)
            {
                if (hasEventListener(AttributeInspectorEvent.SHOW_FEATURE))
                {
                    dispatchEvent(new AttributeInspectorEvent(AttributeInspectorEvent.SHOW_FEATURE, false, this.m_activeFormDescriptor.featureLayer, this.m_activeFormDescriptor.activeFeature));
                }
                this.updateActiveFeature();
            }
            return;
        }// end function

        protected function createFormItemComponent(featureLayer:FeatureLayer, field:Field, fieldInspector:FieldInspector, fieldValue:Object) : UIComponent
        {
            var renderer:UIComponent;
            var labelField:LabelField;
            var group:Group;
            var memoArea:MemoArea;
            var typeField:TypeField;
            var domain:IDomain;
            var codedValueDomainField1:CodedValueDomainField;
            var codedValueDomainField2:CodedValueDomainField;
            var textField:TextField;
            var stringField:StringField;
            var doubleField:DoubleField;
            var integerField:IntegerField;
            var calendarField:CalendarField;
            var singleField:SingleField;
            var smallField:SmallIntegerField;
            var featureLayer:* = featureLayer;
            var field:* = field;
            var fieldInspector:* = fieldInspector;
            var fieldValue:* = fieldValue;
            var setMaxCharsEditable:* = function (textInput:TextInput, field:Field) : void
            {
                if (field.length > 0)
                {
                    textInput.maxChars = field.length;
                }
                return;
            }// end function
            ;
            var formDescriptor:* = this.findFormDescriptor(featureLayer);
            if (fieldInspector)
            {
            }
            if (fieldInspector.memo)
            {
                group = new HGroup();
                memoArea = new MemoArea(fieldValue);
                memoArea.toolTip = fieldInspector.toolTip;
                group.addElement(memoArea);
                group.addElement(new MemoButton(memoArea, this.getFormItemLabel(featureLayer, field, fieldInspector)));
                return group;
            }
            if (fieldInspector)
            {
            }
            if (fieldInspector.editor)
            {
                renderer = fieldInspector.editor.newInstance() as UIComponent;
                if (renderer is IDataRenderer)
                {
                    IDataRenderer(renderer).data = fieldValue;
                }
                if (this.updateEnabled)
                {
                }
                renderer.enabled = field.editable;
            }
            if (!renderer)
            {
            }
            if (field.name === featureLayer.typeIdField)
            {
                typeField = new TypeField(fieldValue, featureLayer, field.editable);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    renderer = typeField;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                typeField.data = data;
                return FeatureType(typeField.selectedItem).name;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (formDescriptor.activeFeatureType)
            {
            }
            if (formDescriptor.activeFeatureType.domains)
            {
                domain = formDescriptor.activeFeatureType.domains[field.name];
                if (domain is CodedValueDomain)
                {
                    codedValueDomainField1 = new CodedValueDomainField(domain as CodedValueDomain, fieldValue, field.editable);
                    if (this.updateEnabled)
                    {
                    }
                    if (field.editable)
                    {
                        renderer = codedValueDomainField1;
                    }
                    else
                    {
                        labelField = new LabelField();
                        labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                codedValueDomainField1.data = data;
                return CodedValue(codedValueDomainField1.selectedItem).name;
            }// end function
            ;
                        labelField.data = fieldValue;
                        renderer = labelField;
                    }
                }
                if (domain is RangeDomain)
                {
                    renderer = this.getRangeDomainField(field, fieldValue, labelField, domain as RangeDomain);
                }
            }
            if (!renderer)
            {
            }
            if (field.domain is CodedValueDomain)
            {
                codedValueDomainField2 = new CodedValueDomainField(field.domain as CodedValueDomain, fieldValue, field.editable);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    renderer = codedValueDomainField2;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                codedValueDomainField2.data = data;
                return CodedValue(codedValueDomainField2.selectedItem).name;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (field.domain is RangeDomain)
            {
                return this.getRangeDomainField(field, fieldValue, labelField, field.domain as RangeDomain);
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_STRING)
            {
                if (field.length > formDescriptor.singleToMultilineThreshold)
                {
                    textField = new TextField(fieldValue);
                    if (this.updateEnabled)
                    {
                    }
                    if (field.editable)
                    {
                        textField.maxChars = field.length;
                        renderer = textField;
                    }
                    else
                    {
                        labelField = new LabelField();
                        labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                textField.data = data;
                return textField.text;
            }// end function
            ;
                        labelField.data = fieldValue;
                        renderer = labelField;
                    }
                }
                else
                {
                    stringField = new StringField(fieldValue);
                    if (this.updateEnabled)
                    {
                    }
                    if (field.editable)
                    {
                        this.setMaxCharsEditable(stringField, field);
                        renderer = stringField;
                    }
                    else
                    {
                        labelField = new LabelField();
                        labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                stringField.data = data;
                return stringField.text;
            }// end function
            ;
                        labelField.data = fieldValue;
                        renderer = labelField;
                    }
                }
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_DOUBLE)
            {
                doubleField = new DoubleField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    this.setMaxCharsEditable(doubleField, field);
                    renderer = doubleField;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                doubleField.data = data;
                return doubleField.text;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_INTEGER)
            {
                integerField = new IntegerField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    this.setMaxCharsEditable(integerField, field);
                    renderer = integerField;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                integerField.data = data;
                return integerField.text;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_DATE)
            {
                calendarField = new CalendarField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    renderer = calendarField;
                }
                else if (fieldValue)
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                calendarField.data = data as Number;
                return calendarField.formatDate(calendarField.selectedDate);
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_SINGLE)
            {
                singleField = new SingleField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    this.setMaxCharsEditable(singleField, field);
                    renderer = singleField;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                singleField.data = data;
                return singleField.text;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
            }
            if (field.type === Field.TYPE_SMALL_INTEGER)
            {
                smallField = new SmallIntegerField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    this.setMaxCharsEditable(smallField, field);
                    renderer = smallField;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                smallField.data = data;
                return smallField.text;
            }// end function
            ;
                    labelField.data = fieldValue;
                    renderer = labelField;
                }
            }
            if (!renderer)
            {
                renderer = new LabelField(fieldValue);
            }
            if (fieldInspector)
            {
            }
            if (renderer)
            {
                renderer.toolTip = fieldInspector.toolTip;
            }
            return renderer;
        }// end function

        private function getRangeDomainField(field:Field, fieldValue:Object, labelField:LabelField, rangeDomain:RangeDomain) : UIComponent
        {
            var result:UIComponent;
            var calendarField:CalendarField;
            var range:RangeDomainField;
            var field:* = field;
            var fieldValue:* = fieldValue;
            var labelField:* = labelField;
            var rangeDomain:* = rangeDomain;
            if (field.type == Field.TYPE_DATE)
            {
                calendarField = new CalendarField(fieldValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    calendarField.disabledRanges = [{rangeEnd:new Date(rangeDomain.minValue)}, {rangeStart:new Date(rangeDomain.maxValue)}];
                    result = calendarField;
                }
                else if (fieldValue)
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                calendarField.data = data as Number;
                return calendarField.formatDate(calendarField.selectedDate);
            }// end function
            ;
                    labelField.data = fieldValue;
                    result = labelField;
                }
            }
            else
            {
                range = new RangeDomainField(fieldValue as Number, rangeDomain.minValue, rangeDomain.maxValue);
                if (this.updateEnabled)
                {
                }
                if (field.editable)
                {
                    result = range;
                }
                else
                {
                    labelField = new LabelField();
                    labelField.labelFunction = function (data:Object) : String
            {
                if (!data)
                {
                    return null;
                }
                range.data = data as Number;
                return range.text;
            }// end function
            ;
                    labelField.data = fieldValue;
                    result = labelField;
                }
            }
            return result;
        }// end function

        protected function getFormItemLabel(featureLayer:FeatureLayer, field:Field, fieldInspector:FieldInspector) : String
        {
            if (fieldInspector)
            {
            }
            if (fieldInspector.label)
            {
                return fieldInspector.label;
            }
            if (field.alias)
            {
                return field.alias;
            }
            return field.name;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_2:FormDescriptor = null;
            super.commitProperties();
            var _loc_1:Boolean = false;
            if (this.m_formFieldsChanged)
            {
                this.m_formFieldsChanged = false;
                _loc_1 = true;
            }
            if (this.m_updateEnabledChanged)
            {
                this.m_updateEnabledChanged = false;
                for each (_loc_2 in this.m_formDescriptors)
                {
                    
                    _loc_2.updateEnabled = this.m_updateEnabled;
                }
                _loc_1 = true;
            }
            if (this.m_singleToMultilineThresholdChanged)
            {
                this.m_singleToMultilineThresholdChanged = false;
                for each (_loc_2 in this.m_formDescriptors)
                {
                    
                    _loc_2.singleToMultilineThreshold = this.m_singleToMultilineThreshold;
                }
                _loc_1 = true;
            }
            if (this.m_activeFormDescriptorChanged)
            {
                this.m_activeFormDescriptorChanged = false;
                _loc_1 = true;
            }
            if (this.activeFeatureIndex === -1)
            {
                if (this.previousButton)
                {
                    this.previousButton.visible = false;
                    this.previousButton.enabled = false;
                }
                if (this.deleteButton)
                {
                    this.deleteButton.includeInLayout = false;
                    this.deleteButton.visible = false;
                    this.deleteButton.enabled = false;
                }
                if (this.nextButton)
                {
                    this.nextButton.visible = false;
                    this.nextButton.enabled = false;
                }
            }
            else
            {
                if (this.numFeatures === 1)
                {
                    if (this.previousButton)
                    {
                        this.previousButton.visible = false;
                        this.previousButton.enabled = false;
                    }
                    if (this.nextButton)
                    {
                        this.nextButton.visible = false;
                        this.nextButton.enabled = false;
                    }
                }
                else
                {
                    if (this.previousButton)
                    {
                        this.previousButton.visible = true;
                        this.previousButton.enabled = this.activeFeatureIndex > 0;
                    }
                    if (this.nextButton)
                    {
                        this.nextButton.visible = true;
                        if (this.activeFeatureIndex > -1)
                        {
                        }
                        this.nextButton.enabled = this.activeFeatureIndex < (this.numFeatures - 1);
                    }
                }
                if (this.deleteButton)
                {
                    if (this.activeFeatureLayer)
                    {
                    }
                    if (this.m_deleteButtonVisible)
                    {
                        var _loc_3:* = this.activeFeatureLayer.isEditable;
                        this.deleteButton.includeInLayout = this.activeFeatureLayer.isEditable;
                        var _loc_3:* = _loc_3;
                        this.deleteButton.visible = _loc_3;
                        this.deleteButton.enabled = _loc_3;
                    }
                    else
                    {
                        var _loc_3:Boolean = false;
                        this.deleteButton.includeInLayout = false;
                        this.deleteButton.visible = _loc_3;
                    }
                }
                if (this.okButton)
                {
                    if (this.activeFeatureLayer)
                    {
                        var _loc_3:* = this.activeFeatureLayer.isEditable;
                        this.okButton.includeInLayout = this.activeFeatureLayer.isEditable;
                        this.okButton.visible = _loc_3;
                    }
                    else
                    {
                        var _loc_3:Boolean = false;
                        this.okButton.includeInLayout = false;
                        this.okButton.visible = _loc_3;
                    }
                }
                if (this.editSummaryLabel)
                {
                    this.updateEditSummaryLabel();
                }
            }
            if (_loc_1)
            {
                this.updateListDataProvider(this.m_activeFormDescriptor);
            }
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (enabled === false)
            {
                return "disabled";
            }
            if (this.m_invalidSources.length > 0)
            {
                return "invalid";
            }
            if (this.m_activeFeatureIndex === -1)
            {
                return "disabled";
            }
            return "normal";
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.list)
            {
                this.list.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.list_propertyChangeHandler);
            }
            if (instance === this.deleteButton)
            {
                var _loc_3:Boolean = false;
                this.deleteButton.visible = false;
                this.deleteButton.includeInLayout = _loc_3;
                this.deleteButton.addEventListener(MouseEvent.CLICK, this.deleteButton_clickHandler);
                this.deleteButton.addEventListener(KeyboardEvent.KEY_UP, this.deleteButton_keyUpHandler);
            }
            if (instance === this.okButton)
            {
                var _loc_3:Boolean = false;
                this.okButton.visible = false;
                this.okButton.includeInLayout = _loc_3;
                this.okButton.addEventListener(MouseEvent.CLICK, this.okButton_clickHandler);
                this.okButton.addEventListener(KeyboardEvent.KEY_UP, this.okButton_keyUpHandler);
            }
            else if (instance === this.previousButton)
            {
                this.previousButton.addEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
                this.previousButton.addEventListener(KeyboardEvent.KEY_UP, this.previousButton_keyUpHandler);
            }
            else if (instance === this.nextButton)
            {
                this.nextButton.addEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
                this.nextButton.addEventListener(KeyboardEvent.KEY_UP, this.nextButton_keyUpHandler);
            }
            if (instance === this.editSummaryLabel)
            {
                var _loc_3:Boolean = false;
                this.editSummaryLabel.visible = false;
                this.editSummaryLabel.includeInLayout = _loc_3;
            }
            else if (instance === this.list)
            {
                this.refreshActiveFeature();
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.deleteButton)
            {
                this.deleteButton.removeEventListener(MouseEvent.CLICK, this.deleteButton_clickHandler);
                this.deleteButton.removeEventListener(KeyboardEvent.KEY_UP, this.deleteButton_keyUpHandler);
            }
            if (instance === this.okButton)
            {
                this.okButton.removeEventListener(MouseEvent.CLICK, this.okButton_clickHandler);
                this.okButton.removeEventListener(KeyboardEvent.KEY_UP, this.okButton_keyUpHandler);
            }
            else if (instance === this.previousButton)
            {
                this.previousButton.removeEventListener(MouseEvent.CLICK, this.previousButton_clickHandler);
                this.previousButton.removeEventListener(KeyboardEvent.KEY_UP, this.previousButton_keyUpHandler);
            }
            else if (instance === this.nextButton)
            {
                this.nextButton.removeEventListener(MouseEvent.CLICK, this.nextButton_clickHandler);
                this.nextButton.removeEventListener(KeyboardEvent.KEY_UP, this.nextButton_keyUpHandler);
            }
            else if (instance === this.list)
            {
                this.disposeListDataProvider();
            }
            return;
        }// end function

        private function dispatchUpdateFeatureAttributeEvent(source:DisplayObject, newValue:Object) : void
        {
            var _loc_4:Field = null;
            var _loc_5:Object = null;
            var _loc_6:AttributeInspectorEvent = null;
            var _loc_3:* = this.findFieldFromRenderer(source);
            if (_loc_3)
            {
            }
            if (_loc_3.feature)
            {
                _loc_4 = _loc_3.field as Field;
                if (_loc_4)
                {
                    _loc_5 = _loc_3.feature.attributes[_loc_4.name];
                    if (_loc_5 != newValue)
                    {
                        _loc_6 = new AttributeInspectorEvent(AttributeInspectorEvent.UPDATE_FEATURE, true);
                        _loc_6.featureLayer = _loc_3.featureLayer;
                        _loc_6.feature = _loc_3.feature;
                        _loc_6.field = _loc_4;
                        _loc_6.oldValue = _loc_5;
                        _loc_6.newValue = newValue;
                        source.dispatchEvent(_loc_6);
                    }
                }
            }
            return;
        }// end function

        private function dispatchUpdateFeatureTypeEvent(source:DisplayObject, featureType:FeatureType) : void
        {
            var _loc_4:Field = null;
            var _loc_5:UpdateFeatureTypeEvent = null;
            var _loc_3:* = this.findFieldFromRenderer(source);
            if (_loc_3)
            {
            }
            if (_loc_3.feature)
            {
                _loc_4 = _loc_3.field as Field;
                if (_loc_4)
                {
                    _loc_5 = new UpdateFeatureTypeEvent();
                    _loc_5.featureLayer = _loc_3.featureLayer;
                    _loc_5.graphic = _loc_3.feature;
                    _loc_5.field = _loc_4;
                    _loc_5.featureType = featureType;
                    source.dispatchEvent(_loc_5);
                }
            }
            return;
        }// end function

        private function updateActiveFeature() : void
        {
            var newLocalIndex:int;
            var formDescriptor:FormDescriptor;
            if (this.editSummaryLabel)
            {
            }
            if (this.activeFeature)
            {
                this.updateEditSummaryLabel();
            }
            var oldActiveFeature:* = this.activeFeature;
            if (this.m_activeFeatureIndex === -1)
            {
            }
            if (this.m_activeFormDescriptor)
            {
                this.m_activeFormDescriptor.unselectFeature();
                this.m_activeFormDescriptor = null;
                return;
            }
            if (this.m_activeFeatureIndex === -1)
            {
                return;
            }
            newLocalIndex = this.m_activeFeatureIndex;
            this.m_formDescriptors.every(function (aifd:FormDescriptor, index:int, array:Array) : Boolean
            {
                formDescriptor = aifd;
                if (!aifd.hasFeatures)
                {
                    return true;
                }
                if (newLocalIndex <= (aifd.numFeatures - 1))
                {
                    return false;
                }
                newLocalIndex = newLocalIndex - aifd.numFeatures;
                return true;
            }// end function
            );
            if (formDescriptor)
            {
            }
            if (newLocalIndex >= 0)
            {
            }
            if (newLocalIndex >= formDescriptor.numFeatures)
            {
                this.m_log.error("new feature index overflow");
                return;
            }
            this.setActiveFormDescriptor(formDescriptor);
            if (this.m_activeFormDescriptor)
            {
            }
            if (this.m_activeFormDescriptor.numFeatures > newLocalIndex)
            {
                this.m_activeFormDescriptor.selectFeature(newLocalIndex);
            }
            else
            {
                this.m_activeFeatureIndex = -1;
            }
            if (this.activeFeature !== oldActiveFeature)
            {
                dispatchEvent(new Event("activeFeatureChanged"));
                if (hasEventListener(AttributeInspectorEvent.SHOW_FEATURE))
                {
                    dispatchEvent(new AttributeInspectorEvent(AttributeInspectorEvent.SHOW_FEATURE, false, this.m_activeFormDescriptor.featureLayer, this.m_activeFormDescriptor.activeFeature));
                }
            }
            return;
        }// end function

        private function updateActiveFeatureIndex() : void
        {
            var _loc_3:FormDescriptor = null;
            var _loc_4:int = 0;
            var _loc_1:int = 0;
            var _loc_2:Boolean = false;
            if (this.numFeatures > 0)
            {
                _loc_4 = 0;
                do
                {
                    
                    _loc_3 = this.m_formDescriptors[_loc_4];
                    if (_loc_3 === this.m_activeFormDescriptor)
                    {
                        _loc_1 = _loc_1 + _loc_3.activeFeatureIndex;
                        _loc_2 = true;
                    }
                    else
                    {
                        _loc_1 = _loc_1 + _loc_3.numFeatures;
                    }
                    _loc_4 = _loc_4 + 1;
                    if (!_loc_2)
                    {
                    }
                }while (_loc_4 < this.m_formDescriptors.length)
            }
            if (_loc_2)
            {
                this.m_activeFeatureIndex = _loc_1;
            }
            else
            {
                this.m_activeFeatureIndex = -1;
                this.disposeListDataProvider();
            }
            this.m_activeFeatureIndexChanged = true;
            this.updateActiveFeature();
            invalidateProperties();
            invalidateSkinState();
            return;
        }// end function

        private function addFormData(featureLayer:FeatureLayer, features:Array) : void
        {
            var _loc_4:Graphic = null;
            var _loc_3:* = this.findFormDescriptor(featureLayer);
            if (!_loc_3)
            {
                _loc_3 = new FormDescriptor(featureLayer);
                this.m_formDescriptors.push(_loc_3);
            }
            for each (_loc_4 in features)
            {
                
                _loc_3.addFeature(_loc_4);
            }
            return;
        }// end function

        private function updateListDataProvider(formDescriptor:FormDescriptor) : void
        {
            var _loc_6:String = null;
            var _loc_7:FeatureLayerDetails = null;
            var _loc_8:Field = null;
            var _loc_9:FeatureTableDetails = null;
            var _loc_10:Field = null;
            var _loc_11:Field = null;
            var _loc_12:FieldInspector = null;
            var _loc_13:FormField = null;
            this.disposeListDataProvider();
            if (!formDescriptor)
            {
                return;
            }
            var _loc_2:* = formDescriptor.featureLayer;
            var _loc_3:* = formDescriptor.activeFeature;
            var _loc_4:Array = [];
            var _loc_5:Array = [];
            if (_loc_2.outFields)
            {
            }
            if (_loc_2.outFields.length > 0)
            {
                if (_loc_2.outFields.indexOf("*") != -1)
                {
                    if (_loc_2.layerDetails)
                    {
                        for each (_loc_8 in _loc_2.layerDetails.fields)
                        {
                            
                            _loc_7 = _loc_2.layerDetails as FeatureLayerDetails;
                            if (_loc_7)
                            {
                            }
                            if (_loc_7.editFieldsInfo)
                            {
                                if (_loc_8.name != _loc_7.editFieldsInfo.creatorField)
                                {
                                }
                                if (_loc_8.name != _loc_7.editFieldsInfo.creationDateField)
                                {
                                }
                                if (_loc_8.name != _loc_7.editFieldsInfo.editorField)
                                {
                                }
                                if (_loc_8.name == _loc_7.editFieldsInfo.editDateField)
                                {
                                    continue;
                                }
                                _loc_5.push(_loc_8.name);
                                continue;
                            }
                            _loc_5.push(_loc_8.name);
                        }
                    }
                    if (_loc_2.tableDetails)
                    {
                        for each (_loc_10 in _loc_2.tableDetails.fields)
                        {
                            
                            _loc_9 = _loc_2.tableDetails as FeatureTableDetails;
                            if (_loc_9)
                            {
                            }
                            if (_loc_9.editFieldsInfo)
                            {
                                if (_loc_10.name != _loc_9.editFieldsInfo.creatorField)
                                {
                                }
                                if (_loc_10.name != _loc_9.editFieldsInfo.creationDateField)
                                {
                                }
                                if (_loc_10.name != _loc_9.editFieldsInfo.editorField)
                                {
                                }
                                if (_loc_10.name == _loc_9.editFieldsInfo.editDateField)
                                {
                                    continue;
                                }
                                _loc_5.push(_loc_10.name);
                                continue;
                            }
                            _loc_5.push(_loc_10.name);
                        }
                    }
                }
                else
                {
                    _loc_5 = _loc_2.outFields;
                }
            }
            else
            {
                if (_loc_2.layerDetails)
                {
                }
                if (_loc_2.layerDetails.displayField)
                {
                    _loc_5.push(_loc_2.layerDetails.displayField);
                }
                if (_loc_2.tableDetails)
                {
                }
                if (_loc_2.tableDetails.displayField)
                {
                    _loc_5.push(_loc_2.tableDetails.displayField);
                }
            }
            for each (_loc_6 in _loc_5)
            {
                
                _loc_11 = this.findField(_loc_2, _loc_6);
                if (_loc_11)
                {
                    _loc_12 = this.findFieldInspector(_loc_2, _loc_6);
                    _loc_13 = new FormField(_loc_11, _loc_12, formDescriptor);
                    _loc_13.createFormItemComponentFunction = this.createFormItemComponent;
                    _loc_13.formItemLabelFunction = this.getFormItemLabel;
                    if (_loc_12)
                    {
                        if (_loc_12.visible === false)
                        {
                            continue;
                        }
                        if (this.m_formFieldsOrder === FIELD_INSPECTOR_ORDER)
                        {
                            _loc_13.order = _loc_12.formItemOrder - 100;
                        }
                        else if (this.m_formFieldsOrder === FIELDS_ORDER)
                        {
                            _loc_13.order = this.getFormItemOrderBasedOnFields(_loc_11, _loc_5);
                        }
                    }
                    if (_loc_13.order == 0)
                    {
                    }
                    if (this.m_formFieldsOrder === FIELDS_ORDER)
                    {
                        _loc_13.order = this.getFormItemOrderBasedOnFields(_loc_11, _loc_5);
                    }
                    if (_loc_11.type === Field.TYPE_OID)
                    {
                        if (this.m_showObjectID === false)
                        {
                            continue;
                        }
                        _loc_13.order = -9999;
                    }
                    if (_loc_11.type === Field.TYPE_GLOBAL_ID)
                    {
                        if (this.m_showGlobalID === false)
                        {
                            continue;
                        }
                        _loc_13.order = -9998;
                    }
                    if (_loc_11.name === _loc_2.typeIdField)
                    {
                        _loc_13.order = -9997;
                    }
                    _loc_4.push(_loc_13);
                    continue;
                }
                if (Log.isWarn())
                {
                    this.m_log.warn("No field info found for {0}", _loc_6);
                }
            }
            _loc_4.sort(this.compareFunction);
            this.list.dataProvider = new ArrayList(_loc_4);
            return;
        }// end function

        private function disposeListDataProvider() : void
        {
            var _loc_1:ArrayList = null;
            var _loc_2:FormField = null;
            var _loc_3:uint = 0;
            if (this.list)
            {
            }
            if (this.list.dataProvider)
            {
                _loc_1 = ArrayList(this.list.dataProvider);
                this.list.dataProvider = null;
                _loc_3 = 0;
                while (_loc_3 < _loc_1.length)
                {
                    
                    _loc_2 = _loc_1.getItemAt(_loc_3) as FormField;
                    if (_loc_2)
                    {
                        _loc_2.dispose();
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return;
        }// end function

        private function getFormItemOrderBasedOnFields(field:Field, fieldNames:Array) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < fieldNames.length)
            {
                
                if (field.name == fieldNames[_loc_4])
                {
                    _loc_3 = _loc_4 + 1;
                    break;
                    continue;
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        private function compareFunction(lhs:FormField, rhs:FormField) : Number
        {
            if (lhs.order < rhs.order)
            {
                return -1;
            }
            if (lhs.order > rhs.order)
            {
                return 1;
            }
            return this.m_sortingCollator.compare(lhs.label, rhs.label);
        }// end function

        private function findFieldFromRenderer(child:DisplayObject) : FormField
        {
            var _loc_2:* = child.parent as IDataRenderer;
            if (_loc_2)
            {
            }
            if (_loc_2.data)
            {
            }
            if (_loc_2.data is FormField)
            {
                return FormField(_loc_2.data);
            }
            if (child.parent)
            {
                return this.findFieldFromRenderer(child.parent);
            }
            return null;
        }// end function

        private function findFormDescriptor(featureLayer:FeatureLayer) : FormDescriptor
        {
            var _loc_2:FormDescriptor = null;
            for each (_loc_2 in this.m_formDescriptors)
            {
                
                if (_loc_2.featureLayer == featureLayer)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        private function findField(featureLayer:FeatureLayer, fieldName:String) : Field
        {
            var _loc_3:Field = null;
            var _loc_4:Field = null;
            if (featureLayer.layerDetails)
            {
                for each (_loc_3 in featureLayer.layerDetails.fields)
                {
                    
                    if (_loc_3.name === fieldName)
                    {
                        return _loc_3;
                    }
                }
            }
            if (featureLayer.tableDetails)
            {
                for each (_loc_4 in featureLayer.tableDetails.fields)
                {
                    
                    if (_loc_4.name === fieldName)
                    {
                        return _loc_4;
                    }
                }
            }
            return null;
        }// end function

        private function findFieldInspector(featureLayer:FeatureLayer, fieldName:String) : FieldInspector
        {
            var _loc_4:FieldInspector = null;
            var _loc_3:int = 0;
            for each (_loc_4 in this.fieldInspectors)
            {
                
                if (_loc_4.featureLayer === featureLayer)
                {
                    if (_loc_4.fieldName === fieldName)
                    {
                        _loc_4.formItemOrder = _loc_3;
                        return _loc_4;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return null;
        }// end function

        private function dispatchFormDataArrChanged() : void
        {
            dispatchEvent(new Event("formDataArrChanged"));
            invalidateSkinState();
            return;
        }// end function

        private function list_propertyChangeHandler(event:PropertyChangeEvent) : void
        {
            if (event.property == "featureType")
            {
            }
            if (event.newValue is FeatureType)
            {
                this.dispatchUpdateFeatureTypeEvent(event.source as DisplayObject, event.newValue as FeatureType);
            }
            else
            {
                this.dispatchUpdateFeatureAttributeEvent(event.source as DisplayObject, event.newValue);
            }
            return;
        }// end function

        private function deleteButton_clickHandler(event:MouseEvent) : void
        {
            this.deleteActiveFeature();
            return;
        }// end function

        private function deleteButton_keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode === Keyboard.ENTER)
            {
                this.deleteActiveFeature();
            }
            return;
        }// end function

        private function okButton_clickHandler(event:MouseEvent) : void
        {
            this.saveActiveFeature();
            return;
        }// end function

        private function okButton_keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode === Keyboard.ENTER)
            {
                this.saveActiveFeature();
            }
            return;
        }// end function

        private function nextButton_clickHandler(event:MouseEvent) : void
        {
            this.next();
            return;
        }// end function

        private function nextButton_keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode === Keyboard.ENTER)
            {
                this.next();
            }
            return;
        }// end function

        private function previousButton_clickHandler(event:MouseEvent) : void
        {
            this.previous();
            return;
        }// end function

        private function previousButton_keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode === Keyboard.ENTER)
            {
                this.previous();
            }
            return;
        }// end function

        private function featureLayer_editsCompleteHandler(event:FeatureLayerEvent) : void
        {
            if (event.featureEditResults.deleteResults)
            {
                this.deleteResultsHandler(event);
            }
            return;
        }// end function

        private function deleteResultsHandler(event:FeatureLayerEvent) : void
        {
            var featureEditResult:FeatureEditResult;
            var event:* = event;
            var formDescriptor:* = this.findFormDescriptor(event.featureLayer);
            try
            {
                if (event.featureEditResults.deleteResults.length > 0)
                {
                    var _loc_3:int = 0;
                    var _loc_4:* = event.featureEditResults.deleteResults;
                    while (_loc_4 in _loc_3)
                    {
                        
                        featureEditResult = _loc_4[_loc_3];
                        if (featureEditResult.success)
                        {
                            formDescriptor.removeFeatureById(featureEditResult.objectId);
                        }
                    }
                    this.updateActiveFeatureIndex();
                }
            }
            catch (error:Error)
            {
                if (Log.isError())
                {
                    m_log.error(error.message);
                }
            }
            return;
        }// end function

        private function featureLayer_selectionClearHandler(event:FeatureLayerEvent) : void
        {
            var _loc_2:* = this.findFormDescriptor(event.featureLayer);
            if (_loc_2)
            {
            }
            if (_loc_2.hasFeatures)
            {
                _loc_2.removeAllFeatures();
                if (_loc_2 === this.m_activeFormDescriptor)
                {
                    this.setActiveFormDescriptor(null);
                }
                if (this.numFeatures > 0)
                {
                    this.activeFeatureIndex$ = 0;
                }
                else
                {
                    this.activeFeatureIndex$ = -1;
                }
            }
            return;
        }// end function

        private function featureLayer_selectionCompleteHandler(event:FeatureLayerEvent) : void
        {
            switch(event.selectionMethod)
            {
                case FeatureLayer.SELECTION_NEW:
                {
                    this.selectionNewHandler(event);
                    break;
                }
                case FeatureLayer.SELECTION_ADD:
                {
                    this.selectionAddHandler(event);
                    break;
                }
                case FeatureLayer.SELECTION_SUBTRACT:
                {
                    this.selectionSubtractHandler(event);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function selectionAddHandler(event:FeatureLayerEvent) : void
        {
            this.addFormData(event.featureLayer, event.features);
            this.updateActiveFeatureIndex();
            this.dispatchFormDataArrChanged();
            return;
        }// end function

        private function selectionNewHandler(event:FeatureLayerEvent) : void
        {
            var _loc_2:* = this.findFormDescriptor(event.featureLayer);
            _loc_2.removeAllFeatures();
            if (event.features.length > 0)
            {
                this.addFormData(event.featureLayer, event.features);
                this.setActiveFeature(event.features[0]);
            }
            this.dispatchFormDataArrChanged();
            return;
        }// end function

        private function selectionSubtractHandler(event:FeatureLayerEvent) : void
        {
            var _loc_3:Graphic = null;
            var _loc_2:* = this.findFormDescriptor(event.featureLayer);
            for each (_loc_3 in event.features)
            {
                
                _loc_2.removeFeature(_loc_3);
            }
            this.updateActiveFeatureIndex();
            this.dispatchFormDataArrChanged();
            return;
        }// end function

        private function updateFeatureTypeHandler(event:UpdateFeatureTypeEvent) : void
        {
            this.refreshActiveFeature();
            var _loc_2:* = this.findFormDescriptor(this.activeFeatureLayer);
            _loc_2.activeFeatureType = event.featureType;
            return;
        }// end function

        private function invalidHandler(event:ValidationResultEvent) : void
        {
            var _loc_2:IEventDispatcher = null;
            _loc_2 = event.target as IEventDispatcher;
            var _loc_3:* = this.m_invalidSources.indexOf(_loc_2);
            if (_loc_3 === -1)
            {
                this.m_invalidSources.push(_loc_2);
                _loc_2.addEventListener(ValidationResultEvent.VALID, this.validHandler);
                invalidateSkinState();
            }
            return;
        }// end function

        private function validHandler(event:Event) : void
        {
            var _loc_2:IEventDispatcher = null;
            _loc_2 = event.target as IEventDispatcher;
            var _loc_3:* = this.m_invalidSources.indexOf(_loc_2);
            if (_loc_3 > -1)
            {
                this.m_invalidSources.splice(_loc_3, 1);
                _loc_2.removeEventListener(event.type, this.validHandler);
                invalidateSkinState();
            }
            return;
        }// end function

        private function updateEditSummaryLabel() : void
        {
            var _loc_2:Boolean = false;
            this.editSummaryLabel.includeInLayout = false;
            this.editSummaryLabel.visible = _loc_2;
            var _loc_1:* = this.activeFeatureLayer.getEditSummary(this.activeFeature);
            if (_loc_1)
            {
            }
            if (_loc_1 != "")
            {
                var _loc_2:Boolean = true;
                this.editSummaryLabel.includeInLayout = true;
                this.editSummaryLabel.visible = _loc_2;
                this.editSummaryLabel.text = this.activeFeatureLayer.getEditSummary(this.activeFeature);
            }
            return;
        }// end function

        function showFeature(feature:Graphic, featureLayer:FeatureLayer) : void
        {
            var _loc_3:* = this.findFormDescriptor(featureLayer);
            _loc_3.removeAllFeatures();
            if (feature)
            {
            }
            if (featureLayer)
            {
                this.addFormData(featureLayer, [feature]);
                this.setActiveFeature(feature);
            }
            return;
        }// end function

        public function get fieldInspectors() : Array
        {
            return this._761646858fieldInspectors;
        }// end function

        public function set fieldInspectors(value:Array) : void
        {
            arguments = this._761646858fieldInspectors;
            if (arguments !== value)
            {
                this._761646858fieldInspectors = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fieldInspectors", arguments, value));
                }
            }
            return;
        }// end function

        public function set featureLayers(value:Array) : void
        {
            arguments = this.featureLayers;
            if (arguments !== value)
            {
                this._1730434088featureLayers = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "featureLayers", arguments, value));
                }
            }
            return;
        }// end function

        public function set formFieldsOrder(value:String) : void
        {
            arguments = this.formFieldsOrder;
            if (arguments !== value)
            {
                this._420143951formFieldsOrder = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "formFieldsOrder", arguments, value));
                }
            }
            return;
        }// end function

        public function set singleToMultilineThreshold(value:Number) : void
        {
            arguments = this.singleToMultilineThreshold;
            if (arguments !== value)
            {
                this._705348479singleToMultilineThreshold = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "singleToMultilineThreshold", arguments, value));
                }
            }
            return;
        }// end function

        public function set showGlobalID(value:Boolean) : void
        {
            arguments = this.showGlobalID;
            if (arguments !== value)
            {
                this._1393647077showGlobalID = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showGlobalID", arguments, value));
                }
            }
            return;
        }// end function

        public function set showObjectID(value:Boolean) : void
        {
            arguments = this.showObjectID;
            if (arguments !== value)
            {
                this._761476425showObjectID = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showObjectID", arguments, value));
                }
            }
            return;
        }// end function

        public function set deleteButtonVisible(value:Boolean) : void
        {
            arguments = this.deleteButtonVisible;
            if (arguments !== value)
            {
                this._1419230453deleteButtonVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteButtonVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set updateEnabled(value:Boolean) : void
        {
            arguments = this.updateEnabled;
            if (arguments !== value)
            {
                this._1189422648updateEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "updateEnabled", arguments, value));
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
