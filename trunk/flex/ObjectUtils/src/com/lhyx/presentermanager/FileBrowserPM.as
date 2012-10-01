package com.lhyx.presentermanager
{
	import com.lhyx.components.FileBrowser;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import org.springextensions.actionscript.core.event.EventBus;
	
	import spark.components.Group;

	public class FileBrowserPM
	{
		/**
		 * This const value is 'inputBrowserFileChangeEvent'.
		 */		
		public static const INPUT_BROWSER_FILE_EVENT:String = "inputBrowserFileChangeEvent";
		
		/**
		 * This const value is 'outputBrowserFileChangeEvent'.
		 */		
		public static const OUTPUT_BROWSER_FILE_EVENT:String = "outputBrowserFileChangeEvent";
		
		private var _fileBrowser:FileBrowser;
		private var _inputBrowserFile:File;
		private var _outputBrowserFile:File;

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
			this._fileBrowser.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
		}
		
		[Bindable(event="inputBrowserFileChangeEvent")]
		public function get inputBrowserFile():File
		{
			return _inputBrowserFile;
		}
		
		[Bindable(event="outputBrowserFileChangeEvent")]
		public function get outputBrowserFile():File
		{
			return _outputBrowserFile;
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			try
			{
				// Add input elements.
				if (this._fileBrowser.inputGroup) 
				{
					this._fileBrowser.addElement(this._fileBrowser.inputGroup);
					
					if (this._fileBrowser.inputGroupLayout && this._fileBrowser.inputGroup is Group) 
					{
						this._fileBrowser.inputGroup.layout = this._fileBrowser.inputGroupLayout;
					}
					
					if (this._fileBrowser.inputLabel) 
					{
						this._fileBrowser.inputGroup.addElement(this._fileBrowser.inputLabel);
					}
					
					if (this._fileBrowser.inputTextInput) 
					{
						this._fileBrowser.inputGroup.addElement(this._fileBrowser.inputTextInput);
					}
					
					if (this._fileBrowser.inputBrowserButton) 
					{
						this._fileBrowser.inputGroup.addElement(this._fileBrowser.inputBrowserButton);
					}
				}
				
				// Add output elements.
				if (this._fileBrowser.outputGroup) 
				{
					this._fileBrowser.addElement(this._fileBrowser.outputGroup);
					
					if (this._fileBrowser.outputGroupLayout && this._fileBrowser.outputGroup is Group) 
					{
						this._fileBrowser.outputGroup.layout = this._fileBrowser.outputGroupLayout;
					}
					
					if (this._fileBrowser.outputLabel) 
					{
						this._fileBrowser.outputGroup.addElement(this._fileBrowser.outputLabel);
					}
					
					if (this._fileBrowser.outputTextInput) 
					{
						this._fileBrowser.outputGroup.addElement(this._fileBrowser.outputTextInput);
					}
					
					if (this._fileBrowser.outputBrowserButton) 
					{
						this._fileBrowser.outputGroup.addElement(this._fileBrowser.outputBrowserButton);
					}
				}
				
				// Add other elements.
				if (this._fileBrowser.otherGroup) 
				{
					this._fileBrowser.addElement(this._fileBrowser.otherGroup);
					
					if (this._fileBrowser.otherGroupLayout && this._fileBrowser.otherGroup is Group) 
					{
						this._fileBrowser.otherGroup.layout = this._fileBrowser.outputGroupLayout;
					}
					
					if (this._fileBrowser.clearButton) 
					{
						this._fileBrowser.otherGroup.addElement(this._fileBrowser.clearButton);
					}
					
					if (this._fileBrowser.generateButton) 
					{
						this._fileBrowser.otherGroup.addElement(this._fileBrowser.generateButton);
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
				// Listener clear button mouse click event.
				this._fileBrowser.clearButton.addEventListener(MouseEvent.CLICK,function(clearEvent:MouseEvent):void
				{
					_fileBrowser.inputTextInput.text = "";
					_fileBrowser.outputTextInput.text = "";
				});
				
				// Listener input browser button mouse click event.
				this._fileBrowser.inputBrowserButton.addEventListener(MouseEvent.CLICK,function(inputBrowserEvent:MouseEvent):void
				{
					try
					{
						if (!_inputBrowserFile) 
						{
							_inputBrowserFile = new File();
							EventBus.dispatchEvent(new Event(INPUT_BROWSER_FILE_EVENT));
						}
						
						if (_inputBrowserFile) 
						{
							_inputBrowserFile.browseForOpen("请选择文件");
							
							_inputBrowserFile.addEventListener(Event.SELECT,function(inputFileEvent:Event):void
							{
								if (inputFileEvent.target is File) 
								{
									_fileBrowser.inputTextInput.text = (inputFileEvent.target as File).url;
								}
							});
						}
					} 
					catch(error:Error) 
					{
						Alert.show(error.toString());
					}
				});
				
				// Listener output browser button mouse click event.
				this._fileBrowser.outputBrowserButton.addEventListener(MouseEvent.CLICK,function(outputBrowserEvent:MouseEvent):void
				{
					try
					{
						if (!_outputBrowserFile) 
						{
							_outputBrowserFile = new File();
							EventBus.dispatchEvent(new Event(OUTPUT_BROWSER_FILE_EVENT));
						}
						
						if (_outputBrowserFile) 
						{
							_outputBrowserFile.browseForDirectory("请选择输入目录");
							
							_outputBrowserFile.addEventListener(Event.SELECT,function(outputFileEvent:Event):void
							{
								if (outputFileEvent.target is File) 
								{
									_fileBrowser.outputTextInput.text = (outputFileEvent.target as File).url;
								}
							});
						}
					} 
					catch(error:Error) 
					{
						Alert.show(error.toString());
					}
				});
			} 
			catch(error:Error) 
			{
				throw error;
			}
		}
	}
}