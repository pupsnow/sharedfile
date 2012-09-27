package com.lhyx.presentermanager
{
	import com.spring.facade.ApplicationFacade;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	/**
	 * 
	 * @author AndriyHuang
	 * 2012-9-24 下午9:27:00
	 */
	public class MainPM
	{
		public static const NAME:String = "MainPM";
		
		private var _layout:LayoutBase;
		private var _showStatusBar:Boolean = true;
		
		private var _menuViewPM:MenuViewPM;
		private var _operationAreaPM:OperationAreaPM;
		
		public function MainPM()
		{
		}
		
		public function set layout(value:LayoutBase):void
		{
			_layout = value;
		}
		
		public function set showStatusBar(value:Boolean):void
		{
			_showStatusBar = value;
		}
		
		public function get main():Main
		{
			return FlexGlobals.topLevelApplication as Main;
		}
		
		public function set menuViewPM(value:MenuViewPM):void
		{
			_menuViewPM = value;
		}
		
		public function set operationAreaPM(value:OperationAreaPM):void
		{
			_operationAreaPM = value;
		}
		
		/**
		 * Initialization application.
		 * 
		 */		
		public function initAppHandler():void
		{
			try
			{
				this.main.showStatusBar = this._showStatusBar;
				
				if (this._layout) 
				{
					this.main.layout = this._layout;
				}
				
				if (this._menuViewPM && this._menuViewPM.menuView) 
				{
					this.main.addElement(_menuViewPM.menuView);
				}
				
				if (this._operationAreaPM && this._operationAreaPM.operationArea) 
				{
					this.main.addElement(this._operationAreaPM.operationArea);
				}
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
	}
}