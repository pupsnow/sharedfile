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

package com.adobe.genie.utils;

import java.io.StringWriter;
import java.util.ArrayList;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class XmlNode {

	private Node xmlNode = null;
	protected XmlNode(){}
	protected void setNode(Node nodeArg)
	{
		this.xmlNode = nodeArg;
	}
	public XmlNode(Node xmlNodeArg) throws Exception
	{
		this.xmlNode = xmlNodeArg;
	}
	private XPathExpression compileXPath(String xPath)
	{
		XPathExpression xExpr = null;
		try{
			javax.xml.xpath.XPathFactory xFac = javax.xml.xpath.XPathFactory.newInstance();
			XPath xp = xFac.newXPath();
			xExpr = xp.compile(xPath);
		}catch(Exception e){}
		
		return xExpr;
	}
	/**
	 * Get tag value from Node
	 * @param tagName
	 * @return Tag value from XML Node. Returns blank string, If not found
	 */
	public String getNodeValue(String tagName)
	{
		String retVal = "";
		if (this.xmlNode != null)
		{
			try{
				XPathExpression xExpr = this.compileXPath(tagName);
				if (xExpr != null)
				{
					NodeList nodes = (NodeList)xExpr.evaluate(this.xmlNode, XPathConstants.NODESET);
					retVal = nodes.item(0).getChildNodes().item(0).getNodeValue();
				}
				else
					retVal = ((Element)this.xmlNode).getElementsByTagName(tagName).item(0).getChildNodes().item(0).getTextContent();
			}catch(Exception e){}
		}
		
		return retVal;
	}
	public String getNodeValueByName(String elementName) throws Exception {
		return this.getNodeValue("//"+ elementName);
	}
	/**
	 * @returns xml string
	 */
	public String toXMLString()
	{
		String res = "";
		try{
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer tr = tf.newTransformer();
			StringWriter sw = new StringWriter();
			tr.transform(new DOMSource(this.xmlNode), new StreamResult(sw));
			res = sw.toString();
			
			/**
			 * if parsing did well, we will get string like:
			 * <?xml version="1.0" encoding="UTF-8"?>................
			 */
			if (res.indexOf("xml version") != -1)
			{
				int idx = res.indexOf(">");
				res = res.substring(idx+1);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return res;
	}
	
	/**
	 * Returns the First Node from the tag passed
	 * @param tagName
	 * @return
	 */
	public XmlNode getNode(String tagName)
	{
		XmlNode gDomNode = null;
		try{
			Node node = null;
			XPathExpression xExpr = this.compileXPath(tagName);
			if (xExpr != null)
			{
				NodeList nodes = (NodeList)xExpr.evaluate(this.xmlNode, XPathConstants.NODESET);
				node = nodes.item(0);
			}
			else
				node = ((Element)this.xmlNode).getElementsByTagName(tagName).item(0);
			
			if (node != null)
				gDomNode = new XmlNode(node);
		}catch(Exception e){}
		return gDomNode;
	}
	public XmlNode getNodeByName(String nodeName) {
		return getNode("//"+ nodeName);
	}
	
	/**
	 * Returns all the nodes matched by passed tag
	 * @param tagName
	 * @return the nodes matched by tag
	 */
	public ArrayList<XmlNode> getNodes(String tagName)
	{
		ArrayList<XmlNode> nodes = new ArrayList<XmlNode>();
		try{
			NodeList nodeList = null;
			
			XPathExpression xExpr = this.compileXPath(tagName);
			if (xExpr != null)
			{
				nodeList = (NodeList)xExpr.evaluate(this.xmlNode, XPathConstants.NODESET);
			}
			else
				nodeList = ((Element)this.xmlNode).getElementsByTagName(tagName);
			
			if (nodeList != null)
			{
				for (int i=0; i<nodeList.getLength(); i++)
				{
					XmlNode gNode = new XmlNode(nodeList.item(i));
					nodes.add(gNode);
				}
			}
			
		}catch(Exception e){}
		return nodes;
	}
	
	/**
	 * Get node value
	 * @return node value
	 */
	public String getValue()
	{
		return this.xmlNode.getTextContent();
	}
	
	/**
	 * Get Node attribute value
	 * @param attribute
	 * @return
	 */
	public String getAttributeValue(String attribute)
	{
		String retValue = "";
		if (this.xmlNode == null)
			return retValue;
		try{
			retValue = ((Element)this.xmlNode).getAttribute(attribute);
		}catch(Exception e){}
		return retValue;
	}
}
