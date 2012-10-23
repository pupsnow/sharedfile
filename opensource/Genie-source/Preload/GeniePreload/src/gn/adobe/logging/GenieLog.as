//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================
package gn.adobe.logging
{
	import flash.xml.*;
	
	import gn.adobe.com.*;
	public class GenieLog implements IGenieLog
	{
		public static var isTraceEnabled:Boolean = false;
		private static var instance:GenieLog = null;
		public var traceLogArrayFlushed:Boolean;
		public var userLogArrayFlushed:Boolean;
		public var detailedTraceArrayFlushed:Boolean;
		private var objCom:IGenieCom;
		private var cachingArrayTraceLog:Array;
		private var cachingArrayUserLog:Array;
		private var cachingArrayDetailedTrace:Array;
		
		
		public function GenieLog():void
		{
			cachingArrayTraceLog=new Array();
			cachingArrayUserLog=new Array();
			cachingArrayDetailedTrace=new Array();
			traceLogArrayFlushed=false;
			userLogArrayFlushed=false;
			detailedTraceArrayFlushed=false;
		}
		
		public static function getInstance():GenieLog
		{
			if(instance == null)
				instance = new GenieLog();
			return instance;
		}
		public function traceLog(strType:String, strMessage:String):void
		{
			var strTime:String = getCurrentTime();
			var xmlStr:String;			
			var msgStr:String=strTime+" "+strType+": "+strMessage;			
			trace(strTime+" "+strType+": "+strMessage);
			if(!GeniePreload.connectionStatusForLogging){
				startCaching("traceLog",strMessage);
			}
			if(GeniePreload.connectionStatusForLogging && !traceLogArrayFlushed){				
				flushCache("traceLog");
			}
			
			if(GeniePreload.connectionStatusForLogging && traceLogArrayFlushed){
				xmlStr = new String;			
				xmlStr =createCommand(strMessage,strTime);
				objCom = GenieMix.genieCom;	
				objCom.sendCommand("Server","logPreloadData",xmlStr,"");
			}
				
		}
		
		public function userLog(strMessage:String):void
		{
			var strTime:String = getCurrentTime();
			var xmlStr:String;
			var msgStr:String=" INFO: "+strMessage;			
			trace(strTime+" INFO: "+strMessage);
			if(!GeniePreload.connectionStatusForLogging){
				startCaching("userLog",strMessage);				
			}
			if(GeniePreload.connectionStatusForLogging && !userLogArrayFlushed){
				flushCache("userLog");				
			}
			if(GeniePreload.connectionStatusForLogging && userLogArrayFlushed){
				xmlStr = new String();			
				xmlStr =createCommand(strMessage,strTime);
				objCom = GenieMix.genieCom;	
				objCom.sendCommand("Server","logPreloadData",xmlStr,"");
			}
		}
		
		public function detailedTrace(strType:String, strMessage:String):void
		{
			if(isTraceEnabled == true)
			{
				var strTime:String = getCurrentTime();
				var xmlStr:String;
				var msgStr:String=strType+": "+strMessage					
				trace(strTime+" "+strType+": "+strMessage);	
				if(!GeniePreload.connectionStatusForLogging){
					startCaching("detailedTrace",strMessage);
				}
				if(GeniePreload.connectionStatusForLogging && !detailedTraceArrayFlushed){					
					flushCache("detailedTrace");
				}
				if(GeniePreload.connectionStatusForLogging && detailedTraceArrayFlushed){
					xmlStr = new String();			
					xmlStr =createCommand(strMessage,strTime);
					objCom = GenieMix.genieCom;	
					objCom.sendCommand("Server","logPreloadData",xmlStr,"");
				}
			}
		}
		
		private function getCurrentTime():String
		{
			var currentTime:Date = new Date();
			return (currentTime.hours.toString()+":"+currentTime.minutes.toString()+":"+currentTime.seconds.toString());
		}
		
		public function startCaching(fromFunction:String, strMessage:String):void{
			var strTime:String = getCurrentTime();
			var xmlStr:String;
			if (fromFunction.indexOf("traceLog")>-1){
			xmlStr = new String();			
			xmlStr =createCommand(strMessage,strTime);
			cachingArrayTraceLog.push(xmlStr);
			traceLogArrayFlushed=false;
			}
			if (fromFunction.indexOf("userLog")>-1){
				xmlStr = new String();			
				xmlStr =createCommand(strMessage,strTime);
				cachingArrayUserLog.push(xmlStr);
				userLogArrayFlushed=false;
			}
			if (fromFunction.indexOf("detailedTrace")>-1){
				xmlStr = new String();			
				xmlStr =createCommand(strMessage,strTime);
				cachingArrayDetailedTrace.push(xmlStr);
				detailedTraceArrayFlushed=false;
			}
		}
		
		public function flushCache(fromFunction:String):void{
			var xmlStr:String;
			if (fromFunction.indexOf("traceLog")>-1){
				objCom = GenieMix.genieCom;
				while(cachingArrayTraceLog.length>0){
					xmlStr = new String();				
					xmlStr=cachingArrayTraceLog.shift();
					objCom.sendCommand("Server","logPreloadData",xmlStr,"");
				}
				traceLogArrayFlushed=true;
			}
			if (fromFunction.indexOf("userLog")>-1){
			objCom = GenieMix.genieCom;
			while(cachingArrayUserLog.length>0){
				xmlStr = new String();				
				xmlStr=cachingArrayUserLog.shift();
				objCom.sendCommand("Server","logPreloadData",xmlStr,"");
			}
			userLogArrayFlushed=true;
			}
			if (fromFunction.indexOf("detailedTrace")>-1){
				objCom = GenieMix.genieCom;
				while(cachingArrayDetailedTrace.length>0){
					xmlStr = new String();				
					xmlStr=cachingArrayDetailedTrace.shift();
					objCom.sendCommand("Server","logPreloadData",xmlStr,"");
				}
				detailedTraceArrayFlushed=true;
			}
		}
		
		public function createCommand(strMessage:String,strTime:String):String{
			var xmlStr:String;
			xmlStr=new String();
			xmlStr += "<AppName>" +GenieMix.strApplicationName+ "</AppName>";
			xmlStr += "<CurrentTime>" + strTime+ "</CurrentTime>";			
			xmlStr += "<Message>"+strMessage+"</Message>";
			return xmlStr;
		}
	}
}