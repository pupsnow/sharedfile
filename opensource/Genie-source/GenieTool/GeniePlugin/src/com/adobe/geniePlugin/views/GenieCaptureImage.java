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
/**
 * Main CaptureImage class. This class is responsible for capturing image for UI based Actions
 * and it captures the image by dragging mouse and finally save the image on disk in png format.
 * 
 *  Owner: Kaveesh Wadhwa
 *  $Author: suman $
 * 
 */
import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import javax.imageio.ImageIO;


import org.apache.sanselan.ImageWriteException;
import org.apache.sanselan.formats.png.PngConstants;
import org.apache.sanselan.formats.png.PngText;
import org.apache.sanselan.formats.png.PngText.tEXt;
import org.apache.sanselan.formats.png.PngWriter;
import org.eclipse.swt.SWT;
import org.eclipse.swt.SWTException;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.MouseMoveListener;
import org.eclipse.swt.events.PaintEvent;
import org.eclipse.swt.events.PaintListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.ImageLoader;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Canvas;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.ScrollBar;
import org.eclipse.swt.widgets.Shell;

import com.adobe.genie.utils.log.LogData;


public class GenieCaptureImage extends Thread{
	Display display = null;
	Shell sShell = null;
	Shell popup = null;
	Point startDrag = null;
	Point endDrag = null;
	Point hotSpotPoint = new Point(0,0);
	boolean hotSpotButtonClicked = false;
	Canvas imageCanvas = null;
	Group btnGp = null;
	Group canvasGroup = null;
	Label hotspotLabel = null;
	Rectangle captureRect = new Rectangle(0,0,0,0);
	Image fileImage = null;
	String hotSpotInformation = new String();
	Button hotSpotBtn = null;
	LogData log = LogData.getInstance();
	final Point origin = new Point (0, 0);
	@Override
	public void run(){
		Display.getDefault().asyncExec(new Runnable() {
			public void run() {
				initInputDialog();
			}
		  });        
	}
	
	public GenieCaptureImage(){
	}
	
	//This function is used to draw hot spot on image
	private void drawHotSpot(Point hotSpotPoint)
	{
			hotSpotInformation = "x=" + hotSpotPoint.x + "," + "y=" + hotSpotPoint.y;
			hotspotLabel.setText("Hot Spot Info:\n\nx = " +hotSpotPoint.x + "\n\ny = " +hotSpotPoint.y);
			GC gc = new GC(imageCanvas);
			gc.setForeground(display.getSystemColor(SWT.COLOR_DARK_RED)); 
			gc.setLineStyle(SWT.LINE_SOLID); 
			//Hot spot point is relocated to its original click point on canvas where user has actually clicked
			//because origin has been shifted for large size images and origin value is always <= 0
			//so we subtract the origin value from hot spot point to get actual click point
			//for normal size images origin is zero
			hotSpotPoint = new Point(hotSpotPoint.x + origin.x,hotSpotPoint.y + origin.y);
			gc.drawLine(hotSpotPoint.x-5,hotSpotPoint.y, hotSpotPoint.x+5, hotSpotPoint.y);
			gc.drawLine(hotSpotPoint.x,hotSpotPoint.y-5, hotSpotPoint.x, hotSpotPoint.y+5);
			gc.dispose();
	}
	
	
	private void createHotSpotButton()
	{
		hotSpotBtn = new Button(btnGp, SWT.PUSH );
		hotSpotBtn.setText("Add HotSpot");
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 25;
		gd.minimumWidth = 98;
		gd.heightHint = 25;
		gd.widthHint = 98;
		hotSpotBtn.setLayoutData(gd);
		
		hotSpotBtn.addListener(SWT.Selection, new Listener(){
   			public void handleEvent(Event e){
   				hotSpotButtonClicked = true;
   				hotSpotBtn.setEnabled(false);
   				hotSpotPoint = new Point(captureRect.width/2 , captureRect.height/2);
       			imageCanvas.redraw();
   			}
   	    });
	}

