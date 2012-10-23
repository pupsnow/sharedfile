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

import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.geniePlugin.model.GenieObject;
import com.genie.data.TreeTab;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.utils.Utils;

public class SWFAppUI extends SWFApp{

	
	public TreeTab uiRep;
	public GenieObject genieData;
	public boolean isVisibleOnUI = false;
	
	//When App's xml came
	public boolean isAppReplied = false;
	
	//While connecting, user clicked on cancel connect
	public boolean isCancelled = false;
	
	//While connecting, timeout happens
	public boolean isTimeout = false;
	
	public Hashtable<String, GenieObject> objectMap;
	
	public SWFAppUI()
	{
		super();
		objectMap = new Hashtable<String, GenieObject>();
		genieData = new GenieObject();
	}

	public void clearObjectMap()
	{
		if (this.objectMap != null)
			this.objectMap.clear();
	}
	public SWFAppUI(SWFApp app)
	{
		super();
		//Copy data
		genieVersion = app.genieVersion;
		name = app.name;
		playerType = app.playerType;
		playerVersion = app.playerVersion;
		asVersion = app.asVersion;
		preloadName=app.preloadName;
		preloadSdkVersion=app.preloadSdkVersion;
		
		objectMap = new Hashtable<String, GenieObject>();
		genieData = new GenieObject();
	}
	
	public String toString()
	{
		StringBuffer res = new StringBuffer();
		res.append("isVisibleOnUI: " + this.isVisibleOnUI);
		res.append(", isAppReplied: " + this.isAppReplied);
		res.append(", isCancelled: " + this.isCancelled);
		res.append(", isTimeout: " + this.isTimeout);
		
		return res.toString();
	}

	public String connect()
	{
		return super.connect();
	}
	
	public void glowComponentInSwf()
	{
		GenieObject selectedObject = uiRep.getSelectedTreeItem();
		SocketClient sc = SocketClient.getInstance();
		if(selectedObject != null)
		{
			sc.glow(name, selectedObject.getGenieId(), "");
		}
	}
	public void removeGlowOnSwf()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.unGlow(name, "");
	}
	public void enableFindComponent()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.enableFindComponent(name, "SelectTreeNode");
	}
	
	public void disableFindComponent()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.disableFindComponent(name, "");
	}
	
	public void enableShowCoordinates()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.enableShowCoordinates(name, "");
	}
	
	public void disableShowCoordinates()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.disableShowCoordinates(name, "");
	}
	
	public void enableRecordingUIFunctions()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.enableRecordingUIFunctions(name, "");
	}
	
	public void disableRecordingUIFunctions()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.disableRecordingUIFunctions(name, "");
	}
	
	public void showGenieIcon()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.showGenieIcon(name, "");
	}
	
	public void hideGenieIcon()
	{
		SocketClient sc = SocketClient.getInstance();
		sc.hideGenieIcon(name, "");
	}
	
	/**
	 * Synchronized way of getting properties.
	 * @param genieID
	 * @return
	 */
	public Map<String, String> getAllGenieProperties(String genieID)
	{
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		String xml = sc.getGenieProperties(name, genieID);
		
		//Utils.printMessageOnConsole(Utils.getAttributeValueFromXML(xml, "accessor", "property", "value").toString());
		
		Map<String, String> properties = Utils.getAttributeValueFromXML(xml, "accessor", "property", "value");
		return properties;		
	}
	
	public void requestAllGenieProperties(String genieID, String callbackMethod)
	{
		SocketClient sc = SocketClient.getInstance();
		
		String data = "<String>" + genieID + "</String>";
		sc.sendCommand(this.name, "getGenieProperties", callbackMethod, data);
	}
	
	public void refreshAppTree()
	{
		if (uiRep != null)
			uiRep.refreshAppTree();
	}
	
	public void setFocus()
	{
		if (uiRep != null)
			uiRep.setFocus();
	}
	
	public void disconnect()
	{
		super.disconnect();
		objectMap.clear();
		//Remove tab from plugin view
		
		if (!isTimeout)
		{
			if(uiRep != null)
				uiRep.removeTab();
		}
		if (genieData != null)
		{
			genieData.freeVars();
			genieData = null;
		}
		isVisibleOnUI = false;
		uiRep = null;		
	}
	

	public GenieObject addGenieObjectFromXML(Element xmlElement, GenieObject parent)
	{
		GenieObject object = new GenieObject();
		object = getInitalInput(xmlElement, parent);
		uiRep.treeViewer.refresh(parent);
		return object;
	}
	
	public void removeGenieObjectFromXML(String genieID)
	{
		if( objectMap.get(genieID) != null)
		{
			GenieObject objTobeRemoved = objectMap.get(genieID);
			GenieObject parentObject = objTobeRemoved.getParent();
			parentObject.remove(objTobeRemoved);
			//recursively remove from object 
			//objectMap.remove(genieID);
			removeAllObjectsFromObjectmMap(genieID);
		}
	}
	
	private void removeAllObjectsFromObjectmMap(String genieID)
	{
		GenieObject parentObject = objectMap.get(genieID);
		if (parentObject != null)
		{
			List<GenieObject> childrenList = parentObject.getChildren();
			if (childrenList != null)
			{
				for(int i = 0 ; i<childrenList.size()  ; ++i)
				{
					GenieObject childObj = childrenList.get(i);
					if (childObj != null)
						removeAllObjectsFromObjectmMap(childObj.getGenieId());
				}
			}
		}
		objectMap.remove(genieID);
	}
	private GenieObject getInitalInput(Element xmldata, GenieObject parent) {
		
		Document doc = null;
		try
		{
			doc = xmldata.getOwnerDocument();
		}
		catch(Exception e){}
		
		TreeTab.processHierarchy(xmldata, parent, objectMap);
		
		//processHierarchy(xmldata, parent);
					
		return parent;
	}
	
	public void resetFlags()
	{
		isCancelled = false;
		isAppReplied = false;
		isTimeout = false;
	}
	
	protected void finalize() throws Throwable
	{
		super.finalize();

		if (objectMap != null)
			objectMap.clear();
		uiRep = null;
		genieData = null;
	}
}
