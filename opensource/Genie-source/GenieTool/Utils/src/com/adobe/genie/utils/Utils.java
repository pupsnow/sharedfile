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
package com.adobe.genie.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecuteResultHandler;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.Executor;
import org.apache.commons.exec.PumpStreamHandler;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Helper methods to be used throughout Genie Java projects
 * All are static methods and to be used directly with Class
 * This class is not for any instantiation
 * 
 * @since Genie 0.4
 */
public class Utils {
	//Name of Components to be used for Communication
	public static String PLUGIN_NAME_STR = "GENIE_COMPONENT_ECLIPSE_PLUGIN__64357";
	public static String EXECUTOR_NAME_STR = "GENIE_COMPONENT_EXECUTOR_PLAYBACK__64357";
	
	//Some performance feature tracking XML Tags
	public static String FEATURE_NAME = "FeatureName";
	public static String CONNECT_TO_SWF = "Connect2Swf";
	public static String TIME_TO_PLAY = "Time2Play";
	public static String TOTAL_TIME = "TotalTimeTaken";
	public static String APP_TREE_CREATION_TIME = "AppTreeCreationTime";
	public static String APP_NAME = "AppName";
	public static String START_TIME = "StartTime";
	public static String END_TIME = "EndTime";
	public static String CURRENT_TIME = "CurrentTime";
	public static String PRELOAD_MESSAGE = "Message";
	
	//Error message when UI rainbow rectangle not visible, but swf is actually running
	public static String UI_ICON_NOT_VISIBLE_MESSAGE = "Unable to find UI Icon. Seems Application SWF not visible on screen!";
	
	//Error message when we do not get any result from the device controller
	public static String NO_RESPONSE_FROM_DEVICE_CONTROLLER = "There Was No Response From The Device Controller,Cannot Perform Click";
	
	//Error message to use in UI actions related to devices
	public static String DESKTOP_ONLY_UI_ACTION = "This UI Action Is Only Valid For Desktops";
	//Error mesasge when executor is running, and swf is not running
	public static String SWF_NOT_PRESENT = "Swf Not Present";
	
	//========================================================================================
	// Helper methods related to XML Processing
	//========================================================================================
	
	/**
	 * Converts an XML doc to a String
	 */
	public static String getStringFromDocument(Node doc) throws Exception
	{
       DOMSource domSource = new DOMSource(doc);
       StringWriter writer = new StringWriter();
       StreamResult result = new StreamResult(writer);
       TransformerFactory tf = TransformerFactory.newInstance();
       Transformer transformer = tf.newTransformer();
       transformer.transform(domSource, result);
       return writer.toString();
	}
	
	/**
	 * Converts a string to a XML Doc object 
	 */
	public static Document getXMLDocFromString(String input)
	{
		Document doc = null;
		try	{
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			doc = db.parse(new InputSource(new StringReader(input)));
			doc.getDocumentElement().normalize();
		}
		catch(Exception e){
			//e.printStackTrace();
			doc = null;
		}
		
		return doc;
	}
	
	/**
	 * Validates if a given XML provided as string conforms to a Schema provide as filename 
	 */
	public static boolean validateXML(String strXML,String schemaFileName) throws Exception
	{
		try{
			DocumentBuilder parser = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		    Document document = parser.parse(new java.io.ByteArrayInputStream(strXML.getBytes("UTF-8")));
	
		    // create a SchemaFactory capable of understanding WXS schemas
		    SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
	
		    // load a WXS schema, represented by a Schema instance
		    Source schemaFile = new StreamSource(new File(schemaFileName));
		    Schema schema = factory.newSchema(schemaFile);
	
		    // create a Validator instance, which can be used to validate an instance document
		    Validator validator = schema.newValidator();
	
		    // validate the DOM tree
		    try {
		        validator.validate(new DOMSource(document));
		    } catch (SAXException e) {
		       throw e;
		    }
		} catch(Exception e){
			throw e;
		}
		
		return true;
	}
	
	//========================================================================================
	// Helper methods related to Streams
	//========================================================================================
	
	/**
	 * Converts an XML provide as String to an inputStream
	 */
	public static InputStream parseStringToIS(String xml) throws Exception
	{
		if(xml==null) return null;
		xml = xml.trim();
		java.io.InputStream in = null;
		try{
			in = new java.io.ByteArrayInputStream(xml.getBytes("UTF-8"));
		}catch(Exception ex){
			throw ex;
		}
		
		return in;
	}

