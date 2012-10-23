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

import java.awt.Point;
import java.util.ArrayList;

import com.adobe.genie.executor.GenieLocatorInfo;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.StepFailedException;
import com.adobe.genie.executor.exceptions.StepTimedOutException;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.executor.uiEvents.UILocal;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.iexecutor.components.IGenieDisplayObject;
import com.adobe.genie.utils.Utils;

/**
 * This class contains functions to be executed on DisplayObject
 * 
 * @since Genie 1.2
 */

public class GenieDisplayObject extends GenieComponent implements IGenieDisplayObject{
	/**
	 * Basic DisplayObject Component Constructor, this initializes the components
	 * and sets startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of the Component
	 * 
	 * @param SWF
	 * 		SWF application object to which Genie component belongs.
	 */
	public GenieDisplayObject(String genieID, SWFApp SWF){
		super(genieID , SWF,false);
		try{
			SynchronizedSocket sc = SynchronizedSocket.getInstance();
			super.waitForComponent(false, false, false, sc.getTimeout());
			super.bWait = true;
		}catch(Exception e){
			StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
		}
	}
	
	//========================================================================================
	// Some public exposed methods for a Accordion object
	//========================================================================================
	
	/**
	 * Clicks on the specific co-ordinates natively using mouse events
	 * 
	 * @param  localX
	 * 		localX value of the component where mouse needs to click
	 * 
	 * @param  localY
	 * 		localY value of the component where mouse needs to click
	 * 
	 * @param  eventPhase
	 * 		Phase of the event i.e. 1 -- Capturing phase (CAPTURING_PHASE)    2 -- Targeting phase (AT_TARGET)    3 -- Bubbling phase (BUBBLING_PHASE)
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.2
	 */
	public boolean click(Number localX, Number localY, int eventPhase)throws StepFailedException, StepTimedOutException{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(localX),
				String.valueOf(localY),
				String.valueOf(eventPhase));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.CLICKATLOCATION_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList,
				false);
		
		return ec.performAction();
	}
	
	/**
	 * Clicks on the specific co-ordinates natively using mouse events
	 * 
	 * @param  localX
	 * 		localX value of the component where mouse needs to click
	 * 
	 * @param  localY
	 * 		localY value of the component where mouse needs to click
	 * 
	 * @param  stageX
	 * 		stageX value of the component where mouse needs to click
	 * 
	 * @param  stageY
	 * 		stageY value of the component where mouse needs to click
	 * 
	 * @param  stageWidth
	 * 		width of the flash player stage
	 * 
	 * @param  stageHeight
	 * 		height of the flash player stage
	 * 
	 * @param  eventPhase
	 * 		Phase of the event i.e. 1 -- Capturing phase (CAPTURING_PHASE)    2 -- Targeting phase (AT_TARGET)    3 -- Bubbling phase (BUBBLING_PHASE)
	 * 
	 * @param  bMoveMouse
	 * 		Boolean than will be passed for moving the mouse. If true mouse will be physically moved to the location before clicking.	
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4
	 */
	public boolean click(Number localX, Number localY, Number stageX, Number stageY, Number stageWidth, Number stageHeight, int eventPhase, boolean bMoveMouse)throws StepFailedException, StepTimedOutException{
		
		//The below line is commented because currently there is no way to map
		//localX/localY or stageX/stageY as per the stage width and height.
		
		//Point p = getStageCoordinates(stageX, stageY, stageWidth, stageHeight);
		
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(localX),
				String.valueOf(localY),
				String.valueOf(stageX),
				String.valueOf(stageY),
				String.valueOf(stageWidth),
				String.valueOf(stageHeight),
				String.valueOf(eventPhase),
				String.valueOf(bMoveMouse));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.CLICKATLOCATION_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList,
				false);
		
		Point p = new Point(Integer.parseInt(stageX.toString()), Integer.parseInt(stageY.toString()));
		boolean bPlayback = true;
		
		if(bMoveMouse)
		{
			UILocal u = new UILocal(app);
			try{
				bPlayback = u.moveMouse(p.x, p.y, false);
			}
			catch (Exception e){
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep(BaseEvent.CLICKATLOCATION_EVENT, GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, getClass().getSimpleName());
				Utils.printMessageOnConsole("GenieID of Component: " + super.getGenieID());
				scriptLog.addTestStepParameter("ComponentName", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, getClass().getSimpleName());
				scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, super.getGenieID());
				
				int argsLen = argsList.size();
				for (int i=0; i < argsLen; i++)
				{
					scriptLog.addTestStepParameter("Param" + (i+1), GenieLogEnums.GenieParameterType.PARAM_INPUT, argsList.get(i));
				}
				
				Result result = new Result();

				result.result = false;
				result.message = "Failed to move mouse on application " + app.name;
				result.message += " because either application/component was not in focus or issue occurred at genie end";
				scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_FAILED);
				
				throw new StepFailedException();      
				
			}
		}
		
		if(bPlayback)
		{
			return ec.performAction();
		}
		else{
			ScriptLog scriptLog = ScriptLog.getInstance();
			scriptLog.addTestStep(BaseEvent.CLICKATLOCATION_EVENT, GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, getClass().getSimpleName());
			Utils.printMessageOnConsole("GenieID of Component: " + super.getGenieID());
			scriptLog.addTestStepParameter("ComponentName", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, getClass().getSimpleName());
			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, super.getGenieID());
			
			int argsLen = argsList.size();
			for (int i=0; i < argsLen; i++)
			{
				scriptLog.addTestStepParameter("Param" + (i+1), GenieLogEnums.GenieParameterType.PARAM_INPUT, argsList.get(i));
			}
			
			Result result = new Result();

			result.result = false;
			result.message = "Failed to move mouse on application " + app.name;
			result.message += " because either application/component was not in focus or issue occurred at genie end";
			scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_FAILED);
		}
		return false;
	}
	
	/**
	 * Doubleclicks on the specific co-ordinates natively using mouse events
	 * 
	 * @param  localX
	 * 		localX value of the component where mouse needs to click
	 * 
	 * @param  localY
	 * 		localY value of the component where mouse needs to click
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.2
	 */
	public boolean doubleClick(Number localX, Number localY)throws StepFailedException, StepTimedOutException{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(localX),
				String.valueOf(localY));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.DOUBLE_CLICKATLOCATION_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList,
				false);
		
		return ec.performAction();
	}
	
	/**
	 * Presses the key for the specific time duration and then releases it automatically
	 * 
	 * @param  keyString
	 * 		This corresponds to the strings associated with the arrows e.g. DOWN and UP
	 * 
	 * @param  nDuration
	 * 		Duration in milli seconds for which key needs to be pressed
	 * 
	 * @return
	 * 		Boolean value indicating the result of the action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4
	 */
	public boolean performKeyAction(String keyString, int nDuration) throws StepFailedException, StepTimedOutException{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(keyString),
				String.valueOf(nDuration));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.PERFORM_KEYACTION,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList
				);
		//This thread is to make sure that next step is not executed until key up is done from preload end
		//For this to happen for the duration for which keydown needs to happen, thread sleep is done
		try 
		{
			Thread.sleep(nDuration);
		} catch (InterruptedException e) 
		{
			e.printStackTrace();
		}
		return ec.performAction();
	}
	
	/**
	 * Presses the key for the specific time duration 
	 * 
	 * @param  keyString
	 * 		This corresponds to the strings associated with the arrows e.g. DOWN and UP
	 * 
	 *  @param keyModifier
	 * 	keyModifier Detail -
	 * 	<ul> 
	 * 		<li>1 - "ctrlKey"</li>
	 * 		<li>2 - "shiftKey" </li>
	 * 		<li>4 - "altKey" </li>
	 *  </ul>
	 *  
	 * @param  nDuration
	 * 		Duration in milli seconds for which key needs to be pressed
	 * 
	 * @return
	 * 		Boolean value indicating the result of the action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4
	 */
	public boolean performKeyAction(String keyString, int keyModifier, int nDuration) throws StepFailedException, StepTimedOutException{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(keyString),
				String.valueOf(keyModifier),
				String.valueOf(nDuration));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.PERFORM_KEYACTION,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList
				);
		//This thread is to make sure that next step is not executed until key up is done from preload end
		//For this to happen for the duration for which keydown needs to happen, thread sleep is done
		try 
		{
			Thread.sleep(nDuration);
		} catch (InterruptedException e) 
		{
			e.printStackTrace();
		}
		return ec.performAction();
	}
	
	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @param name
	 * 		Name of property. For example - Pass "label" to get label of GenieButton control.
	 * 
	 * @return 
	 * 		Current value of Property as string. In case of Error blank string is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.5			
	 */
	public String getValueOf(String name) throws StepFailedException, StepTimedOutException
	{
		return getValueOfDisplayObject(name,true);
	}
	
	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @param name
	 * 		Name of property. For example - Pass "label" to get label of GenieButton control.
	 * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Current value of Property as string. In case of Error blank string is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.0			
	 */
	public String getValueOf(String name,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		String propValue = getValueOfDisplayObject(name, bLogging);		
		return propValue; 
	}
	
	/**
	 * Gets value of given property for GenieDisplayObject control with logging.
	 * 
	 * @param name
	 * 		Name of property. For example - Pass "label" to get label of GenieButton control.
	 * 
	 * @return 
	 * 		Current value of Property as string. In case of Error blank string is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public String getValueOfDisplayObject(String name) throws StepFailedException, StepTimedOutException
	{
		return getValueOfDisplayObject(name,true);
	}
	
	/**
	 * Gets value of given property for GenieDisplayObject control with optional logging.
	 * 
	 * @param name
	 * 		Name of property. For example - Pass "label" to get label of GenieButton control.
	 * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Current value of Property as string. In case of Error blank string is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public String getValueOfDisplayObject(String name,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(name);
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, BaseEvent.GETVALUEOFDISPLAYOBJECT, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList,false);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String propValue = dg.propValue;		
		return propValue; 
	}
	/**
	 * This method returns parent of a GenieComponent
	 * 
	 * @return 
	 * 		Parent of given GenieComponent as GenieComponent
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 0.9
	 */
	public GenieDisplayObject getParent() throws StepTimedOutException,StepFailedException
	{
		GenieComponent component = super.getParent();
		return (new GenieDisplayObject(component.genieID, component.app));
	}
	
	/**
	 * This method returns children of GenieDisplayObject as array of GenieDisplayObject which match properties specified in GenieLocatorInfo
	 * 
	 * @param info
     *      GenieLocatorInfo, which specifies which properties to match when getting children  
     * 
     * @param bRecursive
     * 		This should be set TRUE if user want to fetch the child recursively for the given genieID
     * 		This should be set FALSE if user want to fetch the immediate children and don't want to go recursively for the given genieID
     *      
	 * @return 
	 * 		Array of child GenieDisplayObject
	 * 
	 * @throws Exception
	 *   
	 * @see com.adobe.genie.executor.GenieLocatorInfo
	 * 
	 * @since Genie 1.4
	 *  
	 */
	public GenieDisplayObject[] getChildren(GenieLocatorInfo info, boolean bRecursive) throws StepTimedOutException, StepFailedException
	{
		return getChildren(info,bRecursive,true);
	}
	
	/**
	 * This method returns children of GenieDisplayObject as array of GenieDisplayObject which match properties specified in GenieLocatorInfo
	 * 
	 * @param info
     *      GenieLocatorInfo, which specifies which properties to match when getting children  
     * 
     * @param bRecursive
     * 		This should be set TRUE if user want to fetch the child recursively for the given genieID
     * 		This should be set FALSE if user want to fetch the immediate children and don't want to go recursively for the given genieID
     *      
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Array of child GenieDisplayObject
	 * 
	 * @throws Exception
	 *   
	 * @see com.adobe.genie.executor.GenieLocatorInfo
	 * 
	 * @since Genie 1.4
	 *  
	 */
	public GenieDisplayObject[] getChildren(GenieLocatorInfo info, boolean bRecursive,boolean bLogging) throws StepTimedOutException, StepFailedException
	{
		GenieComponent[] genieComponents = super.getChildren(info, bRecursive, bLogging);
		GenieDisplayObject[] genieDisplayObjects = new GenieDisplayObject[genieComponents.length];
		
		for (int i = 0; i < genieComponents.length; i++) {
			genieDisplayObjects[i] = new GenieDisplayObject(genieComponents[i].getGenieID(),genieComponents[i].app);
		}
		return genieDisplayObjects;
	}
	
	/**
	 * Gets the immediate child at a specified index.
	 * 
	 * @param index
	 *          the index of the child that needs to be returned
	 *          
	 * @return 
	 * 		Object as GenieDisplayObject{@link com.adobe.genie.executor.components.GenieDisplayObject}. In case of Error returns null
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public GenieDisplayObject getChildAt(int index) throws StepFailedException, StepTimedOutException
	{
		GenieComponent genieComponent = super.getChildAt(index);
		if(genieComponent != null)
		{
			GenieDisplayObject genieDisplayObject = new GenieDisplayObject(genieComponent.getGenieID(), genieComponent.app);
			return genieDisplayObject;
		}
		else
			return null;
	}
	
	
	//The below line is commented because currently there is no way to map
	//localX/localY or stageX/stageY as per the stage width and height.
	//This function will be used once the solution for getting the correct co-ordinates at preload end gets fixed.
//	 /**
//     * Get coordinates of stage x and stage y w.r.t 
//     */
//    private Point getStageCoordinates(Number stageX, Number stageY, Number stageWidth, Number stageHeight) throws StepTimedOutException, StepFailedException{
//    	//Adding one second delay before running any action so that components are initialized before any action is performed on them
//    	
//    	ScriptLog scriptLog = ScriptLog.getInstance();
//    	String strCoodinates = "";
//		try
//		{
//			Thread.sleep(1000);
//		}catch(Exception e)
//		{
//			StaticFlags sf=StaticFlags.getInstance();
//			sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
//		}
//		
//    	try
//    	{
//    		//Get local co-ordinates of genie-id corresponding to application 
//    		SynchronizedSocket sc = SynchronizedSocket.getInstance();
//    	
//    		// Check if the Component Exists on Stage
//    		String strArgs = "<String>" + stageX.toString() + "," + stageY.toString() + "," + stageWidth.toString() + "," + stageHeight.toString() + "," + genieID.toString() + "</String>";
//	   		Result result = sc.doAction(app.name, "getStageCoordinates", strArgs);
//    		
//    		String coordinates = result.message;
//    		if(coordinates.contains("<x>") && coordinates.contains("<y>"))
//    		{
//    			float floatX = Float.parseFloat(coordinates.substring(coordinates.indexOf("<x>")+3, coordinates.indexOf("</x>")));
//    			float floatY  = Float.parseFloat(coordinates.substring(coordinates.indexOf("<y>")+3, coordinates.indexOf("</y>")));
//    			
//    			int x = (int)floatX;
//    			int y = (int)floatY;
//    			
//	    		Point genieCoordinates = new Point();
//	    		genieCoordinates.x = x;
//	    		genieCoordinates.y = y;
//	    		
//	    		return genieCoordinates;
//    		}
//    	}
//    	catch(Exception e)
//    	{
//    		if (e.getMessage().contains(Utils.SWF_NOT_PRESENT)){
//    			throw new StepFailedException(Utils.SWF_NOT_PRESENT);
//    		}
//    		else if (e.getMessage().contains(Utils.UI_ICON_NOT_VISIBLE_MESSAGE)) {
//    			throw new StepFailedException(Utils.UI_ICON_NOT_VISIBLE_MESSAGE);
//    		}
//    		else if (e.getMessage().contains(Utils.NO_RESPONSE_FROM_DEVICE_CONTROLLER)){
//    			throw new StepFailedException(Utils.NO_RESPONSE_FROM_DEVICE_CONTROLLER);
//    		}
//    	}
//    	
//    	return new Point(-1,-1);
//    }
	
}
