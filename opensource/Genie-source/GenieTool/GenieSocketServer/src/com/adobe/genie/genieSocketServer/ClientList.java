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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;

/**
 * ClientList contains list of currently connected clients.
 */
public class ClientList {

	/**
	 * List of all Genie clients
	 */
	private List<ClientInfo> clientsInfo;
	
	
	private static final String CLIENT_DISCONNECTED = "clientDisconnected";
	private static final String PLUGIN_SWFLIST_RECEIVED = "swfListReceived";
	private static final String EXECUTOR_EXITED = "executorExited";
	public static final String EXECUTOR_ERROR = "Executor Error: Only Single Executor allowed!";
	private static final String TRACE_DEBUG = "traceDebug";
	private LogData log = LogData.getInstance();
	
	public ArrayList<String> swfListOfExecutor = null;
	
	public ClientList() {
		clientsInfo = new LinkedList<ClientInfo>();
	}
	
	public synchronized String addClient(String from, XmlNode data, Client client) 
	{
		String name = "";
		SWFApp swfObj = null;

		try 
		{
			XmlDoc dataDoc = new XmlDoc(data.toXMLString());
			name = dataDoc.getNodeValueByName("Name");
			
			if(this.isClientSwf(name))
			{
				swfObj = new SWFApp();
				swfObj.name = name;
				swfObj.genieVersion = dataDoc.getNodeValueByName("GenieVersion");
				swfObj.asVersion = dataDoc.getNodeValueByName("ActionScriptVersion");
				swfObj.playerVersion = dataDoc.getNodeValueByName("PlayerVersion");
				swfObj.playerType = dataDoc.getNodeValueByName("PlayerType");
				swfObj.realName = name;
				swfObj.preloadName = dataDoc.getNodeValueByName("GeniePreloadName");
				swfObj.preloadSdkVersion = dataDoc.getNodeValueByName("PreloadSdkVersion");
				
				VersionHandler vH = VersionHandler.getInstance();
				vH.setPreloadVersion(swfObj.genieVersion);
				
			}
		} catch (Exception e){
			log.traceDebug(LogData.ERROR, "Exceptionn while reading swf attributes: " + e.getMessage());
		}
		
		return addClient(name, client, swfObj);
	}
	
	/**
	 * To check client is swf or not
	 */
	public boolean isClientSwf(String clientName)
	{
		if (clientName.startsWith(Utils.EXECUTOR_NAME_STR))
			return false;
		
		if (clientName.startsWith(Utils.PLUGIN_NAME_STR))
			return false;
		
		return true;
	}
		
	public synchronized boolean handleRemoveClient(String nameArg)
	{
		return this.removeClient(nameArg);
	}
	public synchronized Boolean removeClient(String name) {
		try{
					
				//Inform plugin
				Client plugin = getClient(Utils.PLUGIN_NAME_STR);
				if( (plugin != null) && (plugin.isAlive()) && name.equalsIgnoreCase(Utils.EXECUTOR_NAME_STR))
				{
					StringBuffer swfsConnected = new StringBuffer(128);
					if(swfListOfExecutor != null)
					{
						for(int i = 0; i< swfListOfExecutor.size() - 1 ; ++i)
						{
							swfsConnected.append(swfListOfExecutor.get(i));
							swfsConnected.append(",");
						}
					}
					informPluginAboutDisconnection(Utils.EXECUTOR_NAME_STR, swfsConnected.toString());
					//plugin.sendCommand("Server", "executorIsStopped", "", swfsConnected.toString());
				}
				
				//To make sure that swf disconnect signal always goes to plugin or executor, not to other swfs
				if (name.equalsIgnoreCase(Utils.EXECUTOR_NAME_STR))	{
					clearExecutorSwfList();
			}
			else if (this.isClientSwf(name))
			{ 	//means swf
				//remove swf from executorSwfList
				removeSwfFromExecutorSwfList(name);
				
				//Remove swf from map of log files
				StaticFlags sf = StaticFlags.getInstance();
				sf.removeSwfFromMapForLog(name);
			}
			
			log.traceDebug(LogData.INFO, "Request received for Removing client: " + name + " from List");
			
			Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
			while(cIter.hasNext()) {
				ClientInfo cInfo = cIter.next();
				
				if (name.equals(cInfo.getName()))
				{
					cIter.remove();
					
					sendClientDisconnectedEvent(name);
					
					if(name.equalsIgnoreCase(Utils.PLUGIN_NAME_STR)) {
						sendDebuggingFlagToAllSWFs(false);
					}
					else if (this.isClientSwf(name))
					{
						if(listContains(Utils.PLUGIN_NAME_STR)){
							sendSWFListToPlugin();
						}
					}
					return true;
				}
			}
		}catch(Exception e) {
			Shared.displayExecptionInfo(e,"Error while removing client:" + name + " from Server client list. Possibly connection has dropped..");
	    }
		
		return true;
	}
	