	private void createCancelButton()
	{
		Button cancelBtn = new Button(btnGp, SWT.PUSH );
		cancelBtn.setText("Close");
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 25;
		gd.minimumWidth = 65;
		gd.heightHint = 25;
		gd.widthHint = 65;
		cancelBtn.setLayoutData(gd);
		
		cancelBtn.addMouseListener(new MouseAdapter()
		{
			@Override
			public void mouseUp(MouseEvent e)
			{
				sShell.close();
			}
		});
	}

	//This button is used to save the captured image on disk in png format 
	private void createSaveButton()
	{
		final Button saveBtn = new Button(btnGp, SWT.PUSH);
		saveBtn.setText("Save");
		
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 25;
		gd.minimumWidth = 65;
		gd.heightHint = 25;
		gd.widthHint = 65;
		saveBtn.setLayoutData(gd);
		
		saveBtn.addSelectionListener(new SelectionAdapter (){
       	 @Override
		public void widgetSelected(SelectionEvent event) {
       	      if (((Button) event.widget).getText().equals("Save")) {
       	    	saveBtn.addListener(SWT.Selection, new Listener(){
		      			  public void handleEvent(Event e){
		      				 boolean done = false;
		      				 while(!done)
		      				 {	  
		     				  FileDialog dialog = new FileDialog(popup, SWT.SAVE);
		    				  dialog.setFilterPath(System.getProperty("user.home"));
		    				  dialog.setFilterExtensions(new String[]{"png"});
		    				 
		    				  
		    				  String extension = dialog.getFilterExtensions()[0];
		    				  
		    				  //Bug Fixing 2911775
		    				  //We have used dialog.open because dialog.getFileName return null on some MAC
		    				  String fName =  dialog.open();
		    				 
		    				  
		    				  if(fName.length() == 0)
		    				     done = true;
		    				  
		    				  String completeFileName;
		    				  
		    				  if(fName.indexOf(".png") > -1)
		    					completeFileName =  fName ;
		    				  else  
		    					completeFileName =  fName + "." + extension;
		    				 
		    				
		    				  if(completeFileName.indexOf(".png.png") > -1){
    							  completeFileName = completeFileName.substring(0,completeFileName.length()-4);
		    				  } 
		    				  if (fName.length() != 0)
		    				   {
		    					  if(new File(completeFileName).exists())
		    					  {
		    						MessageBox mb = new MessageBox(dialog.getParent(),SWT.YES|SWT.NO);
		    						mb.setMessage("File Already Exist..Overrite Existing File");
		    						done = (mb.open()==SWT.YES);
		    					  }
		    					  else
		    					  {
		    						  done = true;
		    					  }
		    					  if(done)
		    					  {	  
		    						  ImageData fileImageData = fileImage.getImageData();
		    						  ImageLoader loader = new ImageLoader(); 
		    						  loader.data = new ImageData[] { fileImageData };
		    						  try
		    						  {
		    						  	loader.save(completeFileName, SWT.IMAGE_PNG);
		    						  	log.trace(LogData.INFO, "Image Saved Successfully");
		    						  	done = true;
		    						  	if(hotSpotButtonClicked == true)
		    						  	{
		    						  		addHotSpotData(new File(completeFileName), hotSpotInformation);
		    						  		hotSpotButtonClicked = false;
		    						  	}
		    						  }
		    						  catch(SWTException se)
		    						  {
		    							  MessageBox mb = new MessageBox(dialog.getParent(),SWT.OK);
		    							  mb.setMessage("Can not save at mentioned location. Permission Denied.Specify Another Location");
				    					  done = !(mb.open()==SWT.OK);
		    						  }
		    					   }
		    			        }
		      				}
		      				sShell.close();
		    				}
		    		  });
       	    	}
       	   }
       });
		
	}
	
