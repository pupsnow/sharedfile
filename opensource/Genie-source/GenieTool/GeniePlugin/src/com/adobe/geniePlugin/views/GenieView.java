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
package com.adobe.geniePlugin.views;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStreamWriter;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

import org.eclipse.core.databinding.DataBindingContext;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.action.MenuManager;
import org.eclipse.jface.action.Separator;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.TreeViewer;
import org.eclipse.jface.viewers.ViewerSorter;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CTabFolder;
import org.eclipse.swt.custom.CTabFolder2Listener;
import org.eclipse.swt.custom.CTabFolderEvent;
import org.eclipse.swt.custom.CTabItem;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.events.FocusEvent;
import org.eclipse.swt.events.FocusListener;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Group;
import org.eclipse.ui.IActionBars;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.internal.WorkbenchWindow;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.ui.views.properties.PropertySheetPage;

import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.genie.utils.Utils;
import com.adobe.genie.utils.log.LogData;
import com.adobe.geniePlugin.Activator;
//import com.adobe.geniePlugin.comunication.BuildExpiryChecker;
import com.adobe.geniePlugin.comunication.ParseAppXML;
import com.adobe.geniePlugin.comunication.StaticFlags;
import com.adobe.geniePlugin.model.GenieObject;
import com.adobe.geniePlugin.model.GenieObjectProperties;
import com.adobe.geniePlugin.model.Model;
import com.adobe.geniePlugin.model.Property;
import com.adobe.geniePlugin.record.Record;
import com.adobe.geniePlugin.ui.ConnectToSWF;
//import com.adobe.geniePlugin.ui.FeedbackHandle;
import com.adobe.geniePlugin.ui.GenieObjectLabelProvider;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.ui.UICommonFunctions;
import com.genie.data.FindGlowTristateAction;

/**
 * Main GenieView class. This class is responsible for creating all the UI elements for this plugin.
 * <p>
 *  Owner: Suman Mehta
 *  $Author: suman $
 * 
 */


public class GenieView extends ViewPart {

	/**
	 * The ID of the view as specified by the extension.
	 */
	public static final String ID = "labelplugin.views.GenieView";

	private Action glowAction;
	private Action disconnectAction;
	public Action getLastRecordedScript;
	private Action findComponentByGenieID;
	private Action recordScriptAtApplicationPace;
	private Action saveTreeXML;
	private Action stopRecordingUIFunctionAction;
	public Action showCoordinatesAction;
//	private Action doFeedbackAction;
	private Action showHideGenieIconAction;
	private Action switchToHighPerformance;
	private Action captureImgeActionDesktop;
	public Action getGeniePropertiesAction;	
	public Action getComponentImageAction;
	public Action refreshSWFAction;
	
	public FindGlowTristateAction triStateFindGlowAction;
	
	private Composite compositeParent;
	
	protected TreeViewer treeViewer;
	protected Group group;
	protected GenieObjectLabelProvider labelProvider;
	public CTabFolder tabFolder = null;
	protected ViewerSorter sorter;
	protected PropertySheetPage pp;
	protected SashForm sashForm;
	
	private static GenieView genieView = null;
	
	protected GenieObject root;
	
	/**
	 * The constructor.
	 */
	public GenieView() {
	}
	
	private static GenieView showView()
	{
		try{
			IWorkbenchWindow window = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
			IWorkbenchPage wbp = window.getActivePage();
		    genieView = (GenieView) wbp.showView("com.adobe.geniePlugin.views.GenieView");			
		}catch(Exception e){
		}

		return genieView;
	}
	public static GenieView getInstance()
	{
		if (genieView == null)
			genieView = showView();

		return genieView;
	}
	public static GenieView getInstanceAndShowView()
	{
		showView();

		return genieView;
	}
	
	public void dispose()
	{
		super.dispose();
		
		StaticFlags.getInstance().setGenieViewCloseBtnPressed(true);
		//disconnect all the swfs
		SWFList list = SWFList.getInstance();
		
		for (int i=0; i<list.size(); i++)
		{
			SWFAppUI app = (SWFAppUI) list.get(i);
			if (app != null)
			{
				app.isVisibleOnUI = false;
				app.uiRep = null;
				app.disconnect();
			}
		}
		
		StaticFlags.getInstance().setGenieViewCloseBtnPressed(false);
	}
	
