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
import java.util.Hashtable;
import java.util.Vector;

import com.adobe.genie.utils.XmlNode;

public class UsageMetricsData {

	public UsageMetricsData()
	{
		
	}
	
	Hashtable<String,Hashtable<String,String>> getSwfList(XmlNode data)
	{
		Hashtable<String,Hashtable<String,String>> scriptSwfs = new Hashtable<String,Hashtable<String,String>>();		
	
			try 
			{
			ArrayList<XmlNode> mySwfNodes=data.getNodes("Swf");
					for (int i=0;i<mySwfNodes.size();i++)
					{
					 Hashtable<String,String> KeyValuePairs=new Hashtable<String,String>();
					 XmlNode tempSwfNode=mySwfNodes.get(i);
					 ArrayList<XmlNode> tempNameNodeList=tempSwfNode.getNodes("Name");
					 XmlNode tempNameNode=tempNameNodeList.get(0);
					 ArrayList<XmlNode> myKeyValueNodesList=tempSwfNode.getNodes("keyValuePair");
						 for (int j=0;j<myKeyValueNodesList.size();j++)
						 {
						 XmlNode tempkeyValueNode=myKeyValueNodesList.get(j);
						 String keyAndValue[]=tempkeyValueNode.getValue().split(",");
						 KeyValuePairs.put(keyAndValue[0],keyAndValue[1]);						
						 }
						 
					  scriptSwfs.put(tempNameNode.getValue(),KeyValuePairs);
					  KeyValuePairs=null;
					}
			}
			catch (Exception e) 
		    {
				Shared.displayExecptionInfo(e,"Error while reading Name or KeyValue pairs while performing action: ScriptCompletion ");
			}
			
		
		return scriptSwfs;
	}
	
	public Vector<String> getFeatureList(XmlNode data)
	{
		Vector<String> featureList = new Vector<String>();
		try 
		{
		ArrayList<XmlNode> myFeatureNodes=data.getNodes("Feature");
		for (int i=0;i<myFeatureNodes.size();i++)
		{
			XmlNode tempFeatureNode=myFeatureNodes.get(i);
			String Feature=tempFeatureNode.getValue();
			featureList.add(Feature);
		}
		}
		catch (Exception e) {
			Shared.displayExecptionInfo(e,"Error while reading Feature name while performing action: ScriptCompletion ");
		}
		return featureList;
		/*Vector<String> featureList = new Vector<String>();
		int i=1;
		while (true) {
			String tag = "Feature" + i;
			if (data.getNodeByName(tag) != null) {
				try {
					featureList.add(data.getNodeValueByName(tag));
				} catch (Exception e) {
					Shared.displayExecptionInfo(e,"Error while reading SWF name while performing action: ScriptCompletion ");
				}
			}
			else {
				break;
			}
			i++;
		}
	*/	
		
	}
	public Hashtable<String,String> getKeyValuePairs(XmlNode data)
	{
		Hashtable<String,String> keyValuePairs = new Hashtable<String,String>();
		int i=1;
		while (true) {
			String tag = "keyValuePair" + i;
			if (data.getNodeByName(tag) != null) {
				try {
					String myKeyValues=data.getNodeValueByName(tag);
					String myKeyValuesArray[]=myKeyValues.split(",");
					keyValuePairs.put(myKeyValuesArray[0],myKeyValuesArray[1]);
				} catch (Exception e) {
					Shared.displayExecptionInfo(e,"Error while reading keyValuePairs while performing action: ScriptCompletion ");
				}
			}
			else {
				break;
			}
			i++;
		}
		
		return keyValuePairs;
		
		
		
	}
}
