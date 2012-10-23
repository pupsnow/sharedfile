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

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.iexecutor.components.IGenieDividedBox;

import com.adobe.genie.executor.exceptions.*;

/**
 * This class contains functions to be executed on DividedBox object
 * 
 * @since Genie 0.6
 */

public class GenieDividedBox extends GenieComponent implements IGenieDividedBox {
	/**
	 * Basic DividedBox Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieDividedBox(String genieID, SWFApp SWF){
		super(genieID , SWF);
	}
	
	//========================================================================================
	// Some public exposed methods for a DividedBox object
	//========================================================================================
	
	/**
	 * Moves the divider of a Divided box from one position to another
	 * 
	 * @param  startPosition
	 *        The zero-based index of the divider being released.
	 *         
	 * @param  endPosition
	 *         The number of pixels that the divider has been dragged.
	 * 		
	 * @return
	 * 		Boolean value indicating the result of Type action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.6
	 */
	public boolean released(int startPosition,double endPosition)throws StepFailedException, StepTimedOutException
	{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(String.valueOf(startPosition), String.valueOf(endPosition));
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.DIVIDER_RELEASE,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				this.getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
}
