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

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Vector;
import javax.imageio.ImageIO;
import org.apache.commons.lang.math.RandomUtils;
import org.w3c.dom.Document;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.iexecutor.IGenieScript;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.*;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

/**
 * This is an abstract class which every Genie script derives from.
 * Users will have to implement its start() function.
 * <p>
 * There are also multiple methods exposed which will help user in validating properties 
 * as well as provide a comprehensive set of helper methods which can be used while
 * writing a complete test script 
 * 
 * @since Genie 0.4
 * 
 */

public abstract class GenieScript implements Runnable,IGenieScript{
	
	private long startTime = 0;
	private long endTime = 0;
	
	private ScriptLog scriptLog;
	private String name;
	private Vector<String> scriptSwfList = new Vector<String>();
	SWFList<SWFApp> list = null;
	
	SynchronizedSocket synchSocket;
	private static boolean ENABLE_UMPOSTING=true;
	private String screenShotNameFormat = "Failure_";
	protected Thread thread;
	
	
	 /**
	 * Get command line argument array of GenieScript as passed from Script Parameters.
	 * This cmdArguments can be used only when user script is extended from GenieScript class.
	 * For user scripts which are written as regular java class,user should use arguments passed in main method.
	 * 
     * @since Genie 0.10
	 **/
	public String[] cmdArguments = new String[]{};

	
	/**
	 * Set this Flag to true if Script needs to be aborted on Timeout event
	 * The default value is false
	 * <p>
	 * To define a custom action on timeout, enclose the statement in try/catch block
	 * and catch StepTimedOutException 
	 */
	public static boolean EXIT_ON_TIMEOUT=false;
	
	/**
	 * Set this Flag to true if Script needs to be aborted on any Step failure event
	 * The default value is false
	 * <p>
	 * To define a custom action on step failure, enclose the statement in try/catch block
	 * and catch StepFailedException 
	 */
	public static boolean EXIT_ON_FAILURE=false;
	
	/**
	 * The time delay in milliseconds, before executing any action in Genie Script
	 * The default value is zero
	 * <p>
	 * Note: User can change this anywhere in scripts 
	 */
	public static int EXECUTION_DELAY_BEFORE_STEP = 0;
	
	
	/**
	 * Set this Flag to true if a current screen snapshot needs to be captured when a step fails 
	 * The default value is true
	 * <p>
	 * The Captured screenshot is in JPG format and stored in same folder as Script Log.
	 * Each snapshot carries an auto generated number.
	 */
	public static boolean CAPTURE_SCREENSHOT_ON_FAILURE = true;
	
	/**
	 * Default Constructor, No Parameters Required
	 * <p>
	 * <font color="#FF0000"> A script should extended from GenieScript and users
	 * should not instantiate GenieScript object </font>
	 * 
	 * @throws Exception
	 */
	public GenieScript() throws Exception {
		name = this.getClass().getName();
		thread = new Thread(new ThreadGroup(getName()), this, "GenieScript: " + getName());
	}
	
	/**
	 * Constructor for internal use
	 * <p>
	 * <font color="#FF0000">This method is only meant for internal use of Genie framework.
	 * Users should refrain from calling this constructor. 
	 * </font>
	 * 
	 * @throws Exception
	 */
	public GenieScript(LogConfig config) throws Exception {
		name = this.getClass().getName();
		scriptLog = ScriptLog.getInstance();
		if(scriptLog == null)
		{
			initLogs(config);
			scriptLog = ScriptLog.getInstance();
		}
		thread = new Thread(new ThreadGroup(getName()), this, "GenieScript: " + getName());
	}
	
	//========================================================================================
	// Some public methods which are to be used only internally
	// Need to find a way to exclude them from JavaDocs
	//========================================================================================

