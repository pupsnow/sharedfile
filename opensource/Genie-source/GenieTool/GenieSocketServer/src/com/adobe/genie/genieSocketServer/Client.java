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

import java.io.DataInputStream;
import java.io.EOFException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.log.LogData;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;


/**
 * A Client thread runs for per SWF App, Executor and Plugin.
 */
public class Client extends Thread {

	private Socket client;
	private PrintWriter out;
	private String clientName;
	private String toggleUmatrix;
	private ClientList clientList;
	private LogData log = LogData.getInstance();
	private Hashtable<String, String> eventMethodList;
	
	public static final String dataTag = "Genie_Call_Data";
    public static final String dataStartTag = "<" + dataTag + ">";
    public static final String dataEndTag = "</" + dataTag + ">";
    
	//========================================================================================
	// Constructor and Client Thread initialization 
	//========================================================================================

	public Client(Socket client, ClientList clientList) {
		super("Client");
		this.client = client;
		this.clientList = clientList;
		eventMethodList = new Hashtable<String, String>();
		this.start();
	}
	
	@Override
	public void run() {
		DataInputStream in = null;
	    try{
	    	in = new DataInputStream(client.getInputStream());
	      out = new
	      PrintWriter(client.getOutputStream(), true);
	    } catch (IOException e) {
	    	Shared.displayExecptionInfo(e,"Exception while creating Client thread. Aborting Server!!!");
	    	System.exit(-1);
	    }

	    // Infinite block untill client remains connected
	    while(client.isConnected()) {
	    	try {
	    		/* read the input into a String */
				String inputStream = read(in);
	    						
				if(inputStream.equals("")) {
					break;
				} else
					processInput(inputStream, false);
		    } catch(Exception e) {
		    	//This happens when the connection is lost.
		    	//Continue with disconnect.
		    	break;
		    }
	    }
	    log.trace(LogData.INFO, "Socket Connection Disconnected for client: " + clientName);
	    
	    if(clientName != null)
	    	this.clientList.handleRemoveClient(this.getName());
	    
	    this.finalize();
	}

	protected void finalize() {
		try 
		{
			client.close();
		} 
		catch(Exception e) 
		{
			Shared.displayExecptionInfo(e,"Exception while closing Client thread");
		}
	}
	
	
	//========================================================================================
	// Some public exposed methods 
	//========================================================================================
	
	public void addToEventMethodList(String serverMethod, String callBackMethod) {
		eventMethodList.put(serverMethod, callBackMethod);
	}

	public void sendDebuggingFlag(Boolean flag){
		sendCommand("Server", "SetDebugFlag", "", "<Boolean>"+flag.toString()+"</Boolean>");
	}

