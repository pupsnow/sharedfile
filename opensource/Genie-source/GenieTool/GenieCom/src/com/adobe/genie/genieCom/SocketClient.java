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

import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.UUID;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.XmlDoc;

/**
 * This class provides all functionality of Socket to Connect with Server
 * <p>
 * Is a singleton Class and should be used appropriately 
 * 
 * @since Genie 0.4
 */
public class SocketClient extends Thread
{
	//default port number
    private int DESTINATION_PORT = 61120;
    private String destIpAddress = "localhost";
    
    public boolean done = false;
    
	private Socket socket;
	private PrintWriter out;
	private DataInputStream in = null;
    private String name;
    
    private Object obj;
    
    private String pluginVersion;
    private String executorVersion;
    private static SocketClient instance = null;
    private boolean isServerConnected = false;
    private boolean isDebugMode = false;
    
    /**
     * Added for throwing exception when socket is explicitly closed
     * @author gsingal
     */
    private class DeliberateSocketCloseException extends Exception
    {

		/**
		 * Generated Serial version UID
		 */
		private static final long serialVersionUID = 9000883236199014580L;	
    }
    
    protected HashMap<String, String> responseList;
    
	//========================================================================================
    //Strings for prelaod actions.
	//========================================================================================
    private static final String PRELOAD_SET_DEBUG_FLAG = "SetDebugFlag";
    private static final String PRELOAD_ENABLE_FINDER = "EnableFinder";
    private static final String PRELOAD_DISABLE_FINDER = "DisableFinder";
    private static final String PRELOAD_GLOW = "Glow";
    private static final String PRELOAD_GET_APP_XML = "getAppXML";
    private static final String PRELOAD_GET_APP_XML_GENERIC = "getAppXmlGeneric";
    private static final String PRELOAD_CONFIRM_CONNECTION = "connected2Plugin";
    private static final String PRELOAD_UN_GLOW = "unGlow";
    private static final String PRELOAD_ENABLE_SHOW_COORDINATES = "enableShowCoordinates";
    private static final String PRELOAD_DISABLE_SHOW_COORDINATES = "disableShowCoordinates";
    private static final String PRELOAD_ENABLE_RECORD_UI_FUNCTIONS = "enableRecordingUIActions";
    private static final String PRELOAD_DISABLE_RECORD_UI_FUNCTIONS = "disableRecordingUIActions";
    private static final String PRELOAD_SHOW_GENIE_ICON = "showGenieIcon";
    private static final String PRELOAD_HIDE_GENIE_ICON = "hideGenieIcon";
    private static final String PRELOAD_GET_GENIE_PROPERTIES = "getGenieProperties";
    
    private static final String dataTag = "Genie_Call_Data";
    private static final String dataStartTag = "<" + dataTag + ">";
    private static final String dataEndTag = "</" + dataTag + ">";
    
	//========================================================================================
	// Constructor methods to make this class Singleton
	//========================================================================================

	/**
	 * Return instance of SocketClient
	 */
    public static SocketClient getInstance() {
	     return instance;
	}

    /**
	 * Initialize SocketClient and returns instance of SocketClient class.
	 * Executor will use SynhronizedSocket class.
	 * 
 	 * @param name 
 	 * 		Name of the socket
	 * @param obj 
	 * 		Class object whom functions should be called as actions.
	 * 		Currently valid in case of Plugin.
	 * 
	 * @return SocketClient's singleton instance
	 * 
	 */
    public static SocketClient getInstance(String name, Object obj){
	     if(instance == null){
	        instance = new SocketClient(name,obj);
	     }
	     return instance;
	}

