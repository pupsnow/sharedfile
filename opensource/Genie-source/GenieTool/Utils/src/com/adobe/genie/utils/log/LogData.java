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
package com.adobe.genie.utils.log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.adobe.genie.utils.*;

/**
 * This class contains all the methods and Constants that enables in writing a 
 * log file for a component. Primarily used for writing logs for Plugin and 
 * Server to generate there logs
 * 
 * @since Genie 0.4
 */
public class LogData {
	
	//========================================================================================
	// Some Constants defining various behaviors of Log
	//========================================================================================
	public static final String ERROR = "Error";
	public static final String WARNING = "Warning";
	public static final String INFO = "Info";
	public static final String DATE_FORMAT_NOW = "yyyy-MM-dd HH:mm:ss";
	public static final String DATE_FORMAT_FOR_FILENAME = "yyyy-MM-dd-HH-mm-ss";
	public static boolean DEBUG = false;
	
	//========================================================================================
	// Some Methods which Makes this Class as Singleton as well as for instantiation
	//========================================================================================
	private static LogData instance = null;
	private String fileName = "Log.txt";
	
	/**
	 * Instantiate a log instance and returns the instance
	 */
	public static LogData getInstance(String fileName) {
	      if(instance == null) {
	    	  try {
	    		  instance = new LogData(fileName);
		      } catch (Exception e) {
					return null;
		      }
	      }
	      return instance;
	}
	
	/**
	 * Return instance of LogData
	 */
	public static LogData getInstance(){
	     return instance;
	}
	
	/**
	 * Actual bootstrap for instantiation happens here
	 * @throws Exception 
	 */
	public LogData(String fileName) throws Exception
	{
		this.fileName = fileName;
		createLogFile();
	}
	
	private void createLogFile() throws Exception
	{
		File file = new File(fileName);
		
		try{
			//Create parent hierarchy of the file, if one doesn't exists...
			createParentDirRecursively(new File(file.getParent()));
			
			if(!file.exists()){	
				try {
					file.createNewFile();
				} catch (IOException e) {
					if (DEBUG){
						Utils.printErrorOnConsole("Can't Create Log File "+fileName);
						e.printStackTrace();
					}
					else Utils.printErrorOnConsole("Can't Create Log File " + fileName + " ::" + e.getMessage());

					throw new Exception(e);
				}
			}
			
			try	{
				BufferedWriter out = new BufferedWriter(new OutputStreamWriter
		                (new FileOutputStream(file, true),"UTF8"));
				out.flush();
				out.close();
			}
			catch (Exception e) {
				if (DEBUG){
					Utils.printErrorOnConsole("Not able to create the log file");
					e.printStackTrace();
				}
				else Utils.printErrorOnConsole("Not able to create the log file: " + e.getMessage());
				
				throw new Exception(e);
			}
		}
		catch (Exception e) {
			if (DEBUG){
				Utils.printErrorOnConsole("Not able to create the folder Structure");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Not able to create the folder Structure: " + e.getMessage());
			
			throw new Exception(e);
		}
	}
	/**
	 * Creates the Folder Structure for the log file
	 */
	private void createParentDirRecursively(File dirHandle) throws Exception
	{
		if (dirHandle.exists())
			return;
		else if (new File(dirHandle.getParent()).exists()) {
			dirHandle.mkdir();			
		}
		else {
			createParentDirRecursively(new File(dirHandle.getParent()));
			dirHandle.mkdir();
		}
	}
	
	//========================================================================================
	// Some Methods for composition of Log
	//========================================================================================
	
	/**
	 * Get the Current Timestamp
	 * Static Method. Value can be get without an object
	 */
	private static String now() {
	    Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
	    return sdf.format(cal.getTime());
	}
	  
	/**
	 * Get TimeStamp in form required for appending to filename
	 * Static Method. Value can be get without an object
	 */
	public static String getCurrentTimeStamp() {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_FOR_FILENAME);
		return sdf.format(cal.getTime());
	}
	
	
	/**
	 * Log some info 
	 */
	public void trace(String typeOfMessage, String message) {
		try	{
			createLogFile();
			
			BufferedWriter out = new BufferedWriter(new FileWriter(fileName, true));
			out.write(now() + " " + typeOfMessage + "- " + message);
			out.newLine();
			out.flush();
			out.close();
		}
		catch (Exception e) {
			if (DEBUG){
				Utils.printErrorOnConsole("Not able to write to log file");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Not able to write to log file: " + e.getMessage());
		}
	}

	/**
	 * Log some info 
	 */
	public void traceWOTimeStamp(String message) {
		try	{
			createLogFile();
			
			BufferedWriter out = new BufferedWriter(new FileWriter(fileName, true));
			out.write(message);
			out.newLine();
			out.flush();
			out.close();
		}
		catch (Exception e) {
			if (DEBUG){
				Utils.printErrorOnConsole("Not able to write to log file");
				e.printStackTrace();
			}
			else Utils.printErrorOnConsole("Not able to write to log file: " + e.getMessage());
		}
	}

	/**
	 * Log some info when I am in Debug Mode
	 */
	public void traceDebug(String typeOfMessage, String message){
		if(DEBUG){
			trace(typeOfMessage, message);
		}
	}
	
	/**
	 * Log some info when I am not in Debug Mode
	 */
	public void traceRun(String typeOfMessage, String message){
		if(!DEBUG){
			trace(typeOfMessage, message);
		}
	}
}


