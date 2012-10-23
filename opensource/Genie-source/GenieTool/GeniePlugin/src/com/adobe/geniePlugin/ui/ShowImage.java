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

import java.awt.MouseInfo;
import java.awt.Point;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.MouseTrackListener;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.ImageLoader;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;

public class ShowImage extends Thread{

	Label label = null;
	private Image img = null;
	Button saveBtn;
	
	Display display = null;
	Shell shell = null;
	
	Point point = null;
	
	public ShowImage(Image image, Point pt)
	{
		this.img = image;
		this.point = pt;
	}
	
	private void createWidget()
	{
		display = Display.getCurrent();
		shell = new Shell(display, SWT.TRANSPARENCY_ALPHA);
		shell.setBackground(display.getSystemColor(SWT.COLOR_WHITE));
		GridLayout gl = new GridLayout();
		gl.numColumns = 1;
		shell.setLayout(gl);
		
		shell.addListener(SWT.Traverse, new Listener() {
			public void handleEvent(Event event) {
				switch (event.detail) {
				case SWT.TRAVERSE_ESCAPE:
				case SWT.TRAVERSE_RETURN:
				case 128: // key code for Space key
					shell.close();
					event.detail = SWT.TRAVERSE_NONE;
					event.doit = false;
					break;
				}
			}
		});
		
		label = new Label(shell, SWT.NONE);
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.grabExcessVerticalSpace = true;
		if (img != null)
		{
			label.setImage(img);
			label.setToolTipText("Click to save Image");
		
			label.setBackground(display.getSystemColor(SWT.COLOR_WHITE));
			label.setLayoutData(gd);
			
			
			label.addMouseListener(new MouseListener() {
				
				public void mouseUp(MouseEvent e) {
					FileDialog fd = new FileDialog(shell, SWT.SAVE | SWT.ON_TOP);
					fd.setOverwrite(true);
				    fd.setText("Save Image");
				    String[] filterExt = { "*.png"};
				    fd.setFilterExtensions(filterExt);
				        
				    String cPath = fd.open();
				    if (cPath != null)
				    {
				    	if (!cPath.endsWith(".png"))
				    		cPath += ".png";
				    	
				    	ImageLoader iLoader = new ImageLoader();
				    	iLoader.data = new ImageData[]{img.getImageData()};
				    	iLoader.save(cPath, SWT.IMAGE_PNG);
				    }
				}
				public void mouseDown(MouseEvent e) {}
				public void mouseDoubleClick(MouseEvent e) {}
			});
			
			Rectangle screen = display.getBounds();
			img = this.getScaledImage(img, screen);
			Rectangle imgBounds = img.getBounds();
			
			
			if (point.x < 0)
				point.x = 0;
			if (point.y < 0)
				point.y = 0;
			if (screen.width < (point.x + imgBounds.width))
			{
				point.x = point.x - (point.x + imgBounds.width - screen.width);
			}
			if (screen.height < (point.y + imgBounds.height))
			{
				point.y = point.y - (point.y + imgBounds.height - screen.height);
			}
		}
		else
		{
			point.y = point.y - 12;
			point.x = point.x - 30;
			
			label.setText("No Image!");
		}
		
		shell.setMaximized(false);
		shell.pack();
		shell.setLocation(point.x, point.y);
		
		
		label.addMouseTrackListener(new MouseTrackListener() {
			
			public void mouseHover(MouseEvent e) {}
			
			public void mouseExit(MouseEvent e) {
				shell.close();
			}
			
			public void mouseEnter(MouseEvent e) {}
		});
	}
	private Image getScaledImage(Image img, Rectangle screenBounds)
	{
		if (img == null)
			return null;
		
		Image scaledImg = img;
		
		try{
			boolean changed = false;
			float imgHeight = img.getBounds().height;
			float imgWidth = img.getBounds().width;
			
			float perc = 0;
			if ((imgHeight > screenBounds.height) || imgWidth > screenBounds.width) 
			{
				boolean isHeightMoreExceeded = ((imgHeight - screenBounds.height) > (imgWidth - screenBounds.width)) ? true : false;
				perc = isHeightMoreExceeded ? (imgHeight / screenBounds.height) : (imgWidth / screenBounds.width);
				
				imgHeight = imgHeight / perc;
				imgWidth = imgWidth / perc;
				
				changed = true;
			}
			
			if (changed)
			{
				System.out.println("Scaling image");
				System.out.println("Original Bounds: " + img.getBounds());
				System.out.println("Changing to: h: " + imgHeight + ", w: " + imgWidth);
				scaledImg = new Image(this.display, img.getImageData().scaledTo((int)imgWidth, (int)imgHeight));
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return scaledImg;
	}
	public void run()
	{
		Display.getDefault().asyncExec(new Runnable() {
			public void run() {
				createWidget();
				
				shell.open();
				while (!shell.isDisposed()) {
					if (!display.readAndDispatch())
						display.sleep();
					
					//If mouse gets out, and image comes late, then close the shell
					Point globalMousePoint = MouseInfo.getPointerInfo().getLocation();
					if (!shell.getBounds().contains(globalMousePoint.x, globalMousePoint.y))
						break;
				}
				
				if (!shell.isDisposed())
					shell.dispose();
			}
		});
	}
}