	private void createRecaptureButton()
	{
		Button recaptureButton = new Button(btnGp, SWT.PUSH );
		recaptureButton.setText("Recapture");
		
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 25;
		gd.minimumWidth = 83;
		gd.heightHint = 25;
		gd.widthHint = 83;
		recaptureButton.setLayoutData(gd);
		recaptureButton.addMouseListener(new MouseAdapter()
		{
			@Override
			public void mouseUp(MouseEvent e)
			{
				 hotSpotButtonClicked = false;
				 hotSpotBtn.setEnabled(true);
				 fileImage.dispose();
				 popup.dispose();
				 sShell.redraw();
				 sShell.setAlpha(120);
			}
		});
	}
	
	
	private void createPopup()
	{
		GridLayout gl = new GridLayout();
		gl.numColumns = 2;
		gl.makeColumnsEqualWidth = false;
		gl.marginLeft = 10;
		popup =  new Shell(sShell);
		popup.setLayout(gl);
		
		canvasGroup = new Group(popup, SWT.None);
		imageCanvas = new Canvas(canvasGroup, SWT.H_SCROLL | SWT.V_SCROLL);
		
		createCanvasScrollbar();
		
		GridData gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 250;
		gd.minimumWidth = 240;
		gd.heightHint = 250;
		gd.widthHint = 240;
		canvasGroup.setLayoutData(gd);
		
		gd = new GridData();
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = GridData.FILL;
		gd.grabExcessVerticalSpace = true;
		gd.minimumHeight = 250;
		gd.minimumWidth = 240;
		gd.heightHint = 250;
		gd.widthHint = 240;
		imageCanvas.setLayoutData(gd);
		
		Group labelGroup = new Group(popup,SWT.None);
		gl = new GridLayout();
		gl.numColumns = 1;
		labelGroup.setLayout(gl);
		
		hotspotLabel = new Label(labelGroup, SWT.NONE);
		gd = new GridData();
		gd.heightHint = 250;
		gd.minimumHeight = 250;
		gd.minimumWidth = 75;
		gd.widthHint = 75;
		hotspotLabel.setLayoutData(gd);
		hotspotLabel.setText("Hot Spot Info:");
		
		btnGp = new Group(popup, SWT.NONE);
		gl = new GridLayout();
		gl.numColumns = 4;
		gl.makeColumnsEqualWidth = false;
		btnGp.setLayout(gl);
		gd = new GridData();
		gd.horizontalSpan = 2;
		btnGp.setLayoutData(gd);

		createSaveButton();
		createRecaptureButton();
		createCancelButton();
		createHotSpotButton();
		
	    popup.setText("Capture Image");
        popup.setBounds(50, 50, 400, 400);
        Rectangle rect = Display.getCurrent().getBounds();
		int w = popup.getSize().x;
		int h = popup.getSize().y;
		int x = (rect.width - w) / 2;
		int y = (rect.height - h) / 2;
		
        popup.setLocation(x, y);
        popup.addListener(SWT.Close, new Listener() {
			 public void handleEvent(Event e) {
				 	sShell.close();
		     }
          });
        popup.pack();
      }

	
	//It captures the image from current display by using coordinates of captureRect
	//and draw that image on new shell i.e popup
	private void captureImage(){
		if (popup.isDisposed())
        {
			createPopup();
        }
		sShell.setAlpha(0);
		
		try {
			Thread.sleep(50);
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}
		fileImage = new Image(display, captureRect);
		
		GC imageGC = new GC(display);
        imageGC.copyArea(fileImage,captureRect.x,captureRect.y);
        imageCanvas.setBounds(10, 10, canvasGroup.getBounds().width-20, canvasGroup.getBounds().height-20);
        
        imageCanvas.addMouseListener(new MouseAdapter(){
			public void mouseUp(MouseEvent e){
					//hot spot point is relocated to its new point on canvas 
					//because origin has been shifted for large size images and origin value is always <= 0.
				    //so we will add origin content to actual click point
				    //for normal images origin is zero
				    hotSpotPoint = new Point(e.x - origin.x,e.y - origin.y);
					imageCanvas.redraw();
				}
		});
        
        imageCanvas.addListener(SWT.Paint, new Listener() {
            public void handleEvent(Event e) {
              GC gc = e.gc;
              gc.drawImage(fileImage, origin.x, origin.y);
              
              Rectangle rect = fileImage.getBounds();
              Rectangle client = imageCanvas.getClientArea();
              int marginWidth = client.width - rect.width;
              if (marginWidth > 0) {
                gc.fillRectangle(rect.width, 0, marginWidth, client.height);
              }
              int marginHeight = client.height - rect.height;
              if (marginHeight > 0) {
                gc.fillRectangle(0, rect.height, client.width, marginHeight);
              }
              if(hotSpotButtonClicked)
              	drawHotSpot(hotSpotPoint);
            }
          });
      popup.open();
	}
	
