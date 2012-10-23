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
package com.genie.data;

import java.awt.MouseInfo;
import java.util.Iterator;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.action.ActionContributionItem;
import org.eclipse.jface.action.IContributionItem;
import org.eclipse.jface.viewers.CellEditor;
import org.eclipse.jface.viewers.EditingSupport;
import org.eclipse.jface.viewers.ISelectionChangedListener;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.SelectionChangedEvent;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TableViewerColumn;
import org.eclipse.jface.viewers.TextCellEditor;
import org.eclipse.jface.viewers.TreePath;
import org.eclipse.jface.viewers.TreeViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CTabFolder;
import org.eclipse.swt.custom.CTabFolder2Adapter;
import org.eclipse.swt.custom.CTabFolderEvent;
import org.eclipse.swt.custom.CTabItem;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.custom.TableEditor;
import org.eclipse.swt.dnd.Clipboard;
import org.eclipse.swt.dnd.TextTransfer;
import org.eclipse.swt.dnd.Transfer;
import org.eclipse.swt.events.ControlEvent;
import org.eclipse.swt.events.ControlListener;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.MouseTrackListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.ToolBar;
import org.eclipse.swt.widgets.Tree;
import org.eclipse.swt.widgets.TreeItem;
import org.eclipse.swt.widgets.Widget;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.adobe.genie.genieCom.Result;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.log.LogData;
import com.adobe.geniePlugin.Activator;
import com.adobe.geniePlugin.comunication.ComponentImage;
import com.adobe.geniePlugin.comunication.StaticFlags;
import com.adobe.geniePlugin.model.GenieObject;
import com.adobe.geniePlugin.model.GenieObjectProperties;
import com.adobe.geniePlugin.model.Model;
import com.adobe.geniePlugin.model.Property;
import com.adobe.geniePlugin.ui.GenieComponentXML;
import com.adobe.geniePlugin.ui.GenieObjectContentProvider;
import com.adobe.geniePlugin.ui.GenieObjectLabelProvider;
import com.adobe.geniePlugin.ui.PropertyContentProvider;
import com.adobe.geniePlugin.ui.PropertyLabelProvider;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.ui.ShowXml;
import com.adobe.geniePlugin.views.GenieView;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.XmlDoc;

/**
 * Represents a tab in GenieView
 * It contains method to create/remove/update tabs to/from view
 * <p>
 *  Owner: Suman Mehta
 *  $Author: suman $
 * 
 */

public class TreeTab {

	public TreeViewer treeViewer;
	private TableViewer tableViewer;
	
	GenieObjectLabelProvider labelProvider;
	CTabItem tabbedItem; 
	CTabFolder tabFolder;
	SWFAppUI swfApp;
	
	private boolean arrowKeyReleased = true;
	
	public boolean isTabForTimeout = false;
	
	synchronized public void createTab(final CTabFolder parent, final SWFAppUI swf)
	{
		String debugStr = "TreeTab::createTab";
		LogData.getInstance().trace(LogData.INFO, debugStr + " Creating tab for swf: " + swf.name);
		
		tabFolder = parent;
		
		this.swfApp = swf;
		
		if (swf.isCancelled)
		{
			swf.disconnect();
			return;
		}
		
		Thread t = new Thread(){
			public void run(){
				Job j = new Job("Connecting Swf - " + swf.name) {
					
					@Override
					protected IStatus run(final IProgressMonitor monitor) 
					{
						monitor.beginTask("Requesting swf to connect", 100);
						monitor.worked(90);
						
						final GenieObject input = getInitalInput(swf.genieData.getXml());
						
						if (swf.isCancelled)
						{
							swf.disconnect();
							return Status.CANCEL_STATUS;
						}
						
						if (monitor.isCanceled())
						{
							swf.disconnect();
							return Status.CANCEL_STATUS;
						}
						Display.getDefault().syncExec(new Runnable() {
							public void run() {
								monitor.worked(95);
								swf.uiRep = createTabPostProcessing(parent, swf, input);
							}									
						});
						if (monitor.isCanceled())
						{
							swf.disconnect();
							return Status.CANCEL_STATUS;
						}
						monitor.worked(98);
						monitor.done();
						return Status.OK_STATUS;
					}
				};
				j.schedule();
			}
		};
		t.start();
	}
	public String getTabName()
	{
		return this.swfApp.name;
	}
	
