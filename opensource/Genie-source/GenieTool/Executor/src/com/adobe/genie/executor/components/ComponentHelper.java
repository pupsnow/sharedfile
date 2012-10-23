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

import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.events.BaseEvent;

import com.adobe.genie.executor.exceptions.*;

/**
 * This class is an helper class which contains common functions used to define
 * actions for various components. For example if a same event is available in 
 * multiple components, then it should be defined here and used across
 * 
 * Also there are no Public methods and this is not public class. the scope here is only
 * limited to this package
 * 
 * @since Genie 0.6
 */
class ComponentHelper{

	//========================================================================================
	// Some Helper methods which can used to define events across components
	//========================================================================================

	/**
	 * Presses a key on Control
	 * 
	 * @param  splChar
	 * 		The Key to Press (or type). Example "ENTER", "ESCAPE" etc
	 * 
	 * @return
	 * 		Boolean value indicating the result of Type action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.6
	 */
	static boolean type(GenieComponent gObj, String splChar, String... Preload) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(splChar);
		
		ExecuteActions ec = new ExecuteActions(gObj,
				BaseEvent.TYPE_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList);		

		 
		if(Preload.length > 0)
		{
			ArrayList<String> preloadArgsList = Utils.getArrayListFromStringParams(Preload[0]);
			ec.setPreloadArgs(preloadArgsList);
		}
		return ec.performAction();		
	}
	
	/**
	 * Scrolls an item in list object
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
	 * @since Genie 0.6
	 */
	static boolean scroll(GenieComponent gObj, int scrollPosition, int scrollDetail, int scrollDirection) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(
				String.valueOf(scrollPosition),
				String.valueOf(scrollDetail),
				String.valueOf(scrollDirection)
				);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SCROLL_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);		
		
		return ec.performAction();		
	}
	
	/**
	 * Scrolls an item in container object
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
	static boolean mouseScroll(GenieComponent gObj, int scrollPosition) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(scrollPosition));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.MOUSE_SCROLL_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);		
		
		return ec.performAction();
	}
	
	/**
	 * Select an item in list object by value of item
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
	static boolean select(GenieComponent gObj, String value) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(value);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SELECT_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);		
		
		return ec.performAction();
	}
	
	/**
	 * Select an item in list object by index of item
	 * 
	 * @param  index
	 * 		Index of item to be selected
	 * 
	 * @return
	 * 		Boolean value indicating the result of Select action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	static boolean select(GenieComponent gObj,int index)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(index));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SELECT_INDEX_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Select multiple item in list object by index of item
	 * 
	 * @param  index
	 * 		Index of item to be selected
	 * 
	 * @return
	 * 		Boolean value indicating the result of Select action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 1.1
	 */
	static boolean select(GenieComponent gObj,int index,int eventType, int keyModifier)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(index), 
				String.valueOf(eventType),
				String.valueOf(keyModifier));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SELECT_INDEX_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Select item in list object by value of item when keyBoard is used
	 * This is the one that comes up while recording GenieScript
	 * 
	 * @param  value
	 * 		value of the selected item
	 * 
	 * @param eventType
	 * 	eventType detail -
	 * 	<ul> 
	 * 		<li>1 - Mouse Click</li>
	 * 		<li>2 - Keybaord DOWN/UP</li>
	 * 	</ul>
	 *  
	 * @return 
	 * 		Boolean value indicating the result of Select action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.9
	 */
	static boolean select(GenieComponent gObj, String value, int eventType)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(
				value,
				String.valueOf(eventType)
				);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SELECT_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Select multiple items in list object by value of item
	 * This is the one that comes up while recording GenieScript
	 * 
	 * @param  value
	 * 		value of the selected item
	 * 
	 * @param eventType
	 * 	eventType detail -
	 * 	<ul> 
	 * 		<li>1 - Mouse Click</li>
	 * 		<li>2 - Keybaord UP</li>
	 * 	</ul>
	 * 
	 * @param keyModifier
	 * 	keyModifier Detail -
	 * 	<ul> 
	 * 		<li>1 - "ctrlKey"</li>
	 * 		<li>2 - "shiftKey" </li>
	 * 		<li>4 - "altKey" </li>
	 *  </ul>
	 *  
	 * @return 
	 * 		Boolean value indicating the result of Scroll action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.6
	 */
	static boolean select(GenieComponent gObj, String value, int eventType, int keyModifier)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(
				value,
				String.valueOf(eventType),
				String.valueOf(keyModifier)
				);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.SELECT_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Selects the given item in ButtonBar or Tab
	 * 
	 * @param  value
	 * 		Value as String which is to be selected in ButtonBar
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.5
	 */	
	static boolean change(GenieComponent gObj, String value) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(value);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.CHANGE_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Opens the control
	 * 
	 * @return
	 * 		Boolean value indicating the result of Open action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	static boolean open(GenieComponent gObj) throws StepFailedException, StepTimedOutException
	{
		class HelperExecuteActions extends ExecuteActions
		{
			public HelperExecuteActions(
					GenieComponent obj,
					String eventName, 
					GenieStepType stepType, 
					String className, 
					ArrayList<String> args) 
			{
				super(obj, eventName, stepType, className, args);
			}
			
			protected boolean afterParseResultCheck()
			{
				try {
					Thread.sleep(200);
				} catch (InterruptedException e) {}
				
				return true;
			}
		}
		
		HelperExecuteActions ec = new HelperExecuteActions(
				gObj,
				BaseEvent.OPEN_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				new ArrayList<String>());
		return ec.performAction();
	}
	
	/**
	 * Opens the node in the Tree Control
	 * 
	 * @return
	 * 		Boolean value indicating the result of Open action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	static boolean open(GenieComponent gObj, String headerToOpen) throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(headerToOpen);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.OPEN_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction(); 
	}
	
	/**
	 * Closes Tree Node
	 * 
	 * @param  headerToClose
	 * 		The string of the node on which to click on for close
	 * 
	 * @return
	 * 		Boolean value indicating the result of close action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.6
	 */
	static boolean close(GenieComponent gObj, String headerToClose)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(headerToClose);
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.CLOSE_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	/**
	 * Closes DateChooser of DateField
	 * 
	 * 
	 * @return
	 * 		Boolean value indicating the result of close action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.7
	 */
	static boolean close(GenieComponent gObj)throws StepFailedException, StepTimedOutException
	{
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.CLOSE_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				new ArrayList<String>()
				);
		return ec.performAction(); 
	}
	
	/**
	 * DoubleClick action to perform on cell/row in List
	 * 
	 * @param  itemData
	 * 		This corresponds to the strings associated with row/cell
	 * 
	 * @return
	 * 		Boolean value indicating the result of doubleClick action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.6
	 */
	static boolean doubleClick(GenieComponent gObj, String itemData)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(itemData));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.DOUBLE_CLICK_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * DragStart action to perform on cell/row in List
	 * 
	 * @param  itemData
	 * 		This corresponds to the strings associated with row/cell
	 * 
	 * @return
	 * 		Boolean value indicating the result of DragStart action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	static boolean dragStart(GenieComponent gObj, String itemData)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(itemData));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.DRAG_START_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * DragDrop action to perform on cell/row in List
	 * 
	 * @param  strEvent
	 * 		This corresponds to the event happened while moving the item renderer
	 * 
	 * @param  itemData
	 * 		This corresponds to the strings associated with row/cell
	 * 
	 * @return
	 * 		Boolean value indicating the result of DragDrop action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	static boolean dragDrop(GenieComponent gObj,String strEvent, String itemData)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(strEvent), String.valueOf(itemData));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.DRAG_DROP_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * DragDrop action to perform between 2 objects
	 * 
	 * @param  strEvent
	 * 		This corresponds to the event happened while moving the item renderer
	 * 
	 * @return
	 * 		Boolean value indicating the result of DragDrop action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.8
	 */
	static boolean dragDrop(GenieComponent gObj, String strEvent)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(strEvent));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.DRAG_DROP_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Moves a column from one position to another
	 * 
	 * @param  startIndex
	 * 		The index of header which needs to be moved
	 * 
	 * @param  endIndex
	 * 		The index position where the column should be moved to
	 * 
	 * @return
	 * 		Boolean value indicating the result of Shift action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.5
	 */	
	static boolean headerShift(GenieComponent gObj, int startIndex, int endIndex)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(startIndex), String.valueOf(endIndex));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.HEADER_SHIFT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Stretches a Column
	 * 
	 * @param  startIndex
	 * 		The zero-based index of the selected column in the object's columns array.
	 * 
	 * @param  length
	 * 		The length in pixels by which the column will be stretched
	 * 
	 * @return
	 * 		Boolean value indicating the result of Stretch action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.5
	 */	
	static boolean columnStretch(GenieComponent gObj, int startIndex, double length)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(startIndex), String.valueOf(length));
		ExecuteActions ec = new ExecuteActions(
				gObj,
				BaseEvent.COLUMN_STRETCH,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				gObj.getClass().getSimpleName(), 
				argsList
				);		
		
		return ec.performAction();
	}
}

