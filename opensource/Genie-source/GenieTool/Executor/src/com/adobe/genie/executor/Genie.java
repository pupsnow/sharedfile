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

import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;

//This class is extended from GenieScript and is responsible for initializing socket connection.
//User will create instance of this class by calling init() method. 

/**
 * This class needs to be initialized when executing Genie steps from within a regular java file.
 * Call static init() method of this class to instantiate it. This class is a singleton class therefore calling init() 
 * method multiple times would return the same instance.
 * 
 * @since Genie 1.6
 */
public class Genie extends GenieScript{

		private static Genie instance = null; 
		private long startTime = 0;
		private long endTime = 0; 
		private LogConfig logConfig = null;
		/**
		 * Method to initialize Genie framework. It returns instance of Genie class, which can be used to call methods like
		 * connectToApp(), captureAppImage(), connectTodevice().
		 * 
		 * @param logConfig
		 * 		instance of LogConfig class which holds logging options 
		 * 
		 * @return
		 * 		Instance of Genie class {@link com.adobe.genie.executor.Genie}
		 * @throws Exception
         * @since Genie 1.6
		 */
		public static Genie init(LogConfig logConfig)throws Exception 
		{
			if(instance == null)
			{
				instance = new Genie(logConfig);
			}
				
			return instance;
		}
		//Constructor to initialize Genie framework. Made it private to make sure it does not get called by user
		
		private Genie(LogConfig logConfig) throws Exception {
			super(logConfig);
			this.logConfig = logConfig;
			startTime = System.currentTimeMillis();
			CommandHandler ch = new CommandHandler();
			boolean isCompatibile = Executor.isCompat(ch);
			boolean isSecondExecutorIssue = ch.isSecondExecutor();
			ScriptLog scriptLog = ScriptLog.getInstance();
			
		    synchSocket = SynchronizedSocket.getInstance();
			scriptLog.startLogAndConnectToServer(synchSocket, logConfig.getLogFileName(),startTime);
			
			if (isSecondExecutorIssue)
			{
				
				scriptLog.addMessage("One execution is already running! Aborting...", GenieMessageType.MESSAGE_ERROR);
				Utils.printErrorOnConsole("One execution is already running! Aborting...");
			}
			if (isCompatibile && !isSecondExecutorIssue)
			{
				// Pass on Debug Flag Information to ScriptLog instance
				ScriptLog.getInstance().setDebugMode(StaticFlags.getInstance().isdebugMode());
			}
						
			synchSocket = SynchronizedSocket.getInstance(Utils.EXECUTOR_NAME_STR, ch);
			
			StaticFlags.getInstance().loadCustomDelegateClasses();
			
		}

		@Override
		public void start() throws Exception {
			//Do nothing
		}
		
		/**
		 * This method performs cleanup steps for Genie framework.
		 * Call this method when you no longer want to execute Genie APIs. 
		 * Make sure to call this method in finally block so that Genie framework terminates and socket thread closes down.
		 * 
		 * @since Genie 1.6
		 */
		public void stop() {
			try 
			{
				endTime = System.currentTimeMillis();
				StaticFlags sf = StaticFlags.getInstance();
				if (sf.isPerformanceEnabled()){
					sf.writePerfLogs(Utils.TIME_TO_PLAY, logConfig.getLogFileName(), false);
				}
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.setScriptEndTime(endTime);
				Utils.printMessageOnConsole("Total Time taken by Script: " + scriptLog.formatTime(endTime-startTime));
				
				ScriptLog.getInstance().convertFinalLogToHTML();
				SynchronizedSocket synchSocket = SynchronizedSocket.getInstance();
				synchSocket.close();
				SynchronizedSocket.getInstance().resetResponseList();
				ScriptLog.getInstance().dispose();
				UsageMetricsData.getInstance().dispose();
				TestCaseClassLoader.getInstance("").dispose();
				SynchronizedSocket.getInstance().dispose();
				instance = null;

				Utils.printMessageOnConsole("Script ended");
				
				//Invoke Garbage collector....
				System.gc();
				System.runFinalization();
			} 
			catch(Exception e) 
			{
				Utils.printErrorOnConsole("Exception in Stop() method.");
				Utils.printErrorOnConsole("Exception is " + e.getMessage());
			}
		}
		
		
	}