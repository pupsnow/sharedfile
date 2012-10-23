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
import com.adobe.genie.iexecutor.components.IGenieComboBox;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.internalLog.ScriptLog;

import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.*;

/**
 * This class contains functions to be executed on ComboBox object
 * 
 * @since Genie 0.4
 */
public class GenieComboBox extends GenieComponent implements IGenieComboBox{

	/**
	 * Basic ComboBox Component Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieComboBox(String genieID, SWFApp SWF) {
		super(genieID, SWF);
	}
	
	//========================================================================================
	// Some public exposed methods for a ComboBox object
	//========================================================================================
	
	/**
	 * Opens the Combobox control
	 * 
	 * @return
	 * 		Boolean value indicating the result of Open action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean open() throws StepFailedException, StepTimedOutException {
		return ComponentHelper.open(this);
	}
	
	/**
	 * Select an item in ComboBox object by value of item
	 * This is the one that comes up while recording GenieScript
	 * 
	 * @param  value
	 * 		String value of the item to be selected.
	 * 
	 * @return
	 * 		Boolean value indicating the result of Select action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean select(String value) throws StepFailedException, StepTimedOutException  {
		return ComponentHelper.select(this, value);
	}
	
	/**
	 * Performs the action specified in the keyString argument using keyboard on ComboBox
	 * 
	 * @param  keyCode
	 * 		A constant that indicates which key or key combination, if any, was pressed while this operation took place
	 * 		e.g. if down arrow key is pressed then "DOWN"	
	 * 
	 * @return
	 * 		Boolean value indicating the result of Select action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.9
	 */
	public boolean type(String keyCode) throws StepFailedException, StepTimedOutException  {
		return ComponentHelper.type(this, keyCode);
	}
	
	/**
	 * Get the value of the items of the ComboBox in a string array
	 * 
	 * @param strLabelName
	 * 		This is an optional parameter. This represent the "NAME OF THE PROPERTY" using which combo box was populated from the object.
	 * 		This should ONLY be passed when the combo box is custom combo box.
	 * 
	 * @return
	 * 		String array having values of items in the ComboBox. In case of Error blank string array is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	public String[] getComboBoxItems(String... strLabelName)throws StepFailedException, StepTimedOutException
	{
		class ComboBoxExecuteAction extends ExecuteActions
		{
			String propValue = "";
			private boolean isDebugMode = false;
			public ComboBoxExecuteAction(
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				StaticFlags sf = StaticFlags.getInstance();
				this.isDebugMode = sf.isdebugMode();
			}
			protected void initLogs()
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("GetComboBoxItems", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, this.getClass().getSimpleName());
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
				Result result = sc.doAction(app.name, BaseEvent.GETCOMBOBOXITEMS, inputData);
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);

				try{
					String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
					bresult =  Boolean.parseBoolean(temp);
				}catch(Exception e){
					if (this.isDebugMode)
						Utils.printErrorOnConsole("Exception occured"+e.getMessage());				
				}
				
				try
				{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComboBox.getComboBoxItems"+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult)
				{
					try{
						propValue = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Retrieved ItemList Value: " + propValue);
					}catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in Retrieving items values");
					else
						Utils.printErrorOnConsole(message);
				}
				
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStepParameter("PropertyValue", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, propValue);
				
				Result res = new Result();
				res.result = bresult;
				res.message = message;
				gc.updateResult(res);
			}
		}		
		
		ArrayList<String> argsList;
		if(strLabelName.length > 0)
			argsList = Utils.getArrayListFromStringParams(String.valueOf(strLabelName[0]));
		else
			argsList = Utils.getArrayListFromStringParams("");
		ComboBoxExecuteAction dg = new ComboBoxExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		
		dg.performAction();
		
		String propValue = dg.propValue;
		//SCA
		String[] arrData =propValue.split("\\|"); 
		return arrData; 
	}
	
	/**
	 * Get the item count of the ComboBox
	 * 
	 * @param strLabelName
	 * 		This is an optional parameter. This represent the "NAME OF THE PROPERTY" using which combo box was populated from the object.
	 * 		This should ONLY be passed when the combo box is custom combo box.
	 * 
	 * @return
	 * 		item count in the ComboBox. In case of Error 0 is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	public int getItemCount(String... strLabelName)throws StepFailedException, StepTimedOutException
	{
		class ComboBoxExecuteAction extends ExecuteActions
		{
			String propValue = "";			
			public ComboBoxExecuteAction(
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
				scriptLog.addTestStep("GetComboBoxItems", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, this.getClass().getSimpleName());
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
				Result result = sc.doAction(app.name, BaseEvent.GETCOMBOBOXITEMS, inputData);
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);

				try{
					String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
					bresult =  Boolean.parseBoolean(temp);
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());		
				}
				
				try
				{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComboBox.getItemCount"+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try{
						propValue = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Retrieved ItemCount Value: " + propValue);
					}catch(Exception e){
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in Retrieving ItemCount Value");
					else
						Utils.printErrorOnConsole(message);
				}
				
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStepParameter("PropertyValue", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, propValue);
				
				Result res = new Result();
				res.result = bresult;
				res.message = message;
				gc.updateResult(res);
			}
		}		
		
		ArrayList<String> argsList;
		if(strLabelName.length > 0)
			argsList = Utils.getArrayListFromStringParams(String.valueOf(strLabelName[0]));
		else
			argsList = Utils.getArrayListFromStringParams("");
		ComboBoxExecuteAction dg = new ComboBoxExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		
		dg.performAction();
		
		String propValue = dg.propValue;
		//SCA
		String[] arrData = propValue.split("\\|");		
		return arrData.length; 
	}
}
