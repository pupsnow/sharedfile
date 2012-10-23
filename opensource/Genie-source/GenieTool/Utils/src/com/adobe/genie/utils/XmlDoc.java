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

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Document;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XmlDoc extends XmlNode implements ErrorHandler{

	private Document doc = null;
	
	public XmlDoc(String xmlStr) throws Exception
	{
		DOMParser domParser = new DOMParser();
		domParser.setErrorHandler(this);
		domParser.setFeature("http://xml.org/sax/features/validation", false);
		domParser.setFeature("http://xml.org/sax/features/namespaces", false);
	      
		domParser.parse(new InputSource(new StringReader(xmlStr)));
		doc = domParser.getDocument();
		
		this.setNode(doc);
	}
	
	public String getBeautifyXmlString()
	{
		try{
			TransformerFactory tf = TransformerFactory.newInstance();
			tf.setAttribute("indent-number", new Integer(4));
			Transformer transformer = tf.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			StreamResult sRes = new StreamResult(new StringWriter());
			DOMSource source = new DOMSource(this.doc);
			transformer.transform(source, sRes);
			
			return sRes.getWriter().toString();
		}catch(Exception e){
			return "";
		}
	}
	
	public static String getEncodedCharString(String input)
	{
		char ch = ' ';
		String encodedStr = "";
		boolean isInvalidXMLChar = false;
		for (int i = 0; i < input.length(); i++) 
		{
			ch = input.charAt(i);
			isInvalidXMLChar = !isValidXMLChar(ch);
			
			if (isInvalidXMLChar)
			{
				encodedStr = "$GENIE_UTF$" + toHexStr(ch) + "$GENIE_UTF$";
				input = input.replace(Character.toString(ch), encodedStr);
				
				//Jump index to after replaced string
				i += encodedStr.length();
			}
		}
		
		return input;
	}	
	private static String toHexStr(char ch) 
	{
		String s = Integer.toHexString(ch);
        while (s.length() < 3)
        	s = "0" + s;
        
        return s;
    }
	private static boolean isValidXMLChar(char ch)
	{
		return (
				ch == 0x9 ||
				ch == 0xA ||
				ch == 0xD ||
				(ch >= 0x20 && ch <= 0xD7FF  ) ||
				(ch >= 0xE000 && ch <= 0xFFFD ) ||
				(ch >= 0x10000 && ch <= 0x10FFFF)
				);
	}
	
	/**
	 * Get escaped String, i.e. replace character like '>' to '&gt;'
	 * @param xmlStr
	 * @return Escaped String
	 */
	public static String escapeXml(String xmlStr)
	{
		StringBuffer sb = new StringBuffer();
		int l = xmlStr.length();
		for (int i=0; i<l; i++)
		{
			char ch = xmlStr.charAt(i);
			switch(ch)
			{
			case '<':
				sb.append("&lt;");
				break;
			case '>':
				sb.append("&gt;");
				break;
			case '&':
				sb.append("&amp;");
				break;
			case '"':
				sb.append("&quot;");
				break;
			case '\'':
				sb.append("&apos;");
				break;
			default:
				sb.append(ch);
			}
		}
		
		return sb.toString();
	}
	/******************************************************************************
	 *    Public method for exception handling, and printing   *
	 ******************************************************************************
	 */
	public void warning(SAXParseException ex) throws SAXException
	{
		printError("Warning", ex);
	}
	public void error(SAXParseException ex) throws SAXException
	{
		printError("Error", ex);
	}
	public void fatalError(SAXParseException ex) throws SAXException
	{
		printError("Fatal Error", ex);
	}
	
	private void printError(String type, SAXParseException ex) 
	{
		StringBuffer sb = new StringBuffer();
        sb.append("[");
        sb.append(type);
        sb.append("] ");
        String systemId = ex.getSystemId();
        if (systemId != null) {
            int index = systemId.lastIndexOf('/');
            if (index != -1)
                systemId = systemId.substring(index + 1);
            sb.append(systemId);
        }
        sb.append(':');
        sb.append(ex.getLineNumber());
        sb.append(':');
        sb.append(ex.getColumnNumber());
        sb.append(": ");
        sb.append(ex.getMessage());
        System.err.println();
        System.err.println(sb.toString());
        System.err.flush();
    }
}
