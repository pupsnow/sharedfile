package com.lhyx.presentermanager
{
	import com.lhyx.components.OperationArea;
	import com.lhyx.event.EventBase;
	import com.spring.facade.ApplicationFacade;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.springextensions.actionscript.core.event.EventBus;
	
	import spark.components.Group;
	import spark.components.TextArea;

	public class OperationAreaPM
	{
		/**
		 * This const value is 'DefaultView'.
		 */		
		public static const DEFAULT_VIEW:String = "DefaultView";
		
		/**
		 * This const value is 'OperationView'.
		 */		
		public static const OPERATION_VIEW:String = "OperationView";
		
		
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
			var operationView:Canvas = null;
			
			try
			{
				if (this._operationArea.viewStack) 
				{
					this._operationArea.addElement(this._operationArea.viewStack);
				}
				
				operationView = ApplicationFacade.getInstance().applicationContext.getObject(OPERATION_VIEW) as Canvas;
				
				if (operationView) 
				{
					if (this._fileBrowserPM && this._fileBrowserPM.fileBrowser) 
					{
						operationView.addElement(this._fileBrowserPM.fileBrowser);
					}
					
					if (this._operationArea.logLabel) 
					{
						operationView.addElement(this._operationArea.logLabel);
					}
					
					if (this._operationArea.logTextArea) 
					{
						operationView.addElement(this._operationArea.logTextArea);
						this._operationArea.logTextArea.text += "启动应用程序！\n";
					}
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
				this._operationArea.logTextArea.addEventListener("textChanged",function(contentChangeEvent:Event):void
				{
					// Set scroll to bottom.
					_operationArea.logTextArea.validateNow();
					_operationArea.logTextArea.scroller.verticalScrollBar.value = _operationArea.logTextArea.scroller.verticalScrollBar.maximum;
				});
				
				// Listener clear button mouse click event, ouput log text.
				this._fileBrowserPM.fileBrowser.clearButton.addEventListener(MouseEvent.CLICK,function(clearEvent:MouseEvent):void
				{
					_operationArea.logTextArea.text += "清除文件输入、输出框内容！\n";
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
				
				EventBus.addEventListener(FileBrowserPM.START_GENERATE_FILE_EVENT,function(startTransEvent:Event):void
				{
					EventBus.removeEventListener(FileBrowserPM.START_GENERATE_FILE_EVENT,arguments.callmee);
					
					_operationArea.logTextArea.text += "开始转换文件！\n请稍等......\n";
				});
				
				EventBus.addEventListener(FileBrowserPM.END_GENERATE_FILE_EVENT,function(endTransEvent:Event):void
				{
					EventBus.removeEventListener(FileBrowserPM.END_GENERATE_FILE_EVENT,arguments.callmee);
					
					_operationArea.logTextArea.text += "文件转换完成！\n";
				});
				
				EventBus.addEventListener(FileBrowserPM.ERROR_GENERATE_FILE_EVENT,function(errorTransEvent:EventBase):void
				{
					EventBus.removeEventListener(FileBrowserPM.ERROR_GENERATE_FILE_EVENT,arguments.callmee);
					
					_operationArea.logTextArea.text += "文件转换出错：\n" + errorTransEvent.eventMessage + "\n";
				});
			} 
			catch(error:Error) 
			{
				throw error;
			}
		}
	}
}