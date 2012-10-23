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
package com.adobe.genie.genieSocketServer;

import com.adobe.genie.utils.Utils;

public class CommandLineParser {

	private String[] commandLineArgs;
	private boolean debugFlag = false;
	private boolean performanceFlag = false;
	private String customComponentConfigFile = null;
	
	//Exit from server, when --v, or --help option is passed
	private boolean doExit = false;
	
	public CommandLineParser(String[] args)
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
			if (option.equalsIgnoreCase("debug") || option.equalsIgnoreCase("-debug") 
					|| option.equalsIgnoreCase("--debug"))
			{
				this.debugFlag = true;
			}
			else if (option.equalsIgnoreCase("performance") || option.equalsIgnoreCase("-performance") 
					|| option.equalsIgnoreCase("--performance"))
			{
				
				this.performanceFlag = true;
			}
			else if (option.equalsIgnoreCase("customConfig") || option.equalsIgnoreCase("-customConfig") 
					|| option.equalsIgnoreCase("--customConfig"))
			{
				if(commandLineArgs.length > (i+1))
					this.customComponentConfigFile = this.commandLineArgs[++i];
				else
				{
					Utils.printErrorOnConsole("Please specify custom config file path as well");
					showHelp();
					this.doExit = true;
					return;
				}
			}
			else if (option.equalsIgnoreCase("v") || option.equalsIgnoreCase("-v") 
					|| option.equalsIgnoreCase("--v"))
			{
				VersionHandler vH = VersionHandler.getInstance();
				Utils.printMessageOnConsole("Server Version: " + vH.getServerVersion());
				
				this.doExit = true;
				return;
			}
			else if (option.equalsIgnoreCase("help") || option.equalsIgnoreCase("-help") 
					|| option.equalsIgnoreCase("--help"))
			{
				showHelp();
				this.doExit = true;
				return;
			}			

			i++;
		}		
	}
	
	private void showHelp()
	{
		String help = "usage: java -jar GenieSocketServer.jar  [--debug] [--performance] [--customConfig] [--v] [--help] ";
		help += System.getProperty("line.separator");
		help += "     --debug       Enable server to write extra debug information in logs";
		help += System.getProperty("line.separator");
		help += "     --performance Enable tracking of performance measures in logs";
		help += System.getProperty("line.separator");
		help += "     --customConfig Loads a configuration file specifying location of modules required for supporting Custom Components";
		help += System.getProperty("line.separator");		
		help += "     --v           The version of Server";
		help += System.getProperty("line.separator");
		help += "     --help        Print command usage";
		
		Utils.printMessageOnConsole(help);
	}
	
	public boolean isDebugEnabled()
	{
		return this.debugFlag;
	}
	public boolean isPerformanceTrackingEnabled()
	{
		return this.performanceFlag;
	}
	public boolean toExit()
	{
		return this.doExit;
	}
	public String getCustomConfigFile()
	{
		return this.customComponentConfigFile;
	}
}

/* Extra private methods not being used anywhere
private void showHelp(String msg)
{
	if (!msg.equalsIgnoreCase(""))
	{
		Utils.printMessageOnConsole(msg);
	}
	this.showHelp();
}
*/