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
import com.adobe.genie.iexecutor.uiEvents.IUIGlobal;
import com.adobe.genie.executor.internalLog.ScriptLog;

import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;

/**
 * Provides the methods necessary to perform <b>Mouse UI Events</b> based on screen coordinates
 * <p>
 * <font color="#FF0000">
 * These Set of methods perform mouse events on screen co-ordinates based on the passed x,y value.
 * Please note that they are resolution and screen dependent and should only be used when absolutely required.
 * This may result in false results if used just like that. The most optimum use is to get the value of co-ordinates at 
 * runtime from other set of methods and then use these methods to perform operation on returned co-ordinates
 * </font>
 * 
 * @since Genie 0.5
 */

public class UIGlobal implements IUIGlobal{

	UIFunctions uiFunctions = null;
	ScriptLog scriptLog = null;
	private boolean isDebugMode = false;
	
	/**
     * Default Constructor, No Parameters Required
     *     
     *
     */
	public UIGlobal() {
		StaticFlags sf = StaticFlags.getInstance();
		this.isDebugMode = sf.isdebugMode();
		uiFunctions = new UIFunctions(isDebugMode);
		scriptLog = ScriptLog.getInstance();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("UIFunctions");
	}
	
	//========================================================================================
	// Some public exposed methods for a UI events based on Global Screen Coordinates
	//========================================================================================

	/**
     * Clicks at (x, y) coordinate,w.r.t Screen starting coordinates.
     *
     * @param x
     *            x coordinate w.r.t Screen starting coordinates.
     * @param y
     *            y coordinate w.r.t Screen starting coordinates.
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void screenClick(int x, int y)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	if(scriptLog != null){
			scriptLog.addTestStep("Click", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    		scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    		scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    	}
    	try{
    		uiFunctions.click(x, y);
    		result.result = true;
    		result.message = "Screen Click Successful";
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Clicks at Point p,w.r.t Screen starting coordinates.
     *
     * @param p
     *            Point p coordinates  w.r.t Screen starting coordinates.
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void screenClick(Point p)throws StepTimedOutException, StepFailedException{
    	screenClick(p.x,p.y);
    }
    
    /**
     * Clicks at (x, y),w.r.t Screen starting coordinates with the specified modifier_key(SHIFT, ALT or CTRL) pressed.
     *
     * @param x
     *            x coordinate w.r.t Screen starting coordinates
     * @param y
     *            y coordinate w.r.t Screen starting coordinates
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)           
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void screenClick(int x, int y,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	Result result = new Result();
    	result.result = false;
    	if(scriptLog != null){
			scriptLog.addTestStep("Click", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
    		scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
    		scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
    		scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
    	}
	   	try{
    		uiFunctions.click(x, y,key_Modifier);
    		result.result = true;
    		result.message = "Screen Click Successful";
    	}catch(Exception e){
    		result.message = "Exception: " + e.getMessage();
    		if (isDebugMode){
				e.printStackTrace();
			}
    	}
    	UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
    }
    
    /**
     * Clicks at Point p,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..
     *
     * @param p
     *           Point p coordinates w.r.t Screen starting coordinates
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
     */
    public void screenClick(Point p,int key_Modifier)throws StepTimedOutException, StepFailedException{
    	screenClick(p.x,p.y,key_Modifier);
    }
    
