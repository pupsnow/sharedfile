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


import org.eclipse.swt.SWT;
import org.eclipse.ui.menus.CommandContributionItem;
import org.eclipse.ui.menus.CommandContributionItemParameter;
import org.eclipse.ui.menus.ExtensionContributionFactory;
import org.eclipse.ui.menus.IContributionRoot;
import org.eclipse.ui.services.IServiceLocator;

import com.adobe.genie.genieCom.SWFList;
import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.geniePlugin.Activator;
import com.adobe.geniePlugin.comunication.StaticFlags;

/**
 * This class is used to fill swfList menu on the tool bar.
 * <p>
 *  Owner: Suman Mehta
 *  $Author: suman $
 * 
 */
public class AddCommandsToMenu extends ExtensionContributionFactory {

	public static boolean pluginRejectedDueToVersionIncompat = false;
	public static boolean secondPluginRunning = false;
	public static String msg = new String();
	@Override
	public void createContributionItems(IServiceLocator serviceLocator,
			IContributionRoot additions) {
		
		SWFList<SWFAppUI> list = SWFList.getInstance();
		for(int i =0; i<list.size() ; ++i)
		{
			CommandContributionItemParameter p = new CommandContributionItemParameter(
					serviceLocator, list.get(i).name,
					"GeniePlugin.Connect",
					SWT.PUSH);
			p.label = list.get(i).name;
			
			p.icon = Activator.getImageDescriptor("icons/Book.gif");
	
			CommandContributionItem item = new CommandContributionItem(p);
			item.setVisible(true);
			additions.addContributionItem(item, null);
		}
		if(list.size() == 0)
		{
			String pluginMessage = "No Apps to Connect";
			SynchronizedSocket socket = SynchronizedSocket.getInstance();
			if (secondPluginRunning == true)
			{
				pluginMessage = msg;
			}
			else if ((socket == null) || socket.isSocketClosed() || socket.isServerDisconnected())
			{
				pluginMessage = "Server not connected";
			}
			
			if (pluginRejectedDueToVersionIncompat)
			{
				pluginMessage = msg;
			}
			CommandContributionItemParameter p = new CommandContributionItemParameter(
					serviceLocator, pluginMessage,
					"GeniePlugin.Disabled",
					SWT.PUSH);
			p.label = pluginMessage;
			
			//p.icon = Activator.getImageDescriptor("icons/Book.gif");
	
			CommandContributionItem item = new CommandContributionItem(p);
			item.setVisible(true);
			additions.addContributionItem(item, null);
		}
	}
}
