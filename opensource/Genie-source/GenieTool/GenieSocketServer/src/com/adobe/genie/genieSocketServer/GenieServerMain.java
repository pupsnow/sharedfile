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

import java.io.File;
import com.adobe.genie.utils.log.*;
import com.adobe.genie.utils.Utils;

/**
 * Main class for Socket server. It the primary entry point
 */
public class GenieServerMain {
	public static final String SERVER_VERSION  = "0.1";
	
	public static void main(String[] args)
	{
		String logFileName = System.getProperty("user.home") + File.separator + "GenieLogs" + File.separator +
			"GenieSocketServer" + File.separator + "ServerLog_" + LogData.getCurrentTimeStamp() + ".log";
	
		//Instantiate Server log file
		LogData log = LogData.getInstance(logFileName);
		LogData.DEBUG = false;
		StaticFlags sFlags = StaticFlags.getInstance();
		
		
		log.traceWOTimeStamp("===================================================================");
		log.trace("","Initializing Server Log");
		log.traceWOTimeStamp(Shared.getEnvDetails());
		log.traceWOTimeStamp("===================================================================");

		VersionHandler vHandler = VersionHandler.getInstance();
	    if (!(vHandler == null)){
			try{
				CommandLineParser cmdLine = new CommandLineParser(args);
				LogData.DEBUG = cmdLine.isDebugEnabled();
				
				sFlags.setdebugMode(cmdLine.isDebugEnabled());
				if (sFlags.isdebugMode())
					log.trace(LogData.INFO, "Debug Information Tracking is ON");
				else
					log.trace(LogData.INFO, "Debug Information Tracking is OFF");
				
				sFlags.setPerformanceTracking(cmdLine.isPerformanceTrackingEnabled());
				
				//If performance tracking is enabled initiate performance logs
				if (sFlags.isPerformanceEnabled()){
					Utils.printMessageOnConsole("Tracking perf enabled...");
					log.trace(LogData.INFO, "Performance Tracking is ON");
					sFlags.initPerformanceLogs();
				}
				
				//If it is just a version of usage query. Exit after providing it
				if (cmdLine.toExit()){
					return;
				}
				
				//If Custom Component Config file is provided
				if(cmdLine.getCustomConfigFile() != null){
					File cutomConfigFile = new File(cmdLine.getCustomConfigFile());
					if(cutomConfigFile.exists())
						CustomConfigData.getInstance(cmdLine.getCustomConfigFile());
					else
						Utils.printErrorOnConsole("Server is not able locate custom config file. \n"  + cmdLine.getCustomConfigFile());
				}
		    }
		    catch (Exception e){
		    	Shared.displayExecptionInfo(e,"Error while parsing command line args!!!");
		    }	    

	    	//Instantiate few classes and start the server thread
			Parser server = new Parser();
			ServerThread th = new ServerThread(server);
			log.trace(LogData.INFO, "Starting Server");
			th.start();
			
			ServerSignalHandler serverSignalHandle = new ServerSignalHandler(server);
			serverSignalHandle.install("INT");
			
			//Waiting for ServerThread to finish
			try
			{
				th.join();
			}
			catch(Exception e)
			{
				e.printStackTrace();
				Utils.printErrorOnConsole("Exception in Server Thread: " + e.getMessage());
			}
			
			Utils.printMessageOnConsole("Server Stopped...");
	    }
	    else{
	    	Utils.printErrorOnConsole("Since Version handler cannot be initialized, aborting Server process!!!");
	    	log.trace(LogData.ERROR, "Since Version handler cannot be initialized, aborting Server process!!!");
	    }
	}
	
}
