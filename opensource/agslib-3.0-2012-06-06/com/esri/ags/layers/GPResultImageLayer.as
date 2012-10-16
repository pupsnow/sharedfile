package com.esri.ags.layers
{
    import com.esri.ags.components.*;
    import com.esri.ags.components.supportClasses.*;
    import com.esri.ags.layers.supportClasses.*;
    import com.esri.ags.utils.*;
    import flash.display.*;
    import flash.net.*;
    import mx.events.*;

    public class GPResultImageLayer extends DynamicMapServiceLayer
    {
        var credential:Credential;
        private var _dpi:Number = 96;
        private var _imageFormat:String = "png8";
        private var _imageTransparency:Boolean = true;
        private var _jobId:String;
        private var _jobIdChanged:Boolean;
        private var _parameterName:String;
        private var _parameterNameChanged:Boolean;
        private var _proxyURLObj:URL;
        private var _110541305token:String;
        private var _urlChanged:Boolean;
        const urlObj:URL;

        public function GPResultImageLayer(url:String = null)
        {
            this._proxyURLObj = new URL();
            this.urlObj = new URL();
            this.url = url;
            return;
        }// end function

        public function get dpi() : Number
        {
            return this._dpi;
        }// end function

        private function set _99677dpi(value:Number) : void
        {
            if (this._dpi != value)
            {
                this._dpi = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get imageFormat() : String
        {
            return this._imageFormat;
        }// end function

        private function set _1798561074imageFormat(value:String) : void
        {
            if (this._imageFormat != value)
            {
                this._imageFormat = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get imageTransparency() : Boolean
        {
            return this._imageTransparency;
        }// end function

        private function set _1156376493imageTransparency(value:Boolean) : void
        {
            if (this._imageTransparency != value)
            {
                this._imageTransparency = value;
                invalidateLayer();
            }
            return;
        }// end function

        public function get jobId() : String
        {
            return this._jobId;
        }// end function

        private function set _101296568jobId(value:String) : void
        {
            if (this.jobId != value)
            {
                this._jobId = value;
                this._jobIdChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get parameterName() : String
        {
            return this._parameterName;
        }// end function

        private function set _379607596parameterName(value:String) : void
        {
            if (this.parameterName != value)
            {
                this._parameterName = value;
                this._parameterNameChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        public function get proxyURL() : String
        {
            return this._proxyURLObj.sourceURL;
        }// end function

        private function set _985186271proxyURL(value:String) : void
        {
            this._proxyURLObj.update(value);
            return;
        }// end function

        public function get url() : String
        {
            return this.urlObj.sourceURL;
        }// end function

        private function set _116079url(value:String) : void
        {
            if (this.url != value)
            {
                this.urlObj.update(value);
                this._urlChanged = true;
                invalidateProperties();
            }
            return;
        }// end function

        override protected function commitProperties() : void
        {
            super.commitProperties();
            if (this._urlChanged)
            {
                this.credential = IdentityManager.instance.findCredential(this.urlObj.path);
            }
            if (!this._jobIdChanged)
            {
            }
            if (!this._parameterNameChanged)
            {
            }
            if (this._urlChanged)
            {
                this._jobIdChanged = false;
                this._parameterNameChanged = false;
                this._urlChanged = false;
                removeAllChildren();
                if (this.jobId)
                {
                }
                if (this.parameterName)
                {
                }
                if (this.url)
                {
                    setLoaded(true);
                    invalidateLayer();
                }
                else
                {
                    setLoaded(false);
                }
            }
            return;
        }// end function

        override protected function loadMapImage(loader:Loader) : void
        {
            var _loc_2:* = new ImageParameters();
            _loc_2.extent = map.extent;
            _loc_2.dpi = this.dpi;
            _loc_2.format = this.imageFormat;
            _loc_2.height = map.height;
            _loc_2.width = map.width;
            _loc_2.transparent = this.imageTransparency;
            var _loc_3:* = new URLVariables();
            _loc_2.appendToURLVariables(_loc_3);
            _loc_3.f = "image";
            if (map.spatialReference)
            {
                _loc_3.bboxSR = map.spatialReference.toSR();
                _loc_3.imageSR = map.spatialReference.toSR();
            }
            var _loc_4:* = this.credential ? (this.credential.token) : (null);
            var _loc_5:* = AGSUtil.getURLRequest(this.urlObj, this.getPathSuffix(), _loc_3, this.token, this._proxyURLObj, null, _loc_4);
            loader.load(_loc_5);
            return;
        }// end function

        function getPathSuffix() : String
        {
            return "/jobs/" + this.jobId + "/results/" + this.parameterName;
        }// end function

        public function set proxyURL(value:String) : void
        {
            arguments = this.proxyURL;
            if (arguments !== value)
            {
                this._985186271proxyURL = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "proxyURL", arguments, value));
                }
            }
            return;
        }// end function

        public function set jobId(value:String) : void
        {
            arguments = this.jobId;
            if (arguments !== value)
            {
                this._101296568jobId = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "jobId", arguments, value));
                }
            }
            return;
        }// end function

        public function get token() : String
        {
            return this._110541305token;
        }// end function

        public function set token(value:String) : void
        {
            arguments = this._110541305token;
            if (arguments !== value)
            {
                this._110541305token = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "token", arguments, value));
                }
            }
            return;
        }// end function

        public function set imageFormat(value:String) : void
        {
            arguments = this.imageFormat;
            if (arguments !== value)
            {
                this._1798561074imageFormat = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageFormat", arguments, value));
                }
            }
            return;
        }// end function

        public function set imageTransparency(value:Boolean) : void
        {
            arguments = this.imageTransparency;
            if (arguments !== value)
            {
                this._1156376493imageTransparency = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageTransparency", arguments, value));
                }
            }
            return;
        }// end function

        public function set dpi(value:Number) : void
        {
            arguments = this.dpi;
            if (arguments !== value)
            {
                this._99677dpi = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dpi", arguments, value));
                }
            }
            return;
        }// end function

        public function set parameterName(value:String) : void
        {
            arguments = this.parameterName;
            if (arguments !== value)
            {
                this._379607596parameterName = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "parameterName", arguments, value));
                }
            }
            return;
        }// end function

        public function set url(value:String) : void
        {
            arguments = this.url;
            if (arguments !== value)
            {
                this._116079url = value;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "url", arguments, value));
                }
            }
            return;
        }// end function

    }
}
