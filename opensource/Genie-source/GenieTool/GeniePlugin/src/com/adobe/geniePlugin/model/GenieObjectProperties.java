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
package com.adobe.geniePlugin.model;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.ui.views.properties.IPropertyDescriptor;
import org.eclipse.ui.views.properties.IPropertySource;

public class GenieObjectProperties implements IPropertySource{

	private List<Property> properties;

	public GenieObjectProperties() {
		super();
		properties = new ArrayList<Property>();
	}
	
	protected void finalize() throws Throwable
	{
		super.finalize();
		if (properties != null)
			properties.clear();
	}

	public void addProperty(Property prop)
	{
		properties.add(prop);
	}
	
	public List<Property> getProperties() {
		return properties;
	}

	
	public Object getEditableValue() {
		
		return this;
	}

	public boolean isEmpty()
	{
		if (this.properties == null)
			return true;
		
		return this.properties.isEmpty();
	}
	
	public IPropertyDescriptor[] getPropertyDescriptors() {
		// TODO Auto-generated method stub
		return null;
	}

	
	public Object getPropertyValue(Object id) {
		// TODO Auto-generated method stub
		return null;
	}

	
	public boolean isPropertySet(Object id) {
		// TODO Auto-generated method stub
		return false;
	}

	
	public void resetPropertyValue(Object id) {
		// TODO Auto-generated method stub
		
	}

	
	public void setPropertyValue(Object id, Object value) {
		// TODO Auto-generated method stub
		
	}

}

