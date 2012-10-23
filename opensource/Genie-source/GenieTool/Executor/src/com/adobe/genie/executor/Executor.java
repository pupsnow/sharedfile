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
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.executor.internalLog.SuiteLog;
import com.adobe.genie.executor.objects.GenieExecutionResult;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.GenieSuiteRecords;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;

/**
 * This is the main class which is run when executor application is started.
 * It takes Genie script file name as parameter and executes this script
 */
public class Executor {

	private static HandleCommandLine cmdLine;
	private static boolean isSuiteForExecution = false;
	private static String suiteLogFolder = "";
	private static boolean toBeAborted = false;
	private static String scriptlogFile = "";
	
	/**
	 * Main Entry point of Executor
	 * 
	 * @param 
	 * 		scriptName to execute
	 * 
	 * @throws ClassNotFoundException 
	 */
	public static void main(String[] args) throws ClassNotFoundException {
		//Execute the Script/Suite
		try{
			
			startExecution(args);
		}catch(Exception e)
		{
			Utils.printErrorOnConsole("Exception occurred: " + e.getMessage());
		}
		System.exit(0);
	}
	
	/**
	 * Alternate method of execution of Genie Script or Suite
	 * 
	 * @param args
	 * 		Arguments for Executor.jar
	 * 
	 * @return
	 * 		Result of Execution as GenieExecutionResult {@link com.adobe.genie.executor.objects.GenieExecutionResult}
	 * @throws ClassNotFoundException
	 */
	public static GenieExecutionResult startExecution(String[] args) throws ClassNotFoundException{
		GenieExecutionResult execResult = new GenieExecutionResult();
		
		//First Execute the main method
	    String scriptName = "";
	    String suitePath = "";
	    String subSuiteNames = "";
	    String logFolder = "";
	    String[] argsArray = null;
	    List<GenieSuiteRecords> suiteRecords = null;
	    
	    boolean isErrorOccurred = false;
	    String genieSuiteName = "";
	    
	    try{
	    	cmdLine = new HandleCommandLine(args);
	    	isErrorOccurred = cmdLine.isErrorOccurred();
	    	logFolder = cmdLine.getLogFolderName();
	    	suitePath = cmdLine.getSuiteStatus();
	    	
	    	if(logFolder == null || logFolder.length() == 0)
	    	{
	    		logFolder = Utils.getCurrentPath() + File.separator + "GenieLogs";
	    	}
	    	
	    	if (!suitePath.trim().equalsIgnoreCase("")){
	    		isSuiteForExecution = true;
	    	}
	    	if (isSuiteForExecution){
	    		subSuiteNames = cmdLine.getSubSuiteStatus();
	    		
	    		Utils.printMessageOnConsole("Validating if the input Suite XML is in valid format");
	    		genieSuiteName = isValidSuiteXML(suitePath);
	    		
	    		if (genieSuiteName.trim().equalsIgnoreCase("")){
	    			Utils.printErrorOnConsole("Genie Suite XML does not conform to DTD specifications, so it cannot be processes!!! Aborting Execution");
	    			isSuiteForExecution = false;
	    			toBeAborted = true;
	    		}
	    		else{
		    		suiteRecords = parseSuiteXML(suitePath, subSuiteNames);
		    		
		    		if (suiteRecords == null){
		    			Utils.printErrorOnConsole("Either the Suite XML is invalid or contains no Script entries!!! Aborting Execution");
		    			isSuiteForExecution = false;
		    			toBeAborted = true;
		    		}
	    		}
	    	}
	    	else{
	    		scriptName = cmdLine.getScriptName();
	    		argsArray = cmdLine.getCmdArguments();
	    	}

	    }
	    catch (Exception e){
	    	Utils.printErrorOnConsole("Error while parsing command line args!!!");
	    }
	    
	    //Initialize the counter for monitoring number of scripts to be executed
	    int scriptExecutionCounter = 0;
	    
	    //Check if Suite needs to be executed
	    if (isSuiteForExecution && !toBeAborted){
	    	Utils.printMessageOnConsole("Suite Execution Started");
	    	try {
	    		//Initialize Suite Log Structure
	    		initSuiteLogs(logFolder, genieSuiteName, Utils.getCurrentPath());
	    		SuiteLog.getInstance().setDebugMode(StaticFlags.getInstance().isdebugMode());
	    		
		    	for(int counter = 0 ; counter < suiteRecords.size();counter++){
		    		GenieSuiteRecords record = suiteRecords.get(counter);
		    		if (record.isSuiteToBeExecuted && record.isSuiteEnabled && record.isScriptEnabled){
		    			scriptExecutionCounter = scriptExecutionCounter + 1;
		    			record.scriptLogPath = executeSingleScript(record.scriptPath, record.scriptParams, logFolder, isErrorOccurred);
		    		}
		    	}
		    	//Pass the Record Structure for Final Consolidation of log Schema
		    	SuiteLog.getInstance().setSuiteRecordStructure(suiteRecords);
		    	SuiteLog.getInstance().consolidateSuiteLog();
		    	
		    	Utils.printMessageOnConsole("Suite Ended");
		    	Utils.printMessageOnConsole("Total Number of Scripts put through execution: " + scriptExecutionCounter);
			} catch (Exception e) {
				Utils.printErrorOnConsole("Unable to create Suite log structure!!! Aborting Execution");
			}
	    }
	    //If Standalone script needs to be executed
	    else if (!toBeAborted){
	    	if(scriptName != null && scriptName.length() > 0)
	    		executeSingleScript(scriptName, argsArray, logFolder, isErrorOccurred);
	    	else
	    		return execResult;
	    }
		
		//Parse the output to get the output and fill it in GenieExecutionResult object
		//If Suite was executed
		if (isSuiteForExecution && !toBeAborted && !cmdLine.isNoLogging()){
			File f = new File(SuiteLog.getInstance().getLogFolderPath() + File.separator + SuiteLog.getInstance().getLogFileName());
			if (f.exists()){
				try {
					String fileContent = Utils.readFileAsString(f.getAbsolutePath());
					execResult.setTestResultXML(fileContent);
					XmlDoc doc = new XmlDoc(fileContent);
					XmlNode scriptResult = doc.getNode("//TestSuiteLog/SuiteResult");
					if (scriptResult != null){
						String result = scriptResult.getAttributeValue("status");
						if (result.trim().toLowerCase().contains("pass"))
							execResult.setFinalResult(true);
					}
				} catch (Exception e) {
					Utils.printErrorOnConsole("Exception while reading the Log file to generate the final output");
					if (StaticFlags.getInstance().isdebugMode())
						e.printStackTrace();
					else
						Utils.printErrorOnConsole(e.getMessage());
				}
			}
		}
		//If Single Test case was Executed
		else if (!toBeAborted && !cmdLine.isNoLogging()){
			File f = new File(scriptlogFile);
			if (f.exists()){
				try {
					String fileContent = Utils.readFileAsString(f.getAbsolutePath());
					execResult.setTestResultXML(fileContent);
					XmlDoc doc = new XmlDoc(fileContent);
					XmlNode scriptResult = doc.getNode("//TestLog/TestCase/TestScript/TestResults");
					if (scriptResult != null){
						String result = scriptResult.getAttributeValue("status");
						if (result.trim().toLowerCase().contains("pass"))
							execResult.setFinalResult(true);
					}
				} catch (Exception e) {
					Utils.printErrorOnConsole("Exception while reading the Log file to generate the final output");
					if (StaticFlags.getInstance().isdebugMode())
						e.printStackTrace();
					else
						Utils.printErrorOnConsole(e.getMessage());
				}
			}
		}
		if(cmdLine.isNoLogging())
		{
			String result = "<TestLog><Messages><Message message=\"Script logging is switched off using command line param noLogging.\" type=\"Error\"/></Messages></TestLog>";
			execResult.setTestResultXML(result);
			execResult.setFinalResult(false);
		}
		
		//close socket so that socket thread gets closed.
		SynchronizedSocket.getInstance().dispose();
		return execResult;
	}
	
