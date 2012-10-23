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

import java.net.URL;

import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.ui.internal.util.BundleUtility;
import org.osgi.framework.Bundle;

import com.adobe.genie.genieCom.SynchronizedSocket;
import com.adobe.genie.utils.Utils;
import com.adobe.geniePlugin.VersionHandler;
import com.adobe.geniePlugin.comunication.StaticFlags;

public class AboutGenie extends Thread {

	private Shell sShell = null;
	private Composite cShell = null;
	private Display display = null;
	private Button deviceInfoBtn = null;

	private Label genieTitle = null;
	private org.eclipse.swt.graphics.Image img = null;
	private Point pt = null;

	Group genieContactGp;
	Group genieCompVerGp;
	Label styledText1;
	Label styledText2;
	
	Label serverVerLabel;
	Label serverVerValLabel;
	Label pluginVerLabel;
	Label pluginVerValLabel;
	Label preloadVerLabel;
	Label preloadVerValLabel;
	Label executorVerLabel;
	Label executorVerValLabel;

	private void createWidgets() {
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.makeColumnsEqualWidth = false;
		gl.verticalSpacing = 8;
		gl.marginTop = 14;
		gl.marginLeft = 10;
		gl.marginBottom = 10;
		gl.marginRight = 10;

		if (display == null) {
			display = Display.getCurrent();
		}

		if (pt == null) {
			pt = display.getCursorLocation();
		}
		sShell = new Shell(display, SWT.DIALOG_TRIM | SWT.APPLICATION_MODAL | SWT.ON_TOP);
		GridLayout g2 = new GridLayout();
		g2.numColumns = 1;
		sShell.setLayout(g2);
		
		cShell = new Composite(sShell,SWT.CENTER);
		cShell.setLayout(gl);

		sShell.setText("Automated UI Tester for Adobe® ActionScript®");
		sShell.addListener(SWT.Traverse, new Listener() {
			public void handleEvent(Event event) {
				switch (event.detail) {
				case SWT.TRAVERSE_ESCAPE:
				case SWT.TRAVERSE_RETURN:
				case 128: // key code for Space key
					sShell.close();
					event.detail = SWT.TRAVERSE_NONE;
					event.doit = false;
					break;
				}
			}
		});

		FontData fd = new FontData();
		fd.setStyle(SWT.BOLD);
		fd.setHeight(10);
		Font ft = new Font(display, fd);

		GridData gd = new GridData();
		genieTitle = new Label(cShell, SWT.NONE);
		genieTitle.setFont(ft);
		Color c = new Color(display, 0, 0, 0);
		genieTitle.setForeground(c);
		genieTitle.setText("Automated UI Tester for Adobe® ActionScript® (Code name \"Genie\")");
		genieTitle.setLayoutData(gd);
		
		Label erMsgIfAny = new Label(cShell, SWT.NONE);
		VersionHandler vH = VersionHandler.getInstance();
		if (vH.isRefusedConnection())
		{
			Color c2 = new Color(display, 255, 0, 0);
			erMsgIfAny.setForeground(c2);
			String erMsg = vH.getErrorMessage();
			int idx = erMsg.indexOf("!");
			if (idx != -1)
			{
				erMsg = erMsg.substring(0, idx + 1) + "\n" + erMsg.substring(idx+2);
			}
			else
				erMsg = erMsg.substring(0, 32) + "\n" + erMsg.substring(32);
						
			erMsgIfAny.setText(erMsg);
		}
			
		try {
			Bundle bundle = Platform.getBundle("GeniePlugin");
			URL url = BundleUtility.find(bundle, "icons/AboutGenie.png");
			img = new org.eclipse.swt.graphics.Image(display, url.openStream());
		} catch (Exception e) {
		}

		Label gImg = new Label(cShell, SWT.CENTER);
		gd = new GridData();
		gd.horizontalIndent = 25;
		gImg.setImage(img);
		gImg.setLayoutData(gd);

		//createContactGroup();

		
		//Label genieTitle1 = new Label(sShell, SWT.CLOSE);
//		genieTitle1.setFont(ft);
//		Color c1 = new Color(display, 0, 0, 0);
//		genieTitle1.setForeground(c);
//		genieTitle1.setText("About Genie (Codename)");
//		genieTitle1.setLayoutData(gd);
		
		
		createVersionGroup();

		{
			
			
			Button button1 = new Button(sShell, SWT.PUSH | SWT.CENTER);
			button1.setText("OK");
			GridData button1LData = new GridData();
			button1LData.horizontalAlignment = SWT.CENTER;
			button1LData.widthHint = 74;
			button1LData.heightHint = 30;
			
			button1.setLayoutData(button1LData);

			button1.addMouseListener(new MouseListener() {
				public void mouseUp(MouseEvent e) {
					sShell.close();
				}

				public void mouseDown(MouseEvent e) {
				}

				public void mouseDoubleClick(MouseEvent e) {
				}
			});
		}

		sShell.setMaximized(false);
		sShell.pack();
	}

