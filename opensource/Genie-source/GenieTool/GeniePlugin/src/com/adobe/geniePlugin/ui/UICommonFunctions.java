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
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import com.adobe.geniePlugin.views.GenieView;

public class UICommonFunctions extends Thread{

	private Shell sShell = null;
	private Display display = null;
	private StringBuffer sB = null;
	private String inputVal = null;	
	
	/**
	 * 0 => ScriptEditor
	 * 1 => Pop up dialog asking for a value
	 * 2 => Input dialog asking for GenieID, and swf name
	 */
	private int mode = -1;
	
	private StyledText editor;
	
	public static UICommonFunctions getScriptEditorInstance(StringBuffer sb)
	{
		return new UICommonFunctions(sb);		
	}
	public static UICommonFunctions getInputDialog()
	{
		return new UICommonFunctions(1);
	}
	public static UICommonFunctions getInputDialogForWatchWindow()
	{
		return new UICommonFunctions(2);
	}
	
	private UICommonFunctions(int argMode)
	{
		mode = argMode;
	}
	private UICommonFunctions(StringBuffer sb)
	{
		sB = sb;
		mode = 0;
	}
	
	private void initInputDialog()
	{
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.marginTop = 4;
		gl.marginLeft = 4;
		gl.marginBottom = 4;
		gl.marginRight = 4;
		gl.verticalSpacing = 14;
		
		createShellDisplay(gl, "Input Genie ID");
		sShell.setSize(320, 120);
		
		
		GridData gd = new GridData();
		gd.horizontalIndent = 4;
		Label l = new Label(sShell, SWT.NONE);
		l.setText("Genie ID: ");
					
		gd = new GridData(220, 14);
		gd.horizontalIndent = 4;
		final Text str = new Text(sShell, SWT.SINGLE | SWT.BORDER);
		str.setLayoutData(gd);
					
		final Button okBtn = new Button(sShell, SWT.PUSH | SWT.CENTER);
		okBtn.setText("OK");
		gd = new GridData();
		gd.horizontalAlignment = GridData.END;
		gd.horizontalSpan = 2;
		gd.widthHint = 58;
		gd.heightHint = 24;
		okBtn.setLayoutData(gd);
		okBtn.setEnabled(false);
		okBtn.addMouseListener(new MouseListener()
		{
			public void mouseUp(MouseEvent e)
			{
				inputVal = str.getText();
				sShell.close();		          					
			}
			public void mouseDown(MouseEvent e) {}
			public void mouseDoubleClick(MouseEvent e) {}
		});
		
		str.addKeyListener(new KeyListener() {
			public void keyReleased(KeyEvent e) {
				if (str.getText().length() == 0)
					okBtn.setEnabled(false);
				else
					okBtn.setEnabled(true);
			}
				
			public void keyPressed(KeyEvent e) {
				if (e.character == SWT.CR)
				{
					inputVal = str.getText();
					sShell.close();
				}
			}
		});
		str.addMouseListener(new MouseListener() {
			
			public void mouseUp(MouseEvent e) {
				if (str.getText().length() == 0)
					okBtn.setEnabled(false);
				else
					okBtn.setEnabled(true);				
			}
			
			public void mouseDown(MouseEvent e) {
			}
			
			public void mouseDoubleClick(MouseEvent e) {
			}
		});
	}
	
	public String getInputVal()
	{
		return inputVal;
	}
	
	private void initScriptEditor(StringBuffer sb)
	{
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.makeColumnsEqualWidth = false;
		gl.verticalSpacing = 8;
		gl.marginTop = 4;
		gl.marginLeft = 6;
		gl.marginBottom = 4;
		gl.marginRight = 6;
		
		createShellDisplay(gl, "Genie Script Editor");
		
		createEditor(sb);
		
		createCopyButton();
		
		createCancelButton();
		
		sShell.setMaximized(false);
		sShell.pack();
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
	
	private void createEditor(StringBuffer sb)
	{
		GridData gd = new GridData(GridData.FILL_BOTH);
		gd.horizontalSpan = 2;
		gd.horizontalAlignment = GridData.FILL;
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 480;
		gd.minimumWidth = 680;
		gd.heightHint = 480;
		gd.widthHint = 680;
		
		FontData fd = new FontData();
		fd.setHeight(10);
		Font ft = new Font(display, fd);
		
		editor = new StyledText(sShell, SWT.MULTI| SWT.WRAP|SWT.BORDER|SWT.H_SCROLL|SWT.V_SCROLL);
		editor.setFont(ft);
		editor.setLayoutData(gd);
		editor.setText(sb.toString());
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
				 switch(mode)
					{
					case 0:
						initScriptEditor(sB);
						break;
					case 1:
						initInputDialog();
						break;					
					}
					
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
			
		 hook_performAction();

		 closeW();				
	}

	private void closeW()
	{
		if (!sShell.isDisposed())
			sShell.dispose();
				
	}
	
	private void hook_performAction()
	{
		switch(mode)
		{
		case 1:
			GenieView g = GenieView.getInstance();
			g.doSelectGenieObject(inputVal);
			
			break;	
		}
	}
}
