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

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.adobe.genie.utils.Utils;

public class PreloadData {

	private Document doc = null;

	public PreloadData(String data) {
		try {
			doc = Utils.getXMLDocFromString(data);
		} catch (Exception e) {
			doc = null;
		}
	}

	public int getParamCount() {
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = "Data/Arguments/Argument";
		NodeList list = null;
		int length = 0;
		try {
			list = (NodeList) xpath.evaluate(expression, doc,
					XPathConstants.NODESET);
			length = list.getLength();
		} catch (Exception e) {

		}

		try {
			expression = "Data/PreloadParams/PreloadParam";
			list = (NodeList) xpath.evaluate(expression, doc,
					XPathConstants.NODESET);
			length += list.getLength();

		} catch (Exception e) {

		}

		if (length != 0)
			return length;
		else
			return 0;
	}

	public String getGenieId() {
		return getParam("/Data/GenieID");

	}

	public String getEventName() {
		return getParam("/Data/Event");
	}

	public String getObjectType() {
		return getParam("/Data/ClassName");
	}

	public String getParam(String paramPath, int i) {
		return helpGetParam(paramPath, i);
	}

	public String getParam(String paramPath) {
		return helpGetParam(paramPath, 0);
	}

	private String helpGetParam(String paramPath, int i) {
		// "GenieID"
		XPath xpath = XPathFactory.newInstance().newXPath();
		String expression = paramPath;
		String value = "";
		try {
			if (paramPath.equalsIgnoreCase("Data/PreloadParams/PreloadParam"))
				value = xpath.evaluate(expression, doc);
			else {
				NodeList list = (NodeList) xpath.evaluate(expression, doc,
						XPathConstants.NODESET);
				if (list.getLength() > i) {
					Element node = (Element) list.item(i);
					value = node.getTextContent();
				} else {
					// no value found
				}
			}
		} catch (Exception e) {

		}

		return value;
	}

}