	//========================================================================================
	// Some private methods for initializing logs
	//========================================================================================
	
	// Initializes the Script log Instance
	private static void initLogs(String logFolder, String name, String currentDir) throws Exception
	{   boolean b=true;
		//Initialize Script log folder
		if(logFolder != null && logFolder.length()>0)
		{
			if(!isSuiteForExecution)
			{
				if(!cmdLine.isLogOverride())
				{
					if(!cmdLine.isLogNoTimeStampFolder())
						logFolder = logFolder + File.separator + name.split("\\.")[0] + "_" + Utils.getDateTimeStringForFolder(System.currentTimeMillis());
					else
					{
						logFolder = logFolder + File.separator + name.split("\\.")[0];
						Utils.deleteFile(logFolder);
						if( !(new File(logFolder)).exists()){
							b=(new File(logFolder)).mkdirs();
							if(!b)
								StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
						}
					}
				}
				else 
				{
					
					//deleteFile(logFolder);
					if( !(new File(logFolder)).exists()){
						b=(new File(logFolder)).mkdirs();
						if(!b)
							StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
					}
				}
			}
			else
			{
				if (suiteLogFolder.trim().equalsIgnoreCase(""))
					logFolder = logFolder + File.separator + name.split("\\.")[0] + "_" + Utils.getDateTimeStringForFolder(System.currentTimeMillis());
				else
					logFolder = suiteLogFolder + File.separator + name.split("\\.")[0] + "_" + Utils.getDateTimeStringForFolder(System.currentTimeMillis());
			}
			
			File userLogFolder = new File(logFolder);
			
			if(!cmdLine.isNoLogging())
				Utils.createParentDirRecursivelyIfNotExist(userLogFolder);
				
			if (ScriptLog.getInstance(logFolder, name, !cmdLine.isNoLogging()) == null)
				throw new Exception("Unable to Instantiate Script Log! Aborting...");
			
		}
		else
			throw new Exception("Unable to Instantiate Script Log! Aborting...");
	}
	
