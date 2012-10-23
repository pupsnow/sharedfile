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

import com.adobe.genie.utils.Utils;

/**
 * This class contains logging options for Genie
 * Initialize this class and set various logging options by calling setter methods.
 * @since Genie 1.6
 */
public class LogConfig {

	private String logFolder = "";
	private boolean logOverWrite = false;
	private boolean logFolderWithoutTimestamp = false;
	private boolean noLogging = false;
	private String logFileName = "Genie";

	/**
	 * Constructor for LogConfig class
	 * 
     * @since Genie 1.6
	 */
	public LogConfig()
	{
		logFileName = getMainClassName();
   		logFolder = Utils.getCurrentPath() + File.separator + "GenieLogs";
	}
	
	/**
	 * Sets log folder where Genie script logs would be created.  
	 * @param logFolder
	 * 		Path of log folder to set
     * @since Genie 1.6
	 * 
	 */
	public void setLogFolder(String logFolder)
	{
		this.logFolder = logFolder;
	}
	/**
	 * Gets the value of log folder currently set  
	 *  @return
	 * 		log folder path as String
     * @since Genie 1.6
	 */

	public String getLogFolder()
	{
		return this.logFolder;
	}
	
	/**
	 * Gets the name of log File
	 *  @return
	 * 		log file name as String
     * @since Genie 1.6
	 */

	public String getLogFileName()
	{
		return this.logFileName;
	}
	
	
	/**
	 * This method sets logOverWrite option. If it is set to true then no special folder will be created for storing logs and logs will be created at
       root folder and also they will be overwritten on each execution session . If logFolderWithoutTimestamp is also specified then logFolderWithoutTimestamp 
 	   will be ignored and logOverWrite will be considered 
	 * @param logOverWrite
	 * 		boolean value to set
	 * @since Genie 1.6 
	 */

	public void setLogOverWrite(boolean logOverWrite)
	{
		this.logOverWrite = logOverWrite;
	}
	/**
	 * Gets the value of logOverWrite option 
	 *  @return
	 * 		current boolean value 
	 * @since Genie 1.6 
	 */
	public boolean isLogOverWrite()
	{
		return this.logOverWrite;
	}
	
	/**
	 *This method sets logFolderWithoutTimestamp option. If it is set to true then TimeStamp will not be appended to the Script Log folder.
      If same script is executed again the contents of folder will be overwritten. 
	 * @param logFolderWithoutTimestamp
	 * 		boolean value to set
	 * @since Genie 1.6 
	 */
	public void setLogFolderWithoutTimestamp(boolean logFolderWithoutTimestamp)
	{
		this.logFolderWithoutTimestamp = logFolderWithoutTimestamp;
	}
	/**
	 * Gets the value of logFolderWithoutTimestamp option 
	 *  @return
	 * 		current boolean value 
	 * @since Genie 1.6
	 */
	public boolean isLogFolderWithoutTimestamp()
	{
		return this.logFolderWithoutTimestamp;
	}

	/**
	 *This method sets noLogging option. If it is set to true then No script/suite logs are generated.
	 * @param noLogging
	 * 		boolean value to set
	 * @since Genie 1.6 
	 */
	public void setNoLogging(boolean noLogging)
	{
		this.noLogging = noLogging;
	}
	/**
	 * Gets the value of noLogging option 
	 *  @return
	 * 		current boolean value 
	 */
	public boolean isNoLogging()
	{
		return this.noLogging;
	}
	
	
	
	//Get name of main class executing Genie steps
	private String getMainClassName()
	{
		StackTraceElement[] stack = Thread.currentThread ().getStackTrace ();     
	    StackTraceElement main = stack[stack.length - 1];    
	    String mainClass = main.getClassName ();
	    String[] subComps = mainClass.split("\\.");
	    if(subComps.length > 0)
	    	mainClass = subComps[subComps.length - 1];
	    else
	    	mainClass = "GenieScript";
	    return mainClass;
	}
}
