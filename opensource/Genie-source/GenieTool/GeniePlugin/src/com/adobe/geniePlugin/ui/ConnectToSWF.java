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

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;

import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;
import com.adobe.geniePlugin.comunication.StaticFlags;
import com.adobe.geniePlugin.ui.SWFAppUI;

public class ConnectToSWF extends Job 
{
	private String swfName = "";
	private boolean forceConnection = false;
	public ConnectToSWF(String swf, String msg)
	{
		super(msg);
		swfName = swf;
	}
	
	public ConnectToSWF(String swf, String msg, boolean forceConnection)
	{
		super(msg);
		swfName = swf;
		this.forceConnection = forceConnection;
	}
	
	@Override 
    protected IStatus run(IProgressMonitor monitor)
	{
		monitor.beginTask("Requesting swf to connect", 100);
		
		//Do processing
		StaticFlags sf = StaticFlags.getInstance();
		if (sf.isPerformanceEnabled())
		{
			sf.writePerfLogs(Utils.CONNECT_TO_SWF, this.swfName, true);
		}
		
		monitor.worked(20);
		SWFList<SWFAppUI> list = SWFList.getInstance();
		SWFAppUI app = (SWFAppUI) list.getSWF(swfName);
		
		//Logging app status
		LogData log = LogData.getInstance();
		log.trace(LogData.INFO, "App Status: " + app.toString());
		
		monitor.worked(30);
		
		String returnString = "";
		if(!app.isVisibleOnUI || forceConnection)
		{
			log.trace(LogData.INFO, "Requesting connect to swf: " + app.name);
			monitor.worked(10);
			
			//Setting timeout to 50Sec, default was 15 sec
			SynchronizedSocket.getInstance().setTimeout(90);
			
			app.resetFlags();
			
			//Now, Send Connection Request tp swf
			returnString = app.connect();
			
			//Resetting timeout to 15Sec
			SynchronizedSocket.getInstance().resetTimeout();
			
			if (monitor.isCanceled())
				app.isCancelled = true;
			else
				app.isCancelled = false;
			
			if (returnString.equalsIgnoreCase("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE"))
			{
				monitor.worked(50);
				app.isTimeout = true;				
			}
			else
			{
				app.isTimeout = false;
			}
		}
		else
		{
			log.trace(LogData.INFO, "Swf already connected. Bringing app to focus");
			app.setFocus();
		}
		
		/**
		 * Tracking performance
		 */
		if (sf.isPerformanceEnabled())
		{
			sf.writePerfLogs(Utils.CONNECT_TO_SWF, this.swfName, false);
		}
		
		
		if (app.isTimeout && !app.isAppReplied)
		{
			if (!app.isVisibleOnUI)
				sf.addErrorTab(app);
			else
				app.isTimeout = false;			
		}
		else
		{
			//monitor.done();
		}
		
		return Status.OK_STATUS;
		
	}
}