	public void createExpiryTab(CTabFolder parent)
	{
		String debugStr = "TreeTab::createTab";
		LogData.getInstance().trace(LogData.INFO, debugStr + " Creating Expiry Tab");
		
		tabFolder = parent;
		
		tabbedItem = new CTabItem (parent, SWT.BORDER);
		tabbedItem.setText ("Build Expired!");
		
		GridLayout layout = new GridLayout(1, false);
		final Composite tabItemParent = new Composite(parent, SWT.NULL);
		
		tabItemParent.setLayout(layout);
		tabbedItem.setControl(tabItemParent);
		
		GridData treeData = new GridData();
		treeData.grabExcessHorizontalSpace = true;
		treeData.grabExcessVerticalSpace = true;
		treeData.horizontalAlignment = GridData.FILL;
		treeData.verticalAlignment = GridData.FILL;
		
		Label eLabel = new Label(tabItemParent, SWT.VERTICAL);
		eLabel.setText("Your Pre Release version of Genie(Code Name) has Expired! \nPlease Contact Project Genie Team at Adobe Systems Inc.!");
		Color c = new Color(Display.getCurrent(), 255, 0, 0);
		eLabel.setForeground(c);
		FontData fd = new FontData();
		fd.setStyle(SWT.BOLD);
		fd.setHeight(10);
		Font ft = new Font(Display.getCurrent(), fd);
		eLabel.setFont(ft);
		
		parent.setSelection(tabbedItem);
		
		
	}
	synchronized public TreeTab createTabPostProcessing(CTabFolder parent,SWFAppUI swf, GenieObject input)
	{
		String debugStr = "TreeTab::createTabPostProcessing";
	
		GenieView.getInstanceAndShowView().removeOrphanTabsAndEnableActions();
		
		tabbedItem = new CTabItem (parent, SWT.BORDER|SWT.CLOSE);
		tabbedItem.setText (swf.name);
		
		GridLayout layout = new GridLayout(1, false);
		final Composite tabItemParent = new Composite(parent, SWT.NULL);
		
		tabItemParent.setLayout(layout);
		tabbedItem.setControl(tabItemParent);
		
		GridData treeData = new GridData();
		treeData.grabExcessHorizontalSpace = true;
		treeData.grabExcessVerticalSpace = true;
		treeData.horizontalAlignment = GridData.FILL;
		treeData.verticalAlignment = GridData.FILL;
		
		SashForm sashForm = new SashForm(tabItemParent, SWT.VERTICAL);
		sashForm.setLayout(layout);
		sashForm.setLayoutData(treeData);
		
		treeViewer = new TreeViewer(sashForm, SWT.SINGLE);
		treeViewer.setContentProvider(new GenieObjectContentProvider());
		
		labelProvider = new GenieObjectLabelProvider();
		treeViewer.setLabelProvider(labelProvider);
		
		treeViewer.setUseHashlookup(true);
					
		treeViewer.getControl().setLayoutData(treeData);
		
		treeViewer.getTree().addMouseTrackListener(new MouseTrackListener() {
			
			public void mouseHover(MouseEvent event) {
				
				if (GenieView.getInstance().getComponentImageAction.isChecked())
				{
					org.eclipse.swt.graphics.Point pt = new org.eclipse.swt.graphics.Point(event.x, event.y);
					Widget widget = event.widget;
					Tree tree = null;
							          
					if (widget instanceof ToolBar) {
						ToolBar w = (ToolBar) widget;
						widget = w.getItem(pt);
					}
					if (widget instanceof Tree) 
					{
						tree = (Tree) widget;
						widget = tree.getItem(pt);
					}
					if (widget == null) {
						return;
					}
					  
					TreeItem tItem = tree.getItem(pt);
					Object obj = tItem.getData();
					GenieObject gObj = null;
					if(obj instanceof GenieObject)
					{
						gObj = (GenieObject)obj;
					}
					if (obj != null)
					{
						String genieId = gObj.getGenieId();
						CTabItem currentSelection = tabFolder.getSelection();
						String swfName = currentSelection.getText();
					    
						ComponentImage c = new ComponentImage(swfName, genieId, MouseInfo.getPointerInfo().getLocation());
						c.start();
					}
				}
			}
			
			public void mouseExit(MouseEvent e) {}
			public void mouseEnter(MouseEvent e) {}
		});
		
		swf.genieData = input;
		treeViewer.setInput(input);
		
		treeViewer.expandToLevel(2);
		
		tableViewer = new TableViewer(sashForm, SWT.MULTI | SWT.H_SCROLL
				| SWT.V_SCROLL | SWT.FULL_SELECTION | SWT.BORDER);
		
		createColumns(parent, tableViewer);
				
		tableViewer.setContentProvider(new PropertyContentProvider());
				
		tableViewer.setLabelProvider(new PropertyLabelProvider());
		
		hookListeners();
		parent.setSelection(tabbedItem);
		
		parent.addCTabFolder2Listener(new CTabFolder2Adapter() {
			public void close(CTabFolderEvent event) {
				if (!event.item.isDisposed())
				{
					String tabName = ((CTabItem)event.item).getText();
					SWFList<SWFAppUI> list = SWFList.getInstance();
					SWFAppUI app = list.getSWF(tabName);
					if(app!=null)
					{
						app.disconnect();
					}
					else
					{
						//Remove stale tab
						removeTab();
					}
				}
			}}
		);
		
		hookContextMenu();
		
		//Fixed Bug: gsingal. On maximizing view, was not possible to view table
		//Reason: On resizing, the first component grab all the vertical space
		tabItemParent.addControlListener(new ControlListener() {
			
			public void controlResized(ControlEvent e) {
				Rectangle rect = tabItemParent.getClientArea();
				
				GridData treeData = new GridData();
				treeData.grabExcessHorizontalSpace = true;
				treeData.horizontalAlignment = GridData.FILL;
				treeData.heightHint = rect.height / 2;				
				
				treeViewer.getControl().setLayoutData(treeData);
			}
			
			public void controlMoved(ControlEvent e) {
			}
		});
	
		acknowledgePreloadConnection(swf.name);
		
		//Genie Watch Update
		
		LogData.getInstance().trace(LogData.INFO, debugStr + " Succesfully Created tab for swf: " + swf.name);
		
		return this;
	}
	
