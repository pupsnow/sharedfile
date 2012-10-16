package com.esri.ags
{
    import com.esri.ags.utils.*;
    import flash.events.*;

    public class SpatialReference extends EventDispatcher implements IJSONSupport
    {
        private var _vcsWkid:Number;
        private var _wkid:Number;
        private var _wkt:String;
        private var m_toMeterFactor:Number;
        private var m_toMeterFactorChanged:Boolean = true;
        private static const SR_INFOS:Object = {};

        public function SpatialReference(wkid:Number = NaN, wkt:String = null)
        {
            this.wkid = wkid;
            this.wkt = wkt;
            return;
        }// end function

        public function get vcsWkid() : Number
        {
            return this._vcsWkid;
        }// end function

        public function set vcsWkid(value:Number) : void
        {
            if (this._vcsWkid !== value)
            {
                this._vcsWkid = value;
                dispatchEvent(new Event("vcsWkidChanged"));
            }
            return;
        }// end function

        public function get wkid() : Number
        {
            return this._wkid;
        }// end function

        public function set wkid(value:Number) : void
        {
            if (this._wkid !== value)
            {
                this._wkid = value;
                this.m_toMeterFactorChanged = true;
                dispatchEvent(new Event("wkidChanged"));
            }
            return;
        }// end function

        public function get wkt() : String
        {
            return this._wkt;
        }// end function

        public function set wkt(value:String) : void
        {
            if (this._wkt !== value)
            {
                this._wkt = value;
                this.m_toMeterFactorChanged = true;
                dispatchEvent(new Event("wktChanged"));
            }
            return;
        }// end function

        function get info() : SRInfo
        {
            return this.wkid ? (SR_INFOS[this.wkid]) : (null);
        }// end function

        function get toMeterFactor() : Number
        {
            var _loc_1:int = 0;
            var _loc_2:String = null;
            var _loc_3:Number = NaN;
            var _loc_4:Array = null;
            if (this.m_toMeterFactorChanged)
            {
                this.m_toMeterFactorChanged = false;
                _loc_1 = this.wkid;
                _loc_2 = this.wkt;
                if (_loc_1)
                {
                }
                if (_loc_1 in WKIDUnitConversion.WKIDS)
                {
                    _loc_3 = WKIDUnitConversion.VALUES[WKIDUnitConversion.WKIDS[_loc_1]];
                }
                else
                {
                    if (_loc_2)
                    {
                    }
                    if (_loc_2.search(/^PROJCS/i) !== -1)
                    {
                        _loc_4 = /UNIT\[([^\]]+)\]\]$/i.exec(_loc_2) as Array;
                        if (_loc_4)
                        {
                        }
                        if (_loc_4[1])
                        {
                            _loc_3 = parseFloat(_loc_4[1].split(",")[1]);
                        }
                    }
                    else
                    {
                        _loc_3 = ProjUtils.DECDEG_PER_METER;
                    }
                }
                this.m_toMeterFactor = _loc_3;
            }
            return this.m_toMeterFactor;
        }// end function

        function isWebMercator() : Boolean
        {
            return [102113, 102100, 3857].indexOf(this.wkid) !== -1;
        }// end function

        function isWrappable() : Boolean
        {
            return [102113, 102100, 3857, 4326].indexOf(this.wkid) !== -1;
        }// end function

        override public function toString() : String
        {
            var _loc_1:Array = [];
            if (!isNaN(this.vcsWkid))
            {
                _loc_1.push("vcsWkid=" + this.vcsWkid);
            }
            if (!isNaN(this.wkid))
            {
                _loc_1.push("wkid=" + this.wkid);
            }
            if (this.wkt)
            {
                _loc_1.push("wkt=" + this.wkt);
            }
            return "SpatialReference[" + _loc_1.join() + "]";
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {};
            if (!isNaN(this.vcsWkid))
            {
                _loc_2.vcsWkid = this.vcsWkid;
            }
            if (!isNaN(this.wkid))
            {
                _loc_2.wkid = this.wkid;
            }
            if (this.wkt)
            {
                _loc_2.wkt = this.wkt;
            }
            return _loc_2;
        }// end function

        function toSR() : String
        {
            var _loc_1:String = "";
            if (!isNaN(this.wkid))
            {
            }
            if (isNaN(this.vcsWkid))
            {
                _loc_1 = String(this.wkid);
            }
            else
            {
                if (!this.wkt)
                {
                }
                if (!isNaN(this.vcsWkid))
                {
                    _loc_1 = JSONUtil.encode(this.toJSON());
                }
            }
            return _loc_1;
        }// end function

        public static function fromJSON(obj:Object) : SpatialReference
        {
            var _loc_2:SpatialReference = null;
            if (obj)
            {
                _loc_2 = new SpatialReference;
                _loc_2.vcsWkid = obj.vcsWkid;
                _loc_2.wkid = obj.wkid;
                _loc_2.wkt = obj.wkt;
            }
            return _loc_2;
        }// end function

        SpatialReference.function () : void
        {
            var _loc_4:* = undefined;
            var _loc_1:* = "PROJCS[\"WGS_1984_Web_Mercator_Auxiliary_Sphere\",GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Mercator_Auxiliary_Sphere\"],PARAMETER[\"False_Easting\",0.0],PARAMETER[\"False_Northing\",0.0],PARAMETER[\"Central_Meridian\",{0}],PARAMETER[\"Standard_Parallel_1\",0.0],PARAMETER[\"Auxiliary_Sphere_Type\",0.0],UNIT[\"Meter\",1.0]]";
            var _loc_2:* = [-2.00375e+007, 2.00375e+007];
            var _loc_3:* = [-2.00375e+007, 2.00375e+007];
            _loc_4 = new SRInfo(102113);
            _loc_4.wkTemplate = "PROJCS[\"WGS_1984_Web_Mercator\",GEOGCS[\"GCS_WGS_1984_Major_Auxiliary_Sphere\",DATUM[\"D_WGS_1984_Major_Auxiliary_Sphere\",SPHEROID[\"WGS_1984_Major_Auxiliary_Sphere\",6378137.0,0.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Mercator\"],PARAMETER[\"False_Easting\",0.0],PARAMETER[\"False_Northing\",0.0],PARAMETER[\"Central_Meridian\",{0}],PARAMETER[\"Standard_Parallel_1\",0.0],UNIT[\"Meter\",1.0]]";
            _loc_4.valid = _loc_2;
            _loc_4.origin = _loc_3;
            SR_INFOS[_loc_4.wkid] = _loc_4;
            _loc_4 = new SRInfo(102100);
            _loc_4.wkTemplate = _loc_1;
            _loc_4.valid = _loc_2;
            _loc_4.origin = _loc_3;
            SR_INFOS[_loc_4.wkid] = _loc_4;
            _loc_4 = new SRInfo(3857);
            _loc_4.wkTemplate = _loc_1;
            _loc_4.valid = _loc_2;
            _loc_4.origin = _loc_3;
            SR_INFOS[_loc_4.wkid] = _loc_4;
            _loc_4 = new SRInfo(4326);
            _loc_4.wkTemplate = "GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",{0}],UNIT[\"Degree\",0.0174532925199433]]";
            _loc_4.altTemplate = "PROJCS[\"WGS_1984_Plate_Carree\",GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Plate_Carree\"],PARAMETER[\"False_Easting\",0.0],PARAMETER[\"False_Northing\",0.0],PARAMETER[\"Central_Meridian\",{0}],UNIT[\"Degrees\",111319.491]]";
            _loc_4.valid = [-180, 180];
            _loc_4.origin = [-180, 180];
            SR_INFOS[_loc_4.wkid] = _loc_4;
            return;
        }// end function
        ();
    }
}
