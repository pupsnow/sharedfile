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

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.iexecutor.components.IGenieContainer;

import com.adobe.genie.executor.exceptions.*;

/**
 * This class contains functions to be executed on Container object
 * 
 * @since Genie 0.5
 */
public class GenieContainer extends GenieComponent implements IGenieContainer{

	/**
	 * Basic Container Component Constructor, this initializes the components
	 * and set startup parameters
	 * 
	 * @param genieID
	 * 		Genie ID of Component
	 * 
	 * @param SWF
	 * 		SWF application to connect to
	 */
	public GenieContainer(String genieID, SWFApp SWF) {
		super(genieID, SWF);
	}

	//========================================================================================
	// Some public exposed methods for a Container object
	//========================================================================================

	/**
	 * Performs scroll operation on container
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
	 * @since Genie 0.5
	 */	
	public boolean scroll(int scrollPosition, int scrollDetail, int scrollDirection) throws StepFailedException, StepTimedOutException{
		return ComponentHelper.scroll(this, scrollPosition, scrollDetail, scrollDirection);
	}
	
	/**
	 * Scrolls items in container object
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
	public boolean mouseScroll(int scrollPosition) throws StepFailedException, StepTimedOutException{
		return ComponentHelper.mouseScroll(this, scrollPosition);
	}
}
