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

package com.adobe.genie.executor.components;

import java.util.ArrayList;

import com.adobe.genie.executor.GenieScript;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.StepFailedException;
import com.adobe.genie.executor.exceptions.StepTimedOutException;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.iexecutor.components.IExecuteActions;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.internalLog.ScriptLog;

/* Following are some instructions while using this class:
 * - Do not override its public method
 * - You can override its protected methods
 * - performAction function defines an algorithm of executing an action
 * - There are some check functions which can be modified, and will be applicable for all components
 */

/**
 * This class is for performing execution of a step. This is used by all GenieComponent classes to 
 * compose and send playback info to Genie preload. There are various protected methods which can 
 * be overridden, to alter their default behavior.
 * <p>
 * It basically is a mean to define an event which needs to be performed on a component
 *
 * @since Genie 0.8
 */
public class ExecuteActions implements IExecuteActions{
	
	GenieComponent gc;
	String eventName;
	GenieStepType stepType; 
	String className;
	ArrayList<String> args;
	ArrayList<String> preload = null;
	boolean checkForVisibility = true;
	Result componentFoundResult = new Result();
	boolean bLogging = true;
	/**
	 * All required variables are initialized in constructor itself. The constructor also
	 * waits for the component to appear on stage.
	 * 
	 * @param genieComponent
	 * 		Reference to an object of Component
	 * 
	 * @param evName
	 * 		Name of Event which needs to be dispatched on component
	 * 
	 * @param stType
	 * 		Type of Step. In most cases it should be GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE
	 * 
	 * @param clName
	 * 		Name of GenieComponent Class which is instantiating ExecuteActions. This info is used 
	 * 		while writing Genie Script log.  
	 * 
	 * @param args
	 * 		Any Arguments required to successfully construct the desired event.
	 * 		Example: Text to be typed is an argument in case of type event
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType
	 * 
	 * @since Genie 0.8
	 */
	public ExecuteActions(
			GenieComponent genieComponent,
			String evName, 
			GenieStepType stType, 
			String clName, 
			ArrayList<String> args
			)
	{
		initialize(genieComponent,evName,stType,clName,args);
	}
	
	/**
	 * All required variables are initialized in constructor itself. The constructor also
	 * waits for the component to appear on stage.
	 * 
	 * @param genieComponent
	 * 		Reference to an object of Component
	 * 
	 * @param evName
	 * 		Name of Event which needs to be dispatched on component
	 * 
	 * @param stType
	 * 		Type of Step. In most cases it should be GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE
	 * 
	 * @param clName
	 * 		Name of GenieComponent Class which is instantiating ExecuteActions. This info is used 
	 * 		while writing Genie Script log.  
	 * 
	 * @param args
	 * 		Any Arguments required to successfully construct the desired event.
	 * 		Example: Text to be typed is an argument in case of type event
	 * 
	 * @param checkForVisibility
	 * 		If set to true, GenieComponent's visibility is checked before playback
	 * 
	 * @see com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType
	 * 
	 * @since Genie 1.0
	 */
	public ExecuteActions(
			GenieComponent genieComponent,
			String evName, 
			GenieStepType stType, 
			String clName, 
			ArrayList<String> args,
			boolean checkForVisibility
			)
	{
		this.checkForVisibility = checkForVisibility;
		initialize(genieComponent,evName, stType, clName, args);
	}
	
	
	/**
	 * Performs the requested action on given Component
	 * 
	 * @return
	 * 		Boolean value indicating result of Action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	public boolean performAction()  throws StepFailedException, StepTimedOutException
	{
		boolean ret = false;
		initLogs();
		
		//Adding one second delay before running any action so that components are initialized before any action is performed on them
		try{
			Thread.sleep(1000);
		}catch(Exception e){								
			StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
		}
		
		try{
			Thread.sleep(GenieScript.EXECUTION_DELAY_BEFORE_STEP);
		}catch(Exception e)
		{
			StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
		}
		
		if (beforePrepareArgsCheck())
		{
			String inputData = prepareArgs(args);
			
			if (beforeSocketActionCheck())
			{
				Result result = null;
				if(componentFoundResult.result)
				{
					if(StaticFlags.getInstance().getGestureEnabled())
					{
						StaticFlags.getInstance().setGestureAppName(gc.getAppName());
						StaticFlags.getInstance().addGestureEventData(inputData);
					}
					else
						result = doSocketAction(inputData);
				}
				else
				{
					//Do not perform action if Genie id is not found.
					result = new Result();
					result.result = false;
					result.message = componentFoundResult.message;
					if(bLogging)
						gc.updateResult(result);
					return false;
				}
				if (afterSocketActionCheck() && !StaticFlags.getInstance().getGestureEnabled())
				{	
					parseResult(result);		
					if (afterParseResultCheck())
					{
						return result.result;
					}
				}
			}
		}
		
		return ret;
	}
	
	
	//All protected methods can be overridden
	 
	/**
	 * Override this method if some code needs to be executed 
	 * before prepareArgs() method is called
	 * 
	 * @return
	 * 		Boolean value indicating result of Action
	 * 
	 * @since Genie 0.8
	 */
	protected boolean beforePrepareArgsCheck()
	{
		return true;
	}
	
