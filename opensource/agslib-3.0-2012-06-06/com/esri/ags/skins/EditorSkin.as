package com.esri.ags.skins
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.geometry.*;
    import com.esri.ags.skins.supportClasses.*;
    import com.esri.ags.tools.*;
    import flash.events.*;
    import flash.utils.*;
    import mx.binding.*;
    import mx.binding.utils.*;
    import mx.collections.*;
    import mx.controls.*;
    import mx.core.*;
    import mx.events.*;
    import mx.states.*;
    import spark.components.*;
    import spark.effects.*;
    import spark.layouts.*;
    import spark.skins.*;

    public class EditorSkin extends SparkSkin implements IBindingClient, IStateClient2
    {
        private var _854744984_EditorSkin_Group1:Group;
        private var _1068241915_EditorSkin_HGroup2:HGroup;
        public var _EditorSkin_Object11:Object;
        public var _EditorSkin_Object12:Object;
        public var _EditorSkin_Object13:Object;
        public var _EditorSkin_SWFLoader1:SWFLoader;
        private var _1043447969autoCompleteIcon:Object;
        private var _1111194263circleIcon:Object;
        private var _569977297clearSelectionButton:Button;
        private var _1073372180cutButton:ToggleButton;
        private var _1245745987deleteButton:Button;
        private var _274208723drawDropDownList:DropDownList;
        private var _468079241ellipseIcon:Object;
        private var _1809462589extentIcon:Object;
        private var _3135100fade:Fade;
        private var _774807416freehandLineIcon:Object;
        private var _102906104freehandPolygonIcon:Object;
        private var _1188316813lineIcon:Object;
        private var _1713012781mapPointIcon:Object;
        private var _293032566mergeButton:Button;
        private var _1716202732operationCompleteLabel:Label;
        private var _324113529operationStartLabel:Label;
        private var _808926766pointToPointLineIcon:Object;
        private var _1560599406pointToPointPolygonIcon:Object;
        private var _1120171728redoButton:Button;
        private var _1452247584reshapeButton:ToggleButton;
        private var _2030751717selectionDropDownList:DropDownList;
        private var _1725694552templatePicker:TemplatePicker;
        private var _1443410230undoButton:Button;
        private var __moduleFactoryInitialized:Boolean = false;
        private var _changeWatcher:ChangeWatcher;
        private var _createGeometryTypeChanged:Boolean;
        private var _arrayList:ArrayList;
        private var _1097519085loader:Class;
        private var _embed_mxml_____________assets_skins_EditingCircleTool16_png_170231401:Class;
        private var _embed_mxml_____________assets_skins_ElementLine16_png_124998519:Class;
        private var _embed_mxml_____________assets_skins_AddToSelection_png_1510261577:Class;
        private var _embed_mxml_____________assets_skins_ElementMarker16_png_1266106603:Class;
        private var _embed_mxml_____________assets_skins_NewSelection_png_594239913:Class;
        private var _embed_mxml_____________assets_skins_EditingExtent_16_png_1448951827:Class;
        private var _embed_mxml_____________assets_skins_RemoveFromSelection_png_1975225747:Class;
        private var _embed_mxml_____________assets_skins_ElementFreehand16_png_905990551:Class;
        private var _embed_mxml_____________assets_skins_FreehandPolygon_16_png_1659438039:Class;
        private var _embed_mxml_____________assets_skins_ElementPolyline16_png_821353815:Class;
        private var _embed_mxml_____________assets_skins_EditingEllipseTool16_png_431419219:Class;
        private var _embed_mxml_____________assets_skins_EditingAutoCompletePolygonTool16_png_484197179:Class;
        private var _embed_mxml_____________assets_skins_EditingPolygonTool16_png_38240171:Class;
        var _bindings:Array;
        var _watchers:Array;
        var _bindingsByDestination:Object;
        var _bindingsBeginWithWord:Object;
        private var _213507019hostComponent:Editor;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        public function EditorSkin()
        {
            var target:Object;
            var watcherSetupUtilClass:Object;
            this._1097519085loader = EditorSkin_loader;
            this._embed_mxml_____________assets_skins_EditingCircleTool16_png_170231401 = EditorSkin__embed_mxml_____________assets_skins_EditingCircleTool16_png_170231401;
            this._embed_mxml_____________assets_skins_ElementLine16_png_124998519 = EditorSkin__embed_mxml_____________assets_skins_ElementLine16_png_124998519;
            this._embed_mxml_____________assets_skins_AddToSelection_png_1510261577 = EditorSkin__embed_mxml_____________assets_skins_AddToSelection_png_1510261577;
            this._embed_mxml_____________assets_skins_ElementMarker16_png_1266106603 = EditorSkin__embed_mxml_____________assets_skins_ElementMarker16_png_1266106603;
            this._embed_mxml_____________assets_skins_NewSelection_png_594239913 = EditorSkin__embed_mxml_____________assets_skins_NewSelection_png_594239913;
            this._embed_mxml_____________assets_skins_EditingExtent_16_png_1448951827 = EditorSkin__embed_mxml_____________assets_skins_EditingExtent_16_png_1448951827;
            this._embed_mxml_____________assets_skins_RemoveFromSelection_png_1975225747 = EditorSkin__embed_mxml_____________assets_skins_RemoveFromSelection_png_1975225747;
            this._embed_mxml_____________assets_skins_ElementFreehand16_png_905990551 = EditorSkin__embed_mxml_____________assets_skins_ElementFreehand16_png_905990551;
            this._embed_mxml_____________assets_skins_FreehandPolygon_16_png_1659438039 = EditorSkin__embed_mxml_____________assets_skins_FreehandPolygon_16_png_1659438039;
            this._embed_mxml_____________assets_skins_ElementPolyline16_png_821353815 = EditorSkin__embed_mxml_____________assets_skins_ElementPolyline16_png_821353815;
            this._embed_mxml_____________assets_skins_EditingEllipseTool16_png_431419219 = EditorSkin__embed_mxml_____________assets_skins_EditingEllipseTool16_png_431419219;
            this._embed_mxml_____________assets_skins_EditingAutoCompletePolygonTool16_png_484197179 = EditorSkin__embed_mxml_____________assets_skins_EditingAutoCompletePolygonTool16_png_484197179;
            this._embed_mxml_____________assets_skins_EditingPolygonTool16_png_38240171 = EditorSkin__embed_mxml_____________assets_skins_EditingPolygonTool16_png_38240171;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            mx_internal::_document = this;
            var bindings:* = this._EditorSkin_bindingsSetup();
            var watchers:Array;
            target;
            if (_watcherSetupUtil == null)
            {
                watcherSetupUtilClass = getDefinitionByName("_com_esri_ags_skins_EditorSkinWatcherSetupUtil");
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
            this.layout = this._EditorSkin_VerticalLayout1_c();
            this.mxmlContent = [this._EditorSkin_Scroller1_c(), this._EditorSkin_Group1_i(), this._EditorSkin_HGroup2_i(), this._EditorSkin_Label2_i()];
            this.currentState = "normal";
            this._EditorSkin_Object10_i();
            this._EditorSkin_Object8_i();
            this._EditorSkin_Object9_i();
            this._EditorSkin_Object7_i();
            this._EditorSkin_Fade1_i();
            this._EditorSkin_Object3_i();
            this._EditorSkin_Object6_i();
            this._EditorSkin_Object4_i();
            this._EditorSkin_Object1_i();
            this._EditorSkin_Object2_i();
            this._EditorSkin_Object5_i();
            this.addEventListener("initialize", this.___EditorSkin_SparkSkin1_initialize);
            var _EditorSkin_Button1_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_Button1_i);
            var _EditorSkin_Button2_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_Button2_i);
            var _EditorSkin_Button3_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_Button3_i);
            var _EditorSkin_Button4_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_Button4_i);
            var _EditorSkin_Button5_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_Button5_i);
            var _EditorSkin_DropDownList1_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_DropDownList1_i);
            var _EditorSkin_DropDownList2_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_DropDownList2_i);
            var _EditorSkin_ToggleButton1_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_ToggleButton1_i);
            var _EditorSkin_ToggleButton2_factory:* = new DeferredInstanceFromFunction(this._EditorSkin_ToggleButton2_i);
            states = [new State({name:"normal", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button5_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button4_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button3_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"selectionDropDownList", name:"enabled", value:true}), new SetProperty().initializeFromObject({target:"clearSelectionButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"drawDropDownList", name:"enabled", value:false})]}), new State({name:"disabled", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button5_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button4_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button3_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"})]}), new State({name:"applyingEdits", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button5_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button4_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button3_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"selectionDropDownList", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"clearSelectionButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"drawDropDownList", name:"enabled", value:false}), new SetProperty().initializeFromObject({isBaseValueDataBound:true, target:"cutButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"_EditorSkin_HGroup2", name:"includeInLayout", value:true}), new SetProperty().initializeFromObject({target:"_EditorSkin_HGroup2", name:"visible", value:true})]}), new State({name:"toolbarNotVisible", overrides:[]}), new State({name:"templateSelected", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button5_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button4_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button3_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"selectionDropDownList", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"clearSelectionButton", name:"enabled", value:false}), new SetProperty().initializeFromObject({target:"drawDropDownList", name:"enabled", value:true}), new SetProperty().initializeFromObject({isBaseValueDataBound:true, target:"cutButton", name:"enabled", value:false})]}), new State({name:"featuresSelected", overrides:[new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button5_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button4_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button3_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_ToggleButton1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button2_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_Button1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new AddItems().initializeFromObject({itemsFactory:_EditorSkin_DropDownList1_factory, destination:"_EditorSkin_Group1", propertyName:"mxmlContent", position:"first"}), new SetProperty().initializeFromObject({target:"clearSelectionButton", name:"enabled", value:true}), new SetProperty().initializeFromObject({target:"drawDropDownList", name:"enabled", value:false})]})];
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

        private function editorSkin_initializeHandler(event:FlexEvent) : void
        {
            this._changeWatcher = ChangeWatcher.watch(this.hostComponent, "createGeometryType", this.createGeometryType_changeHandler);
            return;
        }// end function

        private function createGeometryType_changeHandler(event:Event = null) : void
        {
            invalidateProperties();
            this._createGeometryTypeChanged = true;
            return;
        }// end function

        override protected function commitProperties() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            super.commitProperties();
            if (this.hostComponent.toolbarVisible)
            {
                if (this._createGeometryTypeChanged)
                {
                    this._createGeometryTypeChanged = false;
                    this._arrayList = new ArrayList();
                    switch(this.hostComponent.createGeometryType)
                    {
                        case Geometry.MAPPOINT:
                        case Geometry.MULTIPOINT:
                        {
                            this._arrayList.addItem(this.mapPointIcon);
                            this.drawDropDownList.dataProvider = this._arrayList;
                            break;
                        }
                        case Geometry.POLYLINE:
                        {
                            if (this.hostComponent.createOptions)
                            {
                                for each (_loc_1 in this.hostComponent.createOptions.polylineDrawTools)
                                {
                                    
                                    if (_loc_1 == DrawTool.POLYLINE)
                                    {
                                        this._arrayList.addItem(this.pointToPointLineIcon);
                                    }
                                    if (_loc_1 == DrawTool.FREEHAND_POLYLINE)
                                    {
                                        this._arrayList.addItem(this.freehandLineIcon);
                                    }
                                    if (_loc_1 == DrawTool.LINE)
                                    {
                                        this._arrayList.addItem(this.lineIcon);
                                    }
                                }
                            }
                            else
                            {
                                this._arrayList.addItem(this.pointToPointLineIcon);
                                this._arrayList.addItem(this.freehandLineIcon);
                            }
                            this.drawDropDownList.dataProvider = this._arrayList;
                            break;
                        }
                        case Geometry.POLYGON:
                        {
                            if (this.hostComponent.createOptions)
                            {
                                for each (_loc_2 in this.hostComponent.createOptions.polygonDrawTools)
                                {
                                    
                                    if (_loc_2 == DrawTool.POLYGON)
                                    {
                                        this._arrayList.addItem(this.pointToPointPolygonIcon);
                                    }
                                    if (_loc_2 == DrawTool.FREEHAND_POLYGON)
                                    {
                                        this._arrayList.addItem(this.freehandPolygonIcon);
                                    }
                                    if (_loc_2 == DrawTool.EXTENT)
                                    {
                                        this._arrayList.addItem(this.extentIcon);
                                    }
                                    if (_loc_2 == CreateOptions.AUTO_COMPLETE)
                                    {
                                        this._arrayList.addItem(this.autoCompleteIcon);
                                    }
                                    if (_loc_2 == DrawTool.CIRCLE)
                                    {
                                        this._arrayList.addItem(this.circleIcon);
                                    }
                                    if (_loc_2 == DrawTool.ELLIPSE)
                                    {
                                        this._arrayList.addItem(this.ellipseIcon);
                                    }
                                }
                            }
                            else
                            {
                                this._arrayList.addItem(this.pointToPointPolygonIcon);
                                this._arrayList.addItem(this.freehandPolygonIcon);
                                this._arrayList.addItem(this.autoCompleteIcon);
                                this._arrayList.addItem(this.extentIcon);
                                this._arrayList.addItem(this.circleIcon);
                                this._arrayList.addItem(this.ellipseIcon);
                            }
                            this.drawDropDownList.dataProvider = this._arrayList;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            return;
        }// end function

        private function fade_effectEndHandler(event:EffectEvent) : void
        {
            this.operationCompleteLabel.includeInLayout = false;
            return;
        }// end function

        private function getNumFeatureLayers(featureLayers:Array) : Number
        {
            return featureLayers.length;
        }// end function

        private function _EditorSkin_Object10_i() : Object
        {
            var _loc_1:Object = {drawId:"autoComplete", icon:this._embed_mxml_____________assets_skins_EditingAutoCompletePolygonTool16_png_484197179, label:null};
            this.autoCompleteIcon = _loc_1;
            BindingManager.executeBindings(this, "autoCompleteIcon", this.autoCompleteIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object8_i() : Object
        {
            var _loc_1:Object = {drawId:"circle", icon:this._embed_mxml_____________assets_skins_EditingCircleTool16_png_170231401, label:null};
            this.circleIcon = _loc_1;
            BindingManager.executeBindings(this, "circleIcon", this.circleIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object9_i() : Object
        {
            var _loc_1:Object = {drawId:"ellipse", icon:this._embed_mxml_____________assets_skins_EditingEllipseTool16_png_431419219, label:null};
            this.ellipseIcon = _loc_1;
            BindingManager.executeBindings(this, "ellipseIcon", this.ellipseIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object7_i() : Object
        {
            var _loc_1:Object = {drawId:"extent", icon:this._embed_mxml_____________assets_skins_EditingExtent_16_png_1448951827, label:null};
            this.extentIcon = _loc_1;
            BindingManager.executeBindings(this, "extentIcon", this.extentIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Fade1_i() : Fade
        {
            var _loc_1:* = new Fade();
            _loc_1.alphaFrom = 1;
            _loc_1.alphaTo = 0;
            _loc_1.duration = 1500;
            _loc_1.addEventListener("effectEnd", this.__fade_effectEnd);
            this.fade = _loc_1;
            BindingManager.executeBindings(this, "fade", this.fade);
            return _loc_1;
        }// end function

        public function __fade_effectEnd(event:EffectEvent) : void
        {
            this.fade_effectEndHandler(event);
            return;
        }// end function

        private function _EditorSkin_Object3_i() : Object
        {
            var _loc_1:Object = {drawId:"freehandLine", icon:this._embed_mxml_____________assets_skins_ElementFreehand16_png_905990551, label:null};
            this.freehandLineIcon = _loc_1;
            BindingManager.executeBindings(this, "freehandLineIcon", this.freehandLineIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object6_i() : Object
        {
            var _loc_1:Object = {drawId:"freehandPolygon", icon:this._embed_mxml_____________assets_skins_FreehandPolygon_16_png_1659438039, label:null};
            this.freehandPolygonIcon = _loc_1;
            BindingManager.executeBindings(this, "freehandPolygonIcon", this.freehandPolygonIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object4_i() : Object
        {
            var _loc_1:Object = {drawId:"line", icon:this._embed_mxml_____________assets_skins_ElementLine16_png_124998519, label:null};
            this.lineIcon = _loc_1;
            BindingManager.executeBindings(this, "lineIcon", this.lineIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object1_i() : Object
        {
            var _loc_1:Object = {drawId:"mappoint", icon:this._embed_mxml_____________assets_skins_ElementMarker16_png_1266106603, label:null};
            this.mapPointIcon = _loc_1;
            BindingManager.executeBindings(this, "mapPointIcon", this.mapPointIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object2_i() : Object
        {
            var _loc_1:Object = {drawId:"pointToPointLine", icon:this._embed_mxml_____________assets_skins_ElementPolyline16_png_821353815, label:null};
            this.pointToPointLineIcon = _loc_1;
            BindingManager.executeBindings(this, "pointToPointLineIcon", this.pointToPointLineIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object5_i() : Object
        {
            var _loc_1:Object = {drawId:"pointToPointPolygon", icon:this._embed_mxml_____________assets_skins_EditingPolygonTool16_png_38240171, label:null};
            this.pointToPointPolygonIcon = _loc_1;
            BindingManager.executeBindings(this, "pointToPointPolygonIcon", this.pointToPointPolygonIcon);
            return _loc_1;
        }// end function

        private function _EditorSkin_VerticalLayout1_c() : VerticalLayout
        {
            var _loc_1:* = new VerticalLayout();
            return _loc_1;
        }// end function

        private function _EditorSkin_Scroller1_c() : Scroller
        {
            var _loc_1:* = new Scroller();
            _loc_1.percentWidth = 100;
            _loc_1.percentHeight = 100;
            _loc_1.focusEnabled = false;
            _loc_1.hasFocusableChildren = true;
            _loc_1.viewport = this._EditorSkin_HGroup1_c();
            _loc_1.setStyle("horizontalScrollPolicy", "auto");
            _loc_1.setStyle("verticalScrollPolicy", "auto");
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _EditorSkin_HGroup1_c() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.mxmlContent = [this._EditorSkin_TemplatePicker1_i()];
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            return _loc_1;
        }// end function

        private function _EditorSkin_TemplatePicker1_i() : TemplatePicker
        {
            var _loc_1:* = new TemplatePicker();
            _loc_1.percentWidth = 100;
            _loc_1.left = 0;
            _loc_1.top = 0;
            _loc_1.visible = true;
            _loc_1.id = "templatePicker";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.templatePicker = _loc_1;
            BindingManager.executeBindings(this, "templatePicker", this.templatePicker);
            return _loc_1;
        }// end function

        private function _EditorSkin_Group1_i() : Group
        {
            var _loc_1:* = new Group();
            _loc_1.percentWidth = 100;
            _loc_1.height = 55;
            _loc_1.horizontalCenter = 0;
            _loc_1.verticalCenter = 0;
            _loc_1.layout = this._EditorSkin_FlowLayout1_c();
            _loc_1.mxmlContent = [];
            _loc_1.id = "_EditorSkin_Group1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._EditorSkin_Group1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_Group1", this._EditorSkin_Group1);
            return _loc_1;
        }// end function

        private function _EditorSkin_FlowLayout1_c() : FlowLayout
        {
            var _loc_1:* = new FlowLayout();
            return _loc_1;
        }// end function

        private function _EditorSkin_DropDownList1_i() : DropDownList
        {
            var _loc_1:* = new DropDownList();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.itemRenderer = this._EditorSkin_ClassFactory1_c();
            _loc_1.labelField = "label";
            _loc_1.dataProvider = this._EditorSkin_ArrayList1_c();
            _loc_1.setStyle("skinClass", EditorSelectionDropDownListSkin);
            _loc_1.id = "selectionDropDownList";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.selectionDropDownList = _loc_1;
            BindingManager.executeBindings(this, "selectionDropDownList", this.selectionDropDownList);
            return _loc_1;
        }// end function

        private function _EditorSkin_ClassFactory1_c() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = EditorDropDownListItemRenderer;
            return _loc_1;
        }// end function

        private function _EditorSkin_ArrayList1_c() : ArrayList
        {
            var _loc_1:* = new ArrayList();
            _loc_1.source = [this._EditorSkin_Object11_i(), this._EditorSkin_Object12_i(), this._EditorSkin_Object13_i()];
            return _loc_1;
        }// end function

        private function _EditorSkin_Object11_i() : Object
        {
            var _loc_1:Object = {icon:this._embed_mxml_____________assets_skins_NewSelection_png_594239913, label:null, selectionName:"newSelection"};
            this._EditorSkin_Object11 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_Object11", this._EditorSkin_Object11);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object12_i() : Object
        {
            var _loc_1:Object = {icon:this._embed_mxml_____________assets_skins_AddToSelection_png_1510261577, label:null, selectionName:"addToSelection"};
            this._EditorSkin_Object12 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_Object12", this._EditorSkin_Object12);
            return _loc_1;
        }// end function

        private function _EditorSkin_Object13_i() : Object
        {
            var _loc_1:Object = {icon:this._embed_mxml_____________assets_skins_RemoveFromSelection_png_1975225747, label:null, selectionName:"subtractFromSelection"};
            this._EditorSkin_Object13 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_Object13", this._EditorSkin_Object13);
            return _loc_1;
        }// end function

        private function _EditorSkin_Button1_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.setStyle("skinClass", EditorClearSelectionButtonSkin);
            _loc_1.id = "clearSelectionButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.clearSelectionButton = _loc_1;
            BindingManager.executeBindings(this, "clearSelectionButton", this.clearSelectionButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_Button2_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.enabled = false;
            _loc_1.setStyle("skinClass", EditorDeleteButtonSkin);
            _loc_1.id = "deleteButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.deleteButton = _loc_1;
            BindingManager.executeBindings(this, "deleteButton", this.deleteButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_DropDownList2_i() : DropDownList
        {
            var _loc_1:* = new DropDownList();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.itemRenderer = this._EditorSkin_ClassFactory2_c();
            _loc_1.setStyle("skinClass", EditorDrawDropDownListSkin);
            _loc_1.id = "drawDropDownList";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.drawDropDownList = _loc_1;
            BindingManager.executeBindings(this, "drawDropDownList", this.drawDropDownList);
            return _loc_1;
        }// end function

        private function _EditorSkin_ClassFactory2_c() : ClassFactory
        {
            var _loc_1:* = new ClassFactory();
            _loc_1.generator = EditorDropDownListItemRenderer;
            return _loc_1;
        }// end function

        private function _EditorSkin_ToggleButton1_i() : ToggleButton
        {
            var _loc_1:* = new ToggleButton();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.setStyle("skinClass", EditorCutButtonSkin);
            _loc_1.id = "cutButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.cutButton = _loc_1;
            BindingManager.executeBindings(this, "cutButton", this.cutButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_Button3_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.enabled = false;
            _loc_1.setStyle("skinClass", EditorMergeButtonSkin);
            _loc_1.id = "mergeButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.mergeButton = _loc_1;
            BindingManager.executeBindings(this, "mergeButton", this.mergeButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_ToggleButton2_i() : ToggleButton
        {
            var _loc_1:* = new ToggleButton();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.enabled = false;
            _loc_1.setStyle("skinClass", EditorReshapeButtonSkin);
            _loc_1.id = "reshapeButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.reshapeButton = _loc_1;
            BindingManager.executeBindings(this, "reshapeButton", this.reshapeButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_Button4_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.setStyle("skinClass", EditorUndoButtonSkin);
            _loc_1.id = "undoButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.undoButton = _loc_1;
            BindingManager.executeBindings(this, "undoButton", this.undoButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_Button5_i() : Button
        {
            var _loc_1:* = new Button();
            _loc_1.width = 40;
            _loc_1.height = 25;
            _loc_1.setStyle("skinClass", EditorRedoButtonSkin);
            _loc_1.id = "redoButton";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.redoButton = _loc_1;
            BindingManager.executeBindings(this, "redoButton", this.redoButton);
            return _loc_1;
        }// end function

        private function _EditorSkin_HGroup2_i() : HGroup
        {
            var _loc_1:* = new HGroup();
            _loc_1.percentWidth = 100;
            _loc_1.includeInLayout = false;
            _loc_1.verticalAlign = "middle";
            _loc_1.visible = false;
            _loc_1.mxmlContent = [this._EditorSkin_SWFLoader1_i(), this._EditorSkin_Label1_i()];
            _loc_1.id = "_EditorSkin_HGroup2";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._EditorSkin_HGroup2 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_HGroup2", this._EditorSkin_HGroup2);
            return _loc_1;
        }// end function

        private function _EditorSkin_SWFLoader1_i() : SWFLoader
        {
            var _loc_1:* = new SWFLoader();
            _loc_1.id = "_EditorSkin_SWFLoader1";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this._EditorSkin_SWFLoader1 = _loc_1;
            BindingManager.executeBindings(this, "_EditorSkin_SWFLoader1", this._EditorSkin_SWFLoader1);
            return _loc_1;
        }// end function

        private function _EditorSkin_Label1_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.id = "operationStartLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.operationStartLabel = _loc_1;
            BindingManager.executeBindings(this, "operationStartLabel", this.operationStartLabel);
            return _loc_1;
        }// end function

        private function _EditorSkin_Label2_i() : Label
        {
            var _loc_1:* = new Label();
            _loc_1.percentWidth = 100;
            _loc_1.includeInLayout = false;
            _loc_1.visible = false;
            _loc_1.id = "operationCompleteLabel";
            if (!_loc_1.document)
            {
                _loc_1.document = this;
            }
            this.operationCompleteLabel = _loc_1;
            BindingManager.executeBindings(this, "operationCompleteLabel", this.operationCompleteLabel);
            return _loc_1;
        }// end function

        public function ___EditorSkin_SparkSkin1_initialize(event:FlexEvent) : void
        {
            this.editorSkin_initializeHandler(event);
            return;
        }// end function

        private function _EditorSkin_bindingsSetup() : Array
        {
            var result:Array;
            result[0] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreatePointLabel");
            }// end function
            , null, "mapPointIcon.label");
            result[1] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreatePointToPointLabel");
            }// end function
            , null, "pointToPointLineIcon.label");
            result[2] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateFreehandLabel");
            }// end function
            , null, "freehandLineIcon.label");
            result[3] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateLineLabel");
            }// end function
            , null, "lineIcon.label");
            result[4] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreatePointToPointLabel");
            }// end function
            , null, "pointToPointPolygonIcon.label");
            result[5] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateFreehandLabel");
            }// end function
            , null, "freehandPolygonIcon.label");
            result[6] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateExtentLabel");
            }// end function
            , null, "extentIcon.label");
            result[7] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateCircleLabel");
            }// end function
            , null, "circleIcon.label");
            result[8] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateEllipseLabel");
            }// end function
            , null, "ellipseIcon.label");
            result[9] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorCreateAutoCompleteLabel");
            }// end function
            , null, "autoCompleteIcon.label");
            result[10] = new Binding(this, function () : Boolean
            {
                return hostComponent.toolbarVisible;
            }// end function
            , null, "_EditorSkin_Group1.includeInLayout");
            result[11] = new Binding(this, function () : Boolean
            {
                return hostComponent.toolbarVisible;
            }// end function
            , null, "_EditorSkin_Group1.visible");
            result[12] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorSelectionTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "selectionDropDownList.toolTip");
            result[13] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorNewSelectionLabel");
            }// end function
            , null, "_EditorSkin_Object11.label");
            result[14] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorAddSelectionLabel");
            }// end function
            , null, "_EditorSkin_Object12.label");
            result[15] = new Binding(this, function ()
            {
                return resourceManager.getString("ESRIMessages", "editorSubtractSelectionLabel");
            }// end function
            , null, "_EditorSkin_Object13.label");
            result[16] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorClearSelectionTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "clearSelectionButton.toolTip");
            result[17] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.deleteEnabled;
            }// end function
            , null, "deleteButton.includeInLayout");
            result[18] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorDeleteTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "deleteButton.toolTip");
            result[19] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.deleteEnabled;
            }// end function
            , null, "deleteButton.visible");
            result[20] = new Binding(this, function () : Boolean
            {
                return hostComponent.toolbarVisible;
            }// end function
            , null, "drawDropDownList.includeInLayout");
            result[21] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorCreateOptionsTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "drawDropDownList.toolTip");
            result[22] = new Binding(this, function () : Boolean
            {
                return hostComponent.toolbarVisible;
            }// end function
            , null, "drawDropDownList.visible");
            result[23] = new Binding(this, function () : Boolean
            {
                if (hostComponent.updateGeometryEnabled)
                {
                }
                return getNumFeatureLayers(hostComponent.featureLayers) > 0;
            }// end function
            , null, "cutButton.enabled");
            result[24] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarCutVisible;
            }// end function
            , null, "cutButton.includeInLayout");
            result[25] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorCutTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "cutButton.toolTip");
            result[26] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarCutVisible;
            }// end function
            , null, "cutButton.visible");
            result[27] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarMergeVisible;
            }// end function
            , null, "mergeButton.includeInLayout");
            result[28] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorMergeTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "mergeButton.toolTip");
            result[29] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarMergeVisible;
            }// end function
            , null, "mergeButton.visible");
            result[30] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarReshapeVisible;
            }// end function
            , null, "reshapeButton.includeInLayout");
            result[31] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorReshapeTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "reshapeButton.toolTip");
            result[32] = new Binding(this, function () : Boolean
            {
                if (hostComponent.toolbarVisible)
                {
                }
                return hostComponent.toolbarReshapeVisible;
            }// end function
            , null, "reshapeButton.visible");
            result[33] = new Binding(this, function () : Boolean
            {
                return hostComponent.undoAndRedoItemLimit > 0;
            }// end function
            , null, "undoButton.includeInLayout");
            result[34] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorUndoTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "undoButton.toolTip");
            result[35] = new Binding(this, function () : Boolean
            {
                return hostComponent.undoAndRedoItemLimit > 0;
            }// end function
            , null, "undoButton.visible");
            result[36] = new Binding(this, function () : Boolean
            {
                return hostComponent.undoAndRedoItemLimit > 0;
            }// end function
            , null, "redoButton.includeInLayout");
            result[37] = new Binding(this, function () : String
            {
                var _loc_1:* = resourceManager.getString("ESRIMessages", "editorRedoTooltip");
                return _loc_1 == undefined ? (null) : (String(_loc_1));
            }// end function
            , null, "redoButton.toolTip");
            result[38] = new Binding(this, function () : Boolean
            {
                return hostComponent.undoAndRedoItemLimit > 0;
            }// end function
            , null, "redoButton.visible");
            result[39] = new Binding(this, function () : Object
            {
                return loader;
            }// end function
            , null, "_EditorSkin_SWFLoader1.source");
            result[40] = new Binding(this, null, function (_sourceFunctionReturnValue) : void
            {
                operationCompleteLabel.setStyle("hideEffect", _sourceFunctionReturnValue);
                return;
            }// end function
            , "operationCompleteLabel.hideEffect", "fade");
            return result;
        }// end function

        public function get _EditorSkin_Group1() : Group
        {
            return this._854744984_EditorSkin_Group1;
        }// end function

        public function set _EditorSkin_Group1(value:Group) : void
        {
            var _loc_2:* = this._854744984_EditorSkin_Group1;
            if (_loc_2 !== value)
            {
                this._854744984_EditorSkin_Group1 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorSkin_Group1", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get _EditorSkin_HGroup2() : HGroup
        {
            return this._1068241915_EditorSkin_HGroup2;
        }// end function

        public function set _EditorSkin_HGroup2(value:HGroup) : void
        {
            var _loc_2:* = this._1068241915_EditorSkin_HGroup2;
            if (_loc_2 !== value)
            {
                this._1068241915_EditorSkin_HGroup2 = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "_EditorSkin_HGroup2", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get autoCompleteIcon() : Object
        {
            return this._1043447969autoCompleteIcon;
        }// end function

        public function set autoCompleteIcon(value:Object) : void
        {
            var _loc_2:* = this._1043447969autoCompleteIcon;
            if (_loc_2 !== value)
            {
                this._1043447969autoCompleteIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "autoCompleteIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get circleIcon() : Object
        {
            return this._1111194263circleIcon;
        }// end function

        public function set circleIcon(value:Object) : void
        {
            var _loc_2:* = this._1111194263circleIcon;
            if (_loc_2 !== value)
            {
                this._1111194263circleIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "circleIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get clearSelectionButton() : Button
        {
            return this._569977297clearSelectionButton;
        }// end function

        public function set clearSelectionButton(value:Button) : void
        {
            var _loc_2:* = this._569977297clearSelectionButton;
            if (_loc_2 !== value)
            {
                this._569977297clearSelectionButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "clearSelectionButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get cutButton() : ToggleButton
        {
            return this._1073372180cutButton;
        }// end function

        public function set cutButton(value:ToggleButton) : void
        {
            var _loc_2:* = this._1073372180cutButton;
            if (_loc_2 !== value)
            {
                this._1073372180cutButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cutButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get deleteButton() : Button
        {
            return this._1245745987deleteButton;
        }// end function

        public function set deleteButton(value:Button) : void
        {
            var _loc_2:* = this._1245745987deleteButton;
            if (_loc_2 !== value)
            {
                this._1245745987deleteButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleteButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get drawDropDownList() : DropDownList
        {
            return this._274208723drawDropDownList;
        }// end function

        public function set drawDropDownList(value:DropDownList) : void
        {
            var _loc_2:* = this._274208723drawDropDownList;
            if (_loc_2 !== value)
            {
                this._274208723drawDropDownList = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "drawDropDownList", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get ellipseIcon() : Object
        {
            return this._468079241ellipseIcon;
        }// end function

        public function set ellipseIcon(value:Object) : void
        {
            var _loc_2:* = this._468079241ellipseIcon;
            if (_loc_2 !== value)
            {
                this._468079241ellipseIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ellipseIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get extentIcon() : Object
        {
            return this._1809462589extentIcon;
        }// end function

        public function set extentIcon(value:Object) : void
        {
            var _loc_2:* = this._1809462589extentIcon;
            if (_loc_2 !== value)
            {
                this._1809462589extentIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "extentIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get fade() : Fade
        {
            return this._3135100fade;
        }// end function

        public function set fade(value:Fade) : void
        {
            var _loc_2:* = this._3135100fade;
            if (_loc_2 !== value)
            {
                this._3135100fade = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fade", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get freehandLineIcon() : Object
        {
            return this._774807416freehandLineIcon;
        }// end function

        public function set freehandLineIcon(value:Object) : void
        {
            var _loc_2:* = this._774807416freehandLineIcon;
            if (_loc_2 !== value)
            {
                this._774807416freehandLineIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "freehandLineIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get freehandPolygonIcon() : Object
        {
            return this._102906104freehandPolygonIcon;
        }// end function

        public function set freehandPolygonIcon(value:Object) : void
        {
            var _loc_2:* = this._102906104freehandPolygonIcon;
            if (_loc_2 !== value)
            {
                this._102906104freehandPolygonIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "freehandPolygonIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get lineIcon() : Object
        {
            return this._1188316813lineIcon;
        }// end function

        public function set lineIcon(value:Object) : void
        {
            var _loc_2:* = this._1188316813lineIcon;
            if (_loc_2 !== value)
            {
                this._1188316813lineIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get mapPointIcon() : Object
        {
            return this._1713012781mapPointIcon;
        }// end function

        public function set mapPointIcon(value:Object) : void
        {
            var _loc_2:* = this._1713012781mapPointIcon;
            if (_loc_2 !== value)
            {
                this._1713012781mapPointIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mapPointIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get mergeButton() : Button
        {
            return this._293032566mergeButton;
        }// end function

        public function set mergeButton(value:Button) : void
        {
            var _loc_2:* = this._293032566mergeButton;
            if (_loc_2 !== value)
            {
                this._293032566mergeButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mergeButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get operationCompleteLabel() : Label
        {
            return this._1716202732operationCompleteLabel;
        }// end function

        public function set operationCompleteLabel(value:Label) : void
        {
            var _loc_2:* = this._1716202732operationCompleteLabel;
            if (_loc_2 !== value)
            {
                this._1716202732operationCompleteLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "operationCompleteLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get operationStartLabel() : Label
        {
            return this._324113529operationStartLabel;
        }// end function

        public function set operationStartLabel(value:Label) : void
        {
            var _loc_2:* = this._324113529operationStartLabel;
            if (_loc_2 !== value)
            {
                this._324113529operationStartLabel = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "operationStartLabel", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pointToPointLineIcon() : Object
        {
            return this._808926766pointToPointLineIcon;
        }// end function

        public function set pointToPointLineIcon(value:Object) : void
        {
            var _loc_2:* = this._808926766pointToPointLineIcon;
            if (_loc_2 !== value)
            {
                this._808926766pointToPointLineIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pointToPointLineIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get pointToPointPolygonIcon() : Object
        {
            return this._1560599406pointToPointPolygonIcon;
        }// end function

        public function set pointToPointPolygonIcon(value:Object) : void
        {
            var _loc_2:* = this._1560599406pointToPointPolygonIcon;
            if (_loc_2 !== value)
            {
                this._1560599406pointToPointPolygonIcon = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pointToPointPolygonIcon", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get redoButton() : Button
        {
            return this._1120171728redoButton;
        }// end function

        public function set redoButton(value:Button) : void
        {
            var _loc_2:* = this._1120171728redoButton;
            if (_loc_2 !== value)
            {
                this._1120171728redoButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "redoButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get reshapeButton() : ToggleButton
        {
            return this._1452247584reshapeButton;
        }// end function

        public function set reshapeButton(value:ToggleButton) : void
        {
            var _loc_2:* = this._1452247584reshapeButton;
            if (_loc_2 !== value)
            {
                this._1452247584reshapeButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "reshapeButton", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get selectionDropDownList() : DropDownList
        {
            return this._2030751717selectionDropDownList;
        }// end function

        public function set selectionDropDownList(value:DropDownList) : void
        {
            var _loc_2:* = this._2030751717selectionDropDownList;
            if (_loc_2 !== value)
            {
                this._2030751717selectionDropDownList = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectionDropDownList", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get templatePicker() : TemplatePicker
        {
            return this._1725694552templatePicker;
        }// end function

        public function set templatePicker(value:TemplatePicker) : void
        {
            var _loc_2:* = this._1725694552templatePicker;
            if (_loc_2 !== value)
            {
                this._1725694552templatePicker = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "templatePicker", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get undoButton() : Button
        {
            return this._1443410230undoButton;
        }// end function

        public function set undoButton(value:Button) : void
        {
            var _loc_2:* = this._1443410230undoButton;
            if (_loc_2 !== value)
            {
                this._1443410230undoButton = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "undoButton", _loc_2, value));
                }
            }
            return;
        }// end function

        private function get loader() : Class
        {
            return this._1097519085loader;
        }// end function

        private function set loader(value:Class) : void
        {
            var _loc_2:* = this._1097519085loader;
            if (_loc_2 !== value)
            {
                this._1097519085loader = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "loader", _loc_2, value));
                }
            }
            return;
        }// end function

        public function get hostComponent() : Editor
        {
            return this._213507019hostComponent;
        }// end function

        public function set hostComponent(value:Editor) : void
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
