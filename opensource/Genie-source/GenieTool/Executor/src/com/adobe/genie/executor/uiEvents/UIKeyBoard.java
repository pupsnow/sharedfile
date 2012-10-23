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


import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieUIRobot.UIFunctions;
import com.adobe.genie.iexecutor.uiEvents.IUIKeyboard;
import com.adobe.genie.executor.internalLog.ScriptLog;

import com.adobe.genie.executor.StaticFlags;
import com.adobe.genie.executor.UsageMetricsData;
import com.adobe.genie.executor.exceptions.*;
import com.adobe.genie.executor.enums.GenieLogEnums;

/**
 * Provides the methods necessary to perform <b>Keyboard based UI events </b> on the current component in Focus
 * <p>
 * These Set of methods provide Keyboard based functionality via system level UI events
 * These set of events work on current focused component or object on screen, so please ensure
 * that the type cursor is appropriately positioned on screen. Apart from typing it also includes
 * methods for key presses 
 * 
 * @since Genie 0.5
 */
public class UIKeyBoard implements IUIKeyboard{

	UIFunctions uiFunctions = null;
	ScriptLog scriptLog = null;
	private boolean isDebugMode = false;
	
	/**
     * Default Constructor, No Parameters Required
     *    
     */
	public UIKeyBoard() {
		StaticFlags sf = StaticFlags.getInstance();
		this.isDebugMode = sf.isdebugMode();
		uiFunctions = new UIFunctions(isDebugMode);
		scriptLog = ScriptLog.getInstance();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("UIFunctions");
	}
	
	//========================================================================================
	// Some public exposed methods for a UI keyboard event
	//========================================================================================