	private void createContactGroup() {
//		genieContactGp = new Group(sShell, SWT.NONE);
//		GridLayout gl = new GridLayout();
//		gl.numColumns = 1;
//		gl.makeColumnsEqualWidth = true;
//		gl.marginRight = 30;
//
//		FontData fd = new FontData();
//		fd.setStyle(SWT.BOLD);
//		fd.setHeight(10);
//		Font ft = new Font(display, fd);
//
//		genieContactGp.setLayout(gl);
//		genieContactGp.setFont(ft);
//		genieContactGp.setText("Contact");
//		GridData gd = new GridData();
//		gd.verticalSpan = 2;
//		genieContactGp.setLayoutData(gd);
//
//		{
//			styledText1 = new Label(genieContactGp, SWT.NONE);
//			styledText1.setFont(ft);
//			styledText1.setText("Developed at");
//		}
//		{
//			styledText2 = new Label(genieContactGp, SWT.NONE);
//			styledText2.setText("Adobe Systems Inc.");
//			gd = new GridData();
//			gd.horizontalIndent = 4;
//			gd.verticalIndent = 2;
//			styledText2.setLayoutData(gd);
//		}
		
	}

	private void createVersionGroup() {
		genieCompVerGp = new Group(cShell, SWT.NONE);
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.makeColumnsEqualWidth = true;

		FontData fd = new FontData();
		fd.setStyle(SWT.BOLD);
		fd.setHeight(10);
		Font ft = new Font(display, fd);

		genieCompVerGp.setLayout(gl);
		genieCompVerGp.setFont(ft);
		genieCompVerGp.setText("Component Versions");

		{
			serverVerLabel = new Label(genieCompVerGp, SWT.NONE);
			serverVerLabel.setText("Server");
			serverVerValLabel = new Label(genieCompVerGp, SWT.NONE);
			serverVerValLabel.setText("Unknown");
		}
		{
			pluginVerLabel = new Label(genieCompVerGp, SWT.NONE);
			pluginVerLabel.setText("Plugin");
			pluginVerValLabel = new Label(genieCompVerGp, SWT.NONE);
			pluginVerValLabel.setText("Unknown");
		}
		{
			preloadVerLabel = new Label(genieCompVerGp, SWT.NONE);
			preloadVerLabel.setText("Swf Lib");
			preloadVerValLabel = new Label(genieCompVerGp, SWT.NONE);
			preloadVerValLabel.setText("Unknown");
		}
		{
			executorVerLabel = new Label(genieCompVerGp, SWT.NONE);
			executorVerLabel.setText("Executor");
			executorVerValLabel = new Label(genieCompVerGp, SWT.NONE);
			executorVerValLabel.setText("Unknown");
		}
	}

	public void run() {
		Display.getDefault().asyncExec(new Runnable() {
			public void run() {
				createWidgets();
				showWidget();
			}
		});
	}

	public void showWidget() {
		updateVariables();

		//Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
		Rectangle rect = Display.getCurrent().getBounds();
		int w = sShell.getSize().x;
		int h = sShell.getSize().y;
		int x = (rect.width - w) / 2;
		int y = (rect.height - h) / 2;

		sShell.setLocation(x, y);

		sShell.open();
		while (!sShell.isDisposed()) {
			/*if (!StaticFlags.getInstance().isDCRunning)
				deviceInfoBtn.setEnabled(false);
			else
				deviceInfoBtn.setEnabled(true);*/
			if (!display.readAndDispatch())
				display.sleep();
		}

		closeW();
	}

	private void updateVariables() {
		VersionHandler vH = VersionHandler.getInstance();
		String versions = "";

		SynchronizedSocket socket = SynchronizedSocket.getInstance();
		if (!socket.isSocketClosed() && !socket.isServerDisconnected()) {
			versions = socket.getAllVersions();

			pluginVerValLabel.setText(Utils.getTagValue(versions, "PluginVersion"));
			serverVerValLabel.setText(Utils.getTagValue(versions, "ServerVersion"));
		} else {
			// Socket is closed. Lets show versions from local storage
			pluginVerValLabel.setText(vH.getPluginVersion());
			
			String serVersion = vH.getServerVersion();
			if (serVersion.equals(""))
				serVersion = "Unknown";
			serverVerValLabel.setText(serVersion);
			
			if (vH.isRefusedConnection())
			{
				Label temp = serverVerValLabel;
				if (vH.isRefusedByServer())
					temp = pluginVerValLabel;
				
				Color c = new Color(display, 255, 0, 0);
				temp.setForeground(c);
			}
			
			serverVerValLabel.setEnabled(false);
			executorVerValLabel.setEnabled(false);
			preloadVerValLabel.setEnabled(false);
		}
		
		preloadVerValLabel.setText(Utils
				.getTagValue(versions, "PreloadVersion"));
		executorVerValLabel.setText(Utils.getTagValue(versions,
				"ExecutorVersion"));
		
		if(executorVerValLabel.getText().equalsIgnoreCase("unknown"))
		{
			executorVerValLabel.setEnabled(false);
		}
		if(preloadVerValLabel.getText().equalsIgnoreCase("unknown"))
		{
			preloadVerValLabel.setEnabled(false);
		}
		
	}

	private void closeW() {
		if (!sShell.isDisposed())
			sShell.dispose();
	}

}