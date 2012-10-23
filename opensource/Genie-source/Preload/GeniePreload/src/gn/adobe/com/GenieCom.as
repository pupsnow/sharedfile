//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================

package gn.adobe.com
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.net.XMLSocket;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import gn.adobe.genie.ArraySocketClass;
	import gn.adobe.genie.CommandsMain;
	import gn.adobe.genie.CommandsMain;
	import gn.adobe.logging.GenieLog;
	import gn.adobe.logging.GenieLogConst;
	import gn.adobe.logging.IGenieLog;
	import gn.adobe.serializers.Serializers;
	import gn.adobe.shared.SharedFunctions;
	
	import mx.automation.Automation;
	import mx.core.FlexVersion;
	import mx.core.mx_internal;

	public class GenieCom extends EventDispatcher implements IGenieCom
	{
		private var isConnected:Boolean = false;
		private var objLogs:IGenieLog;
		private var socket:XMLSocket;
		private static var strApplicationName:String = "";
		private var objToCall:CommandsMain;
		private static var PORT_NO:int = 61120;
		public static var strCustomEnv:String = "";
		private var bLogSocketIOError:Boolean = true;
		private var bLogSocketSecurityError:Boolean = true;

		public function GenieCom():void
		{
			if(!isConnected)
			{
				this.objLogs = GenieMix.genieLog;
				this.objToCall = GenieMix.command;
				objLogs.traceLog(GenieLogConst.INFO, strApplicationName+" connecting to server");
				strApplicationName = GenieMix.strApplicationName;
				connectToServer();
			}
		}
		
		public static function init():void
		{
			GenieMix.genieCom = new GenieCom();
		}
		
		public function connectToServer(event:Event=null):void
		{
			socket = new XMLSocket();
			socket.addEventListener(Event.CONNECT, socketConnected);
			socket.addEventListener(Event.CLOSE, socketClosed);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketSecurityError);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketIOError);
			socket.addEventListener(DataEvent.DATA, socketData);
			socket.connect("localhost", PORT_NO);
		}
		
		private function socketConnected(event:Event):void
		{
			bLogSocketIOError = true;
			bLogSocketSecurityError = true;
			
			socket = event.currentTarget as XMLSocket;
			
			//Initialize com object of Commands class
			CommandsMain.init();
			
			objLogs.traceLog(GenieLogConst.INFO, "socket connected successfully.");
			isConnected = true;
			var pattern:RegExp = /(\d+),(\d+)/;
			var sdkPattern:RegExp = /(\d+).(\d+)/;
			var preloadSdkVersion:String=String(sdkPattern.exec(FlexVersion.mx_internal::VERSION )[0]);
			var preloadName:String=GeniePreload.geniePreloadName;
			//code to get the sdkversion and preload name-end
			var strGenieVersion:String = GenieMix.getLatestVersion();
			socket.send(getMessage("Server","addClient","<Name>"+strApplicationName+"</Name><GenieVersion>"+strGenieVersion+"</GenieVersion><ActionScriptVersion>"+GenieMix.getASVersion()+"</ActionScriptVersion><PlayerVersion>"+String(pattern.exec(Capabilities.version)[0])+"</PlayerVersion><PlayerType>"+Capabilities.playerType+"</PlayerType><GeniePreloadName>"+preloadName+"</GeniePreloadName><PreloadSdkVersion>"+preloadSdkVersion+"</PreloadSdkVersion>","clientAdded"));
		}
		
		private function socketClosed(event:Event):void 
		{
			GenieMix.command.isDebugTrue = false;
			GenieMix.gnDisplay.bConnectedToServer = false;
			//the below flag is set to true starts the preload logging at server end
			GeniePreload.connectionStatusForLogging=false;
			GenieMix.gnDisplay.disableGenie();
			GenieMix.gnDisplay.currentState = "Disconnected";
			
			objLogs.traceLog(GenieLogConst.INFO, "socketClosed....");
			this.dispatchEvent(new GenieComEvent(GenieComEvent.DISCONNECTED));
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, connectToServer);
			timer.start();
			this.dispatchEvent(new GenieComEvent(GenieComEvent.ERROR));
		}
		
		private function socketSecurityError(event:SecurityErrorEvent):void 
		{
			GenieMix.command.isDebugTrue = false;
			if(bLogSocketSecurityError)
			{
				objLogs.traceLog(GenieLogConst.INFO, "socketSecurityError....");
				bLogSocketSecurityError = false;
			}
			this.dispatchEvent(new GenieComEvent(GenieComEvent.ERROR));
		}
		
		private function socketIOError(event:IOErrorEvent):void 
		{
			//Retry connection every 1 second
			GenieMix.command.isDebugTrue = false;
			try
			{
				GenieMix.gnDisplay.removeCoordinatesLabel();
				Mouse.cursor = MouseCursor.ARROW;
			}
			catch(e:Error){}
			if(bLogSocketIOError)
			{
				objLogs.traceLog(GenieLogConst.INFO,"Genie Server is required in order to use GeniePreload. Please launch Genie Server...");
				bLogSocketIOError = false;
			}
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, connectToServer);
			timer.start();
			this.dispatchEvent(new GenieComEvent(GenieComEvent.ERROR));
		}		
		
		
		private function socketData(event:DataEvent):void {
			XML.ignoreProcessingInstructions = false;
			XML.ignoreWhitespace = false;
			XML.prettyPrinting=false;
			//trim length
			var eventData:String = event.data;
			if(eventData.indexOf("<") != 0)
			{
				eventData = eventData.substr(eventData.indexOf(";")+1);
			}
			var data_xml:XML = new XML(eventData);	
			
			var strGuid:String = "";
			var arrParams:Array = new Array();
			
			trace("Debugging:::: Data recieved" + event.data);		
			
			var action:String = String(data_xml.Action[0]);
			var from:String = "";
			try{from = String(data_xml.From[0]);}catch(e:Error){}
			
			XML.ignoreProcessingInstructions = false;
			XML.ignoreWhitespace = false;
			XML.prettyPrinting=false;
			var data:XML = new XML();

			data = (data_xml.Genie_Call_Data[0] as XML).children()[0];

			var dataTag:String = "Genie_Call_Data";
			
			if(from == GenieMix.EXECUTOR_NAME_STR && GenieMix.gnDisplay.currentState != "Playing" && action != "getAppXML")
				GenieMix.gnDisplay.enablePlayIcon();
			
			switch(action) {
				case "clientRefused":
					var preloadMinVersion:String = data_xml.child(dataTag).child("PreloadMinVersion");
					var serverVersion:String = data_xml.child(dataTag).child("ServerVersion");
					
					SharedFunctions.disablePreloadActions(socket, "Preload version is not supported by Genie Server. Found: " + GenieMix.getLatestVersion() +
						", Expected MinVersion: " + preloadMinVersion + ", ServerVersion: " + serverVersion);
					
					break;
				case "clientAdded":
					var svrVersion:String = data_xml.child(dataTag).child("ServerVersion");
					var selfVer:String = GenieMix.getServerMinVersion();
					if (!SharedFunctions.isServerVersionSupported(svrVersion, selfVer))
					{
						SharedFunctions.disablePreloadActions(socket, "Server version is not supported by preload. Found: " +
							svrVersion + ", Expected MinVersion: " + selfVer);
						break;
					}
					//the below flag is set to true starts the preload logging at server end
					GeniePreload.connectionStatusForLogging=true;
					objLogs.traceLog(GenieLogConst.INFO, "added to socket client list successfully");	
					var displayManager:DisplayManager = GenieMix.gnDisplay;
					displayManager.bConnectedToServer = true;
					if(displayManager.currentState == "Disconnected")
						displayManager.currentState = "Connected";
					displayManager.enableGenie();
					
					//Check whether performance tracking enabled or not
					sendCommand("Server", "isPerformanceTrackingEnabled", "", "performanceTracking");
					sendCommand("Server", "areYouProxyServer", "", "areYouProxyServerResponse");
					
					break;
				case "performanceTracking":
					var isPerfEnabled:String = data_xml.child(dataTag).child("PerformanceTracking");
					if (isPerfEnabled == "true")
					{
						GenieMix.isPerformanceTrackingEnabled = true;
						objLogs.traceLog(GenieLogConst.INFO, "Performance Tracking Enabled...");
					}
					break;
				case "executorExited":
					GenieMix.command.cleanEventArray();
					GenieMix.command.refreshPluginAppXML();
					GenieMix.getDisplay.disablePlayIcon();
					break;
				case "connected2Plugin":
					GenieMix.confirmConnectedToPlugin();
					break;
				case "addClient":
					trace("Error::addClient called");
					isConnected = false;
					socket.close();
					connectToServer();
					break;
				case "clientDisconnected":
					
					if(strApplicationName == from)
					{
						var gnDisplay:DisplayManager = GenieMix.getDisplay;
						gnDisplay.bConnectedToServer = false;
						//the below flag is set to true starts the preload logging at server end
						GeniePreload.connectionStatusForLogging=false;
						gnDisplay.enableGenie();
						objLogs.traceLog(GenieLogConst.INFO,"clientDisconnected");
						this.dispatchEvent(new GenieComEvent(GenieComEvent.CLIENT_DISCONNECTED, Serializers.deserialize(data)));
					}
					if(from == GenieMix.EXECUTOR_NAME_STR)
					{
						GenieMix.getDisplay.disablePlayIcon();
						GenieMix.command.refreshPluginAppXML();
						GenieMix.command.cleanEventArray();
					}
					break;
				default:
					try
					{
						strGuid = String(data_xml.CallGUID[0]);	
					}
					catch(e:Error)
					{}
					
					if(Serializers.deserialize(data)!=null)
					{
						
						arrParams = [Serializers.deserialize(data)];
					}
					arrParams.push(strGuid);
					arrParams.push(from);
					objToCall[action].apply(objToCall, arrParams);
					break;
			}
		}
		
		/**
		 * Developer needs to call this in order to get the environment XML provided by user
		 */
		public function sendRequestToGetUserEnvXML():void
		{
			sendCommand("Server", "getUserEnvironmentXML", "", "userEnvXmlReceived");
		}
		public function sendCommand(destination:String, method:String, strData:String, CallBackAction:String):void
		{
			try{
				//Do not send removeObject call rather store them in an array and send it with delta call.
				if(method == "removeObject")
				{
					GenieMix.command.removeObjectList.addItem(strData);
					GenieMix.command.deltaReady = true;
					return;
				}
				//Update name of removeObjects call, so that no change id needed at plugin
				if(method == "removeObjects")
					method = "removeObject";

				if( (method == "DeltaXML" || method == "removeObject") && (GenieMix.command.isRecording || GenieMix.gnDisplay.currentState == "Playing") &&  GenieMix.highPerformanceMode)
					return;
				if(isConnected)				
					socket.send(getMessage(destination,method,strData, CallBackAction));
			}catch(e:Error)	{trace(e.message);}
		}
		
		private function getMessage(dest:String, action:String, data:String, CallBackAction:String):String 
		{
			var dataToSend:String ="<Call><Dest>"+dest+"</Dest><Action>"+action+"</Action><Genie_Call_Data>"+data+"</Genie_Call_Data><CallBackAction>"+CallBackAction+"</CallBackAction></Call>";
			dataToSend = dataToSend.length +  ";" + dataToSend;
			
			var m:ByteArray = new ByteArray();
			m.writeUTFBytes(dataToSend);
			
			if(m.length != dataToSend.length)
			{
				objLogs.traceLog("Error", "Error in length "+ m.length +","+ dataToSend.length);
			}
  			return 	dataToSend;	
		}
		
		public function sendCommandWithId(destination:String, respId:String, method:String, strData:String, CallBackAction:String):void
		{
			//Do not send removeObject call rather store them in an array and send it with delta call.
			if(method == "removeObject")
			{
				GenieMix.command.removeObjectList.addItem(strData);
				GenieMix.command.deltaReady = true;
				return;
			}
			//Update name of removeObjects call, so that no change id needed at plugin
			if(method == "removeObjects")
				method = "removeObject";
			
			if( (method == "DeltaXML" || method == "removeObject") && (GenieMix.command.isRecording || GenieMix.gnDisplay.currentState == "Playing") &&  GenieMix.highPerformanceMode)
				return;
			socket.send(getMessageWithId(destination,respId, method,strData, CallBackAction));
		}
		
		
		private function getMessageWithId(dest:String, respId:String, action:String, data:String, CallBackAction:String):String 
		{
			var dataToSend:String ="<Call><Dest>"+dest+"</Dest><RespGUID>"+respId+"</RespGUID><Action>"+action+"</Action><CallBackAction>"+CallBackAction+"</CallBackAction><Genie_Call_Data>"+data+"</Genie_Call_Data></Call>";
			
				dataToSend = dataToSend.length +  ";" + dataToSend;
			var m:ByteArray = new ByteArray();
			m.writeUTFBytes(dataToSend);
			if(m.length != dataToSend.length)
			{
				objLogs.traceLog("Error", "Error in length "+ m.length +","+ dataToSend.length);
			}
			return 	dataToSend;	
		}
		
	}
}
