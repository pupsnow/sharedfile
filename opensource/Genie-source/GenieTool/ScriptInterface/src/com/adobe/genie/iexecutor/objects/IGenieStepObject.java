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
package com.adobe.genie.iexecutor.objects;

import org.w3c.dom.Element;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;

public interface IGenieStepObject{
	
	/**
	 * Return the StepNode as XML Element
	 * 
	 * @since Genie 1.0
	 */
	public Element getTestStep();
	
	/**
	 * Set the object StepNode with passed SetpNode
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @since Genie 1.0
	 */
	public void setTestStep(Element stepNode);
	
	/**
	 * Return the Step Start Time as long
	 * 
	 * @since Genie 1.0
	 */
	public long getStepStartTime();
	
	/**
	 * Set the object stepStartTime with passed time value
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @since Genie 1.0
	 */
	public void setStepStartTime(long stTime);
	
	/**
	 * Return the Step End Time as long
	 * 
	 * @since Genie 1.0
	 */
	public long getStepEndTime();
	
	/**
	 * Set the object stepEndTime with passed time value
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @since Genie 1.0
	 */
	public void setStepEndTime(long stTime);
	
	 /**
	 * Adds message to the step added in the log file.
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType
	 * 
	 * @since Genie 1.0
	 **/
	public boolean addTestStepMessage(String message, GenieMessageType type);
	
	 /**
	 * Adds test parameter to the step added in the log file.
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType
	 * 
	 * @since Genie 1.0
	 **/	 
	 public boolean addTestStepParameter(String name, GenieParameterType type, String value);
	 
	 /**
	 * Adds test result to the step added in the log file.
	 *  
     * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType
     * 
     * @since Genie 1.0
	 **/
	 public boolean addTestStepResult(GenieResultType status);
}