	// Initializes the Suite log Instance
	private static void initSuiteLogs(String logFolder, String name, String currentDir) throws Exception
	{
		boolean b=true;
		//Initialize Script log folder
		if(logFolder != null && logFolder.length()>0)
		{
			if(!cmdLine.isLogOverride())
			{
				if(!cmdLine.isLogNoTimeStampFolder())
					logFolder = logFolder + File.separator + "GenieSuite_" + name.split("\\.")[0] + "_" + Utils.getDateTimeStringForFolder(System.currentTimeMillis());
				else
				{
					logFolder = logFolder + File.separator + "GenieSuite_" + name.split("\\.")[0];
					Utils.deleteFile(logFolder);
					if( !(new File(logFolder)).exists()){
						b=(new File(logFolder)).mkdirs();
						if(!b)
							StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
					}
				}
			}
			else 
			{
				
				//deleteFile(logFolder);
				if( !(new File(logFolder)).exists()){
					b=(new File(logFolder)).mkdirs();
					if(!b)
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
					
				}
			}
			
			suiteLogFolder = logFolder;
			File userLogFolder = new File(logFolder);
			
			if(!cmdLine.isNoLogging())
				Utils.createParentDirRecursivelyIfNotExist(userLogFolder);
				
			if (SuiteLog.getInstance(logFolder, name, !cmdLine.isNoLogging()) == null)
				throw new Exception("Unable to Instantiate Suite Log! Aborting...");
			
		}
		else
			throw new Exception("Unable to Instantiate Suite Log! Aborting...");
	}	
	
	//========================================================================================
	// Some private methods for actually executing the Script
	//========================================================================================
	
	//Check if Server and Executor are Compatible
	public static boolean isCompat(CommandHandler ch) throws Exception
	{
		boolean isCompat = true;
		
		SynchronizedSocket synchSocket = SynchronizedSocket.getInstance(Utils.EXECUTOR_NAME_STR, ch);

		VersionHandler vH = VersionHandler.getInstance();
		String exVer = vH.getExecutorVersion();
		String versionReply = "";
		if(synchSocket != null)
		{
			if (!synchSocket.waitForSocketConnection())	{
				throw new Exception("Unable to Connect to Server! Aborting Script...");
			}
			
			//Check is Socket is closed due to any reason (most likely because another
			//executor is already running
			if (!synchSocket.isSocketClosed()){
				versionReply = synchSocket.getServerVersion(exVer);
				if (!vH.isReplyCompatible(versionReply))
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addMessage(vH.getErrorMessage(), GenieMessageType.MESSAGE_ERROR);
					
					Utils.printErrorOnConsole(vH.getErrorMessage());
					
					isCompat = false;
					synchSocket.close();
				}
				else{
					//Check perf flag
					StaticFlags sf = StaticFlags.getInstance();
					sf.setPerformanceTracking(synchSocket.isPerformanceTrackingEnabled());
				}
			}
			else
				return false;
		}
		else
			throw new Exception("Unable to get Instance of SocketServer! Aborting...");
		