	/**
	 * Reads complete text from a file whose path is given as String 
	 */
	public static String getTextFromFile(String fileName)
	{
		StringBuilder contents = new StringBuilder();
		try	{
			File f = new File(fileName);
			BufferedReader input =  new BufferedReader(new FileReader(f));
	        String line = null;
	        while (( line = input.readLine()) != null){
	            contents.append(line);
	            contents.append(System.getProperty("line.separator"));
	        }
		}catch(Exception e){ return "";}
        
		return contents.toString();
	}
	
	/**
	 * Reads complete text from a file whose path is given as URL 
	 */
	public static String getTextFromURL(URL filePath)
	{
		StringBuilder contents = new StringBuilder();
		try	{
			InputStream is = filePath.openStream();
			BufferedReader input =new BufferedReader(new InputStreamReader(is));
	        String line = null;
	        while (( line = input.readLine()) != null){
	            contents.append(line);
	            contents.append(System.getProperty("line.separator"));
	        }
		}catch(Exception e){ return "";}
        
		return contents.toString();
	}
	
	//========================================================================================
	// Helper methods related to String manipulation
	//========================================================================================
	
	/**
	 * returns the string having double quotes escaped so that java code compiles well.
	 */
	public static String getEscapedString(String str)
	{
		String s = str.replace("\\", "\\\\");
		s = s.replace("\"", "\\\"");
		
		return s;
	}
	
	/**
	 * returns the string list compatible for XML
	 */
	public static ArrayList<String> getXMLCompatibleStr(ArrayList<String> list)
	{
		ArrayList<String> translatedArray = new ArrayList<String>();
		Iterator<String> itr = list.iterator();
		while (itr.hasNext())
		{
			String s = itr.next();
			s = s.replace("&", "&amp;");
			s = s.replace("<", "&lt;");
			s = s.replace(">", "&gt;");
			translatedArray.add(s);
		}
		
		return translatedArray;
	}
	
	//========================================================================================
	// Helper methods related to Version handling
	//========================================================================================
	
	/**
	 * @return the value of tag passed from String of format: <Version Value="" />
	 */
	public static String getTagValueFromVersionXML(String str, String tag)
	{
		if (str == null)
			return "Unknown";
		String str1 = "<" + tag;
		String str2 = "Value";
		String val = new String("Unknown");
		int idx1 = str. indexOf(str1);
		
		if (idx1 != -1)
		{
			idx1 = str.indexOf(str2, idx1);
			if (idx1 != -1)
			{
				idx1 = str.indexOf("\"", idx1);
				if (idx1 != -1)
				{
					int idx2 = str.indexOf("\"", idx1+1);
					val = str.substring(idx1+1, idx2);
				}
			}
		}
		if (val.equals("null"))
			val = "Unknown";
		
		return val;
	}
	
	/**
	 * Get attribute value from xml, and tag specified
	 */
	public static String getAttributeValueForTag(String xml, String tag, String attr)
	{
		if (xml == null)
			return "";
		
		String str1 = "<" + tag;
		String val = new String("Unknown");
		int idx1 = xml.indexOf(str1);
		
		if (idx1 != -1)
		{
			idx1 = xml.indexOf(attr, idx1);
			if (idx1 != -1)
			{
				idx1 = xml.indexOf("\"", idx1);
				if (idx1 != -1)
				{
					int idx2 = xml.indexOf("\"", idx1+1);
					val = xml.substring(idx1+1, idx2);
				}
			}
		}
		
		return val;
	}
	/**
	 * @returns the value of attribute from single line in format:
	 * <Tag attribute="Value1" />
	 */
	public static String getAtributeValueFromLine(String line, String attribute)
	{
		String val = "";
		
		int idx1 = line.indexOf(attribute);
		int idx2 = -1;
		if (idx1 != -1)
		{
			idx1 = line.indexOf("\"", idx1);
			idx2 = line.indexOf("\"", idx1 + 1);
			
			val = line.substring(idx1 + 1, idx2);
		}
		
		return val;
	}
	
