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

public interface IUIGenieID {

	/**
     * Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @since Genie 0.5
     */
	public void click(String genieID, int x, int y) throws Exception;
	
    /**
     * Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     * 
     * @since Genie 0.5
     */
	public void click(String genieID,Point p) throws Exception;
	
    /**
     * Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void click(String genieID,int x, int y,int key_Modifier) throws Exception;

    /**
     * Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void click(String genieID,Point p,int key_Modifier) throws Exception;

	/**
     * Right Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void rightClick(String genieID,int x, int y) throws Exception;
	
    /**
     * Right Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void rightClick(String genieID,Point p) throws Exception;
	
    /**
     * Right Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void rightClick(String genieID,int x, int y,int key_Modifier) throws Exception;
	
    /**
     * Right Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @since Genie 0.5
     */
	public void rightClick(String genieID,Point p,int key_Modifier) throws Exception;
	
	/**
     * Double Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @since Genie 0.5
     */
	public void doubleClick(String genieID,int x, int y) throws Exception;
	
    /**
     * Double Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter
     * <p>
     * This method is valid for both Desktop and Device
     *
     * @since Genie 0.5
     */
	public void doubleClick(String genieID,Point p) throws Exception;
	
    /**
     * Double Clicks at (x,y) coordinate w.r.t starting position of component whose Genie-ID is specified as parameter with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *
     * @since Genie 0.5
     */
	public void doubleClick(String genieID,int x, int y,int key_Modifier) throws Exception;

	/**
     * Double Clicks at Point p w.r.t starting position of component whose Genie-ID is specified as parameter  with the specified modifier_key (SHIFT, ALT or CTRL) pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @since Genie 0.5
     */	
	public void doubleClick(String genieID,Point p,int key_Modifier) throws Exception;
	
	/**
     * Gets the current screen (Global) coordinates of a particular Genie-ID
     * <p>
     * This method is valid for both Desktop and Device
	 *
	 * @since Genie 0.5
	 */
	public Point getCurrentScreenCoordinates(String genieID) throws Exception;
	
	/**
	 * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t a component
 	 * <p>
	 * User can simulate native MouseOver event which moves mouse cursor over the component with this action.
	 * Only thing to be taken care of is that x,y should be small enough so that they remain within 
	 * component boundaries
	 * <p>
	 * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 
	 * @since Genie 0.7
	 */
	public void mouseOver(String genieID, int x, int y) throws Exception;
	

}
