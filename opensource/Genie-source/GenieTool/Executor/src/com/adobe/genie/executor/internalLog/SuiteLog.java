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
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.management.ManagementFactory;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.adobe.genie.utils.GenieSuiteRecords;
import com.adobe.genie.utils.XmlDoc;
import com.adobe.genie.utils.XmlNode;
import com.adobe.genie.utils.Utils;
import com.sun.management.OperatingSystemMXBean;

/**
 * This class contains all the methods and Constants that enables in writing a 
 * Suite Log. Its constructs the header, hierarchy, add test script and there results
 * as well as computes the net result of a Suite
 * 
 * @since Genie 0.11
 */
public class SuiteLog {
	//int errorCode = 0;
	//long testDuration = 0 ;
	
	List<GenieSuiteRecords> suiteRecords = null;
	//SCA
	//long suiteStartTime =0;
	//long suiteEndTime =0;
	
	DocumentBuilder dbOutput;
	DocumentBuilderFactory dbfOutout;
	Document outputDoc = null;

	Node testSuiteNode = null;
	Element testSettings = null;
	

	String logFileName = "";
	String logFolder = "";

	private boolean isDebugMode = false;
	private static boolean bLog = true;
	
	//========================================================================================
	// Some Constants defining various behaviors of Suite Log
	//========================================================================================
	

	//========================================================================================
	// Some Methods which Makes this Class as Singleton as well as for instantiation
	//========================================================================================
	
	private static SuiteLog instance = null;
	
    public  static SuiteLog getInstance(String logFolder, String className, Boolean bLogArg) {
	     if(instance == null) {
	        try {
	        	bLog = bLogArg;
	        	instance = new SuiteLog(logFolder, className);
			} catch (Exception e) {
				return null;
			}
	     }
	     return instance;
   }
    
    // This Assumes that Suite Log has been successfully Instantiated
    public static SuiteLog getInstance() {
	     return instance;
	}
    
    // dispose object of singleton class so that it can be freshly instantiated
    public  void dispose() {
	    this.logFolder = ""; 
	    this.logFileName = "";
    	instance = null;
	}
    
    /* 
     * Instantiate the SuiteLog 
     */
    private SuiteLog(String logFolder, String className) throws Exception
	{
		try
		{
			if(bLog)
			{
				this.logFolder = logFolder;
				this.initSuiteLogs(logFolder, className);
			}
		}
		catch (Exception e) 
		{
			Utils.printErrorOnConsole("SuiteLog Class: Exception Occurred while instantiating SuiteLog");
			if (isDebugMode) 
				e.printStackTrace();
			else 
				Utils.printErrorOnConsole(e.getMessage());
			throw new Exception(e);
		}
	}
	
	private void initSuiteLogs(String logFolder, String className) throws Exception
	{
		if(!bLog)
			return ;
			this.dbfOutout = DocumentBuilderFactory.newInstance();                    
			this.dbOutput = dbfOutout.newDocumentBuilder();    
			this.outputDoc =  dbOutput.newDocument();

			testSuiteNode = (Element) outputDoc.createElement("TestSuiteLog");
			outputDoc.appendChild(testSuiteNode);

			Element myRootNode = outputDoc.getDocumentElement();
			myRootNode.setAttribute("name", className.split("\\.")[0]);
			
			//suiteStartTime = System.currentTimeMillis();

			//Add Information related to XSL Transformation in the generated XML
			Node pi = outputDoc.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"HTMLSuiteLog.xsl\"");
			outputDoc.insertBefore(pi, testSuiteNode);
			
			this.logFileName = className.split("\\.")[0] + "_GenieSuiteLog" + ".xml";
			
			//Deletes the existing File first before writing a new one
			File f = new File(this.logFolder + File.separator + this.logFileName);
			try{
			boolean b=true;
			if (f.exists())
				b=f.delete();
			if (!b)
				throw new Exception("Dleletion of a old log file failed in SuiteLog.initSuiteLogs");
			}
			catch (Exception e) {
		    	Utils.printErrorOnConsole("Exception occured:"+e.getMessage());
		    }
			
