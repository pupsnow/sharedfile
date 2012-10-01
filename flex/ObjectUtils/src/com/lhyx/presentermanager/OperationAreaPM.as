package com.lhyx.presentermanager
{
	import com.lhyx.components.OperationArea;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.springextensions.actionscript.core.event.EventBus;
	
	import spark.components.TextArea;

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
			this._operationArea.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
		}

		public function set fileBrowserPM(value:FileBrowserPM):void
		{
			_fileBrowserPM = value;
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
					this._operationArea.logTextArea.text += "启动应用程序！\n";
				}
				this.initViewEvent();
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
		
		private function initViewEvent():void
		{
			try
			{
				// Listener clear button mouse click event, ouput log text.
				this._fileBrowserPM.fileBrowser.clearButton.addEventListener(MouseEvent.CLICK,function(clearEvent:MouseEvent):void
				{
					_operationArea.logTextArea.text += "清除文件输入、输出框内容！\n";
					// Set scroll to bottom.
					_operationArea.logTextArea.validateNow();
					_operationArea.logTextArea.scroller.verticalScrollBar.value = _operationArea.logTextArea.scroller.verticalScrollBar.maximum;
				});
				
				EventBus.addEventListener(FileBrowserPM.INPUT_BROWSER_FILE_EVENT,function(inputChangeEvent:Event):void
				{
					EventBus.removeEventListener(FileBrowserPM.INPUT_BROWSER_FILE_EVENT,arguments.callmee);
					
					_fileBrowserPM.inputBrowserFile.addEventListener(Event.SELECT,function(inputSelectEvent:Event):void
					{
						if (inputSelectEvent.target is File) 
						{
							_operationArea.logTextArea.text += "您选择了输入文件：" + (inputSelectEvent.target as File).url + "\n";
						}
					});
					
					_fileBrowserPM.inputBrowserFile.addEventListener(Event.CANCEL,function(inputCancelEvent:Event):void
					{
						_operationArea.logTextArea.text += "取消选择输入文件！\n"
					});
				});
				
				EventBus.addEventListener(FileBrowserPM.OUTPUT_BROWSER_FILE_EVENT,function(outputChangeEvent:Event):void
				{
					EventBus.removeEventListener(FileBrowserPM.OUTPUT_BROWSER_FILE_EVENT,arguments.callmee);
					
					_fileBrowserPM.outputBrowserFile.addEventListener(Event.SELECT,function(outputSelectEvent:Event):void
					{
						if (outputSelectEvent.target is File) 
						{
							_operationArea.logTextArea.text += "您选择了输出目录：" + (outputSelectEvent.target as File).url + "\n";
						}
					});
					
					_fileBrowserPM.outputBrowserFile.addEventListener(Event.CANCEL,function(outputCancelEvent:Event):void
					{
						_operationArea.logTextArea.text += "取消选择输出目录！\n"
					});
				});
			} 
			catch(error:Error) 
			{
				throw error;
			}
		}
	}
}