	public void refreshTree(SWFAppUI swf)
	{
		GenieObject input = getInitalInput(swf.genieData.getXml());
		swf.genieData = input;
		treeViewer.setInput(input);
		treeViewer.expandToLevel(2);
		
		treeViewer.refresh();
	}
	
	private void acknowledgePreloadConnection(String appName)
	{
		SocketClient sc = SocketClient.getInstance();
		sc.acknowledgePreload(appName);
	}
	
	public TreeTab createErrorTab(CTabFolder parent, SWFAppUI swf)
	{
		String debugStr = "TreeTab::createErrorTab";
		LogData.getInstance().trace(LogData.INFO, debugStr + " Creating a timeout tab for swf: " + swf.name);
		
		isTabForTimeout = true;
		tabFolder = parent;
		
		GenieView.getInstanceAndShowView().removeOrphanTabsAfterResettingActions();
		
		this.swfApp = swf;
		tabbedItem = new CTabItem (parent, SWT.BORDER|SWT.CLOSE);
		tabbedItem.setText (swf.name);
		
		GridLayout layout = new GridLayout(1, false);
		Composite tabItemParent = new Composite(parent, SWT.NULL);
		
		tabItemParent.setLayout(layout);
		tabbedItem.setControl(tabItemParent);
		
		GridData treeData = new GridData();
		treeData.grabExcessHorizontalSpace = true;
		treeData.grabExcessVerticalSpace = true;
		treeData.horizontalAlignment = GridData.FILL;
		treeData.verticalAlignment = GridData.FILL;
		
		SashForm sashForm = new SashForm(tabItemParent, SWT.VERTICAL);
		sashForm.setLayout(layout);
		sashForm.setLayoutData(treeData);
		
		FontData fd = new FontData();
		fd.setHeight(12);
		fd.setStyle(SWT.BOLD);
		Font ft = new Font(Display.getCurrent(), fd);
		
		GridData gd = new GridData();
		gd.horizontalSpan = 2;
		Label errMsg = new Label(sashForm, SWT.NONE);
		errMsg.setFont(ft);
		Color c = new Color(Display.getCurrent(), 255, 0, 0);
		errMsg.setForeground(c);
		errMsg.setText("Timeout while connecting swf...\n\nPlease Try Again!");
		errMsg.setLayoutData(gd);
		
		
		parent.setSelection(tabbedItem);
		parent.addCTabFolder2Listener(new CTabFolder2Adapter() {
			public void close(CTabFolderEvent event) {
				if (!event.item.isDisposed())
				{
					String tabName = ((CTabItem)event.item).getText();
					SWFList<SWFAppUI> list = SWFList.getInstance();
					SWFAppUI app = list.getSWF(tabName);
					if(app!=null)
					{
						app.disconnect();
						
					}
					else
					{
						//Remove stale tab
						removeTab();
					}
				}
			}}
		);
		
		return this;
		
	}
	
