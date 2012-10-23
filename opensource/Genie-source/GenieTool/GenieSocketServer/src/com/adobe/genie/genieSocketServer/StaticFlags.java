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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;

import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;

/**
 * Common Static Flag which are used throughout the Server project
 */
public class StaticFlags {
	private static StaticFlags staticFlags = null;
	private boolean performanceTracking = false;
	private boolean debugMode = false;
	
	private String logfileName = null;
	private String preloadLogfileName = null;
	
	private String featureName = "";
	private String appName = "";
	private String startTime = "";
	private String endTime = "";
	private String totalTime = "";
	private String currentTime = "";
	private String preloadMessage = "";
	private Hashtable<String,String> appMap;
	
	//========================================================================================
	// Initialize the StaticFlag class and make it singleton
	//========================================================================================
	
	public static StaticFlags getInstance()
	{
		if (staticFlags == null)
			staticFlags = new StaticFlags();
		return staticFlags;
	}

	private StaticFlags()
	{	
		appMap=new Hashtable<String,String>();
	}

	//========================================================================================
	// Some public exposed methods of StaticFlag class
	//========================================================================================

	public void setdebugMode(boolean flag)
	{
		this.debugMode = flag;
	}
	
	public boolean isdebugMode()
	{
		return this.debugMode;
	}
	
	public void setPerformanceTracking(boolean flag)
	{
		this.performanceTracking = flag;
	}
	
	public boolean isPerformanceEnabled()
	{
		return this.performanceTracking;
	}
	
	public void initPerformanceLogs()
	{
		this.getPerformanceLogFile();
	}
	/*public void initPreloadLogs()
	{
		this.getPreloadLogFile();
	}*/
	//========================================================================================
	// Some private methods which are used to create a log file
	//========================================================================================
   
	//Get Performance Logs Folder
	private String getPerformanceLogFolder()
	{
		String genieLogsDir = System.getProperty("user.home") + File.separator + "GenieLogs";
		File theDir = new File(genieLogsDir);
		
		if (!theDir.exists())
		{
			theDir.mkdir();
		}
		
		String performanceLogFolder = genieLogsDir + File.separator + "PerformanceLogs";
		theDir = new File(performanceLogFolder);
		if (!theDir.exists())
		{
			theDir.mkdir();
		}
		
		return performanceLogFolder;
	}
	
	//Get Preload Logs Folder
	private String getPreloadLogFolder()
	{
		String genieLogsDir = System.getProperty("user.home") + File.separator + "GenieLogs";
		File theDir = new File(genieLogsDir);
		
		if (!theDir.exists())
		{
			theDir.mkdir();
		}
		
		//String preloadLogFolder=(String)appMap.get(this.appName);		
		//if (preloadLogFolder==null){
	    String preloadLogFolder = genieLogsDir + File.separator + "PreloadLogs";
		theDir = new File(preloadLogFolder);
		if (!theDir.exists())
		{
			theDir.mkdir();
			
		}
		 String preloadLogAppFolder = preloadLogFolder+File.separator +this.appName;
			theDir = new File(preloadLogAppFolder);
			if (!theDir.exists())
			{
				theDir.mkdir();
				
			}	
		return preloadLogAppFolder;
		//}
		//return preloadLogFolder;
	}
	//Get Performance log file
	private String getPerformanceLogFile()
	{
		if (this.logfileName == null)
			this.createLogfile();
		return logfileName;
	}
	//Get Preload log file
	/*private String getPreloadLogFile()
	{
		if (this.preloadLogfileName == null)
			this.createPreloadLogfile();
		return preloadLogfileName;
	}*/
	
	//Create performnace log file
	private void createLogfile()
	{
		String logFolder = this.getPerformanceLogFolder();
		
		logfileName = logFolder + File.separator + this.currentDateTimeString() + ".log";
		File theFile = new File(logfileName);
		try{
			theFile.createNewFile();
			
			this.writeEnvToLogs();
		}catch(Exception e){
			Shared.displayExecptionInfo(e,"Exception occurred while creating performance log file");
		}
	}
	
	/**
	 * Remove swf entry from map of log files maintained, so that next time a new file created
	 */
	public void removeSwfFromMapForLog(String clientName)
	{
		this.appMap.remove(clientName);
	}
	
