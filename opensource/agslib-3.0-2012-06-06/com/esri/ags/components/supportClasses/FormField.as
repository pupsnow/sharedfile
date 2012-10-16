package com.esri.ags.components.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.events.*;
    import com.esri.ags.layers.*;
    import com.esri.ags.layers.supportClasses.*;
    import flash.display.*;
    import flash.events.*;
    import mx.core.*;

    public class FormField extends EventDispatcher
    {
        var order:int;
        private var m_fieldInspector:FieldInspector;
        private var m_formDescriptor:FormDescriptor;
        private var m_field:Field;
        private var m_formItemLabelFunction:Function;
        private var m_createFormItemComponentFunction:Function;
        private var m_label:String;

        public function FormField(field:Field, fieldInspector:FieldInspector, formOptions:FormDescriptor)
        {
            this.m_formDescriptor = formOptions;
            this.m_field = field;
            this.m_fieldInspector = fieldInspector;
            this.m_formDescriptor.addEventListener(FormFieldEvent.DATA_CHANGE, this.formOptionsChangeHandler, false, 0, true);
            this.m_formDescriptor.addEventListener(FormFieldEvent.RENDERER_CHANGE, this.formOptionsChangeHandler, false, 0, true);
            return;
        }// end function

        public function get field() : Field
        {
            return this.m_field;
        }// end function

        public function get featureLayer() : FeatureLayer
        {
            return this.m_formDescriptor.featureLayer;
        }// end function

        public function get feature() : Graphic
        {
            return this.m_formDescriptor.activeFeature;
        }// end function

        function set formItemLabelFunction(value:Function) : void
        {
            if (this.m_formItemLabelFunction !== value)
            {
                this.m_formItemLabelFunction = value;
                this.m_label = this.m_formItemLabelFunction(this.m_formDescriptor.featureLayer, this.m_field, this.m_fieldInspector);
                this.dispatchRendererChangeEvent();
            }
            return;
        }// end function

        function get formItemLabelFunction() : Function
        {
            return this.m_formItemLabelFunction;
        }// end function

        function set createFormItemComponentFunction(value:Function) : void
        {
            if (this.m_createFormItemComponentFunction !== value)
            {
                this.m_createFormItemComponentFunction = value;
                this.dispatchRendererChangeEvent();
            }
            return;
        }// end function

        function get createFormItemComponentFunction() : Function
        {
            return this.m_createFormItemComponentFunction;
        }// end function

        private function dispatchFieldDataChangeEvent() : void
        {
            if (hasEventListener(FormFieldEvent.DATA_CHANGE))
            {
                dispatchEvent(new FormFieldEvent(FormFieldEvent.DATA_CHANGE));
            }
            return;
        }// end function

        private function dispatchRendererChangeEvent() : void
        {
            if (hasEventListener(FormFieldEvent.RENDERER_CHANGE))
            {
                dispatchEvent(new FormFieldEvent(FormFieldEvent.RENDERER_CHANGE));
            }
            return;
        }// end function

        public function get label() : String
        {
            return this.m_label;
        }// end function

        public function get fieldData() : Object
        {
            var _loc_1:Object = null;
            if (this.m_formDescriptor)
            {
            }
            if (this.m_formDescriptor.activeFeature)
            {
            }
            if (this.m_formDescriptor.activeFeature.attributes)
            {
                _loc_1 = this.m_formDescriptor.activeFeature.attributes[this.m_field.name];
            }
            return _loc_1;
        }// end function

        public function get updateEnabled() : Boolean
        {
            return this.m_formDescriptor.updateEnabled;
        }// end function

        public function getRendererInstance() : UIComponent
        {
            var _loc_1:UIComponent = null;
            if (this.m_field)
            {
                _loc_1 = this.m_createFormItemComponentFunction(this.m_formDescriptor.featureLayer, this.m_field, this.m_fieldInspector, this.fieldData);
            }
            return _loc_1;
        }// end function

        public function updateRenderer(renderer:UIComponent) : void
        {
            this.updateFieldData(renderer, this.fieldData);
            return;
        }// end function

        function dispose() : void
        {
            this.m_formDescriptor.removeEventListener(FormFieldEvent.DATA_CHANGE, this.formOptionsChangeHandler);
            this.m_formDescriptor.removeEventListener(FormFieldEvent.RENDERER_CHANGE, this.formOptionsChangeHandler);
            return;
        }// end function

        private function formOptionsChangeHandler(event:FormFieldEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function updateFieldData(component:DisplayObject, value:Object) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:DisplayObject = null;
            if (component is IDataRenderer)
            {
                IDataRenderer(component).data = value;
            }
            var _loc_3:* = component as DisplayObjectContainer;
            if (_loc_3)
            {
                _loc_4 = _loc_3.numChildren;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = _loc_3.getChildAt(_loc_5);
                    this.updateFieldData(_loc_6, value);
                    _loc_5 = _loc_5 + 1;
                }
            }
            return;
        }// end function

    }
}