	private void hookContextMenu() {
		Menu menu = new Menu (tabFolder.getParent().getShell(), SWT.POP_UP);
		MenuItem item = new MenuItem (menu, SWT.PUSH);
		item.setText ("Copy GenieID to clipboard");
		item.addSelectionListener(new SelectionAdapter() {
		      public void widgetSelected(SelectionEvent e) {
		    	  GenieObject selectedObject = getSelectedTreeItem();
		    	  if(selectedObject!=null)
		    	  {
		    		  Clipboard clipboard = new Clipboard(Display.getCurrent());
		    		  Object[] data = new Object[]{selectedObject.getGenieId()};
		    		  TextTransfer textTransfer = TextTransfer.getInstance();
		    		  Transfer[] transfers = new Transfer[]{textTransfer};

					  clipboard.setContents(data, transfers);
		    	  }
		      }
		    });
		
				
		MenuItem componentXMLItem = new MenuItem (menu, SWT.PUSH);
		componentXMLItem.setText ("Save Component XML");
		componentXMLItem.addSelectionListener(new SelectionAdapter() {
		      public void widgetSelected(SelectionEvent e) {
		    	  GenieObject selectedObject = getSelectedTreeItem();
		    	  String genieId = selectedObject.getGenieId();
		    	  CTabItem currentSelection = tabFolder.getSelection();
		    	  String swfName = currentSelection.getText();
		    	  if(selectedObject!=null)
		    	  {
		    		  GenieComponentXML genieComponentXML = new GenieComponentXML(swfName,genieId);
		    		  genieComponentXML.start();
		    	  }
		      }
		    });
		
		    
	    treeViewer.getControl().setMenu(menu);
	}
	
	public void refreshAppTree()
	{
		try
		{
			/*
			 * What is following code doing? Getting own xml, and create a new obj????
			 * Leaving code commented for future reference
			 * 
			GenieObject input = getInitalInput(swfApp.genieData.getXml());
			swfApp.genieData = input;*/
			
			Object[] elements = treeViewer.getExpandedElements();
			TreePath[] treePaths = treeViewer.getExpandedTreePaths();
			
			treeViewer.setInput(swfApp.genieData);
					
			treeViewer.refresh();
			treeViewer.setExpandedElements(elements);
			treeViewer.setExpandedTreePaths(treePaths); 
			
		}
		catch(Exception e)
		{
			Utils.printErrorOnConsole(e.getMessage());
		}
		
	}
	
