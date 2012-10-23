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

package com.adobe.genie.executor;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.adobe.genie.utils.Utils;

class VersionHandler {
	private static VersionHandler versionHandler;
	
	private String serverMinVersionTag = "ServerMinVersion";
	private String executorVersionTag = "ExecutorVersion";
	
	private String executorVersion;
	private String serverVersion;
	private String serverMinVersion;
	private String executorMinVersion;
	
	private boolean refusedByServer;
	private boolean refusedByExecutor;
	//SCA
	private String executorMinVersionTag = "ExecutorMinVersion";
	private String compatibleTag = "Compatible";
	private String serverVersionReplyTag = "ServerVersion";
	
	private VersionHandler() {
		this.executorVersion = "";
	  //this.executorVersion = new String();
		this.serverMinVersion = "";
	  //this.serverMinVersion = new String();
		this.executorMinVersion = "";
	  //this.executorMinVersion = new String();
		this.serverVersion = "";
	  //this.serverVersion = new String();
		this.refusedByExecutor = false;
		this.refusedByServer = false;
		
		this.loadVersionInfo();
	}
	
	public synchronized static VersionHandler getInstance()
	{
		if (versionHandler == null)
			versionHandler = new VersionHandler();
		return versionHandler;
	}
	
	private void loadVersionInfo()
    {
		InputStream is = null;
	    BufferedReader br = null;
	    String line;
		
		try{   		
    	    is = getClass().getClassLoader().getResourceAsStream("version.xml");
    	    br = new BufferedReader(new InputStreamReader(is));
    	    String xmlString ="";
    	    //String xmlString =new String();
    	    while (null != (line = br.readLine()))
    	    {
    	    	xmlString += line.trim();
    	    }
    	    
    	    String svrVr = Utils.getTagValueFromVersionXML(xmlString, this.executorVersionTag);
    		this.setExecutorVersion(svrVr);
    		
    		svrVr = Utils.getTagValueFromVersionXML(xmlString, this.serverMinVersionTag);
    		this.setServerMinVersion(svrVr);    		
    	}
    	catch(Exception e)
    	{
    		this.executorVersion = "Unknown";
    		this.serverMinVersion = "Unknown";
    		this.executorMinVersion = "Unknown";
    		this.serverVersion = "Unknown";
    		
    		Utils.printErrorOnConsole("Exception: " + e.getMessage());
    	}
    	finally{
    		try{
	    		is.close();
	    		br.close();
    		}
    		catch (Exception e){
    			StaticFlags sf = StaticFlags.getInstance();					
				sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	    			    			
    		}
    	}
    }
	
	private void setExecutorVersion(String ver)
	{
		this.executorVersion = ver;
		//this.executorVersion = new String(ver);
	}
	public String getExecutorVersion()
	{
		return this.executorVersion;
	}
	public String getServerVersion()
	{
		return this.serverVersion;
	}
	private void setServerVersion(String ver)
	{
		this.serverVersion = ver;
	}
	public String getServerMinVersion()
	{
		return this.serverMinVersion;
	}
	private void setServerMinVersion(String ver)
	{
		this.serverMinVersion = ver;
	}
	public String getExecutorMinVersion()
	{
		return this.executorMinVersion;
	}
	private void setExecutorMinVersion(String ver)
	{
		this.executorMinVersion = ver;
	}
	
	public boolean isRefusedByServer()
	{
		return this.refusedByServer;
	}
	public boolean isRefusedByExecutor()
	{
		return this.refusedByExecutor;
	}
	
	public boolean isExecutorServerSupported()
	{
		String sv1 = this.serverMinVersion;
		String sv2 = this.serverVersion;
		if (sv1.equalsIgnoreCase("Unknown") || sv2.equalsIgnoreCase("Unknown"))
		{
			return true;
		}
		
		int l1 = sv1.split("\\.").length;
		int l2 = sv2.split("\\.").length;
		while (l1 < l2)
		{
			sv1 += ".0";
			l1 ++;
		}
		while (l2 < l1)
		{
			sv2 += ".0";
			l2 ++;
		}
		
		int v1 = Utils.getVersionNumber(sv1);
		int v2 = Utils.getVersionNumber(sv2);
		
		//v2 should be >= v1 
		
		return v1 <= v2;
	}
	
	public boolean isReplyCompatible(String str)
	{
		if (str == null)
			return true;
		String compatibleStr = "";
		String execMinVer = "";
		String serverVer = "";
		boolean reply = false;
		
		try{
			compatibleStr = Utils.getTagValue(str, this.compatibleTag);
			execMinVer = Utils.getTagValue(str, this.executorMinVersionTag);
			serverVer = Utils.getTagValue(str, this.serverVersionReplyTag);
			
			this.setServerVersion(serverVer);
			this.setExecutorMinVersion(execMinVer);
			
			if (compatibleStr.equalsIgnoreCase("false"))
			{
				this.refusedByServer = true;
			}
			else
			{
				boolean compt = this.isExecutorServerSupported();
				if (compt == false)
				{
					this.refusedByExecutor = true;
				}
				return compt;
			}
		}
		catch(Exception e)
		{
			Utils.printErrorOnConsole("Exception while parsing reply from Server for version: " + e.getMessage());
		}
		
		return reply;
	}
	
	public String getErrorMessage()
	{
		String msg = "";
		if (this.refusedByExecutor)
		{
			msg += "Server Version is not supported! Found: " + this.serverVersion + 
				", Expected MinVersion: " + this.serverMinVersion + ". ";
		}
		if (this.refusedByServer)
		{
			msg += "Server did not support executor version! Found: " + this.executorVersion +
				", Expected MinVersion: " + this.executorMinVersion + ". ";
		}
		
		return msg;
	}
}
