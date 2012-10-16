package com.esri.ags.layers.supportClasses
{

    class DomainFactory extends Object
    {

        function DomainFactory()
        {
            return;
        }// end function

        public static function toDomain(obj:Object) : IDomain
        {
            var _loc_2:IDomain = null;
            if (obj)
            {
                if (obj.type == "codedValue")
                {
                    _loc_2 = CodedValueDomain.toCodedValueDomain(obj);
                }
                else if (obj.type == "range")
                {
                    _loc_2 = RangeDomain.toRangeDomain(obj);
                }
                else if (obj.type == "inherited")
                {
                    _loc_2 = new InheritedDomain();
                }
            }
            return _loc_2;
        }// end function

    }
}
