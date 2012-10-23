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

package com.adobe.genie.utils;

import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.util.Vector;

/**
 * Provides the methods necessary to perform operate on images on device
 */
public class PicFinder {
	private BufferedImage lastImage;
	private Point lastFound;
	private int[] sourcePixels;
	private int sourceWidth;
	private int sourceHeight;
	private int[] imagePixels;
	private int tolerance = 0;
	public static final int PULSING = 40;
	private Rectangle searchRect;
	private int[] pixels;
	
	private Dimension deviceSize;
	private BufferedImage deviceImage;
	private boolean isDebugMode = false;
	
	/**
	 * Constructor
	 * @param sourceImageArg, Path to source Image in which to find image
	 * @param dimensionArg, dimension of source
	 * @param debugMode
	 */
	public PicFinder(BufferedImage sourceImageArg, Dimension dimensionArg, boolean debugMode) 
	{
		deviceImage = sourceImageArg;
		isDebugMode = debugMode;
		
		deviceSize = dimensionArg;
		
		//Set the pixel array to desktop size
		pixels = new int[deviceSize.width * deviceSize.height];
		
		//Set the image search rectangle to desktop size
		setSearchRectangle(new Rectangle(deviceSize));
		
		//Set the source to be searched to be desktop.
		setSource(captureScreenPixels(searchRect), searchRect.width,searchRect.height);
	}
	
	//========================================================================================
	// Some Functions related for setting up the source of operation 
	//========================================================================================

	/**
	 * Sets the objects source to the given Buffered image.
	 * 
	 * @param source
	 *            the frame buffer that you want to be the source
	 * @param tolerance
	 *            tolerance for the image to be searched
	 */
	void setSource(BufferedImage source, int tolerance) {
		this.tolerance = tolerance;
		lastFound = new Point(-1, -1);
		sourcePixels = new int[source.getWidth() * source.getHeight()];
		source.getRGB(0, 0, source.getWidth(), source.getHeight(), sourcePixels, 0, source.getWidth());
		sourceWidth = source.getWidth();
		sourceHeight = source.getHeight();
	}
	
	/**
	 * Sets the objects source to the given pixels.
	 * 
	 * @param pixels
	 *            the frame buffer that you want to be the source
	 * @param width
	 *            width of the framebuffer's image
	 * @param height
	 *            height of the framebuffer's image
	 */
	 void setSource(int[] pixels, int width, int height) {
		sourcePixels = pixels;
		sourceWidth = width;
		sourceHeight = height;
	}

	//========================================================================================
	// Some Functions related to finding device coordinate for a given image buffer 
	//========================================================================================
	 
	 /**
		 * Searches the 1st occurrence of the image
		 * 
		 * @param image
		 *            image to be searched
	*/
	 public Point findFirst(BufferedImage image, int tolerance) {
		imagePixels = new int[image.getWidth() * image.getHeight()];
		image.getRGB(0, 0, image.getWidth(), image.getHeight(), imagePixels, 0, image.getWidth());
		lastImage = image;
		lastFound = new Point(-1, -1);
		return find(lastImage, lastFound, tolerance);
	}

	 /**
		 * Searches the next occurrence of the image
		 * 
	*/
	 Point findNext(int tolerance) {
		return find(lastImage, lastFound, tolerance);
	}

	 /**
		 * Searches the all occurrence of the image
		 * 
		 * @param image
		 *            image to be searched
	*/
	 Point[] findAll(BufferedImage image, int maxInt, int tolerance) {
		Vector<Point> tmpPnts = new Vector<Point>();
		Point p = findFirst(image, tolerance);
		int i = 0;
		while (p.x >= 0 && (i++ < maxInt || maxInt == 0)) {
			tmpPnts.add(new Point(p));
			p = findNext(tolerance);
		}
		return tmpPnts.toArray(new Point[0]);
	}

