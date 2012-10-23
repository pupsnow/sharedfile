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
import com.adobe.genie.iexecutor.components.IGenieAccordion;
import com.adobe.genie.utils.Utils;

import com.adobe.genie.executor.enums.GenieLogEnums;
import com.adobe.genie.executor.events.BaseEvent;
import com.adobe.genie.executor.exceptions.*;

/**
 * This class contains functions to be executed on Accordion object
 * 
 * @since Genie 0.6
 */

public class GenieAccordion extends GenieComponent implements IGenieAccordion  {
	/**
	 * Basic Accordion Component Constructor, this initializes the components
	 * and sets startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of the Component
	 * 
	 * @param SWF
	 * 		SWF application object to which Genie component belongs.
	 */
	public GenieAccordion(String genieID, SWFApp SWF){
		super(genieID , SWF);
	}
	
	//========================================================================================
	// Some public exposed methods for a Accordion object
	//========================================================================================
	
	/**
	 * Selects the Selected pane of the Accordion
	 * 
	 * @param  value
	 * 		String value of the tab header to be switched to
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.4
	 */
	public boolean change(String value)throws StepFailedException, StepTimedOutException{
		return ComponentHelper.change(this, value);
	}
	
	/**
	 * Selects the Selected index of the Accordion. 
	 * 
	 * @param  index
	 * 		index of the tab header to be switched to
	 * 
	 * @return
	 * 		Boolean value indicating the result of Change action
	 * 
	 * @throws Exception
	 * 
	 * @since Genie 0.11
	 */
	public boolean changeIndex(int index)throws StepFailedException, StepTimedOutException{
		ArrayList<String> argsList = Utils.getArrayListFromStringParams(index+"");
		ExecuteActions ec = new ExecuteActions(
				this,
				BaseEvent.CHANGE_INDEX_EVENT,
				GenieLogEnums.GenieStepType.STEP_NATIVE_TYPE,
				getClass().getSimpleName(), 
				argsList
				);
		
		return ec.performAction();
	}
	
	/**
	 * Performs keyboard operations on the Accordion
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
	public boolean type(String splChar) throws StepFailedException, StepTimedOutException{
		return ComponentHelper.type(this, splChar);
	}
}
