//========================================================================================
//  
//  ADOBE CONFIDENTIAL
//   
//  $File: //depot/Genie/PrivateBranch/Piyush/GenieTool/ScriptInterface/src/com/adobe/genie/iexecutor/components/IGenieDividedBox.java $
// 
//  Owner: Ankur Khullar
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

public interface IGenieDividedBox extends IGenieComponent {
	
	/**
	 * Moves the Divided box from start position to the released position
	 * 
	 * @since Genie 0.6
	 */
	public boolean released(int startPosition,double endPosition)throws Exception;

}