	/**
	 * Override this method if some code needs to be executed before actual call 
	 * to Genie Preload for executing the action is made.
	 * 
	 * @return
	 * 		Boolean value indicating result of Action
	 * 
	 * @since Genie 0.8
	 */
	protected boolean beforeSocketActionCheck()
	{
		return true;
	}
	
	/**
	 * Override this method if some code needs to be executed after actual call 
	 * to Genie Preload for executing the action has been made.
	 * 
	 * @return
	 * 		Boolean value indicating result of Action
	 * 
	 * @since Genie 0.8
	 */
	protected boolean afterSocketActionCheck()
	{
		return true;
	}
	
	/**
	 * Override this method if some code needs to be executed after parsing of result 
	 * returned by Peload is done.
	 * 
	 * @return
	 * 		Boolean value indicating result of Action
	 * 
	 * @since Genie 0.8
	 */
	protected boolean afterParseResultCheck()
	{
		return true;
	}
	
	/**
	 * This method initializes and adds Genie id and component name in log file.
	 * Override this method if default logging needs to be modified.
	 * 
	 * @since Genie 0.8
	 */
	protected void initLogs()
	{
		ScriptLog scriptLog = ScriptLog.getInstance();
		scriptLog.addTestStep(eventName, stepType, className);
		Utils.printMessageOnConsole("GenieID of Component: " + gc.getGenieID());
		scriptLog.addTestStepParameter("ComponentName", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, className);
		scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, gc.getGenieID());
		int argsLen = args.size();
		for (int i=0; i < argsLen; i++)
		{
			scriptLog.addTestStepParameter("Param" + (i+1), GenieLogEnums.GenieParameterType.PARAM_INPUT, args.get(i));
		}
	}
	
	/**
	 * This method creates array of arguments to be sent to GeniePreload required for 
	 * performing the action. 
	 *
	 * 	@param args
	 * 		ArrayList of arguments to passed to Preload for performing action.
	 *  @return
	 * 		rerurns String in XML format to be sent to Preload. 
	 * 
	 * @since Genie 0.8
	 */
	protected String prepareArgs(ArrayList<String> args)
	{
		BaseEvent be = new BaseEvent();
		int argsLen = args.size();
		for (int i=0; i < argsLen; i++)
		{
			be.arguments.add(args.get(i));
		}
		
		if(preload != null && preload.size() > 0)
		{
			argsLen = preload.size();
			for (int i=0; i < argsLen; i++)
			{
				be.preloadArguments.add(preload.get(i));
			}
		}
		
		String inputData = "";
		if(eventName.toLowerCase().indexOf("touch") > -1 || eventName.toLowerCase().indexOf("finger") > -1)
			inputData = gc.createTouchPreloadData(gc.getGenieID(), eventName, be);
		else
			inputData = gc.createPreloadData(gc.getGenieID(), eventName, be);
		
		return inputData;
	}
	
	/**
	 * Sets Preload specific argument list  
	 */
	protected void setPreloadArgs(ArrayList<String> preloadArgs)
	{
		if(preloadArgs.size() > 0)
			preload = preloadArgs;
	}

	/**
	 * This method parses and updates result
	 * 
	 * 	@param result
	 * 		Result object to be parsed
	 * 
	 *  @return
	 * 		returns String in XML format to be sent to Preload.
	 *  
     * @throws Exception
	 * @since Genie 0.8
	 */
	protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
	{
		gc.updateResult(result);
	}
	
	/**
	 * This method sends event information to Preload and waits for the reply. 
	 *  
	 *  @param inputData
	 *  	XML String returned by prepareArgs() method.
	 *  @return
	 * 		Result object specifying the result of the operation.
	 *  
     * @since Genie 0.8
	 */
	protected Result doSocketAction(String inputData)
	{
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		Result result = sc.doAction(gc.getAppName(), BaseEvent.PLAYBACK, inputData);
		
		return result;
	}
	
	private void initialize(GenieComponent genieComponent,
			String evName, 
			GenieStepType stType, 
			String clName, 
			ArrayList<String> ags
			)
	{
		gc = genieComponent;
		eventName = evName;
		stepType = stType;
		className = clName;
		args = ags;
		
		//Wait for the components only if we have not waited earlier in GenieComponent's constructor.
		if(!gc.bWait)
		{
			String updatedGenieID = StaticFlags.getInstance().getUpdatedGenieId(genieComponent.genieID); 
			if(updatedGenieID != null)
			{
				genieComponent.genieID = updatedGenieID;
			}
			int timeOutValue = SynchronizedSocket.getInstance().getTimeout();
			try{
				if(checkForVisibility)
					componentFoundResult = gc.waitForComponent(false,true,true,timeOutValue);
				else
					componentFoundResult = gc.waitForComponent(false,true,false,timeOutValue);
			}
			catch(StepTimedOutException e)
			{
				componentFoundResult.result = false;
			}
			catch(StepFailedException e)
			{
				componentFoundResult.result = false;
			}
		}
		else
		{
			//Since we are not waiting for component lets set componentFound = true
			componentFoundResult.result = true;
		}
	}
	
}
