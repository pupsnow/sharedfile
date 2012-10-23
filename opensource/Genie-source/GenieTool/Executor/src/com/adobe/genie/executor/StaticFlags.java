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

package com.adobe.genie.executor;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.exceptions.DelegateException;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.internalLog.ScriptLog;


public class StaticFlags {
		private static StaticFlags staticFlags = null;
		private boolean performanceTracking = false;
		private boolean debugMode = false;
		private long startTimeInMilliSec = 0;
		private long endTimeInMilliSec = 0;
		private String startTimeInStr = "";
		private String endTimeInStr = "";
		
		private List<String> customClassNames = null;
		
		//gestures
		
		private String gestureName = null;
		private boolean gestureStarted = false;
		private ArrayList<String> gestureEventDataArray = new ArrayList<String>();
		private String gestureAppName = null;
		
		// Hashtable that holds mapping for old and new genie ids.
		// It comes in action when ,preload executes an action on a component by shortening or increasing the genie id. 
		private Hashtable<String, String> genieMapTable= new Hashtable<String, String>();
		
		//List for holding swf names, which are closed during playback
		private ArrayList<String> closedSwfListDuringPlayback = null;
		
		private StaticFlags()
		{		
		}
		
		public synchronized static StaticFlags getInstance()
		{
			if (staticFlags == null)
				staticFlags = new StaticFlags();
			return staticFlags;
		}
		
		public void addCustomClass(String className)
		{
			if (this.customClassNames == null)
				this.customClassNames = new ArrayList<String>();
			this.customClassNames.add(className);
		}
		public List<String> getCustomClasses()
		{
			return this.customClassNames;
		}
		public void loadCustomDelegateClasses()
		{
			if (this.customClassNames == null)
				return;
			
			try{
				for (String classname : this.customClassNames)
				{
					this.loadDelegateClass(classname);
				}
			}catch(Exception e){}
		}
		
		private void loadDelegateClass(String classPath) throws DelegateException
		{
			try{
				File dc = new File(classPath);
				if (!dc.exists())
				{
					//May be a relative path, try it with current path
					dc = new File((new File(".")).getCanonicalPath() + File.separator + classPath);
					if (!dc.exists())
					{
						Utils.printErrorOnConsole("The delegateClass provided doesn't exist!");
						return;
					}
				}
				
				if(Shared.getClassFromFile(new File(classPath), "") == null)
				      Utils.printErrorOnConsole("Class could not be loaded - " + classPath);
				  else
					  Utils.printMessageOnConsole("Class is loaded successfully. - " + classPath );
			}
			catch(RuntimeException e)
			{
				Utils.printErrorOnConsole("Runtime Exception occured in CommandHandler.loadDelegateClass"+e.getMessage());
				throw new DelegateException("Error while loading delegateClass! Aborting...");
			}
			catch(Exception e)
			{
				throw new DelegateException("Error while loading delegateClass! Aborting...");
			}
		}
		
		public void setPerformanceTracking(boolean flag)
		{
			this.performanceTracking = flag;
		}
		
		public boolean isPerformanceEnabled()
		{
			return this.performanceTracking;
		}
		
		public void setDebugMode(boolean flag)
		{
			this.debugMode = flag;
		}
		
		public boolean isdebugMode()
		{
			return this.debugMode;
		}
		
		/**
		 * Prints message on error console if the debug flag is set
		 */
		public void printErrorOnConsoleDebugMode(String msg){
		    if(debugMode)
		    	Utils.printErrorOnConsole(msg);
		}
		
		/**
		 * Query Server for swf online or not 
		 */
		public boolean isSwfOnline(String swfName)
		{
			SynchronizedSocket synchSocket = SynchronizedSocket.getInstance();
			SWFList<SWFApp> list = synchSocket.getSWFList();
			SWFApp app = list.getSWF(swfName);
			
			if (app != null)
				return true;
			return false;
		}
		
		/**
		 * Connect to swf
		 * @param swfName
		 * @return true if success
		 */
		public boolean conenctToSwf(String swfName)
		{
			SynchronizedSocket synchSocket = SynchronizedSocket.getInstance();
			SWFList<SWFApp> list = synchSocket.getSWFList();
			SWFApp app = list.getSWF(swfName);
			
			boolean res = false;
			if (app != null)
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("ConnectToSWF: " + swfName, GenieStepType.STEP_CONNECTION_TYPE, "Application: "+swfName);
				scriptLog.addTestApplication(swfName, "", "", "");
				
				String op  = app.connect();
				if((op.equalsIgnoreCase("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")) || (op.length() == 0))
				{
					Utils.printErrorOnConsole("Could not connect to SWF " + swfName);
					scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
					scriptLog.addTestStepMessage("Could not connect to SWF " + swfName , GenieMessageType.MESSAGE_ERROR);
					scriptLog.addTestStepMessage("No Further action can be performed on this application" , GenieMessageType.MESSAGE_ERROR);
					
					res = false;
				}
				else
				{
					res = true;
					this.popClosedSwf(swfName);
					synchSocket.pushSwfNameForExecutor(swfName);
					synchSocket.doAction(swfName, "showPlayIcon", "");
					
					scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
				}
			}
			
			return res;
		}
		
		public void pushClosedSwf(String swfName)
		{
			if (closedSwfListDuringPlayback == null)
				closedSwfListDuringPlayback = new ArrayList<String>();
			if (!wasSwfDeadOnce(swfName))
				closedSwfListDuringPlayback.add(swfName);
		}
		public void popClosedSwf(String swfName)
		{
			if (closedSwfListDuringPlayback == null)
				return;
			closedSwfListDuringPlayback.remove(swfName);
		}
		
		/**
		 * Check, whether swf once dead during playback, and then comes
		 */
		public boolean wasSwfDeadOnce(String swfName)
		{
			if (closedSwfListDuringPlayback == null)
				return false;
			return closedSwfListDuringPlayback.contains(swfName);
		}
		
		public void setStartTime()
		{
			this.startTimeInStr = this.getCurrentDateTimeString();
		}
		public void setEndTime()
		{
			this.endTimeInStr = this.getCurrentDateTimeString();
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
		
		public String getUpdatedGenieId(String oldGenieId)
		{
			return genieMapTable.get(oldGenieId); 
		}
		
		public void setUpdatedGenieId(String oldGenieId, String newGenieId)
		{
			genieMapTable.put(oldGenieId, newGenieId); 
		}
		
		public String getCurrentDateTimeString() {
		    Calendar cal = Calendar.getInstance();
		    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
		    return sdf.format(cal.getTime());
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
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				sc.writePerformanceData(xmlStr);
			}
		}
		
		public String getGestureName()
		{
			return gestureName;
		}
		
		public void setGestureName(String gestureNameArg)
		{
			this.gestureName = gestureNameArg; 
		}
		
		public boolean getGestureEnabled()
		{
			return gestureStarted;
		}
		
		public void setGestureEnabled(boolean isEnabledArg)
		{
			this.gestureStarted = isEnabledArg; 
		}
		
		public void addGestureEventData(String strXML)
		{
			gestureEventDataArray.add(strXML);
		}
		
		public ArrayList<String> getGestureEventArray()
		{
			return gestureEventDataArray;
		}
		
		public String getGestureAppName()
		{
			return gestureAppName;
		}
		
		public void setGestureAppName(String gestureAppNameArg)
		{
			this.gestureAppName = gestureAppNameArg; 
		}
		
	}