	//Create preload log file
	private void createPreloadLogfile()
	{
		if((String)appMap.get(new String(this.appName))==null)
		{
				String preloadLogFolder = this.getPreloadLogFolder();		
				preloadLogfileName = preloadLogFolder +File.separator+this.currentDateTimeString() + ".log";
				appMap.put(new String(this.appName),new String(preloadLogfileName));
				File theFile = new File(preloadLogfileName);
				try{
					theFile.createNewFile();				
					
				}catch(Exception e){
					Shared.displayExecptionInfo(e,"Exception occurred while creating Preload log file");
				}
		}
		else preloadLogfileName=(String)appMap.get(new String(this.appName));
	}
	//Create performance log file if not exists
	private void createLogFileIfNotExist()
	{
		if (logfileName == null)
			return;
		File theFile = new File(logfileName);
		if (theFile.exists())
			return;		
		
		//Create logs directory if doesn't exist
		getPerformanceLogFolder();
		
		try{
			theFile.createNewFile();
			this.writeEnvToLogs();
		}catch(Exception e){
			Shared.displayExecptionInfo(e,"Exception occurred while creating performance log file");
		}
	}
	//Create Preload log file if not exists
	private void createPreloadLogFileIfNotExist()
	{
		if (preloadLogfileName == null)
			return;
		File theFile = new File(preloadLogfileName);
		if (theFile.exists())
			return;		
		
		//Create logs directory if doesn't exist
		getPreloadLogFolder();
		
		try{
			theFile.createNewFile();			
		}catch(Exception e){
			Shared.displayExecptionInfo(e,"Exception occurred while creating Preload log file");
		}
	}
	
	private String currentDateTimeString() {
	    Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
	    return sdf.format(cal.getTime());
	}
	
	private void writeToLogs(String message)
	{
		try
		{
			createLogFileIfNotExist();
			BufferedWriter out = new BufferedWriter(new FileWriter(this.logfileName, true));
			out.write(message);
			out.newLine();
			out.flush();
			out.close();
		}
		catch (Exception e) {
			Shared.displayExecptionInfo(e,"Not able to write performance data to log file");
		}
	}
	private void writeToPreloadLogs(String message)
	{
		try
		{
			createPreloadLogfile();
			createPreloadLogFileIfNotExist();
			BufferedWriter out = new BufferedWriter(new FileWriter(this.preloadLogfileName, true));
			out.write(message);
			out.newLine();
			out.flush();
			out.close();
		}
		catch (Exception e) {
			Shared.displayExecptionInfo(e,"Not able to write Preload data to log file");
		}
	}
	//Log Performance Data
	public void writePerformanceData(XmlNode data)
	{
		this.parsePerformanceXml(data);

		String dtToWrite = "===================================================================" +
			System.getProperty("line.separator");
		if (!this.featureName.equalsIgnoreCase(""))	
		{
			dtToWrite += "TrackingFeature: " + this.featureName +
			System.getProperty("line.separator");
		}
		if (!this.appName.equalsIgnoreCase(""))
		{
			dtToWrite += "AppName  : " + this.appName +
			System.getProperty("line.separator");
		}
		if (!this.startTime.equalsIgnoreCase(""))
		{
			dtToWrite += "StartTime: " + this.startTime +
			System.getProperty("line.separator");
		}
		if (!this.endTime.equalsIgnoreCase(""))
		{
			dtToWrite += "EndTime  : " + this.endTime +
			System.getProperty("line.separator");
		}
		if (!this.totalTime.equalsIgnoreCase(""))
		{
			dtToWrite += "Total Time Taken: " + this.totalTime;
		}
		dtToWrite += System.getProperty("line.separator") +
			"===================================================================";
		
		this.writeToLogs(dtToWrite);
	}
	//Log Preload Data
	public void logPreloadData(String name,XmlNode data)
	{
		this.parsePreloadXml(name,data);

		String dtToWrite =System.getProperty("line.separator");
		if (!this.preloadMessage.equalsIgnoreCase(""))
		{
			dtToWrite += this.currentTime+" : " + this.preloadMessage; 
		}
		
		
		this.writeToPreloadLogs(dtToWrite);
	}
	
	private void parsePerformanceXml(XmlNode data)
	{
		try{
			featureName = data.getNodeValueByName(Utils.FEATURE_NAME);
		}catch(Exception e)
		{
			featureName = "";
		}
		try{
			appName = data.getNodeValueByName(Utils.APP_NAME);
		}catch(Exception e)
		{
			appName = "";
		}
		try{
			startTime = data.getNodeValueByName(Utils.START_TIME);
		}catch(Exception e)
		{
			startTime = "";
		}
		try{
			endTime = data.getNodeValueByName(Utils.END_TIME);
		}
		catch(Exception e)
		{	
			endTime = "";
		}
		try{
			totalTime = data.getNodeValueByName(Utils.TOTAL_TIME);
		}
		catch(Exception e)
		{
			totalTime = "";
		}
	}
	private void parsePreloadXml(String name,XmlNode data)
	{
		try{
			appName = name;
		}catch(Exception e)
		{
			appName = "";
		}
		try{
			currentTime = data.getNodeValueByName(Utils.CURRENT_TIME);
		}catch(Exception e)
		{
			currentTime = "";
		}
		try{
			preloadMessage = data.getNodeValueByName(Utils.PRELOAD_MESSAGE);
		}catch(Exception e)
		{
			preloadMessage = "";
		}
		
	}
	
	
	private void writeEnvToLogs()
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
		
		String combinedStr = "===================================================================" + 
			System.getProperty("line.separator") +
			"OS Name: " + osName +
			System.getProperty("line.separator") +
			"Hostname: " + hostname +
			System.getProperty("line.separator") +
			"===================================================================";
		
		this.writeToLogs(combinedStr);
	}
}
