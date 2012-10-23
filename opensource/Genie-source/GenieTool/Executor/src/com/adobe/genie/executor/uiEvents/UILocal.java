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
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.iexecutor.uiEvents.IUILocal;
import com.adobe.genie.utils.Utils;

import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;

/**
 * Provides the methods necessary to perform <b>Mouse UI Events</b> based on coordinate w.r.t current starting 
 * position of SWF
 * <p>
 * These Set of methods calculate the actual position of Object on run time  by asking the Flash player stage
 * and is lot more reliable. These usually will not change with screen resolution or on different platforms
 * but <font color="#FF0000"> might change with component reflow in the application</font>
 * <p>
 * Starting with Genie 1.1, this class is also able to perform UI operations on devices. Some of the methods
 * are valid for both devices and desktop while some are valid only for desktop and similarly other only for device
 * <p>
 * In case a method is applicable only for desktop, using it on device will result in step failure and vice versa
 * 
 * @since Genie 0.5
 */
public class UILocal implements IUILocal{
	private UIFunctions uiFunctions = null;
	private ScriptLog scriptLog = null;
	private SWFApp app = null;
	private boolean isDebugMode = false;
	
	/**
     * Constructor having SWF(on which to perform UI actions) object as parameter
     *
     * @param SWF
     *            Object of SWF application on which to perform UI actions. 
     *            This object is outcome of {@link com.adobe.genie.executor.GenieScript#connectToApp(java.lang.String)} method 
     *            of {@link com.adobe.genie.executor.GenieScript} class)
     */
	public UILocal(SWFApp SWF) {		
		
		StaticFlags sf = StaticFlags.getInstance();
		
		this.app = SWF;
		this.isDebugMode = sf.isdebugMode();
		this.uiFunctions = new UIFunctions(isDebugMode);
		this.scriptLog = ScriptLog.getInstance();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("UIFunctions");
	}

	//========================================================================================
	// Some public exposed methods for a UI events based on local SWF coordinates
	//========================================================================================

