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
package com.adobe.geniePlugin.ui;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.swt.graphics.Image;

import com.adobe.geniePlugin.Activator;
import com.adobe.geniePlugin.model.GenieObject;


public class GenieObjectLabelProvider extends LabelProvider {	
	private Map<ImageDescriptor,Image> imageCache = new HashMap<ImageDescriptor,Image>(11);
	
	/*
	 * @see ILabelProvider#getImage(Object)
	 */
	
	public Image getImage(Object element){
		ImageDescriptor descriptor = null;
		Image image = null;
		if (element instanceof GenieObject) {
			GenieObject object = (GenieObject)element;
			String type = object.getType();
			String myType = "";
			
			if(type!=null && type.contains("::"))
			{
				myType = type.substring(type.lastIndexOf("::")+2);
			}
			
			if(myType.length()>0)
			{
				descriptor = Activator.getImageDescriptor("icons/components/"+ myType + ".png");
			}
			else
			{
				descriptor = Activator.getImageDescriptor("icons/components/Tag.png");
			}
			if(descriptor == null)
			{
				descriptor = Activator.getImageDescriptor("icons/components/Tag.png");
			}
			if(descriptor != null)
			{
				image = (Image)imageCache.get(descriptor);
				  if (image == null) {
				       image = descriptor.createImage();
				       imageCache.put(descriptor, image);
				   }
			}
		}
		return image;

	}
	/*
	 * @see ILabelProvider#getText(Object)
	 */
	public String getText(Object element) {
		if (element instanceof GenieObject) {
			if(((GenieObject)element).getName() == null) {
				return "Box";
			} else {
				return ((GenieObject)element).getName();
			}
		} else {
			throw unknownElement(element);
		}
	}

	public void dispose() {
		for (Iterator i = imageCache.values().iterator(); i.hasNext();) {
			((Image) i.next()).dispose();
		}
		imageCache.clear();
	}

	protected RuntimeException unknownElement(Object element) {
		return new RuntimeException("Unknown type of element in tree of type " + element.getClass().getName());
	}

}
