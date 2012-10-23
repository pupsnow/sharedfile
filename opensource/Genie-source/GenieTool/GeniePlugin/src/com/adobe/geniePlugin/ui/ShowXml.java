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
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.dnd.Clipboard;
import org.eclipse.swt.dnd.TextTransfer;
import org.eclipse.swt.dnd.Transfer;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;

public class ShowXml extends Thread{

	private Shell sShell = null;
	private Display display = null;
	
	private StringBuffer strToShow = new StringBuffer();
	private StyledText editor = null;
	private String title = "";
	private boolean isErrorHappened = false;
	
	public ShowXml(StringBuffer sb, String titleArg, boolean errorHappenedOrNot)
	{
		this.strToShow = sb;
		this.title = titleArg;
		this.isErrorHappened = errorHappenedOrNot;
	}
	
	private void initViewer()
	{
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.makeColumnsEqualWidth = false;
		gl.verticalSpacing = 8;
		gl.marginTop = 4;
		gl.marginLeft = 6;
		gl.marginBottom = 4;
		gl.marginRight = 6;
		
		createShellDisplay(gl, title);
		
		createEditor(this.strToShow);
		
		createCopyButton();
		
		createCancelButton();
		
		sShell.setMaximized(false);
		sShell.pack();
	}
	private void createEditor(StringBuffer sb)
	{
		GridData gd = new GridData(GridData.FILL_BOTH);
		gd.horizontalSpan = 2;
		gd.horizontalAlignment = GridData.FILL;
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 280;
		gd.minimumWidth = 480;
		gd.heightHint = 280;
		gd.widthHint = 480;
		
		FontData fd = new FontData();
		fd.setHeight(11);
		Font ft = new Font(display, fd);
		
		editor = new StyledText(sShell, SWT.MULTI| SWT.WRAP|SWT.BORDER|SWT.H_SCROLL|SWT.V_SCROLL);
		editor.setFont(ft);
		editor.setLayoutData(gd);
		editor.setText(sb.toString());
		
		if (this.isErrorHappened)
		{
			Color c = new Color(display, 255, 0, 0);
			editor.setForeground(c);
		}
	}
	private void createCopyButton()
	{
		Button copyBtn = new Button(sShell, SWT.PUSH | SWT.CENTER);
		copyBtn.setText("Copy");
		
		GridData gd = new GridData();
		gd.horizontalAlignment = GridData.BEGINNING;
		gd.widthHint = 74;
		gd.heightHint = 23;
		
		copyBtn.setLayoutData(gd);
		copyBtn.addMouseListener(new MouseListener()
		{
			public void mouseUp(MouseEvent e)
			{
				copyToClipboard();
				sShell.close();		          					
			}
			public void mouseDown(MouseEvent e) {}
			public void mouseDoubleClick(MouseEvent e) {}
		});
	}
	
	private void createCancelButton()
	{
		Button cancelBtn = new Button(sShell, SWT.PUSH | SWT.CENTER);
		cancelBtn.setText("Close");
		
		GridData gd = new GridData();
		gd.horizontalAlignment = GridData.BEGINNING;
		gd.widthHint = 74;
		gd.heightHint = 23;
		
		cancelBtn.setLayoutData(gd);
		cancelBtn.addMouseListener(new MouseListener()
		{
			public void mouseUp(MouseEvent e)
			{
				sShell.close();		          					
			}
			public void mouseDown(MouseEvent e) {}
			public void mouseDoubleClick(MouseEvent e) {}
		});
	}
	
	private void copyToClipboard()
	{
		 Clipboard clipboard = new Clipboard(display);
		  Object[] data = new Object[]{editor.getText()};
		  TextTransfer textTransfer = TextTransfer.getInstance();
		  Transfer[] transfers = new Transfer[]{textTransfer};
		  clipboard.setContents(data, transfers);
	}
	
	public void run()
	{
		Display.getDefault().asyncExec(new Runnable() {
			 public void run() {
				 	initViewer();
					
					showWidget();
			 }
		});		
	}
	public void showWidget()
	{
		Rectangle rect = Display.getCurrent().getBounds();
		int w = sShell.getSize().x;
		int h = sShell.getSize().y;
		int x = (rect.width - w) / 2;
		int y = (rect.height - h) / 2;

		sShell.setLocation(x, y);
			
		 sShell.open();
		 while (!sShell.isDisposed())
		 {
			 if (!display.readAndDispatch())
				 display.sleep();
		 }
		 closeW();				
	}

	private void closeW()
	{
		if (!sShell.isDisposed())
			sShell.dispose();
				
	}
	private void createShellDisplay(final GridLayout gl, final String title)
	{
		if (display == null)
		{
			display = Display.getCurrent();
		}
		
		sShell = new Shell(display, SWT.DIALOG_TRIM | SWT.APPLICATION_MODAL | SWT.ON_TOP);
					
		sShell.setText(title);
		sShell.setLayout(gl);
					
		sShell.addListener(SWT.Traverse, new Listener() {
			  public void handleEvent(Event event) {
		        switch (event.detail) {
		        case SWT.TRAVERSE_ESCAPE:
		          sShell.close();
		          event.detail = SWT.TRAVERSE_NONE;
		          event.doit = false;
		          break;
		        }
		      }
		    });		
	}
}
