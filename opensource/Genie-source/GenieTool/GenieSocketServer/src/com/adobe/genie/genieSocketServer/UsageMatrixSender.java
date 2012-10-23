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

import java.net.InetAddress;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
//import java.util.logging.Level;
//import java.util.logging.Logger;

//import org.tempuri.ServiceSoap;
//import org.tempuri.ServiceSoapProxy;

//This class sends usage matrix data on a separate thread so that it does not block executor
public class UsageMatrixSender extends Thread {
	
	String clientSwfName;
	Vector<String> features;
	Hashtable<String,String> keyValuePairs;
	
	public UsageMatrixSender(String clientSwfName, Vector<String> features,Hashtable<String,String> keyValuePairs)
	{
		this.clientSwfName = clientSwfName;
		this.features = features;
		this.keyValuePairs = keyValuePairs;
	}
	public void run() {
		logUsageMatrixData(clientSwfName, features, keyValuePairs);
	}
	
	private void logUsageMatrixData(String clientSwfName, Vector<String> features,Hashtable<String,String> keyValuePairs){
		String usagematrixData = "";
		try{
			String revisedSwfName = clientSwfName.replaceFirst("_[0-9]*$", "");
			
			usagematrixData += "<UsageMetrics>";
			usagematrixData += "<UsageInfo>";
			usagematrixData += "<ToolName version=\""+VersionHandler.getInstance().getServerVersion()+"\">Genie</ToolName>";
			usagematrixData += "<Product>" + revisedSwfName + "</Product>";
			usagematrixData += "<User>" + System.getProperty("user.name") + "</User>";			
			usagematrixData += "<ChildTools>";
			usagematrixData += "</ChildTools>";
	
			usagematrixData += "<Features>";
			for(int i=0;i<features.size();i++)
				usagematrixData += "<Feature>" + features.get(i).toString() +"</Feature>";
			usagematrixData += "</Features>";
			
			
			usagematrixData +="<KeyValue>";			
			Enumeration<String> myenum = keyValuePairs.keys ();		
			while(myenum.hasMoreElements())
			{
			String key =myenum.nextElement ();	
			usagematrixData +="<"+key+">"+keyValuePairs.get(key)+"</"+key+">";
			}
			usagematrixData +="</KeyValue>";
			
	
			usagematrixData += "<MachineInfo>";
			usagematrixData += "<MachineName>" + InetAddress.getLocalHost().getHostName()+ "</MachineName>";
			usagematrixData += "<MachineIP>" + InetAddress.getLocalHost().getHostAddress() + "</MachineIP>";
			
			//Get the Platform for the machine
			String platform = "";
			String os = System.getProperty("os.name").toLowerCase();
			if(os.indexOf( "win" ) >= 0)
				platform = "Windows";
			else if(os.indexOf( "nix") >=0)
				platform = "Unix";
			else if(os.indexOf( "nux") >=0)
				platform = "Linux";
			else
				platform = "Macintosh";
		
			usagematrixData += "<MachinePlatform>" + platform + "</MachinePlatform>";
			usagematrixData += "<MachineOS>" + System.getProperty("os.name") + "</MachineOS>";
			usagematrixData += "<MachineLanguage>" + System.getProperty("user.language") + "</MachineLanguage>";
			usagematrixData += "</MachineInfo>";
			
			usagematrixData += "</UsageInfo>";
			usagematrixData += "</UsageMetrics>";
			
			
//			Logger log = Logger.getLogger(org.apache.axis.utils.JavaUtils.class.getName());
//			log.setLevel(Level.SEVERE);

//			ServiceSoap service = new ServiceSoapProxy();
//			service.usageMetricsToolParams(usagematrixData,"Genie");
		}
		catch(Exception e){}
	}
}