	/**
	 * (for internal use only)
	 * Starts execution on a thread
	 * 
	 * @see java.lang.Runnable#run()
	 * 
	 * @since Genie 0.4
	 */
	public final void run() {
		StaticFlags sf = StaticFlags.getInstance();
		scriptLog = ScriptLog.getInstance();
		boolean connectToServerResult = false;
		try {
			
			startTime = System.currentTimeMillis();
			if (sf.isPerformanceEnabled())
			{
				sf.writePerfLogs(Utils.TIME_TO_PLAY, this.name, true);
			}

			Utils.printMessageOnConsole("Start running GenieScript: " + this.name);
			
			synchSocket = SynchronizedSocket.getInstance();
			if(synchSocket != null)
			{
				connectToServerResult = scriptLog.startLogAndConnectToServer(synchSocket,getClassName(),startTime);
			}
			
			if(connectToServerResult)
			{
				//Initialize lists
				list = synchSocket.getSWFList();
				//Do not execute the script if we are unable to fetch list of SWF applications
				//pressAltTabKeyOnlyForMac();
				//Start the Script Execution
				start();
			}
			else
			{
				Utils.printMessageOnConsole("Unable to Connect to Server! Aborting...");
			}
			
		} catch (Exception e) {
			if(e instanceof ConnectionFailedException && CAPTURE_SCREENSHOT_ON_FAILURE)
			{
				captureScreenShot();
			}
			//Log Exception if it has not come up from Step Failure or Timeout issue
			if (!((e instanceof StepFailedException) || (e instanceof StepTimedOutException) || (e instanceof ConnectionFailedException))){
				Utils.printErrorOnConsole("Aborting!... Exception Occurred: " + e.toString());
				scriptLog.addTestStepMessage("Aborting!... Exception Occurred: " + e.toString(),GenieMessageType.MESSAGE_ERROR);
				e.printStackTrace();
			}
			abort();
		}
		finally{
			UsageMetricsData.getInstance().setList(list);
			endTime = System.currentTimeMillis();

			if (sf.isPerformanceEnabled()){
				sf.writePerfLogs(Utils.TIME_TO_PLAY, this.name, false);
			}
			
			scriptLog.setScriptEndTime(endTime);
			Utils.printMessageOnConsole("Total Time taken by Script: " + scriptLog.formatTime(endTime-startTime));
			
			if(synchSocket != null){
				changeFromPlayBackGenieIconOnSwfList(scriptSwfList);
				
				//[Ankur] sending message to server to set flag for posting usage matrix
				synchSocket.setUsageMatrixPostage(ENABLE_UMPOSTING);
				
				UsageMetricsData usg = UsageMetricsData.getInstance();
				usg.addSwf(scriptSwfList);
				
				synchSocket.sendUsageMetricsData(usg.getXml());
			}

			//Invoke Garbage collector....
			System.gc();
			System.runFinalization();
		}
	}
	
    /**
     * (for internal use only)
     * Aborts a running script by interrupting its thread
     * and setting the application object as null
     * 
     */
	final void abort()
	{
	}
	
		
	//========================================================================================
	// Some public exposed methods which are important for GenieScript writing
	//========================================================================================

	/**
	 * Returns this script's thread object.
	 * 
	 * @return 
	 * 		This script's thread object or null if the script was not yet started
	 * 
	 * @since Genie 0.4
	 */
	public Thread getThread() {
		return thread;
	}
	
	
	/**
	 * Returns the name of current script.
	 * 
	 * @return 
	 * 		The name of current script
	 * 
	 * @since Genie 0.4
	 */
	public String getName() {
		return name;
		//return new String(name);
	}
	
	
	/**
	 * This method contains the actual code to execute when running this script and must be
	 * overridden by the test script.
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public abstract void start() throws Exception;
	
	/**
	 * This method checks if the asked SWF is actually launched and returns true if the swf app 
	 * is launched else returns false
	 * 
	 * @param appName
     *            Name of the SWF as string with which to establish the connection.
     *            This name is provided by SWF app itself and it's value can be checked
     *            in Eclipse using Genie plugin. 
     *      
	 * @return 
     * 			returns true if it finds swf application else returns false.
	 * 
	 * 
	 * @since Genie 1.0
	 */
	
	public boolean isAppAvailable(String appName)
	{
		//let's check if the SWF is in the list
		//SCA
		//SWFApp app = list.getSWF(appName);
		
		boolean result = false;
		
		//Check if SWF currently being connected to is not yet available in SWF list
		//If this is the case get the latest SWF List and check if app is present there
		list = synchSocket.getSWFList();
		//SCA
		SWFApp app = list.getSWF(appName);
		
		if(app != null)
		{
			result = true;
		}
		else
			result = false;
		return result;
	}
	
