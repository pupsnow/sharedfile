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

import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.internalLog.ScriptLog;

/**
 * <font color="#FF0000"> The Class and all its methods are deprecated and using 
 * these method may result in inconsistent Script Log behavior </font>
 * 
 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.GenieScriptLogger}
 */
@Deprecated
public class GenieLogHelper {

	private static ScriptLog scriptLog = ScriptLog.getInstance();
	//========================================================================================
	// Some exposed methods related to Logging of Steps in script
	//========================================================================================
	
	/**
	 * Adds new test step in script log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param stepName
     * 			  Step name as it should appear in the log file 
     * 
	 * @since Genie 0.10
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.GenieScriptLogger#addTestStep(String)}
	 */
	@Deprecated
	public static void addTestStep(String stepName)
	 {
		UsageMetricsData usage = UsageMetricsData.getInstance();
		usage.addFeature("CustomLogging");
		 scriptLog.addTestStep(stepName, GenieStepType.STEP_CUSTOM_TYPE, "UserAddedStep");
	 }
	 
	 /**
	 * Adds message to the last step added in the log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param message
     * 			  message that should appear in the log file.
     * @param type
     * 			  Type of message as defined in GenieMessageType. Example :- GenieMessageType.MESSAGE_INFO etc
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType
	 * 
	 * @since Genie 0.10
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepMessage(String, 
	 * 			com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType)}
	 */
	@Deprecated
	public static void addTestStepMessage(String message, GenieMessageType type)
	 {
		 scriptLog.addTestStepMessage(message, type);
	 }
	 
	 /**
	 * Adds test parameter to the last step added in the log file.
	 * 
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param name
     * 			  name of the parameter. Example - "InputValue", "ExpectedValue" etc.
     * @param type
     * 			  Type of parameter as defined in GenieParameterType. Example :- GenieParameterType.PARAM_INPUT etc
     * @param value
     * 			  value of parameter
     * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType
	 * 
	 * @since Genie 0.10
	 * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepParameter(String, 
	 * 		com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType, String)}
	 */
	 public static void addTestStepParameter(String name, GenieParameterType type, String value)
	 {
		 scriptLog.addTestStepParameter(name, type, value);
	 }
	 
	 /**
	 * Adds test result to the last step added in the log file.
	 *
	 * <p>
	 * <font color="#FF0000"> The method is deprecated and using this method
	 * may result in inconsistent Script Log behavior </font>
	 * 
	 * @param status
     * 			Result of the step as defined in enum GenieResultType. Example GenieResultType.STEP_FAILED
     *
     * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType
     * 
     * @since Genie 0.10
     * 
	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.objects.GenieStepObject#addTestStepResult(
	 * 			com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType)}
	 */
	@Deprecated
	 public static void addTestStepResult(GenieResultType status)
	 {
		 scriptLog.addTestStepResult(status); 
	 }
}
