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
package com.adobe.genie.executor.uiEvents;

import com.adobe.genie.executor.GenieScript;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.exceptions.StepFailedException;
import com.adobe.genie.executor.exceptions.StepTimedOutException;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.utils.Utils;

/**
 *	A common class containing static methods to be used throughout
 *	Genie UI events classes
 */
class UIEventsValidationFunctions {
	
	private final static String screenShotNameFormat = "Failure_";
	
	
	/**
	 * For device only
	 * @return true, if currently swf running on AIR on Device
	 * playerType == Desktop for AIR
	 * playerType == Plugin for web
	 */
	static boolean isAIROnDevice(SWFApp appArg){
		if (appArg.playerType.toLowerCase().equals("desktop"))
				return true;
		
		return false;
	}
	
	 /**
	 * Device Specific. Get the Current timeout value and set a specific timeout
	 */
	static int setDeviceUIActionTimeOut(int Timeout){
		//Wait for some time set by user before executing any Step which is UI action on device
		try {
			Thread.sleep(GenieScript.EXECUTION_DELAY_BEFORE_STEP);
		} catch (InterruptedException e) {}
		
		SynchronizedSocket synchSocket=SynchronizedSocket.getInstance();    	
		int userTimeout = synchSocket.getTimeout();
		synchSocket.setTimeout(Timeout);
		
		return userTimeout;
	}
	
	 /**
	 * Device Specific-Check if script needs a termination based on user flags and accordingly raises exceptions
	 * This message also prints message and result in Script Log and Console
	 * @param result
	 * @throws Exception
	 */
	static void checkScriptTerminationDevice(Result result,int userTimeout,boolean bLogging) throws StepTimedOutException, StepFailedException{
		SynchronizedSocket synchSocket=SynchronizedSocket.getInstance();
		synchSocket.setTimeout(userTimeout);		
		checkScriptTerminationOptionalLoggingDesktop(result,bLogging,true);
	}

	/**
	 * Desktop Specific-Check if script needs a termination based on user flags and accordingly raises exceptions
	 * This message also prints message and result in Script Log and Console
	 * @param result
	 * @throws Exception
	 */
	static void checkScriptTerminationDesktop(Result result) throws StepTimedOutException, StepFailedException{
		checkScriptTerminationOptionalLoggingDesktop(result,true,false);
	}
	
	/**
	 * Desktop Specific-Check if script needs a termination based on user flags and accordingly raises exceptions
	 * This message also prints message and result in Script Log and Console
	 * @param result
	 * @throws Exception
	 */
	static void checkScriptTerminationDesktop(Result result, boolean bLogging) throws StepTimedOutException, StepFailedException{
		checkScriptTerminationOptionalLoggingDesktop(result, bLogging, false);
	}

	//Checks if the provided message satisfies timeout condition
	static boolean checkTimeOutCondition(String message){
		if (message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE")||
            message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE")||
            message.contains("PRELOAD_RETURNED_NOTHING") ||
            message.contains("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")||
            message.contains("SOCKET_CONNECTION_TIMEOUT_ON_REQUEST")||
            message.contains("GENIEID_DOES_NOT_MATCH_WITH_THE_GENIEID_OF_THE_EXECUTED_STEP")
		)
			return true;
		else
			return false;
	}
	
	/**
	 * If script needs a termination based on user flags and accordingly raises exceptions
	 * This method also does logging in Script Log optionally
	 * This message also prints message and result in Script Log and Console
	 * @param result
	 * @throws Exception
	 */
	static void checkScriptTerminationOptionalLoggingDesktop(Result result, boolean bLogging, boolean isDevice) throws StepTimedOutException, StepFailedException{
		ScriptLog scriptLog = ScriptLog.getInstance();
		if (bLogging)
			scriptLog.addTestStepResult(result.result? GenieLogEnums.GenieResultType.STEP_PASSED : GenieLogEnums.GenieResultType.STEP_FAILED);
		
		if(!result.result)
		{
			scriptLog.incrementFailureCounter();
			Utils.printErrorOnConsole("Result is: Step failed");
			if(result.message != null && result.message.length() > 0){
				if (result.message.toLowerCase().contains("exception:")){
					if (result.message.contains(Utils.SWF_NOT_PRESENT)){
						result.message = "The SWF on which action is being performed is not connected to Server";
						Utils.printErrorOnConsole("Error Message is:: " + result.message);
						if (bLogging)
							scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
					}
					else{
						Utils.printErrorOnConsole("Error Message is:: " + result.message);
						if (bLogging)
							scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_EXCEPTION);
					}
				}
				else{
					Utils.printErrorOnConsole("Error Message is:: " + result.message);
					if (bLogging)
						scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				}
			}
		}
		