	public void setInput(GenieObject object)
	{
		
	}
	public void setFocus()
	{
		/**
		 * Fixing bug. this function was being called to regain focus of the tab.
		 * But, this was being refreshed continuously by a SWT thread.
		 * So, causing Invalid Thread Access exception 
		 */
		
		Display.getDefault().asyncExec(new Runnable() {
            public void run() {
            	GenieView.getInstanceAndShowView();
            	tabFolder.setSelection(tabbedItem);
            }
         });				
	}
	public void removeTab()
	{
		
		
		
		Display.getDefault().asyncExec(new Runnable() {
			
			public void run() {
				
				try{
					if (!StaticFlags.getInstance().isGenieViewClosedBtnPressed())
					{
						GenieView view1 = GenieView.getInstanceAndShowView();
						if (view1 != null)	
							view1.resetActionsState();
					}
					
					String debugStr = "TreeTab::removeTab";
					if(!tabbedItem.isDisposed())
					{
						LogData.getInstance().trace(LogData.INFO, debugStr + " Removing tab for swf: " + tabbedItem.getText());
						
						tabbedItem.dispose();
					}
					
					if (!tabFolder.isDisposed())
					{
						tabFolder.update();
						tabFolder.redraw();
					}
					
					
				}catch(Exception e)
				{
					Utils.printErrorOnConsole(e.getMessage());
					e.printStackTrace();
				}
			}
		});		
	}
	public GenieObject getSelectedTreeItem()
	{
		GenieObject returnValue = null;
		IStructuredSelection selection = (IStructuredSelection)treeViewer.getSelection();
		for (Iterator iterator = selection.iterator(); iterator.hasNext();) {
			Object domain = (Model) iterator.next();
			if(domain instanceof GenieObject)
			{
				returnValue = (GenieObject) domain;
			}
		}
		return returnValue;
	}
	protected void hookListeners() {
		treeViewer.getTree().addKeyListener(new KeyListener() {
			
			public void keyReleased(org.eclipse.swt.events.KeyEvent e) {
				arrowKeyReleased = true;
				treeViewer.setSelection(treeViewer.getSelection());
			}
			
			public void keyPressed(org.eclipse.swt.events.KeyEvent e) {
				arrowKeyReleased = false;
			}
		});
		
		treeViewer.addSelectionChangedListener(new ISelectionChangedListener() {
			public void selectionChanged(SelectionChangedEvent event) {
				try{
					GenieView view1 = GenieView.getInstance();
					boolean goAhead = true;
					if(view1.getGeniePropertiesAction.isChecked())
					{
						goAhead = arrowKeyReleased;
					}
					if(goAhead)
					{
						//Note: gsingal, when we need to switch it one, uncomment below line, and uncomment below blocks.
						//view1.getGeniePropertiesAction.setChecked(false);
						
						try{
							CTabItem currentSelection = tabFolder.getSelection();
							String tabName = currentSelection.getText();
							SWFList list = SWFList.getInstance();
							SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
							
							IContributionItem item = view1.getViewSite().getActionBars().getToolBarManager().find("Glow");
						    ActionContributionItem actionItem = (ActionContributionItem) item;
						    if(actionItem != null)
						    {
						    	if(actionItem.getAction().isChecked())
						    	{
						    		if(app != null)
									{
										app.glowComponentInSwf();
									}
						    	}
						    }
						}catch(Exception exc1){
							exc1.printStackTrace();
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug1: " + exc1.getMessage());
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug1: " + Utils.getExceptionStackTraceAsString(exc1));
						}
					
						try{
							// if the selection is empty clear the label
							if(event.getSelection().isEmpty()) {
								
								return;
							}
						}catch(Exception exc2){
							exc2.printStackTrace();
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug2: " + exc2.getMessage());
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug2: " + Utils.getExceptionStackTraceAsString(exc2));
						}
						try{
							CTabItem currentSelection = tabFolder.getSelection();
							String tabName = currentSelection.getText();
							SWFList list = SWFList.getInstance();
							SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
						if(event.getSelection() instanceof IStructuredSelection) {
							IStructuredSelection selection = (IStructuredSelection)event.getSelection();
							//StringBuffer toShow = new StringBuffer();
							for (Iterator iterator = selection.iterator(); iterator.hasNext();) {
								Object domain = (Model) iterator.next();
								//String value = labelProvider.getText(domain);
								//toShow.append(value);
								//toShow.append(", ");
								if(domain instanceof GenieObject)
								{
									GenieObject gObject = (GenieObject) domain;
									
									setInputForTableViewer(gObject.getGenieId(), gObject.getProperties());
									if (view1.getGeniePropertiesAction.isChecked())
									{
										if (app != null)
											requestObjectProperties(app, gObject.getGenieId());
									}
								}
							}
							// remove the trailing comma space pair
							//if(toShow.length() > 0) {
							//	toShow.setLength(toShow.length() - 2);
							//}
							
//							if(event.getSelection() instanceof GenieObject)
//							{
//								GenieObject gObject = (GenieObject) event.getSelection();
//								
//								setInputForTableViewer(gObject.getGenieId(), gObject.getProperties());
//								
//								if (view1.getGeniePropertiesAction.isChecked())
//								{
//									if (app != null)
//										requestObjectProperties(app, gObject.getGenieId());
//								}
//							}
						}
						}catch(Exception exc3){
							exc3.printStackTrace();
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug3: " + exc3.getMessage());
							LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug3: " + Utils.getExceptionStackTraceAsString(exc3));
						}
					}
				}catch(Exception ex){
					LogData.getInstance().trace(LogData.ERROR, "Exception ocurred in selectionChanged " );
					LogData.getInstance().trace(LogData.ERROR, "Exception is " + ex.getMessage());
					LogData.getInstance().trace(LogData.ERROR, "Exception in Tree tab selection Debug4: " + Utils.getExceptionStackTraceAsString(ex));
				}
			}
			
		});
	}
	
