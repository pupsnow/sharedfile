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

import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;

/**
 * This class loads information custom component configuration data.
 */
public class CustomConfigData {

	public Hashtable<String, CustomComponentData> components = new Hashtable<String, CustomComponentData>();
	private String[] classNamesForPreload = null;

	private String configFilePath = null;	
	private static CustomConfigData instance = null;
		
	/**
	 * Instantiate a CustomConfigData singleton instance and returns the instance
	 */
	public static CustomConfigData getInstance(String fileName) {
	      if(instance == null) {
	    	  try {
	    		  instance = new CustomConfigData(fileName);
		      } catch (Exception e) {
					return null;
		      }
	      }
	      return instance;
	}
	
	/**
	 * Just return the instance assuming it is already initialized once
	 */
	public static CustomConfigData getInstance() {
		return instance;
	}
	
	//Actual initialization
	private CustomConfigData(String filePath) throws Exception
	{
		configFilePath = filePath;
		loadFile();
	}
	
	//Loads the custom component configuration file
	private void loadFile() throws Exception
	{
		try{
			
			XmlDoc xmlDoc = new XmlDoc(Utils.getTextFromFile(configFilePath));
			ArrayList<XmlNode> comps = xmlDoc.getNodes("/Config/CustomComponent");
			for(int i=0 ; i<comps.size(); ++i)
			{
				XmlNode customComponentNode = comps.get(i);
				String customCompName = customComponentNode.getAttributeValue("name");
				CustomComponentData data = new CustomComponentData(customCompName);
				
				data.executor = fillInfo("Executor/ClassFilePath", customComponentNode);
				data.plugin = fillInfo("Plugin/MapDataFilePath", customComponentNode);
				data.preload.componentSWF = fillInfo("Preload/ComponentSWF", customComponentNode);
				data.preload.envXML = fillInfo("Preload/EnvFile", customComponentNode);
				components.put(customCompName, data);
			}
			
			XmlNode classNode = xmlDoc.getNode("/Config/ExposeChildObjects");
			if (classNode != null)
			{
				List<XmlNode> classNamesNode = classNode.getNodes("//Class");
				if (classNamesNode != null)
				{
					this.classNamesForPreload = new String[classNamesNode.size()];
					for (int i=0; i<classNamesNode.size(); i++)
					{
						XmlNode xNode = classNamesNode.get(i);
						String className = xNode.getAttributeValue("Name");
						this.classNamesForPreload[i] = className;
					}
				}
			}			
		}
		catch(Exception e){
			Shared.displayExecptionInfo(e,"Error while parsing custom component configuration file!!!");
			throw new Exception(e);
		}
	}
	
	public String[] getClassNames()
	{
		return this.classNamesForPreload;
	}
	
	//Return value at a xpath as string array
	private String[] fillInfo(String pathToFind, XmlNode customComponentNode)
	{
		ArrayList<XmlNode> componentInfoNodes = customComponentNode.getNodes(pathToFind);
		String[] arrayToFill = new String[componentInfoNodes.size()];
		for(int j=0 ; j<componentInfoNodes.size(); ++j)
		{
			XmlNode infoNode = componentInfoNodes.get(j);
			String value = infoNode.getAttributeValue("value");
			File file = new File(value);
			if(!value.startsWith("http:") || value.startsWith("/sdcard"))
			{
				if(!file.exists())
				{
					Utils.printErrorOnConsole("Custom Config Error: Could not find file. " + value);
					arrayToFill[j] = value;
				}
				else
				{
					arrayToFill[j] = value;
				}
			}
			else
				arrayToFill[j] = value;
		}
		return arrayToFill;
	}
}