	public synchronized void sendCommand(String from, String action, String callBackAction, String data){
		try{
			StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><From>"+from+"</From><Action>"+action+"</Action><CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag  );
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
   			out.println(dataToSend.length() -1 + ";" + dataToSend);
   			
			if(!action.equalsIgnoreCase("transmitEnv"))
			{
				//Log while debugging..
				StringBuffer sb = new StringBuffer();
				sb.append("sendCommand:");
				if ((from != null) && (from.length() > 0))
					sb.append(" From: " + from);
				if ((action != null) && (action.length() > 0))
					sb.append(", Action: " + action);
				if ((callBackAction != null) && (callBackAction.length() > 0))
					sb.append(", callbackAction: " + callBackAction);
				
				log.traceDebug(LogData.INFO, sb.toString());
			}
		} catch (Exception e){
			Shared.displayExecptionInfo(e,"Error while sending Command to client originating from: " + from + " Action: " + action + " CallBack: " + callBackAction);
		}
	}
	
	public synchronized void sendCommand(String from, String action, String callBackAction, String data, String callID, String respID){
		try{
			StringBuilder dataToSend = new StringBuilder(data.length() + 500);
    		dataToSend.append("<Call><From>"+from+"</From><RespGUID>"+ respID +"</RespGUID><CallGUID>"+ callID +"</CallGUID><Action>"+action+"</Action><CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag);
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
    		out.println(dataToSend.length() -1 + ";" + dataToSend);
   			
			if(!action.equalsIgnoreCase("transmitEnv"))
			{ 
				StringBuffer sb = new StringBuffer();
				sb.append("sendCommand:");
				if ((from != null) && (from.length() > 0))
					sb.append(" From: " + from);
				if ((action != null) && (action.length() > 0))
					sb.append(", Action: " + action);
				if ((callBackAction != null) && (callBackAction.length() > 0))
					sb.append(", callbackAction: " + callBackAction);
				
				log.traceDebug(LogData.INFO, sb.toString());
			}
		} catch (Exception e){
			Shared.displayExecptionInfo(e,"Error while sending Command to client originating from: " + from + " Action: " + action + " CallBack: " + callBackAction + " CallID: " + respID);
		}
	}
	
	public synchronized void sendCommand(String from, String dest, String action, String callBackAction, String data, String callID, String respID){
		try{
			
			StringBuilder dataToSend = new StringBuilder(data.length() + 500);
						
    		dataToSend.append("<Call><From>"+from+"</From><Dest>"+dest+"</Dest><RespGUID>"+ respID +"</RespGUID><CallGUID>"+ callID +"</CallGUID><Action>"+action+"</Action><CallBackAction>"+callBackAction+"</CallBackAction>" + dataStartTag);
    		dataToSend.append(data);
    		dataToSend.append(dataEndTag+ "</Call>\0");
    		
    		out.println(dataToSend.length() -1 + ";" + dataToSend);
   			
			if(!action.equalsIgnoreCase("transmitEnv"))
			{ 
				//Log while debugging..
				StringBuffer sb = new StringBuffer();
				sb.append("sendCommand:");
				if ((from != null) && (from.length() > 0))
					sb.append(" From: " + from);
				if ((action != null) && (action.length() > 0))
					sb.append(", Action: " + action);
				if ((callBackAction != null) && (callBackAction.length() > 0))
					sb.append(", callbackAction: " + callBackAction);
				
				log.traceDebug(LogData.INFO, sb.toString());
			}
		} catch (Exception e){
			Shared.displayExecptionInfo(e,"Error while sending Command to client originating from: " + from + " Action: " + action + " CallBack: " + callBackAction + " CallID: " + respID);
		}
	}
	
	//========================================================================================
	// Some private methods used here 
	//========================================================================================
	
	/**
	 * Process the input stream
	 * If exception comes because of an invalid character allowed in XML, 
	 * 		- that character is encoded by its hex value surrounded by a string 
	 * 			so that preload recognize it
	 * 		- Call same function in recursion
	 * Note: the flag isCalledRecursive is because, we want to call it only once in case of exception
	 * 	to avoid indefinite recursive calls
	 */
	
	private void processInput(String input, boolean isCalledRecursive) {
		XmlDoc doc;
		//long start = (new Date()).getTime();
		//log.trace("Performance", "StartProcessInput::" + start);
		if(input.indexOf('<')!=-1 && input.indexOf('>')!=-1) {
			//Clean input
			while(input.charAt(0)!='<')
				input = input.substring(1, input.length());
			while(input.charAt(input.length()-1)!='>')
				input = input.substring(0, input.length()-1);
		} else
			input = "";
		
		if(!input.equals("")) {
			try {
				doc = new XmlDoc(input);

				String dest = doc.getNodeValue("//Call/Dest"); //<Dest/>
				String from = "";
				String action = doc.getNodeValue("//Call/Action"); //<Action/>
				String callBackAction = "";
				try{
					callBackAction = doc.getNodeValue("//Call/CallBackAction"); //<CallBackAction/>
				}catch(Exception e){}
				try{
					from = doc.getNodeValue("//Call/From"); //<CallBackAction/>
				}catch(Exception e){}

				String callGUID = "";
				try{
					callGUID = doc.getNodeValue("//Call/CallGUID");//<CallGUID/>
				}catch(Exception e){}

				String respGUID = "";
				try{
					respGUID = doc.getNodeValue("//Call/RespGUID"); //<RespGUID/>
				}catch(Exception e){}

				XmlNode data = doc.getNode("//Call/" + dataTag); //</>
								
				if(dest.equals("Server")) {
					processServerAction(action, data, callBackAction, callGUID);
				} 
				else {
					String dataStr = Utils.getTagValue(input, dataTag);	
					processOutgoingAction(from, dest, action, dataStr, callBackAction, callGUID, respGUID);
				}
			} catch(Exception e) {
				
				if (!isCalledRecursive)
				{
					input = XmlDoc.getEncodedCharString(input);
					
					processInput(input, true);
					return;
				}
				else
				{
					Shared.displayExecptionInfo(e,"Error while processing input stream at Server");
					Shared.displayExecptionInfo(e, input);
				}
			}
		}
		//long end = (new Date()).getTime();
		//log.trace("Performance", "EndProcessInput::" + (end-start));
		
	}
	
	//Forward Command to intended client
	private void processOutgoingAction(String from, String dest, String action, String data, String callBackAction, String callGUID, String respGUID) {
		log.traceDebug(LogData.INFO, "Recieved an Outgoing action. Action is: " + action + " for Destination: " + dest);
		
		//Calls to non-existent clients are absorbed
		Client client = clientList.getClient(dest);
		if(from.length() == 0)
			from = this.clientName;
		if(client!=null)
			client.sendCommand(from, dest, action, callBackAction, (data).trim(),callGUID, respGUID);
		else 
		{
			if (this.clientName.equals(Utils.EXECUTOR_NAME_STR)) 
			{
				//Notify caller about Non-Existent of swf object
				sendCommand("Server", "", "", Utils.SWF_NOT_PRESENT, "", callGUID);
			}
		}
		
		/**
		 * For Genie Watch Window Refresh
		 */
		if (action.equals("playback"))
		{
			//If executor does not have the swf list, on which it playback, please push it
			if (!doesExecutorHasSwf(dest))
			{
				pushSwfForExecutor(dest);
			}
			
			if (data.contains("GenieID"))
			{
				Client pluginClient = clientList.getClient(Utils.PLUGIN_NAME_STR);
				if (pluginClient != null)
				{
					//Inform Plugin about some change happens in swf. So that watch expressions can be updated
					String dt = "<Data><Swf>"+ dest + "</Swf></Data>";
					pluginClient.sendCommand("Server", "AskGeniePropertiesNow", "", dt, "", "");
				}
			}
		}
	}
	
	//Process actions to be executed on Server Side itself
	private void processServerAction(String action, XmlNode data, String callBackMethod, String respID) {
		if (!(action.equalsIgnoreCase("logPreloadData")))
			log.traceDebug(LogData.INFO, "Recieved an Action call to be processed at Server. Action is: " + action);
		
		if(action.equals("getServerVersion")) {
			/**
			 * @returns whether server is compatible with the callee component. Also, the minimum version required
			 */
			String version = "";
			String compName = "";
						
			try{
				compName = data.getNodeValueByName("Name");
				version = data.getNodeValueByName("Version");
			}catch(Exception e){}
			
			VersionHandler vH = VersionHandler.getInstance();
			
			//1. Check compatibility
			boolean isCompat = false; 
			
			String targetCompTag = new String();
			if (compName.equalsIgnoreCase(Utils.PLUGIN_NAME_STR))
			{
				vH.setPluginVersion(version);
				isCompat = vH.isPluginServerSupported(version);
				if (!isCompat)
				{
					String errVerMsg = "Plugin version is not supported by Server. Found: " +
						version + ", Expected MinVersion: " + vH.getPluginMinVersion();
					
					log.trace(LogData.INFO, errVerMsg);
					Utils.printErrorOnConsole(errVerMsg);
				}
				targetCompTag = "<PluginMinVersion>" + vH.getPluginMinVersion() + "</PluginMinVersion>";
			}
			else if (compName.equalsIgnoreCase(Utils.EXECUTOR_NAME_STR))
			{	
				vH.setExecutorVersion(version);
				isCompat = vH.isExecutorServerSupported(version);
				if (!isCompat)
				{
					String errVerMsg = "Executor version is not supported by Server. Found: " +
						version + ", Expected MinVersion: " + vH.getExecutorMinVersion();
					
					log.trace(LogData.INFO, errVerMsg);
					Utils.printErrorOnConsole(errVerMsg);
				}
				targetCompTag = "<ExecutorMinVersion>" + vH.getExecutorMinVersion() + "</ExecutorMinVersion>";
			}
			else if (compName.equalsIgnoreCase("preload"))
			{
				vH.setPreloadVersion(version);
				isCompat = vH.isPreloadServerSupported(version);
				if (!isCompat)
				{
					String errVerMsg = "Preload version is not supported by Server. Found: " +
						version + ", Expected MinVersion: " + vH.getPreloadMinVersion();
					
					log.trace(LogData.INFO, errVerMsg);
					Utils.printErrorOnConsole(errVerMsg);
				}
				targetCompTag = "<PreloadMinVersion>" + vH.getPreloadMinVersion() + "</PreloadMinVersion>";
			}
			if (!isCompat)
			{
				this.clientList.removeClient(compName);
			}
			
			String isCompatStr = isCompat ? "true" : "false";
			String compatTag = "<Compatible>" + isCompatStr + "</Compatible>";
			
			String dataToSend = "<String>"+compName+"</String>"+
				targetCompTag + compatTag +	
				"<ServerVersion>" + vH.getServerVersion() + "</ServerVersion>";
			
			sendCommand("Server", callBackMethod, "", "<XML>"+dataToSend+"</XML>", "", respID);
		}
		
		//Entry point for a Client
		else if(action.equals("addClient")) 
		{
			//Add client now
			clientName = clientList.addClient(this.getName(), data, this);
			
			this.setName(clientName);
			
			// Allow only one Executor at a time
			if (clientName.startsWith(Utils.EXECUTOR_NAME_STR + "_"))	{
				this.clientList.removeClient(clientName);
				sendCommand("Server", "secondExecutor", "", "");
				this.finalize();		
				return;
			}
			
			 //Allow only one Plugin at a time
			if (clientName.startsWith(Utils.PLUGIN_NAME_STR + "_")) {
				this.clientList.removeClient(clientName);
				sendCommand("Server", "stopSecondPlugin", "", "", "", respID);
				return;
			}			
			
			if (this.clientList.isClientSwf(clientName))
			{
				ClientInfo cInfo = this.clientList.getClientObject(clientName);
				String genVer = cInfo.getGenieVersion();
				
				//we got genie objects
				VersionHandler vH = VersionHandler.getInstance();
				vH.setPreloadVersion(genVer);
				if (!vH.isPreloadServerSupported(genVer))
				{
					String compatTag = "<Compatible>false</Compatible>";
					String minVerData = "<PreloadMinVersion>" + vH.getPreloadMinVersion() + "</PreloadMinVersion>";
					String dataSend = "<String>"+clientName+"</String><ServerVersion>" + vH.getServerVersion() + "</ServerVersion>" +
						compatTag + minVerData;

					log.trace(LogData.INFO, "Preload version is not supported by Server. Found: " +
							genVer + ", Expected MinVersion: " + vH.getPreloadMinVersion());
					
					sendCommand(clientName, "clientRefused", "",  dataSend, "", respID);
					
					//Set its property to false
					cInfo.setIsVersionSupported(false);
					this.clientList.updateClientInfo(clientName, cInfo);
					
					//Also, remove client from server's list
					this.clientList.removeClient(clientName);
					return;
				}
			}
			
			else if (clientName.equalsIgnoreCase(Utils.PLUGIN_NAME_STR)) {
				handlePluginAddClient(clientName, data, callBackMethod, respID);
				return;
			}
			
			VersionHandler vH = VersionHandler.getInstance();
			String dataToSend = new String();
			dataToSend = "<String>"+clientName+"</String><ServerVersion>" + vH.getServerVersion() + "</ServerVersion>";
			
			ClientInfo cInfo = this.clientList.getClientObject(clientName);
			String oldName = cInfo.getRealName();
			if (!oldName.equals(clientName))
			{
				dataToSend = "<OldName>" + oldName + "</OldName>" + dataToSend;
			}
			sendCommand("Server" , clientName, callBackMethod, "",  dataToSend, "", respID);
		}
		else if (action.equals("NowSendCustomComponentData"))
		{
			this.sendCustomComponentDataToPreload();
		}
		else if (action.equals("binaryDataSending"))
		{
			try
			{
				String binaryData = data.getNodeValueByName("BinaryData");
				String filename = data.getNodeValueByName("Filename");
				
				this.saveBinaryData(filename, binaryData);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			
			sendCommand("Server", "", callBackMethod, "", "", respID);
		}
		/*****************************************************
		 *****************************************************
		 *****************************************************/
		
		else if(action.equals("getClientList")) {
			sendCommand("Server", callBackMethod, "", "<XML>"+clientList.getClientList()+"</XML>", "", respID);
		}
		else if (action.equals("getTempFolder"))
		{
			String res = "<TempFolder>" + Utils.getTempFolderpath() + "</TempFolder>";
			sendCommand(clientName, callBackMethod, "", res, "", respID);
		}
		else if (action.equals("getAllVersions")) {
			VersionHandler vH = VersionHandler.getInstance();
			String dt = vH.getAllVersions();
			sendCommand(clientName, callBackMethod, "", dt, "", respID);
		}
		
		else if (action.equalsIgnoreCase("saveSwfNameForExecutor"))	{
			String swfName = "";
			try{
				XmlDoc xmlDoc = new XmlDoc(data.toXMLString());
				swfName = xmlDoc.getNodeValueByName("swfName");
			}catch(Exception e){ 
				Shared.displayExecptionInfo(e,"Error while getting SWF name while performing action: saveSwfNameForExecutor ");
			}
			pushSwfForExecutor(swfName);
		}

		else if (action.equalsIgnoreCase("isPerformanceTrackingEnabled")) {
			StaticFlags sFlags = StaticFlags.getInstance();
			String flagP = sFlags.isPerformanceEnabled() ? "true" : "false";
			String dt = "<PerformanceTracking>" + flagP + "</PerformanceTracking>";
			
			sendCommand("Server", clientName, callBackMethod, "", dt, "", respID);
			return;
		}
		
		else if(action.equalsIgnoreCase("writePerformanceData")) {
			StaticFlags sf = StaticFlags.getInstance();
			sf.writePerformanceData(data);
		}
		
		else if (action.equalsIgnoreCase("enableUsageMatrix"))
		{
			try {
				toggleUmatrix = data.getValue();
			} catch (Exception e) {
				toggleUmatrix = "true";
			}
		}
		else if (action.equalsIgnoreCase("logPreloadData"))
		{
			StaticFlags dataPreload = StaticFlags.getInstance();
			dataPreload.logPreloadData(clientName,data);
		}

		else if (action.equalsIgnoreCase("UsageMetricsData")) {
			
			
			UsageMetricsData usageInstance = new UsageMetricsData();
			Hashtable<String,Hashtable<String,String>> scriptSwfs = usageInstance.getSwfList(data);
			Vector<String> featureList = usageInstance.getFeatureList(data);			
			try{
				if((toggleUmatrix.equals("true")))
				{
					Enumeration<String> myenum = scriptSwfs.keys ();
					while(myenum.hasMoreElements())
					{
						String key =myenum.nextElement ();
						//Suman::Fixed bug#3006074
						//Suite execution fails with "Second executor" error if two or more suites are executed in bat file
						
						UsageMatrixSender sender = new UsageMatrixSender(key,featureList,scriptSwfs.get(key));
						sender.start();
						
		    	    }
				}
			}catch(Exception e){}
			
			//put in logs, and remove client
			log.trace(LogData.INFO, "Executor finished with script!");
			//Fixed bug
			//this.clientList.removeClient(clientName);
		}
		else if(action.equalsIgnoreCase("getGenieSocketServerVersion")) {
			try 
			{
				VersionHandler vH = VersionHandler.getInstance();
				sendCommand("Client", callBackMethod, "", "<ServerVersion>" + vH.getServerVersion() + "</ServerVersion>", "", respID);
				clientName = data.getNodeValueByName("Name");
			} 
			catch (Exception e) 
			{
				log.trace(LogData.INFO, "Unable to get Genie Socket Server Version");
				this.clientList.removeClient(clientName);
			}
		}
		
	}
	
	//Store a list of SWF currently connected by Executor
	private void pushSwfForExecutor(String swfName)
	{
		if (clientList.swfListOfExecutor == null){
			clientList.swfListOfExecutor = new ArrayList<String>();
		}
		if (!swfName.equalsIgnoreCase("")) {
			clientList.swfListOfExecutor.add(swfName);
		}
	}
	/**
	 * Server maintains a list of swf, on which executor is running.
	 * If, executor does not has it during playback. Checking
	 */
	private boolean doesExecutorHasSwf(String swfName)
	{
		if (clientList.swfListOfExecutor == null)
			return false;
		return clientList.swfListOfExecutor.contains(swfName);
	}
	
	// Add Plug-in to client list and establish connection if compatible
	private boolean handlePluginAddClient(String compName, XmlNode data, String callBackMethod, String respID)
	{
		String version = "";
		boolean isMatch = true;
		
		try{
			version = data.getNodeValueByName("Version");
		}catch(Exception e){}
		
		VersionHandler vH = VersionHandler.getInstance();
		boolean isCompat = false; 
		
		String targetCompTag = "<PluginMinVersion>" + vH.getPluginMinVersion() + "</PluginMinVersion>";
		vH.setPluginVersion(version);
		isCompat = vH.isPluginServerSupported(version);
		if (!isCompat) {
			log.trace(LogData.INFO, "Plugin version is not supported by Server. Found: " +
					version + ", Expected MinVersion: " + vH.getPluginMinVersion());
			
			this.clientList.removeClient(compName);
			isMatch = false;
		}
		
		String isCompatStr = isCompat ? "true" : "false";
		String compatTag = "<Compatible>" + isCompatStr + "</Compatible>";
		
		String dataToSend = "<String>"+compName+"</String>"+
			targetCompTag + compatTag +	
			"<ServerVersion>" + vH.getServerVersion() + "</ServerVersion>";
		
		sendCommand("Server", callBackMethod, "", "<XML>"+dataToSend+"</XML>", "", respID);
		
		return isMatch;
	}

//	//Reads input Stream
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
		//long start = (new Date()).getTime();
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
			
			//reader.readByte();
			
		}
		
		//long end = (new Date()).getTime();
		//String action = Utils.getTagValueDefBlank(buffer.toString(), "Action");
		//log.trace("InRead", "EndTime " + (end-start) + " for action " + action);
		
		
		return buffer.toString();
	}
		
	private void saveBinaryData(String fileName, String binaryData)
	{
		try
		{
			byte[] bytes = Base64.decode(binaryData);
		
			String tmpFilepath = fileName;
		
			File file = new File(tmpFilepath);
				
			OutputStream out = new FileOutputStream(file);
		        
		    out.write(bytes, 0, bytes.length);
		        
		    out.close();
		        }
		catch(Exception e)
		{
		        
		}
	}
	
	/**
	 * Once Server gets acknowledge from Preload that it received class names,
	 * it now sends rest custom component info
	 */
	private void sendCustomComponentDataToPreload()
	{
		CustomConfigData customConfig = CustomConfigData.getInstance();
		if(customConfig != null)
		{
			log.traceDebug(LogData.INFO, "Received request for loading Custom Components. Sending required info to Genie component");
			Set<String> set = customConfig.components.keySet();
			Iterator<String> itr = set.iterator();
			
		    while (itr.hasNext()) {
		    	String compName = itr.next();
		    	CustomComponentData data = customConfig.components.get(compName);
		    	
		    	this.clientList.sendCustomComponentData(clientName,compName, data.preload.componentSWF);
		    	this.clientList.sendEnvFileToPreload(clientName,compName, data.preload.envXML);
		    }
		}
	}
}