	 /**
		 * Searches the 1st occurrence of the image
		 * 
		 * @param image
		 *            image to be searched
		 * @param start
		             start point of the searched source
	*/
	 private Point find(BufferedImage image, Point start, double specifiedTolerance) {
		int imageWidth = image.getWidth();
		int imageHeight = image.getHeight();
		
		int tmpTolerance = (int) Math.round((specifiedTolerance/100)*255);//tolerance;
		
		tolerance = tmpTolerance;
		int firstToSearch = imageHeight / 2;
		int foundLines = 0;
		int foundPixels = 0;
		int startX = start.x + 1;
		
		for (int y = start.y < 0 ? 0 : start.y; y < sourceHeight - imageHeight + 1; y++) {
			for (int x = startX; x < sourceWidth - imageWidth + 1; x++) {
				for (int cx = 0; cx < imageWidth; cx++) {
					int a = imagePixels[(foundLines + firstToSearch) * imageWidth + cx];
					int b = sourcePixels[(y + foundLines + firstToSearch) * sourceWidth + x + cx];
					int dif1 = ((b & 0xff0000) >>> 16) - ((a & 0xff0000) >>> 16);
					int dif2 = ((b & 0xff00) >>> 8) - ((a & 0xff00) >>> 8);
					int dif3 = (b & 0xff) - (a & 0xff);
					if((b >>> 24 == 0) || ((a >>> 24 != 0) && !((dif1 <= tolerance && dif1 >= -tolerance && dif2 <= tolerance && dif2 >= -tolerance && dif3 <= tolerance && dif3 >= -tolerance)))){
						break;
					}
					foundPixels++;
				}
				if (foundPixels == imageWidth) {
					if (firstToSearch == 0) foundLines++;
					firstToSearch = 0;
					if (foundLines == imageHeight) {
						lastFound = new Point(x, y);
						tolerance = tmpTolerance;
						return new Point(x, y);
					}
					x--;
				}
				else {
					foundLines = 0;
					firstToSearch = imageHeight / 2;
				}
				foundPixels = 0;
			}
			startX = 0;
		}
		tolerance = tmpTolerance;
		return new Point(-1, -1);
	}
	
	//========================================================================================
	// Some Functions related to getting/setting iterator or image buffer of last found image
	//========================================================================================
	 
	 /**
		 * Point where last image was found
		 * 
		 * @param image
		 *            image to be searched
		 * @param start
		             start point of the searched source
	*/
	 Point getLastFound() {
		return lastFound;
	}

	 /**
	  * Set the value of last found point
	  * 
	  * @param lastFound
	  * 	sets the last found point
	  */
	void setLastFound(Point lastFound) {
		this.lastFound = lastFound;
	}

	/**
	 * Returns a Buffer of last found image pixels
	 * 
	 * @return
	 */
	BufferedImage getLastImage() {
		return lastImage;
	}

	/**
	 * Initialize the lastImage buffer with the given image
	 * 
	 * @param lastImage
	 */
	void setLastImage(BufferedImage lastImage) {
		imagePixels = new int[lastImage.getWidth() * lastImage.getHeight()];
		lastImage.getRGB(0, 0, lastImage.getWidth(), lastImage.getHeight(), imagePixels, 0, lastImage.getWidth());
		this.lastImage = lastImage;
	}
	
	
	//========================================================================================
	// Some Functions related to getting/setting device and a portion of device
	//========================================================================================
	
	/**
     * Sets the search rectangle to the given rectangle.
     *
     * @param r
     *            the new search rectangle
     */
    void setSearchRectangle(Rectangle r) {
        searchRect = new Rectangle();
        searchRect.setBounds(r);
    }
    
    /**
     * Sets the search rectangle to device rectangle.
     */
    void resetSearchRectangle() {
        searchRect = new Rectangle(getDesktopSize());
    }
    
    /**
     * Returns the desktop resolution.
     *
     * @return the resolution of the desktop in pixels
     */
    Dimension getDesktopSize() {
        return Toolkit.getDefaultToolkit().getScreenSize();
    }
    
	//========================================================================================
	// Some Functions related to capturing device or portion of device
	//========================================================================================

    
    /**
     * Captures the whole device and returns it as an integer array.
     *
     * @return the device's current framebuffer as int[]
     */
    int[] captureScreenPixels() throws Exception {
        return getPixelData();
    }

