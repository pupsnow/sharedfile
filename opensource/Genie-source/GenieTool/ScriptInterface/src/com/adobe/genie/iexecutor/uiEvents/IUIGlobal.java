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

public interface IUIGlobal {
	/**
     * Clicks at (x, y) coordinate,w.r.t Screen starting coordinates.     
     * 
     * @since Genie 0.5
     */
	public void screenClick(int x, int y) throws Exception;
	/**
     * Clicks at Point p,w.r.t Screen starting coordinates.
     *     
     * @since Genie 0.5
     */
	public void screenClick(Point p) throws Exception;
	 /**
     * Clicks at (x, y),w.r.t Screen starting coordinates with the specified modifier_key(SHIFT, ALT or CTRL) pressed.        
     * 
     * @since Genie 0.5
     */
	public void screenClick(int x, int y,int key_Modifier) throws Exception;
	/**
     * Clicks at Point p,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..    
     * 
     * @since Genie 0.5
     */
	public void screenClick(Point p,int key_Modifier) throws Exception;
	 /**
	 * Right clicks at (x, y),coordinates w.r.t Screen starting coordinates	 
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(int x, int y) throws Exception;
	/**
	 * Right clicks at point p,w.r.t Screen starting coordinates
	 *      
     * @since Genie 0.5
	 */
	public void screenRightClick(Point p) throws Exception;
	/**
	 * Right clicks at (x, y),w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..	 	 
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(int x, int y, int key_Modifier ) throws Exception;
	/**
	 * Right clicks at the given point w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed..	 	 
     * 
     * @since Genie 0.5
	 */
	public void screenRightClick(Point p, int key_Modifier) throws Exception;
	/**
	 * Double clicks at (x, y) coordinate w.r.t Screen starting coordinates 
	 * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(int x, int y) throws Exception;
	/**
	 * Double clicks at the point p,w.r.t Screen starting coordinates
	 * 
	 * @since Genie 0.5
	 */
	public void screenDoubleClick(Point p) throws Exception;
	/**
	 * Double clicks at (x, y) coordinatem,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed...
	 * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(int x, int y, int key_Modifier) throws Exception;
	/**
	 * Double clicks at the given point,w.r.t Screen starting coordinates with the specified modifier_key (SHIFT, ALT or CTRL) pressed...	 	 
     * 
     * @since Genie 0.5
	 */
	public void screenDoubleClick(Point p, int key_Modifier) throws Exception;
	/**
	 * Moves the mouse to from current mouse position to (x, y) coordinate w.r.t Screen starting coordinates	 	
     * 
     * @since Genie 0.5
	 */
	
	public void screenmoveMouse(int x, int y) throws Exception;
	/**
	 * Drags from the current mouse position to (x, y) coordinates  w.r.t Screen starting coordinates 
	 * 
     * @since Genie 0.5
	 */
	public void screenDrag(int x, int y) throws Exception;
	/**
	 * Drags Mouse from (x1, y2) coordinates  w.r.t Screen starting coordinates to (x2,y2) coordinates w.r.t Screen starting coordinates	
     * 
     * @since Genie 0.5
	 */
	public void screenDrag(int x1, int y1, int x2, int y2) throws Exception;
}
