package com.lhyx.presentermanager
{
	import com.lhyx.components.FileBrowser;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.Group;

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
			this._fileBrowser.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
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
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
	}
}