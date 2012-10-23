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
package com.adobe.genie.executor.internalLog;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.lang.management.ManagementFactory;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.commons.lang.StringEscapeUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.objects.GenieStepObject;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.sun.management.OperatingSystemMXBean;

/**
 * This class contains all the methods and Constants that enables in writing a 
 * Script Log. Its constructs the header, hierarchy, add steps and there results
 * as well as computes the net result of a Script
 * 
 * @since Genie 0.4
 */
public class ScriptLog {
	//int errorCode = 0;
	long testDuration = 0 ;
	
	//String scriptStartTimeStr = "";
	//String scriptEndTimeStr = "";
	
	//String stepStartTimeStr = "";
	//String stepEndTimeStr = "";
	
	long stepStartTime =0;
	long stepEndTime =0;
	long scriptStartTime =0;
	long scriptEndTime =0;
	
	Node testLogNode = null;
	Element currentScriptElement = null;
	Element currentScriptResult = null;
	Element currentScriptResultTime = null;
	Element currentScriptMessages = null;
	Element currentTestCaseStep = null;
	Element currentTestApplication = null;
	Element testSettings = null;
	Element testTarget = null;
	
	HashMap<String, Element> applicationMap = new HashMap<String, Element>();
	String logFileName = "";
	String logFolder = "";

	GenieResultType scriptResult = GenieResultType.STEP_FAILED;
	boolean bAnyTestResultAdded = false;
	private boolean isDebugMode = false;
	
	private int failureCounter = 0;
	private static boolean bLog = true;

	//========================================================================================
	// Some Constants defining various behaviors of Script Log
	//========================================================================================
	

	//========================================================================================
	// Some Methods which Makes this Class as Singleton as well as for instantiation
	//========================================================================================
	
	private static ScriptLog instance = null;
	
    public static ScriptLog getInstance(String logFolder, String className, boolean bLogArg) {
	     if(instance == null) {
	        try {
	        	bLog = bLogArg;
				instance = new ScriptLog(logFolder, className);
			} catch (Exception e) {
				return null;
			}
	     }
	     return instance;
	}
    
  //Create initial logging info
	public boolean startLogAndConnectToServer(SynchronizedSocket synchSocket, String className, long scriptStartTime)
	{
		String versions = synchSocket.getAllVersions();
		String pluginVersion = Utils.getTagValue(versions, "PluginVersion");
		String serverVersion = Utils.getTagValue(versions, "ServerVersion");
		String executorVersion = Utils.getTagValue(versions, "ExecutorVersion");
		String preloadVersion = Utils.getTagValue(versions, "PreloadVersion");
		addTestEnvMachineInfo(serverVersion,executorVersion,pluginVersion,preloadVersion);
		addTestScriptInfo(className);
		
		updateScriptStartTime(scriptStartTime);
		
		addTestStep("ConnectToServer", GenieStepType.STEP_CONNECTION_TYPE, "Application");
		if(synchSocket.getSWFList() == null)
		{
			addTestStepMessage("Unable to Connect to Server! Aborting...", GenieMessageType.MESSAGE_ERROR);
			addTestStepResult(GenieResultType.STEP_FAILED);
			return false;
		}
		else
		{
			addTestStepResult(GenieResultType.STEP_PASSED);
		}
		return true;
	}
    
    // This Assumes that Script Log has been successfully Instantiated
    public static ScriptLog getInstance() {
	     return instance;
	}
    
    // dispose object of singleton class so that it can be freshly instantiated
    public void dispose() {
	    this.logFolder = ""; 
	    this.logFileName = "";
    	instance = null;
	}
    
    /* 
     * Instantiate the ScriptLog 
     */
	private ScriptLog(String logFolder, String className) throws Exception
	{
		try
		{
			if(bLog)
			{
				this.logFolder = logFolder;
				this.initScriptLogs(logFolder, className);
			}
		}
		catch (Exception e) 
		{
			Utils.printErrorOnConsole("ScriptLog Class: Exception Occurred while instantiating ScriptLog");
			if (isDebugMode) 
				e.printStackTrace();
			else 
				Utils.printErrorOnConsole(e.getMessage());
			throw new Exception(e);
		}
	}
	