		return isCompat;
	}
	
	//Execute One script at a time
	private static String executeSingleScript(String scriptName, String[] argsArray, String logFolder, boolean isErrorOccurred)
	{
		GenieScript script = null;
		boolean isCompatibile = false;
		boolean isSecondExecutorIssue = false;
		boolean isDelegateClassLoaded = true;
		boolean b=true;
		
		CommandHandler ch = new CommandHandler();
		File inProgressFile = null;
		
		String returnLogPath = "";
		
	    @SuppressWarnings("unused")
		Class<?> delegateClass = null;

		try {
			
			//Code to invoke main method of regular java class if it is passed to executor.
//			Class<?> cl1 = Shared.getClassFromFile(new File(scriptName), "");
//			if (GenieScript.class.isAssignableFrom(cl1))
//			{
//				System.out.println("I am genie script");
//			}
//			else
//			{
//				System.out.println("I am not genie script");
//				Constructor<?> c = cl1.getConstructor();
//				
//				//Invoke main
//				Class[] argTypes = new Class[] { String[].class };
//				String[] arr = {"acd"};
//			    Method main = cl1.getDeclaredMethod("main", argTypes);
//		  	    String[] mainArgs = Arrays.copyOfRange(arr, 1, arr.length);
//			    System.out.format("invoking %s.main()%n", c.getName());
//			    main.invoke(null, (Object)mainArgs);
//			    return "";
//			}
			
			if((!isErrorOccurred) && (scriptName != null) && (scriptName.length() > 0))
			{
				File f = new File(scriptName);
				f.getName();
				initLogs(logFolder, f.getName(), Utils.getCurrentPath());
				
				returnLogPath = ScriptLog.getInstance().getLogFolderPath()+ File.separator + ScriptLog.getInstance().getLogFileName();
				scriptlogFile = returnLogPath;
				
				//Started creating inProgress.txt at Executor location instead of log folder
				File executorJarFileLocation = new File(Executor.class.getProtectionDomain().getCodeSource().getLocation().toURI());
				String executorJarLocation = executorJarFileLocation.getCanonicalPath();
				String inProgressFilePath = executorJarLocation.substring(0,executorJarLocation.lastIndexOf(File.separator)) + File.separator + "inProgress.txt";
				
				//String inProgressFilePath = ScriptLog.getInstance().getLogFolderPath() + File.separator + "inProgress.txt";
				inProgressFile = new File(inProgressFilePath);
				b=inProgressFile.createNewFile();
				if(!b)
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
				
				isCompatibile = isCompat(ch);
				isSecondExecutorIssue = ch.isSecondExecutor();
				if (isSecondExecutorIssue)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addMessage("One execution is already running! Aborting...", GenieMessageType.MESSAGE_ERROR);
					Utils.printErrorOnConsole("One execution is already running! Aborting...");
				}
				
				// If Executor is compatible and it is not second Executor and Build is not expired
				if ( isCompatibile && !isSecondExecutorIssue)
				{
					// Pass on Debug Flag Information to ScriptLog instance
					ScriptLog.getInstance().setDebugMode(StaticFlags.getInstance().isdebugMode());
					if(new File(scriptName).exists())
					{
						//Loading custom delegate classes
						StaticFlags.getInstance().loadCustomDelegateClasses();
						
						//load Genie script. 
						Class<?> cl = Shared.getClassFromFile(new File(scriptName), "");
						if(cl == null)
						{
							Utils.printErrorOnConsole(scriptName + " Script class could not be loaded...Aborting...");
							ScriptLog scriptLog = ScriptLog.getInstance();
							scriptLog.addMessage(scriptName + " Script class could not be loaded...Aborting...", GenieMessageType.MESSAGE_ERROR);
						}
						else
						{
							if (GenieScript.class.isAssignableFrom(cl))
							{
								UsageMetricsData usage = UsageMetricsData.getInstance();
								if(isSuiteForExecution)
								{
									usage.addFeature("TestSuite");
								}
								if(cmdLine.isLaunchedWithRE())
								{
									usage.addFeature("RemoteExecutor");
								}
								
								Constructor<?> c = cl.getConstructor();
								script = (GenieScript) c.newInstance();
								if(script.getThread() != null)
								{
									//Set command line arguments in GenieScript if is length is greater than 1
									if(argsArray.length > 0 )
									script.cmdArguments = argsArray;
									//Start Executing Script on a new thread
									script.getThread().start();
									script.getThread().join();
								}
							}
							else
							{
								//Error
								Utils.printErrorOnConsole("Error not assignable!...");
								ScriptLog scriptLog = ScriptLog.getInstance();
								scriptLog.addMessage("Error not assignable!...", GenieMessageType.MESSAGE_ERROR);
							}
						}
					}
					else
					{
						Utils.printErrorOnConsole(scriptName + " Script class file not found...Aborting...");
						ScriptLog scriptLog = ScriptLog.getInstance();
						scriptLog.addMessage(scriptName + " Script class file not found...Aborting...", GenieMessageType.MESSAGE_ERROR);
					}				
				}
				
			}
		}catch (Exception e) {
			Utils.printErrorOnConsole(e.getMessage());
			ScriptLog scriptLog = ScriptLog.getInstance();
			scriptLog.addMessage(e.getMessage(), GenieMessageType.MESSAGE_ERROR);
		}
		finally{
			try{
				ScriptLog.getInstance().convertFinalLogToHTML();
							
				if((scriptName != null) && (scriptName.length() > 0) && 
						isCompatibile && !isSecondExecutorIssue && isDelegateClassLoaded)
				{
					Utils.printMessageOnConsole("Script ended");
				}
				if (inProgressFile != null)
				{
					if(inProgressFile.exists())
						b=inProgressFile.delete();
					if(!b)
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");
				}
			}catch (Exception e) {
				if (StaticFlags.getInstance().isdebugMode()){
					Utils.printErrorOnConsole("Exception Raised on Executor:executeSingleScript:Finally Block 1: " + e.getMessage());
					e.printStackTrace();
				}
			}
			
			try{
				//Dispose off singleton class objects
				//Suman: Stopped disposing SynchronizedSocket after every script execution. Now single socket remains open for the complete suite execution
				//SynchronizedSocket.getInstance().dispose();
				SynchronizedSocket.getInstance().resetResponseList();
				ScriptLog.getInstance().dispose();
				UsageMetricsData.getInstance().dispose();
				TestCaseClassLoader.getInstance("").dispose();
			}catch(Exception e){
				if (StaticFlags.getInstance().isdebugMode()){
					Utils.printErrorOnConsole("Exception Raised on Executor:executeSingleScript:Finally Block 2: " + e.getMessage());
					e.printStackTrace();
				}
			}
		}

		try {
			Thread.sleep(1000);
		} catch (InterruptedException e1) {}
		
		return returnLogPath;
	}
	
	//========================================================================================
	// Some private methods for processing Suite XML file
	//========================================================================================
	
	//Parses the SuiteXML file and fill the array list containing all the attributes for a script 
	// which are part of this Suite XML 
	private static List<GenieSuiteRecords> parseSuiteXML(String suiteXMLPath, String subSuiteNames){
		List<GenieSuiteRecords> suiteParsedRecords = new ArrayList<GenieSuiteRecords>();

		boolean bAllSuites = true;
		String[] subSuites = splitParams(subSuiteNames);
		
		if(!subSuites[0].equalsIgnoreCase("completeGenieSuite")){
			bAllSuites = false;
		}
		
		try {
			//Using factory get an instance of document builder
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			//Parse using builder to get DOM representation of the XML file
			Document dom = db.parse(suiteXMLPath);

			//get the root element
			Element docEle = dom.getDocumentElement();

			//get a node list of elements
			NodeList SuiteNodeList = docEle.getElementsByTagName("Suite");
			
			//Got the Suite Nodes. Lets traverse through each
			if(SuiteNodeList != null && SuiteNodeList.getLength() > 0) {
				for(int i = 0 ; i < SuiteNodeList.getLength();i++) {
					//get the Suite element
					Element SuiteEl = (Element)SuiteNodeList.item(i);
					
					String suiteName = "";
					String suiteDisabledTag = "";
					boolean isSuiteEnabled =true;
					boolean isSuiteToBeExecuted =false;

					suiteName = SuiteEl.getAttribute("name");
					suiteDisabledTag = SuiteEl.getAttribute("disabled");
					
					//Is the current Suite disabled for execution
					if (suiteDisabledTag.trim().equalsIgnoreCase("true")){
						isSuiteEnabled = false;
					}
					
					//Is this suite candidate of execution
					if (!bAllSuites){
						for(int counter = 0 ; counter < subSuites.length;counter++){
							if (subSuites[counter].trim().equalsIgnoreCase(suiteName.trim())){
								isSuiteToBeExecuted = true;
							}
						}
					}
					else
						isSuiteToBeExecuted = true;
					
					//In a Suite Element lets traverse for all Script elements
					NodeList scriptNodeList = SuiteEl.getElementsByTagName("Script");
					if(scriptNodeList != null && scriptNodeList.getLength() > 0) {
						for(int j = 0 ; j < scriptNodeList.getLength();j++) {

							String scriptPath ="";
							String scriptParams ="";
							String scriptDisabledTag = "";
							boolean isScriptEnabled =true;
							
							//get the Script element
							Element scriptEl = (Element)scriptNodeList.item(j);
							
							//Extract all elements of Script
							scriptPath = scriptEl.getAttribute("path"); 
							scriptParams = scriptEl.getAttribute("param");  
							scriptDisabledTag = scriptEl.getAttribute("disabled");  
							
							//Set Enability/disability of Script based on its own tag
							if (scriptDisabledTag.trim().equalsIgnoreCase("true")){
								isScriptEnabled = false;
							}
							
							//Set Enability/disability of Script based on its suites tag
							if (!isSuiteEnabled){
								isScriptEnabled = false;
							}
							
							//Create a new GenieSuite Record
							GenieSuiteRecords record = new GenieSuiteRecords();
							
							record.isScriptEnabled = isScriptEnabled;
							record.isSuiteEnabled = isSuiteEnabled;
							record.isSuiteToBeExecuted = isSuiteToBeExecuted;
							record.scriptPath = scriptPath;
							record.scriptParams = splitParams(scriptParams);
							record.suiteName = suiteName;
							record.scriptLogPath = "";
							
							File f = new File(scriptPath);
							record.className = f.getName().split("\\.")[0];
							
							//Add new record in collection
							suiteParsedRecords.add(record);
						}
					}
				}
			}
		}
		catch(RuntimeException e) {
			Utils.printErrorOnConsole("Runtime Exception occured Executor.executeSingleScript"+e.getMessage());
			e.printStackTrace();
			return null;
		}
		catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		return suiteParsedRecords;
	}
	
	//Flag to identify if XML has errors corresponding to schema
	static boolean dtdHasErrors = false;
	
	//Conform the provided Suite XML with a valid DTD
	//Also returns the Top level Suite name if it is valid else return blank
	private static String isValidSuiteXML(String suiteXMLPath){
		 boolean b=true;
		String inputXML = suiteXMLPath;
		String outputXML = System.getProperty("java.io.tmpdir") + File.separator + "tempSuiteXML.xml";
		
		File tempFile = new File(outputXML);
		if (tempFile.exists())
			b=tempFile.delete();
		if(!b && StaticFlags.getInstance().isdebugMode())
			Utils.printErrorOnConsole("Failed To Delete a File in function Executor.isValidSuiteXML");
		String genieSuiteName = "";

		try {
			//Extract the DTD out of JAR
			InputStream is = Executor.class.getClassLoader().getResourceAsStream("com/adobe/genie/executor/GenieSuite.dtd");
			byte[] buffer = new byte[8 * 1024];

			//File executorJarFileLocation = new File(Executor.class.getProtectionDomain().getCodeSource().getLocation().toURI());
			//String executorJarLocation = executorJarFileLocation.getCanonicalPath();
			String dtdFilePath;/* = executorJarLocation.substring(0,executorJarLocation.lastIndexOf(File.separator)) + File.separator + "GenieSuite.dtd"*/;
			dtdFilePath = System.getProperty("java.io.tmpdir") + File.separator + "GenieSuite.dtd";
			OutputStream fi = new FileOutputStream(dtdFilePath);
			try {
				int bytesRead;
				while ((bytesRead = is.read(buffer)) != -1) {
					fi.write(buffer, 0, bytesRead);
				}
			} finally {
				fi.close();
				is.close();
			}

			//Using factory get an instance of document builder
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			//ignore if any existing DTD is already attached to the XML
			db.setEntityResolver(new EntityResolver() {
				public InputSource resolveEntity(String publicId, String systemId)throws SAXException {
					if (systemId.contains(".dtd")) {
						return new InputSource(new StringReader(""));
					} else {
						return null;
					}
				}
			});

			//Attach the latest DTD to the Source File
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, dtdFilePath);
			
			DOMSource source = new DOMSource(db.parse(new FileInputStream(inputXML)));
			StreamResult result = new StreamResult(new FileOutputStream(outputXML));
			transformer.transform(source, result);
			
			//Now the XML is ready with DTD applied to it, its time to validate the XML
			
			//Set the Validation of Source DTD to true
			dbf.setValidating(true);
			db = dbf.newDocumentBuilder();
			
			//Set Error Checks
			db.setErrorHandler(new org.xml.sax.ErrorHandler() {
				//Ignore the fatal errors
				public void fatalError(SAXParseException err) throws SAXException { 
					Executor.dtdHasErrors = true;
					Utils.printErrorOnConsole("Warning at " +err.getLineNumber() + " line.");
					Utils.printErrorOnConsole(err.getMessage());
				}
	
				//Validation errors 
				public void error(SAXParseException err) throws SAXException {
					Executor.dtdHasErrors = true;
					Utils.printErrorOnConsole("Error at " +err.getLineNumber() + " line.");
					Utils.printErrorOnConsole(err.getMessage());
				 }
				//Show warnings
				public void warning(SAXParseException err)throws SAXException{}
			});			
			
			//Open the XML to validate against DTD
			Document xmlDocument = db.parse(new FileInputStream(outputXML));
			
			//If DTD has matched lets find the name attribute of GenieSuite
			if (!Executor.dtdHasErrors){
				Element docEle = xmlDocument.getDocumentElement();
				genieSuiteName = docEle.getAttribute("name");
			}

			//Validation has been performed... Lets clean up the mess
			
			//After Validation lets remove the attached DTD source
			dbf.setValidating(false);
			db = dbf.newDocumentBuilder();

			//Ignore if any existing DTD is already attached
			db.setEntityResolver(new EntityResolver() {
				public InputSource resolveEntity(String publicId, String systemId)throws SAXException {
					if (systemId.contains(".dtd")) {
						return new InputSource(new StringReader(""));
					} else {
						return null;
					}
				}
			});
			
			//Write back the XML without a DTD reference
			transformer = tf.newTransformer();
			source = new DOMSource(db.parse(new FileInputStream(outputXML)));
			result = new StreamResult(new FileOutputStream(outputXML));
			transformer.transform(source, result);
           
			//Delete the DTD extracted from JAR
			File dtd = new File(dtdFilePath);
			if(dtd.exists()) 
			   b=dtd.delete();
			if(!b)
				StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");

		}
		catch(RuntimeException e) {
			Utils.printErrorOnConsole("Runtime Exception occured in Executor.isValidSuiteXML"+e.getMessage());
			e.printStackTrace();
			return "";
		}
		catch(Exception e) {
			e.printStackTrace();
			return "";
		}
				
		if (tempFile.exists())
			b=tempFile.delete();
	    if(!b)
				StaticFlags.getInstance().printErrorOnConsoleDebugMode("Failed To delete a file in function Executor.initLogs");				
		return genieSuiteName;
	}
	
	
	//Split the parameters as provided in params tag
	//The format is [a,b,c d,e]
	private static String[] splitParams(String params){
		//Trim the Square brackets
		params = params.trim().replace("[", "").replace("]", "");
		String delimiter = ",";
		String[] temp = {};
		if(params.length() > 0)
		{
			temp = params.split(delimiter);
			//Trim White spaces from each parameter
			for(int i = 0 ; i < temp.length;i++){
				temp[i] = temp[i].trim();
			}
		}
		return temp;
	}
	
	
	
	
}