	/**
	 * This method checks if the asked SWF is actually launched for the given time
	 * and connects the Executor to the SWF. It throws ConnectionFailedException if 
	 * can not connect to app within given time.
	 * 
	 * @param appName
     *            Name of the SWF as string with which to establish the connection.
     *            This name is provided by SWF app itself and it's value can be checked
     *            in Eclipse using Genie plugin. 
     *           
	 * @param timeoutInSeconds
     *            timeout value in seconds
     *            
     * 
	 * @return 
     * 			Object of SWF application on which to perform actions. This needs to be passed
     * 			as parameter to all actions on the corresponding SWF and this recognizes the application
     * 			on which the actions are being performed
     * 			<p>
     * 			The Returned object is of type com.adobe.genie.genieCom.SWFApp and it holds certain attributes which
     * 			can provide information related to the application under test {@link com.adobe.genie.genieCom.SWFApp}
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.0
	 */
	public SWFApp waitForAppToConnect(String appName, int timeoutInSeconds) throws ConnectionFailedException
	{
		SWFApp app = null;
		
		long startTime = System.currentTimeMillis();		
		long timeToWait = System.currentTimeMillis() + (timeoutInSeconds*1000L);
		
		scriptLog.addTestStep("waitForAppToConnect: " + appName, GenieStepType.STEP_CONNECTION_TYPE, "Application: "+ appName);
		
		while(app == null)
		{
			if(timeoutInSeconds < 0)
			{
				Utils.printMessageOnConsole("Timeout value provided by user is negative so Genie will directly connect to app and will not wait for app to connect");
				scriptLog.addTestStepMessage("Timeout value provided by user is negative so Genie will directly connect to app and will not wait for app To connect", GenieMessageType.MESSAGE_INFO);
				try{
					app = connectToApp(appName,false);
				}catch(Exception e){
				}
				break;
			}
			else if(timeoutInSeconds == 0)
			{
				Utils.printMessageOnConsole("Timeout value provided by user is zero so Genie will directly connect to app and will not wait for app to connect");
				scriptLog.addTestStepMessage("Timeout value provided by user is zero so Genie will directly connect to app and will not wait for app to connect", GenieMessageType.MESSAGE_INFO);
				try{
					app = connectToApp(appName,false);
				}catch(Exception e){
				}
				break;
			}
			else if(System.currentTimeMillis() <= timeToWait /*&& (app == null)*/)
			{
				try{
					app = connectToApp(appName,false);
				}catch(Exception e){
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {}
				}
			}
			else
				break;
		}
		
		scriptLog.addTestStepMessage("Waited for " + ((System.currentTimeMillis() - startTime)/1000) + " seconds", GenieMessageType.MESSAGE_INFO);
		if(app == null) {
			Utils.printErrorOnConsole("Waited for " + ((System.currentTimeMillis() - startTime)/1000) + " seconds, but could not connect to application" );
			scriptLog.addTestStepMessage("Could not connect to application ", GenieMessageType.MESSAGE_ERROR);
			scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
			throw new ConnectionFailedException();
		}
		else {
			scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
		}
		return app;
	}
	
	/**
	 * This method checks if the asked SWF is actually launched 
	 * and connects the Executor to the SWF
	 * 
	 * @param appName
     *            Name of the SWF as string with which to establish the connection.
     *            This name is provided by SWF app itself and it's value can be checked
     *            in Eclipse using Genie plugin. 
	 * 
	 * @return 
     * 			Object of SWF application on which to perform actions. This needs to be passed
     * 			as parameter to all actions on the corresponding SWF and this recognizes the application
     * 			on which the actions are being performed
     * 			<p>
     * 			The Returned object is of type com.adobe.genie.genieCom.SWFApp and it holds certain attributes which
     * 			can provide information related to the application under test {@link com.adobe.genie.genieCom.SWFApp}
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 0.4
	 */
	public SWFApp connectToApp(String appName) throws ConnectionFailedException
	{
		return connectToApp(appName,true);
	}
	
