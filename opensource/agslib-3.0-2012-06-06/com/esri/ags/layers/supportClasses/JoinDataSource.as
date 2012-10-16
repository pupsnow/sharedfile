package com.esri.ags.layers.supportClasses
{
    import com.esri.ags.utils.*;
    import flash.events.*;

    public class JoinDataSource extends EventDispatcher implements IDataSource, IJSONSupport
    {
        private var _joinType:String;
        private var _leftTableKey:String;
        private var _leftTableSource:ILayerSource;
        private var _rightTableKey:String;
        private var _rightTableSource:ILayerSource;
        public static const LEFT_INNER_JOIN:String = "esriLeftInnerJoin";
        public static const LEFT_OUTER_JOIN:String = "esriLeftOuterJoin";

        public function JoinDataSource()
        {
            return;
        }// end function

        public function get joinType() : String
        {
            return this._joinType;
        }// end function

        public function set joinType(value:String) : void
        {
            if (this._joinType !== value)
            {
                this._joinType = value;
                dispatchEvent(new Event("joinTypeChanged"));
            }
            return;
        }// end function

        public function get leftTableKey() : String
        {
            return this._leftTableKey;
        }// end function

        public function set leftTableKey(value:String) : void
        {
            if (this._leftTableKey !== value)
            {
                this._leftTableKey = value;
                dispatchEvent(new Event("leftTableKeyChanged"));
            }
            return;
        }// end function

        public function get leftTableSource() : ILayerSource
        {
            return this._leftTableSource;
        }// end function

        public function set leftTableSource(value:ILayerSource) : void
        {
            this._leftTableSource = value;
            dispatchEvent(new Event("leftTableSourceChanged"));
            return;
        }// end function

        public function get rightTableKey() : String
        {
            return this._rightTableKey;
        }// end function

        public function set rightTableKey(value:String) : void
        {
            if (this._rightTableKey !== value)
            {
                this._rightTableKey = value;
                dispatchEvent(new Event("rightTableKeyChanged"));
            }
            return;
        }// end function

        public function get rightTableSource() : ILayerSource
        {
            return this._rightTableSource;
        }// end function

        public function set rightTableSource(value:ILayerSource) : void
        {
            this._rightTableSource = value;
            dispatchEvent(new Event("rightTableSourceChanged"));
            return;
        }// end function

        public function toJSON(key:String = null) : Object
        {
            var _loc_2:Object = {type:"joinTable"};
            _loc_2.joinType = this.joinType;
            _loc_2.leftTableKey = this.leftTableKey;
            _loc_2.rightTableKey = this.rightTableKey;
            if (this.leftTableSource is IJSONSupport)
            {
                _loc_2.leftTableSource = (this.leftTableSource as IJSONSupport).toJSON();
            }
            if (this.rightTableSource is IJSONSupport)
            {
                _loc_2.rightTableSource = (this.rightTableSource as IJSONSupport).toJSON();
            }
            return _loc_2;
        }// end function

    }
}