	private void initScriptLogs(String logFolder, String className) throws Exception
	{
		if(!bLog)
			return ;
			DocumentBuilder dbOutput;
			DocumentBuilderFactory dbfOutout;
			Document outputDoc = null;
			dbfOutout = DocumentBuilderFactory.newInstance();                    
			dbOutput = dbfOutout.newDocumentBuilder();    
			outputDoc =  dbOutput.newDocument();

			testLogNode = (Element) outputDoc.createElement("TestLog");
			outputDoc.appendChild(testLogNode);
			scriptStartTime = System.currentTimeMillis();

			//Add Information related to XSL Transformation in the generated XML
			Node pi = outputDoc.createProcessingInstruction
	         ("xml-stylesheet", "type=\"text/xsl\" href=\"HTMLLog.xsl\"");
			outputDoc.insertBefore(pi, testLogNode);
			
			this.logFileName = className.split("\\.")[0] + "_GenieSessionLog" + ".xml";
			
			try{
			//Deletes the existing File first before writing a new one
			boolean b=true;	
			File f = new File(this.logFolder + File.separator + this.logFileName);
			if (f.exists())
				b=f.delete();
			if(!b)
				throw new Exception("Deletion of a old log file failed in SuiteLog.consolidateSuiteLog");
			}catch (Exception e) {
		    	Utils.printErrorOnConsole("Exception occured:"+e.getMessage());
		    }
			
			writeLogToFile();
			
			//Dump the XSL and image in the same Log Folder
			try
		    {
				InputStream isImage = null;
				InputStream isXSL = null;
				isImage = getClass().getClassLoader().getResourceAsStream("assets/GenieImage.png");
				isXSL = getClass().getClassLoader().getResourceAsStream("assets/HTMLLog.xsl");

				byte[] buffer = new byte[8 * 1024];

				OutputStream fImg = new FileOutputStream(this.logFolder+"/GenieImage.png");
				try {
					int bytesRead;
					while ((bytesRead = isImage.read(buffer)) != -1) {
						fImg.write(buffer, 0, bytesRead);
					}
				} finally {
					fImg.close();
					isImage.close();
				}
				buffer = new byte[8 * 1024];
				
				OutputStream fXsl = new FileOutputStream(this.logFolder+"/HTMLLog.xsl");
				try {
					int bytesRead;
					while ((bytesRead = isXSL.read(buffer)) != -1) {
						fXsl.write(buffer, 0, bytesRead);
					}
				} finally {
					fXsl.close();
					isXSL.close();
				}
		    }
		    catch (IOException e){
		    	Utils.printErrorOnConsole("ScriptLog Class: Exception Occurred while copying assets to ScriptLog");
				if (isDebugMode) 
					e.printStackTrace();
				else 
					Utils.printErrorOnConsole(e.getMessage());
				throw new Exception(e);
		    }
			
		 
	}
	
	/**
	 *	Make this Class object aware if extra debug info is ON 
	 */
	public void setDebugMode(boolean mode){
		isDebugMode = mode;
	}
	
	/**
	 * Returns the current Folder Path where Log files needs to be placed
	 */
	public String getLogFolderPath(){
		return this.logFolder;
	}
	
	/**
	 * Returns the current File name of Log file
	 */
	public String getLogFileName(){
		return this.logFileName;
	}
	
	/**
	 *	Returns the current value of Failure Counter 
	 */
	public int getFailureCounter(){
		return this.failureCounter;
	}
	
	/**
	 *	Increment the failure Counter Number by 1 
	 */
	public void incrementFailureCounter(){
		this.failureCounter = this.failureCounter + 1;
	}
	
	//========================================================================================
	// Some Methods which construct the Basic Log Schema and feed in Environment Info
	//========================================================================================
	
