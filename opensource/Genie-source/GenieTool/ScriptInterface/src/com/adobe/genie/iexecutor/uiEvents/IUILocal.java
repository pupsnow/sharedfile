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

public interface IUILocal {
	/**
     * Clicks at (x, y) coordinate w.r.t SWF 
     * <p>
     * This method is valid for both Desktop and Device
     *     
     * @since Genie 0.5
     */
	public void click(int x, int y) throws Exception;

	/**
     * Clicks at Point p w.r.t SWF 
     * <p>
     * This method is valid for both Desktop and Device
     *     
     * @since Genie 0.5
     */
	public void click(Point p) throws Exception;

	/**
     * Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT-0, CTRL-1 or ALT-2)pressed 
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @since Genie 0.5
     */
	public void click(int x, int y,int key_Modifier) throws Exception;

	/**
     * Clicks at Point p  w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed
     * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *      
     * @since Genie 0.5
     */
	public void click(Point p,int key_Modifier) throws Exception;

	/**
	 * Right Clicks at (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 	 
     * @since Genie 0.5
	 */
	public void rightClick(Point p) throws Exception;

	/**
	 * Right Clicks at Point p w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 *	
     * @since Genie 0.5
	 */
	public void rightClick(int x, int y) throws Exception;

	/**
	 * Right Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 	 
     * @since Genie 0.5
     * 
     */
	public void rightClick(int x, int y, int key_Modifier ) throws Exception;

	/**
	 * Right Clicks at Point p w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *    
     * @since Genie 0.5
     */
	public void rightClick(Point p, int key_Modifier) throws Exception;

	/**
	 * Double Clicks at (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
	 * 	 
     * @since Genie 0.5
	 */
	public void doubleClick(int x, int y) throws Exception;

	/**
	 * Double Clicks at Point p w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
	 * 	 
     * @since Genie 0.5
	 */
	public void doubleClick(Point p) throws Exception;

	/**
	 * Double Clicks at (x, y) coordinate w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 	 
     * @since Genie 0.5
     */
	public void doubleClick(int x, int y, int key_Modifier) throws Exception;

	/**
	 * Double Clicks at Point p w.r.t SWF with the specified modifier_key (SHIFT, ALT or CTRL)pressed 
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @since Genie 0.5
     */
	public void doubleClick(Point p, int key_Modifier) throws Exception;

	/**
	 * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t SWF with logging enabled
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *  
     * @since Genie 0.5
	 */
	public void moveMouse(int x, int y) throws Exception;
	
	/**
	 * Moves mouse pointer from current mouse position to (x, y) coordinate w.r.t SWF with Optional Logging
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     *  
     * @since Genie 1.4
	 */
	public boolean moveMouse(int x, int y, boolean bLogging) throws Exception;

	/**
	 * Drags mouse from current mouse position to (x, y) coordinate w.r.t SWF
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
	 * 	
     * @since Genie 0.5
	 */
	public void drag(int x, int y) throws Exception;

	/**
	 * Drags mouse from current mouse position to (x, y) coordinate w.r.t SWF after pressing mouse down for some time
	 * <p>
     * This method is valid only for Desktop. If used on device, it will result in Step failure
     * 
     * @since Genie 1.0
	 */
	public void holdAndDrag(int x, int y, int timeToHold) throws Exception;

	/**
	 * Drags Mouse from (x1,y1) coordinate w.r.t SWF to (x2,y2) coordinate w.r.t SWF
	 * <p>
     * This method is valid for both Desktop and Device
     * 
     * @since Genie 0.5
	 */
	public void drag(int x1, int y1, int x2, int y2) throws Exception;

	/**
	 * Drags Mouse from (x1,y1) coordinate w.r.t SWF to (x2,y2) coordinate w.r.t SWF after pressing mouse down for some time
	 * <p>
     * This method is valid for both Desktop and Device
	 * 	 
     * @since Genie 1.0
	 */
	public void holdAndDrag(int x1, int y1, int x2, int y2, int timeToHold) throws Exception;

}
