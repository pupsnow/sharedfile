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

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.swt.widgets.Display;

import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.utils.Utils;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.views.GenieView;
import com.genie.data.TreeTab;

public class StaticFlags {

	private static StaticFlags staticFlags = null;
	private boolean performanceTracking = false;
	private long startTimeInMilliSec = 0;
	private long endTimeInMilliSec = 0;
	private String startTimeInStr = "";
	private String endTimeInStr = "";
	private Map<String, TreeTab> timedOutSwfsTrees = null;
	private boolean isGenieViewCloseButtonPressed = false;
	
	
	private StaticFlags()
	{		
	}
	
	public static StaticFlags getInstance()
	{
		if (staticFlags == null)
			staticFlags = new StaticFlags();
		return staticFlags;
	}
	
	public void setPerformanceTracking(boolean flag)
	{
		this.performanceTracking = flag;
	}
	
	public boolean isPerformanceEnabled()
	{
		return this.performanceTracking;
	}
	
	public String getCurrentDateTimeString() {
	    Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
	    return sdf.format(cal.getTime());
	}
	
	public String timeDiff()
	{
		if ((this.startTimeInMilliSec == 0) || (this.endTimeInMilliSec == 0) ||
				(this.startTimeInMilliSec > this.endTimeInMilliSec))
		{
			return "";
		}
		
		long diff = this.endTimeInMilliSec - this.startTimeInMilliSec;
	    
	    long diffSeconds = diff / 1000;
	    
	    long diffHours = diffSeconds / (60 * 60);
	    diffSeconds = diffSeconds - (diffHours * 60 * 60);
	    
	    long diffMinutes = diffSeconds / 60;
	    diffSeconds = diffSeconds - (diffMinutes * 60);
	    
	    long diffMS = diff - (diffSeconds * 1000);
	    
	    String timeStr = diffHours + "H:" + diffMinutes + "M:" + diffSeconds + "s:" + diffMS + "ms";
	    return timeStr;
	}
	
	public void setStartTime()
	{
		this.startTimeInStr = this.getCurrentDateTimeString();
	}
	public void setEndTime()
	{
		this.endTimeInStr = this.getCurrentDateTimeString();
	}
	/**
	 * Write performance logs
	 * Prepare xml string based on featureName
	 * isStart=true, then the log for start operation is written
	 * time: In formatted string
	 */
	public void writePerfLogs(String featureName, String name, boolean isStart)
	{
		String xmlStr = "<PerfData>";
		xmlStr += "<" + Utils.FEATURE_NAME + ">" + featureName + "</" + Utils.FEATURE_NAME + ">";
		xmlStr += "<" + Utils.APP_NAME + ">" + name + "</" + Utils.APP_NAME + ">";
		if (isStart)
		{
			this.setStartTime();
			this.startTimeInMilliSec = System.currentTimeMillis();
			xmlStr += "<" + Utils.START_TIME + ">" + this.startTimeInStr + "</" + Utils.START_TIME + ">";
		}
		else
		{
			this.setEndTime();
			this.endTimeInMilliSec = System.currentTimeMillis();
			
			xmlStr += "<" + Utils.START_TIME + ">" + this.startTimeInStr + "</" + Utils.START_TIME + ">";
			xmlStr += "<" + Utils.END_TIME + ">" + this.endTimeInStr + "</" + Utils.END_TIME + ">";
			
			String tDiff = this.timeDiff();
			if (!tDiff.equalsIgnoreCase(""))
			{
				xmlStr += "<" + Utils.TOTAL_TIME + ">" + tDiff + "</" + Utils.TOTAL_TIME + ">";
			}
		}
		xmlStr += "</PerfData>";
		
		if (!isStart)
		{
			SocketClient sc = SocketClient.getInstance();
			sc.writePerformanceData(xmlStr);
		}
	}
	
	public void pushSwfForTimeoutRecord(String swfName, TreeTab tab)
	{
		if (this.timedOutSwfsTrees == null)
			this.timedOutSwfsTrees = new HashMap<String, TreeTab>();
		
		this.timedOutSwfsTrees.put(swfName, tab);
	}
	public void popSwfFromTimeoutRecord(String swfname)
	{
		if (this.timedOutSwfsTrees == null)
			return;
		
		this.timedOutSwfsTrees.remove(swfname);
	}
	public void addErrorTab(final SWFAppUI app)
	{
		if (this.timedOutSwfsTrees == null)
			this.timedOutSwfsTrees = new HashMap<String, TreeTab>();
		
		if (!this.timedOutSwfsTrees.containsKey(app.name))
		{
			final TreeTab  treeTab = new TreeTab();
			final GenieView view1 = GenieView.getInstanceAndShowView();
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {				 
					 app.uiRep = treeTab.createErrorTab(view1.tabFolder,app);
					 timedOutSwfsTrees.put(app.name, app.uiRep);
				 }
			});
		}
	}
	public void removeErrorTabIfPresent(String swfName)
	{
		if (this.timedOutSwfsTrees == null)
			return;
		
		final TreeTab tab = this.timedOutSwfsTrees.get(swfName);
		this.timedOutSwfsTrees.remove(swfName);
		if (tab != null)
		{
			tab.removeTab();
		}
	}
	
	public boolean isGenieViewClosedBtnPressed()
	{
		return isGenieViewCloseButtonPressed;
	}
	public void setGenieViewCloseBtnPressed(boolean flag)
	{
		isGenieViewCloseButtonPressed = flag;
	}
	
	protected void finalize() throws Throwable
	{
		super.finalize();
		
		if (timedOutSwfsTrees != null)
			timedOutSwfsTrees.clear();
	}	
}