	public void setInputForTableViewer(final String genieId, GenieObjectProperties gps)
	{
		Table table = tableViewer.getTable();
		
		//Clears previous editor controls, if any
		Control[] cs = table.getChildren();
		if (cs != null)
		{
			for (Control c : cs)
			{
				c.dispose();
			}
		}
		
		tableViewer.setInput(gps);
		
		TableEditor tes = null;
		Button btn = null;
		TableItem[] tItems = table.getItems();
		for (int i=0; i<tItems.length; i++)
		{
			TableItem item = tItems[i];
			final Property prop = (Property)item.getData();
		
			if (prop.getValue().contains("[object") && !prop.getKey().equals("parent"))
			{
				btn = new Button(table, SWT.PUSH);
				btn.setText("...");
				btn.setToolTipText("Click to show xml of the property");
				
				int btnWidth = 18;
				if (Utils.isMac())
				{
					btnWidth = 32;
				}
				GridData gd = new GridData();
				gd.widthHint = btnWidth;
				gd.heightHint = 14;
				btn.setLayoutData(gd);
				
				btn.addMouseListener(new MouseListener() {
					public void mouseUp(MouseEvent e) {
						
						boolean errorHappened = false;
						String xml = "<XML><Input><GenieID>"+genieId+"</GenieID>" +
							"<PropertyName>" + prop.getKey() + "</PropertyName></Input></XML>";
						SynchronizedSocket sc = SynchronizedSocket.getInstance();
						Result result = sc.doAction(swfApp.name, "getValueOfObject", xml);
						
						StringBuffer sb = new StringBuffer();
						try{
							System.out.println("Xml for genieId: " + result.message + ", property: " + prop.getKey());
							XmlDoc xmlDoc = new XmlDoc(result.message);
							String res = xmlDoc.getNodeValue("//Output/PropertyValue");
							if (res.equals(""))
							{
								errorHappened = true;
								res = xmlDoc.getNodeValue("//Output/Message");
							}
							String xmlString = res;
							if (!res.equals(""))
							{
								try{
									xmlDoc = new XmlDoc(res);
									xmlString = xmlDoc.getBeautifyXmlString();
								}catch(Exception exc){
									errorHappened = true;
								}
							}
							
							sb.append(xmlString);
						}catch(Exception ex){
							errorHappened = true;
							sb.append(ex.getMessage());
						}
						
						ShowXml showXml = new ShowXml(sb, "XML for Property=" + prop.getKey() + ", GenieId: " + genieId, errorHappened);
						showXml.start();
					}
					public void mouseDown(MouseEvent e) {}
					public void mouseDoubleClick(MouseEvent e) {}
				});
			    
				tes = new TableEditor(table);
				tes.horizontalAlignment = SWT.RIGHT;
				tes.minimumHeight = 14;
			    tes.minimumWidth = btnWidth;
			    			    			    
			    tes.setEditor(btn, item, 1);
			}
		}
	}
	