	/**
	 * This method checks if the asked SWF is actually launched 
	 * and connects the Executor to the SWF
	 * 
	 * @param appName
     *            Name of the SWF as string with which to establish the connection.
     *            This name is provided by SWF app itself and it's value can be checked
     *            in Eclipse using Genie plugin. 
     *      
     *  @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
     * 			Object of SWF application on which to perform actions. This needs to be passed
     * 			as parameter to all actions on the corresponding SWF and this recognizes the application
     * 			on which the actions are being performed 
     * 			<p>
     * 			The Returned object is of type com.adobe.genie.genieCom.SWFApp and it holds certain attributes which
     * 			can provide information related to the application under test {@link com.adobe.genie.genieCom.SWFApp}
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.0
	 */
	public SWFApp connectToApp(String appName,boolean bLogging) throws ConnectionFailedException
	{
		if(bLogging)
		{
			//Log info in script
			scriptLog.addTestStep("ConnectToSWF: " + appName, GenieStepType.STEP_CONNECTION_TYPE, "Application: "+appName);
		}
		
		//let's check if the SWF is in the list
		//SCA
		//SWFApp app = list.getSWF(appName);
		
		boolean result = false;
		
		//Check if SWF currently being connected to is not yet available in SWF list
		//If this is the case get the latest SWF List and check if app is present there
		list = synchSocket.getSWFList();
		//SCA
		SWFApp app = list.getSWF(appName);
		
		if(app != null)
		{
			//Increase timeout value of connectToApp method
			int oldTimeOut = SynchronizedSocket.getInstance().getTimeout();
			if(oldTimeOut < 30)
				setTimeout(30);
			String op  = app.connect();
			setTimeout(oldTimeOut);
			
			if((op.equalsIgnoreCase("timeout")) || (op.length() == 0) || (op.equals("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")))
				result = false;
			else
				result = true;
		}
		if(result == false)
		{
			if(bLogging){
				Utils.printErrorOnConsole("Could not connect to SWF " + appName);
				scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
				scriptLog.addTestStepMessage("Could not connect to SWF " + appName , GenieMessageType.MESSAGE_ERROR);
				scriptLog.addTestStepMessage("No Further action can be performed on this application" , GenieMessageType.MESSAGE_ERROR);
			}
			//SCA
			//app = null;
			
			
			abort();
			throw new ConnectionFailedException();
		}
		else {
			scriptLog.addTestApplication(appName, "", "", "");
			scriptLog.addFlashInfo(app.playerType,app.playerVersion,app.asVersion,app.genieVersion, app.preloadName, app.preloadSdkVersion);

			scriptSwfList.add(appName);
		}
		
		synchSocket.pushSwfNameForExecutor(appName);
		
		//Changing to play icon
		changetoPlaybackGenieIcon(appName);
		
		if(bLogging)
			scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
		return app;
	}
	
	/**
	 * Updates Build number of the application in Product tag
	 * 
	 * @param app
	 * 			SWFApp object of the application
	 * 
	 * @param buildNumber
	 * 			Build Number of Application
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 *  * @since Genie 1.0
	 */
	public boolean setAppBuildNumber(SWFApp app, String buildNumber)
	{
		if(app != null)
			return scriptLog.setAppBuildNumber(app.name ,buildNumber);
		else
		{
			Utils.printErrorOnConsole("Application object passed is null");
			return false;
		}
	}
	
	/**
	 * This method captures the application image at specified imagePath location with logging
	 * 
	 * @param app
     *            SWF application object whose image will be captured. 
     *     
     *  @param imagepath
     *  		Path where application image should be saved
     *  
     * 
	 * @return 
     * 			status of capturing image of application as boolean 
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.4
	 */
	public Boolean captureAppImage(SWFApp app,String imagePath) throws StepFailedException
	{
		return captureAppImage(app,imagePath,true);
	}
	
