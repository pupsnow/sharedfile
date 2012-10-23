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

import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.swt.custom.CTabItem;
import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SocketClient;
import com.adobe.geniePlugin.Activator;
import com.adobe.geniePlugin.ui.SWFAppUI;
import com.adobe.geniePlugin.views.GenieView;

public class FindGlowTristateAction extends Action{

	private enum TristateButtonMode{FIND_AND_DONT_PROPAGATE, FIND_AND_PROPAGATE};
	private boolean checkedOnce = false;
	private String currentTabname = "";
	
	public FindGlowTristateAction()
	{
		super("Find Component in Tree And Dont propagate Actions", IAction.AS_CHECK_BOX);
		
		TristateButtonMode defMode = TristateButtonMode.FIND_AND_PROPAGATE;
		this.setText(this.getTooltip(defMode));
		this.setImageDescriptor(this.getImageDesciptor(defMode));
		this.setToolTipText(this.getTooltip(defMode));
		this.setId(defMode.name());
		this.setEnabled(false);
	}
	
	public void run()
	{
		CTabItem currentSelection = GenieView.getInstance().tabFolder.getSelection();
		if (currentSelection == null)
		{
			this.setEnabled(false);
		}
		else
		{
			String tabName = currentSelection.getText();
			SWFList list = SWFList.getInstance();
			
			SWFAppUI app = (SWFAppUI) list.getSWF(tabName);
			currentTabname = app.name;
		
			if (this.isChecked())
			{
				checkedOnce = true;
				
				this.decorateAction(TristateButtonMode.FIND_AND_PROPAGATE);
				
				SocketClient.getInstance().sendCommand(app.name, "dontPropagateActions", "", "<Boolean>false</Boolean>");
				app.enableFindComponent();
			}
			else
			{
				if (this.checkedOnce && this.getId().equals(TristateButtonMode.FIND_AND_PROPAGATE.name()))
				{
					this.decorateAction(TristateButtonMode.FIND_AND_DONT_PROPAGATE);
					
					this.setChecked(true);
					
					SocketClient.getInstance().sendCommand(app.name, "dontPropagateActions", "", "<Boolean>true</Boolean>");
					app.enableFindComponent();
				}
				else
				{
					SocketClient.getInstance().sendCommand(app.name, "dontPropagateActions", "", "<Boolean>false</Boolean>");
					app.disableFindComponent();
					
					this.decorateAction(TristateButtonMode.FIND_AND_PROPAGATE);
				}
			}
		}
	}
	public void resetAndRun()
	{
		this.setChecked(false);
		this.checkedOnce = false;
		this.run();
	}
	private void decorateAction(TristateButtonMode mode)
	{
		this.setId(mode.name());
		this.setText(this.getTooltip(mode));
		this.setImageDescriptor(this.getImageDesciptor(mode));
		this.setToolTipText(this.getTooltip(mode));
	}
	public void setEnabled(boolean flag, boolean force)
	{
		if (!flag)
			checkedOnce = false;
		this.decorateAction(TristateButtonMode.FIND_AND_PROPAGATE);
		if (force && flag)
			super.setEnabled(true);
		else
			super.setEnabled(flag);
	}
	public void setEnabled(boolean flag)
	{
		if (!flag)
		{
			checkedOnce = false;

			if (!currentTabname.equals(""))
			{
				SWFList list = SWFList.getInstance();
				SWFAppUI app = (SWFAppUI) list.getSWF(currentTabname);
				if(app!=null)
				{
					SocketClient.getInstance().sendCommand(app.name, "dontPropagateActions", "", "<Boolean>false</Boolean>");
					app.disableFindComponent();
				}
			}
			this.setChecked(false);
		}
		
		this.decorateAction(TristateButtonMode.FIND_AND_PROPAGATE);
		
		super.setEnabled(flag);
	}
	private ImageDescriptor getImageDesciptor(TristateButtonMode mode)
	{
		ImageDescriptor imgDesc = null;
		switch(mode)
		{
		case FIND_AND_DONT_PROPAGATE:
			imgDesc = Activator.getImageDescriptor("icons/findDontPropagate.png");
			break;
		case FIND_AND_PROPAGATE:
			imgDesc = Activator.getImageDescriptor("icons/Find Component.png");
			break;
		}
		
		return imgDesc;
	}
	private String getTooltip(TristateButtonMode mode)
	{
		switch(mode)
		{
		case FIND_AND_DONT_PROPAGATE:
			return "Find Component in Tree And Dont propagate Actions";
		case FIND_AND_PROPAGATE:
			return "Find Component in Tree";
		}
		return "";
	}
}
