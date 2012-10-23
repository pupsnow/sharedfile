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

import java.awt.image.BufferedImage;
	/**
	 * Provides the methods necessary to perform Rotate Operation On Image
	 */
public class ImageUtils {
	/**
	 * Rotates The Passed Buffered Image to 90 degress right
	 * 
	 * @param bufImage
	 *            buffred image to be rotated
     */
	public static BufferedImage rotate90right(BufferedImage bufImage)
	{
		int width = bufImage.getWidth();
		int height = bufImage.getHeight();
		
		BufferedImage biFlip = new BufferedImage(height, width,1);
		
		for(int i=0; i<width; i++)
			for(int j=0; j<height; j++)
				biFlip.setRGB(height-1-j, i, bufImage.getRGB(i, j));
		
		return biFlip;
	}
	/**
	 * Rotates The Passed Buffered Image to 90 degress left
	 * 
	 * @param bufImage
	 *            buffred image to be rotated
     */
   public static BufferedImage rotate90left(BufferedImage bufImage)
	{
		int width = bufImage.getWidth();
		int height = bufImage.getHeight();
		
		BufferedImage biFlip = new BufferedImage(height, width,1);
		
		for(int i=0; i<width; i++)
			for(int j=0; j<height; j++)
				biFlip.setRGB(j, width-1-i, bufImage.getRGB(i, j));
		
		return biFlip;
	}
   /**
	 * Rotates The Passed Buffered Image to 90 degress left
	 * 
	 * @param bufImage
	 *            buffred image to be rotated
    */
  public static BufferedImage renderInPlace(BufferedImage bufImage)
	{
		int width = bufImage.getWidth();
		int height = bufImage.getHeight();
		
		BufferedImage biFlip = new BufferedImage(height, width,1);
		biFlip=bufImage;
				
		return biFlip;
	}
}
