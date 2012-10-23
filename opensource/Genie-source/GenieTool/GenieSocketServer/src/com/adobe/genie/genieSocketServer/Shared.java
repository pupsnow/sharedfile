//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
//	documentation and/or other materials provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//========================================================================================
package com.adobe.genie.genieSocketServer;

import java.net.InetAddress;

import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;

/**
 * A Shared class used across Server Project
 * 
 */
class Shared {

	//Get some environment details for printing in Log file
	public static String getEnvDetails()
	{
		String osName = "";
		String hostname = "";
		try{
			osName = System.getProperty("os.name");
			hostname = InetAddress.getLocalHost().getHostName();
		}catch(Exception e){
			osName = "Unknown";
			hostname = "Unknown";
		}
		
		String combinedStr = System.getProperty("line.separator") +
			"OS Name: " + osName +
			System.getProperty("line.separator") +
			"Hostname: " + hostname +
			System.getProperty("line.separator");
		
		 return combinedStr;
	}
	
	//Display exception info as appropriate and also puts it in Log
	public static void displayExecptionInfo(Exception e, String msg)
	{
		LogData log = LogData.getInstance();
		StaticFlags sFlags = StaticFlags.getInstance();
		
    	log.traceWOTimeStamp(System.getProperty("line.separator"));
    	log.trace(LogData.ERROR, msg);
    	log.traceRun(LogData.ERROR, e.getMessage());
    	log.traceDebug(LogData.ERROR, Utils.getExceptionStackTraceAsString(e));
    	log.traceWOTimeStamp(System.getProperty("line.separator"));
    	
    	Utils.printErrorOnConsole(msg);
    	if (sFlags.isdebugMode()){
    		e.printStackTrace();
    	}else {
    		Utils.printErrorOnConsole(e.getMessage());
    	}
	}
}
