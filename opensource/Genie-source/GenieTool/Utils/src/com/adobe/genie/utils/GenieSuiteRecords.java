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

/**
 * Structure for storing records specified in Genie Suite XML
 *
 * @since Genie 0.11
 */
public class GenieSuiteRecords {
	/**
	 * Path of Script
	 */
	public String scriptPath;
	
	/**
	 * Log Folder Location where Log of each script is present
	 */
	public String scriptLogPath;
	
	/**
	 * Params as to be passed to each script
	 */
	public String[] scriptParams;
	
	/**
	 * Name of Suite where this Script belongs to
	 */
	public String suiteName;
	
	/**
	 * Final Result of Script
	 */
	public String scriptResult;
	
	/**
	 * Time taken by a script to execute
	 */
	public String scriptDuration;	
	
	/**
	 * The complete XML of Script Log
	 */
	public String scriptLogContent;	
	
	/**
	 * Class name of Script which was executed
	 */
	public String className;	
	
	/**
	 * Is the Script enabled for execution
	 */
	public boolean isScriptEnabled;
	
	/**
	 * Is the Suite where the Script belongs enabled for Execution
	 */
	public boolean isSuiteEnabled;
	
	/**
	 * Is the Suite where this script belongs part of set of suites which needs 
	 * to be executed
	 */
	public boolean isSuiteToBeExecuted;
}
