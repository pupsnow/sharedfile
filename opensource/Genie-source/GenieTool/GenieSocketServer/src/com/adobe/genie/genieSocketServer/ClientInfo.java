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

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.utils.log.LogDataObject;

/**
 * Has all the clients info
 * This is the enhancement to old dirty method of keeping all clients
 * Previously an Object array was being used
 */
public class ClientInfo 
{
	private String name;
	private SWFApp swfObj;
	private Client client;
	
	private boolean isVersionSupported;
	private LogDataObject logger;
	
	public ClientInfo()
	{
		name = null;
		swfObj = null;
		client = null;
		isVersionSupported = true;
		logger = null;
	}
	public ClientInfo(ClientInfo other)
	{
		name = other.name;
		swfObj = other.swfObj;
		client = other.client;
		isVersionSupported = other.isVersionSupported;
		logger = other.logger;
	}
	
	public ClientInfo(String nameArg,
				SWFApp swfAppArg,
				Client clientArg, 
				boolean isVersionSupportedArg
			)
	{
		name = nameArg;
		swfObj = swfAppArg;
		client = clientArg;
		isVersionSupported = isVersionSupportedArg;
		
	}
	
	public SWFApp getSwfAppObj()
	{
		return this.swfObj;
	}
	public String getName()
	{
		return this.name;
	}
	public void setName(String nameArg)
	{
		this.name = nameArg;
	}
	public String getGenieVersion()
	{
		if (swfObj == null)
			return "null";
		return swfObj.genieVersion;
	}
	public void setGenieVersion(String genieVersionArg)
	{
		swfObj.genieVersion = genieVersionArg;
	}
	public String getAsVersion()
	{
		if (swfObj == null)
			return "null";
		return swfObj.asVersion;
	}
	public void setAsVersion(String asVerArg)
	{
		swfObj.asVersion = asVerArg;
	}
	public String getPlayerVersion()
	{
		if (swfObj == null)
			return "null";
		return swfObj.playerVersion;
	}
	public void setPlayerVersion(String playerVerArg)
	{
		swfObj.playerVersion = playerVerArg;
	}
	public String getPlayerType()
	{
		if (swfObj == null)
			return "null";
		return swfObj.playerType;
	}
	public void setPlayerType(String playerTypeArg)
	{
		swfObj.playerType = playerTypeArg;
	}
	public boolean getIsVersionSupported()
	{
		return this.isVersionSupported;
	}
	public void setIsVersionSupported(boolean isVerSuppArg)
	{
		this.isVersionSupported = isVerSuppArg;
	}
	public String getRealName()
	{
		if (swfObj == null)
			return "";
		return swfObj.realName;
	}
	public void setRealName(String realNameArg)
	{
		swfObj.realName = realNameArg;
	}
	public String getGeniePreloadName()
	{
		if (swfObj == null)
			return "null";
		return swfObj.preloadName;
	}
	public void setGeniePreloadName(String geniePreloadNameArg)
	{
		swfObj.preloadName = geniePreloadNameArg;
	}
	public String getPreloadSdkVersion()
	{
		if (swfObj == null)
			return "null";
		return swfObj.preloadSdkVersion;
	}
	public void setPreloadSdkVersion(String preloadSdkVerArg)
	{
		swfObj.preloadSdkVersion = preloadSdkVerArg;
	}
	public Client getClientObj()
	{
		return this.client;
	}
	public void setClientObj(Client clientArg)
	{
		this.client = clientArg;
	}
	
	public LogDataObject getLogger()
	{
		return this.logger;
	}
	
	/**
	 * @return complete xml for current Client
	 */
	public String getXml()
	{
		String xml = "<Client>";
		xml += "<Name>" + this.name + "</Name>";
		xml += "<GenieVersion>" + this.getGenieVersion() + "</GenieVersion>";
		xml += "<ActionScriptVersion>" + this.getAsVersion() + "</ActionScriptVersion>";
		xml += "<PlayerVersion>" + this.getPlayerVersion() + "</PlayerVersion>";
		xml += "<PlayerType>" + this.getPlayerType() + "</PlayerType>";
		xml += "<RealName>" + this.getRealName() + "</RealName>";
		xml += "<GeniePreloadName>" + this.getGeniePreloadName() + "</GeniePreloadName>";
		xml += "<PreloadSdkVersion>" + this.getPreloadSdkVersion() + "</PreloadSdkVersion>";
		
		xml += "</Client>";
		
		return xml;
	}
}
