//========================================================================================
//Copyright � 2012, Adobe Systems Incorporated
//All rights reserved.
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//�	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//�	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
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

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.iexecutor.components.IGenieRadioButton;

/**
 * This class contains functions to be executed on RadioButton object
 * 
 * @since Genie 0.4
 */
public class GenieRadioButton extends GenieButton implements IGenieRadioButton{

	/**
	 * Basic RadioButton Component Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieRadioButton(String genieID, SWFApp SWF){
		super(genieID, SWF);
	}

	//========================================================================================
	// Some public exposed methods for a RadioButton object
	//========================================================================================

}