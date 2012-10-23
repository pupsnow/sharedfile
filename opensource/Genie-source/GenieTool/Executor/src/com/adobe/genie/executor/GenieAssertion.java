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

import java.util.Arrays;

import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.exceptions.StepFailedException;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.utils.Utils;

/**
 * This class contains all the assertion methods that enables the user to assert a value or condition in a script. 
 * Assertion methods will verify a actual value with its expected value and will throw step failed exception 
 * if assertion is false.
 * 
 * @since Genie 1.2
 */

public class GenieAssertion {

	private static ScriptLog scriptLog = ScriptLog.getInstance();
	private static String screenShotNameFormat = "Failure_";
	private static boolean result = false;
	
	
	
	/**
	 * Asserts that two long values are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expected - long expected values
	 * 
	 * @param actual
	 * 		actual - long actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertEquals(String message,long expected,long actual) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertEqualStep");
		scriptLog.addTestStepParameter("Expected Long Value", GenieParameterType.PARAM_INPUT,String.valueOf(expected));
		scriptLog.addTestStepParameter("Actual Long Value", GenieParameterType.PARAM_INPUT,String.valueOf(actual));

		if(expected != actual)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that two double values are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expected - double expected values
	 * 
	 * @param actual
	 * 		actual - double actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertEquals(String message,double expected,double actual) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertEqualStep");
		scriptLog.addTestStepParameter("Expected Double Value", GenieParameterType.PARAM_INPUT,String.valueOf(expected));
		scriptLog.addTestStepParameter("Actual Double Value", GenieParameterType.PARAM_INPUT,String.valueOf(actual));

		if(expected != actual)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that two String values are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expected - String expected values
	 * 
	 * @param actual
	 * 		actual - String actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertEquals(String message,String expected,String actual) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertEqualStep");
		scriptLog.addTestStepParameter("Expected String Value", GenieParameterType.PARAM_INPUT,String.valueOf(expected));
		scriptLog.addTestStepParameter("Actual String Value", GenieParameterType.PARAM_INPUT,String.valueOf(actual));

		if(!actual.equals(expected))
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that two String Arrays are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expecteds - String array with expected values
	 * 
	 * @param actual
	 * 		actuals - String array with actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertArrayEquals(String message,String[] expecteds, String[] actuals) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertArrayEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertArrayEqualStep");
		scriptLog.addTestStepParameter("Expected String Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(expecteds));
		scriptLog.addTestStepParameter("Actual String Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(actuals));

		if(!Arrays.equals(expecteds, actuals))
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that two double Arrays are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expecteds - double array with expected values
	 * 
	 * @param actual
	 * 		actuals - double array with actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertArrayEquals(String message,double[] expecteds, double[] actuals) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertArrayEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertArrayEqualStep");
		scriptLog.addTestStepParameter("Expected Double Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(expecteds));
		scriptLog.addTestStepParameter("Actual Double Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(actuals));

		if(!Arrays.equals(expecteds, actuals))
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	/**
	 * Asserts that two long Arrays are equal. If they are not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param expected
	 * 		expecteds - long array with expected values
	 * 
	 * @param actual
	 * 		actuals - long array with actual values
	 * 
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertArrayEquals(String message,long[] expecteds, long[] actuals) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertArrayEquals: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertArrayEqualStep");
		scriptLog.addTestStepParameter("Expected Long Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(expecteds));
		scriptLog.addTestStepParameter("Actual Long Array Value", GenieParameterType.PARAM_INPUT,Arrays.toString(actuals));

		if(!Arrays.equals(expecteds, actuals))
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that a condition is true. If it is not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param condition
	 * 		condition - condition to be checked
	 *
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertTrue(String message,boolean condition) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertTrue: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertTrueStep");
		scriptLog.addTestStepParameter("Expected Condition value", GenieParameterType.PARAM_INPUT,"true");
		scriptLog.addTestStepParameter("Actual Condition Value", GenieParameterType.PARAM_INPUT,String.valueOf(condition));

		if(!condition)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that a condition is false. If it is not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param condition
	 * 		condition - condition to be checked
	 *
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertFalse(String message,boolean condition) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertFalse: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertFalseStep");
		scriptLog.addTestStepParameter("Expected Condition value", GenieParameterType.PARAM_INPUT,"false");
		scriptLog.addTestStepParameter("Actual Condition Value", GenieParameterType.PARAM_INPUT,String.valueOf(condition));

		if(condition)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}

	/**
	 * Asserts that an object is null. If it is not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param obj
	 * 		    obj - Object to check.
	 *
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertNull(String message,Object obj) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertNull: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertNullStep");
		scriptLog.addTestStepParameter("Expected Object value", GenieParameterType.PARAM_INPUT,"null");
		scriptLog.addTestStepParameter("Actual Object Value", GenieParameterType.PARAM_INPUT,String.valueOf(obj));

		if(obj != null)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	/**
	 * Asserts that an object is not null. If it is not, an StepFailed Exception is thrown with the given message. 
	 * 
	 * @param message
	 * 		message - the identifying message for the AssertionStepFailedError.
	 * 
	 * @param obj
	 * 		    obj - Object to check.
	 *
	 * @throws StepFailedException
	 * 
	 * @since Genie 1.2			
	 */
	public static void assertNotNull(String message,Object obj) throws StepFailedException
	{
		scriptLog.addTestStep("GenieAssertNotNull: ", GenieStepType.STEP_ASSERTION_TYPE , "AssertNotNullStep");
		scriptLog.addTestStepParameter("Expected Object value", GenieParameterType.PARAM_INPUT,"not null");
		scriptLog.addTestStepParameter("Actual Object Value", GenieParameterType.PARAM_INPUT,String.valueOf(obj));

		if(obj == null)
		{
			scriptLog.addTestStepMessage(message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			result = false;
		}
		else
		{
			result = true;
		}
		updateAssertionResult(result);
	}
	
	
	//This method will update the Assertions results in GenieLogs as per result status.
	//and capture screenshot if CAPTURE_SCREENSHOT_ON_FAILURE = TRUE
	private static void updateAssertionResult(boolean result) throws StepFailedException
	{
		
		//Captures ScreenShot when a step failed and CAPTURE_SCREENSHOT_ON_FAILURE flag is set
		//The Saved screenshot will be saved in folder containing ScriptLog
		if(!result)
		{
			scriptLog.incrementFailureCounter();
			scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_FAILED);
			Utils.printErrorOnConsole("Result is: Step failed");
		}
		else{
			scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_PASSED);
			Utils.printMessageOnConsole("Result is: Step Passed");
		}
		
		if (!result && GenieScript.CAPTURE_SCREENSHOT_ON_FAILURE){
			
			StaticFlags sf = StaticFlags.getInstance();
			String fileName = screenShotNameFormat + Integer.toString(scriptLog.getFailureCounter()) + ".jpg";
			try {
				new UIFunctions(sf.isdebugMode()).captureScreenAsJPG(scriptLog.getLogFolderPath(), fileName);
			} catch (Exception e) {
				Utils.printErrorOnConsole("Error occurred while trying to save captured screenshot");
				if (sf.isdebugMode())
					e.printStackTrace();
				else
					Utils.printErrorOnConsole(e.getMessage());
			}
		}
		
	    if (!result && GenieScript.EXIT_ON_FAILURE)
	    {
				Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
				scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				throw new StepFailedException();                                               
		}	
	}
}