	/**
	 * This method captures the application image with optional logging
	 * 
	 * @param app
     *            SWF application object whose image will be captured. 
     *     
     *  @param imagepath
     *  		Path where application image should be saved
     *  
     *  @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
     * 			status of capturing image of application as boolean 
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.4
	 */
	public Boolean captureAppImage(SWFApp app,String imagePath, boolean bLogging) throws StepFailedException
	{
		Result result = new Result();
		if(app == null)
		{
			result.result = false;
			result.message = "Application object is null";
		}
		else if(app != null) 
		{		
			result  = captureApplicationImage(app.name,imagePath);
		}				
		if(bLogging)
		{
				scriptLog.addTestStep("CaptureAppImage", GenieStepType.STEP_CONNECTION_TYPE,"captureApplicationImage");
				if(result.result == false)
				{
					Utils.printErrorOnConsole("Unable to capture image :" + result.message);
					wait(1);
					Utils.printMessageOnConsole("Result is: Step Failed");
					scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
					scriptLog.addTestStepMessage("Unable to capture image :"+ result.message, GenieMessageType.MESSAGE_ERROR);
				}
				else 
				{
					Utils.printMessageOnConsole("Capture image of application at " + imagePath + " location ");
					Utils.printMessageOnConsole("Result is: Step Passed");
					scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
					scriptLog.addTestStepMessage("Capture screenshot of application at " +imagePath + " location ", GenieMessageType.MESSAGE_INFO);
				}
		}
	     
		// Throws Exception when a Step fails and EXIT_ON_FAILURE flag is set
        if (!result.result && GenieScript.EXIT_ON_FAILURE){
			Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
			scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			throw new StepFailedException();                                               
		}
		return result.result;
	}
	
	
	/**
	 * This method captures the application image at temporary location with logging
	 * 
	 * @param app
     *            SWF application object whose image will be captured. 
     *  
	 * @return 
     * 			imagepath as String
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.4
	 */
	public String captureAppImage(SWFApp app) throws StepFailedException
	{
		return captureAppImage(app,true);
	}
	
	/**
	 * This method captures the application image at temporary location
	 * 
	 * @param app
     *            SWF application object whose image will be captured. 
     *     
     *  @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
     * @return 
     * 			imagepath as String
     * 
	 * 
	 * @throws ConnectionFailedException
	 * 
	 * @see com.adobe.genie.genieCom.SWFApp
	 * 
	 * @since Genie 1.4
	 */
	public String captureAppImage(SWFApp app,boolean bLogging) throws StepFailedException
	{
		Result result = new Result();
		String imagePath = "";
		
		if(app == null)
		{
			result.result = false;
			result.message = "Application object is null";
		}
		else
		{
			imagePath = System.getProperty("java.io.tmpdir") + File.separator + "genieComponentImage" + RandomUtils.nextInt() + ".png";
			result  = captureApplicationImage(app.name,imagePath);
		}
		
		if(bLogging)
		{
			scriptLog.addTestStep("CaptureAppImage", GenieStepType.STEP_CONNECTION_TYPE,"captureApplicationImage");
			if(result.result == false)
			{
				Utils.printErrorOnConsole("Unable to capture screenshot :" +result.message);
				wait(1);
				Utils.printMessageOnConsole("Result is: Step Failed");
				scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
				scriptLog.addTestStepMessage("Unable to capture screenshot :" + result.message, GenieMessageType.MESSAGE_ERROR);
			}
			else 
			{
				Utils.printMessageOnConsole("Capture screenshot of application at " + imagePath + " location ");	
				Utils.printMessageOnConsole("Result is: Step Passed");
				scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
				scriptLog.addTestStepMessage("Capture screenshot of " + app.name + "at " +imagePath + "location", GenieMessageType.MESSAGE_INFO);
			}
		}
		// Throws Exception when a Step fails and EXIT_ON_FAILURE flag is set
        if (!result.result && GenieScript.EXIT_ON_FAILURE){
			Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
			scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			throw new StepFailedException();                                               
		}
		return imagePath;
	}
	