	/**
	 * Add the Test Environment Setup to Script Log along with versions of Genie Components
	 * 
	 * @param serverVersion
	 * 			Version Of Server
	 * 
	 * @param executorVersion
	 * 			Version of Executor
	 * 	
	 * @param pluginVersion
	 * 			Version of Plugin
	 * 
	 * @param preloadVersion
	 * 			Version of Preload
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestEnvMachineInfo(String serverVersion,String executorVersion, String pluginVersion, String preloadVersion)
	{
		if(!bLog)
			return true;
		try{
			testSettings = createElement((Element)testLogNode, "TestSettings", null);
			Element testEnvironmentNode = createElement(testSettings, "TestEnvironment",null);
			Element testMachineNode = createElement(testEnvironmentNode, "TestMachine",null);
			
			try{
				OperatingSystemMXBean mxbean = (OperatingSystemMXBean)  ManagementFactory.getOperatingSystemMXBean();
				testMachineNode.setAttribute("availableMemory" , ""+ mxbean.getFreePhysicalMemorySize()/(1024*1024) + " MB");
				testMachineNode.setAttribute("physicalMemory" , ""+ mxbean.getTotalPhysicalMemorySize()/(1024*1024) + " MB");
				testMachineNode.setAttribute("processsorCount" , ""+ mxbean.getAvailableProcessors());
			}
			
			catch (Exception e) {
				testMachineNode.setAttribute("availableMemoryJVM" , ""+ Runtime.getRuntime().freeMemory()/(1024) + " KB");
				testMachineNode.setAttribute("totalMemoryJVM" , ""+ Runtime.getRuntime().totalMemory()/(1024)  + " KB");
			}
			testMachineNode.setAttribute("osArchitecture" , "" + System.getProperty("os.arch"));
			//testMachineNode.setAttribute("osArchitecture" , "" + System.getProperty("os.arch").toString());
			
			
			Element testSetupNode = createElement(testMachineNode, "TestSetup",null);
			testSetupNode.setAttribute("platform", System.getProperty("sun.desktop"));
			testSetupNode.setAttribute("os", System.getProperty("os.name"));
			testSetupNode.setAttribute("osVersion", System.getProperty("os.version"));
			testSetupNode.setAttribute("locale", System.getProperty("user.language"));
			testSetupNode.setAttribute("userTimezone", System.getProperty("user.timezone"));
			
			Element javaSetupNode = createElement(testMachineNode, "JavaSetup",null);
			javaSetupNode.setAttribute("javaVersion", System.getProperty("java.version"));
			javaSetupNode.setAttribute("javaRuntimeVersion", System.getProperty("java.runtime.version"));
			
			Element genieVersion = createElement(testEnvironmentNode, "GenieVersionInfo",null);
			createElement(genieVersion, "ServerVersion",serverVersion);
			createElement(genieVersion, "ExecutorVersion",executorVersion);
			createElement(genieVersion, "PluginVersion",pluginVersion);
					
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestEnvMachineInfo: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Updates Build number of the application in Product tag
	 * 
	 * @param appName
	 * 			Name of Application
	 * 
	 * @param buildNumber
	 * 			Build Number of Application
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean setAppBuildNumber(String appName, String buildNumber)
	{
		if(!bLog)
			return true;
		try{
			Element appElement = applicationMap.get(appName);
			if(appElement != null)
			{
				NodeList productNodes = appElement.getElementsByTagName("Product");
				if(productNodes.getLength() == 1)
				{
					((Element)productNodes.item(0)).setAttribute("buildNumber", buildNumber);
				}
				else
					return false;
			}
			else
				return false;
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:setAppBuildNumber: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	/**
	 * Adds Information related to Application under Test to the Script Log
	 * 
	 * @param appName
	 * 			Name of Application
	 * 
	 * @param appVersion
	 * 			Version of Application
	 * 
	 * @param config
	 * 			Application Configuration
	 * 
	 * @param buildNumber
	 * 			Build Number of Application
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean addTestApplication(String appName, String appVersion, String config, String buildNumber)
	{
		if(!bLog)
			return true;
		try{
			if (testTarget == null)
			testTarget = createElement(testSettings, "TestTarget", null);
			Element testApplicationNode = createElement(testTarget, "TestApplication", null);
			currentTestApplication = testApplicationNode;
			Element productNode = createElement(testApplicationNode, "Product", null);
			productNode.setAttribute("name", appName);
			productNode.setAttribute("appVersion", appVersion);
			productNode.setAttribute("buildNumber", buildNumber);
			
			Element buildNode = createElement(testApplicationNode, "Build", null);
			buildNode.setAttribute("config", config);
			//buildNode.setAttribute("buildNumber", buildNumber);
			
			applicationMap.put(appName, currentTestApplication);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestApplication: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Adds Information related to Player, in which our Target SWF is loaded, in the
	 * Log File
	 * 
	 * @param playerType
	 * 			Type of Player (StandAlone, Plugin, Desktop etc)
	 * 
	 * @param playerVersion
	 * 			Version of Player
	 * 
	 * @param asVersion
	 * 			Version of ActionScript used by application
	 * 
	 * @param appDevice
	 * 			Object of Device on which SWF is running
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean addFlashInfo(String playerType,String playerVersion,String asVersion, String geniePreloadVersion, String preloadName, String preloadVersion)
	{
		if(!bLog)
			return true;
		try{
			Element flashPlayerInfo = createElement(currentTestApplication, "FlashPlayer", null);
			flashPlayerInfo.setAttribute("playerType", playerType);
			flashPlayerInfo.setAttribute("playerVersion", playerVersion);
			flashPlayerInfo.setAttribute("appActionScriptVersion", asVersion);
			flashPlayerInfo.setAttribute("swfLibVersion", geniePreloadVersion);
			flashPlayerInfo.setAttribute("swfLibName", preloadName);
			flashPlayerInfo.setAttribute("swfLibSDKVersion", preloadVersion);
						
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addFlashInfo: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	

	/**
	 * Creates the Basic Test Case and Test Script Tage of Script Log
	 * 
	 * @param scriptName
	 * 			Name of Script for which this Log is being Generated
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean addTestScriptInfo(String scriptName)
	{
		if(!bLog)
			return true;
		try{
			Element testCaseNode = createElement((Element)testLogNode, "TestCase", null);
			Element testScriptNode = createElement((Element)testCaseNode, "TestScript", null);
			testScriptNode.setAttribute("name", scriptName);
			
			currentScriptElement = testScriptNode;
			currentScriptMessages = createElement(currentScriptElement, "Messages", null);
			
			scriptEndTime = System.currentTimeMillis();
			addTestScriptResult(scriptResult);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestScriptInfo: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	//========================================================================================
	// Some Methods which are related to each Execution Step and are publicly exposed
	//========================================================================================

	/**
	 * Adds a Test Step to Script Log
	 * 
	 * @param name
	 * 			Name of Step
	 * 
	 * @param type
	 * 			Type of Step
	 * 
	 * @param controlName
	 * 			Control Name for which Step is fired
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestStep(String name, GenieStepType type, String controlName)
	{
		if(!bLog)
			return true;
		try{
			if (!controlName.equalsIgnoreCase("") && !(type.equals(GenieStepType.STEP_CUSTOM_TYPE))) {
				String msg = "Started operation: " + name;
				msg += ", On control: " + controlName;
				Utils.printMessageOnConsole(msg);
			}

			stepStartTime = System.currentTimeMillis();
			//stepStartTimeStr = getDateTimeString(stepStartTime);
			
			name = StringEscapeUtils.escapeXml(name);
			
			Element testStepNode = createElement(currentScriptElement, "TestStep", null);
			testStepNode.setAttribute("name", name);
			testStepNode.setAttribute("type", convertStepTypeToString(type));
			
			currentTestCaseStep = testStepNode;
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestStep: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Adds a Test Step to Script Log
	 * 
	 * @param name
	 * 			Name of Step
	 * 
	 * @param type
	 * 			Type of Step
	 * 
	 * @param controlName
	 * 			Control Name for which Step is fired
	 * 
	 * @return
	 * 		The XML Element of the current added Step
	 */
	public GenieStepObject addAndReturnTestStep(String name, GenieStepType type, String controlName)
	{
		GenieStepObject objStep = new GenieStepObject();
		boolean result = addTestStep(name,type,controlName);

		if (result){
			objStep.setTestStep(currentTestCaseStep);
			objStep.setStepStartTime(stepStartTime);
			objStep.setStepEndTime(stepEndTime);
			return objStep;
		}
		
		return null;
	}
	
