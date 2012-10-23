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
package com.adobe.genie.genieCom;

import java.util.HashMap;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.utils.Utils;

/**
 * This class provides all functionality of Socket to Executor
 * It performs actions in a synchronized manner and waits for result 
 * of action before returning back control
 * <p>
 * Is a singleton Class and should be used appropriately 
 * 
 * @since Genie 0.4
 */
public class SynchronizedSocket {

	protected SocketClient socket  = null;
	private static SynchronizedSocket instance = null;
	protected HashMap<String, String> responseList;
	
	private static int DEFAULT_TIMEOUT = 15;
	private int timeout = DEFAULT_TIMEOUT;
	
	//========================================================================================
	// Constructor methods to make this class Singleton
	//========================================================================================

	/**
	 * Return instance of SynchSocket
	 */
	public static SynchronizedSocket getInstance(){
	     return instance;
	}

	/**
	 * First type of SynchSocket Constructor
	 */
	public static SynchronizedSocket getInstance(String name, Object obj) {
	     if(instance == null) {
	        instance = new SynchronizedSocket(name,obj);
	     }
	     return instance;
	}

	/**
	 * First type of SynchSocket initialized
	 */
	private SynchronizedSocket(String name, Object obj)
	{
		try{
			socket = SocketClient.getInstance(name, obj);
		}
		catch(Exception e){
			Utils.printErrorOnConsole(e.getMessage());
		}
	}

	/**
	 * Second type of SynchSocket Constructor
	 */
	public static SynchronizedSocket getInstance(SocketClient sc) {
	     if(instance == null) {
	        instance = new SynchronizedSocket(sc);
	     }
	     return instance;
	}

	/**
	 * Second type of SynchSocket initialized
	 */
	public SynchronizedSocket(SocketClient sc){
		socket = sc;
	}
	
	/**
	 * Dispose Synchronized Socket object
	 */
	public void dispose() {
	     this.socket.dispose();
	     this.responseList = null;
	     instance = null;
	}


	 /**
	 * Reset response list
	 */
	public void resetResponseList() {
	    this.responseList = new HashMap<String, String>();
	}
	
	//========================================================================================
	// Properties Getter/Setter
	//========================================================================================
	public void setTimeout(int timeout){
		this.timeout = timeout;
	}
	
	public int getTimeout(){
		return this.timeout;
	}
	
	/**
	 * Will set Timeout to DEFAULT_TIMEOUT
	 */
	public void resetTimeout()
	{
		this.timeout = DEFAULT_TIMEOUT;
	}

	public boolean isServerDisconnected(){
		return this.socket.isServerDisconnected();
	}
	
	public boolean isSocketClosed(){
		return this.socket.isSocketClosed();
	}
	
	public boolean close(){
		socket.close();
		return true;
	}
	
	public boolean getDebugMode(){
		return socket.getDebugMode();
	}
	
	//========================================================================================
	// Basic Socket level methods
	//========================================================================================
	
	/**
	 * Waits for synchSocket to be connected 
	 * Method used for Executor
	 */
	public boolean waitForSocketConnection()
	{
		int connTimeout = getTimeout();
		int timer = 0;
		
		while(timer <= connTimeout){
			if (!this.isServerDisconnected()){
				break;
			}
			try{
				Thread.sleep(2 * 1000);
			}catch (InterruptedException e) { }
			timer = timer + 2;
		}
		if(timer >= connTimeout){
			return false;
		}
		return true;
	}
	
	/**
	 * Waits until response is received for a given operation
	 * Else throws Timeout Exception
	 * Private method of this class
	 */
	private String performWait(String guid) throws Exception
	{
		int connTimeout = getTimeout();
		int timer = 0;
		int partsToWait = connTimeout * 20;
		while( (socket.responseList.get(guid).length() == 0) && timer<=partsToWait) 
		{
			try {
				Thread.sleep(1 * 50);
				timer = timer + 1;
			} catch (InterruptedException e) {}
		}
		if(timer >= partsToWait){
			if(socket.isServerDisconnected())
				throw new Exception("SERVER_DISCONNECTED");
			else
				throw new Exception("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE");
		}else{
			String op = socket.responseList.get(guid);
			//clean this guid data from list.
			socket.responseList.remove(guid);
			return op;
		}
	}

	
	//========================================================================================
	// Version query related methods
	//========================================================================================
	
