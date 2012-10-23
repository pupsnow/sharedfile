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

import java.util.ArrayList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;

public class CommandHandler {

	private boolean isSecondExecutor = false;
	private boolean isDebugMode = false;
	
	/**
	 * 
	 * @return its own version
	 */
	public String getVersion()
	{
		VersionHandler vH = VersionHandler.getInstance();
		return vH.getExecutorVersion();
	}
	
	public void secondExecutor(String from, String data)
	{
		isSecondExecutor = true;
		SynchronizedSocket.getInstance().setDoneFlag();
	}
	
	public boolean isSecondExecutor()
	{
		return this.isSecondExecutor;
	}
	
	public void traceDebug(String from, String data){
		isDebugMode = Utils.getTagValue(data, "Boolean").equalsIgnoreCase("true")? true : false ;
		StaticFlags sf = StaticFlags.getInstance();
		sf.setDebugMode(isDebugMode);
	}
	
	public void customComponentInfo(String from, String data)
	{
		try{
			UsageMetricsData usageInstance = UsageMetricsData.getInstance();
			usageInstance.addFeature("CustomComponent");
			
			XmlDoc xmlDoc = new XmlDoc(data);
			ArrayList<XmlNode> nodes = xmlDoc.getNodes("/String/Path");
			
			for(int i=0; i<nodes.size(); ++i)
			{
				StaticFlags.getInstance().addCustomClass(nodes.get(i).getValue());
			}
		}catch (Exception e) {
			
		}
		
	}
	
	public void updateGenieID(String from, String data)
	{
		//System.out.println(data);
		String[] array = data.split("__SEP__");
		if(array.length == 2)
		{
			String oldGenieId = array[0];
			String newGenieId = array[1];
			StaticFlags.getInstance().setUpdatedGenieId(oldGenieId, newGenieId);
			
		}
	}
	public void eventCalled(String from, String data)
	{
		System.out.println("hello I am called");
	}
}
