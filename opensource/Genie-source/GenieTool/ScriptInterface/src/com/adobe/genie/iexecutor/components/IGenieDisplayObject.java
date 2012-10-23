//========================================================================================
//  
//  ADOBE CONFIDENTIAL
//   
//  $File: //depot/Genie/PrivateBranch/Ruchir/GenieTool/ScriptInterface/src/com/adobe/genie/iexecutor/components/IGenieAccordion.java $
// 
//  Owner: Ruchir
//  
//  $Author: psinghal $
//  
//  $DateTime: 2011/09/05 18:22:11 $
//  
//  $Revision: #5 $
//  
//  $Change: 5168 $
//  
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//  
//  NOTICE:  All information contained herein is, and remains
//  the property of Adobe Systems Incorporated and its suppliers,
//  if any.  The intellectual and technical concepts contained
//  herein are proprietary to Adobe Systems Incorporated and its
//  suppliers and are protected by trade secret or copyright law.
//  Dissemination of this information or reproduction of this material
//  is strictly forbidden unless prior written permission is obtained
//  from Adobe Systems Incorporated.
//  
//========================================================================================
package com.adobe.genie.iexecutor.components;

import com.adobe.genie.executor.GenieLocatorInfo;
import com.adobe.genie.executor.components.GenieDisplayObject;

public interface IGenieDisplayObject extends IGenieComponent{
	/**
	 * Clicks natively on the given localX and localY
	 * 
	 * @since Genie 1.2
	 */
	public boolean click(Number localX, Number localY, int eventPhase)throws Exception;
	
	/**
	 * DoubleClicks natively on the given localX and localY
	 * 
	 * @since Genie 1.2
	 */
	public boolean doubleClick(Number localX, Number localY)throws Exception;
	
	/**
	 * Presses the key for the specified time duration in milli seconds
	 * 
	 * @since Genie 1.4
	 */
	public boolean performKeyAction(String keyString, int nDuration)throws Exception;
	
	/**
	 * Presses the key combination for the specified time duration in milli seconds
	 * 
	 * @since Genie 1.4
	 */
	public boolean performKeyAction(String keyString, int keyModifier, int nDuration)throws Exception;
	
	/**
	 * Moves the mouse if bMoveMouse = true and then click at the specified stageX and stageY location
	 * 
	 * @since Genie 1.4
	 */
	public boolean click(Number localX, Number localY, Number stageX, Number stageY, Number stageWidth, Number stageHeight, int eventPhase, boolean bMoveMouse)throws Exception;
	
	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @since Genie 1.4
	 */
	public String getValueOfDisplayObject(String name) throws Exception;
	
	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @since Genie 1.4
	 */
	public String getValueOfDisplayObject(String name,boolean bLogging) throws Exception;
	
	/**
	 * Gets the child at a specified index,logging is always on.
	 * 
	 * @since Genie 1.4			
	 */
	public GenieDisplayObject getChildAt(int index) throws Exception;
	
	/**
	 * This method returns children of GenieDisplayObject as array of GenieDisplayObject which match properties specified in GenieLocatorInfo,logging is always on.
	 * 
	 * @since Genie 1.4
	 */
	public GenieDisplayObject[] getChildren(GenieLocatorInfo info, boolean bRecursive) throws Exception;
	
	/**
	 * This method returns children of GenieDisplayObject as array of GenieDisplayObject which match properties specified in GenieLocatorInfo with optional logging
	 * 
	 * @since Genie 1.4
	 */
	public GenieDisplayObject[] getChildren(GenieLocatorInfo info, boolean bRecursive,boolean bLogging) throws Exception;

	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @since Genie 1.5
	 */
	public String getValueOf(String name) throws Exception;
	
	/**
	 * Gets value of given property for GenieDisplayObject control.
	 * 
	 * @since Genie 1.5
	 */
	public String getValueOf(String name,boolean bLogging) throws Exception;
	
	/**
	 * This method returns parent of a GenieComponent
	 * 
	 * @since Genie 1.6
	 */
	public GenieDisplayObject getParent() throws Exception;
}
