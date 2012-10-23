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
package com.adobe.geniePlugin.record;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.eclipse.core.runtime.Platform;
import org.eclipse.ui.internal.util.BundleUtility;
import org.osgi.framework.Bundle;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.adobe.genie.utils.Utils;

public class MapActions {

	private static MapActions mapActions = null;
	private Document doc = null;
	private ArrayList<Document> userDocs = new ArrayList<Document>();
	
	public static MapActions getInstance()
	{
		if (mapActions == null)
			mapActions = new MapActions();
		return mapActions;
	}
	
	private MapActions()
	{	
		try
		{
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Bundle bundle = Platform.getBundle("GeniePlugin");
			URL fullPathString = BundleUtility.find(bundle, "resources/MapData.xml");
			doc = db.parse(fullPathString.openStream());
			doc.getDocumentElement().normalize();
		}catch(Exception e){doc = null;}
		
	}
	
	public void crawlForUserSuppliedMapdataXML(ArrayList<String> customMapDataXML)
	{
		Document newDoc = null;
		
		try{
			for (int i=0; i < customMapDataXML.size(); i++)
			{
				DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				
				File tpFile = new File(customMapDataXML.get(i));
				URL fullPathString = tpFile.toURL();
				newDoc = db.parse(fullPathString.openStream());
				newDoc.getDocumentElement().normalize();
				NodeList list = newDoc.getElementsByTagName("Component");
				for(int j=0; j<list.getLength(); ++j)
				{
					Node importedNode = doc.importNode(list.item(j), true);
					doc.getDocumentElement().appendChild(importedNode);
					//doc.adoptNode(importedNode);
				}
				userDocs.add(newDoc);
			}
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}
	
	private String getJavaInterfaceComponentFromUserDocs(String preloadCompName)
	{
			
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component[@preloadName='" + preloadCompName + "']";
		String javaClass = "";
		try
		{
			for (int i=0; i < userDocs.size(); i++)
			{	
				NodeList list = (NodeList) xpath.evaluate(expression, userDocs.get(i), XPathConstants.NODESET);
				if(list.getLength() > 0)
				{
					Element compNode = (Element)list.item(0);
					javaClass = compNode.getAttribute("javaInterfaceName");
					break;
				}
				else
				{
					//no java class found
				}
			}
		}catch(Exception e)
		{
			
		}
		
		return javaClass;
	}
	private String getJavaClassComponentFromUserDocs(String preloadCompName)
	{
			
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component[@preloadName='" + preloadCompName + "']";
		String javaClass = "";
		try
		{
			for (int i=0; i < userDocs.size(); i++)
			{	
				NodeList list = (NodeList) xpath.evaluate(expression, userDocs.get(i), XPathConstants.NODESET);
				if(list.getLength() > 0)
				{
					Element compNode = (Element)list.item(0);
					javaClass = compNode.getAttribute("javaClassName");
					break;
				}
				else
				{
					//no java class found
				}
			}
		}catch(Exception e)
		{
			
		}
		
		return javaClass;
	}
	private NodeList getJavaComponentMethodFromUserDocs(String preloadCompName, String preloadMethodName, PreloadData preloadData)
	{
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component[@preloadName='" + preloadCompName + "']/Method[@preloadName='" + preloadMethodName + "']";
		NodeList paramList = null;
		try
		{
			for (int i=0; i < userDocs.size(); i++)
			{	
				NodeList list = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
				Element eventElement = null;
				if(list.getLength() > 0)
				{
					int x = 0;
					eventElement = ((Element) list.item(x));
					paramList = eventElement.getElementsByTagName("Param");
					while(paramList.getLength() != preloadData.getParamCount())
					{
						i++;
						eventElement = ((Element) list.item(x));
						paramList = eventElement.getElementsByTagName("Param");
					}
				}
				else
				{
					//no java class found
				}
			}
		}catch(Exception e)
		{
			
		}
		
		return paramList;
	}
	
	public String getJavaInterfaceComponent(String preloadCompName)
	{
			
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component[@preloadName='" + preloadCompName + "']";
		String javaClass = "";
		try
		{
			NodeList list = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
			if(list.getLength() > 0)
			{
				Element compNode = (Element)list.item(0);
				javaClass = compNode.getAttribute("javaInterfaceName");
			}
			else
			{
				//no java class found. Try finding in user supplied xml
				javaClass = getJavaInterfaceComponentFromUserDocs(preloadCompName);
			}
		}catch(Exception e)
		{
			
		}
		
		return javaClass;
	}
	
	public String getJavaClassComponent(String preloadCompName)
	{
			
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component[@preloadName='" + preloadCompName + "']";
		String javaClass = "";
		try
		{
			NodeList list = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
			if(list.getLength() > 0)
			{
				Element compNode = (Element)list.item(0);
				javaClass = compNode.getAttribute("javaClassName");
			}
			if(javaClass.length() == 0)
			{
				//no java class found
				String expr = "/XML/Component[@preloadName='" + preloadCompName + "']";
				String parentClass = "";
				xpath = XPathFactory.newInstance().newXPath();
				NodeList tempList = (NodeList) xpath.evaluate(expr, doc, XPathConstants.NODESET);
				if(tempList.getLength() > 0)
				{
					Element compNode = (Element)tempList.item(0);
					parentClass = compNode.getAttribute("preloadParentClass");
					return getJavaClassComponent(parentClass);
				}
				else
				{
					//no java class found
					javaClass = getJavaClassComponentFromUserDocs(preloadCompName);
				}
			}
		}catch(Exception e)
		{
			
		}
		
		return javaClass;
	}
	
	
	public PlaybackInfo getJavaComponentInfo(String preloadCompName, String preloadActionName,PreloadData preloadData)
	{
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "/XML/Component/PreloadClassName[@name='" + preloadCompName + "']";
		PlaybackInfo info = new PlaybackInfo();
		
		try
		{			
			NodeList list = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
			//Filling class name information.
			if(list.getLength() > 0)
			{
				Element compNode = (Element)list.item(0);
				compNode = (Element)compNode.getParentNode();
				info.javaClassName = compNode.getAttribute("javaClassName");
				//Filling method name
				String methodExpr = "Method[@preloadName='" + preloadActionName + "']";
				NodeList methodList = (NodeList) xpath.evaluate(methodExpr, (Node)compNode, XPathConstants.NODESET);
				if(methodList.getLength()>0)
				{
					Element methodNode = (Element)methodList.item(0);
					info.javaMethodName = methodNode.getAttribute("javaName");
					//Get param info
					info.args = getJavaComponentMethodParams(info.javaClassName, info.javaMethodName, preloadData);
					
				}
				else
				{
					//Find method in parent class
					String javaParentClass = compNode.getAttribute("javaParentClass");
					Boolean keepTrying = false;
					if(javaParentClass.length() > 0)
						keepTrying = true;
					while(keepTrying)
					{
						expression = "/XML/Component[@javaClassName='" + javaParentClass + "']";
						NodeList parentCompList = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
						if(parentCompList.getLength()>0)
						{
							Element parentCompNode = (Element)parentCompList.item(0);
							methodList = (NodeList) xpath.evaluate(methodExpr, (Node)parentCompNode, XPathConstants.NODESET);
							if(methodList.getLength()>0)
							{
								Element methodNode = (Element)methodList.item(0);
								info.javaMethodName = methodNode.getAttribute("javaName");
								keepTrying = false;
								break;
							}
							else
							{
								javaParentClass = parentCompNode.getAttribute("javaParentClass");
								if(javaParentClass.length() > 0)
									keepTrying = true;
								else
									keepTrying = false;
							}
						}
						else
							keepTrying = false;
					}
					//Get param info
					info.args = getJavaComponentMethodParams(javaParentClass, info.javaMethodName, preloadData);
				}
				
			}
			
			
			
			
			/*else
			{
				//no java method found
				//Look for javaExtends attribute
				//check in extends comp
				String expr = "/XML/Component[@preloadName='" + preloadCompName + "']";
				String parentClass = "";
				try
				{
					xpath = XPathFactory.newInstance().newXPath();
					NodeList tempList = (NodeList) xpath.evaluate(expr, doc, XPathConstants.NODESET);
					if(tempList.getLength() > 0)
					{
						Element compNode = (Element)tempList.item(0);
						parentClass = compNode.getAttribute("preloadParentClass");
						info = getJavaComponentMethod(parentClass, preloadActionName);
					}
					else
					{
						//no java class found
					}
				}catch(Exception e)
				{
					
				}
				
				
			}*/
		}catch(Exception e)
		{
			if(e.getMessage().equalsIgnoreCase("parameter validation failed"))
			{
				info.javaClassName = "";
				info.javaMethodName = "";
				info.args = "";
			}
		}
		//info.javaClassName = javaClassName;
		return info;
	}
	
	private boolean validateParam(String preloadParam, String paramJavaTypeStr) throws Exception
	{
		if(paramJavaTypeStr.equalsIgnoreCase("String"))
		{
			 preloadParam.toString();
		}
		else if(paramJavaTypeStr.equalsIgnoreCase("Integer") || paramJavaTypeStr.equalsIgnoreCase("int"))
		{
			 Integer.parseInt(preloadParam);
		}
		else if(paramJavaTypeStr.equalsIgnoreCase("Boolean"))
		{
			 Boolean.parseBoolean(preloadParam);
		}
		else if(paramJavaTypeStr.equalsIgnoreCase("Double"))
		{
			 Double.parseDouble(preloadParam);
		}
		
		return true;
	}
	
	public String createParamsString(String preloadCompName, String preloadActionName)
	{
		
		/*String preloadParam = "Hello";
		Class paramJavaType = String.class;
		Object obj = paramJavaType.cast(preloadParam);*/
		
		
		String outputStr = "";
		String preloadParam = "false";
		String paramJavaTypeStr = "Boolean";
		outputStr = outputStr + "," + preloadParam;
		//Remove first Comma ,
		outputStr = outputStr.substring(1);
		
		//System.out.println(obj.toString());
		//Class paramJavaType = Integer.class;
		//Object obj = paramJavaType.cast(preloadParam);
		
		return outputStr;
	}
	
	private boolean checkMethodValidation(String className, String methodName, Class[] params)
	{
		Method method = null;
		try
		{
			Class<?> cl = ClassLoader.getSystemClassLoader().loadClass(className);
			method = cl.getMethod(methodName, params);
			
		}
		catch(Exception e){return true;}
		if(method != null)
			return true;
		else
			return false;
	}
	private String encloseInQuotes(String input)
	{
		return "\"" + input + "\"";
	}
	public String getJavaComponentMethodParams(String javaClassName, String javaMethodName, PreloadData preloadData) throws Exception
	{
		
		/*String preloadParam = "Hello";
		Class paramJavaType = String.class;
		Object obj = paramJavaType.cast(preloadParam);*/
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		//String expression = "/XML/Component[@preloadName='" + preloadCompName+ "']/Method[@preloadName='" + preloadActionName+ "']/Param";
		String expression = "/XML/Component[@javaClassName='" + javaClassName+ "']/Method[@javaName='" + javaMethodName+ "']";
		
		Class paramArr[] = {};
		String outputStr = "";
		try
		{
			NodeList list = (NodeList) xpath.evaluate(expression, doc, XPathConstants.NODESET);
			Element eventElement = null;
			NodeList paramList = null;
			if(list.getLength() > 0)
			{
				int i = 0;
				eventElement = ((Element) list.item(i));
				paramList = eventElement.getElementsByTagName("Param");
				while(paramList.getLength() != preloadData.getParamCount())
				{
					i++;
					eventElement = ((Element) list.item(i));
					paramList = eventElement.getElementsByTagName("Param");
				}
			}
			else
			{
				//Let's check in user class
				paramList = getJavaComponentMethodFromUserDocs(javaClassName, javaMethodName, preloadData);
			}
			if(paramList == null)
			{
				throw(new Exception("parameter validation failed"));
				
			}
			
			paramArr = new Class[paramList.getLength()];
			
			if(paramList.getLength() == preloadData.getParamCount())
			{
				for(int i=0; i< paramList.getLength(); ++i)
				{
					Element methodElement = (Element)paramList.item(i);
					
					String preloadParamName = methodElement.getAttribute("preloadName");
					//get value from preload Data
					String preloadParamValue = preloadData.getParam(preloadParamName, i);
					
					String paramJavaTypeStr = methodElement.getAttribute("type");
					if(validateParam(preloadParamValue, paramJavaTypeStr))
					{
						if(paramJavaTypeStr.equalsIgnoreCase("string"))
						{
							paramArr[i] = String.class;
							preloadParamValue = encloseInQuotes(Utils.getEscapedString(preloadParamValue));
						}
					}
					outputStr = outputStr + "," + preloadParamValue;
				}
			}
		}catch(Exception e){
			throw(new Exception("parameter validation failed"));
		}
		
		//Remove first Comma ,
		if(outputStr.length()>1)
			outputStr = outputStr.substring(1);
		//if(!checkMethodValidation(getJavaInterfaceComponent(preloadCompName), getJavaComponentMethod(preloadCompName, preloadActionName), paramArr))
		//{
			//outputStr = "";
			//throw(new Exception("parameter validation failed"));
		//}
		
		return outputStr;
	}
	
	protected void finalize() throws Throwable
	{
		super.finalize();
		if (userDocs != null)
			userDocs.clear();
	}
}