	//This function captures the application image and sane at specified location
	private Result captureApplicationImage(String appName,String imagePath)
	{
		Result result = SynchronizedSocket.getInstance().doAction(appName, BaseEvent.CAPTURE_APPLICATION_IMAGE, "<String>" + appName +"</String>");
		boolean captureApplicationImageStatus = false;
		String message = "";
		Boolean bresult = false;
		Document doc = Utils.getXMLDocFromString(result.message);
		
		try
		{
			if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
			{
				String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
				bresult =  Boolean.parseBoolean(temp);
			}
			
			if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
			{
				message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
			}
			else
			{
				message = "";
			}
		}
		catch(Exception e)
		{
			if(message.equals(""))
				Utils.printErrorOnConsole("Error occured in capturing application image");
			else
				Utils.printErrorOnConsole(message);
		}
		
		
		if (bresult)
		{
			try
			{
				byte[] bytes = Base64.decode(message);
				File outputFile = new File(imagePath);
				Utils.createParentDirRecursivelyIfNotExist(outputFile.getParentFile());	
				if(!outputFile.exists())
					outputFile.createNewFile();
				BufferedImage bi = ImageIO.read(new ByteArrayInputStream(bytes)); // retrieve image
				ImageIO.write(bi, "png", outputFile);
				captureApplicationImageStatus = true;
			}
			catch(Exception e){
				Utils.printErrorOnConsole("Failed to save image :"+e.getMessage());
				message = "Failed to save image :"+e.getMessage();
			}
		}
		else
		{
			Utils.printMessageOnConsole("Error Occured in capturing Application Image;"+ message);
		}
		
		Result myResult = new Result();
		myResult.result = captureApplicationImageStatus;
		if(!result.result)
			myResult.message = message; 
		return myResult;
		
	}
	
	
	/**
	 * This method returns ArrayList containing all SWFApp objects which are currently launched. 
	 * This list is same as shown in eclipse dropdown.
	 * 	
	 * @return
	 * 			returns ArrayList of SWFApp objects 
	 * @since Genie 1.1
	 */
	public ArrayList<SWFApp> getSWFList()
	{
		ArrayList<SWFApp> returnList = new ArrayList<SWFApp>();
		SWFList<SWFApp> list = synchSocket.getSWFList();
		for(int i =0; i <list.size(); ++i){
			SWFApp app = list.get(i);
			returnList.add(app);
			}
		return returnList;
	}
	
	/**
	 * This method sets the timeout value(in seconds) for actions.
	 * The timeout value set here will apply for all the 
	 * subsequent steps in script.
	 * 
	 * @param timeout
     *            timeout value in seconds
	 * 	
	 * @since Genie 0.4
	 */
	public void setTimeout(int timeout)
	{
		 SynchronizedSocket sc = SynchronizedSocket.getInstance();
		 sc.setTimeout(timeout);
	}
	
	/**
	 * This method gets the current timeout value(in seconds) 
	 * which is currently set for actions
	 *
	 * @return 
     * 			The current value of timeout in seconds
     * 
     * @since Genie 0.4
 	 */
	public int getTimeout()
	{
		 SynchronizedSocket sc = SynchronizedSocket.getInstance();
		 return sc.getTimeout();
	}
	
	/**
	 * This method will make the script to wait for specified time (in seconds)	
	 *  
	 * @param seconds
     *            time in seconds for which the script will wait
     *            
     * @since Genie 0.4
	 */
	public void wait(int seconds) {
		try{
			Thread.sleep(seconds*1000L);
		}catch (Exception e) {
			Utils.printErrorOnConsole(e.getMessage());
		}
	}
	
	/**
	 * Saves Application xml file at the location specified by user. This step is not added to Genie script log.
	 * @param app
     *            Application object as SWFApp whose object structure is to be saved
     * 
     * @param path
     * 			  File name, which will contain object structure of app in XML format
     * 			  The filename can also be an absolute path. If not absolute then it will be saved
     * 			  along with the Logs in Log Folder
     *      
	 * @since Genie 0.11
	*/
	public void saveAppXml(SWFApp app, String path)
	{
		try
		{
			File f = new File(path);
			if (!f.isAbsolute())
			{
				String s = f.getParent();
				if (s == null)
				{
					//just file name passed
					path = ScriptLog.getInstance().getLogFolderPath() + File.separator + path;
				}
				else
				{
					//e.g. abc\file.xml
					path = ScriptLog.getInstance().getLogFolderPath() + File.separator + path;
					f = new File(path);
					Utils.createParentDirRecursivelyIfNotExist(f.getParentFile());					
				}				
			}		
		
			try
			{
				app.saveAppXml(path);
			}
			catch(Exception e)
			{
				Utils.printErrorOnConsole("saveAppXml failed: " + e.getMessage());
			}
		}
		catch(Exception e)
		{
			Utils.printErrorOnConsole("Exception while saving xml: " + e.getMessage());
		}
	}

