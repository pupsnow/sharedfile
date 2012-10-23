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
package com.adobe.genie.executor;

import com.adobe.genie.executor.enums.GenieLogEnums.GenieStepType;
import com.adobe.genie.executor.objects.GenieStepObject;
import com.adobe.genie.executor.internalLog.ScriptLog;

/**
 *	This class contains all static methods to add information
 *	in Script Logging. It assumes that methods are invoked after GenieScript run 
 *	method is already called.
 *	<p>
 *  All methods provided here are static and to be used directly with Class name.
 *  This class is not for any instantiation. Methods in this class are for adding 
 *  custom logging in Genie Script log. 
 *	@since Genie 1.0
 *
 */
public class GenieScriptLogger {

	//========================================================================================
	// Some exposed methods related to Logging of Steps in script
	//========================================================================================
	
	/**
	 * Adds new test step in script log file.
	 * 
	 * @param stepName
     * 			  Step name as it should appear in the log file
     * 
     * @return 
     * 			The reference of Step as GenieStepObject {@link com.adobe.genie.executor.objects}. The method
     * 			returns null if it fails to add step in the Script log
     * 
	 * @since Genie 1.0
	 **/
	public static GenieStepObject addTestStep(String stepName)
	 {
		UsageMetricsData usage = UsageMetricsData.getInstance();
		usage.addFeature("CustomLogging");
		//SCA
		//GenieStepObject objStep = new GenieStepObject();
		GenieStepObject objStep;
		
		objStep = ScriptLog.getInstance().addAndReturnTestStep(stepName, GenieStepType.STEP_CUSTOM_TYPE, "UserAddedStep");

		return objStep;
	 }
}
