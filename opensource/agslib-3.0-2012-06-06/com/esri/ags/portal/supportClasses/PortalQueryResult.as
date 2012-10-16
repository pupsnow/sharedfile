package com.esri.ags.portal.supportClasses
{
    import flash.events.*;

    public class PortalQueryResult extends EventDispatcher
    {
        private var m_previousQueryParameters:PortalQueryParameters;
        private var m_queryParameters:PortalQueryParameters;
        private var m_nextQueryParameters:PortalQueryParameters;
        private var m_totalResults:uint;
        private var m_results:Array;

        public function PortalQueryResult(queryParameters:PortalQueryParameters, nextQueryParameters:PortalQueryParameters, totalResults:uint, results:Array)
        {
            this.m_queryParameters = queryParameters;
            this.m_nextQueryParameters = nextQueryParameters;
            this.m_totalResults = totalResults;
            this.m_results = results;
            return;
        }// end function

        public function get previousQueryParameters() : PortalQueryParameters
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this.queryParameters)
            {
            }
            if (this.queryParameters.startIndex == 1)
            {
                this.m_previousQueryParameters = null;
            }
            else if (!this.m_previousQueryParameters)
            {
                this.m_previousQueryParameters = this.m_queryParameters.clone();
                _loc_1 = this.m_previousQueryParameters.startIndex;
                _loc_2 = this.m_previousQueryParameters.limit;
                _loc_3 = _loc_1 - _loc_2;
                if (_loc_3 < 0)
                {
                    _loc_1 = 0;
                }
                else
                {
                    _loc_1 = _loc_3;
                }
                this.m_previousQueryParameters.startIndex = _loc_1;
            }
            return this.m_previousQueryParameters;
        }// end function

        public function get hasPrevious() : Boolean
        {
            return this.previousQueryParameters !== null;
        }// end function

        public function get queryParameters() : PortalQueryParameters
        {
            return this.m_queryParameters;
        }// end function

        public function get nextQueryParameters() : PortalQueryParameters
        {
            return this.m_nextQueryParameters;
        }// end function

        public function get hasNext() : Boolean
        {
            return this.nextQueryParameters !== null;
        }// end function

        public function get totalResults() : uint
        {
            return this.m_totalResults;
        }// end function

        public function get results() : Array
        {
            return this.m_results;
        }// end function

    }
}
