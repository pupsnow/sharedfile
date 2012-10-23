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
 * Following options available:
usage: java -jar Executor.jar [--logFolder FolderName] [--logOverWrite] [--logFolderWithoutTimestamp] [--v] [--suite GenieSuiteXML] [--executeSuites [suite1,suite2,...]] [-scriptParams [param1,param2,..]] [--help] <scriptName>  

     scriptName                   The class file of GenieScript

     --scriptParams               Comma separated list of all parameters enclosed in square brackets ex [a,b,c]
     							  Access cmdArguments[] array in GenieScript to access these params. 	

     --suite                      The full system path of Genie Suite XML which contains description of all suites

     --executeSuites              Comma separated list of all suite names enclosed in square brackets []
                                  which only needs to be executed out of full suite. 
                                  If ignored full suite is executed. Only valid if -suite is used

     --logFolder                  The folder where you want Executor to put logs

     --logOverWrite               No special folder will be created for storing logs and logs will be created at
                                  root folder and also they will be overwritten on each execution session
                                  In case of Suite only the final Suite log will follow this rule.
                                  If logFolderWithoutTimestamp is also specified then logFolderWithoutTimestamp 
                                  will be ignored and logOverWrite will be considered 

     --logFolderWithoutTimestamp  TimeStamp will not be appended to the Script Log folder
                                  If same script is executed again the contents of folder will be overwritten
                                  In case of Suite only the final Suite log will follow this rule
	
	--noLogging					  No script/suite logs are generated.						
     --v                          The version of Executor

     --help                       Print command usage

 * 
 */
class HandleCommandLine {

	private String[] commandLineArgs;
	private String scriptName = "";
	private String logFolderName = "";
	private boolean errorOccurred = false;
	private boolean logOverride = false;
	private boolean logNoTimeStampFolder = false;
	private boolean noLogging = false;
	private boolean launchedWithRE = false;
	
	private boolean isSuite = false;
	private boolean isSuiteNameSpecified = false;
	private String suitePath = ""; 
	private String suiteNames = ""; 
	
	private String[] args = new String[]{};
	
	public HandleCommandLine(String[] args) 
	{
		commandLineArgs = args;
		this.parseCommandLine();
	}
	
	private void parseCommandLine() 
	{
		int len = this.commandLineArgs.length;
		int i=0;
		while(i<len)
		{
			String option = this.commandLineArgs[i];
			if (option.equalsIgnoreCase("logFolder") || option.equalsIgnoreCase("-logFolder") 
					|| option.equalsIgnoreCase("--logFolder"))
			{
				i++;
				if(commandLineArgs.length > i)
					this.logFolderName = this.commandLineArgs[i];
				else
				{
					Utils.printErrorOnConsole("Please specify log folder path");
					this.showHelp();
					return;
				}
			}
			else if (option.equalsIgnoreCase("suite") || option.equalsIgnoreCase("-suite") 
					|| option.equalsIgnoreCase("--suite"))
			{
				i++;
				if(commandLineArgs.length > i)
				{
					this.isSuite = true;
					this.suitePath = this.commandLineArgs[i];
				}
				else
				{
					Utils.printErrorOnConsole("Please specify Test Suite xml file path");
					this.showHelp();
					return;
				}
			}
			else if (option.equalsIgnoreCase("executeSuites") || option.equalsIgnoreCase("-executeSuites") 
					|| option.equalsIgnoreCase("--executeSuites"))
			{
				i++;
			
				if(commandLineArgs.length > i)
				{
					this.isSuiteNameSpecified = true;
					this.suiteNames = this.commandLineArgs[i];
				}
				else
				{
					Utils.printErrorOnConsole("Please specify Test Suite names to be executed");
					this.showHelp();
					return;
				}
				
			}
			else if (option.equalsIgnoreCase("scriptParams") || option.equalsIgnoreCase("-scriptParams") 
					|| option.equalsIgnoreCase("--scriptParams"))
			{
				i++;
				boolean passed = false;
				if(commandLineArgs.length > i)
				{
					if(this.commandLineArgs[i].startsWith("[") && this.commandLineArgs[i].endsWith("]"))
					{
						String scriptParamsStr = this.commandLineArgs[i].substring(1,this.commandLineArgs[i].length()-1);
						if(scriptParamsStr.length() > 0)
						this.args = scriptParamsStr.split(",");
						for (int j=0;j<this.args.length;j++)
							this.args[j]=this.args[j].trim();
						
						passed = true;
					}
				}
				
				if (!passed)
				{
					Utils.printErrorOnConsole("Please specify script parameters to be passed in format: [param]");
					this.showHelp();
					return;
				}
			}
			else if (option.equalsIgnoreCase("logOverWrite") || option.equalsIgnoreCase("-logOverWrite") 
					|| option.equalsIgnoreCase("--logOverWrite"))
			{
				this.logOverride = true;
			}
			else if (option.equalsIgnoreCase("logFolderWithoutTimestamp") || option.equalsIgnoreCase("-logFolderWithoutTimestamp") 
					|| option.equalsIgnoreCase("--logFolderWithoutTimestamp"))
			{
				this.logNoTimeStampFolder = true;
			}
			else if (option.equalsIgnoreCase("noLogging") || option.equalsIgnoreCase("-noLogging") 
					|| option.equalsIgnoreCase("--noLogging"))
			{
				this.noLogging = true;
			}
			else if (option.equalsIgnoreCase("launchedWithRE") || option.equalsIgnoreCase("-launchedWithRE") 
					|| option.equalsIgnoreCase("--launchedWithRE"))
			{
				this.launchedWithRE = true;
			}
			else if (option.equalsIgnoreCase("v") || option.equalsIgnoreCase("-v") 
					|| option.equalsIgnoreCase("--v"))
			{
				VersionHandler vH = VersionHandler.getInstance();
				Utils.printMessageOnConsole("Executor Version: " + vH.getExecutorVersion());
				return;
			}
			else if (option.equalsIgnoreCase("help") || option.equalsIgnoreCase("-help") 
					|| option.equalsIgnoreCase("--help"))
			{
				this.showHelp();
				return;
			}
			else	//must be script name
			{
				//ignore any Script if Suite option is already specified
				if (!this.isSuite){
					if (scriptName.equals(""))
					{
						this.scriptName = this.commandLineArgs[i];
						
						File f = new File(scriptName);
				    	if(f.exists())
				    	{
				    		scriptName = f.getAbsolutePath();
				    	}
					}
					else
					{
						//User must have used it wrong
						return;
					}
				}
			}
			
			i++;
		}
		
		if (this.scriptName.equalsIgnoreCase("") && !this.isSuite)
		{
			this.showHelp("Must pass argument as script name or a suite path!");
		}
		
	}
	
