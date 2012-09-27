package com.lhyx.presentermanager
{
	import com.lhyx.components.MenuView;
	import com.lhyx.utils.FilePathEnum;
	import com.lhyx.utils.FileUtils;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class MenuViewPM
	{
		private var _menuView:MenuView;
		
		public function MenuViewPM()
		{
		}

		public function get menuView():MenuView
		{
			return _menuView;
		}

		public function set menuView(value:MenuView):void
		{
			_menuView = value;
			this._menuView.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			var xmlFile:File = null;
			var xmlString:String = null;
			
			try
			{
				if (this._menuView.treeMenu) 
				{
					this._menuView.addElement(this._menuView.treeMenu);
				}
				
				xmlFile = File.applicationDirectory.resolvePath(FilePathEnum.TREE_MENU_FILE_PATH);
				xmlString = FileUtils.readFileByMultiByte(xmlFile);
				this._menuView.treeMenu.dataProvider = xmlString;
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
	}
}