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

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.geniePlugin.model.GenieObject;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.views.GenieView;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;
import com.genie.data.TreeTab;

public class ParseAppXML implements Runnable{

	private String from;
	private String data;
	private String action;
	
	public ParseAppXML(String from, String data, String action)
	{
		this.from = from;
		this.data = data;
		this.action = action;
	}
	
	private void instantRefresh(SWFAppUI app)
	{
		try
		{
			GenieView gv = GenieView.getInstance();
			if (!gv.getGeniePropertiesAction.isChecked())
			{
				GenieObject gObject = app.uiRep.getSelectedTreeItem();
				app.uiRep.setInputForTableViewer(gObject.getGenieId(), gObject.getProperties());
			}
		}catch(Exception e){}
	}
	synchronized public void run() {
		String debugStr = "ParseAppXml::run";
		
		if(action.equals("appXML"))
		{
			SWFList<SWFAppUI> list = SWFList.getInstance();
			SWFAppUI app = (SWFAppUI) list.getSWF(from);

			if (app.isTimeout || app.isCancelled)
			{
				app.disconnect();
				return;
			}
			
			app.isAppReplied = true;
			
			LogData log = LogData.getInstance();
			
			if( (((app.uiRep != null) && app.uiRep.isTabForTimeout) || (app.uiRep == null)) && !app.isVisibleOnUI)
			{
				boolean excep= false;
				try{
					app.genieData = new GenieObject();
					app.genieData.setXml(Utils.getXMLDocFromString(data).getDocumentElement());
					
					log.trace(LogData.INFO, debugStr + " appXML, creating tab for swf: " + app.name);
					
					//close if previous was timeout
					StaticFlags sf = StaticFlags.getInstance();
					sf.removeErrorTabIfPresent(app.name);
					
					GenieView view1 = GenieView.getInstanceAndShowView();
					TreeTab  treeTab = new TreeTab();
					treeTab.createTab(view1.tabFolder,app);
					app.isVisibleOnUI = true;
					
				}catch(Exception e)
				{
					excep = true;
				}
				if(!excep)
					SocketClient.getInstance().setDebugFlag(app.name, true, "");
			}
			else
			{
				//Update tree xml
				if (app != null)
				{
					app.clearObjectMap();
					app.genieData = new GenieObject();
					app.genieData.setXml(Utils.getXMLDocFromString(data).getDocumentElement());
					app.clearObjectMap();
					app.uiRep.refreshTree(app);
				}
				//log.trace(LogData.INFO, "Tab already created, app Status: " + app.toString());
			}
			
			app.isAppReplied = false;
			//Send debug flag only when app xml parsing is complete
			SocketClient.getInstance().setDebugFlag(app.name, true, "");
						
		}
		else
		{
			String genieID = "";
			String dataXML = "<Data>"+ data + "</Data>";
			Document doc = Utils.getXMLDocFromString(dataXML);
			
			genieID = doc.getElementsByTagName("GenieID").item(0).getChildNodes().item(0).getNodeValue();
			Node deltaElement = doc.getElementsByTagName("Delta").item(0);
			
			SWFList<SWFAppUI> list = SWFList.getInstance();
			SWFAppUI app = list.getSWF(from);
			if (app != null)
			{
				GenieObject parentObject = app.objectMap.get(genieID);
				if(parentObject != null)
				{
					app.addGenieObjectFromXML((Element)deltaElement,parentObject);
				}
			
				//Suman: Commented below line for bug#
				//This function is used to refresh properties of the currently selected node after parsing delta. 
				//Since preload does not send property updates to preload, so commenting below method for now.
				//instantRefresh(app);
			
				LogData.getInstance().traceDebug(LogData.INFO, debugStr + " Received Delta for swf: " + 
					app.name + ", GenieID: " + genieID + ". Updating...");
			}
		}
		
	}

}
