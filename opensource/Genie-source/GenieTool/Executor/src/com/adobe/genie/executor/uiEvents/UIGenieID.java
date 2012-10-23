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

import org.w3c.dom.Document;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.executor.internalLog.ScriptLog;
import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.iexecutor.uiEvents.IUIGenieID;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;

/**
 * Provides the methods necessary to perform <b>Mouse UI Events</b> based on coordinate w.r.t starting 
 * position of component whose Genie-ID is specified as parameter
 * <p>
 * These Set of methods calculate the actual position of Object on run time  by asking the Flash player stage
 * and is lot more reliable. These usually will not change with screen resolution or with component reflow
 * or on different platforms 
 * <p>
 * Starting with Genie 1.1, this class is also able to perform UI operations on devices. Some of the methods
 * are valid for both devices and desktop while some are valid only for desktop and similarly other only for device
 * <p>
 * In case a method is applicable only for desktop, using it on device will result in step failure and vice versa
 * 
 * @since Genie 0.5
 */
public class UIGenieID implements IUIGenieID {
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
	public UIGenieID(SWFApp SWF) {
		StaticFlags sf = StaticFlags.getInstance();
		
		this.app = SWF;
		this.isDebugMode = sf.isdebugMode();
		this.uiFunctions = new UIFunctions(isDebugMode);
		this.scriptLog = ScriptLog.getInstance();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("AutoSwitching");	
	}
	
	//========================================================================================
	// Some public exposed methods for a UI events based on GenieID
	//========================================================================================