    /**
	 * Dispose Socket object
	 */
	public void dispose() {
	    this.done = true;
	    this.close();
	    this.responseList = null;
	    instance = null;
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e1) {}
	}
    
	/**
	 * SocketCleint actually initialized
	 */
    public SocketClient(String name, Object obj) {
		this.name = name;
		this.obj = obj;
		responseList = new HashMap<String, String>();
		this.start();
	}
    
    /**
	 * SocketCleint actually initialized
	 */
    public SocketClient(String name, Object obj, int port) {
		this.name = name;
		this.obj = obj;
		responseList = new HashMap<String, String>();
		DESTINATION_PORT = port;
		this.start();
	}
    
    public void setDestIpAddress(String ipAddrArg)
    {
    	this.destIpAddress = ipAddrArg;
    }
    
    public boolean waitForSocketConnection()
	{
		int connTimeout = 15;
		int timer = 0;
		
		while(timer <= connTimeout){
			try {
				if (!this.isServerDisconnected()){
					break;
				}
				Utils.printMessageOnConsole("Waiting for socket to be connected...");
				Thread.sleep(2 * 1000);
				timer = timer + 2;
			} catch (InterruptedException e) {}
		}
		if(timer >= connTimeout){
			return false;
		}
		return true;
	}
    public boolean isConnectedToRemoteHost()
    {
    	return !this.destIpAddress.equals("localhost");
    }
    
	//========================================================================================
	// Properties Getter/Setter
	//========================================================================================
    public void setPluginVersion(String version){
    	this.pluginVersion = version;
    }
    public String getPluginVersion(){
    	return this.pluginVersion;
    }
    
    public void setExecutorVersion(String version){
    	this.executorVersion = version;
    }
    public String getExecutorVersion(){
    	return this.executorVersion;
    }
    
    public boolean isSocketClosed(){
    	if (socket == null)
    		return true;
    	return socket.isClosed();
    }
	
    public boolean getDebugMode(){
		return isDebugMode;
	}
	private void setDebugMode(boolean mode){
		isDebugMode = mode;
		if (isDebugMode)
			Utils.printMessageOnConsole("Extra Debug Information while Execution is ON");
	}
    
	public boolean isServerDisconnected(){
		return !this.isServerConnected;
	}

	//========================================================================================
	// Methods to make calls on Server and for which the recipient is Server
	//========================================================================================

	public void sendUsageMetricsData(String xml)
    {
    	sendCommand("Server", "UsageMetricsData", "" , xml);
    }
    
    /**
     * Get user supplied Environment XML if user has supplied
     */
	public String getUserEnvXML()
	{
		UUID uuid = UUID.randomUUID();
		String guid = uuid.toString();
		responseList.put(guid, "");
		   	    
		String data = "<Client><Name>" + this.name+ "</Name></Client>";
		   	    
		sendCommand("Server", "getUserEnvironmentXML", "" , data, guid);
		       	
		return guid;
	}
       
    /**
     * Notify Server to print back performance Data
     */
    public void writePerformanceData(String data){
    	String dt = Utils.getTagValue(data, "PerfData");
    	sendCommand("Server", "writePerformanceData", "", dt);
    }
    
    /**
     * This method tells the server to enable or disable postage of data to usage matrix.
     */
    public void UsageMatrixPostage(boolean umatrix){   
    	//setting string based on the value of umatrix ,because method sendCommand can only take string parameter as input
    	String st;
    	if(umatrix) 
    		st="true";
    	else 
    		st="false";
    	sendCommand("Server", "enableUsageMatrix", "",st);
    }

	/**
	 * Push SWF name being connected by Executor for Server Book keeping
	 */
	public synchronized void pushSwfNameForExecutor(String swfName) {
	    String data = "<Client><swfName>" + swfName + "</swfName></Client>";
	    sendCommand("Server", "saveSwfNameForExecutor", "", data);
	}
	
	/**
	 * Gets current SWF list from server and callback a method with list
	 */
	public synchronized void getSWFList(String callBackMethod){
		sendCommand("Server", "getClientList", callBackMethod , "");
	}

	/**
	 * Gets current SWF list from server
	 * Primarily being used for Synchronized call
	 */
	public synchronized String getSWFList(){
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    sendCommand("Server", "getClientList", "swfListReceived", "", guid);
	    
	    return guid;
	}
	
	/**
	 * Check if Performance Tracking is enabled
	 */
	public synchronized String isPerformanceTrackingEnabled() {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name></Client>";
	    sendCommand("Server", "isPerformanceTrackingEnabled", "tracePerformance", data, guid);
	    
	    return guid;
	}
	
	/**
	 * Only get server version
	 * return contains XML having server version only
	 */
	public synchronized String getServerVersion() {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name></Client>";
	    sendCommand("Server", "getServerVersion", "", data, guid);
	    
	    return guid;
	}
	/**
	 * The sender component sending its own version, and getting server version
	 * return contains server version, also compatibility flag (from server point of view)
	 */
	public synchronized String getServerVersion(String myVersion) {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name>" +
	    		"<Version>"+ myVersion +"</Version></Client>";
	    sendCommand("Server", "getServerVersion", "", data, guid);
	    
	    return guid;
	}
	
	/**
	 * The sender component sending its own version, and getting server version and with callback method
	 * return contains server version, also compatibility flag (from server point of view)
	 */
	public synchronized String getServerVersion(String myVersion, String callback) {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    
	    String data = "<Client><Name>" + this.name+ "</Name>" +
	    		"<Version>"+ myVersion +"</Version></Client>";
	    sendCommand("Server", "getServerVersion", callback, data, guid);
	    return guid;
	}

	/**
	 * Checks the version info from server
	 */
	public synchronized void sendVersionInfo(String callbackMethod) {
		sendCommand("Server", "checkVersion", callbackMethod, "<PluginVersion>" + this.getPluginVersion() + "</PluginVersion>" );
	}
	
	/**
	 * Get Version information for all components from Server
	 */
	public synchronized String getAllVersions() {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name></Client>";
	    sendCommand("Server", "getAllVersions", "", data, guid);
	    
	    return guid;
	}
	
	//======================================================================================
	//	Device related methods
	//======================================================================================
	
	/**
	 * To get deviceList
	 */
	public synchronized String getDeviceList() {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name></Client>";
	    sendCommand("Server", "getDeviceList", "", data, guid);
	    
	    return guid;
	}
	
	/**
	 * Called by Device controller to update device list to server
	 */
	/*public synchronized String deviceListUpdate(String deviceXML)
	{
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<Client><Name>" + this.name+ "</Name></Client>";
	    
	    socket.sendCommand("Server", "deviceListUpdate", "", deviceXml);
	    
	    sendCommand("Server", "getDeviceList", "", data, guid);
	    
	    return guid;
	}*/
	
	//========================================================================================
	// Methods to make calls on Server and for which the recipient is a preloaded Application
	//========================================================================================
  
	/**
	 * This function performs given action on Preload SWF with the arguments given in data field
	 */
	public synchronized String performAction(String appName, String action, String data) {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    sendCommand(appName, action , "", data, guid);

	    return guid;
	}

	/**
	 *  Attach all Event Listeners to application
	 *  Gets an application XML
	 */
	public String getAppXML(String appName) {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    sendCommand(appName, PRELOAD_GET_APP_XML , "", "<String>" + appName +"</String>", guid);

	    return guid;
	}

	/**
	 *  Attach all Event Listeners to application.
	 *  This method also specifies a callback method
	 *  Gets an application XML
	 */
	public void getAppXML(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_GET_APP_XML , callBackAction, "<String>" + appName +"</String>");
	}
	
	/**
	 *  Just Gets an application XML
	 */
	public String getAppXMLGeneric(String appName) {
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    sendCommand(appName, PRELOAD_GET_APP_XML_GENERIC , "", "<String>" + appName +"</String>", guid);

	    return guid;
	}

	/**
	 * @brief Acknowledge preload about got xml perfectly
	 */
	public String acknowledgePreload(String appName)
	{
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    sendCommand(appName, PRELOAD_CONFIRM_CONNECTION , "", "<String>" + appName +"</String>", guid);

	    return guid;
	}
	
	/**
	 * Notify SWF that client is now disconnected 
	 */
	public void disconnectSWF(String appName, String callBackAction) {
		sendCommand(appName, PRELOAD_SET_DEBUG_FLAG, callBackAction, "<Boolean>false</Boolean>");
	}
	 
	/**
	 * Notify SWF to send/not send delta information 
	 */
	public void setDebugFlag(String appName, Boolean flag, String callBackAction) {
		sendCommand(appName, PRELOAD_SET_DEBUG_FLAG, callBackAction, "<Boolean>"+ flag.toString()+"</Boolean>");
	}

	//========================================================================================
	// Methods to make calls on Server and for which the recipient is a preloaded Application
	// These calls are for Plugin for corresponding UI actions
	//========================================================================================
	 
	public void enableFindComponent(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_ENABLE_FINDER , callBackAction, "");
	}
	
	public void disableFindComponent(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_DISABLE_FINDER , callBackAction, "");
	}
	
	public void enableShowCoordinates(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_ENABLE_SHOW_COORDINATES , callBackAction, "");
	}
	
	public String getGenieProperties(String appName, String genieID)
	{
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
	    
	    responseList.put(guid, "");
	    String data = "<String>" + genieID + "</String>";
	    
	    sendCommand(appName, PRELOAD_GET_GENIE_PROPERTIES, "", data, guid);
	    return guid;
	}
	
	public void disableShowCoordinates(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_DISABLE_SHOW_COORDINATES , callBackAction, "");
	}
	
	public void enableRecordingUIFunctions(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_ENABLE_RECORD_UI_FUNCTIONS , callBackAction, "");
	}
	
	public void disableRecordingUIFunctions(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_DISABLE_RECORD_UI_FUNCTIONS , callBackAction, "");
	}
	
	public void showGenieIcon(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_SHOW_GENIE_ICON , callBackAction, "");
	}
	
	public void hideGenieIcon(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_HIDE_GENIE_ICON , callBackAction, "");
	}
	
	public void glow(String appName, String selectedText, String callBackAction){
		String data = "<String>" + selectedText +"</String>";
		sendCommand(appName, PRELOAD_GLOW , callBackAction, data);
	}
	
	public void unGlow(String appName, String callBackAction){
		sendCommand(appName, PRELOAD_UN_GLOW , callBackAction, "");
	}
	
	//========================================================================================
	// Core Methods to make calls on Server
	//========================================================================================
   
    /**
     * This method is used to send command to server
     * Method is primarily used where no trace back to response is required
     * 
     * @param destination
     * @param action
     * @param callBackAction
     * @param data
     */
	public synchronized void sendCommand(String destination, String action, String callBackAction, String data){
    	try{
    		StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><Dest>" + destination+ "</Dest><Action>"+action+"</Action>" +
    				"<CallBackAction>"+callBackAction+"</CallBackAction>"+dataStartTag);
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
   			out.println(dataToSend.length() -1  + ";" + dataToSend);
    	}
    	catch(Exception e){
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception on SocketClient:sendCommand");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception on SocketClient:sendCommand: " + e.getMessage());
    	}
	}
	
	public synchronized void sendCommand(String from, String destination, String action, String callBackAction, String data, String callID, String respGUID){
		responseList.put(callID, "");
    	try{
    		StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><CallGUID>" + callID + "</CallGUID><RespGUID>" + respGUID + "</RespGUID><From>" + from+ "</From><Dest>" + destination+ "</Dest><Action>"+action+"</Action>" +
					"<CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag);
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
    		out.println(dataToSend.length() -1  + ";" + dataToSend);
    	}
    	catch(Exception e){
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback: " + e.getMessage());
    	}
	}
	
	/**
	 * This method is used to send command to server along with a GUID to track the response back
	 * 
	 * @param destination
	 * @param action
	 * @param callBackAction
	 * @param data
	 * @param callID
	 */
	public synchronized void sendCommand(String destination, String action, String callBackAction, String data, String callID){
		responseList.put(callID, "");
    	try{
    		
    		StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><CallGUID>" + callID + "</CallGUID><Dest>" + destination+ "</Dest><Action>"+action+"</Action>" +
					"<CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag);
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
    		out.println(dataToSend.length() -1  + ";" + dataToSend);
   			
    	}
    	catch(Exception e){
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback: " + e.getMessage());
    	}
	}
	
	/**
	 * This method is used to send response signal to callee w.r.t. respID
	 * 
	 * @param destination
	 * @param action
	 * @param callBackAction
	 * @param data
	 * @param callID
	 */
	public synchronized void sendResponse(String destination, String action, String callBackAction, String data, String respID){
		try{
			
			StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><RespGUID>"+ respID +"</RespGUID><Dest>" + destination+ "</Dest><Action>"+action+"</Action>" +
					"<CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag );
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
    		out.println(dataToSend.length() -1  + ";" + dataToSend);
   			
    	}
    	catch(Exception e){
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception on SocketClient:sendCommandWithTraceback: " + e.getMessage());
    	}
	}
 
	//========================================================================================
	// Core Methods for Socket Infrastructure
	//========================================================================================

	/**
	 * Start the Thread
	 */
	@Override
    public void run()
    {
    	try	{
    		if(!done)
    			connect();
			
    		while(socket.isConnected() && !done) {
		 	try {
		 		/* read the input into a String */
				String inputStream = read(in);

				if(inputStream.equals("")) {
					break;
				} else
					processInput(inputStream);
		
				//Wait
			    } catch(Exception e) {
			    	//lets tell plugin about this disconnection
			    	Method method;			
					try {
						if(this.name.equalsIgnoreCase(Utils.PLUGIN_NAME_STR)){
							method = obj.getClass().getMethod("ServerClosed", String.class, String.class);
							method.invoke (this.obj, "", "");
						}
					} catch (SecurityException ex) {
						// ...
					} catch (NoSuchMethodException ex) {
						// ...
					} catch(Exception ex)
					{
						Utils.printMessageOnConsole("Closing Plugin connection...");
						throw new DeliberateSocketCloseException(); //Bug fix by gsingal. Bug #2794515
					}
					
			    	//Server disconnected, lets try to connect it again
			    	connect();
			    }
			}
    		close();
    	}  
    	catch(DeliberateSocketCloseException ex)
		{
    		//Bug fix by gsingal. Bug #2794515
			//Just catch this exception
    		//Only in case when plugin is explicitly closed
		}
    	catch (Exception e) {
			Utils.printErrorOnConsole("Could not connect to Socket server on Port" + DESTINATION_PORT);
			if (getDebugMode()){
				Utils.printErrorOnConsole("Terminating as Exception raised on SocketClient:connect");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Terminating as Exception raised on SocketClient:connect: " + e.getMessage());
			
			System.exit(1);
		 }
    }
   
	/**
	 * Establish Connection with Server
	 */
	private void connect() {
		try
    	{
			boolean keepTrying = true; 
	    	while(keepTrying && !done)
	    	{
	    		try {
		    		socket = new Socket();
		    		
		    		InetSocketAddress endPoint = new InetSocketAddress(this.destIpAddress, DESTINATION_PORT );
		    		
		    		isServerConnected = false;
		    		socket.connect(  endPoint , 2000 );
		    		keepTrying = false;
		    		isServerConnected = true;
		    	}
	    		catch (UnknownHostException e) {
		        	Utils.printErrorOnConsole("Unknown Server host");
					keepTrying = true;
				} catch (IOException e) {
					Utils.printErrorOnConsole("Thread could not Connect to Server");
					keepTrying = true;
					
					Method disconnectionMethod = null;			
					try
					{
						if (this.obj != null)
						{
							disconnectionMethod = this.obj.getClass().getMethod("SocketClosed", String.class, String.class);
							if (disconnectionMethod != null)
								disconnectionMethod.invoke(this.obj, "", "");
						}
					}
					catch (SecurityException ex) {}
					catch (NoSuchMethodException ex) {}
					catch(Exception ex){}
				}
				finally {
					 try{
						 if(keepTrying)
			    			Thread.sleep(2* 1000);
					 }catch(InterruptedException e){}
				 }
			}
	    	
	    	if (!socket.isClosed()){
		    	out = new PrintWriter(socket.getOutputStream(),true);
		    	in = new DataInputStream(socket.getInputStream());
	    	}
	
			if(socket.isConnected()){
				if (this.name.equalsIgnoreCase(Utils.PLUGIN_NAME_STR)){
					sendCommand("Server", "addClient", "setServerVersion", 
						"<Client><Name>" + this.name+ "</Name>" +
						"<Version>"+ this.getPluginVersion() +"</Version></Client>");
				}
				else{
					sendCommand("Server", "addClient", "", 
							"<Client><Name>" + this.name+ "</Name></Client>");
				}
			}

    	} catch (Exception e) {
			Utils.printErrorOnConsole("Could not connect to Socket server on Port" + DESTINATION_PORT);
			if (getDebugMode()){
				Utils.printErrorOnConsole("Terminating as Exception raised on SocketClient:connect");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Terminating as Exception raised on SocketClient:connect: " + e.getMessage());
			
			System.exit(1);
		 }
	}
	
	/**
	 * This method closes the socket connection
	 */
	 public synchronized void close(){
		done = true;
		try {
			if(out != null){
				out.close();
			}
			if(in != null){
				in.close();
			}
			socket.close();
		} catch (IOException e) {
			if (getDebugMode()){
				Utils.printErrorOnConsole("Exception on SocketClient:close");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Exception on SocketClient:close: " + e.getMessage());
		}
	 }

	 
	/**
	 * Processes the input messages received from Server
	 */
	private void processInput(String input) {
		XmlDoc doc;
		input = input.trim();
		//long start = (new Date()).getTime();
		//LogData.getInstance().trace("Performance", "StartProcessInput::" + start);
		
		if(input.indexOf('<')!=-1 && input.indexOf('>')!=-1) {
			//Clean input
			while(input.charAt(0)!='<')
				input = input.substring(1, input.length());
			while(input.charAt(input.length()-1)!='>')
				input = input.substring(0, input.length()-1);
		}else
			input = "";
		
		if(!input.equals("")) {
			try {
				doc = new XmlDoc(input);

				String action = "";
				String from = "";
				String callGUID = "";
				String respGUID = "";
				
				@SuppressWarnings("unused")
				String callBackAction = "";
				
				//Action - action to be performed.
				try{
					action = doc.getNodeValue("//Call/Action"); //<Action/>
				}catch(Exception e){}
				
				//CallGUID - A GUID for the requests. Responses of such requests are tracked in responselist hash table. This is a public Hash Table. 
				try{ 
					callGUID = doc.getNodeValue("//Call/CallGUID"); //<CallGUID/>
				}catch(Exception e){}
				
				//Response GUID. Responses of requests with CallGUID has the same GUID placed in RespGUID field.
				try{ 
					respGUID = doc.getNodeValue("//Call/RespGUID");  //<RespGUID/>
				}catch(Exception e){}
				
				//Origin of Call
				try{
					from = doc.getNodeValue("//Call/From"); //<From/>
				}catch(Exception e){}
				
				try{
					callBackAction =  doc.getNodeValue("//Call/CallBackAction"); //<CallBackAction/>
				}catch(Exception e){}
				
				String data = Utils.getTagValue(input, dataTag);
				Method method;			
				try {
					if(callGUID.length() > 0){
						responseList.put(callGUID, "");
					}
					if(respGUID.length() > 0){
						if( responseList.get(respGUID) != null){
							responseList.put(respGUID, data);
							if(action == null || action.length() == 0)
								return;
						}
					}
					
					//See if some action needs to be taken locally based on message from Server
					handleActionLocally(action,from, data);
					
					//Pass on server message to other components by invoking there methods
					if(this.name.equalsIgnoreCase(Utils.PLUGIN_NAME_STR))
					{
						method = obj.getClass().getMethod(action, String.class, String.class);
						method.invoke (this.obj, from, data);						
					}
					else if(this.name.equalsIgnoreCase(Utils.EXECUTOR_NAME_STR))
					{
						if (obj != null){
							method = obj.getClass().getMethod(action, String.class, String.class);
							method.invoke (this.obj, from, data);
						}
					}
				} catch (SecurityException e) {
					if (getDebugMode()) e.printStackTrace();
				} catch (NoSuchMethodException e) {
					//
				} 
			}
			catch(Exception e) {
				if (getDebugMode()){
					Utils.printErrorOnConsole("Exception on SocketClient:processInput");
					e.printStackTrace();
				}
				else Utils.printErrorOnConsole("Exception on SocketClient:processInput: " + e.getMessage());
			}
		}
		
		//long end = (new Date()).getTime();
		//LogData.getInstance().trace("Performance", "EndProcessInput::" + (end-start));
	}
	
    /**
     * Reads the input stream into String Buffer
     */
//	private String read(BufferedReader reader) throws IOException, EOFException, InterruptedIOException {
//		StringBuffer buffer = new StringBuffer();
//		int codePoint;
//		boolean zeroByteRead=false;
//
//		do {
//			codePoint = reader.read();
//			if(codePoint==0)
//				zeroByteRead=true;
//			else
//				buffer.appendCodePoint(codePoint);
//		} while(!zeroByteRead);
//
//		return buffer.toString();
//	}
	
	private String read(DataInputStream reader) throws IOException, EOFException, InterruptedIOException {
		StringBuilder buffer = new StringBuilder(256);
		StringBuffer tempBuffer = new StringBuffer();
		int codePoint;
		boolean zeroByteRead=false;
		boolean bFound = false;
		do{
			codePoint = reader.read();
			if(codePoint == '<' || codePoint == ';')
				bFound = true;
			else
				tempBuffer.appendCodePoint(codePoint);
		}while(!bFound);
		if(codePoint == '<')
		{
			//This request is coming from DC
			buffer.append(tempBuffer);
			buffer.appendCodePoint('<');
			do {
				codePoint = reader.read();
				if(codePoint==0)
					zeroByteRead=true;
				else
					buffer.appendCodePoint(codePoint);
			} while(!zeroByteRead);
		}
		else
		{
			//This request is coming from Preload
			int length = -1; //reader.readInt();
			try{
				length = Integer.parseInt(tempBuffer.toString().trim());
				
			}catch(Exception e)
			{
			}
			if(length > 0)
			{
				int count = 0;
				int step = 1024;
				int remaining = length;
				buffer = new StringBuilder(length);
				do{
					if(step > length)
						step = length;
					if(remaining < step)
						step = remaining;
					byte[] tempArray = new byte[step];
					int numOfBytesRead = reader.read(tempArray,0, step);
					count = count + numOfBytesRead;
					remaining = length - count;
					buffer.append(new String(tempArray,0,numOfBytesRead));
				}while(count < length);
				
				zeroByteRead = false;
				do {
					codePoint = reader.read();
					if(codePoint==0)
						zeroByteRead=true;
					else
						buffer.appendCodePoint(codePoint);
				} while(!zeroByteRead);
			}
			else
			{
				do {
					codePoint = reader.read();
					if(codePoint==0)
						zeroByteRead=true;
					else
						buffer.appendCodePoint(codePoint);
				} while(!zeroByteRead);
			}
		}
		return buffer.toString();
	}
	
	/**
	 * This methods listens to all messages received from server and act on certain actions locally
	 * Primarily if based on any kind of action something needs to be set/unset/acted upon within
	 * scope of Synch Socket or Socket client. This is place for it
	 * In case of any confusion please contact Piyush
	 */
	private void handleActionLocally(String action, String from,String data){
		if (action.equalsIgnoreCase("tracedebug")){
			setDebugMode(Utils.getTagValue(data, "Boolean").equalsIgnoreCase("true")? true : false);
		}
	}
}

/*
	public synchronized void versionReply()
	{
		String test = "";
		test = "";
	}

	private String elementToString(GenieXMLNode node) {
		try {
			String es = node.toXMLString();
			
			return es.substring(es.indexOf("< + Genie_Call_Data>")+6, es.indexOf("</Genie_Call_Data>"));
		} catch(Exception e) {
			
		}
		return "";
	}

   public static void main(String[] args){
		new SocketClient(Utils.PLUGIN_NAME_STR, null);
    }
*/