    /**
     * Captures a rectangle from the device and returns it as an integer array.
     *
     * @param rect
     *            the rectangle to get the pixel data from
     * @return pixeldata as int[]
     */
    int[] captureScreenPixels(Rectangle rect) {
        return getPixelData(rect);
    }
   
    /**
     * Gets an array holding the device's current framebuffer.
     *
     * @return the device's current framebuffer as int[]
     */
    private int[] getPixelData() {
        try {
        	deviceSize = Toolkit.getDefaultToolkit().getScreenSize();
            getPixelData(new Rectangle(0, 0, deviceSize.width,
            		deviceSize.height));
        } catch (Exception e) {
        	e.printStackTrace();
        	if (isDebugMode){
				e.printStackTrace();
			}
        }
        return pixels;
    }
    
    /**
     * Captures a rectangle from the device and returns it as an array of ints.
     *
     * @return the rectangle of pixels from the device's frame buffer as int[]
     */
    private int[] getPixelData(Rectangle r) {
        try {
            if (pixels.length < r.width * r.height) {
                throw new Exception("UNSUPPORTED: "
                        + "Screen size changed during test run!");
            }
            //deviceImage = robot.createScreenCapture(r);
            deviceImage.getRGB(0, 0, (int) r.width, (int) r.height, pixels, 0,
                    (int) r.width);
        } catch (Exception e) {
        	e.printStackTrace();
        	if (isDebugMode){
				e.printStackTrace();
			}
        }
        return pixels;
    }
    
    /**
     * Captures the whole device and returns it as BufferedImage.
     *
     * @return the device's current framebuffer as BufferedImage
     */
    BufferedImage captureScreenPixelsAsBufferedImage() throws Exception {
        return getBufferedImage();
    }
    
    /**
     * Gets BufferedImage holding the device's current framebuffer.
     *
     * @return the device's current framebuffer as BufferedImage
     */
    private BufferedImage getBufferedImage() throws Exception {
    	BufferedImage snapShot = null;
    	deviceSize = Toolkit.getDefaultToolkit().getScreenSize();
            snapShot = getBufferedImage(new Rectangle(0, 0, deviceSize.width,
            		deviceSize.height));
        return snapShot;
    }
	
    /**
     * Captures a rectangle from the device and returns it as Buffered Image
     *
     * @return the rectangle of pixels from the device's frame buffer as Buffered Image
     */
    private BufferedImage getBufferedImage(Rectangle r) throws Exception{
    	if (pixels.length < r.width * r.height) {
               throw new Exception("UNSUPPORTED: "
                        + "Screen size changed during test run!");
        }
        //deviceImage = robot.createScreenCapture(r);
        return deviceImage;
    }
    
    public Boolean compareImage(BufferedImage image, double specifiedTolerance) {
		int imageWidth = image.getWidth();
		int imageHeight = image.getHeight();
		
		imagePixels = new int[imageWidth * imageHeight];
		image.getRGB(0, 0, imageWidth, imageHeight, imagePixels, 0, imageWidth);
		
		if(sourceWidth != imageWidth || sourceHeight != imageHeight)
			return false;
		
		int tmpTolerance = (int) Math.round((specifiedTolerance/100)*255);//tolerance;
		
		tolerance = tmpTolerance;
		boolean isImageMatched = true;
		for (int y = 0 ; y < sourceHeight; y++) {
			for (int x = 0; x < sourceWidth; x++) {
					int a = imagePixels[x  + y*imageWidth];
					int b = sourcePixels[x + y*sourceWidth];
					int dif1 = ((b & 0xff0000) >>> 16) - ((a & 0xff0000) >>> 16);
					int dif2 = ((b & 0xff00) >>> 8) - ((a & 0xff00) >>> 8);
					int dif3 = (b & 0xff) - (a & 0xff);
					if(!((dif1 <= tolerance && dif1 >= -tolerance && dif2 <= tolerance && dif2 >= -tolerance && dif3 <= tolerance && dif3 >= -tolerance))){
						isImageMatched = false;
						break;
					}
			}
			if(!isImageMatched)
				break;
		}
		tolerance = tmpTolerance;
		return isImageMatched;
	}
}