	/**
	 * Get Versions of all currently connected components
	 * Method used for Executor
	 */
	public String getAllVersions()	{
		String callGuid = socket.getAllVersions();
		String returnXML = "";
		try {
			returnXML = performWait(callGuid);
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getAllVersions");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getAllVersions: " + e1.getMessage());
		}
		return returnXML;
	}

	/**
	 * Sets version of Executor 
	 * Method used for Executor
	 */
	public void setExecutorVersion(String ver){
		socket.setExecutorVersion(ver);
	}

	//*****************************************
	// Different methods to get server version
	//*****************************************

	public String getUserEnvXML()
	{
		String callGuid = socket.getUserEnvXML();
			
		String returnXML = "";
		
		try {
			returnXML = performWait(callGuid);
		} catch (Exception e1) {
			Utils.printErrorOnConsole(e1.getMessage());
		}
		
		return returnXML;
	}
	
	public String getServerVersion()	{
		Utils.printMessageOnConsole("getServerVersion() called");
		String callGuid = socket.getServerVersion();
		String returnXML = "";
		try {
			Utils.printMessageOnConsole("waiting for reply for " + getTimeout() + " seconds");
			returnXML = performWait(callGuid);
			Utils.printMessageOnConsole("wait ended");
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion: " + e1.getMessage());
		}
		return returnXML;
	}
	public String getServerVersion(String myVersion)	{
		String callGuid = socket.getServerVersion(myVersion);
		String returnXML = "";
		try {
			returnXML = performWait(callGuid);
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion: " + e1.getMessage());
		}
		return returnXML;
	}

	public String getServerVersion(String myVersion, String callback)	{
		String callGuid = socket.getServerVersion(myVersion, callback);
		String returnXML = "";
		try {
			returnXML = performWait(callGuid);
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getServerVersion: " + e1.getMessage());
		}
		return returnXML;
	}
	
	//========================================================================================
	// Some Helper methods performing actions in synchronized way
	//========================================================================================
	
	/**
	 * Check if Performance Tracking Flag is enabled
	 * Method used for Executor and Plugin 
	 */
	public boolean isPerformanceTrackingEnabled()
	{
		boolean retStatus = false;
		String returnXML = "";
		
		try {
			String callGuid = socket.isPerformanceTrackingEnabled();
			returnXML = performWait(callGuid);
			retStatus = Utils.getTagValue(returnXML, "PerformanceTracking").equalsIgnoreCase("true")? true : false ;
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:isPerformanceTrackingEnabled");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:isPerformanceTrackingEnabled: " + e1.getMessage());
		}
		return retStatus;
	}
	
	public String getGenieProperties(String appName, String genieID)
	{
		String returnXML = "";
		
		try {
			String callGuid = socket.getGenieProperties(appName, genieID);
			returnXML = performWait(callGuid);			
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getGenieProperties");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getGenieProperties: " + e1.getMessage());
		}
		return returnXML;
	}

	/**
	 * Gets a list of connected SWF
	 * Method used for Executor
	 */
	public SWFList<SWFApp> getSWFList()
	{
		SWFList<SWFApp> list = null;
		String swfListStr = "";
		try {
			String callGuid = socket.getSWFList();
			swfListStr = performWait(callGuid);
			list = SharedFunctions.createSWFAppListFromXML(swfListStr);
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getSWFList");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:getSWFList: " + e1.getMessage());
			
			return null;
		}
		return list;
	}
	
	/**
	 * Pushes a SWF name to which Executor connects to Server book keeping 
	 * Method used for Executor
	 */
	public void pushSwfNameForExecutor(String swfName){
		try {
			socket.pushSwfNameForExecutor(swfName);
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:pushSwfNameForExecutor");
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:pushSwfNameForExecutor: " + e1.getMessage());
		}
	}
	
	/**
	 * Calls Preload for GetAppXML method
	 * Method used for Executor
	 */
	public String getAppXML(String appName)
	{
		String output = "";
		try {
			String callGuid = socket.getAppXML(appName);
			output = performWait(callGuid);
		} catch (Exception e1) {
			output = e1.getMessage();			
		}
		
		return output;
	}
	
	/**
	 * Calls Preload for GetAppXML method
	 * Method used for Executor
	 */
	public String getAppXMLGeneric(String appName)
	{
		String output = "";
		try {
			String callGuid = socket.getAppXMLGeneric(appName);
			output = performWait(callGuid);
		} catch (Exception e1) {
			output = e1.getMessage();			
		}
		
		return output;
	}
	
	/**
	 * @brief: Acknowledge preload about connection successful
	 */
	public void acknowledgePreload(String appName)
	{
		try {
			String callGuid = socket.acknowledgePreload(appName);
			performWait(callGuid);
		} catch (Exception e1) {						
		}
	}

	//========================================================================================
	// Some Helper methods performing actions in non synchronized way. 
	// Directly calling up Socket calls
	//========================================================================================

	/**
	 * Method used by Executor to write the performance data over socket connection via Server
	 * Method used for Executor
	 */
	public void writePerformanceData(String xmlStr){
		socket.writePerformanceData(xmlStr);
	}
	
	/**
	 * Send Server the usage metrics data
	 */
	public void sendUsageMetricsData(String xml)
	{
		socket.sendUsageMetricsData(xml);
	}
	
	/**
	 * Event sent by Executor,Decides if Usage Matrix data should be posted or not
	 * Method used for Executor
	 */
	public void setUsageMatrixPostage(boolean umatrix){
		socket.UsageMatrixPostage(umatrix);		
	}
	
	/**
	 * Sets the done flag of Socket client indicating that
	 * no more attempts should be made for connecting to server
	 * Method used for Executor
	 */
	public void setDoneFlag(){
		socket.done = true;
	}

	public String doGenericAction(String name, String action, String data)
	{
		String output = "";
		
		try {
			String callGuid = socket.performAction(name, action,data);
			output = performWait(callGuid);
			
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:doGenericAction for action " + action );
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:doGenericAction for action " + action + ": " + e1.getMessage());
		}
		return output;
	}
	//========================================================================================
	// Method to perform action on SWF
	//========================================================================================

	/**
	 * Gives Preload a request to perform operation on a SWF component
	 * Waits for its response and sets the result object accordingly
	 * Method used for Executor
	 */
	public Result doAction(String appName, String action, String data)
	{
		String output = "";
		Result result = new Result();
		result.result = false;
		result.message = "UNKNOWN_RESULT";
		try {
			String callGuid = socket.performAction(appName,action,data);
			output = performWait(callGuid);
			result.result = true;
		} catch (Exception e1) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:doGenericAction for action " + action );
				e1.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception raised on SynchronizedSocket:doGenericAction for action " + action + ": " + e1.getMessage());
			
			result.message = e1.getMessage();
		}
		
		//Parse output returned by Genie preload if no Exception has been raised
		if(result.result){
			try{
				if(output.equalsIgnoreCase("true"))	{
					result.result = true;
					result.message = "";
				}
				else if(output.equalsIgnoreCase("false")){
					result.result = false;
					result.message = "";
				}
				else if(output.toLowerCase().contains("propertyvalue") && output.toLowerCase().contains("output") ){
					result.result = true; 
					result.message = output;
				}
				else if(output.toLowerCase().contains("eventproperty") && output.toLowerCase().contains("output") ){
						result.result = true; 
						result.message = output;
				}
				else if(output.trim().equalsIgnoreCase("")){
					result.result = false; 
					result.message = "PRELOAD_RETURNED_NOTHING";
				}
				else{
					result.result = false; 
					result.message = output;
				}
			}
			catch(Exception e)
			{
				result.result = false; 
				result.message = output;
			}
		}
		return result;
	}
}