	/**
     * Clicks at (x, y) coordinate w.r.t SWF 
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param x
     *            x coordinate w.r.t SWF
     * @param y
     *            y coordinate w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(int x, int y)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
		if(scriptLog != null){
			scriptLog.addTestStep("Click: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
	    }
				    		   		            
        try{
	    	
    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
	    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
    		Thread.sleep(1000);
    	
    		//Get Screen co-ordinates of the GenieUI Image
    		Point genieXY = uiFunctions.getUIGenieCoordinates();
    		
    		//Verify of UIGenieImage coordinates are valid
    		if(genieXY.x != -1 && genieXY.y != -1){
    			uiFunctions.click(x+genieXY.x,y+genieXY.y);
    			result.result = true;
    			result.message = "Click Successful";
    		}
    		else{
    			result.message = "Failed to identify UIGenieImage for application "+app.name;
      		}
	
   	      }catch(Exception e)
       	   {
       		result.message = "Exception: " + e.getMessage();
    	   }
       	finally
       	{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
       		}catch(Exception e){
       			if (this.isDebugMode)
       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
       	    }
   	    }
	  
    			
	     UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Clicks at Point p w.r.t SWF 
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param p
     *            Point p coordinates w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(Point p)throws StepTimedOutException, StepFailedException{
    	click(p.x,p.y);
    }
    
    /**
     * Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT-0, CTRL-1 or ALT-2)pressed 
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param x
     *            x coordinate w.r.t SWF
     * @param y
     *            y coordinate w.r.t SWF
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(int x, int y,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	if(scriptLog != null){
			scriptLog.addTestStep("Click: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
		}

    	try{
    			    		
    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
	    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
    		Thread.sleep(1000);
    	
    		//Get Screen co-ordinates of the GenieUI Image
    		Point genieXY = uiFunctions.getUIGenieCoordinates();
    		
    		//Verify of UIGenieImage coordinates are valid
    		if(genieXY.x != -1 && genieXY.y != -1){
    			uiFunctions.click(x+genieXY.x, y+genieXY.y, key_Modifier);
    			result.result = true;
    			result.message = "Click Successful";
    		}
    		else{
    			result.message = "Failed to identify UIGenieImage for application "+app.name;
    		}
       	}catch(Exception e){
       		result.message = "Exception: " + e.getMessage();
    	}
    	 finally{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
	       		}catch(Exception e){
	       			if (this.isDebugMode)
	       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
	       		}
    	 	}
	    	
	   
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
    }
    
    /**
     * Clicks at Point p  w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param p
     *            Point p coordinates  w.r.t SWF
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(Point p,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	click(p.x,p.y,key_Modifier);
    }
    
    /**
	 * Right Clicks at (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param x
	 *            x coordinate w.r.t SWF
	 * @param y
	 *            y coordinate w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void rightClick(int x, int y)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
    	result.result = false;
    	if(scriptLog != null){
			scriptLog.addTestStep("Right Click: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}
		try{			
			//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
				UIEventsValidationFunctions.changetoUIGenieIcon(app);
			Thread.sleep(1000);
    	
			//Get Screen co-ordinates of the GenieUI Image
			Point genieXY = uiFunctions.getUIGenieCoordinates();
			
			//Verify of UIGenieImage coordinates are valid
			if(genieXY.x != -1 && genieXY.y != -1){
				uiFunctions.rightClick(x+genieXY.x, y+genieXY.y);
				result.result = true;
    			result.message = "Right Click Successful";
			}
			else{
				result.message = "Failed to identify UIGenieImage for application "+app.name;
			}
		
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
    	}
		finally{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
       		}catch(Exception e){
       			if (this.isDebugMode)
       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
       	      }
		}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}

	/**
	 * Right Clicks at Point p w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param p
	 *            point p coordinates w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void rightClick(Point p)throws StepTimedOutException, StepFailedException{
		rightClick(p.x,p.y);
	} 

	/**
	 * Right Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param x
	 *            x coordinate w.r.t SWF
	 * @param y
	 *            y coordinate w.r.t SWF
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
	public void rightClick(int x, int y, int key_Modifier )throws StepTimedOutException, StepFailedException{
		Result result = new Result();
    	result.result = false;
    	if(scriptLog != null){
			scriptLog.addTestStep("Right Click: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
		}
		try{
			
			//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
				UIEventsValidationFunctions.changetoUIGenieIcon(app);
			Thread.sleep(1000);
    	
			//Get Screen co-ordinates of the GenieUI Image
			Point genieXY = uiFunctions.getUIGenieCoordinates();

			//Verify of UIGenieImage coordinates are valid
			if(genieXY.x != -1 && genieXY.y != -1){
				uiFunctions.rightClick(x+genieXY.x, y+genieXY.y, key_Modifier);
				result.result = true;
				result.message = "Right Click Successful";
			}
			else{
				result.message = "Failed to identify UIGenieImage for application "+app.name;
			}
		
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
    	}
		finally{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
       		}catch(Exception e){
       			if (this.isDebugMode)
       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
       	 }
		}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}

	/**
	 * Right Clicks at Point p w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param p
	 *            Point p coordinates w.r.t SWF
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
	public void rightClick(Point p, int key_Modifier)throws StepTimedOutException, StepFailedException{
		rightClick(p.x,p.y,key_Modifier);
	} 
	
	/**
	 * Double Clicks at (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
	 *
	 * @param x
	 *            x coordinate w.r.t SWF
	 * @param y
	 *            y coordinate w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void doubleClick(int x, int y)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
    	
		if(scriptLog != null){
			scriptLog.addTestStep("Double Click: SWF App",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}  
		try{
					
				//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
					UIEventsValidationFunctions.changetoUIGenieIcon(app);
				Thread.sleep(1000);
	    	
				//Get Screen co-ordinates of the GenieUI Image
				Point genieXY = uiFunctions.getUIGenieCoordinates();
				
				//Verify of UIGenieImage coordinates are valid
				if(genieXY.x != -1 && genieXY.y != -1){
					uiFunctions.doubleClick(x+genieXY.x, y+genieXY.y);
					result.result = true;
					result.message = "Double Click Successful";
				}
				else{
					result.message = "Failed to identify UIGenieImage for application "+app.name;
				}
			
			}catch(Exception e){
				result.message = "Exception: " + e.getMessage();
	    	}
			finally{
	       		try{
		       		//Change color of genieImage from UIGenieImage to previous Genie Image
		       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
	       		}catch(Exception e){
	       			if (this.isDebugMode)
	       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
	       	}
	       	}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	
	}

	/**
	 * Double Clicks at Point p w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
	 *
	 * @param p
	 *            Point p coordinates w.r.t SWF
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void doubleClick(Point p)throws StepTimedOutException, StepFailedException{
		doubleClick(p.x,p.y);
	}	

	/**
	 * Double Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param x
	 *            x coordinate w.r.t SWF
	 * @param y
	 *            y coordinate w.r.t SWF
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
	public void doubleClick(int x, int y, int key_Modifier)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Double Click: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
		}
		try{
			
			//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
				UIEventsValidationFunctions.changetoUIGenieIcon(app);
			Thread.sleep(1000);
    	
			//Get Screen co-ordinates of the GenieUI Image
			Point genieXY = uiFunctions.getUIGenieCoordinates();
			
			//Verify of UIGenieImage coordinates are valid
			if(genieXY.x != -1 && genieXY.y != -1){
				uiFunctions.doubleClick(x+genieXY.x, y+genieXY.y, key_Modifier);
				result.result = true;
				result.message = "Double Click Successful";
			}
			else{
				result.message = "Failed to identify UIGenieImage for application "+app.name;
			}
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
    	}
		finally{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
       		}catch(Exception e){
       			if (this.isDebugMode)
       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
       		}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}

	/**
	 * Double Clicks at Point p w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *
	 * @param p
	 *            Point p coordinates w.r.t SWF
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
	public void doubleClick(Point p, int key_Modifier)throws StepTimedOutException, StepFailedException{
		doubleClick(p.x,p.y,key_Modifier);
	}
	
	/**
	 * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t SWF with Optional Logging
	 * <p>
	 * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @param x
     *            x coordinate w.r.t SWF starting coordinates (horizontal screen component)
     * @param y
     *            y coordinate w.r.t SWF starting coordinates (vertical screen component)
     * @param bLogging
     *  		If passed as true, this step is logged in Genie script logs.
     *  		If passed as false, the step will not be part of Genie script log.
     * 
     * @return
	 * 		Boolean value indicating the result of Move Mouse action
	 * 
     * @throws Exception
     * 
     * @since Genie 1.4
	 */
	 public boolean moveMouse(int x, int y, boolean bLogging) throws StepTimedOutException, StepFailedException
	 {
		Result result = new Result();
		result.result = false;
	    	if(bLogging)
			{
		    	if(scriptLog != null)
		    	{
					scriptLog.addTestStep("Move Mouse: SWF App",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
					scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
					scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
				}
			}
		   try
		   {
				
				//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
				UIEventsValidationFunctions.changetoUIGenieIcon(app);
				Thread.sleep(1000);
	    	
				//Get Screen co-ordinates of the GenieUI Image
				Point genieXY = uiFunctions.getUIGenieCoordinates();

				//Verify of UIGenieImage coordinates are valid
				if(genieXY.x != -1 && genieXY.y != -1)
				{
					uiFunctions.moveMouse(x+genieXY.x,y+genieXY.y);
					result.result = true;
					result.message = "Move Mouse Successful";
				}
				else
				{
					//Fix for Bug#3074754 by Ruchir Jain
					result.message = "Failed to move mouse on application " + app.name;
					result.message += " because either application/component was not in focus or issue occurred at genie end";
				}

			}
		   catch(Exception e)
		   {
				result.message = "Exception: " + e.getMessage();
		   }
		   finally
		   {
		       	try
		       	{
			       		//Change color of genieImage from UIGenieImage to previous Genie Image
						UIEventsValidationFunctions.changefromUIGenieIcon(app);
		       	}
		       	catch(Exception e)
		       	{
		       			if (this.isDebugMode)
		       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
		       	}
		   }
	    UIEventsValidationFunctions.checkScriptTerminationDesktop(result, bLogging);	
	    return result.result;
	 }
	
	/**
	   * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t SWF with logging enabled
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	   * 
	   * @param x
	   *            x coordinate w.r.t SWF starting coordinates (horizontal screen component)
	   * @param y
	   *            y coordinate w.r.t SWF starting coordinates (vertical screen component)
       * 
       * @throws Exception
       * 
       * @since Genie 0.5
	   */
	   public void moveMouse(int x, int y) throws StepTimedOutException, StepFailedException
	   {
		   moveMouse(x, y, true);
	   }	
	
	/**
	 * Drags mouse from current mouse position to (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 
	 * @param x
	 *            the X coordinate w.r.t SWF up-to where to drag
	 * @param y
	 *            the Y coordinate w.r.t SWF up-to where to drag
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void drag(int x, int y) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Drag Mouse: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("End X", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("End Y", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}
		try{
    		
    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
	    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
    		Thread.sleep(1000);
    	
    		//Get Screen co-ordinates of the GenieUI Image
    		Point genieXY = uiFunctions.getUIGenieCoordinates();

    		//Verify of UIGenieImage coordinates are valid
    		if(genieXY.x != -1 && genieXY.y != -1){
    			uiFunctions.drag(x+genieXY.x,y+genieXY.y);
    			result.result = true;
    			result.message = "Drag Successful";
    		}
    		else{
    			result.message = "Failed to identify UIGenieImage for application "+app.name;
      		}

    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	finally{
       		try{
	       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
	       		}catch(Exception e){}
	       	}
		
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}
	
	/**
	 * Drags mouse from current mouse position to (x, y) coordinate w.r.t SWF after pressing mouse down for some time
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
	 * @param x
	 *            the X coordinate w.r.t SWF up-to where to drag
	 * @param y
	 *            the Y coordinate w.r.t SWF up-to where to drag
	 *            
	 * @param timeToHold 
	 * 			time in miliseconds to hold the mouse down key before dragging. Hold will be applied at current mouse position
     * 
     * @throws Exception
     * 
     * @since Genie 1.0
	 */
	public void holdAndDrag(int x, int y, int timeToHold) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Hold and Drag Mouse: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("End X", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("End Y", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Time to Hold ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(timeToHold));
		}
			try{
	    		
	    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
	    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
	    		Thread.sleep(1000);
	    	
	    		//Get Screen co-ordinates of the GenieUI Image
	    		Point genieXY = uiFunctions.getUIGenieCoordinates();
	
	    		//Verify of UIGenieImage coordinates are valid
	    		if(genieXY.x != -1 && genieXY.y != -1){
	    			uiFunctions.holdAnddrag(x+genieXY.x,y+genieXY.y,timeToHold);
	    			result.result = true;
	    			result.message = "Hold and Drag Successful";
	    		}
	    		else{
	    			result.message = "Failed to identify UIGenieImage for application "+app.name;
	      		}
	
       		}catch(Exception e){
       			if (this.isDebugMode)
       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
	    		result.message = "Exception: " + e.getMessage();
	    	}
	    	finally{
	       		try{
		       		//Change color of genieImage from UIGenieImage to previous Genie Image
	       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
				}catch(Exception e){}
       		}
		 
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}
	
