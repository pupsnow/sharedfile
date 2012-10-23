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

import java.awt.Dimension;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.lang.math.RandomUtils;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;



import com.adobe.genie.executor.GenieLocatorInfo;
import com.adobe.genie.executor.GenieScript;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieParameterType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieMessageType;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieResultType;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.StepFailedException;
import com.adobe.genie.executor.exceptions.StepTimedOutException;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.iexecutor.components.IGenieComponent;
import com.adobe.genie.utils.PicFinder;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

/**
 * This class is the parent class for every automatable Flex component. 
 * It provides basic features to child component classes. 
 * 
 * @since Genie 0.4
 */
public class GenieComponent implements IGenieComponent{

	protected String genieID;
	protected SWFApp app;
	protected boolean bWait = false; 
	private String screenShotNameFormat = "Failure_";
	
	/**
	 * Basic Genie Component Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieComponent(String genieID , SWFApp SWF)
	{
		this.genieID = genieID;
		this.app = SWF;
	}
	
	/**
	 * Basic Genie Component Constructor, this initializes the components
	 * and set startup parameters. 
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 * 
	 * @param bWait
	 * 		if set to true it waits for corresponding component to appear on stage until it times out
	 * 		if set to false it does not wait or check if the component is present on stage or not.
	 */
	public GenieComponent(String genieID , SWFApp SWF, boolean bWait)
	{
		this.genieID = genieID;
		this.app = SWF;
		
		String updatedGenieID = StaticFlags.getInstance().getUpdatedGenieId(genieID); 
		if(updatedGenieID != null)
		{
			this.genieID = updatedGenieID;
		}
		this.bWait = bWait;
		if(bWait)
		{
			try{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				waitForComponent(false,true,true,sc.getTimeout());
			}catch(Exception e){
				StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
			}
		}
	}
	
	/**
	 * Returns the GenieID of the component
	 * 
	 * @return
	 * 		GenieID as String of Current Component
	 * 
	 * @since Genie 0.8
	 */
	public String getGenieID()
	{
		return this.genieID;
	}
	
	/**
	 * Returns current Application Name
	 * 
	 * @return
	 * 		The Application name where this component belongs as String	
	 * 
	 * @since Genie 0.8
	 */
	public String getAppName()
	{
		return this.app.name;
	}

	//========================================================================================
	// Some public exposed methods for a generic Genie Component
	//========================================================================================

	/**
	 * Performs a click event on GenieComponent control.
	 * 
	 * @return 
	 * 		Boolean value indicating the result of Click action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean click() throws StepFailedException, StepTimedOutException
	{
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.CLICK_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				new ArrayList<String>()
				);
		return ec.performAction(); 
	}
	
	/**
	 * Checks if given component is available on stage and returns boolean 
	 * indicating the same
	 * 
	 * @return 
	 * 		true if it finds object on stage else false
	 * 
	 *  @since Genie 1.0		
	 */
	public boolean isPresent() 
	{
		boolean result = false;
		try{
			result = waitFor(0,false);
		}
		catch(RuntimeException e)
		{
			StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.isPresent"+e.getMessage());
			result = false;
		}
		catch(Exception e)
		{
			result = false;
		}
		return result;
	}
	
	/**
	 * Gets value of given property for GenieComponent control.
	 * 
	 * @param name
	 * 		Name of property. For example - Pass "label" to get label of GenieButton control.
	 * 
	 * @return 
	 * 		Current value of Property as string. In case of Error blank string is returned
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4			
	 */
	public String getValueOf(String name) throws StepFailedException, StepTimedOutException
	{
		return getValueOf(name,true);
	}
	/**
	 * Gets value of given property for GenieComponent control.
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
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(name);
		argsList = Utils.getXMLCompatibleStr(argsList);
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, BaseEvent.GETVALUEOF, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String propValue = dg.propValue;		
		return propValue; 
	}
	
	/**
	 * Gets value of given property for GenieComponent control. It always returns serialized XML of the object value.
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
	public String getValueOfObject(String name,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(name);
		argsList = Utils.getXMLCompatibleStr(argsList);
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, BaseEvent.GETVALUEOFOBJECT, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String propValue = dg.propValue;		
		return propValue; 
	}
	
	/**
	 * Capture Image of a given GenieComponent control at imagepath location with logging.
	 * Captured png image can be used only with compareImage Method,not with UiIamge.findImage method
	 * 
	 * @param imagePath
	 * 		image path location. For example - Pass "C:\\test.png".
	 * 
	 * @return 
	 * 		status of capturing image of component as Boolean
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean captureComponentImage(String imagePath) throws StepFailedException, StepTimedOutException
	{
		return captureComponentImage(imagePath,true);
	}
	
	
	/**
	 * Capture Image of a given GenieComponent control at imagepath location with optional logging
	 * Captured png image can be used only with compareImage Method,not with UiIamge.findImage method
	 *  
	 * @param imagePath
	 * 		Image path location where user want to save its file. For example - Pass "C:\\test.png".
	 * 
	 * @param bLogging
     *  	If passed as true, this step is logged in Genie script logs.
     *  	If passed as false, the step will not be part of Genie script log.
     *  
	 * @return 
	 * 		status of capturing image of component as Boolean
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean captureComponentImage(String imagePath,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class CaptureComponentImageExecuteAction extends ExecuteActions
		{
			Boolean captureComponentImageStatus = false;
			public CaptureComponentImageExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("CaptureComponentImage", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.CAPTURE_COMPONENT_IMAGE, inputData);				
				return result;
			}
			
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);
				
				try{
					if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
					{
						String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
						bresult =  Boolean.parseBoolean(temp);
					}
						
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
				}
				
				try{
					if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
					{
						message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
					}
					else
					{
						message = "";
					}
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.captureComponentImage "+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try
					{
						byte[] bytes = Base64.decode(message);
						String filepath = args.get(0);
						File outputFile = new File(filepath);
						Utils.createParentDirRecursivelyIfNotExist(outputFile.getParentFile());	
						if(!outputFile.exists())
							outputFile.createNewFile();
						BufferedImage bi = ImageIO.read(new ByteArrayInputStream(bytes)); // retrieve image
						ImageIO.write(bi, "png", outputFile);
						captureComponentImageStatus = true;
					}
					catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
						message = "Failed to save image :"+e.getMessage();
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in capturing component image");
					else
						Utils.printErrorOnConsole(message);
				}
				
				Result res = new Result();
				res.result = captureComponentImageStatus;
				
				if(captureComponentImageStatus)
				{
					res.message = "Component Image Saved Successfully at "+ args.get(0) + " location";
				}
				else
				{
					res.message = "Error occured in capturing component image :" + message;
				}
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("CaptureComponentImageStatus", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, new Boolean(captureComponentImageStatus).toString());
					gc.updateResult(res);
				}
			}
		}
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(imagePath);
		CaptureComponentImageExecuteAction dg = new CaptureComponentImageExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		return dg.captureComponentImageStatus; 
	}
	
	
	
	/**
	 * Capture Image of a given GenieComponent control and save it in temporary location.
	 * Captured png image can be used only with compareImage Method,not with UiIamge.findImage method
	 *  
	 * @return 
	 * 		imagePath as String
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public String captureComponentImage() throws StepFailedException, StepTimedOutException
	{
		return captureComponentImage(true);
	}
	
	
	/**
	 * Capture Image of a given GenieComponent control and save it in temporary location with optional logging.
	 * Captured png image can be used only with compareImage Method,not with UiIamge.findImage method
	 * 
	 * @param bLogging
     *  If passed as true, this step is logged in Genie script logs.
     *  If passed as false, the step will not be part of Genie script log.
     *  
	 * @return 
	 * 	imagePath as String
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public String captureComponentImage(boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class CaptureComponentImageExecuteAction extends ExecuteActions
		{
			Boolean captureComponentImageStatus = false;
			String filePath = "";
			public CaptureComponentImageExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("CaptureComponentImage", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.CAPTURE_COMPONENT_IMAGE, inputData);				
				return result;
			}
			
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);
				try{
					if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
					{
						String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
						bresult =  Boolean.parseBoolean(temp);
					}
						
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
				}
				
				try{
					if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
					{
						message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
					}
					else
					{
						message = "";
					}
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.captureComponentImage "+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try
					{
						byte[] bytes = Base64.decode(message);
						filePath = System.getProperty("java.io.tmpdir") + File.separator + "genieComponentImage" + RandomUtils.nextInt() + ".png";
						File outputFile = new File(filePath);
						Utils.createParentDirRecursivelyIfNotExist(outputFile.getParentFile());	
						if(!outputFile.exists())
							outputFile.createNewFile();
						BufferedImage bi = ImageIO.read(new ByteArrayInputStream(bytes)); // retrieve image
						ImageIO.write(bi, "png", outputFile);
						captureComponentImageStatus = true;
					}
					catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in capturing component image");
					else
						Utils.printErrorOnConsole(message);
				}
				
				Result res = new Result();
				res.result = bresult;
				
				if(captureComponentImageStatus)
				{
					res.message = "Component Image Saved Successfully at "+ filePath + " location";
				}
				else
				{
					res.message = "Error in capturing component image " + message;
				}
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("CaptureComponentImageStatus", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, new Boolean(captureComponentImageStatus).toString());
					gc.updateResult(res);
				}
			}
		}
		ArrayList<String> argsList = Utils.getArrayListFromStringParams("");
		CaptureComponentImageExecuteAction dg = new CaptureComponentImageExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		return dg.filePath; 
	}
	
	
	/**
	 * Compare Image of a given GenieComponent control with targetImage file with logging.
	 * targetImage is the png image captured from captureComponetImage.
	 * 
	 * @param targetImagePath
	 * 		Saved Image path location. 
	 *      User use this method to match current component image with previously saved image i.e targetImagePath.
	 * 
	 * @return 
	 * 		status of comparing image of component as Boolean
	 *      if images get matched this method will return true else false
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean compareComponentImage(String targetImagePath) throws StepFailedException, StepTimedOutException
	{
		return compareComponentImage(targetImagePath,true);
	}
	
	/**
	 * Compare Image of a given GenieComponent control with targetImage file with optional logging
	 * 
	 * @param targetImagePath
	 * 		Saved Image path location. 
	 *      User use this method to match current component image with previously saved image i.e targetImagePath.
	 * 
	 * @param bLogging
     *  	If passed as true, this step is logged in Genie script logs.
     *  	If passed as false, the step will not be part of Genie script log.
     *  
	 * @return 
	 * 		status of comparing image of component as Boolean
	 * 		if images get matched this method will return true else false
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean compareComponentImage(String targetImagePath,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		Boolean isImageMatched = false;
		Boolean bResult = true;
		Result result = new Result();
		result.result = true;
		ScriptLog scriptLog = ScriptLog.getInstance();
		if(bLogging)
		{
			scriptLog.addTestStep("CompareComponentImage", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName());
			addTestStepInfo();
		}
		if(!new File(targetImagePath).exists())
		{
			bResult = false;
			result.result = false;
			result.message = "Target Image File does not exist";
		}
		
		if(bResult)
		{
			String sourceImagePath = captureComponentImage(false);
			
			if(!new File(sourceImagePath).exists())
			{
				bResult = false;
				result.result = false;
				result.message = "Error in capturing source component image in compareImage Method";
			}
			else
			{
				BufferedImage sourceImage = null;
				BufferedImage targetImage = null;
				try {
					sourceImage = ImageIO.read(new File(sourceImagePath));
					targetImage = ImageIO.read(new File(targetImagePath));
				} catch (IOException e) {
					result.result = false;
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.compareComponentImage "+e.getMessage());
					result.message = "IOException in Creating BufferedImageObject";
				}
				
				if(targetImage == null || sourceImage == null)
				{
					result.result = false;
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception in Creating BufferedImageObject");
					result.message = "Exception in Creating BufferedImageObject";
				}
				if(result.result)
				{
					int height = sourceImage.getHeight();
					int width = sourceImage.getWidth();
					
					PicFinder pf = new PicFinder(sourceImage, new Dimension(width, height), true);
					isImageMatched = pf.compareImage(targetImage,10);
					result.result = true;
					if(isImageMatched)
						result.message = "Component Image matched successfully with target image "+ targetImagePath;
					else
						result.message = "Component Image does not matched with target image " +targetImagePath;
				}
			}
		}
		
		
		if(bLogging)
		{
			if(result.result == false)
			{
				Utils.printErrorOnConsole(result.message);
				Utils.printMessageOnConsole("Result is: Step Failed");
				scriptLog.addTestStepResult(GenieResultType.STEP_FAILED);
				scriptLog.addTestStepMessage(result.message,GenieMessageType.MESSAGE_ERROR);
			}
			else 
			{
				Utils.printMessageOnConsole(result.message);
				Utils.printMessageOnConsole("Result is: Step Passed");
				scriptLog.addTestStepResult(GenieResultType.STEP_PASSED);
				scriptLog.addTestStepMessage(result.message,GenieMessageType.MESSAGE_INFO);
			}
		}
		
		// Throws Exception when a Step times out and EXIT_ON_TIMEOUT flag is set
		if ((result.message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE")||
                result.message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE")||
                result.message.contains("PRELOAD_RETURNED_NOTHING") ||
                result.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")||
                result.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_REQUEST")||
                result.message.contains("GENIEID_DOES_NOT_MATCH_WITH_THE_GENIEID_OF_THE_EXECUTED_STEP")
			)&& GenieScript.EXIT_ON_TIMEOUT)
        {
                Utils.printMessageOnConsole("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set");
                scriptLog.addTestStepMessage("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
                throw new StepTimedOutException();                                                            
        }
		
		// Throws Exception when a Step fails and EXIT_ON_FAILURE flag is set
        if (!result.result && GenieScript.EXIT_ON_FAILURE){
			Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
			scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			throw new StepFailedException();                                               
		}
        
		return isImageMatched;
	}
	
	/**
	 * Method which saves the XML representation of genie component at specified path with logging
	 * 
	 * @param xmlFilePath
	 * 	 	Complete xmlFilePath where the XML needs to be saved
	 * 
	 * @return 
	 * 		status of saving XML of component as Boolean
	 * 		if xml saved successfully it will return true else false
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.5
	 */
	public Boolean saveComponentXML(String xmlFilePath) throws StepFailedException, StepTimedOutException
	{
		return saveComponentXML(xmlFilePath,true);
	}
	
