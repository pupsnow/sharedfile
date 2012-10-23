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
package com.adobe.genie.iexecutor.components;

import java.awt.Point;
import java.util.Hashtable;

import com.adobe.genie.executor.GenieLocatorInfo;
import com.adobe.genie.executor.components.GenieComponent;

public interface IGenieComponent {
	/**
	 * Performs a click event on GenieComponent control.
	 * 
	 * @since Genie 0.4
	 */
	public boolean click()throws Exception;

	/**
	 * Gets value of given property for GenieComponent control.
	 * 
	 * @since Genie 0.4
	 */
	public String getValueOf(String name) throws Exception;
	
	/**
	 * Gets value of given property for GenieComponent control.
	 * 
	 * @since Genie 1.0
	 */
	public String getValueOf(String name,boolean bLogging) throws Exception;
	
	/**
	 * Returns current GenieID
	 * 
	 * @since Genie 0.4
	 */
	public String getGenieID();
	
	/**
	 * Returns current Application Name
	 *  
	 * @since Genie 0.8
	 */
	
	public String getAppName();
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the default time specified times out
	 *
	 * @since Genie 0.5
	 */
	public boolean waitFor() throws Exception;
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the times out happens
	 *
	 * @since Genie 1.0
	 */
	public boolean waitFor(boolean bLogging) throws Exception;
	
	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the user specified time (in seconds) times out
	 * 
	 * @since Genie 0.5
	 */
	public boolean waitFor(int timeInSeconds)throws Exception;
	

	/**
	 * This method will make the script to wait for specified genieId  to appear on stage 
	 * or till the times out happens
	 *
	 * @since Genie 1.0
	 */
	public boolean waitFor(int timeInSeconds, boolean bLogging) throws Exception;
	
	/**
	 * Gets value of the property "visible" for GenieComponent control
	 * 
	 * @since Genie 0.9
	 */
	public boolean isVisible() throws Exception;
	
	/**
	 * Gets value of the property "enabled" for GenieComponent control.
	 * 
	 * @since Genie 0.9
	 */
	public boolean isEnabled() throws Exception;
	
	/**
	 * Gets the number of automatable children of a GenieComponent control.
	 * 
	 * @since Genie 0.9
	 */
	public int getNumAutomatableChildren() throws Exception;

	/**
	 * This method will make the script to wait till the given property attains the specified value or timeout happens
	 * 	
	 * @since Genie 0.8
	 */
	public boolean waitForPropertyValue(String property, String value, int... timeInSeconds) throws Exception;
	
	/**
	 * This method returns children of GenieComponent as array of GenieComponents which match properties specified in GenieLocatorInfo
	 * 
	 * @since Genie 0.9
	 */
	public GenieComponent[] getChildren(GenieLocatorInfo info, boolean bRecursive) throws Exception;
	
	/**
	 * This method returns children of GenieComponent as array of GenieComponents which match properties specified in GenieLocatorInfo
	 * 
	 * @since Genie 1.0
	 */
	public GenieComponent[] getChildren(GenieLocatorInfo info, boolean bRecursive,boolean bLogging) throws Exception;
	
	/**
	 * This method returns parent of a GenieComponent
	 * 
	 * @since Genie 0.9
	 */
	public GenieComponent getParent() throws Exception;
	/**
	 * This method returns the local co-ordinates of a GenieComponent
	 * 
	 * @since Genie 0.11
	 */
	public Point getLocalCoordinates() throws Exception;
	
	/**
	 * This method returns the local co-ordinates of a GenieComponent
	 * 
	 * @since Genie 1.0
	 */
	public Point getLocalCoordinates(boolean bLogging) throws Exception;
	
	/**
	 * This method returns the local co-ordinates of a GenieComponent w.r.t to the passed GenieID
	 * 
	 * @since Genie 1.6
	 */
	public Point getRelativeCoordinates(String strParentGenieId) throws Exception;
	
