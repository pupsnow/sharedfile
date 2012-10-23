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

import java.awt.Point;
import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.iexecutor.uiEvents.IUIImage;
import com.adobe.genie.executor.internalLog.ScriptLog;

import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;

/**
 * Provides the methods necessary to perform <b>Mouse UI Events</b> based on provided image
 * <p>
 * These Set of methods finds the image provided as path in parameter of methods and searches for the image
 * on screen. When found perform the desired operation on them 
 * 
 * @since Genie 0.5
 */

public class UIImage implements IUIImage {
	
	UIFunctions uiFunctions = null;
	ScriptLog scriptLog = null;
	private boolean isDebugMode = false;
	
	/**
     * Default Constructor, No Parameters Required
     *     
     */	
	public UIImage() {
		StaticFlags sf = StaticFlags.getInstance();
		this.isDebugMode = sf.isdebugMode();
		uiFunctions = new UIFunctions(isDebugMode);
		scriptLog = ScriptLog.getInstance();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("UIFunctions");
	}
	
	//========================================================================================
	// Some public exposed methods for a UI events based on provided image
	//========================================================================================

	
    /**
     * Clicks at the center coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image. If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void clickImage(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];

    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.click(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Click Successful";
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    
    /**
     * Clicks at the hot spot coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc 
     *            If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.10
     */
    public void clickImageHotSpot(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	try{
	    	UsageMetricsData usageInstance = UsageMetricsData.getInstance();
			usageInstance.addFeature("ImageHotspot");
    	}catch(Exception e){
    		StaticFlags sf = StaticFlags.getInstance();					
			sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
    	}

		Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];

    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageHotSpotCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.click(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Click Successful";
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Right Clicks at the center coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image. If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void rightClickImage(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];

    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Right Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.rightClick(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Right Click Successful";
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }

    
    /**
     * Right Clicks at the hot spot coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.10
     */
    public void rightClickImageHotSpot(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	try{
	    	UsageMetricsData usageInstance = UsageMetricsData.getInstance();
			usageInstance.addFeature("ImageHotspot");
    	}catch(Exception e){
    		StaticFlags sf = StaticFlags.getInstance();					
			sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
    	}

		Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];

    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Right Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageHotSpotCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.rightClick(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Right Click Successful";
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    /**
     * Double Clicks at the center coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image. If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void doubleClickImage(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Double Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.doubleClick(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Double Click Successful";
    		}	
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }

    
    /**
     * Double Clicks at the hot spot coordinates of the image whose path is passed as parameter 
     *
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @throws Exception
     * 
     * @since Genie 0.10
     */
    public void doubleClickImageHotSpot(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	try{
	    	UsageMetricsData usageInstance = UsageMetricsData.getInstance();
			usageInstance.addFeature("ImageHotspot");
    	}catch(Exception e){
    		StaticFlags sf = StaticFlags.getInstance();					
			sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
    	}
    	
		Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Double Click On Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
    		}
    		Point imageXY = uiFunctions.getImageHotSpotCoordinates(imagePath, myTolerance);
    		
    		if(imageXY.x != -1 && imageXY.y != -1){
    			uiFunctions.doubleClick(imageXY.x,imageXY.y);
    			result.result = true;
    			result.message = "Image Double Click Successful";
    		}	
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }

    /**
     * Returns Center coordinates of the image whose path is passed as parameter
     *
     * @param imagePath
     *            path of the image. If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     * 
     */
    public Point findImage(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	return findImage(imagePath,true,myTolerance);
    } 
    
    /**
     * Returns the current center coordinates of the image as it exists on screen 
     * whose path is passed as parameter.
     * <p>
     * The Coordinates returned are current global screen coordinates and can be used 
     * directly to perform any click operations
     *
     * @param imagePath
     *            path of the image. If image is not found on screen step is logged as failure
     * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     *   
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 1.0
     * 
     */
    public Point findImage(String imagePath, boolean bLogging, int... tolerance)throws StepTimedOutException, StepFailedException{
    	Point imageCoordinates = new Point(-1,-1);
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	if (bLogging){
	    	if(scriptLog != null){
				scriptLog.addTestStep("Find Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	    		scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
	    	}
    	}
    	
    	try{
    		imageCoordinates =  uiFunctions.getImageCoordinates(imagePath, myTolerance);
    		
    		if(imageCoordinates.x != -1 && imageCoordinates.y != -1){
    			result.result = true;
    			result.message = "Image found at X="+imageCoordinates.x+" Y="+imageCoordinates.y;
    			imageCoordinates = new Point(imageCoordinates.x,imageCoordinates.y);
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
      	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
      	UIEventsValidationFunctions.checkScriptTerminationOptionalLoggingDesktop(result,bLogging,false);
      	return imageCoordinates;
    } 

    
    /**
     * Returns the current HotSpot coordinates of the image as it exists on screen 
     * whose path is passed as parameter.
     * <p>
     * If Image do not have any HotSpot information then center coordinates will be returned
     * <p>
     * The Coordinates returned are current global screen coordinates and can be used 
     * directly to perform any click operations
     * 
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 0.10
     */
    public Point findImageHotSpot(String imagePath, int... tolerance)throws StepTimedOutException, StepFailedException{
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	return findImageHotSpot(imagePath,true,myTolerance);
    }
    
    /**
     * Returns the current HotSpot coordinates of the image as it exists on screen 
     * whose path is passed as parameter.
     * <p>
     * If Image do not have any HotSpot information then center coordinates will be returned
     * <p>
     * The Coordinates returned are current global screen coordinates and can be used 
     * directly to perform any click operations
     * 
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     * 
	 * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     *   
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 1.0
     */
    public Point findImageHotSpot(String imagePath, boolean bLogging, int... tolerance)throws StepTimedOutException, StepFailedException{
    	try{
	    	UsageMetricsData usageInstance = UsageMetricsData.getInstance();
			usageInstance.addFeature("ImageHotspot");
    	}catch(Exception e){
    		StaticFlags sf = StaticFlags.getInstance();					
			sf.printErrorOnConsoleDebugMode("Exception Occured"+e.getMessage());	
    	}
    	
		Point imageCoordinates = new Point(-1,-1);
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	if (bLogging){
	    	if(scriptLog != null){
				scriptLog.addTestStep("Find Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	    		scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
	    	}
    	}
    	try{
    		imageCoordinates =  uiFunctions.getImageHotSpotCoordinates(imagePath, myTolerance);
    		
    		if(imageCoordinates.x != -1 && imageCoordinates.y != -1){
    			result.result = true;
    			result.message = "Image found at X="+imageCoordinates.x+" Y="+imageCoordinates.y;
    			imageCoordinates = new Point(imageCoordinates.x,imageCoordinates.y);
    		}
    		else{
    			result.message = "Failed to identify image "+imagePath;
    		}
      	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
      	UIEventsValidationFunctions.checkScriptTerminationOptionalLoggingDesktop(result, bLogging,false);
      	return imageCoordinates;
    } 
    /**
     * Waits for an image to appear on the screen and return its coordinates if found.
     * <p>
     * The Coordinates returned are current global screen coordinates and can be used 
     * directly to perform any click operations.
     * 
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     *
     * @param timeInSeconds 
     *           Time in seconds for which to wait.
     *           
     * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     *  
     * 
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 1.6
     */
    public Point waitForImage(String imagePath,int timeInSeconds,boolean bLogging,int... tolerance)throws StepTimedOutException, StepFailedException{
    	
    	Point imageCoordinates = new Point(-1,-1);
    	long timeToWait;
    	Result result = new Result();
    	result.result = false;
    	
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	
    	timeToWait = System.currentTimeMillis() + (timeInSeconds*1000L);
    	
    	if (bLogging){
	    	if(scriptLog != null){
				scriptLog.addTestStep("Wait For Image", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	    		scriptLog.addTestStepParameter("Image Path", GenieLogEnums.GenieParameterType.PARAM_INPUT, imagePath);
	    		scriptLog.addTestStepParameter("Tolerance", GenieLogEnums.GenieParameterType.PARAM_INPUT, myTolerance + "");
	    		scriptLog.addTestStepParameter("Timeout", GenieLogEnums.GenieParameterType.PARAM_INPUT, timeInSeconds + "");
	    		
	    	}
    	}
    	
    	while(result.result == false && System.currentTimeMillis() < timeToWait)
    	{
    		
    		try{
	        		imageCoordinates =  uiFunctions.getImageCoordinates(imagePath, myTolerance);        		
	        		if(imageCoordinates.x != -1 && imageCoordinates.y != -1)
	        		{
	        			result.result = true;
	        			result.message = "Image found at X="+imageCoordinates.x+" Y="+imageCoordinates.y;
	        			imageCoordinates = new Point(imageCoordinates.x,imageCoordinates.y);
	        		}
	        		else
	        		{
	        			result.message = "Failed to identify image "+imagePath;
	        		}
          	    }
    	    catch(Exception e)
          	    {
	        		result.message = "Exception: " + e.getMessage();
	        		if (isDebugMode)
	        		{
	    				e.printStackTrace();
    			    }
        	     }
			
		 }    	
    	
      	UIEventsValidationFunctions.checkScriptTerminationOptionalLoggingDesktop(result,bLogging,false);
      	return imageCoordinates;
    	
    }
    /**
     * Waits for an image to appear on the screen and return its coordinates if found,
     * this method waits till the default timeout occurs.
     * <p>
     * The Coordinates returned are current global screen coordinates and can be used 
     * directly to perform any click operations.
     * 
     * @param imagePath
     *            path of the image.Example "C:\\Image.png" etc  
     *            If image is not found on screen step is logged as failure
     *            
     * @param timeInSeconds 
     *           Time in seconds for which to wait.
     * @param tolerance
     * 			  Optional Parameter, tolerance while finding the image as % (0-100). If not
     * 					specified the default value is 5 (treated as 5%) 
     * 
     * @return 
     * 			global (x,y) coordinates of the image w.r.t the Screen as java.awt.point. If it fails to find image the return value 
     * is x=-1,y=-1            
     * 
     * @throws Exception
     * 
     * @since Genie 1.6
     */
    public Point waitForImage(String imagePath, int timeInSeconds, int... tolerance)throws StepTimedOutException, StepFailedException{
    	int myTolerance=0;
    	//Set Default value of tolerance
    	if(tolerance.length == 0)
    		myTolerance = 5;
    	else myTolerance = tolerance[0];
    	return waitForImage(imagePath,timeInSeconds,true,myTolerance);
    }
   
}