	public String getClientList() 
	{
		String ret = "<Clients>";
		
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			
			if(isClientSwf(cInfo.getName()))
			{
				ret += cInfo.getXml();
			}
		}
		ret += "</Clients>";
		return ret;
	}

	public Client getClient(String name) 
	{
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			if (name.equals(cInfo.getName()))
			{
				return cInfo.getClientObj();
			}
		}
		
		log.traceDebug(LogData.ERROR, "Unable to find requested client name: " + name + " in Client List");
		return null;
	}
	
	public ClientInfo getClientObject(String name) 
	{
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			if (name.equals(cInfo.getName()))
			{
				return cInfo;
			}
		}
		
		log.traceDebug(LogData.ERROR, "Unable to find requested client name: " + name + " in Client List");
		return null;
	}

	public void updateClientInfo(String name, ClientInfo cInfoArg)
	{
		int i=0;
		for (i=0; i<this.clientsInfo.size(); i++)
		{
			ClientInfo cInfo = this.clientsInfo.get(i);
			if (name.equals(cInfo.getName()))
			{
				this.clientsInfo.set(i, cInfoArg);
				
				break;
			}
		}
		
	}
	
	
	private synchronized void removeSwfFromExecutorSwfList(String swfName) {
		if (swfListOfExecutor == null)
			return;
		swfListOfExecutor.remove(swfName);
	}
	
	private synchronized void clearExecutorSwfList() {
		if (swfListOfExecutor == null)
			return;
		for (String swfName : swfListOfExecutor) 
		{
			Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
			while(cIter.hasNext()) 
			{
				ClientInfo cInfo = cIter.next();
				if (swfName.equals(cInfo.getName()))
				{
					cInfo.getClientObj().sendCommand(Utils.EXECUTOR_NAME_STR,swfName, EXECUTOR_EXITED, 
							"", "<String>" + swfName + "</String>", "","");
				}
			}
		}
		swfListOfExecutor.clear();
	}

	private void sendDebuggingFlagToAllSWFs(Boolean flag) 
	{
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			
			if(isClientSwf(cInfo.getName())) 
			{
				cInfo.getClientObj().sendDebuggingFlag(flag);
			}
		}
	}

	private synchronized void sendClientDisconnectedEvent(String name) 
	{
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			//Suman: Fixed bug#2993601. Send client disconnected event to every client not just to plugin and executor.
			//String clientName = cInfo.getName();
			//if (clientName.startsWith(Utils.EXECUTOR_NAME_STR) || clientName.startsWith(Utils.PLUGIN_NAME_STR))
			cInfo.getClientObj().sendCommand(name, CLIENT_DISCONNECTED, "", "<String>"+name+"</String>");
		}
	}

	private void sendSWFListToPlugin() {
		Client plugin = getClient(Utils.PLUGIN_NAME_STR);
		if( (plugin != null) && (plugin.isAlive())) 	{
			plugin.sendCommand("Server", PLUGIN_SWFLIST_RECEIVED, "", "<XML>"+getClientList()+"</XML>");
		}
	}	
	
	public void sendEnvFileToPreload(String clientName, String componentName, String[] envXMLArray) {
		ClientInfo client = getClientObject(clientName);
		/*//send swf to device and modify path
		if((client.getSwfAppObj() != null) && (client.getSwfAppObj().device != null))
		{
			String dataToSend = "";
			for(int j=0; j < envXMLArray.length; ++j) {
			
				String content = getBinaryData(envXMLArray[j]);
				if(content.length() > 0)
				{
					File file = new File(envXMLArray[j]);
					String compData = "<BinaryData>" + content + "</BinaryData>" +
					    	"<Filename>" + file.getName() + "</Filename>" +
					    	"<ComponentName>" + componentName + "</ComponentName>";
					//compData = "<Component>" + compData + "</ComponentName>";
					dataToSend += compData;
					client.getClientObj().sendCommand("Server", clientName, "customComponentEnvFile", "", dataToSend, "", "");
				}
				else
				{
					//If server could not read file then send the file path as it is
					String infoToSend = "<String>" + Utils.getTextFromFile(envXMLArray[j]) + "</String>";
					client.getClientObj().sendCommand("Server", "customComponentEnvFile", "", infoToSend);
				}
			}
		}
		else
		{*/
		for(int j=0; j<envXMLArray.length; ++j) {
			String infoToSend = "<String>" + Utils.getTextFromFile(envXMLArray[j]) + "</String>";
			client.getClientObj().sendCommand("Server", clientName, "customComponentEnvFile", "", infoToSend, "", "");
		}
	}
	
	public void sendCustomComponentData(String clientName, String componentName, String[] arrayToSend) {
		//sendData to Plugin
		ClientInfo client = getClientObject(clientName);
		
		String infoToSend = "<String>";
		for(int j=0; j<arrayToSend.length; ++j) {
			infoToSend += "<Path>" + arrayToSend[j] + "</Path>";
		}
		infoToSend += "</String>";
		client.getClientObj().sendCommand("Server",clientName, "customComponentInfo", "", infoToSend,"", "");
		
	}
	
	private Boolean listContains(String name) 
	{
		Iterator<ClientInfo> cIter = this.clientsInfo.iterator();
		while(cIter.hasNext()) 
		{
			ClientInfo cInfo = cIter.next();
			if (name.equals(cInfo.getName()))
				return true;
		}
		
		return false;
	}
		
	public String getUniqueClientName(String nameArg, int inst)
	{
		// If same name SWF exists then append an identifier with name
		if(listContains(nameArg)) 
		{
			while (inst < 10000)
			{
				inst ++;
				String tempName = nameArg + "_" + inst;
				if (!listContains(tempName)) {
					nameArg = tempName;
					break;
				}
			}
		}
		return nameArg;
	}
	
	private synchronized String addClient(String name, Client client, SWFApp swfObj) 
	{
		log.traceDebug(LogData.INFO, "Request received for Adding client: " + name + " to List");
		
		// If same name SWF exists then append an identifier with name
		name = getUniqueClientName(name, 1);
		
		boolean isVersionSupported = true;
		
		if (this.isClientSwf(name))
		{
			//updated name
			swfObj.name = name;
		}
		ClientInfo cInfo = new ClientInfo(name, swfObj, client, isVersionSupported);
		
		this.clientsInfo.add(cInfo);
		postProcessAddClient(name);
		
		return name;
	}
	
	private void postProcessAddClient(String clientName)
	{
		//Send Custom Configuration paths to different components
		CustomConfigData customConfig = CustomConfigData.getInstance();
		if(customConfig != null)
		{
			log.traceDebug(LogData.INFO, "Received request for loading Custom Components. Sending required info to Genie component");
			Set<String> set = customConfig.components.keySet();
			Iterator<String> itr = set.iterator();
			
		    while (itr.hasNext()) {
		    	String compName = itr.next();
		    	CustomComponentData data = customConfig.components.get(compName);
		    	if(clientName.equals(Utils.PLUGIN_NAME_STR))
		    		sendCustomComponentData(Utils.PLUGIN_NAME_STR, compName,  data.plugin);
				else if(clientName.equals(Utils.EXECUTOR_NAME_STR))
					sendCustomComponentData(Utils.EXECUTOR_NAME_STR, compName, data.executor);				
		    }
		    
		    if (this.isClientSwf(clientName))
		    {
		    	ClientInfo client = getClientObject(clientName);
		    	String infoToSend = "<XML>";
				String[] classNames = customConfig.getClassNames();
				if (classNames != null)
				{
					for (int k=0; k<classNames.length; k++)
					{
						infoToSend += "<ClassName>" + classNames[k] + "</ClassName>";
					}
				}
				infoToSend += "</XML>";
				//Sending just class names to preload. Preload will digest them, and acknowledge server
				//Server in return send rest of Custom component info to preload
				client.getClientObj().sendCommand("Server", "customComponentClassNames", "", infoToSend);
			}
		}		
		
		StaticFlags sFlags = StaticFlags.getInstance();
		if (sFlags.isdebugMode()) {
			//Send DEBUG flag to newly added client so they can also trace debug information
			Client newClient = getClient(clientName);
			newClient.sendCommand("Server", TRACE_DEBUG, "", "<Boolean>"+ true+"</Boolean>");
		}

		if(listContains(Utils.PLUGIN_NAME_STR)){
			sendSWFListToPlugin();
		}
		
		informPluginAboutClients(clientName);
	}
	
	/**
	 * To inform plugin about client presence
	 * @param clientName
	 */
	private void informPluginAboutClients(String clientName)
	{
		String[] pluginInterestedCLients = new String[]{Utils.EXECUTOR_NAME_STR};
		
		for (String client : pluginInterestedCLients)
		{
			if (clientName.equals(Utils.PLUGIN_NAME_STR))
			{
				Client plugin = getClient(Utils.PLUGIN_NAME_STR);
				if( (plugin != null) && (plugin.isAlive()))
				{
					//If we have executor running, inform plugin about this
					if (this.getClient(client) != null)
					{
						String data = "<ClientName>"+client+"</ClientName>";
						plugin.sendCommand("Server", "clientIsRunning", "", data);
					}
					
				}
			}
			
			if (clientName.equals(client))
			{
				if (this.getClient(Utils.PLUGIN_NAME_STR) != null)
				{
					//inform plugin
					Client plugin = getClient(Utils.PLUGIN_NAME_STR);
					if( (plugin != null) && (plugin.isAlive()))
					{
						String data = "<ClientName>"+client+"</ClientName>";
						plugin.sendCommand("Server", "clientIsRunning", "", data);
					}
				}
			}
		}
	}
	private void informPluginAboutDisconnection(String clientName, String anyData)
	{
		Client plugin = getClient(Utils.PLUGIN_NAME_STR);
		if( (plugin != null) && (plugin.isAlive()))
		{
			String data = "<ClientName>"+clientName+"</ClientName><AnyData>" + anyData + "</AnyData>";
			plugin.sendCommand("Server", "clientIsStopped", "", data);
		}
	}
}