	/**
	 * This is a callback that will allow us
	 * to create the viewer and initialize it.
	 */
	public void createPartControl(Composite parent) {
		
		String debugStr = "GenieView::createPartControl";
		LogData.getInstance().trace(LogData.INFO, debugStr + " Initializing GenieView");
		
		compositeParent = parent;
		pp = new PropertySheetPage();
		pp.setPropertySourceProvider(null);

		tabFolder = new CTabFolder(parent,SWT.TOP);
		      
		GridLayout layout = new GridLayout();
		layout.numColumns = 1;
		layout.verticalSpacing = 2;
		layout.marginWidth = 0;
		layout.marginHeight = 2;
		tabFolder.setLayout(layout);

		IActionBars bars = getViewSite().getActionBars();
		
		triStateFindGlowAction = new FindGlowTristateAction();
		bars.getToolBarManager().add(triStateFindGlowAction);
		
		glowAction = new Action("Highlight Component in SWF",IAction.AS_CHECK_BOX ) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					
					SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
					if(isChecked())
					{	
						app.glowComponentInSwf();
					}
					else
					{
						app.removeGlowOnSwf();
					}
				}
			}
		};
		glowAction.setText("Highlight Component in SWF");
		glowAction.setImageDescriptor(Activator.getImageDescriptor("icons/Brush.png"));
		glowAction.setToolTipText("Highlight Component in SWF");
		glowAction.setId("Glow");
		glowAction.setEnabled(false);
		bars.getToolBarManager().add(glowAction);
					
		showCoordinatesAction = new Action("Show Coordinates on swf", IAction.AS_CHECK_BOX) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
					
					if(isChecked())
					{
						app.enableShowCoordinates();
					}
					else
					{
						app.disableShowCoordinates();
					}
				}
			}};
		
		showCoordinatesAction.setText("Show Coordinates on swf");
		showCoordinatesAction.setImageDescriptor(Activator.getImageDescriptor("icons/showPointer.png"));
		showCoordinatesAction.setToolTipText("Show Local Coordinates on SWF");
		showCoordinatesAction.setEnabled(false);
		bars.getToolBarManager().add(showCoordinatesAction);
		
		//Feature : Capture Image Based Workflow  -----------------------------
		captureImgeActionDesktop = new Action("Capture Image On Desktop", IAction.AS_PUSH_BUTTON) {
			public void run() {
			      compositeParent.getShell().setMinimized(true);
			      GenieCaptureImage genieCaptureImage= new GenieCaptureImage();
			      genieCaptureImage.start();
			}};
		captureImgeActionDesktop.setText("Capture Image On Desktop");
		captureImgeActionDesktop.setImageDescriptor(Activator.getImageDescriptor("icons/CaptureIcon.png"));
		captureImgeActionDesktop.setToolTipText("Capture Image for UI Based Actions on Desktop");
		captureImgeActionDesktop.setEnabled(true);
		bars.getToolBarManager().add(captureImgeActionDesktop);
		

		getGeniePropertiesAction = new Action("Request Genie Properties of Object",IAction.AS_CHECK_BOX) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String swfName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					
					SWFAppUI app = (SWFAppUI) list.getSWF(swfName);
					GenieObject gObject = app.uiRep.getSelectedTreeItem();
					if ((gObject == null) || (app == null))
						return;
					String selectedGenieID = gObject.getGenieId();
					
					if(isChecked())
					{
						app.uiRep.requestObjectProperties(app, selectedGenieID);							
					}
					else
					{
						app.uiRep.setInputForTableViewer(gObject.getGenieId(), gObject.getProperties());
					}
				}
			}
		};
		getGeniePropertiesAction.setText("Request Genie Properties of Object");
		getGeniePropertiesAction.setImageDescriptor(Activator.getImageDescriptor("icons/allProp.png"));
		getGeniePropertiesAction.setToolTipText("Request Genie Properties of Object");
		getGeniePropertiesAction.setId("GenieProperty");
		getGeniePropertiesAction.setEnabled(true);
		bars.getToolBarManager().add(getGeniePropertiesAction);
		
		getComponentImageAction = new Action("Show Genie Component Image",IAction.AS_CHECK_BOX) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				/*else
				{
					this.setEnabled(enabled)
				}*/
			}
		};
		getComponentImageAction.setText("Show Genie Component Image");
		getComponentImageAction.setImageDescriptor(Activator.getImageDescriptor("icons/getCompImg.png"));
		getComponentImageAction.setToolTipText("Show Genie Component Image");
		getComponentImageAction.setEnabled(true);
		bars.getToolBarManager().add(getComponentImageAction);		
		
		
		refreshSWFAction = new Action("Refresh Genie tree",IAction.AS_PUSH_BUTTON) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection != null)
				{
					String tabName = currentSelection.getText();
										
					final ConnectToSWF sJob = new ConnectToSWF(tabName, "Connecting Swf - " + tabName, true);
					
					Thread f = new Thread()
					{
						public void run()
						{
							sJob.schedule();
						}
					};
					f.start();
				}
			}
		};
		refreshSWFAction.setText("Refresh Genie tree");
		refreshSWFAction.setImageDescriptor(Activator.getImageDescriptor("icons/refreshSwf.png"));
		refreshSWFAction.setToolTipText("Refresh Genie tree");
		refreshSWFAction.setEnabled(true);
		bars.getToolBarManager().add(refreshSWFAction);		
		
		
		stopRecordingUIFunctionAction = new Action("Record UI Functions", IAction.AS_CHECK_BOX)	{
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
					if (isChecked())
					{
						app.enableRecordingUIFunctions();
					}
					else
					{
						app.disableRecordingUIFunctions();
					}
				}
			}
		};
		
		findComponentByGenieID = new Action("Find component by GenieID", IAction.AS_PUSH_BUTTON) {
			public void run() {
				if (findComponentByGenieID.isEnabled())
				{
					UICommonFunctions uiT = UICommonFunctions.getInputDialog();
					uiT.start();
				}
			}
		};		
		findComponentByGenieID.setText("Find component by GenieID");
		findComponentByGenieID.setToolTipText("Find component by GenieID");
		findComponentByGenieID.setEnabled(false);
		
		recordScriptAtApplicationPace = new Action("Record Script At Application Pace", IAction.AS_CHECK_BOX) {
			public void run() {
				if (recordScriptAtApplicationPace.isEnabled())
				{
					if (isChecked())
					{
						Record.getInstance().isRecordAtAppPace = true;
					}
					else
					{
						Record.getInstance().isRecordAtAppPace = false;
					}
				}
			}
		};	
		recordScriptAtApplicationPace.setText("Record Script At Application Pace");
		recordScriptAtApplicationPace.setToolTipText("Record Script At Application Pace");
		recordScriptAtApplicationPace.setEnabled(false);
		recordScriptAtApplicationPace.setChecked(false);
		
		stopRecordingUIFunctionAction.setText("Record UI Functions");
		stopRecordingUIFunctionAction.setToolTipText("Enable/Disable Recording UI Functions");
		stopRecordingUIFunctionAction.setChecked(true);
		stopRecordingUIFunctionAction.setEnabled(false);

		showHideGenieIconAction = new Action("Hide Genie Icon", IAction.AS_CHECK_BOX)	{
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
					if (isChecked())
					{
						app.hideGenieIcon();
					}
					else
					{
						app.showGenieIcon();
					}
				}
			}
		};
		
		showHideGenieIconAction.setText("Hide Genie Icon");
		showHideGenieIconAction.setToolTipText("Show/Hide Genie Icon");
		showHideGenieIconAction.setChecked(false);
		showHideGenieIconAction.setEnabled(false);
		
		//By default, its ON. Means, we are not updating tree on delta.
		//But, only in Recording, and Playback mode
		switchToHighPerformance = new Action("Auto Refresh Genie Tree", IAction.AS_CHECK_BOX)	{
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList list = SWFList.getInstance();
					SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
					if (isChecked())
					{
						SocketClient.getInstance().sendCommand(tabName, "setHighPerformanceMode", "", "<Boolean>false</Boolean>");
					}
					else
					{
						SocketClient.getInstance().sendCommand(tabName, "setHighPerformanceMode", "", "<Boolean>true</Boolean>");
					}
					
					//inform preload about this
				}
			}
		};
		
		switchToHighPerformance.setText("Auto Refresh Genie Tree");
		switchToHighPerformance.setToolTipText("Auto Refresh Genie Tree on receiving Delta");
		switchToHighPerformance.setChecked(false);
		switchToHighPerformance.setEnabled(false);
		
		disconnectAction = new Action("Disconnect SWF", IAction.AS_PUSH_BUTTON) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList<SWFAppUI> list = SWFList.getInstance();
					SWFAppUI app = list.getSWF(tabName);
					
					showCoordinatesAction.setChecked(false);
					showCoordinatesAction.run();
					
					app.disconnect();
				}
			}
		};
		
		disconnectAction.setText("Disconnect SWF");
		disconnectAction.setToolTipText("Disconnect SWF");
		disconnectAction.setEnabled(false);
		
		getLastRecordedScript = new Action("Show Last Recorded Script", IAction.AS_PUSH_BUTTON) {
			public void run() {
				Record recObj = Record.getInstance();
				if (recObj.HasLastRecordedScript())
				{
					recObj.showRecordedScript();
				}
			}
		};
		
		getLastRecordedScript.setText("Show Last Recorded Script");
		getLastRecordedScript.setToolTipText("Show Last Recorded Script");
		getLastRecordedScript.setEnabled(false);
		
		saveTreeXML = new Action("Save SWF Xml", IAction.AS_PUSH_BUTTON) {
			public void run() {
				CTabItem currentSelection = tabFolder.getSelection();
				if (currentSelection == null)
				{
					this.setEnabled(false);
				}
				else
				{
					String tabName = currentSelection.getText();
					SWFList<SWFAppUI> list = SWFList.getInstance();
					
					SWFAppUI app = list.getSWF(tabName);
					try{
						FileDialog fileDialog = new FileDialog(getSite().getShell(),SWT.SAVE);
						String[] extn = new String[1];
						extn[0] = "xml";
						fileDialog.setFilterExtensions(extn);
						String fileName = fileDialog.open();
						if (!fileName.endsWith(".xml"))
						{
							fileName += ".xml";
						}
						
						BufferedWriter out = new BufferedWriter(
									new OutputStreamWriter(new FileOutputStream(fileName), "UTF-8")
								);
						
						out.write(app.genieData.convertObjectToXMLString());
						out.newLine();
						out.flush();
						out.close();
					}
					catch(Exception e)
					{
						
					}
				}
			}
		};
		saveTreeXML.setText("Save Tree XML in File");
		saveTreeXML.setToolTipText("Save Tree XML in File");
		saveTreeXML.setEnabled(false);
		
