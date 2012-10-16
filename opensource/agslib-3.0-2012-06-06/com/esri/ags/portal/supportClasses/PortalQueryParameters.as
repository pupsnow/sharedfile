package com.esri.ags.portal.supportClasses
{
    import mx.utils.*;

    public class PortalQueryParameters extends Object
    {
        private var m_query:String = null;
        private var m_limit:uint = 10;
        public var sortField:String = null;
        public var sortOrder:String = null;
        public var startIndex:uint = 1;
        public static const ASCENDING_SORT:String = "asc";
        public static const DESCENDING_SORT:String = "desc";

        public function PortalQueryParameters(query:String = null, limit:uint = 10, sortField:String = null, sortOrder:String = null, startIndex:uint = 1)
        {
            this.query = query;
            this.limit = limit;
            this.sortField = sortField;
            this.sortOrder = sortOrder;
            this.startIndex = startIndex;
            return;
        }// end function

        public function get query() : String
        {
            return this.m_query;
        }// end function

        public function set query(value:String) : void
        {
            this.m_query = value;
            return;
        }// end function

        public function get limit() : uint
        {
            return this.m_limit;
        }// end function

        public function set limit(value:uint) : void
        {
            if (value > 0)
            {
                if (value <= 100)
                {
                    this.m_limit = value;
                }
                else
                {
                    this.m_limit = 100;
                }
            }
            return;
        }// end function

        public function withQuery(query:String) : PortalQueryParameters
        {
            this.query = query;
            return this;
        }// end function

        public function withLimit(limit:uint) : PortalQueryParameters
        {
            this.limit = limit;
            return this;
        }// end function

        public function withSortField(sortField:String) : PortalQueryParameters
        {
            this.sortField = sortField;
            return this;
        }// end function

        public function withSortOrder(sortOrder:String) : PortalQueryParameters
        {
            this.sortOrder = sortOrder;
            return this;
        }// end function

        public function withStartIndex(startIndex:uint) : PortalQueryParameters
        {
            this.startIndex = startIndex;
            return this;
        }// end function

        public function inGroup(groupId:String) : PortalQueryParameters
        {
            if (groupId != null)
            {
            }
            var _loc_2:* = groupId != "";
            if (_loc_2)
            {
                this.addQueryCondition("group:" + groupId);
            }
            return this;
        }// end function

        public function withId(id:String) : PortalQueryParameters
        {
            if (id != null)
            {
            }
            var _loc_2:* = id != "";
            if (_loc_2)
            {
                this.addQueryCondition("id:" + id);
            }
            return this;
        }// end function

        public function ofUser(username:String) : PortalQueryParameters
        {
            if (username != null)
            {
            }
            var _loc_2:* = username != "";
            if (_loc_2)
            {
                this.addQueryCondition("owner:" + username);
            }
            return this;
        }// end function

        public function ofType(type:String) : PortalQueryParameters
        {
            if (type != null)
            {
            }
            var _loc_2:* = type != "";
            if (_loc_2)
            {
                if (type === PortalItem.TYPE_WEB_MAP)
                {
                    this.addQueryCondition(StringUtil.substitute("(+type:\"{0}\" -type:\"{1}\")", PortalItem.TYPE_WEB_MAP, PortalItem.TYPE_WEB_MAPPING_APPLICATION));
                }
                else
                {
                    this.addQueryCondition(StringUtil.substitute("type:\"{0}\"", type));
                }
            }
            return this;
        }// end function

        public function addQueryCondition(condition:String, operator:String = "AND") : PortalQueryParameters
        {
            if (!condition)
            {
                return this;
            }
            var _loc_3:* = operator.toUpperCase();
            if (_loc_3 != "AND")
            {
            }
            if (_loc_3 != "OR")
            {
            }
            if (_loc_3 != "+")
            {
            }
            if (_loc_3 != "NOT")
            {
            }
            if (_loc_3 != "-")
            {
                _loc_3 = "AND";
            }
            if (["AND", "OR", "NOT"].lastIndexOf(_loc_3) != -1)
            {
                _loc_3 = _loc_3 + " ";
            }
            if (this.query)
            {
            }
            if (this.query.length > 0)
            {
                this.query = this.query + (" " + _loc_3 + condition);
            }
            else
            {
                this.query = condition;
            }
            return this;
        }// end function

        public function clone() : PortalQueryParameters
        {
            return new PortalQueryParameters(this.query, this.limit, this.sortField, this.sortOrder, this.startIndex);
        }// end function

        public function toString() : String
        {
            return StringUtil.substitute("PortalQueryParameters[query={0}, startIndex={1}, limit={2}, sortField={3}, sortOrder={4}]", this.query, this.startIndex, this.limit, this.sortField, this.sortOrder);
        }// end function

        public static function forItemsInGroup(groupId:String) : PortalQueryParameters
        {
            var _loc_2:* = new PortalQueryParameters;
            _loc_2.inGroup(groupId);
            return _loc_2;
        }// end function

        public static function forItemsOfTypeWithOwner(type:String, username:String) : PortalQueryParameters
        {
            var _loc_3:* = new PortalQueryParameters;
            _loc_3.ofUser(username).ofType(type);
            return _loc_3;
        }// end function

        public static function forItemWithId(itemId:String) : PortalQueryParameters
        {
            var _loc_2:* = new PortalQueryParameters;
            _loc_2.withId(itemId);
            return _loc_2;
        }// end function

        public static function forQuery(query:String) : PortalQueryParameters
        {
            var _loc_2:* = new PortalQueryParameters;
            _loc_2.withQuery(query);
            return _loc_2;
        }// end function

    }
}
