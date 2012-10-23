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

import java.util.Hashtable;

/**
 * This class is used to specify properties of an Object
 * <p>
 * Primary purpose will be to locate a specific component with the given
 * set of properties and get the GenieID of those components
 * 
 * @since Genie 0.9
 */
public class GenieLocatorInfo {
	
	/**
	 * Value of 'id' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public String id;
	
	/**
	 * Value of 'label' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public String label;
	
	/**
	 * Value of 'enabled' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public String enabled;
	
	/**
	 * Value of 'visible' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public String visible;
	
	/**
	 * Check for the visibility of self along with parent till stage
	 * i.e. if visible property of any of the component in the hierarchy going backward
	 * does not match the provided value will be ignored
	 * 
	 * @since Genie 1.6
	 */
	public String isHierarchyVisible;
	
	/**
	 * Value of 'index' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public int index = -1;
	
	/**
	 * Value of 'text' property of the component to be located
	 * 
	 * @since Genie 0.9
	 */
	public String text;
	
	/**
	 * Class name of the component to be located
	 * Class name should not be fully qualified class name. Only class name
	 * is required. Ex: To locate "mx.controls::Button" , fill "Button" in className 
	 * field 
	 * 
	 * @since Genie 0.9
	 */
	public String className;
	
	/**
	 * Class name of the component to be located
	 * Class name should be fully qualified class name is required.
	 *  Ex: To locate "mx.controls::Button" fill "mx.controls::Button" in qualifiedClassName
	 * field 
	 * 
	 * @since Genie 0.10
	 */
	public String qualifiedClassName;
	
	/**
	 * Any other property for which direct variables are not present
	 * can be added in this hash table. This table contains property name 
	 * value pairs.
	 * 
	 * @since Genie 0.9
	 */
	public Hashtable<String, String> propertyValueTable;
	
	/**
	 * Basic GenieLocatorInfo Constructor, this initializes the GenieLocatorInfo object
	 * 
	 * @since Genie 0.9
	 */	
	public GenieLocatorInfo()
	{
		propertyValueTable = new Hashtable<String, String>();
		
		UsageMetricsData usageInstance = UsageMetricsData.getInstance();
		usageInstance.addFeature("GenieLocatorInfo");
	}
}