		StaticFlags sf = StaticFlags.getInstance();
		if (!isDevice){
			//Captures ScreenShot when a step failed and CAPTURE_SCREENSHOT_ON_FAILURE flag is set
			//The Saved screenshot will be saved in folder containing ScriptLog
			if (!result.result && GenieScript.CAPTURE_SCREENSHOT_ON_FAILURE){
				Utils.printErrorOnConsole("Step Failed and CAPTURE_SCREENSHOT_ON_FAILURE is ON so capturing current ScreenShot");
				
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
		}
				
		if (bLogging && result.result){
			Utils.printMessageOnConsole("Result is: Step Passed");
			if(result.message != null && result.message.length() > 0){
				Utils.printMessageOnConsole("Message Recieved is:: " + result.message);
				
				scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_INFO);
			}
		}
		
		// Throws Exception when a Step times out and EXIT_ON_TIMEOUT flag is set
		if (checkTimeOutCondition(result.message)&& GenieScript.EXIT_ON_TIMEOUT)
        {
            Utils.printMessageOnConsole("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set");
            if (bLogging)
            	scriptLog.addTestStepMessage("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
            throw new StepTimedOutException();                                                            
        }
		
		// Throws Exception when a Step fails and EXIT_ON_FAILURE flag is set
        if (result.result == false && GenieScript.EXIT_ON_FAILURE){
			Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
			if (bLogging)
				scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			throw new StepFailedException();                                                            
		}				
	}

	  
	/**
	 * Change the color of genieImage to UIGenieImage
	 */
	static void changetoUIGenieIcon(SWFApp application) throws StepFailedException{
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		
		if (StaticFlags.getInstance().wasSwfDeadOnce(application.name)){
			//Means, swf becomes alive after disappearing
			StaticFlags sf = StaticFlags.getInstance();
			sf.conenctToSwf(application.name);
		}
		
		Result result = sc.doAction(application.name, "enableUIActions", "");
		if (!result.message.equals(Utils.SWF_NOT_PRESENT)){
			if (!result.result){
				throw new StepFailedException("Not able to bring on Icon required for executing UI Actions");
			}
		}else {
			application.isConnected = false;
			StaticFlags sf = StaticFlags.getInstance();
			sf.pushClosedSwf(application.name);
			throw new StepFailedException();
		}
	}

	/**
	 * Change the color of genieImage from UIGenieImage to previous genieImage
	 */
	static void changefromUIGenieIcon(SWFApp application) throws StepFailedException{
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		
		if (StaticFlags.getInstance().wasSwfDeadOnce(application.name))	{
			//Means, swf becomes alive after disappearing
			StaticFlags sf = StaticFlags.getInstance();
			sf.conenctToSwf(application.name);
		}
		
		Result result = sc.doAction(application.name, "disableUIActions", "");
		if (!result.message.equals(Utils.SWF_NOT_PRESENT)){
			if (!result.result){
				throw new StepFailedException("Not able to bring on Icon required for executing UI Actions");
			}
		}else {
			application.isConnected = false;
			StaticFlags sf = StaticFlags.getInstance();
			sf.pushClosedSwf(application.name);
			throw new StepFailedException(Utils.SWF_NOT_PRESENT);
		}
	}
	
	static Result parseUIResult(Result result, String operationName)
	{
		if(result.message.contains("<ReturnStatus>") && result.message.contains("</ReturnStatus>"))
		{
	        String actionStatus=Utils.getTagValue(result.message,"ReturnStatus");
        	
        	if (actionStatus.equalsIgnoreCase("SUCCESS")){
        		result.result=true;
        		result.message = operationName + " Operation performed successfully.";
        	}
        	else
        		result.message = actionStatus;
		}
		return result;
	}
	
}
