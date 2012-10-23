//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================
package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.automation.AutomationManager;

	public class DisplayManager extends Sprite
	{
		//public var stats:GenieDisplay;
		public var arrayGD:Array;
		private static var instance:DisplayManager = null; 
		public var bConnectedToServer:Boolean = false;
		public var bConnectedToGenieUI:Boolean = true;
		public var currentState:String = "Disconnected";
		public var lastState:String = "";
		public var bGenieHidden:Boolean = false;
		public static function getInstance():DisplayManager
		{
			if(instance == null)
				instance = new DisplayManager();
			return instance;
		}
		
		public function DisplayManager()
		{
			//stats = new GenieDisplay();
			arrayGD = new Array();
		}
		public function resetPreviousIcon():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.resetPreviousIcon();
			}
		}
		public function removeFromArrayGD(gnDisplay:GenieDisplay):void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				if(gd == gnDisplay)
					arrayGD.splice(i,1);
			}
		}
		public function disablePlayIcon():void
		{
			currentState = lastState;
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.disablePlayIcon();
				gd.showGivenGenieIcon(currentState);
				
			}
		}
		public function addToList(gnDisplay:GenieDisplay):void
		{
			arrayGD.push(gnDisplay);
			
			if(currentState == "Connected")
				enableGenie();
			if(currentState == "Record")
				showRecordIcon();	
			if(currentState == "Recording")
				startRecording();
			if(currentState == "Playing")
				gnDisplay.enablePlayIcon();
			if(bGenieHidden)
				hideGenieIcon();
		}
		public function disableGenie():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.disableGenie();
			}
		}
		public function enableGenie():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.enableGenie(null);
			}
		
		}
		
		public function enablePlayIcon():void
		{
			lastState = currentState;
			currentState = "Playing";
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.enablePlayIcon();
			}
		}
		
		
		public function setPreviousIconAsEnabled():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.setPreviousIconAsEnabled();
			}
		}
		
		public function showRecordIcon():void 
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.showRecordIcon();
			}
		}
		
		public function startRecording():void 
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.showGenieRecordingIcon();
			}
		}
		
		public function endRecording():void 
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.showGenieRecordIcon();
			}
		}
		
		public function showIcon():void 
		{
			bGenieHidden = false;
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.showGenieIcon();
			}
		}
		
		public function addCoordinatesLabel():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.addCoordinatesLabel();
			}
		}
		
		public function disableUIIcon():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.disableUIIcon();
			}
		}
		
		public function enableUIIcon(appName:String = ""):void
		{
			if(arrayGD.length > 0)
			{
				var gd:GenieDisplay = arrayGD[0];
				gd.enableUIIcon();
			}
			
		}
		
		public function removeCoordinatesLabel():void
		{
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.removeCoordinatesLabel();
			}
		}
		
		public function hideGenieIcon():void
		{
			bGenieHidden = true;
			for(var i:int=0; i <arrayGD.length ; ++i)
			{
				var gd:GenieDisplay = arrayGD[i];
				gd.hideGenieIcon();
			}
		}
		
		public function updateCoordinatesLabel(x:Number , y:Number, appName:String=""):void
		{
			if(arrayGD.length > 0)
			{
				var gd:GenieDisplay = arrayGD[0];
				gd.updateCoordinatesLabel(x,y);
			}
		}
		
		
	}
}

internal class SingletonBlocker 
{ }