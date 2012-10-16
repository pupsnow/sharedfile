package com.esri.ags.tasks.supportClasses
{
    import flash.events.*;
    import mx.collections.*;

    public class PrintServiceInfo extends EventDispatcher
    {
        private var _defaultFormat:String;
        private var _defaultLayoutTemplate:String;
        private var _formats:IList;
        private var _hasResultData:Boolean;
        private var _isServiceAsynchronous:Boolean;
        private var _layoutTemplates:IList;

        public function PrintServiceInfo()
        {
            return;
        }// end function

        public function get defaultFormat() : String
        {
            return this._defaultFormat;
        }// end function

        public function set defaultFormat(value:String) : void
        {
            if (this._defaultFormat !== value)
            {
                this._defaultFormat = value;
                dispatchEvent(new Event("defaultFormatChanged"));
            }
            return;
        }// end function

        public function get defaultLayoutTemplate() : String
        {
            return this._defaultLayoutTemplate;
        }// end function

        public function set defaultLayoutTemplate(value:String) : void
        {
            if (this._defaultLayoutTemplate !== value)
            {
                this._defaultLayoutTemplate = value;
                dispatchEvent(new Event("defaultLayoutTemplateChanged"));
            }
            return;
        }// end function

        public function get formats() : IList
        {
            return this._formats;
        }// end function

        public function set formats(value:IList) : void
        {
            this._formats = value;
            dispatchEvent(new Event("formatsChanged"));
            return;
        }// end function

        public function get hasResultData() : Boolean
        {
            return this._hasResultData;
        }// end function

        public function set hasResultData(value:Boolean) : void
        {
            if (this._hasResultData !== value)
            {
                this._hasResultData = value;
                dispatchEvent(new Event("hasResultDataChanged"));
            }
            return;
        }// end function

        public function get isServiceAsynchronous() : Boolean
        {
            return this._isServiceAsynchronous;
        }// end function

        public function set isServiceAsynchronous(value:Boolean) : void
        {
            if (this._isServiceAsynchronous !== value)
            {
                this._isServiceAsynchronous = value;
                dispatchEvent(new Event("isServiceAsynchronousChanged"));
            }
            return;
        }// end function

        public function get layoutTemplates() : IList
        {
            return this._layoutTemplates;
        }// end function

        public function set layoutTemplates(value:IList) : void
        {
            this._layoutTemplates = value;
            dispatchEvent(new Event("layoutTemplatesChanged"));
            return;
        }// end function

        static function fromJSON(obj:Object) : PrintServiceInfo
        {
            var _loc_2:PrintServiceInfo = null;
            var _loc_3:Object = null;
            if (obj)
            {
                _loc_2 = new PrintServiceInfo;
                _loc_2.isServiceAsynchronous = obj.executionType == "esriExecutionTypeAsynchronous";
                if (obj.parameters is Array)
                {
                    for each (_loc_3 in obj.parameters)
                    {
                        
                        if (_loc_3.name == "Output_File")
                        {
                        }
                        if (_loc_3.direction == "esriGPParameterDirectionOutput")
                        {
                            _loc_2.hasResultData = true;
                            continue;
                        }
                        if (_loc_3.choiceList is Array)
                        {
                            if (_loc_3.name == "Format")
                            {
                                _loc_2.defaultFormat = _loc_3.defaultValue;
                                _loc_2.formats = new ArrayList(_loc_3.choiceList);
                                continue;
                            }
                            if (_loc_3.name == "Layout_Template")
                            {
                                _loc_2.defaultLayoutTemplate = _loc_3.defaultValue;
                                _loc_2.layoutTemplates = new ArrayList(_loc_3.choiceList);
                            }
                        }
                    }
                }
            }
            return _loc_2;
        }// end function

    }
}