    /**
	 * Right clicks at (x, y),coordinates w.r.t Screen starting coordinates
	 *
	 * @param x
	 *            x coordinate w.r.t Screen starting coordinates
	 * @param y
	 *            y coordinate w.r.t Screen starting coordinates
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(int x, int y)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Right Click", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}
		try{
			uiFunctions.rightClick(x, y);
			result.result = true;
			result.message = "Screen Right Click Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
    	}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}

	/**
	 * Right clicks at point p,w.r.t Screen starting coordinates
	 *
	 * @param p
	 *            Point p coordinates w.r.t Screen starting coordinates
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(Point p)throws StepTimedOutException, StepFailedException{
		screenRightClick(p.x,p.y);
	} 

	/**
	 * Right clicks at (x, y),w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..
	 *
	 * @param x
	 *            x coordinate w.r.t Screen starting coordinates
	 * @param y
	 *            y coordinate w.r.t Screen starting coordinates
	 * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(int x, int y, int key_Modifier )throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Right Click", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
		}
		try{
			uiFunctions.rightClick(x, y, key_Modifier);
			result.result = true;
			result.message = "Screen Right Click Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}

	/**
	 * Right clicks at the given point w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..
	 *
	 * @param p
	 *            Point p coordinates w.r.t Screen starting coordinates
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(Point p, int key_Modifier)throws StepTimedOutException, StepFailedException{
		screenRightClick(p.x,p.y,key_Modifier);
	} 
	
	/**
	 * Double clicks at (x, y) coordinate w.r.t Screen starting coordinates
	 *
	 * @param x
	 *            x coordinate w.r.t Screen starting coordinates
	 * @param y
	 *            y coordinate w.r.t Screen starting coordinates
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(int x, int y)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Double Click",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}
		try{
			uiFunctions.doubleClick(x, y);
			result.result = true;
			result.message = "Screen Double Click Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}

	/**
	 * Double clicks at the point p,w.r.t Screen starting coordinates
	 *
	 * @param p
	 *            Point p coordinates w.r.t Screen starting coordinates
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(Point p)throws StepTimedOutException, StepFailedException{
		screenDoubleClick(p.x,p.y);
	}	

	/**
	 * Double clicks at (x, y) coordinatem,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed...
	 *
	 * @param x
	 *            x coordinate w.r.t Screen starting coordinates
	 * @param y
	 *            y coordinate w.r.t Screen starting coordinates
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(int x, int y, int key_Modifier)throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Double Click", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
			scriptLog.addTestStepParameter("Modifier Key", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(key_Modifier));
		}
		try{
			uiFunctions.doubleClick(x, y, key_Modifier);
			result.result = true;
			result.message = "Screen Double Click Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}

	/**
	 * Double clicks at the given point,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed...
	 *
	 * @param p
	 *            Point p coordinates w.r.t Screen starting coordinates
     * @param key_Modifier
     *            Modifier key Pressed (Pass 0 for SHIFT, 1 for CTRL and 2 for ALT)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(Point p, int key_Modifier)throws StepTimedOutException, StepFailedException{
		screenDoubleClick(p.x,p.y,key_Modifier);
	}
	
	/**
	 * Moves the mouse to from current mouse position to (x, y) coordinate w.r.t Screen starting coordinates
	 * 
	 * @param x
	 *          x coordinate w.r.t Screen starting coordinates (horizontal screen component)
	 * @param y
	 *            y coordinate w.r.t Screen starting coordinates (vertical screen component)
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenmoveMouse(int x, int y) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Move Mouse",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	   		scriptLog.addTestStepParameter("X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
	   		scriptLog.addTestStepParameter("Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
	   }
	   try{
			uiFunctions.moveMouse(x, y);
			result.result = true;
			result.message = "Screen Move Mouse Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}
   
   /**
	 * Drags from the current mouse position to (x, y) coordinates  w.r.t Screen starting coordinates
	 * 
	 * @param x
	 *            the X coordinate  w.r.t Screen starting coordinates up-to where to drag
	 * @param y
	 *            the Y coordinate  w.r.t Screen starting coordinates up-to where to drag
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDrag(int x, int y) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Drag Mouse",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("End X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x));
			scriptLog.addTestStepParameter("End Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y));
		}
		try{
			uiFunctions.drag(x, y);
			result.result = true;
			result.message = "Screen Drag Mouse Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}
	
	/**
	 * Drags Mouse from (x1, y2) coordinates  w.r.t Screen starting coordinates to (x2,y2) coordinates w.r.t Screen starting coordinates
	 * 
	 * @param x1 x coordinate w.r.t Screen starting coordinates from where to start dragging
	 * @param y1 y coordinate w.r.t Screen starting coordinates from where to start dragging
	 * @param x2 x coordinate w.r.t Screen starting coordinates where  to stop dragging
	 * @param y2 y coordinate w.r.t Screen starting coordinates where to stop dragging
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void screenDrag(int x1, int y1, int x2, int y2) throws StepTimedOutException, StepFailedException{
		Result result = new Result();
		result.result = false;
		if(scriptLog != null){
			scriptLog.addTestStep("Drag Mouse",GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
			scriptLog.addTestStepParameter("Start X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x1));
			scriptLog.addTestStepParameter("Start Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y1));
			scriptLog.addTestStepParameter("End X Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(x2));
			scriptLog.addTestStepParameter("End Y Coordinate", GenieLogEnums.GenieParameterType.PARAM_INPUT, Integer.toString(y2));
		}
		try{
			uiFunctions.drag(x1, y1, x2, y2);
			result.result = true;
			result.message = "Screen Drag Mouse Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
	}
}