	/**
	 * @return the value of tag and attribute passed from String of format: 
	 * <Tag attribute1="value1" attribute1="value2"/>
	 */
	public static Map<String, String> getAttributeValueFromXML(String xml, String tag, String attribute1, String attribute2)
	{
		Map<String, String> map = new HashMap<String, String>();
		
		String startChars = "<" + tag;
		String endChars = "/>";
		
		int idx1 = xml.indexOf(startChars);
		int idx2 = -1;
		
		while (idx1 != -1)
		{
			idx2 = xml.indexOf(endChars, idx1);
			if (idx2 != -1)
			{
				idx2 += endChars.length();
				String line = xml.substring(idx1, idx2);
				
				String prop = getAtributeValueFromLine(line, attribute1);
				String propVal = getAtributeValueFromLine(line, attribute2);
				
				map.put(prop, propVal);
			}
			else
				break;
			
			idx1 = xml.indexOf(startChars, idx2);
		}
	
		return map;
	}
	
	/**
	 * Creates the Folder Structure for the log file
	 */
	public static void createParentDirRecursivelyIfNotExist(File dirHandle) throws Exception
	{
		if (dirHandle.exists())
			return;
		else if (new File(dirHandle.getParent()).exists()) {
			dirHandle.mkdir();			
		}
		else {
			createParentDirRecursivelyIfNotExist(new File(dirHandle.getParent()));
			dirHandle.mkdir();
		}
	}
	
	/**
	 * returns the tag value from string of format: <Value>10.2</Value>
	 */
	public static String getTagValue(String str, String tag)
	{
		if (str == null)
		{
			return "Unknown";
		}
		String str1 = "<" + tag + ">";
		String str2 = "</"+ tag +">";
		String val = new String("Unknown");
		int idx1 = str.indexOf(str1);
		if (idx1 != -1)
		{
			idx1 += str1.length();
			int idx2 = str.lastIndexOf(str2);
			
			val = str.substring(idx1, idx2);
		}
		if (val.equals("null"))
			val = "Unknown";
		
		return val;
	}
	
	/**
	 * returns the version in integer computed from string: 1.34.56
	 */
	public static int getVersionNumber(String v)
	{
		if (v == null)
			return 0;
		String str[] = v.split("\\.");
		int l = str.length;
		int pw = l-1;
		int s1 = 0;
		try{
			for(int i=0; i < l; i++)
			{
				s1 += Integer.parseInt(str[i]) * Math.pow(100, pw);
				pw --;
			}
		}
		catch(Exception e){}
		
		return s1;
	}
	
	//========================================================================================
	// Misc Helper methods
	//========================================================================================
	
	/**
	 * Prints message on console with a next line character at end
	 */
	public static void printMessageOnConsole(String msg)
	{
		System.out.println(msg);		
	}
	
	/**
	 * Prints message on error console with a next line character at end
	 */
	public static void printErrorOnConsole(String msg)
	{
		System.err.println(msg);		
	}
	
	/**
	 * Returns Current System time in HH:MM:SS format 
	 */
	public static String formatTime() {
		long t = System.currentTimeMillis();
		long hours = t / 1000 / 60 / 60;
		long minutes = (t / 1000 / 60) % 60;
		long seconds = (t / 1000) % 60;
		
		return (hours > 9 ? hours + "" : "0" + hours) + ":" + (minutes > 9 ? minutes + "" : "0" + minutes) + ":" + (seconds > 9 ? seconds + "" : "0" + seconds);
	}
	
	/**
	 * Returns a ArrayList<String> of passed arguments
	 */
	public static ArrayList<String> getArrayListFromStringParams(String...args)
	{
		ArrayList<String> arrayList = new ArrayList<String>();
		for(int i = 0; i<args.length; i++)
		{
			arrayList.add(args[i]);
		}
		
		return arrayList;
	}
	

	/**
	 * Reads a file provided as path to file as a String
	 * 
	 * @param fileName
	 * 		Path of File
	 * 
	 * @return
	 * 		File Content As String
	 * 
	 * @throws Exception
	 */
	public static String readFileAsString(String fileName) throws Exception{
	    File file = new File(fileName);
	    FileReader fr = new FileReader(file);
	    char[] buffer = null;

	    BufferedReader bufferedReader = new BufferedReader(fr);
        buffer = new char[(int)file.length()];

        int i = 0;
        int c = bufferedReader.read();

        while (c != -1) {
            buffer[i++] = (char)c;
            c = bufferedReader.read();
        }
        bufferedReader.close();
        fr.close();
        
        return new String(buffer);
	}

	/**
	 * Writes a String in a File
	 * @param text
	 * @param fileName
	 * @throws Exception
	 */
	public static void witeStringAsFile(String text, String fileName) throws Exception
	{
		Writer output = null;
		File file = new File(fileName);
		if (file.exists())
			file.delete();
		output = new BufferedWriter(new FileWriter(file));
		output.write(text);
		output.close();
	  }
	