	/**
     * Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(String genieID, int x, int y) throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	try{
    		if(scriptLog != null){
    			scriptLog.addTestStep("Click: Component" , GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify if GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.click(genieIDCoordinates.x+x,genieIDCoordinates.y+y);
    			result.result = true;
    			result.message = "Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
		}
	    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(String genieID,Point p) throws StepTimedOutException, StepFailedException{
    	click(genieID,p.x,p.y);
    } 
    
    /**
     * Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     *
     *	
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(String genieID,int x, int y,int key_Modifier) throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	try{
    		if(scriptLog != null){
    			scriptLog.addTestStep("Click: Component", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    			Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.click(genieIDCoordinates.x+x, genieIDCoordinates.y+y, key_Modifier);
    			result.result = true;
    			result.message = "Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void click(String genieID,Point p,int key_Modifier) throws StepTimedOutException, StepFailedException{
    	click(genieID,p.x,p.y,key_Modifier);
    }

	/**
     * Right Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void rightClick(String genieID,int x, int y) throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Right Click: Component" , GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
				Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.rightClick(genieIDCoordinates.x+x,genieIDCoordinates.y+y);
    			result.result = true;
    			result.message = "Right Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
       
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Right Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void rightClick(String genieID,Point p)throws StepTimedOutException, StepFailedException{
    	rightClick(genieID,p.x,p.y);
    } 
    
    /**
     * Right Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void rightClick(String genieID,int x, int y,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Right Click: Component", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
				Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.rightClick(genieIDCoordinates.x+x, genieIDCoordinates.y+y, key_Modifier);
    			result.result = true;
    			result.message = "Right Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Right Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void rightClick(String genieID,Point p,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	rightClick(genieID,p.x,p.y,key_Modifier);
    }

	/**
     * Double Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     *
     * @throws Exception
     * @since Genie 0.5
     */
    public void doubleClick(String genieID,int x, int y) throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
  
    	
	    	try{
	    		if(scriptLog != null){
				scriptLog.addTestStep("Double Click: Component", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
				Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.doubleClick(genieIDCoordinates.x+x,genieIDCoordinates.y+y);
    			result.result = true;
    			result.message = "Double Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
	    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Double Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void doubleClick(String genieID,Point p) throws StepTimedOutException, StepFailedException{
    	doubleClick(genieID,p.x,p.y);
    } 
    
    /**
     * Double Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param x
     *            x coordinate w.r.t starting position of the component
     * @param y
     *            y coordinate w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void doubleClick(String genieID,int x, int y,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	
    	try{
    		if(scriptLog != null){
				scriptLog.addTestStep("Double Click: Component", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
				Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    			scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    			scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			uiFunctions.doubleClick(genieIDCoordinates.x+x, genieIDCoordinates.y+y, key_Modifier);
    			result.result = true;
    			result.message = "Double Click Successful";
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Double Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @param genieID
     * 			  genieID of the component in the SWF 
     * @param p
     *            Point p w.r.t starting position of the component
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     *
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void doubleClick(String genieID,Point p,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	doubleClick(genieID,p.x,p.y,key_Modifier);
    }
    
    
    /**
     * Gets the current screen (Global) coordinates of a particular Genie-ID
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @param genieID
     *            genieID of the component
     *            
     * @return 
     * 			global (x,y) coordinates of the genieID w.r.t the Screen as java.awt.point
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public Point getCurrentScreenCoordinates(String genieID)throws StepTimedOutException, StepFailedException {
    	Point imageCoordinates = new Point(-1,-1);
    	Result result = new Result();
    	result.result = false;
    	
    	try{
    		if(scriptLog != null){
   				scriptLog.addTestStep("Get Screen Coordinates: Component", GenieLogEnums.GenieStepType.STEP_DEVICE_UI_TYPE, this.getClass().getSimpleName());
				
				Utils.printMessageOnConsole("GenieID of Component: " + genieID);
    			scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
    		}
    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
    		
    		//Verify of GenieID coordinates are valid
    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
    			result.result = true;
    			result.message = "GenieID Screen Coordinates X="+genieIDCoordinates.x + " Y="+genieIDCoordinates.y;
    			imageCoordinates = new Point(genieIDCoordinates.x,genieIDCoordinates.y);
    		}
    		else{
    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
    		}
    	}
    	catch(RuntimeException e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);

    	return imageCoordinates;
    }

	  /**
	   * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t a component
	   * <p>
	   * User can simulate native MouseOver event which moves mouse cursor over the component with this action.
	   * Only thing to be taken care of is that x,y should be small enough so that they remain within 
	   * component boundaries
	 * <p>
	 * This method is valid only for Desktop. If used on device, it will result in Step failure
	   * 
	 * @param genieID
     *            genieID of the component
	   * @param x
	   *            x coordinate w.r.t Component starting coordinates (horizontal screen component)
	   * @param y
	   *            y coordinate w.r.t Component starting coordinates (vertical screen component)
	   * 
	   * @throws Exception
	   * 
	   * @since Genie 0.7
	   */
	   public void mouseOver(String genieID, int x, int y) throws StepTimedOutException, StepFailedException{
		   Result result = new Result();
		   result.result = false;
 	   
	    	try{
				if(scriptLog != null){
					scriptLog.addTestStep("Mouse Over: Component",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
					Utils.printMessageOnConsole("GenieID of Component: " + genieID);
					scriptLog.addTestStepParameter("GenieID", GenieLogEnums.GenieParameterType.PARAM_ATTRIBUTE, genieID);
					scriptLog.addTestStepParameter("X Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
					scriptLog.addTestStepParameter("Y Delta", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
				}
	    		Point genieIDCoordinates = getGenieIDCoordinates(genieID);
	    		
	    		//Verify of GenieID coordinates are valid
	    		if(genieIDCoordinates.x != -1 && genieIDCoordinates.y != -1){
	    			uiFunctions.moveMouse(genieIDCoordinates.x+x, genieIDCoordinates.y+y);
	    			result.result = true;
	    			result.message = "Move Mouse Successful";
	    		}
	    		else{
	    			result.message = "Failed to identify GenieID "+genieID+" for application "+app.name;
	    		}
	    	}catch(Exception e){
	    		result.message = "Exception: " + e.getMessage();
	    	}
 	   
 	   UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }	
	   
		   
	//========================================================================================
	// Some Private methods to be used here
	//========================================================================================
    
    /**
     * Get coordinates of a particular Genie-ID w.r.t Screen
     */
    private Point getGenieIDCoordinates(String genieID) throws StepTimedOutException, StepFailedException{
    	//Adding one second delay before running any action so that components are initialized before any action is performed on them
		try{
			Thread.sleep(1000);
		}catch(Exception e){
			StaticFlags sf=StaticFlags.getInstance();
			sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
		}
		
		String oldGenieID = genieID;
		
		//Check if mapping of given genieId exists in genieIdMap table.
		String updatedGenieID = StaticFlags.getInstance().getUpdatedGenieId(genieID); 
		if(updatedGenieID != null) {
			genieID = updatedGenieID;
		}
		
    	try{
    		//Get local co-ordinates of genie-id corresponding to application 
    		SynchronizedSocket sc = SynchronizedSocket.getInstance();
    	
    		// Check if the Component Exists on Stage
    		Result rCompResult = waitForComponent(genieID,10);
    		if (!rCompResult.message.equals(Utils.SWF_NOT_PRESENT)){
	    		if (!rCompResult.result && !(rCompResult.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_RESPONSE")
	    				|| rCompResult.message.contains("SOCKET_CONNECTION_TIMEOUT_ON_REQUEST"))){
	   				scriptLog.addTestStepMessage("Component not directly found. Going for alternate approach of getting the Component", GenieLogEnums.GenieMessageType.MESSAGE_INFO);
	   				
	   				//If Result is False for Existence, then check with alternate method of genieID existence
	   				Result result = sc.doAction(app.name, "getTrimmedGenieID", "<String>"+genieID+"</String>");
	   				
	   				/*<Output>
 					  <Result>true</Result>
 					  <PropertyValue>new trimmed GenieID</PropertyValue>
 					  <Message/>
 					</Output>*/
 					Document doc = Utils.getXMLDocFromString(result.message);
 					
	   				//If by trimming the new GenieID is found then use this for getting local coordinates
	   				if (result.result){
	   					try{
	   						genieID = doc.getElementsByTagName("PropertyValue").item(0).getChildNodes().item(0).getNodeValue(); 
	   						scriptLog.addTestStepMessage("New GenieID with alternate approach is: " + genieID, GenieLogEnums.GenieMessageType.MESSAGE_INFO);
	   					}catch(Exception e){
	   						StaticFlags.getInstance().printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
	   					}
	   				}

	   				try{
   						String temp = doc.getElementsByTagName("Result").item(0).getChildNodes().item(0).getNodeValue(); 
   						rCompResult.result =  Boolean.parseBoolean(temp);
   					}catch(Exception e){}
   					
   					try{
   						String temp = doc.getElementsByTagName("Message").item(0).getChildNodes().item(0).getNodeValue(); 
   						rCompResult.message =  temp;
   					}catch(Exception e){
   						StaticFlags sf=StaticFlags.getInstance();
						sf.printErrorOnConsoleDebugMode("Exception occured:"+e.getMessage());
	   			}
	   			}
	    		
	    		if (!rCompResult.result && UIEventsValidationFunctions.checkTimeOutCondition(rCompResult.message)){
	    			throw new StepTimedOutException(rCompResult.message);
	    		}
	    		
	    		if (rCompResult.result){
	    			//Update genieId in hashtable if it is different from the passed argument
	    			if(!oldGenieID.equals(genieID))
	    			{
	    				StaticFlags.getInstance().setUpdatedGenieId(oldGenieID, genieID);
	    			}
		    		
		    	
		    		//Get local coordinates for the genieID
		    		Result result = sc.doAction(app.name, "getLocalCoordinates", "<String>"+genieID+"</String>");
		    		
		    		String coordinates = result.message;
		    		if(coordinates.contains("<x>") && coordinates.contains("<y>")){
		    			float floatX = Float.parseFloat(coordinates.substring(coordinates.indexOf("<x>")+3, coordinates.indexOf("</x>")));
		    			float floatY  = Float.parseFloat(coordinates.substring(coordinates.indexOf("<y>")+3, coordinates.indexOf("</y>")));
		    			
		    			int x = (int)floatX;
		    			int y = (int)floatY;
		    			
		    			//Change the color of Genie image to UIGenieImage
		    			UIEventsValidationFunctions.changetoUIGenieIcon(app);
		    			
			    		Point genieCoordinates=null;
			    		
			    		Thread.sleep(1000);
			    		
			    		    //Get start co-ordinates of the application running on desktop
		    			    genieCoordinates = uiFunctions.getUIGenieCoordinates();
		    			Utils.printMessageOnConsole("Current Local Coordinates for GenieID "+genieID+" inside SWF :- X="+x+",Y="+y);
		    			Utils.printMessageOnConsole("Current Top Left Coordinates of SWF on Screen :- X="+genieCoordinates.x+",Y="+genieCoordinates.y);
		    		
		    			//If x & y are valid coordinates, then add app coordinates to get the Screen coordinates.
		    			if(x != -1 && y != -1 && genieCoordinates.x != -1 && genieCoordinates.y != -1){
			    				UIEventsValidationFunctions.changefromUIGenieIcon(app);
		    				return new Point(x+genieCoordinates.x,y+genieCoordinates.y);
		    			}
		    			else{
		    				Utils.printErrorOnConsole(Utils.UI_ICON_NOT_VISIBLE_MESSAGE);
			    				UIEventsValidationFunctions.changefromUIGenieIcon(app);
		    				throw new StepFailedException(Utils.UI_ICON_NOT_VISIBLE_MESSAGE);
		    			}
		    		}
			    	
		    		else {
		    			Utils.printErrorOnConsole("genieID not found on the spcified application");
		    			UIEventsValidationFunctions.changefromUIGenieIcon(app);
		    			return new Point(-1,-1);
		    		}
	    		}
	    		else{
	    			Utils.printErrorOnConsole("Component with specified GenieID not found on Stage");
	    			scriptLog.addTestStepMessage("Component with specified GenieID not found on Stage", GenieLogEnums.GenieMessageType.MESSAGE_ERROR);
	    			return new Point(-1,-1);
	    		}
    		}
    		else{
    			throw new StepFailedException(Utils.SWF_NOT_PRESENT);
    		}
    	}catch(Exception e){
    		if (e.getMessage().contains(Utils.SWF_NOT_PRESENT)){
    			throw new StepFailedException(Utils.SWF_NOT_PRESENT);
    		}
    		else if (e.getMessage().contains(Utils.UI_ICON_NOT_VISIBLE_MESSAGE)) {
    			throw new StepFailedException(Utils.UI_ICON_NOT_VISIBLE_MESSAGE);
    		}
    		else if (e.getMessage().contains(Utils.NO_RESPONSE_FROM_DEVICE_CONTROLLER)){
    			throw new StepFailedException(Utils.NO_RESPONSE_FROM_DEVICE_CONTROLLER);
    		}
    		
    		if (UIEventsValidationFunctions.checkTimeOutCondition(e.getMessage())){
    			throw new StepTimedOutException(e.getMessage());
    		}
    		
    		Utils.printErrorOnConsole(e.getMessage());
    		scriptLog.addTestStepMessage(e.getMessage(), GenieLogEnums.GenieMessageType.MESSAGE_EXCEPTION);
    		UIEventsValidationFunctions.changefromUIGenieIcon(app);
    	}
    	
    	return new Point(-1,-1);
    }
	
	/**
	 * Waits for a particular Component to appear on Stage
	 * 
	 * @param timeInSeconds
	 * 		Time to wait in Seconds
	 * 
	 * @return
	 * 		Boolean value indicating the result of action
	 * 		It will still return false if timeout happens
	 */
	private Result waitForComponent(String genieID,int... timeInSeconds){
		long timeToWait;
		SynchronizedSocket sc = SynchronizedSocket.getInstance();
		
		if(timeInSeconds.length != 0)
			timeToWait = System.currentTimeMillis() + (timeInSeconds[0]*1000L);
		else
			timeToWait = System.currentTimeMillis() + (sc.getTimeout()*1000L); // If timeout is not specified by user, use the current set default timeout
		
		if (StaticFlags.getInstance().wasSwfDeadOnce(this.app.name))
		{
			//Means, swf becomes alive after disappearing
			StaticFlags sf = StaticFlags.getInstance();
			sf.conenctToSwf(this.app.name);
		}
		
		//Wait till genieId is not found or timeout doesn't happens. 
		Result result = sc.doAction(app.name, "exists", "<String>"+genieID+"</String>");
		
		//If swf not present, no need to wait for GenieID
		if (!result.message.equals(Utils.SWF_NOT_PRESENT))
		{
			while(result.result == false && System.currentTimeMillis() < timeToWait){
				result = sc.doAction(app.name, "exists", "<String>"+genieID+"</String>");
				//Make thread sleep for 200 ms.
				try{
					Thread.sleep(200);
				}catch(Exception e){break;}
			}
		}
		else
		{
			this.app.isConnected = false;
			StaticFlags sf = StaticFlags.getInstance();
			sf.pushClosedSwf(this.app.name);
		}
		return result;
	}
    
}