	/**
	 * Request all properties of the object, and refresh properties shown in table
	 */
	public void requestObjectProperties(SWFAppUI app, String genieId)
	{
		if (!genieId.equals(""))
		{
			LogData.getInstance().traceDebug(LogData.INFO, "Requested properties for::" + genieId);
			app.requestAllGenieProperties(genieId, "gotGenieObjectProperties");
		}
	}
	public void refreshObjectProperties(String genieId, GenieObjectProperties gObjProps)
	{
		setInputForTableViewer(genieId, gObjProps);
	}
	
	public static void processHierarchy(Node parent, GenieObject parentObject, java.util.Hashtable<String, GenieObject> objectMap) 
	{
		String debugStr = "TreeTab::processHierarchy";
		try{
			NodeList children = parent.getChildNodes();
	    for(int i=0; i<children.getLength(); i++) 
	    {
	    	GenieObject childTree = null;
	    	
	       if(children.item(i).getNodeType() == Node.ELEMENT_NODE)
	       {
	    	    Element childElement = (Element)children.item(i);
	    	    String genieID = childElement.getAttribute("genieID");
	    	   	if( objectMap.get(genieID) != null)
		    	{
	    		   	childTree = objectMap.get(genieID);
		    	}
		    	else
		    	{
		    		 childTree = new GenieObject();
		    	}
	    	   
	    	   if(!childElement.getNodeName().equalsIgnoreCase("DataItems"))
	    	   {
		    	   String value = childElement.getAttribute("name");
		    	   String type = childElement.getAttribute("type");
		    	   if (value.trim().length() == 0){
		    		   value = type;
		    	   }
		    	   if((value.trim().length() == 0))
		    	   {
		    		   childTree.setName(childElement.getNodeName());
		    	   }
		    	   else
		    	   {
		    		   childTree.setName(value);
		    	   }
		    	   
		    	   childTree.setGenieId(genieID);
		    	   childTree.setType(type);
		    	   
		    	   childTree.setXml(childElement);
		    	   
		    	   NamedNodeMap attributes = childElement.getAttributes();
		    	   GenieObjectProperties props = new GenieObjectProperties();
		    	   for(int j=0; j<attributes.getLength(); j++)
		    	   {
		    		   Node attribute = attributes.item(j);
		    		  // if(attribute.getNodeName() != "name")
		    		   //{
		    			   Property prop = new Property();
		    			   prop.setKey(attribute.getNodeName());
		    			   prop.setValue(attribute.getNodeValue());
		    			   props.addProperty(prop);
		    		   //}
		    	   }
		    	   childTree.setProperties(props);
	    	   
		    	   NodeList chNodes = childElement.getChildNodes();
		    	   for(int j=0; j<chNodes.getLength(); ++j)
		    	   {
		    		   if(chNodes.item(j).getNodeType() == Node.ELEMENT_NODE)
		    		   {
		    			   if(chNodes.item(j).getNodeName().equalsIgnoreCase("DataItems"))
		    			   {
		    				   Element dataItem = (Element)chNodes.item(j);
				    		   if(dataItem!=null)
				    		   {
				    			   
					    		   Property prop = new Property();
				    			   prop.setKey("DataItems");
				    			   prop.setValue(dataItem.getTextContent());
				    			   props.addProperty(prop);
				    		   }
		    			   }
		    		   }
		    	   }
	    	   
	    	      
		    	   if( objectMap.get(genieID) == null)
		    	   {
		    		   	parentObject.add(childTree);
			       }
		    	   
		    	   if(childElement.getAttribute("genieID").length()>0)
		    		   objectMap.put(childElement.getAttribute("genieID"), childTree);
		    	  
		          if (childElement.getElementsByTagName("*").getLength() > 0)
			      {// Ie node with children
		           	 
				     processHierarchy(childElement,childTree,objectMap);
			    	 
			      }
	    	   }
	        }
	    }
		}catch(Exception e)
		{
			LogData log = LogData.getInstance();
			log.traceDebug(LogData.ERROR, debugStr + " " + e.getMessage());
		}
	 }
	