	//========================================================================================
	// Some exposed methods related to Logging of Steps in script
	//========================================================================================
	
	/**
	 * Adds new test step in script log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param stepName
     * 			  Step name as it should appear in the log file 
     * 
	 * @since Genie 0.5
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.GenieScriptLogger#addTestStep(String)}
	 */
	@Deprecated
	public void addTestStep(String stepName)
	 {
		UsageMetricsData usage = UsageMetricsData.getInstance();
		usage.addFeature("CustomLogging");
		
		 scriptLog.addTestStep(stepName, GenieStepType.STEP_CUSTOM_TYPE, "UserAddedStep");
	 }
	 
	 /**
	 * Adds message to the last step added in the log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param message
     * 			  message that should appear in the log file.
     * @param type
     * 			  Type of message as defined in GenieMessageType. Example :- GenieMessageType.MESSAGE_INFO etc
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType
	 * 
	 * @since Genie 0.5
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepMessage(String, 
	 * 			com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType)}
	 */
	@Deprecated
	public void addTestStepMessage(String message, GenieMessageType type)
	 {
		 scriptLog.addTestStepMessage(message, type);
	 }
	 
	 /**
	 * Adds test parameter to the last step added in the log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param name
     * 			  name of the parameter. Example - "InputValue", "ExpectedValue" etc.
     * @param type
     * 			  Type of parameter as defined in GenieParameterType. Example :- GenieParameterType.PARAM_INPUT etc
     * @param value
     * 			  value of parameter
     * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType
	 * 
	 * @since Genie 0.5
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepParameter(String, 
	 * 		com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType, String)}
	 */
	@Deprecated
	 public void addTestStepParameter(String name, GenieParameterType type, String value)
	 {
		 scriptLog.addTestStepParameter(name, type, value);
	 }
	 
	 /**
	 * Adds test result to the last step added in the log file.
	 *
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param status
     * 			Result of the step as defined in enum GenieResultType. Example GenieResultType.STEP_FAILED
     *
     * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType
     * 
     * @since Genie 0.5
     * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepResult
	 * 					(com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType)}
	 */
	@Deprecated
	public void addTestStepResult(GenieResultType status)
	{
		scriptLog.addTestStepResult(status); 
	}
	
//	 /**
//	 * This marks start of a gesture
//	 */
//	public void startGesture(String gestureName)
//	{
//		StaticFlags.getInstance().setGestureEnabled(true);
//		StaticFlags.getInstance().setGestureName(gestureName);
//		
//		scriptLog.addTestStep("Start Gesture" , GenieStepType.STEP_NATIVE_TYPE ,"Multiple controls");
//		Utils.printMessageOnConsole("Started gesture " + gestureName);
//	}
//	
//	/**
//	 * This marks end of a gesture
//	 */
//	public void endGesture(String gestureName)
//	{
//		SynchronizedSocket sc = SynchronizedSocket.getInstance();
//		String appName = StaticFlags.getInstance().getGestureAppName();
//		
//		String output = sc.doGenericAction(appName, "startGesture", "");
//		if(output == "true")
//		{
//			ArrayList<String> eventArray = StaticFlags.getInstance().getGestureEventArray();
//			String dataToSend = "";
//			for(int i=0; i<eventArray.size() ; ++i)
//			{
//				dataToSend += eventArray.get(i);
//			}
//			Result result = sc.doAction(appName, BaseEvent.PLAYBACK, dataToSend);
//			if(result.result)
//				scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
//			else
//				scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
//			scriptLog.addTestStepMessage(result.message, GenieMessageType.MESSAGE_INFO);
//		}
//		Utils.printMessageOnConsole("End gesture " + gestureName);
//		return;
//	}
	