	private void setCaptureRect(int x, int y, int w, int h) {
		captureRect.x = x;
		captureRect.y = y;
		captureRect.width = w;
		captureRect.height = h;
	}
	
	public void makeRectangle(int x1, int y1, int x2, int y2,Display display) {
		GC gc = new GC(sShell);
		gc.drawRectangle(Math.min(x1, x2), Math.min(y1, y2), Math.abs(x1 - x2), Math.abs(y1 - y2));
		gc.dispose();
	}
	
	//This method is creating a shell of full desktop size with some alpha value to gain transparency
	//and provide the feature to capture a image by dragging a mouse and captured image is opened in a new Shell
	//which have features to save the image to disk ,recapture image and close the shell.
	private void initInputDialog()
	{
		if (display == null)
		{
			display = Display.getDefault();//getCurrent();
		}
		
		sShell = new Shell(display ,SWT.ON_TOP |SWT.TRANSPARENCY_ALPHA | SWT.APPLICATION_MODAL);
		sShell.setAlpha(120);
		createPopup();
		
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
		
	    
	    sShell.addListener(SWT.Close, new Listener() {
			  public void handleEvent(Event event) {
		        switch (event.detail) {
		        case SWT.Close:
		          sShell.close();
		          event.detail = SWT.TRAVERSE_NONE;
		          event.doit = false;
		          break;
		        }
		      }
		    });		
		sShell.addPaintListener(new PaintListener() {
			public void paintControl(PaintEvent e) {
				if (startDrag != null && endDrag != null){
					makeRectangle(startDrag.x,startDrag.y,endDrag.x,endDrag.y,display);
					}
			}
		});
		
		sShell.addMouseListener(new MouseListener(){
			public void mouseDown(MouseEvent e){
				startDrag = new Point(e.x, e.y);
			}
			
			public void mouseUp(MouseEvent e){
				if (startDrag != null && endDrag != null)
				{
					Rectangle r = sShell.getBounds();
					Rectangle rClient = sShell.getClientArea();
					setCaptureRect(Math.min(startDrag.x, endDrag.x)+ Math.abs(r.width - rClient.width),Math.min(startDrag.y, endDrag.y)+ Math.abs(r.height - rClient.height),Math.abs(endDrag.x-startDrag.x) ,Math.abs(endDrag.y-startDrag.y));
					makeRectangle(startDrag.x,startDrag.y,endDrag.x,endDrag.y,display);
					startDrag = null;
					endDrag = null;
					captureImage();
				}
				else if(startDrag!=null && endDrag == null){
					startDrag = null;
					endDrag = null;
				}
			}
			
			public void mouseDoubleClick(MouseEvent arg0) {
			}
		});
		
		sShell.addMouseMoveListener(new MouseMoveListener(){
			public void mouseMove(MouseEvent me){
				if (startDrag != null)
				{
					endDrag = new Point(me.x,me.y);
					sShell.redraw();
				}
			}
			});
		
		sShell.setSize(Display.getDefault().getBounds().width,Display.getDefault().getBounds().height); 
		sShell.setLocation(0, 0);	
		sShell.setCursor(display.getSystemCursor(SWT.CURSOR_CROSS));
	    sShell.open();
		sShell.forceActive();
		
		 while (!sShell.isDisposed())
		 {
			 if (!display.readAndDispatch())
				 display.sleep();
		 }
		
		 GenieView g = GenieView.getInstance();
		 g.maximizeEclipseShell();
		
		 disposeShell();
	}
	
