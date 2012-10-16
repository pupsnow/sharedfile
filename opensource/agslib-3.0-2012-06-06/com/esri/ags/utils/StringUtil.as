package com.esri.ags.utils
{

    public class StringUtil extends Object
    {
        private static const PATTERN:RegExp = /\{([^\}]+)\}/g;

        public function StringUtil()
        {
            return;
        }// end function

        public static function substitute(template:String, data:Object) : String
        {
            var template:* = template;
            var data:* = data;
            var result:* = template;
            if (template)
            {
            }
            if (data)
            {
                var replFN:* = function (... args) : String
            {
                args = data[args[1]];
                if (args == null)
                {
                    args = "";
                }
                return args;
            }// end function
            ;
                result = template.replace(PATTERN, replFN);
            }
            return result;
        }// end function

    }
}