	 /**
	  * Releases the key referred to by the name passed in (example: VK_SHIFT), 
	  * if the key was not previously pressed (see pressKey), the result is
	  * undefined.
	  * 
	  * @param name
	  *            the name of the virtual key to press           
	  *            Note :- For Key_name refer static key identifiers in java.awt.event.KeyEvent class
	  *            eg. VK_SHIFT refers to "KeyEvent.VK_SHIFT"
	  *            eg. releaseKey("VK_SHIFT"), will release the SHIFT key, if it is already pressed.
	  * 
	  * @throws Exception
	  *             
      * @since Genie 0.5
	  */
	 public void releaseKey(String name)throws StepTimedOutException, StepFailedException{
	     Result result = new Result();
	     result.result = false;
		 if(scriptLog != null){
			 scriptLog.addTestStep("Release key", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
		 	 scriptLog.addTestStepParameter("Key Name", GenieLogEnums.GenieParameterType.PARAM_INPUT, name);
		 }
		 try{
			 uiFunctions.releaseKey(name);
			 result.result = true;
 			 result.message = "Release Key Successful";
		 }catch(Exception e){
			 result.message = "Exception: " + e.getMessage();
			 if (isDebugMode){
					e.printStackTrace();
			 }
	      }
		 UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	 }    
	 
	 /**
	  * Presses the key referred to by the name passed in (example: VK_SHIFT), also you
	  * must release it yourself through the releaseKey or releaseAllKeys
	  * methods, or it may stay pressed at least until you log off.
	  *
	  * @param name
	  *            the name of the virtual key to press
	  *          	Note :- For Key_name refer static key identifiers in java.awt.event.KeyEvent class
	  *          	eg. VK_SHIFT refers to "KeyEvent.VK_SHIFT"
	  *            	eg. pressKey("VK_SHIFT"), will press the SHIFT key
      * 
      * @throws Exception
      * 
      * @since Genie 0.5
	  */
	 public void pressKey(String name) throws StepTimedOutException, StepFailedException{
	     Result result = new Result();
	     result.result = false;
		 if(scriptLog != null){
				scriptLog.addTestStep("Press key" , GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
		 		scriptLog.addTestStepParameter("Key Name", GenieLogEnums.GenieParameterType.PARAM_INPUT, name);
		 }
		 try{
			uiFunctions.pressKey(name);
			result.result = true;
 			result.message = "Press Key Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	 }

	 /**
	  * Types (presses and releases) the key referred to by the name passed in
	  * (example: VK_SHIFT).
	  *
	  * @param name
	  *            the name of the virtual key to press
	  *            Note :- For Key_name refer static key identifiers in java.awt.event.KeyEvent class
	  *            eg. VK_SHIFT refers to "KeyEvent.VK_SHIFT"
	  *            eg. releaseKey("VK_SHIFT"), will release the SHIFT key, if it is already pressed.            
      * 
      * @throws Exception
      * 
      * @since Genie 0.5
	  */
	 public void typeKey(String name)throws StepTimedOutException, StepFailedException{
	     Result result = new Result();
	     result.result = false;
		 if(scriptLog != null){
			 scriptLog.addTestStep("Type key", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
		 	 scriptLog.addTestStepParameter("Key Name", GenieLogEnums.GenieParameterType.PARAM_INPUT, name);
		 }
		 try{
			 uiFunctions.typeKey(name);
			 result.result = true;
	 		 result.message = "Type Key Successful";
		 }catch(Exception e){
			 result.message = "Exception: " + e.getMessage();
			 if (isDebugMode){
					e.printStackTrace();
			}
		}
		 UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	 }
	 
	/**
	 * Releases all previously pressed keys.
     * 
     * @throws Exception
     * 
     * @since Genie 0.5
	 */
	public void releaseAllKeys() throws StepTimedOutException, StepFailedException{
	    Result result = new Result();
	    result.result = false;
		if(scriptLog != null)
			scriptLog.addTestStep("Release All Keys" , GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
   	
		try{
			uiFunctions.releaseAllKeys();
			result.result = true;
	 		result.message = "Release all Key Successful";
		}catch(Exception e){
			result.message = "Exception: " + e.getMessage();
			if (isDebugMode){
				e.printStackTrace();
			}
		}
		UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
	}
	
	/**
    * Types a string on the host Screen at the current mouse position.
    *
    * @param text
    *            the string to type
    * 
    * @throws Exception
    * 
    * @since Genie 0.5
    */
   public void typeText(String text)throws StepTimedOutException, StepFailedException{
	   Result result = new Result();
	   result.result = false;
	   if(scriptLog != null){
		   	scriptLog.addTestStep("Type Text", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	   		scriptLog.addTestStepParameter("Text Typed", GenieLogEnums.GenieParameterType.PARAM_INPUT, text);
	   }
	   try{
			uiFunctions.typeText(text);
			result.result = true;
	 		result.message = "Type Text Successful";
	   }catch(Exception e){
		   result.message = "Exception: " + e.getMessage();
		   if (isDebugMode){
				e.printStackTrace();
			}
	   }
	   UIEventsValidationFunctions.checkScriptTerminationDesktop(result);	
   }
   
   
   /**
    * Paste a string on the host Screen at the current mouse position.
    * <font color="#FF0000"> After executing pasteText, clipboard contents will be replaced by this string</font>
    *
    * @param text
    *            the string to paste
    * 
    * @throws Exception
    * 
    * @since Genie 1.2
    */
   public void pasteText(String text)throws StepTimedOutException, StepFailedException{
	   Result result = new Result();
	   result.result = false;
	   if(scriptLog != null){
		   	scriptLog.addTestStep("Paste Text", GenieLogEnums.GenieStepType.STEP_UI_TYPE, this.getClass().getSimpleName());
	   		scriptLog.addTestStepParameter("Text Pasted", GenieLogEnums.GenieParameterType.PARAM_INPUT, text);
	   }
	   try{
		   Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
		   StringSelection data = new StringSelection(text);
           clipboard.setContents(data, data);
           
           Transferable clipData = clipboard.getContents(clipboard);
           if (clipData != null) {
             try {
               if 
                 (clipData.isDataFlavorSupported
				    (DataFlavor.stringFlavor)) {
                     if (System.getProperty("os.name").toLowerCase().startsWith("win"))
                     {  	 
                    	uiFunctions.pressKey("VK_CONTROL");
                    	uiFunctions.pressKey("VK_V");
                    	uiFunctions.releaseKey("VK_V");
                    	uiFunctions.releaseKey("VK_CONTROL");
                     }
                     else
	                 {
                    	uiFunctions.pressKey("VK_META");
                    	uiFunctions.pressKey("VK_V");
                    	uiFunctions.releaseKey("VK_V");
                    	uiFunctions.releaseKey("VK_META");
	                 }
                     
                    result.result = true;
         	 		result.message = "Paste Text Successful";
               }
             } catch (UnsupportedFlavorException ufe) {
            	 result.message = "UnsupportedFlavor Exception: " + ufe.getMessage();
	      		   if (isDebugMode){
	      				ufe.printStackTrace();
	      			}
             } catch (IOException ioe) {
            	 result.message = "IO Exception: " + ioe.getMessage();
	      		   if (isDebugMode){
	      				ioe.printStackTrace();
	      			}
             }
           }
		}
	   catch(Exception e){
		   result.message = "Exception: " + e.getMessage();
		   if (isDebugMode){
				e.printStackTrace();
			}
	   }
	   
	   UIEventsValidationFunctions.checkScriptTerminationDesktop(result);
   }
}
