
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

import org.w3c.dom.Document;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.iexecutor.components.IGenieTextInput;

import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.internalLog.ScriptLog;

/**
 * This class contains functions to be executed on TextInput object
 * 
 * @since Genie 0.4
 */
public class GenieTextInput extends GenieComponent implements IGenieTextInput{

	/**
	 * Basic TextInput Component Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieTextInput(String genieID, SWFApp SWF) {
		super(genieID, SWF);
	}
	
	//========================================================================================
	// Some public exposed methods for a TextInput object
	//========================================================================================
	
	/**
	 * Select text of input box from startIndex to endIndex
	 * 
	 * @param  startIndex
	 * 		Starting Index as integer from where the text select needs to start
	 * 
	 * @param  endIndex
	 * 		Ending Index as integer till where the text select needs to end
	 * 
	 * @return
	 * 		Boolean value indicating the result of selectText action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */	
	public boolean selectText(int startIndex, int endIndex)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(startIndex), String.valueOf(endIndex));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.SELECT_TEXT_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Types the given text on TextInput Control
	 * 
	 * @param  input
	 * 		The text to type on a textInput as string
	 * 
	 * @param  Preload
	 * 		This is used to pass params to preload. e.g. if the object is invisible and user still wants to perform the 
	 * 		action on this object then just pass false.
	 * 
	 * @return
	 * 		Boolean value indicating the result of input action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean input(String input, String... Preload)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(input);
		
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.INPUT_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList
				);
		
		 
		if(Preload.length > 0)
		{
			//SCA
			ArrayList<String> preloadArgsList = Utils.getArrayListFromStringParams(Preload[0]);
			ec.setPreloadArgs(preloadArgsList);
		}
		return ec.performAction();
	}
	
	/**
	 * Presses a key on TextInput Control
	 * 
	 * @param  splChar
	 * 		The Key to Press (or type). Example "ENTER", "ESCAPE" etc
	 * 
	 * @param  Preload
	 * 		This is used to pass params to preload. e.g. if the object is invisible and user still wants to perform the 
	 * 		action on this object then just pass false.
	 * 
	 * @return
	 * 		Boolean value indicating the result of Type action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean type(String splChar, String... Preload)throws StepFailedException, StepTimedOutException{
		return ComponentHelper.type(this, splChar, Preload);
	}
	
	//========================================================================================
	// Some public exposed methods for a TextArea object
	//========================================================================================
	
	/**
	 * Scrolls the scrollBar
	 * <p>
	 * <b>This method applies only to TextArea Flex Component</b>
	 * 
	 * @param  scrollPosition
	 * 		The new scroll position.
	 * 
	 * @param scrollDetail
	 * 	Scroll detail -
	 * 	<ul> 
	 * 		<li>1 - at Bottom</li>
	 * 		<li>2 - at Left</li>
	 * 		<li>3 - at Right</li>
	 * 		<li>4 - at Top</li>
	 * 		<li>5 - line Down</li>
	 * 		<li>6 - line Left</li>
	 * 		<li>7 - line Right</li>
	 * 		<li>8 - line Up</li>
	 * 		<li>9 - page Down</li>
	 * 		<li>10 - page Left</li>
	 * 		<li>11 - page Right</li>
	 * 		<li>12 - page Up</li>
	 * 		<li>13 - thumb Position</li>
	 * 		<li>14 - thumb Track</li>
	 * 	</ul>
	 * 
	 * @param scrollDirection
	 * 	scroll direction -
	 * 	<ul> 
	 * 		<li>1 - "horizontal"</li>
	 * 		<li>2 - "vertical" </li>
	 *  </ul>
	 *  
	 * @return 
	 * 		Boolean value indicating the result of Scroll action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.7
	 */
	public boolean scroll(int scrollPosition, int scrollDetail, int scrollDirection) throws StepFailedException, StepTimedOutException{
		return ComponentHelper.scroll(this, scrollPosition, scrollDetail, scrollDirection);
	}
	
	/**
	 * Scrolls TextArea object
	 * <p>
	 * <b>This method applies only to TextArea Flex Component</b>
	 * 
	 * @param  scrollPosition
	 * 		The amount to scroll.
	 * 
	 * @return 
	 * 		Boolean value indicating the result of MouseScroll action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.7
	 */
	public boolean mouseScroll(int scrollPosition) throws StepFailedException, StepTimedOutException{
		return ComponentHelper.mouseScroll(this, scrollPosition);
	}
	
	/**
	 * DoubleClick action to perform on TextInput/Area
	 * 
	 * @return
	 * 		Boolean value indicating the result of doubleClick action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	public boolean doubleClick()throws StepFailedException, StepTimedOutException {
		return ComponentHelper.doubleClick(this,"");
	}
	
	/**
	 * Checks the current focus property of the component (textinput/text area). This function is available for mx and spark component only
	 * 
	 * @return
	 * 		Boolean value indicating whether the compone tis currently in focus or not
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.1
	 */
	public boolean checkFocus()throws StepFailedException, StepTimedOutException
	{
		class GetValueExecuteAction extends ExecuteActions
		{
			String temp = "";
			public GetValueExecuteAction(
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
			}

			protected void initLogs()
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("CheckFocus", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, this.getClass().getSimpleName());
				addTestStepInfo();
				int l = args.size();
				for(int i=0; i<l; i++)
				{
					scriptLog.addTestStepParameter("PropertyName", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(i));
				}	
			}
			
			protected String prepareArgs(ArrayList<String> args)
			{
				int l = args.size();
				String[] arr = new String[l];
				for(int i=0; i < l; i++)
				{
					arr[i] = args.get(i);
				}
				String inputData = gc.createPreloadDataForValue(gc.getGenieID(), arr);
				return inputData;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(), BaseEvent.CHECKFOCUS, inputData);				
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);

				try{
					temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
					bresult =  Boolean.parseBoolean(temp);
				}catch(Exception e){
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
				
				try{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}
				catch(RuntimeException e)
				{
					message = "";
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieTextInput.checkFocus"+e.getMessage());
				}
				catch(Exception e)
				{
					message = "";
				}

				Result res = new Result();
				res.result = bresult;
				res.message = message;
				
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();;		
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);
		
		dg.performAction();
		
		String propValue = dg.temp;
		boolean finalPropValue=false;
		
		//Coverting the string result to boolean value
		if (propValue.equalsIgnoreCase("true"))
			 finalPropValue=true;		    		
		
		return finalPropValue;
	}
}