	public boolean selectTreeNode(String genieID)
	{
		Tree tree = treeViewer.getTree();
		if(tree.getItems().length>0)
		{
			GenieObject item = swfApp.objectMap.get(genieID);
			
			if(item != null)
			{
				treeViewer.setSelection(new StructuredSelection(item), true);
			}
			else
				return false;
			
		}
		
		return true;
	}
	public GenieObject getInitalInput(Element xmldata) {
		GenieObject root = new GenieObject();
		root.setName("root");
		root.setXml(xmldata);
		
		Document doc = null;
		try
		{
			doc = xmldata.getOwnerDocument();
		}
		catch(Exception e){}
		
		processHierarchy(doc, root,swfApp.objectMap);
		return root;
	}

	private static void createColumns(Composite parent, TableViewer viewer) {

		String[] titles = { "Property", "Value"};
		int[] bounds = { 150, 250};
		
		for (int i = 0; i < titles.length; i++) 
		{
			TableViewerColumn viewerColumn = new TableViewerColumn(viewer, SWT.NONE);
			org.eclipse.swt.widgets.TableColumn coloumn = viewerColumn.getColumn();
			coloumn.setText(titles[i]);
			coloumn.setWidth(bounds[i]);
			coloumn.setResizable(true);
			coloumn.setMoveable(true);
			
			viewerColumn.setEditingSupport(new CustomEditingSupport(viewer, i));
		}
		
		Table table = viewer.getTable();
		
		GridData layoutData = new GridData();
		layoutData.grabExcessHorizontalSpace = true;
		layoutData.grabExcessVerticalSpace = true;
		layoutData.horizontalAlignment = GridData.FILL;
		layoutData.verticalAlignment = GridData.FILL;
		layoutData.minimumHeight = 240;
		
		viewer.getControl().setLayoutData(layoutData);
		
		
		table.setLayoutData(new GridData(GridData.FILL_BOTH));
		
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
	}
}

class CustomEditingSupport extends EditingSupport {
	private final TableViewer v;
	private int column;

	public CustomEditingSupport(TableViewer viewer,int columnNum) {
		super(viewer);
		v = viewer;
		this.column = columnNum;
	}

	@Override
	protected boolean canEdit(Object element) {
		return true;
	}

	@Override
	protected CellEditor getCellEditor(Object element) {
		return new TextCellEditor(v.getTable());
	}

	@Override
	protected Object getValue(Object element) {
		Property prop = (Property) element;

		switch (column) {
		case 0:
			return prop.getKey();
			
		case 1:
			return prop.getValue();
		default:
			break;
			
		}
		return null;
	}

	@Override
	protected void setValue(Object element, Object value) {
		//Gorav, Fixing bug: On changing values of cells, it got updated
	}
}
