package com.lhyx.presentermanager
{
	import com.lhyx.components.OperationArea;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;

	public class OperationAreaPM
	{
		private var _operationArea:OperationArea;
		private var _fileBrowserPM:FileBrowserPM;
		
		public function OperationAreaPM()
		{
		}

		public function get operationArea():OperationArea
		{
			return _operationArea;
		}

		public function set operationArea(value:OperationArea):void
		{
			_operationArea = value;
		}

		public function set fileBrowserPM(value:FileBrowserPM):void
		{
			_fileBrowserPM = value;
			this._operationArea.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			try
			{
				if (this._fileBrowserPM && this._fileBrowserPM.fileBrowser) 
				{
					this._operationArea.addElement(this._fileBrowserPM.fileBrowser);
				}
				
				if (this._operationArea.logLabel) 
				{
					this._operationArea.addElement(this._operationArea.logLabel);
				}
				
				if (this._operationArea.logTextArea) 
				{
					this._operationArea.addElement(this._operationArea.logTextArea);
				}
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
	}
}