	public boolean isErrorOccurred()
	{
		return this.errorOccurred;
	}
	
	/**
	 * @returns true if user has specified logFolderWithoutTimeStamp option
	 */
	public boolean isLogNoTimeStampFolder()
	{
		return this.logNoTimeStampFolder;
	}
	
	/**
	 * @returns true if user has specified logOverridden option
	 */
	public boolean isLogOverride()
	{
		return this.logOverride;
	}
	
	/**
	 * @returns path of SuiteXML if user is executing Suite and not stand alone Script
	 * If user is executing Script a blank value is returned
	 */
	public String getSuiteStatus()
	{
		if (this.isSuite){
			return this.suitePath;
		}
		else return "";
	}
	
	/**
	 * @returns name of suites if user is executing Suite and specified suite names
	 * else if no sub suite is specified we need to run all
	 * otherwise a blank string is returned meaning that suite is not intended to be executed
	 */
	public String getSubSuiteStatus()
	{
		if (this.isSuite){
			if(this.isSuiteNameSpecified){
				return suiteNames;
			}
			else return "[completeGenieSuite]";
		}
		else return "";
	}
	
	
	/**
	 * Show an extra message with help, if any
	 */
	private void showHelp(String msg)
	{
		errorOccurred = true;
		
		if (!msg.equalsIgnoreCase(""))
		{
			Utils.printMessageOnConsole(msg);
		}
		this.showHelp();
	}
	private void showHelp()
	{
		String help = "usage: java -jar Executor.jar [--logFolder FolderName] [--logOverWrite] [--logFolderWithoutTimestamp] [--v] [--suite GenieSuiteXML] [--executeSuites [suite1,suite2,...]] [-scriptParams [param1,param2,..]][--help] scriptPath ";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --scriptParams               Comma separated list of all parameters enclosed in square brackets ex \"[a,b,c]\"";
		help += System.getProperty("line.separator");
		help += "     					           please note the double quotes around the params,they are compulsory";
		help += System.getProperty("line.separator");
		help += "     					           Access cmdArguments[] array in GenieScript to access these params.";
		 
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --suite                      The full system path of Genie Suite XML which contains description of all suites";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");

		help += "     --executeSuites              Comma separated list of all suite names enclosed in square brackets []";
		help += System.getProperty("line.separator");  
		help += "                                  which only needs to be executed out of full suite. ";
		help += System.getProperty("line.separator");  
		help += "                                  If ignored full suite is executed. Only valid if -suite is used";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		

		help += "     --logFolder                  The folder where you want Executor to put logs";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --logOverWrite               No special folder will be created for storing logs and logs will be created at";
		help += System.getProperty("line.separator");
		help += "                                  root folder and also they will be overwritten on each execution session";
		help += System.getProperty("line.separator");
		help += "                                  In case of Suite only the final Suite log will follow this rule";
		help += System.getProperty("line.separator");
		help += "                                  If logFolderWithoutTimestamp is also specified then logFolderWithoutTimestamp ";
		help += System.getProperty("line.separator");
		help += "                                  will be ignored and logOverWrite will be considered ";
		
       
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --logFolderWithoutTimestamp  TimeStamp will not be appended to the Script Log folder";
		help += System.getProperty("line.separator");
		help += "                                  If same script is executed again the contents of folder will be overwritten";
		help += System.getProperty("line.separator");
		help += "                                  In case of Suite only the final Suite log will follow this rule";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --noLogging                  Switch off Script/Suite logs";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --v                          The version of Executor";
		help += System.getProperty("line.separator");
		help += System.getProperty("line.separator");
		
		help += "     --help                       Print command usage";
		help += System.getProperty("line.separator");
		
		Utils.printMessageOnConsole(help);
		System.exit(0);
	}
	
	public String getScriptName()
	{
		if (this.isSuite){
			return "";
		}
		return this.scriptName;
	}
	public String getLogFolderName()
	{
		return this.logFolderName;
	}
	public String[] getCmdArguments()
	{
		return this.args;
	}
	
	public boolean isNoLogging()
	{
		return noLogging;
	}
	public boolean isLaunchedWithRE()
	{
		return launchedWithRE;
	}
	
}
