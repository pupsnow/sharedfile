package com.esri.ags.components
{
    import com.esri.ags.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.events.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.symbols.*;
    import com.esri.ags.tasks.*;
    import com.esri.ags.tasks.supportClasses.*;
    import com.esri.ags.tools.*;
    import com.esri.ags.utils.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;
    import flashx.undo.*;
    import mx.binding.utils.*;
    import mx.core.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.*;
    import mx.rpc.events.*;
    import mx.utils.*;
    import spark.components.*;
    import spark.components.supportClasses.*;
    import spark.events.*;

    public class Editor extends SkinnableComponent
    {
        public var clearSelectionButton:ButtonBase;
        public var cutButton:ToggleButtonBase;
        public var deleteButton:ButtonBase;
        public var drawDropDownList:DropDownList;
        public var mergeButton:ButtonBase;
        public var redoButton:ButtonBase;
        public var reshapeButton:ToggleButtonBase;
        public var selectionDropDownList:DropDownList;
        public var templatePicker:TemplatePicker;
        public var undoButton:ButtonBase;
        public var operationStartLabel:Label;
        public var operationCompleteLabel:Label;
        private var moveCursor:Class;
        private var m_featureLayers:Array;
        private var m_loadedFeatureLayers:Array;
        private var m_visibleFeatureLayers:Array;
        private var m_inScaleFeatureLayers:Array;
        private var m_map:Map;
        private var m_geometryService:GeometryService;
        private var m_attributeInspector:AttributeInspector;
        private var m_createOptions:CreateOptions;
        private var m_changeWatcher:ChangeWatcher;
        private var m_drawTool:DrawTool;
        private var m_editTool:EditTool;
        private var m_lastActiveEdit:String;
        private var m_editGraphic:Graphic;
        private var m_query:Query;
        private var m_applyingEdits:Boolean;
        private var m_templateSelected:Boolean;
        private var m_featuresSelected:Boolean;
        private var m_toolbarVisible:Boolean;
        private var m_toolbarCutVisible:Boolean;
        private var m_toolbarMergeVisible:Boolean;
        private var m_toolbarReshapeVisible:Boolean;
        private var m_addEnabled:Boolean = true;
        private var m_deleteEnabled:Boolean = true;
        private var m_updateGeometryEnabled:Boolean = true;
        private var m_updateAttributesEnabled:Boolean = true;
        private var m_doNotApplyEdits:Boolean;
        private var m_editClearSelection:Boolean;
        private var m_cutInProgress:Boolean;
        private var m_cutQueryFeatureArray:Array;
        private var m_polylinePolygonCutResultArray:Array;
        private var m_mergeInProgress:Boolean;
        private var m_reshapeInProgress:Boolean;
        private var m_creationInProgress:Boolean;
        private var m_editGraphicPartOfSelection:Boolean;
        private var m_editPoint:MapPoint;
        private var m_featureCreated:Boolean;
        private var m_lastCreatedGraphic:Graphic;
        private var m_showTemplateSwatchOnCursor:Boolean = true;
        private var m_drawStart:Boolean;
        private var m_graphicRemoved:Boolean;
        private var m_graphicEditing:Boolean;
        private var m_currentlyDrawnGraphic:Graphic;
        private var m_selectionModeFeatureLayers:Array;
        private var m_visibleSelectionModeFeatureLayers:Array;
        private var m_newFeatureCreated:Boolean;
        private var m_selectionMode:Boolean;
        private var m_stagePointInfoWindow:Point;
        private var m_createGeometryType:String;
        private var m_lastPolygonCreateOptionIndex:int = 0;
        private var m_lastPolylineCreateOptionIndex:int = 0;
        private var m_currentSelectedTemplateFeatureLayer:FeatureLayer = null;
        private var m_currentSelectedTemplateFeatureLayerChanged:Boolean;
        private var m_isEdit:Boolean;
        private var m_templateSwatch:UIComponent;
        private var m_selectionExtentSymbol:SimpleFillSymbol;
        private var m_undoManager:UndoManager;
        private var m_undoAndRedoItemLimit:int = 25;
        private var m_redoVertexMoveGraphicGeometry:Geometry;
        private var m_undoVertexMoveGraphicGeometry:Geometry;
        private var m_redoGraphicMoveGraphicGeometry:Geometry;
        private var m_undoGraphicMoveGraphicGeometry:Geometry;
        private var m_redoVertexAddGraphicGeometry:Geometry;
        private var m_undoVertexAddGraphicGeometry:Geometry;
        private var m_redoVertexDeleteGraphicGeometry:Geometry;
        private var m_undoVertexDeleteGraphicGeometry:Geometry;
        private var m_redoGraphicScaleRotateGraphicGeometry:Geometry;
        private var m_undoGraphicScaleRotateGraphicGeometry:Geometry;
        private var m_redoReshapeGraphicGeometry:Geometry;
        private var m_undoReshapeGraphicGeometry:Geometry;
        private var m_undoCutGeometryArray:Array;
        private var m_redoCutGeometryArray:Array;
        private var m_undoRedoAddDeleteOperation:Boolean;
        private var m_undoRedoCutOperation:Boolean;
        private var m_undoRedoMergeOperation:Boolean;
        private var m_undoRedoReshapeOperation:Boolean;
        private var m_redoAddOperation:Boolean;
        private var m_undoAddOperation:Boolean;
        private var m_featureLayerCountLoaded:Number = 0;
        private var m_featuresToBeDeleted:Array;
        private var m_numMergeFeatureLayers:int;
        private var m_countDeleteFeatureLayers:int;
        private var m_featureLayerAddResults:Array;
        private var m_featureLayerDeleteResults:Array;
        private var m_lastUpdateOperation:String;
        private var m_arrUndoCutOperation:Array;
        private var m_undoCutUpdateDeletesArray:Array;
        private var m_undoRedoMergeAddsDeletesArray:Array;
        private var m_arrUndoRedoMergeOperation:Array;
        private var m_undoRedoInProgress:Boolean;
        private var m_openHandCursorVisibleState:Boolean;
        private var m_activeFeatureChangedAttributes:Array;
        private var m_infoWindowCloseButtonClicked:Boolean;
        private var m_attributesSaved:Boolean;
        private var m_featureLayerToDynamicMapServiceLayer:Dictionary;
        private var m_tempNewFeature:Graphic;
        private var m_tempNewFeatureLayer:FeatureLayer;
        private var m_deletingTempGraphic:Boolean;
        private var m_lastActiveTempEdit:String = "moveEditVertices";
        private static const ADD_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorAddFeatureOperationStartLabel");
        private static const ADD_FEATURE_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorAddFeatureOperationCompleteLabel");
        private static const ADD_FEATURE_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorAddFeatureOperationFailedLabel");
        private static const DELETE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorDeleteFeatureOperationStartLabel");
        private static const DELETE_FEATURE_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorDeleteFeatureOperationCompleteLabel");
        private static const DELETE_FEATURE_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorDeleteFeatureOperationFailedLabel");
        private static const DELETE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorDeleteFeaturesOperationStartLabel");
        private static const DELETE_FEATURES_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorDeleteFeaturesOperationCompleteLabel");
        private static const DELETE_FEATURES_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorDeleteFeaturesOperationFailedLabel");
        private static const UPDATE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorUpdateFeatureOperationStartLabel");
        private static const UPDATE_FEATURE_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorUpdateFeatureOperationCompleteLabel");
        private static const UPDATE_FEATURE_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorUpdateFeatureOperationFailedCompleteLabel");
        private static const MERGE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorMergeFeaturesOperationStartLabel");
        private static const MERGE_FEATURES_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorMergeFeaturesOperationCompleteLabel");
        private static const MERGE_FEATURES_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorMergeFeaturesOperationFailedCompleteLabel");
        private static const SPLIT_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorSplitFeatureOperationStartLabel");
        private static const SPLIT_FEATURE_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorSplitFeatureOperationCompleteLabel");
        private static const SPLIT_FEATURE_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorSplitFeatureOperationFailedCompleteLabel");
        private static const SPLIT_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorSplitFeaturesOperationStartLabel");
        private static const SPLIT_FEATURES_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorSplitFeaturesOperationCompleteLabel");
        private static const SPLIT_FEATURES_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorSplitFeaturesOperationFailedCompleteLabel");
        private static const UNDO_ADD_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoAddFeatureOperationStartLabel");
        private static const UNDO_DELETE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoDeleteFeatureOperationStartLabel");
        private static const UNDO_DELETE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoDeleteFeaturesOperationStartLabel");
        private static const UNDO_UPDATE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoUpdateFeatureOperationStartLabel");
        private static const UNDO_MERGE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoMergeFeaturesOperationStartLabel");
        private static const UNDO_SPLIT_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoSplitFeatureOperationStartLabel");
        private static const UNDO_SPLIT_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorUndoSplitFeaturesOperationStartLabel");
        private static const REDO_ADD_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoAddFeatureOperationStartLabel");
        private static const REDO_DELETE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoDeleteFeatureOperationStartLabel");
        private static const REDO_DELETE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoDeleteFeaturesOperationStartLabel");
        private static const REDO_UPDATE_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoUpdateFeatureOperationStartLabel");
        private static const REDO_MERGE_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoMergeFeaturesOperationStartLabel");
        private static const REDO_SPLIT_FEATURE_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoSplitFeatureOperationStartLabel");
        private static const REDO_SPLIT_FEATURES_OPERATION_START:String = ESRIMessageCodes.getString("editorRedoSplitFeaturesOperationStartLabel");
        private static const UNDO_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorUndoOperationCompleteLabel");
        private static const UNDO_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorUndoOperationFailedLabel");
        private static const REDO_OPERATION_COMPLETE:String = ESRIMessageCodes.getString("editorRedoOperationCompleteLabel");
        private static const REDO_OPERATION_FAILED:String = ESRIMessageCodes.getString("editorRedoOperationFailedLabel");
        private static var _skinParts:Object = {operationStartLabel:false, clearSelectionButton:false, mergeButton:false, drawDropDownList:false, reshapeButton:false, deleteButton:false, templatePicker:false, undoButton:false, cutButton:false, selectionDropDownList:false, redoButton:false, operationCompleteLabel:false};

        public function Editor(featureLayers:Array = null, map:Map = null, geometryService:GeometryService = null)
        {
            this.moveCursor = Editor_moveCursor;
            this.m_drawTool = new DrawTool();
            this.m_editTool = new EditTool();
            this.m_selectionExtentSymbol = new SimpleFillSymbol("solid", 0, 0, new SimpleLineSymbol("solid", 0, 1, 2));
            this.m_undoCutUpdateDeletesArray = [];
            this.m_undoRedoMergeAddsDeletesArray = [];
            this.m_activeFeatureChangedAttributes = [];
            this.m_featureLayerToDynamicMapServiceLayer = new Dictionary();
            this.m_undoManager = new UndoManager();
            this.m_attributeInspector = new AttributeInspector();
            this.m_attributeInspector.infoWindowLabel = ESRIMessageCodes.getString("editorInfoWindowLabel");
            this.m_attributeInspector.addEventListener(AttributeInspectorEvent.UPDATE_FEATURE, this.attributeInspector_updateFeatureHandler);
            this.m_attributeInspector.addEventListener(AttributeInspectorEvent.DELETE_FEATURE, this.attributeInspector_deleteFeatureHandler);
            this.m_attributeInspector.addEventListener(AttributeInspectorEvent.SAVE_FEATURE, this.attributeInspector_saveFeatureHandler, false, -1);
            this.m_changeWatcher = ChangeWatcher.watch(this.m_attributeInspector, "activeFeature", this.attributeInspector_activeFeatureChangeHandler);
            this.featureLayers = featureLayers;
            this.map = map;
            this.geometryService = geometryService;
            FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN, this.key_downHandler);
            this.m_drawTool.addEventListener(DrawEvent.DRAW_START, this.drawTool_drawStartHandler);
            this.m_drawTool.addEventListener(DrawEvent.DRAW_END, this.drawTool_drawEndHandler);
            this.addEditToolEventListeners();
            return;
        }// end function

        override public function set enabled(value:Boolean) : void
        {
            if (enabled != value)
            {
                invalidateSkinState();
            }
            super.enabled = value;
            return;
        }// end function

        public function get featureLayers() : Array
        {
            return this.m_featureLayers;
        }// end function

        private function set _1730434088featureLayers(value:Array) : void
        {
            var _loc_2:FeatureLayer = null;
            var _loc_3:FeatureLayer = null;
            for each (_loc_2 in this.m_featureLayers)
            {
                
                _loc_2.removeEventListener(FaultEvent.FAULT, this.featureLayer_faultHandler);
                _loc_2.removeEventListener(FlexEvent.HIDE, this.featureLayer_hideHandler);
                _loc_2.removeEventListener(FlexEvent.SHOW, this.featureLayer_showHandler);
                _loc_2.removeEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_isInScaleRangeChangeHandler);
                _loc_2.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsCompleteHandler);
                _loc_2.removeEventListener(FeatureLayerEvent.SELECTION_CLEAR, this.featureLayer_selectionClearHandler);
                _loc_2.removeEventListener(FeatureLayerEvent.SELECTION_COMPLETE, this.featureLayer_selectionCompleteHandler);
            }
            this.m_featureLayers = value;
            this.m_selectionModeFeatureLayers = [];
            if (this.m_featureLayers)
            {
                for each (_loc_3 in this.m_featureLayers)
                {
                    
                    _loc_3.addEventListener(FaultEvent.FAULT, this.featureLayer_faultHandler);
                    _loc_3.addEventListener(FlexEvent.HIDE, this.featureLayer_hideHandler);
                    _loc_3.addEventListener(FlexEvent.SHOW, this.featureLayer_showHandler);
                    _loc_3.addEventListener(LayerEvent.IS_IN_SCALE_RANGE_CHANGE, this.featureLayer_isInScaleRangeChangeHandler);
                    _loc_3.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, this.featureLayer_editsCompleteHandler);
                    _loc_3.addEventListener(FeatureLayerEvent.SELECTION_CLEAR, this.featureLayer_selectionClearHandler);
                    _loc_3.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE, this.featureLayer_selectionCompleteHandler, false, -1);
                    if (_loc_3.mode == FeatureLayer.MODE_SELECTION)
                    {
                        this.m_selectionModeFeatureLayers.push(_loc_3);
                    }
                }
                this.m_visibleSelectionModeFeatureLayers = this.getInScaleFeatureLayers(this.getVisibleFeatureLayers(this.m_selectionModeFeatureLayers));
                if (this.m_attributeInspector)
                {
                    this.m_attributeInspector.featureLayers = this.m_featureLayers;
                }
                if (this.templatePicker)
                {
                    this.templatePicker.featureLayers = this.m_featureLayers;
                }
            }
            return;
        }// end function

        public function get map() : Map
        {
            return this.m_map;
        }// end function

        private function set _107868map(value:Map) : void
        {
            if (this.m_map)
            {
                if (this.m_openHandCursorVisibleState)
                {
                    this.m_map.openHandCursorVisible = true;
                }
                this.m_map.removeEventListener(KeyboardEvent.KEY_DOWN, this.map_keyDownHandler);
                this.m_map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
            }
            this.m_map = value;
            if (this.m_map)
            {
                this.m_openHandCursorVisibleState = this.m_map.openHandCursorVisible;
                if (this.m_openHandCursorVisibleState)
                {
                    this.m_map.openHandCursorVisible = false;
                }
                this.m_map.addEventListener(KeyboardEvent.KEY_DOWN, this.map_keyDownHandler);
                this.m_map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
                this.m_drawTool.map = this.m_map;
                this.m_editTool.map = this.m_map;
                this.m_map.infoWindowContent = null;
                this.m_map.infoWindowContent = this.m_attributeInspector;
            }
            return;
        }// end function

        public function get geometryService() : GeometryService
        {
            return this.m_geometryService;
        }// end function

        private function set _1579241955geometryService(value:GeometryService) : void
        {
            this.m_geometryService = value;
            return;
        }// end function

        public function get toolbarVisible() : Boolean
        {
            return this.m_toolbarVisible;
        }// end function

        private function set _1563241591toolbarVisible(value:Boolean) : void
        {
            if (this.m_toolbarVisible != value)
            {
                this.m_toolbarVisible = value;
                if (this.m_toolbarVisible)
                {
                    this.setButtonStates();
                }
                invalidateSkinState();
            }
            return;
        }// end function

        public function get toolbarCutVisible() : Boolean
        {
            return this.m_toolbarCutVisible;
        }// end function

        private function set _1691214251toolbarCutVisible(value:Boolean) : void
        {
            if (this.m_toolbarCutVisible != value)
            {
                this.m_toolbarCutVisible = value;
            }
            return;
        }// end function

        public function get toolbarMergeVisible() : Boolean
        {
            return this.m_toolbarMergeVisible;
        }// end function

        private function set _1160858571toolbarMergeVisible(value:Boolean) : void
        {
            if (this.m_toolbarMergeVisible != value)
            {
                this.m_toolbarMergeVisible = value;
            }
            return;
        }// end function

        public function get toolbarReshapeVisible() : Boolean
        {
            return this.m_toolbarReshapeVisible;
        }// end function

        private function set _385871969toolbarReshapeVisible(value:Boolean) : void
        {
            if (this.m_toolbarReshapeVisible != value)
            {
                this.m_toolbarReshapeVisible = value;
            }
            return;
        }// end function

        public function get createOptions() : CreateOptions
        {
            return this.m_createOptions;
        }// end function

        private function set _997042690createOptions(value:CreateOptions) : void
        {
            if (this.m_createOptions != value)
            {
                this.m_createOptions = value;
            }
            return;
        }// end function

        public function get createGeometryType() : String
        {
            return this.m_createGeometryType;
        }// end function

        public function get attributeInspector() : AttributeInspector
        {
            return this.m_attributeInspector;
        }// end function

        public function get editTool() : EditTool
        {
            return this.m_editTool;
        }// end function

        public function get drawTool() : DrawTool
        {
            return this.m_drawTool;
        }// end function

        public function get showTemplateSwatchOnCursor() : Boolean
        {
            return this.m_showTemplateSwatchOnCursor;
        }// end function

        private function set _1701569304showTemplateSwatchOnCursor(value:Boolean) : void
        {
            if (this.m_showTemplateSwatchOnCursor != value)
            {
                this.m_showTemplateSwatchOnCursor = value;
                this.m_templateSwatch = null;
            }
            return;
        }// end function

        public function get deleteEnabled() : Boolean
        {
            return this.m_deleteEnabled;
        }// end function

        private function set _1814366442deleteEnabled(value:Boolean) : void
        {
            if (this.m_deleteEnabled != value)
            {
                this.m_deleteEnabled = value;
                this.m_attributeInspector.deleteButtonVisible = this.m_deleteEnabled;
            }
            return;
        }// end function

        public function get undoAndRedoItemLimit() : int
        {
            return this.m_undoAndRedoItemLimit;
        }// end function

        private function set _1765640073undoAndRedoItemLimit(value:int) : void
        {
            if (this.m_undoAndRedoItemLimit != value)
            {
                this.m_undoAndRedoItemLimit = value;
                this.m_undoManager.undoAndRedoItemLimit = this.m_undoAndRedoItemLimit;
            }
            return;
        }// end function

        public function get addEnabled() : Boolean
        {
            return this.m_addEnabled;
        }// end function

        private function set _298640224addEnabled(value:Boolean) : void
        {
            if (this.m_addEnabled != value)
            {
                this.m_addEnabled = value;
                if (this.templatePicker)
                {
                    this.templatePicker.enabled = this.m_addEnabled;
                }
            }
            return;
        }// end function

        public function get updateAttributesEnabled() : Boolean
        {
            return this.m_updateAttributesEnabled;
        }// end function

        private function set _546952159updateAttributesEnabled(value:Boolean) : void
        {
            if (this.m_updateAttributesEnabled != value)
            {
                this.m_updateAttributesEnabled = value;
                this.m_attributeInspector.updateEnabled = this.m_updateAttributesEnabled;
            }
            return;
        }// end function

        public function get updateGeometryEnabled() : Boolean
        {
            return this.m_updateGeometryEnabled;
        }// end function

        private function set _1030763930updateGeometryEnabled(value:Boolean) : void
        {
            if (this.m_updateGeometryEnabled != value)
            {
                this.m_updateGeometryEnabled = value;
            }
            return;
        }// end function

        override protected function getCurrentSkinState() : String
        {
            if (enabled === false)
            {
                return "disabled";
            }
            if (this.m_applyingEdits)
            {
                return "applyingEdits";
            }
            if (this.m_templateSelected)
            {
                return "templateSelected";
            }
            if (this.m_featuresSelected)
            {
                return "featuresSelected";
            }
            if (!this.m_toolbarVisible)
            {
                return "toolbarNotVisible";
            }
            return "normal";
        }// end function

        override protected function partAdded(partName:String, instance:Object) : void
        {
            super.partAdded(partName, instance);
            if (instance === this.templatePicker)
            {
                this.templatePicker.onlyShowEditableAndCreateAllowedLayers = true;
                this.templatePicker.featureLayers = this.m_featureLayers;
                this.templatePicker.enabled = this.m_addEnabled;
                this.templatePicker.addEventListener(TemplatePickerEvent.SELECTED_TEMPLATE_CHANGE, this.templatePicker_selectedTemplateChangeHandler);
            }
            else if (instance === this.selectionDropDownList)
            {
                this.selectionDropDownList.addEventListener(MouseEvent.MOUSE_DOWN, this.dropDownList_mouseDownHandler);
                this.selectionDropDownList.addEventListener(IndexChangeEvent.CHANGE, this.selectionDropDownList_changeHandler);
            }
            else if (instance === this.clearSelectionButton)
            {
                this.clearSelectionButton.addEventListener(MouseEvent.CLICK, this.clearSelectionButton_clickHandler);
            }
            else if (instance === this.drawDropDownList)
            {
                this.drawDropDownList.addEventListener(FlexEvent.VALUE_COMMIT, this.drawDropDownList_valueCommitHandler);
                this.drawDropDownList.addEventListener(IndexChangeEvent.CHANGE, this.drawDropDownList_changeHandler);
            }
            else if (instance === this.deleteButton)
            {
                this.deleteButton.addEventListener(MouseEvent.CLICK, this.deleteButton_clickHandler);
            }
            else if (instance === this.redoButton)
            {
                this.redoButton.enabled = this.m_undoManager.canRedo();
                this.redoButton.addEventListener(MouseEvent.CLICK, this.redoButton_clickHandler);
            }
            else if (instance === this.undoButton)
            {
                this.undoButton.enabled = this.m_undoManager.canUndo();
                this.undoButton.addEventListener(MouseEvent.CLICK, this.undoButton_clickHandler);
            }
            else if (instance === this.cutButton)
            {
                this.cutButton.addEventListener(Event.CHANGE, this.cutButton_changeHandler);
            }
            else if (instance === this.mergeButton)
            {
                this.mergeButton.addEventListener(MouseEvent.CLICK, this.mergeButton_clickHandler);
            }
            else if (instance === this.reshapeButton)
            {
                this.reshapeButton.addEventListener(Event.CHANGE, this.reshapeButton_changeHandler);
            }
            return;
        }// end function

        override protected function partRemoved(partName:String, instance:Object) : void
        {
            super.partRemoved(partName, instance);
            if (instance === this.templatePicker)
            {
                this.templatePicker.onlyShowEditableAndCreateAllowedLayers = false;
                this.templatePicker.featureLayers = null;
                this.templatePicker.removeEventListener(TemplatePickerEvent.SELECTED_TEMPLATE_CHANGE, this.templatePicker_selectedTemplateChangeHandler);
            }
            else if (instance === this.selectionDropDownList)
            {
                this.selectionDropDownList.removeEventListener(MouseEvent.CLICK, this.dropDownList_mouseDownHandler);
                this.selectionDropDownList.removeEventListener(IndexChangeEvent.CHANGE, this.selectionDropDownList_changeHandler);
            }
            else if (instance === this.clearSelectionButton)
            {
                this.clearSelectionButton.removeEventListener(MouseEvent.CLICK, this.clearSelectionButton_clickHandler);
            }
            else if (instance === this.drawDropDownList)
            {
                this.drawDropDownList.removeEventListener(FlexEvent.VALUE_COMMIT, this.drawDropDownList_valueCommitHandler);
                this.drawDropDownList.removeEventListener(IndexChangeEvent.CHANGE, this.drawDropDownList_changeHandler);
            }
            else if (instance === this.deleteButton)
            {
                this.deleteButton.removeEventListener(MouseEvent.CLICK, this.deleteButton_clickHandler);
            }
            else if (instance === this.redoButton)
            {
                this.redoButton.removeEventListener(MouseEvent.CLICK, this.redoButton_clickHandler);
            }
            else if (instance === this.undoButton)
            {
                this.undoButton.removeEventListener(MouseEvent.CLICK, this.undoButton_clickHandler);
            }
            else if (instance === this.cutButton)
            {
                this.cutButton.removeEventListener(IndexChangeEvent.CHANGE, this.cutButton_changeHandler);
            }
            else if (instance === this.mergeButton)
            {
                this.mergeButton.removeEventListener(MouseEvent.CLICK, this.mergeButton_clickHandler);
            }
            else if (instance === this.reshapeButton)
            {
                this.reshapeButton.removeEventListener(IndexChangeEvent.CHANGE, this.reshapeButton_changeHandler);
            }
            return;
        }// end function

        private function featureLayer_hideHandler(event:FlexEvent) : void
        {
            if (this.templatePicker.selectedTemplate)
            {
            }
            if (this.templatePicker.selectedTemplate.featureLayer === event.target)
            {
                this.templatePicker.clearSelection();
            }
            if (this.m_editGraphic)
            {
            }
            if (FeatureLayer(this.m_editGraphic.graphicsLayer) === event.target)
            {
                this.m_editTool.deactivate();
                this.removeEditToolEventListeners();
                this.clearSelection();
                this.map.infoWindow.hide();
                this.m_editGraphic = null;
            }
            this.m_attributeInspector.featureLayers = this.getVisibleFeatureLayers(this.m_featureLayers);
            this.m_visibleSelectionModeFeatureLayers = this.getInScaleFeatureLayers(this.getVisibleFeatureLayers(this.m_selectionModeFeatureLayers));
            return;
        }// end function

        private function featureLayer_showHandler(event:FlexEvent) : void
        {
            this.m_attributeInspector.featureLayers = this.getVisibleFeatureLayers(this.m_featureLayers);
            this.m_visibleSelectionModeFeatureLayers = this.getInScaleFeatureLayers(this.getVisibleFeatureLayers(this.m_selectionModeFeatureLayers));
            return;
        }// end function

        private function featureLayer_isInScaleRangeChangeHandler(event:LayerEvent) : void
        {
            this.m_attributeInspector.featureLayers = this.getInScaleFeatureLayers(this.m_featureLayers);
            this.m_visibleSelectionModeFeatureLayers = this.getInScaleFeatureLayers(this.getVisibleFeatureLayers(this.m_selectionModeFeatureLayers));
            if (this.templatePicker.selectedTemplate)
            {
            }
            if (this.templatePicker.selectedTemplate.featureLayer === event.target)
            {
                this.templatePicker.clearSelection();
            }
            if (this.m_editGraphic)
            {
            }
            if (FeatureLayer(this.m_editGraphic.graphicsLayer) === event.target)
            {
            }
            if (!FeatureLayer(event.target).isInScaleRange)
            {
                this.m_editTool.deactivate();
                this.removeEditToolEventListeners();
                this.map.infoWindow.hide();
            }
            return;
        }// end function

        private function getVisibleFeatureLayers(featureLayers:Array) : Array
        {
            var _loc_3:FeatureLayer = null;
            this.m_visibleFeatureLayers = featureLayers.slice();
            var _loc_2:int = 0;
            while (_loc_2 < this.m_visibleFeatureLayers.length)
            {
                
                _loc_3 = this.m_visibleFeatureLayers[_loc_2] as FeatureLayer;
                if (_loc_3)
                {
                }
                if (!_loc_3.visible)
                {
                    this.m_visibleFeatureLayers.splice(_loc_2, 1);
                    _loc_2 = _loc_2 - 1;
                }
                _loc_2 = _loc_2 + 1;
            }
            return this.m_visibleFeatureLayers;
        }// end function

        private function getInScaleFeatureLayers(featureLayers:Array) : Array
        {
            var _loc_3:FeatureLayer = null;
            this.m_inScaleFeatureLayers = featureLayers.slice();
            var _loc_2:int = 0;
            while (_loc_2 < this.m_inScaleFeatureLayers.length)
            {
                
                _loc_3 = this.m_inScaleFeatureLayers[_loc_2] as FeatureLayer;
                if (_loc_3)
                {
                }
                if (!_loc_3.isInScaleRange)
                {
                    this.m_inScaleFeatureLayers.splice(_loc_2, 1);
                    _loc_2 = _loc_2 - 1;
                }
                _loc_2 = _loc_2 + 1;
            }
            return this.m_inScaleFeatureLayers;
        }// end function

        private function featureLayer_editsCompleteHandler(event:FeatureLayerEvent) : void
        {
            var k:int;
            var p:int;
            var j:int;
            var d:int;
            var a:int;
            var b:int;
            var event:* = event;
            var undoCutComplete:* = function () : void
            {
                var _loc_1:int = 0;
                var _loc_2:Number = NaN;
                var _loc_3:Number = NaN;
                if (m_arrUndoCutOperation.length == m_undoCutUpdateDeletesArray.length)
                {
                    m_lastUpdateOperation = "";
                    operationCompleteLabel.text = UNDO_OPERATION_COMPLETE;
                    _loc_1 = 0;
                    while (_loc_1 < m_arrUndoCutOperation.length)
                    {
                        
                        if (m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults.length > 0)
                        {
                            _loc_2 = 0;
                            while (_loc_2 < m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults.length)
                            {
                                
                                if (m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults[_loc_2].success)
                                {
                                    _loc_2 = _loc_2 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = UNDO_OPERATION_FAILED;
                                break;
                            }
                        }
                        if (m_arrUndoCutOperation[_loc_1].featureEditResults.deleteResults.length > 0)
                        {
                            _loc_3 = 0;
                            while (_loc_3 < m_arrUndoCutOperation[_loc_1].featureEditResults.deleteResults.length)
                            {
                                
                                if (m_arrUndoCutOperation[_loc_1].featureEditResults.deleteResults[_loc_3].success)
                                {
                                    _loc_3 = _loc_3 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = UNDO_OPERATION_FAILED;
                                break;
                            }
                        }
                        if (operationCompleteLabel.text == UNDO_OPERATION_FAILED)
                        {
                            break;
                            continue;
                        }
                        _loc_1 = _loc_1 + 1;
                    }
                    m_undoRedoInProgress = false;
                    applyEditsComplete();
                }
                return;
            }// end function
            ;
            var redoCutComplete:* = function () : void
            {
                var _loc_1:int = 0;
                var _loc_2:Number = NaN;
                var _loc_3:Number = NaN;
                if (m_arrUndoCutOperation.length == m_undoCutUpdateDeletesArray.length)
                {
                    m_lastUpdateOperation = "";
                    operationCompleteLabel.text = REDO_OPERATION_COMPLETE;
                    _loc_1 = 0;
                    while (_loc_1 < m_arrUndoCutOperation.length)
                    {
                        
                        if (m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults.length > 0)
                        {
                            _loc_2 = 0;
                            while (_loc_2 < m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults.length)
                            {
                                
                                if (m_arrUndoCutOperation[_loc_1].featureEditResults.updateResults[_loc_2].success)
                                {
                                    _loc_2 = _loc_2 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = REDO_OPERATION_FAILED;
                                break;
                            }
                        }
                        if (m_arrUndoCutOperation[_loc_1].featureEditResults.addResults.length > 0)
                        {
                            m_query = new Query();
                            _loc_3 = 0;
                            while (_loc_3 < m_arrUndoCutOperation[_loc_1].featureEditResults.addResults.length)
                            {
                                
                                if (m_arrUndoCutOperation[_loc_1].featureEditResults.addResults[_loc_3].success)
                                {
                                    m_query.objectIds = [m_arrUndoCutOperation[_loc_1].featureEditResults.addResults[_loc_3].objectId];
                                    FeatureLayer(m_arrUndoCutOperation[_loc_1].featureLayer).selectFeatures(m_query, FeatureLayer.SELECTION_ADD);
                                    _loc_3 = _loc_3 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = REDO_OPERATION_FAILED;
                                break;
                            }
                        }
                        if (operationCompleteLabel.text == REDO_OPERATION_FAILED)
                        {
                            break;
                            continue;
                        }
                        _loc_1 = _loc_1 + 1;
                    }
                    m_undoRedoInProgress = false;
                    applyEditsComplete();
                }
                return;
            }// end function
            ;
            var undoRedoMergeComplete:* = function () : void
            {
                var _loc_1:int = 0;
                var _loc_2:Number = NaN;
                var _loc_3:Number = NaN;
                if (m_arrUndoRedoMergeOperation.length == m_undoRedoMergeAddsDeletesArray.length)
                {
                    operationCompleteLabel.text = m_lastUpdateOperation == "undo merge geometry" ? (UNDO_OPERATION_COMPLETE) : (REDO_OPERATION_COMPLETE);
                    _loc_1 = 0;
                    while (_loc_1 < m_arrUndoRedoMergeOperation.length)
                    {
                        
                        if (m_arrUndoRedoMergeOperation[_loc_1].addResults.length > 0)
                        {
                            _loc_2 = 0;
                            while (_loc_2 < m_arrUndoRedoMergeOperation[_loc_1].addResults.length)
                            {
                                
                                if (m_arrUndoRedoMergeOperation[_loc_1].addResults[_loc_2].success)
                                {
                                    _loc_2 = _loc_2 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = m_lastUpdateOperation == "undo merge geometry" ? (UNDO_OPERATION_FAILED) : (REDO_OPERATION_FAILED);
                                break;
                            }
                        }
                        if (m_arrUndoRedoMergeOperation[_loc_1].deleteResults.length > 0)
                        {
                            _loc_3 = 0;
                            while (_loc_3 < m_arrUndoRedoMergeOperation[_loc_1].deleteResults.length)
                            {
                                
                                if (m_arrUndoRedoMergeOperation[_loc_1].deleteResults[_loc_3].success)
                                {
                                    _loc_3 = _loc_3 + 1;
                                    continue;
                                }
                                operationCompleteLabel.text = m_lastUpdateOperation == "undo merge geometry" ? (UNDO_OPERATION_FAILED) : (REDO_OPERATION_FAILED);
                                break;
                            }
                        }
                        if (operationCompleteLabel.text != UNDO_OPERATION_FAILED)
                        {
                        }
                        if (operationCompleteLabel.text == REDO_OPERATION_FAILED)
                        {
                            break;
                            continue;
                        }
                        _loc_1 = _loc_1 + 1;
                    }
                    m_lastUpdateOperation = "";
                    m_undoRedoInProgress = false;
                    applyEditsComplete();
                }
                return;
            }// end function
            ;
            var applyEditsComplete:* = function () : void
            {
                var _loc_1:ArcGISDynamicMapServiceLayer = null;
                if (m_applyingEdits)
                {
                    m_applyingEdits = false;
                    invalidateSkinState();
                }
                operationCompleteLabel.includeInLayout = true;
                operationCompleteLabel.visible = true;
                operationCompleteLabel.visible = false;
                if (event.featureLayer.mode == FeatureLayer.MODE_SELECTION)
                {
                    _loc_1 = findDynamicMapServiceLayer(event.featureLayer);
                    if (_loc_1)
                    {
                        _loc_1.refresh();
                    }
                }
                return;
            }// end function
            ;
            if (event.featureEditResults.addResults)
            {
            }
            if (event.featureEditResults.addResults.length > 0)
            {
                if (this.m_featureCreated)
                {
                    this.m_featureCreated = false;
                    if (event.featureEditResults.addResults[0].success)
                    {
                        this.operationCompleteLabel.text = ADD_FEATURE_OPERATION_COMPLETE;
                        callLater(this.updateUndoRedoButtons);
                    }
                    else
                    {
                        this.operationCompleteLabel.text = ADD_FEATURE_OPERATION_FAILED;
                    }
                    if (this.m_tempNewFeature)
                    {
                        this.removeTempNewGraphic();
                    }
                    this.applyEditsComplete();
                }
                else if (this.m_undoRedoAddDeleteOperation)
                {
                    if (this.m_redoAddOperation)
                    {
                        this.m_redoAddOperation = false;
                        this.m_undoRedoAddDeleteOperation = false;
                        this.operationCompleteLabel.text = event.featureEditResults.addResults[0].success ? (REDO_OPERATION_COMPLETE) : (REDO_OPERATION_FAILED);
                        this.m_undoRedoInProgress = false;
                        this.applyEditsComplete();
                    }
                    else if (this.m_featuresToBeDeleted.length == 1)
                    {
                        this.m_undoRedoAddDeleteOperation = false;
                        if (this.m_featuresToBeDeleted[0].selectedFeatures.length == 1)
                        {
                            this.operationCompleteLabel.text = event.featureEditResults.addResults[0].success ? (UNDO_OPERATION_COMPLETE) : (UNDO_OPERATION_FAILED);
                            this.m_undoRedoInProgress = false;
                            this.applyEditsComplete();
                        }
                        else
                        {
                            this.operationCompleteLabel.text = UNDO_OPERATION_COMPLETE;
                            k;
                            while (k < event.featureEditResults.addResults.length)
                            {
                                
                                if (!event.featureEditResults.addResults[k].success)
                                {
                                    this.operationCompleteLabel.text = UNDO_OPERATION_FAILED;
                                    break;
                                    continue;
                                }
                                k = (k + 1);
                            }
                            this.m_undoRedoAddDeleteOperation = false;
                            this.m_undoRedoInProgress = false;
                            this.applyEditsComplete();
                        }
                    }
                    else
                    {
                        var _loc_3:String = this;
                        var _loc_4:* = this.m_countDeleteFeatureLayers + 1;
                        _loc_3.m_countDeleteFeatureLayers = _loc_4;
                        this.operationCompleteLabel.text = UNDO_OPERATION_COMPLETE;
                        this.m_featureLayerAddResults.push({featureLayer:event.featureLayer, addResults:event.featureEditResults.addResults});
                        if (this.m_countDeleteFeatureLayers == this.m_featuresToBeDeleted.length)
                        {
                            p;
                            while (p < this.m_featureLayerAddResults.length)
                            {
                                
                                j;
                                while (j < this.m_featureLayerAddResults[p].addResults.length)
                                {
                                    
                                    if (!this.m_featureLayerAddResults[p].addResults[j].success)
                                    {
                                        this.operationCompleteLabel.text = UNDO_OPERATION_FAILED;
                                        break;
                                        continue;
                                    }
                                    j = (j + 1);
                                }
                                if (this.operationCompleteLabel.text == UNDO_OPERATION_FAILED)
                                {
                                    break;
                                    continue;
                                }
                                p = (p + 1);
                            }
                            this.m_undoRedoAddDeleteOperation = false;
                            this.m_undoRedoInProgress = false;
                            this.applyEditsComplete();
                        }
                    }
                }
                else if (this.m_lastUpdateOperation == "redo split geometry")
                {
                    this.m_arrUndoCutOperation.push({featureLayer:event.featureLayer, featureEditResults:event.featureEditResults});
                    this.redoCutComplete();
                }
                else
                {
                    if (this.m_lastUpdateOperation != "undo merge geometry")
                    {
                    }
                    if (this.m_lastUpdateOperation == "redo merge geometry")
                    {
                        this.m_arrUndoRedoMergeOperation.push(event.featureEditResults);
                        this.undoRedoMergeComplete();
                    }
                }
            }
            if (event.featureEditResults.deleteResults)
            {
            }
            if (event.featureEditResults.deleteResults.length > 0)
            {
                if (this.m_lastUpdateOperation == "undo split geometry")
                {
                    this.m_arrUndoCutOperation.push({featureLayer:event.featureLayer, featureEditResults:event.featureEditResults});
                    this.undoCutComplete();
                }
                else
                {
                    if (this.m_lastUpdateOperation != "undo merge geometry")
                    {
                    }
                    if (this.m_lastUpdateOperation == "redo merge geometry")
                    {
                        this.m_arrUndoRedoMergeOperation.push(event.featureEditResults);
                        this.undoRedoMergeComplete();
                    }
                    else if (this.m_undoRedoAddDeleteOperation)
                    {
                        this.m_undoRedoAddDeleteOperation = false;
                        if (this.m_undoAddOperation)
                        {
                            this.m_undoAddOperation = false;
                            this.m_editGraphic = null;
                            this.operationCompleteLabel.text = event.featureEditResults.deleteResults[0].success ? (UNDO_OPERATION_COMPLETE) : (UNDO_OPERATION_FAILED);
                        }
                        else
                        {
                            this.operationCompleteLabel.text = event.featureEditResults.deleteResults[0].success ? (REDO_OPERATION_COMPLETE) : (REDO_OPERATION_FAILED);
                        }
                        this.m_undoRedoInProgress = false;
                        this.applyEditsComplete();
                    }
                    else
                    {
                        var isOneFeatureSelected:* = function () : void
            {
                var _loc_1:Boolean = false;
                var _loc_2:Number = 0;
                while (_loc_2 < m_featureLayers.length)
                {
                    
                    if (FeatureLayer(m_featureLayers[_loc_2]).selectedFeatures.length > 0)
                    {
                        _loc_1 = true;
                        break;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                if (!_loc_1)
                {
                    m_editGraphic = null;
                    if (m_toolbarVisible)
                    {
                        deleteButton.enabled = false;
                    }
                    if (m_isEdit)
                    {
                        m_isEdit = false;
                        m_editTool.deactivate();
                        removeEditToolEventListeners();
                    }
                    if (map)
                    {
                        map.infoWindow.hide();
                    }
                }
                return;
            }// end function
            ;
                        if (this.m_featuresToBeDeleted)
                        {
                        }
                        if (this.m_featuresToBeDeleted.length > 0)
                        {
                            if (this.m_featuresToBeDeleted.length == 1)
                            {
                                this.m_undoRedoAddDeleteOperation = false;
                                if (this.m_featuresToBeDeleted[0].selectedFeatures.length == 1)
                                {
                                    if (event.featureEditResults.deleteResults[0].success)
                                    {
                                        this.operationCompleteLabel.text = DELETE_FEATURE_OPERATION_COMPLETE;
                                        this.m_editGraphic = null;
                                        this.m_isEdit = false;
                                        this.m_editTool.deactivate();
                                        this.removeEditToolEventListeners();
                                        if (this.map)
                                        {
                                            this.map.infoWindow.hide();
                                        }
                                    }
                                    else
                                    {
                                        this.operationCompleteLabel.text = DELETE_FEATURE_OPERATION_FAILED;
                                    }
                                    this.applyEditsComplete();
                                }
                                else
                                {
                                    this.operationCompleteLabel.text = DELETE_FEATURES_OPERATION_COMPLETE;
                                    d;
                                    while (d < event.featureEditResults.deleteResults.length)
                                    {
                                        
                                        if (!event.featureEditResults.deleteResults[d].success)
                                        {
                                            this.operationCompleteLabel.text = DELETE_FEATURES_OPERATION_FAILED;
                                            break;
                                            continue;
                                        }
                                        d = (d + 1);
                                    }
                                    this.m_undoRedoAddDeleteOperation = false;
                                    this.applyEditsComplete();
                                    if (this.operationCompleteLabel.text == DELETE_FEATURES_OPERATION_COMPLETE)
                                    {
                                        this.isOneFeatureSelected();
                                    }
                                }
                            }
                            else
                            {
                                var _loc_3:String = this;
                                var _loc_4:* = this.m_countDeleteFeatureLayers + 1;
                                _loc_3.m_countDeleteFeatureLayers = _loc_4;
                                this.operationCompleteLabel.text = DELETE_FEATURES_OPERATION_COMPLETE;
                                this.m_featureLayerDeleteResults.push({featureLayer:event.featureLayer, deleteResults:event.featureEditResults.deleteResults});
                                if (this.m_countDeleteFeatureLayers == this.m_featuresToBeDeleted.length)
                                {
                                    a;
                                    while (a < this.m_featureLayerDeleteResults.length)
                                    {
                                        
                                        b;
                                        while (b < this.m_featureLayerDeleteResults[a].deleteResults.length)
                                        {
                                            
                                            if (!this.m_featureLayerDeleteResults[a].deleteResults[b].success)
                                            {
                                                this.operationCompleteLabel.text = DELETE_FEATURES_OPERATION_FAILED;
                                                break;
                                                continue;
                                            }
                                            b = (b + 1);
                                        }
                                        if (this.operationCompleteLabel.text == DELETE_FEATURES_OPERATION_FAILED)
                                        {
                                            break;
                                            continue;
                                        }
                                        a = (a + 1);
                                    }
                                    if (this.operationCompleteLabel.text == DELETE_FEATURES_OPERATION_COMPLETE)
                                    {
                                        this.isOneFeatureSelected();
                                    }
                                    this.m_undoRedoAddDeleteOperation = false;
                                    this.applyEditsComplete();
                                }
                            }
                        }
                        if (this.m_toolbarVisible)
                        {
                            this.mergeReshapeButtonHandler();
                            this.checkForSelection();
                            this.updateDeleteButtonBasedOnSelection();
                        }
                    }
                }
            }
            if (event.featureEditResults.updateResults)
            {
            }
            if (event.featureEditResults.updateResults.length > 0)
            {
                if (this.m_lastUpdateOperation != "edit geometry")
                {
                }
                if (this.m_lastUpdateOperation != "edit attribute")
                {
                }
                if (this.m_lastUpdateOperation == "reshape geometry")
                {
                    this.operationCompleteLabel.text = event.featureEditResults.updateResults[0].success ? (UPDATE_FEATURE_OPERATION_COMPLETE) : (UPDATE_FEATURE_OPERATION_FAILED);
                    this.applyEditsComplete();
                    if (this.m_toolbarVisible)
                    {
                        this.mergeReshapeButtonHandler();
                        this.checkForSelection();
                    }
                    if (this.m_lastUpdateOperation == "edit geometry")
                    {
                        callLater(this.updateUndoRedoButtons);
                        callLater(this.activateEditToolAfterNormalize);
                    }
                    this.m_lastUpdateOperation = "";
                }
                if (this.m_lastUpdateOperation != "undo edit geometry")
                {
                }
                if (this.m_lastUpdateOperation != "undo edit attribute")
                {
                }
                if (this.m_lastUpdateOperation == "undo reshape geometry")
                {
                    this.m_lastUpdateOperation = "";
                    this.operationCompleteLabel.text = event.featureEditResults.updateResults[0].success ? (UNDO_OPERATION_COMPLETE) : (UNDO_OPERATION_FAILED);
                    this.m_undoRedoInProgress = false;
                    this.applyEditsComplete();
                    if (this.m_toolbarVisible)
                    {
                        this.mergeReshapeButtonHandler();
                        this.checkForSelection();
                    }
                }
                if (this.m_lastUpdateOperation != "redo edit geometry")
                {
                }
                if (this.m_lastUpdateOperation != "redo edit attribute")
                {
                }
                if (this.m_lastUpdateOperation == "redo reshape geometry")
                {
                    this.m_lastUpdateOperation = "";
                    this.operationCompleteLabel.text = event.featureEditResults.updateResults[0].success ? (REDO_OPERATION_COMPLETE) : (REDO_OPERATION_FAILED);
                    this.m_undoRedoInProgress = false;
                    this.applyEditsComplete();
                    if (this.m_toolbarVisible)
                    {
                        this.mergeReshapeButtonHandler();
                        this.checkForSelection();
                    }
                }
                if (this.m_lastUpdateOperation == "undo split geometry")
                {
                    this.m_arrUndoCutOperation.push({featureLayer:event.featureLayer, featureEditResults:event.featureEditResults});
                    this.undoCutComplete();
                }
                if (this.m_lastUpdateOperation == "redo split geometry")
                {
                    this.m_arrUndoCutOperation.push({featureLayer:event.featureLayer, featureEditResults:event.featureEditResults});
                    this.redoCutComplete();
                }
            }
            return;
        }// end function

        private function featureLayer_selectionClearHandler(event:FeatureLayerEvent) : void
        {
            if (this.map)
            {
                this.map.infoWindow.hide();
            }
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            CursorManager.removeCursor(CursorManager.currentCursorID);
            if (this.m_isEdit)
            {
            }
            if (!this.m_editClearSelection)
            {
                this.m_isEdit = false;
                this.m_editGraphic = null;
            }
            if (this.m_toolbarVisible)
            {
                this.m_drawTool.deactivate();
                this.mergeButton.enabled = false;
                this.reshapeButton.enabled = false;
                if (this.cutButton.selected)
                {
                    this.cutButton.selected = false;
                    this.cutReshapeButtonHandler();
                }
                if (this.m_featuresSelected)
                {
                    this.m_featuresSelected = false;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function featureLayer_selectionCompleteHandler(event:FeatureLayerEvent) : void
        {
            if (this.m_toolbarVisible)
            {
                if (!this.m_featuresSelected)
                {
                }
                if (event.featureLayer.selectedFeatures.length > 0)
                {
                    this.m_featuresSelected = true;
                    invalidateSkinState();
                }
                this.mergeReshapeButtonHandler();
            }
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
            if (this.m_toolbarVisible)
            {
                this.updateDeleteButtonBasedOnSelection();
            }
            return;
        }// end function

        private function selectionAddHandler(event:FeatureLayerEvent) : void
        {
            if (event.features)
            {
            }
            if (event.features.length > 0)
            {
                if (this.m_isEdit)
                {
                    this.m_isEdit = false;
                    if (this.m_toolbarVisible)
                    {
                    }
                    if (!this.m_featuresSelected)
                    {
                        this.m_featuresSelected = true;
                        invalidateSkinState();
                    }
                }
            }
            else
            {
                if (this.m_toolbarVisible)
                {
                }
                if (this.m_featuresSelected)
                {
                    this.m_featuresSelected = false;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function selectionSubtractHandler(event:FeatureLayerEvent) : void
        {
            if (event.features)
            {
            }
            if (event.features.length > 0)
            {
                this.m_attributeInspector.refresh();
                if (this.map)
                {
                    this.map.infoWindow.hide();
                }
                this.m_editTool.deactivate();
                this.removeEditToolEventListeners();
                CursorManager.removeCursor(CursorManager.currentCursorID);
                if (this.m_toolbarVisible)
                {
                    this.checkForSelection();
                }
                if (!this.m_featuresSelected)
                {
                    if (this.m_isEdit)
                    {
                    }
                    if (!this.m_editClearSelection)
                    {
                        this.m_isEdit = false;
                        this.m_editGraphic = null;
                    }
                }
            }
            return;
        }// end function

        private function selectionNewHandler(event:FeatureLayerEvent) : void
        {
            if (event.features)
            {
            }
            if (event.features.length == 0)
            {
                if (!this.m_selectionMode)
                {
                    if (this.m_isEdit)
                    {
                        this.m_isEdit = false;
                        this.m_editGraphic = null;
                    }
                    if (this.m_toolbarVisible)
                    {
                    }
                    if (this.m_featuresSelected)
                    {
                        this.m_featuresSelected = false;
                        invalidateSkinState();
                    }
                    if (this.map)
                    {
                        this.map.infoWindow.hide();
                    }
                    this.m_editTool.deactivate();
                    this.removeEditToolEventListeners();
                }
            }
            else if (this.m_isEdit)
            {
                this.m_isEdit = false;
                if (this.map)
                {
                    this.map.infoWindow.show(this.m_editPoint);
                    this.map.infoWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, this.infoWindowCloseButtonMouseDownHandler);
                }
                if (this.m_toolbarVisible)
                {
                }
                if (!this.m_featuresSelected)
                {
                    this.m_featuresSelected = true;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function checkForSelection() : void
        {
            if (this.m_featuresSelected)
            {
                this.m_featuresSelected = false;
                invalidateSkinState();
            }
            var _loc_1:Number = 0;
            while (_loc_1 < this.m_featureLayers.length)
            {
                
                if (FeatureLayer(this.m_featureLayers[_loc_1]).selectedFeatures.length > 0)
                {
                    if (!this.m_featuresSelected)
                    {
                        this.m_featuresSelected = true;
                        invalidateSkinState();
                        break;
                    }
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        private function updateDeleteButtonBasedOnSelection() : void
        {
            var _loc_1:Boolean = false;
            var _loc_3:FeatureLayer = null;
            var _loc_4:int = 0;
            var _loc_5:Graphic = null;
            var _loc_2:int = 0;
            while (_loc_2 < this.m_featureLayers.length)
            {
                
                _loc_3 = this.m_featureLayers[_loc_2];
                if (_loc_3.selectedFeatures.length > 0)
                {
                }
                if (this.checkIfDeleteIsAllowed(_loc_3))
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.selectedFeatures.length)
                    {
                        
                        _loc_5 = _loc_3.selectedFeatures[_loc_4];
                        if (_loc_3.isDeleteAllowed(_loc_5))
                        {
                            _loc_1 = true;
                            break;
                            continue;
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    if (_loc_1)
                    {
                        break;
                    }
                    else
                    {
                        _loc_2 = _loc_2 + 1;
                    }
                    continue;
                }
                _loc_2 = _loc_2 + 1;
            }
            if (this.m_toolbarVisible)
            {
                this.deleteButton.enabled = _loc_1;
            }
            return;
        }// end function

        private function mergeReshapeButtonHandler() : void
        {
            var _loc_5:Graphic = null;
            var _loc_1:Array = [];
            var _loc_2:Number = 0;
            while (_loc_2 < this.m_featureLayers.length)
            {
                
                if (FeatureLayer(this.m_featureLayers[_loc_2]).selectedFeatures.length > 0)
                {
                }
                if (this.checkIfGeometryUpdateIsAllowed(FeatureLayer(this.m_featureLayers[_loc_2])))
                {
                    for each (_loc_5 in FeatureLayer(this.m_featureLayers[_loc_2]).selectedFeatures)
                    {
                        
                        _loc_1.push(_loc_5);
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            if (_loc_1.length == 1)
            {
            }
            this.reshapeButton.enabled = this.m_updateGeometryEnabled ? (true) : (false);
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_1.length)
            {
                
                if (_loc_1[_loc_4].geometry is Polygon)
                {
                    _loc_3 = _loc_3 + 1;
                    if (_loc_3 >= 2)
                    {
                        break;
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_3 >= 2)
            {
            }
            this.mergeButton.enabled = this.m_updateGeometryEnabled ? (true) : (false);
            return;
        }// end function

        private function cutReshapeButtonHandler() : void
        {
            if (this.cutButton.selected)
            {
                this.m_cutInProgress = false;
                this.cutButton.selected = false;
            }
            if (this.reshapeButton.selected)
            {
                this.m_reshapeInProgress = false;
                this.reshapeButton.selected = false;
            }
            this.m_creationInProgress = false;
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.m_drawTool.deactivate();
            return;
        }// end function

        private function featureLayer_faultHandler(event:FaultEvent) : void
        {
            if (this.m_applyingEdits)
            {
                this.m_applyingEdits = false;
                invalidateSkinState();
            }
            if (this.m_tempNewFeature)
            {
                this.removeTempNewGraphic();
            }
            dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, event.fault));
            return;
        }// end function

        private function attributeInspector_activeFeatureChangeHandler(event:Event = null) : void
        {
            var _loc_2:Graphic = null;
            var _loc_3:FeatureLayer = null;
            if (this.m_tempNewFeature)
            {
                return;
            }
            if (!this.m_attributesSaved)
            {
                if (this.m_editGraphic)
                {
                    this.saveUnsavedAttributes(this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer));
                }
            }
            else
            {
                this.m_attributesSaved = false;
            }
            this.m_attributeInspector.deleteButtonVisible = this.deleteEnabled;
            this.m_attributeInspector.updateEnabled = this.updateAttributesEnabled;
            if (this.m_attributeInspector.activeFeatureIndex != -1)
            {
                if (this.m_attributeInspector.activeFeature)
                {
                }
                if (this.m_attributeInspector.activeFeature.geometry)
                {
                }
                if (this.m_attributeInspector.activeFeature.graphicsLayer)
                {
                    _loc_2 = this.m_attributeInspector.activeFeature;
                    _loc_3 = FeatureLayer(_loc_2.graphicsLayer);
                    if (this.m_isEdit)
                    {
                        this.m_editGraphic = _loc_2;
                        if (this.m_toolbarVisible)
                        {
                            this.deleteButton.enabled = _loc_3.isDeleteAllowed(_loc_2);
                        }
                        if (!(this.map.infoWindowContent is AttributeInspector))
                        {
                            this.map.infoWindowContent = this.m_attributeInspector;
                        }
                        if (this.m_updateGeometryEnabled)
                        {
                        }
                        if (this.checkIfGeometryUpdateIsAllowed(_loc_3))
                        {
                            this.checkIfGeometryUpdateIsAllowed(_loc_3);
                        }
                        if (_loc_3.isUpdateAllowed(this.m_editGraphic))
                        {
                            this.m_editTool.deactivate();
                            this.removeEditToolEventListeners();
                            this.m_editTool.activate(EditTool.MOVE | EditTool.EDIT_VERTICES, [this.m_editGraphic]);
                            this.addEditToolEventListeners();
                        }
                        this.updateAttributeInspector(_loc_3, _loc_2);
                        this.showAttributeInspector(this.m_editGraphic);
                    }
                }
            }
            return;
        }// end function

        private function templatePicker_selectedTemplateChangeHandler(event:TemplatePickerEvent) : void
        {
            var _loc_2:Symbol = null;
            var _loc_3:SimpleMarkerSymbol = null;
            var _loc_4:SimpleMarkerSymbol = null;
            var _loc_5:SimpleLineSymbol = null;
            var _loc_6:String = null;
            var _loc_7:SimpleFillSymbol = null;
            var _loc_8:String = null;
            if (!this.map)
            {
                return;
            }
            this.m_drawStart = false;
            this.m_lastActiveEdit = null;
            if (event.selectedTemplate)
            {
                if (this.m_tempNewFeature)
                {
                    this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
                }
                this.m_currentSelectedTemplateFeatureLayerChanged = false;
                if (this.m_currentSelectedTemplateFeatureLayer !== event.selectedTemplate.featureLayer)
                {
                    this.m_currentSelectedTemplateFeatureLayer = event.selectedTemplate.featureLayer;
                    this.m_currentSelectedTemplateFeatureLayerChanged = true;
                }
                if (this.m_showTemplateSwatchOnCursor)
                {
                    this.m_map.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
                    this.m_map.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
                }
                this.m_creationInProgress = true;
                this.m_graphicRemoved = false;
                this.m_templateSelected = true;
                if (this.m_toolbarVisible)
                {
                    invalidateSkinState();
                }
                this.m_createGeometryType = event.selectedTemplate.featureLayer.layerDetails.geometryType;
                dispatchEvent(new Event("createGeometryTypeChanged"));
                this.m_drawTool.deactivate();
                this.m_editTool.deactivate();
                this.removeEditToolEventListeners();
                this.clearSelection();
                switch(event.selectedTemplate.featureLayer.layerDetails.geometryType)
                {
                    case Geometry.MAPPOINT:
                    {
                        if (event.selectedTemplate.featureLayer.renderer)
                        {
                            _loc_2 = event.selectedTemplate.featureLayer.renderer.getSymbol(event.selectedTemplate.featureTemplate.prototype);
                            if (_loc_2)
                            {
                                this.m_drawTool.markerSymbol = _loc_2;
                            }
                        }
                        else if (event.selectedTemplate.featureLayer.symbol)
                        {
                            this.m_drawTool.markerSymbol = event.selectedTemplate.featureLayer.symbol;
                        }
                        else
                        {
                            this.m_drawTool.markerSymbol = new SimpleMarkerSymbol();
                        }
                        if (this.m_showTemplateSwatchOnCursor)
                        {
                            if (this.m_drawTool.markerSymbol is CompositeSymbol)
                            {
                                _loc_3 = new SimpleMarkerSymbol();
                                this.m_templateSwatch = _loc_3.createSwatch(50, 50);
                            }
                            else
                            {
                                this.m_templateSwatch = this.m_drawTool.markerSymbol.createSwatch(50, 50);
                            }
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        if (!this.m_toolbarVisible)
                        {
                            this.m_drawTool.activate(DrawTool.MAPPOINT);
                        }
                        else
                        {
                            this.drawDropDownList.selectedIndex = -1;
                            this.drawDropDownList.selectedIndex = 0;
                        }
                        break;
                    }
                    case Geometry.MULTIPOINT:
                    {
                        if (event.selectedTemplate.featureLayer.renderer)
                        {
                            _loc_2 = event.selectedTemplate.featureLayer.renderer.getSymbol(event.selectedTemplate.featureTemplate.prototype);
                            if (_loc_2)
                            {
                                this.m_drawTool.markerSymbol = _loc_2;
                            }
                        }
                        else if (event.selectedTemplate.featureLayer.symbol)
                        {
                            this.m_drawTool.markerSymbol = event.selectedTemplate.featureLayer.symbol;
                        }
                        else
                        {
                            this.m_drawTool.markerSymbol = new SimpleMarkerSymbol();
                        }
                        if (this.m_showTemplateSwatchOnCursor)
                        {
                            if (this.m_drawTool.markerSymbol is CompositeSymbol)
                            {
                                _loc_4 = new SimpleMarkerSymbol();
                                this.m_templateSwatch = _loc_4.createSwatch(50, 50);
                            }
                            else
                            {
                                this.m_templateSwatch = this.m_drawTool.markerSymbol.createSwatch(50, 50);
                            }
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        if (!this.m_toolbarVisible)
                        {
                            this.m_drawTool.activate(DrawTool.MULTIPOINT);
                        }
                        else
                        {
                            this.drawDropDownList.selectedIndex = -1;
                            this.drawDropDownList.selectedIndex = 0;
                        }
                        break;
                    }
                    case Geometry.POLYLINE:
                    {
                        if (event.selectedTemplate.featureLayer.renderer)
                        {
                            _loc_2 = event.selectedTemplate.featureLayer.renderer.getSymbol(event.selectedTemplate.featureTemplate.prototype);
                            if (_loc_2)
                            {
                                this.m_drawTool.lineSymbol = _loc_2;
                            }
                        }
                        else if (event.selectedTemplate.featureLayer.symbol)
                        {
                            this.m_drawTool.lineSymbol = event.selectedTemplate.featureLayer.symbol;
                        }
                        else
                        {
                            this.m_drawTool.lineSymbol = new SimpleLineSymbol();
                        }
                        if (this.m_showTemplateSwatchOnCursor)
                        {
                            if (this.m_drawTool.lineSymbol is CompositeSymbol)
                            {
                                _loc_5 = new SimpleLineSymbol();
                                this.m_templateSwatch = _loc_5.createSwatch(50, 50);
                            }
                            else
                            {
                                this.m_templateSwatch = this.m_drawTool.lineSymbol.createSwatch(50, 50, event.selectedTemplate.featureTemplate.drawingTool);
                            }
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        if (!this.m_toolbarVisible)
                        {
                            if (this.createOptions)
                            {
                                this.m_drawTool.activate(this.createOptions.polylineDrawTools[0]);
                            }
                            else if (event.selectedTemplate.featureTemplate.drawingTool)
                            {
                                switch(event.selectedTemplate.featureTemplate.drawingTool)
                                {
                                    case FeatureTemplate.TOOL_LINE:
                                    {
                                        this.m_drawTool.activate(DrawTool.POLYLINE);
                                        break;
                                    }
                                    case FeatureTemplate.TOOL_CIRCLE:
                                    case FeatureTemplate.TOOL_ELLIPSE:
                                    case FeatureTemplate.TOOL_RECTANGLE:
                                    case FeatureTemplate.TOOL_FREEHAND:
                                    {
                                        this.m_drawTool.activate(DrawTool.FREEHAND_POLYLINE);
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                this.m_drawTool.activate(DrawTool.POLYLINE);
                            }
                        }
                        else
                        {
                            this.drawDropDownList.selectedIndex = -1;
                            if (this.createOptions)
                            {
                                this.drawDropDownList.selectedIndex = this.m_lastPolylineCreateOptionIndex;
                            }
                            else if (event.selectedTemplate.featureTemplate.drawingTool)
                            {
                                if (this.m_currentSelectedTemplateFeatureLayerChanged)
                                {
                                    _loc_6 = "";
                                    switch(event.selectedTemplate.featureTemplate.drawingTool)
                                    {
                                        case FeatureTemplate.TOOL_LINE:
                                        {
                                            _loc_6 = "pointToPointLine";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_CIRCLE:
                                        case FeatureTemplate.TOOL_ELLIPSE:
                                        case FeatureTemplate.TOOL_RECTANGLE:
                                        case FeatureTemplate.TOOL_FREEHAND:
                                        {
                                            _loc_6 = "freehandLine";
                                            break;
                                        }
                                        default:
                                        {
                                            break;
                                        }
                                    }
                                    callLater(this.checkDrawingToolInfo, [_loc_6, true]);
                                }
                                else
                                {
                                    this.drawDropDownList.selectedIndex = this.m_lastPolylineCreateOptionIndex;
                                }
                            }
                            else
                            {
                                this.drawDropDownList.selectedIndex = this.m_lastPolylineCreateOptionIndex;
                            }
                        }
                        break;
                    }
                    case Geometry.POLYGON:
                    {
                        if (event.selectedTemplate.featureLayer.renderer)
                        {
                            _loc_2 = event.selectedTemplate.featureLayer.renderer.getSymbol(event.selectedTemplate.featureTemplate.prototype);
                            if (_loc_2)
                            {
                                this.m_drawTool.fillSymbol = _loc_2;
                            }
                        }
                        else if (event.selectedTemplate.featureLayer.symbol)
                        {
                            this.m_drawTool.fillSymbol = event.selectedTemplate.featureLayer.symbol;
                        }
                        else
                        {
                            this.m_drawTool.fillSymbol = new SimpleFillSymbol();
                        }
                        if (this.m_showTemplateSwatchOnCursor)
                        {
                            if (this.m_drawTool.fillSymbol is CompositeSymbol)
                            {
                                _loc_7 = new SimpleFillSymbol();
                                this.m_templateSwatch = _loc_7.createSwatch(25, 25);
                            }
                            else
                            {
                                this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, event.selectedTemplate.featureTemplate.drawingTool);
                            }
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        if (!this.m_toolbarVisible)
                        {
                            if (this.createOptions)
                            {
                                this.m_drawTool.activate(this.createOptions.polygonDrawTools[0]);
                            }
                            else if (event.selectedTemplate.featureTemplate.drawingTool)
                            {
                                switch(event.selectedTemplate.featureTemplate.drawingTool)
                                {
                                    case FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON:
                                    case FeatureTemplate.TOOL_FREEHAND:
                                    {
                                        this.m_drawTool.activate(DrawTool.FREEHAND_POLYGON);
                                        break;
                                    }
                                    case FeatureTemplate.TOOL_CIRCLE:
                                    {
                                        this.m_drawTool.activate(DrawTool.CIRCLE);
                                        break;
                                    }
                                    case FeatureTemplate.TOOL_ELLIPSE:
                                    {
                                        this.m_drawTool.activate(DrawTool.ELLIPSE);
                                        break;
                                    }
                                    case FeatureTemplate.TOOL_POLYGON:
                                    case FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON:
                                    {
                                        this.m_drawTool.activate(DrawTool.POLYGON);
                                        break;
                                    }
                                    case FeatureTemplate.TOOL_RECTANGLE:
                                    {
                                        this.m_drawTool.activate(DrawTool.EXTENT);
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                this.m_drawTool.activate(DrawTool.POLYGON);
                            }
                        }
                        else
                        {
                            this.drawDropDownList.selectedIndex = -1;
                            if (this.createOptions)
                            {
                                this.drawDropDownList.selectedIndex = this.m_lastPolygonCreateOptionIndex;
                            }
                            else if (event.selectedTemplate.featureTemplate.drawingTool)
                            {
                                if (this.m_currentSelectedTemplateFeatureLayerChanged)
                                {
                                    _loc_8 = "";
                                    switch(event.selectedTemplate.featureTemplate.drawingTool)
                                    {
                                        case FeatureTemplate.TOOL_FREEHAND:
                                        {
                                            _loc_8 = "freehandPolygon";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_CIRCLE:
                                        {
                                            _loc_8 = "circle";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_ELLIPSE:
                                        {
                                            _loc_8 = "ellipse";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_POLYGON:
                                        {
                                            _loc_8 = "pointToPointPolygon";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON:
                                        case FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON:
                                        {
                                            _loc_8 = "autoComplete";
                                            break;
                                        }
                                        case FeatureTemplate.TOOL_RECTANGLE:
                                        {
                                            _loc_8 = "extent";
                                            break;
                                        }
                                        default:
                                        {
                                            break;
                                        }
                                    }
                                    callLater(this.checkDrawingToolInfo, [_loc_8, false]);
                                }
                                else
                                {
                                    this.drawDropDownList.selectedIndex = this.m_lastPolygonCreateOptionIndex;
                                }
                            }
                            else
                            {
                                this.drawDropDownList.selectedIndex = this.m_lastPolygonCreateOptionIndex;
                            }
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (this.m_templateSwatch)
                {
                    this.m_templateSwatch.filters = [new DropShadowFilter(6, 45, 0, 0.4)];
                }
            }
            else
            {
                this.m_creationInProgress = false;
                this.m_templateSelected = false;
                if (this.m_templateSwatch)
                {
                    this.m_templateSwatch.visible = false;
                }
                this.m_map.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
                this.m_map.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
                if (this.m_toolbarVisible)
                {
                    this.drawDropDownList.selectedIndex = -1;
                    invalidateSkinState();
                }
                this.m_drawTool.deactivate();
                this.m_drawTool.fillSymbol = this.m_selectionExtentSymbol;
            }
            return;
        }// end function

        private function checkDrawingToolInfo(drawingToolString:String, polylineDrawing:Boolean) : void
        {
            var _loc_3:Number = 0;
            while (_loc_3 < this.drawDropDownList.dataProvider.length)
            {
                
                if (drawingToolString == this.drawDropDownList.dataProvider.getItemAt(_loc_3).drawId)
                {
                    this.drawDropDownList.selectedIndex = _loc_3;
                    if (polylineDrawing)
                    {
                        this.m_lastPolygonCreateOptionIndex = _loc_3;
                    }
                    else
                    {
                        this.m_lastPolylineCreateOptionIndex = _loc_3;
                    }
                    break;
                    continue;
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            this.m_map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            this.m_map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            if (this.m_templateSwatch)
            {
                this.m_templateSwatch.visible = false;
            }
            return;
        }// end function

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            if (this.templatePicker.selectedTemplate)
            {
            }
            if (!this.m_drawStart)
            {
                if (this.m_showTemplateSwatchOnCursor)
                {
                }
                if (this.m_templateSwatch)
                {
                    this.m_templateSwatch.x = this.templatePicker.selectedTemplate.featureLayer.layerDetails.geometryType == Geometry.POLYGON ? (event.stageX + 20) : (event.stageX);
                    this.m_templateSwatch.y = this.templatePicker.selectedTemplate.featureLayer.layerDetails.geometryType == Geometry.POLYGON ? (event.stageY + 20) : (event.stageY);
                    event.updateAfterEvent();
                    this.m_templateSwatch.visible = true;
                }
            }
            return;
        }// end function

        private function addSwatchToStage(templateSwatch:UIComponent) : void
        {
            FlexGlobals.topLevelApplication.addElement(templateSwatch);
            templateSwatch.visible = false;
            templateSwatch.includeInLayout = false;
            return;
        }// end function

        private function selectionDropDownList_changeHandler(event:IndexChangeEvent) : void
        {
            if (this.m_tempNewFeature)
            {
                this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
            }
            if (event.newIndex != -1)
            {
                this.m_graphicRemoved = false;
                if (this.templatePicker.selectedTemplate)
                {
                    this.templatePicker.clearSelection();
                }
                this.m_drawTool.deactivate();
                this.m_drawTool.fillSymbol = this.m_selectionExtentSymbol;
                this.m_drawTool.activate(DrawTool.EXTENT);
            }
            return;
        }// end function

        private function dropDownList_mouseDownHandler(event:MouseEvent) : void
        {
            if (!this.map)
            {
                return;
            }
            if (this.m_tempNewFeature)
            {
                this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
            }
            this.cutReshapeButtonHandler();
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.map.infoWindow.hide();
            return;
        }// end function

        private function clearSelectionButton_clickHandler(event:MouseEvent) : void
        {
            if (!this.map)
            {
                return;
            }
            this.cutReshapeButtonHandler();
            if (this.m_editClearSelection)
            {
                this.m_editClearSelection = false;
            }
            this.clearSelection();
            return;
        }// end function

        private function attributeInspector_updateFeatureHandler(event:AttributeInspectorEvent) : void
        {
            this.m_activeFeatureChangedAttributes.push({field:event.field, oldValue:event.oldValue, newValue:event.newValue});
            return;
        }// end function

        private function attributeInspector_deleteFeatureHandler(event:AttributeInspectorEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:DeleteOperation = null;
            if (this.m_tempNewFeature)
            {
                this.m_deletingTempGraphic = true;
                this.removeTempNewGraphic();
                this.map.infoWindow.hide();
            }
            else
            {
                _loc_2 = [event.feature];
                event.featureLayer.applyEdits(null, null, _loc_2, false, new AsyncResponder(this.attributeInspector_editsCompleteHandler, this.attributeInspector_faultHandler));
                this.m_featuresToBeDeleted = [];
                this.m_featuresToBeDeleted.push({selectedFeatures:_loc_2, featureLayer:this.attributeInspector.activeFeatureLayer});
                _loc_3 = new DeleteOperation(this.m_featuresToBeDeleted);
                this.m_undoManager.pushUndo(_loc_3);
                callLater(this.updateUndoRedoButtons);
                this.operationStartLabel.text = DELETE_FEATURE_OPERATION_START;
                this.m_applyingEdits = true;
                invalidateSkinState();
            }
            return;
        }// end function

        private function attributeInspector_saveFeatureHandler(event:AttributeInspectorEvent) : void
        {
            if (this.m_tempNewFeature)
            {
                this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
            }
            else
            {
                this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                this.map.infoWindow.hide();
            }
            return;
        }// end function

        private function drawDropDownList_changeHandler(event:IndexChangeEvent) : void
        {
            this.pickDrawingOption(event.currentTarget as DropDownList);
            return;
        }// end function

        private function drawDropDownList_valueCommitHandler(event:FlexEvent) : void
        {
            this.pickDrawingOption(event.currentTarget as DropDownList);
            return;
        }// end function

        private function pickDrawingOption(dropDownList:DropDownList) : void
        {
            this.m_drawTool.deactivate();
            if (dropDownList.selectedItem)
            {
                switch(dropDownList.selectedItem.drawId)
                {
                    case "mappoint":
                    {
                        if (this.templatePicker.selectedTemplate)
                        {
                        }
                        if (this.templatePicker.selectedTemplate.featureLayer.layerDetails.geometryType == Geometry.MULTIPOINT)
                        {
                            this.m_drawTool.activate(DrawTool.MULTIPOINT);
                        }
                        else
                        {
                            this.m_drawTool.activate(DrawTool.MAPPOINT);
                        }
                        break;
                    }
                    case "freehandLine":
                    {
                        this.m_drawTool.activate(DrawTool.FREEHAND_POLYLINE);
                        this.m_lastPolylineCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.lineSymbol.createSwatch(50, 50, FeatureTemplate.TOOL_FREEHAND);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "line":
                    {
                        this.m_drawTool.activate(DrawTool.LINE);
                        this.m_lastPolylineCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.lineSymbol.createSwatch(50, 50, FeatureTemplate.TOOL_LINE);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "pointToPointLine":
                    {
                        this.m_drawTool.activate(DrawTool.POLYLINE);
                        this.m_lastPolylineCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.lineSymbol.createSwatch(50, 50, FeatureTemplate.TOOL_LINE);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "freehandPolygon":
                    {
                        this.m_drawTool.activate(DrawTool.FREEHAND_POLYGON);
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_FREEHAND);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "pointToPointPolygon":
                    {
                        this.m_drawTool.activate(DrawTool.POLYGON);
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_POLYGON);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "extent":
                    {
                        this.m_drawTool.activate(DrawTool.EXTENT);
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_RECTANGLE);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "circle":
                    {
                        this.m_drawTool.activate(DrawTool.CIRCLE);
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_CIRCLE);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "ellipse":
                    {
                        this.m_drawTool.activate(DrawTool.ELLIPSE);
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_ELLIPSE);
                        this.addSwatchToStage(this.m_templateSwatch);
                        break;
                    }
                    case "autoComplete":
                    {
                        if (this.templatePicker.selectedTemplate)
                        {
                        }
                        if (this.templatePicker.selectedTemplate.featureTemplate.drawingTool == FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON)
                        {
                            this.m_drawTool.activate(DrawTool.FREEHAND_POLYGON);
                            this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_AUTO_COMPLETE_FREEHAND_POLYGON);
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        else
                        {
                            this.m_drawTool.activate(DrawTool.POLYGON);
                            this.m_templateSwatch = this.m_drawTool.fillSymbol.createSwatch(25, 25, FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON);
                            this.addSwatchToStage(this.m_templateSwatch);
                        }
                        this.m_lastPolygonCreateOptionIndex = this.drawDropDownList.selectedIndex;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function drawTool_drawStartHandler(event:DrawEvent) : void
        {
            this.m_drawStart = true;
            this.m_currentlyDrawnGraphic = event.graphic;
            if (this.m_templateSwatch)
            {
                this.m_templateSwatch.visible = false;
            }
            return;
        }// end function

        private function drawTool_drawEndHandler(event:DrawEvent) : void
        {
            var spatialReference:SpatialReference;
            var featureLayer1:FeatureLayer;
            var extent:Extent;
            var arrPoints:Array;
            var polygon:Polygon;
            var newGraphic:Graphic;
            var fault:Fault;
            var featureSetArray:Array;
            var polygonPolylineFeatureLayerCount:int;
            var queryResultCount:int;
            var cutRequestCount:int;
            var p:Number;
            var cut_polylineResultHandler:Function;
            var cut_polygonResultHandler:Function;
            var cut_faultHandler:Function;
            var reshapeSelectedFeaturesArray:Array;
            var r:Number;
            var featureArray:Array;
            var k:Number;
            var reshape_resultHandler:Function;
            var reshape_faultHandler:Function;
            var reshapeFeature:Graphic;
            var nGraphic:Graphic;
            var event:* = event;
            this.m_creationInProgress = false;
            this.m_drawStart = false;
            this.m_doNotApplyEdits = false;
            spatialReference = FeatureLayer(this.m_featureLayers[0]).map.spatialReference;
            if (!this.m_graphicRemoved)
            {
                if (!this.m_templateSelected)
                {
                    if (event.graphic.geometry.type != Geometry.EXTENT)
                    {
                    }
                }
                if (event.graphic.geometry.type == Geometry.POLYGON)
                {
                    this.m_query = new Query();
                    this.m_query.geometry = event.graphic.geometry;
                    this.m_query.where = " ";
                    var _loc_3:int = 0;
                    var _loc_4:* = this.m_featureLayers;
                    while (_loc_4 in _loc_3)
                    {
                        
                        featureLayer1 = _loc_4[_loc_3];
                        if (featureLayer1.visible)
                        {
                        }
                        if (!featureLayer1.isInScaleRange)
                        {
                            continue;
                        }
                        switch(this.selectionDropDownList.selectedItem.selectionName)
                        {
                            case "newSelection":
                            {
                                featureLayer1.selectFeatures(this.m_query, "new");
                                break;
                            }
                            case "addToSelection":
                            {
                                featureLayer1.selectFeatures(this.m_query, "add");
                                break;
                            }
                            case "subtractFromSelection":
                            {
                                featureLayer1.selectFeatures(this.m_query, "subtract");
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    this.m_drawTool.deactivate();
                    this.selectionDropDownList.selectedIndex = -1;
                }
                else if (event.graphic.geometry.type == Geometry.EXTENT)
                {
                    extent = event.graphic.geometry as Extent;
                    if (extent.xmin != extent.xmax)
                    {
                    }
                    if (extent.ymin != extent.ymax)
                    {
                        arrPoints;
                        polygon = new Polygon();
                        polygon.addRing(arrPoints);
                        polygon.spatialReference = extent.spatialReference;
                        this.m_newFeatureCreated = true;
                        newGraphic = this.templatePicker.selectedTemplate.featureTemplate ? (new Graphic(polygon, null, ObjectUtil.copy(this.templatePicker.selectedTemplate.featureTemplate.prototype.attributes))) : (new Graphic(polygon));
                        this.createApplyEdits(newGraphic);
                    }
                    else
                    {
                        this.templatePicker.clearSelection();
                    }
                }
                else if (event.graphic.geometry.type == Geometry.POLYGON)
                {
                    var savePolygon:* = function (polygon:Polygon) : void
            {
                var featureSetArray:Array;
                var polygonFeatureLayerCount:Number;
                var i:Number;
                var autoComplete_resultHandler:Function;
                var autoComplete_faultHandler:Function;
                var g:Graphic;
                var polygon:* = polygon;
                if (m_toolbarVisible)
                {
                }
                if (drawDropDownList.selectedItem.drawId != "autoComplete")
                {
                    if (!m_toolbarVisible)
                    {
                    }
                    if (templatePicker.selectedTemplate.featureTemplate.drawingTool)
                    {
                    }
                }
                if (templatePicker.selectedTemplate.featureTemplate.drawingTool == FeatureTemplate.TOOL_AUTO_COMPLETE_POLYGON)
                {
                    var query_resultHandler:* = function (featureSet:FeatureSet) : void
                {
                    var featureArray:Array;
                    var count:Number;
                    var feature:Graphic;
                    var newGraphic:Graphic;
                    var geometries:Array;
                    var geometry:Geometry;
                    var fault:Fault;
                    var featureSet:* = featureSet;
                    featureSetArray.push(featureSet);
                    if (featureSetArray.length == polygonFeatureLayerCount)
                    {
                        featureArray;
                        count;
                        var _loc_3:int = 0;
                        var _loc_4:* = featureSetArray;
                        while (_loc_4 in _loc_3)
                        {
                            
                            featureSet = _loc_4[_loc_3];
                            if (featureSet.features.length > 0)
                            {
                                var _loc_5:int = 0;
                                var _loc_6:* = featureSet.features;
                                while (_loc_6 in _loc_5)
                                {
                                    
                                    feature = _loc_6[_loc_5];
                                    featureArray.push(feature);
                                }
                                continue;
                            }
                            count = (count + 1);
                        }
                        if (count == featureSetArray.length)
                        {
                            m_newFeatureCreated = true;
                            newGraphic = templatePicker.selectedTemplate.featureTemplate ? (new Graphic(polygon, null, ObjectUtil.copy(templatePicker.selectedTemplate.featureTemplate.prototype.attributes))) : (new Graphic(polygon));
                            createApplyEdits(newGraphic);
                        }
                        else
                        {
                            var geometryServiceAutoComplete:* = function (geometryService:GeometryService) : void
                    {
                        geometryService.autoComplete(geometries, [polygonToPolyline(polygon)], new Responder(autoComplete_resultHandler, autoComplete_faultHandler));
                        return;
                    }// end function
                    ;
                            geometries = GraphicUtil.getGeometries(featureArray);
                            var _loc_3:int = 0;
                            var _loc_4:* = geometries;
                            while (_loc_4 in _loc_3)
                            {
                                
                                geometry = _loc_4[_loc_3];
                                if (!geometry.spatialReference)
                                {
                                    geometry.spatialReference = spatialReference;
                                }
                            }
                            if (m_geometryService)
                            {
                                new activation.geometryServiceAutoComplete(m_geometryService);
                            }
                            else if (GeometryServiceSingleton.instance.url)
                            {
                                new activation.geometryServiceAutoComplete(GeometryServiceSingleton.instance);
                            }
                            else
                            {
                                templatePicker.clearSelection();
                                fault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.GEOMETRYSERVICE_REQUIRED));
                                dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                            }
                        }
                    }
                    return;
                }// end function
                ;
                    var query_faultHandler:* = function (fault:Fault) : void
                {
                    return;
                }// end function
                ;
                    autoComplete_resultHandler = function (result:Object) : void
                {
                    var _loc_3:Geometry = null;
                    var _loc_2:Array = [];
                    for each (_loc_3 in result)
                    {
                        
                        if (templatePicker.selectedTemplate.featureTemplate)
                        {
                            _loc_2.push(new Graphic(_loc_3, null, ObjectUtil.copy(templatePicker.selectedTemplate.featureTemplate.prototype.attributes)));
                            continue;
                        }
                        _loc_2.push(new Graphic(_loc_3));
                    }
                    m_newFeatureCreated = true;
                    createApplyEdits(_loc_2[0] as Graphic);
                    return;
                }// end function
                ;
                    autoComplete_faultHandler = function (fault:Fault) : void
                {
                    return;
                }// end function
                ;
                    m_query = new Query();
                    m_query.geometry = polygon;
                    featureSetArray;
                    polygonFeatureLayerCount;
                    i;
                    while (i < m_featureLayers.length)
                    {
                        
                        if (FeatureLayer(m_featureLayers[i]).visible)
                        {
                        }
                        if (!FeatureLayer(m_featureLayers[i]).isInScaleRange)
                        {
                        }
                        else if (FeatureLayer(m_featureLayers[i]).layerDetails.geometryType == Geometry.POLYGON)
                        {
                            polygonFeatureLayerCount = (polygonFeatureLayerCount + 1);
                            FeatureLayer(m_featureLayers[i]).queryFeatures(m_query, new Responder(query_resultHandler, query_faultHandler));
                        }
                        i = (i + 1);
                    }
                }
                else
                {
                    m_newFeatureCreated = true;
                    g = templatePicker.selectedTemplate.featureTemplate ? (new Graphic(polygon, null, ObjectUtil.copy(templatePicker.selectedTemplate.featureTemplate.prototype.attributes))) : (new Graphic(polygon));
                    createApplyEdits(g);
                }
                return;
            }// end function
            ;
                    if (GeometryUtil.polygonSelfIntersecting(Polygon(event.graphic.geometry)))
                    {
                        var geometryServiceSimplify:* = function (geometryService:GeometryService) : void
            {
                var simplify_resultHandler:Function;
                var simplify_faultHandler:Function;
                var geometryService:* = geometryService;
                simplify_resultHandler = function (result:Object) : void
                {
                    savePolygon(Polygon(result[0]));
                    return;
                }// end function
                ;
                simplify_faultHandler = function (fault:Fault) : void
                {
                    templatePicker.clearSelection();
                    dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                    return;
                }// end function
                ;
                geometryService.simplify([event.graphic.geometry], new Responder(simplify_resultHandler, simplify_faultHandler));
                return;
            }// end function
            ;
                        if (this.m_geometryService)
                        {
                            this.geometryServiceSimplify(this.m_geometryService);
                        }
                        else if (GeometryServiceSingleton.instance.url)
                        {
                            this.geometryServiceSimplify(GeometryServiceSingleton.instance);
                        }
                        else
                        {
                            fault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.GEOMETRYSERVICE_REQUIRED));
                            dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                            this.templatePicker.clearSelection();
                        }
                    }
                    else
                    {
                        this.savePolygon(Polygon(event.graphic.geometry));
                    }
                }
                else
                {
                    if (event.graphic.geometry.type == Geometry.POLYLINE)
                    {
                    }
                    if (this.m_cutInProgress)
                    {
                        var query_resultHandler:* = function (featureSet:FeatureSet, token:Object = null) : void
            {
                var _loc_4:* = queryResultCount + 1;
                queryResultCount = _loc_4;
                featureSetArray.push({featureSet:featureSet, featureLayer:token});
                startCut();
                return;
            }// end function
            ;
                        var query_faultHandler:* = function (fault:Fault, token:Object = null) : void
            {
                var _loc_4:* = queryResultCount + 1;
                queryResultCount = _loc_4;
                templatePicker.clearSelection();
                startCut();
                return;
            }// end function
            ;
                        var startCut:* = function () : void
            {
                var count:Number;
                var i:Number;
                var feature:Graphic;
                var cutFault:Fault;
                if (queryResultCount == polygonPolylineFeatureLayerCount)
                {
                    m_cutQueryFeatureArray = [];
                    count;
                    i;
                    while (i < featureSetArray.length)
                    {
                        
                        if (featureSetArray[i].featureSet.features.length > 0)
                        {
                            var _loc_2:int = 0;
                            var _loc_3:* = featureSetArray[i].featureSet.features;
                            while (_loc_3 in _loc_2)
                            {
                                
                                feature = _loc_3[_loc_2];
                                m_cutQueryFeatureArray.push({feature:feature, featureLayer:featureSetArray[i].featureLayer});
                            }
                        }
                        else
                        {
                            count = (count + 1);
                        }
                        i = (i + 1);
                    }
                    if (count == featureSetArray.length)
                    {
                        m_cutInProgress = false;
                        cutButton.selected = false;
                    }
                    else
                    {
                        var geometryServiceCut:* = function (geometryService:GeometryService) : void
                {
                    m_polylinePolygonCutResultArray = [];
                    var _loc_2:Array = [];
                    var _loc_3:Array = [];
                    var _loc_4:Array = [];
                    var _loc_5:Array = [];
                    var _loc_6:Number = 0;
                    while (_loc_6 < m_cutQueryFeatureArray.length)
                    {
                        
                        if (!m_cutQueryFeatureArray[_loc_6].feature.geometry.spatialReference)
                        {
                            m_cutQueryFeatureArray[_loc_6].feature.geometry.spatialReference = spatialReference;
                        }
                        if (m_cutQueryFeatureArray[_loc_6].feature.geometry.type == Geometry.POLYLINE)
                        {
                            _loc_2.push(m_cutQueryFeatureArray[_loc_6].feature.geometry);
                            _loc_3.push(m_cutQueryFeatureArray[_loc_6]);
                        }
                        else if (m_cutQueryFeatureArray[_loc_6].feature.geometry.type == Geometry.POLYGON)
                        {
                            _loc_4.push(m_cutQueryFeatureArray[_loc_6].feature.geometry);
                            _loc_5.push(m_cutQueryFeatureArray[_loc_6]);
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                    if (_loc_2.length > 0)
                    {
                        var _loc_8:* = cutRequestCount + 1;
                        cutRequestCount = _loc_8;
                        geometryService.cut(_loc_2, Polyline(event.graphic.geometry), new AsyncResponder(cut_polylineResultHandler, cut_faultHandler, {featureArray:_loc_3}));
                    }
                    if (_loc_4.length > 0)
                    {
                        var _loc_8:* = cutRequestCount + 1;
                        cutRequestCount = _loc_8;
                        geometryService.cut(_loc_4, Polyline(event.graphic.geometry), new AsyncResponder(cut_polygonResultHandler, cut_faultHandler, {featureArray:_loc_5}));
                    }
                    return;
                }// end function
                ;
                        if (m_geometryService)
                        {
                            new activation.geometryServiceCut(m_geometryService);
                        }
                        else if (GeometryServiceSingleton.instance.url)
                        {
                            new activation.geometryServiceCut(GeometryServiceSingleton.instance);
                        }
                        else
                        {
                            m_cutInProgress = false;
                            cutButton.selected = false;
                            cutFault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.GEOMETRYSERVICE_REQUIRED));
                            dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, cutFault));
                        }
                    }
                }
                return;
            }// end function
            ;
                        cut_polylineResultHandler = function (result:Object, token:Object = null) : void
            {
                m_polylinePolygonCutResultArray.push({result:result, featureArray:token.featureArray});
                handleCutResult();
                return;
            }// end function
            ;
                        cut_polygonResultHandler = function (result:Object, token:Object = null) : void
            {
                m_polylinePolygonCutResultArray.push({result:result, featureArray:token.featureArray});
                handleCutResult();
                return;
            }// end function
            ;
                        cut_faultHandler = function (fault:Fault, token:Object = null) : void
            {
                m_cutInProgress = false;
                cutButton.selected = false;
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                return;
            }// end function
            ;
                        var handleCutResult:* = function () : void
            {
                var arrCutFeatures:Array;
                var arrAddsUpdates:Array;
                var a:int;
                var featuresArray:Array;
                var c:int;
                var b:int;
                if (m_polylinePolygonCutResultArray.length == cutRequestCount)
                {
                    var cut_selectResult:* = function (features:Array, token:Object = null) : void
                {
                    var cutOperation:CutOperation;
                    var featureEditResultsArray:Array;
                    var applyEditsResultCount:int;
                    var applyEditsFault:Boolean;
                    var k:Number;
                    var polylineFeaturesArray:Array;
                    var polygonFeaturesArray:Array;
                    var i:Number;
                    var features:* = features;
                    var token:* = token;
                    featuresArray.push({feature:features[0], resultGeometries:token.resultGeometries, cutIndexes:token.cutIndexes});
                    if (featuresArray.length == arrCutFeatures.length)
                    {
                        var addUpdateFeatures:* = function (arr:Array) : void
                    {
                        var _loc_3:Boolean = false;
                        var _loc_4:Number = NaN;
                        var _loc_2:Number = 0;
                        while (_loc_2 < arr.length)
                        {
                            
                            _loc_3 = true;
                            _loc_4 = 0;
                            while (_loc_4 < arr[_loc_2].cutIndexes.length)
                            {
                                
                                if (_loc_2 == arr[_loc_2].cutIndexes[_loc_4])
                                {
                                    if (_loc_3)
                                    {
                                        m_undoCutGeometryArray.push({feature:Graphic(arr[_loc_2].feature), geometry:ObjectUtil.copy(Graphic(arr[_loc_2].feature).geometry) as Geometry});
                                        m_redoCutGeometryArray.push({feature:Graphic(arr[_loc_2].feature), geometry:ObjectUtil.copy(arr[_loc_2].resultGeometries[_loc_4]) as Geometry});
                                        Graphic(arr[_loc_2].feature).geometry = arr[_loc_2].resultGeometries[_loc_4];
                                        arrAddsUpdates.push({feature:Graphic(arr[_loc_2].feature), featureLayer:Graphic(arr[_loc_2].feature).graphicsLayer, update:true});
                                        _loc_3 = false;
                                    }
                                    else
                                    {
                                        arrAddsUpdates.push({feature:new Graphic(arr[_loc_2].resultGeometries[_loc_4], null, ObjectUtil.copy(Graphic(arr[_loc_2].feature).attributes)), featureLayer:Graphic(arr[_loc_2].feature).graphicsLayer, update:false});
                                    }
                                }
                                _loc_4 = _loc_4 + 1;
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                        return;
                    }// end function
                    ;
                        var cut_applyEditsResult:* = function (featureEditResults:FeatureEditResults, token:Object = null) : void
                    {
                        var _loc_4:* = applyEditsResultCount + 1;
                        applyEditsResultCount = _loc_4;
                        featureEditResultsArray.push({featureEditResults:featureEditResults, featureLayer:token});
                        cutApplyEditsComplete();
                        return;
                    }// end function
                    ;
                        var cut_applyEditsFault:* = function (fault:Fault, token:Object = null) : void
                    {
                        applyEditsFault = true;
                        var _loc_4:* = applyEditsResultCount + 1;
                        applyEditsResultCount = _loc_4;
                        cutApplyEditsComplete();
                        return;
                    }// end function
                    ;
                        var cutApplyEditsComplete:* = function () : void
                    {
                        var _loc_1:Number = NaN;
                        var _loc_2:Number = NaN;
                        var _loc_3:Number = NaN;
                        if (applyEditsResultCount == arrAddsUpdates.length)
                        {
                            m_cutInProgress = false;
                            cutButton.selected = false;
                            if (!applyEditsFault)
                            {
                                m_query = new Query();
                                operationCompleteLabel.text = m_cutQueryFeatureArray.length == 1 ? (SPLIT_FEATURE_OPERATION_COMPLETE) : (SPLIT_FEATURES_OPERATION_COMPLETE);
                                _loc_1 = 0;
                                while (_loc_1 < featureEditResultsArray.length)
                                {
                                    
                                    if (featureEditResultsArray[_loc_1].featureEditResults.addResults.length > 0)
                                    {
                                        _loc_2 = 0;
                                        while (_loc_2 < featureEditResultsArray[_loc_1].featureEditResults.addResults.length)
                                        {
                                            
                                            if (featureEditResultsArray[_loc_1].featureEditResults.addResults[_loc_2].success)
                                            {
                                                m_query.objectIds = [featureEditResultsArray[_loc_1].featureEditResults.addResults[_loc_2].objectId];
                                                FeatureLayer(featureEditResultsArray[_loc_1].featureLayer).selectFeatures(m_query, FeatureLayer.SELECTION_ADD);
                                                _loc_2 = _loc_2 + 1;
                                                continue;
                                            }
                                            operationCompleteLabel.text = m_cutQueryFeatureArray.length == 1 ? (SPLIT_FEATURE_OPERATION_FAILED) : (SPLIT_FEATURES_OPERATION_FAILED);
                                            break;
                                        }
                                    }
                                    if (featureEditResultsArray[_loc_1].featureEditResults.updateResults.length > 0)
                                    {
                                        _loc_3 = 0;
                                        while (_loc_3 < featureEditResultsArray[_loc_1].featureEditResults.updateResults.length)
                                        {
                                            
                                            if (featureEditResultsArray[_loc_1].featureEditResults.updateResults[_loc_3].success)
                                            {
                                                _loc_3 = _loc_3 + 1;
                                                continue;
                                            }
                                            operationCompleteLabel.text = m_cutQueryFeatureArray.length == 1 ? (SPLIT_FEATURE_OPERATION_FAILED) : (SPLIT_FEATURES_OPERATION_FAILED);
                                            break;
                                        }
                                    }
                                    if (operationCompleteLabel.text != SPLIT_FEATURE_OPERATION_FAILED)
                                    {
                                    }
                                    if (operationCompleteLabel.text == SPLIT_FEATURES_OPERATION_FAILED)
                                    {
                                        break;
                                        continue;
                                    }
                                    _loc_1 = _loc_1 + 1;
                                }
                            }
                            else
                            {
                                operationCompleteLabel.text = m_cutQueryFeatureArray.length == 1 ? (SPLIT_FEATURE_OPERATION_FAILED) : (SPLIT_FEATURES_OPERATION_FAILED);
                            }
                            m_applyingEdits = false;
                            invalidateSkinState();
                            operationCompleteLabel.includeInLayout = true;
                            operationCompleteLabel.visible = true;
                            operationCompleteLabel.visible = false;
                        }
                        return;
                    }// end function
                    ;
                        if (m_polylinePolygonCutResultArray.length == 2)
                        {
                            polylineFeaturesArray;
                            polygonFeaturesArray;
                            i;
                            while (i < featuresArray.length)
                            {
                                
                                if (Graphic(featuresArray[i].feature).geometry.type == Geometry.POLYLINE)
                                {
                                    polylineFeaturesArray.push({feature:featuresArray[i].feature, resultGeometries:featuresArray[i].resultGeometries, cutIndexes:featuresArray[i].cutIndexes});
                                }
                                else if (Graphic(featuresArray[i].feature).geometry.type == Geometry.POLYGON)
                                {
                                    polygonFeaturesArray.push({feature:featuresArray[i].feature, resultGeometries:featuresArray[i].resultGeometries, cutIndexes:featuresArray[i].cutIndexes});
                                }
                                i = (i + 1);
                            }
                            new activation.addUpdateFeatures(polylineFeaturesArray);
                            new activation.addUpdateFeatures(polygonFeaturesArray);
                        }
                        else
                        {
                            new activation.addUpdateFeatures(featuresArray);
                        }
                        m_undoCutUpdateDeletesArray = arrAddsUpdates;
                        cutOperation = new CutOperation(m_undoCutGeometryArray, m_redoCutGeometryArray, arrAddsUpdates);
                        m_undoManager.pushUndo(cutOperation);
                        callLater(updateUndoRedoButtons);
                        m_query = new Query();
                        featureEditResultsArray;
                        applyEditsResultCount;
                        k;
                        while (k < arrAddsUpdates.length)
                        {
                            
                            m_query.geometry = Graphic(arrAddsUpdates[k].feature).geometry;
                            if (arrAddsUpdates[k].update)
                            {
                                FeatureLayer(arrAddsUpdates[k].featureLayer).applyEdits(null, [arrAddsUpdates[k].feature], null, false, new AsyncResponder(cut_applyEditsResult, cut_applyEditsFault, arrAddsUpdates[k].featureLayer));
                            }
                            else
                            {
                                FeatureLayer(arrAddsUpdates[k].featureLayer).applyEdits([arrAddsUpdates[k].feature], null, null, false, new AsyncResponder(cut_applyEditsResult, cut_applyEditsFault, arrAddsUpdates[k].featureLayer));
                            }
                            k = (k + 1);
                        }
                        if (!m_applyingEdits)
                        {
                            m_applyingEdits = true;
                            invalidateSkinState();
                        }
                    }
                    return;
                }// end function
                ;
                    var cut_selectFault:* = function (fault:Fault, token:Object = null) : void
                {
                    m_cutInProgress = false;
                    cutButton.selected = false;
                    return;
                }// end function
                ;
                    operationStartLabel.text = m_cutQueryFeatureArray.length == 1 ? (SPLIT_FEATURE_OPERATION_START) : (SPLIT_FEATURES_OPERATION_START);
                    arrCutFeatures;
                    arrAddsUpdates;
                    a;
                    while (a < m_polylinePolygonCutResultArray.length)
                    {
                        
                        b;
                        while (b < m_polylinePolygonCutResultArray[a].featureArray.length)
                        {
                            
                            arrCutFeatures.push({featureObject:m_polylinePolygonCutResultArray[a].featureArray[b], result:m_polylinePolygonCutResultArray[a].result});
                            b = (b + 1);
                        }
                        a = (a + 1);
                    }
                    featuresArray;
                    c;
                    while (c < arrCutFeatures.length)
                    {
                        
                        if (arrCutFeatures[c].result.geometries)
                        {
                        }
                        if (arrCutFeatures[c].result.cutIndexes)
                        {
                            m_query = new Query();
                            m_query.objectIds = [arrCutFeatures[c].featureObject.feature.attributes[arrCutFeatures[c].featureObject.featureLayer.layerDetails.objectIdField]];
                            FeatureLayer(arrCutFeatures[c].featureObject.featureLayer).selectFeatures(m_query, FeatureLayer.SELECTION_ADD, new AsyncResponder(cut_selectResult, cut_selectFault, {resultGeometries:arrCutFeatures[c].result.geometries, cutIndexes:arrCutFeatures[c].result.cutIndexes}));
                        }
                        c = (c + 1);
                    }
                }
                return;
            }// end function
            ;
                        this.m_query = new Query();
                        this.m_query.geometry = Polyline(event.graphic.geometry);
                        this.m_isEdit = false;
                        this.m_drawTool.deactivate();
                        featureSetArray;
                        polygonPolylineFeatureLayerCount;
                        queryResultCount;
                        cutRequestCount;
                        p;
                        while (p < this.m_featureLayers.length)
                        {
                            
                            if (FeatureLayer(this.m_featureLayers[p]).visible)
                            {
                            }
                            if (!FeatureLayer(this.m_featureLayers[p]).isInScaleRange)
                            {
                            }
                            if (FeatureLayer(this.m_featureLayers[p]).layerDetails.geometryType != Geometry.POLYGON)
                            {
                            }
                            if (FeatureLayer(this.m_featureLayers[p]).layerDetails.geometryType == Geometry.POLYLINE)
                            {
                                polygonPolylineFeatureLayerCount = (polygonPolylineFeatureLayerCount + 1);
                                FeatureLayer(this.m_featureLayers[p]).queryFeatures(this.m_query, new AsyncResponder(query_resultHandler, query_faultHandler, this.m_featureLayers[p]));
                            }
                            p = (p + 1);
                        }
                    }
                    else
                    {
                        if (event.graphic.geometry.type == Geometry.POLYLINE)
                        {
                        }
                        if (this.m_reshapeInProgress)
                        {
                            var reshape_queryResultHandler:* = function (objectIds:Array, token:Object = null) : void
            {
                var selectedGraphicPartOfIntersect:Boolean;
                var n:Number;
                var fault:Fault;
                var objectIds:* = objectIds;
                var token:* = token;
                if (objectIds.length > 0)
                {
                    n;
                    while (n < objectIds.length)
                    {
                        
                        if (token.attributes[FeatureLayer(token.graphicsLayer).layerDetails.objectIdField] === objectIds[n])
                        {
                            selectedGraphicPartOfIntersect;
                            break;
                        }
                        n = (n + 1);
                    }
                    if (selectedGraphicPartOfIntersect)
                    {
                        var geometryServiceReshape:* = function (geometryService:GeometryService) : void
                {
                    var _loc_2:* = token.geometry;
                    m_undoReshapeGraphicGeometry = _loc_2;
                    _loc_2.spatialReference = !_loc_2.spatialReference ? (spatialReference) : (_loc_2.spatialReference);
                    geometryService.reshape(_loc_2, Polyline(event.graphic.geometry), new AsyncResponder(reshape_resultHandler, reshape_faultHandler, token));
                    return;
                }// end function
                ;
                        if (m_geometryService)
                        {
                            new activation.geometryServiceReshape(m_geometryService);
                        }
                        else if (GeometryServiceSingleton.instance.url)
                        {
                            new activation.geometryServiceReshape(GeometryServiceSingleton.instance);
                        }
                        else
                        {
                            fault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.GEOMETRYSERVICE_REQUIRED));
                            dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                        }
                    }
                    else
                    {
                        m_reshapeInProgress = false;
                        reshapeButton.selected = false;
                        m_drawTool.deactivate();
                    }
                }
                return;
            }// end function
            ;
                            reshape_resultHandler = function (result:Object, token:Object = null) : void
            {
                var feature:Graphic;
                var result:* = result;
                var token:* = token;
                var reshape_applyEditsResult:* = function (featureEditResults:FeatureEditResults) : void
                {
                    var _loc_2:ReshapeOperation = null;
                    if (featureEditResults.updateResults[0].success)
                    {
                        _loc_2 = new ReshapeOperation(feature, FeatureLayer(feature.graphicsLayer), m_undoReshapeGraphicGeometry, m_redoReshapeGraphicGeometry);
                        m_undoManager.pushUndo(_loc_2);
                        callLater(updateUndoRedoButtons);
                    }
                    m_editGraphic = feature;
                    return;
                }// end function
                ;
                var reshape_applyEditsFault:* = function (fault:Fault) : void
                {
                    return;
                }// end function
                ;
                m_lastUpdateOperation = "reshape geometry";
                operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                m_reshapeInProgress = false;
                reshapeButton.selected = false;
                m_drawTool.deactivate();
                feature = token as Graphic;
                var featureLayer:* = feature.graphicsLayer as FeatureLayer;
                m_redoReshapeGraphicGeometry = result as Geometry;
                feature.geometry = result as Geometry;
                featureLayer.applyEdits(null, [feature], null, false, new Responder(reshape_applyEditsResult, reshape_applyEditsFault));
                if (!m_applyingEdits)
                {
                    m_applyingEdits = true;
                    invalidateSkinState();
                }
                return;
            }// end function
            ;
                            reshape_faultHandler = function (fault:Fault, token:Object = null) : void
            {
                m_reshapeInProgress = false;
                reshapeButton.selected = false;
                m_drawTool.deactivate();
                dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                return;
            }// end function
            ;
                            var reshape_queryFaultHandler:* = function (fault:Fault, tokern:Object = null) : void
            {
                return;
            }// end function
            ;
                            this.m_query = new Query();
                            this.m_query.geometry = Polyline(event.graphic.geometry);
                            reshapeSelectedFeaturesArray;
                            r;
                            while (r < this.m_featureLayers.length)
                            {
                                
                                if (FeatureLayer(this.m_featureLayers[r]).layerDetails.geometryType != Geometry.POLYGON)
                                {
                                }
                                if (FeatureLayer(this.m_featureLayers[r]).layerDetails.geometryType == Geometry.POLYLINE)
                                {
                                    reshapeSelectedFeaturesArray.push(FeatureLayer(this.m_featureLayers[r]).selectedFeatures);
                                }
                                r = (r + 1);
                            }
                            featureArray;
                            k;
                            while (k < reshapeSelectedFeaturesArray.length)
                            {
                                
                                var _loc_3:int = 0;
                                var _loc_4:* = reshapeSelectedFeaturesArray[k];
                                while (_loc_4 in _loc_3)
                                {
                                    
                                    reshapeFeature = _loc_4[_loc_3];
                                    featureArray.push(reshapeFeature);
                                }
                                k = (k + 1);
                            }
                            if (featureArray)
                            {
                            }
                            if (featureArray.length == 1)
                            {
                                FeatureLayer(Graphic(featureArray[0]).graphicsLayer).queryIds(this.m_query, new AsyncResponder(reshape_queryResultHandler, reshape_queryFaultHandler, featureArray[0]));
                            }
                            else
                            {
                                this.m_reshapeInProgress = false;
                                this.reshapeButton.selected = false;
                                this.m_drawTool.deactivate();
                            }
                        }
                        else
                        {
                            this.m_newFeatureCreated = true;
                            nGraphic = this.templatePicker.selectedTemplate.featureTemplate ? (new Graphic(event.graphic.geometry, null, ObjectUtil.copy(this.templatePicker.selectedTemplate.featureTemplate.prototype.attributes))) : (new Graphic(event.graphic.geometry));
                            this.createApplyEdits(nGraphic);
                        }
                    }
                }
            }
            return;
        }// end function

        private function createApplyEdits(graphic:Graphic) : void
        {
            this.m_featureCreated = true;
            this.m_lastCreatedGraphic = graphic;
            this.m_tempNewFeature = graphic;
            this.m_tempNewFeatureLayer = this.templatePicker.selectedTemplate.featureLayer;
            this.setSelectionFilter(this.m_tempNewFeature, this.m_tempNewFeatureLayer.selectionColor);
            this.m_tempNewFeature.symbol = this.templatePicker.selectedTemplate.symbol;
            this.map.defaultGraphicsLayer.add(this.m_tempNewFeature);
            this.m_attributeInspector.showFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
            this.showAttributeInspector(this.m_tempNewFeature);
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.m_editTool.activate(EditTool.MOVE | EditTool.EDIT_VERTICES, [this.m_tempNewFeature]);
            this.addEditToolEventListeners();
            this.templatePicker.clearSelection();
            this.m_drawTool.deactivate();
            if (this.m_toolbarVisible)
            {
                this.deleteButton.enabled = true;
            }
            return;
        }// end function

        private function addNewFeature(graphic:Graphic, featureLayer:FeatureLayer) : void
        {
            var _loc_6:String = null;
            var _loc_7:Object = null;
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.map.infoWindow.hide();
            this.attributeInspector.activeFeatureIndex = -1;
            this.attributeInspector.refresh();
            var _loc_3:* = featureLayer.editFieldsInfo;
            if (_loc_3)
            {
            }
            if (_loc_3.creatorField)
            {
            }
            if (featureLayer.userId)
            {
                _loc_6 = featureLayer.userId;
                graphic.attributes[_loc_3.creatorField] = _loc_3.realm ? (_loc_6 + "@" + _loc_3.realm) : (_loc_6);
            }
            if (_loc_3)
            {
            }
            if (_loc_3.creationDateField)
            {
                graphic.attributes[_loc_3.creationDateField] = new Date().getTime();
            }
            if (this.m_activeFeatureChangedAttributes.length)
            {
                for each (_loc_7 in this.m_activeFeatureChangedAttributes)
                {
                    
                    graphic.attributes[_loc_7.field.name] = _loc_7.newValue;
                }
            }
            var _loc_4:* = new Graphic(graphic.geometry, null, graphic.attributes);
            featureLayer.applyEdits([_loc_4], null, null);
            this.m_undoRedoAddDeleteOperation = false;
            var _loc_5:* = new AddOperation(_loc_4, featureLayer);
            this.m_undoManager.pushUndo(_loc_5);
            this.operationStartLabel.text = ADD_FEATURE_OPERATION_START;
            if (!this.m_applyingEdits)
            {
                this.m_applyingEdits = true;
                invalidateSkinState();
            }
            return;
        }// end function

        private function polygonToPolyline(polygon:Polygon) : Polyline
        {
            var _loc_3:Array = null;
            var _loc_2:* = new Polyline();
            for each (_loc_3 in polygon.rings)
            {
                
                _loc_2.addPath(_loc_3);
            }
            return _loc_2;
        }// end function

        private function deleteButton_clickHandler(event:MouseEvent) : void
        {
            var _loc_2:FeatureLayer = null;
            var _loc_3:Array = null;
            var _loc_4:Graphic = null;
            var _loc_5:DeleteOperation = null;
            if (this.m_tempNewFeature)
            {
                this.m_deletingTempGraphic = true;
                this.removeTempNewGraphic();
                this.map.infoWindow.hide();
            }
            else
            {
                this.m_featuresToBeDeleted = [];
                this.m_featureLayerDeleteResults = [];
                this.m_undoRedoAddDeleteOperation = false;
                for each (_loc_2 in this.m_featureLayers)
                {
                    
                    if (_loc_2.selectedFeatures.length > 0)
                    {
                    }
                    if (this.checkIfDeleteIsAllowed(_loc_2))
                    {
                        _loc_3 = [];
                        for each (_loc_4 in _loc_2.selectedFeatures)
                        {
                            
                            if (_loc_2.isDeleteAllowed(_loc_4))
                            {
                                _loc_3.push(_loc_4);
                            }
                        }
                        if (_loc_3.length)
                        {
                            this.m_featuresToBeDeleted.push({selectedFeatures:_loc_3, featureLayer:_loc_2});
                            _loc_2.applyEdits(null, null, _loc_3);
                        }
                    }
                }
                if (this.m_featuresToBeDeleted.length)
                {
                    this.cutReshapeButtonHandler();
                    _loc_5 = new DeleteOperation(this.m_featuresToBeDeleted);
                    this.m_undoManager.pushUndo(_loc_5);
                    callLater(this.updateUndoRedoButtons);
                    if (this.m_featuresToBeDeleted.length == 1)
                    {
                        if ((this.m_featuresToBeDeleted[0].selectedFeatures as Array).length == 1)
                        {
                            this.operationStartLabel.text = DELETE_FEATURE_OPERATION_START;
                        }
                        else
                        {
                            this.operationStartLabel.text = DELETE_FEATURES_OPERATION_START;
                        }
                    }
                    else
                    {
                        this.operationStartLabel.text = DELETE_FEATURES_OPERATION_START;
                    }
                    if (!this.m_applyingEdits)
                    {
                        this.m_applyingEdits = true;
                        invalidateSkinState();
                    }
                }
            }
            return;
        }// end function

        private function undoButton_clickHandler(event:MouseEvent) : void
        {
            this.performUndo();
            return;
        }// end function

        private function redoButton_clickHandler(event:MouseEvent) : void
        {
            this.performRedo();
            return;
        }// end function

        private function performUndo() : void
        {
            this.m_undoRedoInProgress = true;
            this.m_applyingEdits = true;
            invalidateSkinState();
            if (!(this.m_undoManager.peekUndo() is AddOperation))
            {
            }
            if (this.m_undoManager.peekUndo() is DeleteOperation)
            {
                if (this.m_undoManager.peekUndo() is AddOperation)
                {
                    this.m_undoAddOperation = true;
                    this.operationStartLabel.text = UNDO_ADD_FEATURE_OPERATION_START;
                }
                else
                {
                    this.m_countDeleteFeatureLayers = 0;
                    this.m_featureLayerAddResults = [];
                    if (this.m_featuresToBeDeleted.length == 1)
                    {
                        if ((this.m_featuresToBeDeleted[0].selectedFeatures as Array).length == 1)
                        {
                            this.operationStartLabel.text = UNDO_DELETE_FEATURE_OPERATION_START;
                        }
                        else
                        {
                            this.operationStartLabel.text = UNDO_DELETE_FEATURES_OPERATION_START;
                        }
                    }
                    else
                    {
                        this.operationStartLabel.text = UNDO_DELETE_FEATURES_OPERATION_START;
                    }
                }
                this.m_undoRedoAddDeleteOperation = true;
                this.m_isEdit = false;
            }
            if (this.m_undoManager.peekUndo() is EditGeometryOperation)
            {
                this.m_lastUpdateOperation = "undo edit geometry";
                this.operationStartLabel.text = UNDO_UPDATE_FEATURE_OPERATION_START;
                if (EditGeometryOperation(this.m_undoManager.peekUndo()).feature === this.m_editGraphic)
                {
                }
                if (!this.m_undoRedoAddDeleteOperation)
                {
                }
                if (!this.m_undoRedoReshapeOperation)
                {
                }
                if (!this.m_undoRedoMergeOperation)
                {
                }
                if (!this.m_undoRedoCutOperation)
                {
                    this.map.infoWindow.hide();
                    EditGeometryOperation(this.m_undoManager.peekUndo()).restoreEditTool = true;
                }
                else
                {
                    EditGeometryOperation(this.m_undoManager.peekUndo()).restoreEditTool = false;
                }
            }
            if (this.m_undoManager.peekUndo() is EditAttributesOperation)
            {
            }
            if (!this.m_undoRedoReshapeOperation)
            {
            }
            if (!this.m_undoRedoMergeOperation)
            {
            }
            if (!this.m_undoRedoCutOperation)
            {
                this.m_lastUpdateOperation = "undo edit attribute";
                this.operationStartLabel.text = UNDO_UPDATE_FEATURE_OPERATION_START;
                if (EditAttributesOperation(this.m_undoManager.peekUndo()).feature === this.m_editGraphic)
                {
                    EditAttributesOperation(this.m_undoManager.peekUndo()).restoreAttributeInspector = true;
                }
                else
                {
                    EditAttributesOperation(this.m_undoManager.peekUndo()).restoreAttributeInspector = false;
                }
            }
            if (this.m_undoManager.peekUndo() is ReshapeOperation)
            {
                this.m_lastUpdateOperation = "undo reshape geometry";
                this.operationStartLabel.text = UNDO_UPDATE_FEATURE_OPERATION_START;
            }
            if (this.m_undoManager.peekUndo() is CutOperation)
            {
                this.m_lastUpdateOperation = "undo split geometry";
                this.m_arrUndoCutOperation = [];
                this.operationStartLabel.text = this.m_cutQueryFeatureArray.length == 1 ? (UNDO_SPLIT_FEATURE_OPERATION_START) : (UNDO_SPLIT_FEATURES_OPERATION_START);
            }
            if (this.m_undoManager.peekUndo() is MergeOperation)
            {
                this.m_lastUpdateOperation = "undo merge geometry";
                this.m_arrUndoRedoMergeOperation = [];
                this.operationStartLabel.text = UNDO_MERGE_FEATURES_OPERATION_START;
            }
            var _loc_1:* = this.m_undoManager.peekUndo();
            this.m_undoManager.undo();
            this.m_undoManager.pushRedo(_loc_1);
            if (this.m_toolbarVisible)
            {
                this.setButtonStates();
            }
            return;
        }// end function

        private function performRedo() : void
        {
            this.m_undoRedoInProgress = true;
            this.m_applyingEdits = true;
            invalidateSkinState();
            if (!(this.m_undoManager.peekRedo() is AddOperation))
            {
            }
            if (this.m_undoManager.peekRedo() is DeleteOperation)
            {
                if (this.m_undoManager.peekRedo() is AddOperation)
                {
                    this.m_redoAddOperation = true;
                    this.operationStartLabel.text = REDO_ADD_FEATURE_OPERATION_START;
                }
                else
                {
                    this.m_countDeleteFeatureLayers = 0;
                    this.m_featureLayerDeleteResults = [];
                    if (this.m_featuresToBeDeleted.length == 1)
                    {
                        if ((this.m_featuresToBeDeleted[0].selectedFeatures as Array).length == 1)
                        {
                            this.operationStartLabel.text = REDO_DELETE_FEATURE_OPERATION_START;
                        }
                        else
                        {
                            this.operationStartLabel.text = REDO_DELETE_FEATURES_OPERATION_START;
                        }
                    }
                    else
                    {
                        this.operationStartLabel.text = REDO_DELETE_FEATURES_OPERATION_START;
                    }
                }
                this.m_undoRedoAddDeleteOperation = true;
                this.m_isEdit = false;
            }
            if (this.m_undoManager.peekRedo() is EditGeometryOperation)
            {
                this.m_lastUpdateOperation = "redo edit geometry";
                this.operationStartLabel.text = REDO_UPDATE_FEATURE_OPERATION_START;
                if (EditGeometryOperation(this.m_undoManager.peekRedo()).feature === this.m_editGraphic)
                {
                }
                if (!this.m_undoRedoAddDeleteOperation)
                {
                }
                if (!this.m_undoRedoReshapeOperation)
                {
                }
                if (!this.m_undoRedoMergeOperation)
                {
                }
                if (!this.m_undoRedoCutOperation)
                {
                    this.map.infoWindow.hide();
                    EditGeometryOperation(this.m_undoManager.peekRedo()).restoreEditTool = true;
                }
                else
                {
                    EditGeometryOperation(this.m_undoManager.peekRedo()).restoreEditTool = false;
                }
            }
            if (this.m_undoManager.peekRedo() is EditAttributesOperation)
            {
                this.m_lastUpdateOperation = "redo edit attribute";
                this.operationStartLabel.text = REDO_UPDATE_FEATURE_OPERATION_START;
                if (EditAttributesOperation(this.m_undoManager.peekRedo()).feature === this.m_editGraphic)
                {
                }
                if (!this.m_undoRedoReshapeOperation)
                {
                }
                if (!this.m_undoRedoMergeOperation)
                {
                }
                if (!this.m_undoRedoCutOperation)
                {
                    EditAttributesOperation(this.m_undoManager.peekRedo()).restoreAttributeInspector = true;
                }
                else
                {
                    EditAttributesOperation(this.m_undoManager.peekRedo()).restoreAttributeInspector = false;
                }
            }
            if (this.m_undoManager.peekRedo() is ReshapeOperation)
            {
                this.m_lastUpdateOperation = "redo reshape geometry";
                this.operationStartLabel.text = REDO_UPDATE_FEATURE_OPERATION_START;
            }
            if (this.m_undoManager.peekRedo() is CutOperation)
            {
                this.m_lastUpdateOperation = "redo split geometry";
                this.m_arrUndoCutOperation = [];
                this.operationStartLabel.text = this.m_cutQueryFeatureArray.length == 1 ? (REDO_SPLIT_FEATURE_OPERATION_START) : (REDO_SPLIT_FEATURES_OPERATION_START);
            }
            if (this.m_undoManager.peekRedo() is MergeOperation)
            {
                this.m_lastUpdateOperation = "redo merge geometry";
                this.m_arrUndoRedoMergeOperation = [];
                this.operationStartLabel.text = REDO_MERGE_FEATURES_OPERATION_START;
            }
            var _loc_1:* = this.m_undoManager.peekRedo();
            this.m_undoManager.redo();
            this.m_undoManager.pushUndo(_loc_1);
            if (this.m_toolbarVisible)
            {
                this.setButtonStates();
            }
            return;
        }// end function

        private function setButtonStates() : void
        {
            if (this.undoButton)
            {
            }
            if (this.redoButton)
            {
                this.undoButton.enabled = this.m_undoManager.canUndo();
                this.redoButton.enabled = this.m_undoManager.canRedo();
            }
            return;
        }// end function

        private function cutButton_changeHandler(event:Event) : void
        {
            this.m_cutInProgress = false;
            this.m_creationInProgress = false;
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.m_drawTool.deactivate();
            this.m_undoCutGeometryArray = [];
            this.m_redoCutGeometryArray = [];
            if (this.cutButton.selected)
            {
                this.m_undoRedoCutOperation = true;
                this.m_mergeInProgress = false;
                this.m_reshapeInProgress = false;
                this.reshapeButton.selected = false;
                this.m_cutInProgress = true;
                if (this.map)
                {
                    this.map.infoWindow.hide();
                }
                this.m_drawTool.activate(DrawTool.POLYLINE);
                this.m_drawTool.lineSymbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 1, 1);
                this.m_creationInProgress = true;
            }
            return;
        }// end function

        private function mergeButton_clickHandler(event:MouseEvent) : void
        {
            var selectedFeaturesArray:Array;
            var spatialReference:SpatialReference;
            var featureArray:Array;
            var feature:Graphic;
            var merge_resultHandler:Function;
            var merge_faultHandler:Function;
            var fault:Fault;
            var event:* = event;
            this.m_reshapeInProgress = false;
            this.reshapeButton.selected = false;
            this.m_cutInProgress = false;
            this.cutButton.selected = false;
            this.cutReshapeButtonHandler();
            this.m_mergeInProgress = true;
            this.m_undoRedoMergeOperation = true;
            selectedFeaturesArray;
            spatialReference = FeatureLayer(this.m_featureLayers[0]).map.spatialReference;
            var i:Number;
            while (i < this.m_featureLayers.length)
            {
                
                if (FeatureLayer(this.m_featureLayers[i]).layerDetails.geometryType == Geometry.POLYGON)
                {
                }
                if (FeatureLayer(this.m_featureLayers[i]).selectedFeatures.length > 1)
                {
                    selectedFeaturesArray.push({featureLayer:FeatureLayer(this.m_featureLayers[i]), selectedFeatures:FeatureLayer(this.m_featureLayers[i]).selectedFeatures});
                }
                i = (i + 1);
            }
            featureArray;
            var k:Number;
            while (k < selectedFeaturesArray.length)
            {
                
                var _loc_3:int = 0;
                var _loc_4:* = selectedFeaturesArray[k].selectedFeatures;
                while (_loc_4 in _loc_3)
                {
                    
                    feature = _loc_4[_loc_3];
                    featureArray.push(feature);
                }
                k = (k + 1);
            }
            if (featureArray)
            {
            }
            if (featureArray.length == 1)
            {
                this.m_mergeInProgress = false;
            }
            else
            {
                if (featureArray)
                {
                }
                if (featureArray.length > 1)
                {
                    var geometryServiceUnion:* = function (geometryService:GeometryService) : void
            {
                m_editTool.deactivate();
                removeEditToolEventListeners();
                if (map)
                {
                    map.infoWindow.hide();
                }
                var _loc_2:Array = [];
                var _loc_3:Number = 0;
                while (_loc_3 < featureArray.length)
                {
                    
                    if (!Graphic(featureArray[_loc_3]).geometry.spatialReference)
                    {
                        Graphic(featureArray[_loc_3]).geometry.spatialReference = spatialReference;
                    }
                    _loc_2.push(Graphic(featureArray[_loc_3]).geometry);
                    _loc_3 = _loc_3 + 1;
                }
                geometryService.union(_loc_2, new AsyncResponder(merge_resultHandler, merge_faultHandler, featureArray));
                return;
            }// end function
            ;
                    merge_resultHandler = function (result:Object, token:Object = null) : void
            {
                var featureEditResultsArray:Array;
                var applyEditsResultCount:int;
                var applyEditsFault:Boolean;
                var merge_applyEditsResult:Function;
                var merge_applyEditsFault:Function;
                var i:Number;
                var result:* = result;
                var token:* = token;
                merge_applyEditsResult = function (featureEditResults:FeatureEditResults, token:Object = null) : void
                {
                    var _loc_4:* = applyEditsResultCount + 1;
                    applyEditsResultCount = _loc_4;
                    featureEditResultsArray.push({featureEditResults:featureEditResults, featureLayer:token});
                    mergeApplyEditsComplete();
                    return;
                }// end function
                ;
                merge_applyEditsFault = function (fault:Fault, token:Object = null) : void
                {
                    applyEditsFault = true;
                    var _loc_4:* = applyEditsResultCount + 1;
                    applyEditsResultCount = _loc_4;
                    mergeApplyEditsComplete();
                    return;
                }// end function
                ;
                var mergeApplyEditsComplete:* = function () : void
                {
                    var _loc_1:Number = NaN;
                    var _loc_2:Number = NaN;
                    var _loc_3:Number = NaN;
                    if (applyEditsResultCount == selectedFeaturesArray.length)
                    {
                        m_mergeInProgress = false;
                        m_isEdit = false;
                        if (!applyEditsFault)
                        {
                            m_query = new Query();
                            operationCompleteLabel.text = MERGE_FEATURES_OPERATION_COMPLETE;
                            _loc_1 = 0;
                            while (_loc_1 < featureEditResultsArray.length)
                            {
                                
                                if (featureEditResultsArray[_loc_1].featureEditResults.addResults.length > 0)
                                {
                                    _loc_2 = 0;
                                    while (_loc_2 < featureEditResultsArray[_loc_1].featureEditResults.addResults.length)
                                    {
                                        
                                        if (featureEditResultsArray[_loc_1].featureEditResults.addResults[_loc_2].success)
                                        {
                                            m_query.objectIds = [featureEditResultsArray[_loc_1].featureEditResults.addResults[_loc_2].objectId];
                                            FeatureLayer(featureEditResultsArray[_loc_1].featureLayer).selectFeatures(m_query, FeatureLayer.SELECTION_ADD);
                                            _loc_2 = _loc_2 + 1;
                                            continue;
                                        }
                                        operationCompleteLabel.text = MERGE_FEATURES_OPERATION_FAILED;
                                        break;
                                    }
                                }
                                if (featureEditResultsArray[_loc_1].featureEditResults.deleteResults.length > 0)
                                {
                                    _loc_3 = 0;
                                    while (_loc_3 < featureEditResultsArray[_loc_1].featureEditResults.deleteResults.length)
                                    {
                                        
                                        if (featureEditResultsArray[_loc_1].featureEditResults.deleteResults[_loc_3].success)
                                        {
                                            _loc_3 = _loc_3 + 1;
                                            continue;
                                        }
                                        operationCompleteLabel.text = MERGE_FEATURES_OPERATION_FAILED;
                                        break;
                                    }
                                }
                                if (operationCompleteLabel.text == MERGE_FEATURES_OPERATION_FAILED)
                                {
                                    break;
                                    continue;
                                }
                                _loc_1 = _loc_1 + 1;
                            }
                        }
                        else
                        {
                            operationCompleteLabel.text = MERGE_FEATURES_OPERATION_FAILED;
                        }
                        m_applyingEdits = false;
                        invalidateSkinState();
                        operationCompleteLabel.includeInLayout = true;
                        operationCompleteLabel.visible = true;
                        operationCompleteLabel.visible = false;
                    }
                    return;
                }// end function
                ;
                var adds:Array;
                var mergeOperation:* = new MergeOperation(adds, token as Array, FeatureLayer(Graphic(token[0]).graphicsLayer), selectedFeaturesArray);
                m_undoManager.pushUndo(mergeOperation);
                callLater(updateUndoRedoButtons);
                operationStartLabel.text = MERGE_FEATURES_OPERATION_START;
                featureEditResultsArray;
                applyEditsResultCount;
                m_undoRedoMergeAddsDeletesArray = selectedFeaturesArray;
                if (selectedFeaturesArray.length == 1)
                {
                    FeatureLayer(Graphic(token[0]).graphicsLayer).applyEdits(adds, null, token as Array, true, new AsyncResponder(merge_applyEditsResult, merge_applyEditsFault, Graphic(token[0]).graphicsLayer));
                }
                else
                {
                    FeatureLayer(Graphic(token[0]).graphicsLayer).applyEdits(adds, null, null, false, new AsyncResponder(merge_applyEditsResult, merge_applyEditsFault, Graphic(token[0]).graphicsLayer));
                    i;
                    while (i < selectedFeaturesArray.length)
                    {
                        
                        FeatureLayer(selectedFeaturesArray[i].featureLayer).applyEdits(null, null, selectedFeaturesArray[i].selectedFeatures as Array, true, new AsyncResponder(merge_applyEditsResult, merge_applyEditsFault, Graphic(token[i]).graphicsLayer));
                        i = (i + 1);
                    }
                }
                if (!m_applyingEdits)
                {
                    m_applyingEdits = true;
                    invalidateSkinState();
                }
                return;
            }// end function
            ;
                    merge_faultHandler = function (fault:Fault, token:Object = null) : void
            {
                m_mergeInProgress = false;
                return;
            }// end function
            ;
                    if (this.m_geometryService)
                    {
                        this.geometryServiceUnion(this.m_geometryService);
                    }
                    else if (GeometryServiceSingleton.instance.url)
                    {
                        this.geometryServiceUnion(GeometryServiceSingleton.instance);
                    }
                    else
                    {
                        this.m_mergeInProgress = false;
                        fault = new Fault(null, ESRIMessageCodes.formatMessage(ESRIMessageCodes.GEOMETRYSERVICE_REQUIRED));
                        dispatchEvent(new FaultEvent(FaultEvent.FAULT, true, false, fault));
                    }
                }
            }
            return;
        }// end function

        private function reshapeButton_changeHandler(event:Event) : void
        {
            this.m_reshapeInProgress = false;
            this.m_creationInProgress = false;
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.m_drawTool.deactivate();
            if (this.reshapeButton.selected)
            {
                this.m_undoRedoReshapeOperation = true;
                this.m_mergeInProgress = false;
                this.m_cutInProgress = false;
                this.cutButton.selected = false;
                this.m_reshapeInProgress = true;
                if (this.map)
                {
                    this.map.infoWindow.hide();
                }
                this.m_drawTool.activate(DrawTool.POLYLINE);
                this.m_drawTool.lineSymbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0, 1, 1);
                this.m_creationInProgress = true;
            }
            return;
        }// end function

        private function key_downHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ESCAPE)
            {
                if (this.m_drawStart)
                {
                }
                if (this.m_templateSelected)
                {
                    this.m_graphicRemoved = true;
                    this.m_drawTool.removeGraphic(this.m_currentlyDrawnGraphic);
                    this.templatePicker.clearSelection();
                }
                else if (!this.m_graphicEditing)
                {
                    this.m_doNotApplyEdits = true;
                    this.m_editGraphic = null;
                    this.m_editTool.deactivate();
                    this.removeEditToolEventListeners();
                    if (this.map)
                    {
                        this.map.infoWindow.hide();
                    }
                    this.clearSelection();
                }
            }
            if (event.ctrlKey)
            {
            }
            if (event.keyCode == 90)
            {
            }
            if (!event.shiftKey)
            {
                if (!this.m_undoRedoInProgress)
                {
                }
                if (this.m_undoManager.canUndo())
                {
                    this.performUndo();
                }
            }
            if (event.ctrlKey)
            {
                if (event.keyCode != 89)
                {
                    if (event.shiftKey)
                    {
                    }
                }
            }
            if (event.keyCode == 90)
            {
                if (!this.m_undoRedoInProgress)
                {
                }
                if (this.m_undoManager.canRedo())
                {
                    this.performRedo();
                }
            }
            return;
        }// end function

        private function map_keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:FeatureLayer = null;
            var _loc_3:Array = null;
            var _loc_4:Graphic = null;
            var _loc_5:DeleteOperation = null;
            if (event.keyCode == Keyboard.DELETE)
            {
                if (this.m_tempNewFeature)
                {
                    this.m_deletingTempGraphic = true;
                    this.removeTempNewGraphic();
                    this.map.infoWindow.hide();
                }
                else if (this.m_deleteEnabled)
                {
                    this.m_featuresToBeDeleted = [];
                    this.m_featureLayerDeleteResults = [];
                    this.m_undoRedoAddDeleteOperation = false;
                    for each (_loc_2 in this.m_featureLayers)
                    {
                        
                        if (_loc_2.selectedFeatures.length > 0)
                        {
                        }
                        if (_loc_2.isDeleteAllowed)
                        {
                        }
                        if (!this.m_graphicEditing)
                        {
                            _loc_3 = [];
                            for each (_loc_4 in _loc_2.selectedFeatures)
                            {
                                
                                if (_loc_2.isDeleteAllowed(_loc_4))
                                {
                                    _loc_3.push(_loc_4);
                                }
                            }
                            if (_loc_3.length)
                            {
                                this.m_featuresToBeDeleted.push({selectedFeatures:_loc_3, featureLayer:_loc_2});
                                _loc_2.applyEdits(null, null, _loc_3);
                            }
                        }
                    }
                    if (this.m_featuresToBeDeleted.length)
                    {
                        _loc_5 = new DeleteOperation(this.m_featuresToBeDeleted);
                        this.m_undoManager.pushUndo(_loc_5);
                        callLater(this.updateUndoRedoButtons);
                        if (this.m_featuresToBeDeleted.length == 1)
                        {
                            if ((this.m_featuresToBeDeleted[0].selectedFeatures as Array).length == 1)
                            {
                                this.operationStartLabel.text = DELETE_FEATURE_OPERATION_START;
                            }
                            else
                            {
                                this.operationStartLabel.text = DELETE_FEATURES_OPERATION_START;
                            }
                        }
                        else
                        {
                            this.operationStartLabel.text = DELETE_FEATURES_OPERATION_START;
                        }
                        if (!this.m_applyingEdits)
                        {
                            this.m_applyingEdits = true;
                            invalidateSkinState();
                        }
                        if (this.map)
                        {
                            this.map.infoWindow.hide();
                        }
                    }
                }
            }
            return;
        }// end function

        private function map_mouseDownHandler(event:MapMouseEvent) : void
        {
            event.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            event.currentTarget.addEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            return;
        }// end function

        private function map_mouseMoveHandler(event:MouseEvent) : void
        {
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            return;
        }// end function

        private function map_mouseUpHandler(event:MouseEvent) : void
        {
            var g:Graphic;
            var featureLayerOfEditor:Boolean;
            var i:Number;
            var clickOnSameFeature:Boolean;
            var editGraphicPartOfSelecttion:Boolean;
            var editFeatureLayer:FeatureLayer;
            var featureLayer:FeatureLayer;
            var p:Number;
            var objectId:Number;
            var j:Number;
            var point:Point;
            var xmin:Number;
            var ymin:Number;
            var xmax:Number;
            var ymax:Number;
            var spatialReference:SpatialReference;
            var selectionExtent:Extent;
            var index:int;
            var event:* = event;
            this.m_attributeInspector.updateEnabled = this.updateAttributesEnabled;
            this.m_attributeInspector.deleteButtonVisible = this.deleteEnabled;
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
            this.m_editPoint = this.map.toMapFromStage(event.stageX, event.stageY);
            if (!this.m_creationInProgress)
            {
                this.m_undoRedoAddDeleteOperation = false;
                this.m_undoRedoCutOperation = false;
                this.m_undoRedoReshapeOperation = false;
                this.m_undoRedoMergeOperation = false;
                if (!(event.target is Graphic))
                {
                }
                if (!(event.target.parent is Graphic))
                {
                }
                if (event.target.parent.parent is Graphic)
                {
                    this.m_selectionMode = false;
                    g = event.target is Graphic ? (Graphic(event.target)) : (event.target.parent is Graphic ? (Graphic(event.target.parent)) : (Graphic(event.target.parent.parent)));
                    if (this.m_tempNewFeature)
                    {
                        if (g.symbol != this.m_editTool.ghostVertexSymbol)
                        {
                        }
                        if (g.symbol != this.m_editTool.vertexSymbol)
                        {
                            if (g !== this.m_tempNewFeature)
                            {
                                this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
                            }
                            else
                            {
                                if (!(this.m_tempNewFeature.geometry is Polyline))
                                {
                                }
                                if (this.m_tempNewFeature.geometry is Polygon)
                                {
                                    if (this.m_lastActiveTempEdit != null)
                                    {
                                    }
                                    if (this.m_lastActiveTempEdit == "")
                                    {
                                        this.m_lastActiveTempEdit = "moveEditVertices";
                                        this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_tempNewFeature]);
                                    }
                                    else if (this.m_lastActiveTempEdit == "moveEditVertices")
                                    {
                                        this.m_lastActiveTempEdit = "rotateShape";
                                        this.m_editTool.activate(EditTool.MOVE | EditTool.SCALE | EditTool.ROTATE, [this.m_tempNewFeature]);
                                    }
                                    else if (this.m_lastActiveTempEdit == "rotateShape")
                                    {
                                        this.m_lastActiveTempEdit = "moveEditVertices";
                                        this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_tempNewFeature]);
                                        this.map.infoWindow.show(this.m_editPoint);
                                    }
                                }
                                else
                                {
                                    this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_tempNewFeature]);
                                    this.map.infoWindow.show(this.m_editPoint);
                                }
                            }
                        }
                    }
                    i;
                    while (i < this.m_featureLayers.length)
                    {
                        
                        if (g.graphicsLayer === this.m_featureLayers[i])
                        {
                            featureLayerOfEditor;
                            break;
                        }
                        i = (i + 1);
                    }
                    if (featureLayerOfEditor)
                    {
                        if (g.symbol != this.m_editTool.ghostVertexSymbol)
                        {
                        }
                        if (g.symbol != this.m_editTool.vertexSymbol)
                        {
                            if (g.graphicsLayer)
                            {
                            }
                            if (g.graphicsLayer is FeatureLayer)
                            {
                            }
                            if (g.graphicsLayer.loaded)
                            {
                            }
                            if (FeatureLayer(g.graphicsLayer).isEditable)
                            {
                                this.m_isEdit = true;
                                this.m_doNotApplyEdits = false;
                                this.m_editClearSelection = false;
                                this.m_selectionMode = false;
                                if (this.m_editGraphic !== g)
                                {
                                    if (this.m_editGraphic)
                                    {
                                        this.saveUnsavedAttributes(this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer));
                                        this.m_attributesSaved = true;
                                    }
                                    this.m_editGraphic = g;
                                    var _loc_3:int = 0;
                                    var _loc_4:* = this.m_featureLayers;
                                    while (_loc_4 in _loc_3)
                                    {
                                        
                                        featureLayer = _loc_4[_loc_3];
                                        p;
                                        while (p < featureLayer.selectedFeatures.length)
                                        {
                                            
                                            if (this.m_editGraphic === featureLayer.selectedFeatures[p])
                                            {
                                                editGraphicPartOfSelecttion;
                                                break;
                                            }
                                            p = (p + 1);
                                        }
                                        if (editGraphicPartOfSelecttion)
                                        {
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    clickOnSameFeature;
                                    editGraphicPartOfSelecttion;
                                }
                                this.m_query = new Query();
                                this.m_query.objectIds = [this.m_editGraphic.attributes[FeatureLayer(this.m_editGraphic.graphicsLayer).layerDetails.objectIdField]];
                                editFeatureLayer = g.graphicsLayer as FeatureLayer;
                                if (event.ctrlKey)
                                {
                                    this.m_lastActiveEdit = "";
                                    if (!editGraphicPartOfSelecttion)
                                    {
                                        this.map.infoWindow.hide();
                                        this.m_editTool.deactivate();
                                        this.removeEditToolEventListeners();
                                        CursorManager.removeCursor(CursorManager.currentCursorID);
                                        editFeatureLayer.selectFeatures(this.m_query, FeatureLayer.SELECTION_ADD);
                                        this.m_editGraphic = null;
                                    }
                                    else
                                    {
                                        this.m_doNotApplyEdits = true;
                                        editFeatureLayer.selectFeatures(this.m_query, FeatureLayer.SELECTION_SUBTRACT);
                                    }
                                }
                                else if (editGraphicPartOfSelecttion)
                                {
                                    if (!clickOnSameFeature)
                                    {
                                        if (this.m_updateGeometryEnabled)
                                        {
                                        }
                                        if (this.checkIfGeometryUpdateIsAllowed(editFeatureLayer))
                                        {
                                            this.checkIfGeometryUpdateIsAllowed(editFeatureLayer);
                                        }
                                        if (editFeatureLayer.isUpdateAllowed(this.m_editGraphic))
                                        {
                                            this.m_editTool.deactivate();
                                            this.removeEditToolEventListeners();
                                            this.m_lastActiveEdit = "moveEditVertices";
                                            this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                                            this.addEditToolEventListeners();
                                        }
                                        this.updateAttributeInspector(editFeatureLayer, this.m_editGraphic);
                                        objectId = this.m_editGraphic.attributes[FeatureLayer(this.m_editGraphic.graphicsLayer).layerDetails.objectIdField];
                                        this.m_attributeInspector.activeFeatureIndex = 0;
                                        j;
                                        while (j < this.m_attributeInspector.numFeatures)
                                        {
                                            
                                            if (this.m_attributeInspector.activeFeature.attributes[FeatureLayer(this.m_editGraphic.graphicsLayer).layerDetails.objectIdField] == objectId)
                                            {
                                                break;
                                            }
                                            else
                                            {
                                                this.m_attributeInspector.next();
                                            }
                                            j = (j + 1);
                                        }
                                        this.map.infoWindow.show(this.m_editPoint);
                                        this.map.infoWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, this.infoWindowCloseButtonMouseDownHandler);
                                    }
                                    else
                                    {
                                        if (this.m_updateGeometryEnabled)
                                        {
                                        }
                                        if (this.checkIfGeometryUpdateIsAllowed(editFeatureLayer))
                                        {
                                            this.checkIfGeometryUpdateIsAllowed(editFeatureLayer);
                                        }
                                        if (editFeatureLayer.isUpdateAllowed(this.m_editGraphic))
                                        {
                                            this.m_editTool.deactivate();
                                            this.removeEditToolEventListeners();
                                            if (!(this.m_editGraphic.geometry is Polyline))
                                            {
                                            }
                                            if (this.m_editGraphic.geometry is Polygon)
                                            {
                                                if (this.m_lastActiveEdit != null)
                                                {
                                                }
                                                if (this.m_lastActiveEdit == "")
                                                {
                                                    this.m_lastActiveEdit = "moveEditVertices";
                                                    this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                                                }
                                                else if (this.m_lastActiveEdit == "moveEditVertices")
                                                {
                                                    this.m_lastActiveEdit = "rotateShape";
                                                    this.m_editTool.activate(EditTool.MOVE | EditTool.SCALE | EditTool.ROTATE, [this.m_editGraphic]);
                                                }
                                                else if (this.m_lastActiveEdit == "rotateShape")
                                                {
                                                    this.m_lastActiveEdit = "moveEditVertices";
                                                    this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                                                    this.updateAttributeInspector(editFeatureLayer, this.m_editGraphic);
                                                    this.map.infoWindow.show(this.m_editPoint);
                                                }
                                            }
                                            else
                                            {
                                                this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                                                this.updateAttributeInspector(editFeatureLayer, this.m_editGraphic);
                                                this.map.infoWindow.show(this.m_editPoint);
                                            }
                                            this.addEditToolEventListeners();
                                        }
                                        else
                                        {
                                            this.updateAttributeInspector(editFeatureLayer, this.m_editGraphic);
                                            this.map.infoWindow.show(this.m_editPoint);
                                        }
                                    }
                                }
                                else
                                {
                                    this.m_editClearSelection = true;
                                    if (this.m_updateGeometryEnabled)
                                    {
                                    }
                                    if (this.checkIfGeometryUpdateIsAllowed(editFeatureLayer))
                                    {
                                        this.checkIfGeometryUpdateIsAllowed(editFeatureLayer);
                                    }
                                    if (editFeatureLayer.isUpdateAllowed(this.m_editGraphic))
                                    {
                                        CursorManager.setCursor(this.moveCursor, CursorManagerPriority.HIGH, -16, -16);
                                        this.m_lastActiveEdit = "moveEditVertices";
                                        this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                                        this.addEditToolEventListeners();
                                    }
                                    this.clearSelection();
                                    editFeatureLayer.selectFeatures(this.m_query, FeatureLayer.SELECTION_NEW);
                                }
                            }
                        }
                    }
                }
                else
                {
                    this.m_isEdit = true;
                    this.m_doNotApplyEdits = false;
                    this.m_editClearSelection = false;
                    this.m_selectionMode = true;
                    if (this.m_tempNewFeature)
                    {
                        this.map.infoWindow.hide();
                        this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
                    }
                    else if (this.m_editGraphic)
                    {
                        this.saveUnsavedAttributes(this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer));
                    }
                    if (this.m_visibleSelectionModeFeatureLayers.length > 0)
                    {
                        var selectFeaturesFromSelectionModeLayers:* = function (selectionMode:String) : void
            {
                var selectedFeatures:Array;
                var selection_resultHandler:Function;
                var selection_faultHandler:Function;
                var selectionMode:* = selectionMode;
                selection_resultHandler = function (features:Array) : void
                {
                    var _loc_2:Graphic = null;
                    (index + 1);
                    if (features)
                    {
                    }
                    if (features.length)
                    {
                        for each (_loc_2 in features)
                        {
                            
                            selectedFeatures.push(_loc_2);
                        }
                    }
                    if (index < m_visibleSelectionModeFeatureLayers.length)
                    {
                        FeatureLayer(m_visibleSelectionModeFeatureLayers[index]).selectFeatures(m_query, selectionMode, new Responder(selection_resultHandler, selection_faultHandler));
                    }
                    else
                    {
                        m_isEdit = selectedFeatures.length != 0;
                        m_lastActiveEdit = selectedFeatures.length != 0 ? ("moveEditVertices") : ("rotateShape");
                    }
                    return;
                }// end function
                ;
                selection_faultHandler = function (fault:Fault) : void
                {
                    (index + 1);
                    if (index < m_visibleSelectionModeFeatureLayers.length)
                    {
                        FeatureLayer(m_visibleSelectionModeFeatureLayers[index]).selectFeatures(m_query, selectionMode, new Responder(selection_resultHandler, selection_faultHandler));
                    }
                    else
                    {
                        m_isEdit = selectedFeatures.length != 0;
                        m_lastActiveEdit = selectedFeatures.length != 0 ? ("moveEditVertices") : ("rotateShape");
                    }
                    return;
                }// end function
                ;
                FeatureLayer(m_visibleSelectionModeFeatureLayers[index]).selectFeatures(m_query, selectionMode, new Responder(selection_resultHandler, selection_faultHandler));
                selectedFeatures;
                return;
            }// end function
            ;
                        point = this.map.toScreen(this.map.toMapFromStage(event.stageX, event.stageY));
                        xmin = this.map.toMapX(point.x - 3);
                        ymin = this.map.toMapY(point.y + 3);
                        xmax = this.map.toMapX(point.x + 3);
                        ymax = this.map.toMapY(point.y - 3);
                        spatialReference = FeatureLayer(this.m_featureLayers[0]).map.spatialReference;
                        selectionExtent = new Extent(xmin, ymin, xmax, ymax, spatialReference);
                        this.m_query = new Query();
                        this.m_query.geometry = selectionExtent;
                        index;
                        if (!event.ctrlKey)
                        {
                            this.m_editClearSelection = true;
                            this.clearSelection();
                            this.selectFeaturesFromSelectionModeLayers(FeatureLayer.SELECTION_NEW);
                        }
                        else
                        {
                            this.map.infoWindow.hide();
                            this.m_editTool.deactivate();
                            this.removeEditToolEventListeners();
                            CursorManager.removeCursor(CursorManager.currentCursorID);
                            this.selectFeaturesFromSelectionModeLayers(FeatureLayer.SELECTION_ADD);
                        }
                    }
                    else if (!event.ctrlKey)
                    {
                        this.finishEditing();
                    }
                }
            }
            return;
        }// end function

        private function updateAttributeInspector(editFeatureLayer:FeatureLayer, editGraphic:Graphic) : void
        {
            if (!editFeatureLayer.isUpdateAllowed(editGraphic))
            {
                this.m_attributeInspector.updateEnabled = false;
            }
            if (!editFeatureLayer.isDeleteAllowed(editGraphic))
            {
                this.m_attributeInspector.deleteButtonVisible = false;
            }
            return;
        }// end function

        private function clearSelection() : void
        {
            var _loc_1:FeatureLayer = null;
            for each (_loc_1 in this.m_featureLayers)
            {
                
                if (_loc_1.selectedFeatures.length > 0)
                {
                    _loc_1.clearSelection();
                }
            }
            if (this.m_toolbarVisible)
            {
                this.deleteButton.enabled = false;
            }
            return;
        }// end function

        private function customContextMenuSelect(event:ContextMenuEvent) : void
        {
            CursorManager.removeCursor(CursorManager.currentCursorID);
            return;
        }// end function

        private function editor_contextMenuHandler(event:EditEvent) : void
        {
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = true;
                this.m_undoVertexDeleteGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            }
            return;
        }// end function

        private function editor_vertexDeleteHandler(event:EditEvent) : void
        {
            var _loc_2:EditGeometryOperation = null;
            if (!this.m_tempNewFeature)
            {
                this.m_redoVertexDeleteGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
                if (!this.m_doNotApplyEdits)
                {
                    this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                    _loc_2 = new EditGeometryOperation(this.m_undoVertexDeleteGraphicGeometry, this.m_redoVertexDeleteGraphicGeometry, this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer), this.m_editTool, this.m_lastActiveEdit);
                    this.m_undoManager.pushUndo(_loc_2);
                    FeatureLayer(this.m_editGraphic.graphicsLayer).applyEdits(null, [this.m_editGraphic], null);
                    this.updateEditInformation(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                    this.m_lastUpdateOperation = "edit geometry";
                    this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                    if (!this.m_applyingEdits)
                    {
                        this.m_applyingEdits = true;
                        invalidateSkinState();
                    }
                }
            }
            return;
        }// end function

        private function editor_ghostVertexMouseDownHandler(event:EditEvent) : void
        {
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = true;
                this.m_undoVertexAddGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            }
            return;
        }// end function

        private function editor_vertexAddHandler(event:EditEvent) : void
        {
            var _loc_2:EditGeometryOperation = null;
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = false;
                this.m_redoVertexAddGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
                if (!this.m_doNotApplyEdits)
                {
                    this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                    _loc_2 = new EditGeometryOperation(this.m_undoVertexAddGraphicGeometry, this.m_redoVertexAddGraphicGeometry, this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer), this.m_editTool, this.m_lastActiveEdit);
                    this.m_undoManager.pushUndo(_loc_2);
                    FeatureLayer(this.m_editGraphic.graphicsLayer).applyEdits(null, [this.m_editGraphic], null);
                    this.updateEditInformation(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                    this.m_lastUpdateOperation = "edit geometry";
                    this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                    if (!this.m_applyingEdits)
                    {
                        this.m_applyingEdits = true;
                        invalidateSkinState();
                    }
                }
            }
            return;
        }// end function

        private function editor_vertexMoveStartHandler(event:EditEvent) : void
        {
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = true;
                this.m_undoVertexMoveGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            }
            return;
        }// end function

        private function editor_vertexMoveFirstHandler(event:EditEvent) : void
        {
            if (!this.m_tempNewFeature)
            {
                this.m_editTool.addEventListener(EditEvent.VERTEX_MOVE_STOP, this.editor_vertexMoveStopHandler);
            }
            return;
        }// end function

        private function editor_vertexMoveStopHandler(event:EditEvent) : void
        {
            var _loc_2:EditGeometryOperation = null;
            this.m_graphicEditing = false;
            this.m_editTool.removeEventListener(EditEvent.VERTEX_MOVE_STOP, this.editor_vertexMoveStopHandler);
            this.m_redoVertexMoveGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            if (!this.m_doNotApplyEdits)
            {
                this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                _loc_2 = new EditGeometryOperation(this.m_undoVertexMoveGraphicGeometry, this.m_redoVertexMoveGraphicGeometry, this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer), this.m_editTool, this.m_lastActiveEdit);
                this.m_undoManager.pushUndo(_loc_2);
                FeatureLayer(this.m_editGraphic.graphicsLayer).applyEdits(null, [this.m_editGraphic], null);
                this.updateEditInformation(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                this.m_lastUpdateOperation = "edit geometry";
                this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                if (!this.m_applyingEdits)
                {
                    this.m_applyingEdits = true;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function editor_graphicMoveFirstHandler(event:EditEvent) : void
        {
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = true;
                this.m_undoGraphicMoveGraphicGeometry = ObjectUtil.copy(event.graphics[0].geometry) as Geometry;
                this.m_editTool.addEventListener(EditEvent.GRAPHICS_MOVE_STOP, this.editor_graphicMoveStopHandler);
            }
            return;
        }// end function

        private function editor_graphicMoveStopHandler(event:EditEvent) : void
        {
            var _loc_2:EditGeometryOperation = null;
            this.m_graphicEditing = false;
            this.m_editTool.removeEventListener(EditEvent.GRAPHICS_MOVE_STOP, this.editor_graphicMoveStopHandler);
            this.m_redoGraphicMoveGraphicGeometry = ObjectUtil.copy(event.graphics[0].geometry) as Geometry;
            if (!this.m_doNotApplyEdits)
            {
                this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                _loc_2 = new EditGeometryOperation(this.m_undoGraphicMoveGraphicGeometry, this.m_redoGraphicMoveGraphicGeometry, this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer), this.m_editTool, this.m_lastActiveEdit);
                this.m_undoManager.pushUndo(_loc_2);
                FeatureLayer(this.m_editGraphic.graphicsLayer).applyEdits(null, [this.m_editGraphic], null);
                this.updateEditInformation(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                this.m_lastUpdateOperation = "edit geometry";
                this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                if (!this.m_applyingEdits)
                {
                    this.m_applyingEdits = true;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function editor_rotateScaleVertexMoveStart(event:EditEvent) : void
        {
            this.m_map.infoWindow.hide();
            if (!this.m_tempNewFeature)
            {
                this.m_graphicEditing = true;
                this.m_undoGraphicScaleRotateGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            }
            return;
        }// end function

        private function editor_rotateScaleVertexMoveFirst(event:EditEvent) : void
        {
            if (!this.m_tempNewFeature)
            {
                this.m_editTool.addEventListener(EditEvent.GRAPHIC_ROTATE_STOP, this.editor_rotateScaleVertexMoveStop);
                this.m_editTool.addEventListener(EditEvent.GRAPHIC_SCALE_STOP, this.editor_rotateScaleVertexMoveStop);
            }
            return;
        }// end function

        private function editor_rotateScaleVertexMoveStop(event:EditEvent) : void
        {
            var _loc_2:EditGeometryOperation = null;
            this.m_graphicEditing = false;
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_ROTATE_STOP, this.editor_rotateScaleVertexMoveStop);
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_SCALE_STOP, this.editor_rotateScaleVertexMoveStop);
            this.m_redoGraphicScaleRotateGraphicGeometry = ObjectUtil.copy(event.graphic.geometry) as Geometry;
            if (!this.m_doNotApplyEdits)
            {
                this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                _loc_2 = new EditGeometryOperation(this.m_undoGraphicScaleRotateGraphicGeometry, this.m_redoGraphicScaleRotateGraphicGeometry, this.m_editGraphic, FeatureLayer(this.m_editGraphic.graphicsLayer), this.m_editTool, this.m_lastActiveEdit);
                this.m_undoManager.pushUndo(_loc_2);
                FeatureLayer(this.m_editGraphic.graphicsLayer).applyEdits(null, [this.m_editGraphic], null);
                this.updateEditInformation(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
                this.m_lastUpdateOperation = "edit geometry";
                this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                if (!this.m_applyingEdits)
                {
                    this.m_applyingEdits = true;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function activateEditToolAfterNormalize() : void
        {
            if (this.m_editGraphic)
            {
                if (!(this.m_editGraphic.geometry is Polyline))
                {
                }
                if (this.m_editGraphic.geometry is Polygon)
                {
                    if (this.m_lastActiveEdit != "moveEditVertices")
                    {
                    }
                    if (this.m_lastActiveEdit == null)
                    {
                        this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                    }
                    else
                    {
                        this.m_editTool.activate(EditTool.MOVE | EditTool.SCALE | EditTool.ROTATE, [this.m_editGraphic]);
                    }
                }
                else
                {
                    this.m_editTool.activate(EditTool.EDIT_VERTICES | EditTool.MOVE, [this.m_editGraphic]);
                }
            }
            return;
        }// end function

        private function addEditToolEventListeners() : void
        {
            this.m_editTool.addEventListener(EditEvent.CONTEXT_MENU_SELECT, this.editor_contextMenuHandler);
            this.m_editTool.addEventListener(EditEvent.GHOST_VERTEX_MOUSE_DOWN, this.editor_ghostVertexMouseDownHandler);
            this.m_editTool.addEventListener(EditEvent.VERTEX_ADD, this.editor_vertexAddHandler);
            this.m_editTool.addEventListener(EditEvent.VERTEX_DELETE, this.editor_vertexDeleteHandler);
            this.m_editTool.addEventListener(EditEvent.VERTEX_MOVE_START, this.editor_vertexMoveStartHandler);
            this.m_editTool.addEventListener(EditEvent.VERTEX_MOVE_FIRST, this.editor_vertexMoveFirstHandler);
            this.m_editTool.addEventListener(EditEvent.GRAPHICS_MOVE_FIRST, this.editor_graphicMoveFirstHandler);
            this.m_editTool.addEventListener(EditEvent.GRAPHIC_ROTATE_START, this.editor_rotateScaleVertexMoveStart);
            this.m_editTool.addEventListener(EditEvent.GRAPHIC_SCALE_START, this.editor_rotateScaleVertexMoveStart);
            this.m_editTool.addEventListener(EditEvent.GRAPHIC_ROTATE_FIRST, this.editor_rotateScaleVertexMoveFirst);
            this.m_editTool.addEventListener(EditEvent.GRAPHIC_SCALE_FIRST, this.editor_rotateScaleVertexMoveFirst);
            return;
        }// end function

        private function removeEditToolEventListeners() : void
        {
            this.m_editTool.removeEventListener(EditEvent.CONTEXT_MENU_SELECT, this.editor_contextMenuHandler);
            this.m_editTool.removeEventListener(EditEvent.GHOST_VERTEX_MOUSE_DOWN, this.editor_ghostVertexMouseDownHandler);
            this.m_editTool.removeEventListener(EditEvent.VERTEX_ADD, this.editor_vertexAddHandler);
            this.m_editTool.removeEventListener(EditEvent.VERTEX_DELETE, this.editor_vertexDeleteHandler);
            this.m_editTool.removeEventListener(EditEvent.VERTEX_MOVE_START, this.editor_vertexMoveStartHandler);
            this.m_editTool.removeEventListener(EditEvent.VERTEX_MOVE_FIRST, this.editor_vertexMoveFirstHandler);
            this.m_editTool.removeEventListener(EditEvent.VERTEX_MOVE_STOP, this.editor_vertexMoveStopHandler);
            this.m_editTool.removeEventListener(EditEvent.GRAPHICS_MOVE_FIRST, this.editor_graphicMoveFirstHandler);
            this.m_editTool.removeEventListener(EditEvent.GRAPHICS_MOVE_STOP, this.editor_graphicMoveStopHandler);
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_ROTATE_START, this.editor_rotateScaleVertexMoveStart);
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_SCALE_START, this.editor_rotateScaleVertexMoveStart);
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_ROTATE_FIRST, this.editor_rotateScaleVertexMoveFirst);
            this.m_editTool.removeEventListener(EditEvent.GRAPHIC_SCALE_FIRST, this.editor_rotateScaleVertexMoveFirst);
            return;
        }// end function

        private function attributeInspector_faultHandler(fault:Fault, token:Object = null) : void
        {
            this.m_applyingEdits = false;
            invalidateSkinState();
            return;
        }// end function

        private function attributeInspector_editsCompleteHandler(featureEditResults:FeatureEditResults, token:Object = null) : void
        {
            var _loc_3:FeatureEditResult = null;
            var _loc_4:Graphic = null;
            var _loc_5:Object = null;
            var _loc_6:FeatureLayer = null;
            this.m_applyingEdits = false;
            invalidateSkinState();
            for each (_loc_3 in featureEditResults.updateResults)
            {
                
                _loc_4 = token.feature;
                if (_loc_3.success === false)
                {
                    for each (_loc_5 in this.m_activeFeatureChangedAttributes)
                    {
                        
                        _loc_4.attributes[_loc_5.field.name] = this.m_activeFeatureChangedAttributes.oldValue;
                    }
                    if (this.attributeInspector.activeFeature === _loc_4)
                    {
                        this.attributeInspector.refreshActiveFeature();
                    }
                }
                else
                {
                    if (_loc_4)
                    {
                    }
                    if (_loc_4.graphicsLayer)
                    {
                        if (_loc_4.graphicsLayer is FeatureLayer)
                        {
                            _loc_6 = _loc_4.graphicsLayer as FeatureLayer;
                            this.updateEditInformation(_loc_4, _loc_6);
                        }
                        _loc_4.refresh();
                    }
                }
                this.m_activeFeatureChangedAttributes = [];
            }
            return;
        }// end function

        private function updateUndoRedoButtons() : void
        {
            if (this.m_undoManager.peekRedo())
            {
                this.m_undoManager.clearRedo();
            }
            if (this.m_toolbarVisible)
            {
                this.setButtonStates();
            }
            return;
        }// end function

        private function findDynamicMapServiceLayer(featureLayer:FeatureLayer) : ArcGISDynamicMapServiceLayer
        {
            var _loc_2:ArcGISDynamicMapServiceLayer = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:Layer = null;
            if (this.m_featureLayerToDynamicMapServiceLayer[featureLayer])
            {
                _loc_2 = this.m_featureLayerToDynamicMapServiceLayer[featureLayer];
            }
            else
            {
                _loc_3 = featureLayer.url.substring(0, featureLayer.url.lastIndexOf("/"));
                _loc_4 = _loc_3.replace("FeatureServer", "MapServer");
                for each (_loc_5 in this.map.layers)
                {
                    
                    if (_loc_5 is ArcGISDynamicMapServiceLayer)
                    {
                    }
                    if (ArcGISDynamicMapServiceLayer(_loc_5).url == _loc_4)
                    {
                        if (featureLayer.gdbVersion)
                        {
                            if (ArcGISDynamicMapServiceLayer(_loc_5).gdbVersion)
                            {
                            }
                            if (ArcGISDynamicMapServiceLayer(_loc_5).gdbVersion == featureLayer.gdbVersion)
                            {
                                _loc_2 = ArcGISDynamicMapServiceLayer(_loc_5);
                                this.m_featureLayerToDynamicMapServiceLayer[featureLayer] = _loc_2;
                                break;
                            }
                            continue;
                        }
                        _loc_2 = ArcGISDynamicMapServiceLayer(_loc_5);
                        this.m_featureLayerToDynamicMapServiceLayer[featureLayer] = _loc_2;
                        break;
                    }
                }
            }
            return _loc_2;
        }// end function

        private function checkIfGeometryUpdateIsAllowed(featureLayer:FeatureLayer) : Boolean
        {
            var _loc_2:Boolean = false;
            if (featureLayer.layerDetails is FeatureLayerDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureLayerDetails).allowGeometryUpdates;
            }
            return _loc_2;
        }// end function

        private function checkIfUpdateIsAllowed(featureLayer:FeatureLayer) : Boolean
        {
            var _loc_2:Boolean = true;
            if (featureLayer.layerDetails is FeatureLayerDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureLayerDetails).isUpdateAllowed;
            }
            else if (featureLayer.tableDetails is FeatureTableDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureTableDetails).isUpdateAllowed;
            }
            return _loc_2;
        }// end function

        private function checkIfDeleteIsAllowed(featureLayer:FeatureLayer) : Boolean
        {
            var _loc_2:Boolean = false;
            if (featureLayer.layerDetails is FeatureLayerDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureLayerDetails).isDeleteAllowed;
            }
            else if (featureLayer.tableDetails is FeatureTableDetails)
            {
                _loc_2 = (featureLayer.layerDetails as FeatureTableDetails).isDeleteAllowed;
            }
            return _loc_2;
        }// end function

        private function showAttributeInspector(graphic:Graphic) : void
        {
            var _loc_2:Multipoint = null;
            var _loc_3:Polyline = null;
            var _loc_4:Polygon = null;
            switch(graphic.geometry.type)
            {
                case Geometry.MAPPOINT:
                {
                    this.map.infoWindow.show(graphic.geometry as MapPoint, this.m_stagePointInfoWindow);
                    break;
                }
                case Geometry.MULTIPOINT:
                {
                    _loc_2 = graphic.geometry as Multipoint;
                    this.map.infoWindow.show(_loc_2.points[0] as MapPoint, this.m_stagePointInfoWindow);
                    break;
                }
                case Geometry.POLYLINE:
                {
                    _loc_3 = graphic.geometry as Polyline;
                    this.map.infoWindow.show((_loc_3.paths[0] as Array)[0] as MapPoint, this.m_stagePointInfoWindow);
                    break;
                }
                case Geometry.POLYGON:
                {
                    _loc_4 = graphic.geometry as Polygon;
                    if (!isNaN(_loc_4.extent.center.x))
                    {
                    }
                    if (!isNaN(_loc_4.extent.center.y))
                    {
                        this.map.infoWindow.show((_loc_4.rings[0] as Array)[0] as MapPoint, this.m_stagePointInfoWindow);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.map.infoWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, this.infoWindowCloseButtonMouseDownHandler);
            return;
        }// end function

        private function removeTempNewGraphic() : void
        {
            if (this.m_deletingTempGraphic)
            {
                this.m_attributeInspector.refresh();
                this.m_deletingTempGraphic = false;
            }
            this.map.defaultGraphicsLayer.remove(this.m_tempNewFeature);
            this.m_tempNewFeature = null;
            this.m_activeFeatureChangedAttributes = [];
            if (this.m_toolbarVisible)
            {
                this.deleteButton.enabled = false;
            }
            return;
        }// end function

        private function finishEditing() : void
        {
            this.m_infoWindowCloseButtonClicked = false;
            this.m_lastActiveEdit = "";
            this.m_isEdit = false;
            this.m_doNotApplyEdits = true;
            if (this.m_editGraphic)
            {
                this.m_editGraphic = null;
            }
            CursorManager.removeCursor(CursorManager.currentCursorID);
            this.m_editTool.deactivate();
            this.removeEditToolEventListeners();
            this.m_stagePointInfoWindow = null;
            this.map.infoWindow.hide();
            this.clearSelection();
            return;
        }// end function

        private function infoWindowCloseButtonMouseDownHandler(event:MouseEvent) : void
        {
            this.map.infoWindow.closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.infoWindowCloseButtonMouseDownHandler);
            if (this.m_tempNewFeature)
            {
                this.addNewFeature(this.m_tempNewFeature, this.m_tempNewFeatureLayer);
            }
            else
            {
                this.saveUnsavedAttributes(this.attributeInspector.activeFeature, this.attributeInspector.activeFeatureLayer);
            }
            return;
        }// end function

        private function saveUnsavedAttributes(feature:Graphic, featureLayer:FeatureLayer) : void
        {
            var _loc_3:Object = null;
            var _loc_4:String = null;
            var _loc_5:Object = null;
            var _loc_6:EditAttributesOperation = null;
            var _loc_7:Graphic = null;
            var _loc_8:Array = null;
            if (this.m_activeFeatureChangedAttributes.length)
            {
                _loc_3 = {};
                _loc_4 = featureLayer.layerDetails.objectIdField;
                _loc_3[_loc_4] = feature.attributes[_loc_4];
                for each (_loc_5 in this.m_activeFeatureChangedAttributes)
                {
                    
                    _loc_3[_loc_5.field.name] = _loc_5.newValue;
                    feature.attributes[_loc_5.field.name] = _loc_5.newValue;
                }
                _loc_6 = new EditAttributesOperation(feature, this.m_activeFeatureChangedAttributes, this.attributeInspector);
                this.m_undoManager.pushUndo(_loc_6);
                callLater(this.updateUndoRedoButtons);
                _loc_7 = new Graphic(null, null, _loc_3);
                _loc_8 = [_loc_7];
                featureLayer.applyEdits(null, _loc_8, null, false, new AsyncResponder(this.attributeInspector_editsCompleteHandler, this.attributeInspector_faultHandler, {feature:feature}));
                this.m_lastUpdateOperation = "edit attribute";
                this.operationStartLabel.text = UPDATE_FEATURE_OPERATION_START;
                if (!this.m_applyingEdits)
                {
                    this.m_applyingEdits = true;
                    invalidateSkinState();
                }
            }
            return;
        }// end function

        private function updateEditInformation(feature:Graphic, featureLayer:FeatureLayer) : void
        {
            var _loc_4:String = null;
            var _loc_3:* = featureLayer.editFieldsInfo;
            if (_loc_3)
            {
            }
            if (_loc_3.editorField)
            {
                if (featureLayer.userId)
                {
                    _loc_4 = featureLayer.userId;
                    feature.attributes[_loc_3.editorField] = _loc_3.realm ? (_loc_4 + "@" + _loc_3.realm) : (_loc_4);
                }
                else
                {
                    feature.attributes[_loc_3.editorField] = "";
                }
            }
            if (_loc_3)
            {
            }
            if (_loc_3.editDateField)
            {
                feature.attributes[_loc_3.editDateField] = new Date().getTime();
            }
            if (this.attributeInspector.activeFeature === feature)
            {
                this.attributeInspector.refreshActiveFeature();
            }
            return;
        }// end function

        private function setSelectionFilter(feature:Graphic, selectionColor:uint) : void
        {
            var _loc_3:* = new GlowFilter();
            _loc_3.alpha = 0.6;
            _loc_3.blurX = 16;
            _loc_3.blurY = 16;
            _loc_3.inner = feature.geometry is Polygon;
            _loc_3.strength = 8;
            _loc_3.color = selectionColor;
            feature.filters = [_loc_3];
            return;
        }// end function

        public function set updateAttributesEnabled(value:Boolean) : void
        {
            arguments = this.updateAttributesEnabled;
            if (arguments !== value)
            {
                this._546952159updateAttributesEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "updateAttributesEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set toolbarMergeVisible(value:Boolean) : void
        {
            arguments = this.toolbarMergeVisible;
            if (arguments !== value)
            {
                this._1160858571toolbarMergeVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolbarMergeVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set updateGeometryEnabled(value:Boolean) : void
        {
            arguments = this.updateGeometryEnabled;
            if (arguments !== value)
            {
                this._1030763930updateGeometryEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "updateGeometryEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set addEnabled(value:Boolean) : void
        {
            arguments = this.addEnabled;
            if (arguments !== value)
            {
                this._298640224addEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set createOptions(value:CreateOptions) : void
        {
            arguments = this.createOptions;
            if (arguments !== value)
            {
                this._997042690createOptions = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "createOptions", arguments, value));
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

        public function set undoAndRedoItemLimit(value:int) : void
        {
            arguments = this.undoAndRedoItemLimit;
            if (arguments !== value)
            {
                this._1765640073undoAndRedoItemLimit = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "undoAndRedoItemLimit", arguments, value));
                }
            }
            return;
        }// end function

        public function set toolbarVisible(value:Boolean) : void
        {
            arguments = this.toolbarVisible;
            if (arguments !== value)
            {
                this._1563241591toolbarVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolbarVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set map(value:Map) : void
        {
            arguments = this.map;
            if (arguments !== value)
            {
                this._107868map = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "map", arguments, value));
                }
            }
            return;
        }// end function

        public function set showTemplateSwatchOnCursor(value:Boolean) : void
        {
            arguments = this.showTemplateSwatchOnCursor;
            if (arguments !== value)
            {
                this._1701569304showTemplateSwatchOnCursor = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showTemplateSwatchOnCursor", arguments, value));
                }
            }
            return;
        }// end function

        public function set geometryService(value:GeometryService) : void
        {
            arguments = this.geometryService;
            if (arguments !== value)
            {
                this._1579241955geometryService = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "geometryService", arguments, value));
                }
            }
            return;
        }// end function

        public function set deleteEnabled(value:Boolean) : void
        {
            arguments = this.deleteEnabled;
            if (arguments !== value)
            {
                this._1814366442deleteEnabled = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteEnabled", arguments, value));
                }
            }
            return;
        }// end function

        public function set toolbarCutVisible(value:Boolean) : void
        {
            arguments = this.toolbarCutVisible;
            if (arguments !== value)
            {
                this._1691214251toolbarCutVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolbarCutVisible", arguments, value));
                }
            }
            return;
        }// end function

        public function set toolbarReshapeVisible(value:Boolean) : void
        {
            arguments = this.toolbarReshapeVisible;
            if (arguments !== value)
            {
                this._385871969toolbarReshapeVisible = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolbarReshapeVisible", arguments, value));
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