	/**
	 * Drags Mouse from (x1,y1) coordinate w.r.t SWF to (x2,y2) coordinate w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
	 * 
	 * @param x1 x coordinate w.r.t SWF from where to start dragging
	 * @param y1 y coordinate w.r.t SWF from where to start dragging
	 * @param x2 x coordinate w.r.t SWF where to stop dragging
	 * @param y2 y coordinate to w.r.t SWF where stop dragging
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void drag(int x1, int y1, int x2, int y2) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		

    		if(scriptLog != null){
				scriptLog.addTestStep("Drag Mouse: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			scriptLog.addTestStepParameter("Start X ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x1));
    			scriptLog.addTestStepParameter("Start Y ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y1));
    			scriptLog.addTestStepParameter("End X ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x2));
    			scriptLog.addTestStepParameter("End Y ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y2));
    		}
		    		try{
		    		
		    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
			    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
		    		Thread.sleep(1000);
		    	
		    		//Get Screen co-ordinates of the GenieUI Image
		    		Point genieXY = uiFunctions.getUIGenieCoordinates();
		    	
		    		//Verify of UIGenieImage coordinates are valid
		    		if(genieXY.x != -1 && genieXY.y != -1){
		    			uiFunctions.drag(x1+genieXY.x,y1+genieXY.y,x2+genieXY.x,y2+genieXY.y);
		    			result.result = true;
		    			result.message = "Drag Successful";
		    		}
		    		else{
		    			if(scriptLog != null){
		    				result.message = "Failed to identify UIGenieImage for application "+app.name;
		    			}
		      		}
		
		    	}catch(Exception e){
		    		result.message = "Exception: " + e.getMessage();
		    	}
		    	finally{
		       		try{
			       		//Change color of genieImage from UIGenieImage to previous Genie Image
			       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
		       		}catch(Exception e){
		       			if (this.isDebugMode)
		       				Utils.printMessageOnConsole("Exception occured:"+e.getMessage());
		       	}
	     	}
	    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}
	
	/**
	 * Drags Mouse from (x1,y1) coordinate w.r.t SWF to (x2,y2) coordinate w.r.t SWF after pressing mouse down for some time
	 * <p>
     * This method is valid for both Desktop and Device
     * 
	 * @param x1 x coordinate w.r.t SWF from where to start dragging
	 * @param y1 y coordinate w.r.t SWF from where to start dragging
	 * @param x2 x coordinate w.r.t SWF where to stop dragging
	 * @param y2 y coordinate to w.r.t SWF where stop dragging
	 * 
	 * @param timeToHold 
	 * 		time in miliseconds to hold the mouse down key before dragging. Mouse is hold at x1,y1 position
     * 
     * @throws Exception
     * 
     * @since Genie 1.0
	 */
	public void holdAndDrag(int x1, int y1, int x2, int y2, int timeToHold) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;

