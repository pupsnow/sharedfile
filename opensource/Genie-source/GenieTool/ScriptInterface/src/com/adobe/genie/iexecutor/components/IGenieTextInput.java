//========================================================================================
//  
//  ADOBE CONFIDENTIAL
//   
//  $File: //depot/Genie/PrivateBranch/Piyush/GenieTool/ScriptInterface/src/com/adobe/genie/iexecutor/components/IGenieTextInput.java $
// 
//  Owner: Suman Mehta
//  
//  $Author: psinghal $
//  
//  $DateTime: 2012/03/30 14:22:17 $
//  
//  $Revision: #1 $
//  
//  $Change: 5952 $
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

public interface IGenieTextInput extends IGenieComponent {
	/**
	 * Select text of input box from startIndex to endIndex
	 * 
	 * @since Genie 0.4
	 */	
	public boolean selectText(int startIndex, int endIndex)throws Exception;
	
	/**
	 * Types the given text on TextInput Control
	 * 
	 * @since Genie 0.4
	 */
	public boolean input(String input, String... Preload)throws Exception;
	
	/**
	 * Presses a key on TextInput Control
	 * 
	 * @since Genie 0.4
	 */
	public boolean type(String splChar, String... Preload)throws Exception;
	
	/**
	 * Scrolls on TextArea Control
	 * 
	 * @since Genie 0.7
	 */
	public boolean scroll(int scrollPosition, int scrollDetail, int scrollDirection) throws Exception;
	
	/**
	 * Performs mouse scroll on TextArea Control
	 * 
	 * @since Genie 0.7
	 */
	public boolean mouseScroll(int scrollPosition) throws Exception;
	
	/**
	 * Performs mouse scroll on TextArea Control
	 * 
	 * @since Genie 0.8
	 */
	public boolean doubleClick() throws Exception;
	
	/**
	 * Checks whether the component is currently in focus or not.  This function is available for mx and spark component only
	 * 
	 * @since Genie 1.1
	 */
	public boolean checkFocus() throws Exception;
}