//[Piyush] Commented these customized functions. Now every calls uses doAction method
// Also commented out method PerformLessWait. Now we use one common method
/*	public String getValueOf(String appName, String genieId, String propName)
{
	String callGuid = socket.performAction(appName, "getValueOf" , "<XML><Input><GenieID>" + genieId + "</GenieID><PropertyName>" + propName +"</PropertyName></Input></XML>");
	String output = "";
	
	try {
		output = performWait(callGuid);
	} catch (Exception e1) {
		Utils.printErrorOnConsole(e1.getMessage());
	}
	
	return output;
}

public String getCellValue(String appName, String genieId, int columnIndex, int rowIndex)
{
	String callGuid = socket.performAction(appName, "getCellValue" , "<XML><Input><GenieID>" + genieId + "</GenieID><PropertyName>" + columnIndex +"</PropertyName><PropertyName>" + rowIndex +"</PropertyName></Input></XML>");
	String output = "";
	
	try {
		output = performWait(callGuid);
	} catch (Exception e1) {
		Utils.printErrorOnConsole(e1.getMessage());
	}
	
	return output;
}

public String getRowValue(String appName, String genieId, int rowIndex)
{
	String callGuid = socket.performAction(appName, "getRowValue" , "<XML><Input><GenieID>" + genieId + "</GenieID><PropertyName>" + rowIndex +"</PropertyName></Input></XML>");
	String output = "";
	
	try {
		output = performWait(callGuid);
	} catch (Exception e1) {
		Utils.printErrorOnConsole(e1.getMessage());
	}
	
	return output;
}

public String getRowCount(String appName, String genieId)
{
	String callGuid = socket.performAction(appName, "getRowCount" , "<XML><Input><GenieID>" + genieId + "</GenieID></Input></XML>");
	String output = "";
	
	try {
		output = performWait(callGuid);
	} catch (Exception e1) {
		Utils.printErrorOnConsole(e1.getMessage());
	}
	
	return output;
}


	private String performLessWait(String guid) throws Exception
	{
		int timer = 0;
		while( (socket.responseList.get(guid).length() == 0) && timer!=timeout) 
		{
			try {
				Thread.sleep(50);
				timer = timer + 2;
			} catch (InterruptedException e) {				
			}
		}
		if(timer == timeout)
		{
			throw new Exception("timeout");
		}
		else
		{
			String op = socket.responseList.get(guid);
			socket.responseList.remove(guid);
			return op;
		}
	}
*/	
