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

import java.io.File;
import java.util.ArrayList;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.eclipse.jface.action.IContributionItem;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Display;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.log.LogData;
import com.adobe.geniePlugin.VersionHandler;
import com.adobe.geniePlugin.record.Record;
import com.adobe.geniePlugin.ui.AddCommandsToMenu;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.views.GenieView;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;
/**
 * This class contains methods which are called when data from socket server is received.
 * <p>
 *  Owner: Suman Mehta
 *  $Author: suman $
 * 
 */


public class ServerHandler {

	public final static String SWF_LIST_RECEIVED = "swfListReceived";
	
	
	private void showErrorPopup(String msg)
	{
		AddCommandsToMenu.pluginRejectedDueToVersionIncompat = true;
		VersionHandler vH = VersionHandler.getInstance();
		if (vH.isRefusedByPlugin())
		{
			AddCommandsToMenu.msg = "Server Incompatible! Please Update";
		}
		else if (vH.isRefusedByServer())
		{
			AddCommandsToMenu.msg = "Plugin Incompatible! Please Update";
		}
		
		final String m = msg + "\n\nYou need to restart plugin after updating";
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				   MessageDialog.openError(
						null,
						"Version Incompatible",
						m);
			 }
		});
	}
	
	public void versionIncompatible(String from, String data)
	{
		String debugStr = "ServerHandler::versionIncompatible";
		String str1 = "<PluginMinVersion>";
		String str2 = "</PluginMinVersion>";
		String plMinVer = new String();
		int idx1 = data.indexOf(str1);
		if (idx1 != -1)
		{
			idx1 += str1.length();
			int idx2 = data.indexOf(str2);
			
			plMinVer = data.substring(idx1, idx2);
			this.setServerVersion("", data);
			
			String errMsg = "Genie Plugin not compatible! Min Plugin Version required: " + plMinVer;
			LogData.getInstance().trace(LogData.ERROR, debugStr + " " + errMsg);
			
			this.showErrorPopup(errMsg);
			
			this.disableGenieActions();
		}
	}
	
	public void gotGenieObjectProperties(String from, String data)
	{
		//Lets hand it over to GenieView
		GenieView.getInstance().refreshGenieObjectProperties(data);
	}
	
	/**
	 * In case Eclipse Plugin launches from different workspace. Disallow that one to connect
	 * Server triggers this action
	 */
	public void stopSecondPlugin(String from, String data)
	{
		String debugStr = "ServerHandler::stopSecondPlugin";
		
		AddCommandsToMenu.secondPluginRunning = true;
		AddCommandsToMenu.msg = "Error: Another plugin is running";
		
		final String errMsg = "Another plugin is running! Only one instance is allowed!";
		LogData.getInstance().trace(LogData.ERROR, debugStr + " " + errMsg);
		
		VersionHandler vH = VersionHandler.getInstance();
		vH.setRefusedConenctionByMiscReasons(errMsg);
		
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				   MessageDialog.openError(
						null,
						"Another plugin is running",
						errMsg);
			 }
		});
			
		this.disableGenieActions();		
	}
	
	public void setServerVersion(String from, String data)
	{
		String debugStr = "ServerHandler::setServerVersion";
		VersionHandler vH = VersionHandler.getInstance();
		if (!vH.isReplyCompatible(data))
		{
			LogData.getInstance().trace(LogData.ERROR, debugStr + " " + vH.getErrorMessage());
			this.showErrorPopup(vH.getErrorMessage());
			this.disableGenieActions();			
		}
		
		//Track Performance
		SocketClient sc = SocketClient.getInstance();
		sc.isPerformanceTrackingEnabled();
	}
	
	private void disableGenieActions()
	{
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				 	
				 try {
				 	    GenieView view1 = GenieView.getInstance();
					    
					    IContributionItem[] items =  view1.getViewSite().getActionBars().getToolBarManager().getItems();
						for (int i=0; i< items.length; i++)
						{
							items[i].dispose();
						}
						
						SynchronizedSocket sc = SynchronizedSocket.getInstance();
						sc.close();
					    
					    SWFList<SWFAppUI> list = SWFList.getInstance();
					    list.clear();
					    
					} catch (Exception e) {
						e.printStackTrace();
					}
			 }
		});
	}
	
	public String getPluginVersion()
	{
		VersionHandler vH = VersionHandler.getInstance();
		return vH.getPluginVersion();
	}
	
	public void tracePerformance(String from, String data)
	{
		StaticFlags sFlags = StaticFlags.getInstance();
		boolean isPerf = Utils.getTagValue(data, "PerformanceTracking").equalsIgnoreCase("true") ? true : false;
		sFlags.setPerformanceTracking(isPerf);
	}
	
	public String swfListReceived(String from, String data)
	{
		SWFList<SWFAppUI> list = createSWFAppListFromXML(data);
		
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
			 	//Lets remove all orphan tabs
			 	
			 	try {
			 		GenieView view1 = GenieView.getInstance();
			 		view1.removeOrphanTabs();
			 		 		
				} catch (Exception e){
					e.printStackTrace();
				}
			 }
		});
		
		return "";
	}
	
	public SWFList<SWFAppUI> createSWFAppListFromXML(String swfListStr)
	{
		Document doc = null;
		SWFList<SWFAppUI> list = SWFList.getInstance();
		
		if(swfListStr!=null && swfListStr.length()!=0)
		{
			try
			{
				DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = dbf.newDocumentBuilder();
				doc = db.parse(Utils.parseStringToIS(swfListStr));
				
				NodeList clientNodes = doc.getElementsByTagName("Client");
				ArrayList<String> appNameList = new ArrayList<String>();
								
				for (int i =0 ; i<clientNodes.getLength(); ++i)
				{
					SWFAppUI app = new SWFAppUI();
					app.name = ((Element) clientNodes.item(i)).getElementsByTagName("Name").item(0).getChildNodes().item(0).getTextContent();
					appNameList.add(app.name);
					//Add new SWFAppUI instance only if did not exist earlier
					if(list.getSWF(app.name) == null )
					{
						list.add(app);
						app.genieVersion = ((Element) clientNodes.item(i)).getElementsByTagName("GenieVersion").item(0).getChildNodes().item(0).getTextContent();
						app.asVersion = ((Element) clientNodes.item(i)).getElementsByTagName("ActionScriptVersion").item(0).getChildNodes().item(0).getTextContent();
						app.playerVersion = ((Element) clientNodes.item(i)).getElementsByTagName("PlayerVersion").item(0).getChildNodes().item(0).getTextContent();
						app.playerType = ((Element) clientNodes.item(i)).getElementsByTagName("PlayerType").item(0).getChildNodes().item(0).getTextContent();
						app.realName = ((Element) clientNodes.item(i)).getElementsByTagName("RealName").item(0).getChildNodes().item(0).getTextContent();
						
						app.isVisibleOnUI = false;
					
					}
				}
				//Remove extra swfs from list
				for(int i =0; i <list.size(); ++i)
				{
					if(!appNameList.contains(list.get(i).name))
					{
						try{
							SWFAppUI app1 = list.get(i);
							app1.disconnect();
						}catch(Exception e){ 
							LogData.getInstance().traceDebug(LogData.ERROR, "Exception while calling app.disconnect. " + e.getMessage());
						}
						
						list.remove(i);
					}
				}
			}
			catch(Exception e){
				Utils.printErrorOnConsole(e.getMessage());
				
			}
		}
		return list;
	}
	
	public String clientDisconnected(final String from, String data)
	{
		String debugStr = "ServerHandler::clientDisconnected";
		LogData.getInstance().trace(LogData.INFO, debugStr + " Stop recording, if running");
		
		//Send stop recording event from swf app which is disconnected. 
		//This is to make sure that disconnected app doesn't have any recording session.
		Record rec = Record.getInstance();
		rec.stopRecording(from);
		
		return "";
	}
	
	public String traceDebug(String from, String data)
	{
		LogData.DEBUG = true;
		LogData log = LogData.getInstance(System.getProperty("user.home")+File.separator+"GenieLogs/PluginLog.txt");
		log.traceDebug(LogData.INFO, "Debug tarce started");
		
		return "";
	}
	public String traceDebug(String data)
	{
		LogData.DEBUG = true;
		LogData log = LogData.getInstance(System.getProperty("user.home")+File.separator+"GenieLogs/PluginLog.txt");
		log.traceDebug(LogData.INFO, data);
		
		return "";
	}
	
	public void SelectElement(final String from, final String data)
	{
		Utils.printMessageOnConsole(data);
		
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				 	SWFList<SWFAppUI> list = SWFList.getInstance();
					SWFAppUI app = (SWFAppUI) list.getSWF(from);
					app.uiRep.selectTreeNode(data);
			 }
			});
	}
	/**
	 * Notification received by Server
	 */
	public void clientIsRunning(String from, String data)
	{
		String clientName = Utils.getTagValue(data, "ClientName");
		if (clientName.equals(Utils.EXECUTOR_NAME_STR))
		{
			GenieView.getInstance().hookPlaybackStart();
		}
	}
	/**
	 * Notification received by Server
	 */
	public void clientIsStopped(String from, String dataArg)
	{
		String clientName = Utils.getTagValue(dataArg, "ClientName");
		if (clientName.equals(Utils.EXECUTOR_NAME_STR))
		{
			GenieView.getInstance().hookPlaybackStop();
			
			String data = Utils.getTagValue(dataArg, "AnyData");
			
			GenieView.getInstance().refreshAppXmlIfConnected(data);
		}
	}
	
	public synchronized void appXML(final String from, final String data)
	{
		ParseAppXML app = new ParseAppXML(from, data, "appXML");
		Display.getDefault().asyncExec(app);
	}
	
	public synchronized void removeObject(final String from, final String data)
	{
		RemoveObjectFromXML rm = new RemoveObjectFromXML(from, data, "removeObject");
		Display.getDefault().asyncExec(rm);
	}
	
	public synchronized void DeltaXML(final String from, final String data)
	{
		ParseAppXML app = new ParseAppXML(from, data, "deltaXML");
		Display.getDefault().asyncExec(app);
	}
	
	private void clearTabs()
	{
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				
				 	try {
				 		GenieView view1 = GenieView.getInstanceAndShowView();
				 		view1.removeAllTabs();
					    					    
					    SWFList<SWFAppUI> list = SWFList.getInstance();
					    list.clear();
					    
					    view1.resetActionsState();
					} catch (Exception e) {
						e.printStackTrace();
					}
			 }
		});
	}
	
	public void ServerClosed(final String from, final String data)
	{
		String debugStr = "ServerHandler::ServerClosed";
		LogData.getInstance().trace(LogData.INFO, debugStr);
		
		//Disabling Genie Actions, and clearing swf list
		clearTabs();
		
		if (!VersionHandler.getInstance().isRefusedConnection())
		{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					   MessageDialog.openError(
							null,
							"Server disconnected",
							"Server disconnected. Genie is trying to reconnect to server. Please check if server is running");
				 }
			});
		}
	}
