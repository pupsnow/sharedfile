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
package com.adobe.genie.executor.enums;

/**
 * This is an Helper class which provide ENUMS related to Script Log
 * <p>
 * All are ENUMS provided here are static and to be used directly with Class name.
 * This class is not for any instantiation. Primary intention is help users provide a 
 * comprehensive set of helper enums for use in Script Log 
 * 
 * @since Genie 0.7
 * 
 */
public class GenieLogEnums {

	//========================================================================================
	// Constants for ScriptLog
	//========================================================================================
	
	/**
	 * Constants for Result of Step in Script Log.
	 * <p>
	 * Use this enum for marking result of Step.
	 * For use in addTestStepResult method
	 * 
	 * @since Genie 0.7
	 */
	public static enum GenieResultType {
		STEP_PASSED, STEP_FAILED 
	}
	
	/**
	 * Constants for Message Type in Script Log.
	 * <p>
	 * Use this enum for Defining type of message to go in Script Log.
	 * For use in addTestStepMessage method
	 * 
	 * @since Genie 0.7
	 */
	public static enum GenieMessageType {
		MESSAGE_INFO, MESSAGE_ERROR,  MESSAGE_WAIT, MESSAGE_EXCEPTION,
		MESSAGE_CUSTOM
	}
	
	/**
	 * Constants for Step Type in Script Log.
	 * <p>
	 * Use this enum for Defining type of Step to go in Script Log.
	 * For user defined Steps the StepType is always CUSTOM_TYPE
	 * 
	 * @since Genie 0.7
	 */
	public static enum GenieStepType {
		STEP_CONNECTION_TYPE, STEP_NATIVE_TYPE,  STEP_UI_TYPE, STEP_FETCH_VALUE_TYPE,
		STEP_CUSTOM_TYPE, STEP_DEVICE_UI_TYPE, STEP_ASSERTION_TYPE
	}
	
	/**
	 * Constants for Parameter Type in Script Log.
	 * <p>
	 * Use this enum for Defining type of Parameter to go in Script Log.
	 * For use in addTestStepParameter method
	 * 
	 * @since Genie 0.7
	 */
	public static enum GenieParameterType {
		PARAM_INPUT, PARAM_OUTPUT,  PARAM_ATTRIBUTE
	}
}