	/**
	 * Method which saves the XML representation of genie component at specified path with optional logging
	 * 
	 * @param xmlFilePath
	 * 	 	Complete xmlFilePath where the XML needs to be saved
	 * 
	 *  @param bLogging
     *  	If passed as true, this step is logged in Genie script logs.
     *  	If passed as false, the step will not be part of Genie script log.
     *  
	 * @return 
	 * 		status of saving XML of component as Boolean
	 * 		if xml saved successfully it will return true else false
	 * 
	 * @throws Exception
	 * @since Genie 1.5
	 */
	public Boolean saveComponentXML(String xmlFilePath,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class SaveComponentXMLExecuteAction extends ExecuteActions
		{
			Boolean saveComponentXMLStatus = false;
			public SaveComponentXMLExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("saveComponentXML", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.SAVE_COMPONENT_XML, inputData);				
				return result;
			}
			
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);
				
				try{
					if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
					{
						String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
						bresult =  Boolean.parseBoolean(temp);
					}
						
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
				}
				
				try{
					if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
					{
						message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
					}
					else
					{
						message = "";
					}
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.captureComponentImage "+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try
					{
						String xmlFilePath = args.get(0);
						File f = new File(xmlFilePath);
						Utils.printMessageOnConsole("Saving Component XML to path: " + f.getAbsolutePath());
						
						if (f.isAbsolute())
						{
							Utils.createParentDirRecursivelyIfNotExist(f.getParentFile());
						}
						
						BufferedWriter out = new BufferedWriter(
								new OutputStreamWriter(new FileOutputStream(xmlFilePath), "UTF-8")
							);
					
						String compXmlStr = message;
						
						out.write(compXmlStr);
						out.newLine();
						out.flush();
						out.close();	
						saveComponentXMLStatus = true;
					}
					catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
						message = "Failed to save component xml :"+e.getMessage();
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in capturing component image");
					else
						Utils.printErrorOnConsole(message);
				}
				
				Result res = new Result();
				res.result = saveComponentXMLStatus;
				
