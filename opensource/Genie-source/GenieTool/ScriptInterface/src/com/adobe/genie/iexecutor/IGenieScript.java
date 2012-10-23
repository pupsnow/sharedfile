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
package com.adobe.genie.iexecutor;

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.executor.enums.GenieLogEnums.*;

public interface IGenieScript{
	
	/**
	 * Returns this script's thread object.
	 * 
	 * @since Genie 0.4
	 */
	public Thread getThread();
	
	
	/**
	 * Returns the name of current script.
	 * 
	 * @since Genie 0.4
	 */
	public String getName();
	
	/**
	 * This method checks if the asked SWF is actually launched 
	 * and connects the Executor to the SWF
	 * 
	 * @since Genie 0.4
	 */
	public SWFApp connectToApp(String appName) throws Exception ;
	
	/**
	 * This method checks if the asked SWF is actually launched 
	 * and connects the Executor to the SWF
	 * 
	 * @since Genie 1.0
	 */
	public SWFApp connectToApp(String appName,boolean bLogging) throws Exception ;
	
	/**
	 * This method sets the timeout value(in seconds) for actions.
	 * The timeout value set here will apply for all the 
	 * subsequent script
	 * 
	 * @since Genie 0.4
	 */
	public void setTimeout(int timeout);
	
   /**
	* This method gets the current timeout value(in seconds) 
	* which is currently set for actions
	*
	* @since Genie 0.4
 	*/
	public int getTimeout();
	
   /**
	* This method will make the script to wait for specified time (in seconds)	
	*  
	* @since Genie 0.4
	*/
	public void wait(int seconds);
	
	/**
	 * Adds new test step in script log file.
	 * 
	 * @since Genie 0.5
	 **/
	 public void addTestStep(String stepName);
	
	 /**
	  * Adds message to the last step added in the log file.
	  * 
	  * @since Genie 0.5
	  **/
	 public void addTestStepMessage(String message, GenieMessageType type);
	 
	/**
	 * Adds test parameter to the last step added in the log file.
	 * 
	 * @since Genie 0.5
	 **/	 
	 public void addTestStepParameter(String name, GenieParameterType type, String value);
	 
    /**
	 * Adds test result to the last step added in the log file.
	 * 
	 * @since Genie 0.5
	 **/
	 public void addTestStepResult(GenieResultType status);
	 
	 /**
	 * This method checks if the asked SWF is actually launched and returns true if the swf app 
	 * is launched else returns false
	 * 
	 * @since Genie 1.0
	 */
	public boolean isAppAvailable(String appName);
	
	/**
	 * This method checks if the asked SWF is actually launched for the given time
	 * and connects the Executor to the SWF. It throws ConnectionFailedException if 
	 * can not connect to app within given time.
	 * 
	 * @since Genie 1.0
	 */
	public SWFApp waitForAppToConnect(String appName, int timeoutInSeconds) throws Exception;
	
	/**
	 * Save Application xml in location specified by user
	 *
	 * @since Genie 0.11
	*/
	public void saveAppXml(SWFApp app, String path);
	
	/**
	 * This method captures the application image at temporary location
	 *  
	 * @since Genie 1.4
	 */
	public String captureAppImage(SWFApp app) throws Exception;
	
	/**
	 * This method captures the application image at temporary location with optional logging
	 * and returns imagepath
	 *  
	 * @since Genie 1.4
	 */
	public String captureAppImage(SWFApp app,boolean bLogging) throws Exception;
	
	/**
	 * This method captures the application image at imagepath location
	 * and returns imagepath
	 *  
	 * @since Genie 1.4
	 */
	public Boolean captureAppImage(SWFApp app,String imagePath) throws Exception;
	
	/**
	 * This method captures the application image at imagepath location with optional logging
	 *  
	 * @since Genie 1.4
	 */
	public Boolean captureAppImage(SWFApp app,String imagePath,boolean bLogging) throws Exception;
	
}
