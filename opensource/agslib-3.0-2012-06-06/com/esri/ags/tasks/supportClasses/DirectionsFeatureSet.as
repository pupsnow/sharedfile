package com.esri.ags.tasks.supportClasses
{
    import com.esri.ags.*;
    import com.esri.ags.geometry.*;
    import mx.events.*;

    public class DirectionsFeatureSet extends FeatureSet
    {
        private var _1289044182extent:Extent;
        private var _1473733566mergedGeometry:Polyline;
        private var _1385647428routeId:String;
        private var _167466100routeName:String;
        private var _546947949totalDriveTime:Number;
        private var _949911734totalLength:Number;
        private var _577281999totalTime:Number;

        public function DirectionsFeatureSet()
        {
            return;
        }// end function

        public function get extent() : Extent
        {
            return this._1289044182extent;
        }// end function

        public function set extent(value:Extent) : void
        {
            arguments = this._1289044182extent;
            if (arguments !== value)
            {
                this._1289044182extent = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "extent", arguments, value));
                }
            }
            return;
        }// end function

        public function get mergedGeometry() : Polyline
        {
            return this._1473733566mergedGeometry;
        }// end function

        public function set mergedGeometry(value:Polyline) : void
        {
            arguments = this._1473733566mergedGeometry;
            if (arguments !== value)
            {
                this._1473733566mergedGeometry = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mergedGeometry", arguments, value));
                }
            }
            return;
        }// end function

        public function get routeId() : String
        {
            return this._1385647428routeId;
        }// end function

        public function set routeId(value:String) : void
        {
            arguments = this._1385647428routeId;
            if (arguments !== value)
            {
                this._1385647428routeId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "routeId", arguments, value));
                }
            }
            return;
        }// end function

        public function get routeName() : String
        {
            return this._167466100routeName;
        }// end function

        public function set routeName(value:String) : void
        {
            arguments = this._167466100routeName;
            if (arguments !== value)
            {
                this._167466100routeName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "routeName", arguments, value));
                }
            }
            return;
        }// end function

        public function get totalDriveTime() : Number
        {
            return this._546947949totalDriveTime;
        }// end function

        public function set totalDriveTime(value:Number) : void
        {
            arguments = this._546947949totalDriveTime;
            if (arguments !== value)
            {
                this._546947949totalDriveTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "totalDriveTime", arguments, value));
                }
            }
            return;
        }// end function

        public function get totalLength() : Number
        {
            return this._949911734totalLength;
        }// end function

        public function set totalLength(value:Number) : void
        {
            arguments = this._949911734totalLength;
            if (arguments !== value)
            {
                this._949911734totalLength = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "totalLength", arguments, value));
                }
            }
            return;
        }// end function

        public function get totalTime() : Number
        {
            return this._577281999totalTime;
        }// end function

        public function set totalTime(value:Number) : void
        {
            arguments = this._577281999totalTime;
            if (arguments !== value)
            {
                this._577281999totalTime = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "totalTime", arguments, value));
                }
            }
            return;
        }// end function

    }
}