	/**
	 * Adds a Parameter attribute for a Test Step
	 * 
	 * @param name
	 * 			Name of Parameter
	 * 
	 * @param type
	 * 			Type of Parameter
	 * 
	 * @param value
	 * 			Value of Parameter
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestStepParameter(String name, GenieParameterType type, String value)
	{
		if(!bLog)
			return true;
		try{
			name = StringEscapeUtils.escapeXml(name);
			value = StringEscapeUtils.escapeXml(value);
			
			Element testParamNode = createElement(currentTestCaseStep, "TestParameter", null);
			
			testParamNode.setAttribute("name", name);
			testParamNode.setAttribute("type", convertParamTypeToString(type));
			testParamNode.setAttribute("value", value);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestStepParameter: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Adds a Parameter attribute for a Test Step
	 * 
	 * @param name
	 * 			Name of Parameter
	 * 
	 * @param type
	 * 			Type of Parameter
	 * 
	 * @param value
	 * 			Value of Parameter
	 * 
	 * @param objStep
	 * 			Reference of Current Step
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestStepParameter(String name, GenieParameterType type, String value, GenieStepObject objStep)
	{
		if(!bLog)
			return true;
		if (objStep != null){
			currentTestCaseStep = objStep.getTestStep();
			stepStartTime = objStep.getStepStartTime();
			stepEndTime = objStep.getStepEndTime();
			
			boolean result = addTestStepParameter(name,type,value);
			
			if (result)
				return true;
			else
				return false;
		}
		return false;
	}
	
	/**
	 * Adds a Test Step Level Message Element
	 * 
	 * @param message
	 * 			Message to be Added
	 * 
	 * @param type
	 * 			Type Of Message
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestStepMessage(String message, GenieMessageType type)
	{
		if(!bLog)
			return true;
		try{
			message = StringEscapeUtils.escapeXml(message);
			
			Element testMessage = createElement(currentTestCaseStep, "Message", null);
			testMessage.setAttribute("message", message);
			testMessage.setAttribute("type", convertMessageTypeToString(type));
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestStepMessage: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Adds a Test Step Level Message Element
	 * 
	 * @param message
	 * 			Message to be Added
	 * 
	 * @param type
	 * 			Type Of Message
	 * 
	 * @param objStep
	 * 			Reference of Current Step
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addTestStepMessage(String message, GenieMessageType type, GenieStepObject objStep)
	{
		if(!bLog)
			return true;
		if (objStep != null){
			currentTestCaseStep = objStep.getTestStep();
			stepStartTime = objStep.getStepStartTime();
			stepEndTime = objStep.getStepEndTime();
			
			boolean result = addTestStepMessage(message,type);
			
			if (result)
				return true;
			else
				return false;
		}
		return false;
	}
	
	/**
	 * Adds a Result to the created Test Step
	 * 
	 * @param status
	 * 			Status of Result
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean addTestStepResult(GenieResultType status)
	{
		if(!bLog)
			return true;
		try{
			//If a Result is already present in a step then don't add another one
			if (currentTestCaseStep.hasChildNodes()){
				NodeList nodes = currentTestCaseStep.getElementsByTagName("TestResults");
				if (nodes.getLength()>0){
					addTestStepMessage("A Result is already added for this Step. Skiping the duplicate result addition", GenieMessageType.MESSAGE_ERROR);
					return false;
					
//					[Piyush] This code was originally removing old step and overwriting with new one
//					But now we are now skipping new result addition and instead keeping the first added result
//					Fixed Bug #2909668					
//					Element oldNode = (Element) currentTestCaseStep.getElementsByTagName("TestResults").item(0);
//					currentTestCaseStep.removeChild(oldNode);
				}
			}
			
			stepEndTime = System.currentTimeMillis();
			long duration = stepEndTime - stepStartTime;
			
			String startTime = getDateTimeString(stepStartTime);
			String endTime = getDateTimeString(stepEndTime);
			

			Element testResult = createElement(currentTestCaseStep, "TestResults", null);
			testResult.setAttribute("status", convertResultTypeToString(status));
			
			Element testTimeNode = createElement((Element)testResult, "TestTime", null);
			testTimeNode.setAttribute("duration", formatTime(duration) + "");
			
			if(scriptStartTime == 0)
				scriptStartTime = stepStartTime;

			scriptEndTime = stepEndTime;
			testDuration = scriptEndTime - scriptStartTime;
			
			testTimeNode.setAttribute("start", startTime);
			testTimeNode.setAttribute("end", endTime);
			
			//[Piyush] Now I have initialized the Script Result to failed so this kind of check is required
			// In this case if we have previously added any result then we should consider the older
			// Script Result, but if it is first result then step result should be equal to script result
			// This will take care of scenarios where due to any situation the script is over
			// With any step being executed and will now appropriately be marked fail instead of Pass
			if (!bAnyTestResultAdded){
				if(status.equals(GenieResultType.STEP_PASSED))
					scriptResult = GenieResultType.STEP_PASSED;
				else
					scriptResult = GenieResultType.STEP_FAILED;
			}
			else{
				if(status.equals(GenieResultType.STEP_PASSED) && scriptResult.equals(GenieResultType.STEP_PASSED))
					scriptResult = GenieResultType.STEP_PASSED;
				else
					scriptResult = GenieResultType.STEP_FAILED;
			}
			// Set this variable so that in future results script result is also considered with Step result
			bAnyTestResultAdded = true;
			
			addTestScriptResult(scriptResult);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestStepResult: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	/**
	 * Adds a Result to the created Test Step
	 * 
	 * @param status
	 * 			Status of Result
	 * 
	 * @param objStep
	 * 			Reference of Current Step
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean addTestStepResult(GenieResultType status, GenieStepObject objStep)
	{
		if(!bLog)
			return true;
		if (objStep != null){
			currentTestCaseStep = objStep.getTestStep();
			stepStartTime = objStep.getStepStartTime();
			stepEndTime = objStep.getStepEndTime();
			
			boolean result = addTestStepResult(status);
			
			if (result)
				return true;
			else
				return false;
		}
		return false;
	}
	
	/**
	 * Adds a Script Level Message Element
	 * 
	 * @param message
	 * 			Message to be Added
	 * 
	 * @param type
	 * 			Type Of Message
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	public boolean addMessage(String message, GenieMessageType type)
	{
		if(!bLog)
			return true;
		try{
			if (currentScriptMessages == null){
				currentScriptMessages = createElement((Element)testLogNode, "Messages", null);
			}
			Element testMessage = createElement(currentScriptMessages, "Message", null);
			testMessage.setAttribute("message", message);
			testMessage.setAttribute("type", convertMessageTypeToString(type));

			scriptEndTime = System.currentTimeMillis();
			addTestScriptResult(scriptResult);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addMessage: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}

	/**
	 * Sets the End time to be marked in Script Log when Script actually ends
	 * 
	 * @param endTime
	 * 			EndTime of Script as received from System.currentTimeMillis()
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean setScriptEndTime(long endTime)
	{
		if(!bLog)
			return true;
		try{
			scriptEndTime = endTime;
			addTestScriptResult(scriptResult);
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:setScriptEndTime: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}

	/**
	 * The primary intention of this function is to reset the Script Start time once the
	 * actual Script Execution starts. Right now Start time is initialized when the ScriptLog
	 * is instantiated, but the actual script starts only before the start method of Genie Script 
	 * is called up. The time between instantiating and actual script starting is consumed by Executor
	 * in processing which we don't want to account in while writing in Script Log
	 * 
	 * This will also ensure that total time shown on console as well as script log matches
	 * 
	 * @param ActualStartTime
	 * 			The Actual Start Time of Script
	 */
	public void updateScriptStartTime(long ActualStartTime){
		scriptStartTime = ActualStartTime;
	}
	