	/**
	 * This method returns the local co-ordinates of a GenieComponent w.r.t to the passed GenieID
	 * 
	 * @since Genie 1.6
	 */
	public Point getRelativeCoordinates(String strParentGenieId, boolean bLogging) throws Exception;
//  Removing the api as there is a typo in its name,bug#3078754
//	/**
//	 * It attaches event listener for the given event name 
//	 * 
//	 * @since Genie 0.11
//	 */
//	@Deprecated
//	public String  attachEventLisenter(String eventName) throws Exception;
	
	/**
	 * It attaches event listener for the given event name 
	 * 
	 * @since Genie 1.0
	 */
	public String attachEventListener(String eventName) throws Exception;
	
	/**
	 * It attaches the event listener on the given property of object for the given event name.  
	 * 
	 * @since Genie 1.6
	 */
	public String attachEventListener(String eventName,String propertyName) throws Exception;
	/**
	 * Waits for the event to happen till timeout happens. 
	 * 
	 * @since Genie 0.11
	 */
	public Hashtable<String, String>  waitForEvent(String eventGUID,int... timeInSeconds) throws Exception;
	
	/**
	 * Checks if given component is available on stage and returns boolean 
	 * indicating the same
	 * 
	 *  @since Genie 1.0	
	 */
	public boolean isPresent();
	
	/**
	 * Gets the child at a specified index,logging is always on.
	 * 
	 * @since Genie 1.0			
	 */
	public GenieComponent  getChildAt(int index) throws Exception;
	
	/**
	 * Capture Image of a given GenieComponent control and save it in temporary location with logging
	 * 
	 * @since Genie 1.4			
	 */
	public String captureComponentImage() throws Exception;
	
	/**
	 * Capture Image of a given GenieComponent control and save it in temporary location with optional logging.
	 * 
	 * @since Genie 1.4			
	 */
	public String captureComponentImage(boolean bLogging) throws Exception;
	
	/**
	 * Capture Image of a given GenieComponent control and save it imagePath location with logging
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean captureComponentImage(String imagePath) throws Exception;
	
	/**
	 * Capture Image of a given GenieComponent control and save it imagePath location with optional logging.
	 * 
	 * @since Genie 1.4			
	 */
	public Boolean captureComponentImage(String imagePath,boolean bLogging) throws Exception;
	
	/**
	 * Gets value of given property for GenieComponent control. It returns serialized XML if property value is an object
	 * 
	 * @since Genie 1.4
	 */
	public String getValueOfObject(String name,boolean bLogging) throws Exception;
	
	/**
	 * Compare Image of a given GenieComponent control with targetImage file with looging
	 * 
	 * @since Genie 1.4
	 */
	public Boolean compareComponentImage(String targetImagePath) throws Exception;
	
	/**
	 * Compare Image of a given GenieComponent control with targetImage file with optional logging
	 * 
	 * @since Genie 1.4
	 */
	public Boolean compareComponentImage(String targetImagePath,boolean bLogging) throws Exception;
	
	/**
	 * Saves XML of a given GenieComponent control at xmlFilePath location with logging and return xml save status
	 * 
	 * @since Genie 1.5
	 */
	public Boolean saveComponentXML(String xmlFilePath) throws Exception;
	
	/**
	 * Saves XML of a given GenieComponent control at xmlFilePath location with optional logging and return xml save status
	 * 
	 * @since Genie 1.5
	 */
	public Boolean saveComponentXML(String xmlFilePath,boolean bLogging) throws Exception;
	
	/**
	 * Saves XML of a given GenieComponent control at temporary location with logging and return xml path
	 * 
	 * @since Genie 1.5
	 */
	public String saveComponentXML() throws Exception;
	
	/**
	 * Saves XML of a given GenieComponent control at temporary location with optional logging and return xml path
	 * 
	 * @since Genie 1.5
	 */
	public String saveComponentXML(boolean bLogging) throws Exception;
	
}
