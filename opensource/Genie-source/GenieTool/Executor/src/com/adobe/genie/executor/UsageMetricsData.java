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


import java.util.Hashtable;
import java.util.Vector;
import java.util.Enumeration;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.utils.Utils;


public class UsageMetricsData {

	Vector<String> swfList = null;
	Vector<String> featureList = null;
	Hashtable<String,String> keyValuePairs=null;	
	
	private SWFList<SWFApp> list =null;
	private String xml = "";
	private static UsageMetricsData usageInstance = null;
	
	private UsageMetricsData()
	{
	}
	
	public synchronized static UsageMetricsData getInstance()
	{
		if (usageInstance == null)
			usageInstance = new UsageMetricsData();
		return usageInstance;
	}
	
	public String getXml()
	{
		prepareSwfList();
		prepareFeatureList();			
		return this.xml;
	}
	
	public void setList(SWFList<SWFApp> myList )
	{
		list = new SWFList<SWFApp>();
		
		for(SWFApp sApp : myList)
		{
			list.add(sApp);
		}
		
		list = myList;	
	}
	
	private void prepareSwfList()

	{
		if (swfList == null)
			return;
		for (int i=1; i <= swfList.size(); i++){
			xml += "<Swf><Name>"+swfList.elementAt(i-1)+"</Name>";
			addKeyValuePairs(i);
			xml +="</Swf>";
    	}
		
	}
	
	public void addSwf(Vector<String> swfListArg)
	{
		for (int i=0; i < swfListArg.size(); i++)
			this.addSwf(swfListArg.elementAt(i));
	}
	public void addSwf(String swfName)
	{
		if (swfList == null)
			swfList = new Vector<String>();
		if (!swfList.contains(swfName))
			swfList.add(swfName);
	}
	private void prepareFeatureList()
	{
		if (featureList == null)
			return;
		for (int i=1; i <= featureList.size(); i++)
		{
			xml += "<Feature>" + featureList.elementAt(i-1) + "</Feature>";
    	}
	}
	
	private void addKeyValuePairs(int index)
	{			
		try{						
		if (list.size()!=0){
			int found=0;	
			for (int j=0;j<list.size();j++)
			{
				if (swfList.get(index-1).equals(list.get(j).name))
				{found=j;
				  break;
				}
						
			}
			prepareKeyValuePairHash("preloadName",list.get(found).preloadName);
			prepareKeyValuePairHash("preloadSdkVersion",list.get(found).preloadSdkVersion);
			
			String pType = list.get(found).playerType;
			
			prepareKeyValuePairHash("playerType", pType);
		}
		int i=1;
		Enumeration<String> myenum = keyValuePairs.keys ();
		while(myenum.hasMoreElements())
		{
			String key =myenum.nextElement ();
			this.xml += "<keyValuePair>"+key+","+ keyValuePairs.get(key)+ "</keyValuePair>";
			i++;
	    }
		keyValuePairs=null;
		}
		catch(RuntimeException e){
			Utils.printErrorOnConsole("Runtime Exception occured in UsageMetricsData.addKeyValuePairs"+e.getMessage());
		}
		catch(Exception e){
			StaticFlags sf=StaticFlags.getInstance();
			sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
		}
	}
	
	public void addFeature(String featureName)
	{
		if (featureList == null)
			featureList = new Vector<String>();
		
		if (!featureList.contains(featureName))
			featureList.add(featureName);
	}
	
	private void prepareKeyValuePairHash(String key,String value)
	{
		if (keyValuePairs == null)
			keyValuePairs = new Hashtable<String,String>();
		
		if (!keyValuePairs.containsKey(key))
			keyValuePairs.put(key, value);
	}
	
	public void dispose()
	{
		usageInstance = null;
		swfList = null;
		featureList = null;
		keyValuePairs=null;
	}
}