	/**
	 * Helper method to format a long time to a valid user readable format
	 * @param t
	 * 		Time as long
	 * @return
	 * 		User readable String depicting time
	 */
	public String formatTime(long t) {
		long hours = t / 1000 / 60 / 60;
		long minutes = (t / 1000 / 60) % 60;
		long seconds = (t / 1000) % 60;
		long milliseconds = (t) % 60;
		return (hours > 9 ? hours + "" : "0" + hours) + ":" + (minutes > 9 ? minutes + "" : "0" + minutes) + ":" + (seconds > 9 ? seconds + "" : "0" + seconds)+ "." + (milliseconds > 9 ? milliseconds + "" : "0" + milliseconds);
	}
	
	/**
	 * Convert the Final Result Log to an HTMl format as well
	 */
	public void convertFinalLogToHTML(){
		if(!bLog)
			return;
		//Trying to convert the final XML in in actual HTML
		try {
			TransformerFactory tFactory = TransformerFactory.newInstance();
		    Transformer transformer = tFactory.newTransformer (new javax.xml.transform.stream.StreamSource(this.logFolder+"/HTMLLog.xsl"));

		    String sHTMLFileName = this.logFolder + File.separator + this.logFileName.split("\\.")[0] + ".html";

		    try{
		    	File fHTML = new File(sHTMLFileName); 
		    	boolean b=true;
		    if (fHTML.exists())
		    	b=fHTML.delete();
		    if(!b)
		    	throw new Exception("Deletion of a file failed in ScriptLog.convertFinalLogToHTML");
		    }catch (Exception e) {
		    	Utils.printErrorOnConsole("Exception occured:"+e.getMessage());
		    }
		    
		    transformer.transform
		      (new javax.xml.transform.stream.StreamSource
		            (this.logFolder + File.separator + this.logFileName),
		       new javax.xml.transform.stream.StreamResult
		            ( new FileOutputStream(sHTMLFileName)));
			
		    //Replace the local GenieImage reference to one hosted on Web
//		    try{
//				String sHTMLContent = Utils.readFileAsString(sHTMLFileName);
//				String replacedHTMLString = sHTMLContent.replaceAll("GenieImage.png","http://toolbase.corp.adobe.com/GenieAssets/GenieImage.png");
//				Utils.witeStringAsFile(replacedHTMLString,sHTMLFileName);
//			} catch (Exception e){
//				StaticFlags sf = StaticFlags.getInstance();					
//				sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
//			}
		  }
		  catch (Exception e) {
			  if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:convertFinalLogToHTML: " + e.getMessage());
				e.printStackTrace();
			  }
		  }
//		System.clearProperty("javax.xml.transform.TransformerFactory");
	}
	//========================================================================================
	// Local method to add result of complete Script
	//========================================================================================

	/**
	 * Adds (or Updates) the Current Script Result to show net result
	 */
	boolean addTestScriptResult(GenieResultType status)
	{
		try{
			Element testResult = null;
			if(currentScriptResult == null || currentScriptResultTime == null)
			{
				testResult = createElement(currentScriptElement, "TestResults", null);
				currentScriptResult = testResult;
				Element testTimeNode = createElement((Element)currentScriptResult, "TestTime", null);
				currentScriptResultTime = testTimeNode;
			}
			
			testDuration = scriptEndTime - scriptStartTime;
			
			currentScriptResult.setAttribute("status", convertResultTypeToString(status));
			currentScriptResultTime.setAttribute("duration", formatTime(testDuration) + "");
			
			currentScriptResultTime.setAttribute("start", getDateTimeString(scriptStartTime));
			currentScriptResultTime.setAttribute("end", getDateTimeString(scriptEndTime));
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on ScriptLog:addTestScriptResult: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	//========================================================================================
	// Helper Functions to actually Construct the Log
	//========================================================================================
	
	private Element createElement(Element parentElement, String elementName, String elementValue) throws Exception
	{
		Element newElement = null;
		try{
			newElement = testLogNode.getOwnerDocument().createElement(elementName);
			if(elementValue != null){
				newElement.setTextContent(elementValue);
			}
			if(parentElement != null){
				parentElement.appendChild(newElement);
			}
		}catch (Exception e) {
			Utils.printErrorOnConsole("ScriptLog Class: Exception Occurred while trying Create ScriptLog Element");
			Utils.printErrorOnConsole(e.getMessage());
			throw new Exception(e);
		}
		return newElement;
	}
	
	private void writeLogToFile() throws Exception
	{
		BufferedWriter out=null;
		try	{
			boolean b=true;
			if( !(new File(logFolder)).exists()){
				b=(new File(logFolder)).mkdirs();
			}
			if(!b)
				throw new Exception("Failed to create logfolder structure");
			
			out = new BufferedWriter(new FileWriter(logFolder + File.separator + logFileName , false));
			
			out.write(getStringFromDocument(testLogNode.getOwnerDocument()));
			out.newLine();
			out.flush();
		}
		catch (Exception e) {
			Utils.printErrorOnConsole("ScriptLog Class: Exception Occured while trying to write to log file");
	    	Utils.printErrorOnConsole(e.getMessage());
			throw new Exception(e);
		}
		finally{
			out.close();
	}
	
	}
	
	private String getStringFromDocument(Document doc) throws Exception
	{
	    try {
	       DOMSource domSource = new DOMSource(doc);
	       StringWriter writer = new StringWriter();
	       StreamResult result = new StreamResult(writer);
	       TransformerFactory tf = TransformerFactory.newInstance();
	       Transformer transformer = tf.newTransformer();
	       transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	       transformer.transform(domSource, result);
	       return writer.toString();
	    }
	    catch(TransformerException ex){
	    	Utils.printErrorOnConsole("ScriptLog Class: Execption Occurred while reading the Current In Memory Log File");
	    	Utils.printErrorOnConsole(ex.getMessage());
	    	throw new Exception(ex);
	    }
	}
	
	//========================================================================================
	// Helper Functions for Time Formatting
	//========================================================================================

	private String getDateTimeString(long time) {
		SimpleDateFormat fmt = new SimpleDateFormat();
		fmt.applyPattern("yyyy-MM-dd-HH:mm:ss");
		String dateTime = fmt.format(new Date(time));
		return dateTime;
	}
	
	/*private String getDateTimeStringForFolder(long time){
		SimpleDateFormat fmt = new SimpleDateFormat();
		fmt.applyPattern("yyyy_MM_dd_HH_mm_ss");
		String dateTime = fmt.format(new Date(time));
		return dateTime;
	}*/

	//========================================================================================
	// Helper Functions for converting Enums to String
	//========================================================================================

	// Return the Corresponding string of GenieResultType	
	private String convertResultTypeToString(GenieResultType type)
	{
		switch (type) {
			case STEP_PASSED:
				return "Passed";
				
			/*case STEP_FAILED:
				return	"Failed";*/
			
			default:
				return "Failed";
		}
	}

	// Return the Corresponding string of GenieStepType
	private String convertStepTypeToString(GenieStepType type)
	{
		switch (type) {
			case STEP_CONNECTION_TYPE:
				return "Connection";
				
			case STEP_NATIVE_TYPE:
				return	"NativeEvent";
	
			case STEP_UI_TYPE:
				return "UIEvent";
				
			case STEP_DEVICE_UI_TYPE:
				return "UIEventOnDevice";

			case STEP_FETCH_VALUE_TYPE:
				return	"FetchValue";
	
			case STEP_ASSERTION_TYPE:
				return	"Assertion";
				
			/*case STEP_CUSTOM_TYPE:
				return "CustomStep";*/
				
			default:
				return "CustomStep";
		}
	}

	// Return the Corresponding string of GenieMessageType
	private String convertMessageTypeToString(GenieMessageType type)
	{
		switch (type) {
			case MESSAGE_INFO:
				return "Info";
				
			case MESSAGE_ERROR:
				return	"Error";
	
			case MESSAGE_WAIT:
				return "Wait";
				
			case MESSAGE_EXCEPTION:
				return	"Exception";
	
			/*case MESSAGE_CUSTOM:
				return "Custom";*/
				
			default:
				return "Custom";
		}
	}
	
	// Return the Corresponding string of GenieParameterType
	private String convertParamTypeToString(GenieParameterType type)
	{
		switch (type) {
			case PARAM_INPUT:
				return "Input";
				
			case PARAM_OUTPUT:
				return	"Output";
	
			case PARAM_ATTRIBUTE:
				return "Attribute";
				
			default:
				return "Custom";
		}
	}
}


/*
 * [Piyush] These 2 methods are never Used, so commenting them out in case they are required
 * in future  
private String formatTime() {
	long t = System.currentTimeMillis();
	long hours = t / 1000 / 60 / 60;
	long minutes = (t / 1000 / 60) % 60;
	long seconds = (t / 1000) % 60;
	return (hours > 9 ? hours + "" : "0" + hours) + ":" + (minutes > 9 ? minutes + "" : "0" + minutes) + ":" + (seconds > 9 ? seconds + "" : "0" + seconds);
}

private double formatTimeSecondsOnly(long start_time) {
	long t = System.currentTimeMillis() - start_time;
	double seconds = (t / 1000.0);
	return seconds;
}*/