//		[Piyush] Commenting out Feedback sending mechanism
//		doFeedbackAction = new Action("Give your Feedback", IAction.AS_PUSH_BUTTON) {
//				public void run() {
//					FeedbackHandle fh = new FeedbackHandle();
//					fh.start();
//				}
//			};
//			
//		doFeedbackAction.setText("Give Your Feedback");
//		doFeedbackAction.setImageDescriptor(Activator.getImageDescriptor("icons/fb.png"));
//		doFeedbackAction.setToolTipText("Give your Feedback");
//		bars.getToolBarManager().add(doFeedbackAction);		
//		bars.getMenuManager().add(doFeedbackAction);
			
		
		//gsingal Removed this from UI temporarily on 12 Dec 2011
		//bars.getMenuManager().add(stopRecordingUIFunctionAction);
		//bars.getMenuManager().add(switchToHighPerformance);
		
		bars.getMenuManager().add(showHideGenieIconAction);
		bars.getMenuManager().add(recordScriptAtApplicationPace);
		
		bars.getMenuManager().add(new Separator());
		
		bars.getMenuManager().add(disconnectAction);
		bars.getMenuManager().add(findComponentByGenieID);
		bars.getMenuManager().add(saveTreeXML);
		bars.getMenuManager().add(getLastRecordedScript);
		
		SWFList list = SWFList.getInstance();		
		
		tabFolder.addSelectionListener(new SelectionListener() {
			
			public void widgetSelected(SelectionEvent e) {
				resetActionsState();
				}

			public void widgetDefaultSelected(SelectionEvent e) {

			}
			
		});
		tabFolder.addCTabFolder2Listener(new CTabFolder2Listener() {
			
			public void showList(CTabFolderEvent event) {}
			
			public void restore(CTabFolderEvent event) {}
			
			public void minimize(CTabFolderEvent event) {}
			
			public void maximize(CTabFolderEvent event) {}
			
			public void close(CTabFolderEvent event) {
				resetActionsState();
				}
		});
		
		tabFolder.addFocusListener(new FocusListener() {
			
			public void focusGained(FocusEvent e) {
				resetActionsState();
				
			}

			public void focusLost(FocusEvent e) {
				//resetActionsState();
			}
		});
		
		tabFolder.pack();
		
	}
	
	public boolean isAnyTab()
	{
		CTabItem currentSelection = tabFolder.getSelection();
		if (currentSelection == null)
			return false;
		return true;
	}
	/**
	 * @return obj of currently opened Swf tab, else null
	 */
	public SWFAppUI getCurrentSwfObj()
	{
		CTabItem currentSelection = tabFolder.getSelection();
		if (currentSelection != null)
		{
			String swfName = currentSelection.getText();
			SWFList list = SWFList.getInstance();
			SWFAppUI app = (SWFAppUI) list.getSWF(swfName);
			return app;
		}
		
		return null;
	}
	
	public void refreshGenieObjectProperties(final String data)
	{
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				 
				 String genieId = Utils.getTagValue(data, "GenieId");
				 SWFAppUI appObj = getCurrentSwfObj();
				 GenieObject gObj = appObj.uiRep.getSelectedTreeItem();
					if (gObj == null)
						return;
				if (data.equals(""))
				 {
					 GenieObjectProperties gps = new GenieObjectProperties();
					 gps.addProperty(new Property("Error", "GenieId not found!"));
					 appObj.uiRep.refreshObjectProperties(gObj.getGenieId(), gps);
					 return;
				 }
					
				 String selectedGenieId = gObj.getGenieId();
				
				 //This check is to neglect the reply for a genie Id, but selection has changed now
				if (selectedGenieId.equals(genieId))
				{
					//refresh props, else nothing
					String forParsing = "";
					
					String genieIdEndTag = "</GenieId>";
					int idx = data.indexOf(genieIdEndTag);
					if (idx != -1)
					{
						forParsing = data.substring(idx + genieIdEndTag.length());
						
						Map<String, String> genieProps = Utils.getAttributeValueFromXML(forParsing, "accessor", "property", "value");
						SortedSet<String> sortedSet= new TreeSet<String>(genieProps.keySet());
						
						GenieObjectProperties gps = new GenieObjectProperties();
						//Add Genie id
						gps.addProperty(new Property("genieID",genieId));
						Iterator<String> itr = sortedSet.iterator();
						while (itr.hasNext())
						{
							String key = itr.next();
							gps.addProperty(new Property(key, genieProps.get(key)));
						}
						
						if (!gps.isEmpty())
							appObj.uiRep.refreshObjectProperties(gObj.getGenieId(), gps);
						else
							appObj.uiRep.refreshObjectProperties(gObj.getGenieId(), gObj.getProperties());
					}
				}
			 }
		});
	}
	
	public void doSelectGenieObject(String genieID)
	{
		CTabItem currentSelection = tabFolder.getSelection();
		if (currentSelection == null)
		{
			findComponentByGenieID.setEnabled(false);			
		}
		else
		{
			String tabName = currentSelection.getText();
			SWFList list = SWFList.getInstance();
			SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
			
			if (!app.uiRep.selectTreeNode(genieID))
			{
				Display.getDefault().asyncExec(new Runnable() {
					 public void run() {
						   MessageDialog.openError(
								null,
								"Find Genie Component",
								"Couldn't find this GenieID!!!");
					 }
				});
			}
		}
	}
	
	public void resetActionsState()
	{
		try{
			glowAction.setChecked(false);
			//triStateFindGlowAction.setChecked(false);
			showCoordinatesAction.setChecked(false);
			getComponentImageAction.setChecked(false);
			recordScriptAtApplicationPace.setChecked(false);
			stopRecordingUIFunctionAction.setChecked(true);
			showHideGenieIconAction.setChecked(false);
			getGeniePropertiesAction.setChecked(false);
			glowAction.run();
			triStateFindGlowAction.resetAndRun();
			//triStateFindGlowAction.run();
			showCoordinatesAction.run();
			getComponentImageAction.run();
			stopRecordingUIFunctionAction.run();
			showHideGenieIconAction.run();
			getGeniePropertiesAction.run();
			recordScriptAtApplicationPace.run();
			
			switchToHighPerformance.run();
			
			if (tabFolder != null)
			{
				if (tabFolder.getSelection() == null)
				{
					disablePushButtonActions();
					
					switchToHighPerformance.setChecked(false);
					switchToHighPerformance.setEnabled(false);
				}
			}
		}catch (Exception e) {
			
		}
	}
	
	/**
	 * Special handling of actions with push buttons, and are showing in menu not on toolbar
	 */
	public void disablePushButtonActions()
	{
		triStateFindGlowAction.setEnabled(false);
		findComponentByGenieID.setEnabled(false);
		refreshSWFAction.setEnabled(false);
		saveTreeXML.setEnabled(false);
		disconnectAction.setEnabled(false);
		recordScriptAtApplicationPace.setEnabled(false);
	}
	
	public void disableView()
	{
		glowAction.setEnabled(false);
		getLastRecordedScript.setEnabled(false);
		stopRecordingUIFunctionAction.setEnabled(false);
		showCoordinatesAction.setEnabled(false);
		//doFeedbackAction.setEnabled(false);
		showHideGenieIconAction.setEnabled(false);
		switchToHighPerformance.setEnabled(false);
		captureImgeActionDesktop.setEnabled(false);
		getGeniePropertiesAction.setEnabled(false);
		getComponentImageAction.setEnabled(false);
		triStateFindGlowAction.setEnabled(false);
		findComponentByGenieID.setEnabled(false);
		refreshSWFAction.setEnabled(false);
		saveTreeXML.setEnabled(false);
		disconnectAction.setEnabled(false);
		recordScriptAtApplicationPace.setEnabled(false);
	}
	
	public void enableFindGlowAction(final boolean flag)
	{
		try{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					 if (flag)
					 {
						 if (isAnyTab())
							 triStateFindGlowAction.setEnabled(true);
					 }
					 else
						 triStateFindGlowAction.setEnabled(flag);
					
					if (!flag)
					{
						glowAction.setChecked(false);
						glowAction.run();
					}
					if (isAnyTab())
						glowAction.setEnabled(flag);
				 }
			});
		}catch(Exception e){}
	}
	
	//Checking states before playback. So that user can not disturb
	public void hookPlaybackStart()
	{
		try{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					enableFindGlowAction(false);
					
					getGeniePropertiesAction.setChecked(false);
					getGeniePropertiesAction.run();
					
					getComponentImageAction.setChecked(false);
					getComponentImageAction.run();
					
					showHideGenieIconAction.setChecked(false);
					showHideGenieIconAction.setEnabled(false);
					
				 }
			});
		}catch(Exception e){}
	}
	public void hookPlaybackStop()
	{
		try{
			Display.getDefault().asyncExec(new Runnable() {
				 public void run() {
					enableFindGlowAction(true);
					
					//showHideGenieIconAction.setChecked(false);
					showHideGenieIconAction.setEnabled(true);
					showHideGenieIconAction.run();
					
					//trackPropertyChangesAction.setChecked(false);
				 }
			});
		}catch(Exception e){}
	}
	
	public void enableAllActions()
	{
		try{
			glowAction.setEnabled(true);
			triStateFindGlowAction.setEnabled(true, true);
			findComponentByGenieID.setEnabled(true);
			refreshSWFAction.setEnabled(true);
			recordScriptAtApplicationPace.setEnabled(true);
			showCoordinatesAction.setEnabled(true);
			getComponentImageAction.setEnabled(true);
			stopRecordingUIFunctionAction.setEnabled(true);
			showHideGenieIconAction.setEnabled(true);
			disconnectAction.setEnabled(true);
			saveTreeXML.setEnabled(true);
			getGeniePropertiesAction.setEnabled(true);
			this.switchToHighPerformance.setEnabled(true);
		}
		catch(Exception e){}
	}
	
	public void refreshAppXmlIfConnected(String data)
	{
		//Refresh app XML
		String[] arr = data.split(",");
		for(int i=0; i<arr.length; ++i)
		{
			SWFList<SWFAppUI> list = SWFList.getInstance();
			final SWFAppUI app = (SWFAppUI) list.getSWF(arr[i]);
			if ((app != null)&& (app.uiRep != null))
			{
				Thread f = new Thread(){
					public void run(){
						app.connect();
					}
				};
				f.start();
			}
		}
	}
	
	protected DataBindingContext initDataBindings() {
		DataBindingContext bindingContext = 
			new DataBindingContext();
			return bindingContext;
	}

	/** Remove the selected domain object(s).
	 * If multiple objects are selected remove all of them.
	 * 
	 * If nothing is selected do nothing. */
	protected void removeSelected() {
		if (treeViewer.getSelection().isEmpty()) {
			return;
		}
		IStructuredSelection selection = (IStructuredSelection) treeViewer.getSelection();
		/* Tell the tree to not redraw until we finish
		 * removing all the selected children. */
		treeViewer.getTree().setRedraw(false);
		for (Iterator iterator = selection.iterator(); iterator.hasNext();) {
			Model model = (Model) iterator.next();
			GenieObject parent = model.getParent();
			parent.remove(model);
		}
		treeViewer.getTree().setRedraw(true);
	}
	
	
	
	public String readTextFile(String fullPathFilename) {
		StringBuffer sb = new StringBuffer();
		try{
			
			BufferedReader reader = new BufferedReader(new FileReader(fullPathFilename));
					
			char[] chars = new char[1024];
			while( reader.read(chars) > -1){
				sb.append(String.valueOf(chars));	
			}
	
			reader.close();
		}
		catch(Exception e)
		{
			
		}
		return sb.toString();
	}

	/**
	 * Passing the focus request to the viewer's control.
	 */
	public void setFocus() {
		
	}
	
	public void removeOrphanTabsAfterResettingActions()
	{
		try{
			this.resetActionsState();						
		}
		catch(Exception e){}
		
		if (tabFolder == null)
			return;
		//Hack: First, Remove any orphan tabs
		CTabItem[] tabItems = tabFolder.getItems();
		for(int i=0; i<tabItems.length; ++i)
		{
			String tabName = tabItems[i].getText();
			SWFList<SWFAppUI> list = SWFList.getInstance();
			SWFAppUI app  = list.getSWF(tabName);
			if(app == null)
			{
				//We have found this orphan tab, let's delete this tab
				tabItems[i].dispose();
			}
		}
	}
	public void removeOrphanTabs()
	{
		if (this.tabFolder == null)
			return;
		//Hack: First, Remove any orphan tabs
		CTabItem[] tabItems = this.tabFolder.getItems();
		for(int i=0; i<tabItems.length; ++i)
		{
			if (!tabItems[i].isDisposed())
			{
				String tabName = tabItems[i].getText();
				SWFList<SWFAppUI> list = SWFList.getInstance();
				SWFAppUI app  = list.getSWF(tabName);
				if((app == null))
				{
					//We have found this orphan tab, let's delete this tab
					tabItems[i].dispose();
				}
			}	
		}
		
		//First reset action state
		try{
			this.resetActionsState();
		}
		catch(Exception e){}
	}
	public void removeOrphanTabsAndEnableActions()
	{
		//First reset action state
		try{
			this.resetActionsState();
			
			this.enableAllActions();						
		}
		catch(Exception e){}
		
		if (tabFolder == null)
			return;
		//Hack: First, Remove any orphan tabs
		CTabItem[] tabItems = tabFolder.getItems();
		for(int i=0; i<tabItems.length; ++i)
		{
			String tabName = tabItems[i].getText();
			SWFList<SWFAppUI> list = SWFList.getInstance();
			SWFAppUI app  = list.getSWF(tabName);
			if(app == null)
			{
				//We have found this orphan tab, let's delete this tab
				tabItems[i].dispose();				
			}
					
		}
	}
	public void removeAllTabs()
	{
		if (tabFolder == null)
			return;
		
		CTabItem[] tabItems = tabFolder.getItems();
		for(int i=0; i<tabItems.length; ++i)
		{
			tabItems[i].dispose();					
		}
	}
	
	public void maximizeEclipseShell()
	{
		compositeParent.getShell().setMinimized(false);		
	}
	
}
