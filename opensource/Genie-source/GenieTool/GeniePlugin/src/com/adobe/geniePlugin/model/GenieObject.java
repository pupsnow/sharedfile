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

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.model.IWorkbenchAdapter;
import org.eclipse.ui.views.properties.IPropertySource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.adobe.genie.utils.Utils;

public class GenieObject extends Model implements IWorkbenchAdapter, IAdaptable{
	private List<GenieObject> children;
	private PropertyChangeSupport propertyChangeSupport = new PropertyChangeSupport(
			this);
	private static IModelVisitor adder = new Adder();
	private static IModelVisitor remover = new Remover();
	private Element xml;
	private String type;
	
	public GenieObject() {
		children = new ArrayList<GenieObject>();
	}
	
	public String convertObjectToXMLString()
	{
		Iterator<GenieObject> iterator = getChildren().iterator();
		String tag = "<Object";
		try{
			List<Property> listP = null;
			if(getProperties() != null)
				listP = getProperties().getProperties();
			if(listP != null)
			{
				Iterator<Property> ip = listP.iterator();
				
				while (ip.hasNext())
				{
					Property myProp = ip.next();
					String key = myProp.getKey();
					String val = myProp.getValue();
					val = val.replace("&", "&amp;");
					val = val.replace("<", "&lt;");
					val = val.replace(">", "&gt;");
					val = val.replace("\"", "&quot;");
					
					tag += " " + key + "=\"" + val + "\" ";
				}
			}
			tag += ">";
			while (iterator.hasNext())
			{
				GenieObject g = iterator.next();
				String childStr = g.convertObjectToXMLString();
				tag += childStr;
				
			}
			tag +="</Object>\n";											
		}catch(Exception e)
		{
			Utils.printErrorOnConsole(e.getMessage());
			e.printStackTrace();
		}
		return tag;
	}
	private static class Adder implements IModelVisitor {

		/*
		 * @see ModelVisitorI#visitMovingBox(MovingBox, Object)
		 */
		public void visitMovingBox(GenieObject obj, Object argument) {
			((GenieObject) argument).addObject(obj);
		}

	}
	
	
	
	private static class Remover implements IModelVisitor {
		/*
		 */
		public void visitMovingBox(GenieObject obj, Object argument) {
			((GenieObject) argument).removeChild(obj);
			obj.addListener(NullDeltaListener.getSoleInstance());
		}

	}
	
	public GenieObject(String name) {
		this();
		this.name = name;
	}
	
	public Element getXml()
	{
		return xml;
	}
	
	public void setXml(Element element)
	{
		xml = element;
	}
	
	public String getType()
	{
		return type;
	}
	
	public void setType(String type)
	{
		this.type = type;
	}
	
	
	public List<GenieObject> getChildren() {
		return children;
	}
	
	protected void addObject(GenieObject object) {
		children.add(object);
		object.parent = this;
		fireAdd(object);
	}
	
	public void remove(Model toRemove) {
		toRemove.accept(remover, this);
	}
	
	protected void removeChild(GenieObject obj) {
		children.remove(obj);
		obj.addListener(NullDeltaListener.getSoleInstance());
		fireRemove(obj);	
	}

	public void add(Model toAdd) {
		toAdd.accept(adder, this);
	}
	
	/** Answer the total number of items the
	 * receiver contains. */
	public int size() {
		return getChildren().size();
	}
	/*
	 * @see Model#accept(ModelVisitorI, Object)
	 */
	public void accept(IModelVisitor visitor, Object passAlongArgument) {
		visitor.visitMovingBox(this, passAlongArgument);
	}

	
	public Object[] getChildren(Object o) {
		return getChildren(o);
		
	}

	
	public ImageDescriptor getImageDescriptor(Object object) {
		
		return null;
	}

	
	public String getLabel(Object o) {
		
		return name;
	}

	
	public Object getParent(Object o) {
		return getParent(o);
	}

	public Object getAdapter(Class adapter) {
		if (adapter == IWorkbenchAdapter.class)
            return this;
        if (adapter == IPropertySource.class)
            return new GenieObjectProperties();
        return null;
	}
	
	public void addPropertyChangeListener(String propertyName,
			PropertyChangeListener listener) {
		propertyChangeSupport.addPropertyChangeListener(propertyName, listener);
	}

	public void removePropertyChangeListener(PropertyChangeListener listener) {
		propertyChangeSupport.removePropertyChangeListener(listener);
	}
	
	public void freeVars()
	{
		if (children != null)
			children.clear();
		xml = null;
	}
	
	protected void finalize() throws Throwable
	{
		super.finalize();
		if (children != null)
		{
			children.clear();
		}
		xml = null;
	}
}
