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
package com.adobe.genie.executor.objects;

import com.adobe.genie.iexecutor.objects.IGenieExecutionResult;

/**
 * This class denotes the return type of execution
 * <p>
 * It contains the final result of execution as well as complete Script Log
 * 
 * @since Genie 1.1
 */
public class GenieExecutionResult implements IGenieExecutionResult{

	//========================================================================================
	// Variables of GenieExecutionResult
	//========================================================================================
	
	private String execResultXML;
	private boolean finalResult;
		
	/**
	 * Basic GenieExecutionResult Constructor, this initializes the GenieExecutionResult object
	 * 
	 */	
	public GenieExecutionResult(){
		this.execResultXML = "";
		this.finalResult = false;
	}
	
	//========================================================================================
	// Getter/Setter of Variables
	//========================================================================================

	/**
	 * Return the Execution result as XML Document
	 * String representation of the Script/Suite Log.
	 * This is a valid XML document
	 * 
	 * @since Genie 1.1
	 */
	public String getTestResultXML() {
		return  this.execResultXML;
	}

	/**
	 * Set the result XML attribute of the object
	 * 
	 * @param resultXML
	 * 		String representation of the Script/Suite Log
	 * 		This is a valid XML document
	 * 
	 * @since Genie 1.1
	 */
	public void setTestResultXML(String resultXML) {
		this.execResultXML = resultXML;
	}
	
	/**
	 * Return the net result of execution as boolean
	 * 
	 * @since Genie 1.1
	 */
	public boolean getFinalResult() {
		return  this.finalResult;
	}

	/**
	 * Set the result of execution
	 * 
	 * @param netResult
	 * 		Result of execution as boolean
	 * 
	 * @since Genie 1.1
	 */
	public void setFinalResult(boolean netResult) {
		this.finalResult = netResult;
	}
}
