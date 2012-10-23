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

package com.adobe.geniePlugin;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;

public class VersionHandler {
	private static VersionHandler versionHandler;
	private String pluginVersionTag = "PluginVersion";
	private String serverVersionTag = "ServerMinVersion";
	
	private String PluginMinVersionTag = "PluginMinVersion";
	private String CompatibleTag = "Compatible";
	private String ServerVersionReplyTag = "ServerVersion";
	
	private String pluginVersion;
	private String serverVersion;
	private String serverMinVersion;
	private String pluginMinVersion;
	
	private boolean refusedByServer;
	private boolean refusedByPlugin;
	private boolean refusedByMiscReasons;
	private String miscErrMsg;
	
	private VersionHandler() {
		this.pluginVersion = new String();
		this.serverVersion = new String();
		this.refusedByServer = false;
		this.refusedByPlugin = false;
		this.refusedByMiscReasons = false;
		this.miscErrMsg = new String();
		
		this.loadVersionInfo();
	}
	
	public static VersionHandler getInstance()
	{
		if (versionHandler == null)
			versionHandler = new VersionHandler();
		return versionHandler;
	}
	
	private void loadVersionInfo()
    {
		String debugStr = "VersionHandler::loadVersionInfo";
    	try{
    		InputStream is = null;
    	    BufferedReader br = null;
    	    String line;
    	    
    	    is = getClass().getClassLoader().getResourceAsStream("resources/version.xml");
    	    br = new BufferedReader(new InputStreamReader(is));
    	    String xmlString = new String();
    	    while (null != (line = br.readLine()))
    	    {
    	    	xmlString += line.trim();
    	    }
    	    
    	    String svrVr = Utils.getTagValueFromVersionXML(xmlString, this.pluginVersionTag);
    		this.setPluginVersion(svrVr);
    		
    		svrVr = Utils.getTagValueFromVersionXML(xmlString, this.serverVersionTag);
    		this.setServerMinVersion(svrVr);
    		
    		LogData log = LogData.getInstance();
    		log.trace(LogData.INFO, debugStr + " Version Info Loaded");
    	}
    	catch(Exception e)
    	{
    		Utils.printErrorOnConsole("Exception: " + e.getMessage());
    	}
    }
	
	public void setRefusedConenctionByMiscReasons(String msg)
	{
		this.refusedByMiscReasons = true;
		miscErrMsg = msg;
	}
	public boolean isRefusedConnection()
	{
		return this.refusedByPlugin || this.refusedByServer || this.refusedByMiscReasons;
	}
	public boolean isRefusedByServer()
	{
		return this.refusedByServer;
	}
	public boolean isRefusedByPlugin()
	{
		return this.refusedByPlugin;
	}
	
	public void setPluginVersion(String ver)
	{
		this.pluginVersion = ver;
	}
	public String getPluginVersion()
	{
		return this.pluginVersion;
	}
	public void setServerVersion(String ver)
	{
		this.serverVersion = ver;
	}
	public String getServerVersion()
	{
		return this.serverVersion;
	}
	public void setPluginMinVersion(String ver)
	{
		this.pluginMinVersion = ver;
	}
	public String getPluginMinVersion()
	{
		return this.pluginMinVersion;
	}
	public void setServerMinVersion(String ver)
	{
		this.serverMinVersion = ver;
	}
	public String getServerMinVersion()
	{
		return this.serverMinVersion;
	}
	
	public boolean isPluginServerSupported()
	{
		String sv1 = this.serverMinVersion;
		String sv2 = this.serverVersion;
		
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
		String compatibleStr = "";
		String pluginMinVer = "";
		String serverVer = "";
		boolean reply = true;
		
		try{
			compatibleStr = Utils.getTagValue(str, this.CompatibleTag);
			pluginMinVer = Utils.getTagValue(str, this.PluginMinVersionTag);
			serverVer = Utils.getTagValue(str, this.ServerVersionReplyTag);
			
			this.setServerVersion(serverVer);
			this.setPluginMinVersion(pluginMinVer);
			
			if (compatibleStr.equalsIgnoreCase("false"))
			{
				reply = false;
				this.refusedByServer = true;
			}
			else
			{
				boolean compt = this.isPluginServerSupported();
				if (compt == false)
				{
					reply = false;
					this.refusedByPlugin = true;
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
		if (this.refusedByPlugin)
		{
			msg += "Server Version is not supported! Found: " + this.serverVersion + 
				", Expected MinVersion: " + this.serverMinVersion + ". ";
		}
		else if (this.refusedByServer)
		{
			msg += "Server did not support Plugin version! Found: " + this.pluginVersion +
				", Expected MinVersion: " + this.pluginMinVersion + ". ";
		}
		else if (this.refusedByMiscReasons)
		{
			msg = this.miscErrMsg;
		}
		
		return msg;
	}
}