				if(saveComponentXMLStatus)
				{
					res.message = "Component XML Saved Successfully at "+ args.get(0) + " location";
				}
				else
				{
					res.message = "Error occured in saving component XML :" + message;
				}
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("saveComponentXMLStatus", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, new Boolean(saveComponentXMLStatus).toString());
					gc.updateResult(res);
				}
			}
		}
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(xmlFilePath);
		SaveComponentXMLExecuteAction dg = new SaveComponentXMLExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		return dg.saveComponentXMLStatus; 
	}
	
	
	/**
	 * Actual method which saves the XML representation of genie component at temporary path with logging
	 * 
	 * @return 
	 * 		imagePath as String
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.5
	 */
	public String saveComponentXML() throws StepFailedException, StepTimedOutException
	{
		return saveComponentXML(true);
	}
	
	/**
	 * Actual method which saves the XML representation of genie component at temporary path with optional logging
	 * 
	 * @param bLogging
     *  If passed as true, this step is logged in Genie script logs.
     *  If passed as false, the step will not be part of Genie script log.
     *  
	 * @return 
	 * 	imagePath as String
	 * 
	 * 
	 * @since Genie 1.5
	 */
	public String saveComponentXML(boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class SaveComponentXMLExecuteAction extends ExecuteActions
		{
			Boolean saveComponentXMLStatus = false;
			String filePath = "";
			public SaveComponentXMLExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("saveComponentXML", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.SAVE_COMPONENT_XML, inputData);				
				return result;
			}
			
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				String message = "";
				Document doc = Utils.getXMLDocFromString(result.message);
				
				try{
					if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
					{
						String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
						bresult =  Boolean.parseBoolean(temp);
					}
						
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
				}
				
				try{
					if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
					{
						message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
					}
					else
					{
						message = "";
					}
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.captureComponentImage "+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try
					{
						filePath = System.getProperty("java.io.tmpdir") + File.separator + "genieComponentImage" + RandomUtils.nextInt() + ".xml";
						File f = new File(filePath);
						Utils.printMessageOnConsole("Saving Component XML to path: " + f.getAbsolutePath());
						
						if (f.isAbsolute())
						{
							Utils.createParentDirRecursivelyIfNotExist(f.getParentFile());
						}
						
						BufferedWriter out = new BufferedWriter(
								new OutputStreamWriter(new FileOutputStream(filePath), "UTF-8")
							);
					
						String compXmlStr = message;
						
						out.write(compXmlStr);
						out.newLine();
						out.flush();
						out.close();	
						saveComponentXMLStatus = true;
					}
					catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
						message = "Failed to save component xml :"+e.getMessage();
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in capturing component image");
					else
						Utils.printErrorOnConsole(message);
				}
				
				Result res = new Result();
				res.result = saveComponentXMLStatus;
				
				if(saveComponentXMLStatus)
				{
					res.message = "Component XML Saved Successfully at "+ filePath + " location";
				}
				else
				{
					res.message = "Error occured in saving component XML :" + message;
				}
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("saveComponentXMLStatus", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, new Boolean(saveComponentXMLStatus).toString());
					gc.updateResult(res);
				}
			}
		}
		ArrayList<String> argsList = Utils.getArrayListFromStringParams("");
		SaveComponentXMLExecuteAction dg = new SaveComponentXMLExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		return dg.filePath; 
	}
	
	/**
	 * Checks if a GenieComponent is currently visible on the stage.
	 * 
	 * @return 
	 * 		Status of visible property as boolean
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.9			
	 */
	public boolean  isVisible() throws StepFailedException, StepTimedOutException,Exception
	{
		ArrayList<String> argsList=new ArrayList<String>();;
		argsList.add("visible");		
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, BaseEvent.GETVALUEOF, "",  GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList,false);
		dg.bLogging = false;
		dg.performAction();
		
		String propValue = dg.propValue;
		boolean finalPropValue=false;
		
		//Coverting the string result to boolean value
		if (propValue.equalsIgnoreCase("true"))
			 finalPropValue=true;		    		
		
		return finalPropValue;
	}
	
	/**
	 * Checks if a GenieComponent is currently enabled on the stage.
	 * 
	 * @return 
	 * 		Status of enabled property as boolean
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.9			
	 */
	public boolean  isEnabled() throws StepFailedException, StepTimedOutException,Exception
	{
		ArrayList<String> argsList=new ArrayList<String>();;
		argsList.add("enabled");		
		GetValueExecuteAction dg = new GetValueExecuteAction(
				this, BaseEvent.GETVALUEOF, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);
		dg.bLogging = false;
		dg.performAction();		
		String propValue = dg.propValue;
		boolean finalPropValue=false;
		
		//Coverting the string result to boolean value
		if (propValue.equalsIgnoreCase("true"))
			 finalPropValue=true;		    		
		
		return finalPropValue;
	}
	
	/**
	 * Gets the number of automatable children of a GenieComponent.
	 * 
	 * @return 
	 * 		Integer value of automatable children of the component. In case of Error 0 is returned.
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 0.9			
	 */
	public int  getNumAutomatableChildren() throws StepFailedException, StepTimedOutException
	{
		return getNumAutomatableChildren(true);
	}
	
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the default time out set times out
	 * 
	 * @return 
	 * 		Boolean value indicating the result of waitFor action
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 0.5
	 */
	public boolean waitFor() throws StepFailedException, StepTimedOutException
	{
		return waitFor(SynchronizedSocket.getInstance().getTimeout());
	}
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the times out happens
	 * 
	 * @param bLogging
     * 			  	pass true if to log this step in Genie Script log else pass false
	 * 
	 * @return 
	 * 		Boolean value indicating the result of waitFor action
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 1.0
	 */
	public boolean waitFor(boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		return waitFor(SynchronizedSocket.getInstance().getTimeout(),bLogging);
	}
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the user specified time (in seconds) times out
	 * 
	 * @param timeInSeconds
     *            Maximum time in seconds for which the script will wait for GenieID to appear.
     *            If the GenieID is found before the timeout value then it will return.
     *            So it is actually a timeout value
	 * @return 
	 * 		Boolean value indicating the result of waitFor action
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 0.5
	 */
	public boolean waitFor(int timeInSeconds) throws StepFailedException, StepTimedOutException
	{
		return waitFor(timeInSeconds, true);
	}
	
	/**
	 * This method will make the script to wait for specified Genie id  to appear on stage 
	 * or till the times out happens
	 * 
	 * @param timeInSeconds
     *            Maximum time in seconds for which the script will wait for GenieID to appear.
     *            If the GenieID is found before the timeout value then it will return.
     *            So it is actually a timeout value
     * @param bLogging
     * 			  	pass true if to log this step in Genie Script log else pass false
	 * @return 
	 * 		Boolean value indicating the result of waitFor action
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 1.0
	 */
	public boolean waitFor(int timeInSeconds, boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		return waitForComponent(bLogging,true,true,timeInSeconds).result;
		
	}
	
	/**
	 * This method will make the script to wait till the given property attains the specified value or timeout happens
	 * 
	 * @param property
	 * 			  Name of property
	 * @param value
	 * 			  Expected property value
	 * @param timeInSeconds
     *            Maximum time in seconds for which the script will wait for component's property to attain given value
     *            Default value for timeout is 10 seconds.
	 * @return 
	 * 		Boolean value indicating the result of waitFor action
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 0.8
	 */
	public boolean waitForPropertyValue(String property, String value, int... timeInSeconds) throws StepFailedException, StepTimedOutException
	{
		boolean returnValue = false;
		ScriptLog scriptLog = ScriptLog.getInstance();
		scriptLog.addTestStep("waitForPropertyValue", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, this.getClass().getSimpleName());
		addTestStepInfo();
		
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		int timeOut = sc.getTimeout();
		if (timeInSeconds.length > 0)
		{
			timeOut = timeInSeconds[0];
		}
		scriptLog.addTestStepParameter("PropertyName", GenieLogEnums.GenieParameterType.PARAM_INPUT, property);
		scriptLog.addTestStepParameter("ExpectedPropertyValue", GenieLogEnums.GenieParameterType.PARAM_INPUT, value);
		
		Result result = waitForComponent(false,true,true,timeOut);
		if(result.result)
		{
			//convert seconds to milliseconds
			int timeOutInMS = timeOut * 1000;
			
			long startTime = System.currentTimeMillis();
			
			String propertyValue = getValueOfInternal(property);
			int step = 100;
			//int numSteps = (timeOut * 1000)/step;
			//int stepCounter = 0;
			while (!propertyValue.equals(value)){
				propertyValue = getValueOfInternal(property);
				
				long currentTime = System.currentTimeMillis();
				if( (currentTime - startTime) < timeOutInMS)
				{
					try {
						Thread.sleep(step);
					} catch (InterruptedException e) {}
					
				}
				else
					break;
			}
			scriptLog.addTestStepParameter("ActualPropertyValue", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, propertyValue);
			if(propertyValue.equals(value))
				returnValue = true;
			
			result.result = returnValue;
			if(!returnValue)
				result.message = "Property \"" + property + "\" did not attain value \"" + value + "\" in " + timeOut + " seconds.";
			else
				result.message = "";
		}
		
		updateResult(result);
		
		return returnValue;
	}
	
	/**
	 * This method returns children of GenieComponent as array of GenieComponents which match properties specified in GenieLocatorInfo
	 * 
	 * @param info
     *      GenieLocatorInfo, which specifies which properties to match when getting children  
     *      
     * @param bRecursive
     * 		This should be set TRUE if user wants to fetch the child recursively for the given genieID
     * 		This should be set FALSE if user wants to fetch the immediate children and don't want to go recursively for the given genieID
     *       
	 * @return 
	 * 		Array of child GenieComponents
	 * 
	 * 
	 * @throws Exception
	 *   
	 * @see com.adobe.genie.executor.GenieLocatorInfo
	 * 
	 * @since Genie 0.9
	 *  
	 */
	public GenieComponent[] getChildren(GenieLocatorInfo info, boolean bRecursive) throws StepTimedOutException, StepFailedException
	{
		return getChildren(info,bRecursive,true);
	}
	
	/**
	 * This method returns children of GenieComponent as array of GenieComponents which match properties specified in GenieLocatorInfo
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
	 * 		Array of child GenieComponents
	 * 
	 * @throws Exception
	 *   
	 * @see com.adobe.genie.executor.GenieLocatorInfo
	 * 
	 * @since Genie 1.0
	 *  
	 */
	public GenieComponent[] getChildren(GenieLocatorInfo info, boolean bRecursive,boolean bLogging) throws StepTimedOutException, StepFailedException
	{
		class GetChildExecuteActions extends ExecuteActions
		{
			GenieComponent[] genieComponents = new GenieComponent[]{};
			GenieLocatorInfo locatorInfo;
			boolean isRecursive;			
			public GetChildExecuteActions(
					GenieLocatorInfo info,
					boolean isRecursive,
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args
					)
					 
			{
				super(obj, eventName, stepType, className, args);
				locatorInfo = info;
				this.isRecursive = isRecursive;
			}
			protected void initLogs()
			{
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("GetChild", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					scriptLog.addTestStepParameter("isRecursive", GenieParameterType.PARAM_INPUT, isRecursive ? "true": "false");
				
					Set<String> set = locatorInfo.propertyValueTable.keySet();
	
				    Iterator<String> itr = set.iterator();
				    while (itr.hasNext()) {
				     String key = itr.next();
				     String value = locatorInfo.propertyValueTable.get(key);
				     
				     scriptLog.addTestStepParameter(key, GenieParameterType.PARAM_INPUT, value);
				      
				    }
					addTestStepInfo();
				}
			}
			protected String prepareArgs(ArrayList<String> args)
			{
				String data = "";
				data = "<XML>";
				data = data + "";
				data = data + "<GenieID>" + genieID + "</GenieID>";
				data = data + convertToXML(locatorInfo);
				data += "</XML>";
				return data;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result;
				if(isRecursive)
				{
					if (genieID.equals(""))
					{
						result = sc.doAction(gc.getAppName(), BaseEvent.FINDCOMPONENTINDICT, inputData);
					}
					else
					{
						result = sc.doAction(gc.getAppName(), BaseEvent.FINDCOMPONENT, inputData);
					}
				}
				else
				{
					result = sc.doAction(gc.getAppName(), BaseEvent.GETCHILD, inputData);
				}
				
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
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
				try{
				
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}catch(Exception e){
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());			
				}

				if (bresult){
					try{
						String genieIDs = "";
						if(doc.getElementsByTagName("Children").getLength() > 0)
							if(doc.getElementsByTagName("Children").item(0).getChildNodes().getLength() > 0)
								genieIDs = doc.getElementsByTagName("Children").item(0).getChildNodes().item(0).getNodeValue();
						//Utils.printMessageOnConsole("GenieIDs Value: " + genieIDs);
						String[] arrData = new String[0];
						if(genieIDs.length() > 0)
						{
							arrData = genieIDs.split("\\|");
						}
						genieComponents = new GenieComponent[arrData.length];
						ScriptLog scriptLog = ScriptLog.getInstance();
						if(bLogging)
						{
							scriptLog.addTestStepParameter("NumberOfChildren", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, arrData.length+"");
						}
						Utils.printMessageOnConsole("Number Of Children ::" + arrData.length);
						for(int i=0; i<arrData.length; ++i)
						{
							String id = arrData[i];
							genieComponents[i] = new GenieComponent(id, app,false);
							if(bLogging)
							scriptLog.addTestStepParameter("ChildGenieID", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, id);
							Utils.printMessageOnConsole("Child Genie id ::" + id);
						}
					}
					catch(RuntimeException e){
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured"+e.getMessage());
					}
					catch(Exception e){
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured in GenieComponent.getChildren"+e.getMessage());
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in getting children");
					else
						Utils.printErrorOnConsole(message);
				}

				Result res = new Result();
				res.result = bresult;
				res.message = message;
				if(bLogging)
					gc.updateResult(res);
			}
		}
		
		ArrayList<String> argsList = new ArrayList<String>();
		if(genieID.equals(""))
			this.bWait = true;
		GetChildExecuteActions dg = new GetChildExecuteActions(info, bRecursive,
				this, BaseEvent.GETCHILD, GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		return dg.genieComponents;
	}
	
	/**
	 * Gets the immediate child at a specified index.
	 * 
	 * @param index
	 *          the index of the child that needs to be returned
	 *          
	 * @return 
	 * 		Object as GenieComponent{@link com.adobe.genie.executor.components.GenieComponent}. In case of Error returns null
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.0			
	 */
	public GenieComponent getChildAt(int index) throws StepFailedException, StepTimedOutException
	{
		return getChildAt(index,true);
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
	public GenieComponent getParent() throws StepTimedOutException,StepFailedException
	{
		return getParent(true);
	}
	
	/**
	 * Gets the local co-ordinates(i.e. with respect to application and not to screen) of the Component
	 * 
	 * @return
	 * 		it returns the Point object
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.11
	 */
	public Point getLocalCoordinates()throws StepFailedException, StepTimedOutException{
	    return getLocalCoordinates(true);
	}
	/**
	 * Gets the local co-ordinates(i.e. with respect to application and not to screen) of the Component
	 * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return
	 * 		it returns the Point object
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.0
	 */
	public Point getLocalCoordinates(boolean bLogging)throws StepFailedException, StepTimedOutException{
		
		class GetLocalCoordinatesExecuteAction extends ExecuteActions
	{		
		public Point p;
		public GetLocalCoordinatesExecuteAction(
				GenieComponent obj, 
				String eventName, 
				GenieStepType stepType, 
				String className, 
				ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				p = new Point();
			}
			protected void initLogs()
			{
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("getLocalCoordinates", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
					scriptLog.addTestStepParameter("GenieID", GenieParameterType.PARAM_ATTRIBUTE,genieID);				
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
				String inputData = gc.createPreloadDataForValue(gc.getGenieID(),arr);
				return inputData;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(),"getLocalCoordinates","<String>"+genieID+"</String>");			
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException			{
				
				String coordinates = result.message;
				if(coordinates.contains("<x>") && coordinates.contains("<y>"))
				{
					float floatX = Float.parseFloat(coordinates.substring(coordinates.indexOf("<x>")+3, coordinates.indexOf("</x>")));
					float floatY  = Float.parseFloat(coordinates.substring(coordinates.indexOf("<y>")+3, coordinates.indexOf("</y>")));
					
					p.x = (int)floatX;
					p.y = (int)floatY;
					if(bLogging)
					{
						ScriptLog scriptLog = ScriptLog.getInstance();
						scriptLog.addTestStepParameter("Result x", GenieParameterType.PARAM_OUTPUT,p.x+"");
						scriptLog.addTestStepParameter("Result y", GenieParameterType.PARAM_OUTPUT,p.y+"");
						scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_PASSED);
					}
				}
				
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();;			
		GetLocalCoordinatesExecuteAction dg = new GetLocalCoordinatesExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);		
		dg.bLogging = bLogging;
		dg.performAction();			
		return dg.p;
		
		
		/*Point p = new Point();
		Result result = new Result();
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		ScriptLog scriptLog = ScriptLog.getInstance();
		
		//Call the function getLocalCoordinates to get the coordinates.
		scriptLog.addTestStep("getLocalCoordinates", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, this.getClass().getSimpleName());
		scriptLog.addTestStepParameter("GenieID", GenieParameterType.PARAM_ATTRIBUTE,genieID);
		result = sc.doAction(app.name, "getLocalCoordinates", "<String>"+genieID+"</String>");
		String coordinates = result.message;
		if(coordinates.contains("<x>") && coordinates.contains("<y>"))
		{
			float floatX = Float.parseFloat(coordinates.substring(coordinates.indexOf("<x>")+3, coordinates.indexOf("</x>")));
			float floatY  = Float.parseFloat(coordinates.substring(coordinates.indexOf("<y>")+3, coordinates.indexOf("</y>")));
			
			p.x = (int)floatX;
			p.y = (int)floatY;
			
			scriptLog.addTestStepParameter("Result x", GenieParameterType.PARAM_OUTPUT,p.x+"");
			scriptLog.addTestStepParameter("Result y", GenieParameterType.PARAM_OUTPUT,p.y+"");
			scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_PASSED);
		}
				
		return p;*/
	}
	
	/**
	 * Gets the local co-ordinates(i.e. with respect to the GenieId passes as parameter) of the Component
	 * 
	 * @param strParentGenieId
	 *		GenieId of the component that encapsulates the the child component and 
	 *		w.r.t to which co-ordinates needs to be returned
	 *
	 * @return
	 * 		it returns the Point object
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.6
	 */
	public Point getRelativeCoordinates(String strParentGenieId)throws StepFailedException, StepTimedOutException{
	    return getRelativeCoordinates(strParentGenieId, true);
	}
	/**
	 * Gets the local co-ordinates(i.e. with respect to the GenieId passes as parameter) of the Component
	 * 
	 * @param strParentGenieId
	 *		GenieId of the component that encapsulates the the child component and 
	 *		w.r.t to which co-ordinates needs to be returned
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return
	 * 		it returns the Point object
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.6
	 */
	public Point getRelativeCoordinates(final String strParentGenieId, boolean bLogging)throws StepFailedException, StepTimedOutException
	{
		class GetRelativeCoordinatesExecuteAction extends ExecuteActions
	{		
		public Point p;
		public GetRelativeCoordinatesExecuteAction(
				GenieComponent obj, 
				String eventName, 
				GenieStepType stepType, 
				String className, 
				ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				p = new Point();
			}
			protected void initLogs()
			{
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("getRelativeCoordinates", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
					scriptLog.addTestStepParameter("GenieID", GenieParameterType.PARAM_ATTRIBUTE,genieID);
					scriptLog.addTestStepParameter("ParentGenieId", GenieParameterType.PARAM_ATTRIBUTE,strParentGenieId);
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
				String inputData = gc.createPreloadDataForValue(genieID,arr);
				return inputData;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(),"getRelativeCoordinates",inputData);			
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException			{
				
				String coordinates = result.message;
				coordinates = coordinates.replace("&lt;", "<");
				coordinates = coordinates.replace("&gt;", ">");
				if(coordinates.contains("<x>") && coordinates.contains("<y>"))
				{
					float floatX = Float.parseFloat(coordinates.substring(coordinates.indexOf("<x>")+3, coordinates.indexOf("</x>")));
					float floatY  = Float.parseFloat(coordinates.substring(coordinates.indexOf("<y>")+3, coordinates.indexOf("</y>")));
					
					p.x = (int)floatX;
					p.y = (int)floatY;
					if(bLogging)
					{
						ScriptLog scriptLog = ScriptLog.getInstance();
						scriptLog.addTestStepParameter("Result x", GenieParameterType.PARAM_OUTPUT,p.x+"");
						scriptLog.addTestStepParameter("Result y", GenieParameterType.PARAM_OUTPUT,p.y+"");
						scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_PASSED);
					}
				}
				
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();
		argsList.add(strParentGenieId);
		GetRelativeCoordinatesExecuteAction dg = new GetRelativeCoordinatesExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);		
		dg.bLogging = bLogging;
		dg.performAction();			
		return dg.p;
	}
	/**
	 * It attaches the event listener for the given event name 
	 * 
	 * @param eventName
	 * 		Event to be attached. Ex: "click". 
	 *  
	 * @return 
	 * 		returns a guid, which is used while capturing the event information.
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.0
	 */
	public String attachEventListener(String eventName) throws StepFailedException, StepTimedOutException
	{
		class AttachEventListenerAction extends ExecuteActions
		{
			public AttachEventListenerAction(
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				UsageMetricsData usageInstance = UsageMetricsData.getInstance();
				usageInstance.addFeature("AttachEventListener");
			}
			protected void initLogs()
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("AttachEventListener", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, className);
				addTestStepInfo();
				scriptLog.addTestStepParameter("EventName", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(0));
			}
			protected String prepareArgs(ArrayList<String> args)
			{
				int l = args.size();
				String[] arr = new String[l];
				for(int i=0; i < l; i++)
				{
					arr[i] = args.get(i);
				}
				String inputData = gc.createPreloadDataForListener(gc.getGenieID(), arr);
				return inputData;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(), BaseEvent.ATTACH_EVENT_LISTENER, inputData);				
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStepParameter("EventGUID", GenieLogEnums.GenieParameterType.PARAM_OUTPUT,args.get(1));
				gc.updateResult(result);
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();;
		argsList.add(eventName);
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
		argsList.add(guid);
		AttachEventListenerAction dg = new AttachEventListenerAction(
				this, "", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, getClass().getSimpleName(),argsList);
		
		dg.performAction();
		return guid;
	}
	
	/**
	 * It attaches the event listener on the given property of object for the given event name.  
	 * 
	 * @param eventName
	 * 		Event to be attached. Ex: "click". 
	 * 
	 * @param propertyName
	 * 		Property name of the object. Ex: "parent" , "soundChanel"
	 *  
	 * @return 
	 * 		returns a guid, which is used while capturing the event information.
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.0
	 */
	public String attachEventListener(String eventName,String propertyName) throws StepFailedException, StepTimedOutException
	{
		class AttachEventListenerAction extends ExecuteActions
		{
			public AttachEventListenerAction(
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				UsageMetricsData usageInstance = UsageMetricsData.getInstance();
				usageInstance.addFeature("AttachEventListener");
			}
			protected void initLogs()
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("AttachEventListener", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, className);
				addTestStepInfo();
				scriptLog.addTestStepParameter("EventName", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(0));
				scriptLog.addTestStepParameter("PropertyName", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(1));
			}
			protected String prepareArgs(ArrayList<String> args)
			{
				int l = args.size();
				String[] arr = new String[l];
				for(int i=0; i < l; i++)
				{
					arr[i] = args.get(i);
				}
				String inputData = gc.createPreloadDataForListener(gc.getGenieID(), arr);
				return inputData;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(), BaseEvent.ATTACH_EVENT_LISTENER, inputData);				
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStepParameter("EventGUID", GenieLogEnums.GenieParameterType.PARAM_OUTPUT,args.get(1));
				gc.updateResult(result);
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();
		argsList.add(eventName);
		UUID uuid = UUID.randomUUID();
	    String guid = uuid.toString();
		argsList.add(guid);
		
		argsList.add(propertyName);
		
		AttachEventListenerAction dg = new AttachEventListenerAction(
				this, "", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, getClass().getSimpleName(),argsList);
		
		dg.performAction();
		return guid;
	}
//   Removing the Api as there is a typo in its name,bug#3078754
//	/**
//	 * It attaches the event listener for the given event name 
//	 * 
//	 * @param eventName
//	 * 		Event to be attached. Ex: "click". 
//	 *  
//	 * @return 
//	 * 		returns a guid, which is used while capturing the event information.
//	 *  
//	 * @throws Exception
//	 * 
//	 * @since Genie 0.11
//	 *
//	 * @deprecated  As of Genie 1.0, replaced by {@link com.adobe.genie.executor.components.GenieComponent#attachEventListener(String)}
//	 */
//	@Deprecated
//	public String attachEventLisenter(String eventName) throws StepFailedException, StepTimedOutException
//	{
//		return attachEventListener(eventName);
//	}
	
	/**
	 * Waits for the event to happen till timeout happens. 
	 * 
	 * @param eventGUID
	 * 		GUID returned by attachEventListener() method while attaching the event listener.
	 * 
	 * @param timeInSeconds
	 * 		Timeout value in seconds. 
	 * 
	 * @return 
	 * 		returns a hashtable containing information about event. Returns null in case of time out.
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 0.11		
	 */
	public Hashtable<String, String>  waitForEvent(String eventGUID,int... timeInSeconds) throws StepFailedException, StepTimedOutException
	{
		//SCA
		Result result;
		//Result result = new Result();
		Hashtable<String, String> eventData = new Hashtable<String, String>();
		long timeToWait;
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		ScriptLog scriptLog = ScriptLog.getInstance();
		
		if(timeInSeconds.length != 0)
			timeToWait = System.currentTimeMillis() + (timeInSeconds[0]*1000L);
		else
			timeToWait = System.currentTimeMillis() + (sc.getTimeout()*1000L); // If timeout is not specified by user, use the current set default timeout
		
		if (StaticFlags.getInstance().wasSwfDeadOnce(this.getAppName()))
		{
			//It means swf becomes alive after disappearing
			StaticFlags sf = StaticFlags.getInstance();
			sf.conenctToSwf(this.getAppName());
		}
		
		String params[] = new String[2];
		params[0] = "";
		params[1] = eventGUID;
		
		result = sc.doAction(app.name, "returnEventData", createPreloadDataForListener(genieID, params));

		//If swf not present, no need to wait for Event
		if (!result.message.equals(Utils.SWF_NOT_PRESENT))
		{
			//Add a step in ScriptLog as we are going to consume time in waiting for component to appear
			scriptLog.addTestStep("Waiting for Event", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("Event GUID", GenieLogEnums.GenieParameterType.PARAM_INPUT, eventGUID);

			while(result.result == false && System.currentTimeMillis() < timeToWait){
				result = sc.doAction(app.name, "returnEventData", createPreloadDataForListener(genieID, params));
				//Make thread sleep for 200 ms.
				try{
					Thread.sleep(200);
				}catch(Exception e){break;}
			}
			if(result.result == false)
			{
				scriptLog.addTestStepMessage("Timeout!. Event information could not be fetched.", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				Utils.printErrorOnConsole("Timeout!. Event information could not be fetched.");
				scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_FAILED);
			}
			else
			{
				//Parse message to get event properties
				eventData = parseEventData(result.message);
				Utils.printMessageOnConsole("Event info for event \"" + eventData.get("type") + "\" is fetched");
				scriptLog.addTestStepResult(GenieLogEnums.GenieResultType.STEP_PASSED);
			}
		}
		else
		{
			this.app.isConnected = false;
			StaticFlags sf = StaticFlags.getInstance();
			sf.pushClosedSwf(this.getAppName());
		}
		return eventData;
	}
	
	//========================================================================================
	// Some protected methods to be used to subclasses of Genie Component
	//========================================================================================
	
	//This method is mainly for parsing the touch arguments to send to preload for execution	
	protected String createTouchPreloadData(String genieID, String eventName, BaseEvent event)
	{
		//Escape special characters for XML
		event.arguments = Utils.getXMLCompatibleStr(event.arguments);
		
		String data = "";
		if(event.arguments.size() > 0)
			data = "<XML>";
		else
			data = "<String>";

		data = data + "";
		
		data = data + "<GenieID>" + genieID + "</GenieID>";
		data = data + "<Event>" + eventName + "</Event>";
		data = data + "<Ctrl>" + event.ctrlKey + "</Ctrl>";
		data = data + "<Alt>" + event.altKey + "</Alt>";
		data = data + "<Shift>" + event.shiftKey + "</Shift>";
		data = data + "<MouseX>" + event.mouseX + "</MouseX>";
		data = data + "<MouseY>" + event.mouseY + "</MouseY>";
		
		data = data + "<Arguments><Argument>";
		
		TouchPointValues t = null;
		String strTouchArgs = "";
		int nArgsSize = event.arguments.size();
		for(int i=0; i < nArgsSize; ++i)
		{
			if((i%5) == 0)
			{
				if(t == null)
					t = getTouchCode((i/5));
				else
				{
					strTouchArgs = strTouchArgs.substring(0, (strTouchArgs.length() -1));
					data += strTouchArgs + "</" + t.toString() + ">" + event.arguments.get(i) + ",";
					strTouchArgs = "";
					t = getTouchCode((i/5));
				}
				data = data + "<" + t.toString() + ">" + event.arguments.get(i) + ",";
			}
			else
			{
				strTouchArgs += event.arguments.get(i) + ",";
			}
		}
		
//		if(nArgsSize == 5)
//		{
			strTouchArgs = strTouchArgs.substring(0, (strTouchArgs.length() -1));
			data += strTouchArgs + "</" + t.toString() + ">" + "</Argument></Arguments>";
//		}
//		else
//			data = data + "</Argument></Arguments>";
		
		if(event.preloadArguments != null && event.preloadArguments.size() > 0)
		{
			data = data + "<PreloadArguments>";
			for(int i=0; i<event.preloadArguments.size(); ++i)
			{
				data = data + "<Argument>" + event.preloadArguments.get(i) + "</Argument>";
			}
			
			data = data + "</PreloadArguments>";
		}
		
		if(event.arguments.size() > 0)
			data += "</XML>";
		else
			data += "</String>";

		return data;
	}
	/**
	 * Creates the message packet to be sent to Prelaod for operation on a component 
	 */
	protected String createPreloadData(String genieID, String eventName, BaseEvent event)
	{
		//SCA-All the calls to append string are saved and instead the string is composed in 
		//string buffer and then converted to string in the end.
		//Escape special characters for XML
		event.arguments = Utils.getXMLCompatibleStr(event.arguments);
		StringBuffer buf = new StringBuffer();		
		String data = "";
		if(event.arguments.size() > 0)
			buf.append("<XML>");
			//data = "<XML>";
		else
			buf.append("<String>");
			//data = "<String>";

		buf.append("");
		//data = data + "";
		
		buf.append("<GenieID>" + genieID + "</GenieID>");
		buf.append("<Event>" + eventName + "</Event>");
		buf.append("<Ctrl>" + event.ctrlKey + "</Ctrl>");
		buf.append("<Alt>" + event.altKey + "</Alt>");
		buf.append("<Shift>" + event.shiftKey + "</Shift>");
		buf.append("<MouseX>" + event.mouseX + "</MouseX>");
		buf.append("<MouseY>" + event.mouseY + "</MouseY>");
		/*data = data + "<GenieID>" + genieID + "</GenieID>";
		data = data + "<Event>" + eventName + "</Event>";
		data = data + "<Ctrl>" + event.ctrlKey + "</Ctrl>";
		data = data + "<Alt>" + event.altKey + "</Alt>";
		data = data + "<Shift>" + event.shiftKey + "</Shift>";
		data = data + "<MouseX>" + event.mouseX + "</MouseX>";
		data = data + "<MouseY>" + event.mouseY + "</MouseY>";*/
		
		buf.append("<Arguments>");
		//data = data + "<Arguments>";
				
		for(int i=0; i<event.arguments.size(); ++i)
		{
		 buf.append("<Argument>" + event.arguments.get(i) + "</Argument>");	
		 //data = data + "<Argument>" + event.arguments.get(i) + "</Argument>";
		}
		buf.append("</Arguments>");
		//data = data + "</Arguments>";
		
		
		if(event.preloadArguments != null && event.preloadArguments.size() > 0)
		{
			//data = data + "<PreloadArguments>";
			buf.append("<PreloadArguments>");
			for(int i=0; i<event.preloadArguments.size(); ++i)
			{
				buf.append("<Argument>" + event.preloadArguments.get(i) + "</Argument>");
				//data = data + "<Argument>" + event.preloadArguments.get(i) + "</Argument>";
			}
			buf.append("</PreloadArguments>");
			//data = data + "</PreloadArguments>";
		}
		
		if(event.arguments.size() > 0)
			buf.append("</XML>");
			//data += "</XML>";
		else
			buf.append("</String>");
			//data += "</String>";
        data=buf.toString();
		return data;
	}
	/**
	 * Creates a Message packet to be sent to preload specifically for retrieving properties of components
	 * 
	 */
	protected String createPreloadDataForValue(String genieID, String...params)
	{
		StringBuffer buf = new StringBuffer();	
		String data = "";
		buf.append("<XML>");
		//data = "<XML>";

		buf.append("");
		buf.append("<Input>");		
		/*data = data + "";
		data = data + "<Input>";*/
		
		buf.append("<GenieID>" + genieID + "</GenieID>");
		//data = data + "<GenieID>" + genieID + "</GenieID>";
		
		for(int i = 0; i<params.length; i++)
		{
			buf.append("<PropertyName>" + params[i] + "</PropertyName>");
			//data = data + "<PropertyName>" + params[i] + "</PropertyName>";
		}
		
		buf.append("</Input>");
		buf.append("</XML>");
		/*data = data + "</Input>";
		data += "</XML>";*/
		data=buf.toString();
		return data;
	}
	
	/**
	 * Creates a Message packet to be sent to preload specifically for retrieving properties of components
	 * 
	 */
	protected String createPreloadDataForListener(String genieID, String...params)
	{
		String data = "";
		data = "<XML>";

		data = data + "";
		data = data + "<Input>";
		
		data = data + "<GenieID>" + genieID + "</GenieID>";
		
		if(params.length >= 2)
		{
			data = data + "<EventName>" + params[0] + "</EventName>";
			data = data + "<EventGUID>" + params[1] + "</EventGUID>";
		}
		
		if(params.length == 3)
		{
			data = data + "<PropertyName>" + params[2] + "</PropertyName>";
		}
		
		data = data + "</Input>";
		data += "</XML>";
		return data;
	}
	
	/**
	 * Update the result of step in Log
	 */
	protected void updateResult(Result result) throws StepFailedException, StepTimedOutException
	{
		ScriptLog scriptLog = ScriptLog.getInstance();
		scriptLog.addTestStepResult(result.result? GenieLogEnums.GenieResultType.STEP_PASSED : GenieLogEnums.GenieResultType.STEP_FAILED);
		
		if (result.message.contains(Utils.SWF_NOT_PRESENT))
			result.message = "The SWF on which action is being performed is not connected to Server";
		
		if(!result.result)
		{
			scriptLog.incrementFailureCounter();
			Utils.printErrorOnConsole("Result is: Step failed");
			if(result.message != null && result.message.length() > 0){
				scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
				Utils.printErrorOnConsole("Error Message is:: " + result.message);
			}
		}
		else{
			Utils.printMessageOnConsole("Result is: Step Passed");
			if(result.message != null && result.message.length() > 0){
				scriptLog.addTestStepMessage(result.message, GenieLogEnums.GenieMessageType.MESSAGE_INFO);
				Utils.printMessageOnConsole("Message Recieved is:: " + result.message);
			}
		}
		
		//Captures ScreenShot when a step failed and CAPTURE_SCREENSHOT_ON_FAILURE flag is set
		//The Saved screenshot will be saved in folder containing ScriptLog
		if (!result.result && GenieScript.CAPTURE_SCREENSHOT_ON_FAILURE){
			Utils.printErrorOnConsole("Step Failed and CAPTURE_SCREENSHOT_ON_FAILURE is ON so capturing current ScreenShot");
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
		
		// Throws Exception when a Step times out and EXIT_ON_TIMEOUT flag is set
		if ((result.message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_AVAILABLE_ON_STAGE")||
                result.message.contains("COMPONENT_OF_GIVEN_GENIEID_NOT_VISIBLE")||
                result.message.contains("PRELOAD_RETURNED_NOTHING") ||
                result.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")||
                result.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_REQUEST")||
                result.message.contains("GENIEID_DOES_NOT_MATCH_WITH_THE_GENIEID_OF_THE_EXECUTED_STEP")
			)&& GenieScript.EXIT_ON_TIMEOUT)
        {
                Utils.printMessageOnConsole("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set");
                scriptLog.addTestStepMessage("Aborting script as the step Timed out and EXIT_ON_TIMEOUT flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
                throw new StepTimedOutException();                                                            
        }
		
		// Throws Exception when a Step fails and EXIT_ON_FAILURE flag is set
        if (!result.result && GenieScript.EXIT_ON_FAILURE){
			Utils.printMessageOnConsole("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set");
			scriptLog.addTestStepMessage("Aborting script as the step Failed and EXIT_ON_FAILURE flag was set", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
			throw new StepFailedException();                                               
		}				
	}
	
	/**
	 * Add info for a test step in script log  
	 */
	protected void addTestStepInfo(String...params)
	{
		ScriptLog scriptLog = ScriptLog.getInstance();
		scriptLog.addTestStepParameter("ComponentName", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, getClass().getSimpleName());
		scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
		Utils.printMessageOnConsole("GenieID of Component: " + genieID);
		for(int i = 0; i<params.length; i++)
		{
			scriptLog.addTestStepParameter("Param" + (i+1), GenieLogEnums.GenieParameterType.PARAM_INPUT, params[i]);
		}
	}

	/**
	 * Waits for a particular Component to appear on Stage
	 *  
	 * @param bLogging
	 * 			If true step is added in GenieLogs
	 * @param callAlternateApproach
	 * 			If true then getTrimmedGenieId is also called
	 * @param checkVisibility
	 * 			If true then visibility of component is also checked
	 *  
	 * @param timeInSeconds
	 * 		Time to wait in Seconds
	 * 
	 * @return
	 * 		Boolean value indicating the result of action
	 * 		It will still return false if timeout happens
	 * @throws StepTimedOutException 
	 * @throws StepFailedException 
	 */
	
	Result waitForComponent(boolean bLogging, boolean callAlternateApproach, boolean checkVisibility, int timeInSeconds) throws StepFailedException, StepTimedOutException
	{
		Result result = new Result();
		long timeToWait;
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		ScriptLog scriptLog = ScriptLog.getInstance();
		
		if(app == null)
		{
			result.result = false;
			result.message = "SWFApp object for this component is null.";
			return result;
		}
		
		timeToWait = System.currentTimeMillis() + (timeInSeconds*1000L);
	
		if (StaticFlags.getInstance().wasSwfDeadOnce(this.getAppName()))
		{
			//Means, swf becomes alive after disappearing
			StaticFlags sf = StaticFlags.getInstance();
			sf.conenctToSwf(this.getAppName());
		}
		
		//Wait till genieId is not found or timeout doesn't happens.
		if(checkVisibility)
			result = sc.doAction(app.name, "exists", "<String>"+genieID+"</String>");
		else
			 result = sc.doAction(app.name, "existsOnStage", "<String>"+genieID+"</String>");

		//If swf not present, no need to wait for GenieID
		if (!result.message.equals(Utils.SWF_NOT_PRESENT))
		{
			//Add a step in ScriptLog as we are going to consume time in waiting for component to appear
			if (bLogging == true){
				scriptLog.addTestStep("Waiting for Component", GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE, this.getClass().getSimpleName());
				addTestStepInfo();
			}

			while(result.result == false && System.currentTimeMillis() < timeToWait){
				if(checkVisibility)
					result = sc.doAction(app.name, "exists", "<String>"+genieID+"</String>");
				else
					result = sc.doAction(app.name, "existsOnStage", "<String>"+genieID+"</String>");
				//Make thread sleep for 200 ms.
				try{
					Thread.sleep(200);
				}catch(Exception e){break;}
			}
			
			if (bLogging == true && result.result == false){
				scriptLog.addTestStepMessage("Component not directly found. Will try alternate approach of getting the Component", GenieLogEnums.GenieMessageType.MESSAGE_INFO);
			}
			if(!result.result && callAlternateApproach)
			{
				result = sc.doAction(app.name, "getTrimmedGenieID", "<String>"+genieID+"</String>");
				if(result.result)
				{
					try{
						Document doc = Utils.getXMLDocFromString(result.message);
 					
						//If by trimming the new GenieID is found then use this for future references
						if (result.result){
							String newGenieID = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue();
	   						StaticFlags.getInstance().setUpdatedGenieId(genieID, newGenieID);
	   						genieID = newGenieID;
	   						result.message = "New GenieID with alternate approach is: " + genieID;
	   					}
	   				}
					catch(RuntimeException e){
						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.waitForComponent"+e.getMessage());
					}
					catch(Exception e){
	   					StaticFlags sf=StaticFlags.getInstance();
	   					sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
	   				}
				}
				else
				{
					if(!result.result)
					{
						if(result.message.length() != 0)
						{
							try{
								Document doc = Utils.getXMLDocFromString(result.message);
								result.message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
							}catch(Exception e){
								StaticFlags sf = StaticFlags.getInstance();					
								sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
							}
						}
					}
				}
			}
			
			if(!result.result && result.message.length() == 0)
			{
				result.message = "Genie id of the component can not be found in application"; 
			}
		}
		else
		{
			this.app.isConnected = false;
			StaticFlags sf = StaticFlags.getInstance();
			sf.pushClosedSwf(this.getAppName());
		}
		if(bLogging)
			updateResult(result);
		return result;
	}
	//========================================================================================
	// Some Private methods to be used here
	//========================================================================================
	
	/**
	 * Internally used method for getting ValueOf a property for a component
	 * The Primary difference between this and public exposed method is that it do not put logging
	 * info. Since this method is called multiple times in one call, it might have resulted in multiple logs
	 * which is incorrect
	 */
	private String getValueOfInternal(String name) throws StepTimedOutException,StepFailedException
	{
		class GetValueExecuteActionInternal extends ExecuteActions
		{
			String propValue = "";
			public GetValueExecuteActionInternal(
					GenieComponent obj, 
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
				bLogging = false;
			}
			protected void initLogs()
			{
				return;
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.GETVALUEOF, inputData);				
				
				return result;
			}
			protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
			{
				Boolean bresult = false;
				Document doc = Utils.getXMLDocFromString(result.message);

				try{
					String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
					bresult =  Boolean.parseBoolean(temp);
				}catch(Exception e){
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
				
				if (bresult){
					try{
						propValue = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Retrieved Property Value: " + propValue);
					}catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
					Utils.printErrorOnConsole("Error occured in Retrieving Property Value");
			}
		}
		
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(name);
		GetValueExecuteActionInternal dg = new GetValueExecuteActionInternal(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		
		dg.performAction();
		
		String propValue = dg.propValue;
		return propValue;
	}
	/**
	 * This Method is parsing results for waitForEvent() method.
	 *  
	 */
	private Hashtable<String, String>parseEventData(String data)
	{
		Document doc = Utils.getXMLDocFromString(data);
		Hashtable<String, String> table = new Hashtable<String, String>();
		try{
			NodeList list = doc.getElementsByTagName("EventProperty"); 
			for(int i=0; i< list.getLength() ; ++i)
			{
				Node propNode = list.item(i);
				NamedNodeMap attribMap = propNode.getAttributes();
				
				String key = attribMap.getNamedItem("key").getTextContent();
				String value = attribMap.getNamedItem("value").getTextContent();
				table.put(key, value);
			}
			
		}
		catch(RuntimeException e){
			StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.getValueOfInternal"+e.getMessage());
		}
		catch(Exception e){
			StaticFlags sf=StaticFlags.getInstance();
			sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
		}
		return table;
	}
	
	/**
	 * Gets the number of automatable children of a GenieComponent.
	 * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Integer value of automatable children of the component. In case of Error 0 is returned.
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.0			
	 */
	private int  getNumAutomatableChildren(boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class GetNumberExecuteAction extends ExecuteActions
		{
			String numChildren = "";
			public GetNumberExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("GetNumberAutomatableChildren", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
					scriptLog.addTestStepParameter("NumberOfChildren", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(0));
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.GETNUMAUTOMATABLECHILDREN, inputData);				
				
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
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
				
				try{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}
				catch(RuntimeException e)
				{
					StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.getNumAutomatableChildren"+e.getMessage());
					message = "";
				}
				catch(Exception e)
				{
					message = "";
				}

				if (bresult){
					try{
						numChildren = doc.getElementsByTagName("numAutomationChildren").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Number of Automatable children:" + numChildren);
					}catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in Retrieving Number of Automatable children");
					else
						Utils.printErrorOnConsole(message);
				}
				
				Result res = new Result();
				res.result = bresult;
				res.message = message;
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("NumAutomationChildren", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, numChildren);
					gc.updateResult(res);
				}
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();;
		argsList.add("numchildren");		
		GetNumberExecuteAction dg = new GetNumberExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String numChildren = dg.numChildren;
		int finalNumChildren = 0;
		
		try{
			finalNumChildren=Integer.parseInt(numChildren);
		}catch(Exception e){
			StaticFlags sf = StaticFlags.getInstance();					
			sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
		}

		return finalNumChildren;  
	}



/**
	 * Gets the child at a specified index.
	 * 
	 * @param index
	 *          the index of the child that needs to be returned
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Object as GenieComponent{@link com.adobe.genie.executor.components.GenieComponent}. In case of Error returns null
	 *  
	 * @throws Exception
	 * 
	 * @since Genie 1.0			
	 */
	private GenieComponent getChildAt(int index,boolean bLogging) throws StepFailedException, StepTimedOutException
	{
		class GetChildAtExecuteAction extends ExecuteActions
		{
			public GenieComponent genieComponent = null;
			public String childGenieId = "";
			private boolean isDebugMode = false;
			public GetChildAtExecuteAction(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("GetChildAt", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
					scriptLog.addTestStepParameter("Index", GenieLogEnums.GenieParameterType.PARAM_INPUT,args.get(0));
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
				Result result = sc.doAction(gc.getAppName(), BaseEvent.GETCHILDAT, inputData);				
				
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
				
				try{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}catch(Exception e){
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}

				if (bresult){
					try{						
						childGenieId = doc.getElementsByTagName("ChildGenieId").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Genie Id of child At specified index :" + childGenieId);
					}catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in Retrieving the child");
					else
						Utils.printErrorOnConsole(message);
				}
					
				
				Result res = new Result();
				res.result = bresult;
				res.message = message;
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("ChildGenieId", GenieLogEnums.GenieParameterType.PARAM_OUTPUT,this.childGenieId);
					gc.updateResult(res);
				}
			}
		}
		
		ArrayList<String> argsList=new ArrayList<String>();
		String indexTemp=Integer.toString(index);
		argsList.add(indexTemp);		
		GetChildAtExecuteAction dg = new GetChildAtExecuteAction(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(),argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String childGenieId = dg.childGenieId;
		
		if (!(childGenieId.equalsIgnoreCase(""))){
			dg.genieComponent=new GenieComponent(childGenieId, app,false);
			return dg.genieComponent;  }
		else 
			return null;
	}


/**
	 * This method returns parent of a GenieComponent
	 * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
	 * @return 
	 * 		Parent of given GenieComponent as GenieComponent
	 * 
	 * @throws Exception
	 *   
	 * @since Genie 1.0
	 */
	private GenieComponent getParent(boolean bLogging) throws StepTimedOutException,StepFailedException
	{
		class GetParentExecuteActions extends ExecuteActions
		{
			String parentGenieID = "";
			public GetParentExecuteActions(
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
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStep("GetParent", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
					addTestStepInfo();
				}
				
			}
			protected String prepareArgs(ArrayList<String> args)
			{
				String data = "";
				data = "<XML>";

				data = data + "";
								
				data = data + "<GenieID>" + genieID + "</GenieID>";
				
				data += "</XML>";
				return data;
			}
			protected Result doSocketAction(String inputData)
			{
				SynchronizedSocket sc = SynchronizedSocket.getInstance();
				Result result = sc.doAction(gc.getAppName(), BaseEvent.GETPARENT, inputData);				
				
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
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
				try{
				
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}catch(Exception e){
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}

				if (bresult){
					try{
						parentGenieID = doc.getElementsByTagName("Parent").item(0).getChildNodes().item(0).getNodeValue();
						Utils.printMessageOnConsole("Retrieved Parent Genie ID Value: " + parentGenieID);
					}catch(Exception e){
						StaticFlags sf = StaticFlags.getInstance();					
						sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
					}
				}
				else
				{
					if(message.equals(""))
						Utils.printErrorOnConsole("Error occured in Retrieving Parent");
					else
						Utils.printErrorOnConsole(message);
				}
					
				
				Result res = new Result();
				res.result = bresult;
				res.message = message;
				
				if(bLogging)
				{
					ScriptLog scriptLog = ScriptLog.getInstance();
					scriptLog.addTestStepParameter("ParentGenieID", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, parentGenieID);
					gc.updateResult(res);
				}	
		
			}
		}
		
		ArrayList<String> argsList = new ArrayList<String>();
		GetParentExecuteActions dg = new GetParentExecuteActions(
				this, "", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, getClass().getSimpleName(), argsList);
		dg.bLogging = bLogging;
		dg.performAction();
		
		String parentGenieID =dg.parentGenieID;
		return new GenieComponent(parentGenieID,app);
	}
	
	/**
	 *	Convert GenieLocator Info object to an XML representation 
	 */
	private String convertToXML(GenieLocatorInfo info)
	{
		String output = "<Properties>";
		if(info.id != null && info.id.length()>0)
			output += "<id value=\""+ info.id +"\" />";
		
		if(info.label != null && info.label.length()>0)
			output += "<label value=\""+ info.label +"\" />";
		
		if(info.text != null && info.text.length()>0)
			output += "<text value=\""+ info.text +"\" />";
		
		if(info.className != null && info.className.length()>0)
			output += "<className value=\""+ info.className +"\" />";
		
		if(info.qualifiedClassName != null && info.qualifiedClassName.length()>0)
			output += "<qualifiedClassName value=\""+ info.qualifiedClassName +"\" />";
		
		
		if(info.enabled != null && info.enabled.length()>0)
			output += "<enabled value=\""+ info.enabled +"\" />";
		
		if(info.visible != null && info.visible.length()>0)
			output += "<visible value=\""+ info.visible +"\" />";
		
		if(info.isHierarchyVisible != null && info.isHierarchyVisible.length()>0)
			output += "<isHierarchyVisible value=\""+ info.isHierarchyVisible +"\" />";
		
		if(info.index > -1)
			output += "<index value=\""+ info.index +"\" />";
		
		 Set<String> set = info.propertyValueTable.keySet();

	    Iterator<String> itr = set.iterator();
	    //SCA
	    StringBuffer buf = new StringBuffer();
	    while (itr.hasNext()) {
	      String key = itr.next();
	      buf.append("<" + key + " value=\""+ info.propertyValueTable.get(key) +"\" />");
	      //output += "<" + key + " value=\""+ info.propertyValueTable.get(key) +"\" />";
	      
	    }
	    String s=buf.toString();
	    output +=s;
		output += "</Properties>";
		return output;
	}
	
	/**
	 *	Enums to be used for creating touch preload arguments 
	 */
	private static enum TouchPointValues
	{
		FIRSTTOUCHARGS, SECONDTOUCHARGS, THIRDTOUCHARGS, FOURTHTOUCHARGS, FIFTHTOUCHARGS
	}
	
	/**
	 *	Method to be used for creating touch preload arguments 
	 */
	private static TouchPointValues getTouchCode(int code)
	{
		for(TouchPointValues e : TouchPointValues.values())
		{
			if (code == e.ordinal())
				return e;
		}
		return null;
	}
	
	// Class used in getValueOf() methods
	class GetValueExecuteAction extends ExecuteActions
	{
		String propValue = "";
		String actionType = BaseEvent.GETVALUEOF;
		public GetValueExecuteAction(
				GenieComponent obj, 
				String getValueType,
				String eventName, 
				GenieStepType stepType, 
				String className, 
				ArrayList<String> args) 
		{
			super(obj, eventName, stepType, className, args);
			actionType = getValueType;
		}
		public GetValueExecuteAction(
				GenieComponent obj, 
				String getValueType,
				String eventName, 
				GenieStepType stepType, 
				String className, 
				ArrayList<String> args,
				boolean checkVisibility) 
		{
			super(obj, eventName, stepType, className, args, checkVisibility);
			actionType = getValueType;
		}
		protected void initLogs()
		{
			if(bLogging)
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStep("GetProperty", GenieLogEnums.GenieStepType.STEP_FETCH_VALUE_TYPE, className);
				addTestStepInfo();
				scriptLog.addTestStepParameter("PropertyName", GenieLogEnums.GenieParameterType.PARAM_INPUT, args.get(0));
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
			Result result = sc.doAction(gc.getAppName(), actionType, inputData);				
			
			return result;
		}
		protected void parseResult(Result result) throws StepFailedException, StepTimedOutException
		{
			Boolean bresult = false;
			String message = "";
			Document doc = Utils.getXMLDocFromString(result.message);
			
			
			try{
				if(doc.getElementsByTagName("Result").item(0).getChildNodes().getLength() > 0)
				{
					String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
					bresult =  Boolean.parseBoolean(temp);
				}
					
			}catch(Exception e){
				StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());
			}
			
			try{
				if(doc.getElementsByTagName("Message").item(0).getChildNodes().getLength() > 0)
				{
					message = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue();
				}
				else
				{
					message = "";
				}
			}
			catch(RuntimeException e)
			{
				StaticFlags.getInstance().printErrorOnConsoleDebugMode("Runtime Exception occured in GenieComponent.getValueOf"+e.getMessage());
				message = "";
			}
			catch(Exception e)
			{
				message = "";
			}

			if (bresult){
				try{
					propValue = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue();
					Utils.printMessageOnConsole("Retrieved Property Value: " + propValue);
				}catch(Exception e){
					StaticFlags sf = StaticFlags.getInstance();					
					sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
				}
			}
			else
			{
				if(message.equals(""))
					Utils.printErrorOnConsole("Error occured in Retrieving Property Value");
				else
					Utils.printErrorOnConsole(message);
			}
			
			Result res = new Result();
			res.result = bresult;
			res.message = message;
			
			if(bLogging)
			{
				ScriptLog scriptLog = ScriptLog.getInstance();
				scriptLog.addTestStepParameter("PropertyValue", GenieLogEnums.GenieParameterType.PARAM_OUTPUT, propValue);
				gc.updateResult(res);
			}
		}
	}
}
