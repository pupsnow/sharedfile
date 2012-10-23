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

package com.adobe.geniePlugin.comunication;

import java.awt.Point;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Display;
import org.w3c.dom.Document;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.ui.ShowImage;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

public class ComponentImage extends Thread{
	private String swfName = "";
	private String genieId = "";
	private Point point = null;
	private byte[] bData = null;
	
	public ComponentImage(String swfNameArg, String genieIdArg, Point pointArg)
	{
		this.swfName = swfNameArg;
		this.genieId = genieIdArg;
		this.point = pointArg;
	}

	private String prepareXml(String genieId)
	{
		StringBuffer sb = new StringBuffer();
		sb.append("<XML>");
		sb.append("<Input>");
		sb.append("<GenieID>");
		sb.append(genieId);
		sb.append("</GenieID>");
		sb.append("</Input>");
		sb.append("</XML>");
		
		return sb.toString();
	}
	private void fillComponentImage(String swfApp, String genieId)
	{
		String objXml = this.prepareXml(genieId);
		
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		Result result = sc.doAction(swfApp, "captureComponentImage", objXml);
		
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
						this.bData = Base64.decode(message);
					}
				}
			}
				
		}catch(Exception e){
			Utils.printErrorOnConsole("Exception while taking Component Image: " + e.getMessage());
		}
	}
	
	public void run()
	{
		Utils.printMessageOnConsole("Capturing image for genieId: " + this.genieId);
		this.fillComponentImage(this.swfName, this.genieId);
		if (this.bData != null)
		{
			try{
				InputStream is = new ByteArrayInputStream(this.bData);
				
				final Image img = new Image(Display.getCurrent(), is);
				
				Rectangle rect = img.getBounds();
				int y = rect.height/2;
				int x = rect.width/2;
				final Point midPt = new Point(point.x-x, point.y-y);
				
				SWFList list = SWFList.getInstance();
				final SWFAppUI app = (SWFAppUI) list.getSWF(this.swfName);
				if (app != null)
				{
					Display.getDefault().asyncExec(new Runnable() {
						 public void run() {
							 ShowImage showImg = new ShowImage(img, midPt);
							 showImg.start();
						 }
					});
				}			
			}catch(Exception ex){
				Utils.printErrorOnConsole("Exception in ComponentImage::run: " + ex.getMessage());
			}
		}
		else
		{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					 ShowImage showImg = new ShowImage(null, point);
					 showImg.start();
				 }
			});
		}
	}
}
