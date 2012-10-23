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
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import gn.adobe.com.GenieCom;
	import gn.adobe.com.IGenieCom;
	import gn.adobe.genie.CommandsMain;
	import gn.adobe.genie.CommandsMain;
	
	import mx.automation.Automation;
	import mx.automation.AutomationManager;
		
	public class GenieDisplay extends Sprite
	{
		[Embed(source="../Icons/GenieDisabled.png")]
		private var GenieDisabledIcon:Class;		
		
		[Embed(source="../Icons/GenieEnabled.png")]
		private var GenieEnabledIcon:Class;
		
		[Embed(source="../Icons/record.png")]
		private var GenieRecordIcon:Class;
		
		[Embed(source="../Icons/recording.png")]
		private var GenieRecordingIcon:Class;
		
		[Embed(source="../Icons/UIEnable.png")]
		private var GenieUIEnableIcon:Class;
		
		[Embed(source="../Icons/play.png")]
		private var GeniePlaybackIcon:Class;
		[Embed(source="../Icons/hidePlay.png")]
		private var GenieHidePlaybackIcon:Class;
		
		[Embed(source="../Icons/CoordWindow.png")]
		private var CoordinatesWindow:Class;
		private var objCom:IGenieCom;
		
		private var genieIcon:DisplayObject;
		private var geniePlayHideIcon:DisplayObject;
		
		private var genieDisabledIcon:DisplayObject;
		private var genieEnabledIcon:DisplayObject;
		private var genieRecordIcon:DisplayObject;
		private var genieRecordingIcon:DisplayObject;
		private var genieUIIcon:DisplayObject;
		private var cWindowIcon:DisplayObject;
		private var previousIcon:Class;
		private var coordinatesLabel:flash.text.TextField = new TextField();
		private var showCoordinates:Boolean = false;
		private var uiIconEnabled:Boolean = false;
		private var isShowingPlayIcon:Boolean = false;
		
		private static var instance:GenieDisplay = null;
				
		//public vars
		
		public var playTimer:Timer = null;
		public var bDisabled:Boolean = true;
		public var bConnectedToServer:Boolean = false;
		public var bConnectedToGenieUI:Boolean = false;
		public var bRecord:Boolean = false;
		
		
		public function GenieDisplay():void 
		{
			if(bConnectedToServer == false && bRecord == false)
			{	
				previousIcon = GenieDisabledIcon;
				showIcon(GenieDisabledIcon);
			}
			cWindowIcon = new CoordinatesWindow();
			cWindowIcon.x = 0;
			cWindowIcon.y = 33;
			cWindowIcon.visible = true;
			
			coordinatesLabel.text = "";
			coordinatesLabel.x = 10;
			coordinatesLabel.y = 40;
			coordinatesLabel.height = 29;
			coordinatesLabel.width = 62;
			coordinatesLabel.background = false;
			//coordinatesLabel.backgroundColor = 0xFFFFFF;
			
		}
		
		public function hideGenieIcon():void
		{
			try
			{
				if(genieIcon is GenieRecordIcon)
				{
					previousIcon = GenieRecordIcon;	
				}else if(genieIcon is GenieRecordingIcon)
				{
					previousIcon = GenieRecordingIcon;	
				}else if(genieIcon is GenieEnabledIcon)
				{
					previousIcon = GenieEnabledIcon;	
				}else if(genieIcon is GenieDisabledIcon)
				{
					previousIcon = GenieDisabledIcon;
				}
				removeChild(genieIcon);
			}
			catch(e:Error)
			{}
			
		}
		
		public function showGenieIcon():void
		{
			if((playTimer == null) && (previousIcon != null))
				showIcon(previousIcon);
		}
		
		public function addCoordinatesLabel():void
		{
			showCoordinates = true;
			addChild(cWindowIcon);
			addChild(coordinatesLabel);
			
		}
		public function removeCoordinatesLabel():void
		{
			showCoordinates = false;
			removeChild(coordinatesLabel);
			removeChild(cWindowIcon);
		}
		public function updateCoordinatesLabel(x:Number , y:Number):void
		{
			coordinatesLabel.text = x + "," + y;
		}
		
		public function enableUIIcon():void
		{
			try{
				GenieMix.command.switchOffColorCorrection();
			}catch(e:Error){}
			
			uiIconEnabled = true;
			if(genieIcon is GenieRecordIcon)
			{
				previousIcon = GenieRecordIcon;	
			}else if(genieIcon is GenieRecordingIcon)
			{
				previousIcon = GenieRecordingIcon;	
			}else if(genieIcon is GenieEnabledIcon)
			{
				previousIcon = GenieEnabledIcon;	
			}else if(genieIcon is GenieDisabledIcon)
			{
				previousIcon = GenieDisabledIcon;	
			}
			
			if (playTimer != null)
			{
				geniePlayHideIcon.visible = false;
				playTimer.stop();
			}
			
			prepareUIIcon(GenieUIEnableIcon);
		}
		
		public function disableUIIcon():void
		{
			try
			{
				GenieMix.command.setPreviousColorCorrection();
				uiIconEnabled = false;
				
				if (playTimer != null)
				{
					geniePlayHideIcon.visible = true;
					removeUIIcon();
					playTimer.start();
				}
				else
				{
					showGenieIcon();					
				}
			}
			catch(e:Error){}
		}
		
		public function enablePlayIcon():void
		{
			if(genieIcon is GenieRecordIcon)
			{
				previousIcon = GenieRecordIcon;	
			}else if(genieIcon is GenieRecordingIcon)
			{
				previousIcon = GenieRecordingIcon;	
			}else if(genieIcon is GenieEnabledIcon)
			{
				previousIcon = GenieEnabledIcon;	
			}else if(genieIcon is GenieDisabledIcon)
			{
				previousIcon = GenieDisabledIcon;	
			}
			
			showAnimatedPlayIcon();
		}
		
		public function disablePlayIcon():void
		{
			try
			{
				if (playTimer != null)
				{
					playTimer.stop();
					isShowingPlayIcon = false;
					playTimer = null;
				}
				
				removePlayHideIcon();
				showGenieIcon();
			}
			catch(e:Error){}
		}
		
		public function disableGenie():void 
		{
			if(genieIcon is GenieRecordIcon)
			{
				previousIcon = GenieRecordIcon;	
			}else if(genieIcon is GenieRecordingIcon)
			{
				previousIcon = GenieRecordingIcon;	
			}else if(genieIcon is GenieEnabledIcon)
			{
				previousIcon = GenieEnabledIcon;	
			}else if(genieIcon is GenieDisabledIcon)
			{
				previousIcon = GenieDisabledIcon;	
			}
			if(DisplayManager.getInstance().currentState == "Playing")
			{
				DisplayManager.getInstance().lastState = "Playing";
				previousIcon = GeniePlaybackIcon;
				disablePlayIcon();
			}
			showIcon(GenieDisabledIcon);
		}
		
		
		public function enableGenie(obj:Object):void
		{
			DisplayManager.getInstance().currentState = "Connected";
			if (playTimer != null)
			{
				//means executor is running, and plugin is closed. Just set previousIcon state
				//previousIcon = GenieEnabledIcon;
				if(genieIcon is GenieRecordIcon)
				{
					previousIcon = GenieRecordIcon;	
				}else if(genieIcon is GenieRecordingIcon)
				{
					previousIcon = GenieRecordingIcon;	
				}else if(genieIcon is GenieEnabledIcon)
				{
					previousIcon = GenieEnabledIcon;	
				}else if(genieIcon is GenieDisabledIcon)
				{
					previousIcon = GenieDisabledIcon;	
				}
			}
			else
			{
				previousIcon = GenieEnabledIcon;
				showIcon(GenieEnabledIcon);
			}
		}
		
		public function setPreviousIconAsEnabled():void
		{
			//only when playTimer != null
			updateGenieIconAndDontShow(GenieEnabledIcon);
			
			previousIcon = GenieEnabledIcon;
		}
		public function resetPreviousIcon():void
		{
			previousIcon = null;
		}
		
		public function showRecordIcon():void 
		{
			previousIcon = GenieRecordIcon;
			if (playTimer != null)
			{
				updateGenieIconAndDontShow(GenieRecordIcon);
			}
			else
			{
				showIcon(GenieRecordIcon);
			}
			DisplayManager.getInstance().currentState = "Record";
		}
		
		private function showAnimatedPlayIcon(): void
		{
			if (this.playTimer != null)
			{
				playTimer.stop();
				playTimer = null;
				isShowingPlayIcon = false;				
			}
			
			preparePlayIcon(GeniePlaybackIcon);
			playTimer = new Timer(1000, 3600 * 10);	//10 hour
			playTimer.addEventListener(TimerEvent.TIMER, togglePlayIcon);
			playTimer.start();
		}
		private function togglePlayIcon(event:TimerEvent):void{
			if (isShowingPlayIcon)
			{
				geniePlayHideIcon.visible = false;
				isShowingPlayIcon = false;
			}
			else
			{
				geniePlayHideIcon.visible = true;
				isShowingPlayIcon = true;
			}
		}
		
		private function preparePlayIcon(type:Class):void
		{
			if(type == null)
				return;
			
			genieIcon.visible = false;

			geniePlayHideIcon = new type();
			geniePlayHideIcon.x = 1;
			geniePlayHideIcon.y = 1;
			geniePlayHideIcon.alpha = 1;
			geniePlayHideIcon.cacheAsBitmap = true;
			geniePlayHideIcon.opaqueBackground = 0xFF0000;
			geniePlayHideIcon.blendMode = BlendMode.NORMAL;
			geniePlayHideIcon.mask = null;
			
			addChild(geniePlayHideIcon);					
		}
		private function removePlayHideIcon():void
		{
			try{
				removeChild(geniePlayHideIcon);
			}catch(e:Error){}
		}
		
		private function prepareUIIcon(type:Class):void
		{
			if(type == null)
				return;
			
			genieIcon.visible = false;
			
			genieUIIcon = new type();
			genieUIIcon.x = 1;
			genieUIIcon.y = 1;
			genieUIIcon.alpha = 1;
			genieUIIcon.cacheAsBitmap = true;
			genieUIIcon.opaqueBackground = 0xFF0000;
			genieUIIcon.blendMode = BlendMode.NORMAL;
			genieUIIcon.mask = null;
			
			addChild(genieUIIcon);
			genieUIIcon.visible = true;
		}
		private function removeUIIcon():void
		{
			try{
				removeChild(genieUIIcon);
			}catch(e:Error){}			
		}
		
		private function updateGenieIconAndDontShow(type:Class):void
		{
			if(type == null)
				return;
			try{
				removeChild(genieIcon);
			}catch(e:Error){}
			
			genieIcon = new type();
			genieIcon.x = 1;
			genieIcon.y = 1;
			genieIcon.alpha = 1;
			genieIcon.cacheAsBitmap = true;
			genieIcon.opaqueBackground = 0xFF0000;
			genieIcon.blendMode = BlendMode.NORMAL;
			genieIcon.mask = null;
			
			addChild(genieIcon);
			genieIcon.visible = false;			
		}
		
		private function showIcon(type:Class):void
		{
			if(type == null)
				return;
			try{
				removeChild(genieIcon);
			}catch(e:Error){}
			
			genieIcon = new type();
			genieIcon.x = 1;
			genieIcon.y = 1;
			genieIcon.alpha = 1;
			genieIcon.cacheAsBitmap = true;
			genieIcon.opaqueBackground = 0xFF0000;
			genieIcon.blendMode = BlendMode.NORMAL;
			genieIcon.mask = null;
			
			addChild(genieIcon);
			genieIcon.visible = true;
			try{
				if(type == GenieDisabledIcon || type == GenieEnabledIcon || type == GenieUIEnableIcon)
				{
					//do nothing
				}
				else
				{
					if(!genieIcon.root.hasEventListener(MouseEvent.CLICK))
						genieIcon.root.addEventListener(MouseEvent.CLICK, startRecording);
				}
			}catch(e:Error){}
		}
		
		public function startRecording(event:MouseEvent):void
		{
			if( (event.stageX > 62) || event.stageY > 29 || uiIconEnabled)
				return;
			
			var childToCheck:Object = event.target.getChildAt(0);
			if(childToCheck is flash.text.TextField || childToCheck is CoordinatesWindow)
				childToCheck = event.target.getChildAt(1);
			if(childToCheck is flash.text.TextField || childToCheck is CoordinatesWindow)
				childToCheck = event.target.getChildAt(2);
			
			if(childToCheck is GenieRecordingIcon)	
			{
				bRecord = false;
				DisplayManager.getInstance().currentState = "Record";
				//Disable Recording mode in Automation Library
				GenieMix.automationManager.endRecording();
				objCom = GenieMix.genieCom;
				objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"endRecording","","");
				GenieMix.command.refreshPluginAppXML();
				GenieMix.command.isRecording = false;
				
				previousIcon = GenieRecordIcon;
				showIcon(GenieRecordIcon);
				DisplayManager.getInstance().endRecording();
			}
			else if(childToCheck is GenieDisabledIcon)
			{
				//Do nothing
			}
			else if(childToCheck is GenieEnabledIcon)
			{
				//Do nothing
			}
			else if(childToCheck is GenieRecordIcon)
			{
				previousIcon = GenieRecordingIcon;
				showIcon(GenieRecordingIcon);
				DisplayManager.getInstance().currentState = "Recording";
				//Enable Recording mode in Automation Library
				GenieMix.automationManager.beginRecording();
				
				objCom = GenieMix.genieCom;	
				objCom.sendCommand(GenieMix.PLUGIN_NAME_STR,"startRecording","","");
				GenieMix.command.isRecording = true;
				DisplayManager.getInstance().startRecording();
			}
			else if(childToCheck is GenieUIEnableIcon)
			{
				//Do nothing
			}
			//Also update other GenieDisplays
			
		}
		
		public function showGenieRecordingIcon():void
		{
			previousIcon = GenieRecordingIcon;
			showIcon(GenieRecordingIcon);
			DisplayManager.getInstance().currentState = "Recording";
		}
		
		public function showGenieRecordIcon():void
		{
			previousIcon = GenieRecordIcon;
			showIcon(GenieRecordIcon);
			DisplayManager.getInstance().currentState = "Record";
		}
		
		public function showGivenGenieIcon(state:String):void
		{
			if(state == "Recording")
			{
				showIcon(GenieRecordingIcon);
			}
			else if(state == "Record")
				showIcon(GenieRecordIcon);
			else if(state == "Connected")
				showIcon(GenieEnabledIcon);
		}
	}
}
