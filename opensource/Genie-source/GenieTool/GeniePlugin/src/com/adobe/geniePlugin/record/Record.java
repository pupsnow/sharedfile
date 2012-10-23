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

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import org.eclipse.core.runtime.Platform;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.internal.util.BundleUtility;
import org.osgi.framework.Bundle;

import com.adobe.geniePlugin.ui.ConnectToSWF;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.ui.UICommonFunctions;
import com.adobe.geniePlugin.views.GenieView;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;

public class Record {

	private static Record instance = null;
	private long stepTimerStart;
	private long stepTimerCount ;
	private boolean isRecording= false;
	public boolean isRecordAtAppPace = false;
	int importIndex;
	String sep = System.getProperty("line.separator");
	
	StringBuffer tempFileScript;
	StringBuffer oldScript;
	private boolean hasLastRecordedScript = false;
	
	//Use to find index to put recorded code
	String mainLine = "public void start() throws Exception {";
	String endUserScriptStr = null;
	
	//File tempFile;
	private HashMap<String, String> appInstanceList;
	private int varNumber = 1;
	
	//public ArrayList<String> customMapDataXML = new ArrayList<String>();
	private Record()
	{
		appInstanceList = new HashMap<String, String>();
		
		this.tempFileScript = new StringBuffer();		
	}
	
	public static Record getInstance()
	{
		if(instance == null)
			instance = new Record();
		
		return instance;
	}
	protected void finalize() throws Throwable
	{
		super.finalize();		
	}
	