	    		if(scriptLog != null){
					scriptLog.addTestStep("Hold and Drag Mouse: SWF App", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
		    			scriptLog.addTestStepParameter("Start X ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x1));
		    			scriptLog.addTestStepParameter("Start Y ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y1));
		    			scriptLog.addTestStepParameter("End X ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x2));
		    			scriptLog.addTestStepParameter("End Y ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y2));
	    			scriptLog.addTestStepParameter("Time to Hold ", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(timeToHold));
	    		}		
		       try{
			    		
		    		//Change color of genieImage to UIGenieImage, so as to get co-ordinates of UIGenieImage.
			    		UIEventsValidationFunctions.changetoUIGenieIcon(app);
		    		Thread.sleep(1000);
		    	
		    		//Get Screen co-ordinates of the GenieUI Image
		    		Point genieXY = uiFunctions.getUIGenieCoordinates();
		
		    		//Verify of UIGenieImage coordinates are valid
		    		if(genieXY.x != -1 && genieXY.y != -1){
			    			uiFunctions.holdAnddrag(x1+genieXY.x,y1+genieXY.y,x2+genieXY.x,y2+genieXY.y,timeToHold);
		    			result.result = true;
		    			result.message = "Hold and Drag Successful";
		    		}
		    		else{
			    			if(scriptLog != null){
		    			result.message = "Failed to identify UIGenieImage for application "+app.name;
		      		}
			      		}
		
		    	}catch(Exception e){
		    		result.message = "Exception: " + e.getMessage();
		    	}
		    	finally{
		       		try{
			       		//Change color of genieImage from UIGenieImage to previous Genie Image
			       			UIEventsValidationFunctions.changefromUIGenieIcon(app);
			       		}catch(Exception e){}
			       	}
    		 
	    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}
	
}
