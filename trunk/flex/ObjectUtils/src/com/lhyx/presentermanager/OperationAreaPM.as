package com.lhyx.presentermanager
{
	import com.lhyx.components.OperationArea;

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
		}
	}
}