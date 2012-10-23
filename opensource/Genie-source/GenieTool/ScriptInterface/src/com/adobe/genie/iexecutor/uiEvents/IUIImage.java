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
package com.adobe.genie.iexecutor.uiEvents;
import java.awt.Point;

public interface IUIImage {
	 /**
     * Clicks at the center coordinates of the image whose path is passed as parameter      
     * 
     * @since Genie 0.5
     */
	public void clickImage(String imagePath, int... tolerance) throws Exception;
	 /**
     * Clicks at the hot spot coordinates of the image whose path is passed as parameter          
     * 
     * @since Genie 0.10
     */
	public void clickImageHotSpot(String imagePath, int... tolerance) throws Exception;
	/**
     * Right Clicks at the center coordinates of the image whose path is passed as parameter         
     * 
     * @since Genie 0.5
     */
	public void rightClickImage(String imagePath, int... tolerance) throws Exception;
	  /**
     * Right Clicks at the hot spot coordinates of the image whose path is passed as parameter   
     * 
     * @since Genie 0.10
     */
	public void rightClickImageHotSpot(String imagePath, int... tolerance) throws Exception;
	 /**
     * Double Clicks at the center coordinates of the image whose path is passed as parameter     
     * 
     * @since Genie 0.5
     */
	public void doubleClickImage(String imagePath, int... tolerance) throws Exception;
	/**
     * Double Clicks at the hot spot coordinates of the image whose path is passed as parameter     
     * 
     * @since Genie 0.10
     */
	public void doubleClickImageHotSpot(String imagePath, int... tolerance) throws Exception;
	/**
     * Returns Center coordinates of the image whose path is passed as parameter         
     * 
     * @since Genie 0.5
     * 
     */
	public Point findImage(String imagePath, int... tolerance) throws Exception;
	/**
     * Returns the current center coordinates of the image as it exists on screen 
     * whose path is passed as parameter,User can enable disable logging of this
     * function.
     *       
     * @since Genie 1.0
     * 
     */
	public Point findImage(String imagePath, boolean bLogging, int... tolerance)throws Exception;
	 /**
     * Returns the current HotSpot coordinates of the image as it exists on screen 
     * whose path is passed as parameter.     
     * 
     * @since Genie 0.10
     *
     */	
	public Point findImageHotSpot(String imagePath, int... tolerance) throws Exception;
	 /**
     * Returns the current HotSpot coordinates of the image as it exists on screen 
     * whose path is passed as parameter.Logging is optional.     
     * 
     * @since Genie 1.0
     */
	public Point findImageHotSpot(String imagePath, boolean bLogging, int... tolerance)throws Exception;
	/**
     * Waits till the user specified image is found on the screen or timeout occurs,timeout can be 
     * specified by the user,the user can also enable/disable logging.
     *  
     * @since Genie 1.6
     *
     */	
	 public Point waitForImage(String imagePath,int timeInSeconds,boolean bLogging,int... tolerance)throws Exception;
	 /**
	   * Waits till the user specified image is found on the screen or timeout occurs.
	   *  
	   * @since Genie 1.6
	   *
	   */	
	 public Point waitForImage(String imagePath, int timeout, int... tolerance)throws Exception ;
	 
}
