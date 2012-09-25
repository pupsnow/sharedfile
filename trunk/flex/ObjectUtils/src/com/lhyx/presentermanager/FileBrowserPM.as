package com.lhyx.presentermanager
{
	import com.lhyx.components.FileBrowser;

	public class FileBrowserPM
	{
		private var _fileBrowser:FileBrowser;
		
		public function FileBrowserPM()
		{
		}

		public function get fileBrowser():FileBrowser
		{
			return _fileBrowser;
		}

		public function set fileBrowser(value:FileBrowser):void
		{
			_fileBrowser = value;
		}
	}
}