//	public void PropertyXML(final String from, final String data)
//	{
//		Utils.printMessageOnConsole(data);
//		SWFList<SWFAppUI> list = SWFList.getInstance();
//		SWFAppUI app = list.getSWF(from);
//		Element rootXML= app.genieData.getXml();
//		//Update XML for property change
//	}
	
	public String startRecording(String from, String data)
	{
		String debugStr = "ServerHandler::startRecording";
		LogData.getInstance().trace(LogData.INFO, debugStr + " for app: " + from);
		
		Record rec = Record.getInstance();
		rec.beginRecording(from);
		return "";
	}
	
	public String endRecording(String from, String data)
	{
		String debugStr = "ServerHandler::endRecording";
		LogData.getInstance().trace(LogData.INFO, debugStr + " for app: " + from);
		
		Record rec = Record.getInstance();
		rec.stopRecording(from);
		return "";
	}
	
	public String errorRecording(String from, String data)
	{
		
		return "";
	}
	
	public void record(String from, String data)
	{
		String debugStr = "ServerHandler::record";
		LogData.getInstance().traceDebug(LogData.INFO, debugStr + " Recording for Swf: " + from);
		
		Record rec = Record.getInstance();
		if(rec.isRecording())
		{
			rec.record(from, data);
		}
	}
	
	public void customComponentInfo(String from, String data)
	{
		try{
			XmlDoc xmlDoc = new XmlDoc(data);
			ArrayList<XmlNode> nodes = xmlDoc.getNodes("/String/Path");
			
			Record rec = Record.getInstance();
			ArrayList<String> customMapDataXML  = new ArrayList<String>();
			for(int i=0; i<nodes.size(); ++i)
			{
				customMapDataXML.add(nodes.get(i).getValue());
			}
			rec.appendCustomMapData(customMapDataXML);
			
		}catch (Exception e) {
			
		}
		
	}
	
	
	
}