			writeLogToFile();
			this.addTestEnvMachineInfo();
			
			//Dump the XSL and image in the same Log Folder
			try
		    {
				InputStream isImage = null;
				InputStream isXSL = null;
				isImage = getClass().getClassLoader().getResourceAsStream("assets/GenieImage.png");
				isXSL = getClass().getClassLoader().getResourceAsStream("assets/HTMLSuiteLog.xsl");

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
				
				OutputStream fXsl = new FileOutputStream(this.logFolder+"/HTMLSuiteLog.xsl");
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
		    	Utils.printErrorOnConsole("SuiteLog Class: Exception Occurred while copying assets to SuiteLog");
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
	 * Fill internal collection of SuiteRecord with one passed from Executor
	 */
	public void setSuiteRecordStructure(List<GenieSuiteRecords> suiteRecord){
		this.suiteRecords = suiteRecord;
	}
	
	//========================================================================================
	// Some Methods which construct the Basic Log Schema and feed in Environment Info
	//========================================================================================
	
	/**
	 * Add the Test Environment Setup to Suite Log along with versions of Genie Components
	 * 
	 * @return
	 * 		Boolean value indicating the result of Operation
	 */
	private boolean addTestEnvMachineInfo()
	{
		if(!bLog)
			return true;
		try{
			testSettings = createElement((Element)testSuiteNode, "SuiteSettings", null);
			Element testEnvironmentNode = createElement(testSettings, "SuiteEnvironment",null);
			Element testMachineNode = createElement(testEnvironmentNode, "TestMachine",null);
			
			try{
				OperatingSystemMXBean mxbean = (OperatingSystemMXBean)  ManagementFactory.getOperatingSystemMXBean();
				testMachineNode.setAttribute("availableMemory" , ""+ mxbean.getFreePhysicalMemorySize()/(1024*1024) + " MB");
				testMachineNode.setAttribute("physicalMemory" , ""+ mxbean.getTotalPhysicalMemorySize()/(1024*1024) + " MB");
				testMachineNode.setAttribute("processsorCount" , ""+ mxbean.getAvailableProcessors());
			}
			catch (RuntimeException e) {
				Utils.printErrorOnConsole("Runtime Exception occured in SuiteLog.addTestEnvMachineInfo"+e.getMessage());
				testMachineNode.setAttribute("availableMemoryJVM" , ""+ Runtime.getRuntime().freeMemory()/(1024) + " KB");
				testMachineNode.setAttribute("totalMemoryJVM" , ""+ Runtime.getRuntime().totalMemory()/(1024)  + " KB");
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
			
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on SuiteLog:addTestEnvMachineInfo: " + e.getMessage());
				e.printStackTrace();
			}
			return false;
		}
		return true;
	}
	
	//========================================================================================
	// Local method to add result of complete Suite
	//========================================================================================
	
	/**
	 * Consolidates the complete Suite log
	 * 
	 * @return
	 * 			Boolean value indicating the result of Operation
	 */
	public boolean consolidateSuiteLog()
	{
		if(!bLog)
			return true;
		try{
			//Get a list of all Suites
			ArrayList<String> strSuites = new ArrayList<String>();
			for(int counter = 0 ; counter < this.suiteRecords.size();counter++){
				GenieSuiteRecords record = suiteRecords.get(counter);

				if (!strSuites.contains(record.suiteName))
					strSuites.add(record.suiteName);
			}
			
			String fullSuiteResult = "Not Executed";
			
			Element GenieSuiteResult = createElement((Element)testSuiteNode, "SuiteResult", null);
			GenieSuiteResult.setAttribute("status", fullSuiteResult);
			
			//Segregate records into Suites
			for(int counter = 0 ; counter < strSuites.size();counter++){
				Element testSuite = createElement((Element)testSuiteNode, "Suite", null);
				testSuite.setAttribute("name" , strSuites.get(counter));
				
				String sSuiteResult = "Not Executed";
				Element suiteResult = createElement((Element)testSuite, "SuiteResult", null);
				suiteResult.setAttribute("status", sSuiteResult);
				
				//Traverse through all records and put them under appropriate suites
				for(int i = 0 ; i < this.suiteRecords.size();i++){
					GenieSuiteRecords record = this.suiteRecords.get(i);
					if (record.suiteName == strSuites.get(counter)){
						Element scriptResult = createElement((Element)testSuite, "ScriptResult", null);
						scriptResult.setAttribute("name", record.className);
						scriptResult.setAttribute("status", "Not Executed");
						scriptResult.setAttribute("link", "");
						
						if (record.isSuiteToBeExecuted){
							if (!record.isSuiteEnabled){
								suiteResult.removeAttribute("status");
								suiteResult.setAttribute("status", "Disabled");
							}

							if (!record.isScriptEnabled){
								scriptResult.removeAttribute("status");
								scriptResult.setAttribute("status", "Disabled");
							}
							else if(record.isSuiteEnabled && record.isScriptEnabled){
								//Parse the Script XML log
								String originalClassName = record.className;
								String linkName = record.suiteName + "_" + originalClassName;
								record = fillRecordValues(record);
								
								//Calculate the Net Result of each suite based on result of All Scripts and update the status
								if (record.scriptResult.trim().equalsIgnoreCase("Passed") && sSuiteResult.trim().equalsIgnoreCase("Not Executed")){
									sSuiteResult = record.scriptResult;
								}
								
								if (record.scriptResult.trim().equalsIgnoreCase("Failed")){
									sSuiteResult = record.scriptResult;
								}

								suiteResult.removeAttribute("status");
								suiteResult.setAttribute("status", sSuiteResult);

								// Set up value of each Script for Summary
								scriptResult.removeAttribute("status");
								scriptResult.setAttribute("status", record.scriptResult);
								
								if (!(record.scriptLogContent.trim().equals(""))){
									
									//Get the Test Node of the Script Log and put it in my Suite XML for full consolidation
									Element scriptTestNode = createElement((Element)testSuite, "TestNode", null);
									scriptTestNode.setAttribute("name", linkName);
									
									DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
									DocumentBuilder db = dbf.newDocumentBuilder();
									
									StringReader reader = new StringReader( record.scriptLogContent.trim() );
									InputSource inputSource = new InputSource(reader);
									
									Document dom = db.parse(inputSource);
									Element docEle = dom.getDocumentElement();

									//Get all nodes and insert it in Current Suite
									NodeList scriptLogNodes = docEle.getChildNodes();
									for(int j = 0 ; j < scriptLogNodes.getLength();j++) {
										Node testLogNode = scriptLogNodes.item(j);
										scriptTestNode.appendChild(this.outputDoc.importNode(testLogNode, true));
									}
									
									//Modify the link information to link to correct test node
									scriptResult.removeAttribute("link");
									scriptResult.setAttribute("link", linkName);
									
									//If I am able to read the class name from script Log I will use it instead of my own
									if (!(record.className.equals(originalClassName))){
										scriptResult.removeAttribute("name");
										scriptResult.setAttribute("name", record.className);
									}
								}
							}
						}
					}
				}
				
				//Calculate the Net Result based on result of All Suites and update the status
				if (sSuiteResult.trim().equalsIgnoreCase("Passed") && fullSuiteResult.trim().equalsIgnoreCase("Not Executed")){
					fullSuiteResult = sSuiteResult;
				}

				if (sSuiteResult.trim().equalsIgnoreCase("Failed")){
					fullSuiteResult = sSuiteResult;
				}

				GenieSuiteResult.removeAttribute("status");
				GenieSuiteResult.setAttribute("status", fullSuiteResult);
			}
			writeLogToFile();
		}catch (Exception e) {
			if (isDebugMode){
				Utils.printErrorOnConsole("Exception Raised on SuiteLog:consolidateSuiteLog: " + e.getMessage());
				e.printStackTrace();
			}
			else
				Utils.printErrorOnConsole("Exception Raised on SuiteLog:consolidateSuiteLog: " + e.getMessage());
			return false;
		}
		
		//Trying to convert the final XML in in actual HTML
		try {
			TransformerFactory tFactory = TransformerFactory.newInstance();
		    Transformer transformer = tFactory.newTransformer (new javax.xml.transform.stream.StreamSource(this.logFolder+"/HTMLSuiteLog.xsl"));

		    String sHTMLFileName = logFolder + File.separator + logFileName.split("\\.")[0] + ".html";

		    try{
		    	boolean b=true;
		    	File fHTML = new File(sHTMLFileName); 
		    if (fHTML.exists())
		    	b=fHTML.delete();
		    if(!b)
				throw new Exception("Deletion of a file failed in");
		    }catch (Exception e) {}
		    
		    transformer.transform
		      (new javax.xml.transform.stream.StreamSource
		            (logFolder + File.separator + logFileName),
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
					Utils.printErrorOnConsole("Exception Raised on SuiteLog:consolidateSuiteLog: Generating HTML:  " + e.getMessage());
					e.printStackTrace();
			  }
		  }
//		System.clearProperty("javax.xml.transform.TransformerFactory");
		return true;
	}

	
	//Parse the Script Log and fill the remaining values in record
	private GenieSuiteRecords fillRecordValues(GenieSuiteRecords record){
		if (record.scriptLogPath.trim().equals("")){
			record.scriptResult = "Failed";
		}
		else{
			File scriptLogPath = new File(record.scriptLogPath.trim());
			if (scriptLogPath.exists()){
				try {
					String fileContent = Utils.readFileAsString(record.scriptLogPath.trim());
					XmlDoc doc = new XmlDoc(fileContent);
					
					XmlNode scriptName = doc.getNode("//TestLog/TestCase/TestScript");
					if (scriptName != null){
						record.className = scriptName.getAttributeValue("name").split("\\.java")[0];
					}
					
					XmlNode scriptResult = doc.getNode("//TestLog/TestCase/TestScript/TestResults");
					record.scriptResult = "Failed";
					if (scriptResult != null){
						record.scriptResult = scriptResult.getAttributeValue("status");
						
						//Get Time spent by Script
						XmlNode scriptDuration = doc.getNode("//TestLog/TestCase/TestScript/TestResults/TestTime");
						if (scriptDuration != null){
							record.scriptDuration = scriptDuration.getAttributeValue("duration");
						}
						else
							record.scriptDuration = "00:00:00.0";
					}
					else{
						record.scriptResult = "Failed";
					}
					
					XmlNode mainNode = doc.getNode("//TestLog");
					record.scriptLogContent = mainNode.toXMLString();
							
				} catch (Exception e) {
					record.scriptResult = "Failed";
					record.scriptDuration = "00:00:00.0";
					record.scriptLogContent = "";
				}
			}
			else
				record.scriptResult = "Failed";
		}
		
		return record;
	}
	
	//========================================================================================
	// Helper Functions to actually Construct the Log
	//========================================================================================
	
	private Element createElement(Element parentElement, String elementName, String elementValue) throws Exception
	{
		Element newElement = null;
		try{
			newElement = testSuiteNode.getOwnerDocument().createElement(elementName);
			if(elementValue != null){
				newElement.setTextContent(elementValue);
			}
			if(parentElement != null){
				parentElement.appendChild(newElement);
			}
		}catch (Exception e) {
			Utils.printErrorOnConsole("SuiteLog Class: Exception Occurred while trying Create SuiteLog Element");
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
			  if(!b)
				  throw new Exception("Failed to create log folder structure in SuiteLog.writeLogToFile");
			}
			
			out = new BufferedWriter(new FileWriter(logFolder + File.separator + logFileName , false));
			
			out.write(getStringFromDocument(testSuiteNode.getOwnerDocument()));
			out.newLine();
			out.flush();
		}
		catch (Exception e) {
			Utils.printErrorOnConsole("SuiteLog Class: Exception Occured while trying to write to log file");
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
	    	Utils.printErrorOnConsole("SuiteLog Class: Execption Occurred while reading the Current In Memory Log File");
	    	Utils.printErrorOnConsole(ex.getMessage());
	    	throw new Exception(ex);
	    }
	}
}
