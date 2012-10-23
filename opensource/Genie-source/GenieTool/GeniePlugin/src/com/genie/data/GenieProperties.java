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
package com.genie.data;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * The class will represent Genie Properties corresponding to one Genie ID
 * @author gsingal
 *
 */
public class GenieProperties {

	private String swfName;
	private String genieID;
	private String selectedProp = "";
	private Map<String, String> genieProperties = null;
	
	public GenieProperties(String argSwfName, String argGenieID)
	{
		swfName = new String(argSwfName);
		genieID = new String(argGenieID);		
	}
	public GenieProperties(String argSwfName, String argGenieID, Map<String, String> argGenieProperties)
	{
		swfName = new String(argSwfName);
		genieID = new String(argGenieID);
		genieProperties = new HashMap<String, String>(argGenieProperties);
	}
	
	public String getSwfName()
	{
		return this.swfName;
	}
	public String getSelectedProperty()
	{
		return this.selectedProp;
	}
	public void setSelectedProp(String property)
	{
		this.selectedProp = property;
	}
	public String getGenieProperty(String prop)
	{
		String res = "";
		Iterator<String> itr = genieProperties.keySet().iterator();
		while (itr.hasNext())
		{
			String key = itr.next();
			String val = genieProperties.get(key);
		
			if (key.equals(prop))
			{
				res = val;
				break;
			}
		}
		return res;
	}
	public Map<String, String> getGenieProperties()
	{
		return this.genieProperties;
	}
	public String getGenieID()
	{
		return this.genieID;
	}
	public void setGenieProperties(Map<String, String> argGenieProperties)
	{
		genieProperties = new HashMap<String, String>(argGenieProperties);
	}	
}