	public static void createDirIfDoesntExist(String dirName)
	{
		File theDir = new File(dirName);
		
		if (!theDir.exists())
		{
			theDir.mkdir();
		}
	}
	
	public static String[] getFilteredFilesByExtension(String dirname, final String extension)
	{
		FilenameFilter fl = new FilenameFilter() {
			
			public boolean accept(File dir, String name) {
				
				if (name.endsWith(extension))
					return true;
				return false;
			}
		};
		
		File dirH = new File(dirname);
		return dirH.list(fl);
	}
	
	public static String getExceptionStackTraceAsString(Exception e){
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw);
		String stacktrace = sw.toString();
		pw.close();
		try {
			sw.close();
		} catch (IOException e1) {}
		return stacktrace;
	}
	
	//========================================================================================
	// Process Related Helper Methods
	//========================================================================================

    //Check if underlying System is Windows
    public static boolean isWindows() {
    	String os = System.getProperty("os.name").toLowerCase();
		//windows
	    return (os.indexOf( "win" ) >= 0);
	}
    
    //Check if underlying System is Mac
    public static boolean isMac(){
		String os = System.getProperty("os.name").toLowerCase();
		//Mac
	    return (os.indexOf( "mac" ) >= 0); 
	}
    
    //Executes a Command. Return the Output as String
    public static String executeCommand (String[] cmd, boolean returnOutput, int timeOut, boolean killProcess){
    	String outputStr = "";
    	
    	//Compose a command line from passed command
    	CommandLine cmdLine = new CommandLine(cmd[0]);
    	for (int i=1; i < cmd.length; i++) {
    		cmdLine.addArgument(cmd[i],false);
    	}
    	
    	// create the executor and consider the exitValue '0' as success
    	ByteArrayOutputStream stdout = new ByteArrayOutputStream();
        PumpStreamHandler psh = new PumpStreamHandler(stdout);

    	Executor executor = new DefaultExecutor();
    	executor.setExitValue(0);
    	executor.setStreamHandler(psh);

    	ExecuteWatchdog watchdog = new ExecuteWatchdog(timeOut);
    	if (killProcess)
    		executor.setWatchdog(watchdog);
    	else
    		watchdog = null;
    	
    	try {
    		if (!killProcess){
				try{
					executor.execute(cmdLine, new DefaultExecuteResultHandler());
				} catch (Exception e1){
					outputStr = e1.getMessage();
				}
    		}
    		else
    			executor.execute(cmdLine);
    		
			if (returnOutput)
				outputStr = stdout.toString();
			else
				outputStr  = "SUCCESS";
		} catch (ExecuteException e1) {
			if(watchdog != null && watchdog.killedProcess()) {
				outputStr = "The Process Timedout";
			}
			else {
				if (returnOutput)
					outputStr = stdout.toString();
				else
					outputStr = "The process failed to execute : " + e1.getMessage();
			}
		} catch (IOException e2) {
			outputStr = "The process failed to execute : " + e2.getMessage();
		}
		
		return outputStr;
    }

    //Get PID of a process if it is running else return 0
	public static ArrayList<Integer> getPIDIfProcessRunning(String pName) 
	{
		ArrayList<Integer> PIDArray = new ArrayList<Integer>();
		
		if (isWindows()){
			String line;
			BufferedReader input = null;
			try {
				String prName = "\"name like '%" + pName + "%'\"";  
				String cmd[] = {"wmic.exe", "PROCESS", "WHERE", prName , "GET", "ProcessID"};
				String outPut = executeCommand(cmd,true,5000,true);
				InputStream is = new ByteArrayInputStream(outPut.getBytes());
			    input = new BufferedReader(new InputStreamReader(is));
			    line = input.readLine();
			    while ((line = input.readLine()) != null) {
			    	int nPID = 0;
			    	try{
						nPID = Integer.parseInt(line.trim());
						PIDArray.add(nPID);
					}catch(Exception e){}
			    }

			    if (PIDArray.size() == 0)
			    	PIDArray.add(0);
			    
			    input.close();
			} catch (Exception err) {}
			finally{
				try {
					input.close();
				} catch (IOException e) {}					
			}
			
			File tempBat = new File(new File (".").getAbsolutePath() + File.separator + "TempWmicBatchFile.bat");
			if (tempBat.exists())
				tempBat.delete();
			
		    return PIDArray;
		}
		else if (isMac()){
			String line;
			BufferedReader input = null;
			try {
				String command[]={"ps", "-ax"};
				String outPut = executeCommand(command,true,5000,true);
				InputStream is = new ByteArrayInputStream(outPut.getBytes());
			    input = new BufferedReader(new InputStreamReader(is));
			    while ((line = input.readLine()) != null) {
			    	if (line.toLowerCase().indexOf(pName.toLowerCase())>-1){
			    		String[] arr2 = line.split("\\s");
			    		int nPID = 0;
						for (int j=0; j< arr2.length; j++){
							if(!(arr2[j].trim().equalsIgnoreCase(""))){
								try{
									nPID = Integer.parseInt(arr2[j].trim());
									PIDArray.add(nPID);
									break;
								}catch(Exception e){}
							}
						}
			    	}
			    }
			    if (PIDArray.size() == 0)
			    	PIDArray.add(0);
			    
			    input.close();
			} catch (Exception err) {}
			finally{
				try {
					input.close();
				} catch (IOException e) {}	
			}
			return PIDArray;
		}
		
		if (PIDArray.size() == 0)
	    	PIDArray.add(0);
		
		return PIDArray;
	}

	//Kills a Java process running a particular Jar
	public static boolean forceKillJavaProcessRunningAJar(String jarToWatch)
	{
		boolean bFound = false;
		if (jarToWatch.toLowerCase().trim().contains(".jar")){
			if(isWindows()){
				String line;
				BufferedReader input = null;
				String nameCommand = " \"CommandLine like '%" + jarToWatch + "%' AND name like '%java%'\"";
				try {
					String cmd[] = {"wmic.exe", "PROCESS", "WHERE", nameCommand, "GET", "ProcessID"};
					String outPut = executeCommand(cmd,true,5000,true);
					InputStream is = new ByteArrayInputStream(outPut.getBytes());
				    input = new BufferedReader(new InputStreamReader(is));
				    line = input.readLine();
				    while ((line = input.readLine()) != null) {
				    	if (!line.trim().equalsIgnoreCase("")){
				    		//System.out.println(line);
				    		int nPID = 0;
							try{
								nPID = Integer.parseInt(line.trim());
							}catch(Exception e){}
				    		
							//If PID is found lets kill the process
							if (nPID != 0){
								bFound=true;
	    						System.out.println(nPID);
	    						System.out.println(jarToWatch.trim());
	    						String cmd2[] = {"taskkill", "/F", "/PID", Integer.toString(nPID)};
    							executeCommand(cmd2, false,10000,true);
							}
				    	}
				    }
				    input.close();
				} catch (Exception err) {
					err.printStackTrace();
				}
				finally{
					try {
						input.close();
					} catch (IOException e) {}					
				}
	
				//Delete Temp Bat file if exists
				File tempBat = new File(new File (".").getAbsolutePath() + File.separator + "TempWmicBatchFile.bat");
				if (tempBat.exists())
					tempBat.delete();
			}

			if (isMac()){
				String line;
				BufferedReader input = null;
				try {
					String cmd[] = {"ps", "-ax"};
					String outPut = executeCommand(cmd,true,5000,true);
					InputStream is = new ByteArrayInputStream(outPut.getBytes());
				    input = new BufferedReader(new InputStreamReader(is));
				    line = input.readLine();
	
				    while ((line = input.readLine()) != null) {
				    	if (line.toLowerCase().contains(jarToWatch.trim().toLowerCase())){
				    		String[] arr = line.split("\\s");
				    		int nPID = 0;
				    		for (int i=0; i< arr.length; i++){
	   							if(!(arr[i].trim().equalsIgnoreCase(""))){
	    							try{
	    								nPID = Integer.parseInt(arr[i].trim());
	    							}catch(Exception e){}
	   							}
				    		}
				    		//If PID is found lets kill the process
							if (nPID != 0){
								bFound=true;
	    						System.out.println(nPID);
	    						System.out.println(jarToWatch.trim());
								String cmd2[] = {"kill", "-9", Integer.toString(nPID)};
								executeCommand(cmd2, false,10000,true);
							}
				    	}
				    }
				} catch (Exception err) {}
				finally{
					try {
						input.close();
					} catch (IOException e) {}					
				}
			}
		}
		return bFound;
	}
	
	public static boolean closeProcess(String pName, boolean bForce)
	{
		ArrayList<Integer> PIDArray = new ArrayList<Integer>();
		
		if (Utils.isWindows() || Utils.isMac()){
			PIDArray = Utils.getPIDIfProcessRunning(pName);
			
			if (PIDArray.size() == 0){
				return true;
			}
			else{
				if (PIDArray.get(0) == 0)
					return true;
				else{
					for(int i=0;i<PIDArray.size();i++){
						if (Utils.isWindows()){
							if (bForce){
								String	cmd2[] = {"taskkill", "/F", "/PID", Integer.toString(PIDArray.get(i))};
								Utils.executeCommand(cmd2,false,10000,true);
							}
							else{
								String	cmd2[] = {"taskkill", "/PID", Integer.toString(PIDArray.get(i))};
								Utils.executeCommand(cmd2,false,10000,true);
							}
						}
						else if (Utils.isMac()){
							if (bForce){
								String cmd2[] = {"kill", "-9", Integer.toString(PIDArray.get(i))};
								Utils.executeCommand(cmd2, false,10000,true);
							}
							else{
								String cmd2[] = {"kill", "-3", Integer.toString(PIDArray.get(i))};
								Utils.executeCommand(cmd2, false,10000,true);
							}
						}
						else
							return false;
					}
					
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {}
					
					PIDArray = Utils.getPIDIfProcessRunning(pName);
					if (PIDArray.size() == 0){
						return true;
					}
					else{
						if (PIDArray.get(0) == 0)
							return true;
						else
							return false;
					}
				}
			}
		}
		return false;
	}
	public static String getTempFolderpath()
	{
		return System.getProperty("java.io.tmpdir");
	}
	
	/**
	 * To check client is swf or not
	 */
	public static boolean isClientSwf(String clientName)
	{
		if (clientName.startsWith(Utils.EXECUTOR_NAME_STR))
			return false;
		
		if (clientName.startsWith(Utils.PLUGIN_NAME_STR))
			return false;
		
			
		return true;
	}
	
	/**
	 * If tag not found, return blank string
	 * @param str
	 * @param tag
	 * @return
	 */
	public static String getTagValueDefBlank(String str, String tag)
	{
		if (str == null)
		{
			return "";
		}
		String str1 = "<" + tag + ">";
		String str2 = "</"+ tag +">";
		String val = new String("");
		int idx1 = str.indexOf(str1);
		if (idx1 != -1)
		{
			idx1 += str1.length();
			int idx2 = str.lastIndexOf(str2);
			
			val = str.substring(idx1, idx2);
		}
		if (val.equals("null"))
			val = "";
		
		return val;
	}
	
	/**
	 * Copy file to a temporary location
	 * @param filepath
	 * @return copied path. If could not created, return blank string
	 */
	public static String copyFileInTempLocation(String filepath)
	{
		String tmpPath = System.getProperty("java.io.tmpdir");
		File tmpFile = new File(tmpPath, "genieSuiteTemp.xml");
		try{
			if (tmpFile.exists())
				tmpFile.delete();
			tmpFile.createNewFile();
			
			File file = new File(filepath);
			
			FileReader fReader = new FileReader(file);
			FileWriter fWriter = new FileWriter(tmpFile);
			int c;
			while ((c = fReader.read()) != -1)
				fWriter.write(c);
			fReader.close();
			fWriter.close();
			
		}catch(Exception e){
			return "";
		}
		
		return tmpFile.getAbsolutePath();
	}
	public static boolean deleteFile(String sFilePath)
	{
	  File oFile = new File(sFilePath);
	  if(oFile.isDirectory())
	  {
	    File[] aFiles = oFile.listFiles();
	    for(File oFileCur: aFiles)
	    {
	       deleteFile(oFileCur.getAbsolutePath());
	    }
	  }
	  return oFile.delete();
	}
	
	public static String getDateTimeStringForFolder(long time){
		SimpleDateFormat fmt = new SimpleDateFormat();
		fmt.applyPattern("yyyy_MM_dd_HH_mm_ss");
		String dateTime = fmt.format(new Date(time));
		return dateTime;
	}
	
	// Gets the Current Path from where Executor is being Executed
	public static String getCurrentPath()
	{
		File dir1 = new File (".");
		String currentDir = "";
		try {
			currentDir = dir1.getCanonicalPath();
	    
	       }
	     catch(Exception e) {
	       e.printStackTrace();
	       }
	     return currentDir;
	}	
}



