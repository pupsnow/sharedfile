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
package com.adobe.geniePlugin.ui;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Shell;

import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;

import org.w3c.dom.Document;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;

public class GenieComponentXML extends Thread {
	
	private String appName = "";
	private String genieID = "";
	Shell shell = null;
	Display display = null;
	
	public GenieComponentXML(String swfAppName, String genieID)
	{
			this.appName = swfAppName;
			this.genieID = genieID;
			createWidget();
	}
	
	private void createWidget()
	{
		display = Display.getCurrent();
		shell = new Shell(display, SWT.APPLICATION_MODAL | SWT.ON_TOP);
	}
	
	public void run()
	{
		Display.getDefault().asyncExec(new Runnable() {
			public void run() {
				saveComponentXML();
			}
		});
	}
	
	private void saveComponentXML()
	{
		FileDialog fd = new FileDialog(shell, SWT.SAVE);
		fd.setOverwrite(true);
	    fd.setText("Save Component XML");
	    String[] filterExt = { "*.xml"};
	    fd.setFilterExtensions(filterExt);
	    String cPath = fd.open();
	    if (cPath != null)
	    {
	    	if (!cPath.endsWith(".xml"))
	    		cPath += ".xml";
	    	
	    	BufferedWriter out;
			try {
				out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(cPath), "UTF-8"));
				String compXmlStr = getComponentXMLData();
				out.write(compXmlStr);
				out.newLine();
				out.flush();
				out.close();	
			}
			catch (UnsupportedEncodingException e) {
				Utils.printErrorOnConsole("UnsupportedEncodingException " + e.getMessage());
				//e.printStackTrace();
			} catch (FileNotFoundException e) {
				Utils.printErrorOnConsole("FileNotFoundException " + e.getMessage());
				//e.printStackTrace();
			} catch (IOException e) {
				Utils.printErrorOnConsole("IOException " + e.getMessage());
				//e.printStackTrace();
			}
	    }
	}	
		
	
	private String prepareXml()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("<XML>");
		sb.append("<Input>");
		sb.append("<GenieID>");
		sb.append(genieID);
		sb.append("</GenieID>");
		sb.append("</Input>");
		sb.append("</XML>");
		return sb.toString();
	}
	
	public String getComponentXMLData()
	{
		Utils.printMessageOnConsole("Saving XML data for GenieComponent " + this.genieID);
		String componentXMLData = "";
		String objXml = this.prepareXml();
		
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		Result result = sc.doAction(appName, "saveComponentXML", objXml);
		
		Document doc = Utils.getXMLDocFromString(result.message);
		try{
			if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
			{
				String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
				boolean bResult =  Boolean.parseBoolean(temp);
				
				if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
				{
					String message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
					if (bResult)
					{
						componentXMLData = message;
					}
					else
					{
						Utils.printErrorOnConsole("Error in getting component xml Data : " + message);
					}
				}
			}
				
		}catch(Exception e){
			Utils.printErrorOnConsole("Exception while saving component xml: " + e.getMessage());
		}
		return componentXMLData;
	}
}