	private void disposeShell()
	{
		if (!sShell.isDisposed())
			sShell.dispose();
	}
	
	//This function is used to add hotspot data in an image using Sanselan.jar functionality to edit exif data of an image
	// We store hot spot information in Comment tag of image as a string
	private void addHotSpotData(File file , String hotSpotInformation)
	  {
		  try {
			  	BufferedImage bf = null;
				bf = ImageIO.read(file);
				OutputStream os = new FileOutputStream(file);
				os = new BufferedOutputStream(os);
				
				HashMap<String,ArrayList<tEXt>> writeParams = new HashMap<String, ArrayList<tEXt>>();
				
				ArrayList<tEXt> writeTexts = new ArrayList<tEXt>();
				{
                    String keyword = "Comment";
                    String text = hotSpotInformation;
                    writeTexts.add(new PngText.tEXt(keyword, text));
				}
				writeParams.put(PngConstants.PARAM_KEY_PNG_TEXT_CHUNKS, writeTexts);
				PngWriter pw = new PngWriter(true);
				try {
					pw.writeImage(bf, os, writeParams);
					log.trace(LogData.INFO, "HotSpot Data Saved");
				} catch (ImageWriteException e) {
					log.trace(LogData.ERROR, "Error in Writing Hotspot Information in Image " + e.getMessage());
				}
				} catch (IOException e) {
					log.trace(LogData.ERROR,"IO Exception Occurs");
				}
		  
	  }
	
	
	//This function creates scroll bar on image canvas for large size images
	private void createCanvasScrollbar()
	{
		final ScrollBar hBar = imageCanvas.getHorizontalBar ();
		hBar.addListener (SWT.Selection, new Listener () {
			public void handleEvent (Event e) {
				int hSelection = hBar.getSelection ();
				int destX = -hSelection - origin.x;
				Rectangle rect = fileImage.getBounds ();
				imageCanvas.scroll (destX, 0, 0, 0, rect.width, rect.height, false);
				origin.x = -hSelection;
			}
		});
		final ScrollBar vBar = imageCanvas.getVerticalBar ();
		vBar.addListener (SWT.Selection, new Listener () {
			public void handleEvent (Event e) {
				int vSelection = vBar.getSelection ();
				int destY = -vSelection - origin.y;
				Rectangle rect = fileImage.getBounds ();
				imageCanvas.scroll (0, destY, 0, 0, rect.width, rect.height, false);
				origin.y = -vSelection;
			}
		});
		imageCanvas.addListener (SWT.Resize,  new Listener () {
			public void handleEvent (Event e) {
				Rectangle rect = fileImage.getBounds ();
				Rectangle client = imageCanvas.getClientArea ();
				hBar.setMaximum (rect.width);
				vBar.setMaximum (rect.height);
				hBar.setThumb (Math.min (rect.width, client.width));
				vBar.setThumb (Math.min (rect.height, client.height));
				int hPage = rect.width - client.width;
				int vPage = rect.height - client.height;
				int hSelection = hBar.getSelection ();
				int vSelection = vBar.getSelection ();
				if (hSelection >= hPage) {
					if (hPage <= 0) hSelection = 0;
					origin.x = -hSelection;
				}
				if (vSelection >= vPage) {
					if (vPage <= 0) vSelection = 0;
					origin.y = -vSelection;
				}
				imageCanvas.redraw ();
			}
		});
	}
	
}