	//========================================================================================
	// Some private Functions related to changing of Genie image on prelaod and log file
	//========================================================================================
		
	/**
	 * Create a script log file
	 */
	
	@SuppressWarnings("unchecked")
	private String getClassName()
	{
		Class cls=this.getClass();
		String className=cls.getName().concat(".java");
		return className;
	}
	
	// Initializes the Script log Instance
	private void initLogs(LogConfig logConfig) throws Exception
	{
		boolean b=true;
		String scriptLogFolder = logConfig.getLogFolder();
		String name = logConfig.getLogFileName();
		if(!logConfig.isLogOverWrite())
		{
			if(!logConfig.isLogFolderWithoutTimestamp())
			{
				scriptLogFolder = logConfig.getLogFolder() + File.separator + name + "_" + Utils.getDateTimeStringForFolder(System.currentTimeMillis());
			}
			else
			{
				scriptLogFolder = logConfig.getLogFolder() + File.separator + name.split("\\.")[0];
				Utils.deleteFile(scriptLogFolder);
				if( !(new File(scriptLogFolder)).exists()){
					b=(new File(scriptLogFolder)).mkdirs();
					if(!b)
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
				}
			}
		}
		else
		{
			//deleteFile(logFolder);
			if( !(new File(scriptLogFolder)).exists()){
				b=(new File(scriptLogFolder)).mkdirs();
				if(!b)
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
			}
		}
		
		File userLogFolder = new File(scriptLogFolder);
		
		if(!logConfig.isNoLogging())
			Utils.createParentDirRecursivelyIfNotExist(userLogFolder);
			
		if (ScriptLog.getInstance(scriptLogFolder, name, !logConfig.isNoLogging()) == null)
			throw new Exception("Unable to Instantiate Script Log! Aborting...");
		
	}
	 /**
     * Change the color of genieImage to play icon
     */
    private void changetoPlaybackGenieIcon(String appName){
    	synchSocket.doAction(appName, "showPlayIcon", "");
    }
    
    /**
     * Change the color of genieImage from play icon to previous genieImage
     */
    private void changefromPlaybackGenieIcon(String appName){
    	synchSocket.doAction(appName, "hidePlayIcon", "");
    }
    
    /**
     * Change the Genie Icon on SWF to previous icon 
     */
    private void changeFromPlayBackGenieIconOnSwfList(Vector<String> swfList)
    {
    	Iterator<String> it = swfList.iterator();
    	while (it.hasNext())
    	{
    		changefromPlaybackGenieIcon(it.next());
    	}
    }
    
    /**
	 * Need for this is MAC specific.
	 * When user perform UI operations on mac, robot initializes, and it focus out the application.
	 * And, when UI operation occurs, it just focus the application, 
	 * and actual operation does not happen
	 * 
	 * So, this action is being performed just before script is about to executed
	 *//*
	private void pressAltTabKeyOnlyForMac()
	{
		if (System.getProperty("os.name").toLowerCase().startsWith("mac"))
		{
			try
			{
				UIFunctions ui = new UIFunctions(false);
				ui.pressKey("VK_META");
				ui.pressKey("VK_TAB");
				ui.releaseKey("VK_TAB");
				ui.releaseKey("VK_META");
			}
			catch(Exception e){
				StaticFlags sf = StaticFlags.getInstance();					
				sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
			}
		}
	}*/
	
	private void captureScreenShot()
	{
		Utils.printErrorOnConsole("Step Failed and CAPTURE_SCREENSHOT_ON_FAILURE is ON so capturing current ScreenShot");
		String fileName = screenShotNameFormat + Integer.toString(scriptLog.getFailureCounter()) + ".jpg";
		StaticFlags sf = StaticFlags.getInstance();
		try {
			new UIFunctions(sf.isdebugMode()).captureScreenAsJPG(scriptLog.getLogFolderPath(), fileName);
		} catch (Exception e) {
			Utils.printErrorOnConsole("Error occurred while trying to save captured screenshot");
			if (sf.isdebugMode())
				e.printStackTrace();
			else
				Utils.printErrorOnConsole(e.getMessage());
		}
	}
}