	public boolean HasLastRecordedScript()
	{
		return hasLastRecordedScript;
	}
	private void clearBuffer()
	{
		this.tempFileScript.replace(0, this.tempFileScript.length(), "");
	}
	private void startRecordingHook()
	{
		try{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					GenieView.getInstance().enableFindGlowAction(false);
					GenieView.getInstance().showCoordinatesAction.setChecked(false);
					GenieView.getInstance().showCoordinatesAction.run();
					GenieView.getInstance().getGeniePropertiesAction.setChecked(false);
					GenieView.getInstance().getGeniePropertiesAction.run();
					GenieView.getInstance().getComponentImageAction.setChecked(false);
					GenieView.getInstance().getComponentImageAction.run();
				 }
			});
		}
		catch(Exception e){}
	}
	private void stopRecordingHook()
	{
		try{
			GenieView view1 = GenieView.getInstance();
			view1.getLastRecordedScript.setEnabled(true);
			view1.enableFindGlowAction(true);
		}
		catch(Exception e){}
	}
	public void beginRecording(String appName)
	{
		startRecordingHook();
		
		String debugStr = "Record::beginRecording";
		LogData.getInstance().trace(LogData.INFO, debugStr + " for app: " + appName);
		
		hasLastRecordedScript = true;
		
		try{
			
			if(!isRecording)
			{
				varNumber = 1;
				isRecording = true;
			
				Bundle bundle = Platform.getBundle("GeniePlugin");
				URL fullPathString = BundleUtility.find(bundle, "resources/TestScript.java");
				
				String text = Utils.getTextFromURL(fullPathString);
		        
				this.tempFileScript.append(text);
				
				int idx = this.tempFileScript.indexOf("}", this.tempFileScript.indexOf(this.mainLine));
				endUserScriptStr = new String(this.tempFileScript.substring(idx));
				this.tempFileScript.delete(idx, this.tempFileScript.length());				
			}
			
			String varName = "app" + varNumber++;

			if(varNumber > 2)
			{
				stepTimerCount = System.currentTimeMillis() - stepTimerStart;
				int roundOffStepTimerInSec = Math.round((float)stepTimerCount/1000);
				if(isRecordAtAppPace == true)
				{
					addCommandToScript("wait("+roundOffStepTimerInSec+");");
				}
			}
			
			stepTimerStart = System.currentTimeMillis();
			addCommandToScript("SWFApp " + varName + "=" +  "connectToApp(\"" + appName + "\");");
			appInstanceList.put(appName, varName);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void appendCustomMapData(ArrayList<String> customMapDataXML )
	{
		MapActions.getInstance().crawlForUserSuppliedMapdataXML(customMapDataXML);
	}
	private void addCommandToScript(String line)
	{
		try{
			//Add connectToApp method		connectToApp("job_ticket");
			String sep = System.getProperty("line.separator");
			String codeLine = sep + "\t\t" + line;
			
			this.tempFileScript.append(codeLine);
			
		}catch(Exception e)
		{
			
		}
	}
	public void stopRecording(String from)
	{
		if (!isRecording)
			return;
		
		String debugStr = "Record::stopRecording";
		LogData.getInstance().trace(LogData.INFO, debugStr + " for app: " + from);
		
		appInstanceList.remove(from);
		if(appInstanceList.size() == 0 && isRecording())
		{
			try {
				this.tempFileScript.append(sep + "\t}"+ sep + "}");
				this.oldScript = new StringBuffer(this.tempFileScript);
				this.clearBuffer();
			}
			catch (Exception e){}
			
			isRecording = false;
			
			showRecordedScript();
		}
		
		stopRecordingHook();
		
		SWFList<SWFAppUI> list = SWFList.getInstance();
		final SWFAppUI app = (SWFAppUI) list.getSWF(from);
		
		if(app != null)
		{
			Thread f = new Thread()
			{
				public void run()
				{
					app.connect();
				}
			};
			f.start();
		}
	}
	
	public void showRecordedScript()
	{
		UICommonFunctions uiThread = UICommonFunctions.getScriptEditorInstance(this.oldScript);
		uiThread.start();
	}
	
	public boolean isRecording()
	{
		return isRecording;
	}
	public void record(String appName, String data)
	{
		data = "<Data>" + data + "</Data>"; 
		
		stepTimerCount = System.currentTimeMillis() - stepTimerStart;
		stepTimerStart = System.currentTimeMillis();
		
		if(isRecordAtAppPace == true)
		{
			String javaWaitCode = getWaitCode(appInstanceList.get(appName),data,stepTimerCount);
			if(javaWaitCode.length()>0)
			{
				javaWaitCode = sep +"\t\t" + javaWaitCode ;
				this.tempFileScript.append(javaWaitCode);			
			}
		}
		
		String javaLine = getcode(appInstanceList.get(appName), data);
		if(javaLine.length()>0)
		{
			javaLine = sep +"\t\t" + javaLine ;
			
			this.tempFileScript.append(javaLine);			
		}
	}
		
	private String getWaitCode(String appName, String data , long stepTimerCount)
	{
		String waitCode = "";
		PreloadData preloadData = new PreloadData(data);
		String genieID= preloadData.getGenieId();
		int roundOffStepTimerInSec = Math.round((float)stepTimerCount/1000);
		if(roundOffStepTimerInSec >= 1)
		waitCode = "(new GenieComponent(" + encloseInQuotes(genieID) + "," + appName + ")).waitFor(" + roundOffStepTimerInSec + ");";
		return waitCode;
	}
	
	private String getcode(String appName, String data)
	{
		//Parse data xml
		PreloadData preloadData = new PreloadData(data);
		String genieID= preloadData.getGenieId();
		String eventName = preloadData.getEventName();
		String objectType = preloadData.getObjectType();
		
		
		MapActions map = MapActions.getInstance();
		
		PlaybackInfo info = map.getJavaComponentInfo(objectType, eventName, preloadData);
		String javaClass = info.javaClassName;
		String javaMethod = info.javaMethodName;
		
		String args = info.args;
		String code = "";
		try
		{
			if(javaClass.length()>0)
				javaClass = javaClass.substring((javaClass.lastIndexOf(".")+1));
			
		//	(new GenieButton("Button1", "job_ticket")).click();
			if(objectType.equalsIgnoreCase("ui.controls.Generic"))
			{
				code = "(new " + javaClass + "(" + appName + "))." + javaMethod +"(" + args + ");";
			}else
			if( (javaClass.length() > 0) && (genieID.length() > 0) && (javaMethod.length() > 0))
				
				code = "(new " + javaClass + "(" + encloseInQuotes(genieID) + "," + appName + "))." + javaMethod +"(" + args + ");";
			else
				code = "";
		}
		catch(Exception e)
		{
			//no such method exists or param validation failed
		}
		return code;
	}
	
	private String encloseInQuotes(String input)
	{
		return "\"" + input + "\"";
	}
}
