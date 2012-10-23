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
package com.adobe.genie.genieCom;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.adobe.genie.utils.Utils;

/**
 * This class provides some common methods that can be used by classes using GenieCom
 * <p>
 * All the methods defined here should be static and should be used appropriately 
 * 
 * @since Genie 0.4
 */
public class SharedFunctions {

	@SuppressWarnings("unchecked")
	public static SWFList<SWFApp> createSWFAppListFromXML(String swfListStr) throws Exception
	{
		Document doc = null;
		SWFList<SWFApp> list = null;
		
		if(swfListStr!=null && swfListStr.length()!=0)
		{
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			doc = db.parse(Utils.parseStringToIS(swfListStr));
			
			NodeList clientNodes = doc.getElementsByTagName("Client");
			list = (SWFList<SWFApp>) SWFList.getInstance();
			list.clear();
			for (int i =0 ; i<clientNodes.getLength(); ++i)
			{
				SWFApp app = new SWFApp();
				app.name = ((Element) clientNodes.item(i)).getElementsByTagName("Name").item(0).getChildNodes().item(0).getTextContent();
				app.genieVersion = ((Element) clientNodes.item(i)).getElementsByTagName("GenieVersion").item(0).getChildNodes().item(0).getTextContent();
				app.asVersion = ((Element) clientNodes.item(i)).getElementsByTagName("ActionScriptVersion").item(0).getChildNodes().item(0).getTextContent();
				app.playerVersion = ((Element) clientNodes.item(i)).getElementsByTagName("PlayerVersion").item(0).getChildNodes().item(0).getTextContent();
				app.playerType = ((Element) clientNodes.item(i)).getElementsByTagName("PlayerType").item(0).getChildNodes().item(0).getTextContent();
				app.realName = ((Element) clientNodes.item(i)).getElementsByTagName("RealName").item(0).getChildNodes().item(0).getTextContent();
				app.preloadName = ((Element) clientNodes.item(i)).getElementsByTagName("GeniePreloadName").item(0).getChildNodes().item(0).getTextContent();
				app.preloadSdkVersion = ((Element) clientNodes.item(i)).getElementsByTagName("PreloadSdkVersion").item(0).getChildNodes().item(0).getTextContent();
				
				app.isConnected = false;
				
				list.add(app);
			}
		}
		return list;
	}
}
