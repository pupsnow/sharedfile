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

import org.w3c.dom.Element;

import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;
import com.adobe.genie.iexecutor.objects.IGenieStepObject;
import com.adobe.genie.executor.internalLog.ScriptLog;

/**
 * This class denotes the return type of addTestStep method as defined in
 * GenieScriptLogger
 * <p>
 * This may be required to invoke other methods related to adding value to added step
 * 
 * @see com.adobe.genie.executor.GenieScriptLogger#addTestStep(String) 
 * 
 * @since Genie 1.0
 */
public class GenieStepObject implements IGenieStepObject{

	//========================================================================================
	// Variables of GenieStepObject
	//========================================================================================
	
	private Element testStepNode;
	long stepStartTime =0;
	long stepEndTime =0;
	
	/**
	 * Basic GenieStepObject Constructor, this initializes the GenieStepObject object
	 * 
	 */	
	public GenieStepObject(){
		this.testStepNode = null;
		this.stepStartTime = 0;
		this.stepEndTime = 0;
	}
	
	//========================================================================================
	// Getter/Setter of Variables
	//========================================================================================

	/**
	 * Return the StepNode as XML Element
	 * 
	 * @since Genie 1.0
	 */
	public Element getTestStep() {
		return  this.testStepNode;
	}

	/**
	 * Set the object StepNode with passed SetpNode
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @param stepNode
	 * 		Node reference of Step as XML Element
	 * 
	 * @since Genie 1.0
	 */
	public void setTestStep(Element stepNode) {
		this.testStepNode = stepNode;
	}
	
	/**
	 * Return the Step Start Time as long
	 * 
	 * @since Genie 1.0
	 */
	public long getStepStartTime() {
		return  this.stepStartTime;
	}

	/**
	 * Set the object stepStartTime with passed time value
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @param stTime
	 * 		Start Time of Script as long
	 * 
	 * @since Genie 1.0
	 */
	public void setStepStartTime(long stTime) {
		this.stepStartTime = stTime;
	}
	
	/**
	 * Return the Step End Time as long
	 * 
	 * @since Genie 1.0
	 */
	public long getStepEndTime() {
		return  this.stepEndTime;
	}

	/**
	 * Set the object stepEndTime with passed time value
	 * <p>
	 * <font color="#FF0000"> Internal Use Only. Using this method is Script
	 * can result in ScriptLog Inconsistency </font>
	 * 
	 * @param stTime
	 * 		End Time of Script as long
	 * 
	 * @since Genie 1.0
	 */
	public void setStepEndTime(long stTime) {
		this.stepEndTime = stTime;
	}
	
	//========================================================================================
	// Public Methods for usage 
	//========================================================================================
	
	 /**
	 * Adds message to the step added in the log file.
	 * 
	 * @param message
     * 			  message that should appear in the log file.
     * @param type
     * 			  Type of message as defined in GenieMessageType. Example :- GenieMessageType.MESSAGE_INFO etc
	 * 
	 * @return 
	 * 			Boolean value indication result of action being performed
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType
	 * 
	 * @since Genie 1.0
	 **/
	public boolean addTestStepMessage(String message, GenieMessageType type)
	 {
		if (this.testStepNode != null && this.stepStartTime !=0){
			if (this.getTestStep() != null){
				return ScriptLog.getInstance().addTestStepMessage(message, type,this);
			}
		}
		return false;
	 }
	 
	 /**
	 * Adds test parameter to the step added in the log file.
	 * 
	 * @param name
     * 			  name of the parameter. Example - "InputValue", "ExpectedValue" etc.
     * @param type
     * 			  Type of parameter as defined in GenieParameterType. Example :- GenieParameterType.PARAM_INPUT etc
     * @param value
     * 			  value of parameter
     * 
	 * @return 
	 * 			Boolean value indication result of action being performed
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType
	 * 
	 * @since Genie 1.0
	 **/	 
	 public boolean addTestStepParameter(String name, GenieParameterType type, String value)
	 {
		if (this.testStepNode != null && this.stepStartTime !=0){
			if (this.getTestStep() != null){
				return ScriptLog.getInstance().addTestStepParameter(name, type, value,this);
			}
		}
		return false;
	 }
	 
	 /**
	 * Adds test result to the step added in the log file.
	 * 
	 * @param status
     * 			Result of the step as defined in enum GenieResultType. Example GenieResultType.STEP_FAILED
     *
	 * @return 
	 * 			Boolean value indication result of action being performed
	 * 
     * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType
     * 
     * @since Genie 1.0
	 **/
	 public boolean addTestStepResult(GenieResultType status)
	 {
		if (this.testStepNode != null && this.stepStartTime !=0){
			if (this.getTestStep() != null){
				return ScriptLog.getInstance().addTestStepResult(status,this); 
			}
		 }
		 return false;
	 }
}
