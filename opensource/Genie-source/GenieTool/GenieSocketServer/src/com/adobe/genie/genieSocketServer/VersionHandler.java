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

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.adobe.genie.utils.Utils;

public class VersionHandler {
	private static VersionHandler versionHandler;
	
	private String serverVersionTag = "ServerVersion";
	private String pluginVersionTag = "PluginMinVersion";
	private String executorVersionTag = "ExecutorMinVersion";
	private String preloadVersionTag = "PreloadMinVersion";
	
	private String serverVersion;
	private String pluginMinVersion;
	private String executorMinVersion;
	private String preloadMinVersion;
	
	//The versions which server got while connection
	private String pluginVersion;
	private String executorVersion;
	private String preloadVersion;
	
	/**
	 * Instantiate a VersionHandler singleton instance and returns the instance
	 */
	public static VersionHandler getInstance()
	{
		if (versionHandler == null)
			try {
				versionHandler = new VersionHandler();
			} catch (Exception e) {
				versionHandler = null;
			}
		return versionHandler;
	}

	//Actual instantiation
	private VersionHandler() throws Exception {
		this.serverVersion = "Unknown";
		this.pluginMinVersion = "Unknown";
		this.executorMinVersion = "Unknown";
		
		this.loadVersionInfo();
	}

	//Loads info from version.xml
	private void loadVersionInfo() throws Exception
    {
    	try{
    		InputStream is = null;
    	    BufferedReader br = null;
    	    String line;
    	    
    	    is = getClass().getClassLoader().getResourceAsStream("version.xml");
    	    br = new BufferedReader(new InputStreamReader(is));
    	    String xmlString = new String();
    	    
    	    while (null != (line = br.readLine())) {
    	    	xmlString += line.trim();
    	    }
    	    
    		String svrVr = Utils.getTagValueFromVersionXML(xmlString, this.serverVersionTag);
    		this.setServerVersion(svrVr);
    		
    		svrVr = Utils.getTagValueFromVersionXML(xmlString, this.pluginVersionTag);
    		this.setPluginMinVersion(svrVr);
    		
    		svrVr = Utils.getTagValueFromVersionXML(xmlString, this.executorVersionTag);
    		this.setExecutorMinVersion(svrVr);
    		
    		svrVr = Utils.getTagValueFromVersionXML(xmlString, this.preloadVersionTag);
    		this.setPreloadMinVersion(svrVr);
    		
    	}
    	catch(Exception e){
    		Shared.displayExecptionInfo(e,"Got Exception while reading version.xml");
			throw new Exception(e);
    	}
    }
	
	private void setServerVersion(String ver){
		this.serverVersion = new String(ver);
	}
	private void setPluginMinVersion(String ver) {
		this.pluginMinVersion = ver;
	}
	private void setPreloadMinVersion(String ver){
		this.preloadMinVersion = ver;
	}
	private void setExecutorMinVersion(String ver){
		this.executorMinVersion = ver;
	}

	
	public String getServerVersion(){
		return this.serverVersion;
	}
	
	public String getPluginMinVersion()	{
		return this.pluginMinVersion;
	}
	public String getPreloadMinVersion(){
		return this.preloadMinVersion;
	}
	public String getExecutorMinVersion(){
		return this.executorMinVersion;
	}
	public void setPluginVersion(String ver){
		this.pluginVersion = new String(ver);
	}
	public String getPluginVersion(){
		return this.pluginVersion;
	}

	public void setPreloadVersion(String ver){
		this.preloadVersion = new String(ver);
	}
	public String getPreloadVersion(){
		return this.preloadVersion;
	}
	
	public void setExecutorVersion(String ver){
		this.executorVersion = new String(ver);
	}
	public String getExecutorVersion(){
		return this.executorVersion;
	}
	
	
	//If version of executor greater than supported version
	public boolean isExecutorServerSupported(String ver)
	{
		String sv1 = this.executorMinVersion;
		String sv2 = ver;
		
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

	//If version of preload greater than supported version
	public boolean isPreloadServerSupported(String ver)
	{
		if ((ver == null) || ver.equalsIgnoreCase("Unknown"))
			return false;
		
		String sv1 = this.preloadMinVersion;
		String sv2 = ver;
		
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
	
	//If version of plugin greater than supported version
	public boolean isPluginServerSupported(String ver)
	{
		String sv1 = this.pluginMinVersion;
		String sv2 = ver;
		
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
	
	//return version of all components as an XML
	public String getAllVersions()
	{
		String xml = "";
		
		xml += "<ServerVersion>" + this.serverVersion + "</ServerVersion>";
		xml += "<PluginVersion>" + this.pluginVersion + "</PluginVersion>";
		xml += "<ExecutorVersion>" + this.executorVersion + "</ExecutorVersion>";
		xml += "<PreloadVersion>" + this.preloadVersion + "</PreloadVersion>";
		
		return xml;
	}
}
